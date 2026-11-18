// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================

`timescale 1ps/1ps

module kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram # (
  // Common module parameters
  parameter integer                 DATA_WIDTH         = 10,
  parameter integer                 ADDR_WIDTH         = 12,
  parameter integer                 DEPTH              = 2049,

  // Port A module parameters
  parameter integer                 WRITE_DATA_WIDTH_A = DATA_WIDTH,
  parameter integer                 BYTE_WRITE_WIDTH_A = WRITE_DATA_WIDTH_A,
  parameter integer                 WRITE_ENABLE_WIDTH_A = WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A,
  parameter integer                 ADDR_WIDTH_A       = ADDR_WIDTH,

  // Port B module parameters
  parameter integer                 READ_DATA_WIDTH_B  = WRITE_DATA_WIDTH_A,
  parameter integer                 ADDR_WIDTH_B       = ADDR_WIDTH

) (
  // Port A module ports
  input  wire                                               clka,
  input  wire                                               ena,
  input  wire [WRITE_ENABLE_WIDTH_A-1:0]                    wea,
  input  wire [ADDR_WIDTH_A-1:0]                            addra,
  input  wire [DATA_WIDTH-1:0]                              dina,

  // Port B module ports
  input  wire                                               clkb,
  input  wire                                               rstb,
  input  wire                                               enb,
  input  wire [ADDR_WIDTH_B-1:0]                            addrb,
  output wire [DATA_WIDTH-1:0]                              doutb
);

  parameter integer                 MEMORY_SIZE        = DATA_WIDTH * DEPTH;
  parameter                         MEMORY_PRIMITIVE   = "ultra";
  parameter                         CLOCKING_MODE      = "common_clock";
  parameter                         ECC_MODE           = "no_ecc";
  parameter                         MEMORY_INIT_FILE   = "none";
  parameter                         WAKEUP_TIME        = "disable_sleep";
  parameter integer                 MESSAGE_CONTROL    = 0;
  parameter                         READ_RESET_VALUE_B = "0";
  parameter integer                 READ_LATENCY_B     = 1;
  parameter                         WRITE_MODE_B       = "read_first";


// Set parameter values and connect ports to instantiate an XPM_MEMORY simple dual port RAM configuration
xpm_memory_sdpram # (

  // Common module parameters
  .MEMORY_SIZE        (MEMORY_SIZE),           //positive integer
  .MEMORY_PRIMITIVE   (MEMORY_PRIMITIVE),      //string; "auto", "distributed", "block" or "ultra";
  .CLOCKING_MODE      (CLOCKING_MODE),         //string; "common_clock", "independent_clock"
  .ECC_MODE           (ECC_MODE),              //do not change
  .MEMORY_INIT_FILE   (MEMORY_INIT_FILE),      //string; "none" or "<filename>.mem" 
  .MEMORY_INIT_PARAM  ("0"), //string;
  .WAKEUP_TIME        (WAKEUP_TIME),           //string; "disable_sleep" or "use_sleep_pin"
  .MESSAGE_CONTROL    (MESSAGE_CONTROL),       //do not change

  // Port A module parameters
  .WRITE_DATA_WIDTH_A (WRITE_DATA_WIDTH_A),    //positive integer
  .BYTE_WRITE_WIDTH_A (BYTE_WRITE_WIDTH_A),    //integer; 8, 9, or WRITE_DATA_WIDTH_A value
  .ADDR_WIDTH_A       (ADDR_WIDTH_A),          //positive integer

  // Port B module parameters
  .READ_DATA_WIDTH_B  (READ_DATA_WIDTH_B),     //positive integer
  .ADDR_WIDTH_B       (ADDR_WIDTH_B),          //positive integer
  .READ_RESET_VALUE_B (READ_RESET_VALUE_B),    //string
  .READ_LATENCY_B     (READ_LATENCY_B),        //non-negative integer
  .WRITE_MODE_B       (WRITE_MODE_B)           //string; "write_first", "read_first", "no_change"

) xpm_memory_sdpram_inst (

  // Common module ports
  .sleep          (1'b0),  //do not change

  // Port A module ports
  .clka           (clka),
  .ena            (ena),
  .wea            (wea),
  .addra          (addra),
  .dina           (dina),
  .injectsbiterra (1'b0),  //do not change
  .injectdbiterra (1'b0),  //do not change

  // Port B module ports
  .clkb           (clkb),
  .rstb           (rstb),
  .enb            (enb),
  .regceb         (enb),
  .addrb          (addrb),
  .doutb          (doutb),
  .sbiterrb       (),      //do not change
  .dbiterrb       ()       //do not change

);


endmodule : kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram

`timescale 1 ns / 1 ps
module kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W(
    reset,
    clk,
    address0,
    ce0,
    address1,
    ce1,
    we0,
    d0,
    q1);

parameter DataWidth = 32'd10;
parameter AddressRange = 32'd2049;
parameter AddressWidth = 32'd12;
input reset;
input clk;
input[AddressWidth - 1:0] address0;
input ce0;
input[AddressWidth - 1:0] address1;
input ce1;
input we0;
input[DataWidth - 1:0] d0;
output[DataWidth - 1:0] q1;



kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram #(
.DATA_WIDTH( DataWidth ),
.ADDR_WIDTH( AddressWidth ),
.DEPTH( AddressRange ))
kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram_U(
    .clka( clk ),
    .clkb( clk ),
    .rstb( reset ),
    .addra( address0 ),
    .ena( ce0 ),
    .addrb( address1 ),
    .enb( ce1 ),
    .dina( d0 ),
    .wea( we0 ),
    .doutb( q1 ));

endmodule

