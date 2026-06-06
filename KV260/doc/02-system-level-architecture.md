# Chapter 2 — System-Level Architecture

## 2.1 Overview of the System-Level Architecture

The FPGA Video Color Processing System is organized as a real-time camera-to-output video pipeline. The architecture receives image data from one or more camera sensors, converts the raw sensor stream into RGB video, applies programmable video-processing operations, and forwards the processed video stream to display or network output interfaces.

The system is designed around a **capture–process–output** model:

Camera Input

↓

MIPI CSI-2 Receiver

↓

RAW Pixel Capture

↓

Demosaic Processing

↓

RGB Video Stream

↓

Video Color Processing Module

↓

DisplayPort / Ethernet / Memory Output

At the system level, the design combines:

- **Programmable Logic (PL)** for high-speed video datapath processing.

- **Processing System (PS)** for configuration, control, software management, and output coordination.

- **AXI4-Stream interfaces** for real-time pixel movement.

- **AXI4-Lite interfaces** for register-based control.

- **Clock-domain management** for camera input, processing, and output timing.

- **Video synchronization signals** for preserving frame and line structure.

This division allows computationally intensive pixel operations to execute in FPGA hardware while software manages configuration, mode selection, and system supervision.

## 2.2 End-to-End Video Data Flow

The end-to-end video data flow begins at the camera sensor and ends at the selected video output interface. Each stage transforms, synchronizes, or routes the video stream.

### 2.2.1 Input Stage

The input stage receives raw image data from camera sensors through a MIPI CSI-2 physical interface. The camera output is generally formatted as RAW10 Bayer-pattern data. This data is captured by the MIPI CSI-2 RX subsystem and converted into a stream format suitable for downstream hardware processing.

Primary functions of the input stage include:

1.  Camera sensor configuration.

2.  MIPI lane reception.

3.  RAW10 pixel capture.

4.  Frame and line boundary detection.

5.  Stream formatting for internal processing.

### 2.2.2 Pre-Processing Stage

The pre-processing stage converts raw Bayer-pattern data into RGB pixels. Since the raw camera stream contains only one color component per pixel location, demosaic processing is required to reconstruct complete red, green, and blue values.

The output of this stage is a synchronized RGB pixel stream.

### 2.2.3 Processing Stage

The processing stage contains the custom **Video Color Processing (VCP)** module. This module applies selected operations to each pixel or pixel neighborhood.

Supported operations include:

- Image enhancement.

- Color correction.

- RGB gain control.

- Color-space conversion.

- Spatial filtering.

- K-means color clustering.

- Programmable color schemes.

- Local threshold segmentation.

The VCP module operates on the streaming video path and is designed to maintain real-time throughput.

### 2.2.4 Output Stage

The output stage routes the processed video stream to one or more output interfaces.

Typical output paths include:

- **DisplayPort output** for direct visual display.

- **Ethernet UDP streaming** for network transmission.

- **VDMA-based memory buffering** for frame movement through external memory.

The output stage must preserve pixel ordering, line boundaries, frame boundaries, and video timing metadata.

## 2.3 Processing System and Programmable Logic Partitioning

The target platform uses a Zynq UltraScale+ MPSoC architecture, which contains both a software-capable processing system and FPGA programmable logic.

The system is divided into two main functional domains:

| **Domain**         | **Main Responsibility**                                                                     |
|--------------------|---------------------------------------------------------------------------------------------|
| Processing System  | Software control, configuration, initialization, register access, output management         |
| Programmable Logic | Camera capture, stream processing, filtering, color conversion, clustering, video transport |

### 2.3.1 Processing System Responsibilities

The Processing System is responsible for system management and software-controlled configuration. It does not perform the main pixel-by-pixel processing workload. Instead, it initializes and supervises the hardware pipeline.

Typical PS responsibilities include:

- Configuring camera sensors through I2C.

- Initializing MIPI CSI-2 receiver settings.

- Configuring VCP control registers.

- Selecting processing modes.

- Managing DisplayPort output.

- Managing Ethernet streaming software.

- Starting, stopping, and monitoring pipeline operation.

- Reading diagnostic and status registers.

### 2.3.2 Programmable Logic Responsibilities

The Programmable Logic implements the real-time video datapath. It performs operations that require high throughput and deterministic timing.

Typical PL responsibilities include:

- Receiving MIPI CSI-2 video data.

- Handling RAW10 pixel streams.

- Performing demosaic conversion.

- Transporting pixels through AXI4-Stream.

- Applying filters and color conversions.

- Applying K-means clustering.

- Managing line buffers and local pixel neighborhoods.

- Sending processed video toward output interfaces.

The PL is optimized for parallelism and pipelining. This allows the design to process one or more pixels per clock cycle depending on configuration.

## 2.4 High-Level Block Architecture

The system-level architecture can be represented as a set of connected functional blocks:

+------------------+

\| Camera Sensor \|

\| IMX477 / AR1335 \|

+--------+---------+

\|

v

+------------------+

\| MIPI CSI-2 RX \|

\| + MIPI D-PHY \|

+--------+---------+

\|

v

+------------------+

\| RAW10 Capture \|

\| Stream Formatter \|

+--------+---------+

\|

v

+------------------+

\| Demosaic Module \|

\| RAW to RGB \|

+--------+---------+

\|

v

+------------------------------+

\| Video Color Processing Module\|

\| Filters / Color Conversion \|

\| K-Means / Enhancement \|

+--------+---------------------+

\|

v

+-----------------------------+

\| Output Routing \|

\| DisplayPort / UDP / VDMA \|

+-----------------------------+

Each block performs a defined function and passes data to the next stage using a streaming interface. This structure supports modular development and allows individual processing blocks to be added, removed, or replaced.

## 2.5 AXI4-Stream Video Pipeline

The video datapath is based on AXI4-Stream. AXI4-Stream is suitable for real-time video because it provides a continuous data-transfer model with handshake and sideband signals.

A typical AXI4-Stream video interface includes:

| **Signal** | **Purpose**                                         |
|------------|-----------------------------------------------------|
| TDATA      | Carries pixel data.                                 |
| TVALID     | Indicates that the source is presenting valid data. |
| TREADY     | Indicates that the destination can accept data.     |
| TLAST      | Usually marks the end of a video line.              |
| TUSER      | Often marks the start of a video frame.             |
| ACLK       | Stream clock.                                       |
| ARESETN    | Active-low reset.                                   |

The AXI4-Stream protocol allows the video pipeline to maintain synchronization while supporting backpressure through the TREADY signal.

### 2.5.1 Pixel Transport

Each pixel or group of pixels is carried through the TDATA bus. For RGB video, the data bus may contain red, green, and blue channel values packed into a single stream word.

Example RGB packing:

TDATA\[29:20\] = Red

TDATA\[19:10\] = Green

TDATA\[9:0\] = Blue

The exact packing depends on the selected pixel width and implementation configuration.

### 2.5.2 Frame and Line Signaling

Video streams require line and frame boundary markers.

Common conventions include:

- TUSER asserted at the first pixel of a frame.

- TLAST asserted at the final pixel of a line.

- TVALID asserted when pixel data is valid.

- TREADY asserted when the downstream block can receive data.

Maintaining these signals correctly is essential for display output, frame buffering, and downstream image-processing alignment.

## 2.6 AXI4-Lite Configuration Interface

AXI4-Lite is used for register-based control of the video-processing system. Unlike AXI4-Stream, which carries high-speed pixel data, AXI4-Lite carries low-bandwidth configuration and status transactions.

The AXI4-Lite interface allows software to control the hardware pipeline by writing configuration registers and reading status registers.

Typical AXI4-Lite register functions include:

- Enable or disable the VCP module.

- Select active processing mode.

- Configure brightness, contrast, and saturation.

- Configure RGB gain.

- Select color-space conversion mode.

- Enable filter blocks.

- Configure threshold values.

- Select palette or color scheme.

- Read diagnostic status.

- Read frame counters or error indicators.

This separation of control path and data path allows the video stream to remain hardware-driven while software updates operating parameters.

## 2.7 Video Input Subsystem

The video input subsystem receives camera data and prepares it for processing. It includes the physical camera connection, MIPI receiver, stream formatter, and raw-to-RGB conversion stage.

### 2.7.1 Camera Sensor Input

The camera sensor captures light and converts it into digital pixel data. The design supports MIPI-based sensors such as IMX477 and AR1335-class devices.

Camera configuration is typically performed through I2C, while pixel data is transmitted through MIPI CSI-2 lanes.

### 2.7.2 MIPI CSI-2 Receiver

The MIPI CSI-2 receiver captures serialized camera data and converts it into a parallel pixel stream. It works with the MIPI D-PHY layer, which handles the physical signaling.

Important receiver parameters include:

- Pixel format.

- Number of data lanes.

- Line rate.

- Virtual channel selection.

- TUSER width.

- CRC enablement.

- Pixels per clock.

### 2.7.3 RAW10 Stream Handling

RAW10 format represents each pixel using 10 bits. The receiver and stream formatter must preserve pixel order and align data correctly before demosaic conversion.

RAW10 stream handling includes:

- Bit unpacking.

- Pixel alignment.

- Frame boundary detection.

- Line boundary detection.

- Conversion into internal stream format.

## 2.8 Demosaic and RGB Stream Generation

Most image sensors output Bayer-pattern data instead of full RGB pixels. In a Bayer pattern, each pixel location contains only one color component: red, green, or blue. Demosaic processing reconstructs full RGB values by using neighboring pixel information.

The demosaic module converts:

RAW Bayer Pixel Stream → RGB Pixel Stream

The output of the demosaic stage is a stream where each pixel contains red, green, and blue components. This RGB stream becomes the primary input to the Video Color Processing module.

Demosaic processing must preserve:

- Pixel position.

- Frame alignment.

- Line alignment.

- Channel reconstruction accuracy.

- Stream timing.

## 2.9 Video Color Processing Module Placement

The VCP module is placed after demosaic conversion and before the final output stage. This placement allows the module to operate on complete RGB pixel data rather than raw Bayer data.

MIPI RX → RAW Capture → Demosaic → VCP → Output

This is the most practical location for operations such as:

- RGB gain adjustment.

- Color correction.

- RGB-to-HSL conversion.

- HSL-to-RGB conversion.

- Sobel edge detection.

- Blur and sharp filters.

- K-means color clustering.

- Programmable color mapping.

The VCP module receives a valid RGB stream, processes it according to the selected mode, and outputs a modified RGB stream.

## 2.10 Output Subsystem

The output subsystem routes processed video to display, memory, or network interfaces.

### 2.10.1 DisplayPort Output

DisplayPort output is used for direct visual display. The processed video stream is routed from programmable logic to the DisplayPort interface managed by the processing system.

Display output requires correct:

- Pixel format.

- Resolution timing.

- Frame synchronization.

- Line synchronization.

- Video clocking.

### 2.10.2 Ethernet UDP Video Streaming

Ethernet UDP streaming allows processed video data to be transmitted over a network. This path is useful for remote viewing, host-side processing, and debugging.

UDP video streaming requires:

- Packet formatting.

- Frame segmentation.

- Packet sequence management.

- Bandwidth planning.

- Host-side receiver compatibility.

### 2.10.3 VDMA-Based Memory Transfer

VDMA may be used to transfer video frames to or from external memory. This supports buffering, software access, or display pipelines that require memory-backed frame transport.

VDMA operation requires coordination between:

- AXI4-Stream video input.

- AXI memory-mapped interfaces.

- DDR memory.

- Software control registers.

- Frame buffer addresses.

## 2.11 Clocking Architecture

The system uses multiple clock domains because different subsystems operate at different rates. Camera input, video processing, output timing, and control interfaces may each require independent clocks.

Typical clock domains include:

| **Clock Domain**       | **Purpose**                            |
|------------------------|----------------------------------------|
| MIPI/D-PHY clock       | Camera data reception                  |
| Video processing clock | Pixel-processing pipeline              |
| AXI4-Lite clock        | Register control interface             |
| Display clock          | DisplayPort output timing              |
| Ethernet/system clock  | Network and software subsystem support |

Clocking must be planned carefully to avoid data loss, metastability, and timing violations.

### 2.11.1 Clock-Domain Crossing

When data or control signals pass between different clock domains, clock-domain crossing logic is required.

Common CDC techniques include:

- Dual-clock FIFOs.

- Register synchronization.

- Handshake synchronizers.

- Reset synchronization.

- Gray-coded counters for buffer pointers.

For video streams, asynchronous FIFOs are commonly used when crossing between unrelated stream clocks.

## 2.12 Reset and Initialization Sequence

The system must be initialized in a controlled sequence to ensure stable operation. Improper reset sequencing can cause invalid video data, locked interfaces, or frame synchronization errors.

A typical initialization sequence is:

1.  Apply global reset.

2.  Enable stable system clocks.

3.  Release AXI4-Lite control reset.

4.  Configure camera sensor registers.

5.  Configure MIPI CSI-2 receiver.

6.  Enable video input stream.

7.  Enable demosaic module.

8.  Configure VCP registers.

9.  Enable output interface.

10. Start video streaming.

Each stage should confirm readiness before the next stage begins.

## 2.13 Control and Status Monitoring

The architecture should include status signals and diagnostic registers to support runtime visibility. This is important for bring-up, validation, and debugging.

Useful status indicators include:

- Camera lock status.

- MIPI receiver active status.

- Frame counter.

- Line counter.

- Pixel counter.

- AXI4-Stream overflow flag.

- AXI4-Stream underflow flag.

- VCP active mode.

- Output path enable status.

- Error counters.

- Frame synchronization status.

Software can read these registers to verify whether the pipeline is operating correctly.

## 2.14 Data Path and Control Path Separation

A key architectural principle is the separation of the data path from the control path.

**Data Path**

The data path carries high-speed video pixels. It must remain deterministic and operate continuously.

Data-path examples include:

- RAW10 stream.

- RGB stream.

- Filtered video stream.

- Converted color-space stream.

- Display output stream.

- UDP video stream payload.

**Control Path**

The control path carries configuration, status, and mode-selection information. It operates at lower speed and does not directly carry pixel data.

Control-path examples include:

- AXI4-Lite register writes.

- AXI4-Lite register reads.

- Camera I2C configuration.

- Software-controlled enable signals.

- Diagnostic readback.

Separating these paths allows the design to maintain real-time video throughput while still supporting software configurability.

## 2.15 Modular Expandability

The architecture is designed to be modular. Processing blocks can be added, removed, bypassed, or replaced without redesigning the entire system.

Examples of modular extensions include:

- Adding a new color-space conversion block.

- Adding a new spatial filter.

- Adding a new segmentation algorithm.

- Expanding K-means clustering support.

- Adding programmable LUT-based color mapping.

- Adding runtime diagnostic capture.

- Adding additional output streaming protocols.

A modular architecture improves maintainability and supports incremental development.

## 2.16 System-Level Latency Considerations

Each processing stage introduces latency. In a real-time video system, latency is acceptable as long as it is deterministic and does not break stream timing.

Latency sources include:

- MIPI receiver buffering.

- RAW10 unpacking.

- Demosaic line buffering.

- VCP pipeline stages.

- Filter line buffers.

- Color conversion arithmetic.

- VDMA buffering.

- Display output synchronization.

- UDP packetization.

Latency can be categorized as:

| **Latency Type**     | **Description**                              |
|----------------------|----------------------------------------------|
| Pipeline latency     | Delay from registers and arithmetic stages.  |
| Line-buffer latency  | Delay caused by neighborhood-based filters.  |
| Frame-buffer latency | Delay caused by full-frame memory buffering. |
| Output latency       | Delay from display or network transmission.  |

For low-latency operation, the design should avoid full-frame buffering unless required by the output path.

## 2.17 System-Level Throughput Considerations

Throughput determines whether the system can sustain the required resolution and frame rate. The design must process pixels at or above the incoming pixel rate.

Important throughput factors include:

- Pixel clock frequency.

- Pixels per clock.

- AXI4-Stream bus width.

- Processing pipeline initiation interval.

- Memory bandwidth.

- MIPI lane rate.

- Output interface bandwidth.

- Backpressure behavior.

The preferred processing model is a streaming pipeline with an initiation interval of one clock cycle, meaning the design can accept a new pixel every clock cycle after the pipeline is filled.

## 2.18 Error Handling and Safe Operation

A robust video-processing architecture should detect and handle error conditions without corrupting the entire system.

Common error conditions include:

- Missing frame-start marker.

- Missing line-end marker.

- Unexpected resolution.

- AXI4-Stream backpressure timeout.

- FIFO overflow.

- FIFO underflow.

- MIPI receiver lock loss.

- Invalid mode selection.

- Output interface stall.

Recommended safe responses include:

- Disable affected output path.

- Hold last valid configuration.

- Reset only the affected subsystem.

- Report error status through registers.

- Resume operation at the next valid frame boundary.

This approach improves reliability during testing and deployment.

## 2.19 System-Level Architecture Summary

The FPGA Video Color Processing System uses a structured hardware/software architecture to support real-time camera capture, RGB processing, and video output. The Processing System manages configuration and runtime control, while Programmable Logic performs high-throughput image-processing operations.

The system follows a capture–process–output model:

Capture Pipeline → Processing Pipeline → Output Pipeline

The capture pipeline receives RAW10 camera data through MIPI CSI-2 and converts it into RGB video. The processing pipeline applies enhancement, filtering, color conversion, and clustering operations through the VCP module. The output pipeline routes processed video to DisplayPort, Ethernet UDP streaming, or memory-based video paths.

The architecture is designed for deterministic throughput, modular expansion, register-controlled configurability, and real-time operation on the AMD Kria KV260 platform.
