# Chapter 20 — Sensor-Specific Implementation Notes

## 20.1 Overview

Sensor-specific implementation notes define the practical configuration, interface, timing, data-format, and integration requirements for each camera sensor supported by the FPGA Video Color Processing System. Although the downstream Video Color Processing pipeline can process a normalized RGB stream, each sensor may require different configuration registers, lane counts, pixel formats, frame rates, Bayer phase settings, and clocking assumptions.

The source design identifies support for Sony IMX477, IMX682, IMX519, IMX219, ON Semiconductor AR1335, and OV5640/OV5647-style camera modules in the camera video-streaming section.

A generalized sensor integration flow is:

Sensor Power-Up

↓

Clock and Reset Release

↓

I2C Register Configuration

↓

MIPI CSI-2 / Parallel Interface Bring-Up

↓

RAW Frame Capture

↓

Demosaic Conversion

↓

RGB Stream Generation

↓

VCP Processing

↓

Display / Ethernet Output

The goal of this chapter is to document sensor-specific details so that each camera can be brought up reliably and connected to the same FPGA video-processing pipeline.

## 20.2 Common Sensor Integration Requirements

Each camera sensor requires a set of common integration steps, even when the exact register values and data rates differ.

| **Requirement**           | **Description**                                                                      |
|---------------------------|--------------------------------------------------------------------------------------|
| Power sequencing          | Sensor rails must be enabled in the correct order.                                   |
| Reset control             | Sensor reset must be asserted and released cleanly.                                  |
| Reference clock           | The sensor requires a stable input clock.                                            |
| I2C configuration         | Sensor registers must be programmed before streaming.                                |
| MIPI lane configuration   | Lane count must match the sensor mode and FPGA receiver.                             |
| RAW format selection      | RAW8, RAW10, RAW12, or RGB format must be declared consistently.                     |
| Bayer phase configuration | Demosaic must use the correct Bayer pattern.                                         |
| Frame timing              | Width, height, blanking, line length, and frame length must match the selected mode. |
| Stream enable             | The sensor must be placed into streaming mode after configuration.                   |
| Status monitoring         | Lock, frame count, line count, and error flags should be checked during bring-up.    |

Sensor-specific work is mostly concentrated in the front end. Once the stream becomes valid RGB, the VCP pipeline can process it using the same filters, color conversion, K-means clustering, and enhancement logic.

## 20.3 Sensor Interface Types

The design supports camera modules connected through MIPI CSI-2 and, in some earlier or related paths, parallel camera-style interfaces.

### 20.3.1 MIPI CSI-2 Sensor Interface

MIPI CSI-2 is used for high-speed serial camera input. The sensor sends serialized image data through one or more data lanes into the FPGA MIPI CSI-2 receiver subsystem.

A standard MIPI capture path is:

Camera Sensor

↓

MIPI CSI-2 Data Lanes

↓

MIPI D-PHY

↓

MIPI CSI-2 RX Subsystem

↓

AXI4-Stream RAW Video

↓

Demosaic

↓

AXI4-Stream RGB Video

The source document states that the MIPI CSI-2 receiver subsystem includes a MIPI D-PHY core and captures AR1335 and IMX477 camera frames in RAW10 format.

### 20.3.2 Parallel Sensor Interface

For parallel sensors, the camera provides pixel data along with a pixel clock, frame-valid, and line-valid signals. This interface is simpler electrically but requires careful timing and clock-domain crossing.

A typical parallel interface includes:

pixclk

frame_valid

line_valid

pixel_data\[N-1:0\]

This path is compatible with line-buffered RAW data capture, where pixels are written at the camera pixel clock and read at the system clock.

## 20.4 Sony IMX477 Sensor Notes

The Sony IMX477 is a high-resolution camera sensor used in the design. The source document describes the IMX477-MIPI-CS as a high-resolution digital camera incorporating a Sony 1/2.3-inch CMOS digital image sensor with an active imaging pixel array of **4056H × 3040V**.

### 20.4.1 IMX477 Key Characteristics

| **Feature**            | **Implementation Note**        |
|------------------------|--------------------------------|
| Sensor type            | Sony CMOS digital image sensor |
| Active pixels          | 4056 × 3040                    |
| Approximate resolution | 12.3 MP / 12.5 MP class        |
| Pixel size             | 1.55 μm × 1.55 μm              |
| Output interface       | MIPI CSI-2                     |
| Lane support           | 2-lane or 4-lane mode          |
| RAW format             | Raw Bayer 10/12 bits           |
| Shutter type           | Rolling shutter                |

The source document lists IMX477 CSI-2 data output as 2/4-lane mode and data format as Raw Bayer 10/12 bits.

### 20.4.2 IMX477 Resolution and Frame-Rate Notes

The system-level design describes a 3840×2160 video frame at 30 frames per second and also notes support for maximum full resolution of 4056×3040 with a limit of 15 frames per second.

Recommended use cases:

| **Mode**                   | **Use Case**                                          |
|----------------------------|-------------------------------------------------------|
| 3840×2160p30               | 4K real-time processing and display-oriented output   |
| 1920×1080p60               | High-frame-rate development and processing tests      |
| 4056×3040 lower frame rate | Full sensor-resolution capture and quality evaluation |
| 720p / reduced mode        | Network streaming and algorithm debugging             |

### 20.4.3 IMX477 MIPI Lane Notes

The document states that the IMX477 camera module and Kria KV260 board are connected through a flexible flat cable, with camera pixel data transferred through a dual-lane MIPI CSI-2 interface via a 15-pin flat flexible cable. It also notes that the Raspberry Pi camera module interface supports two MIPI lanes connected to the Zynq UltraScale+ MPSoC HPA bank.

Implementation guidance:

IMX477 Raspberry Pi style module:

MIPI lanes = 2

Interface = FPC / 15-pin ribbon

Receiver = MIPI CSI-2 RX subsystem

The FPGA MIPI CSI-2 configuration must match the sensor lane mode. A 2-lane sensor configuration should not be paired with a 4-lane receiver mode unless the sensor and board routing support it.

## 20.5 IMX477 Register Configuration

The IMX477 sensor requires I2C register programming before video streaming. The source document identifies an “IMX477 Configuration Registers” section and lists register addresses such as line length, X/Y start, X/Y end, gain, coarse integration time, and mode select.

Important register categories include:

| **Register Category** | **Purpose**                                |
|-----------------------|--------------------------------------------|
| Line length           | Defines pixels per line including blanking |
| Frame length          | Defines frame timing and frame rate        |
| X/Y start             | Defines crop window start                  |
| X/Y end               | Defines crop window end                    |
| Output size           | Defines transmitted image size             |
| PLL settings          | Defines internal sensor clocking           |
| Gain registers        | Controls analog/digital gain               |
| Integration time      | Controls exposure                          |
| Mode select           | Enables or disables streaming              |

A simplified configuration flow is:

1\. Hold sensor in reset or standby.

2\. Configure PLL and timing registers.

3\. Configure crop window and output size.

4\. Configure RAW format and lane mode.

5\. Configure exposure and gain.

6\. Configure MIPI output timing.

7\. Enable streaming with MODE_SEL.

The final streaming register is commonly represented by a mode-select register. The source register listing includes MODE_SEL with address 0x0100.

## 20.6 IMX477 Video Input Subsystem Notes

The source document states that, for the IMX477 design application, the camera is configured to output 1920×1080p video frames with RGB 30-bit pixel format at 60 frames per second, and both the camera and MIPI CSI-2 subsystem are configured in advance.

The document also states that the MIPI CSI-2 subsystem captures images from the IMX477 sensor and outputs AXI4-Stream video; the demosaic module converts raw AXI4-Stream video data to RGB format; and VDMA converts demosaic video stream data to AXI4 memory-mapped format for DDR access.

A practical IMX477 input subsystem is:

IMX477

↓

MIPI CSI-2 RX Subsystem

↓

RAW AXI4-Stream

↓

Demosaic

↓

RGB AXI4-Stream

↓

VDMA / VCP / DisplayPort / Ethernet

## 20.7 AR1335 Sensor Notes

The AR1335 is another high-resolution sensor supported by the system. The source document describes the AR1335 as a **13.0 MP** CMOS digital image sensor with an active imaging pixel array of **4208H × 3120V** at 30 fps maximum resolution. It is configured by I2C and provides MIPI output to the MIPI CSI-2 RX subsystem.

### 20.7.1 AR1335 Key Characteristics

| **Feature**                 | **Implementation Note**          |
|-----------------------------|----------------------------------|
| Sensor class                | 13 MP CMOS sensor                |
| Active pixels               | 4208 × 3120                      |
| Configuration interface     | I2C                              |
| Output interface            | MIPI CSI-2                       |
| Receiver lane configuration | 4 lanes in the documented design |
| Captured format             | RAW10 in the design pipeline     |
| Demosaic requirement        | Bayer to RGB conversion required |

The source document states that the MIPI CSI-2 receiver connects **2 data lanes for IMX477** and **4 lanes for AR1335**, and captures frames from both cameras in RAW10 format.

### 20.7.2 AR1335 Integration Notes

Because the AR1335 uses a higher lane count in the documented design, the MIPI receiver configuration must be updated accordingly.

Key requirements:

AR1335:

MIPI lanes = 4

Format = RAW10

Config = I2C

Receiver = MIPI CSI-2 RX subsystem

Demosaic = Required

The 4-lane configuration is useful for higher bandwidth sensor modes, but it requires correct board routing and receiver settings.

## 20.8 Sony IMX219 Sensor Notes

The Sony IMX219 is an 8 MP sensor referenced in the design. The source document states that the IMX219 module is an 8 Megapixel CMOS color image sensor supporting **1080p30**, **720p60**, and **640×480p90** video resolutions, with still-image maximum resolution of **3280×2464** pixels.

### 20.8.1 IMX219 Key Characteristics

| **Feature**          | **Implementation Note**                  |
|----------------------|------------------------------------------|
| Sensor class         | 8 MP CMOS image sensor                   |
| Max still resolution | 3280 × 2464                              |
| Video modes          | 1080p30, 720p60, VGA90                   |
| Interface            | Dual-lane MIPI CSI-2                     |
| Connection           | 15-pin flat flexible cable               |
| Data format          | Raw Bayer 10-bit noted in specifications |

The source specification section lists IMX219 active pixels, CSI-2 2-lane data output, Raw Bayer 10-bit format, and supported video modes.

### 20.8.2 IMX219 Implementation Notes

IMX219 is suitable for:

- Lower-bandwidth testing.

- 720p and 1080p development.

- Early MIPI bring-up.

- Reduced frame-size Ethernet streaming.

- VCP algorithm debugging.

Because it uses a two-lane MIPI interface and lower resolution than IMX477/AR1335, it can be easier to use during initial integration.

## 20.9 OV5640 and OV5647 Sensor Notes

The source document references OV5640 and OV5647 5 MP sensor interfaces. It describes the OV5640 PCAM 5C module as a 5 Megapixel CMOS color image sensor and states that image pixel data is transferred over a dual-lane MIPI CSI-2 interface connected to the Kria KV260 through a 15-pin flat flexible cable.

### 20.9.1 OV5640 / OV5647 Key Characteristics

| **Feature**          | **Implementation Note**                                           |
|----------------------|-------------------------------------------------------------------|
| Sensor class         | 5 MP CMOS image sensor                                            |
| Interface            | Dual-lane MIPI CSI-2                                              |
| Connection           | 15-pin flat flexible cable                                        |
| Typical use          | Development, lower-resolution camera input, compatibility testing |
| Pipeline requirement | MIPI receive, Bayer/RGB handling, VCP processing                  |

### 20.9.2 OV5640 / OV5647 Implementation Notes

These sensors are useful for:

- Lower-resolution functional tests.

- Camera interface validation.

- MIPI CSI-2 receiver bring-up.

- Basic video streaming tests.

- Reduced-bandwidth VCP validation.

When integrating these sensors, the receiver pixel format, Bayer phase, resolution, and lane rate should be configured according to the selected mode.

## 20.10 IMX519 and IMX682 Notes

The source table of contents identifies 16 MP IMX519 and 64 MP IMX682 sensor interface sections. The detailed parsed text in the available document excerpt appears to repeat OV5640-style text under these headings, so these sections should be treated as placeholders requiring final sensor-specific register and mode validation.

### 20.10.1 Implementation Guidance

For IMX519 and IMX682 integration, confirm:

- Actual sensor register table.

- Supported MIPI lane count.

- RAW bit depth.

- Maximum lane rate.

- Selected output resolution.

- Selected frame rate.

- Bayer pattern.

- MIPI virtual channel and data type.

- Board routing and connector compatibility.

- Demosaic configuration.

These sensors have higher resolution classes, so bandwidth planning is critical.

## 20.11 Sensor Configuration Through I2C

Most supported sensors require I2C register programming. The source document states that both IMX477 and AR1335 are configured by I2C and have MIPI output connected to the MIPI CSI-2 RX subsystem.

A typical I2C configuration sequence is:

Power rails stable

↓

Sensor reset released

↓

Sensor ID read

↓

PLL / clock registers written

↓

Image window registers written

↓

Output format registers written

↓

MIPI lane registers written

↓

Exposure / gain registers written

↓

Stream-on command written

Recommended I2C validation steps:

| **Step**           | **Purpose**                                          |
|--------------------|------------------------------------------------------|
| Read sensor ID     | Confirms I2C address and sensor presence             |
| Write standby mode | Ensures sensor is not streaming during configuration |
| Program timing     | Sets line/frame length                               |
| Program format     | Selects RAW10/RAW12/RGB path                         |
| Enable streaming   | Starts video output                                  |
| Read status        | Confirms sensor mode where supported                 |

## 20.12 MIPI CSI-2 Receiver Configuration

The MIPI receiver must match the sensor output. Important receiver parameters include:

| **Parameter**     | **Meaning**                                |
|-------------------|--------------------------------------------|
| Data type         | RAW8, RAW10, RAW12, RGB, YUV               |
| Lane count        | Number of active MIPI data lanes           |
| Lane rate         | Mbps per lane                              |
| Pixel per clock   | Number of pixels output per internal clock |
| Virtual channel   | Selected CSI-2 virtual channel             |
| TUSER width       | Frame-start sideband width                 |
| CRC enable        | Packet-integrity checking                  |
| Line buffer depth | Maximum line support                       |

The documented Vivado configuration uses RAW10, one pixel per clock, TUSER width of 1, CRC enabled, 2 lanes for one receiver, and 4 lanes for another receiver.

## 20.13 Bayer Pattern and Demosaic Notes

RAW Bayer sensors require demosaic conversion before RGB processing. The source design states that the demosaic module converts Bayer-pattern input frames to RGB color frames.

Sensor-specific Bayer configuration should include:

| **Parameter**         | **Description**                        |
|-----------------------|----------------------------------------|
| Bayer order           | RGGB, BGGR, GRBG, or GBRG              |
| First active pixel    | Color of pixel at coordinate (0,0)     |
| Horizontal flip       | May swap Bayer phase                   |
| Vertical flip         | May swap Bayer phase                   |
| Crop offset           | Odd/even offset changes phase          |
| Demosaic output width | RGB channel width after reconstruction |

Incorrect Bayer phase causes visible color errors such as green tint, magenta tint, or red/blue channel inversion.

## 20.14 Resolution and Frame-Timing Notes

Sensor mode configuration must match the expected video timing. The design identifies 3840×2160 at 30 fps as a target image frame resolution, with full 4056×3040 support limited to 15 fps.

Important timing fields include:

| **Timing Field** | **Purpose**                            |
|------------------|----------------------------------------|
| Active width     | Number of valid pixels per line        |
| Active height    | Number of valid lines per frame        |
| Line length      | Active pixels plus horizontal blanking |
| Frame length     | Active lines plus vertical blanking    |
| Pixel clock      | Rate of pixel generation               |
| Lane rate        | MIPI serial bandwidth per lane         |
| Frame rate       | Frames per second                      |
| Crop window      | Sensor readout region                  |

If line length or frame length is wrong, the MIPI receiver may output unstable frames or the downstream VDMA may see incorrect line sizes.

## 20.15 RAW Bit Depth and Internal RGB Width

Different sensors may output different RAW bit depths.

| **RAW Format** | **Sample Width**    | **Notes**                          |
|----------------|---------------------|------------------------------------|
| RAW8           | 8 bits              | Lower precision, lower bandwidth   |
| RAW10          | 10 bits             | Common MIPI sensor mode            |
| RAW12          | 12 bits             | Higher precision, higher bandwidth |
| RGB30          | 10 bits/channel RGB | High-precision RGB stream          |
| RGB888         | 8 bits/channel RGB  | Common output/streaming format     |

The IMX477 section lists Raw Bayer 10/12-bit data format, while the MIPI capture path describes RAW10 capture for AR1335 and IMX477.

When converting between bit depths:

RAW10 → RGB888:

output_8bit = raw_10bit\[9:2\]

or with rounding:

output_8bit = (raw_10bit + 2) \>\> 2

The scaling method should be consistent across the entire pipeline.

## 20.16 Sensor Mode Selection

Sensor mode selection should be based on application goals.

| **Goal**               | **Recommended Mode**                           |
|------------------------|------------------------------------------------|
| Highest detail         | Full-resolution or 4K mode                     |
| Real-time display      | 1080p or 4K30 mode                             |
| Ethernet streaming     | 720p, grayscale, RGB565, or frame-skipped mode |
| Algorithm testing      | Lower resolution with stable frame rate        |
| Low latency            | Reduced frame size and short exposure          |
| High light sensitivity | Larger exposure time and lower frame rate      |

Mode selection affects:

- MIPI lane rate.

- Pixel clock.

- Line length.

- Frame length.

- VDMA buffer size.

- DDR bandwidth.

- Ethernet bandwidth.

- Processing latency.

## 20.17 Sensor Bring-Up Checklist

A practical bring-up checklist is:

| **Step** | **Check**                                           |
|----------|-----------------------------------------------------|
| 1        | Confirm power rails and reset state                 |
| 2        | Confirm reference clock                             |
| 3        | Read sensor ID over I2C                             |
| 4        | Program sensor mode registers                       |
| 5        | Configure MIPI CSI-2 receiver lane count and format |
| 6        | Enable sensor stream                                |
| 7        | Confirm MIPI receiver lock                          |
| 8        | Confirm AXI4-Stream TVALID activity                 |
| 9        | Confirm TUSER frame-start and TLAST line-end        |
| 10       | Confirm demosaic output RGB activity                |
| 11       | Verify frame width and height                       |
| 12       | Display color bars or live image                    |
| 13       | Verify Bayer phase                                  |
| 14       | Enable VCP processing                               |
| 15       | Verify Ethernet or DisplayPort output               |

## 20.18 Common Sensor-Specific Failure Modes

| **Failure Mode**          | **Likely Cause**                         | **Correction**                                     |
|---------------------------|------------------------------------------|----------------------------------------------------|
| No video stream           | Sensor not configured or not streaming   | Verify I2C sequence and mode-select register       |
| MIPI receiver not locked  | Lane rate or lane count mismatch         | Match sensor and receiver settings                 |
| Green/magenta image       | Wrong Bayer phase                        | Correct Bayer order or crop offset                 |
| Red and blue swapped      | Incorrect Bayer phase or channel packing | Correct demosaic and RGB packing                   |
| Image cropped incorrectly | Wrong X/Y start or end registers         | Verify crop-window registers                       |
| Frame rolls or tears      | Wrong frame timing                       | Verify line length and frame length                |
| Intermittent frame loss   | Bandwidth too high                       | Reduce resolution, frame rate, or bit depth        |
| Incorrect brightness      | Wrong RAW scaling or gain                | Verify RAW bit-depth conversion and gain registers |
| UDP/display mismatch      | Output format too large                  | Reduce frame size or pixel format                  |
| VDMA error                | Stride or frame-size mismatch            | Match VDMA width, height, and stride               |

## 20.19 Sensor-Specific Register Documentation

For each supported sensor, the final system documentation should include a register table:

| **Field**        | **Description**                          |
|------------------|------------------------------------------|
| Register address | Sensor register address                  |
| Register name    | Functional register name                 |
| Value            | Programmed value                         |
| Purpose          | Why the value is used                    |
| Mode dependency  | Which resolution/frame-rate mode uses it |
| Notes            | Timing, gain, crop, or format notes      |

Example categories:

PLL registers

Line length registers

Frame length registers

Crop registers

Output size registers

MIPI timing registers

RAW format registers

Exposure registers

Analog gain registers

Digital gain registers

Mode select register

This improves repeatability and makes the sensor bring-up sequence easier to debug.

## 20.20 Software Structure Notes

The source document states that the Vitis program design is divided into video initialization, configuration, control, and transmission, and that the overall software structure shows program and data flow.

A practical software structure is:

main()

init_platform()

init_i2c()

init_sensor()

init_mipi_rx()

init_demosaic()

init_vdma()

init_vcp()

init_display_or_udp()

start_stream()

control_loop()

The software should separate:

| **Software Block** | **Responsibility**                 |
|--------------------|------------------------------------|
| Sensor driver      | I2C register programming           |
| MIPI driver        | Receiver configuration and status  |
| VDMA driver        | Frame-buffer transfer              |
| VCP driver         | Processing-mode configuration      |
| Network driver     | UDP streaming and command handling |
| Diagnostics        | Counters, status, error reporting  |

## 20.21 Verification Strategy

### 20.21.1 Sensor-Level Verification

Verify:

- I2C communication.

- Sensor ID readback.

- Register writes.

- Stream-on command.

- MIPI lane activity.

- Receiver lock.

- RAW format output.

### 20.21.2 Frame-Level Verification

Verify:

- Correct frame width.

- Correct frame height.

- Correct line count.

- Correct pixel count.

- Stable frame rate.

- No dropped lines.

- No blank frame after stream enable.

### 20.21.3 Color-Level Verification

Verify:

- Correct Bayer phase.

- Correct demosaic output.

- No red/blue inversion.

- No excessive green or magenta tint.

- Correct RAW-to-RGB scaling.

- Correct white-balance baseline.

### 20.21.4 System-Level Verification

Verify:

- VCP receives valid RGB stream.

- Filters operate correctly.

- K-means output works.

- Display output is stable.

- Ethernet UDP output is stable.

- Frame counters and diagnostics agree.

## 20.22 Hardware Design Recommendations

1.  **Parameterize lane count, data type, and frame size.**  
    This allows multiple sensors to share the same receiver and VCP path.

2.  **Keep sensor register tables separate by mode.**  
    Avoid mixing 1080p, 4K, and full-resolution settings.

3.  **Expose sensor status through software diagnostics.**  
    I2C status, stream state, frame count, and error flags reduce bring-up time.

4.  **Validate Bayer phase early.**  
    A wrong Bayer pattern may still produce a stable image, but color will be incorrect.

5.  **Match MIPI receiver configuration to the sensor exactly.**  
    Lane count, RAW data type, and line rate must agree.

6.  **Use lower-resolution modes for first bring-up.**  
    Start with 720p or 1080p before testing 4K or full sensor resolution.

7.  **Document all sensor register values.**  
    Repeatable builds require traceable configuration data.

8.  **Use test patterns when available.**  
    Sensor-generated test patterns simplify debugging of lane order, bit alignment, and color mapping.

## 20.23 Chapter Summary

This chapter described sensor-specific implementation notes for integrating multiple camera sensors into the FPGA Video Color Processing System. The supported camera family includes IMX477, IMX219, IMX519, IMX682, AR1335, OV5640, and OV5647-style modules. The design uses MIPI CSI-2 camera input, D-PHY receiver logic, RAW Bayer capture, demosaic conversion, VDMA, VCP processing, and output through DisplayPort or Ethernet.

The source document identifies IMX477 and AR1335 as high-resolution camera sources connected through MIPI CSI-2, with IMX477 using a 2-lane path and AR1335 using a 4-lane path in the documented system. It also states that RAW10 frames are captured and converted from Bayer to RGB by the demosaic module.

A reliable sensor implementation requires correct I2C configuration, lane-count matching, RAW-format selection, Bayer phase control, demosaic alignment, VDMA sizing, software initialization, and systematic bring-up verification. Once each sensor produces a stable RGB stream, the same Video Color Processing pipeline can apply filtering, color correction, K-means clustering, histogram analysis, and Ethernet/DisplayPort output.
