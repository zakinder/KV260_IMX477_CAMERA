# Chapter 24 — FPGA Implementation and Resource Considerations

## 24.1 Overview

FPGA implementation converts the verified RTL video-processing design into a placed, routed, timing-closed bitstream for the target hardware platform. For the FPGA Video Color Processing System, implementation must account for real-time video throughput, MIPI camera input, AXI4-Stream pixel transport, AXI4-Lite control, VDMA/DDR movement, DisplayPort or Ethernet output, and processing modules such as filters, color-space conversion, color correction, K-means clustering, histogram processing, and local segmentation.

The source design is based on a Raspberry Pi camera link running on the **Kria KV260** board. It captures RGB video through a MIPI interface, processes video data into AXI4-Stream, and outputs to Ethernet or DisplayPort. The source also states that one module was synthesized and implemented using **Vivado 2022.1** for the Kria KV260 board and verified using ModelSim 2020 Edition.

A high-level FPGA implementation flow is:

RTL Design

↓

Simulation and Verification

↓

Synthesis

↓

Implementation

↓

Timing Closure

↓

Bitstream Generation

↓

Hardware Bring-Up

↓

Resource and Performance Validation

## 24.2 Implementation Goals

The implementation stage must satisfy functional, timing, and resource goals.

| **Goal**                | **Description**                                                                 |
|-------------------------|---------------------------------------------------------------------------------|
| Functional preservation | Implemented netlist must match verified RTL behavior.                           |
| Timing closure          | All required clocks must meet setup and hold timing.                            |
| Throughput preservation | Video path must sustain one pixel per clock where required.                     |
| Resource efficiency     | LUT, FF, BRAM, DSP, and routing usage must remain within device limits.         |
| Interface stability     | MIPI, AXI4-Stream, AXI4-Lite, VDMA, and output interfaces must remain reliable. |
| Debug visibility        | Critical counters and internal states should remain observable.                 |
| Scalability             | Design should support multiple resolutions and optional processing modes.       |
| Live-video safety       | Runtime updates must not corrupt active frames.                                 |

A successful implementation is not only a bitstream that builds; it must meet timing, preserve video synchronization, and operate reliably on the board.

## 24.3 Target Platform Considerations

The documented system targets the Kria KV260 development platform. The platform includes programmable logic for camera capture and video processing, and processing-system resources for control, Ethernet, VDMA, and software interaction.

The system-level architecture includes:

Camera Sensor

↓

MIPI CSI-2 Receiver

↓

Demosaic

↓

Video Color Processing

↓

VDMA / DDR / DisplayPort / Ethernet

The source document states that VDMA transfers video streams to and from external memory under software control, and that DisplayPort sources live input video data from programmable logic.

Important platform considerations include:

| **Area**         | **Consideration**                                                             |
|------------------|-------------------------------------------------------------------------------|
| PL clocks        | Must support video processing, MIPI D-PHY, and video output domains.          |
| PS–PL interfaces | AXI HP/HPC/HPM ports must be configured for video and control bandwidth.      |
| DDR bandwidth    | Must support VDMA frame writes/reads without starving video.                  |
| Ethernet         | Must match intended streaming resolution and frame rate.                      |
| DisplayPort      | Requires correct timing and stream formatting.                                |
| I/O pins         | MIPI lane assignment and board connector routing must match sensor interface. |

## 24.4 Clock Domain Planning

The design uses multiple clocks. The source document states that a 100 MHz input clock feeds a clock generator that creates 300 MHz, 297 MHz, and 200 MHz clocks. It identifies 300 MHz for video AXI4 configuration and processing, 200 MHz for MIPI D-PHY video input, and 297 MHz for video output.

A representative clock-domain table is:

| **Clock Domain**       | **Example Frequency** | **Function**                           |
|------------------------|-----------------------|----------------------------------------|
| PS/PL base clock       | 100 MHz               | Base fabric reference and control      |
| Video processing clock | 300 MHz               | VCP pipeline and AXI4 video processing |
| MIPI D-PHY clock       | 200 MHz               | Camera input receiver path             |
| Video output clock     | 297 MHz               | Output timing path                     |
| AXI4-Lite clock        | 100–300 MHz           | Register access and control            |
| Ethernet/PS clock      | Platform-dependent    | UDP/IP and software-side transmission  |

Clock-domain planning must define:

- Which modules run in each domain.

- Which signals cross clock domains.

- Whether CDC uses FIFO, synchronizer, handshake, or dual-port memory.

- Which timing constraints apply to each clock.

- Which clock crossings should be marked as asynchronous.

## 24.5 Clock-Domain Crossing Considerations

Camera input, processing, DDR buffering, and output may operate in different clock domains. Directly transferring control or pixel data between unrelated clocks can cause metastability or intermittent corruption.

Recommended CDC methods:

| **Crossing Type**     | **Recommended Method**                 |
|-----------------------|----------------------------------------|
| Single-bit control    | Two-flop synchronizer                  |
| Multi-bit control     | Valid/ack handshake or shadow register |
| Pixel stream          | Dual-clock FIFO                        |
| Line buffer crossing  | Dual-port RAM with controlled pointers |
| Frame buffer crossing | VDMA/DDR memory interface              |
| Reset crossing        | Reset synchronizer per clock domain    |

CDC-related bugs often pass simulation but fail in hardware. Therefore, implementation should include CDC review, constraints, and hardware debug counters.

## 24.6 AXI4-Stream Datapath Resource Considerations

The AXI4-Stream datapath must preserve pixel throughput. For one pixel per clock, each processing stage must accept and produce a pixel every cycle after pipeline fill.

The source MIPI configuration identifies **Pixel Per Clock = 1** and TUSER width of 1 for both receiver configurations.

Important AXI4-Stream resource considerations include:

| **Item**             | **Resource Impact**                                      |
|----------------------|----------------------------------------------------------|
| Data width           | Wider pixels increase routing and register usage.        |
| Pipeline depth       | More stages increase FF usage but improve timing.        |
| Backpressure support | Requires buffering and ready/valid control.              |
| Sideband delay       | Requires registers for TUSER, TLAST, valid, coordinates. |
| Multi-mode muxing    | Adds LUTs and routing.                                   |
| Debug taps           | Add fanout and may affect timing.                        |

For high-resolution video, the datapath should be deeply pipelined rather than combinationally complex.

## 24.7 LUT Utilization

Lookup tables implement combinational logic, control, comparisons, muxes, fixed-point operations, address decoding, and small memories.

High LUT usage may come from:

- Large mode-selection muxes.

- K-means minimum-distance comparator trees.

- Saturation and clamp logic.

- AXI4-Lite register decode.

- Histogram hazard handling.

- Color-space conversion decision logic.

- Border handling for spatial filters.

- Runtime-selectable data paths.

Optimization methods:

| **Method**                                    | **Effect**                                      |
|-----------------------------------------------|-------------------------------------------------|
| Register large mux outputs                    | Improves timing and reduces routing pressure    |
| Partition modes into optional generate blocks | Removes unused logic                            |
| Use BRAM/LUTRAM for tables                    | Reduces LUT use                                 |
| Pipeline comparator trees                     | Improves timing                                 |
| Use shared arithmetic carefully               | Reduces LUT/DSP usage but may reduce throughput |
| Avoid excessive debug fanout                  | Improves routing                                |

## 24.8 Flip-Flop Utilization

Flip-flops are used for pipeline registers, sideband alignment, state machines, counters, and synchronization.

High FF usage is expected in a pipelined video design. This is usually acceptable if it improves timing closure.

Common FF consumers:

| **Resource Consumer**      | **Reason**                          |
|----------------------------|-------------------------------------|
| Pixel pipeline registers   | Maintain high clock rate            |
| Valid/sideband delay lines | Align control with pixel data       |
| AXI4-Lite registers        | Store software configuration        |
| Shadow/active banks        | Support frame-safe updates          |
| Coordinate counters        | Track x/y position                  |
| Debug counters             | Count frames, lines, pixels, errors |
| Synchronizers              | Clock-domain crossing safety        |

Resource-efficient design should keep only required debug counters in production builds.

## 24.9 BRAM and Memory Considerations

BRAM is important for line buffers, frame-control FIFOs, histogram bins, palette storage, and VDMA/DDR buffering support.

The source MIPI receiver configuration lists line-buffer defined data type depth of **4096**, which supports wide video-line buffering in the CSI-2 receive path.

Major BRAM consumers include:

| **Block**      | **Memory Use**                                      |
|----------------|-----------------------------------------------------|
| Line buffers   | Spatial filters, Sobel, demosaic, local threshold   |
| Histogram      | 256-bin counters, RGB or grayscale                  |
| Palette memory | K-means and programmable color schemes              |
| FIFO buffers   | CDC and packetization                               |
| Debug capture  | Sample buffers and trace memory                     |
| VDMA interface | External DDR, but internal buffering still required |

For 3×3 filters, line buffers are usually required. For 4K-width images, line buffers should be implemented using BRAM rather than long shift-register chains.

## 24.10 DSP Utilization

DSP blocks are used for multiply-accumulate operations and fixed-point arithmetic.

DSP-heavy modules include:

| **Module**                 | **DSP Demand**                                  |
|----------------------------|-------------------------------------------------|
| Color correction matrix    | 9 multipliers for full parallel 3×3 matrix      |
| RGB/HSL/HSV conversion     | Divisions and scaling, depending implementation |
| HSL/RGB inverse conversion | Multipliers and interpolation                   |
| K-means Euclidean distance | Squaring operations for each centroid           |
| Convolution filters        | Kernel multiplications                          |
| Weighted luminance         | RGB coefficient multiplication                  |
| Histogram equalization     | CDF scaling if implemented in hardware          |

Optimization methods:

| **Method**                            | **Benefit**                             |
|---------------------------------------|-----------------------------------------|
| Use Manhattan distance for K-means    | Avoids squared-distance multipliers     |
| Use shift-add coefficients            | Reduces DSP usage                       |
| Time-multiplex multipliers            | Saves DSPs but lowers throughput        |
| Pipeline DSP operations               | Improves timing                         |
| Use constant coefficient optimization | Allows synthesis to simplify arithmetic |
| Use fixed-point formats               | Avoids expensive floating-point logic   |

For one-pixel-per-clock operation, full parallel arithmetic is often required unless the internal clock runs at a higher multiple of the pixel rate.

## 24.11 K-Means Resource Considerations

K-means clustering can become one of the most resource-intensive blocks when K is large. Each pixel must be compared against K reference colors.

Resource scaling:

Distance engines ≈ K

Comparator inputs ≈ K

Palette entries = K

For Euclidean squared distance:

Dk = (Rin - Rk)² + (Gin - Gk)² + (Bin - Bk)²

This requires subtractors, squaring logic, adders, and a minimum comparator tree for each centroid.

For Manhattan distance:

Dk = \|Rin - Rk\| + \|Gin - Gk\| + \|Bin - Bk\|

This removes multipliers and is usually more resource-efficient.

Implementation guidance:

| **K Mode** | **Recommended Architecture**                      |
|------------|---------------------------------------------------|
| 6          | Fully parallel distance and compare               |
| 9          | Fully parallel distance and compare               |
| 24         | Fully parallel or partially pipelined             |
| 51         | Pipelined comparator tree required                |
| 90         | Strong pipelining or partial parallelism required |

## 24.12 Spatial Filter Resource Considerations

Spatial filters such as sharp, blur, emboss, Sobel, and local threshold require neighboring pixels. This creates memory and routing demands.

Main resource costs:

| **Resource**       | **Use**                                |
|--------------------|----------------------------------------|
| BRAM               | Line buffers                           |
| LUT/FF             | Shift-register taps and control        |
| DSP/LUT arithmetic | Kernel multiplication and accumulation |
| Comparators        | Threshold and edge decisions           |
| Sideband registers | Latency alignment                      |

For a 3×3 filter:

Required rows = 3

Required taps = 9 pixels

The design should use shared window-generation infrastructure where possible. Multiple filters can reuse the same 3×3 window generator and select different kernels.

## 24.13 Color-Space Conversion Resource Considerations

Color-space conversion modules can be arithmetic-heavy.

| **Conversion** | **Resource Risk**                        |
|----------------|------------------------------------------|
| RGB to HSL     | Max/min, division, conditional hue logic |
| HSL to RGB     | Region selection and interpolation       |
| RGB to YCbCr   | Multiply-add coefficient matrix          |
| RGB to HSV     | Max/min and saturation/hue scaling       |
| RGB to CMYK    | Division and subtractive color logic     |

Optimization strategies:

- Replace division with reciprocal lookup where practical.

- Use fixed-point arithmetic.

- Pipeline max/min and arithmetic stages.

- Use shared max/min logic for HSL/HSV.

- Use coefficient shifts for approximate luminance.

- Clamp outputs after arithmetic.

## 24.14 Histogram Resource Considerations

Histogram processing requires counters and read-modify-write logic.

For an 8-bit histogram:

Bins = 256

Counter width ≥ ceil(log2(width × height + 1))

Potential resource concerns:

| **Concern**      | **Impact**                        |
|------------------|-----------------------------------|
| 32-bit counters  | Increase BRAM/register width      |
| RGB histograms   | Triple memory requirement         |
| Same-bin hazards | Require forwarding or cache logic |
| Ping-pong banks  | Double memory requirement         |
| Software readout | Requires read port or arbitration |

For real-time video, ping-pong histogram banks are recommended so one bank accumulates while the other is read or cleared.

## 24.15 VDMA and DDR Bandwidth

VDMA moves video frames between AXI4-Stream and external DDR memory. The source document states that VDMA converts demosaic video stream data to AXI4 memory-mapped format and DDR fetching/decoding/execution through the AXI_HP interface. It also describes VDMA as a DMA used for video and image applications with AXI4 memory-mapped read and write channels.

DDR bandwidth must support:

- Frame write from camera/VCP.

- Frame read for DisplayPort.

- Frame read for UDP packetization.

- Possible software access.

- Cache maintenance overhead.

- Multiple frame buffers if enabled.

Bandwidth equation:

Frame bandwidth = width × height × bytes_per_pixel × frames_per_second

If VDMA or DDR is undersized, symptoms include frame tearing, dropped frames, stale frames, or DMA underflow/overflow.

## 24.16 Timing Closure Strategy

Timing closure is one of the most important implementation tasks.

Recommended timing strategy:

| **Strategy**                        | **Reason**                              |
|-------------------------------------|-----------------------------------------|
| Pipeline arithmetic                 | Reduces combinational delay             |
| Register module boundaries          | Improves placement and timing isolation |
| Constrain clocks accurately         | Enables meaningful timing reports       |
| Mark false/asynchronous CDC paths   | Prevents invalid timing analysis        |
| Limit high-fanout controls          | Reduces routing delay                   |
| Use retiming where safe             | Allows synthesis to optimize pipelines  |
| Floorplan critical blocks if needed | Reduces long routing paths              |
| Avoid over-wide combinational muxes | Improves Fmax                           |

Common critical paths include:

- K-means comparator tree.

- HSL/HSV division and hue logic.

- CCM multiply-accumulate path.

- Sobel magnitude calculation.

- Large mode-selection muxes.

- AXI4-Lite register decode feeding many modules.

- Palette and coefficient update muxes.

## 24.17 Pipeline Strategy

A real-time video design should use pipeline stages to meet the pixel clock requirement.

A typical processing pipeline is:

Input Register

↓

Preprocess / Unpack

↓

Arithmetic Stage 1

↓

Arithmetic Stage 2

↓

Compare / Select

↓

Clamp / Format

↓

Output Register

Pipeline benefits:

| **Benefit**           | **Description**                         |
|-----------------------|-----------------------------------------|
| Higher Fmax           | Shorter logic between registers         |
| Deterministic latency | Fixed delay through the block           |
| Easier timing closure | Critical paths are localized            |
| Better throughput     | One pixel per clock after pipeline fill |

Pipeline cost:

- More flip-flops.

- More sideband delay registers.

- More latency.

- More verification alignment requirements.

## 24.18 Sideband and Control Alignment

Every pipeline stage that delays pixel data must also delay sideband signals.

Sideband signals include:

- valid

- sof

- eol

- eof

- tuser

- tlast

- Pixel coordinates

- Frame/line counters

- Cluster index valid

- Histogram update valid

A sideband mismatch can produce a visually corrupted frame even when pixel arithmetic is correct.

Recommended rule:

pixel_latency == sideband_latency

A sideband delay module should be reusable across VCP processing blocks.

## 24.19 Build-Time Feature Selection

The source document describes filters and color-space functions that can be enabled before build, including Color Correction Matrix, K-means Color Clustering, Test Pattern, Sharp, Blur, Emboss, Sobel, Contrast, and color-space conversions.

Build-time feature selection reduces resource usage by removing unused modules.

Example configuration approach:

parameter ENABLE_SOBEL = 1;

parameter ENABLE_HSL = 1;

parameter ENABLE_KMEANS = 0;

parameter ENABLE_CCM = 1;

Advantages:

| **Advantage**        | **Description**                                        |
|----------------------|--------------------------------------------------------|
| Lower resource usage | Unused logic is not synthesized                        |
| Better timing        | Fewer muxes and shorter routes                         |
| Smaller bitstream    | Reduced implemented logic                              |
| Easier debug         | Fewer active blocks                                    |
| Targeted builds      | Create separate demo, debug, and production bitstreams |

## 24.20 Runtime Feature Selection

Runtime selection allows software to change processing modes without rebuilding the FPGA.

Runtime selection requires:

- Register-controlled mode muxes.

- Active/shadow registers.

- Frame-safe update logic.

- Bypass path.

- Status readback.

- Error handling.

Resource cost:

| **Runtime Feature** | **Cost**           |
|---------------------|--------------------|
| Mode mux            | LUTs and routing   |
| Shadow registers    | FFs                |
| Active bank         | FFs or BRAM        |
| Update controller   | FSM logic          |
| Readback registers  | Register mux logic |

For production, use runtime selection only for features that must change during operation. Use build-time selection for optional experimental blocks.

## 24.21 Resource Optimization Checklist

| **Area**      | **Optimization**                                      |
|---------------|-------------------------------------------------------|
| K-means       | Use Manhattan distance or pipeline Euclidean distance |
| CCM           | Use fixed-point DSP pipeline                          |
| HSL/HSV       | Use reciprocal LUTs or staged division                |
| Filters       | Share 3×3 window generator                            |
| Histogram     | Use BRAM counters and ping-pong banks                 |
| Palettes      | Store in BRAM or LUTRAM                               |
| Register map  | Use clean address decode and avoid huge fanout        |
| Debug         | Compile debug counters conditionally                  |
| CDC           | Use FIFOs instead of wide direct synchronizers        |
| Output format | Reduce pixel width when Ethernet bandwidth is limited |

## 24.22 Implementation Reports to Review

After synthesis and implementation, review the following reports:

| **Report**         | **Purpose**                             |
|--------------------|-----------------------------------------|
| Utilization report | LUT, FF, BRAM, DSP usage                |
| Timing summary     | WNS, TNS, WHS, setup/hold status        |
| Clock utilization  | Clock buffers and clock routing         |
| Power report       | Dynamic and static power                |
| CDC report         | Unsafe clock-domain crossings           |
| DRC report         | Design-rule violations                  |
| Methodology report | Tool-recommended improvements           |
| Route status       | Congestion and routing issues           |
| IO report          | Pin assignment and electrical standards |

Important timing metrics:

WNS ≥ 0 → setup timing closed

WHS ≥ 0 → hold timing closed

TNS = 0 → no total negative setup slack

THS = 0 → no total negative hold slack

## 24.23 Resource Budget Planning

A resource budget should be created before implementation.

Example budget table:

| **Block**       | **LUT**   | **FF**    | **BRAM**  | **DSP**     | **Notes**                      |
|-----------------|-----------|-----------|-----------|-------------|--------------------------------|
| MIPI CSI-2 RX   | Medium    | Medium    | Medium    | Low         | Vendor IP                      |
| Demosaic        | Medium    | Medium    | Medium    | Medium      | Depends on quality             |
| VCP control     | Low       | Medium    | Low       | Low         | Registers and FSMs             |
| Spatial filters | Medium    | Medium    | High      | Medium      | Line buffers                   |
| HSL/HSV         | Medium    | Medium    | Low       | Medium      | Division/scaling               |
| CCM             | Low       | Medium    | Low       | High        | 3×3 multiply matrix            |
| K-means         | High      | High      | Low       | Medium/High | Depends on K and metric        |
| Histogram       | Low       | Medium    | Medium    | Low         | Bin counters                   |
| VDMA interface  | Vendor IP | Vendor IP | Vendor IP | Vendor IP   | DDR movement                   |
| Debug/ILA       | Variable  | Variable  | Variable  | Low         | Remove in production if needed |

This table should be replaced with actual Vivado utilization numbers after implementation.

## 24.24 Power Considerations

Video-processing pipelines toggle heavily because pixels arrive continuously.

Power contributors:

| **Contributor**         | **Reason**                     |
|-------------------------|--------------------------------|
| High pixel clock        | Frequent switching             |
| Wide data buses         | Many bits toggle per pixel     |
| Parallel K-means        | Many distance engines active   |
| DSP pipelines           | Multiply-accumulate switching  |
| BRAM line buffers       | Continuous read/write activity |
| VDMA/DDR                | High memory bandwidth          |
| Debug cores             | Additional probes and buffers  |
| Ethernet/Display output | Continuous I/O switching       |

Power reduction methods:

- Disable unused processing modules.

- Gate updates when pixels are invalid.

- Use clock enables instead of unnecessary toggling.

- Use build-time feature removal.

- Reduce frame rate or resolution for low-power modes.

- Avoid unnecessary debug cores in final builds.

## 24.25 Floorplanning and Placement

Most designs can be implemented without manual floorplanning at first. However, floorplanning may help if timing or congestion fails.

Potential floorplanning strategy:

| **Region**                  | **Suggested Placement**                      |
|-----------------------------|----------------------------------------------|
| MIPI receiver               | Near relevant I/O and D-PHY resources        |
| Demosaic and early pipeline | Near camera input path                       |
| VCP arithmetic              | Central PL logic for routing balance         |
| BRAM line buffers           | Near filter processing logic                 |
| VDMA interface              | Near AXI/DDR interconnect path               |
| Debug ILA                   | Near probed signals but not on critical path |

Floorplanning should be applied only after reviewing timing and congestion reports.

## 24.26 Hardware Debug Resource Tradeoffs

Debug cores are useful but consume resources.

| **Debug Feature**        | **Resource Cost**                   | **Benefit**                |
|--------------------------|-------------------------------------|----------------------------|
| ILA probes               | BRAM + routing                      | Internal signal visibility |
| Debug counters           | FF + LUT                            | Low-cost runtime status    |
| Frame capture FIFO       | BRAM                                | Pixel-level inspection     |
| Register readback        | LUT + mux                           | Software observability     |
| Assertions in simulation | No hardware cost unless synthesized | Early bug detection        |

Recommended practice:

- Keep low-cost counters in production.

- Use ILA only in debug bitstreams.

- Keep debug probe fanout low.

- Remove unused debug logic before final timing closure.

## 24.27 Hardware Bring-Up Sequence

A practical bring-up sequence is:

1\. Program bitstream.

2\. Verify clocks are alive.

3\. Verify resets release.

4\. Read VCP status registers.

5\. Enable RGB bypass.

6\. Enable test pattern.

7\. Enable camera input.

8\. Verify demosaic output.

9\. Enable one filter at a time.

10\. Verify DisplayPort output.

11\. Verify Ethernet UDP output.

12\. Check error/status counters.

Bring-up should proceed from simple to complex. Complex modes such as K-means, histogram, and UDP streaming should be enabled only after base RGB video is stable.

## 24.28 Common Implementation Failure Modes

| **Failure Mode**                 | **Likely Cause**                              | **Correction**                                     |
|----------------------------------|-----------------------------------------------|----------------------------------------------------|
| Timing failure                   | Long arithmetic or comparator path            | Add pipeline stages                                |
| High LUT usage                   | Large muxes or comparator trees               | Partition logic or reduce runtime selection        |
| High BRAM usage                  | Multiple line buffers or histogram banks      | Share buffers or reduce feature set                |
| High DSP usage                   | Parallel multipliers                          | Use fixed coefficients, shift-add, or time-sharing |
| Video unstable                   | CDC or timing violation                       | Add FIFO/synchronizers and review constraints      |
| Output shifted                   | Sideband latency mismatch                     | Align control and data pipelines                   |
| VDMA underflow                   | DDR bandwidth or stride mismatch              | Verify bandwidth and frame-buffer settings         |
| MIPI not locking                 | Lane count or rate mismatch                   | Correct sensor and CSI-2 configuration             |
| Bitstream builds but no image    | Reset, clock, or register configuration issue | Check status counters and simple bypass mode       |
| Hardware differs from simulation | CDC, timing, or uninitialized state           | Review CDC, constraints, and reset behavior        |

## 24.29 Implementation Sign-Off Checklist

Before releasing the FPGA build, confirm:

| **Item**                                      | **Required Status** |
|-----------------------------------------------|---------------------|
| Synthesis completes without critical warnings |                     |
| Implementation completes successfully         |                     |
| Setup timing passes                           |                     |
| Hold timing passes                            |                     |
| Clock constraints are correct                 |                     |
| CDC paths reviewed                            |                     |
| DRC clean or justified                        |                     |
| Utilization within device budget              |                     |
| Power within board limits                     |                     |
| VCP register readback works                   |                     |
| RGB bypass mode works                         |                     |
| Camera input validated                        |                     |
| Display or Ethernet output validated          |                     |
| Processing modes validated                    |                     |
| Debug counters checked                        |                     |
| Known limitations documented                  |                     |

## 24.30 Chapter Summary

This chapter described FPGA implementation and resource considerations for the FPGA Video Color Processing System. The design targets the Kria KV260 platform, uses MIPI camera input, processes video through AXI4-Stream, supports AXI4-Lite control, and outputs through DisplayPort or Ethernet. The source design identifies the KV260-based camera/video path and explains that VCP maintains control registers and local buffers while processing pixel streams through filters and color-space functions.

Successful FPGA implementation requires careful planning for clock domains, timing closure, pipeline depth, sideband alignment, line buffers, DSP usage, K-means scaling, histogram memory, VDMA/DDR bandwidth, runtime feature selection, debug visibility, and resource optimization. A production-quality build should close timing, remain within utilization limits, validate all active interfaces, and provide enough diagnostic visibility for reliable hardware bring-up.
