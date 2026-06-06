# Appendices

## Appendix A — Acronyms and Abbreviations

| **Term**    | **Meaning**                                   |
|-------------|-----------------------------------------------|
| ADC         | Analog-to-Digital Converter                   |
| AXI         | Advanced eXtensible Interface                 |
| AXI4-Lite   | Memory-mapped AXI control interface           |
| AXI4-Stream | Streaming AXI data interface                  |
| BMP         | Bitmap Image Format                           |
| BRAM        | Block RAM                                     |
| CDC         | Clock-Domain Crossing                         |
| CCM         | Color Correction Matrix                       |
| CSI-2       | Camera Serial Interface 2                     |
| DDR         | Double Data Rate Memory                       |
| DMA         | Direct Memory Access                          |
| D-PHY       | MIPI physical layer                           |
| DSP         | Digital Signal Processing / DSP slice         |
| EOF         | End of Frame                                  |
| EOL         | End of Line                                   |
| FPGA        | Field-Programmable Gate Array                 |
| FPS         | Frames Per Second                             |
| FF          | Flip-Flop                                     |
| GUI         | Graphical User Interface                      |
| HSL         | Hue, Saturation, Luminosity                   |
| HSV         | Hue, Saturation, Value                        |
| I2C         | Inter-Integrated Circuit                      |
| ILA         | Integrated Logic Analyzer                     |
| IP          | Intellectual Property / Internet Protocol     |
| K-Means     | Clustering algorithm using K reference groups |
| LUT         | Lookup Table                                  |
| MIPI        | Mobile Industry Processor Interface           |
| PL          | Programmable Logic                            |
| PS          | Processing System                             |
| RAW10       | 10-bit RAW Bayer pixel format                 |
| RGB         | Red, Green, Blue                              |
| RGB888      | 24-bit RGB, 8 bits per channel                |
| RGB565      | 16-bit RGB format                             |
| RTL         | Register Transfer Level                       |
| SOF         | Start of Frame                                |
| UDP         | User Datagram Protocol                        |
| UVM         | Universal Verification Methodology            |
| VCP         | Video Color Processing                        |
| VDMA        | Video Direct Memory Access                    |
| YCbCr       | Luma and chroma color space                   |

## Appendix B — Common Video Processing Equations

### B.1 Pixel Clock Frequency

Pixel Clock Frequency = Total Horizontal Samples × Total Vertical Lines × Refresh Rate

### B.2 Video Bandwidth

Bandwidth = Pixel Clock Frequency × Bits Per Pixel

### B.3 MIPI Line Rate

Line Rate = Total Data Rate / Number of Data Lanes

### B.4 Frame Size

Frame Size = Width × Height × Bytes Per Pixel

### B.5 RGB888 Frame Size

Frame Size = Width × Height × 3

### B.6 RGB565 Frame Size

Frame Size = Width × Height × 2

### B.7 DDR Bandwidth

DDR Write Bandwidth = Width × Height × Bytes Per Pixel × FPS

DDR Read Bandwidth = Width × Height × Bytes Per Pixel × FPS

Total DDR Bandwidth = DDR Write Bandwidth + DDR Read Bandwidth

### B.8 Pipeline Latency

Latency Cycles = Output Cycle − Input Cycle

Latency Time = Latency Cycles / Clock Frequency

## Appendix C — Example Video Mode Calculations

### C.1 1920×1080p60 RAW10, 2-Lane MIPI

Total Horizontal Samples = 2200

Total Vertical Lines = 1125

Refresh Rate = 60 Hz

Bits Per Pixel = 10

Number of Lanes = 2

Pixel Clock = 2200 × 1125 × 60

= 148.5 MHz

Bandwidth = 148.5 MHz × 10

= 1485 Mbps

Line Rate = 1485 Mbps / 2

= 742.5 Mbps per lane

### C.2 2560×1080p30 RAW10, 2-Lane MIPI

Pixel Clock = 3520 × 1125 × 30

= 118.8 MHz

Bandwidth = 118.8 MHz × 10

= 1188 Mbps

Line Rate = 1188 Mbps / 2

= 594 Mbps per lane

### C.3 3840×2160p30 RAW8, 4-Lane MIPI

Pixel Clock = 4400 × 2250 × 30

= 297 MHz

Bandwidth = 297 MHz × 8

= 2376 Mbps

Line Rate = 2376 Mbps / 4

= 594 Mbps per lane

## Appendix D — AXI4-Lite Register Map Summary

| **Register Name**    | **Offset** | **Purpose**                      |
|----------------------|------------|----------------------------------|
| initAddr             | 0x00       | Initialization/base control      |
| oRgbOsharp           | 0x00       | Sharp output/shared register     |
| oEdgeType            | 0x04       | Edge type control                |
| filter_id            | 0x08       | Active filter selection          |
| aBusSelect           | 0x0C       | Bus/path selection               |
| threshold            | 0x10       | Threshold value                  |
| videoChannel         | 0x14       | Video channel selection          |
| dChannel             | 0x18       | Display/destination channel      |
| cChannel             | 0x1C       | Color channel selection          |
| kls_k1–kls_k9        | 0x20–0x40  | 3×3 kernel coefficients          |
| kls_config           | 0x44       | Kernel configuration             |
| als_k1–als_k9        | 0x54–0x74  | Color matrix coefficients        |
| als_config           | 0x78       | Color matrix configuration       |
| pReg_pointInterest   | 0x7C       | Point-of-interest control        |
| pReg_deltaConfig     | 0x80       | Delta configuration              |
| pReg_cpuAckGoAgain   | 0x84       | CPU restart/continue acknowledge |
| pReg_cpuWgridLock    | 0x88       | Grid-lock control                |
| pReg_cpuAckoffFrame  | 0x8C       | Frame-off acknowledge            |
| pReg_fifoReadAddress | 0x90       | FIFO read address                |
| pReg_clearFifoData   | 0x94       | FIFO clear                       |
| rgbCoord_rl          | 0xC8       | Red coordinate low               |
| rgbCoord_rh          | 0xCC       | Red coordinate high              |
| rgbCoord_gl          | 0xD0       | Green coordinate low             |
| rgbCoord_gh          | 0xD4       | Green coordinate high            |
| rgbCoord_bl          | 0xD8       | Blue coordinate low              |
| rgbCoord_bh          | 0xDC       | Blue coordinate high             |
| oLumTh               | 0xE0       | Luminance threshold output       |
| oHsvPerCh            | 0xE4       | HSV per-channel output           |
| oYccPerCh            | 0xE8       | YCbCr per-channel output         |

## Appendix E — Recommended Filter ID Map

| **Filter ID** | **Processing Mode**                  |
|---------------|--------------------------------------|
| 0             | RGB bypass                           |
| 1             | Color gain / color correction        |
| 2             | Sharp filter                         |
| 3             | Blur filter                          |
| 4             | Emboss filter                        |
| 5             | Sobel edge detection                 |
| 6             | RGB to HSL                           |
| 7             | HSL to RGB                           |
| 8             | RGB to HSV                           |
| 9             | RGB to YCbCr                         |
| 10            | K-means clustering                   |
| 11            | Histogram mode                       |
| 12            | Local dynamic threshold segmentation |
| 13            | Test pattern                         |
| 14            | Programmable color scheme            |
| 15            | Reserved                             |

## Appendix F — Example 3×3 Kernel Coefficients

### F.1 Sharp Filter

0 -1 0

-1 5 -1

0 -1 0

### F.2 Blur Filter

1 1 1

1 1 1

1 1 1

Scale = 1/9

### F.3 Emboss Filter

-2 -1 0

-1 1 1

0 1 2

### F.4 Sobel Horizontal Kernel

-1 0 1

-2 0 2

-1 0 1

### F.5 Sobel Vertical Kernel

-1 -2 -1

0 0 0

1 2 1

## Appendix G — K-Means Reference Palette Example

### G.1 K = 6 Reference Palette

| **Index** | **Red** | **Green** | **Blue** |
|-----------|---------|-----------|----------|
| 1         | 230     | 170       | 120      |
| 2         | 70      | 40        | 35       |
| 3         | 150     | 200       | 130      |
| 4         | 20      | 25        | 10       |
| 5         | 75      | 150       | 180      |
| 6         | 15      | 30        | 60       |

### G.2 Euclidean Distance

D = (Rin − Rref)² + (Gin − Gref)² + (Bin − Bref)²

### G.3 Manhattan Distance

D = \|Rin − Rref\| + \|Gin − Gref\| + \|Bin − Bref\|

### G.4 Cluster Selection

Selected Cluster = Reference Color with Minimum Distance

## Appendix H — Recommended Performance Counters

| **Counter**          | **Description**                 |
|----------------------|---------------------------------|
| frame_in_count       | Number of frames entering VCP   |
| frame_out_count      | Number of frames leaving VCP    |
| pixel_in_count       | Number of accepted input pixels |
| pixel_out_count      | Number of output pixels         |
| line_count           | Number of lines per frame       |
| stall_cycle_count    | Number of stalled cycles        |
| fifo_overflow_count  | FIFO overflow events            |
| fifo_underflow_count | FIFO underflow events           |
| mipi_error_count     | MIPI CSI-2 error events         |
| vdma_error_count     | VDMA error events               |
| udp_packet_count     | UDP packets transmitted         |
| udp_byte_count       | UDP bytes transmitted           |
| mode_update_count    | Runtime processing-mode updates |
| error_status         | Sticky error summary            |

## Appendix I — Verification Checklist

| **Verification Area** | **Required Check**                                           |
|-----------------------|--------------------------------------------------------------|
| Reset                 | All registers and state machines reset correctly             |
| AXI4-Lite             | Read/write transactions complete correctly                   |
| Register map          | Offsets, bit fields, and readback values match specification |
| RGB bypass            | Output equals input after latency alignment                  |
| Filter modes          | Sharp, blur, emboss, and Sobel match reference model         |
| Color conversion      | RGB/HSL/HSV/YCbCr outputs match expected tolerance           |
| K-means               | Cluster output matches selected palette                      |
| Histogram             | Bin counts match input pixels                                |
| Local threshold       | Neighbor averaging follows threshold rule                    |
| Frame protocol        | SOF, EOL, EOF, valid, and sideband signals align             |
| Pipeline latency      | Expected and actual output timing match                      |
| UVM scoreboard        | All expected/actual comparisons pass                         |
| Image output          | Generated BMP files are valid                                |
| Coverage              | Major modes and corner cases are exercised                   |

## Appendix J — Deployment Checklist for Kria KV260

| **Step** | **Action**             | **Expected Result**          |
|----------|------------------------|------------------------------|
| 1        | Power KV260 board      | Board powers correctly       |
| 2        | Connect UART/JTAG      | Debug access available       |
| 3        | Program bitstream      | FPGA configuration succeeds  |
| 4        | Read status register   | AXI4-Lite path works         |
| 5        | Verify clocks          | Required PL clocks active    |
| 6        | Release resets         | VCP exits reset              |
| 7        | Configure sensor       | I2C writes succeed           |
| 8        | Verify MIPI lock       | CSI-2 receiver locks         |
| 9        | Enable demosaic        | RGB stream becomes valid     |
| 10       | Enable RGB bypass      | Unprocessed video appears    |
| 11       | Configure VDMA         | Frame buffers active         |
| 12       | Enable DisplayPort     | Monitor shows image          |
| 13       | Enable UDP             | Host receives frames         |
| 14       | Select processing mode | Filter/color effect visible  |
| 15       | Read counters          | No overflow/underflow errors |

## Appendix K — Ethernet UDP Configuration Example

| **Parameter**          | **Example Value**                          |
|------------------------|--------------------------------------------|
| Board IP               | 192.168.0.10                               |
| Host PC IP             | 192.168.0.42                               |
| Subnet Mask            | 255.255.255.0                              |
| Transport              | UDP                                        |
| Host Decoder           | FFmpeg / FFplay                            |
| Header Size            | 54 bytes for BMP-style stream header       |
| Recommended First Test | Reduced-resolution RGB or grayscale stream |

### K.1 UDP Deployment Notes

1\. Configure host static IP.

2\. Connect KV260 directly or through a switch.

3\. Confirm Ethernet link is active.

4\. Start host receiver.

5\. Enable board UDP transmitter.

6\. Verify packet counter.

7\. Verify frame counter.

8\. Confirm image display.

## Appendix L — Sensor Bring-Up Checklist

| **Step** | **Check**                | **Expected Result**        |
|----------|--------------------------|----------------------------|
| 1        | Camera cable orientation | Correctly seated           |
| 2        | Sensor power rails       | Stable                     |
| 3        | Reset release            | Sensor exits reset         |
| 4        | I2C sensor ID            | Correct ID read            |
| 5        | Register table write     | No I2C errors              |
| 6        | MIPI lane setting        | Matches receiver           |
| 7        | RAW format setting       | Matches receiver data type |
| 8        | Stream enable            | Sensor begins output       |
| 9        | MIPI receiver lock       | Link active                |
| 10       | Demosaic output          | RGB valid                  |
| 11       | Bayer phase              | Natural colors             |
| 12       | Frame dimensions         | Width/height correct       |
| 13       | Frame rate               | Matches selected mode      |

## Appendix M — Debug Failure Table

| **Symptom**              | **Likely Cause**                  | **Recommended Debug Step**              |
|--------------------------|-----------------------------------|-----------------------------------------|
| No video output          | Reset, clock, or stream disabled  | Check status counters and bypass mode   |
| AXI registers unreadable | Address map or interconnect issue | Verify base address and AXI connections |
| Camera not detected      | I2C, cable, reset, or power issue | Read sensor ID                          |
| MIPI not locked          | Lane count or lane rate mismatch  | Check sensor and CSI-2 settings         |
| Purple/green image       | Wrong Bayer phase                 | Change Bayer pattern setting            |
| Red/blue swapped         | RGB/BGR packing mismatch          | Check channel order                     |
| Image shifted            | Wrong stride or packet offset     | Verify frame format and line stride     |
| Sobel output too dense   | Threshold too low                 | Increase threshold                      |
| Sobel output missing     | Threshold too high                | Decrease threshold                      |
| K-means output poor      | Palette unsuitable or K too small | Adjust palette or increase K            |
| UDP image corrupt        | Packet loss or header mismatch    | Check packet order and 54-byte header   |
| Display tearing          | Buffer synchronization issue      | Use double/triple buffering             |
| Runtime flicker          | Mid-frame register update         | Use active/shadow frame-safe update     |

## Appendix N — Suggested File and Folder Structure

VideoColorProcessing_Project/

│

├── docs/

│ ├── architecture/

│ ├── register_map/

│ ├── verification/

│ ├── deployment/

│ └── results/

│

├── rtl/

│ ├── vcp/

│ ├── filters/

│ ├── color_space/

│ ├── kmeans/

│ ├── histogram/

│ └── interfaces/

│

├── sim/

│ ├── testbench/

│ ├── uvm/

│ ├── input_images/

│ ├── expected_images/

│ └── output_images/

│

├── vivado/

│ ├── bd/

│ ├── constraints/

│ ├── scripts/

│ └── reports/

│

├── vitis/

│ ├── platform/

│ ├── application/

│ └── drivers/

│

├── deployment/

│ ├── bitstream/

│ ├── boot/

│ ├── sensor_configs/

│ └── network/

│

└── results/

├── screenshots/

├── waveform/

├── performance/

└── validation_logs/

## Appendix O — Release Documentation Template

Project Name:

Release Version:

Designer:

Target Board:

FPGA Device:

Vivado Version:

Vitis Version:

Simulation Tool:

Supported Sensors:

Supported Resolutions:

Supported Output Modes:

Enabled VCP Features:

Known Limitations:

Bitstream File:

Software File:

Register Map Version:

Validation Date:

Validation Summary:

### O.1 Example Release Summary

Project Name: Video Color Processing

Designer: Sakinder Ali

Target Board: AMD/Xilinx Kria KV260

Primary Interfaces: MIPI CSI-2, AXI4-Stream, AXI4-Lite, VDMA, DisplayPort, Ethernet UDP

Primary Functions: Color conversion, filters, K-means, histogram, local threshold, UDP streaming

## Appendix P — Recommended Future Work List

1.  Add automated BMP/image comparison.

2.  Add active/shadow frame-safe register updates.

3.  Add hardware performance counters.

4.  Add same-bin forwarding for histogram updates.

5.  Add K-means Manhattan-distance mode.

6.  Add programmable palette bank switching.

7.  Add sensor abstraction layer.

8.  Add auto white balance.

9.  Add gamma correction.

10. Add black-level correction.

11. Add UDP packet sequence checking.

12. Add reduced-bandwidth RGB565 streaming mode.

13. Add GUI sliders for threshold, saturation, brightness, and palette selection.

14. Add scripted KV260 deployment flow.

15. Add automated validation report generation.

## Appendix Q — Final Technical Statement

The FPGA Video Color Processing System provides a modular platform for real-time camera capture, RGB processing, color-space transformation, filtering, clustering, histogram analysis, Ethernet streaming, and hardware deployment. The appendices summarize the supporting equations, register structures, verification procedures, deployment checklists, debug tables, and future engineering tasks required to maintain and extend the system.

These appendices are intended to serve as a practical engineering reference for implementation, verification, hardware bring-up, demonstration, publication, and future development.
