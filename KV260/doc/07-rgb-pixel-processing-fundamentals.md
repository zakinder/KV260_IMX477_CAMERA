# Chapter 7 — RGB Pixel Processing Fundamentals

## 7.1 Overview of RGB Pixel Processing

RGB pixel processing is the foundation of the Video Color Processing System. After camera capture and demosaic conversion, the raw Bayer-pattern sensor stream is transformed into a full RGB video stream. Each pixel then contains three color components: **red**, **green**, and **blue**.

The RGB stream is the primary working format for the Video Color Processing module because most enhancement, filtering, color correction, color conversion, and clustering operations begin from RGB channel values.

The source design identifies the VCP module as the stage that applies filters, color-space conversion, K-means color clustering, and image-enhancement controls such as contrast, brightness, saturation, white/black balance, and RGB gain through AXI4-Lite registers.

At a high level, RGB pixel processing follows this flow:

RAW Camera Stream

↓

Demosaic Processing

↓

RGB Pixel Stream

↓

RGB Channel Processing

↓

Filtered / Corrected / Converted / Clustered Output

## 7.2 RGB Pixel Representation

An RGB pixel is a three-component vector:

PixelRGB = (R, G, B)

Where:

| **Component** | **Meaning**             |
|---------------|-------------------------|
| R             | Red channel intensity   |
| G             | Green channel intensity |
| B             | Blue channel intensity  |

Each channel stores the intensity of one color component. The combination of all three channels defines the final perceived color of the pixel.

For example:

| **RGB Value**   | **Meaning** |
|-----------------|-------------|
| (0, 0, 0)       | Black       |
| (Max, Max, Max) | White       |
| (Max, 0, 0)     | Red         |
| (0, Max, 0)     | Green       |
| (0, 0, Max)     | Blue        |
| (Max, Max, 0)   | Yellow      |
| (0, Max, Max)   | Cyan        |
| (Max, 0, Max)   | Magenta     |

The actual maximum value depends on pixel bit width. For 8-bit channels, the maximum is 255. For 10-bit channels, the maximum is 1023. For 12-bit channels, the maximum is 4095.

## 7.3 RGB Channel Bit Width

RGB processing must define the number of bits used per channel. The channel bit width affects image precision, dynamic range, arithmetic size, bandwidth, and FPGA resource usage.

Common RGB formats include:

| **Format** | **Red** | **Green** | **Blue** | **Total Bits Per Pixel** |
|------------|---------|-----------|----------|--------------------------|
| RGB888     | 8 bits  | 8 bits    | 8 bits   | 24 bits                  |
| RGB101010  | 10 bits | 10 bits   | 10 bits  | 30 bits                  |
| RGB121212  | 12 bits | 12 bits   | 12 bits  | 36 bits                  |

The source system captures camera data in RAW10 format before demosaic conversion, and the VCP pipeline processes video as RGB data after the Bayer-pattern stream is converted into an RGB color frame.

### 7.3.1 8-Bit RGB

8-bit RGB is widely used for display and visualization.

R, G, B range = 0 to 255

It is efficient for output and display but provides less precision for intermediate processing.

### 7.3.2 10-Bit RGB

10-bit RGB provides higher precision and is useful when the input camera stream is RAW10.

R, G, B range = 0 to 1023

10-bit processing preserves more sensor detail and reduces quantization artifacts during enhancement and conversion.

### 7.3.3 12-Bit RGB

12-bit RGB provides additional dynamic range but increases datapath width and resource usage.

R, G, B range = 0 to 4095

This format is useful for high-precision imaging but requires wider adders, multipliers, buffers, and stream buses.

## 7.4 RGB Pixel Packing

In an AXI4-Stream video pipeline, RGB components are usually packed into a single TDATA word. The packing format must be consistent across all modules in the pipeline.

A typical 30-bit RGB packing format for 10-bit channels is:

TDATA\[29:20\] = Red

TDATA\[19:10\] = Green

TDATA\[9:0\] = Blue

A typical 24-bit RGB packing format for 8-bit channels is:

TDATA\[23:16\] = Red

TDATA\[15:8\] = Green

TDATA\[7:0\] = Blue

The VCP module must unpack the input stream before processing and repack the output stream after processing:

AXI4-Stream TDATA

↓

RGB Unpack

↓

R, G, B Processing

↓

RGB Pack

↓

AXI4-Stream TDATA

Incorrect packing causes channel swapping, color distortion, or invalid output images.

## 7.5 Pixel Validity and Stream Control

RGB pixel processing must occur only when the input pixel is valid. In AXI4-Stream video, pixel validity is controlled by the TVALID and TREADY handshake.

| **Signal**       | **Meaning**                           |
|------------------|---------------------------------------|
| TVALID           | Source is presenting valid pixel data |
| TREADY           | Destination can accept pixel data     |
| TVALID && TREADY | Pixel transfer occurs                 |
| TUSER            | Start-of-frame marker                 |
| TLAST            | End-of-line marker                    |

A pixel should be processed only on a valid transfer:

if TVALID = 1 and TREADY = 1:

process current RGB pixel

else:

hold pipeline state or stall safely

The RGB datapath must preserve the video stream structure. This means the pixel data and its associated control markers must remain aligned through every processing stage.

## 7.6 Frame and Line Alignment

RGB video streams are organized as frames and lines. Each frame contains rows of pixels, and each row contains a fixed number of pixels.

For a 3840×2160 frame:

Frame width = 3840 pixels

Frame height = 2160 lines

The processing pipeline must track:

- Start of frame.

- End of line.

- Active pixel count.

- Current x-coordinate.

- Current y-coordinate.

- Valid frame region.

- Blanking or inactive regions, if applicable.

A typical coordinate-tracking model is:

if start_of_frame:

x = 0

y = 0

if valid_pixel:

process pixel(x, y)

x = x + 1

if end_of_line:

x = 0

y = y + 1

Frame and line alignment are especially important for filters, demosaic validation, histogram generation, thresholding, and debugging.

## 7.7 RGB Channel Gain Control

RGB gain control applies independent scaling to the red, green, and blue channels. This is used for white balance, color correction, and sensor calibration.

The basic gain equations are:

Rout = clamp(Rin × Rgain)

Gout = clamp(Gin × Ggain)

Bout = clamp(Bin × Bgain)

Where:

- Rin, Gin, and Bin are input channel values.

- Rgain, Ggain, and Bgain are programmable gain values.

- Rout, Gout, and Bout are gain-adjusted output values.

- clamp() limits the output to the valid channel range.

The source document explicitly identifies RGB gain as one of the image-quality controls applied through AXI4-Lite configuration registers.

### 7.7.1 Fixed-Point Gain Format

In FPGA logic, gain values are typically represented using fixed-point arithmetic.

Example fixed-point gain format:

Gain format = Q4.8

Integer bits = 4

Fraction bits = 8

Gain value 1.0 = 256

A gain operation can then be implemented as:

Rout = (Rin × Rgain_fixed) \>\> 8

This avoids floating-point hardware and improves timing predictability.

## 7.8 Brightness Adjustment

Brightness adjustment adds or subtracts an offset from each RGB channel.

Basic brightness equations:

Rout = clamp(Rin + BrightnessOffset)

Gout = clamp(Gin + BrightnessOffset)

Bout = clamp(Bin + BrightnessOffset)

A positive offset increases brightness. A negative offset decreases brightness.

For 8-bit RGB:

Valid range = 0 to 255

For 10-bit RGB:

Valid range = 0 to 1023

Brightness adjustment is simple to implement in FPGA logic because it requires adders and clamp logic.

## 7.9 Contrast Adjustment

Contrast adjustment changes the difference between each pixel value and a midpoint intensity. A common formula is:

Output = clamp((Input - Midpoint) × ContrastGain + Midpoint)

For 8-bit RGB:

Midpoint = 128

For 10-bit RGB:

Midpoint = 512

Per-channel contrast adjustment can be represented as:

Rout = clamp((Rin - Midpoint) × ContrastGain + Midpoint)

Gout = clamp((Gin - Midpoint) × ContrastGain + Midpoint)

Bout = clamp((Bin - Midpoint) × ContrastGain + Midpoint)

Contrast processing requires signed arithmetic because the intermediate value (Input - Midpoint) may be negative.

## 7.10 Saturation Adjustment

Saturation controls the intensity of color relative to grayscale luminance. Increasing saturation makes colors more vivid. Decreasing saturation moves colors closer to grayscale.

A hardware-friendly saturation method first computes luminance:

Y ≈ (R + 2G + B) / 4

Then each channel is adjusted relative to luminance:

Rout = clamp(Y + SaturationGain × (Rin - Y))

Gout = clamp(Y + SaturationGain × (Gin - Y))

Bout = clamp(Y + SaturationGain × (Bin - Y))

This method avoids expensive floating-point operations and can be implemented with fixed-point arithmetic.

The green channel is weighted more heavily because it often contributes strongly to perceived brightness.

## 7.11 White Balance

White balance compensates for lighting conditions that make an image appear too warm, too cool, too green, or too magenta. It is usually implemented by applying different gains to each color channel.

Example white-balance correction:

Rout = clamp(Rin × Rwhite_gain)

Gout = clamp(Gin × Gwhite_gain)

Bout = clamp(Bin × Bwhite_gain)

If the image appears too blue, the red gain may be increased or the blue gain may be reduced. If the image appears too warm, the blue gain may be increased or the red gain may be reduced.

White balance is commonly implemented as part of RGB gain control.

## 7.12 Black Balance

Black balance adjusts low-level channel offsets so that dark regions remain neutral. Without proper black balance, shadows may show unwanted color tinting.

Basic black-balance correction:

Rout = clamp(Rin - Rblack_offset)

Gout = clamp(Gin - Gblack_offset)

Bout = clamp(Bin - Bblack_offset)

Black balance may be applied before gain correction so that channel offsets are removed before scaling.

Recommended order:

Input RGB

↓

Black Balance Offset Correction

↓

RGB Gain / White Balance

↓

Brightness / Contrast / Saturation

↓

Output RGB

## 7.13 RGB Clamping and Overflow Protection

RGB arithmetic can generate values outside the valid range. For example:

- Brightness can produce values below 0 or above maximum.

- Contrast can produce negative intermediate values.

- Gain multiplication can exceed the channel maximum.

- Filter kernels can produce large positive or negative values.

- Color conversion can generate signed intermediate results.

Clamping prevents invalid wraparound.

For 8-bit RGB:

if value \< 0:

output = 0

else if value \> 255:

output = 255

else:

output = value

For 10-bit RGB:

if value \< 0:

output = 0

else if value \> 1023:

output = 1023

else:

output = value

Without clamping, overflow can cause severe color artifacts. For example, a value slightly above maximum may wrap around to a dark value if unsigned truncation is used incorrectly.

## 7.14 RGB Arithmetic Precision

Intermediate arithmetic should usually use more bits than the final channel width. This prevents loss of precision and protects against overflow during calculations.

Example for 10-bit input channels:

| **Operation**               | **Recommended Intermediate Width**           |
|-----------------------------|----------------------------------------------|
| Addition of two channels    | 11 bits                                      |
| Addition of three channels  | 12 bits                                      |
| Gain multiplication         | 18 to 24 bits, depending on fixed-point gain |
| Contrast signed calculation | 12 to 16 bits                                |
| 3×3 filter accumulation     | 16 to 24 bits                                |
| Color matrix multiplication | 20 to 32 bits                                |

A general FPGA design rule is:

Use wider internal arithmetic.

Clamp only at the final output stage.

This preserves image quality and prevents avoidable quantization artifacts.

## 7.15 RGB-to-Grayscale Conversion

Grayscale conversion reduces an RGB pixel to a single intensity value. This is useful for edge detection, thresholding, segmentation, histogram analysis, and debugging.

A simple average method is:

Gray = (R + G + B) / 3

A hardware-friendly weighted approximation is:

Gray ≈ (R + 2G + B) / 4

A more perceptual approximation is:

Gray ≈ 0.299R + 0.587G + 0.114B

For FPGA implementation, the weighted approximation can be implemented using shifts and additions:

Gray = (R + (G \<\< 1) + B) \>\> 2

This avoids multipliers and provides a practical grayscale estimate.

## 7.16 RGB Pixel Difference Operations

Many image-processing functions require differences between channels or between neighboring pixels.

### 7.16.1 Channel Difference

Channel difference is used for color detection and color-space conversion.

RG_diff = R - G

GB_diff = G - B

RB_diff = R - B

Because differences can be negative, signed arithmetic is required.

### 7.16.2 Absolute Difference

Absolute difference is used for edge detection, clustering, similarity comparison, and thresholding.

abs_diff = \|A - B\|

For RGB color distance:

Distance = \|R1 - R2\| + \|G1 - G2\| + \|B1 - B2\|

This form is especially useful for FPGA-based K-means clustering because it avoids squaring and square-root operations.

## 7.17 RGB Pixel Coordinates

Pixel coordinates provide the spatial position of each RGB pixel in the frame.

Pixel position = (x, y)

Where:

- x is the horizontal pixel index.

- y is the vertical line index.

Coordinates are used for:

- Test-pattern generation.

- Region-of-interest processing.

- Bayer phase verification.

- Filter window alignment.

- Histogram addressing.

- Threshold segmentation.

- Debug overlays.

- Frame-boundary validation.

A coordinate tracker should reset at the start of each frame and increment only on valid pixel transfers.

## 7.18 RGB Line Buffers

Spatial filters require neighboring pixels. Since video arrives in raster order, previous rows must be stored in line buffers.

A 3×3 filter window requires access to:

P(x-1,y-1) P(x,y-1) P(x+1,y-1)

P(x-1,y) P(x,y) P(x+1,y)

P(x-1,y+1) P(x,y+1) P(x+1,y+1)

Line buffers are used for:

- Blur filtering.

- Sharp filtering.

- Emboss filtering.

- Sobel edge detection.

- Local thresholding.

- Neighborhood statistics.

The VCP module is described as maintaining local small buffers for video frame lines, which supports these neighborhood-based operations.

## 7.19 RGB Processing Latency

Each RGB processing operation introduces latency. Simple operations such as brightness adjustment may require only a few pipeline stages, while complex operations such as color conversion or clustering may require many stages.

Example latency sources:

| **Processing Function** | **Typical Latency Source**                             |
|-------------------------|--------------------------------------------------------|
| RGB gain                | Multiplication and clamp stages                        |
| Brightness              | Addition and clamp stages                              |
| Contrast                | Signed offset, multiplication, restore midpoint, clamp |
| Saturation              | Luminance calculation and channel interpolation        |
| Color correction        | Matrix multiplication and accumulation                 |
| Filter kernel           | Line buffers and convolution pipeline                  |
| K-means clustering      | Distance calculation and minimum selection             |
| Color conversion        | Fixed-point arithmetic and normalization               |

The control signals must be delayed by the same number of cycles as the pixel data:

RGB data delay = N cycles

TUSER delay = N cycles

TLAST delay = N cycles

TVALID delay = N cycles

Correct latency alignment is required for valid video output.

## 7.20 RGB Processing Pipeline Example

A practical RGB processing pipeline may use the following sequence:

AXI4-Stream Input

↓

Input Register

↓

RGB Unpack

↓

Black Balance Correction

↓

RGB Gain / White Balance

↓

Brightness Adjustment

↓

Contrast Adjustment

↓

Saturation Adjustment

↓

Optional Filter / Conversion / Clustering

↓

Clamp and Normalize

↓

RGB Pack

↓

AXI4-Stream Output

This structure provides a clean separation between basic color correction, image enhancement, and optional advanced processing functions.

## 7.21 RGB Processing Register Controls

RGB processing parameters are typically controlled through AXI4-Lite registers.

A representative register set may include:

| **Register Name** | **Function**                        |
|-------------------|-------------------------------------|
| VCP_CONTROL       | Enables or bypasses RGB processing  |
| RGB_GAIN_R        | Red channel gain                    |
| RGB_GAIN_G        | Green channel gain                  |
| RGB_GAIN_B        | Blue channel gain                   |
| BRIGHTNESS_OFFSET | Brightness adjustment value         |
| CONTRAST_GAIN     | Contrast scaling value              |
| SATURATION_GAIN   | Saturation scaling value            |
| BLACK_OFFSET_R    | Red black-level offset              |
| BLACK_OFFSET_G    | Green black-level offset            |
| BLACK_OFFSET_B    | Blue black-level offset             |
| WHITE_GAIN_R      | Red white-balance gain              |
| WHITE_GAIN_G      | Green white-balance gain            |
| WHITE_GAIN_B      | Blue white-balance gain             |
| STATUS            | Current active mode and error state |

Register-controlled processing allows software to tune image output without changing the FPGA bitstream.

## 7.22 RGB Processing Error Conditions

RGB processing logic should detect or protect against invalid conditions.

Common error conditions include:

| **Error Condition** | **Cause**                                    | **Protection Method**            |
|---------------------|----------------------------------------------|----------------------------------|
| Overflow            | Gain, contrast, or filter result exceeds max | Clamp output                     |
| Underflow           | Negative intermediate result                 | Clamp to zero                    |
| Channel swap        | Incorrect pixel packing                      | Define and verify packing format |
| Frame shift         | Incorrect TUSER delay                        | Align sideband pipeline          |
| Line shift          | Incorrect TLAST delay                        | Align line marker pipeline       |
| Pixel loss          | Backpressure or invalid ready handling       | Verify AXI handshake             |
| Color tint          | Incorrect gain or balance values             | Register default calibration     |
| Filter border error | Missing neighbor pixels at image edges       | Border handling logic            |
| Precision loss      | Narrow intermediate arithmetic               | Use wider internal bit widths    |

A robust RGB processing stage should fail safely and preserve stream integrity even when processing parameters are changed.

## 7.23 Hardware Design Guidelines

The following design practices improve RGB processing reliability:

1.  **Use consistent channel ordering.**  
    Clearly define whether packed format is RGB, BGR, or another ordering.

2.  **Use wider internal arithmetic.**  
    Avoid truncating intermediate results too early.

3.  **Clamp at output boundaries.**  
    Prevent wraparound artifacts.

4.  **Pipeline arithmetic operations.**  
    Improve timing closure for high-resolution video clocks.

5.  **Align sideband signals with pixel data.**  
    Delay TUSER, TLAST, and TVALID through matching pipelines.

6.  **Apply configuration changes at frame boundaries.**  
    Avoid partial-frame visual artifacts.

7.  **Use fixed-point arithmetic.**  
    Reduce FPGA resource usage and maintain deterministic timing.

8.  **Verify with known test patterns.**  
    Test red, green, blue, grayscale, ramps, checkerboards, and edge patterns.

## 7.24 Chapter Summary

RGB pixel processing is the core operating layer of the Video Color Processing module. After demosaic conversion, each pixel is represented by red, green, and blue channel values. These values are unpacked from the AXI4-Stream data word, processed through enhancement, correction, filtering, conversion, or clustering logic, and then repacked for downstream output.

The main RGB processing functions include channel gain, brightness, contrast, saturation, white balance, black balance, grayscale conversion, pixel difference calculation, and stream-aligned filtering. The design must protect against overflow, preserve frame and line markers, maintain deterministic latency, and use sufficient internal precision.

A reliable RGB processing architecture depends on correct pixel packing, valid AXI4-Stream handshaking, sideband alignment, fixed-point arithmetic, output clamping, and frame-safe runtime configuration.
