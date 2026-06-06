# Chapter 16 — Camera RAW Data Processing

## 16.1 Overview

Camera RAW data processing is the front-end image-preparation stage that converts sensor-originated pixel information into a stable internal stream for downstream video processing. In the FPGA Video Color Processing System, RAW data handling begins at the camera interface, continues through buffering and synchronization, and feeds the demosaic and RGB video-processing stages.

The source design states that the MIPI CSI-2 receiver captures video stream frames from IMX477 and AR1335 cameras in **RAW10 format**, and that the demosaic module converts the Bayer-pattern input frame into an RGB color frame.

A simplified RAW processing flow is:

Camera Sensor

↓

RAW Bayer / RAW10 Data Stream

↓

MIPI CSI-2 Receiver or Parallel Camera Interface

↓

Pixel Alignment and Line Buffering

↓

Frame / Line Valid Qualification

↓

Demosaic Processing

↓

RGB Pixel Stream

↓

Video Color Processing Module

The objective is to preserve the sensor pixel order, frame timing, line timing, bit precision, and Bayer phase before RGB conversion.

## 16.2 Purpose of Camera RAW Data Processing

Camera sensors usually do not output final RGB pixels directly. Instead, they output RAW samples arranged according to a color filter array, commonly a Bayer pattern. RAW processing prepares this sensor data for later color reconstruction and image enhancement.

Camera RAW data processing provides:

| **Function**              | **Description**                                                        |
|---------------------------|------------------------------------------------------------------------|
| Pixel capture             | Samples camera output at the correct pixel clock or stream rate.       |
| RAW format handling       | Receives RAW8, RAW10, RAW12, or parallel sensor data.                  |
| Bayer phase preservation  | Maintains the correct red, green, and blue sampling pattern.           |
| Line buffering            | Stores image data line by line for controlled readout.                 |
| Clock synchronization     | Transfers pixel data from camera timing into system timing.            |
| Valid-pixel qualification | Uses frame-valid and line-valid signals to identify active image data. |
| Demosaic preparation      | Provides correctly aligned Bayer data to the RGB reconstruction stage. |
| Pipeline formatting       | Converts sensor data into an internal video-stream format.             |

The source document describes host camera data being stored into a buffer line by line, then fetched at the system clock rate. It also states that valid read is enabled when both frame-valid and line-valid signals are asserted.

## 16.3 RAW Sensor Data Concept

RAW camera data is a direct representation of sensor samples before full RGB reconstruction. Each pixel sample usually represents only one color component because the sensor uses a color filter array.

A Bayer-pattern sensor may arrange pixels as:

G R G R G R

B G B G B G

G R G R G R

B G B G B G

Each location stores one component:

- Red sample

- Green sample

- Blue sample

A demosaic stage later estimates the missing components so that every output pixel has full RGB data.

## 16.4 RAW10 Format

RAW10 means that each sensor pixel sample uses 10 bits. It provides more precision than RAW8 while requiring less bandwidth than RAW12 or RAW16.

RAW10 sample range = 0 to 1023

The design’s MIPI CSI-2 receiver settings identify RAW10 as the selected pixel format for both a 2-lane receiver configuration and a 4-lane receiver configuration.

### 16.4.1 RAW10 Advantages

RAW10 provides:

- Higher precision than 8-bit capture.

- Improved dynamic range for later processing.

- Better preservation of sensor intensity detail.

- Manageable MIPI bandwidth compared with wider formats.

- Suitable input precision for RGB gain, color correction, and enhancement.

### 16.4.2 RAW10 Processing Requirement

RAW10 data must be:

1.  Correctly received from the MIPI CSI-2 stream.

2.  Unpacked or aligned into internal pixel words.

3.  Associated with the correct Bayer phase.

4.  Qualified by frame and line timing.

5.  Delivered to the demosaic stage without pixel-order errors.

## 16.5 RAW12 and Parallel Camera Data

The source design also describes a camera RAW data module that reads **12-bit RGB data from Demosaic Xilinx IP**, uses an external pixel clock, and stores host camera data into buffers line by line.

The camera RAW data module interface includes:

integer img_width

integer dataWidth

integer addrWidth

std_logic pixclk

std_logic ifval

std_logic ilval

std_logic_vector(dataWidth-1 downto 0) idata

oRgbSet rRgb

The source document also states that the host camera interface uses **12-bit parallel input data** with line and frame valid control signals.

This means the architecture can support both:

| **Interface Type**        | **Example Data**   | **Control Method**                                |
|---------------------------|--------------------|---------------------------------------------------|
| MIPI CSI-2                | RAW10 Bayer stream | CSI-2 packets, TUSER, TLAST, valid stream control |
| Parallel camera interface | 12-bit pixel data  | Pixel clock, frame valid, line valid              |

## 16.6 Bayer Pattern Handling

The input data from the camera is arranged in a Bayer pattern. The source document states that input camera data is color-filtered and arranged in a Bayer pattern, then read line by line at the pixel clock rate before being synchronized into the system clock.

Correct Bayer handling requires:

- Correct first-pixel color identification.

- Correct line parity tracking.

- Correct column parity tracking.

- Correct reset of coordinates at start of frame.

- Correct handling of crop offsets or sensor orientation.

- Correct demosaic input alignment.

A Bayer phase can be represented using coordinate parity:

if y is even and x is even: pixel = G

if y is even and x is odd: pixel = R

if y is odd and x is even: pixel = B

if y is odd and x is odd: pixel = G

The exact phase depends on the sensor configuration and should be treated as a configurable parameter.

## 16.7 Pixel Clock Sampling

For parallel camera data, the pixel clock controls when pixel data is sampled. The source document states that the external pixel clock from the camera is used to sample one pixel, and this pixel clock corresponds to one generated master external clock cycle.

A simplified sampling rule is:

on rising_edge(pixclk):

if frame_valid == 1 and line_valid == 1:

capture idata

The pixel clock domain is usually different from the internal system clock domain. Therefore, buffering or clock-domain crossing logic is required.

## 16.8 Frame Valid and Line Valid Signals

Frame-valid and line-valid signals define which pixels belong to the active image area.

| **Signal**          | **Meaning**                   |
|---------------------|-------------------------------|
| ifval / frame valid | Indicates active frame period |
| ilval / line valid  | Indicates active line period  |
| idata               | Camera pixel data             |
| pixclk              | Camera pixel sampling clock   |

The source document states that valid reading is enabled when both frame-valid and line-valid are asserted high.

A standard valid-pixel expression is:

pixel_valid = frame_valid AND line_valid

Only pixels satisfying this condition should be written into the active line buffer or passed into the image-processing pipeline.

## 16.9 Line Buffer Storage

The camera RAW data module stores incoming data line by line. The source document states that host camera data is stored into a buffer line by line and then fetched at the system clock rate. It also states that the buffer size is set to the frame width.

A typical buffer model is:

Write side:

clock = pixclk

write_enable = frame_valid AND line_valid

write_address = x_position

write_data = camera_pixel

Read side:

clock = system_clk

read_enable = processing_ready

read_address = x_position

read_data = buffered_pixel

This structure allows the camera input clock and the processing clock to operate independently.

## 16.10 Camera-to-System Clock Synchronization

The RAW data path often crosses from a camera pixel-clock domain into a faster internal system-clock domain.

The source document states that the values written to the buffer run at the pixel clock rate, whereas the buffer read side runs at a faster rate than the pixel clock.

A safe clock-domain crossing can be implemented using:

| **Method**             | **Use**                                     |
|------------------------|---------------------------------------------|
| Dual-clock FIFO        | Stream crossing between unrelated clocks    |
| Dual-port RAM          | Line buffer with separate read/write clocks |
| Handshake synchronizer | Control event crossing                      |
| Gray-coded counters    | FIFO pointer crossing                       |
| Reset synchronizer     | Clean reset release per clock domain        |

A dual-clock line buffer is a practical solution when pixel data must be written by pixclk and read by system_clk.

## 16.11 Buffer Size and Frame Width

The line buffer size should match the active frame width. The source document states that the buffer size is auto-size supported using the input line-valid signal and that the maximum default value is 3071.

A buffer sizing rule is:

buffer_depth \>= active_image_width

Examples:

| **Image Width** | **Required Buffer Depth** |
|-----------------|---------------------------|
| 1280            | At least 1280 entries     |
| 1920            | At least 1920 entries     |
| 2560            | At least 2560 entries     |
| 3072            | At least 3072 entries     |
| 3840            | At least 3840 entries     |

If the configured buffer depth is too small, the line will overflow and pixels will be lost.

## 16.12 Internal Pipeline Width

The source document states that a base configuration consists of a **single 24-bit pipeline** capable of processing **1080p HD video at 30 frames per second**.

A 24-bit RGB pipeline typically means:

R = 8 bits

G = 8 bits

B = 8 bits

Total = 24 bits

For RAW10 or RAW12 internal processing, the design may use wider formats before conversion or scale the result into 8-bit RGB for downstream modules.

Typical internal widths:

| **Stage**       | **Width** |
|-----------------|-----------|
| RAW8 sample     | 8 bits    |
| RAW10 sample    | 10 bits   |
| RAW12 sample    | 12 bits   |
| RGB888 pixel    | 24 bits   |
| RGB101010 pixel | 30 bits   |
| RGB121212 pixel | 36 bits   |

## 16.13 RAW Data to RGB Conversion

RAW Bayer data must be converted into RGB before most VCP functions can operate. The demosaic stage reconstructs complete RGB pixels from neighboring Bayer samples.

RAW Bayer Pixel Stream

↓

Demosaic

↓

RGB Pixel Stream

The source document states that the demosaic module converts Bayer-pattern input frames into RGB color frames.

After demosaic conversion, the RGB stream can be processed by:

- RGB gain.

- Brightness and contrast.

- Color correction matrix.

- HSL/HSV conversion.

- K-means color clustering.

- Spatial filters.

- Histogram generation.

- Ethernet or DisplayPort output.

## 16.14 RAW Data Flow Architecture

A practical RAW data flow architecture is:

Camera Data Input

↓

Pixel Valid Qualification

↓

Write Address Counter

↓

Line Buffer Write

↓

Read Address Controller

↓

Clock Domain Crossing

↓

Demosaic Input Formatter

↓

RGB Output Formatter

The module must track:

- Current pixel position.

- Current line number.

- Active frame state.

- Write pointer.

- Read pointer.

- Buffer-full state.

- Buffer-empty state.

- Frame-start event.

- Line-end event.

## 16.15 Pixel Coordinates

Pixel coordinates are required for Bayer phase tracking, line buffering, demosaic alignment, histogram generation, and debug.

A coordinate tracker can be implemented as:

if frame_start:

x \<= 0

y \<= 0

else if pixel_valid:

if line_end:

x \<= 0

y \<= y + 1

else:

x \<= x + 1

The source document references pixel coordinate figures in the Camera Raw Data section, indicating that coordinate tracking is part of the RAW data processing flow.

## 16.16 Three-Tap and Four-Tap Data Structures

The source document includes “THREE TAPS DATA” and “FOUR TAPS DATA” in the Camera Raw Data section.

Tap structures are used to access neighboring pixels in a streaming image pipeline.

### 16.16.1 Three-Tap Data

Three taps provide access to three adjacent pixels:

tap0 = P(x-1)

tap1 = P(x)

tap2 = P(x+1)

This is useful for:

- Horizontal filtering.

- Demosaic interpolation.

- Edge detection.

- Local averaging.

### 16.16.2 Four-Tap Data

Four taps provide a wider local context:

tap0 = P(x-1)

tap1 = P(x)

tap2 = P(x+1)

tap3 = P(x+2)

This can support higher-quality interpolation or more advanced local processing.

## 16.17 MIPI RAW Stream Handling

For the MIPI CSI-2 path, RAW pixels are received as serialized packet data rather than simple parallel samples. The receiver subsystem converts packetized MIPI data into an internal stream.

The design identifies:

| **MIPI CSI-2 Parameter** | **Configuration** |
|--------------------------|-------------------|
| Pixel format             | RAW10             |
| Receiver 1 lanes         | 2 lanes           |
| Receiver 1 line rate     | 2500 Mbps         |
| Receiver 2 lanes         | 4 lanes           |
| Receiver 2 line rate     | 2000 Mbps         |
| Pixel per clock          | 1                 |
| TUSER width              | 1                 |
| CRC                      | Enabled           |

These settings are listed in the source Vivado configuration for the MIPI CSI-2 RX subsystems.

The MIPI RAW stream must preserve:

- Pixel order.

- Line boundaries.

- Frame boundaries.

- Bayer phase.

- Pixel bit precision.

- Virtual-channel selection.

- Packet integrity.

## 16.18 RAW Bandwidth Considerations

RAW input bandwidth depends on pixel clock and sample width.

The basic equation is:

Bandwidth = Pixel Clock Frequency × Pixel Size

The source document gives RAW10 examples where bandwidth is calculated using 10 bits per pixel, such as 1920×1080p60 RAW10 producing 1485 Mbps total bandwidth over two lanes.

For RAW10:

RAW10 bandwidth = pixel_clock × 10

For RAW12:

RAW12 bandwidth = pixel_clock × 12

For RGB888 after demosaic:

RGB888 bandwidth = pixel_clock × 24

This means the internal RGB stream may require more bandwidth than the RAW input stream.

## 16.19 RAW Data Error Conditions

The RAW data processing block should detect and report error conditions.

| **Error Condition**  | **Possible Cause**                        | **Effect**                      |
|----------------------|-------------------------------------------|---------------------------------|
| Frame-valid missing  | Camera not streaming or control error     | No valid image                  |
| Line-valid missing   | Sensor timing issue                       | No active line data             |
| Buffer overflow      | System read side too slow                 | Pixel loss                      |
| Buffer underflow     | Read side too fast or write side inactive | Invalid output                  |
| Wrong Bayer phase    | Incorrect first-pixel configuration       | Color tint or channel inversion |
| RAW bit misalignment | Incorrect MIPI unpacking                  | Corrupted image intensity       |
| Frame width mismatch | Wrong resolution or line count            | Line wrapping errors            |
| Clock-domain error   | Unsafe CDC                                | Intermittent image corruption   |
| CRC error            | MIPI packet corruption                    | Invalid frame data              |

The RAW data module should expose status flags for these errors through a diagnostic or AXI4-Lite register interface.

## 16.20 Register-Level Control

A representative RAW data processing register map is:

| **Register**     | **Function**                                        |
|------------------|-----------------------------------------------------|
| RAW_CONTROL      | Enable, bypass, reset, and mode control             |
| RAW_STATUS       | Active state, lock state, and error flags           |
| RAW_WIDTH        | Active frame width                                  |
| RAW_HEIGHT       | Active frame height                                 |
| RAW_FORMAT       | RAW8, RAW10, RAW12, or RGB input selection          |
| RAW_BAYER_PHASE  | Bayer pattern selection                             |
| RAW_BUFFER_DEPTH | Configured line-buffer depth                        |
| RAW_FRAME_COUNT  | Number of frames captured                           |
| RAW_LINE_COUNT   | Number of lines captured                            |
| RAW_PIXEL_COUNT  | Pixels captured in current line                     |
| RAW_ERROR_STATUS | Overflow, underflow, phase, width, or timing errors |

These registers make the RAW input path easier to validate during hardware bring-up.

## 16.21 Verification Strategy

Camera RAW data processing should be verified at module level and system level.

### 16.21.1 Directed Module Tests

Use synthetic RAW input patterns:

| **Pattern**         | **Purpose**                      |
|---------------------|----------------------------------|
| Constant value      | Checks stable capture and output |
| Horizontal ramp     | Verifies pixel order             |
| Vertical ramp       | Verifies line order              |
| Bayer color pattern | Verifies phase handling          |
| Checkerboard        | Tests high-frequency alignment   |
| Short line          | Tests width mismatch detection   |
| Missing line-valid  | Tests valid-signal gating        |
| Clock mismatch      | Tests buffer behavior            |

### 16.21.2 Demosaic Alignment Tests

Use a known Bayer test pattern and verify that the output RGB image reconstructs correctly.

Validation checks:

- Red samples appear in red locations.

- Green samples appear in green locations.

- Blue samples appear in blue locations.

- No row or column phase shift.

- No swapped red/blue channels.

- No line offset.

### 16.21.3 Full-System Tests

Full-system validation should confirm:

- Camera streaming starts correctly.

- MIPI receiver locks.

- RAW data is captured.

- Demosaic output becomes valid RGB.

- VCP receives correct RGB data.

- DisplayPort or Ethernet output shows stable video.

- Frame counters increment correctly.

- No overflow or underflow flags are active.

## 16.22 Common Failure Modes

| **Failure Mode**            | **Likely Cause**                       | **Correction**                              |
|-----------------------------|----------------------------------------|---------------------------------------------|
| Green or magenta image tint | Wrong Bayer phase                      | Correct Bayer pattern configuration         |
| Image shifted horizontally  | Incorrect pixel counter or line width  | Verify active width and line end            |
| Image shifted vertically    | Incorrect frame-start or line counter  | Verify frame valid and SOF handling         |
| Random pixel noise          | RAW bit alignment error                | Verify RAW10/RAW12 unpacking                |
| Dropped lines               | Buffer overflow or read/write mismatch | Increase buffer depth or adjust clocks      |
| No output frame             | Frame-valid or line-valid not asserted | Verify camera configuration                 |
| Incorrect brightness        | RAW bit depth scaling error            | Verify RAW-to-RGB scaling                   |
| Intermittent corruption     | Clock-domain crossing issue            | Use dual-clock FIFO or dual-port RAM safely |

## 16.23 Hardware Design Recommendations

1.  **Preserve Bayer phase from the first active pixel.**  
    Demosaic output depends on correct row and column alignment.

2.  **Use line buffers for clock-domain and line-rate management.**  
    This decouples camera pixel timing from system processing timing.

3.  **Gate writes with frame-valid and line-valid.**  
    Never store inactive or blanking pixels unless explicitly required.

4.  **Use safe clock-domain crossing logic.**  
    Do not directly pass pixel data between unrelated clocks.

5.  **Expose diagnostic counters.**  
    Frame, line, pixel, overflow, and underflow counters speed up bring-up.

6.  **Validate with synthetic Bayer patterns before live camera testing.**

7.  **Parameterize image width and data width.**  
    This supports multiple sensors and pixel formats.

8.  **Clamp or scale RAW-to-RGB outputs consistently.**  
    Avoid brightness mismatch when converting between 10-bit, 12-bit, and 8-bit paths.

## 16.24 Chapter Summary

This chapter described Camera RAW Data Processing for the FPGA Video Color Processing System. RAW processing captures sensor-originated Bayer data, qualifies pixels using frame and line valid signals, stores incoming data line by line, crosses into the system clock domain, and prepares the stream for demosaic conversion.

The source design describes a RAW data module that reads camera data using pixel-clock timing, stores host camera data into line buffers, enables valid reads when frame-valid and line-valid are asserted, and supports a buffer sized to the frame width. It also identifies RAW10 MIPI capture for IMX477 and AR1335 camera paths and confirms that Bayer-pattern input frames are converted into RGB color frames through demosaic processing.

A reliable RAW processing architecture requires correct pixel sampling, RAW bit alignment, Bayer phase tracking, line buffering, clock-domain synchronization, valid-signal qualification, demosaic preparation, diagnostic status reporting, and careful handling of frame and line timing.
