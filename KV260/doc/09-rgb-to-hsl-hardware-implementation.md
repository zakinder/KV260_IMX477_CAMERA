# Chapter 9 — RGB to HSL Hardware Implementation

## 9.1 Overview

The **RGB to HSL hardware implementation** converts each input RGB pixel into an HSL-formatted output pixel. This conversion is useful because HSL separates color information into three more intuitive components:

| **HSL Component**          | **Meaning**                        |
|----------------------------|------------------------------------|
| **Hue**                    | Dominant color region              |
| **Saturation**             | Color intensity or color purity    |
| **Lightness / Luminosity** | Brightness-related intensity level |

In this design, the RGB to HSL conversion block is implemented as a hardware module inside the Video Color Processing pipeline. The original design describes the module as using an HSL algorithm with a standard Xilinx AXI4-Stream interface so it can be inserted into an image-processing pipeline.

The conversion block receives RGB channel values, calculates maximum and minimum channel values, determines hue based on the dominant RGB channel, calculates saturation, calculates luminosity, and outputs the HSL result as a synchronized video stream.

## 9.2 RGB to HSL Conversion Role in the Pipeline

The RGB to HSL block is positioned after RGB pixel generation and before any HSL-based processing or display-mapped output stage.

Demosaic RGB Stream

↓

RGB Channel Unpack

↓

RGB to HSL Conversion

↓

HSL Output Stream

↓

HSL-Based Processing / Diagnostic Display / HSL to RGB Conversion

The module is suitable for operations such as:

- Hue-based segmentation.

- Saturation enhancement.

- Color filtering.

- Color-region classification.

- Diagnostic visualization of hue, saturation, and luminosity channels.

- Round-trip color processing through HSL-to-RGB conversion.

Because the design operates in a streaming video pipeline, the RGB to HSL module must preserve pixel order, valid timing, frame-start signaling, and line-end signaling.

## 9.3 HSL Output Mapping

The implemented module maps the HSL components onto output channel fields. The source document identifies the RGB input and HSL output ports as 8-bit channel values, where the output red field carries hue, the output green field carries saturation, and the output blue field carries luminosity.

A practical output mapping is:

oHsl.red = Hue

oHsl.green = Saturation

oHsl.blue = Luminosity

This mapping allows the HSL stream to remain compatible with a three-channel video datapath. It also permits direct visualization of HSL data, although the output should be interpreted as component data rather than conventional RGB color unless remapped for display.

## 9.4 Module Interface

The RGB to HSL conversion block contains clock, reset, RGB input channel, HSL output channel, and valid-signal ports. The original document lists clk, reset, input RGB channel, output HSL channel, and valid signals as part of the module interface.

### 9.4.1 Input Interface

| **Signal** | **Width** | **Description**                                         |
|------------|-----------|---------------------------------------------------------|
| clk        | 1         | Reference clock for input and output stream processing. |
| reset      | 1         | Module reset signal.                                    |
| iRgb.red   | 8 bits    | Input red channel value.                                |
| iRgb.green | 8 bits    | Input green channel value.                              |
| iRgb.blue  | 8 bits    | Input blue channel value.                               |
| iRgb.valid | 1         | Indicates that the input RGB pixel is valid.            |

The source document specifies the input red, green, and blue values as 8-bit data and identifies iRgb.valid as the input-valid control signal.

### 9.4.2 Output Interface

| **Signal** | **Width** | **Description**                               |
|------------|-----------|-----------------------------------------------|
| oHsl.red   | 8 bits    | Output hue value.                             |
| oHsl.green | 8 bits    | Output saturation value.                      |
| oHsl.blue  | 8 bits    | Output luminosity value.                      |
| oHsl.valid | 1         | Indicates that the output HSL pixel is valid. |

The output valid signal must be delayed to match the conversion latency so that each HSL output corresponds to the correct input RGB pixel.

## 9.5 HSL Scaling Model

For hardware implementation, the HSL values are commonly scaled into an 8-bit range:

Hue = 0 to 255

Saturation = 0 to 255

Luminosity = 0 to 255

This avoids floating-point output and allows the HSL result to fit into the same three-channel stream format used by RGB.

A practical scaling model is:

| **Component** | **Mathematical Range** | **Hardware Range** |
|---------------|------------------------|--------------------|
| Hue           | 0° to 360°             | 0 to 255           |
| Saturation    | 0.0 to 1.0             | 0 to 255           |
| Luminosity    | 0.0 to 1.0             | 0 to 255           |

Under this model:

Hue_8bit ≈ Hue_degrees × 255 / 360

Saturation_8bit ≈ Saturation × 255

Luminosity_8bit ≈ Luminosity × 255

The source implementation describes hue regions using 8-bit ranges: red-dominant hue from 0 to 85, green-dominant hue from 86 to 171, and blue-dominant hue from 172 to 255.

## 9.6 Top-Level Conversion Flow

The RGB to HSL conversion can be implemented using the following hardware sequence:

Input RGB Pixel

↓

Register Input Channels

↓

Find RGB Maximum and Minimum

↓

Calculate Delta

↓

Calculate Hue Numerator

↓

Calculate Hue Denominator

↓

Calculate Hue Fraction

↓

Add Hue Region Offset

↓

Calculate Saturation

↓

Calculate Luminosity

↓

Clamp / Normalize

↓

Register HSL Output

This flow separates the conversion into hardware-friendly stages. Each stage may be registered to support high clock frequency and deterministic latency.

## 9.7 Maximum and Minimum RGB Logic

The first arithmetic stage calculates the maximum and minimum of the input RGB channels. The source document states that the first logic calculates the maximum and minimum values of the RGB input values.

### 9.7.1 Maximum Logic

rgb_max = max(R, G, B)

A comparator implementation is:

if R \>= G and R \>= B:

rgb_max = R

else if G \>= R and G \>= B:

rgb_max = G

else:

rgb_max = B

### 9.7.2 Minimum Logic

rgb_min = min(R, G, B)

A comparator implementation is:

if R \<= G and R \<= B:

rgb_min = R

else if G \<= R and G \<= B:

rgb_min = G

else:

rgb_min = B

### 9.7.3 Dominant Channel Encoding

The maximum-channel stage should also generate a dominant-channel code:

| **Dominant Channel** | **Code** | **Meaning**                        |
|----------------------|----------|------------------------------------|
| Red                  | 0        | Red is the maximum RGB component   |
| Green                | 1        | Green is the maximum RGB component |
| Blue                 | 2        | Blue is the maximum RGB component  |

This code is used by the hue numerator and hue offset logic.

## 9.8 RGB Delta Calculation

After rgb_max and rgb_min are known, the module calculates the RGB delta:

rgb_delta = rgb_max - rgb_min

The delta represents the spread between the strongest and weakest color channels.

| **Delta Condition** | **Meaning**                                                        |
|---------------------|--------------------------------------------------------------------|
| rgb_delta = 0       | Pixel is grayscale or neutral; hue is undefined.                   |
| rgb_delta \> 0      | Pixel has chromatic content; hue and saturation can be calculated. |

When rgb_delta = 0, hue should be forced to a defined neutral value, usually zero, and saturation should be zero.

if rgb_delta == 0:

Hue = 0

Saturation = 0

This prevents divide-by-zero conditions and gives a stable output for black, white, and gray pixels.

## 9.9 Hue Calculation Overview

Hue identifies the dominant color region of the pixel. The hardware implementation calculates hue by:

1.  Determining which RGB channel is maximum.

2.  Selecting the correct channel-difference numerator.

3.  Using RGB delta as the denominator.

4.  Calculating a hue fraction.

5.  Adding a hue-region base offset.

The source document describes hue as being calculated by determining the hue fraction from the greatest RGB channel value. It also states that the hue denominator is the RGB delta.

## 9.10 Hue Numerator Logic

The hue numerator depends on the dominant channel.

### 9.10.1 Red-Dominant Case

If red is the maximum channel:

Hue numerator = \|G - B\|

Hue region = 0 to 85

The source document states that if the current maximum channel is red, the hue numerator is based on green minus blue when green is greater than blue; otherwise, blue is subtracted from green, and the hue degree is set in the 0 to 85 range.

Hardware logic:

if R == rgb_max:

if G \>= B:

hue_num = G - B

hue_dir = positive

else:

hue_num = B - G

hue_dir = negative

### 9.10.2 Green-Dominant Case

If green is the maximum channel:

Hue numerator = \|B - R\|

Hue region = 86 to 171

The source document states that if the maximum channel is green, the hue numerator is based on blue minus red when blue is greater than red; otherwise, red is subtracted from blue, and the hue degree is set in the 86 to 171 range.

Hardware logic:

if G == rgb_max:

if B \>= R:

hue_num = B - R

hue_dir = positive

else:

hue_num = R - B

hue_dir = negative

### 9.10.3 Blue-Dominant Case

If blue is the maximum channel:

Hue numerator = \|R - G\|

Hue region = 172 to 255

The source document states that if the maximum channel is blue, the hue numerator is based on red minus green when red is greater than green; otherwise, green is subtracted from red, and the hue degree is set in the 172 to 255 range.

Hardware logic:

if B == rgb_max:

if R \>= G:

hue_num = R - G

hue_dir = positive

else:

hue_num = G - R

hue_dir = negative

## 9.11 Hue Denominator Logic

The hue denominator is the RGB delta:

hue_den = rgb_delta

The source document explicitly states that the hue denominator is the RGB delta.

If hue_den = 0, the module must bypass division and force hue to zero.

if hue_den == 0:

hue_fraction = 0

else:

hue_fraction = hue_num / hue_den

Because division is expensive in FPGA hardware, the divider should be implemented using one of the following methods:

| **Method**                | **Description**                                          |
|---------------------------|----------------------------------------------------------|
| Pipelined divider         | Accurate but may require more resources and latency.     |
| Reciprocal lookup table   | Stores approximate 1 / delta values.                     |
| Reciprocal multiplication | Multiplies numerator by approximate reciprocal.          |
| Piecewise approximation   | Reduces divider complexity with segmented approximation. |

For high-throughput video, a pipelined reciprocal-multiply method is often preferred.

## 9.12 Hue Region Offset Logic

The 8-bit hue range can be divided into three major regions:

| **Dominant Channel** | **Hue Region** |
|----------------------|----------------|
| Red maximum          | 0 to 85        |
| Green maximum        | 86 to 171      |
| Blue maximum         | 172 to 255     |

The implementation adds a region offset after calculating the hue fraction. The source document states that once the hue fraction values are calculated, the fraction values are added to the hue degree to produce the final hue value.

A practical hardware form is:

if max_channel == RED:

hue_base = 0

else if max_channel == GREEN:

hue_base = 86

else:

hue_base = 172

Hue = hue_base + hue_fraction_scaled

The hue fraction must be scaled to fit the active region.

hue_fraction_scaled = (hue_num × 85) / rgb_delta

Final hue logic should include saturation to prevent overflow beyond 255.

## 9.13 Saturation Calculation

Saturation measures how strongly colored the pixel is. In the source design, saturation is calculated from the difference between RGB maximum and RGB minimum over RGB maximum.

The hardware equation is:

Saturation = rgb_delta / rgb_max

For 8-bit output scaling:

Saturation_8bit = (rgb_delta × 255) / rgb_max

If rgb_max = 0, the pixel is black and saturation should be forced to zero:

if rgb_max == 0:

Saturation = 0

else:

Saturation = (rgb_delta × 255) / rgb_max

This prevents divide-by-zero and produces stable black-pixel behavior.

## 9.14 Luminosity Calculation

The source implementation identifies luminosity as the RGB maximum value.

The implemented luminosity equation is therefore:

Luminosity = rgb_max

This is closer to the “value” component used in HSV than the conventional HSL lightness equation:

Conventional HSL Lightness = (rgb_max + rgb_min) / 2

For this implementation, the hardware should document the output as **luminosity/value-style lightness** unless the design is later modified to compute conventional HSL lightness.

Using rgb_max has several hardware advantages:

- No adder required for rgb_max + rgb_min.

- No divide-by-two stage required.

- Luminosity remains directly tied to the strongest channel.

- The result is simple, deterministic, and low-latency.

## 9.15 Hardware Pipeline Stages

A practical RGB to HSL hardware pipeline can be divided into deterministic stages.

| **Stage** | **Function**                                       |
|-----------|----------------------------------------------------|
| Stage 0   | Capture input RGB and valid signal                 |
| Stage 1   | Calculate rgb_max, rgb_min, and max-channel code   |
| Stage 2   | Calculate rgb_delta                                |
| Stage 3   | Calculate hue numerator and hue denominator        |
| Stage 4   | Calculate hue fraction using divider or reciprocal |
| Stage 5   | Add hue-region offset                              |
| Stage 6   | Calculate saturation                               |
| Stage 7   | Assign luminosity                                  |
| Stage 8   | Clamp and register HSL output                      |

A possible pipeline flow is:

RGB In

→ Max/Min

→ Delta

→ Hue Numerator

→ Hue Divide

→ Hue Offset

→ Saturation Divide

→ Luminosity Assign

→ HSL Out

The exact number of stages depends on divider implementation and target clock frequency.

## 9.16 Valid Signal Pipeline

Because the conversion block is pipelined, the valid signal must be delayed by the same number of cycles as the pixel data.

RGB data pipeline: P0 → P1 → P2 → P3 → P4 → P5

Valid pipeline: V0 → V1 → V2 → V3 → V4 → V5

The output valid signal should be asserted only when the corresponding HSL output is valid:

oHsl.valid = delayed_iRgb.valid

This requirement is consistent with the source document, which defines oHsl.valid as the control signal indicating the validity of each output pixel.

## 9.17 AXI4-Stream Integration

Although the source module description uses iRgb and oHsl channel structures, the conversion block is designed for standard Xilinx AXI4-Stream pipeline integration.

A practical AXI4-Stream wrapper should map the conversion logic as follows:

s_axis_tdata → RGB unpack → RGB to HSL core → HSL pack → m_axis_tdata

s_axis_tvalid → valid pipeline → m_axis_tvalid

s_axis_tuser → sideband delay → m_axis_tuser

s_axis_tlast → sideband delay → m_axis_tlast

s_axis_tready ← ready / pipeline flow control

The wrapper must preserve:

- Pixel order.

- Frame-start marker.

- End-of-line marker.

- Valid-data timing.

- Backpressure behavior.

- Reset behavior.

## 9.18 Sideband Signal Alignment

If the RGB to HSL core is placed inside an AXI4-Stream video path, the sideband signals must be delayed through matching pipelines.

Signals requiring alignment include:

| **Signal**        | **Required Handling**                              |
|-------------------|----------------------------------------------------|
| TVALID            | Delay to match HSL output latency.                 |
| TUSER             | Delay to remain aligned with first pixel of frame. |
| TLAST             | Delay to remain aligned with last pixel of line.   |
| Pixel coordinates | Delay if used for debug or downstream processing.  |

A generic sideband alignment model is:

for each clock:

tuser_delay\[N:1\] \<= tuser_delay\[N-1:0\]

tlast_delay\[N:1\] \<= tlast_delay\[N-1:0\]

tvalid_delay\[N:1\] \<= tvalid_delay\[N-1:0\]

The output sideband signals are taken from the final delay stage.

## 9.19 Divider and Reciprocal Implementation

The RGB to HSL implementation requires division for hue fraction and saturation. In FPGA hardware, this is one of the most important architectural choices.

### 9.19.1 Hue Fraction Division

hue_fraction = hue_num / rgb_delta

Scaled to an 8-bit hue region:

hue_fraction_scaled = (hue_num × 85) / rgb_delta

### 9.19.2 Saturation Division

saturation = (rgb_delta × 255) / rgb_max

### 9.19.3 Recommended Hardware Methods

| **Method**          | **Advantage**                | **Disadvantage**                                                  |
|---------------------|------------------------------|-------------------------------------------------------------------|
| Direct divider IP   | Accurate and straightforward | Higher latency and resource usage                                 |
| Reciprocal LUT      | Fast and pipeline-friendly   | Approximation error                                               |
| Reciprocal multiply | Good throughput              | Requires multiplier and reciprocal scaling                        |
| Shift approximation | Very low cost                | Lower accuracy                                                    |
| Shared divider      | Saves resources              | May reduce throughput unless multi-cycle scheduling is acceptable |

For one-pixel-per-clock video, division resources must either be fully pipelined or replicated enough to sustain continuous throughput.

## 9.20 Fixed-Point Representation

A fixed-point representation allows hue fraction and saturation to be calculated using integer hardware.

Example format:

Input channels: 8-bit unsigned

rgb_delta: 8-bit unsigned

hue_num: 8-bit unsigned

reciprocal_delta: Q0.16 fixed-point

hue_fraction_product: Q8.16

saturation_product: Q8.16

Example reciprocal-based hue calculation:

reciprocal_delta = round((1 / rgb_delta) × 2^16)

hue_fraction_scaled = (hue_num × 85 × reciprocal_delta) \>\> 16

Example saturation calculation:

reciprocal_max = round((1 / rgb_max) × 2^16)

saturation = (rgb_delta × 255 × reciprocal_max) \>\> 16

This approach replaces division with multiplication and shifting.

## 9.21 Edge-Case Handling

The conversion block must explicitly handle edge cases.

| **Condition**               | **Required Output**                                  |
|-----------------------------|------------------------------------------------------|
| R = G = B = 0               | Hue = 0, Saturation = 0, Luminosity = 0              |
| R = G = B \> 0              | Hue = 0, Saturation = 0, Luminosity = R              |
| rgb_delta = 0               | Hue = 0, Saturation = 0                              |
| rgb_max = 0                 | Saturation = 0                                       |
| Maximum channel tie         | Use deterministic priority rule                      |
| Calculated hue \> 255       | Clamp to 255                                         |
| Intermediate negative value | Convert using absolute difference or signed handling |
| Output overflow             | Clamp to output channel width                        |

A deterministic priority rule for equal maximum values prevents unstable hue output when two or three channels are equal.

Example priority rule:

if R \>= G and R \>= B:

max_channel = RED

else if G \>= B:

max_channel = GREEN

else:

max_channel = BLUE

This rule gives predictable behavior for tie cases.

## 9.22 Output Clamping and Saturation

The output values must be clamped to the valid output range.

For 8-bit HSL output:

if Hue \> 255:

Hue = 255

if Saturation \> 255:

Saturation = 255

if Luminosity \> 255:

Luminosity = 255

For unsigned values, underflow is prevented by using absolute-difference logic or signed intermediate handling before output conversion.

Clamping protects the output from:

- Divider approximation error.

- Fixed-point rounding overflow.

- Region-offset overflow.

- Invalid register or coefficient configuration.

- Arithmetic bit-growth truncation.

## 9.23 Latency Model

The RGB to HSL block has deterministic latency. Latency depends mainly on:

- Comparator stages.

- Divider or reciprocal stages.

- Saturation calculation.

- Output register stages.

- AXI4-Stream wrapper stages.

A representative latency model is:

| **Block**                     | **Example Latency** |
|-------------------------------|---------------------|
| Input register                | 1 cycle             |
| Max/min calculation           | 1 cycle             |
| Delta calculation             | 1 cycle             |
| Hue numerator logic           | 1 cycle             |
| Hue reciprocal/divider        | 4–16 cycles         |
| Hue offset and clamp          | 1 cycle             |
| Saturation reciprocal/divider | 4–16 cycles         |
| Output register               | 1 cycle             |

If hue and saturation divisions are performed in parallel, total latency can be reduced. If one divider is shared, latency increases and throughput may be reduced unless the divider is pipelined.

## 9.24 Throughput Model

The desired throughput for real-time video is one pixel per clock.

Throughput = 1 pixel / clock

To sustain this throughput:

- Max/min logic must accept a new RGB pixel every cycle.

- Hue numerator logic must accept a new pixel every cycle.

- Divider or reciprocal logic must be pipelined.

- Saturation logic must be pipelined.

- Output logic must not introduce stalls.

- AXI4-Stream backpressure must be handled correctly.

If the divider is not pipelined, the design may fail to process one pixel per clock and could drop frames in high-resolution video modes.

## 9.25 Simulation and Waveform Validation

The source document includes RGB to HSL simulation results and references a wave diagram for the conversion module.

Simulation should verify:

- Correct maximum and minimum channel selection.

- Correct RGB delta.

- Correct hue numerator selection.

- Correct hue region offset.

- Correct saturation scaling.

- Correct luminosity output.

- Correct valid-signal delay.

- Correct reset behavior.

- Correct output under grayscale conditions.

- Correct behavior for primary and secondary colors.

Recommended directed test vectors:

| **Input RGB**   | **Expected Result**                                  |
|-----------------|------------------------------------------------------|
| (0, 0, 0)       | Hue = 0, Saturation = 0, Luminosity = 0              |
| (255, 255, 255) | Hue = 0, Saturation = 0, Luminosity = 255            |
| (255, 0, 0)     | Red hue region, high saturation, high luminosity     |
| (0, 255, 0)     | Green hue region, high saturation, high luminosity   |
| (0, 0, 255)     | Blue hue region, high saturation, high luminosity    |
| (255, 255, 0)   | Yellow hue region, high saturation, high luminosity  |
| (0, 255, 255)   | Cyan hue region, high saturation, high luminosity    |
| (255, 0, 255)   | Magenta hue region, high saturation, high luminosity |
| (128, 128, 128) | Hue = 0, Saturation = 0, Luminosity = 128            |

## 9.26 Image-Based Validation

The source document references RGB images, HSL converted images, and separated hue, saturation, and luminosity channel outputs as visual validation artifacts.

Image-based validation should include:

1.  **RGB input image inspection**  
    Confirm that the original image is correctly loaded and streamed.

2.  **HSL composite output inspection**  
    Confirm that hue, saturation, and luminosity values are generated across the frame.

3.  **Hue-channel inspection**  
    Confirm that color regions transition smoothly and match expected image colors.

4.  **Saturation-channel inspection**  
    Confirm that grayscale or low-color areas produce low saturation and strong color regions produce high saturation.

5.  **Luminosity-channel inspection**  
    Confirm that bright regions produce high luminosity and dark regions produce low luminosity.

6.  **Frame alignment inspection**  
    Confirm that the HSL output image has no line shift, frame offset, tearing, or dropped pixels.

The document also describes HSL as a cylindrical geometry in which hue transitions through red, orange, yellow, green, cyan, blue, and magenta.

## 9.27 Register-Level Integration

If the RGB to HSL block is controlled through the VCP register map, the following register controls are recommended:

| **Register**         | **Function**                                         |
|----------------------|------------------------------------------------------|
| VCP_MODE             | Selects RGB to HSL conversion mode.                  |
| RGB_HSL_ENABLE       | Enables or disables the RGB to HSL block.            |
| RGB_HSL_BYPASS       | Bypasses conversion and forwards input RGB.          |
| RGB_HSL_STATUS       | Reports active state and error conditions.           |
| RGB_HSL_LATENCY      | Optional readback of configured pipeline latency.    |
| RGB_HSL_FRAME_COUNT  | Counts frames processed by the block.                |
| RGB_HSL_ERROR_STATUS | Reports invalid stream, overflow, or divider errors. |

Configuration should preferably be applied at frame boundaries to prevent partial-frame changes.

## 9.28 Verification Checklist

A complete verification plan for the RGB to HSL module should include:

**Functional Checks**

- Verify max/min calculation.

- Verify delta calculation.

- Verify hue numerator logic for red, green, and blue dominant cases.

- Verify hue denominator logic.

- Verify saturation equation.

- Verify luminosity equation.

- Verify grayscale behavior.

- Verify black-pixel behavior.

- Verify tie-case priority behavior.

**Interface Checks**

- Verify input valid handling.

- Verify output valid latency.

- Verify reset behavior.

- Verify AXI4-Stream wrapper operation.

- Verify TUSER alignment.

- Verify TLAST alignment.

- Verify no output is generated for invalid input pixels.

**Image Checks**

- Verify RGB-to-HSL output image.

- Verify hue channel output.

- Verify saturation channel output.

- Verify luminosity channel output.

- Compare against a software reference model.

- Measure maximum absolute error and mean absolute error.

## 9.29 Hardware Design Recommendations

The RGB to HSL block should follow these implementation recommendations:

1.  **Pipeline all comparator and arithmetic stages.**  
    This improves timing closure at high video clocks.

2.  **Use deterministic tie handling.**  
    Equal-channel cases should not produce unstable hue results.

3.  **Protect all divider inputs.**  
    Prevent divide-by-zero when rgb_delta = 0 or rgb_max = 0.

4.  **Use reciprocal lookup tables where appropriate.**  
    This can reduce divider cost and support one-pixel-per-clock throughput.

5.  **Delay sideband signals through matched pipelines.**  
    TVALID, TUSER, and TLAST must remain aligned with output HSL data.

6.  **Document the luminosity definition.**  
    If luminosity equals rgb_max, clearly identify it as value-style luminosity rather than conventional HSL lightness.

7.  **Clamp all output channels.**  
    Prevent wraparound caused by fixed-point arithmetic or approximation error.

8.  **Validate with primary colors, grayscale ramps, and full images.**  
    These test cases reveal most hue-region and saturation errors.

## 9.30 Chapter Summary

This chapter described the RGB to HSL hardware implementation used inside the FPGA Video Color Processing pipeline. The module receives RGB pixel data, determines the maximum and minimum channel values, calculates RGB delta, computes hue based on the dominant channel, calculates saturation from rgb_delta / rgb_max, assigns luminosity from rgb_max, and outputs the HSL result using a three-channel stream format.

The source design defines the RGB to HSL block as an AXI4-Stream-compatible module and identifies its port structure, max/min logic, hue numerator logic, hue denominator logic, saturation calculation, and luminosity calculation.

A reliable RGB to HSL implementation must use safe divide handling, deterministic hue-region selection, fixed-point arithmetic, output clamping, valid-signal alignment, and AXI4-Stream sideband preservation. With proper pipelining, the block can operate as a real-time color-conversion stage inside the FPGA video-processing system.
