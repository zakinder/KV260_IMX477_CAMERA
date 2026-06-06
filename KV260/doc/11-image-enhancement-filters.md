# Chapter 11 — Image Enhancement Filters

## 11.1 Overview

Image enhancement filters are hardware-processing blocks that modify pixel values using either the current pixel or a local neighborhood of surrounding pixels. In the FPGA Video Color Processing System, these filters are implemented inside the Video Color Processing module and operate on the real-time RGB stream.

The source design identifies the VCP filter group as including **sharp**, **blur**, **emboss**, **Sobel edge detection**, and **contrast** functions.

At a high level, the enhancement filter path is:

AXI4-Stream RGB Input

↓

RGB Unpack

↓

Line Buffer / Window Generator

↓

Filter Kernel / Enhancement Logic

↓

Clamp and Normalize

↓

RGB Pack

↓

AXI4-Stream RGB Output

These filters improve visual quality, emphasize image features, reduce high-frequency noise, detect object boundaries, or create specialized visual effects.

## 11.2 Purpose of Image Enhancement Filters

Image enhancement filters support several image-processing objectives:

| **Objective**        | **Description**                                                        |
|----------------------|------------------------------------------------------------------------|
| Sharpening           | Emphasizes edges and fine image detail.                                |
| Blurring             | Smooths image regions and reduces high-frequency noise.                |
| Embossing            | Creates a raised or relief-like visual effect.                         |
| Edge detection       | Extracts strong intensity transitions from the image.                  |
| Contrast enhancement | Increases or decreases the difference between bright and dark regions. |
| Pre-processing       | Prepares the image for segmentation, thresholding, or clustering.      |
| Debug visualization  | Makes structural image features easier to inspect.                     |

In FPGA implementation, these filters must be designed for deterministic throughput. The preferred model is one processed pixel per clock after pipeline fill.

## 11.3 Filter Placement in the VCP Pipeline

Image enhancement filters are placed after RGB pixel generation and before final output routing.

Camera Sensor

↓

MIPI CSI-2 RX

↓

RAW10 Capture

↓

Demosaic

↓

RGB Stream

↓

Image Enhancement Filter

↓

DisplayPort / UDP / VDMA Output

This placement allows the filter logic to operate on full RGB pixels rather than raw Bayer samples. Filtering can be applied directly to each RGB channel or to a grayscale/luminance representation depending on the selected mode.

## 11.4 Spatial Filtering Concept

Most image enhancement filters use a **kernel** or **convolution mask**. A kernel is a small matrix of coefficients applied to a local window around the current pixel.

A typical 3×3 pixel window is:

P00 P01 P02

P10 P11 P12

P20 P21 P22

Where P11 is the center pixel currently being processed.

A general 3×3 convolution is:

Output =

K00×P00 + K01×P01 + K02×P02

\+ K10×P10 + K11×P11 + K12×P12

\+ K20×P20 + K21×P21 + K22×P22

The coefficient matrix determines the filter behavior.

## 11.5 Line Buffer and Window Generator Architecture

Because video pixels arrive in raster order, the filter cannot access future or previous rows unless those rows are buffered. A 3×3 filter normally requires a three-line pixel window.

The source document describes a filter architecture with image registers or shift registers, an image window, a coefficient table, and a convolution module.

A practical hardware structure is:

Input Pixel Stream

↓

Line Buffer 0

↓

Line Buffer 1

↓

Line Buffer 2

↓

3×3 Window Generator

↓

Coefficient Multiply

↓

Accumulator

↓

Clamp

↓

Output Pixel Stream

### 11.5.1 Line Buffer Purpose

Line buffers provide access to pixels from previous rows. For a 3×3 kernel, the system must access:

Previous row: P(x-1,y-1), P(x,y-1), P(x+1,y-1)

Current row: P(x-1,y), P(x,y), P(x+1,y)

Next row: P(x-1,y+1), P(x,y+1), P(x+1,y+1)

Because the stream is processed in real time, the “next row” is formed by delaying and shifting incoming pixels through the buffer structure.

## 11.6 Filter Module Interface

A generic enhancement filter module includes clock, reset, image width, input RGB channel, coefficient input, and output RGB channel ports. The source design shows the sharp filter interface with parameters such as i_data_width, img_width, address-width parameters, clk, rst_l, input RGB channel, coefficient input, and output RGB channel.

A generalized filter interface is:

| **Signal / Parameter** | **Description**                          |
|------------------------|------------------------------------------|
| i_data_width           | Pixel-channel data width.                |
| img_width              | Active image width used by line buffers. |
| addrWidth              | Address width for line-buffer memory.    |
| clk                    | Filter processing clock.                 |
| rst_l                  | Active-low reset.                        |
| iRgb                   | Input RGB pixel channel.                 |
| coefficients           | Kernel coefficient values.               |
| oRgb                   | Filtered RGB output channel.             |
| valid                  | Valid-pixel control signal.              |

For AXI4-Stream integration, this interface is wrapped with TVALID, TREADY, TUSER, and TLAST sideband handling.

## 11.7 Sharp Filter

The sharp filter increases local contrast around edges and fine details. It makes transitions appear more defined by emphasizing the center pixel relative to neighboring pixels.

The source document identifies a sharp filter implementation and states that it was implemented and tested for a **1024 × 1024** image size.

### 11.7.1 Typical Sharp Kernel

A common 3×3 sharpen kernel is:

0 -1 0

-1 5 -1

0 -1 0

The output equation is:

Output =

5×P11 - P01 - P10 - P12 - P21

This retains the center pixel while subtracting neighboring values. The result enhances high-frequency image detail.

### 11.7.2 Hardware Implementation

The sharp filter requires:

- 3×3 window generation.

- Signed coefficient multiplication.

- Accumulation.

- Negative-value protection.

- Output clamping.

- Sideband delay alignment.

A hardware pipeline can be structured as:

Stage 0: Register 3×3 window

Stage 1: Multiply pixels by coefficients

Stage 2: Sum row products

Stage 3: Sum full kernel result

Stage 4: Clamp to valid range

Stage 5: Register output

### 11.7.3 Sharp Filter Use Cases

The sharp filter is useful for:

- Improving edge visibility.

- Enhancing object boundaries.

- Increasing perceived detail.

- Preparing images for thresholding or segmentation.

However, excessive sharpening may amplify noise, so coefficient selection should be controlled carefully.

## 11.8 Blur Filter

The blur filter smooths an image by averaging neighboring pixels. It reduces high-frequency variations and can suppress noise before segmentation or clustering.

The source design includes a blur filter module with parameters such as iMSB, iLSB, i_data_width, img_width, address-width parameters, clock, reset, input RGB channel, and output RGB channel.

### 11.8.1 Typical Blur Kernel

A simple 3×3 average blur kernel is:

1 1 1

1 1 1

1 1 1

The normalized output is:

Output = (P00 + P01 + P02 + P10 + P11 + P12 + P20 + P21 + P22) / 9

A hardware-friendly approximation may use a power-of-two divisor:

Output ≈ sum_3x3 \>\> 3

This divides by 8 instead of 9 and reduces hardware cost. If higher accuracy is required, a fixed-point reciprocal multiply can be used:

Output = (sum_3x3 × 7282) \>\> 16

Where 7282 ≈ 2^16 / 9.

### 11.8.2 Hardware Implementation

The blur filter requires:

- Line buffers.

- 3×3 window generator.

- Add tree.

- Normalization stage.

- Output clamp.

- Valid and sideband alignment.

Because blur coefficients are often simple, the implementation may not require DSP multipliers.

### 11.8.3 Blur Filter Use Cases

The blur filter is useful for:

- Noise reduction.

- Smoothing small artifacts.

- Preparing data for threshold segmentation.

- Reducing high-frequency texture before clustering.

- Creating soft visual effects.

## 11.9 Emboss Filter

The emboss filter converts a normal image into a relief-like image. It emphasizes directional intensity changes and gives the appearance of depth or raised surfaces.

The source design includes an emboss filter and states that an emboss filter takes a video frame and converts it into an embossed image.

### 11.9.1 Typical Emboss Kernel

A common emboss kernel is:

-2 -1 0

-1 1 1

0 1 2

Another simpler emboss kernel is:

-1 -1 0

-1 0 1

0 1 1

A bias is often added to shift the signed output into a visible range:

Output = convolution_result + bias

For 8-bit output:

bias = 128

### 11.9.2 Hardware Implementation

The emboss filter requires signed arithmetic because kernel coefficients include negative values.

The hardware path includes:

3×3 Window

↓

Signed Coefficient Multiply

↓

Signed Accumulation

↓

Bias Addition

↓

Clamp

↓

Output Pixel

### 11.9.3 Emboss Filter Use Cases

The emboss filter is useful for:

- Feature visualization.

- Edge-direction emphasis.

- Demonstrating convolution effects.

- Generating artistic or diagnostic output.

## 11.10 Sobel Edge Detection Filter

The Sobel filter detects edges by calculating intensity gradients in horizontal and vertical directions. It is one of the most important enhancement filters for object boundary detection and structural image analysis.

The source design states that Sobel edge detection uses monochrome 8-bit RGB pixels stored row-by-row, uses two Sobel filters for vertical and horizontal edge detection, and convolves the filters with an input three-line buffer.

### 11.10.1 Grayscale Input

Sobel filtering is typically applied to grayscale intensity rather than full RGB.

A hardware-friendly grayscale conversion is:

Gray = (R + 2G + B) \>\> 2

This approximates luminance while avoiding multipliers.

### 11.10.2 Sobel Kernels

The standard horizontal and vertical Sobel kernels are:

Kx =

-1 0 1

-2 0 2

-1 0 1

Ky =

-1 -2 -1

0 0 0

1 2 1

Kx detects vertical edges, while Ky detects horizontal edges.

### 11.10.3 Gradient Calculation

The convolution results are:

Gx = Kx convolution result

Gy = Ky convolution result

A full magnitude calculation is:

Magnitude = sqrt(Gx² + Gy²)

The source document describes the final vertical and horizontal output as being combined through a square-root-style magnitude calculation.

For FPGA efficiency, a common approximation is:

Magnitude ≈ \|Gx\| + \|Gy\|

This avoids multipliers and square-root hardware.

### 11.10.4 Threshold-Based Edge Output

After gradient magnitude calculation, the result can be compared with a threshold:

if Magnitude \> Threshold:

Edge = 255

else:

Edge = 0

The source design states that once the Sobel result is calculated, it is compared with a user-input threshold, and pixels greater than the threshold are detected as edges.

### 11.10.5 Sobel Buffer Architecture

The source design states that three video-buffer lines are used for a 3×3 kernel and that the buffer enters the filter in parallel form.

A practical architecture is:

Grayscale Pixel Stream

↓

Three-Line Buffer

↓

3×3 Window

↓

Kx Convolution

↓

Ky Convolution

↓

Magnitude Approximation

↓

Threshold Compare

↓

Edge Output

## 11.11 Contrast Filter

Contrast filtering adjusts the difference between dark and bright regions. Unlike convolution filters, contrast enhancement can be implemented as a per-pixel transformation.

A common contrast equation is:

Output = clamp((Input - Midpoint) × Gain + Midpoint)

For 8-bit pixels:

Midpoint = 128

For 10-bit pixels:

Midpoint = 512

For RGB images, the equation may be applied independently to each channel:

Rout = clamp((Rin - Midpoint) × ContrastGain + Midpoint)

Gout = clamp((Gin - Midpoint) × ContrastGain + Midpoint)

Bout = clamp((Bin - Midpoint) × ContrastGain + Midpoint)

Contrast enhancement is useful for:

- Improving image visibility.

- Expanding weak intensity differences.

- Preparing images for segmentation.

- Improving visual output under low-contrast lighting.

## 11.12 Filter Coefficient Table

A coefficient table stores the kernel values used by the filter module. The source filter diagrams show a coefficient table feeding a convolution module.

A representative coefficient table is:

| **Filter** | **Kernel Type**               | **Coefficient Behavior**                |
|------------|-------------------------------|-----------------------------------------|
| Sharp      | 3×3 signed kernel             | Center emphasis with negative neighbors |
| Blur       | 3×3 positive kernel           | Local averaging                         |
| Emboss     | 3×3 signed directional kernel | Relief-like edge emphasis               |
| Sobel Kx   | 3×3 signed gradient kernel    | Vertical edge detection                 |
| Sobel Ky   | 3×3 signed gradient kernel    | Horizontal edge detection               |
| Contrast   | Scalar gain                   | Per-pixel intensity expansion           |

The coefficient table can be implemented using:

- Constant parameters.

- ROM.

- LUTRAM.

- BRAM.

- AXI4-Lite programmable registers.

Programmable coefficients allow runtime filter customization, but they require safe update handling and validation.

## 11.13 RGB Versus Grayscale Filtering

Filters can operate either on each RGB channel independently or on a grayscale/luminance value.

### 11.13.1 RGB Channel Filtering

Each channel is filtered separately:

Rout = filter(R window)

Gout = filter(G window)

Bout = filter(B window)

This preserves color information but uses more hardware because three filter paths are required.

### 11.13.2 Grayscale Filtering

The RGB pixel is first converted into grayscale:

Gray = (R + 2G + B) \>\> 2

Then the filter operates on Gray.

This is efficient for edge detection because edge output is usually structural rather than color-specific.

### 11.13.3 Hybrid Filtering

Some designs compute a grayscale edge map and overlay it on the original RGB image:

if Edge == 1:

output = edge_color

else:

output = original_rgb

This approach is useful for debugging and visual demonstration.

## 11.14 Border Handling

Kernel filters require neighboring pixels. At image borders, some neighbors are unavailable.

Common border strategies include:

| **Strategy**      | **Description**                         |
|-------------------|-----------------------------------------|
| Zero padding      | Missing pixels are treated as zero.     |
| Replication       | Edge pixel values are repeated.         |
| Mirror padding    | Border values are reflected.            |
| Valid-only output | Border pixels are suppressed or copied. |
| Bypass border     | Original pixel is output at borders.    |

For real-time FPGA video, **bypass border** or **replication** is often practical because it avoids large control complexity.

Example border rule:

if x == 0 or y == 0 or x == width-1 or y == height-1:

output = input_pixel

else:

output = filtered_pixel

## 11.15 Output Clamping and Normalization

Convolution can produce values outside the legal channel range. Signed kernels may produce negative values, and high-gain kernels may produce values greater than the maximum.

For 8-bit output:

if value \< 0:

output = 0

else if value \> 255:

output = 255

else:

output = value

For 10-bit output:

if value \< 0:

output = 0

else if value \> 1023:

output = 1023

else:

output = value

Normalization may also be required. For blur filters, the accumulated sum must be divided by the sum of kernel coefficients. For Sobel filters, the gradient magnitude may need scaling before output.

## 11.16 Pipeline Latency

Image filters introduce latency from line buffering, window generation, multiplication, accumulation, normalization, and output registration.

Typical latency sources include:

| **Stage**                  | **Latency Source**                            |
|----------------------------|-----------------------------------------------|
| Line buffers               | Row delay required for window formation       |
| Window generator           | Shift-register alignment                      |
| Coefficient multiplication | DSP or LUT multiplier pipeline                |
| Accumulation               | Add-tree pipeline                             |
| Magnitude calculation      | Absolute value, square-root, or approximation |
| Threshold comparison       | Registered comparator                         |
| Output clamp               | Saturation logic                              |
| Sideband alignment         | Delay chains for TUSER, TLAST, TVALID         |

The line-buffer delay is structural and depends on image width. The arithmetic latency is measured in clock cycles and must be matched by the sideband delay pipeline.

## 11.17 AXI4-Stream Sideband Alignment

The filter output must remain synchronized with AXI4-Stream sideband signals.

Signals requiring alignment include:

- TVALID

- TUSER

- TLAST

- Pixel coordinates

- Frame counter

- Line counter

A generic alignment structure is:

Pixel pipeline: P0 → P1 → P2 → P3 → P4

TVALID pipeline: V0 → V1 → V2 → V3 → V4

TUSER pipeline: U0 → U1 → U2 → U3 → U4

TLAST pipeline: L0 → L1 → L2 → L3 → L4

If sideband signals are not delayed correctly, the output image may show shifted lines, corrupted frame starts, or invalid display timing.

## 11.18 Throughput Requirement

For live video, the enhancement filter should sustain one pixel per clock after pipeline fill:

Throughput = 1 output pixel / clock

To meet this requirement:

- The window generator must shift one pixel per cycle.

- The line buffers must support one read/write per active pixel.

- Coefficient multiplication must be pipelined.

- Accumulation must be pipelined.

- Output clamp must be registered.

- AXI4-Stream backpressure must be handled correctly.

If the filter stalls for multiple cycles per pixel, the design may not support real-time video at high resolution.

## 11.19 Resource Considerations

Image enhancement filters use FPGA resources differently depending on their implementation.

| **Filter** | **LUTs** | **FFs** | **BRAM**     | **DSP**  | **Notes**                        |
|------------|----------|---------|--------------|----------|----------------------------------|
| Contrast   | Low      | Low     | None         | Optional | Per-pixel operation              |
| Blur       | Medium   | Medium  | Line buffers | Low      | Mostly adders and normalization  |
| Sharp      | Medium   | Medium  | Line buffers | Medium   | Signed coefficients              |
| Emboss     | Medium   | Medium  | Line buffers | Medium   | Signed directional kernel        |
| Sobel      | High     | High    | Line buffers | Medium   | Two kernels plus magnitude logic |

BRAM usage is mainly driven by image width, pixel width, and number of buffered lines.

## 11.20 Register-Level Controls

A representative register interface for filter control may include:

| **Register**                     | **Function**                                          |
|----------------------------------|-------------------------------------------------------|
| FILTER_ENABLE                    | Enables filter processing.                            |
| FILTER_MODE                      | Selects sharp, blur, emboss, Sobel, or contrast mode. |
| FILTER_BYPASS                    | Forwards input pixels unchanged.                      |
| FILTER_COEFF_0 to FILTER_COEFF_8 | Stores programmable 3×3 kernel coefficients.          |
| FILTER_SCALE                     | Normalization or right-shift scale factor.            |
| FILTER_BIAS                      | Bias value for emboss or signed-kernel output.        |
| SOBEL_THRESHOLD                  | Edge-detection threshold.                             |
| FILTER_STATUS                    | Reports active mode and error status.                 |
| FILTER_FRAME_COUNT               | Counts processed frames.                              |

The source testbench parameter section lists enable parameters for sharp, blur, HSL, HSV, RGB, Sobel, and emboss filter tests, showing that these functions are intended to be selectable for verification and test operation.

## 11.21 Filter Mode Selection

A practical filter mode table is:

| **Mode** | **Filter**               |
|----------|--------------------------|
| 0        | Bypass                   |
| 1        | Contrast                 |
| 2        | Sharp                    |
| 3        | Blur                     |
| 4        | Emboss                   |
| 5        | Sobel edge detection     |
| 6        | User-programmable kernel |

Mode changes should preferably be applied at frame boundaries:

Software writes pending filter mode

↓

Start-of-frame detected

↓

Pending mode becomes active

↓

Entire frame uses one consistent filter

This prevents a single frame from containing mixed filter outputs.

## 11.22 Verification Strategy

Image enhancement filters should be verified using both pixel-level and image-level tests.

### 11.22.1 Directed Kernel Tests

Use small image windows with known values:

10 10 10

10 100 10

10 10 10

The expected output is calculated manually or by a software reference model.

### 11.22.2 Full-Frame Image Tests

Use complete images to verify:

- Sharpness improvement.

- Blur smoothness.

- Emboss directional effect.

- Sobel edge extraction.

- Contrast scaling.

- Border handling.

- No frame or line shift.

- No invalid wraparound artifacts.

### 11.22.3 AXI4-Stream Protocol Tests

Verify:

- Correct TVALID behavior.

- Correct TREADY handling.

- Correct TUSER alignment.

- Correct TLAST alignment.

- Correct reset recovery.

- No pixel loss under continuous streaming.

- Correct behavior during bypass.

## 11.23 Simulation Test Images

Recommended simulation inputs include:

| **Test Image**   | **Purpose**                               |
|------------------|-------------------------------------------|
| Solid color      | Verifies no false edges or filter bias.   |
| Grayscale ramp   | Checks contrast and clamp behavior.       |
| Checkerboard     | Tests high-frequency response.            |
| Vertical lines   | Tests horizontal-gradient edge detection. |
| Horizontal lines | Tests vertical-gradient edge detection.   |
| Color bars       | Checks RGB channel preservation.          |
| Natural image    | Validates visual quality.                 |
| Noise image      | Tests blur and Sobel stability.           |

A good verification environment should compare hardware output against a software-generated reference image.

## 11.24 Common Failure Modes

| **Failure Mode**               | **Likely Cause**                       | **Correction**                          |
|--------------------------------|----------------------------------------|-----------------------------------------|
| Image shifted by one line      | Incorrect line-buffer timing           | Recheck window generator latency        |
| Image shifted horizontally     | Incorrect shift-register tap selection | Align tap positions                     |
| Frame starts in wrong location | TUSER not delayed with pixel data      | Add matched sideband delay              |
| Missing line end               | TLAST not delayed or dropped           | Verify sideband pipeline                |
| Excessively bright output      | Missing normalization                  | Apply scale or divide                   |
| Negative values wrap bright    | Signed result treated as unsigned      | Clamp negative values to zero           |
| Sobel output too noisy         | Threshold too low                      | Increase threshold or blur before Sobel |
| Blur too dark                  | Incorrect divide factor                | Correct normalization                   |
| Emboss output black            | Missing bias                           | Add midpoint bias before clamp          |

## 11.25 Hardware Design Recommendations

1.  **Use line buffers for all 3×3 spatial filters.**  
    This supports continuous streaming without full-frame memory.

2.  **Register each convolution stage.**  
    Pipelined multiplication and accumulation improve timing closure.

3.  **Use signed arithmetic for sharp, emboss, and Sobel filters.**  
    Negative coefficients must be handled correctly.

4.  **Normalize accumulated results.**  
    Blur and weighted filters require scaling before output.

5.  **Clamp final output values.**  
    Prevent overflow, underflow, and wraparound artifacts.

6.  **Delay sideband signals through the same latency as pixel data.**  
    Preserve frame and line synchronization.

7.  **Handle image borders explicitly.**  
    Use bypass, replication, or valid-only output rules.

8.  **Use programmable coefficients where practical.**  
    This makes the filter block reusable for multiple enhancement modes.

## 11.26 Chapter Summary

This chapter described the image enhancement filters used in the FPGA Video Color Processing System. The VCP filter group includes sharp, blur, emboss, Sobel edge detection, and contrast processing.

The sharp, blur, and emboss filters are implemented as convolution-style spatial filters using image registers, line buffers, coefficient tables, and convolution modules. Sobel edge detection uses monochrome 8-bit pixels, two gradient filters, a three-line buffer, convolution logic, magnitude calculation, and threshold comparison to detect edges.

A reliable FPGA filter implementation must preserve AXI4-Stream timing, use correct line-buffer alignment, manage signed arithmetic, normalize accumulated results, clamp outputs, and delay valid and sideband signals to match the processing latency.
