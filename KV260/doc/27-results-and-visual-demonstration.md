# Chapter 27 — Results and Visual Demonstration

## 27.1 Overview

The **Results and Visual Demonstration** chapter documents the observable outputs of the FPGA Video Color Processing System. It connects the engineering implementation to visible evidence: processed images, converted color-space views, channel extractions, K-means clustering outputs, filter results, histogram displays, simulation BMP outputs, and live hardware demonstrations on the Kria KV260.

The source document includes multiple visual-result sections, including RGB-to-HSL simulation results, hue/saturation/luminosity channel views, RGB channel separation, color-space conversion figures, K-means clustering output, and generated BMP images from testbench verification.

The demonstration objective is to prove that:

Input Camera / Test Image

↓

FPGA Video Color Processing

↓

Processed Output Image

↓

Visual Confirmation + Measured Validation

A complete visual demonstration should show both **qualitative results** and **technical validation evidence**.

## 27.2 Purpose of Visual Results

Visual results are important because image-processing systems are judged not only by register correctness or simulation pass/fail status, but also by the visible quality of the processed image.

Visual results support:

| **Purpose**             | **Description**                                                              |
|-------------------------|------------------------------------------------------------------------------|
| Functional confirmation | Shows that the selected processing mode produces the intended visual effect. |
| Color validation        | Confirms correct RGB, HSL, HSV, YCbCr, and palette mapping.                  |
| Channel verification    | Confirms red, green, blue, hue, saturation, and luminance channels.          |
| Filter verification     | Shows edge detection, blur, sharp, emboss, and threshold behavior.           |
| Clustering validation   | Shows K-means color quantization results.                                    |
| Hardware demonstration  | Confirms real-time output on DisplayPort or Ethernet.                        |
| Debug evidence          | Helps identify color swaps, misalignment, noise, or tearing.                 |
| Documentation evidence  | Provides figures for reports, papers, and technical presentations.           |

Visual demonstration should be treated as engineering evidence when it is paired with configuration data, frame size, mode ID, and expected behavior.

## 27.3 Result Categories

The results should be organized into clear categories.

| **Result Category**     | **Example Output**                                  |
|-------------------------|-----------------------------------------------------|
| Original image          | Baseline RGB image before processing                |
| Channel extraction      | Red, green, blue, hue, saturation, luminosity       |
| Color conversion        | RGB-to-HSL, RGB-to-YCbCr, RGB-to-CIEXYZ, etc.       |
| Enhancement             | Saturation, brightness, hue, contrast, gain changes |
| Spatial filtering       | Sharp, blur, emboss, Sobel edge detection           |
| K-means clustering      | Reduced-palette quantized output                    |
| Segmentation            | Local dynamic threshold regions                     |
| Histogram               | Pixel intensity distribution                        |
| Streaming demonstration | UDP/FFplay or GUI display result                    |
| Hardware output         | DisplayPort live image or screen capture            |

A professional results chapter should provide each output together with the processing mode and configuration parameters used to generate it.

## 27.4 Original RGB Image Demonstration

Every visual demonstration should begin with the original RGB input. This provides a baseline for comparison.

A recommended original-image result block is:

Figure 27-1 — Original RGB Input Image

Resolution:

Pixel format:

Source:

Frame number:

Processing mode: Bypass

The original image confirms:

- Input frame is valid.

- RGB channel ordering is correct.

- Sensor or testbench stimulus is stable.

- Frame dimensions are correct.

- No unwanted processing is active.

The source document references RGB image figures and channel-separated figures where the first image is RGB and subsequent images show extracted or converted results.

## 27.5 RGB Channel Demonstration

RGB channel separation is one of the simplest and most important demonstrations. It proves that the pixel data is correctly unpacked and that the red, green, and blue channels are not swapped.

The source document describes a visual sequence in which the first figure shows an RGB image, the second shows the red channel, the third shows the green channel, and the fourth shows the blue channel.

Recommended presentation:

| **Figure**   | **Output**         |
|--------------|--------------------|
| Figure 27-2A | Original RGB image |
| Figure 27-2B | Red channel        |
| Figure 27-2C | Green channel      |
| Figure 27-2D | Blue channel       |

Validation checks:

| **Check**       | **Expected Result**                  |
|-----------------|--------------------------------------|
| Red channel     | Bright where red content exists      |
| Green channel   | Bright where green content exists    |
| Blue channel    | Bright where blue content exists     |
| Neutral regions | Similar intensity in all channels    |
| Color bars      | Channel brightness matches bar color |

RGB channel demonstration is especially useful for detecting RGB/BGR byte-order errors in UDP output.

## 27.6 HSL Conversion Results

The RGB-to-HSL result demonstrates that the FPGA pipeline can convert RGB pixels into hue, saturation, and luminosity/intensity-style components.

The source document states that simulation results of RGB-channel conversion to HSL color space are presented in a waveform diagram, and that figures show RGB color-space conversion into six regions of the hexagon image. It also identifies RGB images and HSL-converted images as paired visual results.

A recommended HSL result set is:

| **Figure**   | **Description**              |
|--------------|------------------------------|
| Figure 27-3A | RGB input                    |
| Figure 27-3B | HSL-converted output         |
| Figure 27-3C | Hue channel                  |
| Figure 27-3D | Saturation channel           |
| Figure 27-3E | Luminosity/intensity channel |

The source document also describes HSL image channel figures in which the first image is the HSL image, the second represents hue, the third represents saturation, and the fourth represents luminosity.

## 27.7 HSL Enhancement Demonstration

HSL enhancement demonstrates that image appearance can be modified through hue, saturation, and brightness/luminosity-related controls.

The source document describes enhanced image results where saturation and hue coefficients are adjusted. It states that after applying gains to HSL components and converting back to RGB, the enhanced image colors appear natural and brighter. It also references examples such as original image, 2× saturated, 3× saturated, and combinations of saturation, hue, and brightness changes.

Recommended result table:

| **Demonstration**                   | **Configuration**                         |
|-------------------------------------|-------------------------------------------|
| Original                            | No gain applied                           |
| Saturation boost                    | S_gain = 2.0                              |
| Strong saturation                   | S_gain = 3.0                              |
| Saturation + brightness             | S_gain = 3.0, L_gain = 1.2                |
| Hue shift + saturation              | H_gain = 0.95, S_gain = 3.0               |
| Hue shift + saturation + brightness | H_gain = 0.90, S_gain = 3.0, L_gain = 1.2 |

Expected visual effect:

- Saturation gain makes colors stronger.

- Brightness/luminosity gain makes the image brighter.

- Hue adjustment shifts color tone.

- Excessive gain may cause clipping or unnatural color.

## 27.8 HSL-to-RGB Reconstruction Results

A complete color-space demonstration should show both forward and reverse conversion.

RGB input

↓

RGB-to-HSL

↓

HSL adjustment

↓

HSL-to-RGB

↓

Enhanced RGB output

The source document includes HSL-to-RGB conversion as a module that uses an HSL-to-RGB algorithm and is designed as a standard Xilinx AXI4-Stream-compatible module.

Validation checks:

| **Check**           | **Expected Result**                        |
|---------------------|--------------------------------------------|
| Identity conversion | RGB → HSL → RGB closely matches original   |
| Saturation increase | Color intensity increases                  |
| Hue shift           | Hue changes without frame corruption       |
| Luminosity change   | Brightness changes predictably             |
| No channel swap     | Red, green, blue remain correctly ordered  |
| No invalid pixels   | No X/Z or black output after pipeline fill |

## 27.9 Color-Space Conversion Demonstrations

The design includes many RGB-to-color-space conversion modules. The source document references visual results for several conversions, including RGB-to-YDbDr, RGB-to-CIEXYZ, RGB-to-CIEYUV, RGB-to-YIQ, RGB-to-YPbPr, LMS, ICtCp, HED, YC1C2, and YCbCr. The document describes several outputs as converted images or channel components.

A structured results table should be used:

| **Conversion** | **Demonstration Output** | **Expected Visual Meaning**        |
|----------------|--------------------------|------------------------------------|
| RGB to YCbCr   | Y, Cb, Cr output image   | Luma and chroma separation         |
| RGB to YIQ     | Y, I, Q output image     | Luminance plus chrominance         |
| RGB to YPbPr   | Y, Pb, Pr output image   | Video luma/chroma representation   |
| RGB to CIEXYZ  | X, Y, Z output image     | Tristimulus color representation   |
| RGB to CIEYUV  | Y, U, V output image     | Luma/chroma representation         |
| RGB to LMS     | L, M, S output image     | Cone-response-like components      |
| RGB to HED     | H, E, D output image     | Stain/color-space representation   |
| RGB to YC1C2   | Y, C1, C2 output image   | Alternative luma/chroma separation |

Each demonstration should show:

Input RGB image

Converted output image

Optional per-channel images

Configuration register values

Observed result summary

## 27.10 Spatial Filter Results

Spatial filters demonstrate neighborhood-based image processing.

Expected visual outputs:

| **Filter** | **Expected Result**                    |
|------------|----------------------------------------|
| Sharp      | Edges and fine details appear stronger |
| Blur       | Image appears smoother and less noisy  |
| Emboss     | Image appears raised or relief-like    |
| Sobel      | Edges appear as bright outlines        |
| Contrast   | Bright/dark separation increases       |

For Sobel, the source document describes vertical and horizontal edge calculation using a 3-line buffer, Kx/Ky filtering, accumulation, and threshold comparison to detect edges.

Recommended Sobel demonstration:

| **Figure**   | **Output**                |
|--------------|---------------------------|
| Figure 27-4A | Original RGB image        |
| Figure 27-4B | Grayscale/luminance input |
| Figure 27-4C | Sobel horizontal response |
| Figure 27-4D | Sobel vertical response   |
| Figure 27-4E | Thresholded edge output   |

Validation points:

- Edges align with original image boundaries.

- Uniform areas remain dark.

- Threshold changes edge density.

- No frame shift or line tearing is visible.

## 27.11 K-Means Clustering Results

K-means clustering demonstrates color quantization. It reduces the input RGB image to a smaller set of reference colors.

The source document states that the K-means module takes RGB stream data and outputs a K-means RGB cluster color space. It also states that generated images are results of K-means clustering using palette reference schemes, and it specifically identifies a result using K = 6 references.

A recommended K-means visual set is:

| **Figure**   | **Description**         |
|--------------|-------------------------|
| Figure 27-5A | Original RGB image      |
| Figure 27-5B | K = 6 clustered output  |
| Figure 27-5C | K = 9 clustered output  |
| Figure 27-5D | K = 24 clustered output |
| Figure 27-5E | K = 51 clustered output |
| Figure 27-5F | K = 90 clustered output |

The source document also identifies a K-means result figure where the left side is the original image and the right side shows results obtained using K-means clustering.

Expected progression:

Small K → stronger posterization, fewer colors

Large K → closer visual match to original image

## 27.12 K-Means Palette Demonstration

The K-means palette result should show both the palette and the output image. For K = 6, the source document lists a six-color reference scheme with RGB values.

Example K = 6 palette result:

| **Index** | **Red** | **Green** | **Blue** |
|-----------|---------|-----------|----------|
| 1         | 230     | 170       | 120      |
| 2         | 70      | 40        | 35       |
| 3         | 150     | 200       | 130      |
| 4         | 20      | 25        | 10       |
| 5         | 75      | 150       | 180      |
| 6         | 15      | 30        | 60       |

Demonstration notes should include:

- K value.

- Palette values.

- Distance metric.

- Output image.

- Cluster index visualization if available.

- Visual comparison to original.

## 27.13 Local Dynamic Threshold Segmentation Results

Local dynamic threshold segmentation demonstrates region smoothing and local clustering.

Expected result:

| **Input Region**     | **Output Behavior**                    |
|----------------------|----------------------------------------|
| Smooth region        | Neighbor values average together       |
| Edge region          | Strong differences preserve boundaries |
| Noisy region         | Small variations are reduced           |
| High-contrast region | Original structure remains visible     |

A demonstration should include:

Original image

Threshold = 5 result

Threshold = 10 result

Threshold = 20 result

Difference view

Expected visual trend:

- Low threshold preserves more detail.

- Medium threshold smooths minor variation.

- High threshold creates stronger regional averaging.

- Excessive threshold may over-smooth the image.

## 27.14 Histogram Results

Histogram results demonstrate image statistics rather than direct pixel transformation.

Recommended histogram demonstration:

| **Figure**   | **Description**               |
|--------------|-------------------------------|
| Figure 27-6A | Input RGB image               |
| Figure 27-6B | Red-channel histogram         |
| Figure 27-6C | Green-channel histogram       |
| Figure 27-6D | Blue-channel histogram        |
| Figure 27-6E | Grayscale/luminance histogram |

The histogram should confirm:

- Dark images produce high counts near low bins.

- Bright images produce high counts near high bins.

- Balanced images spread counts across the range.

- Color-specific scenes show different distributions per channel.

Histogram results are especially useful for exposure, threshold selection, and contrast analysis.

## 27.15 Simulation Output Demonstration

The source document describes a VHDL testbench approach that reads an image file, applies RGB stimulus, waits until the end of frame, and generates a valid output BMP file. It also describes generated images as output results from the testbench.

Recommended simulation-result package:

| **File**                   | **Purpose**                    |
|----------------------------|--------------------------------|
| input.bmp                  | Source stimulus                |
| rtl_output.bmp             | DUT-generated image            |
| expected.bmp               | Software reference output      |
| diff.bmp                   | Pixel difference visualization |
| waveform.wlf or equivalent | Signal-level debug             |
| simulation.log             | Pass/fail and error messages   |

A result should be considered complete only when the output image is paired with pass/fail status and configuration data.

## 27.16 Waveform Demonstration

Waveform results demonstrate timing correctness. For example, the RGB-to-HSL section in the source document references waveform-based simulation results for RGB-to-HSL conversion.

Waveform screenshots should show:

- Input RGB values.

- Input valid.

- Start-of-frame.

- End-of-line.

- Internal intermediate values.

- Output HSL/RGB values.

- Output valid.

- Pipeline latency.

A useful waveform annotation includes:

Input pixel accepted at cycle N

Output pixel valid at cycle N + latency

Expected result equals observed output

This demonstrates that the output is not only visually correct but also correctly timed.

## 27.17 DisplayPort Demonstration

DisplayPort demonstration confirms live hardware output.

Recommended evidence:

| **Evidence**  | **Description**                   |
|---------------|-----------------------------------|
| Monitor image | Live processed image visible      |
| Mode overlay  | Active filter or color-space mode |
| Frame counter | Confirms continuous output        |
| Resolution    | Confirms expected display mode    |
| No tearing    | Confirms frame synchronization    |
| No flicker    | Confirms stable control update    |
| Color bars    | Confirms channel mapping          |

DisplayPort should first show a test pattern, then RGB bypass, then selected VCP modes.

## 27.18 Ethernet UDP Demonstration

Ethernet UDP demonstration confirms network output. The source design states that the GUI on the remote computer sends commands to the FPGA board and receives image data, while FFmpeg/ffplay.exe decodes received BMP images into a video stream at a specified frame rate.

Recommended UDP result evidence:

| **Evidence**             | **Description**                  |
|--------------------------|----------------------------------|
| Host receiver screenshot | Shows received video frame       |
| Packet counter           | Confirms packets transmitted     |
| Frame counter            | Confirms frames received         |
| FFplay display           | Confirms decoding path           |
| Packet loss report       | Confirms network stability       |
| Bandwidth measurement    | Confirms selected mode fits link |
| Color test               | Confirms RGB/BGR order           |

A good UDP demonstration should include a reduced-resolution mode first, then higher-resolution modes if bandwidth permits.

## 27.19 Visual Demonstration Script

A demonstration should follow a controlled sequence:

1\. Show original RGB bypass.

2\. Show red, green, and blue channels.

3\. Show HSL conversion and channels.

4\. Apply saturation and brightness gain.

5\. Enable sharp filter.

6\. Enable blur filter.

7\. Enable emboss filter.

8\. Enable Sobel edge detection.

9\. Enable K-means clustering.

10\. Enable local threshold segmentation.

11\. Show histogram readout.

12\. Show DisplayPort output.

13\. Show Ethernet UDP output.

The purpose of this sequence is to prove the design from simple to complex, avoiding confusion during demonstration.

## 27.20 Result Documentation Template

Each result should be documented in a consistent format.

Result ID:

Processing Mode:

Input Source:

Resolution:

Frame Rate:

Pixel Format:

Register Configuration:

Expected Behavior:

Observed Behavior:

Pass/Fail:

Output File or Screenshot:

Notes:

Example:

Result ID: R27-KMEANS-006

Processing Mode: K-Means Clustering

K Value: 6

Input Source: Test image

Expected Behavior: Output limited to six reference RGB colors

Observed Behavior: Image appears posterized with six-color palette

Pass/Fail: Pass

## 27.21 Visual Result Quality Criteria

A result should be evaluated using both visual and technical criteria.

| **Criterion**                | **Requirement**                             |
|------------------------------|---------------------------------------------|
| Correct format               | Output image decodes correctly              |
| Correct dimensions           | Width and height match expected values      |
| Correct channel order        | RGB/BGR mapping is correct                  |
| Correct frame alignment      | No row shift, tearing, or skew              |
| Correct visual effect        | Processing mode matches expected appearance |
| Stable frame rate            | Output does not freeze or flicker           |
| Valid register configuration | Settings match documented mode              |
| Reproducible output          | Same input and config produce same result   |
| Scoreboard pass              | Automated check passes where available      |

## 27.22 Common Visual Defects and Interpretation

| **Visual Defect**                 | **Likely Cause**                               |
|-----------------------------------|------------------------------------------------|
| Red and blue swapped              | RGB/BGR byte ordering error                    |
| Green or magenta tint             | Wrong Bayer phase                              |
| Image shifted sideways            | Incorrect stride or packet offset              |
| Image upside down                 | Frame orientation mismatch                     |
| Edge output too dense             | Sobel threshold too low                        |
| Edge output missing               | Sobel threshold too high                       |
| K-means output too flat           | K too small or palette unsuitable              |
| Histogram does not match image    | Wrong channel selected or missed bin updates   |
| Frame flickers during mode change | Registers updated mid-frame                    |
| UDP image tears                   | Packet loss or incomplete frame reconstruction |

This table should be included in demonstration notes to speed up analysis.

## 27.23 Recommended Figures for Final Document

The final chapter should include the following figure set:

| **Figure**   | **Title**                                     |
|--------------|-----------------------------------------------|
| Figure 27-1  | Original RGB Input Image                      |
| Figure 27-2  | Red, Green, and Blue Channel Separation       |
| Figure 27-3  | RGB-to-HSL Conversion Result                  |
| Figure 27-4  | Hue, Saturation, and Luminosity Channels      |
| Figure 27-5  | HSL Enhancement Examples                      |
| Figure 27-6  | Sharp, Blur, and Emboss Filter Results        |
| Figure 27-7  | Sobel Edge Detection Result                   |
| Figure 27-8  | K-Means Clustering K=6, K=9, K=24, K=51, K=90 |
| Figure 27-9  | Local Threshold Segmentation Result           |
| Figure 27-10 | RGB Histogram Result                          |
| Figure 27-11 | DisplayPort Hardware Demonstration            |
| Figure 27-12 | Ethernet UDP / FFplay Demonstration           |

## 27.24 Results Summary Table

A formal results table should summarize all demonstrated functions.

| **Function**    | **Demonstrated Output** | **Expected Result**                   | **Status**                                    |
|-----------------|-------------------------|---------------------------------------|-----------------------------------------------|
| RGB bypass      | Original image          | Unmodified frame                      | Pass when identical                           |
| RGB channels    | R/G/B images            | Correct channel separation            | Pass when channel mapping correct             |
| HSL conversion  | HSL output              | Hue/saturation/luminosity represented | Pass when visually and numerically consistent |
| HSL enhancement | Saturated/bright image  | Controlled color enhancement          | Pass when no corruption                       |
| Spatial filters | Sharp/blur/emboss       | Expected visual filter effect         | Pass when output matches reference            |
| Sobel           | Edge image              | Boundaries detected                   | Pass when threshold behavior correct          |
| CCM             | Corrected color output  | Matrix-adjusted image                 | Pass when reference matches                   |
| K-means         | Quantized image         | Reduced palette output                | Pass when all pixels map to palette           |
| Segmentation    | Smoothed local regions  | Threshold-controlled averaging        | Pass when edge behavior is correct            |
| Histogram       | Bin distribution        | Counts match pixel values             | Pass when bin totals equal pixel count        |
| DisplayPort     | Live monitor output     | Stable visible video                  | Pass when frame stable                        |
| UDP streaming   | Host video output       | Frame received and decoded            | Pass when packet/frame counters stable        |

## 27.25 Chapter Summary

This chapter described the results and visual demonstration method for the FPGA Video Color Processing System. Visual results should include original RGB input, RGB channel extraction, HSL conversion, hue/saturation/luminosity channels, HSL enhancement, spatial filters, Sobel edge detection, K-means clustering, local threshold segmentation, histogram outputs, DisplayPort hardware output, and Ethernet UDP host display.

The source document provides multiple examples of visual-result evidence, including HSL conversion waveforms and converted images, separated channel views, K-means clustering results, and generated BMP output files from the testbench.

A complete results chapter should not only show images; it should also document the mode, resolution, register configuration, expected behavior, observed behavior, pass/fail result, and any known limitations. This creates a reproducible visual evidence package for simulation, hardware validation, publication, and live demonstration.
