"""Run with a graphical display: local fake board + actual Tk window."""
import io
import queue
import socket
import sys
import threading
import time
import tkinter as tk
from tkinter import ttk
from pathlib import Path

from PIL import Image
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "windows"))
from kjpg import HEADER, CHUNK
from kv260_camera_studio import CameraStudio

server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server.bind(("127.0.0.1", 0))
server.settimeout(0.2)
board_port = server.getsockname()[1]
received = queue.Queue()
done = threading.Event()
reject_balance = threading.Event()


def fake_board():
    while not done.is_set():
        try:
            data, peer = server.recvfrom(1024)
        except socket.timeout:
            continue
        parts = data.decode("ascii").split()
        received.put(parts)
        if parts[2] == "PING":
            result = "PONG 1"
        elif parts[2] == "SENSOR":
            result = "SENSOR 300 2200 0 0 0 0 256 512 768 1024"
        else:
            result = "VFP_WRITTEN"
        if parts[2:] == ["OUT", "18"] and reject_balance.is_set():
            server.sendto(f"KVR1 {parts[1]} ERR FORMAT".encode(), peer)
        else:
            server.sendto(f"KVR1 {parts[1]} OK {result}".encode(), peer)


threading.Thread(target=fake_board, daemon=True).start()
probe = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
probe.bind(("127.0.0.1", 0))
video_port = probe.getsockname()[1]
probe.close()
root = tk.Tk()
app = CameraStudio(root, "127.0.0.1", video_port, board_port)
sender = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
try:
    def widgets(widget):
        yield widget
        for child in widget.winfo_children():
            yield from widgets(child)
    notebook = next(w for w in widgets(root) if isinstance(w, ttk.Notebook))
    for tab in notebook.tabs():
        notebook.select(tab)
        root.update()
    notebook.select(0)
    app.start_video()
    app.ping()
    img = Image.new("RGB", (3840, 2160), (175, 90, 30))
    buf = io.BytesIO()
    img.save(buf, format="JPEG")
    data = buf.getvalue()
    for offset in range(0, len(data), CHUNK):
        sender.sendto(HEADER.pack(b"KJPG", 1, len(data), offset) + data[offset:offset+CHUNK], ("127.0.0.1", video_port))
        time.sleep(0.0002)
    deadline = time.monotonic() + 5
    while time.monotonic() < deadline and not (app.ready and app.photo is not None):
        root.update()
        time.sleep(0.01)
    assert app.ready and app.photo is not None, (app.ready, app.message.get())
    app.send("SENSOR")
    deadline = time.monotonic() + 3
    while time.monotonic() < deadline and "Exposure 300" not in app.sensor_status.get():
        root.update()
        time.sleep(0.01)
    assert "Exposure 300" in app.sensor_status.get()
    app.knobs[1].value.set(1.5)
    app.apply_gain(1, app.knobs[1])
    app.exposure.set("35% of usable frame lines")
    app.apply_exposure()
    app.hw_saturation.set("1.5")
    app.hw_value.set("0.5")
    app.apply_hardware_hsv()
    deadline = time.monotonic() + 3
    commands = []
    while time.monotonic() < deadline:
        root.update()
        try:
            commands.append(received.get_nowait())
        except queue.Empty:
            time.sleep(0.01)
        if all(any(c[2] == name for c in commands) for name in ("GAIN", "EXPO", "CCM")):
            break
    gain = next(c for c in commands if c[2] == "GAIN")
    exposure = next(c for c in commands if c[2] == "EXPO")
    assert gain[3:] == ["1", "384"], gain
    assert exposure[3:] == ["2"], exposure
    matrix = next(c for c in commands if c[2] == "CCM")
    assert matrix[3:] == ["1", "1024", "0", "0", "0", "1536", "0", "0", "0", "512"], matrix

    for bank, expected_output in (("Dark • RGB path", 6), ("Light • HSV path", 22),
                                  ("Balance • YCbCr path", 18)):
        app.ccm_bank.set(bank)
        if expected_output == 18:
            reject_balance.set()  # Existing v1 firmware does not allow OUT 18.
            app.show_ccm_path()
            deadline = time.monotonic() + 3
            while time.monotonic() < deadline and "needs the updated gui_control.c" not in app.message.get():
                root.update()
                time.sleep(0.01)
            assert "needs the updated gui_control.c" in app.message.get(), app.message.get()
            reject_balance.clear()
        app.show_ccm_path()
        deadline = time.monotonic() + 3
        while time.monotonic() < deadline and f"Requested VFP output {expected_output}." not in app.message.get():
            root.update()
            time.sleep(0.01)
        assert f"Requested VFP output {expected_output}." in app.message.get(), app.message.get()
    app.send("OUT", 0)
    deadline = time.monotonic() + 3
    while time.monotonic() < deadline and "Requested VFP output 0." not in app.message.get():
        root.update()
        time.sleep(0.01)
    assert "Requested VFP output 0." in app.message.get(), app.message.get()
    print("PASS: Tk GUI + 4K video + sensor controls + CCM routes 6/22/18 + v1 compatibility + bypass")
finally:
    sender.close()
    done.set()
    app.close()
    server.close()
