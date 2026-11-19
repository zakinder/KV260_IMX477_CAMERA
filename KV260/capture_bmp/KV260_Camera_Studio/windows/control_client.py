"""Small request/reply client for the Camera Studio board extension."""
import ipaddress
import queue
import socket
import threading
import time


class ControlClient:
    def __init__(self, events):
        self.events = events
        self.jobs = queue.Queue(maxsize=8)
        self.stopping = threading.Event()
        self.sequence = 0
        self.thread = threading.Thread(target=self._loop, daemon=True)
        self.thread.start()

    def send(self, host, port, operation, *values):
        ipaddress.IPv4Address(host)
        if not 1 <= int(port) <= 65535:
            raise ValueError("Control port must be 1–65535")
        try:
            self.jobs.put_nowait((host, int(port), operation, values))
        except queue.Full as exc:
            raise ValueError("Control queue is full; wait for the current request") from exc

    def close(self):
        self.stopping.set()

    def _loop(self):
        while not self.stopping.is_set():
            try:
                host, port, operation, values = self.jobs.get(timeout=0.2)
            except queue.Empty:
                continue
            self.sequence = self.sequence % 2147483647 + 1
            seq = self.sequence
            message = " ".join(["KVC1", str(seq), operation] + [str(v) for v in values])
            try:
                with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
                    sock.connect((host, port))
                    sock.send(message.encode("ascii"))
                    deadline = time.monotonic() + 12.0
                    while True:
                        remaining = deadline - time.monotonic()
                        if remaining <= 0:
                            raise TimeoutError("No reply; the setting may or may not have been applied. Read the board state before retrying.")
                        sock.settimeout(remaining)
                        try:
                            data = sock.recv(512).decode("ascii", "strict").split()
                        except socket.timeout as exc:
                            raise TimeoutError("No reply; the setting may or may not have been applied. Read the board state before retrying.") from exc
                        if len(data) >= 4 and data[0] == "KVR1" and data[1] == str(seq):
                            self.events.put(("control", operation, data[2:], (host, port), values))
                            break
            except (OSError, UnicodeError, TimeoutError) as exc:
                self.events.put(("control_error", operation, str(exc), (host, port)))
            finally:
                self.jobs.task_done()
