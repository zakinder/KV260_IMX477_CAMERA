# Chapter 8 — Color Space Conversion Methods

## 8.1 Overview of Color Space Conversion

Color space conversion is the process of transforming pixel data from one mathematical color representation into another. In the FPGA Video Color Processing System, the primary input after demosaic processing is an RGB pixel stream. RGB is suitable for display and direct color-channel processing, but many image-processing operations are easier, faster, or more meaningful in other color spaces.

The Video Color Processing module supports multiple color space conversions, including RGB to HSL, HSL to RGB, RGB to YCbCr, RGB to CMYK, RGB to YDbDr, RGB to CIE XYZ, RGB to CIE YUV, RGB to YIQ, RGB to YPbPr, RGB to LMS, RGB to ICtCp, RGB to HED, and RGB to YC1C2.

Color space conversion enables the system to separate color, brightness, chroma, luminance, and perceptual information into different mathematical components. This improves the design flexibility of filters, thresholding logic, segmentation, enhancement, clustering, and diagnostic visualization.

## 8.2 Purpose of Color Space Conversion in FPGA Video Processing

RGB represents each pixel using red, green, and blue channel intensities. While this representation is useful for display, it is not always ideal for image analysis. Many processing tasks require separating brightness from color information or converting the pixel into a space that better matches human perception.

Color space conversion supports the following design objectives:

| **Objective**         | **Description**                                                                 |
|-----------------------|---------------------------------------------------------------------------------|
| Image enhancement     | Adjust brightness, contrast, hue, saturation, or luminance independently.       |
| Segmentation          | Separate objects based on hue, chroma, intensity, or color distance.            |
| Compression support   | Convert RGB into luminance/chrominance formats such as YCbCr or YPbPr.          |
| Color correction      | Transform RGB into standardized color spaces for calibration.                   |
| Feature extraction    | Generate values useful for edge detection, color classification, or clustering. |
| Display compatibility | Convert processed values back into RGB for final output.                        |
| Hardware optimization | Use simplified fixed-point arithmetic for real-time operation.                  |

In an FPGA pipeline, the conversion method must be selected carefully because each color space has different arithmetic complexity, bit-width growth, and timing requirements.

## 8.3 RGB as the Source Color Space

The RGB color model represents each pixel as:

PixelRGB = (R, G, B)

Where:

- R is the red channel intensity.

- G is the green channel intensity.

- B is the blue channel intensity.

For 8-bit RGB:

R, G, B ∈ \[0, 255\]

For 10-bit RGB:

R, G, B ∈ \[0, 1023\]

For 12-bit RGB:

R, G, B ∈ \[0, 4095\]

In this video-processing system, RGB data is produced after RAW camera data is converted through demosaic processing. The source document states that the demosaic module converts Bayer-pattern input frames into RGB color frames.

The RGB stream then becomes the input to the Video Color Processing module.

## 8.4 General Hardware Conversion Pipeline

A color space conversion block typically follows a structured hardware pipeline:

AXI4-Stream RGB Input

↓

Input Register Stage

↓

RGB Channel Unpack

↓

Normalization / Scaling

↓

Conversion Arithmetic

↓

Fixed-Point Rounding

↓

Clamp / Saturate

↓

Output Channel Pack

↓

AXI4-Stream Output

The main hardware requirements are:

1.  **Input alignment**  
    RGB data and sideband signals must enter the conversion block together.

2.  **Channel unpacking**  
    Red, green, and blue components must be extracted from the packed video word.

3.  **Arithmetic processing**  
    Conversion equations are implemented using adders, subtractors, comparators, multipliers, lookup tables, or fixed-point approximations.

4.  **Bit-width control**  
    Intermediate signals must be wide enough to prevent overflow.

5.  **Output clamping**  
    Converted values must be limited to the valid output range.

6.  **Sideband alignment**  
    TVALID, TUSER, and TLAST must be delayed to match the conversion pipeline latency.

## 8.5 Fixed-Point Arithmetic for Color Conversion

FPGA video pipelines typically use fixed-point arithmetic instead of floating-point arithmetic. Fixed-point arithmetic is more resource-efficient, easier to pipeline, and more predictable for timing closure.

A fixed-point number can be represented as:

Qm.n

Where:

- m is the number of integer bits.

- n is the number of fractional bits.

Example:

Q4.12 format:

4 integer bits

12 fractional bits

Scale factor = 2^12 = 4096

A floating-point coefficient such as 0.299 can be represented as:

0.299 × 4096 ≈ 1225

The multiplication can then be performed using integer arithmetic:

Y = (1225 × R + 2404 × G + 467 × B) \>\> 12

Fixed-point conversion requires careful handling of:

- Coefficient scaling.

- Signed intermediate values.

- Rounding.

- Saturation.

- Overflow protection.

- Pipeline latency.

## 8.6 RGB to HSL Conversion

The HSL color space represents color using:

| **Component** | **Meaning**                |
|---------------|----------------------------|
| Hue           | Dominant color angle       |
| Saturation    | Color intensity or purity  |
| Lightness     | Perceived light/dark level |

HSL is useful for operations that need to adjust color tone independently from brightness.

### 8.6.1 RGB to HSL Concept

The conversion begins by finding the maximum and minimum channel values:

Cmax = max(R, G, B)

Cmin = min(R, G, B)

Delta = Cmax - Cmin

Lightness is calculated as:

L = (Cmax + Cmin) / 2

Saturation depends on the lightness region:

If Delta = 0:

S = 0

Else:

S = Delta / (1 - \|2L - 1\|)

Hue depends on which RGB channel is maximum:

If Delta = 0:

H = 0

If Cmax = R:

H = 60 × (((G - B) / Delta) mod 6)

If Cmax = G:

H = 60 × (((B - R) / Delta) + 2)

If Cmax = B:

H = 60 × (((R - G) / Delta) + 4)

### 8.6.2 FPGA Implementation Notes

RGB to HSL requires:

- Maximum and minimum comparators.

- Subtractors.

- Division or reciprocal approximation.

- Conditional logic for hue sector selection.

- Signed arithmetic for channel differences.

- Output scaling for hue, saturation, and lightness.

Because division is expensive in FPGA logic, the implementation may use:

- Lookup-table reciprocals.

- Approximate reciprocal multiplication.

- Pipelined divider IP.

- Reduced-precision fixed-point arithmetic.

### 8.6.3 Use Cases

RGB to HSL is useful for:

- Hue-based segmentation.

- Saturation enhancement.

- Color filtering.

- Lightness adjustment.

- User-controlled image tuning.

The source document contains dedicated RGB to HSL and HSL to RGB sections, showing that HSL conversion is a major processing function in the design.

## 8.7 HSL to RGB Conversion

HSL to RGB converts hue, saturation, and lightness values back into red, green, and blue channels for display or further RGB processing.

### 8.7.1 HSL to RGB Concept

A common conversion method computes intermediate values:

C = (1 - \|2L - 1\|) × S

X = C × (1 - \|(H / 60 mod 2) - 1\|)

M = L - C / 2

The temporary RGB values are selected based on hue sector:

| **Hue Range** | **R′** | **G′** | **B′** |
|---------------|--------|--------|--------|
| 0°–60°        | C      | X      | 0      |
| 60°–120°      | X      | C      | 0      |
| 120°–180°     | 0      | C      | X      |
| 180°–240°     | 0      | X      | C      |
| 240°–300°     | X      | 0      | C      |
| 300°–360°     | C      | 0      | X      |

Final RGB values are:

R = R′ + M

G = G′ + M

B = B′ + M

### 8.7.2 FPGA Implementation Notes

HSL to RGB requires:

- Hue-sector classification.

- Multiplication for C and X.

- Absolute value logic.

- Adders for final channel restoration.

- Fixed-point scaling and output clamping.

The hue-sector logic is well suited for a case-statement or comparator-based decoder.

## 8.8 RGB to HSV Conversion

HSV represents color using:

| **Component** | **Meaning**               |
|---------------|---------------------------|
| Hue           | Dominant color angle      |
| Saturation    | Color purity              |
| Value         | Maximum channel intensity |

HSV is similar to HSL, but the brightness component is based on the maximum RGB channel rather than the average of maximum and minimum values.

### 8.8.1 RGB to HSV Equations

Cmax = max(R, G, B)

Cmin = min(R, G, B)

Delta = Cmax - Cmin

V = Cmax

If Cmax = 0:

S = 0

Else:

S = Delta / Cmax

Hue is calculated similarly to HSL:

If Delta = 0:

H = 0

If Cmax = R:

H = 60 × (((G - B) / Delta) mod 6)

If Cmax = G:

H = 60 × (((B - R) / Delta) + 2)

If Cmax = B:

H = 60 × (((R - G) / Delta) + 4)

### 8.8.2 FPGA Use Cases

HSV is useful for:

- Color-object detection.

- Hue thresholding.

- Saturation-based masking.

- Brightness-independent color classification.

- Real-time segmentation.

HSV is often preferred over RGB for color detection because hue can remain relatively stable under certain brightness changes.

## 8.9 RGB to YCbCr Conversion

YCbCr separates luminance from chrominance.

| **Component** | **Meaning**             |
|---------------|-------------------------|
| Y             | Luminance or brightness |
| Cb            | Blue-difference chroma  |
| Cr            | Red-difference chroma   |

YCbCr is widely used in video systems because human vision is more sensitive to luminance detail than chrominance detail.

### 8.9.1 Common Conversion Approximation

For 8-bit video-range processing, a common fixed-point style model is:

Y ≈ 0.299R + 0.587G + 0.114B

Cb ≈ -0.169R - 0.331G + 0.500B + Offset

Cr ≈ 0.500R - 0.419G - 0.081B + Offset

For unsigned 8-bit chroma, the offset is commonly 128. For 10-bit chroma, the offset is commonly 512.

### 8.9.2 FPGA Implementation Notes

RGB to YCbCr can be implemented using:

- Fixed-point multipliers.

- DSP blocks.

- Shift-add coefficient approximations.

- Signed adders.

- Chroma offset insertion.

- Output clamp logic.

YCbCr is useful for:

- Video compression pipelines.

- Luma-based filtering.

- Chroma-based segmentation.

- Brightness-independent processing.

## 8.10 YCbCr to RGB Conversion

YCbCr to RGB reconstructs red, green, and blue channels from luminance and chrominance components.

### 8.10.1 Common Conversion Approximation

For normalized components:

R ≈ Y + 1.402Cr

G ≈ Y - 0.344Cb - 0.714Cr

B ≈ Y + 1.772Cb

If Cb and Cr are stored as unsigned values, the chroma offset must be removed before conversion:

Cb_signed = Cb - Offset

Cr_signed = Cr - Offset

### 8.10.2 FPGA Implementation Notes

YCbCr to RGB requires:

- Offset subtraction.

- Signed fixed-point multipliers.

- Add/subtract stages.

- Output saturation.

- Pipeline alignment.

This conversion is important when intermediate processing is performed in luminance/chrominance space but output must be displayed in RGB format.

## 8.11 RGB to CMYK Conversion

CMYK represents color using:

| **Component** | **Meaning** |
|---------------|-------------|
| C             | Cyan        |
| M             | Magenta     |
| Y             | Yellow      |
| K             | Black       |

CMYK is commonly associated with printing, but it can also be used for color decomposition and analysis.

### 8.11.1 RGB to CMYK Concept

For normalized RGB values in the range 0 to 1:

K = 1 - max(R, G, B)

If K = 1:

C = 0

M = 0

Y = 0

Else:

C = (1 - R - K) / (1 - K)

M = (1 - G - K) / (1 - K)

Y = (1 - B - K) / (1 - K)

### 8.11.2 FPGA Implementation Notes

CMYK conversion requires:

- Maximum channel detection.

- Inversion logic.

- Conditional divide.

- Fixed-point normalization.

Because division is required, a simplified approximation may be preferred for real-time FPGA implementation.

## 8.12 RGB to YDbDr Conversion

YDbDr is a luminance/chrominance color space historically used in analog color television systems.

| **Component** | **Meaning**                 |
|---------------|-----------------------------|
| Y             | Luminance                   |
| Db            | Blue chrominance difference |
| Dr            | Red chrominance difference  |

A common conversion model is:

Y = 0.299R + 0.587G + 0.114B

Db = -0.450R - 0.883G + 1.333B

Dr = -1.333R + 1.116G + 0.217B

### 8.12.1 FPGA Implementation Notes

RGB to YDbDr is matrix-based and can be implemented using fixed-point multiplication and accumulation.

The conversion structure is:

\[Y \] \[a00 a01 a02\] \[R\]

\[Db\] = \[a10 a11 a12\] \[G\]

\[Dr\] \[a20 a21 a22\] \[B\]

This requires three multiply-accumulate paths.

## 8.13 RGB to CIE XYZ Conversion

CIE XYZ is a standardized color space designed to represent human color perception. It is frequently used as an intermediate color space for color calibration and colorimetry.

| **Component** | **Meaning**                               |
|---------------|-------------------------------------------|
| X             | Approximate red/green perceptual response |
| Y             | Luminance-like response                   |
| Z             | Approximate blue perceptual response      |

A common sRGB-to-XYZ conversion matrix is:

X = 0.4124R + 0.3576G + 0.1805B

Y = 0.2126R + 0.7152G + 0.0722B

Z = 0.0193R + 0.1192G + 0.9505B

### 8.13.1 FPGA Implementation Notes

RGB to CIE XYZ is matrix-based and requires:

- Coefficient multiplication.

- Accumulation.

- Fixed-point scaling.

- Optional gamma correction if strict color accuracy is required.

- Output range normalization.

For real-time FPGA implementation, the matrix multiplication should be deeply pipelined.

## 8.14 RGB to CIE YUV Conversion

CIE YUV separates luminance from chromaticity components.

| **Component** | **Meaning**             |
|---------------|-------------------------|
| Y             | Luminance               |
| U             | Chromaticity coordinate |
| V             | Chromaticity coordinate |

Unlike simple matrix conversions, CIE YUV may involve normalization terms that require division. Therefore, it can be more expensive in FPGA hardware than linear matrix conversions.

### 8.14.1 FPGA Implementation Notes

Implementation options include:

- Full fixed-point division.

- Lookup-table reciprocal approximation.

- Simplified linear approximation.

- Reduced-precision chromaticity computation.

This color space is useful for perceptual color analysis but may require careful resource planning.

## 8.15 RGB to YIQ Conversion

YIQ was used in analog NTSC television systems. It separates luminance from two chrominance components.

| **Component** | **Meaning**            |
|---------------|------------------------|
| Y             | Luminance              |
| I             | In-phase chrominance   |
| Q             | Quadrature chrominance |

A common conversion model is:

Y = 0.299R + 0.587G + 0.114B

I = 0.596R - 0.274G - 0.322B

Q = 0.211R - 0.523G + 0.312B

### 8.15.1 FPGA Implementation Notes

RGB to YIQ is a linear matrix conversion. It is suitable for FPGA implementation using signed fixed-point multipliers and adders.

YIQ can be useful for:

- Luminance extraction.

- Chroma analysis.

- Legacy video format experiments.

- Color separation demonstrations.

## 8.16 RGB to YPbPr Conversion

YPbPr is a component video color space that separates luma from blue-difference and red-difference signals.

| **Component** | **Meaning**               |
|---------------|---------------------------|
| Y             | Luma                      |
| Pb            | Blue-difference component |
| Pr            | Red-difference component  |

A common conversion approximation is:

Y = 0.299R + 0.587G + 0.114B

Pb = -0.169R - 0.331G + 0.500B

Pr = 0.500R - 0.419G - 0.081B

YPbPr is mathematically related to YCbCr, but YCbCr is typically the digital representation with offsets and scaling.

### 8.16.1 FPGA Implementation Notes

The conversion is matrix-based and hardware-friendly compared with HSL/HSV because it does not require division.

## 8.17 RGB to LMS Conversion

LMS represents color using estimated responses of the three cone types in the human eye:

| **Component** | **Meaning**                     |
|---------------|---------------------------------|
| L             | Long-wavelength cone response   |
| M             | Medium-wavelength cone response |
| S             | Short-wavelength cone response  |

A typical RGB-to-LMS conversion is matrix-based:

L = aR + bG + cB

M = dR + eG + fB

S = gR + hG + iB

The exact coefficient set depends on the selected color model and RGB reference space.

### 8.17.1 FPGA Implementation Notes

RGB to LMS is useful for:

- Perceptual color processing.

- Color-vision modeling.

- Advanced image analysis.

- Color correction experiments.

Since it is matrix-based, it maps well to DSP-based multiply-accumulate pipelines.

## 8.18 RGB to ICtCp Conversion

ICtCp is a color representation designed for high-dynamic-range and wide-color-gamut video systems.

| **Component** | **Meaning**             |
|---------------|-------------------------|
| I             | Intensity               |
| Ct            | Tritan chroma component |
| Cp            | Protan chroma component |

ICtCp is more complex than simple RGB matrix transforms because it may include nonlinear transfer functions and perceptual quantization, depending on implementation accuracy.

### 8.18.1 FPGA Implementation Notes

An FPGA implementation may require:

- RGB to LMS-like matrix conversion.

- Nonlinear transfer approximation.

- Additional matrix conversion to ICtCp.

- Lookup tables for nonlinear stages.

- High-precision fixed-point arithmetic.

ICtCp is useful for advanced color-processing research and HDR-related experiments.

## 8.19 RGB to HED Conversion

HED color space is commonly used in biomedical imaging to separate stain components:

| **Component** | **Meaning**           |
|---------------|-----------------------|
| H             | Hematoxylin component |
| E             | Eosin component       |
| D             | DAB component         |

In a general FPGA video-processing system, HED conversion can be used as an experimental or specialized color decomposition method.

### 8.19.1 FPGA Implementation Notes

HED conversion may require:

- Optical-density transformation.

- Logarithmic approximation.

- Matrix conversion.

- Fixed-point or LUT-based nonlinear processing.

Because logarithmic operations are expensive in hardware, lookup tables or approximation methods are often preferred.

## 8.20 RGB to YC1C2 Conversion

YC1C2 separates luminance from two chromatic components.

| **Component** | **Meaning**                           |
|---------------|---------------------------------------|
| Y             | Luminance-like component              |
| C1            | First chromatic difference component  |
| C2            | Second chromatic difference component |

A simple form may be implemented using channel differences:

Y = weighted luminance

C1 = R - G

C2 = B - G

or another defined matrix model depending on the selected implementation.

### 8.20.1 FPGA Implementation Notes

YC1C2 can be hardware-efficient because it may be implemented using:

- Adders.

- Subtractors.

- Simple shifts.

- Optional fixed-point coefficients.

It is useful for:

- Color segmentation.

- Channel-difference analysis.

- Object detection.

- Low-cost chroma separation.

## 8.21 Matrix-Based Conversion Architecture

Many color space conversions can be represented as a 3×3 matrix multiplication:

O0 = a00R + a01G + a02B + offset0

O1 = a10R + a11G + a12B + offset1

O2 = a20R + a21G + a22B + offset2

Or in matrix form:

\[O0\] \[a00 a01 a02\] \[R\] \[offset0\]

\[O1\] = \[a10 a11 a12\] \[G\] + \[offset1\]

\[O2\] \[a20 a21 a22\] \[B\] \[offset2\]

This architecture applies to:

- RGB to YCbCr

- RGB to YDbDr

- RGB to CIE XYZ

- RGB to YIQ

- RGB to YPbPr

- RGB to LMS

- Some YC1C2 variants

### 8.21.1 Hardware Pipeline

A matrix conversion pipeline may be structured as:

Stage 1: Register R, G, B

Stage 2: Multiply by coefficients

Stage 3: Accumulate products

Stage 4: Add offsets

Stage 5: Round and shift

Stage 6: Clamp outputs

Stage 7: Pack output word

This structure is highly pipeline-friendly and can sustain one pixel per clock when properly implemented.

## 8.22 Nonlinear Conversion Architecture

Some color conversions require nonlinear operations such as division, modulo, absolute value, maximum/minimum comparison, gamma correction, or logarithms.

Examples include:

| **Conversion** | **Nonlinear Operations**                         |
|----------------|--------------------------------------------------|
| RGB to HSL     | max, min, divide, hue-sector logic               |
| RGB to HSV     | max, min, divide, hue-sector logic               |
| HSL to RGB     | absolute value, hue-sector logic, multiplication |
| RGB to CIE YUV | normalization and division                       |
| RGB to ICtCp   | nonlinear transfer functions                     |
| RGB to HED     | logarithmic transformation                       |

### 8.22.1 FPGA Implementation Options

Nonlinear functions can be implemented using:

- Lookup tables.

- Piecewise-linear approximation.

- Pipelined division.

- Reciprocal multiplication.

- CORDIC-style computation.

- Approximation with reduced precision.

The selected method depends on accuracy requirements, available resources, and target clock frequency.

## 8.23 Color Conversion Mode Selection

The VCP module may include multiple conversion blocks. A mode-selection register determines which conversion is active.

A representative conversion mode table is:

| **Mode** | **Function**   |
|----------|----------------|
| 0        | Bypass RGB     |
| 1        | RGB to HSL     |
| 2        | HSL to RGB     |
| 3        | RGB to HSV     |
| 4        | RGB to YCbCr   |
| 5        | YCbCr to RGB   |
| 6        | RGB to CMYK    |
| 7        | RGB to YDbDr   |
| 8        | RGB to CIE XYZ |
| 9        | RGB to CIE YUV |
| 10       | RGB to YIQ     |
| 11       | RGB to YPbPr   |
| 12       | RGB to LMS     |
| 13       | RGB to ICtCp   |
| 14       | RGB to HED     |
| 15       | RGB to YC1C2   |

The exact mode values should be defined in the register map. The important requirement is that software and hardware use the same mode encoding.

## 8.24 Output Formatting

Not every color space produces output that is directly displayable as RGB. Therefore, the output format must be defined for each conversion mode.

Possible output strategies include:

| **Strategy**              | **Description**                                                                |
|---------------------------|--------------------------------------------------------------------------------|
| Display-normalized output | Scale converted channels into RGB-like ranges for visualization.               |
| Raw converted output      | Output converted channels directly for downstream processing.                  |
| Round-trip output         | Convert RGB to another space, process it, then convert back to RGB.            |
| Diagnostic output         | Display one component as grayscale or false color.                             |
| Packed data output        | Pack converted components into AXI4-Stream for analysis or Ethernet streaming. |

For example, an RGB-to-HSL diagnostic output may map:

Rout = H scaled to channel width

Gout = S scaled to channel width

Bout = L scaled to channel width

This allows HSL components to be viewed as a pseudo-color image.

## 8.25 Clamping, Rounding, and Saturation

Color conversion arithmetic may generate values outside the valid output range. Therefore, each output channel should be clamped.

For 8-bit output:

if value \< 0:

output = 0

else if value \> 255:

output = 255

else:

output = value

For 10-bit output:

if value \< 0:

output = 0

else if value \> 1023:

output = 1023

else:

output = value

Rounding should be applied before truncating fixed-point values:

rounded_value = (fixed_value + rounding_constant) \>\> fractional_bits

This reduces bias compared with direct truncation.

## 8.26 Sideband Signal Alignment

Color conversion blocks introduce pipeline latency. The AXI4-Stream sideband signals must be delayed by the same number of cycles as the pixel data.

Signals requiring alignment include:

- TVALID

- TUSER

- TLAST

- Pixel coordinate values

- Frame counters

- Line counters

- Mode-valid flags

A typical delay alignment structure is:

Pixel pipeline: P0 → P1 → P2 → P3 → P4

TVALID pipeline: V0 → V1 → V2 → V3 → V4

TUSER pipeline: U0 → U1 → U2 → U3 → U4

TLAST pipeline: L0 → L1 → L2 → L3 → L4

If sideband signals are not aligned, the output video may have incorrect frame boundaries, shifted lines, or corrupted stream control.

## 8.27 Resource and Timing Considerations

Color space conversion blocks vary significantly in hardware cost.

| **Conversion Type**     | **Hardware Cost** | **Main Resource Drivers**                    |
|-------------------------|-------------------|----------------------------------------------|
| Simple grayscale/luma   | Low               | Adders, shifts                               |
| Matrix-based conversion | Medium            | DSPs, adders, pipeline registers             |
| HSL/HSV conversion      | Medium to high    | Comparators, dividers, sector logic          |
| ICtCp/HED conversion    | High              | LUTs, nonlinear approximation, matrix stages |
| Round-trip conversion   | High              | Forward and inverse conversion blocks        |

Timing closure considerations include:

- Pipeline all multiplier outputs.

- Avoid long combinational comparator chains.

- Split accumulation into multiple stages.

- Register large mux outputs.

- Use DSP blocks for coefficient multiplication.

- Use BRAM/LUTRAM for reciprocal or nonlinear lookup tables.

- Align all output valid and synchronization signals.

## 8.28 Verification Strategy for Color Conversion

Each color conversion block should be verified independently and then verified in the full video pipeline.

### 8.28.1 Directed Pixel Tests

Use known RGB input values:

| **Input RGB** | **Expected Behavior**             |
|---------------|-----------------------------------|
| Black         | Minimum luminance/lightness/value |
| White         | Maximum luminance/lightness/value |
| Red           | Hue near red sector               |
| Green         | Hue near green sector             |
| Blue          | Hue near blue sector              |
| Gray ramp     | Zero or low saturation            |
| Color bars    | Known hue and chroma transitions  |

### 8.28.2 Image-Based Tests

Use full-frame images to verify:

- Color accuracy.

- Component separation.

- Visual stability.

- Frame alignment.

- Output range handling.

- Absence of overflow artifacts.

- Absence of line or frame shifts.

### 8.28.3 Reference Model Comparison

A software reference model should be used to compare FPGA output against expected values.

Recommended comparison methods include:

- Pixel-by-pixel difference.

- Maximum absolute error.

- Mean absolute error.

- Component histogram comparison.

- Tolerance-based pass/fail checks.

- Visual output review.

## 8.29 Design Recommendations

The following recommendations improve color conversion quality and reliability:

1.  **Use fixed-point arithmetic with documented scaling.**  
    Every coefficient and intermediate format should have a defined Q-format.

2.  **Use wider intermediate signals.**  
    Prevent overflow during multiplication and accumulation.

3.  **Clamp only at final output boundaries.**  
    Avoid premature saturation unless required by the algorithm.

4.  **Pipeline all complex arithmetic.**  
    Maintain high clock frequency for real-time video.

5.  **Use lookup tables for expensive nonlinear functions.**  
    Divisions, reciprocals, gamma curves, and logarithms should be optimized.

6.  **Preserve AXI4-Stream sideband alignment.**  
    Delay TUSER, TLAST, and TVALID with the pixel data.

7.  **Define output interpretation for every mode.**  
    The system should clearly distinguish displayable RGB output from diagnostic or converted-component output.

8.  **Validate using known color patterns.**  
    Test black, white, red, green, blue, grayscale ramps, color bars, and saturated colors.

## 8.30 Chapter Summary

Color space conversion expands the capability of the FPGA Video Color Processing System by transforming RGB pixels into alternate mathematical representations. These representations separate luminance, chrominance, hue, saturation, lightness, perceptual components, or specialized color features.

The VCP module supports a wide set of conversions, including RGB to HSL, HSL to RGB, RGB to YCbCr, RGB to CMYK, RGB to YDbDr, RGB to CIE XYZ, RGB to CIE YUV, RGB to YIQ, RGB to YPbPr, RGB to LMS, RGB to ICtCp, RGB to HED, and RGB to YC1C2.

Matrix-based conversions are generally efficient in FPGA logic because they can be implemented with pipelined fixed-point multiply-accumulate structures. Nonlinear conversions such as HSL, HSV, ICtCp, and HED require additional care because they may involve division, sector selection, lookup tables, or logarithmic approximations.

A reliable color conversion architecture must preserve stream timing, maintain sideband alignment, control bit growth, clamp output values, and meet the required video clock for real-time processing.
