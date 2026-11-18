"""Receive KV260 KJPG frames independently of the ffplay display process."""
import argparse
from pathlib import Path
import queue
import socket
import struct
import subprocess
import sys
import threading
import time

HEADER = struct.Struct('!4sIII')
CHUNK = 1384
MAX_SIZE = 8 * 1024 * 1024
FRAME_TIMEOUT = 2.0
RESTART_GAP = 10.0


def jpeg_dimensions(jpeg):
    """Read JPEG SOF dimensions without decoding or adding dependencies."""
    if len(jpeg) < 4 or jpeg[:2] != b'\xff\xd8':
        return None
    sof_markers = {0xc0, 0xc1, 0xc2, 0xc3, 0xc5, 0xc6, 0xc7,
                   0xc9, 0xca, 0xcb, 0xcd, 0xce, 0xcf}
    pos = 2
    while pos < len(jpeg):
        if jpeg[pos] != 0xff:
            return None
        while pos < len(jpeg) and jpeg[pos] == 0xff:
            pos += 1
        if pos >= len(jpeg):
            return None
        marker = jpeg[pos]
        pos += 1
        if marker in (0xd8, 0x01) or 0xd0 <= marker <= 0xd7:
            continue
        if marker in (0xd9, 0xda) or pos + 2 > len(jpeg):
            return None
        length = (jpeg[pos] << 8) | jpeg[pos + 1]
        if length < 2 or pos + length > len(jpeg):
            return None
        if marker in sof_markers:
            if length < 8:
                return None
            height = (jpeg[pos + 3] << 8) | jpeg[pos + 4]
            width = (jpeg[pos + 5] << 8) | jpeg[pos + 6]
            return (width, height) if width and height else None
        pos += length
    return None


def incomplete_details(frame_id, active, received, reason):
    expected = (len(active) + CHUNK - 1) // CHUNK
    missing = expected - len(received)
    first_missing = [i * CHUNK for i in range(expected)
                     if i * CHUNK not in received][:5]
    return (f'Dropped incomplete frame {frame_id} ({reason}; '
            f'chunks {len(received)}/{expected}; missing {missing}; '
            f'first missing offsets {first_missing}; JPEG bytes {len(active)})')


class SampleSaver:
    """Keep disk writes off the UDP receiver thread; queue is bounded."""
    def __init__(self, maximum):
        self.maximum = maximum
        self.pending = queue.Queue(maxsize=4)
        self.stop = threading.Event()
        self.accepted = 0
        self.saved = 0
        self.skipped = 0
        self.thread = threading.Thread(target=self._write_loop, daemon=True)
        self.thread.start()

    def offer(self, frame_id, jpeg):
        if self.accepted >= self.maximum:
            return
        try:
            self.pending.put_nowait((frame_id, jpeg))
            self.accepted += 1
        except queue.Full:
            self.skipped += 1
            print(f'Sample frame {frame_id} not saved: disk queue full', flush=True)

    def _write_loop(self):
        while not self.stop.is_set() or not self.pending.empty():
            try:
                frame_id, jpeg = self.pending.get(timeout=0.1)
            except queue.Empty:
                continue
            try:
                path = Path(__file__).resolve().with_name(
                    f'kv260_sample_{frame_id}_{time.time_ns()}.jpg')
                with path.open('xb') as output:
                    output.write(jpeg)
                dimensions = jpeg_dimensions(jpeg)
                size = f'{dimensions[0]}x{dimensions[1]}' if dimensions else 'unknown'
                self.saved += 1
                print(f'Saved sample frame {frame_id}: {size}, {len(jpeg):,} bytes: {path}', flush=True)
            except OSError as exc:
                print(f'Could not save sample frame {frame_id}: {exc}', flush=True)
            finally:
                self.pending.task_done()

    def close(self):
        self.stop.set()
        self.thread.join(timeout=5)
        if self.thread.is_alive():
            print('Sample writer is still finishing queued files', flush=True)


class LatestFrame:
    """One in-progress pipe write and at most one waiting frame."""
    def __init__(self):
        self.condition = threading.Condition()
        self.pending = None
        self.closed = False
        self.submitted = 0
        self.written = 0
        self.replaced = 0
        self.failure = None

    def offer(self, frame_id, jpeg):
        with self.condition:
            if self.pending is not None:
                self.replaced += 1
            self.pending = (frame_id, jpeg)
            self.submitted += 1
            self.condition.notify()

    def close(self):
        with self.condition:
            self.closed = True
            self.condition.notify_all()

    def counts(self):
        with self.condition:
            return self.submitted, self.written, self.replaced, self.failure

    def write_loop(self, proc):
        try:
            while True:
                with self.condition:
                    while self.pending is None and not self.closed:
                        self.condition.wait()
                    if self.closed:
                        return
                    frame_id, jpeg = self.pending
                    self.pending = None
                proc.stdin.write(jpeg)
                proc.stdin.flush()
                with self.condition:
                    self.written += 1
        except (BrokenPipeError, OSError, ValueError) as exc:
            with self.condition:
                self.failure = str(exc)
                self.closed = True
                self.condition.notify_all()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', help='optional KV260 IPv4 address')
    parser.add_argument('--port', default=8081, type=int)
    parser.add_argument('--ffplay', default='ffplay')
    parser.add_argument('--save-first', action='store_true', help='save first received JPEG')
    parser.add_argument('--save-every', default=0, type=int,
                        help='save frames whose ID is a multiple of this value (0 disables)')
    parser.add_argument('--save-max', default=8, type=int,
                        help='maximum number of later sample JPEGs to save (1-20)')
    parser.add_argument('--no-preview-scale', action='store_true',
                        help='disable the 1920x1080 Lanczos preview filter')
    args = parser.parse_args()
    if args.save_every < 0 or not 1 <= args.save_max <= 20:
        parser.error('--save-every must be nonnegative and --save-max must be 1-20')
    local = Path(__file__).with_name('ffplay.exe')
    player = str(local.resolve()) if args.ffplay == 'ffplay' and local.is_file() else args.ffplay
    command = [player, '-hide_banner', '-loglevel', 'warning', '-analyzeduration', '1',
               '-probesize', '32', '-f', 'mjpeg']
    if not args.no_preview_scale:
        command += ['-vf', 'scale=1920:1080:flags=lanczos']
    command += ['-i', 'pipe:0', '-sync', 'video', '-x', '1280', '-y', '720']
    latest = LatestFrame()
    sock = None
    proc = None
    writer = None
    saver = None
    complete_count = 0
    incomplete_count = 0
    payload_bytes = 0
    unobserved_ids = 0
    started_time = time.monotonic()
    report_time = started_time
    report_complete = 0
    report_written = 0
    report_replaced = 0
    report_bytes = 0
    active = None
    frame_id = None
    frame_started = 0.0
    last_packet = 0.0
    peer = None
    received = set()
    saved = False
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4 * 1024 * 1024)
        sock.bind(('0.0.0.0', args.port))
        sock.settimeout(0.25)
        proc = subprocess.Popen(command, stdin=subprocess.PIPE)
        writer = threading.Thread(target=latest.write_loop, args=(proc,), daemon=True)
        writer.start()
        if args.save_every:
            saver = SampleSaver(args.save_max)
        print(f'Listening on UDP {args.port}. Press k + Enter on the KV260.', flush=True)
        print('Preview: 1920x1080 Lanczos' if not args.no_preview_scale else 'Preview: no pre-scale filter', flush=True)
        while True:
            try:
                packet, sender = sock.recvfrom(2048)
            except socket.timeout:
                packet, sender = b'', None
            now = time.monotonic()
            if active is not None and now - frame_started >= FRAME_TIMEOUT:
                print(incomplete_details(frame_id, active, received, 'timeout'), flush=True)
                incomplete_count += 1
                active = None
            if peer is not None and now - last_packet >= RESTART_GAP:
                peer, frame_id = None, None
            if len(packet) > HEADER.size and (not args.source or sender[0] == args.source):
                magic, incoming_id, total, offset = HEADER.unpack_from(packet)
                data = packet[HEADER.size:]
                valid = (magic == b'KJPG' and 4 <= total <= MAX_SIZE and
                         offset < total and offset % CHUNK == 0 and
                         len(data) == min(CHUNK, total - offset) and
                         (peer is None or sender == peer))
                if valid:
                    if incoming_id != frame_id:
                        newer = frame_id is None or 0 < (incoming_id - frame_id) % (1 << 32) < (1 << 31)
                        if newer:
                            if active is not None:
                                print(incomplete_details(frame_id, active, received,
                                                         'next frame arrived'), flush=True)
                                incomplete_count += 1
                            if frame_id is not None:
                                delta = (incoming_id - frame_id) % (1 << 32)
                                if delta > 1:
                                    unobserved_ids += delta - 1
                                    print(f'Frame ID gap: after {frame_id}, next {incoming_id}; '
                                          f'{delta - 1} IDs not observed', flush=True)
                            peer, frame_id = sender, incoming_id
                            active, frame_started = bytearray(total), now
                            received.clear()
                    last_packet = now
                    if incoming_id == frame_id and active is not None and len(active) == total and offset not in received:
                        active[offset:offset + len(data)] = data
                        received.add(offset)
                        if len(received) == (total + CHUNK - 1) // CHUNK:
                            jpeg, active = active, None
                            if jpeg.startswith(b'\xff\xd8') and jpeg.endswith(b'\xff\xd9'):
                                if args.save_first and not saved:
                                    path = Path(__file__).resolve().with_name(f'kv260_frame_{frame_id}_{time.time_ns()}.jpg')
                                    with path.open('xb') as output:
                                        output.write(jpeg)
                                    print(f'Saved received JPEG: {path}', flush=True)
                                    saved = True
                                complete_count += 1
                                payload_bytes += len(jpeg)
                                latest.offer(frame_id, jpeg)
                                if saver is not None and frame_id % args.save_every == 0:
                                    saver.offer(frame_id, jpeg)
                            else:
                                incomplete_count += 1
                                print(f'Dropped invalid JPEG frame {frame_id}', flush=True)
            submitted, written, replaced, failure = latest.counts()
            if failure is not None or proc.poll() is not None:
                print(f'FFplay closed: {failure or proc.returncode}', flush=True)
                break
            if now - report_time >= 5.0:
                elapsed = now - report_time
                count = complete_count - report_complete
                byte_count = payload_bytes - report_bytes
                mean_kib = byte_count / count / 1024 if count else 0.0
                print(f'STATS {elapsed:.1f}s: received {(complete_count-report_complete)/elapsed:.2f} fps; '
                      f'written to ffplay {(written-report_written)/elapsed:.2f} fps; '
                      f'replaced waiting {replaced-report_replaced}; incomplete total {incomplete_count}; '
                      f'last frame {frame_id}; avg JPEG {mean_kib:.1f} KiB; '
                      f'JPEG payload {byte_count * 8 / elapsed / 1000000:.1f} Mb/s; '
                      f'unobserved IDs {unobserved_ids}', flush=True)
                report_time, report_complete = now, complete_count
                report_written, report_replaced = written, replaced
                report_bytes = payload_bytes
    except KeyboardInterrupt:
        pass
    except OSError as exc:
        print(f'Player or network error: {exc}', file=sys.stderr, flush=True)
    finally:
        latest.close()
        if proc is not None and proc.poll() is None:
            proc.terminate()
            try:
                proc.wait(timeout=3)
            except subprocess.TimeoutExpired:
                proc.kill()
                proc.wait()
        if sock is not None:
            sock.close()
        if writer is not None:
            writer.join(timeout=1)
        if saver is not None:
            saver.close()
        submitted, written, replaced, failure = latest.counts()
        print(f'TOTAL received={complete_count}, written to ffplay={written}, '
              f'replaced waiting={replaced}, incomplete={incomplete_count}, '
              f'unobserved IDs={unobserved_ids}', flush=True)


if __name__ == '__main__':
    main()
