# Chapter 18 — Ethernet UDP Video Streaming

## 18.1 Overview

**Ethernet UDP Video Streaming** provides a network-based method for transmitting processed video frames from the FPGA development board to a host computer. In the FPGA Video Color Processing System, this feature allows the camera output or processed VCP output to be sent over Ethernet for remote viewing, debugging, recording, or software-side analysis.

The source design states that real-time UDP video streaming uses the **Kria KV260 development board** and is implemented using **UDP over Ethernet**.

A simplified UDP streaming flow is:

Camera / VCP Video Stream

↓

Frame Buffer or Packetizer

↓

Video Header Insertion

↓

UDP Payload Formation

↓

LwIP UDP/IP Stack

↓

Gigabit Ethernet MAC / PHY

↓

Host PC Receiver

↓

FFmpeg / FFplay Display

UDP is selected because it provides low-overhead, low-latency transport suitable for video transmission where speed is more important than guaranteed packet delivery.

## 18.2 Purpose of UDP Video Streaming

Ethernet UDP streaming extends the FPGA video-processing pipeline beyond local display output. Instead of only sending video to DisplayPort or memory, the system can stream video frames to a computer through a network connection.

UDP video streaming supports:

| **Purpose**          | **Description**                                                |
|----------------------|----------------------------------------------------------------|
| Remote viewing       | Sends FPGA video output to a host PC.                          |
| Debugging            | Allows processed frames to be inspected outside the board.     |
| Recording            | Enables PC-side frame capture and video logging.               |
| Algorithm validation | Compares hardware output against software analysis tools.      |
| GUI integration      | Allows a host GUI to send commands and receive image data.     |
| Low-latency display  | Uses UDP to reduce protocol overhead.                          |
| Development bring-up | Confirms camera, VCP, memory, and network paths are operating. |

The source document states that the remote GUI sends commands to the FPGA board IP address and receives image data from the development board.

## 18.3 System-Level Streaming Architecture

The source design describes the UDP streaming system as consisting of two platforms: a receiver platform and a transmitter platform. The receiver platform receives input video from the IMX477 camera and implements the PL logic design, while the transmitter platform on the PS side implements the UDP/IP hardware protocol stack for high-speed communication over LAN or point-to-point connection.

A practical system partition is:

| **Platform Area**       | **Function**                                              |
|-------------------------|-----------------------------------------------------------|
| Programmable Logic (PL) | Camera capture, demosaic, VCP processing, frame buffering |
| Processing System (PS)  | UDP/IP stack, Ethernet control, packet scheduling         |
| Host PC                 | Receives UDP packets, decodes frames, displays video      |
| Network link            | Carries UDP packets from board to host                    |

A high-level block diagram is:

IMX477 Camera

↓

MIPI CSI-2 RX

↓

Demosaic

↓

Video Color Processing

↓

Frame Buffer / DMA

↓

PS Software Transmitter

↓

LwIP UDP Stack

↓

Gigabit Ethernet

↓

Host PC

## 18.4 Why UDP Is Used

UDP is a connectionless transport protocol. It does not provide built-in retransmission, ordering guarantee, or reliable delivery like TCP. However, its lower overhead makes it appropriate for real-time video transport where timeliness is more important than retransmitting old packets.

The source document states that LwIP supports both TCP and UDP, but UDP is used for better performance because it is connectionless and faster than TCP, making it suitable for video transmission requiring fast transport.

### 18.4.1 UDP Advantages

| **Advantage**                | **Relevance to Video Streaming**                     |
|------------------------------|------------------------------------------------------|
| Low overhead                 | More bandwidth available for video payload           |
| Low latency                  | Frames reach the host quickly                        |
| Simple transmission          | No connection management required                    |
| Suitable for frame streaming | Lost packets can be tolerated in debug/display modes |
| Easier embedded stack usage  | Works well with lightweight IP stacks                |

### 18.4.2 UDP Limitations

| **Limitation**        | **Impact**                                        |
|-----------------------|---------------------------------------------------|
| Packet loss           | Missing video payload may corrupt part of a frame |
| No retransmission     | Lost data is not automatically recovered          |
| No ordering guarantee | Receiver may need sequence numbers                |
| No congestion control | Link saturation can cause drops                   |
| Payload-size limits   | Frames must be split into packets                 |

The design should therefore include packet headers, sequence numbers, frame identifiers, and receiver-side validation where possible.

## 18.5 LwIP Ethernet Stack

The design uses **LwIP**, the Lightweight Internet Protocol stack, for embedded Ethernet communication. The source document states that UDP/IP video streaming is implemented using LwIP and notes that LwIP is useful because of portability and small code/data size, making it suitable for embedded network video transmission.

LwIP provides:

- IP addressing.

- UDP transport.

- Packet buffer management.

- Ethernet interface integration.

- Lightweight embedded networking.

- TCP support when required.

- UDP support for fast video transmission.

The source also notes that the board support package includes LwIP settings that affect Ethernet performance.

## 18.6 Network Configuration

The source configuration describes a direct connection between the Kria KV260 board and the host PC. The host PC is configured with:

Host PC IP address: 192.168.0.42

Subnet mask: 255.255.255.0

The FPGA development board default IP address is:

Board IP address: 192.168.0.10

These values are stated in the source document’s UDP configuration section.

A practical point-to-point setup is:

| **Device** | **IP Address** | **Role**              |
|------------|----------------|-----------------------|
| Kria KV260 | 192.168.0.10   | UDP video transmitter |
| Host PC    | 192.168.0.42   | UDP video receiver    |
| Subnet     | 255.255.255.0  | Local network mask    |

The source document also states that LwIP attempts to fetch an IP address from DHCP at startup, and if no DHCP server is present, it times out and defaults to 192.168.0.10.

## 18.7 Gigabit Ethernet Interface

The Kria KV260 board provides a Gigabit Ethernet interface. The source document states that the KV260 development board has **1 Gigabit Ethernet** connected through the **RGMII interface**.

A basic Ethernet path is:

PS Software

↓

LwIP UDP Stack

↓

Ethernet MAC

↓

RGMII Interface

↓

Ethernet PHY

↓

RJ45 Cable

↓

Host PC NIC

Theoretical 1 GbE throughput is 1 Gbps at the physical layer, but actual usable payload throughput is lower due to Ethernet, IP, UDP, and application overhead.

## 18.8 Video Payload Formation

A video frame is usually too large to fit into a single UDP packet. Therefore, the frame must be split into multiple UDP payloads.

A basic packet format may include:

Packet Header

Frame ID

Packet ID

Width

Height

Pixel Format

Payload Length

Payload Offset

Checksum / Flags

Payload Data

Then each packet carries a portion of the video frame:

UDP Packet 0 → Frame header + first video payload block

UDP Packet 1 → Next video payload block

UDP Packet 2 → Next video payload block

...

UDP Packet N → Final video payload block

The receiver reconstructs the frame using frame ID and packet ID.

## 18.9 Video Header Format

The source design states that when video images are received, FFmpeg invokes ffplay.exe, which decodes the first **54 bytes** as the source video type, and the document references a 54-byte video header format.

A 54-byte header is commonly associated with BMP-style image framing. A practical frame packet may therefore contain:

| **Field**              | **Purpose**                       |
|------------------------|-----------------------------------|
| Signature              | Identifies image type             |
| File size / frame size | Describes payload length          |
| Pixel offset           | Indicates where pixel data starts |
| Image width            | Frame width                       |
| Image height           | Frame height                      |
| Bits per pixel         | Pixel format                      |
| Compression field      | Indicates raw/uncompressed frame  |
| Payload data           | RGB or BGR pixel stream           |

In a streaming design, the header can be inserted once per frame before pixel payload data.

## 18.10 Frame Buffering Before Transmission

The PS-side UDP transmitter usually requires access to a complete frame or frame segments in memory. Therefore, VDMA or DMA buffering is commonly used between PL video processing and PS Ethernet transmission.

A practical memory path is:

PL Video Stream

↓

AXI VDMA / DMA

↓

DDR Frame Buffer

↓

PS Software Reads Frame Buffer

↓

UDP Packetization

↓

Ethernet Transmission

Frame buffering provides:

- Clock-domain decoupling.

- Burst access from DDR.

- Packetization flexibility.

- Software access to image data.

- Ability to repeat, skip, or throttle frames.

## 18.11 Packetization Strategy

Packetization converts a frame buffer into UDP packets.

A typical process is:

1\. Read frame metadata.

2\. Build frame header.

3\. Divide frame payload into packet-sized blocks.

4\. Attach packet header to each block.

5\. Send each block through UDP.

6\. Mark final packet of frame.

A practical UDP payload size should avoid IP fragmentation. Common payload sizes are:

| **Payload Size** | **Notes**                                 |
|------------------|-------------------------------------------|
| 512 bytes        | Conservative, simple debugging            |
| 1024 bytes       | Common embedded packet size               |
| 1400 bytes       | Fits standard Ethernet MTU with headers   |
| Jumbo payload    | Requires jumbo-frame support on both ends |

For standard Ethernet MTU, keeping UDP payload below roughly 1472 bytes avoids fragmentation.

## 18.12 Bandwidth Requirement

UDP streaming bandwidth depends on resolution, frame rate, and pixel format.

The raw video bandwidth equation is:

Bandwidth = Width × Height × BytesPerPixel × FramesPerSecond

Examples:

| **Format**          | **Bytes/Pixel** | **Frame Rate** | **Approx. Payload Bandwidth** |
|---------------------|-----------------|----------------|-------------------------------|
| 640×480 RGB888      | 3               | 30 fps         | 27.6 MB/s                     |
| 1280×720 RGB888     | 3               | 30 fps         | 82.9 MB/s                     |
| 1920×1080 RGB888    | 3               | 30 fps         | 186.6 MB/s                    |
| 1920×1080 grayscale | 1               | 30 fps         | 62.2 MB/s                     |

A 1 GbE link has a theoretical maximum of 125 MB/s before protocol overhead. Therefore, uncompressed 1080p30 RGB888 generally exceeds practical 1 GbE payload capacity, while lower resolution, lower frame rate, grayscale, compressed, or downsampled output is more practical.

## 18.13 Stream Throttling and Frame Skipping

To avoid saturating Ethernet bandwidth, the design may use frame throttling.

Options include:

| **Method**         | **Description**                       |
|--------------------|---------------------------------------|
| Lower resolution   | Transmit smaller frames               |
| Lower frame rate   | Send every Nth frame                  |
| Lower pixel depth  | Send grayscale or RGB565              |
| Region of interest | Send only selected area               |
| Compression        | Encode or compress payload before UDP |
| Packet pacing      | Add controlled delay between packets  |
| Frame skip         | Drop frames when network is busy      |

A simple frame skip control is:

if frame_count % FRAME_DIVIDER == 0:

transmit_frame

else:

skip_frame

## 18.14 UDP Receiver on Host PC

The host PC receives UDP packets and reconstructs or displays the video stream. The source document states that FFmpeg on the host PC connects to the video transmitter application and invokes ffplay.exe to decode received image data.

The host-side receiver may perform:

- UDP socket receive.

- Packet sequence checking.

- Frame buffer reconstruction.

- Header parsing.

- Pixel format conversion.

- FFmpeg/FFplay invocation.

- GUI display.

- Frame logging.

A conceptual receiver flow is:

UDP Socket Receive

↓

Validate Packet Header

↓

Group Packets by Frame ID

↓

Reconstruct Frame Buffer

↓

Decode Header / Pixel Format

↓

Display with FFplay or GUI

## 18.15 GUI Control Interface

The source design states that the GUI on the remote computer sends commands to the FPGA board IP address 192.168.0.10 and receives image data from the board.

A GUI may support:

| **Feature**       | **Description**                               |
|-------------------|-----------------------------------------------|
| Start stream      | Enables UDP video transmission                |
| Stop stream       | Stops network output                          |
| Select resolution | Chooses output frame size                     |
| Select filter     | Commands VCP mode                             |
| Set threshold     | Updates segmentation or Sobel threshold       |
| Select palette    | Updates K-means or color-scheme palette       |
| Capture frame     | Saves one received image                      |
| Display status    | Shows frame count, packet loss, and bandwidth |

Control commands can be sent using UDP, TCP, or a separate AXI/UART/software command path.

## 18.16 Packet Header Recommendation

A custom UDP video packet header improves reliability and debugging.

Recommended fields:

| **Field**      | **Width**     | **Description**                 |
|----------------|---------------|---------------------------------|
| Magic word     | 32 bits       | Identifies valid video packet   |
| Frame ID       | 32 bits       | Increments every frame          |
| Packet ID      | 16 or 32 bits | Packet number within frame      |
| Total packets  | 16 or 32 bits | Expected packets per frame      |
| Payload offset | 32 bits       | Byte offset inside frame        |
| Payload length | 16 bits       | Number of payload bytes         |
| Width          | 16 bits       | Frame width                     |
| Height         | 16 bits       | Frame height                    |
| Pixel format   | 16 bits       | RGB888, RGB565, grayscale, etc. |
| Flags          | 16 bits       | Start/end frame indicators      |

This allows the receiver to detect missing, duplicate, or out-of-order packets.

## 18.17 Packet Loss Handling

UDP does not automatically recover lost packets. The receiver should detect missing packets and handle them safely.

Packet loss strategies include:

| **Strategy**           | **Description**                                   |
|------------------------|---------------------------------------------------|
| Drop incomplete frame  | Simplest and safest                               |
| Fill missing payload   | Replace missing block with black or previous data |
| Display partial frame  | Useful for debugging but may show artifacts       |
| Request retransmission | Requires custom control protocol                  |
| Use frame counter      | Detect skipped or incomplete frames               |

For real-time display, dropping incomplete frames is often preferable to displaying corrupted frames.

## 18.18 Latency Considerations

UDP streaming latency includes:

| **Latency Source**    | **Description**                 |
|-----------------------|---------------------------------|
| Frame buffering       | Time to capture or store frame  |
| DDR access            | Time to read frame data         |
| Packetization         | Time to build UDP packets       |
| LwIP stack            | Software/network-stack overhead |
| Ethernet transmission | Packet transmission time        |
| Host receive buffer   | OS socket buffering             |
| Decoder/display       | FFmpeg or GUI rendering time    |

To reduce latency:

- Use smaller frames.

- Avoid full-frame buffering where possible.

- Use packet streaming as lines become available.

- Use low-overhead pixel formats.

- Reduce socket buffering.

- Use direct LAN point-to-point connection.

## 18.19 PS–PL Data Transfer

The video stream originates in PL but is transmitted through PS Ethernet software. Therefore, a reliable PS–PL data transfer mechanism is required.

Common approaches:

| **Method**        | **Description**                           |
|-------------------|-------------------------------------------|
| AXI VDMA          | Streams video frames into DDR             |
| AXI DMA           | Transfers frame blocks or line blocks     |
| Shared DDR buffer | PS reads completed frames from memory     |
| Interrupts        | PL signals frame ready to PS              |
| Polling           | PS checks frame-ready status registers    |
| Cache management  | Required when PS reads DMA-written memory |

A robust design should include:

PL writes frame buffer

↓

PL sets frame-ready flag or interrupt

↓

PS invalidates cache if required

↓

PS reads frame buffer

↓

PS sends UDP packets

↓

PS clears frame-ready flag

## 18.20 Register-Level Control

A representative UDP streaming register/control interface may include:

| **Register / Parameter** | **Function**                           |
|--------------------------|----------------------------------------|
| UDP_STREAM_ENABLE        | Enables video transmission             |
| UDP_FRAME_WIDTH          | Output frame width                     |
| UDP_FRAME_HEIGHT         | Output frame height                    |
| UDP_PIXEL_FORMAT         | RGB888, RGB565, grayscale, BMP, etc.   |
| UDP_FRAME_STRIDE         | Bytes per frame line                   |
| UDP_FRAME_BUFFER_ADDR    | DDR address of frame buffer            |
| UDP_FRAME_READY          | Indicates new frame available          |
| UDP_FRAME_DONE           | Indicates PS completed transmission    |
| UDP_FRAME_DIVIDER        | Sends every Nth frame                  |
| UDP_STATUS               | Active state and error flags           |
| UDP_PACKET_COUNT         | Packets sent per frame                 |
| UDP_ERROR_STATUS         | Frame drop, buffer error, packet error |

These controls help coordinate PL frame generation and PS UDP transmission.

## 18.21 Performance Monitoring

The design should monitor network and video performance.

Recommended counters:

| **Counter**          | **Purpose**                           |
|----------------------|---------------------------------------|
| Frames captured      | Confirms PL video input is active     |
| Frames transmitted   | Confirms PS streaming is active       |
| Frames dropped       | Identifies bandwidth or timing limits |
| Packets sent         | Tracks network output                 |
| Bytes sent           | Measures bandwidth                    |
| Packet errors        | Detects socket or buffer failures     |
| UDP send failures    | Detects network stack issues          |
| Frame-ready overruns | Detects PS falling behind PL          |

These counters are useful during bring-up and performance tuning.

## 18.22 Verification Strategy

### 18.22.1 Network Configuration Tests

Verify:

- Host PC IP address is correct.

- Board IP address is reachable.

- Ping works when enabled.

- Subnet mask is correct.

- Ethernet cable and link are active.

- DHCP fallback address is correct.

### 18.22.2 Packet Tests

Verify:

- UDP packets are transmitted.

- Packet payload length is correct.

- Frame ID increments correctly.

- Packet ID increments correctly.

- Final-packet flag is correct.

- No unexpected packet fragmentation occurs.

### 18.22.3 Image Reconstruction Tests

Use known test frames:

| **Test Frame** | **Purpose**                            |
|----------------|----------------------------------------|
| Solid color    | Checks payload fill and frame size     |
| Color bars     | Checks RGB/BGR ordering                |
| Checkerboard   | Checks line stride and packet ordering |
| Ramp image     | Checks byte order and pixel order      |
| VCP output     | Confirms processed image is streamed   |

### 18.22.4 Host Display Tests

Verify:

- FFplay launches correctly.

- Header is decoded correctly.

- Frame dimensions match.

- Pixel format matches.

- Video updates at expected frame rate.

- No severe tearing or color channel swap.

## 18.23 Common Failure Modes

| **Failure Mode**     | **Likely Cause**                         | **Correction**                                   |
|----------------------|------------------------------------------|--------------------------------------------------|
| No packets received  | Wrong IP, firewall, cable, or port       | Verify network settings and host firewall        |
| Board not reachable  | DHCP/default IP mismatch                 | Use default 192.168.0.10 or correct DHCP address |
| Wrong image colors   | RGB/BGR mismatch                         | Swap channel order or correct header format      |
| Image shifted        | Incorrect stride or packet offset        | Verify line size and payload offset              |
| Incomplete frames    | Packet loss or bandwidth saturation      | Reduce frame size/rate or add packet checks      |
| FFplay cannot decode | Incorrect 54-byte header or pixel format | Verify header fields                             |
| High latency         | Full-frame buffering or host buffering   | Reduce buffer size and frame resolution          |
| Dropped frames       | PS cannot transmit fast enough           | Use lower frame rate or optimize LwIP settings   |

## 18.24 Hardware and Software Design Recommendations

1.  **Use UDP for low-latency video transmission.**  
    It is appropriate for fast video transport where occasional packet loss is acceptable.

2.  **Use packet headers with frame and packet counters.**  
    This makes packet loss and ordering issues detectable.

3.  **Avoid IP fragmentation.**  
    Keep UDP payload sizes within the Ethernet MTU unless jumbo frames are explicitly supported.

4.  **Use frame throttling for high-resolution streams.**  
    1 GbE cannot practically carry all uncompressed high-resolution RGB modes.

5.  **Provide GUI and command control.**  
    Host software should start/stop streaming and control VCP modes.

6.  **Use frame-ready synchronization between PL and PS.**  
    Prevent PS from reading incomplete frames.

7.  **Monitor packet and frame counters.**  
    Diagnostics are essential for network bring-up.

8.  **Validate with simple test patterns first.**  
    Use solid colors and color bars before streaming live camera output.

## 18.25 Chapter Summary

This chapter described Ethernet UDP Video Streaming for the FPGA Video Color Processing System. The design uses the Kria KV260 board, a PS-side UDP/IP stack, LwIP networking, and a host PC receiver to transmit processed video frames over Ethernet.

The source document describes a system with receiver and transmitter platforms, where the PL receives the camera stream and the PS implements the UDP/IP stack for high-speed LAN or point-to-point communication. It also states that LwIP is used for embedded UDP/IP video streaming and that UDP is selected for performance because it is connectionless and suitable for fast video transmission.

A reliable UDP video-streaming implementation requires frame buffering, packetization, header formatting, network configuration, host-side reconstruction, bandwidth management, packet-loss handling, PS–PL synchronization, and diagnostic counters. This makes Ethernet UDP streaming a practical output and validation path for real-time FPGA video processing.
