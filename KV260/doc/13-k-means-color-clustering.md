# Chapter 13 — K-Means Color Clustering

## 13.1 Overview

**K-Means Color Clustering** is a color-quantization method that reduces a full RGB image into a smaller set of representative colors. In the FPGA Video Color Processing System, K-means clustering is implemented as a real-time streaming module that receives RGB pixels, compares each pixel against a set of reference colors, and outputs the nearest clustered color.

The source document identifies K-Means Color Clustering as a supported Video Color Processing function and states that the custom VCP module applies filters, color-space conversion, and K-means color clusters.

At a high level, the K-means hardware path is:

Input RGB Pixel

↓

Reference Color / Palette Table

↓

Distance Calculation

↓

Minimum Distance Selection

↓

Cluster Assignment

↓

Clustered RGB Output

The output image contains fewer colors than the original image while preserving the closest available palette representation.

## 13.2 Purpose of K-Means Color Clustering

K-means clustering is used to simplify image color complexity. A normal 24-bit RGB image can represent:

256 × 256 × 256 = 16,777,216 colors

The K-means clustering block reduces this large color space into **K representative colors**. If K = 6, the image is reduced to six output colors. If K = 24, the image is reduced to 24 output colors. If K = 90, the image is reduced to 90 output colors.

The source document states that an RGB image with 24-bit color depth contains about 16 million colors, and after K-means clustering with value n, the image is converted into a version with n colors.

The clustering block supports:

| **Purpose**                      | **Description**                                         |
|----------------------------------|---------------------------------------------------------|
| Color quantization               | Reduces image colors to a smaller palette.              |
| Segmentation                     | Groups visually similar pixels into color classes.      |
| Visualization                    | Produces simplified color-region output.                |
| Compression support              | Reduces color diversity before storage or transmission. |
| Object grouping                  | Groups regions with similar color characteristics.      |
| Hardware-friendly classification | Converts complex RGB space into limited output states.  |

## 13.3 K-Means Clustering Concept

In standard K-means clustering, each cluster is represented by a **centroid**. In this implementation, the centroids are treated as predefined RGB reference colors or palette entries.

Each reference color is represented as:

Centroid\[k\] = (Rk, Gk, Bk)

Each input pixel is represented as:

Pixel = (Rin, Gin, Bin)

The clustering module compares the input pixel against all reference colors and selects the closest reference color.

Cluster Index = argmin distance(Pixel, Centroid\[k\])

The selected cluster can then output:

- The nearest reference color.

- The cluster index.

- A palette-mapped color.

- A symbolic segmentation color.

- A diagnostic label.

## 13.4 K Parameter

The value **K** defines the number of clusters or reference colors.

K = number of reference colors

The source document describes several reference-color configurations, including K = 6, K = 9, K = 24, K = 51, and K = 90.

A practical K selection table is:

| **K Value** | **Description**     | **Typical Use**                 |
|-------------|---------------------|---------------------------------|
| 6           | Very small palette  | Strong color simplification     |
| 9           | Small palette       | Basic region grouping           |
| 24          | Medium palette      | Better visual detail            |
| 51          | Large palette       | More accurate color retention   |
| 90          | High-detail palette | Fine-grained color quantization |

Increasing K improves color detail but increases hardware cost because more distances must be calculated and compared.

## 13.5 Reference Color Scheme / Palette

The set of K reference colors is also called a **codebook**, **color palette**, or **reference color scheme**. The source document states that the codebook created for K-means is called the color palette or reference color scheme.

A reference color table has this form:

Index Red Green Blue

0 R0 G0 B0

1 R1 G1 B1

2 R2 G2 B2

...

K-1 RK-1 GK-1 BK-1

For example, the source document lists a K = 6 reference color scheme with six RGB entries.

A palette table may be stored in:

| **Storage Type**           | **Use Case**                                      |
|----------------------------|---------------------------------------------------|
| Registers                  | Small K values and software-programmable palettes |
| LUTRAM                     | Moderate K values                                 |
| BRAM                       | Larger palettes such as K = 51 or K = 90          |
| ROM                        | Fixed palettes known at synthesis time            |
| Shadow/active memory banks | Runtime palette update without frame corruption   |

## 13.6 Module Interface

The source design describes the K-means image segment as an FPGA module using a standard Xilinx AXI4-Stream style interface so that it can be inserted into an image-processing pipeline. It identifies the module interface as including i_data_width, clk, reset, input RGB channel, and output RGB channel.

### 13.6.1 Input Interface

| **Signal** | **Description**                        |
|------------|----------------------------------------|
| clk        | Reference clock for stream processing. |
| reset      | Module reset signal.                   |
| iRgb.red   | Input red channel.                     |
| iRgb.green | Input green channel.                   |
| iRgb.blue  | Input blue channel.                    |
| iRgb.valid | Indicates valid input pixel.           |
| iRgb.sof   | Start-of-frame marker.                 |
| iRgb.eol   | End-of-line marker.                    |
| iRgb.eof   | End-of-frame marker.                   |

The source document states that the stream must present RGB input data and control signals including valid, end-of-line, end-of-frame, and start-of-frame.

### 13.6.2 Output Interface

| **Signal** | **Description**                         |
|------------|-----------------------------------------|
| oRgb.red   | Clustered red output value.             |
| oRgb.green | Clustered green output value.           |
| oRgb.blue  | Clustered blue output value.            |
| oRgb.valid | Indicates valid clustered output pixel. |

The source document describes output channels as 8-bit clustered red, green, and blue values with a valid signal.

## 13.7 AXI4-Stream Integration

A practical AXI4-Stream wrapper maps the clustering logic to the video stream as follows:

s_axis_tdata

↓

RGB Unpack

↓

K-Means Cluster Core

↓

Clustered RGB Pack

↓

m_axis_tdata

Sideband and control mapping:

s_axis_tvalid → valid delay pipeline → m_axis_tvalid

s_axis_tuser → sideband delay → m_axis_tuser

s_axis_tlast → sideband delay → m_axis_tlast

s_axis_tready ← flow-control logic

The wrapper must preserve:

- Pixel order.

- Frame-start alignment.

- End-of-line alignment.

- Valid-pixel timing.

- Reset behavior.

- Backpressure behavior.

## 13.8 Distance Calculation

The core operation of K-means clustering is distance calculation. The source document describes the algorithm as finding the distance between each input pixel and selected RGB K points, then assigning the new pixel to the closest selected RGB value.

### 13.8.1 Euclidean Distance

The source document states that Euclidean distance is calculated between the original image pixel and the reference pixel color schemes.

The Euclidean distance is:

Dk = sqrt((Rin - Rk)² + (Gin - Gk)² + (Bin - Bk)²)

For minimum comparison, the square root is not required because the smallest squared distance also produces the smallest distance:

Dk_squared = (Rin - Rk)² + (Gin - Gk)² + (Bin - Bk)²

This form is more hardware-friendly than computing the square root.

### 13.8.2 Manhattan Distance

A lower-cost alternative is Manhattan distance:

Dk = \|Rin - Rk\| + \|Gin - Gk\| + \|Bin - Bk\|

Manhattan distance avoids multipliers and square-root logic. It is efficient for FPGA implementations and is often suitable when approximate color similarity is acceptable.

### 13.8.3 Distance Metric Selection

| **Metric**                 | **Hardware Cost** | **Accuracy / Behavior**               |
|----------------------------|-------------------|---------------------------------------|
| Euclidean squared          | Medium to high    | Strong geometric color-distance model |
| Euclidean with square root | High              | Usually unnecessary for comparison    |
| Manhattan                  | Low               | Efficient and deterministic           |
| Weighted Manhattan         | Low to medium     | Allows channel importance weighting   |
| Max-channel distance       | Very low          | Coarse approximation                  |

For high-throughput video, Euclidean squared or Manhattan distance is preferred.

## 13.9 Parallel Distance Engine

To process one pixel per clock, the K-means block can calculate distances to multiple reference colors in parallel.

For K reference colors:

Distance\[0\] = distance(Pixel, Centroid\[0\])

Distance\[1\] = distance(Pixel, Centroid\[1\])

Distance\[2\] = distance(Pixel, Centroid\[2\])

...

Distance\[K-1\] = distance(Pixel, Centroid\[K-1\])

A fully parallel engine has:

| **Component**             | **Count** |
|---------------------------|-----------|
| Reference color inputs    | K         |
| Distance calculators      | K         |
| Minimum comparator inputs | K         |
| Output selected cluster   | 1         |

This approach provides the highest throughput but increases resource usage as K grows.

## 13.10 Minimum Distance Selector

After all distances are calculated, the minimum distance selector determines the closest reference color.

min_distance = Distance\[0\]

cluster_index = 0

for k = 1 to K-1:

if Distance\[k\] \< min_distance:

min_distance = Distance\[k\]

cluster_index = k

In hardware, this is implemented using a comparator tree:

Distance\[0\] ─┐

Distance\[1\] ─┘→ min01 ─┐

Distance\[2\] ─┐ ├→ min_final

Distance\[3\] ─┘→ min23 ─┘

For large K values such as 51 or 90, the comparator tree should be pipelined to meet timing.

## 13.11 Cluster Output Mapping

Once the nearest cluster is selected, the output can be generated in several ways.

### 13.11.1 Nearest Palette Color Output

The most direct output is the selected reference color:

Rout = R_cluster

Gout = G_cluster

Bout = B_cluster

This produces an image quantized to K colors.

### 13.11.2 Cluster Index Output

The output may also be a cluster index:

Output = cluster_index

The cluster index can be used for segmentation, histogram analysis, or downstream symbolic processing.

### 13.11.3 Diagnostic False-Color Output

A diagnostic palette can map each cluster index to a visually distinct color:

cluster_index → debug_color\[cluster_index\]

This is useful for verifying cluster boundaries and region grouping.

## 13.12 Hardware Pipeline Architecture

A practical K-means hardware pipeline can be structured as follows:

| **Stage** | **Function**                                     |
|-----------|--------------------------------------------------|
| Stage 0   | Register input RGB and sideband signals          |
| Stage 1   | Read selected reference color table              |
| Stage 2   | Calculate per-channel differences                |
| Stage 3   | Calculate absolute values or squared differences |
| Stage 4   | Sum channel distances                            |
| Stage 5   | Compare distances in first-level comparator tree |
| Stage 6   | Continue comparator-tree reduction               |
| Stage 7   | Select nearest cluster index                     |
| Stage 8   | Read output palette color                        |
| Stage 9   | Clamp and register output RGB                    |

Pipeline flow:

RGB In

→ Difference Calculation

→ Distance Calculation

→ Minimum Distance Tree

→ Cluster Index

→ Palette Output

→ RGB Out

For large K, additional comparator stages may be required.

## 13.13 Fully Parallel Versus Time-Multiplexed Architecture

### 13.13.1 Fully Parallel Architecture

A fully parallel architecture computes all K distances at the same time.

| **Feature**    | **Description**                 |
|----------------|---------------------------------|
| Throughput     | One pixel per clock             |
| Latency        | Moderate and deterministic      |
| Resource usage | High                            |
| Best for       | Real-time high-resolution video |

### 13.13.2 Time-Multiplexed Architecture

A time-multiplexed architecture reuses fewer distance engines across multiple cycles.

| **Feature**    | **Description**                            |
|----------------|--------------------------------------------|
| Throughput     | Lower unless clock is much faster          |
| Latency        | Higher                                     |
| Resource usage | Lower                                      |
| Best for       | Low-resolution or non-real-time processing |

For a live FPGA video pipeline, the fully parallel or partially parallel pipelined approach is preferred.

## 13.14 Reference Color Storage

The reference color table may be implemented as fixed constants or programmable memory.

### 13.14.1 Constant Palette

A constant palette is known at synthesis time:

constant centroid_0 = (230, 170, 120)

constant centroid_1 = (70, 40, 35)

...

Advantages:

- Simple implementation.

- No runtime update logic.

- Good timing predictability.

Disadvantages:

- Palette changes require rebuild or reconfiguration.

### 13.14.2 Programmable Palette

A programmable palette can be updated through AXI4-Lite registers or BRAM.

Advantages:

- Runtime flexibility.

- Supports multiple scenes or lighting modes.

- Enables adaptive color schemes.

Disadvantages:

- Requires control logic.

- Requires safe update method.

- Requires readback and validation.

## 13.15 Active/Shadow Palette Update

To prevent live video artifacts, palette updates should use an active/shadow strategy.

Software writes new palette to shadow table

↓

Software sets update request

↓

K-means block waits for start-of-frame

↓

Shadow palette copies to active palette

↓

Entire next frame uses new palette

This prevents a single frame from being clustered with partially updated reference colors.

| **Palette Bank** | **Purpose**                          |
|------------------|--------------------------------------|
| Active palette   | Used by the live pixel datapath      |
| Shadow palette   | Updated by software                  |
| Update request   | Indicates pending palette activation |
| Update done      | Confirms new palette is active       |

## 13.16 K Value Configuration

The K value may be fixed at synthesis time or selectable at runtime.

### 13.16.1 Fixed K

A fixed K design uses a constant number of clusters.

Advantages:

- Best timing closure.

- Lowest control complexity.

- Efficient comparator tree.

Disadvantages:

- Less runtime flexibility.

### 13.16.2 Runtime-Selectable K

A runtime-selectable design supports different active cluster counts, such as 6, 9, 24, 51, or 90.

Advantages:

- Flexible palette size.

- Supports quality/performance modes.

- Allows different applications.

Disadvantages:

- More control logic.

- Comparator tree must support maximum K.

- Unused cluster entries must be masked.

A masked distance approach can be used:

if k \< active_K:

use Distance\[k\]

else:

Distance\[k\] = MAX_DISTANCE

## 13.17 Example K = 6 Palette Mode

The source document provides a K = 6 reference color scheme and describes the generated image as the result of K-means clustering using six reference colors.

A representative K = 6 mode is:

1: (230, 170, 120)

2: (70, 40, 35)

3: (150, 200, 130)

4: (20, 25, 10)

5: (75, 150, 180)

6: (15, 30, 60)

This mode strongly simplifies image colors and is useful for:

- Demonstrating color quantization.

- Segmenting broad visual regions.

- Reducing visual complexity.

- Generating stylized output.

## 13.18 K = 9, K = 24, K = 51, and K = 90 Modes

The source document identifies multiple reference-color modes:

- K = 9, where the input image is quantized into 9 clusters.

- K = 24, where the input image is quantized into 24 clusters.

- K = 51, where the input image is quantized into 51 clusters.

- K = 90, where the input image is quantized into 90 clusters.

### 13.18.1 Quality and Resource Tradeoff

| **K Value** | **Visual Detail** | **Hardware Cost** | **Typical Use**                |
|-------------|-------------------|-------------------|--------------------------------|
| 6           | Low               | Low               | Strong stylization             |
| 9           | Low to medium     | Low               | Simple segmentation            |
| 24          | Medium            | Medium            | General quantization           |
| 51          | High              | High              | Detailed palette approximation |
| 90          | Very high         | Very high         | Fine color preservation        |

As K increases, the design requires more distance engines, more comparator stages, more palette storage, and more routing resources.

## 13.19 Output Latency and Sideband Alignment

The K-means pipeline introduces latency from distance calculation, comparator reduction, and palette lookup. Therefore, control signals must be delayed by the same number of cycles as the pixel data.

Signals requiring alignment include:

- iRgb.valid

- iRgb.sof

- iRgb.eol

- iRgb.eof

- TVALID

- TUSER

- TLAST

- Pixel coordinates

A generic delay structure is:

RGB data pipeline: P0 → P1 → P2 → P3 → P4 → P5

SOF pipeline: S0 → S1 → S2 → S3 → S4 → S5

EOL pipeline: L0 → L1 → L2 → L3 → L4 → L5

VALID pipeline: V0 → V1 → V2 → V3 → V4 → V5

If these signals are not aligned, the clustered output image may have shifted frame boundaries or line errors.

## 13.20 Output Clamping and Format Control

If the output is selected directly from the palette, clamping is generally unnecessary because palette values are already valid. However, clamping is still recommended when palette entries are programmable.

For 8-bit output:

if palette_value \< 0:

output = 0

else if palette_value \> 255:

output = 255

else:

output = palette_value

Output formatting options include:

| **Output Mode**        | **Output Data**                     |
|------------------------|-------------------------------------|
| Palette RGB            | Selected reference RGB color        |
| Cluster index          | Encoded index value                 |
| False-color label      | Debug palette color                 |
| Mask output            | Binary or region mask               |
| Original/cluster blend | Mix of original and quantized color |

## 13.21 AXI4-Lite Register Map Recommendation

A representative register map for K-means clustering is:

| **Register**         | **Function**                                      |
|----------------------|---------------------------------------------------|
| KMEANS_CONTROL       | Enable, bypass, update control                    |
| KMEANS_STATUS        | Active state and error flags                      |
| KMEANS_ACTIVE_K      | Number of active clusters                         |
| KMEANS_PENDING_K     | Pending K value for next frame                    |
| KMEANS_MODE          | Output mode selection                             |
| KMEANS_DISTANCE_MODE | Euclidean squared or Manhattan distance           |
| KMEANS_PALETTE_INDEX | Selects palette entry for write/read              |
| KMEANS_PALETTE_R     | Red value for selected palette entry              |
| KMEANS_PALETTE_G     | Green value for selected palette entry            |
| KMEANS_PALETTE_B     | Blue value for selected palette entry             |
| KMEANS_UPDATE_REQ    | Requests shadow-to-active palette update          |
| KMEANS_FRAME_COUNT   | Counts processed frames                           |
| KMEANS_ERROR_STATUS  | Reports invalid K, palette error, or stream error |

Register programming should be frame-safe.

## 13.22 Verification Strategy

The K-means clustering module should be verified using directed pixel tests, palette tests, and full-frame image tests.

### 13.22.1 Directed Pixel Tests

Use simple palettes and known inputs.

Example:

Palette:

0 = (255, 0, 0)

1 = (0, 255, 0)

2 = (0, 0, 255)

Input Pixel:

(250, 10, 5)

Expected Output:

(255, 0, 0)

Checks:

- Correct distance calculation.

- Correct minimum selection.

- Correct tie handling.

- Correct palette output.

- Correct valid-signal delay.

### 13.22.2 Tie-Case Tests

When two reference colors have the same distance, the hardware should use a deterministic priority rule.

Example:

if Distance\[k\] \< min_distance:

update winner

else:

keep earlier winner

This gives lower-index clusters priority during exact ties.

### 13.22.3 Full-Frame Tests

Use natural images and color-bar images to verify:

- Correct color reduction.

- No frame tearing.

- No line shift.

- Correct cluster boundaries.

- Stable output under repeated frames.

- Correct behavior for K = 6, 9, 24, 51, and 90.

## 13.23 Software Reference Model

A software reference model should calculate expected cluster results for each pixel.

Reference model pseudocode:

for each pixel in frame:

best_index = 0

best_distance = MAX

for k in range(active_K):

dr = pixel.R - palette\[k\].R

dg = pixel.G - palette\[k\].G

db = pixel.B - palette\[k\].B

distance = dr\*dr + dg\*dg + db\*db

if distance \< best_distance:

best_distance = distance

best_index = k

output_pixel = palette\[best_index\]

The FPGA output should match the reference model after accounting for pipeline latency.

## 13.24 Hardware Design Recommendations

1.  **Use a fully pipelined distance path.**  
    This supports one-pixel-per-clock real-time video.

2.  **Avoid square root for Euclidean distance.**  
    Compare squared distances instead.

3.  **Use Manhattan distance when resource efficiency is more important than exact Euclidean behavior.**

4.  **Pipeline the minimum comparator tree.**  
    This is especially important for K = 51 or K = 90.

5.  **Use active/shadow palette memory.**  
    Prevent partial-frame palette updates.

6.  **Provide deterministic tie handling.**  
    Tie cases should not produce unstable cluster selection.

7.  **Delay sideband signals with pixel latency.**  
    Preserve SOF, EOL, EOF, TUSER, TLAST, and TVALID alignment.

8.  **Support bypass mode.**  
    Bypass mode is essential for debugging and baseline image comparison.

## 13.25 Common Failure Modes

| **Failure Mode**       | **Likely Cause**                  | **Correction**                                |
|------------------------|-----------------------------------|-----------------------------------------------|
| Wrong cluster color    | Incorrect distance calculation    | Verify RGB difference and palette values      |
| Color flicker          | Palette updated mid-frame         | Use shadow-to-active update                   |
| Output shifted         | Sideband latency mismatch         | Delay valid and frame/line markers            |
| Timing failure         | Comparator tree too large         | Pipeline reduction tree                       |
| Excessive DSP usage    | Euclidean squared for large K     | Use Manhattan distance or partial parallelism |
| Cluster ties unstable  | No tie priority rule              | Use lowest-index priority                     |
| No output color change | Bypass active or K = 0            | Verify control registers                      |
| Invalid colors         | Programmable palette out of range | Clamp palette values                          |

## 13.26 Chapter Summary

This chapter described the K-Means Color Clustering block used in the FPGA Video Color Processing System. The module receives RGB video pixels, compares each pixel against K reference colors, selects the nearest color using a distance metric, and outputs a clustered RGB pixel.

The source design describes an FPGA K-means module with a standard Xilinx AXI4-Stream style interface and RGB input/output channels. It explains that K-means color quantization selects RGB reference colors, computes distances to input pixels, assigns pixels to the closest reference color, and converts a 24-bit RGB image into an n-color version.

A reliable hardware implementation requires pipelined distance calculation, minimum-distance selection, palette lookup, frame-safe palette updates, deterministic tie handling, and proper sideband alignment. When implemented efficiently, the K-means block provides a powerful real-time color-quantization and segmentation capability for FPGA video pipelines.
