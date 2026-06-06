# Chapter 19 — Video Stream Data Format

## 19.1 Overview

The **Video Stream Data Format** defines how image pixels, frame metadata, packet headers, and payload data are represented when video is transferred from the FPGA development board to a host computer. In the FPGA Video Color Processing System, the stream format is important because the host application, FFmpeg/FFplay, UDP receiver, and FPGA transmitter must all interpret the image data in the same way.

The source design states that the host-side GUI receives image data from the FPGA development board and that FFmpeg/ffplay.exe decodes the received BMP images into a video stream at a specified frame rate.

A simplified video stream format flow is:

Processed RGB Frame

↓

Frame Header

↓

Pixel Payload

↓

UDP Packetization

↓

Host Receiver

↓

Image Decode / Video Display

The stream format must define:

- Frame width.

- Frame height.

- Pixel format.

- Pixel ordering.

- Header structure.

- Payload size.

- Packet sequence.

- Frame sequence.

- Endianness.

- Host decoding method.

## 19.2 Purpose of a Defined Video Stream Format

A defined stream format ensures that the receiver correctly reconstructs the image. Without a known format, the host may interpret pixel bytes incorrectly, resulting in color swaps, shifted lines, distorted frames, or decode failure.

The stream format supports:

| **Purpose**          | **Description**                                                      |
|----------------------|----------------------------------------------------------------------|
| Frame reconstruction | Allows the host to rebuild complete images from packets.             |
| Pixel interpretation | Defines RGB, BGR, grayscale, or other pixel order.                   |
| Decode compatibility | Allows FFmpeg/FFplay or custom software to display frames.           |
| Error detection      | Provides frame ID, packet ID, and payload length fields.             |
| Synchronization      | Identifies frame start, frame end, and packet sequence.              |
| Debugging            | Makes network and video errors easier to isolate.                    |
| Extensibility        | Allows future formats such as RGB565, grayscale, or compressed data. |

A consistent format is essential when moving video data across PL logic, PS software, UDP packets, and host-side decoding tools.

## 19.3 Stream Format Layers

The video stream can be understood as a layered structure.

Application Frame Format

↓

Video Frame Header

↓

Pixel Payload

↓

UDP Packet Header

↓

IP Packet

↓

Ethernet Frame

Each layer has a different function:

| **Layer**         | **Function**                                      |
|-------------------|---------------------------------------------------|
| Pixel format      | Defines how one pixel is represented.             |
| Frame format      | Defines how all pixels form one image.            |
| Image header      | Describes the image type, size, and pixel offset. |
| UDP packet format | Splits the image into network payloads.           |
| Network format    | Transports the packets over Ethernet.             |

This chapter focuses on the video frame, image header, pixel payload, and UDP packet payload structure used by the FPGA video-streaming design.

## 19.4 BMP-Style Frame Header

The source document states that, when video images are received, FFmpeg invokes ffplay.exe, which decodes the first **54 bytes** as the source video type, and the document references a 54-byte video header format.

A 54-byte header is consistent with a basic BMP-style image header:

14-byte bitmap file header

40-byte bitmap information header

Total = 54 bytes

A practical 54-byte frame header contains:

| **Field**          | **Typical Size** | **Purpose**                     |
|--------------------|------------------|---------------------------------|
| Signature          | 2 bytes          | Identifies BMP-like frame type  |
| File size          | 4 bytes          | Header plus pixel payload size  |
| Reserved fields    | 4 bytes          | Reserved or unused              |
| Pixel data offset  | 4 bytes          | Usually 54 bytes                |
| DIB header size    | 4 bytes          | Usually 40 bytes                |
| Image width        | 4 bytes          | Frame width in pixels           |
| Image height       | 4 bytes          | Frame height in pixels          |
| Planes             | 2 bytes          | Usually 1                       |
| Bits per pixel     | 2 bytes          | Example: 24 for RGB888/BGR888   |
| Compression        | 4 bytes          | Usually 0 for uncompressed data |
| Image payload size | 4 bytes          | Pixel data size                 |
| X/Y resolution     | 8 bytes          | Optional display metadata       |
| Color table fields | 8 bytes          | Usually 0 for direct color      |

The FPGA/PS transmitter must generate this header consistently so the host-side decoder can identify the incoming image correctly.

## 19.5 Pixel Payload Format

After the header, the stream carries pixel payload data. The payload is the actual frame image.

For 24-bit color:

Bytes per pixel = 3

Frame payload size = width × height × 3

A common BMP payload byte order is **BGR** rather than RGB:

Pixel byte 0 = Blue

Pixel byte 1 = Green

Pixel byte 2 = Red

However, many FPGA video pipelines internally use RGB order:

Pixel byte 0 = Red

Pixel byte 1 = Green

Pixel byte 2 = Blue

Therefore, the transmitter must explicitly define whether the payload is RGB or BGR.

**Recommended Payload Declaration**

| **Internal Format** | **Host Payload Format** | **Required Action**                   |
|---------------------|-------------------------|---------------------------------------|
| RGB888              | RGB888 raw stream       | No channel swap                       |
| RGB888              | BMP/BGR888              | Swap red and blue before transmission |
| BGR888              | BMP/BGR888              | No channel swap                       |
| Grayscale           | 8-bit raw               | Send one byte per pixel               |
| RGB565              | 16-bit packed           | Pack to 2 bytes per pixel             |

If the host displays red objects as blue, the payload is likely using the wrong RGB/BGR order.

## 19.6 RGB888 Data Format

RGB888 uses 24 bits per pixel:

R = 8 bits

G = 8 bits

B = 8 bits

Total = 24 bits

A common internal FPGA stream layout is:

TDATA\[23:16\] = Red

TDATA\[15:8\] = Green

TDATA\[7:0\] = Blue

For byte-oriented UDP transmission, RGB888 can be serialized as:

Byte 0 = R

Byte 1 = G

Byte 2 = B

or, for BMP-compatible BGR888:

Byte 0 = B

Byte 1 = G

Byte 2 = R

The selected ordering must be documented and used consistently by the receiver.

## 19.7 Grayscale Data Format

Grayscale uses one byte per pixel for 8-bit output:

Gray = 8 bits

Bytes per pixel = 1

A grayscale frame payload size is:

payload_size = width × height

Grayscale is useful for:

- Sobel edge output.

- Threshold masks.

- Histogram visualization.

- Low-bandwidth streaming.

- Debug output.

When Ethernet bandwidth is limited, grayscale streaming can reduce payload size by approximately 66% compared with RGB888.

## 19.8 RGB565 Data Format

RGB565 packs one pixel into 16 bits:

R = 5 bits

G = 6 bits

B = 5 bits

Total = 16 bits

Packing equation:

rgb565\[15:11\] = R\[7:3\]

rgb565\[10:5\] = G\[7:2\]

rgb565\[4:0\] = B\[7:3\]

This format reduces payload size:

RGB888 bytes per pixel = 3

RGB565 bytes per pixel = 2

RGB565 is useful when a compromise is needed between color output and Ethernet bandwidth.

## 19.9 Frame Size Calculation

The frame payload size depends on width, height, and bytes per pixel.

payload_size = width × height × bytes_per_pixel

The total frame size with a 54-byte header is:

frame_size = 54 + payload_size

Example calculations:

| **Resolution** | **Format** | **Payload Size** | **Total With 54-Byte Header** |
|----------------|------------|------------------|-------------------------------|
| 640×480        | RGB888     | 921,600 bytes    | 921,654 bytes                 |
| 1280×720       | RGB888     | 2,764,800 bytes  | 2,764,854 bytes               |
| 1920×1080      | RGB888     | 6,220,800 bytes  | 6,220,854 bytes               |
| 1280×720       | Grayscale  | 921,600 bytes    | 921,654 bytes                 |
| 1280×720       | RGB565     | 1,843,200 bytes  | 1,843,254 bytes               |

This calculation is required for header generation, packetization, and host-side frame reconstruction.

## 19.10 Line Stride and Alignment

Line stride is the number of bytes between the start of one image row and the start of the next image row.

For tightly packed RGB888:

stride = width × 3

For tightly packed grayscale:

stride = width

Some image formats require each row to be aligned to a 4-byte boundary. For BMP-style data, line stride may need padding:

bmp_stride = ((width × bits_per_pixel + 31) / 32) × 4

If padding is required but omitted, the displayed image may appear shifted or skewed line by line.

## 19.11 Frame Orientation

BMP-style images may treat positive height values as bottom-up images. That means the first row in the payload represents the bottom line of the image. Some streaming systems use top-down order.

Two common choices are:

| **Orientation** | **Description**                       |
|-----------------|---------------------------------------|
| Top-down        | First payload row is top image row    |
| Bottom-up       | First payload row is bottom image row |

For real-time video streaming, top-down order is easier because it matches raster scan order:

Row 0

Row 1

Row 2

...

Row H-1

If a BMP-style header is used and top-down display is desired, the height field may need to be encoded according to the decoder’s expected convention.

## 19.12 UDP Packet Payload Structure

A complete frame is usually split into multiple UDP packets. Each packet should contain either:

1.  A portion of the frame stream directly, or

2.  A custom packet header followed by part of the frame stream.

Recommended packet structure:

Custom UDP Video Packet Header

Frame ID

Packet ID

Total Packets

Payload Offset

Payload Length

Flags

Video Payload Bytes

This allows the host to detect missing packets and reconstruct the frame in the correct order.

## 19.13 Frame ID and Packet ID

A **Frame ID** identifies the video frame. A **Packet ID** identifies the packet inside that frame.

Frame 100:

Packet 0

Packet 1

Packet 2

...

Packet N

Recommended fields:

| **Field**      | **Purpose**                                     |
|----------------|-------------------------------------------------|
| frame_id       | Detects new frames and dropped frames           |
| packet_id      | Detects missing packets                         |
| total_packets  | Allows receiver to know when frame is complete  |
| payload_offset | Places payload at correct frame-buffer location |
| payload_length | Validates packet size                           |
| flags          | Marks first or last packet                      |

These fields make UDP loss or reordering detectable.

## 19.14 Payload Offset

Payload offset defines where the packet data belongs inside the reconstructed frame buffer.

destination_address = frame_buffer_base + payload_offset

For a header-plus-payload stream, packet 0 may start with the 54-byte frame header:

payload_offset = 0

packet_payload = header\[0:53\] + first_pixel_bytes

Later packets continue at increasing offsets:

payload_offset = packet_id × payload_bytes_per_packet

The receiver should use the offset rather than assuming packets always arrive in order.

## 19.15 Endianness

Endianness must be defined for multi-byte fields such as width, height, frame size, frame ID, and packet ID.

Recommended rule:

Network packet metadata = big-endian

BMP-style header fields = little-endian

Pixel bytes = format-specific byte order

This separates network protocol convention from file/image header convention. The receiver must parse each field using the correct endianness.

## 19.16 Stream Header Versus Packet Header

The design may contain two different headers:

| **Header Type**    | **Purpose**                                        |
|--------------------|----------------------------------------------------|
| Frame/image header | Describes the image format to FFmpeg/FFplay        |
| UDP packet header  | Describes packet order and reconstruction metadata |

The 54-byte BMP-style header belongs to the **frame/image format**. The UDP packet header belongs to the **transport format**.

Recommended structure:

UDP Packet Header

↓

Frame Header or Frame Payload Fragment

For packet 0:

UDP Packet Header + 54-byte BMP Header + first pixel bytes

For later packets:

UDP Packet Header + pixel payload bytes

## 19.17 Host GUI Data Handling

The source design states that the GUI on the remote computer sends commands to the FPGA board IP address and receives image data from the development board.

The GUI receiver should perform:

1.  Open UDP socket.

2.  Receive video packets.

3.  Validate packet header.

4.  Reconstruct frame buffer.

5.  Parse 54-byte frame header.

6.  Pass complete frame to FFmpeg/FFplay or internal display code.

7.  Track frame rate, packet loss, and bandwidth.

A simple receiver model is:

while streaming:

packet = udp_receive()

parse packet_header

copy payload to frame_buffer\[payload_offset\]

if frame_complete:

display frame

## 19.18 FFmpeg / FFplay Decode Path

The source document states that FFmpeg invokes ffplay.exe to decode received BMP images into a video stream at a specified frame rate.

The host display flow is:

UDP Receiver

↓

Complete BMP-like Frame

↓

FFmpeg / FFplay Decode

↓

Video Display Window

FFplay requires the received frame data to match the declared format. If the header declares 24-bit BMP but the payload is RGB instead of BGR, the image may display with swapped red and blue channels.

## 19.19 Pixel Order and Color Channel Verification

Correct color-channel order should be verified using known test patterns.

Recommended color-bar test:

| **Test Region** | **Expected RGB**       |
|-----------------|------------------------|
| Red bar         | R high, G low, B low   |
| Green bar       | R low, G high, B low   |
| Blue bar        | R low, G low, B high   |
| White bar       | R high, G high, B high |
| Black bar       | R low, G low, B low    |

If red appears blue and blue appears red, the byte order should be changed from RGB to BGR or BGR to RGB.

## 19.20 Frame Synchronization

Frame synchronization ensures that each displayed frame begins at the correct first byte.

The receiver should identify:

- First packet of frame.

- Last packet of frame.

- Frame ID transition.

- Expected total frame size.

- Expected total packet count.

- Payload offset continuity.

A frame should be marked valid only if:

all expected packets are received

and total bytes == expected frame size

and frame header is valid

Incomplete frames should be dropped or flagged.

## 19.21 Packet Loss and Incomplete Frame Handling

UDP may lose packets. The receiver should detect this using packet IDs or payload offsets.

Possible handling methods:

| **Method**              | **Description**                         |
|-------------------------|-----------------------------------------|
| Drop frame              | Safest for display correctness          |
| Fill missing section    | Replace missing data with black         |
| Use previous frame data | Reuse previous pixels in missing region |
| Show partial frame      | Useful for debugging only               |
| Count packet loss       | Report network quality                  |

A robust display receiver should avoid showing corrupted frames unless debug mode is enabled.

## 19.22 Bandwidth and Format Tradeoffs

The stream format should match available Ethernet bandwidth.

| **Format**            | **Bytes/Pixel** | **Bandwidth Demand** | **Visual Quality** |
|-----------------------|-----------------|----------------------|--------------------|
| Grayscale             | 1               | Low                  | Low to medium      |
| RGB565                | 2               | Medium               | Medium             |
| RGB888                | 3               | High                 | High               |
| BMP RGB888/BGR888     | 3 + header      | High                 | High               |
| Compressed JPEG/H.264 | Variable        | Low to medium        | Depends on encoder |

For 1 Gigabit Ethernet, full uncompressed RGB888 at high resolution may exceed practical bandwidth. Lower resolution, frame skipping, grayscale, or RGB565 can improve stability.

## 19.23 Register-Level Format Control

A representative register/control map for stream formatting is:

| **Register**        | **Function**                                 |
|---------------------|----------------------------------------------|
| STREAM_CONTROL      | Enable, reset, start, stop                   |
| STREAM_FORMAT       | RGB888, BGR888, RGB565, grayscale            |
| STREAM_WIDTH        | Output frame width                           |
| STREAM_HEIGHT       | Output frame height                          |
| STREAM_STRIDE       | Bytes per output line                        |
| STREAM_HEADER_MODE  | None, BMP54, custom                          |
| STREAM_FRAME_ID     | Current frame number                         |
| STREAM_PAYLOAD_SIZE | Payload bytes per frame                      |
| STREAM_PACKET_SIZE  | UDP payload bytes per packet                 |
| STREAM_STATUS       | Active state and error flags                 |
| STREAM_ERROR_STATUS | Format mismatch, packet overflow, frame drop |

These controls allow software to configure the stream format without changing the FPGA design.

## 19.24 Verification Strategy

### 19.24.1 Header Verification

Check that:

- Header size is 54 bytes when BMP-style format is selected.

- Image width matches transmitted frame width.

- Image height matches transmitted frame height.

- Bits-per-pixel field matches payload format.

- Pixel offset points to the first pixel byte.

- Frame size matches header plus payload.

### 19.24.2 Payload Verification

Check that:

- Payload byte count equals width × height × bytes_per_pixel.

- Line stride is correct.

- Pixel order is correct.

- RGB/BGR ordering is correct.

- No extra bytes are inserted or removed.

- First and last pixels are at expected offsets.

### 19.24.3 Packet Verification

Check that:

- Packet IDs are continuous.

- Frame IDs increment correctly.

- Payload offsets are correct.

- Total packet count is correct.

- Last packet length is correct.

- Incomplete frames are detected.

### 19.24.4 Display Verification

Use known test patterns:

| **Pattern**     | **Verification Purpose**        |
|-----------------|---------------------------------|
| Solid red       | RGB/BGR channel order           |
| Solid green     | Green channel position          |
| Solid blue      | RGB/BGR channel order           |
| Horizontal ramp | Pixel order and stride          |
| Vertical ramp   | Row order and frame orientation |
| Checkerboard    | Packet and line alignment       |
| Color bars      | Full color validation           |

## 19.25 Common Failure Modes

| **Failure Mode**           | **Likely Cause**                       | **Correction**                            |
|----------------------------|----------------------------------------|-------------------------------------------|
| FFplay cannot decode frame | Bad header or size mismatch            | Verify 54-byte header fields              |
| Image colors swapped       | RGB/BGR mismatch                       | Swap red and blue bytes                   |
| Image appears slanted      | Incorrect stride or row padding        | Correct line-stride calculation           |
| Image upside down          | Orientation mismatch                   | Use correct row order or height sign      |
| Frame tears or jumps       | Packet loss or missing synchronization | Use frame and packet IDs                  |
| Receiver buffer overflow   | Packet rate too high                   | Reduce frame rate or payload size         |
| Incomplete image           | Dropped UDP packets                    | Drop incomplete frame or reduce bandwidth |
| Random color noise         | Wrong pixel format                     | Match stream format to decoder setting    |

## 19.26 Hardware and Software Design Recommendations

1.  **Document the exact pixel format.**  
    RGB888, BGR888, RGB565, and grayscale must not be treated as interchangeable.

2.  **Use a fixed 54-byte BMP-style header only when FFplay expects BMP image frames.**  
    Header values must match the actual payload.

3.  **Use a custom UDP packet header for reconstruction.**  
    Include frame ID, packet ID, payload offset, payload length, and flags.

4.  **Avoid IP fragmentation.**  
    Keep packet payloads within standard Ethernet MTU limits unless jumbo frames are configured.

5.  **Validate with color bars before live camera video.**  
    This quickly exposes RGB/BGR and stride errors.

6.  **Drop incomplete frames by default.**  
    This prevents corrupted video display.

7.  **Expose stream-format registers.**  
    Runtime format control improves testing and deployment flexibility.

8.  **Maintain separate definitions for frame header and packet header.**  
    The image header describes the image; the packet header describes transport.

## 19.27 Chapter Summary

This chapter described the Video Stream Data Format used for Ethernet UDP video output. The stream format defines how pixel data, frame headers, packet headers, payload bytes, frame IDs, and packet IDs are represented so that the host computer can reconstruct and display video correctly.

The source document identifies a Video Stream Data and Format section, states that the remote GUI receives image data from the development board, and notes that FFmpeg/ffplay.exe decodes received BMP images into a video stream at a specified frame rate. It also states that the first 54 bytes are decoded as the source video type, indicating a BMP-style frame header requirement.

A reliable video stream format must define the image header, pixel format, byte ordering, payload size, stride, orientation, packetization, sequence numbers, and receiver behavior. This ensures that FPGA-generated video frames are reconstructed accurately and displayed correctly on the host PC.
