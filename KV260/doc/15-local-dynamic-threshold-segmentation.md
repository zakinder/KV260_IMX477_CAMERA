# Chapter 15 — Local Dynamic Threshold Segmentation

## 15.1 Overview

**Local Dynamic Threshold Segmentation** is an image-processing method that classifies or smooths pixels based on the relationship between a center pixel and its neighboring pixels. Instead of applying one global threshold to the entire frame, the module evaluates local pixel differences within a neighborhood window.

In the FPGA Video Color Processing System, this module operates on streaming video data and compares the current pixel against nearby pixels. If the local pixel differences are within a defined threshold range, the region can be treated as locally uniform and averaged. If the difference exceeds the threshold, the original pixel value may be preserved to retain edges and details.

The source design describes this module as taking the center pixel, checking its neighboring pixels one by one, comparing them against threshold limits, and averaging the values when the local difference is small.

At a high level, the processing flow is:

Input RGB Pixel Stream

↓

Line Buffer / Local Window Generator

↓

Center Pixel and Neighbor Comparison

↓

Threshold Decision

↓

Average or Preserve Pixel

↓

Segmented / Smoothed RGB Output

## 15.2 Purpose of Local Dynamic Thresholding

Local dynamic threshold segmentation is used to detect whether a pixel belongs to a smooth local region or a region with strong variation. This makes it useful for noise reduction, region smoothing, local clustering, and edge-preserving segmentation.

The method supports the following objectives:

| **Objective**        | **Description**                                                                      |
|----------------------|--------------------------------------------------------------------------------------|
| Local smoothing      | Averages neighboring pixels when differences are small.                              |
| Edge preservation    | Preserves original pixels when local difference exceeds the threshold.               |
| Region uniformity    | Produces more uniform local regions.                                                 |
| Noise reduction      | Reduces small pixel-level variation in flat areas.                                   |
| Segmentation support | Separates smooth regions from detailed or boundary regions.                          |
| FPGA efficiency      | Uses local comparisons, adders, and threshold logic rather than full-frame analysis. |

The source document states that the produced new region is uniform and that the difference in the region becomes small after local averaging.

## 15.3 Local Neighborhood Concept

The module treats each pixel as a **center pixel** and compares it with surrounding pixels. A common neighborhood window is a 3×3 window:

P00 P01 P02

P10 Pc P12

P20 P21 P22

Where:

- Pc is the center pixel.

- P00 to P22 are neighboring pixels around the center.

- The module compares each neighbor with Pc.

The local difference can be calculated as:

diff_i = \|Pc - Pi\|

For RGB pixels, the difference may be calculated per channel or as a combined RGB distance.

## 15.4 Threshold Decision Rule

The threshold determines whether a neighboring pixel is close enough to the center pixel to be included in the local average.

A simple decision rule is:

if \|Pc - Pi\| \< threshold:

include Pi in local average

else:

exclude Pi from local average

The source document states that a threshold value of **10** is selected for pixel values in a **0–255** range. Pixels with values less than the threshold are mapped to the average, while pixels greater than or equal to the threshold are mapped to the original pixel values.

This behavior can be expressed as:

if local_difference \< threshold:

output = local_average

else:

output = original_pixel

## 15.5 RGB Difference Calculation

For RGB processing, the difference between the center pixel and a neighbor can be computed in several ways.

### 15.5.1 Per-Channel Difference

Each channel is compared independently:

diff_R = \|Rc - Ri\|

diff_G = \|Gc - Gi\|

diff_B = \|Bc - Bi\|

A neighbor is accepted only if all channel differences are below the threshold:

if diff_R \< T and diff_G \< T and diff_B \< T:

include neighbor

### 15.5.2 Combined RGB Difference

A combined RGB difference can be calculated using Manhattan distance:

diff_rgb = \|Rc - Ri\| + \|Gc - Gi\| + \|Bc - Bi\|

A neighbor is included if:

if diff_rgb \< T_rgb:

include neighbor

### 15.5.3 Luminance Difference

The system may also convert RGB to grayscale or luminance first:

Gray = (R + 2G + B) \>\> 2

Then compare grayscale values:

diff = \|Gray_center - Gray_neighbor\|

This method reduces hardware cost because only one difference value is calculated per neighbor.

## 15.6 Local Average Calculation

If neighboring pixels are within the threshold range, their values can be averaged with the center pixel.

For a selected set of N accepted pixels:

Average = Sum(accepted pixels) / N

For RGB:

Ravg = Sum(accepted R values) / N

Gavg = Sum(accepted G values) / N

Bavg = Sum(accepted B values) / N

The output may be:

if accepted_count \> minimum_required:

output = average

else:

output = original_pixel

This prevents unstable output when too few neighbors are accepted.

## 15.7 Local Clustering Behavior

Local dynamic thresholding creates a form of local clustering. Pixels that are close in value are grouped through averaging, while pixels that differ significantly are kept separate.

The source document describes this mapping as giving **local clustering of image pixels**.

This local clustering differs from K-means clustering:

| **Feature**     | **Local Dynamic Threshold**  | **K-Means Color Clustering**    |
|-----------------|------------------------------|---------------------------------|
| Scope           | Local neighborhood           | Global palette/reference colors |
| Decision basis  | Difference from center pixel | Distance to reference colors    |
| Output          | Average or original pixel    | Nearest palette color           |
| Hardware memory | Line buffers                 | Palette/register table          |
| Main use        | Edge-preserving smoothing    | Color quantization              |

## 15.8 Hardware Pipeline Architecture

A practical hardware pipeline for local dynamic threshold segmentation is:

AXI4-Stream RGB Input

↓

Input Register

↓

Line Buffer

↓

3×3 Window Generator

↓

Center Pixel Extraction

↓

Neighbor Difference Calculation

↓

Threshold Comparator

↓

Accepted Pixel Accumulator

↓

Average Calculation

↓

Output Selection

↓

Clamp and Pack

↓

AXI4-Stream RGB Output

A deterministic pipeline table is:

| **Stage** | **Function**                              |
|-----------|-------------------------------------------|
| Stage 0   | Register input pixel and sideband signals |
| Stage 1   | Generate local 3×3 window                 |
| Stage 2   | Extract center pixel and neighbors        |
| Stage 3   | Calculate absolute differences            |
| Stage 4   | Compare differences against threshold     |
| Stage 5   | Accumulate accepted pixels                |
| Stage 6   | Divide by accepted count                  |
| Stage 7   | Select average or original pixel          |
| Stage 8   | Clamp and register output                 |

## 15.9 Line Buffer Requirements

A neighborhood-based threshold module requires line buffers, similar to blur, sharp, emboss, and Sobel filters.

For a 3×3 window, the design requires access to three image rows:

Previous line

Current line

Next line

The line-buffer architecture may be:

Input Pixel Stream

↓

Line Buffer 0

↓

Line Buffer 1

↓

Shift Register Taps

↓

3×3 Pixel Window

Line buffers may be implemented using:

| **Resource**    | **Use**                      |
|-----------------|------------------------------|
| Shift registers | Small tap delays             |
| LUTRAM          | Small or medium line buffers |
| BRAM            | High-resolution image lines  |
| URAM            | Very large frame widths      |

For 3840-pixel-wide video, BRAM is typically more suitable than distributed shift registers for full-line storage.

## 15.10 Threshold Register

The threshold value should be programmable through AXI4-Lite. This allows software to tune the segmentation behavior at runtime.

A representative threshold register is:

| **Register**   | **Description**                                |
|----------------|------------------------------------------------|
| LDTS_THRESHOLD | Difference threshold used for local comparison |

Example:

LDTS_THRESHOLD = 10

For 8-bit pixels, the valid range is:

0 to 255

For 10-bit pixels, the valid range is:

0 to 1023

The default threshold should be chosen conservatively. A value that is too low preserves too much noise. A value that is too high can over-smooth edges and textures.

## 15.11 Threshold Behavior

The threshold controls the amount of smoothing and segmentation.

| **Threshold Value** | **Behavior**                                     |
|---------------------|--------------------------------------------------|
| Very low            | Only nearly identical pixels are averaged        |
| Moderate            | Similar local regions are smoothed               |
| High                | More pixels are averaged, stronger smoothing     |
| Too high            | Edges may blur and object boundaries may be lost |
| Zero                | No neighbor is accepted unless exactly equal     |

The source example uses a threshold of 10 in a 0–255 pixel range, which is a moderate low threshold suitable for preserving edges while smoothing small local variations.

## 15.12 Output Selection Logic

The output selection logic determines whether to use the averaged pixel or the original center pixel.

A basic implementation is:

if local_difference \< threshold:

output_pixel = average_pixel

else:

output_pixel = center_pixel

A more complete implementation uses an accepted-neighbor count:

if accepted_count \>= MIN_ACCEPTED:

output_pixel = average_pixel

else:

output_pixel = center_pixel

This prevents a single similar neighbor from forcing an average when most of the local region is different.

## 15.13 Accepted-Neighbor Mask

The threshold comparator can generate a mask showing which neighboring pixels are accepted.

For an 8-neighbor 3×3 window:

accept_mask\[0\] = neighbor0_close

accept_mask\[1\] = neighbor1_close

accept_mask\[2\] = neighbor2_close

...

accept_mask\[7\] = neighbor7_close

The accepted count is:

accepted_count = sum(accept_mask)

The accumulator only includes accepted pixels:

if accept_mask\[i\] == 1:

sum += neighbor\[i\]

The center pixel may always be included to stabilize the average.

## 15.14 Average Division Hardware

The average calculation requires division by accepted_count.

average = sum / accepted_count

Since accepted_count is small for a 3×3 window, it ranges from 1 to 9 if the center pixel is included.

A hardware-friendly implementation can use a small reciprocal lookup table:

| **Count** | **Reciprocal Approximation** |
|-----------|------------------------------|
| 1         | 1/1                          |
| 2         | 1/2                          |
| 3         | 1/3                          |
| 4         | 1/4                          |
| 5         | 1/5                          |
| 6         | 1/6                          |
| 7         | 1/7                          |
| 8         | 1/8                          |
| 9         | 1/9                          |

Fixed-point form:

average = (sum × reciprocal_count\[accepted_count\]) \>\> fractional_bits

This avoids a general-purpose divider and supports one-pixel-per-clock throughput.

## 15.15 Edge Preservation

The main advantage of local dynamic thresholding is edge preservation. A conventional blur filter averages all neighboring pixels, which can blur object boundaries. Local dynamic thresholding only averages neighbors that are similar to the center pixel.

Example:

If center pixel is part of a dark object:

similar dark neighbors are averaged

bright background neighbors are rejected

This preserves the boundary between the dark object and bright background.

## 15.16 Border Handling

At image borders, a complete 3×3 neighborhood is not available. The module must define a border policy.

Common policies:

| **Policy**        | **Description**                          |
|-------------------|------------------------------------------|
| Bypass border     | Output original center pixel at borders  |
| Replicate border  | Repeat nearest valid pixel               |
| Zero padding      | Treat missing pixels as zero             |
| Mirror padding    | Reflect pixels at image boundaries       |
| Valid-only output | Suppress output until full window exists |

For FPGA video pipelines, **bypass border** is often the simplest and safest option:

if x == 0 or y == 0 or x == width-1 or y == height-1:

output = center_pixel

else:

output = threshold_processed_pixel

## 15.17 AXI4-Stream Integration

The local dynamic threshold segmentation module should be wrapped for AXI4-Stream compatibility.

s_axis_tdata

↓

RGB Unpack

↓

Local Threshold Core

↓

RGB Pack

↓

m_axis_tdata

AXI4-Stream signal handling:

| **Signal** | **Required Handling**                                |
|------------|------------------------------------------------------|
| TVALID     | Delay to match output pixel latency                  |
| TREADY     | Support backpressure or use a fully streaming design |
| TUSER      | Delay to remain aligned with start-of-frame          |
| TLAST      | Delay to remain aligned with end-of-line             |
| TDATA      | Carry packed RGB pixel data                          |

The module must process only valid pixels and preserve frame/line structure.

## 15.18 Sideband Signal Alignment

The local threshold pipeline introduces delay from line buffering, comparison, accumulation, average division, and output selection. All sideband signals must be delayed by the same latency.

Signals requiring alignment include:

- TVALID

- TUSER

- TLAST

- SOF

- EOL

- EOF

- Pixel coordinates

Example delay structure:

Pixel output latency: N cycles

TVALID_delay\[N\] = delayed valid for output pixel

TUSER_delay\[N\] = delayed start-of-frame marker

TLAST_delay\[N\] = delayed end-of-line marker

Incorrect sideband alignment can cause shifted frames, broken line boundaries, or invalid downstream output.

## 15.19 Throughput Requirement

The preferred throughput is:

1 processed pixel per clock

To achieve this:

- The line buffer must accept one pixel per clock.

- The window generator must update every valid pixel.

- Absolute-difference units must be parallel or pipelined.

- Threshold comparators must operate every cycle.

- Accumulation must be pipelined.

- Average division must use reciprocal lookup or pipelined division.

- Output selection must be registered.

A non-pipelined divider or sequential neighborhood loop can break real-time throughput.

## 15.20 Latency Model

A representative latency model is:

| **Block**                      | **Example Latency**    |
|--------------------------------|------------------------|
| Input register                 | 1 cycle                |
| Line buffer/window alignment   | Depends on image width |
| Difference calculation         | 1 cycle                |
| Threshold comparison           | 1 cycle                |
| Accepted-pixel accumulation    | 1–2 cycles             |
| Reciprocal average calculation | 1–2 cycles             |
| Output selection               | 1 cycle                |
| Clamp and output register      | 1 cycle                |

The line-buffer delay is structural; arithmetic latency is counted in clock cycles and must be matched by sideband delay pipelines.

## 15.21 Register-Level Control

A representative AXI4-Lite control register map is:

| **Register**      | **Function**                                        |
|-------------------|-----------------------------------------------------|
| LDTS_CONTROL      | Enable, bypass, reset, frame-safe update control    |
| LDTS_STATUS       | Active state, frame count, error flags              |
| LDTS_THRESHOLD    | Local difference threshold                          |
| LDTS_MIN_ACCEPTED | Minimum accepted-neighbor count                     |
| LDTS_MODE         | RGB, grayscale, or luminance comparison mode        |
| LDTS_BORDER_MODE  | Border handling selection                           |
| LDTS_OUTPUT_MODE  | Average, mask, highlight, or original/average blend |
| LDTS_FRAME_COUNT  | Counts processed frames                             |
| LDTS_ERROR_STATUS | Reports invalid threshold or stream error           |

Runtime threshold changes should be applied at frame boundaries.

## 15.22 Output Modes

The module can support several output modes:

| **Mode** | **Output Behavior**                 |
|----------|-------------------------------------|
| 0        | Bypass original RGB                 |
| 1        | Output locally averaged RGB         |
| 2        | Output original-or-average decision |
| 3        | Output segmentation mask            |
| 4        | Highlight changed pixels            |
| 5        | Blend original and averaged pixel   |

### 15.22.1 Segmentation Mask Mode

A binary mask can show whether the local region is smooth or detailed:

if accepted_count \>= MIN_ACCEPTED:

output = white

else:

output = black

### 15.22.2 Highlight Mode

Highlight mode can mark pixels that are not locally uniform:

if local_difference \>= threshold:

output = highlight_color

else:

output = original_pixel

This is useful for debugging boundaries and detailed regions.

## 15.23 Comparison Modes

The module can support different comparison modes.

| **Mode**                   | **Difference Basis**                | **Hardware Cost** |
|----------------------------|-------------------------------------|-------------------|
| Grayscale difference       | One value per pixel                 | Low               |
| RGB per-channel            | Three comparisons per neighbor      | Medium            |
| RGB Manhattan distance     | Sum of absolute channel differences | Medium            |
| Weighted luminance         | Weighted RGB intensity              | Medium            |
| Maximum channel difference | Max of channel differences          | Medium            |

For real-time FPGA implementation, grayscale difference or RGB Manhattan distance is often practical.

## 15.24 Common Failure Modes

| **Failure Mode**     | **Likely Cause**                      | **Correction**                     |
|----------------------|---------------------------------------|------------------------------------|
| Image too blurry     | Threshold too high                    | Reduce threshold                   |
| No smoothing effect  | Threshold too low                     | Increase threshold                 |
| Edges damaged        | Average includes dissimilar neighbors | Use per-channel or lower threshold |
| Output flicker       | Threshold changed mid-frame           | Use frame-safe update              |
| Border artifacts     | Undefined border policy               | Use bypass or replication          |
| Shifted output image | Sideband latency mismatch             | Align valid and frame markers      |
| Division error       | Accepted count is zero                | Always include center pixel        |
| Incorrect colors     | RGB channels averaged inconsistently  | Average channels using same mask   |

## 15.25 Verification Strategy

### 15.25.1 Directed Window Tests

Use small windows with known values.

Example:

100 101 102

99 100 101

220 225 230

With threshold T = 10, the top and center pixels are accepted, while the bottom row is rejected. The expected output is the average of the accepted pixels.

### 15.25.2 Edge Preservation Test

Use an image with a sharp black-white boundary. The expected behavior is:

- Smooth inside black region.

- Smooth inside white region.

- Preserve boundary between black and white.

### 15.25.3 Full-Frame Tests

Use:

- Grayscale ramp.

- Natural image.

- Noisy image.

- Checkerboard.

- Color bars.

- Edge pattern.

Verify:

- Correct smoothing behavior.

- Correct edge preservation.

- No frame or line shift.

- Correct border handling.

- Correct threshold response.

## 15.26 Hardware Design Recommendations

1.  **Always include the center pixel in the average.**  
    This prevents divide-by-zero and stabilizes output.

2.  **Use a 3×3 window for first implementation.**  
    It provides useful local context with manageable hardware cost.

3.  **Use reciprocal lookup for accepted-count division.**  
    This avoids a general divider.

4.  **Support programmable threshold.**  
    Runtime tuning is important for different lighting and noise conditions.

5.  **Apply threshold updates at frame boundaries.**  
    Prevent split-frame behavior.

6.  **Use explicit border handling.**  
    Undefined borders create visible artifacts.

7.  **Delay sideband signals to match pixel latency.**  
    Preserve AXI4-Stream video synchronization.

8.  **Provide bypass and mask-output modes.**  
    These simplify bring-up and verification.

## 15.27 Chapter Summary

This chapter described Local Dynamic Threshold Segmentation for the FPGA Video Color Processing System. The module compares a center pixel with neighboring pixels, checks whether local differences are within a programmable threshold, and either averages similar pixels or preserves the original pixel when the difference is too large.

The source document describes this module as checking neighboring pixels against threshold limits, averaging values within the threshold, and producing more uniform local regions. It also identifies a typical threshold of 10 for pixel values in the 0–255 range.

A reliable FPGA implementation requires line buffers, a local window generator, absolute-difference logic, threshold comparators, accepted-pixel accumulation, reciprocal-based averaging, output selection, border handling, and AXI4-Stream sideband alignment. This provides an edge-preserving local smoothing and segmentation capability suitable for real-time video processing.
