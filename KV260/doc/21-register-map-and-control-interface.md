# Chapter 21 — Register Map and Control Interface

## 21.1 Overview

The **Register Map and Control Interface** defines how software configures, monitors, and controls the FPGA Video Color Processing System. The video datapath performs real-time pixel operations in hardware, while the control interface allows the Processing System, testbench, or host software to select modes, load coefficients, set thresholds, configure filters, update palettes, and read status information.

In this design, the Video Color Processing module uses **AXI4-Lite** as the configuration interface and **AXI4-Stream** as the video input/output interface. The source document states that the VCP architecture consists of AXI4-Lite for configuration and AXI4-Stream for video input and output, with filters, color-space conversion, K-means quantization, and color-gain matrix functions.

A simplified control architecture is:

Processing System / Software

↓

AXI4-Lite Register Interface

↓

Control and Status Registers

↓

VCP Processing Blocks

↓

AXI4-Stream Video Datapath

The control interface must be deterministic, readable, software-friendly, and safe for live video operation.

## 21.2 Purpose of the Register Map

The register map provides a structured memory-mapped control space for the VCP hardware.

It supports:

| **Function**          | **Description**                                                     |
|-----------------------|---------------------------------------------------------------------|
| Mode selection        | Selects active filter, color conversion, K-means, or bypass mode.   |
| Threshold programming | Sets Sobel, local threshold, histogram, or segmentation thresholds. |
| Coefficient loading   | Loads filter, color matrix, and gain coefficients.                  |
| Channel selection     | Selects RGB, HSL, HSV, YCbCr, or other output channels.             |
| Palette control       | Selects K-means or programmable color scheme entries.               |
| Runtime status        | Reports active mode, frame state, and error flags.                  |
| Testbench access      | Allows UVM sequences to write and read configuration values.        |
| Software control      | Allows Vitis or embedded software to configure video behavior.      |

The source document states that the VCP custom module applies image enhancement control, including contrast, brightness, saturation, white/black balance, and RGB gain through AXI4-Lite configuration registers.

## 21.3 AXI4-Lite Control Interface

AXI4-Lite is used because it provides a simple memory-mapped interface suitable for low-bandwidth control registers. It is not intended for high-throughput pixel streaming. Pixel data is carried separately through AXI4-Stream.

The source design states that AXI4-Lite presents a memory-map register interface to the processor for video-stream register configuration.

### 21.3.1 AXI4-Lite Signals

A standard AXI4-Lite slave interface includes:

| **Channel**    | **Main Signals**             | **Purpose**                        |
|----------------|------------------------------|------------------------------------|
| Write address  | AWADDR, AWVALID, AWREADY     | Selects register address for write |
| Write data     | WDATA, WSTRB, WVALID, WREADY | Transfers write data               |
| Write response | BRESP, BVALID, BREADY        | Reports write completion           |
| Read address   | ARADDR, ARVALID, ARREADY     | Selects register address for read  |
| Read data      | RDATA, RRESP, RVALID, RREADY | Returns register data              |

The testbench reset sequence in the source document shows AXI4-Lite signals such as AWADDR, AWPROT, AWVALID, WDATA, WSTRB, WVALID, BREADY, ARADDR, and ARPROT, confirming the register-level AXI4-Lite interface structure used by the verification environment.

## 21.4 AXI4-Stream Video Interface Relationship

The AXI4-Lite interface configures the VCP behavior, while AXI4-Stream carries the video pixels.

AXI4-Lite:

register writes

control bits

coefficients

status reads

AXI4-Stream:

pixel data

valid signal

frame marker

line marker

The VCP block therefore has two different interface responsibilities:

| **Interface** | **Role**                         |
|---------------|----------------------------------|
| AXI4-Lite     | Low-speed software configuration |
| AXI4-Stream   | High-speed video pixel transport |

Control registers should never stall or corrupt the live AXI4-Stream datapath.

## 21.5 Register Addressing Model

The register map is organized as offsets from a base address. The source document states that AXI4-Lite module registers in RTL use offsets from a base address for AXI4-Lite transactions.

A typical software access pattern is:

register_address = VCP_BASE_ADDRESS + register_offset

Example:

VCP_BASE_ADDRESS = 0xA0000000

FILTER_ID_OFFSET = 0x08

write32(VCP_BASE_ADDRESS + FILTER_ID_OFFSET, filter_id_value)

The specific base address is assigned during Vivado address mapping. The register offsets remain local to the VCP IP.

## 21.6 Existing RTL Register Offset Table

The source document lists the following AXI4-Lite register offsets for the VCP RTL interface.

| **Register Name**    | **Offset** | **Function Category**                    |
|----------------------|------------|------------------------------------------|
| initAddr             | 0x00       | Initialization / base control            |
| oRgbOsharp           | 0x00       | Sharp output / shared initial register   |
| oEdgeType            | 0x04       | Edge mode or edge type control           |
| filter_id            | 0x08       | Active filter selection                  |
| aBusSelect           | 0x0C       | Bus or processing path selection         |
| threshold            | 0x10       | Threshold value                          |
| videoChannel         | 0x14       | Video channel selection                  |
| dChannel             | 0x18       | Destination or display channel selection |
| cChannel             | 0x1C       | Color channel selection                  |
| kls_k1               | 0x20       | Kernel/filter coefficient 1              |
| kls_k2               | 0x24       | Kernel/filter coefficient 2              |
| kls_k3               | 0x28       | Kernel/filter coefficient 3              |
| kls_k4               | 0x2C       | Kernel/filter coefficient 4              |
| kls_k5               | 0x30       | Kernel/filter coefficient 5              |
| kls_k6               | 0x34       | Kernel/filter coefficient 6              |
| kls_k7               | 0x38       | Kernel/filter coefficient 7              |
| kls_k8               | 0x3C       | Kernel/filter coefficient 8              |
| kls_k9               | 0x40       | Kernel/filter coefficient 9              |
| kls_config           | 0x44       | Kernel/filter configuration              |
| als_k1               | 0x54       | Color matrix / adjustment coefficient 1  |
| als_k2               | 0x58       | Color matrix / adjustment coefficient 2  |
| als_k3               | 0x5C       | Color matrix / adjustment coefficient 3  |
| als_k4               | 0x60       | Color matrix / adjustment coefficient 4  |
| als_k5               | 0x64       | Color matrix / adjustment coefficient 5  |
| als_k6               | 0x68       | Color matrix / adjustment coefficient 6  |
| als_k7               | 0x6C       | Color matrix / adjustment coefficient 7  |
| als_k8               | 0x70       | Color matrix / adjustment coefficient 8  |
| als_k9               | 0x74       | Color matrix / adjustment coefficient 9  |
| als_config           | 0x78       | Color-adjust matrix configuration        |
| pReg_pointInterest   | 0x7C       | Point-of-interest control                |
| pReg_deltaConfig     | 0x80       | Delta / difference configuration         |
| pReg_cpuAckGoAgain   | 0x84       | CPU acknowledge / restart control        |
| pReg_cpuWgridLock    | 0x88       | CPU/grid lock control                    |
| pReg_cpuAckoffFrame  | 0x8C       | CPU frame-off acknowledge                |
| pReg_fifoReadAddress | 0x90       | FIFO read address                        |
| pReg_clearFifoData   | 0x94       | FIFO clear command                       |
| rgbCoord_rl          | 0xC8       | Red coordinate low                       |
| rgbCoord_rh          | 0xCC       | Red coordinate high                      |
| rgbCoord_gl          | 0xD0       | Green coordinate low                     |
| rgbCoord_gh          | 0xD4       | Green coordinate high                    |
| rgbCoord_bl          | 0xD8       | Blue coordinate low                      |
| rgbCoord_bh          | 0xDC       | Blue coordinate high                     |
| oLumTh               | 0xE0       | Luminance threshold output               |
| oHsvPerCh            | 0xE4       | HSV per-channel output                   |
| oYccPerCh            | 0xE8       | YCbCr per-channel output                 |

This register table forms the baseline control interface for the documented RTL system.

## 21.7 Register Categories

The VCP register map can be organized into logical categories.

| **Category**              | **Register Examples**                    | **Purpose**                                             |
|---------------------------|------------------------------------------|---------------------------------------------------------|
| Core control              | initAddr, filter_id, aBusSelect          | Enables and selects processing modes                    |
| Threshold control         | threshold, oLumTh                        | Supports edge, segmentation, and luminance thresholds   |
| Channel control           | videoChannel, dChannel, cChannel         | Selects input/output color channel behavior             |
| Kernel coefficients       | kls_k1–kls_k9, kls_config                | Controls 3×3 filters such as sharp, blur, emboss, Sobel |
| Color matrix coefficients | als_k1–als_k9, als_config                | Controls color adjustment matrix                        |
| Point control             | pReg_pointInterest, pReg_deltaConfig     | Supports coordinate/delta-based processing              |
| CPU handshaking           | pReg_cpuAckGoAgain, pReg_cpuAckoffFrame  | Synchronizes software and hardware state                |
| FIFO access               | pReg_fifoReadAddress, pReg_clearFifoData | Supports buffered diagnostic readout                    |
| Coordinate readback       | rgbCoord\_\*                             | Reports RGB coordinate-related information              |
| Color-space output        | oHsvPerCh, oYccPerCh                     | Reports selected color-space channel values             |

This grouping makes the register map easier for software, verification, and documentation.

## 21.8 Filter Selection Register

The filter_id register selects the active image-processing function.

A representative filter ID map is:

| **filter_id Value** | **Processing Mode**           |
|---------------------|-------------------------------|
| 0                   | Bypass / RGB pass-through     |
| 1                   | Color gain / color correction |
| 2                   | Sharp filter                  |
| 3                   | Blur filter                   |
| 4                   | Emboss filter                 |
| 5                   | Sobel edge detection          |
| 6                   | RGB to HSL                    |
| 7                   | HSL to RGB                    |
| 8                   | RGB to HSV                    |
| 9                   | K-means clustering            |
| 10                  | Local threshold segmentation  |
| 11                  | Histogram / diagnostic mode   |
| 12                  | Programmable color scheme     |

The source test configuration table lists filter and color-space test enables such as F_CGA, F_SHP, F_BLU, F_HSL, F_HSV, F_RGB, F_SOB, and F_EMB, showing the major selectable processing functions verified in the RTL environment.

## 21.9 Threshold Register

The threshold register controls threshold-based operations.

Possible users include:

| **Processing Block**         | **Use of Threshold**                |
|------------------------------|-------------------------------------|
| Sobel edge detection         | Edge/no-edge decision               |
| Local dynamic threshold      | Similar/different neighbor decision |
| Histogram-based segmentation | Intensity cutoff                    |
| Luminance threshold          | Bright/dark classification          |
| Debug highlighting           | Region-detection threshold          |

Recommended field definition:

threshold\[7:0\] = 8-bit threshold value

threshold\[15:8\] = optional secondary threshold

threshold\[31:16\] = reserved

For 8-bit pixel channels:

valid threshold range = 0 to 255

For 10-bit or 12-bit internal channels, the threshold register should define whether values are scaled or represented at full internal precision.

## 21.10 Kernel Coefficient Registers

The kls_k1 through kls_k9 registers are suitable for a 3×3 kernel:

kls_k1 kls_k2 kls_k3

kls_k4 kls_k5 kls_k6

kls_k7 kls_k8 kls_k9

These coefficients can be used by filters such as:

- Sharp.

- Blur.

- Emboss.

- Sobel Kx.

- Sobel Ky.

- Custom user-defined convolution.

A typical software loading sequence is:

write kls_k1

write kls_k2

write kls_k3

write kls_k4

write kls_k5

write kls_k6

write kls_k7

write kls_k8

write kls_k9

write kls_config

The kls_config register should contain scaling, signed/unsigned mode, normalization, and activation bits.

## 21.11 Color Matrix Coefficient Registers

The als_k1 through als_k9 registers represent a 3×3 color adjustment matrix:

als_k1 als_k2 als_k3

als_k4 als_k5 als_k6

als_k7 als_k8 als_k9

A color correction matrix applies:

Rout = als_k1×Rin + als_k2×Gin + als_k3×Bin

Gout = als_k4×Rin + als_k5×Gin + als_k6×Bin

Bout = als_k7×Rin + als_k8×Gin + als_k9×Bin

Recommended implementation detail:

Coefficient format = signed fixed-point

Example format = Q4.12 or Q3.13

The als_config register should define matrix enable, coefficient format, rounding mode, clamp enable, and active matrix index.

## 21.12 Channel Selection Registers

The channel-selection registers allow software to select which color or diagnostic channel is displayed, processed, or read back.

| **Register** | **Possible Function**                 |
|--------------|---------------------------------------|
| videoChannel | Selects input or output video channel |
| dChannel     | Selects display/debug channel         |
| cChannel     | Selects color-space channel           |

Example channel map:

| **Value** | **Channel**            |
|-----------|------------------------|
| 0         | RGB full output        |
| 1         | Red only               |
| 2         | Green only             |
| 3         | Blue only              |
| 4         | Hue                    |
| 5         | Saturation             |
| 6         | Luminosity / intensity |
| 7         | Y / luminance          |
| 8         | Cb                     |
| 9         | Cr                     |
| 10        | Cluster index          |
| 11        | Threshold mask         |

Channel selection is useful for debugging color-space conversion and verifying per-channel outputs.

## 21.13 CPU Handshake Registers

Some registers coordinate state changes between software and the video pipeline.

| **Register**        | **Purpose**                                            |
|---------------------|--------------------------------------------------------|
| pReg_cpuAckGoAgain  | CPU acknowledges that hardware can restart or continue |
| pReg_cpuWgridLock   | CPU requests or observes grid-lock state               |
| pReg_cpuAckoffFrame | CPU acknowledges frame-off or frame-boundary state     |

These registers should be treated as handshake controls rather than static configuration fields.

A safe handshake pattern is:

Software writes request bit

Hardware detects request

Hardware performs operation at safe boundary

Hardware sets done bit

Software reads done bit

Software clears request bit

This avoids race conditions when the video stream is active.

## 21.14 FIFO and Diagnostic Readback Registers

The register map includes FIFO-related controls:

| **Register**         | **Purpose**               |
|----------------------|---------------------------|
| pReg_fifoReadAddress | Selects FIFO read address |
| pReg_clearFifoData   | Clears FIFO contents      |

These registers can support diagnostic readout such as:

- Captured pixel samples.

- Histogram bins.

- Coordinate hits.

- Region-of-interest data.

- Filter debug results.

- Error snapshots.

A safe FIFO diagnostic sequence is:

1\. Stop or freeze diagnostic capture.

2\. Set FIFO read address.

3\. Read diagnostic data register.

4\. Increment address or repeat.

5\. Clear FIFO when analysis is complete.

## 21.15 Coordinate Readback Registers

The register map includes RGB coordinate registers:

rgbCoord_rl

rgbCoord_rh

rgbCoord_gl

rgbCoord_gh

rgbCoord_bl

rgbCoord_bh

These can be interpreted as low/high halves of coordinate or count values associated with red, green, and blue channel processing.

Possible uses include:

| **Register Pair** | **Possible Meaning**              |
|-------------------|-----------------------------------|
| rgbCoord_rl/rh    | Red-channel coordinate or count   |
| rgbCoord_gl/gh    | Green-channel coordinate or count |
| rgbCoord_bl/bh    | Blue-channel coordinate or count  |

For 32-bit coordinate reconstruction:

red_coord = {rgbCoord_rh, rgbCoord_rl}

green_coord = {rgbCoord_gh, rgbCoord_gl}

blue_coord = {rgbCoord_bh, rgbCoord_bl}

The exact bit field should be documented in the final RTL register specification.

## 21.16 Recommended Extended Register Map

The documented register map provides a baseline. For a complete production-ready VCP system, the following extended map is recommended.

| **Offset**  | **Register**        | **Access** | **Description**                                      |
|-------------|---------------------|------------|------------------------------------------------------|
| 0x000       | VCP_CONTROL         | R/W        | Enable, bypass, soft reset, frame-safe update enable |
| 0x004       | VCP_STATUS          | R          | Active mode, idle, busy, frame-active, error flags   |
| 0x008       | FILTER_ID           | R/W        | Selects active processing mode                       |
| 0x00C       | BUS_SELECT          | R/W        | Selects internal datapath source                     |
| 0x010       | THRESHOLD           | R/W        | General threshold control                            |
| 0x014       | VIDEO_CHANNEL       | R/W        | Video channel selection                              |
| 0x018       | DISPLAY_CHANNEL     | R/W        | Display/debug channel selection                      |
| 0x01C       | COLOR_CHANNEL       | R/W        | Color-space channel selection                        |
| 0x020–0x040 | KERNEL_COEFF\[0:8\] | R/W        | 3×3 filter kernel coefficients                       |
| 0x044       | KERNEL_CONFIG       | R/W        | Kernel scale, signed mode, clamp enable              |
| 0x054–0x074 | COLOR_MATRIX\[0:8\] | R/W        | 3×3 color correction coefficients                    |
| 0x078       | COLOR_MATRIX_CONFIG | R/W        | Matrix enable, scale, clamp, bank select             |
| 0x07C       | POINT_OF_INTEREST   | R/W        | Pixel or region point-of-interest                    |
| 0x080       | DELTA_CONFIG        | R/W        | Difference/delta configuration                       |
| 0x084       | CPU_ACK_GO_AGAIN    | R/W        | CPU restart/continue acknowledge                     |
| 0x088       | CPU_GRID_LOCK       | R/W        | Grid-lock control/status                             |
| 0x08C       | CPU_ACK_OFF_FRAME   | R/W        | CPU frame-off acknowledge                            |
| 0x090       | FIFO_READ_ADDR      | R/W        | Diagnostic FIFO read address                         |
| 0x094       | FIFO_CLEAR          | W          | Clears diagnostic FIFO                               |
| 0x0A0       | PALETTE_INDEX       | R/W        | Selects palette entry                                |
| 0x0A4       | PALETTE_RGB         | R/W        | Packed palette RGB value                             |
| 0x0A8       | PALETTE_CONTROL     | R/W        | Palette update and bank control                      |
| 0x0AC       | KMEANS_CONFIG       | R/W        | K value, distance mode, output mode                  |
| 0x0B0       | HIST_CONTROL        | R/W        | Histogram enable, clear, mode                        |
| 0x0B4       | HIST_INDEX          | R/W        | Histogram bin index                                  |
| 0x0B8       | HIST_COUNT          | R          | Histogram count readback                             |
| 0x0C0       | FRAME_COUNT         | R          | Processed frame counter                              |
| 0x0C4       | ERROR_STATUS        | R/W1C      | Sticky error flags                                   |
| 0x0C8–0x0DC | RGB_COORD\_\*       | R          | RGB coordinate readback                              |
| 0x0E0       | LUMA_THRESHOLD_OUT  | R          | Luminance threshold diagnostic                       |
| 0x0E4       | HSV_PER_CHANNEL     | R          | HSV diagnostic output                                |
| 0x0E8       | YCC_PER_CHANNEL     | R          | YCbCr diagnostic output                              |

This extended map keeps compatibility with the documented offsets while adding structured controls for later chapters and system integration.

## 21.17 Register Access Types

Every register should define its access type.

| **Access Type** | **Meaning**                                                    |
|-----------------|----------------------------------------------------------------|
| R               | Read-only                                                      |
| W               | Write-only                                                     |
| R/W             | Read/write                                                     |
| W1C             | Write one to clear                                             |
| RC              | Read clears value                                              |
| RO-sticky       | Read-only sticky status until cleared                          |
| Shadowed        | Write affects shadow register, not active datapath immediately |

Recommended practice:

- Control registers should be R/W.

- Status registers should be R or W1C.

- Error flags should be sticky and W1C.

- Active coefficients should be protected by shadow update logic.

- Read-only diagnostic outputs should not be overwritten by software.

## 21.18 Bit-Field Definition Example

A register map is incomplete without bit-field definitions. Example for VCP_CONTROL:

| **Bit** | **Name**          | **Access** | **Description**                        |
|---------|-------------------|------------|----------------------------------------|
| 0       | enable            | R/W        | Enables VCP processing                 |
| 1       | bypass            | R/W        | Passes input video unchanged           |
| 2       | soft_reset        | W          | Resets internal VCP state              |
| 3       | frame_safe_update | R/W        | Applies updates only at frame boundary |
| 4       | update_request    | R/W        | Requests active/shadow update          |
| 5       | palette_bank_swap | R/W        | Enables palette bank swap              |
| 6       | coeff_bank_swap   | R/W        | Enables coefficient bank swap          |
| 7       | interrupt_enable  | R/W        | Enables interrupt generation           |
| 31:8    | reserved          | R          | Reserved, read as zero                 |

Example for VCP_STATUS:

| **Bit** | **Name**        | **Access** | **Description**                          |
|---------|-----------------|------------|------------------------------------------|
| 0       | enabled         | R          | VCP is enabled                           |
| 1       | bypass_active   | R          | Bypass is active                         |
| 2       | frame_active    | R          | Currently inside active frame            |
| 3       | update_pending  | R          | Shadow update waiting for frame boundary |
| 4       | update_done     | W1C        | Update completed                         |
| 5       | stream_error    | W1C        | Stream protocol error detected           |
| 6       | overflow_error  | W1C        | Internal overflow occurred               |
| 7       | underflow_error | W1C        | Internal underflow occurred              |
| 31:8    | reserved        | R          | Reserved                                 |

## 21.19 Frame-Safe Register Updates

Some registers can be updated immediately without visible artifacts, but others must be applied only at a safe video boundary.

**Immediate Update Registers**

Examples:

- Status clear bits.

- Diagnostic FIFO read address.

- Software-only control bits.

- Debug selection when output is not active.

**Frame-Safe Update Registers**

Examples:

- filter_id

- threshold

- kls_k1–kls_k9

- als_k1–als_k9

- Palette entries.

- K-means active K value.

- Output stream format.

Frame-safe update flow:

Software writes shadow registers

↓

Software sets update_request

↓

Hardware waits for start-of-frame or end-of-frame

↓

Shadow values copy to active registers

↓

Hardware sets update_done

This prevents a single video frame from being processed using mixed configuration values.

## 21.20 Active and Shadow Register Banks

Active/shadow register banks are recommended for live video control.

| **Bank**     | **Purpose**                        |
|--------------|------------------------------------|
| Active bank  | Drives current video datapath      |
| Shadow bank  | Receives software writes           |
| Pending flag | Indicates a requested update       |
| Done flag    | Indicates safe activation occurred |

Example:

active_filter_id → used by video datapath

shadow_filter_id → written by AXI4-Lite

At frame boundary:

if update_request:

active_filter_id \<= shadow_filter_id

update_done \<= 1

This method is especially important for coefficients, palettes, and mode changes.

## 21.21 Reset Behavior

The register interface should define reset values.

Recommended reset behavior:

| **Register Type**   | **Reset Value**               |
|---------------------|-------------------------------|
| Control             | Disabled or bypass mode       |
| Filter ID           | Bypass / RGB pass-through     |
| Threshold           | Safe default, such as 0 or 10 |
| Kernel coefficients | Identity or no-effect kernel  |
| Color matrix        | Identity matrix               |
| Palette             | Safe default palette          |
| Status              | No errors                     |
| Frame counter       | 0                             |
| FIFO state          | Empty                         |
| Histogram state     | Cleared                       |

A safe reset configuration prevents corrupted output during initialization.

## 21.22 Software Access Sequence

A typical software sequence for configuring a filter is:

1\. Disable VCP or enable frame-safe update.

2\. Write filter_id to shadow register.

3\. Write threshold if required.

4\. Write kernel coefficients if required.

5\. Write channel selection.

6\. Set update_request.

7\. Poll update_done.

8\. Clear update_done.

9\. Verify active mode through status register.

Example pseudocode:

write32(VCP_CONTROL, FRAME_SAFE_UPDATE_EN);

write32(FILTER_ID, FILTER_SOBEL);

write32(THRESHOLD, 32);

write32(KERNEL_CONFIG, KERNEL_SIGNED \| KERNEL_CLAMP);

write32(VCP_CONTROL, FRAME_SAFE_UPDATE_EN \| UPDATE_REQUEST);

while ((read32(VCP_STATUS) & UPDATE_DONE) == 0) {

/\* wait \*/

}

write32(VCP_STATUS, UPDATE_DONE); // W1C clear

## 21.23 Verification Interface Requirements

The verification environment must test register reads, writes, reset behavior, and side effects.

The source document states that tests are created for each filter and color space to verify RTL code, and each test can configure image dimensions and VFP configuration registers.

Verification should include:

| **Test**                      | **Purpose**                             |
|-------------------------------|-----------------------------------------|
| Reset test                    | Confirms all registers reset correctly  |
| Write/read test               | Confirms register storage               |
| Reserved-bit test             | Confirms reserved bits read as zero     |
| W1C test                      | Confirms sticky flags clear correctly   |
| Invalid-address test          | Confirms safe AXI response              |
| Mode-change test              | Confirms filter selection works         |
| Coefficient test              | Confirms kernel and matrix loading      |
| Frame-safe update test        | Confirms updates occur only at boundary |
| Back-to-back transaction test | Confirms AXI4-Lite protocol stability   |

## 21.24 AXI4-Lite Protocol Verification

AXI4-Lite protocol verification should check:

- Write address handshake.

- Write data handshake.

- Write response generation.

- Read address handshake.

- Read data return.

- Reset behavior.

- Back-to-back reads and writes.

- Byte strobe behavior.

- Invalid address behavior.

- No deadlock under stalled ready/valid.

A UVM driver should generate:

single write

single read

write-readback

random register access

reserved register access

reset during transaction

back-to-back access

The scoreboard should compare expected register state with RTL readback.

## 21.25 Common Register Map Failure Modes

| **Failure Mode**             | **Likely Cause**                 | **Correction**                 |
|------------------------------|----------------------------------|--------------------------------|
| Register write has no effect | Wrong offset or missing decode   | Verify address map             |
| Readback mismatch            | Register not stored or wrong mux | Fix read mux and storage       |
| Mode changes mid-frame       | No frame-safe update             | Add active/shadow registers    |
| Reserved bits change         | Missing bit masking              | Mask reserved fields           |
| Error flags disappear        | Non-sticky status bits           | Use sticky W1C flags           |
| AXI transaction hangs        | Missing ready/valid response     | Verify AXI4-Lite FSM           |
| Coefficients swapped         | Wrong register order             | Confirm coefficient layout     |
| Threshold wrong scale        | 8-bit/10-bit mismatch            | Document threshold format      |
| Software writes active bank  | No shadow protection             | Restrict writes to shadow bank |

## 21.26 Hardware Design Recommendations

1.  **Use AXI4-Lite only for control and status.**  
    Pixel data should remain on AXI4-Stream or memory-mapped video paths.

2.  **Use 32-bit aligned register offsets.**  
    This simplifies software and AXI bus access.

3.  **Document every bit field.**  
    Register name and offset alone are not sufficient.

4.  **Use active/shadow registers for visible video changes.**  
    This prevents partial-frame artifacts.

5.  **Use W1C sticky error flags.**  
    Error information should not disappear before software reads it.

6.  **Provide readback for coefficients and mode settings.**  
    Software must confirm configuration state.

7.  **Mask reserved bits.**  
    Reserved bits should read as zero and ignore writes.

8.  **Verify AXI4-Lite protocol independently from video processing.**  
    Register access must remain reliable even when video is inactive.

## 21.27 Chapter Summary

This chapter described the Register Map and Control Interface for the FPGA Video Color Processing System. The VCP block uses AXI4-Lite for software-accessible control registers and AXI4-Stream for high-speed video pixel transport. The source document confirms that the VCP architecture uses AXI4-Lite configuration with AXI4-Stream video input/output and includes filters, color-space conversion, K-means quantization, and color-gain matrix functions.

The documented RTL register map includes control, filter selection, threshold, channel selection, kernel coefficient, color matrix, CPU handshake, FIFO, coordinate, luminance, HSV, and YCbCr diagnostic registers. A robust implementation should organize these registers into clear categories, define bit fields, support readback, protect live video through active/shadow updates, and verify all AXI4-Lite behavior through directed and randomized register tests.
