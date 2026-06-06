# Chapter 1 — Introduction to FPGA Video Color Processing

## 1.1 Purpose of the Video Color Processing System

The purpose of the FPGA Video Color Processing System is to implement a real-time camera-to-output video pipeline that captures image data, converts raw sensor information into RGB video, applies programmable image-processing operations, and transmits the processed stream to display or Ethernet output interfaces.

The system is designed around hardware-accelerated video processing. Instead of relying entirely on software execution, the design places critical pixel-processing functions inside programmable logic. This allows the video stream to be processed with deterministic timing, high throughput, and low latency.

At a high level, the system performs the following functions:

1.  Captures video data from camera sensors through a MIPI CSI-2 interface.

2.  Converts raw Bayer-pattern camera data into RGB image frames.

3.  Applies real-time video-processing operations using a custom Video Color Processing module.

4.  Supports image enhancement, filtering, color-space conversion, and color-clustering functions.

5.  Outputs the processed video stream to DisplayPort and Ethernet-based video streaming interfaces.

The system is intended for applications where video must be processed continuously while maintaining real-time frame timing. Examples include embedded vision, smart camera systems, FPGA image-processing research, color analysis, object segmentation, edge detection, and real-time image enhancement.

## 1.2 Target Platform: AMD Kria KV260

The target platform for this design is the AMD Kria KV260 Vision AI Starter Kit, which is based on a Zynq UltraScale+ MPSoC architecture. This platform combines an Arm-based processing system with programmable logic fabric, making it suitable for mixed software-hardware video-processing systems.

The programmable logic is used for high-throughput video datapath operations, including:

- MIPI video reception

- RAW pixel stream handling

- Demosaic processing

- RGB stream processing

- Filtering

- Color-space conversion

- K-means color clustering

- AXI4-Stream video transport

The processing system is used for configuration, control, and system-level management. It can initialize peripherals, configure registers, control video modes, and coordinate output interfaces such as DisplayPort and Ethernet.

This hardware/software partitioning allows the system to combine the flexibility of software control with the deterministic performance of FPGA logic.

## 1.3 Camera-Based Video Processing Overview

The design supports camera-based video input using image sensors connected through MIPI CSI-2 receiver subsystems. The camera sensors generate raw pixel data, typically in RAW10 format, which is transmitted over MIPI lanes into the programmable logic.

The basic camera processing flow is:

Camera Sensor

↓

MIPI CSI-2 Receiver

↓

RAW10 Pixel Stream

↓

Demosaic Processing

↓

RGB Pixel Stream

↓

Video Color Processing Module

↓

DisplayPort / Ethernet Output

The raw image stream produced by the image sensor is not directly suitable for final display because most camera sensors output Bayer-pattern image data. A demosaic stage is therefore required to reconstruct full RGB pixel values from the raw sensor pattern.

After demosaic conversion, each pixel is represented as an RGB value. The RGB stream is then passed into the Video Color Processing module, where programmable processing blocks can modify, transform, classify, or enhance the pixel data.

## 1.4 Real-Time Processing Requirements

Real-time video processing imposes strict throughput and latency requirements. The system must process each incoming pixel at the rate required by the selected resolution and frame rate. If the pipeline cannot sustain the required pixel rate, frame drops, video tearing, or unstable output may occur.

For high-resolution video formats such as 3840×2160 at 30 frames per second, the pixel-processing system must support a high data rate. Each stage of the hardware pipeline must therefore be designed to accept and process video continuously.

Key real-time requirements include:

| **Requirement**               | **Description**                                                                   |
|-------------------------------|-----------------------------------------------------------------------------------|
| Continuous pixel throughput   | The processing pipeline should accept incoming pixels without unnecessary stalls. |
| Deterministic latency         | Each pipeline stage should introduce predictable delay.                           |
| Frame synchronization         | Start-of-frame and end-of-line timing must remain aligned through the pipeline.   |
| Clock-domain coordination     | Input, processing, and output clocks must be managed safely.                      |
| Stream protocol compliance    | AXI4-Stream control signals must preserve video structure.                        |
| Register-controlled operation | Processing modes should be configurable without rebuilding the entire design.     |

The FPGA implementation is well suited for these requirements because image-processing operations can be deeply pipelined and executed in parallel. This allows the system to maintain throughput even when several processing functions are active.

## 1.5 High-Level Capture–Process–Output Pipeline

The complete design can be understood as three major pipeline regions:

Capture Pipeline → Processing Pipeline → Output Pipeline

### 1.5.1 Capture Pipeline

The capture pipeline receives raw video from camera sensors. It includes camera configuration, MIPI reception, raw stream handling, and conversion of Bayer-pattern data into RGB pixels.

Primary capture functions include:

- Camera sensor initialization

- MIPI CSI-2 data reception

- RAW10 pixel stream capture

- Frame and line synchronization

- Demosaic conversion from Bayer data to RGB

The capture pipeline provides the RGB stream that feeds the processing subsystem.

### 1.5.2 Processing Pipeline

The processing pipeline contains the custom Video Color Processing module. This module applies the selected video operation to the incoming RGB stream.

Supported processing categories include:

- Color correction

- RGB gain adjustment

- Brightness control

- Contrast control

- Saturation control

- White balance and black balance

- Sharp filtering

- Blur filtering

- Emboss filtering

- Sobel edge detection

- RGB-to-HSL conversion

- HSL-to-RGB conversion

- RGB-to-YCbCr conversion

- RGB-to-CMYK conversion

- RGB-to-YDbDr conversion

- RGB-to-CIE XYZ conversion

- RGB-to-CIE YUV conversion

- RGB-to-YIQ conversion

- RGB-to-YPbPr conversion

- RGB-to-LMS conversion

- RGB-to-ICtCp conversion

- RGB-to-HED conversion

- RGB-to-YC1C2 conversion

- K-means color clustering

The processing pipeline is modular, allowing specific processing blocks to be enabled, disabled, or configured depending on the selected build and runtime control registers.

### 1.5.3 Output Pipeline

The output pipeline sends processed video to external viewing or streaming interfaces.

The main output paths are:

- DisplayPort output for direct visual display

- Ethernet UDP video streaming for network-based transmission

- Memory-based video movement using VDMA where required

The output pipeline must preserve video timing, pixel ordering, frame boundaries, and synchronization metadata.

## 1.6 Role of the Video Color Processing Module

The Video Color Processing module is the central computational block of the system. It receives an input video stream, applies selected pixel-processing operations, and outputs a modified video stream.

The module can operate as either:

1.  **A pixel transformation block**, where each input pixel is converted into a modified output pixel.

2.  **A pixel generation block**, where new pixel content may be generated based on internal processing, filtering, or classification logic.

The VCP module includes control registers and local buffering resources. Control registers allow software to configure processing behavior, while local buffers support operations that require neighboring pixel information, such as blur, sharp, emboss, and Sobel edge detection filters.

The VCP module is designed to support a modular video-processing architecture. This allows multiple image-processing functions to share a common streaming interface while maintaining real-time throughput.

## 1.7 FPGA Advantages for Video Color Processing

FPGA-based video processing provides several advantages over purely software-based processing for real-time applications.

**Deterministic Timing**

FPGA logic operates with predictable clock-cycle behavior. Once the pipeline latency is known, the timing relationship between input and output pixels can be controlled precisely.

**Parallel Processing**

Color-channel operations, filter kernels, distance calculations, and matrix transformations can be executed in parallel hardware. This avoids the sequential bottlenecks common in processor-only implementations.

**Deep Pipelining**

Complex arithmetic can be divided across multiple pipeline stages. This improves timing closure and allows the design to maintain high clock frequencies.

**Low-Latency Streaming**

AXI4-Stream video processing allows pixels to flow continuously through the design. This reduces the need for full-frame buffering and supports low-latency operation.

**Hardware Customization**

The architecture can be customized for specific use cases, including fixed-point arithmetic, custom color models, application-specific filters, and optimized clustering logic.

## 1.8 AXI4-Stream and AXI4-Lite Control Model

The design uses two important AXI interface types:

| **Interface** | **Purpose**                                                         |
|---------------|---------------------------------------------------------------------|
| AXI4-Stream   | Carries real-time video pixel data through the processing pipeline. |
| AXI4-Lite     | Provides register-based configuration and control access.           |

AXI4-Stream is used for high-throughput video transport. It carries pixel data along with control signals that indicate valid data, frame boundaries, and line boundaries.

AXI4-Lite is used for low-bandwidth control operations. Software can write configuration values into control registers to select filters, adjust enhancement parameters, configure color gains, or enable specific video-processing functions.

This separation of datapath and control path is important because it allows the real-time video stream to continue flowing while software manages configuration independently.

## 1.9 Supported Processing Capabilities

The Video Color Processing system supports a broad set of image-processing functions. These capabilities are grouped into several categories.

**Image Enhancement**

Image enhancement functions improve perceived image quality or compensate for camera and lighting conditions.

Examples include:

- Brightness adjustment

- Contrast adjustment

- Saturation adjustment

- RGB gain control

- White balance

- Black balance

**Spatial Filtering**

Spatial filters use neighboring pixels to modify the current output pixel.

Examples include:

- Sharp filter

- Blur filter

- Emboss filter

- Sobel edge detection

**Color-Space Conversion**

Color-space conversion transforms RGB data into other mathematical representations used for analysis, enhancement, compression, or classification.

Examples include:

- RGB to HSL

- HSL to RGB

- RGB to YCbCr

- RGB to CMYK

- RGB to YDbDr

- RGB to CIE XYZ

- RGB to CIE YUV

- RGB to YIQ

- RGB to YPbPr

- RGB to LMS

- RGB to ICtCp

- RGB to HED

- RGB to YC1C2

**Color Classification and Clustering**

K-means color clustering is used to classify pixels based on their position in RGB color space. This can reduce image complexity, support color segmentation, and enable symbolic or palette-based image representation.

## 1.10 Design Scope

This document describes a complete FPGA-based video color-processing system, including the camera input path, color-processing pipeline, video output interfaces, and verification architecture.

The scope includes:

- AMD Kria KV260 platform usage

- MIPI CSI-2 camera interface

- RAW10 video capture

- Demosaic conversion

- RGB pixel-stream processing

- AXI4-Stream video architecture

- AXI4-Lite register control

- Video timing and bandwidth calculation

- Color-space conversion blocks

- Image filters

- K-means color clustering

- Programmable color schemes

- Ethernet UDP video streaming

- Sensor-specific interface notes

- Testbench and verification structure

The document is intended to serve as both a technical design reference and a formal engineering description of the video-processing system.

## 1.11 Chapter Summary

This chapter introduced the purpose and scope of the FPGA Video Color Processing System. The system captures camera video through MIPI CSI-2, converts RAW sensor data into RGB video, applies real-time image-processing operations, and outputs the processed stream through DisplayPort or Ethernet.

The architecture is organized around a capture–process–output model. The Video Color Processing module serves as the central hardware block for filtering, enhancement, color-space conversion, and K-means color clustering. By using FPGA logic, AXI4-Stream video transport, and register-controlled configuration, the system provides a deterministic and extensible platform for real-time video color processing.
