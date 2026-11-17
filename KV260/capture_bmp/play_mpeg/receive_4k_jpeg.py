"""Receive one numbered KV260 JPEG snapshot using Python 3."""
import argparse
from pathlib import Path
import socket
import struct
import time

HEADER = struct.Struct("!4sIII")
CHUNK = 1384
MAX_SIZE = 8 * 1024 * 1024


def receive(sock, source_ip, timeout):
    deadline = time.monotonic() + timeout
    frame_key = None
    size = 0
    data = bytearray()
    received = set()

    while time.monotonic() < deadline:
        sock.settimeout(max(0.001, deadline - time.monotonic()))
        try:
            packet, peer = sock.recvfrom(2048)
        except socket.timeout:
            break
        if (source_ip and peer[0] != source_ip) or len(packet) <= HEADER.size:
            continue
        magic, frame_id, total, offset = HEADER.unpack_from(packet)
        payload = packet[HEADER.size:]
        if (magic != b"KJPG" or not 4 <= total <= MAX_SIZE
                or offset >= total or offset % CHUNK
                or len(payload) != min(CHUNK, total - offset)):
            continue
        key = (peer, frame_id)
        if frame_key is None:
            frame_key, size = key, total
            data = bytearray(size)
        if key != frame_key or size != total:
            continue
        data[offset:offset + len(payload)] = payload
        received.add(offset)
        if len(received) == (size + CHUNK - 1) // CHUNK:
            if not (data.startswith(b"\xff\xd8") and data.endswith(b"\xff\xd9")):
                raise ValueError("Complete payload lacks JPEG start/end markers")
            return data

    missing = (size + CHUNK - 1) // CHUNK - len(received)
    raise TimeoutError(f"snapshot incomplete: {len(received)} chunks received, "
                       f"{missing} missing" if frame_key else "no JPEG packets received")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8081)
    parser.add_argument("--source", default=None, help="optional KV260 IPv4 filter")
    parser.add_argument("--timeout", type=float, default=60)
    parser.add_argument("--output", type=Path, default=Path("kv260_4k.jpg"))
    args = parser.parse_args()
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
            sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4 * 1024 * 1024)
            sock.bind(("0.0.0.0", args.port))
            print(f"Listening on UDP {args.port}. Press j + Enter on the KV260.", flush=True)
            jpeg = receive(sock, args.source, args.timeout)
        args.output.write_bytes(jpeg)
        print(f"Saved {len(jpeg):,} bytes to {args.output.resolve()}")
    except (OSError, ValueError) as error:
        parser.exit(1, f"{error}\n")


if __name__ == "__main__":
    main()
