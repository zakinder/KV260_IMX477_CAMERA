# Chapter 28 — Limitations and Future Improvements

## 28.1 Overview

The **Limitations and Future Improvements** chapter identifies technical boundaries in the current FPGA Video Color Processing System and proposes practical upgrades for future revisions. The system already demonstrates a broad real-time video-processing architecture: MIPI camera input, RAW-to-RGB conversion, AXI4-Stream processing, AXI4-Lite control, filters, color-space conversion, K-means clustering, histogram processing, local threshold segmentation, DisplayPort output, and Ethernet UDP streaming. However, several areas can be improved for higher performance, stronger automation, better image quality, wider sensor support, and more robust deployment.

The source design supports 3840×2160 at 30 frames per second, while the full 4056×3040 resolution mode is supported but limited to 15 frames per second. This establishes an important performance boundary: the system is suitable for real-time high-resolution processing, but full-resolution sensor operation requires lower frame rate or additional optimization.

## 28.2 Summary of Current Limitations

The major limitations are grouped below.

| **Limitation Area**          | **Current Boundary**                                                            |
|------------------------------|---------------------------------------------------------------------------------|
| Full-resolution frame rate   | Full 4056×3040 operation is limited to 15 fps                                   |
| Ethernet streaming           | 1 GbE limits uncompressed high-resolution RGB streaming                         |
| Verification automation      | Some image tests require manual visual pass/fail review                         |
| Local threshold segmentation | Maximum-value exclusion before averaging is not yet implemented                 |
| K-means scalability          | Large K values require substantial comparison and routing resources             |
| Histogram processing         | Real-time readout and same-bin hazard handling require careful design           |
| Runtime updates              | Coefficients and palettes should use frame-safe active/shadow updates           |
| Sensor coverage              | Some sensor sections require final validated register tables                    |
| Debug observability          | Hardware debug counters and capture buffers can be expanded                     |
| Image quality                | Additional tuning is needed for noise, exposure, color balance, and compression |

These limitations do not invalidate the design; they define the next engineering improvements.

## 28.3 Resolution and Frame-Rate Limitation

The current design targets 3840×2160 at 30 fps and supports 4056×3040 full resolution at a reduced frame rate of 15 fps.

This limitation is caused by several factors:

- Sensor output bandwidth.

- MIPI lane rate.

- Pixel clock requirements.

- Internal processing clock margin.

- VDMA/DDR bandwidth.

- Output-interface bandwidth.

- Resource and timing pressure in complex modes.

**Future Improvement**

Future revisions should add adaptive mode scaling:

Full resolution capture

↓

Optional crop / bin / scale

↓

Processing resolution selection

↓

Display or network output mode

Recommended improvements:

| **Improvement**                   | **Benefit**                                                |
|-----------------------------------|------------------------------------------------------------|
| Multi-resolution processing modes | Allows 4K, 1080p, 720p, and ROI modes                      |
| Sensor binning support            | Reduces pixel rate while preserving field of view          |
| Region-of-interest processing     | Reduces compute load                                       |
| Multi-pixel-per-clock pipeline    | Increases throughput for 4K/60 or higher                   |
| 10 GbE option                     | Supports higher-resolution network streaming               |
| Frame-rate governor               | Automatically reduces frame rate when bandwidth is limited |

## 28.4 Ethernet Bandwidth Limitation

The UDP streaming path is useful for remote visualization, but uncompressed high-resolution video can exceed practical 1 Gigabit Ethernet throughput.

For example, RGB888 requires:

Bytes per frame = width × height × 3

Bandwidth = bytes per frame × frames per second

At 1920×1080p30 RGB888:

1920 × 1080 × 3 × 30 ≈ 186.6 MB/s

≈ 1.49 Gbps before packet overhead

This exceeds practical 1 GbE capacity.

**Future Improvement**

Recommended upgrades:

| **Improvement**                | **Benefit**                                  |
|--------------------------------|----------------------------------------------|
| RGB565 streaming               | Reduces payload by 33% compared with RGB888  |
| Grayscale diagnostic streaming | Reduces payload by 66%                       |
| ROI streaming                  | Sends selected image regions only            |
| JPEG/H.264/H.265 compression   | Makes higher-resolution streaming practical  |
| UDP packet pacing              | Reduces burst loss                           |
| Hardware packetizer            | Reduces PS software overhead                 |
| 10 GbE interface               | Enables higher-resolution uncompressed modes |

A future design can include a selectable output-format register:

00 = RGB888

01 = BGR888/BMP

10 = RGB565

11 = Grayscale / diagnostic

## 28.5 Local Dynamic Threshold Limitation

The local dynamic threshold module performs local averaging based on pixel difference thresholds. The source document identifies a future function that is **not yet implemented**: excluding a maximum value from a selected region before averaging when values are below the defined threshold.

Current behavior:

If pixel difference \< threshold:

map to average

Else:

keep original value

Unimplemented improvement:

For a selected region:

detect maximum value

exclude maximum value from average

average remaining values

**Future Improvement**

The improved algorithm would be:

1\. Collect local pixel neighborhood.

2\. Compare each neighbor against threshold.

3\. Identify maximum value in selected set.

4\. Exclude maximum value if region size ≥ 3.

5\. Compute average of remaining values.

6\. Output averaged value or original pixel according to threshold rule.

Benefits:

| **Benefit**            | **Description**                                      |
|------------------------|------------------------------------------------------|
| Better noise rejection | Removes local outlier before averaging               |
| Improved segmentation  | Smooths similar pixels while preserving strong peaks |
| Better visual quality  | Reduces isolated bright artifacts                    |
| More robust clustering | Avoids one extreme sample dominating average         |

## 28.6 Verification Automation Limitation

The source document states that the testbench generates output images and requires the user to manually check filtered output images and pass/fail test-pattern results.

Manual inspection is useful for visual confirmation, but it is not sufficient for regression sign-off.

**Future Improvement**

Add automated image comparison:

Input image

↓

Software reference model

↓

Expected image

↓

RTL output image

↓

Pixel-by-pixel comparison

↓

Pass/fail report

Recommended additions:

| **Improvement**             | **Benefit**                                |
|-----------------------------|--------------------------------------------|
| Automatic BMP comparison    | Removes manual review dependency           |
| Difference-image generation | Shows mismatch location visually           |
| Pixel mismatch threshold    | Supports fixed-point tolerance             |
| Regression summary          | Enables batch testing                      |
| Seed logging                | Makes failures reproducible                |
| Coverage reporting          | Shows which modes were verified            |
| CI regression flow          | Runs tests automatically after RTL changes |

The scoreboard should report:

Total pixels checked

Mismatched pixels

Maximum channel error

First mismatch coordinate

Expected RGB

Actual RGB

Pass/fail status

## 28.7 K-Means Scalability Limitation

K-means color clustering becomes more expensive as K increases. For every pixel, the hardware must compare the input color against multiple reference colors. Large K values increase:

- Comparator count.

- Distance engine count.

- Routing congestion.

- Pipeline depth.

- LUT and DSP usage.

- Register fanout.

- Timing-closure pressure.

**Future Improvement**

Future K-means improvements should include:

| **Improvement**              | **Benefit**                               |
|------------------------------|-------------------------------------------|
| Manhattan distance option    | Reduces multiplier/DSP use                |
| Hierarchical centroid search | Reduces number of comparisons             |
| Palette preclassification    | Uses coarse bins before detailed distance |
| Partial parallelism          | Balances resource use and throughput      |
| Runtime K selection          | Uses only required number of centroids    |
| BRAM-based palette banks     | Supports larger palette libraries         |
| Cluster-index output         | Enables downstream analytics              |
| Adaptive palette update      | Adjusts colors based on scene statistics  |

A future selectable distance mode:

0 = Euclidean squared distance

1 = Manhattan distance

2 = Weighted Manhattan distance

3 = Hybrid coarse/fine distance

## 28.8 Histogram Limitation

Histogram processing requires real-time counter updates. The most difficult case is when many consecutive pixels map to the same bin. This creates a read-modify-write hazard if the previous counter update has not completed before the next pixel arrives.

**Future Improvement**

Recommended improvements:

| **Improvement**               | **Benefit**                                         |
|-------------------------------|-----------------------------------------------------|
| Same-bin forwarding           | Prevents lost increments                            |
| Counter cache                 | Reduces BRAM write conflict                         |
| Ping-pong histogram banks     | Allows one bank to accumulate while another is read |
| Multi-channel histograms      | Supports RGB and luma statistics                    |
| Hardware threshold extraction | Automatically finds threshold from histogram        |
| Histogram equalization        | Adds automatic contrast enhancement                 |
| AXI readout interface         | Allows software to inspect bins                     |
| Overflow protection           | Prevents counter wraparound                         |

A future histogram block should support:

clear

accumulate

freeze

readout

bank swap

overflow detect

## 28.9 Runtime Reconfiguration Limitation

The current design uses AXI4-Lite registers for configuration. However, any live video system must prevent partial register updates from affecting the active frame. Updating filter coefficients, color matrix entries, thresholds, or palettes during a frame can cause visible tearing, flicker, or mixed-mode output.

**Future Improvement**

Add a formal active/shadow register model:

Software writes shadow registers

↓

Software asserts update request

↓

Hardware waits for frame boundary

↓

Shadow registers copy to active registers

↓

Hardware asserts update done

Recommended future features:

| **Feature**                     | **Purpose**                            |
|---------------------------------|----------------------------------------|
| Active/shadow coefficient banks | Prevent partial filter updates         |
| Active/shadow palette banks     | Prevent mixed K-means colors           |
| Frame-boundary update FSM       | Applies changes safely                 |
| Update-done interrupt           | Notifies software                      |
| Readback of active bank         | Confirms deployed values               |
| Rollback register               | Restores last-known-good configuration |
| Update checksum                 | Confirms complete configuration write  |

## 28.10 Sensor-Specific Limitation

Some sensor sections require final hardware-validated register tables and mode-specific documentation. The design references multiple sensors, including IMX477, IMX219, IMX519, IMX682, AR1335, OV5640, and OV5647. However, each sensor requires different lane counts, register settings, timing values, Bayer phase, and RAW format handling.

**Future Improvement**

Create a formal sensor abstraction layer:

sensor_id

mode_id

lane_count

raw_format

width

height

frame_rate

bayer_phase

register_table_pointer

Recommended additions:

| **Improvement**            | **Benefit**                                 |
|----------------------------|---------------------------------------------|
| Per-sensor register tables | Reliable bring-up                           |
| Sensor ID auto-detection   | Selects correct configuration automatically |
| Mode descriptor table      | Simplifies resolution/frame-rate selection  |
| Bayer phase metadata       | Prevents color errors                       |
| Sensor test-pattern enable | Simplifies validation                       |
| Lane-rate validation       | Prevents MIPI mismatch                      |
| Exposure/gain API          | Enables image-quality tuning                |
| Sensor status readback     | Improves field debug                        |

## 28.11 Image Quality Limitation

The system contains many processing blocks, but image quality depends on tuning. Raw sensor output may require black-level correction, white balance, gamma correction, denoising, color correction, and exposure control.

**Future Improvement**

Future image-quality pipeline:

RAW input

↓

Black-level correction

↓

Bad-pixel correction

↓

Demosaic

↓

White balance

↓

Color correction matrix

↓

Gamma correction

↓

Noise reduction

↓

VCP filters / clustering

↓

Output formatting

Recommended future blocks:

| **Block**              | **Purpose**                        |
|------------------------|------------------------------------|
| Auto exposure          | Stabilizes brightness              |
| Auto white balance     | Corrects color temperature         |
| Black-level correction | Removes sensor pedestal            |
| Bad-pixel correction   | Fixes defective pixels             |
| Gamma correction       | Improves perceptual brightness     |
| Temporal denoise       | Reduces noise across frames        |
| Adaptive sharpening    | Enhances detail without overshoot  |
| Tone mapping           | Improves high-dynamic-range scenes |

## 28.12 Fixed-Point Precision Limitation

FPGA video systems usually use fixed-point arithmetic. Fixed-point designs are efficient but introduce truncation, rounding, saturation, and overflow risks.

Affected modules include:

- HSL/HSV conversion.

- HSL-to-RGB reconstruction.

- Color correction matrix.

- YCbCr conversion.

- K-means distance computation.

- Histogram equalization.

- Local threshold averaging.

**Future Improvement**

Future versions should define one consistent fixed-point policy:

| **Parameter**          | **Recommendation**                    |
|------------------------|---------------------------------------|
| Internal RGB precision | 10-bit or 12-bit where possible       |
| Output precision       | 8-bit or 10-bit selectable            |
| Coefficient format     | Signed Q format                       |
| Rounding               | Round-to-nearest for final output     |
| Saturation             | Clamp to legal channel range          |
| Overflow flags         | Sticky error flags in status register |
| Verification tolerance | Defined per module                    |

A complete fixed-point specification improves repeatability and verification quality.

## 28.13 Memory and Buffering Limitation

High-resolution video requires substantial buffering. Spatial filters require line buffers. VDMA requires frame buffers. Histogram and palette features require BRAM or LUTRAM. UDP output may require packet buffers.

**Future Improvement**

Recommended memory improvements:

| **Improvement**                   | **Benefit**                      |
|-----------------------------------|----------------------------------|
| Shared line-buffer infrastructure | Reduces duplicate BRAM use       |
| Parameterized buffer depth        | Supports multiple resolutions    |
| Ping-pong frame buffers           | Prevents read/write collision    |
| Triple buffering                  | Reduces tearing in display paths |
| BRAM/URAM selection               | Optimizes large buffers          |
| Buffer status counters            | Improves debug visibility        |
| Overflow/underflow protection     | Prevents silent corruption       |
| Memory bandwidth monitor          | Measures real runtime pressure   |

## 28.14 Debug Visibility Limitation

Debugging live video hardware is difficult without internal observability. The current system benefits from output images and testbench results, but future hardware builds should expose more runtime diagnostic data.

**Future Improvement**

Add a formal debug and telemetry block:

| **Debug Feature**      | **Purpose**                    |
|------------------------|--------------------------------|
| Frame counter          | Confirms continuous video      |
| Line counter           | Confirms correct frame height  |
| Pixel counter          | Confirms correct frame width   |
| Stall counter          | Measures backpressure          |
| FIFO overflow counter  | Detects buffering failure      |
| FIFO underflow counter | Detects output starvation      |
| MIPI error counter     | Detects input-link problems    |
| VDMA error counter     | Detects memory movement issues |
| UDP packet counter     | Confirms network output        |
| Mode-change counter    | Confirms runtime updates       |
| Last-error register    | Speeds root-cause analysis     |

These counters should be readable through AXI4-Lite and optionally visible in a host GUI.

## 28.15 Software and GUI Limitation

The current host control flow includes command transmission and image reception, but future versions should provide a more complete GUI and scripting interface.

**Future Improvement**

Recommended GUI features:

| **GUI Feature**         | **Benefit**                                   |
|-------------------------|-----------------------------------------------|
| Live mode selection     | Switch filters and color spaces interactively |
| Threshold slider        | Tune Sobel/local segmentation visually        |
| Palette editor          | Modify K-means colors                         |
| Histogram viewer        | Display real-time channel distributions       |
| Frame-rate monitor      | Show measured FPS                             |
| Packet-loss monitor     | Show UDP health                               |
| Register inspector      | Read/write VCP registers                      |
| Screenshot capture      | Save demonstration evidence                   |
| Configuration save/load | Reuse tuned settings                          |
| Automated demo script   | Repeat demonstrations consistently            |

A strong GUI converts the FPGA design into a more usable demonstration platform.

## 28.16 Deployment Limitation

Deployment on hardware involves many configuration points: bitstream, Vitis software, camera register tables, VDMA setup, network settings, and display output. A mismatch in any one area can prevent successful demonstration.

**Future Improvement**

Create a deployment automation package:

build bitstream

export hardware

build software

package boot files

program board

configure network

run validation script

collect logs

Recommended deployment improvements:

| **Improvement**                   | **Benefit**                         |
|-----------------------------------|-------------------------------------|
| Scripted build flow               | Reduces manual errors               |
| Versioned bitstream/software pair | Prevents mismatched builds          |
| Register-map auto-generation      | Keeps software and RTL synchronized |
| Sensor-mode configuration files   | Simplifies camera selection         |
| Board self-test                   | Validates basic hardware after boot |
| Automated validation report       | Generates evidence after deployment |

## 28.17 Verification Coverage Limitation

The design includes many modes. It is easy to verify common cases while missing corner cases.

Potentially under-tested areas:

- Reset during active frame.

- Register write during active video.

- Back-to-back AXI4-Lite transactions.

- K-means tie distance cases.

- Histogram repeated-bin stress.

- MIPI line-rate edge modes.

- VDMA stride mismatch.

- UDP packet loss and reordering.

- Bayer phase changes due to cropping.

- Maximum-resolution long-run operation.

**Future Improvement**

Create a formal coverage model:

| **Coverage Type** | **Example**                                   |
|-------------------|-----------------------------------------------|
| Mode coverage     | Every filter and color-space mode             |
| Register coverage | Every register read/write path                |
| Pixel coverage    | Min, max, mid, random RGB values              |
| Frame coverage    | Small, medium, 1080p, 4K frames               |
| Error coverage    | Timeout, overflow, underflow                  |
| Update coverage   | Frame-safe update at multiple frame positions |
| Network coverage  | Packet loss, packet reorder, frame drop       |
| Sensor coverage   | Each supported sensor and mode                |

Coverage closure should become part of release sign-off.

## 28.18 Performance Improvement Roadmap

A future performance roadmap should be staged.

**Stage 1 — Stability Improvements**

- Add automated image comparison.

- Add debug counters.

- Add active/shadow register update.

- Improve local threshold max-value exclusion.

- Document all sensor registers.

**Stage 2 — Image Quality Improvements**

- Add auto white balance.

- Add gamma correction.

- Add black-level correction.

- Add denoise and adaptive sharpening.

- Add histogram-based exposure support.

**Stage 3 — Throughput Improvements**

- Add multi-pixel-per-clock processing.

- Optimize K-means with hierarchical search.

- Add hardware UDP packetization.

- Add compressed network output.

- Add improved DDR buffering.

**Stage 4 — Productization Improvements**

- Add GUI.

- Add configuration save/load.

- Add automated deployment.

- Add validation report generation.

- Add user-selectable processing profiles.

## 28.19 Future Architecture: Adaptive Video Intelligence Layer

A major future improvement is a runtime-adaptive control layer that selects processing modes based on scene conditions and performance limits.

Example adaptive behavior:

If scene is dark:

increase gain or exposure support

If histogram is flat:

enable contrast enhancement

If UDP bandwidth is saturated:

reduce frame rate or switch to RGB565

If edge density is high:

adjust Sobel threshold

If K-means resource mode is heavy:

reduce K or switch palette family

Future adaptive control inputs:

| **Input**                | **Use**                         |
|--------------------------|---------------------------------|
| Histogram                | Exposure and contrast decisions |
| Frame-rate counter       | Performance throttling          |
| UDP packet-loss counter  | Network adaptation              |
| Scene brightness         | Gain/exposure correction        |
| Edge density             | Sobel threshold tuning          |
| Palette mismatch         | K-means palette selection       |
| Temperature/power status | Performance mode control        |

This would convert the design from a fixed video pipeline into an intelligent adaptive FPGA video-processing system.

## 28.20 Future Register Map Enhancements

Future register-map improvements should include:

| **Register Group** | **Future Purpose**                     |
|--------------------|----------------------------------------|
| VERSION_ID         | Identifies RTL build                   |
| FEATURE_MASK       | Reports compiled features              |
| ACTIVE_MODE        | Reports current active processing mode |
| SHADOW_MODE        | Shows pending configuration            |
| UPDATE_STATUS      | Reports frame-safe update state        |
| ERROR_STATUS       | Sticky error flags                     |
| PERF_COUNTERS      | Runtime performance measurement        |
| SENSOR_STATUS      | Sensor lock and mode                   |
| UDP_STATUS         | Network transmission health            |
| HISTOGRAM_READOUT  | Statistical analysis                   |
| DEBUG_CAPTURE      | Pixel or event sample readback         |

These registers would make software integration more robust and reduce board-level debug time.

## 28.21 Future Documentation Improvements

The final technical package should include:

| **Document**               | **Future Addition**                         |
|----------------------------|---------------------------------------------|
| Architecture specification | Complete block diagrams and timing diagrams |
| Register specification     | Full bit fields, reset values, access type  |
| Verification plan          | Tests, coverage, scoreboard rules           |
| User guide                 | Board setup and demo flow                   |
| Sensor guide               | Register tables and mode settings           |
| Performance report         | Throughput, latency, resource, timing       |
| Known limitations          | Documented constraints and workarounds      |
| Release notes              | Version, build, features, bug fixes         |
| Troubleshooting guide      | Failure symptoms and corrections            |

Documentation should become part of the release, not an afterthought.

## 28.22 Risk Register for Future Work

| **Risk**                     | **Impact**              | **Mitigation**                       |
|------------------------------|-------------------------|--------------------------------------|
| K-means K=90 timing pressure | Timing failure          | Pipeline comparator tree or reduce K |
| Ethernet saturation          | Dropped frames          | Compress or reduce payload           |
| Sensor register mismatch     | No camera stream        | Use validated register tables        |
| Manual verification gaps     | Escaped bugs            | Add automated image comparison       |
| Runtime update artifacts     | Flicker or tearing      | Use active/shadow banks              |
| DDR bandwidth pressure       | Frame drops             | Optimize buffering and burst access  |
| Color-space precision errors | Visible color artifacts | Define fixed-point formats           |
| Debug visibility too low     | Long bring-up time      | Add telemetry counters               |
| Multi-sensor complexity      | Integration errors      | Add sensor abstraction layer         |

## 28.23 Future Improvement Summary Table

| **Area**        | **Limitation**                       | **Future Improvement**                           |
|-----------------|--------------------------------------|--------------------------------------------------|
| Resolution      | Full resolution limited to lower fps | Multi-pixel-per-clock and adaptive scaling       |
| Ethernet        | 1 GbE limits RGB streaming           | Compression, RGB565, 10 GbE, hardware packetizer |
| Verification    | Manual image review                  | Automated reference comparison                   |
| Segmentation    | Max exclusion not implemented        | Add max-value exclusion before averaging         |
| K-means         | High K uses many resources           | Hierarchical/Manhattan/partial-parallel search   |
| Histogram       | Same-bin hazards                     | Forwarding and ping-pong banks                   |
| Runtime control | Risk of mid-frame changes            | Active/shadow frame-safe updates                 |
| Sensors         | Register tables need validation      | Sensor abstraction and auto-detect               |
| Image quality   | Limited ISP features                 | AWB, gamma, denoise, black-level correction      |
| Debug           | Limited telemetry                    | Counters, logs, ILA profiles                     |
| Deployment      | Manual steps                         | Scripted build and validation package            |

## 28.24 Chapter Summary

This chapter identified the main limitations and future improvements for the FPGA Video Color Processing System. The documented design already supports high-resolution video processing, multiple filters, color-space conversions, K-means clustering, local thresholding, histogram processing, UDP streaming, and KV260 deployment. However, the system can be improved in frame-rate scalability, Ethernet bandwidth efficiency, automated verification, local threshold segmentation, K-means resource optimization, histogram hazard handling, runtime reconfiguration safety, sensor abstraction, image quality, debug telemetry, and deployment automation.

The source document identifies two specific limitations that guide future development: full-resolution 4056×3040 operation is limited to 15 fps, and the local threshold module has an unimplemented maximum-value exclusion step before averaging. It also shows that some visual verification still depends on manual checking of generated output images, which should be replaced with automated image comparison and regression reporting.

Future work should focus on converting the design from a strong functional prototype into a more automated, adaptive, validated, and deployment-ready FPGA video-processing platform.
