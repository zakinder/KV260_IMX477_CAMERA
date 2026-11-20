-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Thu Nov 19 12:01:02 2026
-- Host        : LAPTOP-I3ECBFK4 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ kv260_video_vfp_0_0_stub.vhdl
-- Design      : kv260_video_vfp_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xck26-sfvc784-2LV-c
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    vfpconfig_aclk : in STD_LOGIC;
    vfpconfig_aresetn : in STD_LOGIC;
    vfpconfig_awaddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    vfpconfig_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    vfpconfig_awvalid : in STD_LOGIC;
    vfpconfig_awready : out STD_LOGIC;
    vfpconfig_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    vfpconfig_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    vfpconfig_wvalid : in STD_LOGIC;
    vfpconfig_wready : out STD_LOGIC;
    vfpconfig_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    vfpconfig_bvalid : out STD_LOGIC;
    vfpconfig_bready : in STD_LOGIC;
    vfpconfig_araddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    vfpconfig_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    vfpconfig_arvalid : in STD_LOGIC;
    vfpconfig_arready : out STD_LOGIC;
    vfpconfig_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    vfpconfig_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    vfpconfig_rvalid : out STD_LOGIC;
    vfpconfig_rready : in STD_LOGIC;
    ovideo_aclk : in STD_LOGIC;
    ovideo_aresetn : in STD_LOGIC;
    ovideo_tvalid : out STD_LOGIC;
    ovideo_tkeep : out STD_LOGIC_VECTOR ( 2 downto 0 );
    ovideo_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 );
    ovideo_tstrb : out STD_LOGIC_VECTOR ( 2 downto 0 );
    ovideo_tlast : out STD_LOGIC;
    ovideo_tready : in STD_LOGIC;
    ovideo_tuser : out STD_LOGIC;
    o1video_aclk : in STD_LOGIC;
    o1video_aresetn : in STD_LOGIC;
    o1video_tvalid : out STD_LOGIC;
    o1video_tkeep : out STD_LOGIC_VECTOR ( 2 downto 0 );
    o1video_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 );
    o1video_tstrb : out STD_LOGIC_VECTOR ( 2 downto 0 );
    o1video_tlast : out STD_LOGIC;
    o1video_tready : in STD_LOGIC;
    o1video_tuser : out STD_LOGIC;
    rgb_fr_plw_red : out STD_LOGIC_VECTOR ( 9 downto 0 );
    rgb_fr_plw_gre : out STD_LOGIC_VECTOR ( 9 downto 0 );
    rgb_fr_plw_blu : out STD_LOGIC_VECTOR ( 9 downto 0 );
    rgb_fr_plw_sof : out STD_LOGIC;
    rgb_fr_plw_eol : out STD_LOGIC;
    rgb_fr_plw_eof : out STD_LOGIC;
    rgb_fr_plw_val : out STD_LOGIC;
    rgb_fr_plw_xcnt : out STD_LOGIC_VECTOR ( 15 downto 0 );
    rgb_fr_plw_ycnt : out STD_LOGIC_VECTOR ( 15 downto 0 );
    crd_x : out STD_LOGIC_VECTOR ( 15 downto 0 );
    crd_y : out STD_LOGIC_VECTOR ( 15 downto 0 );
    ivideo_aclk : in STD_LOGIC;
    ivideo_aresetn : in STD_LOGIC;
    ivideo_tready : out STD_LOGIC;
    ivideo_tkeep : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ivideo_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    ivideo_tstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ivideo_tlast : in STD_LOGIC;
    ivideo_tuser : in STD_LOGIC;
    ivideo_tvalid : in STD_LOGIC;
    video2_aclk : in STD_LOGIC;
    video2_aresetn : in STD_LOGIC;
    video2_tready : out STD_LOGIC;
    video2_tkeep : in STD_LOGIC_VECTOR ( 3 downto 0 );
    video2_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    video2_tstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    video2_tlast : in STD_LOGIC;
    video2_tuser : in STD_LOGIC;
    video2_tvalid : in STD_LOGIC
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "vfpconfig_aclk,vfpconfig_aresetn,vfpconfig_awaddr[7:0],vfpconfig_awprot[2:0],vfpconfig_awvalid,vfpconfig_awready,vfpconfig_wdata[31:0],vfpconfig_wstrb[3:0],vfpconfig_wvalid,vfpconfig_wready,vfpconfig_bresp[1:0],vfpconfig_bvalid,vfpconfig_bready,vfpconfig_araddr[7:0],vfpconfig_arprot[2:0],vfpconfig_arvalid,vfpconfig_arready,vfpconfig_rdata[31:0],vfpconfig_rresp[1:0],vfpconfig_rvalid,vfpconfig_rready,ovideo_aclk,ovideo_aresetn,ovideo_tvalid,ovideo_tkeep[2:0],ovideo_tdata[23:0],ovideo_tstrb[2:0],ovideo_tlast,ovideo_tready,ovideo_tuser,o1video_aclk,o1video_aresetn,o1video_tvalid,o1video_tkeep[2:0],o1video_tdata[23:0],o1video_tstrb[2:0],o1video_tlast,o1video_tready,o1video_tuser,rgb_fr_plw_red[9:0],rgb_fr_plw_gre[9:0],rgb_fr_plw_blu[9:0],rgb_fr_plw_sof,rgb_fr_plw_eol,rgb_fr_plw_eof,rgb_fr_plw_val,rgb_fr_plw_xcnt[15:0],rgb_fr_plw_ycnt[15:0],crd_x[15:0],crd_y[15:0],ivideo_aclk,ivideo_aresetn,ivideo_tready,ivideo_tkeep[3:0],ivideo_tdata[31:0],ivideo_tstrb[3:0],ivideo_tlast,ivideo_tuser,ivideo_tvalid,video2_aclk,video2_aresetn,video2_tready,video2_tkeep[3:0],video2_tdata[31:0],video2_tstrb[3:0],video2_tlast,video2_tuser,video2_tvalid";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "vfp_v1_0,Vivado 2022.1";
begin
end;
