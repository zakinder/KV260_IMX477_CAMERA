# Chapter 25 — Performance Evaluation

## 25.1 Overview

**Performance evaluation** measures whether the FPGA Video Color Processing System can sustain the required frame rate, pixel throughput, bandwidth, latency, and output quality for real-time operation. A correct image-processing algorithm is not sufficient if the implementation cannot process pixels at video rate, close timing, avoid buffer overflow, or maintain stable output through DisplayPort or Ethernet.

The source design targets a real-time video pipeline on the Kria KV260 platform. It identifies a 3840×2160 frame resolution at 30 frames per second and notes that maximum full resolution of 4056×3040 is also supported but limited to 15 frames per second.

A practical performance-evaluation flow is:

Define Target Video Mode

↓

Calculate Pixel Clock and Bandwidth

↓

Measure Processing Throughput

↓

Measure Pipeline Latency

↓

Check Resource Utilization

↓

Check Timing Closure

↓

Validate Output Frame Rate

↓

Validate Image Quality

↓

Record Performance Results

Performance evaluation should be performed in simulation, after implementation, and on real hardware.

## 25.2 Performance Evaluation Goals

The performance evaluation should answer the following engineering questions:

| **Question**                                   | **Performance Area**         |
|------------------------------------------------|------------------------------|
| Can the design accept one pixel per clock?     | Pixel throughput             |
| Can the design maintain the target frame rate? | Frame-rate performance       |
| Can the MIPI input handle the selected format? | Input bandwidth              |
| Can the VCP pipeline process without stalls?   | Processing throughput        |
| Can DDR/VDMA sustain frame movement?           | Memory bandwidth             |
| Can Ethernet transmit the selected stream?     | Network bandwidth            |
| Does the output meet timing?                   | FPGA timing closure          |
| Does pipeline latency remain deterministic?    | Latency                      |
| Does output quality match expected results?    | Functional/image performance |
| Does resource usage leave enough margin?       | Implementation scalability   |

The performance result should be numerical, repeatable, and tied to a specific configuration.

## 25.3 Key Performance Metrics

The main metrics are:

| **Metric**           | **Meaning**                                      |
|----------------------|--------------------------------------------------|
| Pixel clock          | Required pixel processing rate.                  |
| Pixels per clock     | Number of pixels processed per clock cycle.      |
| Frame rate           | Frames processed per second.                     |
| Throughput           | Pixels or bytes processed per second.            |
| Latency              | Delay from input pixel to output pixel.          |
| Line rate            | MIPI data rate per lane.                         |
| DDR bandwidth        | Memory traffic required for frame buffers.       |
| Ethernet bandwidth   | UDP payload bandwidth required for streaming.    |
| Resource utilization | LUT, FF, BRAM, DSP usage.                        |
| Timing slack         | Setup and hold timing margin.                    |
| Drop rate            | Number of frames or packets lost.                |
| Quality error        | Pixel mismatch count or image-difference metric. |

## 25.4 Pixel Clock Calculation

The pixel clock determines the rate at which pixels must be processed.

The source document defines pixel clock frequency as:

Pixel Clock Frequency = Total Horizontal Samples × Total Vertical Lines × Refresh Rate

It also states that video bandwidth is the product of pixel clock frequency and pixel size, and that line rate equals total bandwidth divided by the number of data lanes.

Therefore:

PixelClock = Htotal × Vtotal × FrameRate

Bandwidth = PixelClock × BitsPerPixel

LaneRate = Bandwidth / NumberOfLanes

These equations should be used before implementation to confirm that the selected camera mode and output mode are feasible.

## 25.5 Example RAW10 Performance Calculation

The source document gives a 1920×1080p60 RAW10 2-lane example:

Total horizontal samples = 2200

Total vertical lines = 1125

Refresh rate = 60 Hz

Pixel per clock = 1

The calculated video clock is:

Video Clock = 2200 × 1125 × 60

= 148.5 MHz

The RAW10 bandwidth is:

Bandwidth = 148.5 MHz × 10 bits

= 1485 Mbps

For two lanes:

Line Rate = 1485 Mbps / 2

= 742.5 Mbps per lane

These exact calculation results are shown in the source bandwidth section.

## 25.6 Example 2560×1080 RAW10 Performance

The source document gives two 2560×1080 RAW10 2-lane modes.

For 2560×1080p30:

Pixel Clock = 3520 × 1125 × 30

= 118.8 MHz

Bandwidth = 118.8 MHz × 10 bits

= 1188 Mbps

Line Rate = 1188 Mbps / 2

= 594.0 Mbps per lane

For 2560×1080p60:

Pixel Clock = 3520 × 1125 × 60

= 237.6 MHz

Bandwidth = 237.6 MHz × 10 bits

= 2376 Mbps

Line Rate = 2376 Mbps / 2

= 1188.0 Mbps per lane

These calculations are listed in the source document’s bandwidth and data-rate section.

## 25.7 Example 3840×2160 RAW8 Performance

For 3840×2160 at 30 Hz, the source document gives:

Total horizontal samples = 4400

Total vertical lines = 2250

Refresh rate = 30 Hz

The pixel clock is:

Pixel Clock = 4400 × 2250 × 30

= 297 MHz

For RAW8:

Bandwidth = 297 MHz × 8 bits

= 2376 Mbps

For four lanes:

Line Rate = 2376 Mbps / 4

= 594 Mbps per lane

The same values are documented in the source design.

## 25.8 Processing Clock Evaluation

The source design divides operation into multiple clock domains and identifies:

- 300 MHz for video AXI4 video configuration and processing.

- 200 MHz for MIPI D-PHY video input.

- 297 MHz for video output.

A processing clock must be high enough to process all active pixels. If the video pipeline processes one pixel per clock, then:

ProcessingClock ≥ RequiredPixelClock

For example:

| **Mode**            | **Required Pixel Clock** | **300 MHz Processing Clock Margin**        |
|---------------------|--------------------------|--------------------------------------------|
| 1080p60 timing      | 148.5 MHz                | Positive                                   |
| 2560×1080p60 timing | 237.6 MHz                | Positive                                   |
| 3840×2160p30 timing | 297 MHz                  | Small positive margin                      |
| 3840×2160p60 timing | 594 MHz                  | Not supported by single-pixel 300 MHz path |

At 3840×2160p30, a 300 MHz processing clock gives very little headroom if the active path must handle every pixel in real time. Therefore, timing closure, ready/valid behavior, and no-stall processing become critical.

## 25.9 Pixels-Per-Clock Throughput

The source MIPI configuration identifies **Pixel Per Clock = 1** for the receiver configuration.

For a one-pixel-per-clock architecture:

Throughput_pixels_per_second = ClockFrequency × 1

At 300 MHz:

Maximum theoretical processing throughput = 300 million pixels/second

A video mode is feasible if:

Required active/total pixel rate ≤ sustained processing throughput

However, practical throughput can be reduced by:

- Backpressure.

- Memory stalls.

- Non-pipelined dividers.

- Time-multiplexed arithmetic.

- VDMA contention.

- Output interface stalls.

- Runtime reconfiguration pauses.

Therefore, the measured throughput is more important than the theoretical clock rate.

## 25.10 Frame Rate Measurement

Frame rate should be measured using hardware counters.

Recommended counters:

| **Counter**         | **Purpose**                                |
|---------------------|--------------------------------------------|
| input_frame_count   | Counts frames entering VCP                 |
| output_frame_count  | Counts frames leaving VCP                  |
| dropped_frame_count | Counts missed or skipped frames            |
| input_pixel_count   | Counts input pixels per frame              |
| output_pixel_count  | Counts output pixels per frame             |
| line_count          | Counts lines per frame                     |
| stall_cycle_count   | Counts cycles where data could not advance |

Measured frame rate:

MeasuredFPS = FramesProcessed / MeasurementTimeSeconds

For example:

MeasuredFPS = 300 frames / 10 seconds

= 30 fps

A stable design should maintain target FPS over long runtime intervals, not only for short tests.

## 25.11 Latency Evaluation

Latency is the delay between an input pixel and its corresponding output pixel.

Latency_cycles = OutputCycle - InputCycle

Latency_time = Latency_cycles / ClockFrequency

Example:

Pipeline latency = 40 cycles

Clock frequency = 300 MHz

Latency time = 40 / 300,000,000

= 133.3 ns

Latency should be measured for every major mode:

| **Mode**        | **Latency Source**                           |
|-----------------|----------------------------------------------|
| Bypass          | Register stages                              |
| CCM             | Multiply-accumulate pipeline                 |
| HSL/HSV         | Max/min, divide, hue logic                   |
| Sobel           | Line buffers plus arithmetic                 |
| K-means         | Distance engines and comparator tree         |
| Histogram       | Mostly sideband/statistical latency          |
| Local threshold | Line buffers, neighbor comparison, averaging |
| UDP output      | Frame buffering and packetization            |

For live video, deterministic latency is usually more important than minimum latency.

## 25.12 Line Buffer Latency

Spatial processing modules require line buffers. This creates structural latency because the module cannot compute a full neighborhood until enough previous lines are available.

A 3×3 filter requires at least:

2 full line delays + horizontal tap delay

For image width W:

LineBufferLatency ≈ 2W + small pipeline latency

For 1920-pixel width:

Approximate structural latency ≈ 3840 pixel clocks + arithmetic delay

For 3840-pixel width:

Approximate structural latency ≈ 7680 pixel clocks + arithmetic delay

This latency does not reduce throughput if the pipeline remains one pixel per clock, but it affects frame alignment and debug expectations.

## 25.13 Bandwidth Evaluation

Bandwidth must be evaluated at all major interfaces:

| **Interface**        | **Bandwidth Concern**                 |
|----------------------|---------------------------------------|
| MIPI CSI-2 input     | RAW sensor stream lane rate           |
| AXI4-Stream internal | Pixel-processing path width and clock |
| VDMA write           | Camera/VCP frame write into DDR       |
| VDMA read            | Display or UDP frame read from DDR    |
| DDR memory           | Total read/write traffic              |
| Ethernet UDP         | Network payload throughput            |
| DisplayPort          | Output video timing bandwidth         |

The basic bandwidth equation is:

Bandwidth = PixelRate × BitsPerPixel

For RGB888:

BitsPerPixel = 24

For RAW10:

BitsPerPixel = 10

For RGB30:

BitsPerPixel = 30

Bandwidth evaluation should be performed separately for RAW input and RGB output because RGB expansion increases data width after demosaic.

## 25.14 DDR and VDMA Performance

VDMA performance is required when frames are written to or read from DDR. The source design states that VDMA transfers video streams to and from external memory under software control. It also states that VDMA converts demosaic video stream data to AXI4 memory-mapped format for DDR fetching and execution through the AXI_HP interface.

A simple DDR bandwidth estimate is:

DDR_Write_BW = Width × Height × BytesPerPixel × FPS

DDR_Read_BW = Width × Height × BytesPerPixel × FPS

Total_BW = DDR_Write_BW + DDR_Read_BW

Example for 1920×1080 RGB888 at 30 fps:

Frame size = 1920 × 1080 × 3

= 6,220,800 bytes

Write bandwidth = 6,220,800 × 30

= 186,624,000 bytes/s

≈ 186.6 MB/s

If one read and one write are required:

Total DDR bandwidth ≈ 373.2 MB/s

This excludes overhead, cache effects, burst inefficiency, and additional software accesses.

## 25.15 Ethernet UDP Performance

UDP streaming performance depends on frame size, packet size, software overhead, network throughput, and host receiver speed.

The source design uses LwIP for UDP/IP video streaming and selects UDP because it is connectionless and faster than TCP for video transport.

UDP payload bandwidth:

UDP_Payload_BW = Width × Height × BytesPerPixel × FPS

Example for 1280×720 RGB888 at 30 fps:

Payload = 1280 × 720 × 3 × 30

= 82,944,000 bytes/s

≈ 82.9 MB/s

≈ 663.6 Mbps

This is before Ethernet/IP/UDP overhead. For 1 GbE, this is feasible only if software overhead, packetization, host receive processing, and system buffering are efficient.

For 1920×1080 RGB888 at 30 fps:

Payload = 1920 × 1080 × 3 × 30

= 186.6 MB/s

≈ 1.49 Gbps

This exceeds practical 1 GbE payload capacity. Therefore, 1080p30 RGB888 uncompressed UDP streaming should use lower frame rate, reduced resolution, RGB565, grayscale, compression, or frame skipping.

## 25.16 Algorithm-Specific Performance

Different video-processing functions have different performance risks.

| **Algorithm**     | **Performance Risk** | **Mitigation**                                 |
|-------------------|----------------------|------------------------------------------------|
| RGB bypass        | Low                  | Simple register pipeline                       |
| Sharp/blur/emboss | Medium               | Shared 3×3 window generator                    |
| Sobel             | Medium/high          | Pipeline gradient calculation                  |
| RGB↔HSL           | High                 | Pipeline division and hue logic                |
| CCM               | Medium/high          | DSP pipeline                                   |
| K-means           | High                 | Pipelined distance engines and comparator tree |
| Histogram         | Medium               | Handle same-bin hazards                        |
| Local threshold   | Medium/high          | Efficient line buffers and reciprocal average  |
| UDP output        | High                 | Packet pacing and frame throttling             |

Performance must be measured per mode. A design may meet timing in bypass mode but fail throughput in K-means or HSL mode.

## 25.17 K-Means Performance Evaluation

K-means performance scales with K.

Work per pixel ≈ K distance calculations + minimum search

For K = 90, the datapath must evaluate 90 references or use a partially parallel architecture. The fully parallel version has high resource demand but can preserve one pixel per clock. A time-multiplexed version saves resources but may reduce throughput unless the processing clock is much faster than the pixel rate.

Evaluation metrics:

| **Metric**                      | **Description**                    |
|---------------------------------|------------------------------------|
| Distance calculations per pixel | Number of centroid comparisons     |
| Comparator tree latency         | Cycles to select minimum distance  |
| Output pixel rate               | Sustained pixels per second        |
| Palette read latency            | Delay from palette access          |
| Tie-handling determinism        | Stable result when distances match |
| Resource-per-K scaling          | LUT/DSP/FF growth with K           |

Recommended target:

Sustained K-means throughput = 1 pixel per clock

## 25.18 Histogram Performance Evaluation

Histogram performance depends on whether every valid pixel can increment a bin without losing counts.

Critical cases:

| **Case**         | **Reason**                       |
|------------------|----------------------------------|
| Constant image   | Every pixel updates the same bin |
| Ramp image       | Sequential bins update           |
| Checkerboard     | Repeated alternating bins        |
| Random image     | Typical distribution             |
| Full white/black | Worst-case single-bin pressure   |

For a constant image:

all pixels → same histogram bin

This stresses read-modify-write hazard handling. If the histogram result is lower than expected, the update path is dropping increments.

## 25.19 Resource Efficiency Metrics

Performance should be considered together with resource usage.

Useful efficiency metrics:

PixelsPerSecondPerLUT = PixelThroughput / LUT_Count

PixelsPerSecondPerDSP = PixelThroughput / DSP_Count

FramesPerSecondPerBRAM = FrameRate / BRAM_Count

These are not absolute quality measures, but they help compare alternative architectures.

Example comparison:

| **Architecture**   | **Throughput** | **Resource Cost** | **Best Use**                         |
|--------------------|----------------|-------------------|--------------------------------------|
| Fully parallel     | Highest        | Highest           | Real-time high resolution            |
| Time-multiplexed   | Lower          | Lower             | Low-resource or low-resolution modes |
| Pipelined parallel | High           | Medium/high       | Balanced real-time design            |
| Software-assisted  | Low/variable   | Low PL usage      | Non-real-time control/statistics     |

## 25.20 Timing Performance

Timing performance is evaluated through implementation timing reports.

Important timing metrics:

| **Metric**        | **Meaning**                            |
|-------------------|----------------------------------------|
| WNS               | Worst negative setup slack             |
| TNS               | Total negative setup slack             |
| WHS               | Worst hold slack                       |
| THS               | Total hold slack                       |
| Fmax              | Maximum achievable clock frequency     |
| Clock uncertainty | Timing margin reserved for jitter/skew |
| Critical path     | Slowest path limiting clock frequency  |

Passing condition:

WNS ≥ 0

TNS = 0

WHS ≥ 0

THS = 0

For a 300 MHz clock, the period is:

Clock period = 1 / 300 MHz

= 3.333 ns

All combinational logic between registers in that domain must fit within the timing budget after routing delay and clock uncertainty.

## 25.21 Stall and Backpressure Evaluation

A streaming pipeline must be evaluated for stalls.

Definitions:

| **Term**        | **Meaning**                                      |
|-----------------|--------------------------------------------------|
| Input stall     | Upstream has valid data but DUT cannot accept it |
| Output stall    | DUT has output data but downstream is not ready  |
| Backpressure    | Downstream ready controls upstream flow          |
| Bubble          | Empty cycle inside a pipeline                    |
| Dropped pixel   | Pixel lost due to invalid flow control           |
| Frame underflow | Output lacks data when required                  |
| Frame overflow  | Buffer receives more data than it can store      |

Stall measurement:

StallRate = StallCycles / TotalActiveCycles

For real-time deterministic video, the ideal stall rate in active video is:

StallRate = 0 during active pixels

## 25.22 Output Quality Performance

Performance evaluation should include image quality, not only speed.

Quality metrics:

| **Metric**              | **Description**                             |
|-------------------------|---------------------------------------------|
| Pixel mismatch count    | Number of pixels different from reference   |
| Maximum channel error   | Largest absolute RGB error                  |
| Mean absolute error     | Average absolute pixel error                |
| Histogram difference    | Distribution difference                     |
| Edge preservation score | Sobel/local threshold quality               |
| Color error             | RGB/HSV/HSL/YCbCr mismatch                  |
| Visual artifact check   | Human inspection for tearing, tint, flicker |

For deterministic modules such as pass-through, palette lookup, and histogram, the expected mismatch should be zero. For fixed-point color conversion, a small documented tolerance may be acceptable.

## 25.23 Long-Run Stability Evaluation

A video system can pass short tests but fail after minutes due to buffer drift, memory leak, counter overflow, or network instability.

Recommended long-run tests:

| **Test Duration** | **Purpose**                   |
|-------------------|-------------------------------|
| 1 minute          | Basic stream stability        |
| 10 minutes        | Thermal and network stability |
| 1 hour            | Buffer and counter stability  |
| Overnight         | Extended endurance validation |

Track:

- Frame count.

- Dropped frames.

- Packet loss.

- FIFO overflow/underflow.

- MIPI errors.

- VDMA errors.

- CPU load.

- Temperature.

- Timing-related artifacts.

## 25.24 Hardware Counter Set for Performance

A performance counter block should expose:

| **Counter**         | **Description**               |
|---------------------|-------------------------------|
| perf_input_pixels   | Total accepted input pixels   |
| perf_output_pixels  | Total produced output pixels  |
| perf_input_frames   | Total input frames            |
| perf_output_frames  | Total output frames           |
| perf_stall_cycles   | Cycles where pipeline stalled |
| perf_active_cycles  | Cycles during active video    |
| perf_dropped_frames | Frames lost or skipped        |
| perf_fifo_overflow  | FIFO overflow events          |
| perf_fifo_underflow | FIFO underflow events         |
| perf_udp_packets    | UDP packets transmitted       |
| perf_udp_bytes      | UDP payload bytes transmitted |
| perf_error_flags    | Sticky error summary          |

Measured throughput:

Throughput = perf_output_pixels / measurement_time

Frame integrity:

FrameDropRate = perf_dropped_frames / perf_input_frames

## 25.25 Test Cases for Performance Evaluation

Recommended performance test cases:

| **Test Case**            | **Purpose**                   |
|--------------------------|-------------------------------|
| RGB bypass 1080p30       | Baseline pipeline performance |
| RGB bypass 4K30          | High-resolution baseline      |
| Sobel 1080p30            | Spatial-filter throughput     |
| Sobel 4K30               | Line-buffer stress            |
| HSL/HSV 1080p30          | Arithmetic pipeline stress    |
| CCM 4K30                 | DSP throughput stress         |
| K-means K=90 1080p30     | Comparator/distance stress    |
| Histogram constant image | Same-bin hazard stress        |
| UDP 720p30 RGB888        | Network payload stress        |
| UDP 1080p reduced format | Bandwidth mitigation test     |
| Sensor full mode         | Camera input stress           |
| Long-run bypass          | Stability test                |
| Long-run full pipeline   | Endurance test                |

## 25.26 Performance Report Template

A professional performance report should include:

Design Version:

Bitstream Version:

Board:

Sensor:

Resolution:

Frame Rate Target:

Pixel Format:

Active Processing Mode:

Clock Frequencies:

Resource Utilization:

Timing Summary:

Input Pixel Count:

Output Pixel Count:

Measured FPS:

Pipeline Latency:

DDR Bandwidth:

UDP Bandwidth:

Dropped Frames:

Error Flags:

Image Quality Result:

Conclusion:

Example result table:

| **Item**             | **Value**                   |
|----------------------|-----------------------------|
| Board                | Kria KV260                  |
| Mode                 | 1920×1080p60 RAW10 input    |
| Processing           | RGB bypass                  |
| Required pixel clock | 148.5 MHz                   |
| Processing clock     | 300 MHz                     |
| Target FPS           | 60                          |
| Measured FPS         | To be measured              |
| Dropped frames       | To be measured              |
| Timing               | WNS ≥ 0 required            |
| Result               | Pass/fail after measurement |

## 25.27 Performance Bottleneck Identification

When the system fails performance targets, isolate the bottleneck.

| **Symptom**       | **Likely Bottleneck**                               |
|-------------------|-----------------------------------------------------|
| MIPI errors       | Lane rate, sensor configuration, D-PHY timing       |
| Input frame drops | Capture path or CDC FIFO                            |
| VCP stalls        | Processing block not one pixel per clock            |
| Timing violation  | Long arithmetic or comparator path                  |
| DDR underflow     | VDMA/DDR bandwidth or burst efficiency              |
| UDP packet loss   | Network bandwidth, software overhead, host receiver |
| Display tearing   | Frame buffer synchronization                        |
| Wrong frame rate  | Clock configuration or frame timing                 |
| High CPU usage    | Software packetization or cache maintenance         |
| Heat/power issue  | Excessive switching or parallel logic               |

Bottleneck analysis should change one variable at a time: resolution, frame rate, pixel format, processing mode, or output path.

## 25.28 Optimization Based on Evaluation

Performance results should guide optimization.

| **Problem**            | **Optimization**                                                |
|------------------------|-----------------------------------------------------------------|
| Processing too slow    | Add pipeline stages or reduce mode complexity                   |
| K-means too large      | Use Manhattan distance or reduce K                              |
| Ethernet saturated     | Lower resolution, RGB565, grayscale, compression, or frame skip |
| DDR saturated          | Reduce buffering, optimize bursts, reduce pixel width           |
| Timing fails           | Pipeline critical paths and register mux outputs                |
| Resource usage high    | Disable unused build-time features                              |
| Histogram drops counts | Add same-bin forwarding                                         |
| Latency too high       | Stream lines instead of full frames where possible              |
| Power too high         | Disable unused modules and reduce toggle rate                   |

## 25.29 Performance Sign-Off Criteria

A performance sign-off should require:

| **Criterion**                           | **Required Result** |
|-----------------------------------------|---------------------|
| Target mode runs at required FPS        | Pass                |
| Pixel count matches expected frame size | Pass                |
| No unexplained dropped frames           | Pass                |
| No FIFO overflow/underflow              | Pass                |
| Timing closed for all active clocks     | Pass                |
| Resource utilization within margin      | Pass                |
| DDR bandwidth stable                    | Pass                |
| UDP bandwidth stable if enabled         | Pass                |
| Output image quality meets tolerance    | Pass                |
| Long-run stability verified             | Pass                |
| Known limitations documented            | Pass                |

A design that works only at reduced resolution should not be claimed as full-resolution capable unless the reduced mode is explicitly documented.

## 25.30 Chapter Summary

This chapter described performance evaluation for the FPGA Video Color Processing System. The evaluation covers pixel clock, frame rate, throughput, bandwidth, latency, DDR/VDMA behavior, UDP streaming performance, algorithm-specific cost, resource efficiency, timing closure, output quality, and long-run stability.

The source document provides the core performance equations: pixel clock equals total horizontal samples times total vertical lines times refresh rate, bandwidth equals pixel clock times pixel size, and lane rate equals total bandwidth divided by lane count. It also provides example calculations for 1080p60 RAW10, 2560×1080 RAW10, and 3840×2160 RAW8 operating modes.

A complete performance evaluation must combine theoretical calculations, simulation results, implementation timing reports, hardware counters, output-frame validation, network measurements, and long-run stability tests. This ensures that the design is not only functionally correct but also capable of sustained real-time operation on the target FPGA platform.
