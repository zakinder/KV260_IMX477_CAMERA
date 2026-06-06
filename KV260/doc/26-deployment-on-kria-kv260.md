# Chapter 26 — Deployment on Kria KV260

## 26.1 Overview

Deployment on the **Kria KV260** converts the verified FPGA Video Color Processing System into an operational hardware/software platform. The deployed system must load the FPGA bitstream, initialize the Processing System, configure the MIPI camera input, start video capture, enable the VCP pipeline, route output to DisplayPort or Ethernet, and provide runtime software control.

The source design is explicitly based on a Raspberry Pi camera link running on the **Kria KV260** board. It captures RGB video data through a MIPI interface, processes the stream as AXI4-Stream video, and outputs video to Ethernet or DisplayPort.

A deployment-level flow is:

Build Hardware Platform

↓

Generate Bitstream

↓

Export Hardware to Vitis

↓

Build Software Application

↓

Prepare Boot / Runtime Files

↓

Program Kria KV260

↓

Initialize Camera and Video Pipeline

↓

Validate DisplayPort / Ethernet Output

Deployment is complete only when the live camera stream is visible, stable, controllable, and measurable on the target board.

## 26.2 Kria KV260 Deployment Objectives

The deployment process must satisfy the following objectives:

| **Objective**          | **Description**                                                           |
|------------------------|---------------------------------------------------------------------------|
| Program FPGA logic     | Load the implemented VCP bitstream into programmable logic.               |
| Initialize PS software | Run the control application on the Processing System.                     |
| Configure sensor       | Program camera registers and start streaming.                             |
| Start MIPI receiver    | Enable CSI-2 capture and verify link activity.                            |
| Start demosaic         | Convert RAW Bayer input into RGB video.                                   |
| Enable VCP             | Apply selected filters, color conversions, K-means, histogram, or bypass. |
| Configure VDMA         | Move video frames between stream and DDR if required.                     |
| Enable output          | Route video to DisplayPort, Ethernet UDP, or both.                        |
| Provide control        | Allow software or GUI commands to modify runtime behavior.                |
| Validate stability     | Confirm frame rate, no drops, no underruns, and correct color output.     |

The deployment goal is not only to load a bitstream but to establish a repeatable live-video operating procedure.

## 26.3 Hardware Platform Architecture

The deployed platform is divided between the **Programmable Logic (PL)** and the **Processing System (PS)**.

Programmable Logic

Camera RX

Demosaic

VCP pipeline

AXI4-Stream routing

VDMA stream interfaces

Debug counters

Processing System

Boot software

Sensor configuration

AXI4-Lite control

VDMA setup

DisplayPort control

Ethernet UDP / LwIP transmission

The source document describes the VCP as a module with control registers and local buffers that takes input video pixels, performs computation or content generation through filters, and outputs a processed pixel stream.

## 26.4 Deployment Build Artifacts

A complete deployment package should contain all required files to reproduce the board run.

| **Artifact**          | **Purpose**                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| .bit                  | FPGA programmable logic bitstream                                           |
| .xsa                  | Exported hardware platform for Vitis                                        |
| .elf                  | PS software application                                                     |
| .bif                  | Boot image format description if boot image is created                      |
| BOOT.BIN              | Bootable image containing FSBL, bitstream, and application where applicable |
| image.ub              | Linux image if deploying through Linux/PetaLinux                            |
| Device tree           | Hardware description for Linux-based deployment                             |
| Register map header   | Software definitions for AXI4-Lite offsets                                  |
| Sensor register table | I2C initialization data                                                     |
| Validation script     | Runtime checks and status readback                                          |
| README                | Deployment procedure and expected output                                    |

For bare-metal deployment, the focus is normally FSBL, bitstream, and application ELF. For Linux deployment, the focus also includes device tree, kernel image, root filesystem, and application startup scripts.

## 26.5 Vivado Hardware Export

The deployment process begins after implementation timing has closed. The hardware must be exported so software can access address maps, interrupts, clocks, and peripheral definitions.

Recommended Vivado export steps:

1\. Open implemented design.

2\. Confirm timing closure.

3\. Generate bitstream.

4\. Export hardware platform.

5\. Include bitstream in exported hardware.

6\. Create XSA file.

7\. Import XSA into Vitis.

The source design uses Vivado for synthesis and implementation on the KV260 platform, with a documented module implemented using Vivado 2022.1.

## 26.6 PS–PL Configuration

The Processing System must be configured to communicate with the programmable logic. The source Vivado configuration includes PS–PL interfaces such as HPM and HPC ports with 128-bit data width. It also includes DisplayPort lane/reference settings and MIPI CSI-2 subsystem configuration.

Important PS–PL configuration items include:

| **Configuration Area** | **Deployment Requirement**                       |
|------------------------|--------------------------------------------------|
| AXI HPM                | Allows PS to access PL control registers         |
| AXI HP/HPC             | Supports high-bandwidth memory movement          |
| Interrupts             | Allows PL to notify PS of frame events or errors |
| Clocks                 | Provides required PL clock sources               |
| Reset control          | Ensures PL modules reset cleanly                 |
| DisplayPort            | Enables PS-controlled display output             |
| Ethernet               | Enables PS-side UDP streaming                    |
| MIPI CSI-2             | Enables camera capture path                      |

The address map generated by Vivado must match the software register definitions used by the Vitis application.

## 26.7 Vitis Software Structure

The source document states that the Vitis program design is divided into **video initialization**, **configuration**, **control**, and **transmission**, and that the software structure presents the program and data flow.

A practical deployed application structure is:

int main(void)

{

platform_init();

video_init();

sensor_config();

mipi_rx_config();

demosaic_config();

vdma_config();

vcp_config();

output_config();

start_video_stream();

while (1) {

poll_status();

process_commands();

update_vcp_registers();

handle_errors();

}

return 0;

}

The software should be modular so that camera, VDMA, VCP, DisplayPort, and Ethernet paths can be tested independently.

## 26.8 Video Initialization

Video initialization prepares all video-related hardware blocks before live streaming begins.

Recommended initialization order:

1\. Initialize platform and caches.

2\. Initialize AXI drivers.

3\. Reset PL video blocks.

4\. Configure sensor clocks and I2C.

5\. Configure MIPI CSI-2 receiver.

6\. Configure demosaic.

7\. Configure VDMA frame buffers.

8\. Configure VCP control registers.

9\. Configure output path.

10\. Release stream reset.

11\. Enable camera streaming.

Starting the camera before the receiver, demosaic, or VDMA are ready can cause corrupted first frames or stuck status flags.

## 26.9 Camera Deployment

The camera module must be physically connected and logically configured.

The source document describes the IMX477 camera module connected to the KV260 through an FPC flexible cable, with camera pixel data transferred over a dual-lane MIPI CSI-2 interface through a 15-pin flat flexible cable.

Deployment checks:

| **Check**                | **Expected Result**                  |
|--------------------------|--------------------------------------|
| Cable inserted correctly | No reversed or loose connection      |
| Sensor power enabled     | Camera responds on I2C               |
| Sensor ID readable       | Correct sensor detected              |
| Register table loaded    | Sensor mode configured               |
| MIPI lane count correct  | Receiver matches sensor output       |
| RAW format correct       | RAW10/RAW12 setting matches receiver |
| Stream enabled           | Sensor starts frame output           |
| MIPI receiver locked     | CSI-2 status indicates valid link    |

A failed sensor ID read should be debugged before any video-pipeline debugging.

## 26.10 MIPI CSI-2 Receiver Deployment

The MIPI receiver must match the sensor output configuration. The source design lists MIPI CSI-2 settings that include RAW10 format, serial data lanes, line rate, line-buffer depth of 4096, pixel-per-clock of 1, TUSER width of 1, and CRC enabled.

Deployment parameters include:

| **Parameter**     | **Deployment Meaning**                  |
|-------------------|-----------------------------------------|
| Pixel format      | RAW10, RAW12, or selected sensor output |
| Lane count        | 2-lane or 4-lane mode                   |
| Lane rate         | Must match sensor mode                  |
| Virtual channel   | Must match sensor packet VC             |
| Line buffer depth | Must support selected width             |
| Pixel per clock   | Determines internal stream width        |
| CRC               | Detects packet corruption               |
| TUSER width       | Provides frame-start sideband           |

If the MIPI receiver is misconfigured, symptoms include no frame, corrupted image, CRC errors, wrong line size, or unstable video.

## 26.11 Demosaic and RGB Conversion

After MIPI reception, RAW Bayer video must be converted to RGB. The source design states that the demosaic module converts Bayer-pattern input frame data to RGB color frames.

Deployment checks:

| **Check**                 | **Expected Result**                 |
|---------------------------|-------------------------------------|
| Demosaic reset released   | Output stream becomes active        |
| Bayer phase correct       | Natural colors                      |
| Bit depth correct         | Brightness appears correct          |
| Output RGB format correct | VCP receives expected channel order |
| TUSER and TLAST aligned   | Frame/line boundaries correct       |
| No dropped valid cycles   | Stable frame output                 |

Wrong Bayer phase is a common deployment failure and appears as green, purple, or red/blue inverted output.

## 26.12 VDMA Deployment

VDMA moves frames between AXI4-Stream and DDR memory. The source document states that VDMA converts demosaic video stream data to AXI4 memory-mapped format and performs DDR fetching/decoding/execution through the AXI_HP interface. It also describes VDMA as a video/image DMA with AXI4 memory-mapped read and write channels.

The source also states that in the main function, a one-frame buffer is initialized for VDMA1 using VIDEO1_MAX_FRAME = 1, with pFrame0 pointing to the cache of camera 1.

Deployment configuration should define:

| **Item**                  | **Description**                     |
|---------------------------|-------------------------------------|
| Frame buffer base address | DDR address for video frame         |
| Frame width               | Active pixels per line              |
| Frame height              | Active lines per frame              |
| Stride                    | Bytes per line                      |
| Pixel format              | RGB888, RGB565, RGB30, etc.         |
| Number of buffers         | Single, double, or triple buffering |
| Write channel             | Stream-to-memory path               |
| Read channel              | Memory-to-stream path               |
| Interrupts                | Frame complete and error handling   |

Incorrect stride or buffer size can cause tearing, shifted rows, or VDMA errors.

## 26.13 VCP Deployment

The VCP block is controlled through AXI4-Lite registers. Deployment software must configure the correct mode, threshold, coefficients, palette, and output channel before enabling active video processing.

Recommended VCP startup sequence:

1\. Put VCP in bypass mode.

2\. Clear status and error flags.

3\. Program default thresholds.

4\. Program identity color matrix.

5\. Program default kernel coefficients.

6\. Program default palette if K-means is enabled.

7\. Enable frame-safe update.

8\. Start video.

9\. Switch from bypass to selected processing mode.

10\. Read back active status.

Initial deployment should start with RGB bypass. More complex functions should be enabled one at a time after the base video path is stable.

## 26.14 DisplayPort Output Deployment

The source design states that DisplayPort sources live input video data from PL and that the PS DisplayPort controller is coupled to the STDP4320 demultiplexer on the carrier board for DP/HDMI output.

DisplayPort deployment requires:

| **Check**         | **Requirement**                       |
|-------------------|---------------------------------------|
| Output clock      | Correct pixel clock for resolution    |
| Frame timing      | Correct width, height, sync, blanking |
| Pixel format      | Compatible with display controller    |
| Frame buffer      | Valid DDR buffer address              |
| VDMA read channel | Active and not underflowing           |
| Display link      | Monitor connected and detected        |
| Color order       | RGB channel mapping correct           |

Display output should first be tested with a generated test pattern before live camera input.

## 26.15 Ethernet UDP Deployment

The source UDP design uses the Kria KV260 board for real-time UDP video streaming. It identifies a direct board-to-PC configuration where the host PC uses IP address 192.168.0.42, subnet mask 255.255.255.0, and the FPGA board default IP address is 192.168.0.10.

Deployment network setup:

| **Device**  | **IP Address** | **Role**        |
|-------------|----------------|-----------------|
| Kria KV260  | 192.168.0.10   | UDP transmitter |
| Host PC     | 192.168.0.42   | UDP receiver    |
| Subnet mask | 255.255.255.0  | Local network   |

The source also states that the KV260 has 1 Gigabit Ethernet connected through RGMII.

UDP deployment checks:

- Ethernet link is up.

- Board IP is correct.

- Host firewall allows UDP.

- Receiver port matches transmitter.

- Payload size avoids fragmentation.

- Frame header matches host decoder.

- FFplay or GUI receives frames.

- Packet counters increment.

- Dropped packet counter remains acceptable.

## 26.16 Host PC Receiver Deployment

The host PC receives video frames through UDP or a GUI application. The source design states that FFmpeg/ffplay.exe decodes received BMP images into a video stream at the specified frame rate.

Host deployment tasks:

1\. Configure static IP address.

2\. Disable or configure firewall for UDP port.

3\. Start receiver application or FFplay flow.

4\. Confirm packets arrive.

5\. Confirm frame header parses.

6\. Confirm image dimensions and format.

7\. Verify color order and frame rate.

A host receiver should report:

- Frames received.

- Packets received.

- Missing packets.

- Payload bytes per frame.

- Frame ID.

- Packet ID.

- Measured FPS.

- Decode errors.

## 26.17 Bare-Metal Deployment Option

Bare-metal deployment is useful for low-level bring-up and deterministic control.

Typical bare-metal flow:

FSBL

↓

Configure PL bitstream

↓

Run Vitis application ELF

↓

Initialize camera, VDMA, VCP, output

↓

Loop on status and control

Advantages:

| **Advantage**          | **Description**                  |
|------------------------|----------------------------------|
| Simpler timing         | No Linux scheduling effects      |
| Direct register access | Easier low-level debug           |
| Deterministic startup  | Predictable initialization order |
| Smaller software stack | Useful for first bring-up        |

Limitations:

| **Limitation**              | **Description**                      |
|-----------------------------|--------------------------------------|
| Less flexible runtime       | Harder to integrate high-level tools |
| Manual driver work          | More peripheral setup code           |
| Limited networking features | More custom LwIP integration         |

Bare-metal is recommended for first bring-up of the PL video path.

## 26.18 Linux / PetaLinux Deployment Option

Linux deployment is useful for advanced networking, file handling, scripting, and application-level control.

Typical Linux flow:

Boot Linux

↓

Load bitstream or boot with bitstream

↓

Bind drivers / device tree

↓

Run camera/VCP application

↓

Stream video through UDP or display

Advantages:

| **Advantage**              | **Description**                                   |
|----------------------------|---------------------------------------------------|
| Better application support | Easier GUI, network, file, and process management |
| Scriptable control         | Runtime commands and automation                   |
| Standard networking        | Easier UDP/TCP tools                              |
| Debug access               | SSH, logs, utilities                              |

Limitations:

| **Limitation**                | **Description**                     |
|-------------------------------|-------------------------------------|
| More boot complexity          | Device tree and driver dependencies |
| Cache coherency requirements  | Important with DMA buffers          |
| Less deterministic scheduling | Real-time behavior may need tuning  |
| More integration points       | More possible failure causes        |

Linux deployment should be used after the hardware path is stable.

## 26.19 Runtime Control Flow

Runtime control updates VCP behavior while video is active.

Example runtime flow:

User selects filter mode

↓

Software writes shadow registers

↓

Software sets update request

↓

Hardware waits for safe frame boundary

↓

VCP applies new configuration

↓

Software reads update-done status

Runtime controls may include:

| **Control**      | **Example**                    |
|------------------|--------------------------------|
| Filter selection | Sharp, blur, emboss, Sobel     |
| Color conversion | RGB/HSL/HSV/YCbCr              |
| Threshold        | Sobel or local segmentation    |
| Color matrix     | CCM coefficient update         |
| K-means palette  | Select K or palette bank       |
| Histogram        | Enable and read bin data       |
| Output mode      | DisplayPort, UDP, test pattern |

Frame-safe update prevents mid-frame artifacts.

## 26.20 Board Bring-Up Checklist

Use this checklist when deploying the design on the KV260.

| **Step** | **Check**               | **Expected Result**            |
|----------|-------------------------|--------------------------------|
| 1        | Power board             | Board boots or is programmable |
| 2        | Connect JTAG/UART       | Console/debug access available |
| 3        | Program bitstream       | PL configuration succeeds      |
| 4        | Read ID/status register | VCP responds                   |
| 5        | Confirm clocks          | Video clocks active            |
| 6        | Release resets          | Status shows not-in-reset      |
| 7        | Configure camera        | I2C writes succeed             |
| 8        | Check MIPI lock         | Receiver reports active stream |
| 9        | Start demosaic          | RGB stream valid               |
| 10       | Start bypass mode       | Output image visible           |
| 11       | Enable VDMA             | Frame buffer active            |
| 12       | Enable DisplayPort      | Monitor shows frame            |
| 13       | Enable UDP              | Host receives frames           |
| 14       | Enable VCP mode         | Processing effect visible      |
| 15       | Check counters          | No overflow/underflow          |

## 26.21 Deployment Validation Tests

Recommended validation tests:

| **Test**            | **Purpose**                                |
|---------------------|--------------------------------------------|
| Register readback   | Confirms AXI4-Lite and address map         |
| Test pattern output | Confirms output path independent of camera |
| Camera bypass       | Confirms sensor-to-display path            |
| Color bars          | Confirms RGB order                         |
| Sobel mode          | Confirms spatial filter operation          |
| HSL/HSV mode        | Confirms color-space processing            |
| CCM identity        | Confirms no unintended color shift         |
| K-means palette     | Confirms palette and clustering logic      |
| Histogram readout   | Confirms measurement path                  |
| UDP 720p stream     | Confirms network output                    |
| Long-run test       | Confirms stability over time               |

A deployed design should pass these tests before being considered stable.

## 26.22 Runtime Diagnostic Counters

Deployment should expose software-readable diagnostic counters.

| **Counter**          | **Purpose**                |
|----------------------|----------------------------|
| frame_in_count       | Frames entering VCP        |
| frame_out_count      | Frames leaving VCP         |
| line_count           | Lines per frame            |
| pixel_count          | Pixels per line/frame      |
| mipi_error_count     | CSI-2 errors               |
| vdma_error_count     | DMA errors                 |
| fifo_overflow_count  | Buffer overflow            |
| fifo_underflow_count | Buffer underflow           |
| udp_packet_count     | Packets transmitted        |
| udp_drop_count       | Dropped network frames     |
| mode_update_count    | Runtime mode changes       |
| last_error_code      | Debug error classification |

These counters simplify board-level debugging and field validation.

## 26.23 Deployment Failure Modes

| **Failure**                  | **Likely Cause**                                             | **Correction**                                |
|------------------------------|--------------------------------------------------------------|-----------------------------------------------|
| Board boots but no video     | VCP disabled, camera not streaming, or output not configured | Start with test pattern and bypass            |
| VCP registers unreadable     | Wrong base address or AXI interconnect issue                 | Verify Vivado address map and software header |
| Camera not detected          | I2C address, cable, reset, or power issue                    | Check sensor ID and physical connection       |
| MIPI receiver not locked     | Lane count, lane rate, or format mismatch                    | Match sensor and CSI-2 settings               |
| Image has wrong colors       | Bayer phase or RGB/BGR mismatch                              | Use color bars and Bayer-phase correction     |
| Display output unstable      | Pixel clock or timing mismatch                               | Verify output timing and VDMA stride          |
| UDP receives no packets      | IP, firewall, cable, or socket issue                         | Verify network settings                       |
| UDP image corrupt            | Header, payload, stride, or packet loss                      | Validate frame format and packet sequence     |
| VDMA underflow               | DDR bandwidth, bad stride, or buffer issue                   | Verify VDMA configuration                     |
| Runtime mode change flickers | Active registers updated mid-frame                           | Use frame-safe shadow update                  |

## 26.24 Deployment Documentation Package

A complete deployment package should include:

| **Document**          | **Content**                                      |
|-----------------------|--------------------------------------------------|
| Board setup guide     | Cable, power, boot mode, UART, Ethernet, display |
| Build guide           | Vivado/Vitis project build steps                 |
| Register guide        | Base addresses, offsets, bit fields              |
| Sensor guide          | I2C register table and camera setup              |
| Runtime guide         | Commands for selecting modes                     |
| Network guide         | IP settings, UDP ports, receiver commands        |
| Validation guide      | Tests and expected results                       |
| Troubleshooting guide | Common failures and fixes                        |
| Release notes         | Version, limitations, known issues               |

This documentation makes deployment repeatable by another engineer.

## 26.25 Recommended Deployment Sequence

For a clean deployment, use this sequence:

1\. Deploy bitstream with all outputs disabled.

2\. Verify AXI4-Lite register readback.

3\. Enable internal test pattern.

4\. Verify DisplayPort output.

5\. Configure camera sensor.

6\. Verify MIPI and demosaic output.

7\. Enable RGB bypass through VCP.

8\. Enable one VCP feature at a time.

9\. Enable VDMA buffering if required.

10\. Enable UDP streaming at reduced resolution.

11\. Increase resolution or frame rate gradually.

12\. Run long-duration stability test.

This prevents multiple unknowns from being debugged at once.

## 26.26 Security and Safety Considerations

Deployment should prevent unsafe runtime states.

Recommended safeguards:

| **Safeguard**              | **Purpose**                                 |
|----------------------------|---------------------------------------------|
| Default bypass mode        | Provides safe output at startup             |
| Register access validation | Prevents invalid mode selection             |
| Frame-safe updates         | Prevents visible tearing or partial updates |
| Watchdog status            | Detects stalled pipeline                    |
| Error flags                | Reports overflow, underflow, or link errors |
| Safe fallback mode         | Returns to bypass or test pattern           |
| Network rate limit         | Prevents host/network overload              |
| Configuration checksum     | Confirms sensor/register table integrity    |

These safeguards improve system reliability during demonstrations and long-run tests.

## 26.27 Chapter Summary

This chapter described deployment of the FPGA Video Color Processing System on the Kria KV260. Deployment includes Vivado hardware export, Vitis software development, bitstream programming, sensor configuration, MIPI CSI-2 bring-up, demosaic activation, VDMA setup, VCP register configuration, DisplayPort output, Ethernet UDP streaming, and host-side validation.

The source design confirms that the KV260 system captures MIPI camera video, processes it into AXI4-Stream, and outputs through Ethernet or DisplayPort. It also describes a Vitis software structure divided into video initialization, configuration, control, and transmission, with VDMA frame-buffer initialization in the main function.

A reliable deployment should start with register readback and test patterns, then progress through camera input, demosaic, bypass video, VCP processing modes, DisplayPort output, UDP streaming, and long-run stability validation. This structured approach converts the verified FPGA design into a repeatable real-time video-processing system on the target hardware platform.
