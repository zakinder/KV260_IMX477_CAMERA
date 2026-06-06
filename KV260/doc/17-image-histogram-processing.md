# Chapter 17 — Image Histogram Processing

## 17.1 Overview

**Image histogram processing** is used to measure how frequently pixel intensity values occur in an image or video frame. In the FPGA Video Color Processing System, the histogram module analyzes incoming RGB pixel data and accumulates counts for pixel-value levels.

The source design identifies an **Image Histogram** module with image-width, image-height, clock, reset, coordinate, input RGB channel, and output RGB channel signals. It also describes the histogram function as assigning memory locations based on an RGB red-channel input value between **0 and 255**, where each value represents one of **256 addressable levels**, and each input hit increments the count at that level.

At a high level, the histogram processing flow is:

Input RGB Stream

↓

Channel Selection / Intensity Extraction

↓

Histogram Bin Address Generation

↓

Bin Counter Read

↓

Counter Increment

↓

Bin Counter Writeback

↓

Histogram Readout / Visualization / Analysis

The histogram block provides a statistical view of image intensity distribution and can support contrast analysis, exposure evaluation, threshold selection, segmentation, and diagnostic visualization.

## 17.2 Purpose of Image Histogram Processing

A histogram converts image pixel values into a frequency distribution. For 8-bit pixel values, the histogram contains **256 bins**, one bin for each possible intensity value from 0 to 255.

Histogram processing supports:

| **Purpose**           | **Description**                                                     |
|-----------------------|---------------------------------------------------------------------|
| Brightness analysis   | Determines whether the image is dark, bright, or balanced.          |
| Contrast analysis     | Measures whether pixel values are spread widely or concentrated.    |
| Exposure checking     | Detects underexposure or overexposure.                              |
| Threshold selection   | Helps choose segmentation thresholds.                               |
| Image enhancement     | Supports contrast stretching and equalization methods.              |
| Debugging             | Shows whether RGB channels and pixel values are valid.              |
| Real-time diagnostics | Allows software to monitor image statistics during video operation. |

A histogram does not change the image by itself. It provides measurement data that other processing stages can use.

## 17.3 Histogram Bin Concept

A histogram bin is a memory location that stores the number of pixels having a specific value.

For an 8-bit channel:

Pixel value range = 0 to 255

Number of bins = 256

The bin address is the pixel value:

bin_address = pixel_value

The bin update is:

histogram\[bin_address\] = histogram\[bin_address\] + 1

For example:

| **Pixel Value** | **Histogram Action** |
|-----------------|----------------------|
| 0               | Increment bin 0      |
| 15              | Increment bin 15     |
| 128             | Increment bin 128    |
| 255             | Increment bin 255    |

The source design follows this model by mapping the red-channel integer value from 0 to 255 into 256 histogram memory locations.

## 17.4 Histogram Module Interface

A generalized image histogram module interface is:

| **Signal / Parameter** | **Description**                                                |
|------------------------|----------------------------------------------------------------|
| img_width              | Active image width.                                            |
| img_height             | Active image height.                                           |
| clk                    | Processing clock.                                              |
| reset                  | Reset signal.                                                  |
| txCord                 | Pixel coordinate input.                                        |
| iRgb                   | Input RGB pixel channel.                                       |
| oRgb                   | Optional output RGB channel for pass-through or visualization. |

The source document lists these exact structural elements for the histogram module: img_width, img_height, clk, reset, coord txCord, channel iRgb, and oRgb channel.

The histogram module may operate as a **measurement-only block** or as a **video pass-through block with histogram sideband statistics**.

## 17.5 Histogram Processing Modes

The histogram module may support several processing modes.

| **Mode**                  | **Description**                                        |
|---------------------------|--------------------------------------------------------|
| Red-channel histogram     | Counts red-channel values only.                        |
| Green-channel histogram   | Counts green-channel values only.                      |
| Blue-channel histogram    | Counts blue-channel values only.                       |
| Grayscale histogram       | Converts RGB to intensity and counts intensity values. |
| Luminance histogram       | Uses weighted RGB luminance approximation.             |
| Combined RGB histogram    | Accumulates all channel values into one distribution.  |
| Per-channel RGB histogram | Maintains separate red, green, and blue histograms.    |

The source design explicitly describes red-channel histogram addressing, but the same architecture can be extended to green, blue, grayscale, or luminance histograms.

## 17.6 Red-Channel Histogram

A red-channel histogram counts how often each red-channel value appears in the frame.

red_value = iRgb.red

hist_red\[red_value\] = hist_red\[red_value\] + 1

For 8-bit red:

red_value ∈ \[0, 255\]

hist_red contains 256 bins

This is useful for:

- Red-channel exposure checking.

- Sensor channel debugging.

- Color-balance analysis.

- Detecting red-channel clipping.

- Supporting white-balance tuning.

## 17.7 Green-Channel Histogram

A green-channel histogram counts green intensity values.

green_value = iRgb.green

hist_green\[green_value\] = hist_green\[green_value\] + 1

The green channel is often useful for luminance-related analysis because green commonly contributes strongly to perceived brightness.

Green histograms can help detect:

- Excessive green tint.

- Green-channel clipping.

- Sensor imbalance.

- Exposure problems.

## 17.8 Blue-Channel Histogram

A blue-channel histogram counts blue intensity values.

blue_value = iRgb.blue

hist_blue\[blue_value\] = hist_blue\[blue_value\] + 1

Blue-channel statistics are useful for:

- Cool-lighting analysis.

- White-balance correction.

- Detecting blue-channel clipping.

- Verifying RGB channel alignment.

## 17.9 Grayscale or Luminance Histogram

A grayscale histogram reduces RGB to a single intensity value before counting.

A hardware-friendly grayscale approximation is:

gray = (R + 2G + B) \>\> 2

A more perceptual luminance approximation is:

Y ≈ 0.299R + 0.587G + 0.114B

For FPGA logic, the shift-add approximation is usually efficient:

gray = (R + (G \<\< 1) + B) \>\> 2

Then:

hist_gray\[gray\] = hist_gray\[gray\] + 1

This mode is useful for brightness, contrast, thresholding, and exposure analysis.

## 17.10 Histogram Counter Width

Histogram counter width must be large enough to count all pixels in one frame.

The maximum count in a single bin can theoretically equal the total number of pixels in the frame:

max_bin_count = img_width × img_height

Required counter bits:

counter_width = ceil(log2(img_width × img_height + 1))

Example counter widths:

| **Resolution** | **Pixels Per Frame** | **Minimum Counter Width** |
|----------------|----------------------|---------------------------|
| 640×480        | 307,200              | 19 bits                   |
| 1280×720       | 921,600              | 20 bits                   |
| 1920×1080      | 2,073,600            | 21 bits                   |
| 3840×2160      | 8,294,400            | 23 bits                   |
| 4056×3040      | 12,330,240           | 24 bits                   |

A 32-bit counter is often used for simplicity and software readback alignment.

## 17.11 Histogram Memory Architecture

A 256-bin 8-bit histogram requires memory for 256 counters. The memory depth is determined by the number of bins. The width is determined by the counter width.

memory_depth = 256

memory_width = counter_width

For three separate RGB histograms:

total_memory = 3 × 256 × counter_width

A 32-bit counter implementation requires:

single-channel histogram = 256 × 32 = 8192 bits

RGB histogram = 3 × 256 × 32 = 24576 bits

Histogram counters may be implemented using:

| **Resource**    | **Use Case**                                 |
|-----------------|----------------------------------------------|
| Distributed RAM | Small histograms and low-resource designs    |
| BRAM            | Multi-channel histograms and larger counters |
| Registers       | Very small or low-latency debug histograms   |
| Dual-port RAM   | Simultaneous update and readout              |
| Ping-pong banks | Frame-safe software readout                  |

## 17.12 Read-Modify-Write Challenge

Histogram update requires reading the current bin value, incrementing it, and writing it back.

old_count = histogram\[pixel_value\]

new_count = old_count + 1

histogram\[pixel_value\] = new_count

This is a **read-modify-write** operation.

In a one-pixel-per-clock stream, back-to-back pixels may address the same bin. This creates a write-after-read hazard.

Example:

Pixel N = 100

Pixel N + 1 = 100

The second update must see the result of the first update. If not handled correctly, one count may be lost.

## 17.13 Hazard Handling for Consecutive Same-Bin Updates

A robust histogram design should handle consecutive pixels with identical bin addresses.

Possible methods:

| **Method**          | **Description**                                                |
|---------------------|----------------------------------------------------------------|
| Forwarding / bypass | If current bin equals previous bin, forward incremented count. |
| Pipeline stall      | Pause one cycle when a collision occurs.                       |
| Multi-bank memory   | Split bins across banks to reduce collision frequency.         |
| Accumulation cache  | Temporarily accumulate repeated values before writing memory.  |
| Frame buffering     | Compute histogram offline after frame storage.                 |

For real-time streaming, forwarding or small accumulation-cache logic is preferred.

### 17.13.1 Forwarding Example

if current_bin == previous_bin:

old_count = previous_new_count

else:

old_count = histogram\[current_bin\]

new_count = old_count + 1

This preserves correct counts without stalling the video stream.

## 17.14 Frame-Based Histogram Operation

A histogram is normally calculated over one complete frame. At the start of each frame, the active histogram counters should be cleared or a new bank should be selected.

A frame-based sequence is:

Start of Frame

↓

Clear histogram or select empty bank

↓

Accumulate bin counts for active pixels

↓

End of Frame

↓

Freeze completed histogram

↓

Software readout or visualization

The frame counter and pixel coordinates help identify when histogram accumulation should start and stop.

## 17.15 Clear Strategy

Histogram memory must be cleared before accumulating a new frame.

### 17.15.1 Full Clear at Frame Start

Clear all bins at the beginning of each frame:

for bin in 0 to 255:

histogram\[bin\] = 0

This requires 256 clear cycles for a single-channel histogram. If the video stream cannot wait, clearing must occur in a separate bank.

### 17.15.2 Ping-Pong Histogram Banks

Use two histogram banks:

Bank A accumulates current frame.

Bank B is read and cleared by software/control logic.

At frame boundary, swap banks:

active_bank \<= inactive_bank

inactive_bank \<= previous_active_bank

This avoids interrupting the live video stream.

## 17.16 Ping-Pong Histogram Architecture

A ping-pong histogram architecture is recommended for real-time video.

Frame N:

Active accumulation bank = A

Software read bank = B

Frame N+1:

Active accumulation bank = B

Software read bank = A

Advantages:

- No need to stall video while software reads histogram.

- Software receives a complete frame histogram.

- Current frame accumulation is isolated from previous frame readout.

- Clear operation can occur on the inactive bank.

## 17.17 Histogram Readout

Software can read histogram data through AXI4-Lite or AXI memory-mapped access.

A simple readout model is:

write HIST_INDEX = bin_number

read HIST_COUNT = histogram\[bin_number\]

For RGB histograms, add channel selection:

write HIST_CHANNEL = RED / GREEN / BLUE / GRAY

write HIST_INDEX = bin_number

read HIST_COUNT = selected_histogram\[bin_number\]

A burst-capable AXI memory-mapped interface can improve readout efficiency if full histogram transfer is required every frame.

## 17.18 Histogram Visualization

Histogram data can be converted into a visual overlay or standalone display. A histogram visualization module maps bin counts to vertical bar heights.

For an 8-bit histogram:

x_coordinate = histogram bin index

bar_height = scaled histogram count

Output pixel rule:

if y_coordinate \>= display_height - bar_height:

output = histogram_bar_color

else:

output = background_color

The source document references images showing RGB input and separated red, green, and blue channels in the section following histogram content.

## 17.19 Histogram-Based Threshold Selection

Histogram data can guide threshold selection for segmentation. For example, a grayscale histogram may show two peaks: one for background and one for foreground.

A simple threshold can be selected between peaks:

threshold = valley_between_two_histogram_peaks

This threshold can be used by:

- Local dynamic threshold segmentation.

- Binary mask generation.

- Edge filtering.

- Object detection.

- Brightness classification.

In hardware, threshold selection may be done by software after reading the histogram, or by a dedicated hardware peak/valley detector.

## 17.20 Histogram-Based Contrast Analysis

A histogram can identify low-contrast and high-contrast images.

**Low Contrast**

Most bins are concentrated in a narrow range:

pixel values mostly between 90 and 140

**High Contrast**

Pixel values are spread across a wider range:

pixel values distributed from 0 to 255

This information can control:

- Contrast gain.

- Brightness offset.

- Color correction parameters.

- Auto-exposure support.

- Adaptive threshold settings.

## 17.21 Histogram Equalization Concept

Histogram equalization redistributes pixel values to improve contrast. A complete implementation requires cumulative histogram calculation.

Steps:

1\. Build histogram.

2\. Compute cumulative distribution function.

3\. Normalize cumulative values.

4\. Map input pixels through equalization table.

The cumulative distribution function is:

CDF\[i\] = histogram\[0\] + histogram\[1\] + ... + histogram\[i\]

Equalized output:

output = CDF\[input_value\] × max_value / total_pixels

This is more complex than basic histogram counting and typically requires a frame-delayed processing strategy.

## 17.22 AXI4-Stream Integration

The histogram block can be inserted in the AXI4-Stream video path as a pass-through measurement block:

s_axis_tdata

↓

RGB Unpack

↓

Histogram Update

↓

RGB Pack / Pass-Through

↓

m_axis_tdata

The output stream may be identical to the input stream while histogram counters update in parallel.

Required stream behavior:

| **Signal** | **Handling**                                         |
|------------|------------------------------------------------------|
| TVALID     | Histogram updates only when input transfer is valid. |
| TREADY     | Must respect downstream backpressure.                |
| TUSER      | Used to identify start of frame.                     |
| TLAST      | Used to identify end of line.                        |
| TDATA      | Carries RGB pixel data.                              |

Histogram updates should occur only when:

pixel_transfer = TVALID AND TREADY

## 17.23 Coordinate-Based Histogram Control

The histogram module includes a coordinate input in the source design. Pixel coordinates allow the module to restrict histogram calculation to selected regions.

Examples:

| **Region Mode**    | **Description**                                 |
|--------------------|-------------------------------------------------|
| Full frame         | Count all active pixels.                        |
| Region of interest | Count pixels only inside a selected rectangle.  |
| Center window      | Count only central pixels for exposure control. |
| Exclusion zone     | Ignore overlay or border areas.                 |
| Debug region       | Analyze a selected area for verification.       |

Example ROI condition:

if x \>= roi_x0 and x \<= roi_x1 and y \>= roi_y0 and y \<= roi_y1:

update_histogram = 1

else:

update_histogram = 0

## 17.24 Register-Level Control

A representative histogram register map is:

| **Register**      | **Function**                                        |
|-------------------|-----------------------------------------------------|
| HIST_CONTROL      | Enable, reset, clear, mode selection                |
| HIST_STATUS       | Active bank, frame done, overflow flags             |
| HIST_MODE         | Red, green, blue, grayscale, luminance, RGB mode    |
| HIST_ACTIVE_BANK  | Current accumulation bank                           |
| HIST_READ_BANK    | Completed bank available for readout                |
| HIST_INDEX        | Selected bin index for readback                     |
| HIST_COUNT        | Count value for selected bin                        |
| HIST_CHANNEL      | Selects red, green, blue, or gray histogram         |
| HIST_ROI_X0       | Region-of-interest start x                          |
| HIST_ROI_Y0       | Region-of-interest start y                          |
| HIST_ROI_X1       | Region-of-interest end x                            |
| HIST_ROI_Y1       | Region-of-interest end y                            |
| HIST_FRAME_COUNT  | Number of frames accumulated                        |
| HIST_ERROR_STATUS | Counter overflow, invalid mode, read/write conflict |

The register interface allows software to configure histogram behavior and read statistical results.

## 17.25 Counter Overflow Protection

Histogram counters must not overflow during a frame. A counter overflow can corrupt statistical interpretation.

Overflow protection methods include:

| **Method**          | **Description**                                |
|---------------------|------------------------------------------------|
| Wider counters      | Use enough bits for full-frame count.          |
| Saturating counters | Stop at maximum value instead of wrapping.     |
| Overflow flag       | Report if any bin exceeds counter capacity.    |
| Frame-size limit    | Validate width and height before accumulation. |

A saturating counter behaves as:

if count \< MAX_COUNT:

count = count + 1

else:

count = MAX_COUNT

overflow_flag = 1

## 17.26 Verification Strategy

### 17.26.1 Directed Pixel Tests

Use controlled pixel streams.

Example:

Input red values:

10, 10, 20, 20, 20, 255

Expected histogram:

bin\[10\] = 2

bin\[20\] = 3

bin\[255\] = 1

### 17.26.2 Frame Tests

Use test images:

| **Test Image** | **Expected Histogram**             |
|----------------|------------------------------------|
| Solid black    | Bin 0 equals total pixels          |
| Solid white    | Bin 255 equals total pixels        |
| Gray ramp      | Uniform or known ramp distribution |
| Checkerboard   | Two dominant bins                  |
| Color bars     | Known channel distributions        |
| Natural image  | Broad distribution                 |

### 17.26.3 Protocol Tests

Verify:

- Histogram updates only on valid transfers.

- Counters clear at frame boundary.

- Completed histogram can be read while next frame accumulates.

- Same-bin consecutive pixels are counted correctly.

- ROI selection works.

- Counter overflow flag works.

- Reset clears state.

## 17.27 Common Failure Modes

| **Failure Mode**             | **Likely Cause**                           | **Correction**                        |
|------------------------------|--------------------------------------------|---------------------------------------|
| Counts too low               | Read-modify-write hazard                   | Add forwarding or accumulation cache  |
| Counts too high              | Counting during blanking or invalid pixels | Gate updates with valid transfer      |
| Histogram not cleared        | Clear sequence failed                      | Use frame-bank swap or explicit clear |
| Software reads changing data | No ping-pong bank                          | Use completed read bank               |
| Wrong channel counted        | Incorrect channel selector                 | Verify RGB unpacking                  |
| Counter wraparound           | Counter width too small                    | Increase width or saturate            |
| ROI count incorrect          | Coordinate mismatch                        | Align coordinates with pixel latency  |
| Histogram shifted            | Pixel value truncation or wrong bit slice  | Verify channel bit mapping            |

## 17.28 Hardware Design Recommendations

1.  **Use 256 bins for 8-bit histogram processing.**  
    This directly maps pixel values to bin addresses.

2.  **Use enough counter width for the maximum frame size.**  
    A 32-bit counter is practical for software alignment.

3.  **Implement read-modify-write hazard handling.**  
    Consecutive same-bin pixels must not lose counts.

4.  **Use ping-pong banks for real-time readout.**  
    One bank accumulates while the other is read or cleared.

5.  **Update counters only on valid pixel transfers.**  
    Do not count blanking or invalid stream cycles.

6.  **Support grayscale and per-channel RGB modes.**  
    This improves diagnostic and enhancement flexibility.

7.  **Use coordinate-based ROI support.**  
    ROI histograms are useful for exposure and object-specific analysis.

8.  **Expose software-readable registers.**  
    Histogram results are most useful when software can inspect or act on them.

## 17.29 Chapter Summary

This chapter described Image Histogram Processing for the FPGA Video Color Processing System. The histogram module counts how many times each pixel value occurs within a frame. For 8-bit channel data, this creates 256 bins addressed by pixel values from 0 to 255.

The source design identifies the histogram module interface with image dimensions, clock, reset, coordinate input, RGB input channel, and RGB output channel. It also states that the module assigns memory locations based on red-channel values from 0 to 255 and accumulates hits per level.

A reliable FPGA histogram implementation requires valid-pixel gating, bin memory, read-modify-write hazard handling, frame-based clearing, ping-pong banks, software readout, counter overflow protection, optional ROI control, and AXI4-Stream timing compliance. This makes histogram processing a useful diagnostic and adaptive-control feature for real-time video pipelines.
