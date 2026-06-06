# Chapter 5 — Video Timing, Bandwidth, and Data Rate Analysis

## 5.1 Overview

Video timing, bandwidth, and data-rate analysis are essential for validating whether the FPGA video-processing pipeline can sustain the required image resolution, frame rate, pixel format, and output interface bandwidth. A real-time video system must move every pixel through the capture, processing, and output stages without dropping data or violating frame timing.

The FPGA Video Color Processing System uses camera input, MIPI CSI-2 reception, RAW pixel capture, RGB conversion, video-processing logic, and output transport. Each subsystem must be sized according to the required pixel rate and data width.

The design document identifies the system clocking structure and states that the design uses multiple clocks, including a 300 MHz clock for AXI video configuration and processing, a 200 MHz clock for MIPI D-PHY video input, and a 297 MHz clock for video output.

This chapter defines the timing and bandwidth calculations used to evaluate the system.

## 5.2 Video Timing Fundamentals

A video frame is composed of active pixels and blanking intervals. The active region contains visible image data, while blanking intervals provide timing separation between lines and frames.

The main timing parameters are:

| **Parameter**    | **Description**                                                 |
|------------------|-----------------------------------------------------------------|
| Active width     | Number of visible pixels per line                               |
| Active height    | Number of visible lines per frame                               |
| Horizontal total | Active pixels plus horizontal blanking                          |
| Vertical total   | Active lines plus vertical blanking                             |
| Refresh rate     | Number of frames per second                                     |
| Pixel clock      | Clock rate required to transmit all active and blanking samples |
| Pixel format     | Number of bits used per pixel or sample                         |
| Lane count       | Number of physical serial lanes used for MIPI transport         |

The pixel clock is normally calculated using the total horizontal samples and total vertical lines, not only the active resolution. This is because the video interface must also account for blanking intervals.

## 5.3 Pixel Clock Frequency

The pixel clock frequency defines how many pixel timing samples must be transferred per second. It is calculated as:

Pixel Clock Frequency = Total Horizontal Samples × Total Vertical Lines × Refresh Rate

Where:

- **Total Horizontal Samples** = active horizontal pixels + horizontal blanking.

- **Total Vertical Lines** = active vertical lines + vertical blanking.

- **Refresh Rate** = frames per second.

The source document gives the same calculation model for pixel clock frequency.

**Example Interpretation**

For a 1920×1080p60 video mode with standard timing totals:

Total Horizontal Samples = 2200

Total Vertical Lines = 1125

Refresh Rate = 60 Hz

Pixel Clock = 2200 × 1125 × 60

= 148,500,000 Hz

= 148.5 MHz

This value represents the required pixel timing rate for the video mode.

## 5.4 Video Clock Requirement

The video clock must be high enough to support the required pixel throughput. If the design processes **one pixel per clock**, then the video-processing clock must be at least equal to the required pixel clock, with additional margin for implementation timing and interface overhead.

For a one-pixel-per-clock pipeline:

Minimum Video Processing Clock ≥ Pixel Clock Frequency

For example:

| **Video Mode** | **Pixel Clock** | **Minimum One-Pixel/Clock Processing Rate** |
|----------------|-----------------|---------------------------------------------|
| 1920×1080p60   | 148.5 MHz       | ≥ 148.5 MHz                                 |
| 2560×1080p30   | 118.8 MHz       | ≥ 118.8 MHz                                 |
| 2560×1080p60   | 237.6 MHz       | ≥ 237.6 MHz                                 |
| 3840×2160p30   | 297 MHz         | ≥ 297 MHz                                   |

The design document lists 300 MHz for video AXI configuration and processing, which provides practical support for modes requiring approximately 297 MHz operation.

## 5.5 Total Data Rate Calculation

Total data rate is the amount of video payload data that must be transported per second. It depends on pixel clock frequency and pixel size.

The source document defines bandwidth as:

Bandwidth = Pixel Clock Frequency × Pixel Size

Where:

- **Pixel Clock Frequency** is measured in Hz.

- **Pixel Size** is measured in bits per pixel or bits per sample.

- **Bandwidth** is measured in bits per second.

For RAW10 input:

Total Data Rate = Pixel Clock × 10 bits

For RGB 10-bit per channel output:

Total Data Rate = Pixel Clock × 30 bits

This distinction is important because camera input bandwidth and internal RGB processing bandwidth may be different.

## 5.6 MIPI Lane Rate Calculation

The MIPI lane rate defines the required data rate per physical MIPI lane. It is calculated by dividing the total data rate by the number of active lanes.

The source document defines line rate as:

Line Rate = Total Data Rate / Number of Data Lanes

For example, if the total RAW10 bandwidth is 1485 Mbps and the camera uses two MIPI lanes:

Lane Rate = 1485 Mbps / 2

= 742.5 Mbps per lane

The lane rate must remain within the supported range of the camera sensor, board routing, MIPI D-PHY, and receiver subsystem.

## 5.7 RAW8, RAW10, and RGB Data Width Considerations

Different stages of the system may use different pixel widths. The input camera stream may use RAW10, while downstream video processing may operate on RGB components.

### 5.7.1 RAW8

RAW8 uses 8 bits per pixel sample:

Data Rate = Pixel Clock × 8

RAW8 reduces bandwidth but provides less sensor precision than RAW10.

### 5.7.2 RAW10

RAW10 uses 10 bits per pixel sample:

Data Rate = Pixel Clock × 10

RAW10 provides higher precision than RAW8 and is commonly used by camera sensors.

### 5.7.3 RGB 8-Bit Per Channel

RGB888 uses 24 bits per pixel:

Data Rate = Pixel Clock × 24

### 5.7.4 RGB 10-Bit Per Channel

RGB with 10 bits per channel uses 30 bits per pixel:

Data Rate = Pixel Clock × 30

This is significantly larger than the RAW10 input stream because each output pixel contains full red, green, and blue channel values.

## 5.8 1920×1080p60 RAW10, 2-Lane Example

The source document provides a 1920×1080p60 RAW10 example using two MIPI lanes. The listed values are:

Total Horizontal Samples = 2200

Total Vertical Lines = 1125

Refresh Rate = 60 Hz

Number of Data Lanes = 2

Pixel per Clock = 1

The document calculates the video clock as 148.5 MHz, the RAW10 bandwidth as 1485 Mbps, and the lane rate as 742.5 Mbps per lane.

**Calculation**

Pixel Clock = 2200 × 1125 × 60

= 148.5 MHz

Bandwidth = 148.5 MHz × 10 bits

= 1485 Mbps

Lane Rate = 1485 Mbps / 2

= 742.5 Mbps per lane

**Result**

| **Parameter**   | **Value**       |
|-----------------|-----------------|
| Resolution      | 1920×1080       |
| Refresh rate    | 60 Hz           |
| Pixel format    | RAW10           |
| Lane count      | 2               |
| Pixel clock     | 148.5 MHz       |
| Total data rate | 1485 Mbps       |
| Lane rate       | 742.5 Mbps/lane |

This example demonstrates that 1080p60 RAW10 input can be supported with a two-lane MIPI interface when each lane supports at least 742.5 Mbps.

## 5.9 2560×1080p30 RAW10, 2-Lane Example

The source document provides a 2560×1080p30 RAW10 example using two MIPI lanes. The listed horizontal total is 3520, vertical total is 1125, and refresh rate is 30 Hz.

**Calculation**

Pixel Clock = 3520 × 1125 × 30

= 118.8 MHz

Bandwidth = 118.8 MHz × 10 bits

= 1188 Mbps

Lane Rate = 1188 Mbps / 2

= 594 Mbps per lane

**Result**

| **Parameter**   | **Value**     |
|-----------------|---------------|
| Resolution      | 2560×1080     |
| Refresh rate    | 30 Hz         |
| Pixel format    | RAW10         |
| Lane count      | 2             |
| Pixel clock     | 118.8 MHz     |
| Total data rate | 1188 Mbps     |
| Lane rate       | 594 Mbps/lane |

This mode requires less bandwidth than 1920×1080p60 because the frame rate is lower, even though the horizontal active width is larger.

## 5.10 2560×1080p60 RAW10, 2-Lane Example

The source document also provides a 2560×1080p60 RAW10 example. The same horizontal and vertical totals are used, but the refresh rate is increased to 60 Hz.

**Calculation**

Pixel Clock = 3520 × 1125 × 60

= 237.6 MHz

Bandwidth = 237.6 MHz × 10 bits

= 2376 Mbps

Lane Rate = 2376 Mbps / 2

= 1188 Mbps per lane

**Result**

| **Parameter**   | **Value**      |
|-----------------|----------------|
| Resolution      | 2560×1080      |
| Refresh rate    | 60 Hz          |
| Pixel format    | RAW10          |
| Lane count      | 2              |
| Pixel clock     | 237.6 MHz      |
| Total data rate | 2376 Mbps      |
| Lane rate       | 1188 Mbps/lane |

Doubling the refresh rate from 30 Hz to 60 Hz doubles the pixel clock, total data rate, and lane rate.

## 5.11 3840×2160p30 RAW8, 4-Lane Example

The source document provides a 3840×2160p30 RAW8 example using four MIPI lanes. The listed timing values are:

Total Horizontal Samples = 4400

Total Vertical Lines = 2250

Refresh Rate = 30 Hz

Pixel format = RAW8

Number of Data Lanes = 4

The document calculates the pixel clock as 297 MHz, bandwidth as 2376 Mbps, and lane rate as 594 Mbps per lane.

**Calculation**

Pixel Clock = 4400 × 2250 × 30

= 297 MHz

Bandwidth = 297 MHz × 8 bits

= 2376 Mbps

Lane Rate = 2376 Mbps / 4

= 594 Mbps per lane

**Result**

| **Parameter**   | **Value**     |
|-----------------|---------------|
| Resolution      | 3840×2160     |
| Refresh rate    | 30 Hz         |
| Pixel format    | RAW8          |
| Lane count      | 4             |
| Pixel clock     | 297 MHz       |
| Total data rate | 2376 Mbps     |
| Lane rate       | 594 Mbps/lane |

This example shows why four lanes are useful for high-resolution input. Even with a high pixel clock, distributing the data across four lanes reduces the per-lane rate.

## 5.12 3840×2160p30 RAW10, 4-Lane Derived Example

For RAW10 at 3840×2160p30 using the same timing totals:

Total Horizontal Samples = 4400

Total Vertical Lines = 2250

Refresh Rate = 30 Hz

Pixel Format = RAW10

Number of Data Lanes = 4

**Calculation**

Pixel Clock = 4400 × 2250 × 30

= 297 MHz

Bandwidth = 297 MHz × 10 bits

= 2970 Mbps

Lane Rate = 2970 Mbps / 4

= 742.5 Mbps per lane

**Result**

| **Parameter**   | **Value**       |
|-----------------|-----------------|
| Resolution      | 3840×2160       |
| Refresh rate    | 30 Hz           |
| Pixel format    | RAW10           |
| Lane count      | 4               |
| Pixel clock     | 297 MHz         |
| Total data rate | 2970 Mbps       |
| Lane rate       | 742.5 Mbps/lane |

This derived example is important because the camera input path uses RAW10 in the documented MIPI CSI-2 receiver configuration. The Vivado configuration identifies RAW10 as the selected pixel format for both receiver instances.

## 5.13 Internal RGB Bandwidth After Demosaic

After demosaic conversion, the stream expands from one RAW sample per pixel to a full RGB pixel. If each RGB component uses 10 bits, then each pixel becomes 30 bits.

For 3840×2160p30 RGB 10-bit per channel:

Pixel Clock = 297 MHz

RGB Bandwidth = 297 MHz × 30 bits

= 8910 Mbps

= 8.91 Gbps

For RGB888:

RGB Bandwidth = 297 MHz × 24 bits

= 7128 Mbps

= 7.128 Gbps

This means the internal RGB stream can require substantially more bandwidth than the RAW camera input. The AXI4-Stream bus width, processing clock, and downstream output interfaces must be sized accordingly.

## 5.14 Output Bandwidth Considerations

The output bandwidth depends on the selected output path.

### 5.14.1 DisplayPort Output

DisplayPort output must support the selected display resolution, refresh rate, and pixel format. For high-resolution modes, the output clock and display timing must match the configured video mode.

The source timing table includes 3840×2160 progressive video modes with 297 MHz pixel clock for 30 Hz operation and 594 MHz pixel clock for 60 Hz operation.

### 5.14.2 Ethernet UDP Output

Ethernet UDP streaming must account for:

- Pixel payload bandwidth.

- Packet headers.

- Frame headers.

- UDP/IP/Ethernet overhead.

- Packet gap and software handling overhead.

- Possible packet loss.

For uncompressed high-resolution RGB video, Ethernet bandwidth requirements can exceed typical 1 GbE capability. Therefore, Ethernet streaming may require reduced resolution, reduced frame rate, pixel packing, compression, or region-based streaming.

### 5.14.3 VDMA Memory Output

VDMA-based memory transfer must support read and write bandwidth to DDR memory. If both stream-to-memory and memory-to-stream operations are active, the DDR subsystem must support combined bandwidth.

For example, one RGB888 3840×2160p30 stream requires:

Active Pixel Payload = 3840 × 2160 × 30 × 24

= 5,971,968,000 bits/s

≈ 5.97 Gbps

≈ 746.5 MB/s

This calculation uses active pixels only and does not include blanking or memory overhead.

## 5.15 Active-Pixel Payload Versus Timing Payload

There are two useful bandwidth views:

| **Bandwidth Type**             | **Calculation Basis**                                   | **Use Case**                                    |
|--------------------------------|---------------------------------------------------------|-------------------------------------------------|
| Timing payload bandwidth       | Total horizontal × total vertical × refresh rate × bits | Interface timing and pixel clock planning       |
| Active-pixel payload bandwidth | Active width × active height × refresh rate × bits      | Memory, storage, and network payload estimation |

### 5.15.1 Timing Payload

Timing payload includes blanking intervals and is used for display timing, camera timing, and stream clock planning.

### 5.15.2 Active-Pixel Payload

Active-pixel payload includes only visible image pixels and is useful for estimating memory bandwidth and Ethernet payload requirements.

For 3840×2160p30 RGB888 active-pixel payload:

Active Pixels per Frame = 3840 × 2160

= 8,294,400 pixels

Active Pixels per Second = 8,294,400 × 30

= 248,832,000 pixels/s

Payload = 248,832,000 × 24

= 5,971,968,000 bits/s

≈ 5.97 Gbps

## 5.16 Clock-Domain Planning

The design includes separate clock domains for input, processing, and output. Clock-domain planning is necessary because not all subsystems operate at the same rate.

The documented clock plan includes:

| **Clock** | **Purpose**                            |
|-----------|----------------------------------------|
| 100 MHz   | PL fabric base clock from the MPSoC    |
| 300 MHz   | AXI video configuration and processing |
| 200 MHz   | MIPI D-PHY video input                 |
| 297 MHz   | Video output                           |

### 5.16.1 Clock-Domain Crossing Requirements

Clock-domain crossings may be required between:

- MIPI input clock domain and video-processing clock domain.

- Video-processing clock domain and video-output clock domain.

- AXI4-Lite control clock domain and video datapath clock domain.

- VDMA memory clock domain and stream clock domain.

Safe crossing methods include:

- Dual-clock FIFOs.

- AXI clock converters.

- Register synchronizers.

- Handshake synchronizers.

- Reset synchronizers.

Improper clock-domain crossing can result in metastability, corrupted pixels, lost frame markers, or intermittent video failure.

## 5.17 One-Pixel-Per-Clock Throughput Model

The MIPI CSI-2 receiver configuration lists **one pixel per clock** operation.

In a one-pixel-per-clock pipeline, the design should accept a new pixel every clock cycle when the stream is active.

The ideal throughput is:

Pixels per Second = Processing Clock Frequency × Pixels per Clock

For a 297 MHz processing clock:

Pixels per Second = 297,000,000 × 1

= 297,000,000 pixels/s

This supports video modes whose total pixel timing rate is less than or equal to 297 MHz, assuming no sustained backpressure.

## 5.18 Backpressure and Throughput Loss

AXI4-Stream supports backpressure through the TREADY signal. When a downstream block deasserts TREADY, upstream data transfer pauses.

Backpressure can be caused by:

- Output interface stalls.

- FIFO almost-full conditions.

- VDMA memory latency.

- Clock-domain crossing congestion.

- Ethernet packetization delay.

- Processing module not ready.

- Software-controlled pipeline interruption.

In real-time video, sustained backpressure is dangerous because the camera source usually continues producing data. If upstream buffering is insufficient, pixels or whole frames may be dropped.

Design techniques to reduce backpressure risk include:

- Fully pipelined processing stages.

- Adequate FIFO depth.

- Stable output timing.

- Memory bandwidth margin.

- Avoiding software dependency in the pixel path.

- Using frame-boundary mode changes.

## 5.19 Bandwidth Margin

A reliable design should not operate exactly at the theoretical bandwidth limit. Margin is required to account for implementation effects, protocol overhead, clock tolerance, arbitration, and memory contention.

Recommended margin planning includes:

| **Area**            | **Recommended Consideration**                        |
|---------------------|------------------------------------------------------|
| MIPI lane rate      | Keep below maximum supported lane rate when possible |
| Processing clock    | Provide margin above minimum pixel rate              |
| AXI stream width    | Avoid unnecessary packing bottlenecks                |
| DDR bandwidth       | Include read/write overlap and burst inefficiency    |
| Ethernet streaming  | Include UDP/IP/Ethernet header overhead              |
| Display output      | Match timing generator and pixel clock accurately    |
| Clock crossing FIFO | Size for short-term rate mismatch                    |

For high-resolution video, memory and output interfaces often become the limiting resources rather than the internal arithmetic pipeline.

## 5.20 Design Validation Checklist

The following checklist should be used to validate video timing and bandwidth assumptions.

### 5.20.1 Timing Checklist

- Confirm active resolution.

- Confirm horizontal total samples.

- Confirm vertical total lines.

- Confirm refresh rate.

- Calculate pixel clock.

- Confirm processing clock is sufficient.

- Confirm output clock matches selected video mode.

- Confirm frame and line timing are preserved.

### 5.20.2 Bandwidth Checklist

- Confirm input pixel format.

- Calculate input RAW bandwidth.

- Calculate MIPI lane rate.

- Calculate internal RGB bandwidth.

- Calculate output display bandwidth.

- Calculate Ethernet payload bandwidth if used.

- Calculate VDMA memory bandwidth if used.

- Add protocol overhead and design margin.

### 5.20.3 Interface Checklist

- Confirm MIPI lane count.

- Confirm AXI4-Stream data width.

- Confirm pixels per clock.

- Confirm FIFO depth across clock domains.

- Confirm DDR bandwidth if frame buffering is active.

- Confirm DisplayPort output timing.

- Confirm UDP packetization rate if streaming over Ethernet.

## 5.21 Chapter Summary

This chapter defined the timing, bandwidth, and data-rate calculations required for the FPGA Video Color Processing System.

The core timing equation is:

Pixel Clock Frequency = Total Horizontal Samples × Total Vertical Lines × Refresh Rate

The core bandwidth equation is:

Bandwidth = Pixel Clock Frequency × Pixel Size

The MIPI lane-rate equation is:

Lane Rate = Total Data Rate / Number of Data Lanes

The documented design examples include 1920×1080p60 RAW10 at 148.5 MHz and 742.5 Mbps per lane over two lanes, 2560×1080p30 RAW10 at 118.8 MHz and 594 Mbps per lane, 2560×1080p60 RAW10 at 237.6 MHz and 1188 Mbps per lane, and 3840×2160p30 RAW8 at 297 MHz and 594 Mbps per lane over four lanes.

A reliable real-time video design must ensure that the camera input path, AXI4-Stream processing path, memory subsystem, and output interface all support the selected resolution, frame rate, and pixel format with sufficient timing and bandwidth margin.
