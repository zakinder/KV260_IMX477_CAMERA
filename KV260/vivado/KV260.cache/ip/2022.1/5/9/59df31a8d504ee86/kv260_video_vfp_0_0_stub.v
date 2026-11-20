// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Nov 20 13:35:50 2026
// Host        : LAPTOP-I3ECBFK4 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ kv260_video_vfp_0_0_stub.v
// Design      : kv260_video_vfp_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "vfp_v1_0,Vivado 2022.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(vfpconfig_aclk, vfpconfig_aresetn, 
  vfpconfig_awaddr, vfpconfig_awprot, vfpconfig_awvalid, vfpconfig_awready, 
  vfpconfig_wdata, vfpconfig_wstrb, vfpconfig_wvalid, vfpconfig_wready, vfpconfig_bresp, 
  vfpconfig_bvalid, vfpconfig_bready, vfpconfig_araddr, vfpconfig_arprot, 
  vfpconfig_arvalid, vfpconfig_arready, vfpconfig_rdata, vfpconfig_rresp, vfpconfig_rvalid, 
  vfpconfig_rready, ovideo_aclk, ovideo_aresetn, ovideo_tvalid, ovideo_tkeep, ovideo_tdata, 
  ovideo_tstrb, ovideo_tlast, ovideo_tready, ovideo_tuser, o1video_aclk, o1video_aresetn, 
  o1video_tvalid, o1video_tkeep, o1video_tdata, o1video_tstrb, o1video_tlast, o1video_tready, 
  o1video_tuser, rgb_fr_plw_red, rgb_fr_plw_gre, rgb_fr_plw_blu, rgb_fr_plw_sof, 
  rgb_fr_plw_eol, rgb_fr_plw_eof, rgb_fr_plw_val, rgb_fr_plw_xcnt, rgb_fr_plw_ycnt, crd_x, 
  crd_y, ivideo_aclk, ivideo_aresetn, ivideo_tready, ivideo_tkeep, ivideo_tdata, ivideo_tstrb, 
  ivideo_tlast, ivideo_tuser, ivideo_tvalid, video2_aclk, video2_aresetn, video2_tready, 
  video2_tkeep, video2_tdata, video2_tstrb, video2_tlast, video2_tuser, video2_tvalid)
/* synthesis syn_black_box black_box_pad_pin="vfpconfig_aclk,vfpconfig_aresetn,vfpconfig_awaddr[7:0],vfpconfig_awprot[2:0],vfpconfig_awvalid,vfpconfig_awready,vfpconfig_wdata[31:0],vfpconfig_wstrb[3:0],vfpconfig_wvalid,vfpconfig_wready,vfpconfig_bresp[1:0],vfpconfig_bvalid,vfpconfig_bready,vfpconfig_araddr[7:0],vfpconfig_arprot[2:0],vfpconfig_arvalid,vfpconfig_arready,vfpconfig_rdata[31:0],vfpconfig_rresp[1:0],vfpconfig_rvalid,vfpconfig_rready,ovideo_aclk,ovideo_aresetn,ovideo_tvalid,ovideo_tkeep[2:0],ovideo_tdata[23:0],ovideo_tstrb[2:0],ovideo_tlast,ovideo_tready,ovideo_tuser,o1video_aclk,o1video_aresetn,o1video_tvalid,o1video_tkeep[2:0],o1video_tdata[23:0],o1video_tstrb[2:0],o1video_tlast,o1video_tready,o1video_tuser,rgb_fr_plw_red[9:0],rgb_fr_plw_gre[9:0],rgb_fr_plw_blu[9:0],rgb_fr_plw_sof,rgb_fr_plw_eol,rgb_fr_plw_eof,rgb_fr_plw_val,rgb_fr_plw_xcnt[15:0],rgb_fr_plw_ycnt[15:0],crd_x[15:0],crd_y[15:0],ivideo_aclk,ivideo_aresetn,ivideo_tready,ivideo_tkeep[3:0],ivideo_tdata[31:0],ivideo_tstrb[3:0],ivideo_tlast,ivideo_tuser,ivideo_tvalid,video2_aclk,video2_aresetn,video2_tready,video2_tkeep[3:0],video2_tdata[31:0],video2_tstrb[3:0],video2_tlast,video2_tuser,video2_tvalid" */;
  input vfpconfig_aclk;
  input vfpconfig_aresetn;
  input [7:0]vfpconfig_awaddr;
  input [2:0]vfpconfig_awprot;
  input vfpconfig_awvalid;
  output vfpconfig_awready;
  input [31:0]vfpconfig_wdata;
  input [3:0]vfpconfig_wstrb;
  input vfpconfig_wvalid;
  output vfpconfig_wready;
  output [1:0]vfpconfig_bresp;
  output vfpconfig_bvalid;
  input vfpconfig_bready;
  input [7:0]vfpconfig_araddr;
  input [2:0]vfpconfig_arprot;
  input vfpconfig_arvalid;
  output vfpconfig_arready;
  output [31:0]vfpconfig_rdata;
  output [1:0]vfpconfig_rresp;
  output vfpconfig_rvalid;
  input vfpconfig_rready;
  input ovideo_aclk;
  input ovideo_aresetn;
  output ovideo_tvalid;
  output [2:0]ovideo_tkeep;
  output [23:0]ovideo_tdata;
  output [2:0]ovideo_tstrb;
  output ovideo_tlast;
  input ovideo_tready;
  output ovideo_tuser;
  input o1video_aclk;
  input o1video_aresetn;
  output o1video_tvalid;
  output [2:0]o1video_tkeep;
  output [23:0]o1video_tdata;
  output [2:0]o1video_tstrb;
  output o1video_tlast;
  input o1video_tready;
  output o1video_tuser;
  output [9:0]rgb_fr_plw_red;
  output [9:0]rgb_fr_plw_gre;
  output [9:0]rgb_fr_plw_blu;
  output rgb_fr_plw_sof;
  output rgb_fr_plw_eol;
  output rgb_fr_plw_eof;
  output rgb_fr_plw_val;
  output [15:0]rgb_fr_plw_xcnt;
  output [15:0]rgb_fr_plw_ycnt;
  output [15:0]crd_x;
  output [15:0]crd_y;
  input ivideo_aclk;
  input ivideo_aresetn;
  output ivideo_tready;
  input [3:0]ivideo_tkeep;
  input [31:0]ivideo_tdata;
  input [3:0]ivideo_tstrb;
  input ivideo_tlast;
  input ivideo_tuser;
  input ivideo_tvalid;
  input video2_aclk;
  input video2_aresetn;
  output video2_tready;
  input [3:0]video2_tkeep;
  input [31:0]video2_tdata;
  input [3:0]video2_tstrb;
  input video2_tlast;
  input video2_tuser;
  input video2_tvalid;
endmodule
