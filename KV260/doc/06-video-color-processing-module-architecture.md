# Chapter 6 — Video Color Processing Module Architecture

## 6.1 Overview of the Video Color Processing Module

The **Video Color Processing (VCP) module** is the central processing block in the FPGA video pipeline. It receives an RGB video stream, applies selected image-processing functions, and outputs a modified video stream for display, memory transfer, or Ethernet streaming.

The VCP module is positioned after camera capture and demosaic conversion. This placement allows the module to operate on complete RGB pixel data instead of raw Bayer-pattern sensor data. In the system architecture, the VCP module applies filters, color-space conversion, K-means color clustering, and image-enhancement controls such as contrast, brightness, saturation, white balance, black balance, and RGB gain through AXI4-Lite configuration registers.

The VCP module supports a modular architecture. Each processing function is organized as a selectable hardware block, allowing the system to enable, bypass, or configure specific video operations depending on the selected design mode.

## 6.2 Purpose of the VCP Module

The purpose of the VCP module is to provide a hardware-accelerated image-processing layer for real-time video streams. Instead of sending every pixel to software for processing, the FPGA fabric performs the pixel operations directly in the streaming datapath.

The VCP module provides the following capabilities:

| **Capability**         | **Description**                                                                       |
|------------------------|---------------------------------------------------------------------------------------|
| Pixel transformation   | Modifies each input pixel and produces a processed output pixel.                      |
| Spatial filtering      | Uses neighboring pixels to perform blur, sharp, emboss, or edge-detection operations. |
| Color-space conversion | Converts RGB pixels into alternate color representations.                             |
| Image enhancement      | Adjusts brightness, contrast, saturation, gain, white balance, and black balance.     |
| Color correction       | Applies matrix-based correction to improve output color accuracy.                     |
| Color clustering       | Classifies pixels using K-means color-clustering logic.                               |
| Programmable control   | Uses AXI4-Lite registers for runtime configuration and status readback.               |

The design document describes the VCP module as a block that receives an input video pixel stream, performs computation or adds new content through filters, and outputs the processed pixel stream. It also identifies the module as either a pixel transformation block or a pixel generation block.

## 6.3 VCP Placement in the Video Pipeline

The VCP module is placed between the RGB generation stage and the output routing stage.

Camera Sensor

↓

MIPI CSI-2 Receiver

↓

RAW10 Capture

↓

Demosaic

↓

RGB Video Stream

↓

Video Color Processing Module

↓

DisplayPort / Ethernet / VDMA Output

This placement provides two major advantages:

1.  **The input stream contains full RGB pixels.**  
    This allows the VCP module to perform RGB gain, color correction, color-space conversion, and K-means clustering using complete color vectors.

2.  **The output stream remains compatible with standard video-output paths.**  
    After processing, the output can be routed to DisplayPort, Ethernet streaming, or memory-backed video movement.

## 6.4 VCP Interface Architecture

The VCP module uses separate datapath and control interfaces. The datapath carries high-speed video pixels, while the control interface carries low-speed configuration and status information.

### 6.4.1 AXI4-Stream Video Input Interface

The AXI4-Stream input interface receives RGB pixel data from the upstream demosaic or preprocessing stage.

Typical input signals include:

| **Signal**          | **Purpose**                                   |
|---------------------|-----------------------------------------------|
| s_axis_video_tdata  | Input pixel data.                             |
| s_axis_video_tvalid | Indicates valid input pixel data.             |
| s_axis_video_tready | Indicates VCP readiness to accept input data. |
| s_axis_video_tlast  | Marks the end of a video line.                |
| s_axis_video_tuser  | Marks the start of a video frame.             |
| aclk                | Video stream clock.                           |
| aresetn             | Active-low reset.                             |

The VCP input interface must preserve frame and line alignment. Incorrect handling of TUSER or TLAST can cause downstream display corruption, shifted images, or invalid frame boundaries.

### 6.4.2 AXI4-Stream Video Output Interface

The AXI4-Stream output interface sends the processed pixel stream to downstream blocks.

Typical output signals include:

| **Signal**          | **Purpose**                                      |
|---------------------|--------------------------------------------------|
| m_axis_video_tdata  | Processed output pixel data.                     |
| m_axis_video_tvalid | Indicates valid processed output data.           |
| m_axis_video_tready | Indicates downstream readiness.                  |
| m_axis_video_tlast  | Propagated or regenerated end-of-line marker.    |
| m_axis_video_tuser  | Propagated or regenerated start-of-frame marker. |

The output stream must remain protocol-compliant even when different processing modes are selected.

### 6.4.3 AXI4-Lite Control Interface

The AXI4-Lite interface provides software control over the VCP module. It allows the processing system to configure image-processing modes and read status information.

Typical AXI4-Lite register functions include:

- VCP enable and bypass control.

- Processing-mode selection.

- Filter enable control.

- Color-space conversion selection.

- Brightness control.

- Contrast control.

- Saturation control.

- RGB gain control.

- White-balance and black-balance control.

- Threshold configuration.

- K-means clustering parameter selection.

- Diagnostic status readback.

The source document states that the VCP module contains control registers and local small buffers used to support video-stream processing.

## 6.5 Internal VCP Block Architecture

The internal VCP architecture can be organized as a set of selectable processing blocks connected to a common stream-control structure.

AXI4-Stream Input

↓

Input Register Stage

↓

Pixel Unpack / Channel Split

↓

Processing Mode Selector

↓

Selected Processing Block

↓

Output Clamp / Normalize

↓

Pixel Pack

↓

AXI4-Stream Output

The major internal blocks include:

| **Block**              | **Function**                                                   |
|------------------------|----------------------------------------------------------------|
| Input register stage   | Captures incoming pixel data and sideband signals.             |
| Pixel unpacker         | Separates RGB channels from the input stream word.             |
| Mode selector          | Selects active processing function.                            |
| Enhancement block      | Applies brightness, contrast, saturation, and gain adjustment. |
| Filter block           | Performs spatial filtering using local pixel neighborhoods.    |
| Color-conversion block | Converts RGB data into selected color-space formats.           |
| K-means block          | Performs color clustering and output mapping.                  |
| Output limiter         | Clamps or normalizes computed values into valid channel range. |
| Pixel packer           | Recombines processed channels into output stream format.       |
| Sideband aligner       | Delays TUSER, TLAST, and valid signals to match pixel latency. |

## 6.6 Streaming Processing Model

The VCP module is designed as a streaming datapath. Pixels flow continuously through the module rather than being processed one full frame at a time.

In the preferred operating mode, the VCP module accepts one pixel per clock cycle after pipeline initialization:

Clock N: Pixel 0 enters stage 1

Clock N+1: Pixel 1 enters stage 1, Pixel 0 enters stage 2

Clock N+2: Pixel 2 enters stage 1, Pixel 1 enters stage 2, Pixel 0 enters stage 3

This streaming model provides:

- Low latency compared with full-frame software processing.

- Predictable pipeline timing.

- Efficient use of FPGA registers and arithmetic resources.

- Compatibility with AXI4-Stream video.

- Continuous real-time operation.

## 6.7 Pixel Transformation Mode

In pixel transformation mode, the VCP module produces one output pixel for each input pixel. The operation modifies the color or intensity of the current pixel without necessarily generating new image structure.

Examples of pixel transformation functions include:

- RGB gain adjustment.

- Brightness adjustment.

- Contrast adjustment.

- Saturation adjustment.

- White-balance correction.

- Black-balance correction.

- Color correction matrix.

- RGB-to-HSL conversion.

- HSL-to-RGB conversion.

- RGB-to-YCbCr conversion.

- RGB-to-CMYK conversion.

- RGB-to-YDbDr conversion.

- RGB-to-CIE XYZ conversion.

- RGB-to-CIE YUV conversion.

- RGB-to-YIQ conversion.

- RGB-to-YPbPr conversion.

- RGB-to-LMS conversion.

- RGB-to-ICtCp conversion.

- RGB-to-HED conversion.

- RGB-to-YC1C2 conversion.

A pixel transformation block generally follows this pattern:

Input RGB Pixel → Arithmetic Operation → Output RGB or Converted Pixel

## 6.8 Pixel Generation Mode

In pixel generation mode, the VCP module may produce output content that is not a simple direct mathematical conversion of the current input pixel. The output may be generated from a filter kernel, test pattern, segmentation map, cluster label, or symbolic color-mapping logic.

Examples include:

- Test-pattern generation.

- Sobel edge map generation.

- Embossed image generation.

- K-means cluster-color output.

- Threshold segmentation output.

- Programmable palette output.

Pixel generation may use:

- Current pixel value.

- Neighboring pixel values.

- Pixel coordinates.

- Local buffers.

- User-defined thresholds.

- Palette or LUT entries.

- Cluster centroid values.

This mode is useful when the VCP module is used not only to enhance an image but also to create a classified or interpreted output image.

## 6.9 Local Buffer Architecture

Some VCP functions require access to neighboring pixels. These functions cannot be implemented using only the current pixel value. For example, blur, sharp, emboss, and Sobel edge detection use spatial kernels that operate over a local pixel window.

To support these operations, the VCP module uses local line buffers.

The source document states that the VCP module maintains local small buffers to store video frame lines.

### 6.9.1 Line Buffer Purpose

Line buffers allow the module to access pixels from previous image rows while processing the current row.

A typical 3×3 filter kernel requires:

Previous Line: P(x-1,y-1) P(x,y-1) P(x+1,y-1)

Current Line: P(x-1,y) P(x,y) P(x+1,y)

Next Line: P(x-1,y+1) P(x,y+1) P(x+1,y+1)

Because the stream arrives in raster order, previous lines must be stored so that the kernel window can be assembled.

### 6.9.2 Buffer Implementation Options

Line buffers may be implemented using:

| **Resource**    | **Use Case**                                    |
|-----------------|-------------------------------------------------|
| Shift registers | Short delay chains and small windows.           |
| LUTRAM          | Small local buffers.                            |
| BRAM            | Full-line storage for higher resolutions.       |
| URAM            | Large buffers for very high-resolution designs. |
| FIFO structures | Stream alignment and clock-domain crossing.     |

The selected implementation depends on image width, pixel format, filter size, and target FPGA resource availability.

## 6.10 Processing Mode Selection

The VCP module supports multiple processing functions. A mode-selection register determines which function is active.

A typical mode map may be structured as:

| **Mode Value** | **Processing Function**      |
|----------------|------------------------------|
| 0              | Bypass                       |
| 1              | RGB gain / image enhancement |
| 2              | Color correction matrix      |
| 3              | RGB to HSL                   |
| 4              | HSL to RGB                   |
| 5              | RGB to YCbCr                 |
| 6              | Sharp filter                 |
| 7              | Blur filter                  |
| 8              | Emboss filter                |
| 9              | Sobel edge detection         |
| 10             | K-means color clustering     |
| 11             | Programmable color scheme    |
| 12             | Threshold segmentation       |
| 13             | Test pattern                 |

The exact register values may be customized in the implementation. The important architectural requirement is that mode selection must be deterministic and must not corrupt active frame timing.

## 6.11 Bypass Mode

Bypass mode forwards the input stream directly to the output stream without modifying the pixel values.

Bypass mode is useful for:

- Baseline camera validation.

- Debugging downstream output interfaces.

- Comparing processed and unprocessed images.

- Measuring VCP latency.

- Confirming AXI4-Stream signal integrity.

The bypass datapath must still preserve:

- TDATA

- TVALID

- TREADY

- TLAST

- TUSER

Bypass mode should be available even when advanced processing blocks are disabled or under debug.

## 6.12 Image Enhancement Block

The image enhancement block adjusts basic image characteristics using programmable parameters.

Supported enhancement operations include:

| **Operation**      | **Purpose**                                                |
|--------------------|------------------------------------------------------------|
| Brightness control | Adds or subtracts an offset from pixel intensity.          |
| Contrast control   | Scales the difference between pixel value and midpoint.    |
| Saturation control | Adjusts color intensity relative to luminance.             |
| RGB gain control   | Applies independent gain to red, green, and blue channels. |
| White balance      | Compensates for lighting color temperature.                |
| Black balance      | Adjusts low-level channel offsets.                         |

The source document identifies contrast, brightness, saturation, white/black balance, and RGB gain as image-enhancement controls applied through AXI4-Lite configuration registers.

A simplified RGB gain operation can be represented as:

Rout = clamp(Rin × Rgain)

Gout = clamp(Gin × Ggain)

Bout = clamp(Bin × Bgain)

The output clamp prevents overflow and ensures that the result remains within the valid pixel range.

## 6.13 Filter Processing Block

The filter processing block performs spatial image filtering. Unlike simple pixel transformation, spatial filtering depends on a neighborhood of pixels.

The VCP-supported filter set includes:

- Sharp filter.

- Blur filter.

- Emboss filter.

- Sobel edge detection.

- Contrast filter.

The source document lists sharp, blur, emboss, Sobel edge detection, and contrast under VCP filter capabilities.

### 6.13.1 Kernel-Based Filtering

A kernel filter applies a matrix of coefficients to neighboring pixels.

For a 3×3 filter:

Output(x,y) =

K00×P(x-1,y-1) + K01×P(x,y-1) + K02×P(x+1,y-1)

\+ K10×P(x-1,y) + K11×P(x,y) + K12×P(x+1,y)

\+ K20×P(x-1,y+1) + K21×P(x,y+1) + K22×P(x+1,y+1)

This structure is suitable for blur, sharpen, emboss, and edge-detection operations.

### 6.13.2 Sobel Edge Detection

Sobel edge detection uses horizontal and vertical gradient kernels to detect image edges.

A simplified Sobel process is:

Gx = horizontal gradient

Gy = vertical gradient

Edge Magnitude ≈ \|Gx\| + \|Gy\|

The absolute-sum approximation is hardware-friendly because it avoids square-root operations.

## 6.14 Color-Space Conversion Block

The color-space conversion block transforms RGB data into alternate mathematical color representations. These conversions are useful for image enhancement, segmentation, compression, feature extraction, and color analysis.

The VCP design supports multiple color-space conversion functions, including RGB to HSL, HSL to RGB, RGB to YCbCr, RGB to CMYK, RGB to YDbDr, RGB to CIE XYZ, RGB to CIE YUV, RGB to YIQ, RGB to YPbPr, RGB to LMS, RGB to ICtCp, RGB to HED, and RGB to YC1C2.

### 6.14.1 Conversion Block Structure

A typical color-conversion block includes:

1.  Input RGB channel extraction.

2.  Fixed-point coefficient multiplication.

3.  Addition and subtraction stages.

4.  Range normalization.

5.  Output clamping.

6.  Output packing.

7.  Sideband signal delay alignment.

For FPGA implementation, fixed-point arithmetic is preferred over floating-point arithmetic because it reduces resource usage and improves timing predictability.

## 6.15 K-Means Color Clustering Block

The K-means color clustering block classifies pixels according to their distance from a set of color centroids. Each RGB pixel is treated as a vector in three-dimensional color space:

Pixel = (R, G, B)

Centroid K = (Rk, Gk, Bk)

The classifier computes the distance between the input pixel and each centroid. The pixel is assigned to the cluster with the minimum distance.

A hardware-friendly distance metric is Manhattan distance:

Distance = \|R - Rk\| + \|G - Gk\| + \|B - Bk\|

This avoids multipliers and square-root operations, making it efficient for FPGA logic.

### 6.15.1 Parallel Cluster Comparison

To maintain real-time throughput, distances to multiple centroids can be calculated in parallel:

Pixel RGB

↓

Distance to Centroid 0

Distance to Centroid 1

Distance to Centroid 2

...

Distance to Centroid N

↓

Minimum Distance Selector

↓

Cluster Index

↓

Output Color / Palette Mapping

The output may be:

- Cluster index.

- Centroid color.

- Palette-mapped color.

- Segmentation mask.

- Reduced-color image.

## 6.16 Programmable Color Scheme Block

The programmable color scheme block maps input pixels, cluster labels, thresholds, or color ranges into selected output colors.

This block may support:

- Palette-based color replacement.

- User-defined color profiles.

- LUT-controlled color mapping.

- Symbolic color output.

- Region-based color coding.

- Cluster-to-color remapping.

A simplified mapping operation is:

Input Classification → Palette Lookup → Output RGB Color

Programmable color schemes are useful for visualization, segmentation, debugging, and artistic image effects.

## 6.17 Threshold and Segmentation Block

The threshold and segmentation block separates pixels into classes based on intensity, color, or local image statistics.

Basic threshold logic can be represented as:

If pixel_value \>= threshold:

output = foreground_color

Else:

output = background_color

More advanced local dynamic thresholding can use neighborhood information, local averages, or adaptive thresholds.

Segmentation outputs may include:

- Binary mask.

- Foreground/background image.

- Highlighted object region.

- Edge-enhanced region.

- Palette-coded output.

## 6.18 Output Clamp and Normalization

Many processing functions produce intermediate values that can exceed the valid pixel range. For example, filter accumulation, contrast scaling, and matrix multiplication can generate negative values or values above the maximum channel limit.

The output clamp stage ensures that processed values remain valid.

For 8-bit output:

if value \< 0:

value = 0

else if value \> 255:

value = 255

else:

value = value

For 10-bit output:

if value \< 0:

value = 0

else if value \> 1023:

value = 1023

else:

value = value

Clamping is required to prevent wraparound artifacts and invalid output colors.

## 6.19 Pipeline Latency and Sideband Alignment

Each VCP processing path introduces latency. Color conversion, filtering, clustering, and matrix operations may require different numbers of pipeline stages.

The sideband signals must be delayed by the same number of cycles as the pixel data.

Important aligned signals include:

- TVALID

- TUSER

- TLAST

- Pixel coordinates

- Frame counters

- Line counters

- Mode-valid indicators

If sideband signals are not aligned with processed pixel data, the output stream may show frame shifts, line corruption, or incorrect image boundaries.

A typical alignment structure is:

Pixel Data Pipeline: D0 → D1 → D2 → D3 → D4

TUSER Delay Pipeline: U0 → U1 → U2 → U3 → U4

TLAST Delay Pipeline: L0 → L1 → L2 → L3 → L4

TVALID Delay Pipeline: V0 → V1 → V2 → V3 → V4

## 6.20 Runtime Configuration Strategy

The VCP module supports software-controlled configuration through AXI4-Lite registers. Runtime configuration allows the user to change processing parameters without rebuilding the FPGA bitstream.

Runtime-configurable parameters may include:

- Processing mode.

- Filter enable.

- Color-conversion selection.

- RGB gain values.

- Brightness offset.

- Contrast scale.

- Saturation scale.

- White-balance gain.

- Black-balance offset.

- Threshold values.

- Palette selection.

- K-means centroid values.

- Output mapping selection.

### 6.20.1 Frame-Safe Configuration

For stable video output, parameter changes should be applied at safe synchronization points, preferably at frame boundaries.

Recommended strategy:

Software writes new configuration

↓

VCP stores pending values

↓

Start-of-frame detected

↓

Pending values become active

↓

Entire frame uses one consistent configuration

This avoids partial-frame artifacts where one part of the frame uses old settings and another part uses new settings.

## 6.21 Resource Considerations

The VCP module can consume different FPGA resources depending on which processing blocks are enabled.

| **Resource**       | **Typical Usage**                                                   |
|--------------------|---------------------------------------------------------------------|
| LUTs               | Control logic, comparators, adders, mode selection, threshold logic |
| Flip-flops         | Pipeline registers, sideband delay, state machines                  |
| BRAM               | Line buffers, LUTs, palettes, histogram storage                     |
| DSP blocks         | Multiplication for color conversion, gain, matrix operations        |
| URAM               | Large image buffers if required                                     |
| Clocking resources | Video clock, control clock, output clock                            |

The most resource-intensive blocks are usually:

- Color correction matrix.

- High-precision color-space conversion.

- Large kernel filters.

- K-means clustering with many centroids.

- Histogram and segmentation logic.

- High-resolution line buffers.

## 6.22 Timing Closure Considerations

The VCP module must meet timing at the selected video-processing clock. High-resolution video modes may require processing clocks near 297 MHz or higher.

Critical timing paths may occur in:

- Multiplication and accumulation chains.

- Division or reciprocal approximation logic.

- K-means distance comparison tree.

- Filter kernel accumulation.

- Large multiplexers used for mode selection.

- Long sideband alignment pipelines.

- BRAM read/write paths.

- Output clamp logic.

Recommended timing-closure techniques include:

- Deep pipelining.

- Register balancing.

- Breaking large arithmetic operations into stages.

- Using DSP blocks for multiplication.

- Avoiding large combinational mode-selection trees.

- Registering BRAM outputs.

- Using fixed-point arithmetic instead of floating-point arithmetic.

- Constraining clocks correctly in Vivado.

## 6.23 Verification Requirements for the VCP Module

The VCP module should be verified at both block level and system level.

### 6.23.1 Block-Level Verification

Block-level verification checks each processing function independently.

Recommended tests include:

- Bypass mode test.

- RGB gain test.

- Brightness adjustment test.

- Contrast adjustment test.

- Saturation adjustment test.

- Color correction matrix test.

- RGB-to-HSL conversion test.

- HSL-to-RGB conversion test.

- Filter kernel test.

- Sobel edge-detection test.

- K-means clustering test.

- Palette mapping test.

- Threshold segmentation test.

### 6.23.2 Stream Protocol Verification

The VCP module must preserve AXI4-Stream protocol behavior.

Protocol checks include:

- TVALID stability.

- TREADY handling.

- Correct TUSER propagation.

- Correct TLAST propagation.

- No pixel loss during continuous streaming.

- No output when input is invalid.

- Correct behavior during reset.

- Correct backpressure handling.

### 6.23.3 Image-Based Verification

Image-based verification compares output frames against expected reference images.

Useful checks include:

- Pixel-by-pixel comparison.

- Mean absolute error.

- Histogram comparison.

- Edge-map comparison.

- Cluster label comparison.

- Visual inspection.

- Frame-boundary validation.

## 6.24 VCP Architecture Summary

The Video Color Processing module is the main real-time image-processing block in the FPGA video pipeline. It receives RGB video after demosaic conversion, applies selected processing functions, and outputs a processed stream to display, Ethernet, or memory paths.

The module combines AXI4-Stream video transport with AXI4-Lite software control. It supports pixel transformation, pixel generation, spatial filtering, color-space conversion, image enhancement, color correction, K-means clustering, programmable color schemes, and threshold segmentation.

The source design identifies the VCP module as a configurable block with control registers, local buffers, filter functions, color-space conversion functions, and K-means color clustering support.

A successful VCP implementation must preserve stream timing, maintain sideband alignment, meet video-clock timing, support deterministic throughput, and provide reliable software-controlled configuration.
