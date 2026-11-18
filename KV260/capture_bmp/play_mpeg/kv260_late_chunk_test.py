"""Compare strict next-frame reassembly with a short late-chunk grace period.

This diagnostic listens to the KV260 KJPG UDP stream. It does not display or
save images, and it does not alter the board's firmware.
"""

import argparse
import collections
import heapq
import queue
import socket
import struct
import sys
import threading
import time


HEADER = struct.Struct("!4sIII")
CHUNK = 1384
MAX_SIZE = 8 * 1024 * 1024
FRAME_TIMEOUT = 2.0
RESTART_GAP = 10.0
VERSION = 2


class Logger:
    """Keep console and pipe writes off the UDP receiving thread."""

    def __init__(self):
        self.messages = queue.SimpleQueue()
        self.thread = threading.Thread(target=self._run, daemon=True)
        self.thread.start()

    def _run(self):
        while True:
            line = self.messages.get()
            if line is None:
                return
            try:
                print(line, flush=True)
            except (BrokenPipeError, OSError):
                return

    def log(self, line):
        self.messages.put(line)

    def close(self):
        self.messages.put(None)
        self.thread.join(timeout=3)


class Frame:
    __slots__ = ("frame_id", "total", "started", "deadline", "chunks", "expected",
                 "at_boundary", "late_chunks", "start_bytes", "end_first", "end_second")

    def __init__(self, frame_id, total, now):
        self.frame_id = frame_id
        self.total = total
        self.started = now
        self.deadline = now + FRAME_TIMEOUT
        self.chunks = set()
        self.expected = (total + CHUNK - 1) // CHUNK
        self.at_boundary = None
        self.late_chunks = 0
        self.start_bytes = b""
        self.end_first = None
        self.end_second = None

    def first_missing(self):
        result = []
        for chunk in range(self.expected):
            offset = chunk * CHUNK
            if offset not in self.chunks:
                result.append(offset)
                if len(result) == 5:
                    break
        return result


class Inspector:
    def __init__(self, grace_seconds, log, source=None):
        self.grace = grace_seconds
        self.log = log
        self.source = source
        self.peer = None
        self.last_packet = 0.0
        self.latest_id = None
        self.frames = {}
        self.expiries = []
        self.count = collections.Counter()

    def expire(self, now):
        while self.expiries and self.expiries[0][0] <= now:
            deadline, frame_id = heapq.heappop(self.expiries)
            frame = self.frames.get(frame_id)
            if frame is None or frame.deadline != deadline:
                continue
            del self.frames[frame_id]
            missing = frame.expected - len(frame.chunks)
            if frame.at_boundary is not None:
                self.count["unresolved"] += 1
                self.log(f"UNRESOLVED frame={frame_id} after_grace_ms={self.grace * 1000:.0f} "
                         f"missing_now={missing} late_unique_chunks={frame.late_chunks} "
                         f"first_missing_offsets={frame.first_missing()}")
            else:
                self.count["timeouts"] += 1
                self.log(f"TIMEOUT frame={frame_id} missing={missing} "
                         f"first_missing_offsets={frame.first_missing()}")

    def feed(self, packet, sender, now):
        self.expire(now)
        if self.peer is not None and now - self.last_packet >= RESTART_GAP:
            self.log("STREAM IDLE: resetting peer and frame tracking")
            self.peer = None
            self.latest_id = None
            self.frames.clear()
            self.expiries.clear()
        if len(packet) <= HEADER.size or (self.source and sender[0] != self.source):
            return
        magic, incoming, total, offset = HEADER.unpack_from(packet)
        data = packet[HEADER.size:]
        valid = (magic == b"KJPG" and 4 <= total <= MAX_SIZE and
                 offset < total and offset % CHUNK == 0 and
                 len(data) == min(CHUNK, total - offset) and
                 (self.peer is None or sender == self.peer))
        if not valid:
            self.count["invalid_packets"] += 1
            return
        self.count["valid_packets"] += 1
        self.last_packet = now
        if incoming != self.latest_id:
            delta = 0 if self.latest_id is None else (incoming - self.latest_id) % (1 << 32)
            newer = self.latest_id is None or 0 < delta < (1 << 31)
            if newer:
                old = self.frames.get(self.latest_id)
                if old is not None:
                    old.at_boundary = now
                    old.deadline = now + self.grace
                    heapq.heappush(self.expiries, (old.deadline, old.frame_id))
                    self.count["strict_drops"] += 1
                    self.log(f"STRICT_DROP frame={old.frame_id} next={incoming} "
                             f"missing_at_boundary={old.expected - len(old.chunks)} "
                             f"first_missing_offsets={old.first_missing()}")
                if self.latest_id is not None and delta > 1:
                    self.count["unobserved_ids"] += delta - 1
                    self.log(f"ID_GAP after={self.latest_id} next={incoming} "
                             f"unobserved={delta - 1}")
                self.peer = sender
                self.latest_id = incoming
                frame = Frame(incoming, total, now)
                self.frames[incoming] = frame
                heapq.heappush(self.expiries, (frame.deadline, frame.frame_id))
        frame = self.frames.get(incoming)
        if frame is None:
            self.count["packets_for_closed_frames"] += 1
            return
        if frame.total != total:
            self.count["size_mismatch_packets"] += 1
            return
        if offset in frame.chunks:
            self.count["duplicate_packets"] += 1
            return
        frame.chunks.add(offset)
        if frame.at_boundary is not None:
            frame.late_chunks += 1
            self.count["late_unique_chunks"] += 1
        if offset == 0:
            frame.start_bytes = data[:2]
        # The EOI marker can straddle chunks when the final chunk is one byte.
        # Remember each byte independently; packets can arrive out of order.
        if offset <= total - 2 < offset + len(data):
            frame.end_first = data[total - 2 - offset]
        if offset <= total - 1 < offset + len(data):
            frame.end_second = data[total - 1 - offset]
        if len(frame.chunks) == frame.expected:
            del self.frames[incoming]
            end_marker = (frame.end_first, frame.end_second)
            if frame.start_bytes != b"\xff\xd8" or end_marker != (0xff, 0xd9):
                self.count["invalid_jpegs"] += 1
                end_hex = "".join("??" if b is None else f"{b:02x}" for b in end_marker)
                last_chunk_bytes = ((frame.total - 1) % CHUNK) + 1
                self.log(f"INVALID_JPEG frame={incoming} jpeg_bytes={frame.total} "
                         f"last_chunk_bytes={last_chunk_bytes} "
                         f"start={frame.start_bytes.hex()} end={end_hex}")
            elif frame.at_boundary is not None:
                self.count["recovered"] += 1
                self.log(f"RECOVERED frame={incoming} late_unique_chunks={frame.late_chunks} "
                         f"after_next_ms={(now - frame.at_boundary) * 1000:.1f}")
            else:
                self.count["strict_complete"] += 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8081)
    parser.add_argument("--source", help="optional board IPv4 address")
    parser.add_argument("--grace-ms", type=int, default=500,
                        help="time to wait after a newer frame arrives (default: 500 ms)")
    parser.add_argument("--seconds", type=int, default=180,
                        help="test duration after first valid packet (default: 180 s)")
    parser.add_argument("--idle-seconds", type=float, default=2.5,
                        help="end after this many seconds without packets (default: 2.5)")
    args = parser.parse_args()
    if (not 1 <= args.port <= 65535 or not 50 <= args.grace_ms <= 2000 or
            args.seconds < 1 or not 0.5 <= args.idle_seconds <= 60):
        parser.error("port must be 1-65535, grace-ms 50-2000, seconds positive, "
                     "and idle-seconds 0.5-60")
    log = Logger()
    inspector = Inspector(args.grace_ms / 1000, log.log, args.source)
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    started = None
    report_at = None
    previous = collections.Counter()
    try:
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4 * 1024 * 1024)
        sock.bind(("0.0.0.0", args.port))
        sock.settimeout(0.1)
        log.log(f"LISTENING UDP {args.port}; diagnostic_version={VERSION}; grace={args.grace_ms} ms; "
                f"duration={args.seconds} s after first packet; "
                f"socket_receive_buffer={sock.getsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF)} bytes")
        log.log("Now press k + Enter on the KV260. No video window will open.")
        while True:
            try:
                packet, sender = sock.recvfrom(2048)
            except socket.timeout:
                packet, sender = b"", None
            now = time.monotonic()
            inspector.expire(now)
            if packet:
                inspector.feed(packet, sender, now)
                if started is None and inspector.count["valid_packets"]:
                    started = now
                    report_at = now
                    log.log("First valid KJPG packet received; timing started.")
            if started is None:
                continue
            if now - report_at >= 5:
                elapsed = now - report_at
                current = inspector.count.copy()
                strict_fps = (current["strict_complete"] - previous["strict_complete"]) / elapsed
                grace_fps = ((current["strict_complete"] - previous["strict_complete"]) +
                             (current["recovered"] - previous["recovered"])) / elapsed
                log.log(f"STATS {elapsed:.1f}s strict_complete={strict_fps:.2f} fps "
                        f"grace_complete={grace_fps:.2f} fps "
                        f"strict_drops={current['strict_drops']} recovered={current['recovered']} "
                        f"unresolved={current['unresolved']} late_chunks={current['late_unique_chunks']} "
                        f"ID_gaps={current['unobserved_ids']}")
                previous = current
                report_at = now
            if now - started >= args.seconds:
                log.log("TIME LIMIT REACHED: press k + Enter on the KV260 to stop streaming.")
                break
            if now - inspector.last_packet >= args.idle_seconds:
                log.log("STREAM IDLE: the test is ending after packets stopped arriving.")
                break
    except KeyboardInterrupt:
        log.log("Stopped by user. Press k + Enter on the KV260 if it is still streaming.")
    except OSError as exc:
        log.log(f"SOCKET ERROR: {exc}")
        return 1
    finally:
        sock.close()
        c = inspector.count
        log.log(f"TOTAL strict_complete={c['strict_complete']} strict_drops={c['strict_drops']} "
                f"recovered={c['recovered']} unresolved={c['unresolved']} "
                f"late_unique_chunks={c['late_unique_chunks']} timeouts={c['timeouts']} "
                f"invalid_jpegs={c['invalid_jpegs']} unobserved_IDs={c['unobserved_ids']} "
                f"invalid_packets={c['invalid_packets']} packets_for_closed_frames={c['packets_for_closed_frames']} "
                f"pending_at_stop={len(inspector.frames)} valid_packets={c['valid_packets']}")
        log.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
