"""Receive KV260 KJPG frames independently of the ffplay display process."""
import argparse
from pathlib import Path
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
    parser.add_argument('--no-preview-scale', action='store_true',
                        help='disable the 1920x1080 Lanczos preview filter')
    args = parser.parse_args()
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
    complete_count = 0
    incomplete_count = 0
    started_time = time.monotonic()
    report_time = started_time
    report_complete = 0
    report_written = 0
    report_replaced = 0
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
        print(f'Listening on UDP {args.port}. Press k + Enter on the KV260.', flush=True)
        print('Preview: 1920x1080 Lanczos' if not args.no_preview_scale else 'Preview: no pre-scale filter', flush=True)
        while True:
            try:
                packet, sender = sock.recvfrom(2048)
            except socket.timeout:
                packet, sender = b'', None
            now = time.monotonic()
            if active is not None and now - frame_started >= FRAME_TIMEOUT:
                print(f'Dropped incomplete frame {frame_id} (timeout)', flush=True)
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
                                print(f'Dropped incomplete frame {frame_id}', flush=True)
                                incomplete_count += 1
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
                                latest.offer(frame_id, jpeg)
                            else:
                                incomplete_count += 1
                                print(f'Dropped invalid JPEG frame {frame_id}', flush=True)
            submitted, written, replaced, failure = latest.counts()
            if failure is not None or proc.poll() is not None:
                print(f'FFplay closed: {failure or proc.returncode}', flush=True)
                break
            if now - report_time >= 5.0:
                elapsed = now - report_time
                print(f'STATS {elapsed:.1f}s: received {(complete_count-report_complete)/elapsed:.2f} fps; '
                      f'written to ffplay {(written-report_written)/elapsed:.2f} fps; '
                      f'replaced waiting {replaced-report_replaced}; incomplete total {incomplete_count}; '
                      f'last frame {frame_id}', flush=True)
                report_time, report_complete = now, complete_count
                report_written, report_replaced = written, replaced
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
        submitted, written, replaced, failure = latest.counts()
        print(f'TOTAL received={complete_count}, written to ffplay={written}, '
              f'replaced waiting={replaced}, incomplete={incomplete_count}', flush=True)


if __name__ == '__main__':
    main()
