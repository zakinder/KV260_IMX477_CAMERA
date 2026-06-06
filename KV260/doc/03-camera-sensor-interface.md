# Chapter 3 — Camera Sensor Interface

## 3.1 Overview of the Camera Sensor Interface

The camera sensor interface is the front-end acquisition stage of the FPGA Video Color Processing System. Its purpose is to receive live image data from external image sensors, convert the incoming sensor stream into a usable internal video format, and forward the resulting pixel stream into the real-time processing pipeline.

In this design, camera data is received through a **MIPI CSI-2 interface** and processed inside the programmable logic of the AMD Kria KV260 platform. The system supports camera sensors such as the **Sony IMX477** and **AR1335**, with the input stream captured in **RAW10** format before conversion into RGB video data. The source document identifies both IMX477 and AR1335 camera paths and states that the MIPI CSI-2 receiver captures frames in RAW10 format.

The camera interface performs four major functions:

1.  **Sensor configuration** through a control interface such as I2C.

2.  **High-speed pixel-data reception** through MIPI CSI-2 lanes.

3.  **RAW pixel stream capture** and alignment.

4.  **Preparation of image data** for demosaic and RGB video processing.

The camera sensor interface is therefore responsible for converting physical sensor output into a synchronized digital video stream that can be processed by downstream FPGA modules.

## 3.2 Supported Camera Sensors

The system architecture is designed to support multiple camera sensors. The primary sensors referenced in the design are:

| **Sensor**      | **Resolution Class** | **Interface**           | **Output Format**                  | **Role**                               |
|-----------------|----------------------|-------------------------|------------------------------------|----------------------------------------|
| Sony IMX477     | 12.5 MP              | MIPI CSI-2              | RAW10                              | Primary high-resolution camera input   |
| AR1335          | 13.0 MP              | MIPI CSI-2              | RAW10                              | Alternate high-resolution camera input |
| IMX219          | 8 MP class           | MIPI CSI-2              | RAW format                         | Optional supported camera family       |
| IMX519          | 16 MP class          | MIPI CSI-2              | RAW format                         | Optional supported camera family       |
| IMX682          | 64 MP class          | MIPI CSI-2              | RAW format                         | Optional supported camera family       |
| OV5640 / OV5647 | 5 MP class           | Camera sensor interface | RAW/RGB dependent on configuration | Optional sensor interface support      |

The document table of contents includes dedicated sections for the OV5640, OV5647, IMX219, IMX477, IMX519, and IMX682 sensor interfaces, showing that the design is structured to document multiple camera input options.

Although the exact initialization sequence may differ between sensors, the general interface model remains the same:

Camera Sensor

↓

I2C Configuration

↓

MIPI CSI-2 Pixel Output

↓

MIPI CSI-2 Receiver

↓

RAW Pixel Stream

↓

Demosaic / RGB Conversion

## 3.3 Sony IMX477 Sensor Interface

The Sony IMX477 is a high-resolution CMOS digital image sensor used as one of the main camera inputs in the system. The design document identifies the IMX477 as a **12.5 MP sensor** with a **4056 × 3040 active imaging pixel array** and a MIPI output interface.

### 3.3.1 IMX477 Interface Characteristics

The IMX477 camera interface includes:

- CMOS image sensor array.

- I2C-based configuration interface.

- MIPI CSI-2 output interface.

- RAW10 image-stream output.

- Connection to the MIPI CSI-2 RX subsystem.

- Two-lane MIPI operation in the described configuration.

The sensor captures image data through its active pixel array and transmits serialized pixel data to the FPGA through MIPI CSI-2. The programmable logic then receives the stream, aligns the data, and forwards it into the camera processing pipeline.

### 3.3.2 IMX477 Role in the Pipeline

The IMX477 input path can be summarized as:

IMX477 Sensor

↓

MIPI CSI-2 2-Lane Output

↓

MIPI D-PHY

↓

MIPI CSI-2 RX Subsystem

↓

RAW10 Frame Stream

↓

Demosaic Module

↓

RGB Video Stream

The IMX477 is suitable for high-resolution video-processing demonstrations because it supports large image frames and provides a standard MIPI CSI-2 interface for FPGA video acquisition.

## 3.4 AR1335 Sensor Interface

The AR1335 is another supported camera sensor in the system. The document identifies it as a **13.0 MP CMOS digital image sensor** with a **4208 × 3120 active imaging pixel array**. It is configured using I2C and provides a MIPI output interface connected to the MIPI CSI-2 receiver subsystem.

### 3.4.1 AR1335 Interface Characteristics

The AR1335 camera interface includes:

- CMOS image sensor architecture.

- I2C control and configuration.

- MIPI CSI-2 output.

- RAW10 pixel-stream capture.

- Four-lane MIPI operation in the described configuration.

- Connection to the FPGA camera input subsystem.

### 3.4.2 AR1335 Role in the Pipeline

The AR1335 input path can be summarized as:

AR1335 Sensor

↓

MIPI CSI-2 4-Lane Output

↓

MIPI D-PHY

↓

MIPI CSI-2 RX Subsystem

↓

RAW10 Frame Stream

↓

Demosaic Module

↓

RGB Video Stream

Compared with the IMX477 path, the AR1335 configuration uses more MIPI data lanes in the described design. This allows higher aggregate input bandwidth for the camera stream.

## 3.5 MIPI CSI-2 Receiver Subsystem

The **MIPI CSI-2 Receiver Subsystem** receives serialized camera data from the external image sensor and converts it into an internal parallel video stream. It works together with the MIPI D-PHY physical layer, which handles the electrical signaling and lane-level data transfer.

The document states that the MIPI CSI-2 receiver subsystem includes a **MIPI D-PHY core**, connects **2 data lanes for the IMX477**, connects **4 data lanes for the AR1335**, and captures frames in **RAW10 format**.

### 3.5.1 Receiver Subsystem Functions

The MIPI CSI-2 receiver performs the following functions:

1.  Receives high-speed serial data from the camera.

2.  Recovers packetized video data.

3.  Identifies valid frame and line payloads.

4.  Filters or accepts selected data types.

5.  Converts MIPI payloads into an internal video stream.

6.  Provides synchronization metadata for downstream processing.

### 3.5.2 Receiver Configuration Parameters

Important receiver parameters include:

| **Parameter**           | **Purpose**                                               |
|-------------------------|-----------------------------------------------------------|
| Pixel format            | Defines the incoming camera data format, such as RAW10.   |
| Serial data lanes       | Defines the number of active MIPI data lanes.             |
| Line rate               | Defines the high-speed data rate per lane.                |
| Virtual channel         | Selects accepted camera virtual channels.                 |
| User-defined data types | Controls accepted MIPI payload types.                     |
| Line buffer depth       | Supports line-based stream buffering.                     |
| Pixels per clock        | Defines the number of output pixels per processing clock. |
| TUSER width             | Defines frame-start sideband width.                       |
| CRC enable              | Enables packet integrity checking where supported.        |

The source configuration lists RAW10 format, 2 serial lanes, 2500 Mbps line rate, 4096 line-buffer data type depth, all virtual channels, one pixel per clock, TUSER width of 1, and CRC enabled for one MIPI CSI-2 receiver instance. It also lists a second RAW10 receiver instance configured with 4 lanes and 2000 Mbps line rate.

## 3.6 MIPI D-PHY Interface

The **MIPI D-PHY** is the physical layer associated with the MIPI CSI-2 interface. It is responsible for receiving high-speed differential data from the camera sensor and presenting it to the CSI-2 protocol layer.

The D-PHY handles:

- High-speed serial lane reception.

- Clock and data recovery.

- Lane synchronization.

- Low-power and high-speed signaling states.

- Interface-level timing requirements.

In the system architecture, the D-PHY is part of the camera input subsystem and directly connects to the MIPI CSI-2 receiver. Without a stable D-PHY link, valid image frames cannot be captured.

## 3.7 RAW10 Pixel Stream Capture

The camera sensors transmit image data in **RAW10** format. RAW10 means that each raw pixel sample is represented using 10 bits. This format is common in image sensors because it provides higher precision than 8-bit data while reducing bandwidth compared with wider formats.

### 3.7.1 RAW10 Characteristics

RAW10 data has the following characteristics:

- Each pixel sample contains 10 bits of sensor intensity.

- The stream is usually arranged according to a Bayer color filter pattern.

- Pixel values must be unpacked and aligned before image processing.

- RAW10 data is not equivalent to full RGB data.

- Demosaic processing is required before RGB-based color operations.

### 3.7.2 RAW10 Capture Flow

The RAW10 capture path can be represented as:

MIPI CSI-2 Packet Payload

↓

RAW10 Pixel Extraction

↓

Pixel Alignment

↓

Frame / Line Synchronization

↓

Bayer Pixel Stream

↓

Demosaic Input

The receiver must preserve the correct order of pixels, lines, and frames. Any misalignment at this stage can produce color artifacts, corrupted images, or invalid downstream processing results.

## 3.8 Bayer Pattern Image Data

Most camera sensors do not output complete RGB values for every pixel. Instead, they use a **Bayer color filter array**, where each pixel location measures only one color component: red, green, or blue.

A common Bayer arrangement is:

G R G R G R

B G B G B G

G R G R G R

B G B G B G

Because each sensor pixel contains only one color component, the raw image must be reconstructed into full RGB form before most color-processing functions can operate.

### 3.8.1 Importance of Bayer Alignment

Correct Bayer alignment is critical. If the demosaic module assumes the wrong Bayer phase, the output RGB image may show:

- Incorrect color balance.

- Color inversion.

- Green or magenta tinting.

- False edges.

- Reduced image sharpness.

The camera interface must therefore preserve pixel-coordinate alignment from the first pixel of each frame.

## 3.9 Demosaic Processing

The demosaic module converts Bayer-pattern sensor data into RGB pixel data. The document states that the demosaic module converts Bayer-pattern input frames into RGB color frames.

### 3.9.1 Demosaic Function

The demosaic stage estimates missing color channels by using neighboring pixel values. For each output pixel, the module reconstructs:

Red component

Green component

Blue component

The result is a full RGB pixel stream suitable for color correction, filtering, color-space conversion, clustering, display output, and Ethernet streaming.

### 3.9.2 Demosaic Placement

The demosaic module is placed after RAW10 capture and before the Video Color Processing module:

RAW10 Camera Stream

↓

Demosaic Module

↓

RGB Video Stream

↓

Video Color Processing Module

This placement allows the VCP module to operate on complete RGB data rather than sensor-specific raw data.

## 3.10 I2C-Based Camera Configuration

Camera sensors require configuration before they can stream valid video. Configuration is typically performed using an I2C control interface.

I2C camera configuration may include:

- Sensor reset control.

- Resolution selection.

- Frame-rate selection.

- Exposure configuration.

- Gain configuration.

- MIPI lane configuration.

- Pixel format selection.

- Test pattern enablement.

- Stream start and stop control.

The source document states that both IMX477 and AR1335 sensors are configured using I2C and provide MIPI output into the MIPI CSI-2 subsystem.

### 3.10.1 Configuration Sequence

A typical camera initialization sequence is:

Power Enable

↓

Reset Release

↓

I2C Bus Check

↓

Sensor ID Read

↓

Register Configuration

↓

MIPI Output Enable

↓

Stream Start

↓

Frame Lock Verification

The FPGA and software control layer must ensure that sensor configuration is complete before enabling the downstream video-processing pipeline.

## 3.11 Frame and Line Synchronization

The camera stream must preserve frame and line boundaries. These boundaries allow the downstream pipeline to determine where each image frame begins and where each row of pixels ends.

Important synchronization concepts include:

| **Signal or Marker** | **Purpose**                                            |
|----------------------|--------------------------------------------------------|
| Start of frame       | Identifies the first pixel of a new image frame.       |
| End of line          | Identifies the final pixel of a video line.            |
| Pixel valid          | Indicates that the current pixel value is valid.       |
| Line valid           | Indicates that pixels belong to an active line.        |
| Frame valid          | Indicates that pixels belong to an active frame.       |
| Blanking interval    | Represents non-active periods between lines or frames. |

Downstream modules such as demosaic, filters, histogram logic, DisplayPort output, and frame buffers depend on these boundaries.

## 3.12 Pixel Coordinate Tracking

Pixel coordinate tracking identifies the current pixel location inside the frame. It typically uses an **x-coordinate** for horizontal position and a **y-coordinate** for vertical position.

Pixel coordinates are useful for:

- Bayer pattern phase detection.

- Demosaic processing.

- Line-buffer addressing.

- Kernel-based filtering.

- Region-of-interest processing.

- Test-pattern generation.

- Debugging frame alignment.

- Histogram and segmentation logic.

A basic coordinate counter structure is:

If start_of_frame:

x = 0

y = 0

For each valid pixel:

process pixel at coordinate (x, y)

x = x + 1

If end_of_line:

x = 0

y = y + 1

Correct coordinate tracking is especially important for Bayer reconstruction because the meaning of each raw pixel depends on its row and column position.

## 3.13 Camera Input Timing

Camera input timing is determined by resolution, frame rate, MIPI lane count, pixel format, and internal clocking. The system must provide sufficient input bandwidth to receive the full frame stream without data loss.

Important timing parameters include:

- Active image width.

- Active image height.

- Frame rate.

- Pixel bit depth.

- Number of MIPI data lanes.

- MIPI lane rate.

- Pixel clock.

- Horizontal blanking.

- Vertical blanking.

The design document states that one supported image-frame resolution is **3840 × 2160 at 30 frames per second**, with a maximum full resolution of **4056 × 3040** supported at a reduced frame rate of **15 frames per second**.

## 3.14 Camera Interface Error Conditions

The camera sensor interface should detect and report error conditions during operation. Common camera-interface errors include:

| **Error Condition**       | **Possible Cause**                                        | **Effect**                      |
|---------------------------|-----------------------------------------------------------|---------------------------------|
| No MIPI lock              | Sensor not streaming, cable issue, incorrect lane setting | No valid frames                 |
| Invalid RAW format        | Sensor register mismatch                                  | Incorrect pixel decoding        |
| Frame-size mismatch       | Wrong resolution configuration                            | Misaligned frames               |
| Line-length mismatch      | Incorrect timing or dropped packets                       | Image tearing or corrupted rows |
| Bayer phase mismatch      | Incorrect sensor orientation or crop offset               | Incorrect color reconstruction  |
| FIFO overflow             | Downstream backpressure or clock mismatch                 | Dropped pixels                  |
| CRC error                 | MIPI packet corruption                                    | Invalid frame data              |
| I2C configuration failure | Sensor not responding                                     | Camera cannot initialize        |

Robust status registers and diagnostic counters should be included to support bring-up and runtime debugging.

## 3.15 Camera Bring-Up Procedure

A disciplined bring-up procedure improves the reliability of hardware validation.

Recommended camera bring-up steps:

1.  Verify camera module power rails.

2.  Verify reference clock and reset timing.

3.  Confirm I2C communication.

4.  Read sensor identification registers.

5.  Program the selected resolution and frame rate.

6.  Program MIPI lane mode and pixel format.

7.  Enable the MIPI CSI-2 receiver subsystem.

8.  Start sensor streaming.

9.  Verify MIPI lock and frame reception.

10. Confirm RAW10 pixel activity.

11. Enable demosaic conversion.

12. Confirm RGB output.

13. Route RGB stream to the VCP module.

14. Validate display or Ethernet output.

This procedure isolates problems by testing each stage before enabling the full processing pipeline.

## 3.16 Camera Sensor Interface Summary

The camera sensor interface forms the acquisition front end of the FPGA Video Color Processing System. It receives high-speed image data from MIPI CSI-2 camera sensors, captures RAW10 Bayer-pattern frames, and prepares the stream for demosaic conversion.

The design supports camera sensors such as the Sony IMX477 and AR1335. The IMX477 is described as a 12.5 MP sensor with a 4056 × 3040 active imaging array, while the AR1335 is described as a 13.0 MP sensor with a 4208 × 3120 active imaging array. Both sensors are configured through I2C and connected to the MIPI CSI-2 receiver subsystem.

The MIPI CSI-2 receiver and MIPI D-PHY convert serialized camera data into an internal RAW10 stream. This stream is then converted by the demosaic module into RGB video, which becomes the input to the Video Color Processing module. Correct sensor configuration, MIPI lane setup, RAW10 alignment, Bayer phase tracking, and frame synchronization are essential for reliable real-time video processing.
