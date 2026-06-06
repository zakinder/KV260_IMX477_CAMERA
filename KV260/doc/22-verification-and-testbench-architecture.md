# Chapter 22 — Verification and Testbench Architecture

## 22.1 Overview

The **Verification and Testbench Architecture** validates the FPGA Video Color Processing System before hardware deployment. The verification environment confirms that the DUT correctly accepts camera-style video input, responds to AXI4-Lite register transactions, processes RGB frames through selected filters or color-space functions, and produces valid output frames.

The source design describes two verification approaches:

1.  A VHDL image-file testbench that reads image data, applies RGB stimulus to filter sections, waits for the end of frame, and generates a valid output BMP image.

2.  A UVM class-based verification environment that uses tests, environment, agent, driver, monitor, scoreboard, sequences, and transactions.

A high-level verification architecture is:

Test / Sequence

↓

Sequencer

↓

Driver

↓

DUT Interface

↓

Video Color Processing DUT

↓

Monitor

↓

Scoreboard / Coverage / Image Output

The goal is to verify both **pixel-processing correctness** and **control-interface correctness**.

## 22.2 Verification Objectives

The testbench must prove that the design operates correctly under expected and stressed operating conditions.

Primary verification objectives include:

| **Objective**                 | **Description**                                                            |
|-------------------------------|----------------------------------------------------------------------------|
| Video stimulus generation     | Apply RGB image frames, synthetic patterns, and camera-like streams.       |
| AXI4-Lite configuration       | Program registers for filters, coefficients, thresholds, and modes.        |
| Pixel transformation checking | Compare DUT output against expected processed pixels.                      |
| Frame protocol checking       | Verify start-of-frame, end-of-line, valid, and frame boundaries.           |
| Reset checking                | Confirm clean recovery after reset.                                        |
| Mode checking                 | Verify filter and color-space mode selection.                              |
| Register read/write checking  | Verify AXI4-Lite address, data, response, and readback behavior.           |
| Error detection               | Catch timeouts, invalid responses, protocol violations, and mismatches.    |
| Coverage                      | Track tested modes, formats, thresholds, image sizes, and protocol states. |

The source document states that the D5M verification testbench is created through configuration, factory, and phase build processes, allowing stimulus and randomization generation.

## 22.3 DUT Under Test

The DUT represents the FPGA video-processing path or selected VCP module. Depending on the simulation level, the DUT may include:

- AXI4-Lite register interface.

- Camera input interface.

- RGB pixel input channel.

- Filter or color-space conversion block.

- K-means clustering block.

- Color correction matrix.

- Histogram or segmentation block.

- AXI4-Stream style output channel.

- Diagnostic outputs.

The verification architecture should support both:

| **Verification Level**   | **Description**                                                       |
|--------------------------|-----------------------------------------------------------------------|
| Block-level verification | Tests one module such as Sobel, HSL conversion, CCM, or K-means.      |
| Subsystem verification   | Tests VCP with register control and video stream input/output.        |
| System-level simulation  | Tests camera stimulus, VCP, memory interfaces, and output generation. |

## 22.4 VHDL Image-Based Testbench

The source design states that a VHDL testbench is used to verify filter modules by generating image stimulus. The testbench reads an image file, applies RGB stimulus to the filter section, waits until the end of frame, and generates a valid output BMP file.

This approach is useful for visual verification.

Input BMP / Image File

↓

Pixel Reader

↓

RGB Stimulus Driver

↓

DUT Filter Module

↓

Output Pixel Collector

↓

Output BMP / Image File

### 22.4.1 Advantages

| **Advantage**         | **Description**                                                                  |
|-----------------------|----------------------------------------------------------------------------------|
| Visual validation     | Output image can be inspected directly.                                          |
| Simple bring-up       | Easy to verify filters with known image files.                                   |
| Useful for algorithms | Helps confirm blur, sharp, emboss, Sobel, and color conversion results.          |
| Fast debugging        | Visual artifacts reveal channel swaps, alignment errors, and threshold problems. |

### 22.4.2 Limitations

| **Limitation**            | **Description**                                   |
|---------------------------|---------------------------------------------------|
| Manual checking           | Pass/fail may depend on visual inspection.        |
| Limited protocol coverage | Does not fully verify AXI4-Lite behavior.         |
| Limited randomization     | Mostly directed image stimulus.                   |
| Weak corner-case checking | May miss rare timing or register-access failures. |

For production-grade verification, image-based tests should be combined with UVM checking and software reference models.

## 22.5 UVM Testbench Architecture

The UVM environment is class-based and reusable. The source document states that the UVM testbench is built from classes, with a test containing an environment and the environment containing a D5M agent. It also states that the testbench flow is to connect the DUT and testbench, configure the D5M agent, and generate stimulus.

A representative UVM structure is:

uvm_test

↓

uvm_env

↓

d5m_agent

├── sequencer

├── driver

├── monitor

└── coverage

↓

scoreboard

The UVM environment improves verification by supporting:

- Structured stimulus generation.

- Randomization.

- Reusable drivers and monitors.

- Register access testing.

- Automated checking.

- Functional coverage.

- Regression execution.

## 22.6 Testbench Components

The source table of contents identifies the main testbench sections as **Testbench**, **Testbench Components/Objects**, **DUT Connections**, **Sequence Item**, **Sequence**, **Sequencer**, **Driver**, **Monitor**, **Agent**, **Scoreboard**, **Environment/ENV**, **Test**, **D5M Transaction**, and **Testbench Top**.

### 22.6.1 Component Summary

| **Component** | **Function**                                                  |
|---------------|---------------------------------------------------------------|
| testbench_top | Instantiates DUT, interfaces, clocks, resets, and starts UVM. |
| uvm_test      | Selects scenario and starts sequences.                        |
| uvm_env       | Builds and connects reusable components.                      |
| agent         | Groups sequencer, driver, monitor, and coverage.              |
| sequencer     | Provides transactions to driver.                              |
| sequence      | Generates transaction streams.                                |
| sequence_item | Defines randomized transaction fields.                        |
| driver        | Drives DUT pins and AXI4-Lite/video interface signals.        |
| monitor       | Observes DUT input/output transactions.                       |
| scoreboard    | Compares actual DUT behavior against expected behavior.       |
| coverage      | Tracks verification completeness.                             |

## 22.7 Sequence Item and Transaction Model

The sequence item defines the transaction fields used to stimulate the DUT. The source document identifies a d5m_trans class inherited from uvm_sequence_item, with data members such as vfp, d5m, coefficient channel, and AXI4-Lite channel.

A practical transaction model includes:

class d5m_trans extends uvm_sequence_item;

rand rgb_channel vfp;

rand rgb_channel d5m;

rand cof_channel cof;

rand axi4_lite_channel axi4_lite;

rand int unsigned image_width;

rand int unsigned image_height;

rand bit \[7:0\] filter_id;

rand bit \[31:0\] threshold;

endclass

Transaction fields should support:

| **Field**                | **Purpose**                   |
|--------------------------|-------------------------------|
| RGB pixel data           | Video stimulus                |
| Valid/line/frame signals | Stream timing                 |
| AXI4-Lite address/data   | Register programming          |
| Coefficients             | Kernel or color-matrix values |
| Threshold                | Sobel or segmentation control |
| Image size               | Resolution testing            |
| Mode selection           | Filter/color-space selection  |
| Coordinates              | Pixel-position-aware checking |

## 22.8 Sequence Architecture

Sequences generate ordered or randomized stimulus. A sequence can configure registers, drive a frame, and collect results.

Example sequence flow:

1\. Reset DUT.

2\. Program VCP registers through AXI4-Lite.

3\. Load image/frame stimulus.

4\. Drive valid RGB pixels.

5\. Wait for output frame.

6\. Compare output with expected model.

7\. Collect coverage.

Recommended sequence types:

| **Sequence**                 | **Purpose**                                          |
|------------------------------|------------------------------------------------------|
| Reset sequence               | Tests reset and default state.                       |
| Register read/write sequence | Verifies AXI4-Lite register map.                     |
| RGB pass-through sequence    | Verifies baseline video timing.                      |
| Filter sequence              | Tests sharp, blur, emboss, Sobel.                    |
| Color-space sequence         | Tests RGB↔HSL, HSV, YCbCr.                           |
| CCM sequence                 | Tests 3×3 color matrix.                              |
| K-means sequence             | Tests palette and nearest-cluster logic.             |
| Histogram sequence           | Tests bin counting and readback.                     |
| Stress sequence              | Tests random modes, random frames, and corner cases. |

## 22.9 Sequencer

The sequencer arbitrates and provides sequence items to the driver. It does not drive DUT signals directly. Its role is to generate transaction order and control stimulus flow.

A sequencer supports:

- Directed transaction sequences.

- Randomized transaction streams.

- Multiple image sizes.

- Multiple filter modes.

- Register programming sequences.

- Reset and protocol stress sequences.

The driver pulls items from the sequencer and converts them into pin-level activity.

## 22.10 Driver Architecture

The source document states that the UVM driver extends uvm_driver, pulls data items generated by the sequencer, and drives them to the DUT. In the run phase, methods are used for reading and writing operations to the DUT through the interface handle.

The driver performs three major tasks:

Driver

├── Reset DUT signals

├── Drive AXI4-Lite transactions

└── Drive camera/video pixel transactions

The source driver run phase uses fork/join threads to drive reset signals and D5M frame stimulus.

### 22.10.1 Driver Responsibilities

| **Responsibility** | **Description**                                                |
|--------------------|----------------------------------------------------------------|
| Reset driving      | Initializes DUT and interface signals.                         |
| AXI4-Lite write    | Programs control registers.                                    |
| AXI4-Lite read     | Reads status and verifies readback.                            |
| Pixel driving      | Drives RGB data and valid timing.                              |
| Frame driving      | Generates frame-valid, line-valid, SOF, EOF, and EOL behavior. |
| Timeout checking   | Reports missing ready/valid responses.                         |

## 22.11 AXI4-Lite Driver

The AXI4-Lite driver verifies the control interface. The source document describes AXI4-Lite communication across five channels, with read transactions split into address and data phases and write transactions split into address, data, and response phases. It also describes VALID/READY flow control for address, data, and response transfer.

### 22.11.1 AXI4-Lite Write Flow

AWADDR + AWVALID

↓

Wait for AWREADY

↓

WDATA + WVALID + WSTRB

↓

Wait for WREADY

↓

Wait for BVALID

↓

Check BRESP

↓

Assert BREADY

The source driver includes timeout checks for write address, write data, and write response behavior, including BVALID timeout and error response checks.

### 22.11.2 AXI4-Lite Read Flow

ARADDR + ARVALID

↓

Wait for ARREADY

↓

Wait for RVALID

↓

Capture RDATA

↓

Check RRESP

↓

Assert RREADY

The source driver describes read address handling and AXI4-Lite read-data handling with timeout checks and read-response error checking.

## 22.12 Video Frame Driver

The video frame driver converts sequence-item data into DUT pixel-interface activity.

A camera-style frame driver should generate:

| **Signal**         | **Meaning**                           |
|--------------------|---------------------------------------|
| clk                | Video clock                           |
| valid              | Pixel valid                           |
| lvalid / eol       | Active line or end-of-line indication |
| fvalid / sof / eof | Active frame or frame marker          |
| red                | Red pixel channel                     |
| green              | Green pixel channel                   |
| blue               | Blue pixel channel                    |
| x                  | Pixel coordinate                      |
| y                  | Line coordinate                       |

The source document states that D5M data items include clock, valid, line-valid, frame-valid, end-of-frame, start-of-frame, RGB channels, and x/y coordinate data members.

## 22.13 Monitor Architecture

The monitor observes DUT activity without driving signals. The source document describes the monitor as a critical verification component that obtains and collects events and data activity in the DUT. The collected information is used by checkers, scoreboard, and coverage.

A monitor should collect:

- Input video transactions.

- Output video transactions.

- AXI4-Lite reads and writes.

- Register states.

- Frame-start and line-end events.

- Error/status signals.

- Pixel coordinates.

- Output image data.

The monitor publishes transactions through analysis ports.

DUT Interface

↓

Monitor

↓

Analysis Port

↓

Scoreboard / Coverage / Logger

The source document describes monitor analysis ports for sending DUT monitor items and predicted monitor values.

## 22.14 Agent Architecture

The agent groups sequencer, driver, monitor, and coverage into a reusable verification component. The source document states that the D5M agent extends uvm_agent and bundles sequencer, driver, monitor, and coverage. It also states that the agent connects analysis ports to the monitor port and conditionally connects driver and sequencer when configured active.

An agent may be configured as:

| **Agent Mode** | **Description**                         |
|----------------|-----------------------------------------|
| Active         | Contains sequencer, driver, and monitor |
| Passive        | Contains monitor only                   |
| Reactive       | Monitors and responds to DUT behavior   |

For this video-processing system, an active camera/VCP agent drives stimulus and monitors results.

## 22.15 Scoreboard Architecture

The scoreboard answers whether the DUT output is correct. The source document states that the scoreboard collects DUT operation data and compares it with expected values. It receives expected transactions from a predictor and actual DUT output transactions from a monitor.

A scoreboard architecture is:

Input Monitor

↓

Predictor / Reference Model

↓

Expected Transaction Queue

↓

Actual Output Monitor

↓

Comparison Engine

↓

Pass / Fail / Error Report

### 22.15.1 Scoreboard Checks

| **Check**             | **Description**                                         |
|-----------------------|---------------------------------------------------------|
| Pixel value match     | Compares expected RGB to actual RGB.                    |
| Latency alignment     | Accounts for pipeline delay.                            |
| Frame length          | Verifies expected number of pixels per frame.           |
| Line length           | Verifies expected pixels per line.                      |
| Register side effects | Confirms register writes affect output correctly.       |
| Mode behavior         | Confirms selected mode matches expected transformation. |
| Error flags           | Confirms invalid conditions produce correct status.     |

## 22.16 Predictor and Reference Model

A predictor computes the expected DUT output based on the input transaction and active configuration.

Reference models may include:

| **DUT Function** | **Reference Model**                    |
|------------------|----------------------------------------|
| RGB pass-through | Output equals input after latency      |
| Sharp filter     | 3×3 convolution model                  |
| Blur filter      | Averaging convolution model            |
| Emboss filter    | Signed kernel model                    |
| Sobel            | Gradient magnitude and threshold model |
| RGB to HSL       | Software color-space conversion        |
| HSL to RGB       | Inverse color-space conversion         |
| Color correction | 3×3 matrix multiply model              |
| K-means          | Minimum-distance palette model         |
| Histogram        | Bin-count model                        |

The predictor should be bit-accurate when checking RTL output. When mathematical differences are expected due to rounding, the scoreboard should use a documented tolerance.

## 22.17 Environment

The environment builds and connects the verification components. The source document states that the D5M camera environment creates and configures an agent to stimulate the DUT and creates a scoreboard, then connects the agent to the scoreboard.

A representative environment includes:

class d5m_env extends uvm_env;

d5m_agent agent;

d5m_scoreboard scoreboard;

d5m_coverage coverage;

function void build_phase(uvm_phase phase);

super.build_phase(phase);

agent = d5m_agent::type_id::create("agent", this);

scoreboard = d5m_scoreboard::type_id::create("scoreboard", this);

coverage = d5m_coverage::type_id::create("coverage", this);

endfunction

function void connect_phase(uvm_phase phase);

agent.monitor.analysis_port.connect(scoreboard.actual_export);

agent.monitor.analysis_port.connect(coverage.analysis_export);

endfunction

endclass

## 22.18 Test Class

The test class selects and runs the desired sequence. The source document states that the test class initiates and executes a sequence on the specified sequencer in the run phase. It also notes that the simulator command line specifies the selected test through +UVM_TESTNAME=test, after which the UVM factory creates the test component and starts phase methods through run_test.

A representative test structure is:

class sobel_test extends uvm_test;

d5m_env env;

function void build_phase(uvm_phase phase);

super.build_phase(phase);

env = d5m_env::type_id::create("env", this);

endfunction

task run_phase(uvm_phase phase);

sobel_sequence seq;

phase.raise_objection(this);

seq = sobel_sequence::type_id::create("seq");

seq.start(env.agent.sequencer);

phase.drop_objection(this);

endtask

endclass

## 22.19 Testbench Top

The top-level testbench instantiates the DUT, clock generators, reset generator, interfaces, and UVM startup.

A practical top-level structure is:

module testbench_top;

logic clk;

logic reset_n;

d5m_camera_if d5m_if(clk, reset_n);

dut_top dut (

.clk(clk),

.reset_n(reset_n),

.axi4(d5m_if.axi4),

.video(d5m_if.d5p)

);

initial begin

uvm_config_db#(virtual d5m_camera_if)::set(

null, "\*", "d5m_camera_vif", d5m_if

);

run_test();

end

endmodule

The testbench top connects physical simulation signals to UVM virtual interfaces and starts the selected test.

## 22.20 Functional Coverage

Coverage measures verification completeness. A video-processing verification plan should include coverage for:

| **Coverage Group** | **Coverpoints**                                  |
|--------------------|--------------------------------------------------|
| Filter mode        | Bypass, sharp, blur, emboss, Sobel               |
| Color mode         | RGB, HSL, HSV, YCbCr                             |
| CCM                | Identity, gain, negative coefficient, saturation |
| K-means            | K = 6, 9, 24, 51, 90                             |
| Threshold          | Low, medium, high, boundary values               |
| Image size         | 64×64, 128×128, 255×255, 1080p                   |
| AXI4-Lite          | Read, write, back-to-back, invalid address       |
| Pixel values       | 0, midrange, maximum, random                     |
| Frame protocol     | SOF, EOL, EOF, blanking, reset mid-frame         |
| Error handling     | Timeout, invalid response, overflow, underflow   |

The source test configuration includes selectable image sizes and filter enables for verification scenarios, including RGB, sharp, blur, emboss, HSL, HSV, color gain, and Sobel.

## 22.21 Assertion Strategy

Assertions should check protocol and design invariants.

Recommended assertions:

| **Assertion**            | **Purpose**                                            |
|--------------------------|--------------------------------------------------------|
| Valid data stability     | Pixel data stable while valid and not accepted         |
| SOF alignment            | SOF occurs only at first pixel of frame                |
| EOL alignment            | EOL occurs at expected line boundary                   |
| No output without input  | Output valid only after valid input and pipeline delay |
| AXI ready/valid protocol | AXI4-Lite handshakes obey protocol                     |
| Register reserved bits   | Reserved bits remain zero                              |
| No unknown output        | Output RGB never becomes X/Z after reset               |
| Frame length             | Output frame has expected pixel count                  |
| Coefficient update       | Active coefficients change only at safe boundary       |

Assertions catch failures earlier than scoreboard-only comparison.

## 22.22 Regression Test Plan

A full regression suite should include both directed and randomized tests.

| **Test Name**        | **Purpose**                                 |
|----------------------|---------------------------------------------|
| reset_test           | Verifies default state and reset recovery   |
| axi4_lite_rw_test    | Verifies register write/read behavior       |
| rgb_passthrough_test | Verifies baseline timing and output         |
| sharp_filter_test    | Verifies sharpening kernel                  |
| blur_filter_test     | Verifies smoothing kernel                   |
| emboss_filter_test   | Verifies emboss kernel                      |
| sobel_filter_test    | Verifies edge detection and threshold       |
| rgb_to_hsl_test      | Verifies RGB-to-HSL conversion              |
| hsl_to_rgb_test      | Verifies inverse conversion                 |
| ccm_test             | Verifies color correction matrix            |
| kmeans_test          | Verifies nearest palette selection          |
| histogram_test       | Verifies bin accumulation                   |
| local_threshold_test | Verifies local segmentation                 |
| random_mode_test     | Randomizes modes and parameters             |
| stress_frame_test    | Uses larger images and long frame sequences |

Each test should produce a pass/fail result through the scoreboard and log enough information for debug.

## 22.23 Image-Based Result Checking

Some image-processing blocks are easier to inspect visually. The testbench can generate output BMP files for manual or automated comparison.

Recommended outputs:

| **Output File** | **Purpose**                     |
|-----------------|---------------------------------|
| input.bmp       | Original input frame            |
| expected.bmp    | Software reference output       |
| actual.bmp      | DUT output                      |
| diff.bmp        | Pixel-by-pixel difference image |
| log.txt         | Mismatch and transaction log    |

Manual image checking is useful, but automated comparison should be the primary sign-off method.

## 22.24 Scoreboard Tolerance Policy

Some transformations involve division, rounding, or fixed-point approximation. The scoreboard should define a tolerance policy.

Example:

if abs(actual - expected) \<= tolerance:

pass

else:

fail

Recommended tolerance:

| **Function**           | **Tolerance**                              |
|------------------------|--------------------------------------------|
| Pass-through           | 0                                          |
| Simple register output | 0                                          |
| Kernel convolution     | 0 or 1 LSB depending on rounding           |
| RGB to HSL             | 1–2 LSB depending on scaling               |
| HSL to RGB             | 1–2 LSB depending on inverse approximation |
| CCM                    | 1 LSB if fixed-point rounding differs      |
| K-means                | 0 for selected cluster index               |
| Histogram              | 0 for final bin count                      |

Tolerance must be documented so failures are not hidden.

## 22.25 Debug and Logging

A structured debug system should report:

- Test name.

- Seed.

- Image size.

- Filter ID.

- Register writes.

- Register readback.

- First mismatch coordinate.

- Expected pixel.

- Actual pixel.

- Pipeline latency used.

- Frame and line counters.

- AXI timeout events.

- Scoreboard summary.

Example mismatch message:

ERROR: Pixel mismatch

Frame: 3

X: 124

Y: 87

Mode: SOBEL

Expected RGB: 255,255,255

Actual RGB: 0,0,0

Threshold: 32

Good logging reduces time-to-debug during regression failure analysis.

## 22.26 Common Verification Failure Modes

| **Failure Mode**         | **Likely Cause**                         | **Correction**                            |
|--------------------------|------------------------------------------|-------------------------------------------|
| Output shifted by pixels | Incorrect pipeline latency in scoreboard | Align expected output with DUT latency    |
| Frame starts late        | SOF delay mismatch                       | Delay SOF with pixel pipeline             |
| Register write ignored   | Wrong AXI address or decode              | Verify register map                       |
| AXI timeout              | Missing ready/valid response             | Debug AXI4-Lite slave FSM                 |
| Color channels swapped   | RGB packing mismatch                     | Verify channel order                      |
| Filter mismatch          | Kernel coefficient order wrong           | Verify k1–k9 layout                       |
| HSL mismatch             | Fixed-point rounding difference          | Define tolerance or improve model         |
| K-means mismatch         | Tie handling different                   | Document and model tie priority           |
| Histogram count mismatch | Read-modify-write hazard                 | Add forwarding or correct reference model |
| Random failure only      | Uninitialized state or X-propagation     | Improve reset and initialization          |

## 22.27 Verification Sign-Off Criteria

A design should not be considered verified until the following criteria are met:

| **Criterion**                      | **Required Evidence**                   |
|------------------------------------|-----------------------------------------|
| All directed tests pass            | Pass/fail logs                          |
| All register tests pass            | AXI4-Lite read/write report             |
| All image-processing modes checked | Scoreboard summary                      |
| Frame protocol verified            | Assertions and monitor reports          |
| Functional coverage closed         | Coverage report                         |
| No AXI protocol violations         | Assertion or VIP report                 |
| No unexplained X/Z outputs         | Simulation waveform or assertion result |
| Random regression stable           | Multiple seeds pass                     |
| Reference model aligned            | Expected/actual comparison validated    |
| Output images reviewed             | BMP or diff outputs archived            |

## 22.28 Hardware Design Recommendations for Verification

1.  **Keep verification models independent of RTL implementation.**  
    The predictor should model intended behavior, not copy RTL bugs.

2.  **Use both image-based and transaction-based checking.**  
    Visual image output is useful, but scoreboard automation is required.

3.  **Verify AXI4-Lite separately before full video tests.**  
    Configuration errors can invalidate all video tests.

4.  **Track pipeline latency explicitly.**  
    Every processing mode may have different latency.

5.  **Use active/shadow update tests.**  
    Verify that mode, coefficient, and palette changes occur only at safe frame boundaries.

6.  **Use small image sizes for fast regressions.**  
    Then run selected full-resolution tests for stress validation.

7.  **Create a coverage matrix for every filter and color-space mode.**  
    Untested modes should be visible in coverage reports.

8.  **Archive input, expected, actual, and difference images.**  
    These files are useful for regression triage and documentation.

## 22.29 Chapter Summary

This chapter described the Verification and Testbench Architecture for the FPGA Video Color Processing System. The design uses image-based VHDL testing and a UVM class-based verification environment. The VHDL testbench reads image files, applies RGB stimulus, waits for frame completion, and generates output BMP files for inspection. The UVM environment uses a test, environment, D5M agent, driver, monitor, scoreboard, sequence, sequencer, and transaction model to generate stimulus and check DUT behavior.

A complete verification architecture must validate AXI4-Lite register access, camera/video stimulus timing, image-processing correctness, frame protocol alignment, reset behavior, functional coverage, and scoreboard comparison against reference models. This verification structure provides the confidence required before FPGA synthesis, hardware bring-up, and live camera deployment.
