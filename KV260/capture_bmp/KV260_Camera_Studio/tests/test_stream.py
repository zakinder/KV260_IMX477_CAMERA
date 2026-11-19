import io
import os
import queue
import socket
import sys
import threading
import time
import unittest
from pathlib import Path

from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "windows"))
from kjpg import CHUNK, HEADER, Reassembler
from control_client import ControlClient
from video_engine import VideoEngine, apply_preview_hsv


def jpeg_bytes(size=(3840, 2160)):
    image = Image.new("RGB", size, (186, 80, 31))
    output = io.BytesIO()
    image.save(output, "JPEG", quality=80)
    return output.getvalue()


def packets(frame_id, data):
    return [HEADER.pack(b"KJPG", frame_id, len(data), offset) + data[offset:offset+CHUNK]
            for offset in range(0, len(data), CHUNK)]


class TestReassembly(unittest.TestCase):
    def test_valid_reordered_and_duplicate_chunks(self):
        image = jpeg_bytes((512, 512))
        parts = packets(7, image)
        self.assertGreater(len(parts), 2)
        reader = Reassembler("192.168.0.10")
        peer = ("192.168.0.10", 8080)
        self.assertIsNone(reader.feed(parts[1], peer, 1.0))
        self.assertIsNone(reader.feed(parts[1], peer, 1.01))
        result = None
        for packet in [parts[0], *parts[2:]]:
            result = reader.feed(packet, peer, 1.1)
        self.assertEqual(result, (7, image))
        self.assertEqual(reader.complete, 1)
        self.assertEqual(reader.incomplete, 0)

    def test_drop_and_restart(self):
        image = jpeg_bytes((512, 512))
        reader = Reassembler()
        peer = ("192.168.0.10", 8080)
        reader.feed(packets(100, image)[0], peer, 1.0)
        reader.feed(packets(101, image)[0], peer, 1.2)
        self.assertEqual(reader.incomplete, 1)
        self.assertEqual(reader.missing, len(packets(100, image))-1)
        reader.expire(12.0)
        self.assertEqual(reader.incomplete, 2)
        result = None
        for packet in packets(1, image):
            result = reader.feed(packet, peer, 12.1)
        self.assertEqual(result, (1, image))

    def test_reject_invalid_and_wrong_source(self):
        reader = Reassembler("192.168.0.10")
        p = HEADER.pack(b"KJPG", 1, 20, 0) + b"x" * 20
        self.assertIsNone(reader.feed(p, ("192.168.0.11", 8080), 0))
        self.assertEqual(reader.datagrams, 0)
        self.assertIsNone(reader.feed(p, ("192.168.0.10", 8080), 0))
        self.assertEqual(reader.invalid_jpeg, 1)
        self.assertIsNone(reader.feed(HEADER.pack(b"KJPG", 2, 9000000, 0) + b"x", ("192.168.0.10", 8080), 1))

    def test_wrap(self):
        image = jpeg_bytes((64, 64))
        reader = Reassembler()
        peer = ("192.168.0.10", 8080)
        for fid in (0xffffffff, 0):
            result = None
            for packet in packets(fid, image):
                result = reader.feed(packet, peer, 1.0)
            self.assertEqual(result, (fid, image))
        self.assertEqual(reader.frame_gaps, 0)


class TestPreviewAndNetworking(unittest.TestCase):
    def test_hsv_neutral_and_zero_saturation(self):
        original = Image.new("RGB", (4, 4), (240, 10, 20))
        self.assertIs(apply_preview_hsv(original, 0, 1.0, 1.0), original)
        result = apply_preview_hsv(original, 45, 0.0, 1.0)
        r, g, b = result.getpixel((0, 0))
        self.assertEqual((r, g, b), (240, 240, 240))
        self.assertEqual(original.getpixel((0, 0)), (240, 10, 20))

    def test_control_reply_on_separate_udp_socket(self):
        events = queue.Queue()
        server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        server.bind(("127.0.0.1", 0))
        port = server.getsockname()[1]
        def responder():
            data, peer = server.recvfrom(512)
            self.assertEqual(data.split()[0], b"KVC1")
            seq = data.split()[1]
            server.sendto(b"KVR1 " + seq + b" OK PONG 1", peer)
            server.close()
        threading.Thread(target=responder, daemon=True).start()
        client = ControlClient(events)
        try:
            client.send("127.0.0.1", port, "PING")
            event = events.get(timeout=2)
            self.assertEqual(event[:3], ("control", "PING", ["OK", "PONG", "1"]))
        finally:
            client.close()

    def test_live_video_receive_and_decode(self):
        probe = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        probe.bind(("127.0.0.1", 0))
        port = probe.getsockname()[1]
        probe.close()
        events = queue.Queue()
        engine = VideoEngine(events, "127.0.0.1", port)
        engine.start()
        engine.set_preview((640, 360), (0, 1.0, 1.0), 0)
        data = jpeg_bytes()
        sender = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            for packet in packets(42, data):
                sender.sendto(packet, ("127.0.0.1", port))
                time.sleep(0.0002)
            fid, preview = engine.rendered.get(timeout=5)
            self.assertEqual(fid, 42)
            self.assertLessEqual(preview.width, 640)
            self.assertLessEqual(preview.height, 360)
            self.assertEqual(engine.snapshot()["dimensions"], (3840, 2160))
            self.assertEqual(engine.last_jpeg, data)
        finally:
            sender.close()
            engine.close()


if __name__ == "__main__":
    unittest.main()
