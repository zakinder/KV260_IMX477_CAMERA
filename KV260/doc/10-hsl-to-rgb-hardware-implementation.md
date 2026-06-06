# Chapter 10 — HSL to RGB Hardware Implementation

## 10.1 Overview

The **HSL to RGB hardware implementation** converts hue, saturation, and luminosity data back into red, green, and blue pixel values. This conversion is required when the video-processing pipeline performs intermediate operations in HSL space but must return the final image to a standard RGB stream for display, Ethernet streaming, memory buffering, or additional RGB-domain processing.

The source design identifies an HSL-to-RGB module with clock, reset, input HSL channel, and output RGB channel interfaces. It also identifies the module as part of the Video Color Processing color-space conversion flow.

At a high level, the HSL-to-RGB block performs the reverse operation of the RGB-to-HSL block:

HSL Input Stream

↓

Hue Sector Decode

↓

Saturation / Luminosity Expansion

↓

Intermediate Color Component Calculation

↓

RGB Channel Reconstruction

↓

Output Clamp

↓

RGB Output Stream

The module must preserve real-time video timing, valid-pixel alignment, and stream synchronization while converting each HSL pixel into an RGB pixel.

## 10.2 Purpose of HSL to RGB Conversion

HSL is useful for modifying image properties such as hue, saturation, and brightness-like intensity. However, most display and output interfaces expect RGB-formatted pixels. Therefore, once HSL-domain processing is complete, the design must reconstruct RGB values.

The HSL-to-RGB block supports:

| **Function**             | **Description**                                            |
|--------------------------|------------------------------------------------------------|
| Display output           | Converts HSL-processed pixels into RGB display pixels.     |
| Round-trip processing    | Allows RGB → HSL → processing → RGB conversion.            |
| Saturation control       | Applies saturation-domain changes before returning to RGB. |
| Hue adjustment           | Enables hue shifting or color remapping.                   |
| Diagnostic visualization | Converts selected HSL values into RGB-compatible output.   |
| Pipeline compatibility   | Restores RGB format for downstream VCP modules.            |

The output of this block should be a valid RGB stream that can be routed into DisplayPort, Ethernet UDP streaming, VDMA, or additional RGB-domain processing logic.

## 10.3 HSL Input Representation

The HSL input stream uses three channel fields:

InputHSL = (H, S, L)

Where:

| **Component** | **Description**               |
|---------------|-------------------------------|
| H             | Hue value                     |
| S             | Saturation value              |
| L             | Luminosity or lightness value |

For the implementation style used in the previous RGB-to-HSL chapter, these components are stored as 8-bit values:

H ∈ \[0, 255\]

S ∈ \[0, 255\]

L ∈ \[0, 255\]

The original document describes 8-bit input and output channel fields and valid signals for the color-space conversion modules.

Because the RGB-to-HSL implementation uses hue ranges mapped into 8-bit regions, the HSL-to-RGB conversion should use the same scaling model so that round-trip conversion remains consistent.

## 10.4 Output RGB Representation

The output RGB pixel is represented as:

OutputRGB = (R, G, B)

Where:

| **Component** | **Description**             |
|---------------|-----------------------------|
| R             | Reconstructed red channel   |
| G             | Reconstructed green channel |
| B             | Reconstructed blue channel  |

For 8-bit output:

R, G, B ∈ \[0, 255\]

A typical AXI4-Stream RGB packing format is:

TDATA\[23:16\] = R

TDATA\[15:8\] = G

TDATA\[7:0\] = B

The HSL-to-RGB block must output channel values that are clamped to the valid range before packing.

## 10.5 Module Interface

The HSL-to-RGB block includes a reference clock, reset, HSL input channel, RGB output channel, and valid-signal handling. The source document lists i_data_width, clk, reset, iHsl, and oRgb as part of the HSL-to-RGB module interface.

### 10.5.1 Input Interface

| **Signal**      | **Width** | **Description**                              |
|-----------------|-----------|----------------------------------------------|
| clk             | 1         | Reference clock for stream processing.       |
| reset           | 1         | Module reset signal.                         |
| iHsl.hue        | 8 bits    | Input hue component.                         |
| iHsl.saturation | 8 bits    | Input saturation component.                  |
| iHsl.luminosity | 8 bits    | Input luminosity/lightness component.        |
| iHsl.valid      | 1         | Indicates that the input HSL pixel is valid. |

### 10.5.2 Output Interface

| **Signal** | **Width** | **Description**                               |
|------------|-----------|-----------------------------------------------|
| oRgb.red   | 8 bits    | Reconstructed red channel.                    |
| oRgb.green | 8 bits    | Reconstructed green channel.                  |
| oRgb.blue  | 8 bits    | Reconstructed blue channel.                   |
| oRgb.valid | 1         | Indicates that the output RGB pixel is valid. |

The exact signal naming should be aligned with the project’s channel-record definitions and AXI wrapper conventions.

## 10.6 AXI4-Stream Integration

The source design indicates that the HSL-to-RGB module is intended for insertion into an image-processing pipeline using a standard Xilinx AXI4-Stream style interface.

A practical AXI4-Stream wrapper should connect the module as follows:

s_axis_tdata

↓

HSL unpack

↓

HSL to RGB core

↓

RGB pack

↓

m_axis_tdata

Control and sideband signals should be handled as:

s_axis_tvalid → valid delay pipeline → m_axis_tvalid

s_axis_tuser → sideband delay → m_axis_tuser

s_axis_tlast → sideband delay → m_axis_tlast

s_axis_tready ← flow-control logic

The wrapper must preserve:

- Pixel ordering.

- Frame-start alignment.

- Line-end alignment.

- Valid-signal timing.

- Backpressure behavior.

- Reset behavior.

## 10.7 HSL Scaling Assumptions

For this hardware implementation, HSL values are assumed to use an 8-bit fixed-point-compatible range.

| **Component** | **Range** | **Interpretation**                           |
|---------------|-----------|----------------------------------------------|
| H             | 0–255     | Hue around the color wheel                   |
| S             | 0–255     | Saturation from grayscale to fully saturated |
| L             | 0–255     | Luminosity / value-style intensity           |

The RGB-to-HSL module described earlier uses hue regions corresponding to red, green, and blue dominant color zones: red in the lower hue region, green in the middle region, and blue in the upper hue region.

A compatible HSL-to-RGB decoder should therefore divide hue into hardware-friendly regions.

## 10.8 Hue Sector Classification

Hue controls which RGB channels are dominant. In a full HSL model, hue rotates through six major color sectors:

| **Sector** | **Approx. 8-Bit Hue Range** | **Dominant Transition** |
|------------|-----------------------------|-------------------------|
| 0          | 0–42                        | Red → Yellow            |
| 1          | 43–85                       | Yellow → Green          |
| 2          | 86–127                      | Green → Cyan            |
| 3          | 128–171                     | Cyan → Blue             |
| 4          | 172–212                     | Blue → Magenta          |
| 5          | 213–255                     | Magenta → Red           |

This six-sector model matches the cylindrical HSL concept where hue transitions through red, orange, yellow, green, cyan, blue, and magenta. The source document describes HSL as cylindrical geometry with hue transitioning through these color regions.

A hardware sector decoder can be implemented with comparators:

if H \<= 42:

sector = 0

else if H \<= 85:

sector = 1

else if H \<= 127:

sector = 2

else if H \<= 171:

sector = 3

else if H \<= 212:

sector = 4

else:

sector = 5

Each sector determines the ordering of the reconstructed RGB components.

## 10.9 Chroma Calculation

The first major reconstruction value is **chroma**, which represents the intensity of color relative to the luminosity value.

For a hardware-friendly value-style HSL/HSV-compatible model:

C = (L × S) / 255

Where:

- C is chroma.

- L is luminosity or value-style intensity.

- S is saturation.

If saturation is zero:

C = 0

The output should become grayscale:

R = L

G = L

B = L

This is an important edge case because hue has no visible effect when saturation is zero.

## 10.10 Intermediate X Calculation

The second intermediate value is X, which controls the transition between two color channels inside each hue sector.

A common sector-based expression is:

X = C × (1 - \|((H_sector_position mod 2) - 1)\|)

For FPGA implementation, this should be converted into integer arithmetic.

A practical 8-bit approach is:

sector_pos = H position within current sector

ramp = scaled sector_pos from 0 to 255

if sector is even:

X = (C × ramp) / 255

else:

X = (C × (255 - ramp)) / 255

This produces a rising or falling transition between adjacent primary/secondary colors.

## 10.11 Match / Base Offset Calculation

After chroma is calculated, a base offset is added so that the final RGB channels match the desired luminosity.

For value-style conversion:

M = L - C

Then:

R = R′ + M

G = G′ + M

B = B′ + M

Where R′, G′, and B′ are temporary sector-based values chosen from C, X, and 0.

This model ensures that the strongest reconstructed channel reaches approximately L.

## 10.12 Sector-Based RGB Reconstruction

The HSL-to-RGB block reconstructs temporary RGB values based on the hue sector.

| **Sector** | **Hue Range**  | **R′** | **G′** | **B′** |
|------------|----------------|--------|--------|--------|
| 0          | Red → Yellow   | C      | X      | 0      |
| 1          | Yellow → Green | X      | C      | 0      |
| 2          | Green → Cyan   | 0      | C      | X      |
| 3          | Cyan → Blue    | 0      | X      | C      |
| 4          | Blue → Magenta | X      | 0      | C      |
| 5          | Magenta → Red  | C      | 0      | X      |

Final output channels:

Rout = clamp(R′ + M)

Gout = clamp(G′ + M)

Bout = clamp(B′ + M)

This reconstruction provides a straightforward hardware path using comparators, subtractors, multipliers, adders, and clamp logic.

## 10.13 Grayscale Case

When saturation is zero, the output should be grayscale. Hue should be ignored because a desaturated pixel has no meaningful hue.

if S == 0:

R = L

G = L

B = L

This condition must be handled before hue-sector reconstruction or must override the sector output.

Examples:

| **H** | **S** | **L** | **Output**   |
|-------|-------|-------|--------------|
| Any   | 0     | 0     | Black        |
| Any   | 0     | 128   | Neutral gray |
| Any   | 0     | 255   | White        |

This prevents random or unstable colors in gray regions.

## 10.14 Black and White Edge Cases

The block should explicitly handle black and white cases.

**Black**

if L == 0:

R = 0

G = 0

B = 0

**White or Maximum Gray**

if S == 0 and L == 255:

R = 255

G = 255

B = 255

These cases also reduce unnecessary arithmetic in the datapath and improve output stability.

## 10.15 Fixed-Point Arithmetic

HSL-to-RGB conversion should be implemented using fixed-point or integer arithmetic.

### 10.15.1 Multiplication Scaling

For 8-bit components:

C = (L × S) / 255

X = (C × ramp) / 255

A hardware approximation can use division by 256:

C ≈ (L × S) \>\> 8

X ≈ (C × ramp) \>\> 8

For better accuracy, use a rounded form:

C = ((L × S) + 127) / 255

X = ((C × ramp) + 127) / 255

Or a multiply-shift approximation:

value_div255 ≈ (value + (value \>\> 8) + 128) \>\> 8

### 10.15.2 Intermediate Width

For 8-bit inputs:

| **Signal** | **Recommended Width**                            |
|------------|--------------------------------------------------|
| H, S, L    | 8 bits                                           |
| L × S      | 16 bits                                          |
| C × ramp   | 16 bits                                          |
| M = L - C  | 9 bits signed or 8 bits unsigned with protection |
| Final RGB  | 8 bits                                           |

Using wider intermediate signals prevents overflow and preserves precision.

## 10.16 Hardware Pipeline Stages

A practical HSL-to-RGB pipeline can be divided into deterministic stages.

| **Stage** | **Function**                          |
|-----------|---------------------------------------|
| Stage 0   | Register input HSL and valid signal   |
| Stage 1   | Decode hue sector and sector position |
| Stage 2   | Calculate chroma C                    |
| Stage 3   | Calculate ramp and intermediate X     |
| Stage 4   | Calculate match value M               |
| Stage 5   | Select temporary R′G′B′ values        |
| Stage 6   | Add M to each temporary channel       |
| Stage 7   | Clamp and register final RGB output   |

A possible pipeline flow is:

HSL In

→ Sector Decode

→ Chroma Calculation

→ Ramp / X Calculation

→ Match Calculation

→ RGB Temporary Select

→ Add / Clamp

→ RGB Out

Pipeline registers should be inserted between arithmetic stages to meet timing at video-processing clock rates.

## 10.17 Valid Signal Alignment

The valid signal must be delayed by the same number of cycles as the HSL-to-RGB datapath.

HSL data pipeline: P0 → P1 → P2 → P3 → P4 → P5 → P6

Valid pipeline: V0 → V1 → V2 → V3 → V4 → V5 → V6

The output valid signal is:

oRgb.valid = delayed_iHsl.valid

If the conversion block is wrapped in AXI4-Stream, then TVALID, TUSER, and TLAST must also be delayed through matching sideband pipelines.

## 10.18 Sideband Signal Alignment

The following signals require latency matching:

| **Signal**        | **Alignment Requirement**                              |
|-------------------|--------------------------------------------------------|
| TVALID            | Must align with the corresponding output RGB pixel.    |
| TUSER             | Must remain aligned with the first pixel of the frame. |
| TLAST             | Must remain aligned with the last pixel of the line.   |
| Pixel coordinates | Must align if used for debug or downstream operations. |

Generic sideband delay structure:

tuser_delay\[N:1\] \<= tuser_delay\[N-1:0\]

tlast_delay\[N:1\] \<= tlast_delay\[N-1:0\]

tvalid_delay\[N:1\] \<= tvalid_delay\[N-1:0\]

Output sideband signals are selected from the final delay stage.

## 10.19 Output Clamping

All reconstructed RGB values must be clamped to the valid range.

For 8-bit output:

if value \< 0:

output = 0

else if value \> 255:

output = 255

else:

output = value

Clamping prevents:

- Negative values from subtract operations.

- Overflow from fixed-point approximation.

- Invalid values from saturation or hue edge cases.

- Wraparound artifacts during output packing.

The clamp stage should be placed immediately before the final output register.

## 10.20 Throughput Requirement

The target throughput for real-time video is one output RGB pixel per clock after pipeline fill:

Throughput = 1 pixel / clock

To sustain this throughput:

- Sector decode must accept a new pixel every cycle.

- Chroma multiplication must be pipelined.

- X calculation must be pipelined.

- RGB selection logic must not create a long combinational path.

- Output clamp must be registered.

- AXI4-Stream backpressure must be handled correctly.

If the HSL-to-RGB block is used in a high-resolution stream such as 3840×2160p30, the design must meet the required video-processing clock and avoid sustained stalls.

## 10.21 Latency Model

The latency of the HSL-to-RGB block is deterministic. A representative latency model is:

| **Block**              | **Example Latency** |
|------------------------|---------------------|
| Input register         | 1 cycle             |
| Hue sector decode      | 1 cycle             |
| Chroma calculation     | 1–2 cycles          |
| Ramp and X calculation | 1–2 cycles          |
| Match calculation      | 1 cycle             |
| RGB temporary select   | 1 cycle             |
| Add and clamp          | 1 cycle             |
| Output register        | 1 cycle             |

The total latency depends on multiplier pipelining, division-by-255 implementation, and the number of output registers. The valid and sideband delay chains must use the same latency value.

## 10.22 Register-Level Integration

If controlled through the VCP register map, the HSL-to-RGB block should expose control and status bits.

| **Register**         | **Function**                               |
|----------------------|--------------------------------------------|
| VCP_MODE             | Selects HSL-to-RGB conversion mode.        |
| HSL_RGB_ENABLE       | Enables HSL-to-RGB conversion.             |
| HSL_RGB_BYPASS       | Bypasses conversion when required.         |
| HSL_RGB_STATUS       | Reports active state and error flags.      |
| HSL_RGB_LATENCY      | Optional readback for pipeline latency.    |
| HSL_RGB_FRAME_COUNT  | Counts processed frames.                   |
| HSL_RGB_ERROR_STATUS | Reports invalid stream or overflow events. |

Mode switching should preferably occur at frame boundaries so that one video frame does not contain mixed conversion states.

## 10.23 Simulation Test Vectors

The HSL-to-RGB block should be verified using directed test vectors.

| **Input HSL**       | **Expected RGB Behavior** |
|---------------------|---------------------------|
| H=0, S=0, L=0       | Black                     |
| H=0, S=0, L=128     | Neutral gray              |
| H=0, S=0, L=255     | White                     |
| H≈0, S=255, L=255   | Red                       |
| H≈43, S=255, L=255  | Yellow region             |
| H≈85, S=255, L=255  | Green region              |
| H≈128, S=255, L=255 | Cyan / blue-green region  |
| H≈172, S=255, L=255 | Blue region               |
| H≈213, S=255, L=255 | Magenta region            |
| H≈255, S=255, L=255 | Red wraparound region     |

The testbench should compare hardware output against a software reference model using a defined tolerance because fixed-point approximation may produce small differences.

## 10.24 Image-Based Validation

Image-based validation confirms that the HSL-to-RGB block works correctly over full frames, not only isolated pixels.

Recommended validation flow:

RGB Source Image

↓

RGB to HSL Conversion

↓

Optional HSL Modification

↓

HSL to RGB Conversion

↓

RGB Output Image Comparison

Validation checks should include:

- Round-trip visual similarity.

- No line shifts.

- No frame shifts.

- No unexpected hue discontinuities.

- Stable grayscale output.

- Correct saturation behavior.

- Correct output clamping.

- Correct frame-start and line-end alignment.

The source document references image-based conversion results and separated RGB/HSL component visualization in the color-space conversion section.

## 10.25 Verification Checklist

**Functional Checks**

- Verify hue sector decoding.

- Verify chroma calculation.

- Verify X ramp calculation.

- Verify M offset calculation.

- Verify temporary RGB selection per sector.

- Verify grayscale behavior when saturation is zero.

- Verify black output when luminosity is zero.

- Verify output clamping.

- Verify hue wraparound behavior.

**Interface Checks**

- Verify input valid handling.

- Verify output valid latency.

- Verify reset behavior.

- Verify AXI4-Stream wrapper operation.

- Verify TUSER delay alignment.

- Verify TLAST delay alignment.

- Verify no output pixel is generated for invalid input.

**Image Checks**

- Verify full-frame RGB reconstruction.

- Verify RGB-to-HSL-to-RGB round-trip behavior.

- Verify primary and secondary color regions.

- Verify grayscale ramp reconstruction.

- Verify no tearing, frame offset, or dropped pixels.

## 10.26 Hardware Design Recommendations

1.  **Use a six-sector hue decoder.**  
    It gives clean mapping across red, yellow, green, cyan, blue, and magenta transitions.

2.  **Use fixed-point arithmetic.**  
    Avoid floating-point logic and keep the datapath deterministic.

3.  **Pipeline multipliers and large muxes.**  
    This improves timing closure at video clock rates.

4.  **Handle saturation-zero cases explicitly.**  
    Grayscale pixels should bypass hue reconstruction.

5.  **Clamp all RGB outputs.**  
    Prevent wraparound artifacts.

6.  **Delay sideband signals through matched pipelines.**  
    Keep TVALID, TUSER, and TLAST aligned with output RGB data.

7.  **Use the same HSL scaling as the RGB-to-HSL block.**  
    This improves round-trip consistency.

8.  **Validate with color bars and grayscale ramps.**  
    These inputs expose hue-sector, saturation, and clamping errors quickly.

## 10.27 Chapter Summary

This chapter described the HSL-to-RGB hardware implementation used to reconstruct RGB pixels from hue, saturation, and luminosity components. The module receives an HSL stream, decodes the hue sector, calculates chroma and intermediate transition values, reconstructs temporary RGB components, applies the match offset, clamps the result, and outputs an RGB stream.

The source document identifies the HSL-to-RGB block as a module with iHsl input, oRgb output, clock, reset, and streaming-style valid control.

A reliable HSL-to-RGB implementation must preserve stream timing, align valid and sideband signals, handle grayscale and black edge cases, use fixed-point arithmetic, and sustain one-pixel-per-clock throughput for real-time FPGA video processing.
