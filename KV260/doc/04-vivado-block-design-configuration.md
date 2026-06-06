# Chapter 4 — Vivado Block Design Configuration

## 4.1 Overview of the Vivado Block Design

The Vivado block design defines the hardware integration structure for the FPGA Video Color Processing System. It connects the processing system, programmable logic, camera input subsystem, video-processing modules, memory interfaces, and output interfaces into one hardware platform.

The design is built around the AMD Zynq UltraScale+ MPSoC architecture used on the Kria KV260 platform. The MPSoC provides both the **Processing System (PS)** and **Programmable Logic (PL)**. The PS manages software control, register access, and platform initialization, while the PL performs real-time video capture and processing.

The Vivado block design includes the following major functional groups:

1.  Zynq UltraScale+ MPSoC configuration.

2.  PS–PL AXI interface configuration.

3.  MIPI CSI-2 receiver subsystem.

4.  MIPI D-PHY camera interface.

5.  Clock generation and distribution.

6.  AXI4-Stream video datapath.

7.  AXI4-Lite control path.

8.  Video Color Processing module integration.

9.  DisplayPort and Ethernet output support.

10. VDMA and memory interface support where required.

The original design configuration identifies Zynq UltraScale+ MPSoC settings, MIPI CSI-2 receiver settings, clocking, DisplayPort settings, and PS–PL interface selections as part of the Vivado configuration flow.

## 4.2 Zynq UltraScale+ MPSoC Configuration

The Zynq UltraScale+ MPSoC block is the central control and interconnect component in the Vivado design. It provides the embedded processing subsystem and exposes AXI interfaces that allow software running on the processing system to communicate with hardware blocks in the programmable logic.

The MPSoC configuration supports:

- Software-controlled hardware initialization.

- AXI4-Lite access to video-processing registers.

- AXI memory-mapped access to video buffers.

- DisplayPort output control.

- Clock and reset distribution.

- Interrupt and status monitoring.

- PS-to-PL and PL-to-PS communication.

The processing system is configured to expose high-performance AXI interfaces for communication between software, memory, and programmable logic.

## 4.3 I/O Configuration

The I/O configuration assigns physical and logical MPSoC I/O resources required by the design. In the referenced configuration, the DisplayPort auxiliary interface uses MIO pins 27 through 30.

### 4.3.1 DisplayPort Auxiliary Interface

The DisplayPort auxiliary channel is used for DisplayPort link management and communication with the connected display device. It supports display detection, capability discovery, and link configuration.

The relevant configuration item is:

| **Interface** | **Configuration** |
|---------------|-------------------|
| DPAUX         | MIO 27 to MIO 30  |

This configuration allows the PS-side DisplayPort controller to communicate with the external display over the auxiliary channel.

### 4.3.2 DisplayPort Lane Selection

The design configuration identifies the DisplayPort lane selection as **Dual Lower**.

This setting defines which DisplayPort physical lanes are used by the platform. Correct lane selection is required for proper display output operation.

## 4.4 Clock Configuration

Clock configuration is critical in a real-time video design because each subsystem must operate at a frequency that supports the selected video format. The design uses clocks for the processing system, programmable logic, MIPI input, video processing, and output timing.

The referenced MPSoC configuration sets the PL fabric output clock **PL0** to **100 MHz** and the DisplayPort reference frequency to **27 MHz**.

### 4.4.1 Primary Clock Sources

The design uses the following clocking concept:

| **Clock**   | **Purpose**                                  |
|-------------|----------------------------------------------|
| PL0 100 MHz | Base programmable logic fabric clock         |
| 300 MHz     | Video AXI configuration and processing clock |
| 200 MHz     | MIPI D-PHY video input clock                 |
| 297 MHz     | Video output clock                           |
| 27 MHz      | DisplayPort reference clock                  |

The document states that the output clock from the Zynq UltraScale+ MPSoC is set to **100 MHz**, and this clock is fed into a clock generator that creates the additional clocks used inside the programmable logic. The listed generated clocks are **300 MHz**, **297 MHz**, and **200 MHz**.

### 4.4.2 Clock Generator Role

The clock generator produces subsystem-specific clocks from the base PL clock. Its responsibilities include:

- Generating video-processing clocks.

- Generating MIPI input support clocks.

- Generating video output clocks.

- Maintaining phase and frequency stability.

- Providing locked status to reset-control logic.

A stable clocking architecture is required before camera streaming, VCP processing, or display output can operate reliably.

## 4.5 PS–PL Interface Configuration

The PS–PL interface configuration defines how the processing system communicates with programmable logic. These interfaces are essential for software control, register programming, memory access, and video-buffer movement.

The referenced configuration enables the following PS–PL interfaces:

| **Interface** | **Direction / Role**                   | **Data Width** |
|---------------|----------------------------------------|----------------|
| AXI HPM0 FPD  | PS master to PL peripherals            | 128-bit        |
| AXI HPM1 FPD  | PS master to PL peripherals            | 128-bit        |
| AXI HPC0 FPD  | PL/PS high-performance coherent access | 128-bit        |

The design document lists AXI HPM0 FPD, AXI HPM1 FPD, and AXI HPC0 FPD interfaces as selected, each with a 128-bit data width.

### 4.5.1 AXI HPM Interfaces

The AXI HPM interfaces allow the processing system to act as an AXI master and access control registers in the programmable logic.

Typical HPM usage includes:

- Writing VCP control registers.

- Selecting filter modes.

- Updating color-processing parameters.

- Enabling or disabling video blocks.

- Reading status registers.

- Reading diagnostic counters.

### 4.5.2 AXI HPC Interface

The AXI HPC interface supports high-performance data movement between programmable logic and the processing system memory subsystem. It can be used for video frame buffering, VDMA operation, or memory-backed stream processing.

Typical HPC usage includes:

- Frame-buffer access.

- VDMA traffic.

- PL-to-DDR video movement.

- High-bandwidth memory transactions.

- Shared buffer access between hardware and software.

## 4.6 MIPI CSI-2 RX Subsystem Configuration

The MIPI CSI-2 RX subsystem receives serialized camera data from the image sensor and converts it into an internal video stream. The system uses two receiver configurations: one for a 2-lane camera path and one for a 4-lane camera path.

The source design lists two MIPI CSI-2 RX subsystem configurations. The first uses RAW10 format, 2 serial data lanes, 2500 Mbps line rate, one pixel per clock, TUSER width of 1, and CRC enabled. The second uses RAW10 format, 4 serial data lanes, 2000 Mbps line rate, one pixel per clock, TUSER width of 1, and CRC enabled.

### 4.6.1 MIPI CSI-2 RX Subsystem 1

| **Parameter**                       | **Setting** |
|-------------------------------------|-------------|
| Pixel format                        | RAW10       |
| Serial data lanes                   | 2           |
| Line rate                           | 2500 Mbps   |
| CSI-2 controller register interface | Enabled     |
| User-defined data type filtering    | Enabled     |
| Line buffer defined data types      | 4096        |
| Allowed virtual channels            | All         |
| Pixels per clock                    | 1           |
| TUSER width                         | 1           |
| CRC                                 | Enabled     |

This configuration is suitable for a 2-lane camera input path such as the IMX477 configuration described in the camera interface chapter.

### 4.6.2 MIPI CSI-2 RX Subsystem 2

| **Parameter**                       | **Setting** |
|-------------------------------------|-------------|
| Pixel format                        | RAW10       |
| Serial data lanes                   | 4           |
| Line rate                           | 2000 Mbps   |
| CSI-2 controller register interface | Enabled     |
| User-defined data type filtering    | Enabled     |
| Line buffer defined data types      | 4096        |
| Allowed virtual channels            | All         |
| Pixels per clock                    | 1           |
| TUSER width                         | 1           |
| CRC                                 | Enabled     |

This configuration is suitable for a 4-lane camera input path such as the AR1335 configuration described in the camera interface chapter.

## 4.7 Pixel Format Configuration

The selected camera input pixel format is **RAW10**. RAW10 uses 10 bits per pixel sample and is common for image sensors because it preserves more sensor precision than 8-bit capture while maintaining manageable bandwidth.

### 4.7.1 RAW10 Role in the Video Pipeline

The RAW10 format is used at the camera input stage before demosaic conversion:

Camera Sensor

↓

MIPI CSI-2 RAW10 Stream

↓

MIPI CSI-2 RX Subsystem

↓

RAW10 Pixel Capture

↓

Demosaic

↓

RGB Video Stream

RAW10 is not a final RGB display format. It represents Bayer-pattern intensity samples and must be converted into RGB pixel data before most color-processing operations can be applied.

### 4.7.2 RAW10 Configuration Considerations

Important RAW10 configuration requirements include:

- Correct MIPI data type selection.

- Correct lane count.

- Correct line rate.

- Correct pixel unpacking.

- Correct Bayer phase tracking.

- Correct frame and line synchronization.

- Correct demosaic input formatting.

Incorrect RAW10 handling can produce invalid colors, spatial distortion, or corrupted video frames.

## 4.8 Pixels-Per-Clock Configuration

The MIPI CSI-2 RX subsystem is configured for **one pixel per clock**.

A one-pixel-per-clock architecture simplifies the downstream processing pipeline because each clock cycle corresponds to one valid pixel transfer when TVALID and TREADY are asserted.

### 4.8.1 Benefits of One-Pixel-Per-Clock Processing

One-pixel-per-clock processing provides:

- Simple pixel alignment.

- Predictable stream timing.

- Easier filter pipeline design.

- Easier coordinate counter design.

- Straightforward frame and line tracking.

- Reduced complexity in VCP processing blocks.

### 4.8.2 Throughput Requirement

For one-pixel-per-clock operation, the processing clock must be high enough to sustain the selected resolution and frame rate. For example, 3840×2160 at 30 Hz requires a pixel clock near 297 MHz when using standard timing totals. The source document lists 3840×2160 progressive at 30 Hz with a 297 MHz clock.

## 4.9 TUSER and TLAST Video Signaling

The Vivado video stream configuration includes a **TUSER width of 1** for the MIPI CSI-2 RX subsystem.

In a typical AXI4-Stream video design:

| **Signal** | **Common Video Meaning**         |
|------------|----------------------------------|
| TUSER\[0\] | Start of frame                   |
| TLAST      | End of line                      |
| TVALID     | Pixel data is valid              |
| TREADY     | Downstream block can accept data |
| TDATA      | Pixel data payload               |

The VCP module and downstream output blocks must preserve these signals. Any misalignment between pixel data and sideband signals can cause display corruption, line shifting, frame tearing, or invalid image-processing results.

## 4.10 CRC Enablement

The MIPI CSI-2 RX subsystem configuration enables CRC.

CRC support helps detect corrupted packet payloads in the MIPI stream. During system bring-up and validation, CRC error reporting can be used to identify:

- Signal-integrity problems.

- Incorrect lane configuration.

- Cable or connector issues.

- Camera timing errors.

- Receiver configuration mismatches.

CRC status should be connected to diagnostic registers or software-visible status paths where possible.

## 4.11 Video Timing and Resolution Configuration

The Vivado design includes a video timing table that defines supported resolution modes, total horizontal samples, blanking intervals, total vertical lines, refresh rates, and pixel clocks.

Examples from the configuration include:

| **Resolution** | **Mode**    | **Refresh Rate** | **Pixel Clock** |
|----------------|-------------|------------------|-----------------|
| 1280×720       | Progressive | 60 Hz            | 74.250 MHz      |
| 1920×1080      | Progressive | 60 Hz            | 148.500 MHz     |
| 3840×2160      | Progressive | 30 Hz            | 297 MHz         |
| 3840×2160      | Progressive | 60 Hz            | 594 MHz         |
| 4096×2160      | Progressive | 30 Hz            | 297 MHz         |

The source timing table lists 1280×720 at 60 Hz with a 74.250 MHz clock, 1920×1080 at 60 Hz with a 148.500 MHz clock, and 3840×2160 at 30 Hz with a 297 MHz clock.

### 4.11.1 Importance of Video Timing

Video timing parameters are required for:

- Pixel clock calculation.

- Display output compatibility.

- Frame-rate selection.

- Bandwidth estimation.

- AXI4-Stream throughput planning.

- MIPI lane-rate planning.

- VDMA frame-buffer sizing.

The selected timing mode must be consistent across the camera input, processing pipeline, memory subsystem, and output interface.

## 4.12 DisplayPort Configuration

The DisplayPort output path allows processed video to be displayed directly. The MPSoC configuration includes DisplayPort-related settings such as DPAUX MIO assignment, lane selection, and reference frequency.

The key DisplayPort configuration values include:

| **Parameter**       | **Setting**      |
|---------------------|------------------|
| DPAUX MIO           | MIO 27 to MIO 30 |
| Lane selection      | Dual Lower       |
| Reference frequency | 27 MHz           |

These settings support DisplayPort link management and output timing. The output video stream must be formatted according to the selected display resolution and refresh rate.

## 4.13 AXI4-Stream Integration

The Vivado block design connects video-processing modules using AXI4-Stream interfaces. AXI4-Stream is used for the high-speed movement of pixel data from one processing block to the next.

A typical AXI4-Stream video path is:

MIPI CSI-2 RX

↓

RAW Stream Formatter

↓

Demosaic

↓

Video Color Processing

↓

VDMA / DisplayPort / Ethernet Output

### 4.13.1 AXI4-Stream Design Requirements

Each AXI4-Stream block must correctly handle:

- TDATA pixel payload.

- TVALID valid-data signaling.

- TREADY backpressure.

- TLAST line boundary marking.

- TUSER frame-start marking.

- Clock and reset alignment.

For deterministic video processing, the stream should avoid unnecessary stalls and maintain one-pixel-per-clock throughput whenever possible.

## 4.14 AXI4-Lite Register Integration

Control registers are exposed through AXI4-Lite. This allows software running on the processing system to configure the programmable logic.

AXI4-Lite integration supports:

- Camera receiver configuration.

- VCP mode selection.

- Filter enable control.

- Color-space conversion selection.

- Image enhancement parameter updates.

- Threshold register updates.

- Palette or LUT register access.

- Diagnostic status reads.

The AXI4-Lite path should be separated from the high-speed AXI4-Stream video path. This separation allows software to configure the design without interfering with the active video datapath.

## 4.15 Video Color Processing IP Integration

The custom Video Color Processing module is integrated into the Vivado block design as a programmable-logic processing block. It connects to the upstream RGB video stream and outputs a processed RGB video stream.

### 4.15.1 VCP Interfaces

The VCP module typically includes:

| **Interface**      | **Purpose**                                             |
|--------------------|---------------------------------------------------------|
| AXI4-Stream Slave  | Receives input RGB video stream                         |
| AXI4-Stream Master | Outputs processed RGB video stream                      |
| AXI4-Lite Slave    | Receives software configuration writes and status reads |
| Clock and Reset    | Synchronizes datapath and control logic                 |
| Optional Interrupt | Reports events or error conditions                      |

### 4.15.2 VCP Placement

The VCP module is placed after demosaic conversion and before output routing:

Demosaic RGB Output

↓

Video Color Processing Module

↓

DisplayPort / UDP / VDMA Output

This placement allows the VCP module to operate on full RGB pixel data, enabling color correction, filtering, color-space conversion, and K-means color clustering.

## 4.16 VDMA and Memory Interface Configuration

VDMA may be used to move video frames between AXI4-Stream interfaces and external DDR memory. This is useful when the output path requires memory-backed frame buffers or when software must access video frames.

### 4.16.1 VDMA Functions

VDMA supports:

- Stream-to-memory-mapped transfer.

- Memory-mapped-to-stream transfer.

- Frame buffering.

- Display pipeline feeding.

- Software frame inspection.

- Buffer address control.

### 4.16.2 Memory Interface Requirements

The memory path must provide enough bandwidth to support the selected video format. For high-resolution video, memory bandwidth can become a bottleneck if multiple read and write paths are active simultaneously.

Important memory configuration considerations include:

- AXI data width.

- Burst length.

- DDR bandwidth.

- Frame-buffer stride.

- Number of frame buffers.

- Cache coherency policy.

- Synchronization between software and hardware.

The source document states that VDMA transfers video streaming to and from external memory and operates under software control.

## 4.17 Reset Architecture

Reset logic is required to initialize and recover each subsystem safely. The Vivado block design should use synchronized reset signals for each clock domain.

### 4.17.1 Reset Domains

Typical reset domains include:

| **Reset Domain**       | **Associated Blocks**                       |
|------------------------|---------------------------------------------|
| AXI4-Lite reset        | Register interfaces and control logic       |
| Video-processing reset | VCP datapath and stream logic               |
| MIPI input reset       | MIPI CSI-2 RX and D-PHY logic               |
| Output reset           | DisplayPort, VDMA, or Ethernet stream logic |
| Clock-generator reset  | Clock management blocks                     |

### 4.17.2 Reset Sequencing

A recommended reset sequence is:

1.  Hold all programmable-logic blocks in reset.

2.  Enable and stabilize input clocks.

3.  Wait for clock-generator lock.

4.  Release AXI4-Lite control reset.

5.  Configure control registers.

6.  Release MIPI receiver reset.

7.  Start camera streaming.

8.  Release video-processing reset.

9.  Release output-interface reset.

10. Confirm frame activity.

This sequence prevents downstream modules from processing invalid or unstable data during startup.

## 4.18 Interrupt and Status Signal Integration

Interrupts and status signals improve software visibility into the hardware pipeline. They are useful for frame events, error reporting, and runtime monitoring.

Recommended status signals include:

- MIPI receiver lock.

- CRC error status.

- Frame-start detection.

- Line-end detection.

- Frame counter.

- Pixel counter.

- FIFO overflow.

- FIFO underflow.

- VCP active mode.

- Output active status.

- VDMA interrupt status.

These signals may be mapped to AXI4-Lite status registers or connected to PS interrupt inputs.

## 4.19 Vivado Address Map Planning

The Vivado address map assigns memory-mapped address ranges to AXI4-Lite and AXI memory-mapped peripherals. Proper address planning is required so software can access each hardware block reliably.

A typical address map includes:

| **Block**            | **Interface Type** | **Function**                             |
|----------------------|--------------------|------------------------------------------|
| MIPI CSI-2 RX        | AXI4-Lite          | Camera receiver configuration and status |
| VCP Module           | AXI4-Lite          | Processing control and status            |
| VDMA                 | AXI4-Lite / AXI-MM | Frame-buffer control and memory access   |
| GPIO / Control       | AXI4-Lite          | Reset, enable, and miscellaneous control |
| Interrupt Controller | AXI4-Lite          | Interrupt status and routing             |

The address ranges should be documented in the register-map chapter so software developers can configure and debug the system consistently.

## 4.20 IP Integration Checklist

Before generating the bitstream, the Vivado block design should be reviewed using a structured checklist.

### 4.20.1 Camera Input Checklist

- Confirm MIPI lane count.

- Confirm RAW10 data type.

- Confirm line rate.

- Confirm D-PHY connection.

- Confirm TUSER width.

- Confirm pixels-per-clock setting.

- Confirm CRC enablement.

- Confirm camera I2C control path.

### 4.20.2 Video Datapath Checklist

- Confirm AXI4-Stream connections.

- Confirm TDATA width compatibility.

- Confirm TUSER and TLAST propagation.

- Confirm clock-domain crossings.

- Confirm reset synchronization.

- Confirm VCP placement after demosaic.

- Confirm output path routing.

### 4.20.3 Control Path Checklist

- Confirm AXI4-Lite register connections.

- Confirm address map assignment.

- Confirm PS master interface enablement.

- Confirm register reset values.

- Confirm status readback paths.

- Confirm software-accessible diagnostics.

### 4.20.4 Output Path Checklist

- Confirm DisplayPort clock settings.

- Confirm DisplayPort lane selection.

- Confirm VDMA memory interface if used.

- Confirm Ethernet streaming path if used.

- Confirm output resolution timing.

## 4.21 Vivado Validation and Bitstream Generation

After block design integration, Vivado validation should be run to detect connectivity, clocking, reset, and interface issues.

The implementation flow includes:

1.  Validate block design.

2.  Generate output products.

3.  Create HDL wrapper.

4.  Run synthesis.

5.  Run implementation.

6.  Review timing summary.

7.  Review utilization summary.

8.  Generate bitstream.

9.  Export hardware platform.

10. Use the exported hardware in software or embedded Linux flow.

### 4.21.1 Timing Review

Timing closure must be checked carefully for high-frequency video clocks such as 297 MHz or 300 MHz. Critical paths often appear in:

- Color-space conversion arithmetic.

- Filter kernel accumulation.

- K-means distance comparison.

- AXI stream routing.

- Clock-domain crossing logic.

- VDMA interface logic.

Pipeline registers may be required to meet timing.

### 4.21.2 Utilization Review

Resource usage should be reviewed for:

- LUTs.

- Flip-flops.

- BRAM.

- DSP blocks.

- Clocking resources.

- AXI interconnect resources.

The VCP module can consume significant resources depending on how many filters, color conversions, and clustering functions are included.

## 4.22 Chapter Summary

This chapter described the Vivado block design configuration used to integrate the FPGA Video Color Processing System. The design centers on the Zynq UltraScale+ MPSoC, with PS–PL interfaces configured for software control and high-performance data movement.

The Vivado configuration includes DisplayPort auxiliary I/O mapping, DisplayPort lane selection, PL clock setup, PS–PL AXI interface selection, and MIPI CSI-2 receiver subsystem settings. The MIPI CSI-2 input path uses RAW10 format, one pixel per clock, TUSER width of 1, CRC enablement, and either 2-lane or 4-lane camera configurations.

The block design connects camera input, RAW capture, demosaic conversion, the Video Color Processing module, memory movement, and display or Ethernet output paths. A correct Vivado configuration is essential for reliable camera acquisition, deterministic video processing, and successful deployment on the Kria KV260 platform.
