"""Receive 4K KJPG without blocking the UI; decode only the newest frame."""
import collections
import io
import queue
import socket
import threading
import time

from PIL import Image
from kjpg import Reassembler


def apply_preview_hsv(image, hue_degrees, saturation, value):
    """Apply HSV to the displayed image only, never to the received JPEG."""
    if hue_degrees == 0 and saturation == 1.0 and value == 1.0:
        return image
    h, s, v = image.convert("HSV").split()
    shift = round(hue_degrees * 256 / 360)
    h = h.point([(i + shift) % 256 for i in range(256)])
    s = s.point([min(255, round(i * saturation)) for i in range(256)])
    v = v.point([min(255, round(i * value)) for i in range(256)])
    return Image.merge("HSV", (h, s, v)).convert("RGB")


class VideoEngine:
    def __init__(self, events, source, port):
        self.events = events
        self.source = source
        self.port = port
        self.stop = threading.Event()
        self.lock = threading.Lock()
        self.frames = queue.Queue(maxsize=1)
        self.rendered = queue.Queue(maxsize=1)
        self.target = (1000, 650)
        self.hsv = (0, 1.0, 1.0)
        self.rotation = 0
        self.reader = Reassembler(source)
        self.recent = collections.deque()
        self.last_jpeg = None
        self.last_id = None
        self.last_dimensions = None
        self.preview_skips = 0
        self.socket = None

    def start(self):
        # Bind before returning so a port conflict is reported immediately.
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4 * 1024 * 1024)
            sock.bind(("0.0.0.0", self.port))
            sock.settimeout(0.2)
        except Exception:
            sock.close()
            raise
        self.socket = sock
        threading.Thread(target=self._receive, daemon=True).start()
        threading.Thread(target=self._decode, daemon=True).start()

    def close(self):
        self.stop.set()
        if self.socket:
            self.socket.close()

    def set_preview(self, target, hsv, rotation):
        with self.lock:
            self.target = tuple(target)
            self.hsv = tuple(hsv)
            self.rotation = rotation

    def snapshot(self):
        with self.lock:
            now = time.monotonic()
            while self.recent and self.recent[0] < now - 5:
                self.recent.popleft()
            return {
                "fps": len(self.recent) / 5.0,
                "id": self.last_id,
                "dimensions": self.last_dimensions,
                "complete": self.reader.complete,
                "incomplete": self.reader.incomplete,
                "missing": self.reader.missing,
                "frame_gaps": self.reader.frame_gaps,
                "invalid": self.reader.invalid_jpeg,
                "preview_skips": self.preview_skips,
            }

    @staticmethod
    def _replace(q, value):
        dropped = False
        try:
            q.put_nowait(value)
        except queue.Full:
            try:
                q.get_nowait()
                dropped = True
            except queue.Empty:
                pass
            try:
                q.put_nowait(value)
            except queue.Full:
                dropped = True
        return dropped

    def _receive(self):
        try:
            while not self.stop.is_set():
                try:
                    packet, peer = self.socket.recvfrom(2048)
                except socket.timeout:
                    with self.lock:
                        self.reader.expire()
                    continue
                with self.lock:
                    complete = self.reader.feed(packet, peer)
                    if complete:
                        self.last_id, self.last_jpeg = complete
                        self.recent.append(time.monotonic())
                if complete and self._replace(self.frames, complete):
                    with self.lock:
                        self.preview_skips += 1
        except OSError as exc:
            if not self.stop.is_set():
                self.events.put(("video_error", str(exc)))
        finally:
            if self.socket:
                self.socket.close()

    def _decode(self):
        while not self.stop.is_set():
            try:
                frame_id, jpeg = self.frames.get(timeout=0.2)
            except queue.Empty:
                continue
            with self.lock:
                target, hsv, rotation = self.target, self.hsv, self.rotation
            try:
                with Image.open(io.BytesIO(jpeg)) as source:
                    with self.lock:
                        self.last_dimensions = source.size
                    source.draft("RGB", target)
                    picture = source.convert("RGB")
                if rotation:
                    picture = picture.rotate(rotation, expand=True)
                picture.thumbnail(target, Image.Resampling.LANCZOS)
                picture = apply_preview_hsv(picture, *hsv)
                self._replace(self.rendered, (frame_id, picture))
            except (OSError, ValueError) as exc:
                self.events.put(("decode_error", str(exc)))
