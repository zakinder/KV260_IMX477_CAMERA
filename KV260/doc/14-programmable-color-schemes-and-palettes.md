# Chapter 14 — Programmable Color Schemes and Palettes

## 14.1 Overview

Programmable color schemes and palettes provide a controlled method for mapping input pixels, cluster labels, segmentation results, or processed color values into defined output colors. In the FPGA Video Color Processing System, palettes are closely related to K-means color clustering because the reference colors used for clustering form a **color palette** or **reference color scheme**. The source document states that the K-means codebook is called the **color palette** or **reference color scheme**.

A programmable palette allows the system to replace a large RGB color space with a smaller, controlled set of output colors.

Input RGB Pixel / Cluster Index / Segmentation Result

↓

Palette Lookup

↓

Selected RGB Output Color

↓

AXI4-Stream Output

This chapter describes the architecture, control model, memory structure, update strategy, verification approach, and hardware implementation considerations for programmable color schemes and palettes.

## 14.2 Purpose of Programmable Color Schemes

Programmable color schemes allow the video-processing system to generate consistent, controlled, and application-specific color output. Instead of displaying the raw RGB pixel values, the system can map pixels into predefined colors.

Programmable palettes support:

| **Purpose**              | **Description**                                                                |
|--------------------------|--------------------------------------------------------------------------------|
| Color quantization       | Reduces millions of RGB colors into a smaller number of palette colors.        |
| Segmentation display     | Assigns distinct colors to detected regions or classes.                        |
| K-means output mapping   | Converts nearest-cluster decisions into representative RGB colors.             |
| Diagnostic visualization | Displays internal algorithm states as visible colors.                          |
| Artistic transformation  | Produces stylized or simplified video output.                                  |
| Runtime adaptation       | Allows software to change the color scheme without rebuilding the FPGA design. |
| Object highlighting      | Maps selected regions or thresholds to high-visibility colors.                 |

The programmable palette is especially useful when the system must classify or simplify video while preserving real-time operation.

## 14.3 Relationship Between Palettes and K-Means Clustering

In K-means color clustering, each reference color acts as a cluster representative. The input pixel is compared with each reference color, and the closest reference color becomes the output.

The source document describes the clustering goal as reducing a 24-bit RGB image into an n-color version, where n is the number of clusters.

The palette therefore serves two roles:

1.  **Distance reference table**  
    The palette defines the RGB values used for distance comparison.

2.  **Output color table**  
    The palette defines the RGB values written to the output stream after cluster selection.

The simplest architecture uses the same table for both roles:

Reference Color\[k\] = Output Color\[k\]

A more flexible architecture uses separate tables:

Distance Reference Palette\[k\] → Cluster Index\[k\]

Cluster Index\[k\] → Output Display Palette\[k\]

This allows the system to classify pixels using one set of reference colors while displaying them using another set of diagnostic or symbolic colors.

## 14.4 Palette Data Structure

A palette is a table of RGB entries. Each entry contains red, green, and blue channel values.

Palette\[k\] = {Red\[k\], Green\[k\], Blue\[k\]}

For 8-bit RGB:

Red\[k\] ∈ \[0, 255\]

Green\[k\] ∈ \[0, 255\]

Blue\[k\] ∈ \[0, 255\]

A representative palette table is:

| **Index** | **Red** | **Green** | **Blue** |
|-----------|---------|-----------|----------|
| 0         | R0      | G0        | B0       |
| 1         | R1      | G1        | B1       |
| 2         | R2      | G2        | B2       |
| ...       | ...     | ...       | ...      |
| K-1       | RK-1    | GK-1      | BK-1     |

The source document gives an example K = 6 reference color scheme containing six RGB entries.

## 14.5 Example K = 6 Palette

A six-color palette reduces the output image to six representative colors. The source document lists the following example K = 6 reference color scheme:

1: Red=230, Green=170, Blue=120

2: Red=70, Green=40, Blue=35

3: Red=150, Green=200, Blue=130

4: Red=20, Green=25, Blue=10

5: Red=75, Green=150, Blue=180

6: Red=15, Green=30, Blue=60

This palette is used to generate a K-means clustered image using six reference colors.

A small palette such as K = 6 produces strong simplification. It is useful for early testing, segmentation visualization, and demonstrating color quantization.

## 14.6 Supported Palette Sizes

The system may support several predefined palette sizes. The source document identifies reference-color configurations for K = 6, K = 9, K = 24, K = 51, and K = 90.

| **Palette Size** | **Description**    | **Expected Result**         |
|------------------|--------------------|-----------------------------|
| K = 6            | Very small palette | Strong color simplification |
| K = 9            | Small palette      | Basic color-region mapping  |
| K = 24           | Medium palette     | Better scene detail         |
| K = 51           | Large palette      | Higher color fidelity       |
| K = 90           | Very large palette | Fine-grained quantization   |

Increasing the palette size improves visual detail but increases storage, comparison, and routing requirements.

## 14.7 Programmable Palette Architecture

A programmable palette block contains memory or registers that store color entries. These entries can be selected by a cluster index, threshold result, region label, or direct software control.

Cluster Index

↓

Palette Address

↓

Palette Memory

↓

RGB Output Entry

A typical palette lookup operation is:

Rout = palette_red\[index\]

Gout = palette_green\[index\]

Bout = palette_blue\[index\]

The palette memory can be implemented using:

| **Storage Type**      | **Best Use**                                    |
|-----------------------|-------------------------------------------------|
| Constant ROM          | Fixed palettes known at synthesis time          |
| AXI4-Lite registers   | Small programmable palettes                     |
| LUTRAM                | Medium palettes with low latency                |
| BRAM                  | Larger palettes such as K = 51 or K = 90        |
| Dual-bank memory      | Runtime updates without corrupting active video |
| Distributed registers | Very small, high-speed palettes                 |

## 14.8 Palette Lookup Pipeline

The palette lookup pipeline should be deterministic and stream-compatible.

A typical pipeline is:

Input Pixel / Cluster Index

↓

Index Register

↓

Palette Address Decode

↓

Palette Memory Read

↓

RGB Output Register

↓

AXI4-Stream Output

A representative pipeline table is:

| **Stage** | **Function**                                    |
|-----------|-------------------------------------------------|
| Stage 0   | Register cluster index or classification result |
| Stage 1   | Address palette memory                          |
| Stage 2   | Read RGB palette entry                          |
| Stage 3   | Clamp or validate RGB value                     |
| Stage 4   | Pack RGB output                                 |
| Stage 5   | Register output stream                          |

For BRAM-based palettes, the memory read normally adds at least one clock cycle of latency.

## 14.9 Palette Input Sources

The palette block can be driven by different input sources.

| **Input Source**              | **Palette Address Meaning**     |
|-------------------------------|---------------------------------|
| K-means cluster index         | Nearest reference color index   |
| Threshold segmentation result | Foreground/background class     |
| Sobel edge result             | Edge/non-edge state             |
| Local region label            | Region-class identifier         |
| Histogram classification      | Intensity or color bin          |
| Software test mode            | Directly selected palette index |
| Pixel coordinate mode         | Pattern or diagnostic index     |

This flexibility allows the same palette hardware to support multiple video-processing modes.

## 14.10 Direct RGB Palette Mapping

In direct RGB palette mapping, the input index directly selects an RGB output entry.

index = cluster_index

output_rgb = palette\[index\]

This mode is useful for K-means output, segmentation visualization, and diagnostic region display.

**Example**

cluster_index = 2

palette\[2\] = (150, 200, 130)

output = (150, 200, 130)

This produces a stable and repeatable color for every pixel assigned to cluster 2.

## 14.11 Range-Based Color Scheme Mapping

A programmable color scheme can also map pixel ranges into colors. Instead of using a cluster index, the system compares the input pixel against programmed thresholds.

Example grayscale range mapping:

| **Input Range** | **Output Color** |
|-----------------|------------------|
| 0–63            | Dark blue        |
| 64–127          | Green            |
| 128–191         | Yellow           |
| 192–255         | White            |

Hardware logic:

if gray \< threshold0:

output = palette\[0\]

else if gray \< threshold1:

output = palette\[1\]

else if gray \< threshold2:

output = palette\[2\]

else:

output = palette\[3\]

This mode is useful for thermal-style visualization, depth-like visualization, intensity classification, and threshold segmentation.

## 14.12 Channel-Based Color Scheme Mapping

A color scheme may use RGB channel dominance to choose output colors.

Example logic:

if R \> G and R \> B:

output = red_dominant_color

else if G \> R and G \> B:

output = green_dominant_color

else if B \> R and B \> G:

output = blue_dominant_color

else:

output = neutral_color

This produces symbolic color categories rather than continuous RGB output.

Channel-based mapping is useful for:

- Dominant-color classification.

- Basic object detection.

- Color-region highlighting.

- Debugging color-space conversion results.

## 14.13 Palette Output Modes

The palette block may support multiple output modes:

| **Mode** | **Description**                       |
|----------|---------------------------------------|
| 0        | Bypass original RGB                   |
| 1        | Output selected palette RGB           |
| 2        | Output cluster index as grayscale     |
| 3        | Output false-color diagnostic palette |
| 4        | Blend original RGB with palette RGB   |
| 5        | Output binary mask                    |
| 6        | Highlight selected classes only       |

### 14.13.1 Bypass Mode

Bypass mode passes the original RGB pixel through unchanged.

output = input_rgb

### 14.13.2 Palette RGB Mode

Palette mode outputs the selected RGB entry.

output = palette\[index\]

### 14.13.3 Cluster Index Grayscale Mode

The cluster index is scaled into grayscale:

gray = cluster_index × 255 / (K - 1)

output = (gray, gray, gray)

### 14.13.4 Blend Mode

Blend mode combines the original image with the palette output:

output = (alpha × input_rgb + (1-alpha) × palette_rgb)

In FPGA logic, alpha should be a fixed-point value.

## 14.14 Active and Shadow Palette Banks

Runtime palette updates can cause visual artifacts if software modifies palette entries while the video stream is using them. To avoid this, the design should use active and shadow palette banks.

Active Palette → Used by live video datapath

Shadow Palette → Written by software

Safe update flow:

Software writes new palette entries to shadow bank

↓

Software sets update request

↓

Hardware waits for start-of-frame

↓

Shadow palette copies or swaps into active bank

↓

Update-done flag is set

This ensures that a complete frame uses one consistent palette.

## 14.15 Palette Bank Swap Strategy

A bank swap is more efficient than copying all palette entries from shadow memory to active memory.

active_bank_select = 0 → Bank A used for video, Bank B updated by software

active_bank_select = 1 → Bank B used for video, Bank A updated by software

At frame boundary:

active_bank_select \<= pending_bank_select

This method provides:

- Fast update activation.

- No long copy operation.

- No partial-frame palette corruption.

- Clean frame-to-frame color changes.

## 14.16 AXI4-Lite Register Map Recommendation

A representative register map for programmable color schemes is:

| **Register**         | **Function**                                          |
|----------------------|-------------------------------------------------------|
| PALETTE_CONTROL      | Enable, bypass, update request, bank swap enable      |
| PALETTE_STATUS       | Active bank, update done, error flags                 |
| PALETTE_ACTIVE_K     | Active number of palette entries                      |
| PALETTE_PENDING_K    | Pending number of palette entries                     |
| PALETTE_MODE         | Output mode selection                                 |
| PALETTE_INDEX        | Selects palette entry for read/write                  |
| PALETTE_R            | Red value of selected entry                           |
| PALETTE_G            | Green value of selected entry                         |
| PALETTE_B            | Blue value of selected entry                          |
| PALETTE_THRESHOLD_0  | Optional range threshold                              |
| PALETTE_THRESHOLD_1  | Optional range threshold                              |
| PALETTE_THRESHOLD_2  | Optional range threshold                              |
| PALETTE_UPDATE_REQ   | Requests shadow-to-active update                      |
| PALETTE_UPDATE_DONE  | Confirms update activation                            |
| PALETTE_ERROR_STATUS | Invalid index, invalid K, write conflict, range error |

All programmable color values should be clamped or validated before being used by the active video datapath.

## 14.17 Palette Entry Format

A compact palette entry may use 24 bits:

palette_entry\[23:16\] = Red

palette_entry\[15:8\] = Green

palette_entry\[7:0\] = Blue

For 10-bit RGB, a 32-bit aligned entry is practical:

palette_entry\[31:30\] = Reserved

palette_entry\[29:20\] = Red

palette_entry\[19:10\] = Green

palette_entry\[9:0\] = Blue

Using a 32-bit entry simplifies AXI4-Lite programming and register alignment.

## 14.18 Palette Memory Sizing

Palette memory size depends on the number of entries and channel width.

For 8-bit RGB:

Memory bits = K × 24

For 10-bit RGB:

Memory bits = K × 30

Examples:

| **K** | **RGB888 Memory** | **RGB101010 Memory** |
|-------|-------------------|----------------------|
| 6     | 144 bits          | 180 bits             |
| 9     | 216 bits          | 270 bits             |
| 24    | 576 bits          | 720 bits             |
| 51    | 1,224 bits        | 1,530 bits           |
| 90    | 2,160 bits        | 2,700 bits           |

These memory sizes are small compared with full-frame buffers. The main hardware cost for large K is usually the distance-comparison logic, not the palette memory.

## 14.19 Palette Validation and Safety

Programmable palette logic should include validation checks.

Recommended checks:

| **Check**                | **Purpose**                                        |
|--------------------------|----------------------------------------------------|
| Entry range check        | Ensures RGB values are within valid channel range. |
| Index range check        | Prevents writes beyond maximum palette depth.      |
| K range check            | Prevents invalid active cluster count.             |
| Update conflict check    | Prevents writing active bank during live use.      |
| CRC or checksum          | Optional integrity check for loaded palette.       |
| Default fallback palette | Provides safe output after reset or error.         |

A safe default palette should be loaded at reset. Identity or grayscale palettes are useful defaults.

## 14.20 Frame-Safe Palette Update

Palette changes should not become active in the middle of a frame. A frame-safe update sequence is:

1\. Software writes shadow palette entries.

2\. Software writes pending K value.

3\. Software sets update request.

4\. Hardware waits for start-of-frame.

5\. Hardware swaps active bank.

6\. Hardware clears update request.

7\. Hardware sets update-done status.

This prevents:

- Color flicker.

- Split-frame color mismatch.

- Partial palette corruption.

- Inconsistent cluster output.

## 14.21 Integration with K-Means Clustering

The palette block can be tightly integrated with the K-means block.

RGB Pixel

↓

Distance to Reference Palette Entries

↓

Minimum Distance Cluster Index

↓

Output Palette Lookup

↓

Clustered RGB Output

Two palette structures may be used:

| **Palette**       | **Function**                                |
|-------------------|---------------------------------------------|
| Reference palette | Used for nearest-color distance calculation |
| Output palette    | Used for final display color                |

Using separate reference and output palettes allows symbolic remapping. For example, similar skin-tone or vegetation colors may be classified using natural reference colors but displayed with high-contrast diagnostic colors.

## 14.22 Integration with Segmentation and Thresholding

Programmable palettes can also support local threshold segmentation and edge detection.

Example threshold map:

Class 0 = background color

Class 1 = foreground color

Class 2 = edge color

Class 3 = uncertain region color

Example Sobel map:

if edge_detected:

output = palette\[EDGE_CLASS\]

else:

output = original_rgb

Example local segmentation map:

if local_difference \< threshold:

output = palette\[SMOOTH_REGION\]

else:

output = palette\[DETAIL_REGION\]

The source document places “Programable Color Schemes” before the Video Controller Interface and Local Dynamic Threshold Segmentation sections, showing that palette-style output is part of the larger video-processing control and segmentation flow.

## 14.23 Throughput Requirement

The palette lookup must sustain the video pixel rate.

For one-pixel-per-clock video:

Palette throughput = 1 lookup per clock

To achieve this:

- Palette memory must support one read per pixel clock.

- Output register must accept one result per clock.

- BRAM or LUTRAM read latency must be pipelined.

- Sideband signals must be delayed to match palette-read latency.

- Bank-swapping logic must not stall the active video datapath.

## 14.24 Latency and Sideband Alignment

A palette lookup introduces one or more cycles of latency. Therefore, stream control signals must be delayed by the same number of cycles.

Signals requiring alignment include:

- TVALID

- TUSER

- TLAST

- SOF

- EOL

- EOF

- Pixel coordinates

- Cluster index valid

Example:

Index pipeline: I0 → I1 → I2

Palette output: P1 → P2

TUSER pipeline: U0 → U1 → U2

TLAST pipeline: L0 → L1 → L2

TVALID pipeline: V0 → V1 → V2

If sideband alignment is incorrect, frame markers and line markers may no longer correspond to the correct output pixel.

## 14.25 Verification Strategy

Programmable color schemes should be verified at register level, pixel level, and full-frame level.

### 14.25.1 Register-Level Tests

Verify:

- Palette entries can be written.

- Palette entries can be read back.

- Active and shadow banks behave correctly.

- Update request is accepted.

- Update done flag is asserted at the correct frame boundary.

- Invalid index writes are rejected or flagged.

- Default palette loads correctly after reset.

### 14.25.2 Pixel-Level Tests

Use known index-to-color mappings:

palette\[0\] = red

palette\[1\] = green

palette\[2\] = blue

input index = 1

expected output = green

### 14.25.3 Full-Frame Tests

Use images and cluster maps to verify:

- Correct color replacement.

- No split-frame artifacts.

- No palette flicker.

- Correct cluster-to-color mapping.

- Correct output after bank swap.

- Correct behavior for K = 6, 9, 24, 51, and 90.

## 14.26 Common Failure Modes

| **Failure Mode**         | **Likely Cause**                            | **Correction**                             |
|--------------------------|---------------------------------------------|--------------------------------------------|
| Wrong colors displayed   | Incorrect palette index or RGB packing      | Verify entry format and address mapping    |
| Split-frame color change | Palette updated mid-frame                   | Use frame-safe bank swap                   |
| Output flicker           | Software writes active palette during video | Restrict writes to shadow bank             |
| Invalid color values     | Missing range check                         | Clamp or reject out-of-range values        |
| Cluster output mismatch  | Reference and output palettes misaligned    | Verify both palette tables                 |
| Frame marker shifted     | Sideband latency mismatch                   | Delay sideband signals with lookup latency |
| No palette effect        | Bypass mode active                          | Verify control register                    |
| BRAM read wrong entry    | Address pipeline not aligned                | Register index and sideband together       |

## 14.27 Hardware Design Recommendations

1.  **Use active/shadow palette banks.**  
    This prevents live-video artifacts during palette updates.

2.  **Use frame-boundary activation.**  
    Apply new palettes only at start-of-frame.

3.  **Separate reference and output palettes when flexibility is required.**  
    This supports symbolic remapping and diagnostic visualization.

4.  **Use 32-bit aligned palette entries for AXI4-Lite programming.**  
    This simplifies software control.

5.  **Validate palette indices and K values.**  
    Prevent memory overrun and invalid lookup behavior.

6.  **Pipeline palette memory reads.**  
    Preserve one-pixel-per-clock throughput.

7.  **Delay sideband signals to match lookup latency.**  
    Keep output pixels aligned with frame and line markers.

8.  **Provide a default safe palette.**  
    Reset behavior should produce valid and predictable output.

## 14.28 Chapter Summary

This chapter described programmable color schemes and palettes for the FPGA Video Color Processing System. A palette is a table of RGB entries used to map cluster indices, segmentation classes, threshold results, or diagnostic states into output colors. The source document identifies the K-means codebook as a color palette or reference color scheme and shows palette-based clustering examples, including K = 6, K = 9, K = 24, K = 51, and K = 90 reference-color modes.

A robust programmable palette implementation should use structured RGB entries, AXI4-Lite control registers, active/shadow memory banks, frame-safe updates, sideband alignment, and validation logic. When integrated with K-means clustering, segmentation, or diagnostic output modes, programmable palettes provide a flexible method for real-time color quantization, symbolic visualization, and adaptive video color control.
