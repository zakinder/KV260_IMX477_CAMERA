"""Play the KV260 KJPG stream with ffplay."""
import argparse
from pathlib import Path
import socket
import struct
import subprocess
import time

HEADER = struct.Struct("!4sIII")
CHUNK = 1384
MAX_SIZE = 8 * 1024 * 1024
FRAME_TIMEOUT = 2.0
RESTART_GAP = 10.0


def frames(sock, source):
    active = None
    last_id = None
    peer = None
    last_packet = 0.0
    received = set()
    while True:
        try:
            packet, sender = sock.recvfrom(2048)
        except socket.timeout:
            packet = b""
            sender = None
        now = time.monotonic()
        if active is not None and now - started >= FRAME_TIMEOUT:
            print(f"Dropped incomplete frame {last_id}", flush=True)
            active = None
        if peer is not None and now - last_packet >= RESTART_GAP:
            peer, last_id = None, None
        if len(packet) <= HEADER.size or (source and sender[0] != source):
            continue
        magic, frame_id, total, offset = HEADER.unpack_from(packet)
        data = packet[HEADER.size:]
        if (magic != b"KJPG" or not 4 <= total <= MAX_SIZE
                or offset >= total or offset % CHUNK
                or len(data) != min(CHUNK, total - offset)):
            continue
        if peer is not None and sender != peer:
            continue
        if frame_id != last_id:
            if last_id is not None and not 0 < (frame_id - last_id) % (1 << 32) < (1 << 31):
                continue
            if active is not None:
                print(f"Dropped incomplete frame {last_id}", flush=True)
            peer, last_id = sender, frame_id
            active, started = bytearray(total), now
            received.clear()
        last_packet = now
        if active is None or len(active) != total or offset in received:
            continue
        active[offset:offset + len(data)] = data
        received.add(offset)
        if len(received) == (total + CHUNK - 1) // CHUNK:
            complete, active = active, None
            if complete.startswith(b"\xff\xd8") and complete.endswith(b"\xff\xd9"):
                yield frame_id, complete
            else:
                print(f"Dropped invalid JPEG frame {frame_id}", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", help="optional KV260 IPv4 address")
    parser.add_argument("--port", default=8081, type=int)
    parser.add_argument("--ffplay", default="ffplay")
    args = parser.parse_args()
    local = Path(__file__).with_name("ffplay.exe")
    player = str(local.resolve()) if args.ffplay == "ffplay" and local.is_file() else args.ffplay
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
            sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4 * 1024 * 1024)
            sock.bind(("0.0.0.0", args.port))
            sock.settimeout(0.25)
            with subprocess.Popen(
                [player, "-hide_banner", "-loglevel", "warning", "-analyzeduration", "1",
                 "-probesize", "32", "-f", "mjpeg", "-i", "pipe:0",
                 "-sync", "video", "-x", "1280", "-y", "720"],
                stdin=subprocess.PIPE,
            ) as proc:
                print(f"Listening on UDP {args.port}. Press k + Enter on the KV260.", flush=True)
                previous = None
                try:
                    for frame_id, jpeg in frames(sock, args.source):
                        now = time.monotonic()
                        rate = f", {1 / (now - previous):.2f} fps" if previous is not None else ""
                        previous = now
                        print(f"Frame {frame_id}: {len(jpeg):,} bytes{rate}", flush=True)
                        proc.stdin.write(jpeg)
                        proc.stdin.flush()
                finally:
                    if proc.poll() is None:
                        proc.terminate()
    except KeyboardInterrupt:
        return
    except BrokenPipeError:
        return
    except OSError as error:
        parser.exit(1, f"{error}\n")


if __name__ == "__main__":
    main()
