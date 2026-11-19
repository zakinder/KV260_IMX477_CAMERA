"""Bounded KJPG UDP frame reassembly for the existing KV260 sender."""
import struct
import time

HEADER = struct.Struct("!4sIII")
CHUNK = 1384
MAX_SIZE = 8 * 1024 * 1024
FRAME_TIMEOUT = 2.0
RESTART_GAP = 10.0


class Reassembler:
    """One frame at a time; a newer ID ends an incomplete older frame."""
    def __init__(self, source=None):
        self.source = source
        self.frame_id = None
        self.frame_started = 0.0
        self.last_packet = 0.0
        self.peer = None
        self.data = None
        self.offsets = set()
        self.complete = 0
        self.incomplete = 0
        self.missing = 0
        self.invalid_jpeg = 0
        self.datagrams = 0
        self.frame_gaps = 0

    def _drop(self):
        if self.data is not None:
            self.incomplete += 1
            self.missing += (len(self.data) + CHUNK - 1) // CHUNK - len(self.offsets)
            self.data = None
            self.offsets.clear()

    def expire(self, now=None):
        now = time.monotonic() if now is None else now
        if self.data is not None and now - self.frame_started >= FRAME_TIMEOUT:
            self._drop()
        if self.peer is not None and now - self.last_packet >= RESTART_GAP:
            self._drop()
            self.peer = None
            self.frame_id = None

    def feed(self, packet, peer, now=None):
        """Return (frame ID, JPEG bytes) when complete, otherwise None."""
        now = time.monotonic() if now is None else now
        self.expire(now)
        if len(packet) <= HEADER.size or (self.source and peer[0] != self.source):
            return None
        magic, frame_id, total, offset = HEADER.unpack_from(packet)
        part = packet[HEADER.size:]
        if (magic != b"KJPG" or total < 4 or total > MAX_SIZE or offset >= total
                or offset % CHUNK or len(part) != min(CHUNK, total - offset)
                or (self.peer is not None and peer != self.peer)):
            return None
        self.datagrams += 1
        if frame_id != self.frame_id:
            newer = self.frame_id is None or 0 < ((frame_id - self.frame_id) & 0xffffffff) < 0x80000000
            if not newer:
                self.last_packet = now
                return None
            self._drop()
            if self.frame_id is not None:
                delta = (frame_id - self.frame_id) & 0xffffffff
                if delta > 1:
                    self.frame_gaps += delta - 1
            self.peer = peer
            self.frame_id = frame_id
            self.data = bytearray(total)
            self.offsets.clear()
            self.frame_started = now
        self.last_packet = now
        if self.data is None or len(self.data) != total or offset in self.offsets:
            return None
        self.data[offset:offset + len(part)] = part
        self.offsets.add(offset)
        if len(self.offsets) != (total + CHUNK - 1) // CHUNK:
            return None
        jpeg = bytes(self.data)
        self.data = None
        self.offsets.clear()
        if not jpeg.startswith(b"\xff\xd8") or not jpeg.endswith(b"\xff\xd9"):
            self.invalid_jpeg += 1
            return None
        self.complete += 1
        return frame_id, jpeg
