// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Sun Nov 15 00:35:38 2026
// Host        : LAPTOP-I3ECBFK4 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_ila_0_1/kv260_video_ila_0_1_stub.v
// Design      : kv260_video_ila_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "ila,Vivado 2022.1" *)
module kv260_video_ila_0_1(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[23:0],probe2[2:0],probe3[0:0],probe4[0:0],probe5[0:0],probe6[2:0],probe7[0:0],probe8[0:0]" */;
  input clk;
  input [0:0]probe0;
  input [23:0]probe1;
  input [2:0]probe2;
  input [0:0]probe3;
  input [0:0]probe4;
  input [0:0]probe5;
  input [2:0]probe6;
  input [0:0]probe7;
  input [0:0]probe8;
endmodule
