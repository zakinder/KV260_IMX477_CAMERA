"""KV260 4K MJPEG viewer with IMX477 and VFP control."""
import argparse
import ipaddress
import math
import queue
import tkinter as tk
from tkinter import filedialog, messagebox, ttk

from PIL import ImageTk

from control_client import ControlClient
from video_engine import VideoEngine

BG = "#0c1220"
PANEL = "#162135"
MUTED = "#aab9cc"
ACCENT = "#55d5c4"
WHITE = "#edf5ff"

OUTPUTS = {
    "0  Camera bypass": 0,
    "1  Test pattern": 1,
    "2  Selected RGB input": 2,
    "6  Dark CCM output": 6,
    "9  Color clustering": 9,
    "13  RGB contrast": 13,
    "15  Sobel edges": 15,
    "16  Clustering + edges": 16,
    "18  Balance CCM → YCbCr-to-RGB": 18,
    "22  HSV-to-RGB path": 22,
    "25  Saturation: cluster path": 25,
    "26  Saturation: edge path": 26,
    "27  CMYK-to-RGB path": 27,
    "30  Refined portrait": 30,
}
INPUTS = {
    "0  Camera RGB": 0,
    "1  Channel remap": 1,
    "2  RYB": 2,
    "3  VFP saturation/exposure": 3,
    "4  CMYK-to-RGB": 4,
    "5  Other RGB path": 5,
}
ADJUST = {
    "Contrast 1 (tenths)": (1, 0, 40),
    "Contrast 2 (tenths; may be unused)": (2, 0, 40),
    "Contrast 3 (tenths)": (3, 0, 40),
    "Contrast 4 (tenths)": (4, 0, 40),
    "Positive saturation P_SAT": (5, 0, 16),
    "Negative saturation N_SAT": (6, 0, 16),
    "RGB value multiplier": (7, 0, 16),
    "Contrast enable": (8, 0, 1),
    "Saturation reference": (9, 0, 255),
    "Output divisor: 0=/1, 1=/2, 2=/4": (10, 0, 2),
    "CMYK red key": (11, 0, 255),
    "CMYK green key": (12, 0, 255),
    "CMYK blue key": (13, 0, 255),
}


class GainKnob(ttk.Frame):
    """Pointer-driven dial with a numeric editor; movement does not send."""
    def __init__(self, parent, label, channel, apply):
        super().__init__(parent, style="Card.TFrame")
        self.value = tk.DoubleVar(value=1.0)
        ttk.Label(self, text=label, style="CardTitle.TLabel").pack(pady=(4, 0))
        self.dial = tk.Canvas(self, width=82, height=82, bg=PANEL,
                              highlightthickness=0, cursor="hand2")
        self.dial.pack()
        self.dial.bind("<Button-1>", self._drag)
        self.dial.bind("<B1-Motion>", self._drag)
        self.edit = ttk.Spinbox(self, from_=1.0, to=8.0, increment=0.0625,
                                textvariable=self.value, width=6, justify="center")
        self.edit.pack()
        ttk.Label(self, text="× gain", style="CardMuted.TLabel").pack()
        ttk.Button(self, text="Apply", command=lambda: apply(channel, self)).pack(pady=(4, 6))
        self.value.trace_add("write", lambda *_: self._draw())
        self._draw()

    def _drag(self, event):
        angle = math.degrees(math.atan2(event.y - 41, event.x - 41))
        # Dial runs from lower-left (-225°) clockwise to lower-right (45°).
        angle = (angle + 225) % 360
        angle = min(angle, 270)
        self.value.set(round((1 + angle / 270 * 7) * 16) / 16)

    def _draw(self):
        try:
            value = min(8.0, max(1.0, float(self.value.get())))
        except (ValueError, tk.TclError):
            return
        d = self.dial
        d.delete("all")
        d.create_oval(8, 8, 74, 74, fill="#23334a", outline="#425871", width=2)
        d.create_arc(7, 7, 75, 75, start=225, extent=-270, style="arc",
                     outline="#425871", width=4)
        d.create_arc(7, 7, 75, 75, start=225, extent=-270 * (value - 1) / 7,
                     style="arc", outline=ACCENT, width=4)
        a = math.radians(135 + 270 * (value - 1) / 7)
        d.create_line(41, 41, 41 + 24 * math.cos(a), 41 + 24 * math.sin(a),
                      fill=WHITE, width=3, capstyle="round")
        d.create_oval(37, 37, 45, 45, fill=ACCENT, outline="")

    def raw(self):
        try:
            value = float(self.value.get())
        except (ValueError, tk.TclError) as exc:
            raise ValueError("Gain must be a number from 1.0 to 8.0") from exc
        if not math.isfinite(value) or not 1.0 <= value <= 8.0:
            raise ValueError("Gain must be between 1.0× and 8.0×")
        return round(value * 256)


class CameraStudio:
    def __init__(self, root, board, video_port, control_port):
        self.root = root
        self.events = queue.Queue()
        self.client = ControlClient(self.events)
        self.video = None
        self.ready = False
        self.ready_target = None
        self.photo = None
        self.board = tk.StringVar(value=board)
        self.control_port = tk.IntVar(value=control_port)
        self.video_port = tk.IntVar(value=video_port)
        self.header_status = tk.StringVar(value="Control: not checked")
        self.video_status = tk.StringVar(value="Receiver stopped")
        self.message = tk.StringVar(value="Start receiver, then press k + Enter on the KV260.")
        self.sensor_status = tk.StringVar(value="Sensor settings not read yet")
        self.hue = tk.IntVar(value=0)
        self.saturation = tk.DoubleVar(value=1.0)
        self.value = tk.DoubleVar(value=1.0)
        self.rotation = tk.StringVar(value="0°")
        self._style()
        self._build()
        self.root.protocol("WM_DELETE_WINDOW", self.close)
        self.root.after(40, self._tick)

    def _style(self):
        self.root.title("KV260 Camera Studio")
        self.root.configure(bg=BG)
        self.root.geometry("1500x900")
        self.root.minsize(1030, 680)
        style = ttk.Style(self.root)
        style.theme_use("clam")
        style.configure("TFrame", background=BG)
        style.configure("TLabel", background=BG, foreground=WHITE, font=("Segoe UI", 10))
        style.configure("Muted.TLabel", background=BG, foreground=MUTED, font=("Segoe UI", 9))
        style.configure("Title.TLabel", background=BG, foreground=WHITE, font=("Segoe UI", 19, "bold"))
        style.configure("Section.TLabel", background=BG, foreground=WHITE, font=("Segoe UI", 12, "bold"))
        style.configure("Card.TFrame", background=PANEL)
        style.configure("CardTitle.TLabel", background=PANEL, foreground=WHITE, font=("Segoe UI", 10, "bold"))
        style.configure("CardMuted.TLabel", background=PANEL, foreground=MUTED, font=("Segoe UI", 8))
        style.configure("TButton", font=("Segoe UI", 9), padding=(8, 5))
        style.configure("TNotebook", background=BG, borderwidth=0)
        style.configure("TNotebook.Tab", padding=(10, 8), font=("Segoe UI", 9, "bold"))
        style.map("TNotebook.Tab", background=[("selected", "#244257")], foreground=[("selected", WHITE)])

    @staticmethod
    def _note(parent, text, **kw):
        return ttk.Label(parent, text=text, style="Muted.TLabel", wraplength=405,
                         justify="left", **kw)

    def _build(self):
        outer = ttk.Frame(self.root, padding=14)
        outer.pack(fill="both", expand=True)
        heading = ttk.Frame(outer)
        heading.pack(fill="x", pady=(0, 10))
        ttk.Label(heading, text="KV260 CAMERA STUDIO", style="Title.TLabel").pack(side="left")
        ttk.Label(heading, text="IMX477  •  4K MJPEG  •  VFP", style="Muted.TLabel").pack(side="left", padx=16, pady=(7, 0))
        ttk.Label(heading, textvariable=self.header_status, style="Muted.TLabel").pack(side="right")

        connection = ttk.Frame(outer)
        connection.pack(fill="x", pady=(0, 10))
        ttk.Label(connection, text="Board IP").pack(side="left")
        ttk.Entry(connection, textvariable=self.board, width=15).pack(side="left", padx=(6, 12))
        ttk.Label(connection, text="Control port").pack(side="left")
        ttk.Entry(connection, textvariable=self.control_port, width=6).pack(side="left", padx=(6, 12))
        ttk.Button(connection, text="Check board", command=self.ping).pack(side="left", padx=(0, 10))
        ttk.Label(connection, text="Video port").pack(side="left")
        ttk.Entry(connection, textvariable=self.video_port, width=6).pack(side="left", padx=6)
        ttk.Button(connection, text="Start receiver", command=self.start_video).pack(side="left", padx=3)
        ttk.Button(connection, text="Stop receiver", command=self.stop_video).pack(side="left", padx=3)
        ttk.Button(connection, text="Start board stream", command=lambda: self.send("STREAM", 1)).pack(side="left", padx=(12, 3))
        ttk.Button(connection, text="Stop board stream", command=lambda: self.send("STREAM", 0)).pack(side="left")

        body = ttk.Frame(outer)
        body.pack(fill="both", expand=True)
        viewer = ttk.Frame(body)
        viewer.pack(side="left", fill="both", expand=True, padx=(0, 12))
        bar = ttk.Frame(viewer)
        bar.pack(fill="x", pady=(0, 6))
        ttk.Label(bar, text="LIVE PREVIEW", style="Section.TLabel").pack(side="left")
        ttk.Label(bar, textvariable=self.video_status, style="Muted.TLabel").pack(side="right")
        self.canvas = tk.Canvas(viewer, bg="#030711", highlightthickness=1,
                                highlightbackground="#34445a")
        self.canvas.pack(fill="both", expand=True)
        self.canvas.bind("<Configure>", lambda _e: self._update_preview_settings())
        self.canvas.create_text(400, 200, text="Waiting for video on UDP 8081",
                                fill=MUTED, tags="placeholder", font=("Segoe UI", 14))
        actions = ttk.Frame(viewer)
        actions.pack(fill="x", pady=(8, 0))
        ttk.Button(actions, text="Save received JPEG…", command=self.save_jpeg).pack(side="left")
        ttk.Label(actions, text="Rotation", style="Muted.TLabel").pack(side="left", padx=(16, 4))
        rot = ttk.Combobox(actions, state="readonly", width=6, textvariable=self.rotation,
                           values=("0°", "90°", "180°", "270°"))
        rot.pack(side="left")
        rot.bind("<<ComboboxSelected>>", lambda _e: self._update_preview_settings())
        self._note(actions, "Saved JPEG is the original received frame.").pack(side="left", padx=12)

        side = ttk.Frame(body, width=435)
        side.pack(side="right", fill="y")
        side.pack_propagate(False)
        notebook = ttk.Notebook(side)
        notebook.pack(fill="both", expand=True)
        camera = self._scroll_tab(notebook, "CAMERA")
        vfp = self._scroll_tab(notebook, "VFP")
        ccm = self._scroll_tab(notebook, "CCM")
        hsv = self._scroll_tab(notebook, "HSV")
        self._camera_tab(camera)
        self._vfp_tab(vfp)
        self._ccm_tab(ccm)
        self._hsv_tab(hsv)
        ttk.Label(outer, textvariable=self.message, style="Muted.TLabel", wraplength=1350).pack(fill="x", pady=(10, 0))

    @staticmethod
    def _scroll_tab(notebook, name):
        page = ttk.Frame(notebook)
        notebook.add(page, text=name)
        canvas = tk.Canvas(page, bg=BG, highlightthickness=0, borderwidth=0)
        scroll = ttk.Scrollbar(page, orient="vertical", command=canvas.yview)
        canvas.configure(yscrollcommand=scroll.set)
        scroll.pack(side="right", fill="y")
        canvas.pack(side="left", fill="both", expand=True)
        content = ttk.Frame(canvas, padding=12)
        window = canvas.create_window((0, 0), window=content, anchor="nw")
        content.bind("<Configure>", lambda _e: canvas.configure(scrollregion=canvas.bbox("all")))
        canvas.bind("<Configure>", lambda e: canvas.itemconfigure(window, width=e.width))
        canvas.bind("<MouseWheel>", lambda e: canvas.yview_scroll(-int(e.delta / 120), "units"))
        return content

    def _camera_tab(self, frame):
        ttk.Label(frame, text="IMX477 sensor", style="Section.TLabel").pack(anchor="w")
        self._note(frame, "Digital gain is per color channel. Turning a knob changes the editor only; press Apply to write the sensor.").pack(anchor="w", pady=(4, 10))
        knobs = ttk.Frame(frame)
        knobs.pack(fill="x")
        self.knobs = []
        for channel, name in enumerate(("Gr", "R", "B", "Gb")):
            knob = GainKnob(knobs, name, channel, self.apply_gain)
            knob.pack(side="left", expand=True, fill="x", padx=2)
            self.knobs.append(knob)
        ttk.Button(frame, text="Use per-channel gain", command=lambda: self.send("GMODE", 0)).pack(anchor="w", pady=(12, 3))
        self._note(frame, "A gain write is rejected while global gain mode is active. Read sensor status first.").pack(anchor="w")
        ttk.Separator(frame).pack(fill="x", pady=14)
        ttk.Label(frame, text="Exposure", style="Section.TLabel").pack(anchor="w")
        self.exposure = tk.StringVar(value="35% of usable frame lines")
        self.exposure_options = [f"{n}% of usable frame lines" for n in (5, 15, 35, 60, 90)]
        row = ttk.Frame(frame)
        row.pack(fill="x", pady=8)
        ttk.Combobox(row, state="readonly", textvariable=self.exposure,
                     values=self.exposure_options, width=27).pack(side="left")
        ttk.Button(row, text="Apply exposure", command=self.apply_exposure).pack(side="left", padx=8)
        self._note(frame, "Uses the sensor's existing SDR exposure presets. Sensor writes briefly enter standby and can interrupt video.").pack(anchor="w")
        ttk.Separator(frame).pack(fill="x", pady=14)
        ttk.Button(frame, text="Read sensor settings", command=lambda: self.send("SENSOR")).pack(anchor="w")
        ttk.Label(frame, textvariable=self.sensor_status, style="Muted.TLabel", wraplength=405,
                  justify="left").pack(anchor="w", pady=8)

    def _vfp_tab(self, frame):
        ttk.Label(frame, text="VFP output and color", style="Section.TLabel").pack(anchor="w")
        self._note(frame, "These controls write FPGA registers and can also change the board's monitor output. The selected video path determines which controls are visible.").pack(anchor="w", pady=(4, 10))
        ttk.Label(frame, text="Output path").pack(anchor="w")
        self.output = tk.StringVar(value=next(iter(OUTPUTS)))
        ttk.Combobox(frame, textvariable=self.output, values=list(OUTPUTS), state="readonly").pack(fill="x", pady=4)
        ttk.Button(frame, text="Apply output path", command=lambda: self.send("OUT", OUTPUTS[self.output.get()])).pack(anchor="w")
        ttk.Label(frame, text="RGB input selector").pack(anchor="w", pady=(10, 0))
        self.input_path = tk.StringVar(value=next(iter(INPUTS)))
        ttk.Combobox(frame, textvariable=self.input_path, values=list(INPUTS), state="readonly").pack(fill="x", pady=4)
        ttk.Button(frame, text="Apply RGB input", command=lambda: self.send("INPUT", INPUTS[self.input_path.get()])).pack(anchor="w")
        self._note(frame, "For the saturation module, choose input 3 and output 2. The hardware interprets the values below as raw register settings.").pack(anchor="w", pady=(10, 4))
        ttk.Separator(frame).pack(fill="x", pady=8)
        self.adjust_name = tk.StringVar(value=next(iter(ADJUST)))
        ttk.Combobox(frame, textvariable=self.adjust_name, values=list(ADJUST), state="readonly").pack(fill="x", pady=4)
        row = ttk.Frame(frame)
        row.pack(fill="x", pady=4)
        ttk.Label(row, text="Raw value").pack(side="left")
        self.adjust_value = tk.StringVar(value="1")
        ttk.Entry(row, textvariable=self.adjust_value, width=7).pack(side="left", padx=8)
        ttk.Button(row, text="Apply adjustment", command=self.apply_adjustment).pack(side="left")
        self.adjust_limits = tk.StringVar()
        ttk.Label(frame, textvariable=self.adjust_limits, style="Muted.TLabel").pack(anchor="w")
        self.adjust_name.trace_add("write", lambda *_: self._update_adjust_limits())
        self._update_adjust_limits()
        ttk.Separator(frame).pack(fill="x", pady=8)
        row = ttk.Frame(frame)
        row.pack(fill="x", pady=3)
        ttk.Label(row, text="Cluster LUT").pack(side="left")
        self.lut = tk.StringVar(value="5")
        ttk.Spinbox(row, from_=0, to=9, textvariable=self.lut, width=5).pack(side="left", padx=6)
        ttk.Button(row, text="Apply LUT", command=self.apply_lut).pack(side="left")
        row = ttk.Frame(frame)
        row.pack(fill="x", pady=3)
        ttk.Label(row, text="Sobel / pattern").pack(side="left")
        self.threshold = tk.StringVar(value="100")
        ttk.Entry(row, textvariable=self.threshold, width=7).pack(side="left", padx=6)
        ttk.Button(row, text="Apply shared register", command=self.apply_threshold).pack(side="left")
        self._note(frame, "Shared register: Sobel threshold 0–65535; test-pattern choices 0–21.").pack(anchor="w", pady=(4, 0))

    def _ccm_tab(self, frame):
        ttk.Label(frame, text="Color correction matrix", style="Section.TLabel").pack(anchor="w")
        self._note(frame, "Choose a block, apply its matrix, then select its video path below. The default bypass does not show CCM changes.").pack(anchor="w", pady=(4, 10))
        self.ccm_bank = tk.StringVar(value="Dark • RGB path")
        self.ccm_banks = {"Dark • RGB path": 0, "Light • HSV path": 1, "Balance • YCbCr path": 2}
        ttk.Combobox(frame, textvariable=self.ccm_bank, values=list(self.ccm_banks), state="readonly").pack(fill="x", pady=4)
        self.ccm_path_hint = tk.StringVar()
        self._note(frame, "Select camera input 0, then show this CCM to view the result. Path changes affect the board's video output.").pack(anchor="w", pady=(4, 3))
        ttk.Label(frame, textvariable=self.ccm_path_hint, style="Muted.TLabel", wraplength=405).pack(anchor="w")
        self.ccm_bank.trace_add("write", lambda *_: self._update_ccm_path_hint())
        self._update_ccm_path_hint()
        row = ttk.Frame(frame)
        row.pack(anchor="w", pady=5)
        ttk.Button(row, text="Use camera input", command=lambda: self.send("INPUT", 0)).pack(side="left")
        ttk.Button(row, text="Show this CCM", command=self.show_ccm_path).pack(side="left", padx=6)
        ttk.Button(row, text="Show bypass", command=lambda: self.send("OUT", 0)).pack(side="left")
        matrix = ttk.Frame(frame)
        matrix.pack(pady=12)
        self.matrix = []
        for i in range(9):
            v = tk.StringVar(value="1.000" if i in (0, 4, 8) else "0.000")
            ttk.Entry(matrix, textvariable=v, width=9, justify="center").grid(row=i // 3, column=i % 3, padx=5, pady=5)
            self.matrix.append(v)
        row = ttk.Frame(frame)
        row.pack(anchor="w", pady=5)
        ttk.Button(row, text="Apply matrix", command=self.apply_ccm).pack(side="left")
        ttk.Button(row, text="Edit identity", command=self.edit_identity).pack(side="left", padx=8)
        self._note(frame, "Apply writes coefficients in 1/1024 units and selects custom mode 15. Diagonal values are nonnegative; off-diagonal values are signed. Writes are sequential.").pack(anchor="w", pady=8)
        ttk.Separator(frame).pack(fill="x", pady=14)
        ttk.Label(frame, text="Built-in CCM preset").pack(anchor="w")
        row = ttk.Frame(frame)
        row.pack(anchor="w", pady=8)
        self.preset = tk.StringVar(value="3")
        ttk.Spinbox(row, from_=0, to=7, textvariable=self.preset, width=5).pack(side="left")
        ttk.Button(row, text="Apply preset", command=self.apply_preset).pack(side="left", padx=8)
        self._note(frame, "Preset values come from the VFP design. Hardware writes are acknowledged, but visual effect depends on the selected path.").pack(anchor="w")

    def _hsv_tab(self, frame):
        ttk.Label(frame, text="HSV • VFP hardware", style="Section.TLabel").pack(anchor="w")
        self._note(frame, "Applies saturation and value gains through the Light CCM on the HSV path. Select VFP output 22 to view it. This replaces the Light CCM custom matrix.").pack(anchor="w", pady=(4, 8))
        self.hw_saturation = tk.StringVar(value="1.00")
        self.hw_value = tk.StringVar(value="1.00")
        row = ttk.Frame(frame)
        row.pack(fill="x", pady=4)
        ttk.Label(row, text="Saturation ×").pack(side="left")
        ttk.Spinbox(row, from_=0, to=2, increment=0.05, textvariable=self.hw_saturation, width=6).pack(side="left", padx=6)
        ttk.Label(row, text="Value ×").pack(side="left", padx=(8, 0))
        ttk.Spinbox(row, from_=0, to=2, increment=0.05, textvariable=self.hw_value, width=6).pack(side="left", padx=6)
        ttk.Button(frame, text="Apply VFP HSV gains", command=self.apply_hardware_hsv).pack(anchor="w", pady=4)
        self._note(frame, "The current VFP has no direct hue-offset register. Hardware effect is unverified until tested on your bitstream.").pack(anchor="w", pady=(4, 5))
        ttk.Separator(frame).pack(fill="x", pady=8)
        ttk.Label(frame, text="HSV • Windows preview only", style="Section.TLabel").pack(anchor="w")
        self._note(frame, "The sliders below affect only this PC window, not the FPGA, monitor, or saved original JPEG.").pack(anchor="w", pady=(4, 4))
        for name, var, lower, upper, resolution in (
                ("Hue shift (degrees)", self.hue, -180, 180, 1),
                ("Saturation multiplier", self.saturation, 0, 2, 0.05),
                ("Value multiplier", self.value, 0, 2, 0.05)):
            ttk.Label(frame, text=name).pack(anchor="w", pady=(8, 0))
            scale = tk.Scale(frame, variable=var, from_=lower, to=upper, resolution=resolution,
                             orient="horizontal", bg=BG, fg=WHITE, troughcolor="#314158",
                             highlightthickness=0, activebackground=ACCENT,
                             command=lambda _v: self._update_preview_settings())
            scale.pack(fill="x")
        ttk.Button(frame, text="Reset preview HSV", command=self.reset_hsv).pack(anchor="w", pady=8)

    def apply_hardware_hsv(self):
        try:
            saturation = float(self.hw_saturation.get())
            value = float(self.hw_value.get())
            if not all(math.isfinite(x) and 0.0 <= x <= 2.0 for x in (saturation, value)):
                raise ValueError("VFP HSV gains must be between 0.0 and 2.0")
            self.send("CCM", 1, 1024, 0, 0, 0, round(saturation * 1024),
                      0, 0, 0, round(value * 1024))
        except ValueError as exc:
            self.message.set(str(exc))

    def _update_adjust_limits(self):
        _, low, high = ADJUST[self.adjust_name.get()]
        self.adjust_limits.set(f"Allowed raw value: {low}–{high}")

    def _network_values(self):
        host = self.board.get().strip()
        ipaddress.IPv4Address(host)
        port = int(self.control_port.get())
        if not 1 <= port <= 65535:
            raise ValueError("Control port must be 1–65535")
        return host, port

    def ping(self):
        self.ready = False
        self.ready_target = None
        self.send("PING", require_ready=False)

    def send(self, operation, *values, require_ready=True):
        try:
            host, port = self._network_values()
            if require_ready and (not self.ready or self.ready_target != (host, port)):
                self.message.set("Check this board and port first. Initialize its network from the UART menu.")
                return
            self.client.send(host, port, operation, *values)
            self.message.set(f"Waiting for board: {operation}…")
        except (ValueError, tk.TclError) as exc:
            self.message.set(str(exc))

    def apply_gain(self, channel, knob):
        try:
            self.send("GAIN", channel, knob.raw())
        except ValueError as exc:
            self.message.set(str(exc))

    def apply_exposure(self):
        self.send("EXPO", self.exposure_options.index(self.exposure.get()))

    @staticmethod
    def integer(value, lo, hi):
        try:
            parsed = int(value, 10)
        except ValueError as exc:
            raise ValueError(f"Enter an integer from {lo} to {hi}") from exc
        if not lo <= parsed <= hi:
            raise ValueError(f"Enter an integer from {lo} to {hi}")
        return parsed

    def apply_adjustment(self):
        selector, lo, hi = ADJUST[self.adjust_name.get()]
        try:
            self.send("ADJ", selector, self.integer(self.adjust_value.get(), lo, hi))
        except ValueError as exc:
            self.message.set(str(exc))

    def apply_lut(self):
        try:
            value = self.integer(self.lut.get(), 0, 9)
            if value == 8:
                raise ValueError("Choose LUT 0–7 or 9")
            self.send("LUT", value)
        except ValueError as exc:
            self.message.set(str(exc))

    def apply_threshold(self):
        try:
            self.send("THRESH", self.integer(self.threshold.get(), 0, 65535))
        except ValueError as exc:
            self.message.set(str(exc))

    def apply_preset(self):
        try:
            self.send("PRESET", self.ccm_banks[self.ccm_bank.get()], self.integer(self.preset.get(), 0, 7))
        except ValueError as exc:
            self.message.set(str(exc))

    def _update_ccm_path_hint(self):
        bank = self.ccm_banks[self.ccm_bank.get()]
        detail = {
            0: "Dark: output 6 (RGB after the HSV path).",
            1: "Light: output 22 (HSV converted back to RGB).",
            2: "Balance: output 18 (requires the updated board control firmware).",
        }[bank]
        self.ccm_path_hint.set(detail)

    def show_ccm_path(self):
        bank = self.ccm_banks[self.ccm_bank.get()]
        self.send("OUT", (6, 22, 18)[bank])

    def edit_identity(self):
        for i, var in enumerate(self.matrix):
            var.set("1.000" if i in (0, 4, 8) else "0.000")
        self.message.set("Identity loaded in editor; press Apply matrix to send.")

    def apply_ccm(self):
        try:
            values = []
            for i, variable in enumerate(self.matrix):
                v = float(variable.get())
                lo, hi = (0.0, 4.0) if i in (0, 4, 8) else (-2.0, 2.0)
                if not math.isfinite(v) or not lo <= v <= hi:
                    raise ValueError(f"Coefficient {i+1}: allowed range {lo} to {hi}")
                values.append(round(v * 1024))
            self.send("CCM", self.ccm_banks[self.ccm_bank.get()], *values)
        except ValueError as exc:
            self.message.set(f"Invalid matrix: {exc}")

    def reset_hsv(self):
        self.hue.set(0)
        self.saturation.set(1.0)
        self.value.set(1.0)
        self._update_preview_settings()

    def _update_preview_settings(self):
        if self.video:
            width = max(64, min(1920, self.canvas.winfo_width() - 8))
            height = max(64, min(1080, self.canvas.winfo_height() - 8))
            try:
                self.video.set_preview((width, height),
                    (self.hue.get(), self.saturation.get(), self.value.get()),
                    int(self.rotation.get().replace("°", "")))
            except (tk.TclError, ValueError):
                pass

    def start_video(self):
        if self.video is not None:
            self.message.set("Receiver is already running")
            return
        try:
            host = str(ipaddress.IPv4Address(self.board.get().strip()))
            port = int(self.video_port.get())
            if not 1 <= port <= 65535:
                raise ValueError("Video port must be 1–65535")
            engine = VideoEngine(self.events, host, port)
            engine.start()
            self.video = engine
            self._update_preview_settings()
            self.message.set(f"Listening on UDP {port} for {host}. Press k + Enter on the KV260 to initialize streaming.")
        except (ValueError, OSError, tk.TclError) as exc:
            self.message.set(f"Receiver could not start: {exc}")

    def stop_video(self):
        if self.video:
            self.video.close()
            self.video = None
            self.video_status.set("Receiver stopped")
            self.message.set("Receiver stopped on this PC; the board stream may still be running.")

    def save_jpeg(self):
        if not self.video:
            self.message.set("Start the receiver and wait for a frame first")
            return
        with self.video.lock:
            data, frame_id = self.video.last_jpeg, self.video.last_id
        if data is None:
            self.message.set("No complete JPEG received yet")
            return
        path = filedialog.asksaveasfilename(title="Save original received JPEG", defaultextension=".jpg",
                 initialfile=f"kv260_frame_{frame_id}.jpg", filetypes=[("JPEG image", "*.jpg")])
        if path:
            try:
                with open(path, "wb") as output:
                    output.write(data)
                self.message.set(f"Saved original frame {frame_id}: {path}")
            except OSError as exc:
                self.message.set(f"Could not save JPEG: {exc}")

    def _sensor_reply(self, values):
        if len(values) != 10:
            self.message.set("Board returned an incomplete sensor status")
            return
        try:
            exposure, frame, analog, dol, shift, mode, gr, red, blue, gb = map(int, values)
        except ValueError:
            self.message.set("Board returned invalid sensor values")
            return
        self.sensor_status.set(
            f"Exposure {exposure} lines / {frame} frame lines  •  analog code {analog}\n"
            f"DOL {dol}  •  long-exposure shift {shift}  •  {'GLOBAL (uses Gr)' if mode & 1 else 'per-channel'}\n"
            f"Gr {gr/256:.3f}×  R {red/256:.3f}×  B {blue/256:.3f}×  Gb {gb/256:.3f}×")
        for knob, raw in zip(self.knobs, (gr, red, blue, gb)):
            if 256 <= raw <= 2048:
                knob.value.set(raw / 256)
        self.message.set("Sensor status read from the board. Values outside 1–8× are displayed above but not loaded into the knobs.")

    def _tick(self):
        try:
            while True:
                event = self.events.get_nowait()
                if event[0] == "control_error":
                    self.ready = False
                    self.ready_target = None
                    self.header_status.set("Control: no reply")
                    self.message.set(f"{event[1]}: {event[2]}")
                elif event[0] == "control":
                    operation, values = event[1], event[2]
                    if values[0] == "OK":
                        if operation == "PING" and values[1:] == ["PONG", "1"]:
                            self.ready = True
                            self.ready_target = event[3]
                            self.header_status.set(f"Control: connected to {event[3][0]}")
                            self.message.set("Board control v1 is responding. Click Read sensor settings.")
                        elif operation == "SENSOR" and len(values) >= 2 and values[1] == "SENSOR":
                            self._sensor_reply(values[2:])
                        elif len(values) >= 2 and values[1] == "VFP_WRITTEN":
                            if operation == "OUT" and event[4]:
                                output = event[4][0]
                                name = next((name for name, number in OUTPUTS.items() if number == output), None)
                                if name is not None:
                                    self.output.set(name)
                                self.message.set(f"Requested VFP output {output}. Check the picture; hardware readback was not verified.")
                            else:
                                self.message.set("VFP register write issued. Visual effect depends on the active path; no hardware readback was verified.")
                        elif operation == "STREAM":
                            self.message.set("Board accepted the stream command. Video reception depends on the configured destination and receiver.")
                        else:
                            self.message.set(f"Board accepted {operation}. Read sensor settings to refresh the display.")
                    else:
                        reason = " ".join(values[1:])
                        reason = {
                            "GLOBAL_MODE": "Set per-channel gain mode first.",
                            "HDR_ACTIVE": "This sensor operation is available in SDR mode.",
                            "SENSOR_IO": "Sensor identification, I2C, timing, or readback failed; check the UART log.",
                            "SENSOR_RANGE": "The requested sensor setting is outside the supported timing range.",
                            "PIPELINE_BUSY": "The board JPEG pipeline is busy; wait and retry.",
                            "BUSY": "The board is processing another command; wait and retry.",
                        }.get(reason, reason)
                        if operation == "OUT" and event[4] == (18,) and reason == "FORMAT":
                            reason = "Output 18 needs the updated gui_control.c on the board."
                        self.message.set(f"Board rejected {operation}: {reason}")
                elif event[0] in ("video_error", "decode_error"):
                    self.message.set(f"{event[0]}: {event[1]}")
        except queue.Empty:
            pass
        if self.video:
            try:
                _id, picture = self.video.rendered.get_nowait()
                self.photo = ImageTk.PhotoImage(picture)
                self.canvas.delete("all")
                self.canvas.create_image(self.canvas.winfo_width() // 2,
                                         self.canvas.winfo_height() // 2,
                                         image=self.photo, anchor="center")
            except queue.Empty:
                pass
            s = self.video.snapshot()
            dims = f"{s['dimensions'][0]}×{s['dimensions'][1]}" if s['dimensions'] else "waiting"
            self.video_status.set(f"{dims}  |  {s['fps']:.1f} fps received  |  incomplete {s['incomplete']}  |  preview skipped {s['preview_skips']}")
        self.root.after(40, self._tick)

    def close(self):
        self.client.close()
        if self.video:
            self.video.close()
        self.root.destroy()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--board", default="192.168.0.10")
    parser.add_argument("--video-port", type=int, default=8081)
    parser.add_argument("--control-port", type=int, default=8082)
    args = parser.parse_args()
    root = tk.Tk()
    CameraStudio(root, args.board, args.video_port, args.control_port)
    root.mainloop()


if __name__ == "__main__":
    main()
