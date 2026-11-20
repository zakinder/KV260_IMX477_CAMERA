-- (c) Copyright 1995-2026 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:user:vfp:2.0
-- IP Revision: 162

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY kv260_video_vfp_0_0 IS
  PORT (
    vfpconfig_aclk : IN STD_LOGIC;
    vfpconfig_aresetn : IN STD_LOGIC;
    vfpconfig_awaddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    vfpconfig_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    vfpconfig_awvalid : IN STD_LOGIC;
    vfpconfig_awready : OUT STD_LOGIC;
    vfpconfig_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    vfpconfig_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    vfpconfig_wvalid : IN STD_LOGIC;
    vfpconfig_wready : OUT STD_LOGIC;
    vfpconfig_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    vfpconfig_bvalid : OUT STD_LOGIC;
    vfpconfig_bready : IN STD_LOGIC;
    vfpconfig_araddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    vfpconfig_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    vfpconfig_arvalid : IN STD_LOGIC;
    vfpconfig_arready : OUT STD_LOGIC;
    vfpconfig_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    vfpconfig_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    vfpconfig_rvalid : OUT STD_LOGIC;
    vfpconfig_rready : IN STD_LOGIC;
    ovideo_aclk : IN STD_LOGIC;
    ovideo_aresetn : IN STD_LOGIC;
    ovideo_tvalid : OUT STD_LOGIC;
    ovideo_tkeep : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    ovideo_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    ovideo_tstrb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    ovideo_tlast : OUT STD_LOGIC;
    ovideo_tready : IN STD_LOGIC;
    ovideo_tuser : OUT STD_LOGIC;
    o1video_aclk : IN STD_LOGIC;
    o1video_aresetn : IN STD_LOGIC;
    o1video_tvalid : OUT STD_LOGIC;
    o1video_tkeep : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    o1video_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    o1video_tstrb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    o1video_tlast : OUT STD_LOGIC;
    o1video_tready : IN STD_LOGIC;
    o1video_tuser : OUT STD_LOGIC;
    rgb_fr_plw_red : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    rgb_fr_plw_gre : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    rgb_fr_plw_blu : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    rgb_fr_plw_sof : OUT STD_LOGIC;
    rgb_fr_plw_eol : OUT STD_LOGIC;
    rgb_fr_plw_eof : OUT STD_LOGIC;
    rgb_fr_plw_val : OUT STD_LOGIC;
    rgb_fr_plw_xcnt : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    rgb_fr_plw_ycnt : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    crd_x : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    crd_y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    ivideo_aclk : IN STD_LOGIC;
    ivideo_aresetn : IN STD_LOGIC;
    ivideo_tready : OUT STD_LOGIC;
    ivideo_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    ivideo_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ivideo_tstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    ivideo_tlast : IN STD_LOGIC;
    ivideo_tuser : IN STD_LOGIC;
    ivideo_tvalid : IN STD_LOGIC;
    video2_aclk : IN STD_LOGIC;
    video2_aresetn : IN STD_LOGIC;
    video2_tready : OUT STD_LOGIC;
    video2_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    video2_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    video2_tstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    video2_tlast : IN STD_LOGIC;
    video2_tuser : IN STD_LOGIC;
    video2_tvalid : IN STD_LOGIC
  );
END kv260_video_vfp_0_0;

ARCHITECTURE kv260_video_vfp_0_0_arch OF kv260_video_vfp_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF kv260_video_vfp_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT vfp_v1_0 IS
    GENERIC (
      revision_number : STD_LOGIC_VECTOR(31 DOWNTO 0);
      C_vfpConfig_DATA_WIDTH : INTEGER;
      C_vfpConfig_ADDR_WIDTH : INTEGER;
      C_oVideo_TDATA_WIDTH : INTEGER;
      C_oVideo_START_COUNT : INTEGER;
      C_iVideo_TDATA_WIDTH : INTEGER;
      FRAME_WIDTH : INTEGER;
      FRAME_HEIGHT : INTEGER;
      FRAME_PIXEL_DEPTH : INTEGER
    );
    PORT (
      vfpconfig_aclk : IN STD_LOGIC;
      vfpconfig_aresetn : IN STD_LOGIC;
      vfpconfig_awaddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      vfpconfig_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      vfpconfig_awvalid : IN STD_LOGIC;
      vfpconfig_awready : OUT STD_LOGIC;
      vfpconfig_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      vfpconfig_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      vfpconfig_wvalid : IN STD_LOGIC;
      vfpconfig_wready : OUT STD_LOGIC;
      vfpconfig_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      vfpconfig_bvalid : OUT STD_LOGIC;
      vfpconfig_bready : IN STD_LOGIC;
      vfpconfig_araddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      vfpconfig_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      vfpconfig_arvalid : IN STD_LOGIC;
      vfpconfig_arready : OUT STD_LOGIC;
      vfpconfig_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      vfpconfig_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      vfpconfig_rvalid : OUT STD_LOGIC;
      vfpconfig_rready : IN STD_LOGIC;
      ovideo_aclk : IN STD_LOGIC;
      ovideo_aresetn : IN STD_LOGIC;
      ovideo_tvalid : OUT STD_LOGIC;
      ovideo_tkeep : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      ovideo_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      ovideo_tstrb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      ovideo_tlast : OUT STD_LOGIC;
      ovideo_tready : IN STD_LOGIC;
      ovideo_tuser : OUT STD_LOGIC;
      o1video_aclk : IN STD_LOGIC;
      o1video_aresetn : IN STD_LOGIC;
      o1video_tvalid : OUT STD_LOGIC;
      o1video_tkeep : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      o1video_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      o1video_tstrb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      o1video_tlast : OUT STD_LOGIC;
      o1video_tready : IN STD_LOGIC;
      o1video_tuser : OUT STD_LOGIC;
      rgb_fr_plw_red : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      rgb_fr_plw_gre : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      rgb_fr_plw_blu : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      rgb_fr_plw_sof : OUT STD_LOGIC;
      rgb_fr_plw_eol : OUT STD_LOGIC;
      rgb_fr_plw_eof : OUT STD_LOGIC;
      rgb_fr_plw_val : OUT STD_LOGIC;
      rgb_fr_plw_xcnt : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      rgb_fr_plw_ycnt : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      crd_x : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      crd_y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      ivideo_aclk : IN STD_LOGIC;
      ivideo_aresetn : IN STD_LOGIC;
      ivideo_tready : OUT STD_LOGIC;
      ivideo_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ivideo_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ivideo_tstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ivideo_tlast : IN STD_LOGIC;
      ivideo_tuser : IN STD_LOGIC;
      ivideo_tvalid : IN STD_LOGIC;
      video2_aclk : IN STD_LOGIC;
      video2_aresetn : IN STD_LOGIC;
      video2_tready : OUT STD_LOGIC;
      video2_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      video2_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      video2_tstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      video2_tlast : IN STD_LOGIC;
      video2_tuser : IN STD_LOGIC;
      video2_tvalid : IN STD_LOGIC
    );
  END COMPONENT vfp_v1_0;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF ivideo_aclk: SIGNAL IS "XIL_INTERFACENAME ivideo_aclk, ASSOCIATED_BUSIF ivideo, ASSOCIATED_RESET ivideo_aresetn, FREQ_HZ 299997000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_video_clk_wiz_1_0_clk_out1, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF ivideo_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 ivideo_aclk CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF ivideo_aresetn: SIGNAL IS "XIL_INTERFACENAME ivideo_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF ivideo_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 ivideo_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF ivideo_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 ivideo TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF ivideo_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 ivideo TKEEP";
  ATTRIBUTE X_INTERFACE_INFO OF ivideo_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 ivideo TLAST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF ivideo_tready: SIGNAL IS "XIL_INTERFACENAME ivideo, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 299997000, PHASE 0.0, CLK_DOMAIN kv260_video_clk_wiz_1_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF ivideo_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 ivideo TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF ivideo_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 ivideo TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF ivideo_tuser: SIGNAL IS "xilinx.com:interface:axis:1.0 ivideo TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF ivideo_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 ivideo TVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF o1video_aclk: SIGNAL IS "XIL_INTERFACENAME o1video_aclk, ASSOCIATED_RESET o1video_aresetn, ASSOCIATED_BUSIF o1video, FREQ_HZ 299997000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_video_clk_wiz_1_0_clk_out1, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF o1video_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 o1video_aclk CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF o1video_aresetn: SIGNAL IS "XIL_INTERFACENAME o1video_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF o1video_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 o1video_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF o1video_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 o1video TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF o1video_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 o1video TKEEP";
  ATTRIBUTE X_INTERFACE_INFO OF o1video_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 o1video TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF o1video_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 o1video TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF o1video_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 o1video TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF o1video_tuser: SIGNAL IS "xilinx.com:interface:axis:1.0 o1video TUSER";
  ATTRIBUTE X_INTERFACE_PARAMETER OF o1video_tvalid: SIGNAL IS "XIL_INTERFACENAME o1video, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 299997000, PHASE 0.0, CLK_DOMAIN kv260_video_clk_wiz_1_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF o1video_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 o1video TVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF ovideo_aclk: SIGNAL IS "XIL_INTERFACENAME ovideo_aclk, ASSOCIATED_BUSIF ovideo, ASSOCIATED_RESET ovideo_aresetn, FREQ_HZ 299997000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_video_clk_wiz_1_0_clk_out1, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF ovideo_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 ovideo_aclk CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF ovideo_aresetn: SIGNAL IS "XIL_INTERFACENAME ovideo_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF ovideo_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 ovideo_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF ovideo_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 ovideo TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF ovideo_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 ovideo TKEEP";
  ATTRIBUTE X_INTERFACE_INFO OF ovideo_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 ovideo TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF ovideo_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 ovideo TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF ovideo_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 ovideo TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF ovideo_tuser: SIGNAL IS "xilinx.com:interface:axis:1.0 ovideo TUSER";
  ATTRIBUTE X_INTERFACE_PARAMETER OF ovideo_tvalid: SIGNAL IS "XIL_INTERFACENAME ovideo, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 299997000, PHASE 0.0, CLK_DOMAIN kv260_video_clk_wiz_1_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF ovideo_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 ovideo TVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF vfpconfig_aclk: SIGNAL IS "XIL_INTERFACENAME vfpconfig_aclk, ASSOCIATED_BUSIF vfpconfig, ASSOCIATED_RESET vfpconfig_aresetn, FREQ_HZ 299997000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_video_clk_wiz_1_0_clk_out1, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 vfpconfig_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig ARADDR";
  ATTRIBUTE X_INTERFACE_PARAMETER OF vfpconfig_aresetn: SIGNAL IS "XIL_INTERFACENAME vfpconfig_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 vfpconfig_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_arprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig ARPROT";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig ARVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF vfpconfig_awaddr: SIGNAL IS "XIL_INTERFACENAME vfpconfig, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 64, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 8, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN kv260_video_clk_wiz_1_" & 
"0_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig AWPROT";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_rresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF vfpconfig_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 vfpconfig WVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF video2_aclk: SIGNAL IS "XIL_INTERFACENAME video2_aclk, ASSOCIATED_RESET video2_aresetn, ASSOCIATED_BUSIF video2, FREQ_HZ 299997000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_video_clk_wiz_1_0_clk_out1, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF video2_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 video2_aclk CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF video2_aresetn: SIGNAL IS "XIL_INTERFACENAME video2_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF video2_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 video2_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF video2_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 video2 TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF video2_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 video2 TKEEP";
  ATTRIBUTE X_INTERFACE_INFO OF video2_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 video2 TLAST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF video2_tready: SIGNAL IS "XIL_INTERFACENAME video2, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 299997000, PHASE 0.0, CLK_DOMAIN kv260_video_clk_wiz_1_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF video2_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 video2 TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF video2_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 video2 TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF video2_tuser: SIGNAL IS "xilinx.com:interface:axis:1.0 video2 TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF video2_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 video2 TVALID";
BEGIN
  U0 : vfp_v1_0
    GENERIC MAP (
      revision_number => X"12032022",
      C_vfpConfig_DATA_WIDTH => 32,
      C_vfpConfig_ADDR_WIDTH => 8,
      C_oVideo_TDATA_WIDTH => 32,
      C_oVideo_START_COUNT => 32,
      C_iVideo_TDATA_WIDTH => 32,
      FRAME_WIDTH => 4096,
      FRAME_HEIGHT => 3040,
      FRAME_PIXEL_DEPTH => 10
    )
    PORT MAP (
      vfpconfig_aclk => vfpconfig_aclk,
      vfpconfig_aresetn => vfpconfig_aresetn,
      vfpconfig_awaddr => vfpconfig_awaddr,
      vfpconfig_awprot => vfpconfig_awprot,
      vfpconfig_awvalid => vfpconfig_awvalid,
      vfpconfig_awready => vfpconfig_awready,
      vfpconfig_wdata => vfpconfig_wdata,
      vfpconfig_wstrb => vfpconfig_wstrb,
      vfpconfig_wvalid => vfpconfig_wvalid,
      vfpconfig_wready => vfpconfig_wready,
      vfpconfig_bresp => vfpconfig_bresp,
      vfpconfig_bvalid => vfpconfig_bvalid,
      vfpconfig_bready => vfpconfig_bready,
      vfpconfig_araddr => vfpconfig_araddr,
      vfpconfig_arprot => vfpconfig_arprot,
      vfpconfig_arvalid => vfpconfig_arvalid,
      vfpconfig_arready => vfpconfig_arready,
      vfpconfig_rdata => vfpconfig_rdata,
      vfpconfig_rresp => vfpconfig_rresp,
      vfpconfig_rvalid => vfpconfig_rvalid,
      vfpconfig_rready => vfpconfig_rready,
      ovideo_aclk => ovideo_aclk,
      ovideo_aresetn => ovideo_aresetn,
      ovideo_tvalid => ovideo_tvalid,
      ovideo_tkeep => ovideo_tkeep,
      ovideo_tdata => ovideo_tdata,
      ovideo_tstrb => ovideo_tstrb,
      ovideo_tlast => ovideo_tlast,
      ovideo_tready => ovideo_tready,
      ovideo_tuser => ovideo_tuser,
      o1video_aclk => o1video_aclk,
      o1video_aresetn => o1video_aresetn,
      o1video_tvalid => o1video_tvalid,
      o1video_tkeep => o1video_tkeep,
      o1video_tdata => o1video_tdata,
      o1video_tstrb => o1video_tstrb,
      o1video_tlast => o1video_tlast,
      o1video_tready => o1video_tready,
      o1video_tuser => o1video_tuser,
      rgb_fr_plw_red => rgb_fr_plw_red,
      rgb_fr_plw_gre => rgb_fr_plw_gre,
      rgb_fr_plw_blu => rgb_fr_plw_blu,
      rgb_fr_plw_sof => rgb_fr_plw_sof,
      rgb_fr_plw_eol => rgb_fr_plw_eol,
      rgb_fr_plw_eof => rgb_fr_plw_eof,
      rgb_fr_plw_val => rgb_fr_plw_val,
      rgb_fr_plw_xcnt => rgb_fr_plw_xcnt,
      rgb_fr_plw_ycnt => rgb_fr_plw_ycnt,
      crd_x => crd_x,
      crd_y => crd_y,
      ivideo_aclk => ivideo_aclk,
      ivideo_aresetn => ivideo_aresetn,
      ivideo_tready => ivideo_tready,
      ivideo_tkeep => ivideo_tkeep,
      ivideo_tdata => ivideo_tdata,
      ivideo_tstrb => ivideo_tstrb,
      ivideo_tlast => ivideo_tlast,
      ivideo_tuser => ivideo_tuser,
      ivideo_tvalid => ivideo_tvalid,
      video2_aclk => video2_aclk,
      video2_aresetn => video2_aresetn,
      video2_tready => video2_tready,
      video2_tkeep => video2_tkeep,
      video2_tdata => video2_tdata,
      video2_tstrb => video2_tstrb,
      video2_tlast => video2_tlast,
      video2_tuser => video2_tuser,
      video2_tvalid => video2_tvalid
    );
END kv260_video_vfp_0_0_arch;
