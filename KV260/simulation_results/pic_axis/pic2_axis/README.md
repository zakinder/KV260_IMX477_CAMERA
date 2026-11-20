# PIC2-style camera filter in VHDL-2008

The VHDL testbench opens the supplied **images/PIC1.JPG** directly, decodes its 2048 × 1152 JPEG raster and sends the RGB pixels through **pic2_filter_axis**. On accepted output transfers it writes **results/PIC1_filtered.bmp**. The PNG in the same folder is a lossless copy of that BMP. Open **results/PIC1_RTL_PIC2_Comparison.png** to see the input, RTL result and reference together.

The design approximates the reference's brightened surfaces, smoother skin and structural edges. All output color comes from the input neighborhoods. PIC2 is used only for the visual and luminance comparison. There is no palette, skin detector, position-specific processing or reference-image input in the design.

## Re-run in Questa on Windows

From the extracted **pic2_axis** directory, open Windows CMD and run:

```cmd
vsim -c -do sim/run_questa.do
```

If Questa is installed in the usual project location and is absent from PATH, run:

```cmd
"C:\questasim64_2024.1\win64\vsim.exe" -c -do sim/run_questa.do
```

The script compiles the ordered sources in **sim/sources.txt**, runs **work.tb_pic2** with randomized stalls, and checks its completion flag. The expected output is **results/PIC1_filtered.bmp**. This flow needs no Make, DLL, JPEG preprocessing, or Python. GHDL was used for the recorded simulations. The Questa command is supplied for reproduction.

## Re-run with GHDL

From the same directory:

```sh
python sim/run_ghdl.py --stalls --decoded-bmp results/decoded.bmp
```

GHDL and Python 3 are required for this launcher. It reads the width and height from the JPEG header and passes them as DUT generics. All entropy decoding, IDCT, color conversion and filtering still execute in VHDL. Substitute a different 8-bit baseline JPEG as the first argument to the launcher. The bundled reader supports single-scan grayscale and YCbCr (including 4:4:4, 4:2:2 and 4:2:0), centers subsampled chroma, and ignores metadata including ICC/EXIF. Progressive and CMYK inputs require conversion to baseline RGB/JFIF for this testbench.

For an independent byte-by-byte check, install NumPy and Pillow in the Python environment and run:

```sh
python tools/check_pixels.py results/decoded.bmp results/PIC1_filtered.bmp --jpeg images/PIC1.JPG
python tools/check_two_frames.py
```

The first command evaluates the expected filter using raster coordinates and compares every output pixel. The second generates two different odd-sized JPEGs and drives them consecutively, with source gaps and sink backpressure. It checks both output frames, boundary handling, grayscale neutrality and whether previous-frame state affects the second frame.

## RTL signal path

| Module | Operation |
|---|---|
| **pic2_filter_axis** | AXI4-Stream Video top level. Chains three surface passes, the tone/contour stage and the final smoothing stage. |
| **axis_window5** | Centered 5 × 5 window with programmable sample spacing, synchronous column-addressed line memories and edge replication on all four borders. Used by each processing stage. |
| **axis_surface_pass** | Four overlapping 3 × 3 regions compete using luminance range and RGB distance from the center. Similar regions are averaged, and a high-contrast isolated center retains extra weight. The three passes have sample spacings of 1, 3 and 6 pixels. |
| **axis_tone_contour** | Lifts the dim camera image with a one-dimensional luminance curve. Gentle luminance quantization simplifies shading. A Sobel measure and four opposing pixel pairs distinguish dark strokes and bright ridges. The opposing pairs keep the center of narrow strokes visible even where the local gradient cancels. |
| **axis_contour_finish** | A dense 5 × 5 binomial average softens jagged contour transitions. Neighbors across strong color differences have less influence. |
| **pic2_types** | Packed RGB data types and bounded arithmetic shared by the datapath. |

The renderer applies one common chroma gain to all three channels and adds one common brightness offset. This preserves channel ordering, subject to integer rounding. Gray neighborhoods remain gray. **G_CHROMA_Q8 = 384** allows up to 1.5× chroma separation. Set it to **256** for unity chroma gain. Local surface averaging can still blend nearby colors. The fixed brightness curve was tuned for the supplied dark exposure and will have a different effect on a scene that is already bright.

## Streaming interface and KV260 placement

| Signal or setting | Meaning |
|---|---|
| **s_axis_tdata, m_axis_tdata** | RGB888, R in bits 23–16, G in 15–8, B in 7–0. One pixel per accepted transfer. |
| **TVALID / TREADY** | A transfer occurs on a rising clock edge when both are high. Each stage holds its output data, SOF and EOL stable under backpressure. |
| **TUSER** | High for the first pixel of a frame. |
| **TLAST** | High for the last pixel of each line. |
| **aresetn** | Synchronous active-low reset. Begin with a full frame and SOF after reset. |
| **G_WIDTH, G_HEIGHT** | Actual active input dimensions, fixed at elaboration. The full border is emitted at the output. |

For the bare-metal UDP path, insert the top level after demosaic on the RGB branch feeding the capture VDMA used by the JPEG encoder. Feed the filtered frame buffer to the existing encoder and UDP sender. At an RGB10 boundary, adapt component widths and verify lane order against the existing VFP interface. The testbench JPEG reader and BMP writer are simulation-only. Include only **rtl/** in the hardware design.

Each window accepts one interior pixel per enabled clock. It takes extra clock cycles to replicate the right edge and flush the last rows, and it can deassert **s_axis_tready**. Size the upstream buffering and clock margin for the actual camera traffic. With the default spacings (1, 3, 6, 6, 1), column histories store 68 lines of RGB888, or 408 KiB at width 2048 and 765 KiB at width 3840, before memory packing and horizontal taps. The shorter spacings are tunable with **G_MEDIUM_STEP**, **G_COARSE_STEP** and **G_CONTOUR_STEP**. Timing, device utilization and sustained UDP frame rate require a Vivado build and board measurements.

## Recorded verification

| Check | Result |
|---|---|
| GHDL 5.0.1, full PIC1 JPEG | 2,359,296 accepted output pixels, 1,152 EOL markers and one SOF. |
| Full frame with pseudo-random stalls | Passed data/sideband stability checks over 1,010,373 stalled output cycles. |
| Full frame with continuous source and ready sink | The complete BMP was byte-identical to the stalled run. |
| Independent spatial reference | All 2,359,296 RGB pixels matched the RTL output exactly. |
| JPEG reader versus Pillow/libjpeg | Mean absolute channel error 0.04207 and maximum 3 on an 8-bit scale, including IDCT and upsampling differences. |
| Different back-to-back frames | Both 43 × 27 outputs matched the reference model, including borders. All 1,161 grayscale pixels remained neutral. |
| Synthesis front end | GHDL generated a synthesizable RTL netlist and inferred the column memories. Vivado timing and live KV260/UDP playback remain unverified. |

At the 1280 × 720 reference dimensions, the mean absolute luma difference from PIC2 was **50.054** for the camera input and **4.664** for the RTL output (8-bit scale). This measures brightness on the image used for tuning. The comparison image also shows the remaining differences in hue and surface detail. The original BMP, logs, hashes and measurement details are under **results/**.
