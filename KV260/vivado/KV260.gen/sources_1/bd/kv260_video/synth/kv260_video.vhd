--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
--Date        : Fri Nov 20 13:08:37 2026
--Host        : LAPTOP-I3ECBFK4 running 64-bit major release  (build 9200)
--Command     : generate_target kv260_video.bd
--Design      : kv260_video
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity RX_VIDEO_imp_QQ232Y is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    csirxss_s_axi1_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    csirxss_s_axi1_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi1_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi1_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    csirxss_s_axi1_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi1_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi1_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi1_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    csirxss_s_axi1_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi1_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    csirxss_s_axi1_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi1_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    csirxss_s_axi1_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi1_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    csirxss_s_axi1_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi1_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    csirxss_s_axi1_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    csirxss_s_axi_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    csirxss_s_axi_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    csirxss_s_axi_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    csirxss_s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    csirxss_s_axi_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    csirxss_s_axi_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    csirxss_s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    csirxss_s_axi_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    dphy_clk_200M : in STD_LOGIC;
    m_axis_video_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 );
    m_axis_video_tkeep : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_video_tlast : out STD_LOGIC;
    m_axis_video_tready : in STD_LOGIC;
    m_axis_video_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_video_tvalid : out STD_LOGIC;
    mipi_phy_if_clk_n : in STD_LOGIC;
    mipi_phy_if_clk_p : in STD_LOGIC;
    mipi_phy_if_data_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_phy_if_data_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_rx_ias_clk_n : in STD_LOGIC;
    mipi_rx_ias_clk_p : in STD_LOGIC;
    mipi_rx_ias_data_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mipi_rx_ias_data_p : in STD_LOGIC_VECTOR ( 3 downto 0 );
    o1video_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 );
    o1video_tkeep : out STD_LOGIC_VECTOR ( 2 downto 0 );
    o1video_tlast : out STD_LOGIC;
    o1video_tready : in STD_LOGIC;
    o1video_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    o1video_tvalid : out STD_LOGIC;
    s_axi_CTRL1_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_CTRL1_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL1_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL1_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_CTRL1_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL1_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL1_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL1_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL1_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL1_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL1_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL1_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL1_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL1_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL1_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL1_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_CTRL1_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_CTRL_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_CTRL_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_CTRL_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    vfpconfig_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    vfpconfig_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    vfpconfig_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    vfpconfig_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    vfpconfig_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    vfpconfig_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    vfpconfig_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    vfpconfig_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    vfpconfig_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    vfpconfig_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    vfpconfig_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    vfpconfig_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    vfpconfig_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    vfpconfig_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    vfpconfig_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    vfpconfig_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    vfpconfig_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    vfpconfig_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    vfpconfig_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end RX_VIDEO_imp_QQ232Y;

architecture STRUCTURE of RX_VIDEO_imp_QQ232Y is
  component kv260_video_ila_0_0 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe4 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe7 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe10 : in STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  end component kv260_video_ila_0_0;
  component kv260_video_mipi_csi2_rx_subsyst_0_0 is
  port (
    lite_aclk : in STD_LOGIC;
    lite_aresetn : in STD_LOGIC;
    dphy_clk_200M : in STD_LOGIC;
    rxbyteclkhs : out STD_LOGIC;
    clkoutphy_out : out STD_LOGIC;
    system_rst_out : out STD_LOGIC;
    pll_lock_out : out STD_LOGIC;
    rxbyteclkhs_cnts_out : out STD_LOGIC;
    csirxss_csi_irq : out STD_LOGIC;
    video_aclk : in STD_LOGIC;
    video_aresetn : in STD_LOGIC;
    csirxss_s_axi_araddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    csirxss_s_axi_arready : out STD_LOGIC;
    csirxss_s_axi_arvalid : in STD_LOGIC;
    csirxss_s_axi_awaddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    csirxss_s_axi_awready : out STD_LOGIC;
    csirxss_s_axi_awvalid : in STD_LOGIC;
    csirxss_s_axi_bready : in STD_LOGIC;
    csirxss_s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    csirxss_s_axi_bvalid : out STD_LOGIC;
    csirxss_s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    csirxss_s_axi_rready : in STD_LOGIC;
    csirxss_s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    csirxss_s_axi_rvalid : out STD_LOGIC;
    csirxss_s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    csirxss_s_axi_wready : out STD_LOGIC;
    csirxss_s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    csirxss_s_axi_wvalid : in STD_LOGIC;
    video_out_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    video_out_tdest : out STD_LOGIC_VECTOR ( 9 downto 0 );
    video_out_tlast : out STD_LOGIC;
    video_out_tready : in STD_LOGIC;
    video_out_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    video_out_tvalid : out STD_LOGIC;
    mipi_phy_if_clk_n : in STD_LOGIC;
    mipi_phy_if_clk_p : in STD_LOGIC;
    mipi_phy_if_data_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_phy_if_data_p : in STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  end component kv260_video_mipi_csi2_rx_subsyst_0_0;
  component kv260_video_mipi_csi2_rx_subsyst_1_0 is
  port (
    lite_aclk : in STD_LOGIC;
    lite_aresetn : in STD_LOGIC;
    dphy_clk_200M : in STD_LOGIC;
    rxbyteclkhs : out STD_LOGIC;
    clkoutphy_out : out STD_LOGIC;
    system_rst_out : out STD_LOGIC;
    pll_lock_out : out STD_LOGIC;
    rxbyteclkhs_cnts_out : out STD_LOGIC;
    csirxss_csi_irq : out STD_LOGIC;
    video_aclk : in STD_LOGIC;
    video_aresetn : in STD_LOGIC;
    csirxss_s_axi_araddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    csirxss_s_axi_arready : out STD_LOGIC;
    csirxss_s_axi_arvalid : in STD_LOGIC;
    csirxss_s_axi_awaddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    csirxss_s_axi_awready : out STD_LOGIC;
    csirxss_s_axi_awvalid : in STD_LOGIC;
    csirxss_s_axi_bready : in STD_LOGIC;
    csirxss_s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    csirxss_s_axi_bvalid : out STD_LOGIC;
    csirxss_s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    csirxss_s_axi_rready : in STD_LOGIC;
    csirxss_s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    csirxss_s_axi_rvalid : out STD_LOGIC;
    csirxss_s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    csirxss_s_axi_wready : out STD_LOGIC;
    csirxss_s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    csirxss_s_axi_wvalid : in STD_LOGIC;
    video_out_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    video_out_tdest : out STD_LOGIC_VECTOR ( 9 downto 0 );
    video_out_tlast : out STD_LOGIC;
    video_out_tready : in STD_LOGIC;
    video_out_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    video_out_tvalid : out STD_LOGIC;
    mipi_phy_if_clk_n : in STD_LOGIC;
    mipi_phy_if_clk_p : in STD_LOGIC;
    mipi_phy_if_data_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mipi_phy_if_data_p : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component kv260_video_mipi_csi2_rx_subsyst_1_0;
  component kv260_video_v_demosaic_0_0 is
  port (
    s_axi_CTRL_AWADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_CTRL_AWVALID : in STD_LOGIC;
    s_axi_CTRL_AWREADY : out STD_LOGIC;
    s_axi_CTRL_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_CTRL_WVALID : in STD_LOGIC;
    s_axi_CTRL_WREADY : out STD_LOGIC;
    s_axi_CTRL_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL_BVALID : out STD_LOGIC;
    s_axi_CTRL_BREADY : in STD_LOGIC;
    s_axi_CTRL_ARADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_CTRL_ARVALID : in STD_LOGIC;
    s_axi_CTRL_ARREADY : out STD_LOGIC;
    s_axi_CTRL_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL_RVALID : out STD_LOGIC;
    s_axi_CTRL_RREADY : in STD_LOGIC;
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    interrupt : out STD_LOGIC;
    s_axis_video_TVALID : in STD_LOGIC;
    s_axis_video_TREADY : out STD_LOGIC;
    s_axis_video_TDATA : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_video_TKEEP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_video_TSTRB : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_video_TUSER : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_video_TLAST : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_video_TID : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_video_TDEST : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_video_TVALID : out STD_LOGIC;
    m_axis_video_TREADY : in STD_LOGIC;
    m_axis_video_TDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_video_TKEEP : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axis_video_TSTRB : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axis_video_TUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_video_TLAST : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_video_TID : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_video_TDEST : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component kv260_video_v_demosaic_0_0;
  component kv260_video_v_demosaic_1_0 is
  port (
    s_axi_CTRL_AWADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_CTRL_AWVALID : in STD_LOGIC;
    s_axi_CTRL_AWREADY : out STD_LOGIC;
    s_axi_CTRL_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_CTRL_WVALID : in STD_LOGIC;
    s_axi_CTRL_WREADY : out STD_LOGIC;
    s_axi_CTRL_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL_BVALID : out STD_LOGIC;
    s_axi_CTRL_BREADY : in STD_LOGIC;
    s_axi_CTRL_ARADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_CTRL_ARVALID : in STD_LOGIC;
    s_axi_CTRL_ARREADY : out STD_LOGIC;
    s_axi_CTRL_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL_RVALID : out STD_LOGIC;
    s_axi_CTRL_RREADY : in STD_LOGIC;
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    interrupt : out STD_LOGIC;
    s_axis_video_TVALID : in STD_LOGIC;
    s_axis_video_TREADY : out STD_LOGIC;
    s_axis_video_TDATA : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_video_TKEEP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_video_TSTRB : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_video_TUSER : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_video_TLAST : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_video_TID : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_video_TDEST : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_video_TVALID : out STD_LOGIC;
    m_axis_video_TREADY : in STD_LOGIC;
    m_axis_video_TDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_video_TKEEP : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axis_video_TSTRB : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axis_video_TUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_video_TLAST : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_video_TID : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_video_TDEST : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component kv260_video_v_demosaic_1_0;
  component kv260_video_vfp_0_0 is
  port (
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
  end component kv260_video_vfp_0_0;
  signal Conn1_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal Conn1_ARREADY : STD_LOGIC;
  signal Conn1_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn1_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal Conn1_AWREADY : STD_LOGIC;
  signal Conn1_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn1_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn1_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal Conn1_BVALID : STD_LOGIC;
  signal Conn1_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn1_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn1_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal Conn1_RVALID : STD_LOGIC;
  signal Conn1_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn1_WREADY : STD_LOGIC;
  signal Conn1_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal Conn1_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn2_CLK_N : STD_LOGIC;
  signal Conn2_CLK_P : STD_LOGIC;
  signal Conn2_DATA_N : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal Conn2_DATA_P : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal Conn4_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal Conn4_ARREADY : STD_LOGIC;
  signal Conn4_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn4_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal Conn4_AWREADY : STD_LOGIC;
  signal Conn4_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn4_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn4_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal Conn4_BVALID : STD_LOGIC;
  signal Conn4_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn4_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn4_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal Conn4_RVALID : STD_LOGIC;
  signal Conn4_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn4_WREADY : STD_LOGIC;
  signal Conn4_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal Conn4_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal csirxss_s_axi_1_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal csirxss_s_axi_1_ARREADY : STD_LOGIC;
  signal csirxss_s_axi_1_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal csirxss_s_axi_1_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal csirxss_s_axi_1_AWREADY : STD_LOGIC;
  signal csirxss_s_axi_1_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal csirxss_s_axi_1_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal csirxss_s_axi_1_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal csirxss_s_axi_1_BVALID : STD_LOGIC;
  signal csirxss_s_axi_1_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal csirxss_s_axi_1_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal csirxss_s_axi_1_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal csirxss_s_axi_1_RVALID : STD_LOGIC;
  signal csirxss_s_axi_1_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal csirxss_s_axi_1_WREADY : STD_LOGIC;
  signal csirxss_s_axi_1_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal csirxss_s_axi_1_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal dphy_clk_200M_1 : STD_LOGIC;
  signal mipi_csi2_rx_subsyst_0_video_out_TDATA : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal mipi_csi2_rx_subsyst_0_video_out_TDEST : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal mipi_csi2_rx_subsyst_0_video_out_TLAST : STD_LOGIC;
  signal mipi_csi2_rx_subsyst_0_video_out_TREADY : STD_LOGIC;
  signal mipi_csi2_rx_subsyst_0_video_out_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal mipi_csi2_rx_subsyst_0_video_out_TVALID : STD_LOGIC;
  signal mipi_csi2_rx_subsyst_1_video_out_TDATA : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal mipi_csi2_rx_subsyst_1_video_out_TDEST : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal mipi_csi2_rx_subsyst_1_video_out_TLAST : STD_LOGIC;
  signal mipi_csi2_rx_subsyst_1_video_out_TREADY : STD_LOGIC;
  signal mipi_csi2_rx_subsyst_1_video_out_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal mipi_csi2_rx_subsyst_1_video_out_TVALID : STD_LOGIC;
  signal mipi_phy_if_1_CLK_N : STD_LOGIC;
  signal mipi_phy_if_1_CLK_P : STD_LOGIC;
  signal mipi_phy_if_1_DATA_N : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal mipi_phy_if_1_DATA_P : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal rst_ps8_0_249M_peripheral_aresetn : STD_LOGIC;
  signal v_demosaic_0_m_axis_video_TDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal v_demosaic_0_m_axis_video_TKEEP : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal v_demosaic_0_m_axis_video_TLAST : STD_LOGIC_VECTOR ( 0 to 0 );
  signal v_demosaic_0_m_axis_video_TREADY : STD_LOGIC;
  signal v_demosaic_0_m_axis_video_TSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal v_demosaic_0_m_axis_video_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal v_demosaic_0_m_axis_video_TVALID : STD_LOGIC;
  signal v_demosaic_1_m_axis_video_TDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal v_demosaic_1_m_axis_video_TKEEP : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal v_demosaic_1_m_axis_video_TLAST : STD_LOGIC_VECTOR ( 0 to 0 );
  signal v_demosaic_1_m_axis_video_TREADY : STD_LOGIC;
  signal v_demosaic_1_m_axis_video_TSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal v_demosaic_1_m_axis_video_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal v_demosaic_1_m_axis_video_TVALID : STD_LOGIC;
  signal vfp_0_cord_x : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal vfp_0_cord_y : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal vfp_0_o1video_TDATA : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal vfp_0_o1video_TKEEP : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal vfp_0_o1video_TLAST : STD_LOGIC;
  signal vfp_0_o1video_TREADY : STD_LOGIC;
  signal vfp_0_o1video_TUSER : STD_LOGIC;
  signal vfp_0_o1video_TVALID : STD_LOGIC;
  signal vfp_0_ovideo_TDATA : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal vfp_0_ovideo_TKEEP : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal vfp_0_ovideo_TLAST : STD_LOGIC;
  signal vfp_0_ovideo_TREADY : STD_LOGIC;
  signal vfp_0_ovideo_TUSER : STD_LOGIC;
  signal vfp_0_ovideo_TVALID : STD_LOGIC;
  signal vfp_0_rgb_fr_plw_blu : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal vfp_0_rgb_fr_plw_eof : STD_LOGIC;
  signal vfp_0_rgb_fr_plw_eol : STD_LOGIC;
  signal vfp_0_rgb_fr_plw_gre : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal vfp_0_rgb_fr_plw_red : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal vfp_0_rgb_fr_plw_sof : STD_LOGIC;
  signal vfp_0_rgb_fr_plw_val : STD_LOGIC;
  signal vfp_0_rgb_fr_plw_xcnt : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal vfp_0_rgb_fr_plw_ycnt : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_pl_clk0 : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_0_clkoutphy_out_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_0_csirxss_csi_irq_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_0_pll_lock_out_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_0_rxbyteclkhs_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_0_rxbyteclkhs_cnts_out_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_0_system_rst_out_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_1_clkoutphy_out_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_1_csirxss_csi_irq_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_1_pll_lock_out_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_1_rxbyteclkhs_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_1_rxbyteclkhs_cnts_out_UNCONNECTED : STD_LOGIC;
  signal NLW_mipi_csi2_rx_subsyst_1_system_rst_out_UNCONNECTED : STD_LOGIC;
  signal NLW_v_demosaic_0_interrupt_UNCONNECTED : STD_LOGIC;
  signal NLW_v_demosaic_0_m_axis_video_TDEST_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_v_demosaic_0_m_axis_video_TID_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_v_demosaic_1_interrupt_UNCONNECTED : STD_LOGIC;
  signal NLW_v_demosaic_1_m_axis_video_TDEST_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_v_demosaic_1_m_axis_video_TID_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_vfp_0_o1video_tstrb_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_vfp_0_ovideo_tstrb_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
begin
  Conn1_ARADDR(39 downto 0) <= csirxss_s_axi1_araddr(39 downto 0);
  Conn1_ARVALID(0) <= csirxss_s_axi1_arvalid(0);
  Conn1_AWADDR(39 downto 0) <= csirxss_s_axi1_awaddr(39 downto 0);
  Conn1_AWVALID(0) <= csirxss_s_axi1_awvalid(0);
  Conn1_BREADY(0) <= csirxss_s_axi1_bready(0);
  Conn1_RREADY(0) <= csirxss_s_axi1_rready(0);
  Conn1_WDATA(31 downto 0) <= csirxss_s_axi1_wdata(31 downto 0);
  Conn1_WSTRB(3 downto 0) <= csirxss_s_axi1_wstrb(3 downto 0);
  Conn1_WVALID(0) <= csirxss_s_axi1_wvalid(0);
  Conn2_CLK_N <= mipi_rx_ias_clk_n;
  Conn2_CLK_P <= mipi_rx_ias_clk_p;
  Conn2_DATA_N(3 downto 0) <= mipi_rx_ias_data_n(3 downto 0);
  Conn2_DATA_P(3 downto 0) <= mipi_rx_ias_data_p(3 downto 0);
  Conn4_ARADDR(39 downto 0) <= s_axi_CTRL1_araddr(39 downto 0);
  Conn4_ARVALID(0) <= s_axi_CTRL1_arvalid(0);
  Conn4_AWADDR(39 downto 0) <= s_axi_CTRL1_awaddr(39 downto 0);
  Conn4_AWVALID(0) <= s_axi_CTRL1_awvalid(0);
  Conn4_BREADY(0) <= s_axi_CTRL1_bready(0);
  Conn4_RREADY(0) <= s_axi_CTRL1_rready(0);
  Conn4_WDATA(31 downto 0) <= s_axi_CTRL1_wdata(31 downto 0);
  Conn4_WSTRB(3 downto 0) <= s_axi_CTRL1_wstrb(3 downto 0);
  Conn4_WVALID(0) <= s_axi_CTRL1_wvalid(0);
  csirxss_s_axi1_arready(0) <= Conn1_ARREADY;
  csirxss_s_axi1_awready(0) <= Conn1_AWREADY;
  csirxss_s_axi1_bresp(1 downto 0) <= Conn1_BRESP(1 downto 0);
  csirxss_s_axi1_bvalid(0) <= Conn1_BVALID;
  csirxss_s_axi1_rdata(31 downto 0) <= Conn1_RDATA(31 downto 0);
  csirxss_s_axi1_rresp(1 downto 0) <= Conn1_RRESP(1 downto 0);
  csirxss_s_axi1_rvalid(0) <= Conn1_RVALID;
  csirxss_s_axi1_wready(0) <= Conn1_WREADY;
  csirxss_s_axi_1_ARADDR(39 downto 0) <= csirxss_s_axi_araddr(39 downto 0);
  csirxss_s_axi_1_ARVALID(0) <= csirxss_s_axi_arvalid(0);
  csirxss_s_axi_1_AWADDR(39 downto 0) <= csirxss_s_axi_awaddr(39 downto 0);
  csirxss_s_axi_1_AWVALID(0) <= csirxss_s_axi_awvalid(0);
  csirxss_s_axi_1_BREADY(0) <= csirxss_s_axi_bready(0);
  csirxss_s_axi_1_RREADY(0) <= csirxss_s_axi_rready(0);
  csirxss_s_axi_1_WDATA(31 downto 0) <= csirxss_s_axi_wdata(31 downto 0);
  csirxss_s_axi_1_WSTRB(3 downto 0) <= csirxss_s_axi_wstrb(3 downto 0);
  csirxss_s_axi_1_WVALID(0) <= csirxss_s_axi_wvalid(0);
  csirxss_s_axi_arready(0) <= csirxss_s_axi_1_ARREADY;
  csirxss_s_axi_awready(0) <= csirxss_s_axi_1_AWREADY;
  csirxss_s_axi_bresp(1 downto 0) <= csirxss_s_axi_1_BRESP(1 downto 0);
  csirxss_s_axi_bvalid(0) <= csirxss_s_axi_1_BVALID;
  csirxss_s_axi_rdata(31 downto 0) <= csirxss_s_axi_1_RDATA(31 downto 0);
  csirxss_s_axi_rresp(1 downto 0) <= csirxss_s_axi_1_RRESP(1 downto 0);
  csirxss_s_axi_rvalid(0) <= csirxss_s_axi_1_RVALID;
  csirxss_s_axi_wready(0) <= csirxss_s_axi_1_WREADY;
  dphy_clk_200M_1 <= dphy_clk_200M;
  m_axis_video_tdata(23 downto 0) <= vfp_0_ovideo_TDATA(23 downto 0);
  m_axis_video_tkeep(2 downto 0) <= vfp_0_ovideo_TKEEP(2 downto 0);
  m_axis_video_tlast <= vfp_0_ovideo_TLAST;
  m_axis_video_tuser(0) <= vfp_0_ovideo_TUSER;
  m_axis_video_tvalid <= vfp_0_ovideo_TVALID;
  mipi_phy_if_1_CLK_N <= mipi_phy_if_clk_n;
  mipi_phy_if_1_CLK_P <= mipi_phy_if_clk_p;
  mipi_phy_if_1_DATA_N(1 downto 0) <= mipi_phy_if_data_n(1 downto 0);
  mipi_phy_if_1_DATA_P(1 downto 0) <= mipi_phy_if_data_p(1 downto 0);
  o1video_tdata(23 downto 0) <= vfp_0_o1video_TDATA(23 downto 0);
  o1video_tkeep(2 downto 0) <= vfp_0_o1video_TKEEP(2 downto 0);
  o1video_tlast <= vfp_0_o1video_TLAST;
  o1video_tuser(0) <= vfp_0_o1video_TUSER;
  o1video_tvalid <= vfp_0_o1video_TVALID;
  ps8_0_axi_periph_M03_AXI_ARADDR(39 downto 0) <= s_axi_CTRL_araddr(39 downto 0);
  ps8_0_axi_periph_M03_AXI_ARVALID(0) <= s_axi_CTRL_arvalid(0);
  ps8_0_axi_periph_M03_AXI_AWADDR(39 downto 0) <= s_axi_CTRL_awaddr(39 downto 0);
  ps8_0_axi_periph_M03_AXI_AWVALID(0) <= s_axi_CTRL_awvalid(0);
  ps8_0_axi_periph_M03_AXI_BREADY(0) <= s_axi_CTRL_bready(0);
  ps8_0_axi_periph_M03_AXI_RREADY(0) <= s_axi_CTRL_rready(0);
  ps8_0_axi_periph_M03_AXI_WDATA(31 downto 0) <= s_axi_CTRL_wdata(31 downto 0);
  ps8_0_axi_periph_M03_AXI_WSTRB(3 downto 0) <= s_axi_CTRL_wstrb(3 downto 0);
  ps8_0_axi_periph_M03_AXI_WVALID(0) <= s_axi_CTRL_wvalid(0);
  ps8_0_axi_periph_M06_AXI_ARADDR(39 downto 0) <= vfpconfig_araddr(39 downto 0);
  ps8_0_axi_periph_M06_AXI_ARPROT(2 downto 0) <= vfpconfig_arprot(2 downto 0);
  ps8_0_axi_periph_M06_AXI_ARVALID(0) <= vfpconfig_arvalid(0);
  ps8_0_axi_periph_M06_AXI_AWADDR(39 downto 0) <= vfpconfig_awaddr(39 downto 0);
  ps8_0_axi_periph_M06_AXI_AWPROT(2 downto 0) <= vfpconfig_awprot(2 downto 0);
  ps8_0_axi_periph_M06_AXI_AWVALID(0) <= vfpconfig_awvalid(0);
  ps8_0_axi_periph_M06_AXI_BREADY(0) <= vfpconfig_bready(0);
  ps8_0_axi_periph_M06_AXI_RREADY(0) <= vfpconfig_rready(0);
  ps8_0_axi_periph_M06_AXI_WDATA(31 downto 0) <= vfpconfig_wdata(31 downto 0);
  ps8_0_axi_periph_M06_AXI_WSTRB(3 downto 0) <= vfpconfig_wstrb(3 downto 0);
  ps8_0_axi_periph_M06_AXI_WVALID(0) <= vfpconfig_wvalid(0);
  rst_ps8_0_249M_peripheral_aresetn <= aresetn;
  s_axi_CTRL1_arready(0) <= Conn4_ARREADY;
  s_axi_CTRL1_awready(0) <= Conn4_AWREADY;
  s_axi_CTRL1_bresp(1 downto 0) <= Conn4_BRESP(1 downto 0);
  s_axi_CTRL1_bvalid(0) <= Conn4_BVALID;
  s_axi_CTRL1_rdata(31 downto 0) <= Conn4_RDATA(31 downto 0);
  s_axi_CTRL1_rresp(1 downto 0) <= Conn4_RRESP(1 downto 0);
  s_axi_CTRL1_rvalid(0) <= Conn4_RVALID;
  s_axi_CTRL1_wready(0) <= Conn4_WREADY;
  s_axi_CTRL_arready(0) <= ps8_0_axi_periph_M03_AXI_ARREADY;
  s_axi_CTRL_awready(0) <= ps8_0_axi_periph_M03_AXI_AWREADY;
  s_axi_CTRL_bresp(1 downto 0) <= ps8_0_axi_periph_M03_AXI_BRESP(1 downto 0);
  s_axi_CTRL_bvalid(0) <= ps8_0_axi_periph_M03_AXI_BVALID;
  s_axi_CTRL_rdata(31 downto 0) <= ps8_0_axi_periph_M03_AXI_RDATA(31 downto 0);
  s_axi_CTRL_rresp(1 downto 0) <= ps8_0_axi_periph_M03_AXI_RRESP(1 downto 0);
  s_axi_CTRL_rvalid(0) <= ps8_0_axi_periph_M03_AXI_RVALID;
  s_axi_CTRL_wready(0) <= ps8_0_axi_periph_M03_AXI_WREADY;
  vfp_0_o1video_TREADY <= o1video_tready;
  vfp_0_ovideo_TREADY <= m_axis_video_tready;
  vfpconfig_arready(0) <= ps8_0_axi_periph_M06_AXI_ARREADY;
  vfpconfig_awready(0) <= ps8_0_axi_periph_M06_AXI_AWREADY;
  vfpconfig_bresp(1 downto 0) <= ps8_0_axi_periph_M06_AXI_BRESP(1 downto 0);
  vfpconfig_bvalid(0) <= ps8_0_axi_periph_M06_AXI_BVALID;
  vfpconfig_rdata(31 downto 0) <= ps8_0_axi_periph_M06_AXI_RDATA(31 downto 0);
  vfpconfig_rresp(1 downto 0) <= ps8_0_axi_periph_M06_AXI_RRESP(1 downto 0);
  vfpconfig_rvalid(0) <= ps8_0_axi_periph_M06_AXI_RVALID;
  vfpconfig_wready(0) <= ps8_0_axi_periph_M06_AXI_WREADY;
  zynq_ultra_ps_e_0_pl_clk0 <= aclk;
ila_0: component kv260_video_ila_0_0
     port map (
      clk => zynq_ultra_ps_e_0_pl_clk0,
      probe0(9 downto 0) => vfp_0_rgb_fr_plw_red(9 downto 0),
      probe1(9 downto 0) => vfp_0_rgb_fr_plw_gre(9 downto 0),
      probe10(15 downto 0) => vfp_0_cord_y(15 downto 0),
      probe2(9 downto 0) => vfp_0_rgb_fr_plw_blu(9 downto 0),
      probe3(0) => vfp_0_rgb_fr_plw_sof,
      probe4(0) => vfp_0_rgb_fr_plw_eol,
      probe5(0) => vfp_0_rgb_fr_plw_eof,
      probe6(0) => vfp_0_rgb_fr_plw_val,
      probe7(15 downto 0) => vfp_0_rgb_fr_plw_xcnt(15 downto 0),
      probe8(15 downto 0) => vfp_0_rgb_fr_plw_ycnt(15 downto 0),
      probe9(15 downto 0) => vfp_0_cord_x(15 downto 0)
    );
mipi_csi2_rx_subsyst_0: component kv260_video_mipi_csi2_rx_subsyst_0_0
     port map (
      clkoutphy_out => NLW_mipi_csi2_rx_subsyst_0_clkoutphy_out_UNCONNECTED,
      csirxss_csi_irq => NLW_mipi_csi2_rx_subsyst_0_csirxss_csi_irq_UNCONNECTED,
      csirxss_s_axi_araddr(7 downto 0) => csirxss_s_axi_1_ARADDR(7 downto 0),
      csirxss_s_axi_arready => csirxss_s_axi_1_ARREADY,
      csirxss_s_axi_arvalid => csirxss_s_axi_1_ARVALID(0),
      csirxss_s_axi_awaddr(7 downto 0) => csirxss_s_axi_1_AWADDR(7 downto 0),
      csirxss_s_axi_awready => csirxss_s_axi_1_AWREADY,
      csirxss_s_axi_awvalid => csirxss_s_axi_1_AWVALID(0),
      csirxss_s_axi_bready => csirxss_s_axi_1_BREADY(0),
      csirxss_s_axi_bresp(1 downto 0) => csirxss_s_axi_1_BRESP(1 downto 0),
      csirxss_s_axi_bvalid => csirxss_s_axi_1_BVALID,
      csirxss_s_axi_rdata(31 downto 0) => csirxss_s_axi_1_RDATA(31 downto 0),
      csirxss_s_axi_rready => csirxss_s_axi_1_RREADY(0),
      csirxss_s_axi_rresp(1 downto 0) => csirxss_s_axi_1_RRESP(1 downto 0),
      csirxss_s_axi_rvalid => csirxss_s_axi_1_RVALID,
      csirxss_s_axi_wdata(31 downto 0) => csirxss_s_axi_1_WDATA(31 downto 0),
      csirxss_s_axi_wready => csirxss_s_axi_1_WREADY,
      csirxss_s_axi_wstrb(3 downto 0) => csirxss_s_axi_1_WSTRB(3 downto 0),
      csirxss_s_axi_wvalid => csirxss_s_axi_1_WVALID(0),
      dphy_clk_200M => dphy_clk_200M_1,
      lite_aclk => zynq_ultra_ps_e_0_pl_clk0,
      lite_aresetn => rst_ps8_0_249M_peripheral_aresetn,
      mipi_phy_if_clk_n => mipi_phy_if_1_CLK_N,
      mipi_phy_if_clk_p => mipi_phy_if_1_CLK_P,
      mipi_phy_if_data_n(1 downto 0) => mipi_phy_if_1_DATA_N(1 downto 0),
      mipi_phy_if_data_p(1 downto 0) => mipi_phy_if_1_DATA_P(1 downto 0),
      pll_lock_out => NLW_mipi_csi2_rx_subsyst_0_pll_lock_out_UNCONNECTED,
      rxbyteclkhs => NLW_mipi_csi2_rx_subsyst_0_rxbyteclkhs_UNCONNECTED,
      rxbyteclkhs_cnts_out => NLW_mipi_csi2_rx_subsyst_0_rxbyteclkhs_cnts_out_UNCONNECTED,
      system_rst_out => NLW_mipi_csi2_rx_subsyst_0_system_rst_out_UNCONNECTED,
      video_aclk => zynq_ultra_ps_e_0_pl_clk0,
      video_aresetn => rst_ps8_0_249M_peripheral_aresetn,
      video_out_tdata(15 downto 0) => mipi_csi2_rx_subsyst_0_video_out_TDATA(15 downto 0),
      video_out_tdest(9 downto 0) => mipi_csi2_rx_subsyst_0_video_out_TDEST(9 downto 0),
      video_out_tlast => mipi_csi2_rx_subsyst_0_video_out_TLAST,
      video_out_tready => mipi_csi2_rx_subsyst_0_video_out_TREADY,
      video_out_tuser(0) => mipi_csi2_rx_subsyst_0_video_out_TUSER(0),
      video_out_tvalid => mipi_csi2_rx_subsyst_0_video_out_TVALID
    );
mipi_csi2_rx_subsyst_1: component kv260_video_mipi_csi2_rx_subsyst_1_0
     port map (
      clkoutphy_out => NLW_mipi_csi2_rx_subsyst_1_clkoutphy_out_UNCONNECTED,
      csirxss_csi_irq => NLW_mipi_csi2_rx_subsyst_1_csirxss_csi_irq_UNCONNECTED,
      csirxss_s_axi_araddr(7 downto 0) => Conn1_ARADDR(7 downto 0),
      csirxss_s_axi_arready => Conn1_ARREADY,
      csirxss_s_axi_arvalid => Conn1_ARVALID(0),
      csirxss_s_axi_awaddr(7 downto 0) => Conn1_AWADDR(7 downto 0),
      csirxss_s_axi_awready => Conn1_AWREADY,
      csirxss_s_axi_awvalid => Conn1_AWVALID(0),
      csirxss_s_axi_bready => Conn1_BREADY(0),
      csirxss_s_axi_bresp(1 downto 0) => Conn1_BRESP(1 downto 0),
      csirxss_s_axi_bvalid => Conn1_BVALID,
      csirxss_s_axi_rdata(31 downto 0) => Conn1_RDATA(31 downto 0),
      csirxss_s_axi_rready => Conn1_RREADY(0),
      csirxss_s_axi_rresp(1 downto 0) => Conn1_RRESP(1 downto 0),
      csirxss_s_axi_rvalid => Conn1_RVALID,
      csirxss_s_axi_wdata(31 downto 0) => Conn1_WDATA(31 downto 0),
      csirxss_s_axi_wready => Conn1_WREADY,
      csirxss_s_axi_wstrb(3 downto 0) => Conn1_WSTRB(3 downto 0),
      csirxss_s_axi_wvalid => Conn1_WVALID(0),
      dphy_clk_200M => dphy_clk_200M_1,
      lite_aclk => zynq_ultra_ps_e_0_pl_clk0,
      lite_aresetn => rst_ps8_0_249M_peripheral_aresetn,
      mipi_phy_if_clk_n => Conn2_CLK_N,
      mipi_phy_if_clk_p => Conn2_CLK_P,
      mipi_phy_if_data_n(3 downto 0) => Conn2_DATA_N(3 downto 0),
      mipi_phy_if_data_p(3 downto 0) => Conn2_DATA_P(3 downto 0),
      pll_lock_out => NLW_mipi_csi2_rx_subsyst_1_pll_lock_out_UNCONNECTED,
      rxbyteclkhs => NLW_mipi_csi2_rx_subsyst_1_rxbyteclkhs_UNCONNECTED,
      rxbyteclkhs_cnts_out => NLW_mipi_csi2_rx_subsyst_1_rxbyteclkhs_cnts_out_UNCONNECTED,
      system_rst_out => NLW_mipi_csi2_rx_subsyst_1_system_rst_out_UNCONNECTED,
      video_aclk => zynq_ultra_ps_e_0_pl_clk0,
      video_aresetn => rst_ps8_0_249M_peripheral_aresetn,
      video_out_tdata(15 downto 0) => mipi_csi2_rx_subsyst_1_video_out_TDATA(15 downto 0),
      video_out_tdest(9 downto 0) => mipi_csi2_rx_subsyst_1_video_out_TDEST(9 downto 0),
      video_out_tlast => mipi_csi2_rx_subsyst_1_video_out_TLAST,
      video_out_tready => mipi_csi2_rx_subsyst_1_video_out_TREADY,
      video_out_tuser(0) => mipi_csi2_rx_subsyst_1_video_out_TUSER(0),
      video_out_tvalid => mipi_csi2_rx_subsyst_1_video_out_TVALID
    );
v_demosaic_0: component kv260_video_v_demosaic_0_0
     port map (
      ap_clk => zynq_ultra_ps_e_0_pl_clk0,
      ap_rst_n => rst_ps8_0_249M_peripheral_aresetn,
      interrupt => NLW_v_demosaic_0_interrupt_UNCONNECTED,
      m_axis_video_TDATA(31 downto 0) => v_demosaic_0_m_axis_video_TDATA(31 downto 0),
      m_axis_video_TDEST(0) => NLW_v_demosaic_0_m_axis_video_TDEST_UNCONNECTED(0),
      m_axis_video_TID(0) => NLW_v_demosaic_0_m_axis_video_TID_UNCONNECTED(0),
      m_axis_video_TKEEP(3 downto 0) => v_demosaic_0_m_axis_video_TKEEP(3 downto 0),
      m_axis_video_TLAST(0) => v_demosaic_0_m_axis_video_TLAST(0),
      m_axis_video_TREADY => v_demosaic_0_m_axis_video_TREADY,
      m_axis_video_TSTRB(3 downto 0) => v_demosaic_0_m_axis_video_TSTRB(3 downto 0),
      m_axis_video_TUSER(0) => v_demosaic_0_m_axis_video_TUSER(0),
      m_axis_video_TVALID => v_demosaic_0_m_axis_video_TVALID,
      s_axi_CTRL_ARADDR(5 downto 0) => ps8_0_axi_periph_M03_AXI_ARADDR(5 downto 0),
      s_axi_CTRL_ARREADY => ps8_0_axi_periph_M03_AXI_ARREADY,
      s_axi_CTRL_ARVALID => ps8_0_axi_periph_M03_AXI_ARVALID(0),
      s_axi_CTRL_AWADDR(5 downto 0) => ps8_0_axi_periph_M03_AXI_AWADDR(5 downto 0),
      s_axi_CTRL_AWREADY => ps8_0_axi_periph_M03_AXI_AWREADY,
      s_axi_CTRL_AWVALID => ps8_0_axi_periph_M03_AXI_AWVALID(0),
      s_axi_CTRL_BREADY => ps8_0_axi_periph_M03_AXI_BREADY(0),
      s_axi_CTRL_BRESP(1 downto 0) => ps8_0_axi_periph_M03_AXI_BRESP(1 downto 0),
      s_axi_CTRL_BVALID => ps8_0_axi_periph_M03_AXI_BVALID,
      s_axi_CTRL_RDATA(31 downto 0) => ps8_0_axi_periph_M03_AXI_RDATA(31 downto 0),
      s_axi_CTRL_RREADY => ps8_0_axi_periph_M03_AXI_RREADY(0),
      s_axi_CTRL_RRESP(1 downto 0) => ps8_0_axi_periph_M03_AXI_RRESP(1 downto 0),
      s_axi_CTRL_RVALID => ps8_0_axi_periph_M03_AXI_RVALID,
      s_axi_CTRL_WDATA(31 downto 0) => ps8_0_axi_periph_M03_AXI_WDATA(31 downto 0),
      s_axi_CTRL_WREADY => ps8_0_axi_periph_M03_AXI_WREADY,
      s_axi_CTRL_WSTRB(3 downto 0) => ps8_0_axi_periph_M03_AXI_WSTRB(3 downto 0),
      s_axi_CTRL_WVALID => ps8_0_axi_periph_M03_AXI_WVALID(0),
      s_axis_video_TDATA(15 downto 0) => mipi_csi2_rx_subsyst_0_video_out_TDATA(15 downto 0),
      s_axis_video_TDEST(0) => mipi_csi2_rx_subsyst_0_video_out_TDEST(0),
      s_axis_video_TID(0) => '0',
      s_axis_video_TKEEP(1 downto 0) => B"11",
      s_axis_video_TLAST(0) => mipi_csi2_rx_subsyst_0_video_out_TLAST,
      s_axis_video_TREADY => mipi_csi2_rx_subsyst_0_video_out_TREADY,
      s_axis_video_TSTRB(1 downto 0) => B"11",
      s_axis_video_TUSER(0) => mipi_csi2_rx_subsyst_0_video_out_TUSER(0),
      s_axis_video_TVALID => mipi_csi2_rx_subsyst_0_video_out_TVALID
    );
v_demosaic_1: component kv260_video_v_demosaic_1_0
     port map (
      ap_clk => zynq_ultra_ps_e_0_pl_clk0,
      ap_rst_n => rst_ps8_0_249M_peripheral_aresetn,
      interrupt => NLW_v_demosaic_1_interrupt_UNCONNECTED,
      m_axis_video_TDATA(31 downto 0) => v_demosaic_1_m_axis_video_TDATA(31 downto 0),
      m_axis_video_TDEST(0) => NLW_v_demosaic_1_m_axis_video_TDEST_UNCONNECTED(0),
      m_axis_video_TID(0) => NLW_v_demosaic_1_m_axis_video_TID_UNCONNECTED(0),
      m_axis_video_TKEEP(3 downto 0) => v_demosaic_1_m_axis_video_TKEEP(3 downto 0),
      m_axis_video_TLAST(0) => v_demosaic_1_m_axis_video_TLAST(0),
      m_axis_video_TREADY => v_demosaic_1_m_axis_video_TREADY,
      m_axis_video_TSTRB(3 downto 0) => v_demosaic_1_m_axis_video_TSTRB(3 downto 0),
      m_axis_video_TUSER(0) => v_demosaic_1_m_axis_video_TUSER(0),
      m_axis_video_TVALID => v_demosaic_1_m_axis_video_TVALID,
      s_axi_CTRL_ARADDR(5 downto 0) => Conn4_ARADDR(5 downto 0),
      s_axi_CTRL_ARREADY => Conn4_ARREADY,
      s_axi_CTRL_ARVALID => Conn4_ARVALID(0),
      s_axi_CTRL_AWADDR(5 downto 0) => Conn4_AWADDR(5 downto 0),
      s_axi_CTRL_AWREADY => Conn4_AWREADY,
      s_axi_CTRL_AWVALID => Conn4_AWVALID(0),
      s_axi_CTRL_BREADY => Conn4_BREADY(0),
      s_axi_CTRL_BRESP(1 downto 0) => Conn4_BRESP(1 downto 0),
      s_axi_CTRL_BVALID => Conn4_BVALID,
      s_axi_CTRL_RDATA(31 downto 0) => Conn4_RDATA(31 downto 0),
      s_axi_CTRL_RREADY => Conn4_RREADY(0),
      s_axi_CTRL_RRESP(1 downto 0) => Conn4_RRESP(1 downto 0),
      s_axi_CTRL_RVALID => Conn4_RVALID,
      s_axi_CTRL_WDATA(31 downto 0) => Conn4_WDATA(31 downto 0),
      s_axi_CTRL_WREADY => Conn4_WREADY,
      s_axi_CTRL_WSTRB(3 downto 0) => Conn4_WSTRB(3 downto 0),
      s_axi_CTRL_WVALID => Conn4_WVALID(0),
      s_axis_video_TDATA(15 downto 0) => mipi_csi2_rx_subsyst_1_video_out_TDATA(15 downto 0),
      s_axis_video_TDEST(0) => mipi_csi2_rx_subsyst_1_video_out_TDEST(0),
      s_axis_video_TID(0) => '0',
      s_axis_video_TKEEP(1 downto 0) => B"11",
      s_axis_video_TLAST(0) => mipi_csi2_rx_subsyst_1_video_out_TLAST,
      s_axis_video_TREADY => mipi_csi2_rx_subsyst_1_video_out_TREADY,
      s_axis_video_TSTRB(1 downto 0) => B"11",
      s_axis_video_TUSER(0) => mipi_csi2_rx_subsyst_1_video_out_TUSER(0),
      s_axis_video_TVALID => mipi_csi2_rx_subsyst_1_video_out_TVALID
    );
vfp_0: component kv260_video_vfp_0_0
     port map (
      crd_x(15 downto 0) => vfp_0_cord_x(15 downto 0),
      crd_y(15 downto 0) => vfp_0_cord_y(15 downto 0),
      ivideo_aclk => zynq_ultra_ps_e_0_pl_clk0,
      ivideo_aresetn => rst_ps8_0_249M_peripheral_aresetn,
      ivideo_tdata(31 downto 0) => v_demosaic_0_m_axis_video_TDATA(31 downto 0),
      ivideo_tkeep(3 downto 0) => v_demosaic_0_m_axis_video_TKEEP(3 downto 0),
      ivideo_tlast => v_demosaic_0_m_axis_video_TLAST(0),
      ivideo_tready => v_demosaic_0_m_axis_video_TREADY,
      ivideo_tstrb(3 downto 0) => v_demosaic_0_m_axis_video_TSTRB(3 downto 0),
      ivideo_tuser => v_demosaic_0_m_axis_video_TUSER(0),
      ivideo_tvalid => v_demosaic_0_m_axis_video_TVALID,
      o1video_aclk => zynq_ultra_ps_e_0_pl_clk0,
      o1video_aresetn => rst_ps8_0_249M_peripheral_aresetn,
      o1video_tdata(23 downto 0) => vfp_0_o1video_TDATA(23 downto 0),
      o1video_tkeep(2 downto 0) => vfp_0_o1video_TKEEP(2 downto 0),
      o1video_tlast => vfp_0_o1video_TLAST,
      o1video_tready => vfp_0_o1video_TREADY,
      o1video_tstrb(2 downto 0) => NLW_vfp_0_o1video_tstrb_UNCONNECTED(2 downto 0),
      o1video_tuser => vfp_0_o1video_TUSER,
      o1video_tvalid => vfp_0_o1video_TVALID,
      ovideo_aclk => zynq_ultra_ps_e_0_pl_clk0,
      ovideo_aresetn => rst_ps8_0_249M_peripheral_aresetn,
      ovideo_tdata(23 downto 0) => vfp_0_ovideo_TDATA(23 downto 0),
      ovideo_tkeep(2 downto 0) => vfp_0_ovideo_TKEEP(2 downto 0),
      ovideo_tlast => vfp_0_ovideo_TLAST,
      ovideo_tready => vfp_0_ovideo_TREADY,
      ovideo_tstrb(2 downto 0) => NLW_vfp_0_ovideo_tstrb_UNCONNECTED(2 downto 0),
      ovideo_tuser => vfp_0_ovideo_TUSER,
      ovideo_tvalid => vfp_0_ovideo_TVALID,
      rgb_fr_plw_blu(9 downto 0) => vfp_0_rgb_fr_plw_blu(9 downto 0),
      rgb_fr_plw_eof => vfp_0_rgb_fr_plw_eof,
      rgb_fr_plw_eol => vfp_0_rgb_fr_plw_eol,
      rgb_fr_plw_gre(9 downto 0) => vfp_0_rgb_fr_plw_gre(9 downto 0),
      rgb_fr_plw_red(9 downto 0) => vfp_0_rgb_fr_plw_red(9 downto 0),
      rgb_fr_plw_sof => vfp_0_rgb_fr_plw_sof,
      rgb_fr_plw_val => vfp_0_rgb_fr_plw_val,
      rgb_fr_plw_xcnt(15 downto 0) => vfp_0_rgb_fr_plw_xcnt(15 downto 0),
      rgb_fr_plw_ycnt(15 downto 0) => vfp_0_rgb_fr_plw_ycnt(15 downto 0),
      vfpconfig_aclk => zynq_ultra_ps_e_0_pl_clk0,
      vfpconfig_araddr(7 downto 0) => ps8_0_axi_periph_M06_AXI_ARADDR(7 downto 0),
      vfpconfig_aresetn => rst_ps8_0_249M_peripheral_aresetn,
      vfpconfig_arprot(2 downto 0) => ps8_0_axi_periph_M06_AXI_ARPROT(2 downto 0),
      vfpconfig_arready => ps8_0_axi_periph_M06_AXI_ARREADY,
      vfpconfig_arvalid => ps8_0_axi_periph_M06_AXI_ARVALID(0),
      vfpconfig_awaddr(7 downto 0) => ps8_0_axi_periph_M06_AXI_AWADDR(7 downto 0),
      vfpconfig_awprot(2 downto 0) => ps8_0_axi_periph_M06_AXI_AWPROT(2 downto 0),
      vfpconfig_awready => ps8_0_axi_periph_M06_AXI_AWREADY,
      vfpconfig_awvalid => ps8_0_axi_periph_M06_AXI_AWVALID(0),
      vfpconfig_bready => ps8_0_axi_periph_M06_AXI_BREADY(0),
      vfpconfig_bresp(1 downto 0) => ps8_0_axi_periph_M06_AXI_BRESP(1 downto 0),
      vfpconfig_bvalid => ps8_0_axi_periph_M06_AXI_BVALID,
      vfpconfig_rdata(31 downto 0) => ps8_0_axi_periph_M06_AXI_RDATA(31 downto 0),
      vfpconfig_rready => ps8_0_axi_periph_M06_AXI_RREADY(0),
      vfpconfig_rresp(1 downto 0) => ps8_0_axi_periph_M06_AXI_RRESP(1 downto 0),
      vfpconfig_rvalid => ps8_0_axi_periph_M06_AXI_RVALID,
      vfpconfig_wdata(31 downto 0) => ps8_0_axi_periph_M06_AXI_WDATA(31 downto 0),
      vfpconfig_wready => ps8_0_axi_periph_M06_AXI_WREADY,
      vfpconfig_wstrb(3 downto 0) => ps8_0_axi_periph_M06_AXI_WSTRB(3 downto 0),
      vfpconfig_wvalid => ps8_0_axi_periph_M06_AXI_WVALID(0),
      video2_aclk => zynq_ultra_ps_e_0_pl_clk0,
      video2_aresetn => rst_ps8_0_249M_peripheral_aresetn,
      video2_tdata(31 downto 0) => v_demosaic_1_m_axis_video_TDATA(31 downto 0),
      video2_tkeep(3 downto 0) => v_demosaic_1_m_axis_video_TKEEP(3 downto 0),
      video2_tlast => v_demosaic_1_m_axis_video_TLAST(0),
      video2_tready => v_demosaic_1_m_axis_video_TREADY,
      video2_tstrb(3 downto 0) => v_demosaic_1_m_axis_video_TSTRB(3 downto 0),
      video2_tuser => v_demosaic_1_m_axis_video_TUSER(0),
      video2_tvalid => v_demosaic_1_m_axis_video_TVALID
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity VIDEO_PIPELINE_imp_U9ZAJD is
  port (
    ctrl_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    ctrl_arready : out STD_LOGIC;
    ctrl_arvalid : in STD_LOGIC;
    ctrl_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    ctrl_awready : out STD_LOGIC;
    ctrl_awvalid : in STD_LOGIC;
    ctrl_bready : in STD_LOGIC;
    ctrl_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ctrl_bvalid : out STD_LOGIC;
    ctrl_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ctrl_rready : in STD_LOGIC;
    ctrl_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ctrl_rvalid : out STD_LOGIC;
    ctrl_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    ctrl_wready : out STD_LOGIC;
    ctrl_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ctrl_wvalid : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    vid_active_video : out STD_LOGIC;
    vid_data : out STD_LOGIC_VECTOR ( 35 downto 0 );
    vid_hsync : out STD_LOGIC;
    vid_io_out_clk : in STD_LOGIC;
    vid_vsync : out STD_LOGIC;
    video_in_tdata : in STD_LOGIC_VECTOR ( 23 downto 0 );
    video_in_tlast : in STD_LOGIC;
    video_in_tready : out STD_LOGIC;
    video_in_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    video_in_tvalid : in STD_LOGIC
  );
end VIDEO_PIPELINE_imp_U9ZAJD;

architecture STRUCTURE of VIDEO_PIPELINE_imp_U9ZAJD is
  component kv260_video_ila_0_1 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe1 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe4 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe6 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe7 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe8 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component kv260_video_ila_0_1;
  component kv260_video_ila_1_0 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe1 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe3 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component kv260_video_ila_1_0;
  component kv260_video_v_axi4s_vid_out_0_0 is
  port (
    aclk : in STD_LOGIC;
    aclken : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_video_tdata : in STD_LOGIC_VECTOR ( 23 downto 0 );
    s_axis_video_tvalid : in STD_LOGIC;
    s_axis_video_tready : out STD_LOGIC;
    s_axis_video_tuser : in STD_LOGIC;
    s_axis_video_tlast : in STD_LOGIC;
    fid : in STD_LOGIC;
    vid_io_out_clk : in STD_LOGIC;
    vid_io_out_ce : in STD_LOGIC;
    vid_io_out_reset : in STD_LOGIC;
    vid_active_video : out STD_LOGIC;
    vid_vsync : out STD_LOGIC;
    vid_hsync : out STD_LOGIC;
    vid_vblank : out STD_LOGIC;
    vid_hblank : out STD_LOGIC;
    vid_field_id : out STD_LOGIC;
    vid_data : out STD_LOGIC_VECTOR ( 35 downto 0 );
    vtg_vsync : in STD_LOGIC;
    vtg_hsync : in STD_LOGIC;
    vtg_vblank : in STD_LOGIC;
    vtg_hblank : in STD_LOGIC;
    vtg_active_video : in STD_LOGIC;
    vtg_field_id : in STD_LOGIC;
    vtg_ce : out STD_LOGIC;
    locked : out STD_LOGIC;
    overflow : out STD_LOGIC;
    underflow : out STD_LOGIC;
    fifo_read_level : out STD_LOGIC_VECTOR ( 12 downto 0 );
    status : out STD_LOGIC_VECTOR ( 31 downto 0 );
    sof_state_out : out STD_LOGIC
  );
  end component kv260_video_v_axi4s_vid_out_0_0;
  component kv260_video_v_tc_0_0 is
  port (
    clk : in STD_LOGIC;
    clken : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    s_axi_aclken : in STD_LOGIC;
    gen_clken : in STD_LOGIC;
    sof_state : in STD_LOGIC;
    hsync_out : out STD_LOGIC;
    hblank_out : out STD_LOGIC;
    vsync_out : out STD_LOGIC;
    vblank_out : out STD_LOGIC;
    active_video_out : out STD_LOGIC;
    resetn : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    irq : out STD_LOGIC;
    fsync_in : in STD_LOGIC;
    fsync_out : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component kv260_video_v_tc_0_0;
  component kv260_video_xlconstant_0_0 is
  port (
    dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component kv260_video_xlconstant_0_0;
  signal axis_subset_converter_0_M_AXIS_TDATA : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal axis_subset_converter_0_M_AXIS_TLAST : STD_LOGIC;
  signal axis_subset_converter_0_M_AXIS_TREADY : STD_LOGIC;
  signal axis_subset_converter_0_M_AXIS_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axis_subset_converter_0_M_AXIS_TVALID : STD_LOGIC;
  signal clk_wiz_0_clk_out1 : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_ARVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_AWVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_BREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_RREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_WVALID : STD_LOGIC;
  signal rst_ps8_0_249M_peripheral_aresetn : STD_LOGIC;
  signal v_axi4s_vid_out_0_vid_active_video : STD_LOGIC;
  signal v_axi4s_vid_out_0_vid_data : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal v_axi4s_vid_out_0_vid_hsync : STD_LOGIC;
  signal v_axi4s_vid_out_0_vid_vsync : STD_LOGIC;
  signal v_axi4s_vid_out_0_vtg_ce : STD_LOGIC;
  signal v_tc_0_vtiming_out_ACTIVE_VIDEO : STD_LOGIC;
  signal v_tc_0_vtiming_out_HBLANK : STD_LOGIC;
  signal v_tc_0_vtiming_out_HSYNC : STD_LOGIC;
  signal v_tc_0_vtiming_out_VBLANK : STD_LOGIC;
  signal v_tc_0_vtiming_out_VSYNC : STD_LOGIC;
  signal xlconstant_0_dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal zynq_ultra_ps_e_0_pl_clk0 : STD_LOGIC;
  signal NLW_v_axi4s_vid_out_0_locked_UNCONNECTED : STD_LOGIC;
  signal NLW_v_axi4s_vid_out_0_overflow_UNCONNECTED : STD_LOGIC;
  signal NLW_v_axi4s_vid_out_0_sof_state_out_UNCONNECTED : STD_LOGIC;
  signal NLW_v_axi4s_vid_out_0_underflow_UNCONNECTED : STD_LOGIC;
  signal NLW_v_axi4s_vid_out_0_vid_field_id_UNCONNECTED : STD_LOGIC;
  signal NLW_v_axi4s_vid_out_0_vid_hblank_UNCONNECTED : STD_LOGIC;
  signal NLW_v_axi4s_vid_out_0_vid_vblank_UNCONNECTED : STD_LOGIC;
  signal NLW_v_axi4s_vid_out_0_fifo_read_level_UNCONNECTED : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal NLW_v_axi4s_vid_out_0_status_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_v_tc_0_irq_UNCONNECTED : STD_LOGIC;
  signal NLW_v_tc_0_fsync_out_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  axis_subset_converter_0_M_AXIS_TDATA(23 downto 0) <= video_in_tdata(23 downto 0);
  axis_subset_converter_0_M_AXIS_TLAST <= video_in_tlast;
  axis_subset_converter_0_M_AXIS_TUSER(0) <= video_in_tuser(0);
  axis_subset_converter_0_M_AXIS_TVALID <= video_in_tvalid;
  clk_wiz_0_clk_out1 <= vid_io_out_clk;
  ctrl_arready <= ps8_0_axi_periph_M05_AXI_ARREADY;
  ctrl_awready <= ps8_0_axi_periph_M05_AXI_AWREADY;
  ctrl_bresp(1 downto 0) <= ps8_0_axi_periph_M05_AXI_BRESP(1 downto 0);
  ctrl_bvalid <= ps8_0_axi_periph_M05_AXI_BVALID;
  ctrl_rdata(31 downto 0) <= ps8_0_axi_periph_M05_AXI_RDATA(31 downto 0);
  ctrl_rresp(1 downto 0) <= ps8_0_axi_periph_M05_AXI_RRESP(1 downto 0);
  ctrl_rvalid <= ps8_0_axi_periph_M05_AXI_RVALID;
  ctrl_wready <= ps8_0_axi_periph_M05_AXI_WREADY;
  ps8_0_axi_periph_M05_AXI_ARADDR(39 downto 0) <= ctrl_araddr(39 downto 0);
  ps8_0_axi_periph_M05_AXI_ARVALID <= ctrl_arvalid;
  ps8_0_axi_periph_M05_AXI_AWADDR(39 downto 0) <= ctrl_awaddr(39 downto 0);
  ps8_0_axi_periph_M05_AXI_AWVALID <= ctrl_awvalid;
  ps8_0_axi_periph_M05_AXI_BREADY <= ctrl_bready;
  ps8_0_axi_periph_M05_AXI_RREADY <= ctrl_rready;
  ps8_0_axi_periph_M05_AXI_WDATA(31 downto 0) <= ctrl_wdata(31 downto 0);
  ps8_0_axi_periph_M05_AXI_WSTRB(3 downto 0) <= ctrl_wstrb(3 downto 0);
  ps8_0_axi_periph_M05_AXI_WVALID <= ctrl_wvalid;
  rst_ps8_0_249M_peripheral_aresetn <= s_axi_aresetn;
  vid_active_video <= v_axi4s_vid_out_0_vid_active_video;
  vid_data(35 downto 0) <= v_axi4s_vid_out_0_vid_data(35 downto 0);
  vid_hsync <= v_axi4s_vid_out_0_vid_hsync;
  vid_vsync <= v_axi4s_vid_out_0_vid_vsync;
  video_in_tready <= axis_subset_converter_0_M_AXIS_TREADY;
  zynq_ultra_ps_e_0_pl_clk0 <= s_axi_aclk;
ila_0: component kv260_video_ila_0_1
     port map (
      clk => zynq_ultra_ps_e_0_pl_clk0,
      probe0(0) => axis_subset_converter_0_M_AXIS_TREADY,
      probe1(23 downto 0) => axis_subset_converter_0_M_AXIS_TDATA(23 downto 0),
      probe2(2 downto 0) => B"111",
      probe3(0) => axis_subset_converter_0_M_AXIS_TVALID,
      probe4(0) => axis_subset_converter_0_M_AXIS_TLAST,
      probe5(0) => axis_subset_converter_0_M_AXIS_TUSER(0),
      probe6(2 downto 0) => B"111",
      probe7(0) => '0',
      probe8(0) => '0'
    );
ila_1: component kv260_video_ila_1_0
     port map (
      clk => clk_wiz_0_clk_out1,
      probe0(0) => v_axi4s_vid_out_0_vid_active_video,
      probe1(35 downto 0) => v_axi4s_vid_out_0_vid_data(35 downto 0),
      probe2(0) => v_axi4s_vid_out_0_vid_hsync,
      probe3(0) => v_axi4s_vid_out_0_vid_vsync
    );
v_axi4s_vid_out_0: component kv260_video_v_axi4s_vid_out_0_0
     port map (
      aclk => zynq_ultra_ps_e_0_pl_clk0,
      aclken => xlconstant_0_dout(0),
      aresetn => rst_ps8_0_249M_peripheral_aresetn,
      fid => '0',
      fifo_read_level(12 downto 0) => NLW_v_axi4s_vid_out_0_fifo_read_level_UNCONNECTED(12 downto 0),
      locked => NLW_v_axi4s_vid_out_0_locked_UNCONNECTED,
      overflow => NLW_v_axi4s_vid_out_0_overflow_UNCONNECTED,
      s_axis_video_tdata(23 downto 0) => axis_subset_converter_0_M_AXIS_TDATA(23 downto 0),
      s_axis_video_tlast => axis_subset_converter_0_M_AXIS_TLAST,
      s_axis_video_tready => axis_subset_converter_0_M_AXIS_TREADY,
      s_axis_video_tuser => axis_subset_converter_0_M_AXIS_TUSER(0),
      s_axis_video_tvalid => axis_subset_converter_0_M_AXIS_TVALID,
      sof_state_out => NLW_v_axi4s_vid_out_0_sof_state_out_UNCONNECTED,
      status(31 downto 0) => NLW_v_axi4s_vid_out_0_status_UNCONNECTED(31 downto 0),
      underflow => NLW_v_axi4s_vid_out_0_underflow_UNCONNECTED,
      vid_active_video => v_axi4s_vid_out_0_vid_active_video,
      vid_data(35 downto 0) => v_axi4s_vid_out_0_vid_data(35 downto 0),
      vid_field_id => NLW_v_axi4s_vid_out_0_vid_field_id_UNCONNECTED,
      vid_hblank => NLW_v_axi4s_vid_out_0_vid_hblank_UNCONNECTED,
      vid_hsync => v_axi4s_vid_out_0_vid_hsync,
      vid_io_out_ce => xlconstant_0_dout(0),
      vid_io_out_clk => clk_wiz_0_clk_out1,
      vid_io_out_reset => '0',
      vid_vblank => NLW_v_axi4s_vid_out_0_vid_vblank_UNCONNECTED,
      vid_vsync => v_axi4s_vid_out_0_vid_vsync,
      vtg_active_video => v_tc_0_vtiming_out_ACTIVE_VIDEO,
      vtg_ce => v_axi4s_vid_out_0_vtg_ce,
      vtg_field_id => '0',
      vtg_hblank => v_tc_0_vtiming_out_HBLANK,
      vtg_hsync => v_tc_0_vtiming_out_HSYNC,
      vtg_vblank => v_tc_0_vtiming_out_VBLANK,
      vtg_vsync => v_tc_0_vtiming_out_VSYNC
    );
v_tc_0: component kv260_video_v_tc_0_0
     port map (
      active_video_out => v_tc_0_vtiming_out_ACTIVE_VIDEO,
      clk => clk_wiz_0_clk_out1,
      clken => xlconstant_0_dout(0),
      fsync_in => '0',
      fsync_out(0) => NLW_v_tc_0_fsync_out_UNCONNECTED(0),
      gen_clken => v_axi4s_vid_out_0_vtg_ce,
      hblank_out => v_tc_0_vtiming_out_HBLANK,
      hsync_out => v_tc_0_vtiming_out_HSYNC,
      irq => NLW_v_tc_0_irq_UNCONNECTED,
      resetn => '1',
      s_axi_aclk => zynq_ultra_ps_e_0_pl_clk0,
      s_axi_aclken => xlconstant_0_dout(0),
      s_axi_araddr(8 downto 0) => ps8_0_axi_periph_M05_AXI_ARADDR(8 downto 0),
      s_axi_aresetn => rst_ps8_0_249M_peripheral_aresetn,
      s_axi_arready => ps8_0_axi_periph_M05_AXI_ARREADY,
      s_axi_arvalid => ps8_0_axi_periph_M05_AXI_ARVALID,
      s_axi_awaddr(8 downto 0) => ps8_0_axi_periph_M05_AXI_AWADDR(8 downto 0),
      s_axi_awready => ps8_0_axi_periph_M05_AXI_AWREADY,
      s_axi_awvalid => ps8_0_axi_periph_M05_AXI_AWVALID,
      s_axi_bready => ps8_0_axi_periph_M05_AXI_BREADY,
      s_axi_bresp(1 downto 0) => ps8_0_axi_periph_M05_AXI_BRESP(1 downto 0),
      s_axi_bvalid => ps8_0_axi_periph_M05_AXI_BVALID,
      s_axi_rdata(31 downto 0) => ps8_0_axi_periph_M05_AXI_RDATA(31 downto 0),
      s_axi_rready => ps8_0_axi_periph_M05_AXI_RREADY,
      s_axi_rresp(1 downto 0) => ps8_0_axi_periph_M05_AXI_RRESP(1 downto 0),
      s_axi_rvalid => ps8_0_axi_periph_M05_AXI_RVALID,
      s_axi_wdata(31 downto 0) => ps8_0_axi_periph_M05_AXI_WDATA(31 downto 0),
      s_axi_wready => ps8_0_axi_periph_M05_AXI_WREADY,
      s_axi_wstrb(3 downto 0) => ps8_0_axi_periph_M05_AXI_WSTRB(3 downto 0),
      s_axi_wvalid => ps8_0_axi_periph_M05_AXI_WVALID,
      sof_state => '0',
      vblank_out => v_tc_0_vtiming_out_VBLANK,
      vsync_out => v_tc_0_vtiming_out_VSYNC
    );
xlconstant_0: component kv260_video_xlconstant_0_0
     port map (
      dout(0) => xlconstant_0_dout(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity V_DMA_imp_18YRF98 is
  port (
    M00_AXI_araddr : out STD_LOGIC_VECTOR ( 48 downto 0 );
    M00_AXI_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M00_AXI_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_arready : in STD_LOGIC;
    M00_AXI_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_arvalid : out STD_LOGIC;
    M00_AXI_awaddr : out STD_LOGIC_VECTOR ( 48 downto 0 );
    M00_AXI_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M00_AXI_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_awready : in STD_LOGIC;
    M00_AXI_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_awvalid : out STD_LOGIC;
    M00_AXI_bready : out STD_LOGIC;
    M00_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_bvalid : in STD_LOGIC;
    M00_AXI_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    M00_AXI_rlast : in STD_LOGIC;
    M00_AXI_rready : out STD_LOGIC;
    M00_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_rvalid : in STD_LOGIC;
    M00_AXI_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    M00_AXI_wlast : out STD_LOGIC;
    M00_AXI_wready : in STD_LOGIC;
    M00_AXI_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M00_AXI_wvalid : out STD_LOGIC;
    M_AXIS_MM2S_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 );
    M_AXIS_MM2S_tkeep : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXIS_MM2S_tlast : out STD_LOGIC;
    M_AXIS_MM2S_tready : in STD_LOGIC;
    M_AXIS_MM2S_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXIS_MM2S_tvalid : out STD_LOGIC;
    S_AXIS_S2MM1_tdata : in STD_LOGIC_VECTOR ( 23 downto 0 );
    S_AXIS_S2MM1_tkeep : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXIS_S2MM1_tlast : in STD_LOGIC;
    S_AXIS_S2MM1_tready : out STD_LOGIC;
    S_AXIS_S2MM1_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXIS_S2MM1_tvalid : in STD_LOGIC;
    S_AXIS_S2MM_tdata : in STD_LOGIC_VECTOR ( 23 downto 0 );
    S_AXIS_S2MM_tkeep : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXIS_S2MM_tlast : in STD_LOGIC;
    S_AXIS_S2MM_tready : out STD_LOGIC;
    S_AXIS_S2MM_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXIS_S2MM_tvalid : in STD_LOGIC;
    S_AXI_LITE1_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_LITE1_arready : out STD_LOGIC;
    S_AXI_LITE1_arvalid : in STD_LOGIC;
    S_AXI_LITE1_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_LITE1_awready : out STD_LOGIC;
    S_AXI_LITE1_awvalid : in STD_LOGIC;
    S_AXI_LITE1_bready : in STD_LOGIC;
    S_AXI_LITE1_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LITE1_bvalid : out STD_LOGIC;
    S_AXI_LITE1_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_LITE1_rready : in STD_LOGIC;
    S_AXI_LITE1_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LITE1_rvalid : out STD_LOGIC;
    S_AXI_LITE1_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_LITE1_wready : out STD_LOGIC;
    S_AXI_LITE1_wvalid : in STD_LOGIC;
    S_AXI_LITE_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_LITE_arready : out STD_LOGIC;
    S_AXI_LITE_arvalid : in STD_LOGIC;
    S_AXI_LITE_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_LITE_awready : out STD_LOGIC;
    S_AXI_LITE_awvalid : in STD_LOGIC;
    S_AXI_LITE_bready : in STD_LOGIC;
    S_AXI_LITE_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LITE_bvalid : out STD_LOGIC;
    S_AXI_LITE_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_LITE_rready : in STD_LOGIC;
    S_AXI_LITE_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LITE_rvalid : out STD_LOGIC;
    S_AXI_LITE_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_LITE_wready : out STD_LOGIC;
    S_AXI_LITE_wvalid : in STD_LOGIC;
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s2mm_introut : out STD_LOGIC
  );
end V_DMA_imp_18YRF98;

architecture STRUCTURE of V_DMA_imp_18YRF98 is
  component kv260_video_axi_smc_0 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    S00_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S00_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_arvalid : in STD_LOGIC;
    S00_AXI_arready : out STD_LOGIC;
    S00_AXI_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    S00_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_rlast : out STD_LOGIC;
    S00_AXI_rvalid : out STD_LOGIC;
    S00_AXI_rready : in STD_LOGIC;
    S01_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S01_AXI_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S01_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S01_AXI_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S01_AXI_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S01_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S01_AXI_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S01_AXI_awvalid : in STD_LOGIC;
    S01_AXI_awready : out STD_LOGIC;
    S01_AXI_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S01_AXI_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S01_AXI_wlast : in STD_LOGIC;
    S01_AXI_wvalid : in STD_LOGIC;
    S01_AXI_wready : out STD_LOGIC;
    S01_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S01_AXI_bvalid : out STD_LOGIC;
    S01_AXI_bready : in STD_LOGIC;
    S02_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S02_AXI_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S02_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S02_AXI_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S02_AXI_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    S02_AXI_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S02_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S02_AXI_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S02_AXI_awvalid : in STD_LOGIC;
    S02_AXI_awready : out STD_LOGIC;
    S02_AXI_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S02_AXI_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S02_AXI_wlast : in STD_LOGIC;
    S02_AXI_wvalid : in STD_LOGIC;
    S02_AXI_wready : out STD_LOGIC;
    S02_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S02_AXI_bvalid : out STD_LOGIC;
    S02_AXI_bready : in STD_LOGIC;
    M00_AXI_awaddr : out STD_LOGIC_VECTOR ( 48 downto 0 );
    M00_AXI_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M00_AXI_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_awvalid : out STD_LOGIC;
    M00_AXI_awready : in STD_LOGIC;
    M00_AXI_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    M00_AXI_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M00_AXI_wlast : out STD_LOGIC;
    M00_AXI_wvalid : out STD_LOGIC;
    M00_AXI_wready : in STD_LOGIC;
    M00_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_bvalid : in STD_LOGIC;
    M00_AXI_bready : out STD_LOGIC;
    M00_AXI_araddr : out STD_LOGIC_VECTOR ( 48 downto 0 );
    M00_AXI_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M00_AXI_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_arvalid : out STD_LOGIC;
    M00_AXI_arready : in STD_LOGIC;
    M00_AXI_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    M00_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_rlast : in STD_LOGIC;
    M00_AXI_rvalid : in STD_LOGIC;
    M00_AXI_rready : out STD_LOGIC
  );
  end component kv260_video_axi_smc_0;
  component kv260_video_axi_vdma_0_0 is
  port (
    s_axi_lite_aclk : in STD_LOGIC;
    m_axi_mm2s_aclk : in STD_LOGIC;
    m_axis_mm2s_aclk : in STD_LOGIC;
    m_axi_s2mm_aclk : in STD_LOGIC;
    s_axis_s2mm_aclk : in STD_LOGIC;
    axi_resetn : in STD_LOGIC;
    s_axi_lite_awvalid : in STD_LOGIC;
    s_axi_lite_awready : out STD_LOGIC;
    s_axi_lite_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_lite_wvalid : in STD_LOGIC;
    s_axi_lite_wready : out STD_LOGIC;
    s_axi_lite_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_lite_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_lite_bvalid : out STD_LOGIC;
    s_axi_lite_bready : in STD_LOGIC;
    s_axi_lite_arvalid : in STD_LOGIC;
    s_axi_lite_arready : out STD_LOGIC;
    s_axi_lite_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_lite_rvalid : out STD_LOGIC;
    s_axi_lite_rready : in STD_LOGIC;
    s_axi_lite_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_lite_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mm2s_frame_ptr_out : out STD_LOGIC_VECTOR ( 5 downto 0 );
    s2mm_frame_ptr_out : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_mm2s_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_mm2s_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_mm2s_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_mm2s_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_mm2s_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_mm2s_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_mm2s_arvalid : out STD_LOGIC;
    m_axi_mm2s_arready : in STD_LOGIC;
    m_axi_mm2s_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axi_mm2s_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_mm2s_rlast : in STD_LOGIC;
    m_axi_mm2s_rvalid : in STD_LOGIC;
    m_axi_mm2s_rready : out STD_LOGIC;
    m_axis_mm2s_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 );
    m_axis_mm2s_tkeep : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_mm2s_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_mm2s_tvalid : out STD_LOGIC;
    m_axis_mm2s_tready : in STD_LOGIC;
    m_axis_mm2s_tlast : out STD_LOGIC;
    m_axi_s2mm_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_s2mm_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_s2mm_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_s2mm_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_s2mm_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_s2mm_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_s2mm_awvalid : out STD_LOGIC;
    m_axi_s2mm_awready : in STD_LOGIC;
    m_axi_s2mm_wdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axi_s2mm_wstrb : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_s2mm_wlast : out STD_LOGIC;
    m_axi_s2mm_wvalid : out STD_LOGIC;
    m_axi_s2mm_wready : in STD_LOGIC;
    m_axi_s2mm_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_s2mm_bvalid : in STD_LOGIC;
    m_axi_s2mm_bready : out STD_LOGIC;
    s_axis_s2mm_tdata : in STD_LOGIC_VECTOR ( 23 downto 0 );
    s_axis_s2mm_tkeep : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axis_s2mm_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_s2mm_tvalid : in STD_LOGIC;
    s_axis_s2mm_tready : out STD_LOGIC;
    s_axis_s2mm_tlast : in STD_LOGIC;
    mm2s_introut : out STD_LOGIC;
    s2mm_introut : out STD_LOGIC
  );
  end component kv260_video_axi_vdma_0_0;
  component kv260_video_axi_vdma_1_0 is
  port (
    s_axi_lite_aclk : in STD_LOGIC;
    m_axi_s2mm_aclk : in STD_LOGIC;
    s_axis_s2mm_aclk : in STD_LOGIC;
    axi_resetn : in STD_LOGIC;
    s_axi_lite_awvalid : in STD_LOGIC;
    s_axi_lite_awready : out STD_LOGIC;
    s_axi_lite_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_lite_wvalid : in STD_LOGIC;
    s_axi_lite_wready : out STD_LOGIC;
    s_axi_lite_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_lite_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_lite_bvalid : out STD_LOGIC;
    s_axi_lite_bready : in STD_LOGIC;
    s_axi_lite_arvalid : in STD_LOGIC;
    s_axi_lite_arready : out STD_LOGIC;
    s_axi_lite_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_lite_rvalid : out STD_LOGIC;
    s_axi_lite_rready : in STD_LOGIC;
    s_axi_lite_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_lite_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s2mm_frame_ptr_out : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_s2mm_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_s2mm_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_s2mm_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_s2mm_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_s2mm_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_s2mm_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_s2mm_awvalid : out STD_LOGIC;
    m_axi_s2mm_awready : in STD_LOGIC;
    m_axi_s2mm_wdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axi_s2mm_wstrb : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_s2mm_wlast : out STD_LOGIC;
    m_axi_s2mm_wvalid : out STD_LOGIC;
    m_axi_s2mm_wready : in STD_LOGIC;
    m_axi_s2mm_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_s2mm_bvalid : in STD_LOGIC;
    m_axi_s2mm_bready : out STD_LOGIC;
    s_axis_s2mm_tdata : in STD_LOGIC_VECTOR ( 23 downto 0 );
    s_axis_s2mm_tkeep : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axis_s2mm_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_s2mm_tvalid : in STD_LOGIC;
    s_axis_s2mm_tready : out STD_LOGIC;
    s_axis_s2mm_tlast : in STD_LOGIC;
    s2mm_introut : out STD_LOGIC
  );
  end component kv260_video_axi_vdma_1_0;
  signal S_AXIS_S2MM1_1_TDATA : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal S_AXIS_S2MM1_1_TKEEP : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S_AXIS_S2MM1_1_TLAST : STD_LOGIC;
  signal S_AXIS_S2MM1_1_TREADY : STD_LOGIC;
  signal S_AXIS_S2MM1_1_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal S_AXIS_S2MM1_1_TVALID : STD_LOGIC;
  signal S_AXIS_S2MM_1_TDATA : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal S_AXIS_S2MM_1_TKEEP : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S_AXIS_S2MM_1_TLAST : STD_LOGIC;
  signal S_AXIS_S2MM_1_TREADY : STD_LOGIC;
  signal S_AXIS_S2MM_1_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal S_AXIS_S2MM_1_TVALID : STD_LOGIC;
  signal S_AXI_LITE1_1_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal S_AXI_LITE1_1_ARREADY : STD_LOGIC;
  signal S_AXI_LITE1_1_ARVALID : STD_LOGIC;
  signal S_AXI_LITE1_1_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal S_AXI_LITE1_1_AWREADY : STD_LOGIC;
  signal S_AXI_LITE1_1_AWVALID : STD_LOGIC;
  signal S_AXI_LITE1_1_BREADY : STD_LOGIC;
  signal S_AXI_LITE1_1_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal S_AXI_LITE1_1_BVALID : STD_LOGIC;
  signal S_AXI_LITE1_1_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal S_AXI_LITE1_1_RREADY : STD_LOGIC;
  signal S_AXI_LITE1_1_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal S_AXI_LITE1_1_RVALID : STD_LOGIC;
  signal S_AXI_LITE1_1_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal S_AXI_LITE1_1_WREADY : STD_LOGIC;
  signal S_AXI_LITE1_1_WVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_ARADDR : STD_LOGIC_VECTOR ( 48 downto 0 );
  signal axi_smc_M00_AXI_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_smc_M00_AXI_ARLOCK : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axi_smc_M00_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_ARREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_ARVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_AWADDR : STD_LOGIC_VECTOR ( 48 downto 0 );
  signal axi_smc_M00_AXI_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_smc_M00_AXI_AWLOCK : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axi_smc_M00_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_AWREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_AWVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_BREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_BVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_RDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal axi_smc_M00_AXI_RLAST : STD_LOGIC;
  signal axi_smc_M00_AXI_RREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_RVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_WDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal axi_smc_M00_AXI_WLAST : STD_LOGIC;
  signal axi_smc_M00_AXI_WREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_WSTRB : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal axi_smc_M00_AXI_WVALID : STD_LOGIC;
  signal axi_vdma_0_M_AXIS_MM2S_TDATA : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal axi_vdma_0_M_AXIS_MM2S_TKEEP : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vdma_0_M_AXIS_MM2S_TLAST : STD_LOGIC;
  signal axi_vdma_0_M_AXIS_MM2S_TREADY : STD_LOGIC;
  signal axi_vdma_0_M_AXIS_MM2S_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axi_vdma_0_M_AXIS_MM2S_TVALID : STD_LOGIC;
  signal axi_vdma_0_M_AXI_MM2S_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vdma_0_M_AXI_MM2S_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_vdma_0_M_AXI_MM2S_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_vdma_0_M_AXI_MM2S_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_vdma_0_M_AXI_MM2S_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vdma_0_M_AXI_MM2S_ARREADY : STD_LOGIC;
  signal axi_vdma_0_M_AXI_MM2S_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vdma_0_M_AXI_MM2S_ARVALID : STD_LOGIC;
  signal axi_vdma_0_M_AXI_MM2S_RDATA : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal axi_vdma_0_M_AXI_MM2S_RLAST : STD_LOGIC;
  signal axi_vdma_0_M_AXI_MM2S_RREADY : STD_LOGIC;
  signal axi_vdma_0_M_AXI_MM2S_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_vdma_0_M_AXI_MM2S_RVALID : STD_LOGIC;
  signal axi_vdma_0_M_AXI_S2MM_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vdma_0_M_AXI_S2MM_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_vdma_0_M_AXI_S2MM_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_vdma_0_M_AXI_S2MM_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_vdma_0_M_AXI_S2MM_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vdma_0_M_AXI_S2MM_AWREADY : STD_LOGIC;
  signal axi_vdma_0_M_AXI_S2MM_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vdma_0_M_AXI_S2MM_AWVALID : STD_LOGIC;
  signal axi_vdma_0_M_AXI_S2MM_BREADY : STD_LOGIC;
  signal axi_vdma_0_M_AXI_S2MM_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_vdma_0_M_AXI_S2MM_BVALID : STD_LOGIC;
  signal axi_vdma_0_M_AXI_S2MM_WDATA : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal axi_vdma_0_M_AXI_S2MM_WLAST : STD_LOGIC;
  signal axi_vdma_0_M_AXI_S2MM_WREADY : STD_LOGIC;
  signal axi_vdma_0_M_AXI_S2MM_WSTRB : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_vdma_0_M_AXI_S2MM_WVALID : STD_LOGIC;
  signal axi_vdma_1_M_AXI_S2MM_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vdma_1_M_AXI_S2MM_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_vdma_1_M_AXI_S2MM_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_vdma_1_M_AXI_S2MM_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_vdma_1_M_AXI_S2MM_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vdma_1_M_AXI_S2MM_AWREADY : STD_LOGIC;
  signal axi_vdma_1_M_AXI_S2MM_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vdma_1_M_AXI_S2MM_AWVALID : STD_LOGIC;
  signal axi_vdma_1_M_AXI_S2MM_BREADY : STD_LOGIC;
  signal axi_vdma_1_M_AXI_S2MM_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_vdma_1_M_AXI_S2MM_BVALID : STD_LOGIC;
  signal axi_vdma_1_M_AXI_S2MM_WDATA : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal axi_vdma_1_M_AXI_S2MM_WLAST : STD_LOGIC;
  signal axi_vdma_1_M_AXI_S2MM_WREADY : STD_LOGIC;
  signal axi_vdma_1_M_AXI_S2MM_WSTRB : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_vdma_1_M_AXI_S2MM_WVALID : STD_LOGIC;
  signal axi_vdma_1_s2mm_introut : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_ARVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_AWVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_BREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_RREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_WVALID : STD_LOGIC;
  signal rst_ps8_0_249M_peripheral_aresetn : STD_LOGIC;
  signal zynq_ultra_ps_e_0_pl_clk0 : STD_LOGIC;
  signal NLW_axi_vdma_0_mm2s_introut_UNCONNECTED : STD_LOGIC;
  signal NLW_axi_vdma_0_s2mm_introut_UNCONNECTED : STD_LOGIC;
  signal NLW_axi_vdma_0_mm2s_frame_ptr_out_UNCONNECTED : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal NLW_axi_vdma_0_s2mm_frame_ptr_out_UNCONNECTED : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal NLW_axi_vdma_1_s2mm_frame_ptr_out_UNCONNECTED : STD_LOGIC_VECTOR ( 5 downto 0 );
begin
  M00_AXI_araddr(48 downto 0) <= axi_smc_M00_AXI_ARADDR(48 downto 0);
  M00_AXI_arburst(1 downto 0) <= axi_smc_M00_AXI_ARBURST(1 downto 0);
  M00_AXI_arcache(3 downto 0) <= axi_smc_M00_AXI_ARCACHE(3 downto 0);
  M00_AXI_arlen(7 downto 0) <= axi_smc_M00_AXI_ARLEN(7 downto 0);
  M00_AXI_arlock(0) <= axi_smc_M00_AXI_ARLOCK(0);
  M00_AXI_arprot(2 downto 0) <= axi_smc_M00_AXI_ARPROT(2 downto 0);
  M00_AXI_arqos(3 downto 0) <= axi_smc_M00_AXI_ARQOS(3 downto 0);
  M00_AXI_arsize(2 downto 0) <= axi_smc_M00_AXI_ARSIZE(2 downto 0);
  M00_AXI_arvalid <= axi_smc_M00_AXI_ARVALID;
  M00_AXI_awaddr(48 downto 0) <= axi_smc_M00_AXI_AWADDR(48 downto 0);
  M00_AXI_awburst(1 downto 0) <= axi_smc_M00_AXI_AWBURST(1 downto 0);
  M00_AXI_awcache(3 downto 0) <= axi_smc_M00_AXI_AWCACHE(3 downto 0);
  M00_AXI_awlen(7 downto 0) <= axi_smc_M00_AXI_AWLEN(7 downto 0);
  M00_AXI_awlock(0) <= axi_smc_M00_AXI_AWLOCK(0);
  M00_AXI_awprot(2 downto 0) <= axi_smc_M00_AXI_AWPROT(2 downto 0);
  M00_AXI_awqos(3 downto 0) <= axi_smc_M00_AXI_AWQOS(3 downto 0);
  M00_AXI_awsize(2 downto 0) <= axi_smc_M00_AXI_AWSIZE(2 downto 0);
  M00_AXI_awvalid <= axi_smc_M00_AXI_AWVALID;
  M00_AXI_bready <= axi_smc_M00_AXI_BREADY;
  M00_AXI_rready <= axi_smc_M00_AXI_RREADY;
  M00_AXI_wdata(127 downto 0) <= axi_smc_M00_AXI_WDATA(127 downto 0);
  M00_AXI_wlast <= axi_smc_M00_AXI_WLAST;
  M00_AXI_wstrb(15 downto 0) <= axi_smc_M00_AXI_WSTRB(15 downto 0);
  M00_AXI_wvalid <= axi_smc_M00_AXI_WVALID;
  M_AXIS_MM2S_tdata(23 downto 0) <= axi_vdma_0_M_AXIS_MM2S_TDATA(23 downto 0);
  M_AXIS_MM2S_tkeep(2 downto 0) <= axi_vdma_0_M_AXIS_MM2S_TKEEP(2 downto 0);
  M_AXIS_MM2S_tlast <= axi_vdma_0_M_AXIS_MM2S_TLAST;
  M_AXIS_MM2S_tuser(0) <= axi_vdma_0_M_AXIS_MM2S_TUSER(0);
  M_AXIS_MM2S_tvalid <= axi_vdma_0_M_AXIS_MM2S_TVALID;
  S_AXIS_S2MM1_1_TDATA(23 downto 0) <= S_AXIS_S2MM1_tdata(23 downto 0);
  S_AXIS_S2MM1_1_TKEEP(2 downto 0) <= S_AXIS_S2MM1_tkeep(2 downto 0);
  S_AXIS_S2MM1_1_TLAST <= S_AXIS_S2MM1_tlast;
  S_AXIS_S2MM1_1_TUSER(0) <= S_AXIS_S2MM1_tuser(0);
  S_AXIS_S2MM1_1_TVALID <= S_AXIS_S2MM1_tvalid;
  S_AXIS_S2MM1_tready <= S_AXIS_S2MM1_1_TREADY;
  S_AXIS_S2MM_1_TDATA(23 downto 0) <= S_AXIS_S2MM_tdata(23 downto 0);
  S_AXIS_S2MM_1_TKEEP(2 downto 0) <= S_AXIS_S2MM_tkeep(2 downto 0);
  S_AXIS_S2MM_1_TLAST <= S_AXIS_S2MM_tlast;
  S_AXIS_S2MM_1_TUSER(0) <= S_AXIS_S2MM_tuser(0);
  S_AXIS_S2MM_1_TVALID <= S_AXIS_S2MM_tvalid;
  S_AXIS_S2MM_tready <= S_AXIS_S2MM_1_TREADY;
  S_AXI_LITE1_1_ARADDR(39 downto 0) <= S_AXI_LITE1_araddr(39 downto 0);
  S_AXI_LITE1_1_ARVALID <= S_AXI_LITE1_arvalid;
  S_AXI_LITE1_1_AWADDR(39 downto 0) <= S_AXI_LITE1_awaddr(39 downto 0);
  S_AXI_LITE1_1_AWVALID <= S_AXI_LITE1_awvalid;
  S_AXI_LITE1_1_BREADY <= S_AXI_LITE1_bready;
  S_AXI_LITE1_1_RREADY <= S_AXI_LITE1_rready;
  S_AXI_LITE1_1_WDATA(31 downto 0) <= S_AXI_LITE1_wdata(31 downto 0);
  S_AXI_LITE1_1_WVALID <= S_AXI_LITE1_wvalid;
  S_AXI_LITE1_arready <= S_AXI_LITE1_1_ARREADY;
  S_AXI_LITE1_awready <= S_AXI_LITE1_1_AWREADY;
  S_AXI_LITE1_bresp(1 downto 0) <= S_AXI_LITE1_1_BRESP(1 downto 0);
  S_AXI_LITE1_bvalid <= S_AXI_LITE1_1_BVALID;
  S_AXI_LITE1_rdata(31 downto 0) <= S_AXI_LITE1_1_RDATA(31 downto 0);
  S_AXI_LITE1_rresp(1 downto 0) <= S_AXI_LITE1_1_RRESP(1 downto 0);
  S_AXI_LITE1_rvalid <= S_AXI_LITE1_1_RVALID;
  S_AXI_LITE1_wready <= S_AXI_LITE1_1_WREADY;
  S_AXI_LITE_arready <= ps8_0_axi_periph_M01_AXI_ARREADY;
  S_AXI_LITE_awready <= ps8_0_axi_periph_M01_AXI_AWREADY;
  S_AXI_LITE_bresp(1 downto 0) <= ps8_0_axi_periph_M01_AXI_BRESP(1 downto 0);
  S_AXI_LITE_bvalid <= ps8_0_axi_periph_M01_AXI_BVALID;
  S_AXI_LITE_rdata(31 downto 0) <= ps8_0_axi_periph_M01_AXI_RDATA(31 downto 0);
  S_AXI_LITE_rresp(1 downto 0) <= ps8_0_axi_periph_M01_AXI_RRESP(1 downto 0);
  S_AXI_LITE_rvalid <= ps8_0_axi_periph_M01_AXI_RVALID;
  S_AXI_LITE_wready <= ps8_0_axi_periph_M01_AXI_WREADY;
  axi_smc_M00_AXI_ARREADY <= M00_AXI_arready;
  axi_smc_M00_AXI_AWREADY <= M00_AXI_awready;
  axi_smc_M00_AXI_BRESP(1 downto 0) <= M00_AXI_bresp(1 downto 0);
  axi_smc_M00_AXI_BVALID <= M00_AXI_bvalid;
  axi_smc_M00_AXI_RDATA(127 downto 0) <= M00_AXI_rdata(127 downto 0);
  axi_smc_M00_AXI_RLAST <= M00_AXI_rlast;
  axi_smc_M00_AXI_RRESP(1 downto 0) <= M00_AXI_rresp(1 downto 0);
  axi_smc_M00_AXI_RVALID <= M00_AXI_rvalid;
  axi_smc_M00_AXI_WREADY <= M00_AXI_wready;
  axi_vdma_0_M_AXIS_MM2S_TREADY <= M_AXIS_MM2S_tready;
  ps8_0_axi_periph_M01_AXI_ARADDR(39 downto 0) <= S_AXI_LITE_araddr(39 downto 0);
  ps8_0_axi_periph_M01_AXI_ARVALID <= S_AXI_LITE_arvalid;
  ps8_0_axi_periph_M01_AXI_AWADDR(39 downto 0) <= S_AXI_LITE_awaddr(39 downto 0);
  ps8_0_axi_periph_M01_AXI_AWVALID <= S_AXI_LITE_awvalid;
  ps8_0_axi_periph_M01_AXI_BREADY <= S_AXI_LITE_bready;
  ps8_0_axi_periph_M01_AXI_RREADY <= S_AXI_LITE_rready;
  ps8_0_axi_periph_M01_AXI_WDATA(31 downto 0) <= S_AXI_LITE_wdata(31 downto 0);
  ps8_0_axi_periph_M01_AXI_WVALID <= S_AXI_LITE_wvalid;
  rst_ps8_0_249M_peripheral_aresetn <= aresetn;
  s2mm_introut <= axi_vdma_1_s2mm_introut;
  zynq_ultra_ps_e_0_pl_clk0 <= aclk;
axi_smc: component kv260_video_axi_smc_0
     port map (
      M00_AXI_araddr(48 downto 0) => axi_smc_M00_AXI_ARADDR(48 downto 0),
      M00_AXI_arburst(1 downto 0) => axi_smc_M00_AXI_ARBURST(1 downto 0),
      M00_AXI_arcache(3 downto 0) => axi_smc_M00_AXI_ARCACHE(3 downto 0),
      M00_AXI_arlen(7 downto 0) => axi_smc_M00_AXI_ARLEN(7 downto 0),
      M00_AXI_arlock(0) => axi_smc_M00_AXI_ARLOCK(0),
      M00_AXI_arprot(2 downto 0) => axi_smc_M00_AXI_ARPROT(2 downto 0),
      M00_AXI_arqos(3 downto 0) => axi_smc_M00_AXI_ARQOS(3 downto 0),
      M00_AXI_arready => axi_smc_M00_AXI_ARREADY,
      M00_AXI_arsize(2 downto 0) => axi_smc_M00_AXI_ARSIZE(2 downto 0),
      M00_AXI_arvalid => axi_smc_M00_AXI_ARVALID,
      M00_AXI_awaddr(48 downto 0) => axi_smc_M00_AXI_AWADDR(48 downto 0),
      M00_AXI_awburst(1 downto 0) => axi_smc_M00_AXI_AWBURST(1 downto 0),
      M00_AXI_awcache(3 downto 0) => axi_smc_M00_AXI_AWCACHE(3 downto 0),
      M00_AXI_awlen(7 downto 0) => axi_smc_M00_AXI_AWLEN(7 downto 0),
      M00_AXI_awlock(0) => axi_smc_M00_AXI_AWLOCK(0),
      M00_AXI_awprot(2 downto 0) => axi_smc_M00_AXI_AWPROT(2 downto 0),
      M00_AXI_awqos(3 downto 0) => axi_smc_M00_AXI_AWQOS(3 downto 0),
      M00_AXI_awready => axi_smc_M00_AXI_AWREADY,
      M00_AXI_awsize(2 downto 0) => axi_smc_M00_AXI_AWSIZE(2 downto 0),
      M00_AXI_awvalid => axi_smc_M00_AXI_AWVALID,
      M00_AXI_bready => axi_smc_M00_AXI_BREADY,
      M00_AXI_bresp(1 downto 0) => axi_smc_M00_AXI_BRESP(1 downto 0),
      M00_AXI_bvalid => axi_smc_M00_AXI_BVALID,
      M00_AXI_rdata(127 downto 0) => axi_smc_M00_AXI_RDATA(127 downto 0),
      M00_AXI_rlast => axi_smc_M00_AXI_RLAST,
      M00_AXI_rready => axi_smc_M00_AXI_RREADY,
      M00_AXI_rresp(1 downto 0) => axi_smc_M00_AXI_RRESP(1 downto 0),
      M00_AXI_rvalid => axi_smc_M00_AXI_RVALID,
      M00_AXI_wdata(127 downto 0) => axi_smc_M00_AXI_WDATA(127 downto 0),
      M00_AXI_wlast => axi_smc_M00_AXI_WLAST,
      M00_AXI_wready => axi_smc_M00_AXI_WREADY,
      M00_AXI_wstrb(15 downto 0) => axi_smc_M00_AXI_WSTRB(15 downto 0),
      M00_AXI_wvalid => axi_smc_M00_AXI_WVALID,
      S00_AXI_araddr(31 downto 0) => axi_vdma_0_M_AXI_MM2S_ARADDR(31 downto 0),
      S00_AXI_arburst(1 downto 0) => axi_vdma_0_M_AXI_MM2S_ARBURST(1 downto 0),
      S00_AXI_arcache(3 downto 0) => axi_vdma_0_M_AXI_MM2S_ARCACHE(3 downto 0),
      S00_AXI_arlen(7 downto 0) => axi_vdma_0_M_AXI_MM2S_ARLEN(7 downto 0),
      S00_AXI_arlock(0) => '0',
      S00_AXI_arprot(2 downto 0) => axi_vdma_0_M_AXI_MM2S_ARPROT(2 downto 0),
      S00_AXI_arqos(3 downto 0) => B"0000",
      S00_AXI_arready => axi_vdma_0_M_AXI_MM2S_ARREADY,
      S00_AXI_arsize(2 downto 0) => axi_vdma_0_M_AXI_MM2S_ARSIZE(2 downto 0),
      S00_AXI_arvalid => axi_vdma_0_M_AXI_MM2S_ARVALID,
      S00_AXI_rdata(63 downto 0) => axi_vdma_0_M_AXI_MM2S_RDATA(63 downto 0),
      S00_AXI_rlast => axi_vdma_0_M_AXI_MM2S_RLAST,
      S00_AXI_rready => axi_vdma_0_M_AXI_MM2S_RREADY,
      S00_AXI_rresp(1 downto 0) => axi_vdma_0_M_AXI_MM2S_RRESP(1 downto 0),
      S00_AXI_rvalid => axi_vdma_0_M_AXI_MM2S_RVALID,
      S01_AXI_awaddr(31 downto 0) => axi_vdma_0_M_AXI_S2MM_AWADDR(31 downto 0),
      S01_AXI_awburst(1 downto 0) => axi_vdma_0_M_AXI_S2MM_AWBURST(1 downto 0),
      S01_AXI_awcache(3 downto 0) => axi_vdma_0_M_AXI_S2MM_AWCACHE(3 downto 0),
      S01_AXI_awlen(7 downto 0) => axi_vdma_0_M_AXI_S2MM_AWLEN(7 downto 0),
      S01_AXI_awlock(0) => '0',
      S01_AXI_awprot(2 downto 0) => axi_vdma_0_M_AXI_S2MM_AWPROT(2 downto 0),
      S01_AXI_awqos(3 downto 0) => B"0000",
      S01_AXI_awready => axi_vdma_0_M_AXI_S2MM_AWREADY,
      S01_AXI_awsize(2 downto 0) => axi_vdma_0_M_AXI_S2MM_AWSIZE(2 downto 0),
      S01_AXI_awvalid => axi_vdma_0_M_AXI_S2MM_AWVALID,
      S01_AXI_bready => axi_vdma_0_M_AXI_S2MM_BREADY,
      S01_AXI_bresp(1 downto 0) => axi_vdma_0_M_AXI_S2MM_BRESP(1 downto 0),
      S01_AXI_bvalid => axi_vdma_0_M_AXI_S2MM_BVALID,
      S01_AXI_wdata(63 downto 0) => axi_vdma_0_M_AXI_S2MM_WDATA(63 downto 0),
      S01_AXI_wlast => axi_vdma_0_M_AXI_S2MM_WLAST,
      S01_AXI_wready => axi_vdma_0_M_AXI_S2MM_WREADY,
      S01_AXI_wstrb(7 downto 0) => axi_vdma_0_M_AXI_S2MM_WSTRB(7 downto 0),
      S01_AXI_wvalid => axi_vdma_0_M_AXI_S2MM_WVALID,
      S02_AXI_awaddr(31 downto 0) => axi_vdma_1_M_AXI_S2MM_AWADDR(31 downto 0),
      S02_AXI_awburst(1 downto 0) => axi_vdma_1_M_AXI_S2MM_AWBURST(1 downto 0),
      S02_AXI_awcache(3 downto 0) => axi_vdma_1_M_AXI_S2MM_AWCACHE(3 downto 0),
      S02_AXI_awlen(7 downto 0) => axi_vdma_1_M_AXI_S2MM_AWLEN(7 downto 0),
      S02_AXI_awlock(0) => '0',
      S02_AXI_awprot(2 downto 0) => axi_vdma_1_M_AXI_S2MM_AWPROT(2 downto 0),
      S02_AXI_awqos(3 downto 0) => B"0000",
      S02_AXI_awready => axi_vdma_1_M_AXI_S2MM_AWREADY,
      S02_AXI_awsize(2 downto 0) => axi_vdma_1_M_AXI_S2MM_AWSIZE(2 downto 0),
      S02_AXI_awvalid => axi_vdma_1_M_AXI_S2MM_AWVALID,
      S02_AXI_bready => axi_vdma_1_M_AXI_S2MM_BREADY,
      S02_AXI_bresp(1 downto 0) => axi_vdma_1_M_AXI_S2MM_BRESP(1 downto 0),
      S02_AXI_bvalid => axi_vdma_1_M_AXI_S2MM_BVALID,
      S02_AXI_wdata(63 downto 0) => axi_vdma_1_M_AXI_S2MM_WDATA(63 downto 0),
      S02_AXI_wlast => axi_vdma_1_M_AXI_S2MM_WLAST,
      S02_AXI_wready => axi_vdma_1_M_AXI_S2MM_WREADY,
      S02_AXI_wstrb(7 downto 0) => axi_vdma_1_M_AXI_S2MM_WSTRB(7 downto 0),
      S02_AXI_wvalid => axi_vdma_1_M_AXI_S2MM_WVALID,
      aclk => zynq_ultra_ps_e_0_pl_clk0,
      aresetn => rst_ps8_0_249M_peripheral_aresetn
    );
axi_vdma_0: component kv260_video_axi_vdma_0_0
     port map (
      axi_resetn => rst_ps8_0_249M_peripheral_aresetn,
      m_axi_mm2s_aclk => zynq_ultra_ps_e_0_pl_clk0,
      m_axi_mm2s_araddr(31 downto 0) => axi_vdma_0_M_AXI_MM2S_ARADDR(31 downto 0),
      m_axi_mm2s_arburst(1 downto 0) => axi_vdma_0_M_AXI_MM2S_ARBURST(1 downto 0),
      m_axi_mm2s_arcache(3 downto 0) => axi_vdma_0_M_AXI_MM2S_ARCACHE(3 downto 0),
      m_axi_mm2s_arlen(7 downto 0) => axi_vdma_0_M_AXI_MM2S_ARLEN(7 downto 0),
      m_axi_mm2s_arprot(2 downto 0) => axi_vdma_0_M_AXI_MM2S_ARPROT(2 downto 0),
      m_axi_mm2s_arready => axi_vdma_0_M_AXI_MM2S_ARREADY,
      m_axi_mm2s_arsize(2 downto 0) => axi_vdma_0_M_AXI_MM2S_ARSIZE(2 downto 0),
      m_axi_mm2s_arvalid => axi_vdma_0_M_AXI_MM2S_ARVALID,
      m_axi_mm2s_rdata(63 downto 0) => axi_vdma_0_M_AXI_MM2S_RDATA(63 downto 0),
      m_axi_mm2s_rlast => axi_vdma_0_M_AXI_MM2S_RLAST,
      m_axi_mm2s_rready => axi_vdma_0_M_AXI_MM2S_RREADY,
      m_axi_mm2s_rresp(1 downto 0) => axi_vdma_0_M_AXI_MM2S_RRESP(1 downto 0),
      m_axi_mm2s_rvalid => axi_vdma_0_M_AXI_MM2S_RVALID,
      m_axi_s2mm_aclk => zynq_ultra_ps_e_0_pl_clk0,
      m_axi_s2mm_awaddr(31 downto 0) => axi_vdma_0_M_AXI_S2MM_AWADDR(31 downto 0),
      m_axi_s2mm_awburst(1 downto 0) => axi_vdma_0_M_AXI_S2MM_AWBURST(1 downto 0),
      m_axi_s2mm_awcache(3 downto 0) => axi_vdma_0_M_AXI_S2MM_AWCACHE(3 downto 0),
      m_axi_s2mm_awlen(7 downto 0) => axi_vdma_0_M_AXI_S2MM_AWLEN(7 downto 0),
      m_axi_s2mm_awprot(2 downto 0) => axi_vdma_0_M_AXI_S2MM_AWPROT(2 downto 0),
      m_axi_s2mm_awready => axi_vdma_0_M_AXI_S2MM_AWREADY,
      m_axi_s2mm_awsize(2 downto 0) => axi_vdma_0_M_AXI_S2MM_AWSIZE(2 downto 0),
      m_axi_s2mm_awvalid => axi_vdma_0_M_AXI_S2MM_AWVALID,
      m_axi_s2mm_bready => axi_vdma_0_M_AXI_S2MM_BREADY,
      m_axi_s2mm_bresp(1 downto 0) => axi_vdma_0_M_AXI_S2MM_BRESP(1 downto 0),
      m_axi_s2mm_bvalid => axi_vdma_0_M_AXI_S2MM_BVALID,
      m_axi_s2mm_wdata(63 downto 0) => axi_vdma_0_M_AXI_S2MM_WDATA(63 downto 0),
      m_axi_s2mm_wlast => axi_vdma_0_M_AXI_S2MM_WLAST,
      m_axi_s2mm_wready => axi_vdma_0_M_AXI_S2MM_WREADY,
      m_axi_s2mm_wstrb(7 downto 0) => axi_vdma_0_M_AXI_S2MM_WSTRB(7 downto 0),
      m_axi_s2mm_wvalid => axi_vdma_0_M_AXI_S2MM_WVALID,
      m_axis_mm2s_aclk => zynq_ultra_ps_e_0_pl_clk0,
      m_axis_mm2s_tdata(23 downto 0) => axi_vdma_0_M_AXIS_MM2S_TDATA(23 downto 0),
      m_axis_mm2s_tkeep(2 downto 0) => axi_vdma_0_M_AXIS_MM2S_TKEEP(2 downto 0),
      m_axis_mm2s_tlast => axi_vdma_0_M_AXIS_MM2S_TLAST,
      m_axis_mm2s_tready => axi_vdma_0_M_AXIS_MM2S_TREADY,
      m_axis_mm2s_tuser(0) => axi_vdma_0_M_AXIS_MM2S_TUSER(0),
      m_axis_mm2s_tvalid => axi_vdma_0_M_AXIS_MM2S_TVALID,
      mm2s_frame_ptr_out(5 downto 0) => NLW_axi_vdma_0_mm2s_frame_ptr_out_UNCONNECTED(5 downto 0),
      mm2s_introut => NLW_axi_vdma_0_mm2s_introut_UNCONNECTED,
      s2mm_frame_ptr_out(5 downto 0) => NLW_axi_vdma_0_s2mm_frame_ptr_out_UNCONNECTED(5 downto 0),
      s2mm_introut => NLW_axi_vdma_0_s2mm_introut_UNCONNECTED,
      s_axi_lite_aclk => zynq_ultra_ps_e_0_pl_clk0,
      s_axi_lite_araddr(8 downto 0) => ps8_0_axi_periph_M01_AXI_ARADDR(8 downto 0),
      s_axi_lite_arready => ps8_0_axi_periph_M01_AXI_ARREADY,
      s_axi_lite_arvalid => ps8_0_axi_periph_M01_AXI_ARVALID,
      s_axi_lite_awaddr(8 downto 0) => ps8_0_axi_periph_M01_AXI_AWADDR(8 downto 0),
      s_axi_lite_awready => ps8_0_axi_periph_M01_AXI_AWREADY,
      s_axi_lite_awvalid => ps8_0_axi_periph_M01_AXI_AWVALID,
      s_axi_lite_bready => ps8_0_axi_periph_M01_AXI_BREADY,
      s_axi_lite_bresp(1 downto 0) => ps8_0_axi_periph_M01_AXI_BRESP(1 downto 0),
      s_axi_lite_bvalid => ps8_0_axi_periph_M01_AXI_BVALID,
      s_axi_lite_rdata(31 downto 0) => ps8_0_axi_periph_M01_AXI_RDATA(31 downto 0),
      s_axi_lite_rready => ps8_0_axi_periph_M01_AXI_RREADY,
      s_axi_lite_rresp(1 downto 0) => ps8_0_axi_periph_M01_AXI_RRESP(1 downto 0),
      s_axi_lite_rvalid => ps8_0_axi_periph_M01_AXI_RVALID,
      s_axi_lite_wdata(31 downto 0) => ps8_0_axi_periph_M01_AXI_WDATA(31 downto 0),
      s_axi_lite_wready => ps8_0_axi_periph_M01_AXI_WREADY,
      s_axi_lite_wvalid => ps8_0_axi_periph_M01_AXI_WVALID,
      s_axis_s2mm_aclk => zynq_ultra_ps_e_0_pl_clk0,
      s_axis_s2mm_tdata(23 downto 0) => S_AXIS_S2MM_1_TDATA(23 downto 0),
      s_axis_s2mm_tkeep(2 downto 0) => S_AXIS_S2MM_1_TKEEP(2 downto 0),
      s_axis_s2mm_tlast => S_AXIS_S2MM_1_TLAST,
      s_axis_s2mm_tready => S_AXIS_S2MM_1_TREADY,
      s_axis_s2mm_tuser(0) => S_AXIS_S2MM_1_TUSER(0),
      s_axis_s2mm_tvalid => S_AXIS_S2MM_1_TVALID
    );
axi_vdma_1: component kv260_video_axi_vdma_1_0
     port map (
      axi_resetn => rst_ps8_0_249M_peripheral_aresetn,
      m_axi_s2mm_aclk => zynq_ultra_ps_e_0_pl_clk0,
      m_axi_s2mm_awaddr(31 downto 0) => axi_vdma_1_M_AXI_S2MM_AWADDR(31 downto 0),
      m_axi_s2mm_awburst(1 downto 0) => axi_vdma_1_M_AXI_S2MM_AWBURST(1 downto 0),
      m_axi_s2mm_awcache(3 downto 0) => axi_vdma_1_M_AXI_S2MM_AWCACHE(3 downto 0),
      m_axi_s2mm_awlen(7 downto 0) => axi_vdma_1_M_AXI_S2MM_AWLEN(7 downto 0),
      m_axi_s2mm_awprot(2 downto 0) => axi_vdma_1_M_AXI_S2MM_AWPROT(2 downto 0),
      m_axi_s2mm_awready => axi_vdma_1_M_AXI_S2MM_AWREADY,
      m_axi_s2mm_awsize(2 downto 0) => axi_vdma_1_M_AXI_S2MM_AWSIZE(2 downto 0),
      m_axi_s2mm_awvalid => axi_vdma_1_M_AXI_S2MM_AWVALID,
      m_axi_s2mm_bready => axi_vdma_1_M_AXI_S2MM_BREADY,
      m_axi_s2mm_bresp(1 downto 0) => axi_vdma_1_M_AXI_S2MM_BRESP(1 downto 0),
      m_axi_s2mm_bvalid => axi_vdma_1_M_AXI_S2MM_BVALID,
      m_axi_s2mm_wdata(63 downto 0) => axi_vdma_1_M_AXI_S2MM_WDATA(63 downto 0),
      m_axi_s2mm_wlast => axi_vdma_1_M_AXI_S2MM_WLAST,
      m_axi_s2mm_wready => axi_vdma_1_M_AXI_S2MM_WREADY,
      m_axi_s2mm_wstrb(7 downto 0) => axi_vdma_1_M_AXI_S2MM_WSTRB(7 downto 0),
      m_axi_s2mm_wvalid => axi_vdma_1_M_AXI_S2MM_WVALID,
      s2mm_frame_ptr_out(5 downto 0) => NLW_axi_vdma_1_s2mm_frame_ptr_out_UNCONNECTED(5 downto 0),
      s2mm_introut => axi_vdma_1_s2mm_introut,
      s_axi_lite_aclk => zynq_ultra_ps_e_0_pl_clk0,
      s_axi_lite_araddr(8 downto 0) => S_AXI_LITE1_1_ARADDR(8 downto 0),
      s_axi_lite_arready => S_AXI_LITE1_1_ARREADY,
      s_axi_lite_arvalid => S_AXI_LITE1_1_ARVALID,
      s_axi_lite_awaddr(8 downto 0) => S_AXI_LITE1_1_AWADDR(8 downto 0),
      s_axi_lite_awready => S_AXI_LITE1_1_AWREADY,
      s_axi_lite_awvalid => S_AXI_LITE1_1_AWVALID,
      s_axi_lite_bready => S_AXI_LITE1_1_BREADY,
      s_axi_lite_bresp(1 downto 0) => S_AXI_LITE1_1_BRESP(1 downto 0),
      s_axi_lite_bvalid => S_AXI_LITE1_1_BVALID,
      s_axi_lite_rdata(31 downto 0) => S_AXI_LITE1_1_RDATA(31 downto 0),
      s_axi_lite_rready => S_AXI_LITE1_1_RREADY,
      s_axi_lite_rresp(1 downto 0) => S_AXI_LITE1_1_RRESP(1 downto 0),
      s_axi_lite_rvalid => S_AXI_LITE1_1_RVALID,
      s_axi_lite_wdata(31 downto 0) => S_AXI_LITE1_1_WDATA(31 downto 0),
      s_axi_lite_wready => S_AXI_LITE1_1_WREADY,
      s_axi_lite_wvalid => S_AXI_LITE1_1_WVALID,
      s_axis_s2mm_aclk => zynq_ultra_ps_e_0_pl_clk0,
      s_axis_s2mm_tdata(23 downto 0) => S_AXIS_S2MM1_1_TDATA(23 downto 0),
      s_axis_s2mm_tkeep(2 downto 0) => S_AXIS_S2MM1_1_TKEEP(2 downto 0),
      s_axis_s2mm_tlast => S_AXIS_S2MM1_1_TLAST,
      s_axis_s2mm_tready => S_AXIS_S2MM1_1_TREADY,
      s_axis_s2mm_tuser(0) => S_AXIS_S2MM1_1_TUSER(0),
      s_axis_s2mm_tvalid => S_AXIS_S2MM1_1_TVALID
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m00_couplers_imp_SG6IWI is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wvalid : in STD_LOGIC
  );
end m00_couplers_imp_SG6IWI;

architecture STRUCTURE of m00_couplers_imp_SG6IWI is
  signal m00_couplers_to_m00_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m00_couplers_to_m00_couplers_ARREADY : STD_LOGIC;
  signal m00_couplers_to_m00_couplers_ARVALID : STD_LOGIC;
  signal m00_couplers_to_m00_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m00_couplers_to_m00_couplers_AWREADY : STD_LOGIC;
  signal m00_couplers_to_m00_couplers_AWVALID : STD_LOGIC;
  signal m00_couplers_to_m00_couplers_BREADY : STD_LOGIC;
  signal m00_couplers_to_m00_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m00_couplers_to_m00_couplers_BVALID : STD_LOGIC;
  signal m00_couplers_to_m00_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_m00_couplers_RREADY : STD_LOGIC;
  signal m00_couplers_to_m00_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m00_couplers_to_m00_couplers_RVALID : STD_LOGIC;
  signal m00_couplers_to_m00_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_m00_couplers_WREADY : STD_LOGIC;
  signal m00_couplers_to_m00_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(39 downto 0) <= m00_couplers_to_m00_couplers_ARADDR(39 downto 0);
  M_AXI_arvalid <= m00_couplers_to_m00_couplers_ARVALID;
  M_AXI_awaddr(39 downto 0) <= m00_couplers_to_m00_couplers_AWADDR(39 downto 0);
  M_AXI_awvalid <= m00_couplers_to_m00_couplers_AWVALID;
  M_AXI_bready <= m00_couplers_to_m00_couplers_BREADY;
  M_AXI_rready <= m00_couplers_to_m00_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m00_couplers_to_m00_couplers_WDATA(31 downto 0);
  M_AXI_wvalid <= m00_couplers_to_m00_couplers_WVALID;
  S_AXI_arready <= m00_couplers_to_m00_couplers_ARREADY;
  S_AXI_awready <= m00_couplers_to_m00_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m00_couplers_to_m00_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m00_couplers_to_m00_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m00_couplers_to_m00_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m00_couplers_to_m00_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m00_couplers_to_m00_couplers_RVALID;
  S_AXI_wready <= m00_couplers_to_m00_couplers_WREADY;
  m00_couplers_to_m00_couplers_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  m00_couplers_to_m00_couplers_ARREADY <= M_AXI_arready;
  m00_couplers_to_m00_couplers_ARVALID <= S_AXI_arvalid;
  m00_couplers_to_m00_couplers_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  m00_couplers_to_m00_couplers_AWREADY <= M_AXI_awready;
  m00_couplers_to_m00_couplers_AWVALID <= S_AXI_awvalid;
  m00_couplers_to_m00_couplers_BREADY <= S_AXI_bready;
  m00_couplers_to_m00_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m00_couplers_to_m00_couplers_BVALID <= M_AXI_bvalid;
  m00_couplers_to_m00_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m00_couplers_to_m00_couplers_RREADY <= S_AXI_rready;
  m00_couplers_to_m00_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m00_couplers_to_m00_couplers_RVALID <= M_AXI_rvalid;
  m00_couplers_to_m00_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m00_couplers_to_m00_couplers_WREADY <= M_AXI_wready;
  m00_couplers_to_m00_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m01_couplers_imp_1X6EAI4 is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end m01_couplers_imp_1X6EAI4;

architecture STRUCTURE of m01_couplers_imp_1X6EAI4 is
  signal m01_couplers_to_m01_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m01_couplers_to_m01_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_m01_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_m01_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m01_couplers_to_m01_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_m01_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_m01_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_m01_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m01_couplers_to_m01_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_m01_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_m01_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_m01_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m01_couplers_to_m01_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_m01_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_m01_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_m01_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m01_couplers_to_m01_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  M_AXI_araddr(39 downto 0) <= m01_couplers_to_m01_couplers_ARADDR(39 downto 0);
  M_AXI_arvalid(0) <= m01_couplers_to_m01_couplers_ARVALID(0);
  M_AXI_awaddr(39 downto 0) <= m01_couplers_to_m01_couplers_AWADDR(39 downto 0);
  M_AXI_awvalid(0) <= m01_couplers_to_m01_couplers_AWVALID(0);
  M_AXI_bready(0) <= m01_couplers_to_m01_couplers_BREADY(0);
  M_AXI_rready(0) <= m01_couplers_to_m01_couplers_RREADY(0);
  M_AXI_wdata(31 downto 0) <= m01_couplers_to_m01_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m01_couplers_to_m01_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid(0) <= m01_couplers_to_m01_couplers_WVALID(0);
  S_AXI_arready(0) <= m01_couplers_to_m01_couplers_ARREADY(0);
  S_AXI_awready(0) <= m01_couplers_to_m01_couplers_AWREADY(0);
  S_AXI_bresp(1 downto 0) <= m01_couplers_to_m01_couplers_BRESP(1 downto 0);
  S_AXI_bvalid(0) <= m01_couplers_to_m01_couplers_BVALID(0);
  S_AXI_rdata(31 downto 0) <= m01_couplers_to_m01_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m01_couplers_to_m01_couplers_RRESP(1 downto 0);
  S_AXI_rvalid(0) <= m01_couplers_to_m01_couplers_RVALID(0);
  S_AXI_wready(0) <= m01_couplers_to_m01_couplers_WREADY(0);
  m01_couplers_to_m01_couplers_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  m01_couplers_to_m01_couplers_ARREADY(0) <= M_AXI_arready(0);
  m01_couplers_to_m01_couplers_ARVALID(0) <= S_AXI_arvalid(0);
  m01_couplers_to_m01_couplers_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  m01_couplers_to_m01_couplers_AWREADY(0) <= M_AXI_awready(0);
  m01_couplers_to_m01_couplers_AWVALID(0) <= S_AXI_awvalid(0);
  m01_couplers_to_m01_couplers_BREADY(0) <= S_AXI_bready(0);
  m01_couplers_to_m01_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m01_couplers_to_m01_couplers_BVALID(0) <= M_AXI_bvalid(0);
  m01_couplers_to_m01_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m01_couplers_to_m01_couplers_RREADY(0) <= S_AXI_rready(0);
  m01_couplers_to_m01_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m01_couplers_to_m01_couplers_RVALID(0) <= M_AXI_rvalid(0);
  m01_couplers_to_m01_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m01_couplers_to_m01_couplers_WREADY(0) <= M_AXI_wready(0);
  m01_couplers_to_m01_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m01_couplers_to_m01_couplers_WVALID(0) <= S_AXI_wvalid(0);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m02_couplers_imp_105IVDB is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end m02_couplers_imp_105IVDB;

architecture STRUCTURE of m02_couplers_imp_105IVDB is
  signal m02_couplers_to_m02_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m02_couplers_to_m02_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_m02_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_m02_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m02_couplers_to_m02_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_m02_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_m02_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_m02_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m02_couplers_to_m02_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_m02_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_m02_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_m02_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m02_couplers_to_m02_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_m02_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_m02_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_m02_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m02_couplers_to_m02_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  M_AXI_araddr(39 downto 0) <= m02_couplers_to_m02_couplers_ARADDR(39 downto 0);
  M_AXI_arvalid(0) <= m02_couplers_to_m02_couplers_ARVALID(0);
  M_AXI_awaddr(39 downto 0) <= m02_couplers_to_m02_couplers_AWADDR(39 downto 0);
  M_AXI_awvalid(0) <= m02_couplers_to_m02_couplers_AWVALID(0);
  M_AXI_bready(0) <= m02_couplers_to_m02_couplers_BREADY(0);
  M_AXI_rready(0) <= m02_couplers_to_m02_couplers_RREADY(0);
  M_AXI_wdata(31 downto 0) <= m02_couplers_to_m02_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m02_couplers_to_m02_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid(0) <= m02_couplers_to_m02_couplers_WVALID(0);
  S_AXI_arready(0) <= m02_couplers_to_m02_couplers_ARREADY(0);
  S_AXI_awready(0) <= m02_couplers_to_m02_couplers_AWREADY(0);
  S_AXI_bresp(1 downto 0) <= m02_couplers_to_m02_couplers_BRESP(1 downto 0);
  S_AXI_bvalid(0) <= m02_couplers_to_m02_couplers_BVALID(0);
  S_AXI_rdata(31 downto 0) <= m02_couplers_to_m02_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m02_couplers_to_m02_couplers_RRESP(1 downto 0);
  S_AXI_rvalid(0) <= m02_couplers_to_m02_couplers_RVALID(0);
  S_AXI_wready(0) <= m02_couplers_to_m02_couplers_WREADY(0);
  m02_couplers_to_m02_couplers_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  m02_couplers_to_m02_couplers_ARREADY(0) <= M_AXI_arready(0);
  m02_couplers_to_m02_couplers_ARVALID(0) <= S_AXI_arvalid(0);
  m02_couplers_to_m02_couplers_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  m02_couplers_to_m02_couplers_AWREADY(0) <= M_AXI_awready(0);
  m02_couplers_to_m02_couplers_AWVALID(0) <= S_AXI_awvalid(0);
  m02_couplers_to_m02_couplers_BREADY(0) <= S_AXI_bready(0);
  m02_couplers_to_m02_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m02_couplers_to_m02_couplers_BVALID(0) <= M_AXI_bvalid(0);
  m02_couplers_to_m02_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m02_couplers_to_m02_couplers_RREADY(0) <= S_AXI_rready(0);
  m02_couplers_to_m02_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m02_couplers_to_m02_couplers_RVALID(0) <= M_AXI_rvalid(0);
  m02_couplers_to_m02_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m02_couplers_to_m02_couplers_WREADY(0) <= M_AXI_wready(0);
  m02_couplers_to_m02_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m02_couplers_to_m02_couplers_WVALID(0) <= S_AXI_wvalid(0);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m03_couplers_imp_87J55D is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m03_couplers_imp_87J55D;

architecture STRUCTURE of m03_couplers_imp_87J55D is
  signal m03_couplers_to_m03_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m03_couplers_to_m03_couplers_ARREADY : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_ARVALID : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m03_couplers_to_m03_couplers_AWREADY : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_AWVALID : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_BREADY : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m03_couplers_to_m03_couplers_BVALID : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_m03_couplers_RREADY : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m03_couplers_to_m03_couplers_RVALID : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_m03_couplers_WREADY : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m03_couplers_to_m03_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(39 downto 0) <= m03_couplers_to_m03_couplers_ARADDR(39 downto 0);
  M_AXI_arvalid <= m03_couplers_to_m03_couplers_ARVALID;
  M_AXI_awaddr(39 downto 0) <= m03_couplers_to_m03_couplers_AWADDR(39 downto 0);
  M_AXI_awvalid <= m03_couplers_to_m03_couplers_AWVALID;
  M_AXI_bready <= m03_couplers_to_m03_couplers_BREADY;
  M_AXI_rready <= m03_couplers_to_m03_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m03_couplers_to_m03_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m03_couplers_to_m03_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m03_couplers_to_m03_couplers_WVALID;
  S_AXI_arready <= m03_couplers_to_m03_couplers_ARREADY;
  S_AXI_awready <= m03_couplers_to_m03_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m03_couplers_to_m03_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m03_couplers_to_m03_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m03_couplers_to_m03_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m03_couplers_to_m03_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m03_couplers_to_m03_couplers_RVALID;
  S_AXI_wready <= m03_couplers_to_m03_couplers_WREADY;
  m03_couplers_to_m03_couplers_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  m03_couplers_to_m03_couplers_ARREADY <= M_AXI_arready;
  m03_couplers_to_m03_couplers_ARVALID <= S_AXI_arvalid;
  m03_couplers_to_m03_couplers_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  m03_couplers_to_m03_couplers_AWREADY <= M_AXI_awready;
  m03_couplers_to_m03_couplers_AWVALID <= S_AXI_awvalid;
  m03_couplers_to_m03_couplers_BREADY <= S_AXI_bready;
  m03_couplers_to_m03_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m03_couplers_to_m03_couplers_BVALID <= M_AXI_bvalid;
  m03_couplers_to_m03_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m03_couplers_to_m03_couplers_RREADY <= S_AXI_rready;
  m03_couplers_to_m03_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m03_couplers_to_m03_couplers_RVALID <= M_AXI_rvalid;
  m03_couplers_to_m03_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m03_couplers_to_m03_couplers_WREADY <= M_AXI_wready;
  m03_couplers_to_m03_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m03_couplers_to_m03_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m04_couplers_imp_WB4IH5 is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end m04_couplers_imp_WB4IH5;

architecture STRUCTURE of m04_couplers_imp_WB4IH5 is
  signal m04_couplers_to_m04_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m04_couplers_to_m04_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m04_couplers_to_m04_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_m04_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_m04_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m04_couplers_to_m04_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m04_couplers_to_m04_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_m04_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_m04_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_m04_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m04_couplers_to_m04_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_m04_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_m04_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_m04_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m04_couplers_to_m04_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_m04_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_m04_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_m04_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m04_couplers_to_m04_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  M_AXI_araddr(39 downto 0) <= m04_couplers_to_m04_couplers_ARADDR(39 downto 0);
  M_AXI_arprot(2 downto 0) <= m04_couplers_to_m04_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid(0) <= m04_couplers_to_m04_couplers_ARVALID(0);
  M_AXI_awaddr(39 downto 0) <= m04_couplers_to_m04_couplers_AWADDR(39 downto 0);
  M_AXI_awprot(2 downto 0) <= m04_couplers_to_m04_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid(0) <= m04_couplers_to_m04_couplers_AWVALID(0);
  M_AXI_bready(0) <= m04_couplers_to_m04_couplers_BREADY(0);
  M_AXI_rready(0) <= m04_couplers_to_m04_couplers_RREADY(0);
  M_AXI_wdata(31 downto 0) <= m04_couplers_to_m04_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m04_couplers_to_m04_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid(0) <= m04_couplers_to_m04_couplers_WVALID(0);
  S_AXI_arready(0) <= m04_couplers_to_m04_couplers_ARREADY(0);
  S_AXI_awready(0) <= m04_couplers_to_m04_couplers_AWREADY(0);
  S_AXI_bresp(1 downto 0) <= m04_couplers_to_m04_couplers_BRESP(1 downto 0);
  S_AXI_bvalid(0) <= m04_couplers_to_m04_couplers_BVALID(0);
  S_AXI_rdata(31 downto 0) <= m04_couplers_to_m04_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m04_couplers_to_m04_couplers_RRESP(1 downto 0);
  S_AXI_rvalid(0) <= m04_couplers_to_m04_couplers_RVALID(0);
  S_AXI_wready(0) <= m04_couplers_to_m04_couplers_WREADY(0);
  m04_couplers_to_m04_couplers_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  m04_couplers_to_m04_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m04_couplers_to_m04_couplers_ARREADY(0) <= M_AXI_arready(0);
  m04_couplers_to_m04_couplers_ARVALID(0) <= S_AXI_arvalid(0);
  m04_couplers_to_m04_couplers_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  m04_couplers_to_m04_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m04_couplers_to_m04_couplers_AWREADY(0) <= M_AXI_awready(0);
  m04_couplers_to_m04_couplers_AWVALID(0) <= S_AXI_awvalid(0);
  m04_couplers_to_m04_couplers_BREADY(0) <= S_AXI_bready(0);
  m04_couplers_to_m04_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m04_couplers_to_m04_couplers_BVALID(0) <= M_AXI_bvalid(0);
  m04_couplers_to_m04_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m04_couplers_to_m04_couplers_RREADY(0) <= S_AXI_rready(0);
  m04_couplers_to_m04_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m04_couplers_to_m04_couplers_RVALID(0) <= M_AXI_rvalid(0);
  m04_couplers_to_m04_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m04_couplers_to_m04_couplers_WREADY(0) <= M_AXI_wready(0);
  m04_couplers_to_m04_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m04_couplers_to_m04_couplers_WVALID(0) <= S_AXI_wvalid(0);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m05_couplers_imp_1TE0YS7 is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wvalid : in STD_LOGIC
  );
end m05_couplers_imp_1TE0YS7;

architecture STRUCTURE of m05_couplers_imp_1TE0YS7 is
  signal m05_couplers_to_m05_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m05_couplers_to_m05_couplers_ARREADY : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_ARVALID : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m05_couplers_to_m05_couplers_AWREADY : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_AWVALID : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_BREADY : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m05_couplers_to_m05_couplers_BVALID : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_m05_couplers_RREADY : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m05_couplers_to_m05_couplers_RVALID : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_m05_couplers_WREADY : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(39 downto 0) <= m05_couplers_to_m05_couplers_ARADDR(39 downto 0);
  M_AXI_arvalid <= m05_couplers_to_m05_couplers_ARVALID;
  M_AXI_awaddr(39 downto 0) <= m05_couplers_to_m05_couplers_AWADDR(39 downto 0);
  M_AXI_awvalid <= m05_couplers_to_m05_couplers_AWVALID;
  M_AXI_bready <= m05_couplers_to_m05_couplers_BREADY;
  M_AXI_rready <= m05_couplers_to_m05_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m05_couplers_to_m05_couplers_WDATA(31 downto 0);
  M_AXI_wvalid <= m05_couplers_to_m05_couplers_WVALID;
  S_AXI_arready <= m05_couplers_to_m05_couplers_ARREADY;
  S_AXI_awready <= m05_couplers_to_m05_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m05_couplers_to_m05_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m05_couplers_to_m05_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m05_couplers_to_m05_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m05_couplers_to_m05_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m05_couplers_to_m05_couplers_RVALID;
  S_AXI_wready <= m05_couplers_to_m05_couplers_WREADY;
  m05_couplers_to_m05_couplers_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  m05_couplers_to_m05_couplers_ARREADY <= M_AXI_arready;
  m05_couplers_to_m05_couplers_ARVALID <= S_AXI_arvalid;
  m05_couplers_to_m05_couplers_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  m05_couplers_to_m05_couplers_AWREADY <= M_AXI_awready;
  m05_couplers_to_m05_couplers_AWVALID <= S_AXI_awvalid;
  m05_couplers_to_m05_couplers_BREADY <= S_AXI_bready;
  m05_couplers_to_m05_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m05_couplers_to_m05_couplers_BVALID <= M_AXI_bvalid;
  m05_couplers_to_m05_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m05_couplers_to_m05_couplers_RREADY <= S_AXI_rready;
  m05_couplers_to_m05_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m05_couplers_to_m05_couplers_RVALID <= M_AXI_rvalid;
  m05_couplers_to_m05_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m05_couplers_to_m05_couplers_WREADY <= M_AXI_wready;
  m05_couplers_to_m05_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m06_couplers_imp_145GNP0 is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end m06_couplers_imp_145GNP0;

architecture STRUCTURE of m06_couplers_imp_145GNP0 is
  signal m06_couplers_to_m06_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m06_couplers_to_m06_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_m06_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_m06_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m06_couplers_to_m06_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_m06_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_m06_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_m06_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m06_couplers_to_m06_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_m06_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_m06_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_m06_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m06_couplers_to_m06_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_m06_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_m06_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_m06_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m06_couplers_to_m06_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  M_AXI_araddr(39 downto 0) <= m06_couplers_to_m06_couplers_ARADDR(39 downto 0);
  M_AXI_arvalid(0) <= m06_couplers_to_m06_couplers_ARVALID(0);
  M_AXI_awaddr(39 downto 0) <= m06_couplers_to_m06_couplers_AWADDR(39 downto 0);
  M_AXI_awvalid(0) <= m06_couplers_to_m06_couplers_AWVALID(0);
  M_AXI_bready(0) <= m06_couplers_to_m06_couplers_BREADY(0);
  M_AXI_rready(0) <= m06_couplers_to_m06_couplers_RREADY(0);
  M_AXI_wdata(31 downto 0) <= m06_couplers_to_m06_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m06_couplers_to_m06_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid(0) <= m06_couplers_to_m06_couplers_WVALID(0);
  S_AXI_arready(0) <= m06_couplers_to_m06_couplers_ARREADY(0);
  S_AXI_awready(0) <= m06_couplers_to_m06_couplers_AWREADY(0);
  S_AXI_bresp(1 downto 0) <= m06_couplers_to_m06_couplers_BRESP(1 downto 0);
  S_AXI_bvalid(0) <= m06_couplers_to_m06_couplers_BVALID(0);
  S_AXI_rdata(31 downto 0) <= m06_couplers_to_m06_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m06_couplers_to_m06_couplers_RRESP(1 downto 0);
  S_AXI_rvalid(0) <= m06_couplers_to_m06_couplers_RVALID(0);
  S_AXI_wready(0) <= m06_couplers_to_m06_couplers_WREADY(0);
  m06_couplers_to_m06_couplers_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  m06_couplers_to_m06_couplers_ARREADY(0) <= M_AXI_arready(0);
  m06_couplers_to_m06_couplers_ARVALID(0) <= S_AXI_arvalid(0);
  m06_couplers_to_m06_couplers_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  m06_couplers_to_m06_couplers_AWREADY(0) <= M_AXI_awready(0);
  m06_couplers_to_m06_couplers_AWVALID(0) <= S_AXI_awvalid(0);
  m06_couplers_to_m06_couplers_BREADY(0) <= S_AXI_bready(0);
  m06_couplers_to_m06_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m06_couplers_to_m06_couplers_BVALID(0) <= M_AXI_bvalid(0);
  m06_couplers_to_m06_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m06_couplers_to_m06_couplers_RREADY(0) <= S_AXI_rready(0);
  m06_couplers_to_m06_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m06_couplers_to_m06_couplers_RVALID(0) <= M_AXI_rvalid(0);
  m06_couplers_to_m06_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m06_couplers_to_m06_couplers_WREADY(0) <= M_AXI_wready(0);
  m06_couplers_to_m06_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m06_couplers_to_m06_couplers_WVALID(0) <= S_AXI_wvalid(0);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m07_couplers_imp_4A60RU is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end m07_couplers_imp_4A60RU;

architecture STRUCTURE of m07_couplers_imp_4A60RU is
  signal m07_couplers_to_m07_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m07_couplers_to_m07_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m07_couplers_to_m07_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m07_couplers_to_m07_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_m07_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m07_couplers_to_m07_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_m07_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m07_couplers_to_m07_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  M_AXI_araddr(39 downto 0) <= m07_couplers_to_m07_couplers_ARADDR(39 downto 0);
  M_AXI_arvalid(0) <= m07_couplers_to_m07_couplers_ARVALID(0);
  M_AXI_awaddr(39 downto 0) <= m07_couplers_to_m07_couplers_AWADDR(39 downto 0);
  M_AXI_awvalid(0) <= m07_couplers_to_m07_couplers_AWVALID(0);
  M_AXI_bready(0) <= m07_couplers_to_m07_couplers_BREADY(0);
  M_AXI_rready(0) <= m07_couplers_to_m07_couplers_RREADY(0);
  M_AXI_wdata(31 downto 0) <= m07_couplers_to_m07_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m07_couplers_to_m07_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid(0) <= m07_couplers_to_m07_couplers_WVALID(0);
  S_AXI_arready(0) <= m07_couplers_to_m07_couplers_ARREADY(0);
  S_AXI_awready(0) <= m07_couplers_to_m07_couplers_AWREADY(0);
  S_AXI_bresp(1 downto 0) <= m07_couplers_to_m07_couplers_BRESP(1 downto 0);
  S_AXI_bvalid(0) <= m07_couplers_to_m07_couplers_BVALID(0);
  S_AXI_rdata(31 downto 0) <= m07_couplers_to_m07_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m07_couplers_to_m07_couplers_RRESP(1 downto 0);
  S_AXI_rvalid(0) <= m07_couplers_to_m07_couplers_RVALID(0);
  S_AXI_wready(0) <= m07_couplers_to_m07_couplers_WREADY(0);
  m07_couplers_to_m07_couplers_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  m07_couplers_to_m07_couplers_ARREADY(0) <= M_AXI_arready(0);
  m07_couplers_to_m07_couplers_ARVALID(0) <= S_AXI_arvalid(0);
  m07_couplers_to_m07_couplers_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  m07_couplers_to_m07_couplers_AWREADY(0) <= M_AXI_awready(0);
  m07_couplers_to_m07_couplers_AWVALID(0) <= S_AXI_awvalid(0);
  m07_couplers_to_m07_couplers_BREADY(0) <= S_AXI_bready(0);
  m07_couplers_to_m07_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m07_couplers_to_m07_couplers_BVALID(0) <= M_AXI_bvalid(0);
  m07_couplers_to_m07_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m07_couplers_to_m07_couplers_RREADY(0) <= S_AXI_rready(0);
  m07_couplers_to_m07_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m07_couplers_to_m07_couplers_RVALID(0) <= M_AXI_rvalid(0);
  m07_couplers_to_m07_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m07_couplers_to_m07_couplers_WREADY(0) <= M_AXI_wready(0);
  m07_couplers_to_m07_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m07_couplers_to_m07_couplers_WVALID(0) <= S_AXI_wvalid(0);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m08_couplers_imp_IQ13YC is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end m08_couplers_imp_IQ13YC;

architecture STRUCTURE of m08_couplers_imp_IQ13YC is
  signal m08_couplers_to_m08_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m08_couplers_to_m08_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m08_couplers_to_m08_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m08_couplers_to_m08_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_m08_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m08_couplers_to_m08_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_m08_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m08_couplers_to_m08_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  M_AXI_araddr(39 downto 0) <= m08_couplers_to_m08_couplers_ARADDR(39 downto 0);
  M_AXI_arvalid(0) <= m08_couplers_to_m08_couplers_ARVALID(0);
  M_AXI_awaddr(39 downto 0) <= m08_couplers_to_m08_couplers_AWADDR(39 downto 0);
  M_AXI_awvalid(0) <= m08_couplers_to_m08_couplers_AWVALID(0);
  M_AXI_bready(0) <= m08_couplers_to_m08_couplers_BREADY(0);
  M_AXI_rready(0) <= m08_couplers_to_m08_couplers_RREADY(0);
  M_AXI_wdata(31 downto 0) <= m08_couplers_to_m08_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m08_couplers_to_m08_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid(0) <= m08_couplers_to_m08_couplers_WVALID(0);
  S_AXI_arready(0) <= m08_couplers_to_m08_couplers_ARREADY(0);
  S_AXI_awready(0) <= m08_couplers_to_m08_couplers_AWREADY(0);
  S_AXI_bresp(1 downto 0) <= m08_couplers_to_m08_couplers_BRESP(1 downto 0);
  S_AXI_bvalid(0) <= m08_couplers_to_m08_couplers_BVALID(0);
  S_AXI_rdata(31 downto 0) <= m08_couplers_to_m08_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m08_couplers_to_m08_couplers_RRESP(1 downto 0);
  S_AXI_rvalid(0) <= m08_couplers_to_m08_couplers_RVALID(0);
  S_AXI_wready(0) <= m08_couplers_to_m08_couplers_WREADY(0);
  m08_couplers_to_m08_couplers_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  m08_couplers_to_m08_couplers_ARREADY(0) <= M_AXI_arready(0);
  m08_couplers_to_m08_couplers_ARVALID(0) <= S_AXI_arvalid(0);
  m08_couplers_to_m08_couplers_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  m08_couplers_to_m08_couplers_AWREADY(0) <= M_AXI_awready(0);
  m08_couplers_to_m08_couplers_AWVALID(0) <= S_AXI_awvalid(0);
  m08_couplers_to_m08_couplers_BREADY(0) <= S_AXI_bready(0);
  m08_couplers_to_m08_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m08_couplers_to_m08_couplers_BVALID(0) <= M_AXI_bvalid(0);
  m08_couplers_to_m08_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m08_couplers_to_m08_couplers_RREADY(0) <= S_AXI_rready(0);
  m08_couplers_to_m08_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m08_couplers_to_m08_couplers_RVALID(0) <= M_AXI_rvalid(0);
  m08_couplers_to_m08_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m08_couplers_to_m08_couplers_WREADY(0) <= M_AXI_wready(0);
  m08_couplers_to_m08_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m08_couplers_to_m08_couplers_WVALID(0) <= S_AXI_wvalid(0);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m09_couplers_imp_1P7ROII is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 10 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 10 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m09_couplers_imp_1P7ROII;

architecture STRUCTURE of m09_couplers_imp_1P7ROII is
  component kv260_video_auto_cc_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 10 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 10 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    m_axi_aclk : in STD_LOGIC;
    m_axi_aresetn : in STD_LOGIC;
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC
  );
  end component kv260_video_auto_cc_0;
  signal M_ACLK_1 : STD_LOGIC;
  signal M_ARESETN_1 : STD_LOGIC;
  signal S_ACLK_1 : STD_LOGIC;
  signal S_ARESETN_1 : STD_LOGIC;
  signal auto_cc_to_m09_couplers_ARADDR : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal auto_cc_to_m09_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_cc_to_m09_couplers_ARREADY : STD_LOGIC;
  signal auto_cc_to_m09_couplers_ARVALID : STD_LOGIC;
  signal auto_cc_to_m09_couplers_AWADDR : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal auto_cc_to_m09_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_cc_to_m09_couplers_AWREADY : STD_LOGIC;
  signal auto_cc_to_m09_couplers_AWVALID : STD_LOGIC;
  signal auto_cc_to_m09_couplers_BREADY : STD_LOGIC;
  signal auto_cc_to_m09_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_cc_to_m09_couplers_BVALID : STD_LOGIC;
  signal auto_cc_to_m09_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_cc_to_m09_couplers_RREADY : STD_LOGIC;
  signal auto_cc_to_m09_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_cc_to_m09_couplers_RVALID : STD_LOGIC;
  signal auto_cc_to_m09_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_cc_to_m09_couplers_WREADY : STD_LOGIC;
  signal auto_cc_to_m09_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_cc_to_m09_couplers_WVALID : STD_LOGIC;
  signal m09_couplers_to_auto_cc_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m09_couplers_to_auto_cc_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m09_couplers_to_auto_cc_ARREADY : STD_LOGIC;
  signal m09_couplers_to_auto_cc_ARVALID : STD_LOGIC;
  signal m09_couplers_to_auto_cc_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m09_couplers_to_auto_cc_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m09_couplers_to_auto_cc_AWREADY : STD_LOGIC;
  signal m09_couplers_to_auto_cc_AWVALID : STD_LOGIC;
  signal m09_couplers_to_auto_cc_BREADY : STD_LOGIC;
  signal m09_couplers_to_auto_cc_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m09_couplers_to_auto_cc_BVALID : STD_LOGIC;
  signal m09_couplers_to_auto_cc_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_auto_cc_RREADY : STD_LOGIC;
  signal m09_couplers_to_auto_cc_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m09_couplers_to_auto_cc_RVALID : STD_LOGIC;
  signal m09_couplers_to_auto_cc_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_auto_cc_WREADY : STD_LOGIC;
  signal m09_couplers_to_auto_cc_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m09_couplers_to_auto_cc_WVALID : STD_LOGIC;
begin
  M_ACLK_1 <= M_ACLK;
  M_ARESETN_1 <= M_ARESETN;
  M_AXI_araddr(10 downto 0) <= auto_cc_to_m09_couplers_ARADDR(10 downto 0);
  M_AXI_arprot(2 downto 0) <= auto_cc_to_m09_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= auto_cc_to_m09_couplers_ARVALID;
  M_AXI_awaddr(10 downto 0) <= auto_cc_to_m09_couplers_AWADDR(10 downto 0);
  M_AXI_awprot(2 downto 0) <= auto_cc_to_m09_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= auto_cc_to_m09_couplers_AWVALID;
  M_AXI_bready <= auto_cc_to_m09_couplers_BREADY;
  M_AXI_rready <= auto_cc_to_m09_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= auto_cc_to_m09_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= auto_cc_to_m09_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= auto_cc_to_m09_couplers_WVALID;
  S_ACLK_1 <= S_ACLK;
  S_ARESETN_1 <= S_ARESETN;
  S_AXI_arready <= m09_couplers_to_auto_cc_ARREADY;
  S_AXI_awready <= m09_couplers_to_auto_cc_AWREADY;
  S_AXI_bresp(1 downto 0) <= m09_couplers_to_auto_cc_BRESP(1 downto 0);
  S_AXI_bvalid <= m09_couplers_to_auto_cc_BVALID;
  S_AXI_rdata(31 downto 0) <= m09_couplers_to_auto_cc_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m09_couplers_to_auto_cc_RRESP(1 downto 0);
  S_AXI_rvalid <= m09_couplers_to_auto_cc_RVALID;
  S_AXI_wready <= m09_couplers_to_auto_cc_WREADY;
  auto_cc_to_m09_couplers_ARREADY <= M_AXI_arready;
  auto_cc_to_m09_couplers_AWREADY <= M_AXI_awready;
  auto_cc_to_m09_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  auto_cc_to_m09_couplers_BVALID <= M_AXI_bvalid;
  auto_cc_to_m09_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  auto_cc_to_m09_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  auto_cc_to_m09_couplers_RVALID <= M_AXI_rvalid;
  auto_cc_to_m09_couplers_WREADY <= M_AXI_wready;
  m09_couplers_to_auto_cc_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  m09_couplers_to_auto_cc_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m09_couplers_to_auto_cc_ARVALID <= S_AXI_arvalid;
  m09_couplers_to_auto_cc_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  m09_couplers_to_auto_cc_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m09_couplers_to_auto_cc_AWVALID <= S_AXI_awvalid;
  m09_couplers_to_auto_cc_BREADY <= S_AXI_bready;
  m09_couplers_to_auto_cc_RREADY <= S_AXI_rready;
  m09_couplers_to_auto_cc_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m09_couplers_to_auto_cc_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m09_couplers_to_auto_cc_WVALID <= S_AXI_wvalid;
auto_cc: component kv260_video_auto_cc_0
     port map (
      m_axi_aclk => M_ACLK_1,
      m_axi_araddr(10 downto 0) => auto_cc_to_m09_couplers_ARADDR(10 downto 0),
      m_axi_aresetn => M_ARESETN_1,
      m_axi_arprot(2 downto 0) => auto_cc_to_m09_couplers_ARPROT(2 downto 0),
      m_axi_arready => auto_cc_to_m09_couplers_ARREADY,
      m_axi_arvalid => auto_cc_to_m09_couplers_ARVALID,
      m_axi_awaddr(10 downto 0) => auto_cc_to_m09_couplers_AWADDR(10 downto 0),
      m_axi_awprot(2 downto 0) => auto_cc_to_m09_couplers_AWPROT(2 downto 0),
      m_axi_awready => auto_cc_to_m09_couplers_AWREADY,
      m_axi_awvalid => auto_cc_to_m09_couplers_AWVALID,
      m_axi_bready => auto_cc_to_m09_couplers_BREADY,
      m_axi_bresp(1 downto 0) => auto_cc_to_m09_couplers_BRESP(1 downto 0),
      m_axi_bvalid => auto_cc_to_m09_couplers_BVALID,
      m_axi_rdata(31 downto 0) => auto_cc_to_m09_couplers_RDATA(31 downto 0),
      m_axi_rready => auto_cc_to_m09_couplers_RREADY,
      m_axi_rresp(1 downto 0) => auto_cc_to_m09_couplers_RRESP(1 downto 0),
      m_axi_rvalid => auto_cc_to_m09_couplers_RVALID,
      m_axi_wdata(31 downto 0) => auto_cc_to_m09_couplers_WDATA(31 downto 0),
      m_axi_wready => auto_cc_to_m09_couplers_WREADY,
      m_axi_wstrb(3 downto 0) => auto_cc_to_m09_couplers_WSTRB(3 downto 0),
      m_axi_wvalid => auto_cc_to_m09_couplers_WVALID,
      s_axi_aclk => S_ACLK_1,
      s_axi_araddr(10 downto 0) => m09_couplers_to_auto_cc_ARADDR(10 downto 0),
      s_axi_aresetn => S_ARESETN_1,
      s_axi_arprot(2 downto 0) => m09_couplers_to_auto_cc_ARPROT(2 downto 0),
      s_axi_arready => m09_couplers_to_auto_cc_ARREADY,
      s_axi_arvalid => m09_couplers_to_auto_cc_ARVALID,
      s_axi_awaddr(10 downto 0) => m09_couplers_to_auto_cc_AWADDR(10 downto 0),
      s_axi_awprot(2 downto 0) => m09_couplers_to_auto_cc_AWPROT(2 downto 0),
      s_axi_awready => m09_couplers_to_auto_cc_AWREADY,
      s_axi_awvalid => m09_couplers_to_auto_cc_AWVALID,
      s_axi_bready => m09_couplers_to_auto_cc_BREADY,
      s_axi_bresp(1 downto 0) => m09_couplers_to_auto_cc_BRESP(1 downto 0),
      s_axi_bvalid => m09_couplers_to_auto_cc_BVALID,
      s_axi_rdata(31 downto 0) => m09_couplers_to_auto_cc_RDATA(31 downto 0),
      s_axi_rready => m09_couplers_to_auto_cc_RREADY,
      s_axi_rresp(1 downto 0) => m09_couplers_to_auto_cc_RRESP(1 downto 0),
      s_axi_rvalid => m09_couplers_to_auto_cc_RVALID,
      s_axi_wdata(31 downto 0) => m09_couplers_to_auto_cc_WDATA(31 downto 0),
      s_axi_wready => m09_couplers_to_auto_cc_WREADY,
      s_axi_wstrb(3 downto 0) => m09_couplers_to_auto_cc_WSTRB(3 downto 0),
      s_axi_wvalid => m09_couplers_to_auto_cc_WVALID
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity s00_couplers_imp_12FSI76 is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_arid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_arlock : in STD_LOGIC;
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_awid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_awlock : in STD_LOGIC;
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_rid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_rlast : out STD_LOGIC;
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_wlast : in STD_LOGIC;
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end s00_couplers_imp_12FSI76;

architecture STRUCTURE of s00_couplers_imp_12FSI76 is
  component kv260_video_auto_ds_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awregion : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_arid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arregion : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC;
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    m_axi_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wlast : out STD_LOGIC;
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    m_axi_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rlast : in STD_LOGIC;
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC
  );
  end component kv260_video_auto_ds_0;
  component kv260_video_auto_pc_0 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awregion : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arregion : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC;
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC
  );
  end component kv260_video_auto_pc_0;
  signal S_ACLK_1 : STD_LOGIC;
  signal S_ARESETN_1 : STD_LOGIC;
  signal auto_ds_to_auto_pc_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal auto_ds_to_auto_pc_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_ds_to_auto_pc_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal auto_ds_to_auto_pc_ARLOCK : STD_LOGIC_VECTOR ( 0 to 0 );
  signal auto_ds_to_auto_pc_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_ds_to_auto_pc_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_ARREADY : STD_LOGIC;
  signal auto_ds_to_auto_pc_ARREGION : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_ds_to_auto_pc_ARVALID : STD_LOGIC;
  signal auto_ds_to_auto_pc_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal auto_ds_to_auto_pc_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_ds_to_auto_pc_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal auto_ds_to_auto_pc_AWLOCK : STD_LOGIC_VECTOR ( 0 to 0 );
  signal auto_ds_to_auto_pc_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_ds_to_auto_pc_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_AWREADY : STD_LOGIC;
  signal auto_ds_to_auto_pc_AWREGION : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_ds_to_auto_pc_AWVALID : STD_LOGIC;
  signal auto_ds_to_auto_pc_BREADY : STD_LOGIC;
  signal auto_ds_to_auto_pc_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_ds_to_auto_pc_BVALID : STD_LOGIC;
  signal auto_ds_to_auto_pc_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_ds_to_auto_pc_RLAST : STD_LOGIC;
  signal auto_ds_to_auto_pc_RREADY : STD_LOGIC;
  signal auto_ds_to_auto_pc_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_ds_to_auto_pc_RVALID : STD_LOGIC;
  signal auto_ds_to_auto_pc_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_ds_to_auto_pc_WLAST : STD_LOGIC;
  signal auto_ds_to_auto_pc_WREADY : STD_LOGIC;
  signal auto_ds_to_auto_pc_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_WVALID : STD_LOGIC;
  signal auto_pc_to_s00_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal auto_pc_to_s00_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_pc_to_s00_couplers_ARREADY : STD_LOGIC;
  signal auto_pc_to_s00_couplers_ARVALID : STD_LOGIC;
  signal auto_pc_to_s00_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal auto_pc_to_s00_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_pc_to_s00_couplers_AWREADY : STD_LOGIC;
  signal auto_pc_to_s00_couplers_AWVALID : STD_LOGIC;
  signal auto_pc_to_s00_couplers_BREADY : STD_LOGIC;
  signal auto_pc_to_s00_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_pc_to_s00_couplers_BVALID : STD_LOGIC;
  signal auto_pc_to_s00_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_pc_to_s00_couplers_RREADY : STD_LOGIC;
  signal auto_pc_to_s00_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_pc_to_s00_couplers_RVALID : STD_LOGIC;
  signal auto_pc_to_s00_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_pc_to_s00_couplers_WREADY : STD_LOGIC;
  signal auto_pc_to_s00_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_pc_to_s00_couplers_WVALID : STD_LOGIC;
  signal s00_couplers_to_auto_ds_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal s00_couplers_to_auto_ds_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_auto_ds_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_ds_ARID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s00_couplers_to_auto_ds_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal s00_couplers_to_auto_ds_ARLOCK : STD_LOGIC;
  signal s00_couplers_to_auto_ds_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_auto_ds_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_ds_ARREADY : STD_LOGIC;
  signal s00_couplers_to_auto_ds_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_auto_ds_ARVALID : STD_LOGIC;
  signal s00_couplers_to_auto_ds_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal s00_couplers_to_auto_ds_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_auto_ds_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_ds_AWID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s00_couplers_to_auto_ds_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal s00_couplers_to_auto_ds_AWLOCK : STD_LOGIC;
  signal s00_couplers_to_auto_ds_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_auto_ds_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_ds_AWREADY : STD_LOGIC;
  signal s00_couplers_to_auto_ds_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_auto_ds_AWVALID : STD_LOGIC;
  signal s00_couplers_to_auto_ds_BID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s00_couplers_to_auto_ds_BREADY : STD_LOGIC;
  signal s00_couplers_to_auto_ds_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_auto_ds_BVALID : STD_LOGIC;
  signal s00_couplers_to_auto_ds_RDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal s00_couplers_to_auto_ds_RID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s00_couplers_to_auto_ds_RLAST : STD_LOGIC;
  signal s00_couplers_to_auto_ds_RREADY : STD_LOGIC;
  signal s00_couplers_to_auto_ds_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_auto_ds_RVALID : STD_LOGIC;
  signal s00_couplers_to_auto_ds_WDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal s00_couplers_to_auto_ds_WLAST : STD_LOGIC;
  signal s00_couplers_to_auto_ds_WREADY : STD_LOGIC;
  signal s00_couplers_to_auto_ds_WSTRB : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s00_couplers_to_auto_ds_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(39 downto 0) <= auto_pc_to_s00_couplers_ARADDR(39 downto 0);
  M_AXI_arprot(2 downto 0) <= auto_pc_to_s00_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= auto_pc_to_s00_couplers_ARVALID;
  M_AXI_awaddr(39 downto 0) <= auto_pc_to_s00_couplers_AWADDR(39 downto 0);
  M_AXI_awprot(2 downto 0) <= auto_pc_to_s00_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= auto_pc_to_s00_couplers_AWVALID;
  M_AXI_bready <= auto_pc_to_s00_couplers_BREADY;
  M_AXI_rready <= auto_pc_to_s00_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= auto_pc_to_s00_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= auto_pc_to_s00_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= auto_pc_to_s00_couplers_WVALID;
  S_ACLK_1 <= S_ACLK;
  S_ARESETN_1 <= S_ARESETN;
  S_AXI_arready <= s00_couplers_to_auto_ds_ARREADY;
  S_AXI_awready <= s00_couplers_to_auto_ds_AWREADY;
  S_AXI_bid(15 downto 0) <= s00_couplers_to_auto_ds_BID(15 downto 0);
  S_AXI_bresp(1 downto 0) <= s00_couplers_to_auto_ds_BRESP(1 downto 0);
  S_AXI_bvalid <= s00_couplers_to_auto_ds_BVALID;
  S_AXI_rdata(127 downto 0) <= s00_couplers_to_auto_ds_RDATA(127 downto 0);
  S_AXI_rid(15 downto 0) <= s00_couplers_to_auto_ds_RID(15 downto 0);
  S_AXI_rlast <= s00_couplers_to_auto_ds_RLAST;
  S_AXI_rresp(1 downto 0) <= s00_couplers_to_auto_ds_RRESP(1 downto 0);
  S_AXI_rvalid <= s00_couplers_to_auto_ds_RVALID;
  S_AXI_wready <= s00_couplers_to_auto_ds_WREADY;
  auto_pc_to_s00_couplers_ARREADY <= M_AXI_arready;
  auto_pc_to_s00_couplers_AWREADY <= M_AXI_awready;
  auto_pc_to_s00_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  auto_pc_to_s00_couplers_BVALID <= M_AXI_bvalid;
  auto_pc_to_s00_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  auto_pc_to_s00_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  auto_pc_to_s00_couplers_RVALID <= M_AXI_rvalid;
  auto_pc_to_s00_couplers_WREADY <= M_AXI_wready;
  s00_couplers_to_auto_ds_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  s00_couplers_to_auto_ds_ARBURST(1 downto 0) <= S_AXI_arburst(1 downto 0);
  s00_couplers_to_auto_ds_ARCACHE(3 downto 0) <= S_AXI_arcache(3 downto 0);
  s00_couplers_to_auto_ds_ARID(15 downto 0) <= S_AXI_arid(15 downto 0);
  s00_couplers_to_auto_ds_ARLEN(7 downto 0) <= S_AXI_arlen(7 downto 0);
  s00_couplers_to_auto_ds_ARLOCK <= S_AXI_arlock;
  s00_couplers_to_auto_ds_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  s00_couplers_to_auto_ds_ARQOS(3 downto 0) <= S_AXI_arqos(3 downto 0);
  s00_couplers_to_auto_ds_ARSIZE(2 downto 0) <= S_AXI_arsize(2 downto 0);
  s00_couplers_to_auto_ds_ARVALID <= S_AXI_arvalid;
  s00_couplers_to_auto_ds_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  s00_couplers_to_auto_ds_AWBURST(1 downto 0) <= S_AXI_awburst(1 downto 0);
  s00_couplers_to_auto_ds_AWCACHE(3 downto 0) <= S_AXI_awcache(3 downto 0);
  s00_couplers_to_auto_ds_AWID(15 downto 0) <= S_AXI_awid(15 downto 0);
  s00_couplers_to_auto_ds_AWLEN(7 downto 0) <= S_AXI_awlen(7 downto 0);
  s00_couplers_to_auto_ds_AWLOCK <= S_AXI_awlock;
  s00_couplers_to_auto_ds_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  s00_couplers_to_auto_ds_AWQOS(3 downto 0) <= S_AXI_awqos(3 downto 0);
  s00_couplers_to_auto_ds_AWSIZE(2 downto 0) <= S_AXI_awsize(2 downto 0);
  s00_couplers_to_auto_ds_AWVALID <= S_AXI_awvalid;
  s00_couplers_to_auto_ds_BREADY <= S_AXI_bready;
  s00_couplers_to_auto_ds_RREADY <= S_AXI_rready;
  s00_couplers_to_auto_ds_WDATA(127 downto 0) <= S_AXI_wdata(127 downto 0);
  s00_couplers_to_auto_ds_WLAST <= S_AXI_wlast;
  s00_couplers_to_auto_ds_WSTRB(15 downto 0) <= S_AXI_wstrb(15 downto 0);
  s00_couplers_to_auto_ds_WVALID <= S_AXI_wvalid;
auto_ds: component kv260_video_auto_ds_0
     port map (
      m_axi_araddr(39 downto 0) => auto_ds_to_auto_pc_ARADDR(39 downto 0),
      m_axi_arburst(1 downto 0) => auto_ds_to_auto_pc_ARBURST(1 downto 0),
      m_axi_arcache(3 downto 0) => auto_ds_to_auto_pc_ARCACHE(3 downto 0),
      m_axi_arlen(7 downto 0) => auto_ds_to_auto_pc_ARLEN(7 downto 0),
      m_axi_arlock(0) => auto_ds_to_auto_pc_ARLOCK(0),
      m_axi_arprot(2 downto 0) => auto_ds_to_auto_pc_ARPROT(2 downto 0),
      m_axi_arqos(3 downto 0) => auto_ds_to_auto_pc_ARQOS(3 downto 0),
      m_axi_arready => auto_ds_to_auto_pc_ARREADY,
      m_axi_arregion(3 downto 0) => auto_ds_to_auto_pc_ARREGION(3 downto 0),
      m_axi_arsize(2 downto 0) => auto_ds_to_auto_pc_ARSIZE(2 downto 0),
      m_axi_arvalid => auto_ds_to_auto_pc_ARVALID,
      m_axi_awaddr(39 downto 0) => auto_ds_to_auto_pc_AWADDR(39 downto 0),
      m_axi_awburst(1 downto 0) => auto_ds_to_auto_pc_AWBURST(1 downto 0),
      m_axi_awcache(3 downto 0) => auto_ds_to_auto_pc_AWCACHE(3 downto 0),
      m_axi_awlen(7 downto 0) => auto_ds_to_auto_pc_AWLEN(7 downto 0),
      m_axi_awlock(0) => auto_ds_to_auto_pc_AWLOCK(0),
      m_axi_awprot(2 downto 0) => auto_ds_to_auto_pc_AWPROT(2 downto 0),
      m_axi_awqos(3 downto 0) => auto_ds_to_auto_pc_AWQOS(3 downto 0),
      m_axi_awready => auto_ds_to_auto_pc_AWREADY,
      m_axi_awregion(3 downto 0) => auto_ds_to_auto_pc_AWREGION(3 downto 0),
      m_axi_awsize(2 downto 0) => auto_ds_to_auto_pc_AWSIZE(2 downto 0),
      m_axi_awvalid => auto_ds_to_auto_pc_AWVALID,
      m_axi_bready => auto_ds_to_auto_pc_BREADY,
      m_axi_bresp(1 downto 0) => auto_ds_to_auto_pc_BRESP(1 downto 0),
      m_axi_bvalid => auto_ds_to_auto_pc_BVALID,
      m_axi_rdata(31 downto 0) => auto_ds_to_auto_pc_RDATA(31 downto 0),
      m_axi_rlast => auto_ds_to_auto_pc_RLAST,
      m_axi_rready => auto_ds_to_auto_pc_RREADY,
      m_axi_rresp(1 downto 0) => auto_ds_to_auto_pc_RRESP(1 downto 0),
      m_axi_rvalid => auto_ds_to_auto_pc_RVALID,
      m_axi_wdata(31 downto 0) => auto_ds_to_auto_pc_WDATA(31 downto 0),
      m_axi_wlast => auto_ds_to_auto_pc_WLAST,
      m_axi_wready => auto_ds_to_auto_pc_WREADY,
      m_axi_wstrb(3 downto 0) => auto_ds_to_auto_pc_WSTRB(3 downto 0),
      m_axi_wvalid => auto_ds_to_auto_pc_WVALID,
      s_axi_aclk => S_ACLK_1,
      s_axi_araddr(39 downto 0) => s00_couplers_to_auto_ds_ARADDR(39 downto 0),
      s_axi_arburst(1 downto 0) => s00_couplers_to_auto_ds_ARBURST(1 downto 0),
      s_axi_arcache(3 downto 0) => s00_couplers_to_auto_ds_ARCACHE(3 downto 0),
      s_axi_aresetn => S_ARESETN_1,
      s_axi_arid(15 downto 0) => s00_couplers_to_auto_ds_ARID(15 downto 0),
      s_axi_arlen(7 downto 0) => s00_couplers_to_auto_ds_ARLEN(7 downto 0),
      s_axi_arlock(0) => s00_couplers_to_auto_ds_ARLOCK,
      s_axi_arprot(2 downto 0) => s00_couplers_to_auto_ds_ARPROT(2 downto 0),
      s_axi_arqos(3 downto 0) => s00_couplers_to_auto_ds_ARQOS(3 downto 0),
      s_axi_arready => s00_couplers_to_auto_ds_ARREADY,
      s_axi_arregion(3 downto 0) => B"0000",
      s_axi_arsize(2 downto 0) => s00_couplers_to_auto_ds_ARSIZE(2 downto 0),
      s_axi_arvalid => s00_couplers_to_auto_ds_ARVALID,
      s_axi_awaddr(39 downto 0) => s00_couplers_to_auto_ds_AWADDR(39 downto 0),
      s_axi_awburst(1 downto 0) => s00_couplers_to_auto_ds_AWBURST(1 downto 0),
      s_axi_awcache(3 downto 0) => s00_couplers_to_auto_ds_AWCACHE(3 downto 0),
      s_axi_awid(15 downto 0) => s00_couplers_to_auto_ds_AWID(15 downto 0),
      s_axi_awlen(7 downto 0) => s00_couplers_to_auto_ds_AWLEN(7 downto 0),
      s_axi_awlock(0) => s00_couplers_to_auto_ds_AWLOCK,
      s_axi_awprot(2 downto 0) => s00_couplers_to_auto_ds_AWPROT(2 downto 0),
      s_axi_awqos(3 downto 0) => s00_couplers_to_auto_ds_AWQOS(3 downto 0),
      s_axi_awready => s00_couplers_to_auto_ds_AWREADY,
      s_axi_awregion(3 downto 0) => B"0000",
      s_axi_awsize(2 downto 0) => s00_couplers_to_auto_ds_AWSIZE(2 downto 0),
      s_axi_awvalid => s00_couplers_to_auto_ds_AWVALID,
      s_axi_bid(15 downto 0) => s00_couplers_to_auto_ds_BID(15 downto 0),
      s_axi_bready => s00_couplers_to_auto_ds_BREADY,
      s_axi_bresp(1 downto 0) => s00_couplers_to_auto_ds_BRESP(1 downto 0),
      s_axi_bvalid => s00_couplers_to_auto_ds_BVALID,
      s_axi_rdata(127 downto 0) => s00_couplers_to_auto_ds_RDATA(127 downto 0),
      s_axi_rid(15 downto 0) => s00_couplers_to_auto_ds_RID(15 downto 0),
      s_axi_rlast => s00_couplers_to_auto_ds_RLAST,
      s_axi_rready => s00_couplers_to_auto_ds_RREADY,
      s_axi_rresp(1 downto 0) => s00_couplers_to_auto_ds_RRESP(1 downto 0),
      s_axi_rvalid => s00_couplers_to_auto_ds_RVALID,
      s_axi_wdata(127 downto 0) => s00_couplers_to_auto_ds_WDATA(127 downto 0),
      s_axi_wlast => s00_couplers_to_auto_ds_WLAST,
      s_axi_wready => s00_couplers_to_auto_ds_WREADY,
      s_axi_wstrb(15 downto 0) => s00_couplers_to_auto_ds_WSTRB(15 downto 0),
      s_axi_wvalid => s00_couplers_to_auto_ds_WVALID
    );
auto_pc: component kv260_video_auto_pc_0
     port map (
      aclk => S_ACLK_1,
      aresetn => S_ARESETN_1,
      m_axi_araddr(39 downto 0) => auto_pc_to_s00_couplers_ARADDR(39 downto 0),
      m_axi_arprot(2 downto 0) => auto_pc_to_s00_couplers_ARPROT(2 downto 0),
      m_axi_arready => auto_pc_to_s00_couplers_ARREADY,
      m_axi_arvalid => auto_pc_to_s00_couplers_ARVALID,
      m_axi_awaddr(39 downto 0) => auto_pc_to_s00_couplers_AWADDR(39 downto 0),
      m_axi_awprot(2 downto 0) => auto_pc_to_s00_couplers_AWPROT(2 downto 0),
      m_axi_awready => auto_pc_to_s00_couplers_AWREADY,
      m_axi_awvalid => auto_pc_to_s00_couplers_AWVALID,
      m_axi_bready => auto_pc_to_s00_couplers_BREADY,
      m_axi_bresp(1 downto 0) => auto_pc_to_s00_couplers_BRESP(1 downto 0),
      m_axi_bvalid => auto_pc_to_s00_couplers_BVALID,
      m_axi_rdata(31 downto 0) => auto_pc_to_s00_couplers_RDATA(31 downto 0),
      m_axi_rready => auto_pc_to_s00_couplers_RREADY,
      m_axi_rresp(1 downto 0) => auto_pc_to_s00_couplers_RRESP(1 downto 0),
      m_axi_rvalid => auto_pc_to_s00_couplers_RVALID,
      m_axi_wdata(31 downto 0) => auto_pc_to_s00_couplers_WDATA(31 downto 0),
      m_axi_wready => auto_pc_to_s00_couplers_WREADY,
      m_axi_wstrb(3 downto 0) => auto_pc_to_s00_couplers_WSTRB(3 downto 0),
      m_axi_wvalid => auto_pc_to_s00_couplers_WVALID,
      s_axi_araddr(39 downto 0) => auto_ds_to_auto_pc_ARADDR(39 downto 0),
      s_axi_arburst(1 downto 0) => auto_ds_to_auto_pc_ARBURST(1 downto 0),
      s_axi_arcache(3 downto 0) => auto_ds_to_auto_pc_ARCACHE(3 downto 0),
      s_axi_arlen(7 downto 0) => auto_ds_to_auto_pc_ARLEN(7 downto 0),
      s_axi_arlock(0) => auto_ds_to_auto_pc_ARLOCK(0),
      s_axi_arprot(2 downto 0) => auto_ds_to_auto_pc_ARPROT(2 downto 0),
      s_axi_arqos(3 downto 0) => auto_ds_to_auto_pc_ARQOS(3 downto 0),
      s_axi_arready => auto_ds_to_auto_pc_ARREADY,
      s_axi_arregion(3 downto 0) => auto_ds_to_auto_pc_ARREGION(3 downto 0),
      s_axi_arsize(2 downto 0) => auto_ds_to_auto_pc_ARSIZE(2 downto 0),
      s_axi_arvalid => auto_ds_to_auto_pc_ARVALID,
      s_axi_awaddr(39 downto 0) => auto_ds_to_auto_pc_AWADDR(39 downto 0),
      s_axi_awburst(1 downto 0) => auto_ds_to_auto_pc_AWBURST(1 downto 0),
      s_axi_awcache(3 downto 0) => auto_ds_to_auto_pc_AWCACHE(3 downto 0),
      s_axi_awlen(7 downto 0) => auto_ds_to_auto_pc_AWLEN(7 downto 0),
      s_axi_awlock(0) => auto_ds_to_auto_pc_AWLOCK(0),
      s_axi_awprot(2 downto 0) => auto_ds_to_auto_pc_AWPROT(2 downto 0),
      s_axi_awqos(3 downto 0) => auto_ds_to_auto_pc_AWQOS(3 downto 0),
      s_axi_awready => auto_ds_to_auto_pc_AWREADY,
      s_axi_awregion(3 downto 0) => auto_ds_to_auto_pc_AWREGION(3 downto 0),
      s_axi_awsize(2 downto 0) => auto_ds_to_auto_pc_AWSIZE(2 downto 0),
      s_axi_awvalid => auto_ds_to_auto_pc_AWVALID,
      s_axi_bready => auto_ds_to_auto_pc_BREADY,
      s_axi_bresp(1 downto 0) => auto_ds_to_auto_pc_BRESP(1 downto 0),
      s_axi_bvalid => auto_ds_to_auto_pc_BVALID,
      s_axi_rdata(31 downto 0) => auto_ds_to_auto_pc_RDATA(31 downto 0),
      s_axi_rlast => auto_ds_to_auto_pc_RLAST,
      s_axi_rready => auto_ds_to_auto_pc_RREADY,
      s_axi_rresp(1 downto 0) => auto_ds_to_auto_pc_RRESP(1 downto 0),
      s_axi_rvalid => auto_ds_to_auto_pc_RVALID,
      s_axi_wdata(31 downto 0) => auto_ds_to_auto_pc_WDATA(31 downto 0),
      s_axi_wlast => auto_ds_to_auto_pc_WLAST,
      s_axi_wready => auto_ds_to_auto_pc_WREADY,
      s_axi_wstrb(3 downto 0) => auto_ds_to_auto_pc_WSTRB(3 downto 0),
      s_axi_wvalid => auto_ds_to_auto_pc_WVALID
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity s01_couplers_imp_5X0UYK is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_arid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_arlock : in STD_LOGIC;
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S_AXI_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_awid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_awlock : in STD_LOGIC;
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_rid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_rlast : out STD_LOGIC;
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_wlast : in STD_LOGIC;
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end s01_couplers_imp_5X0UYK;

architecture STRUCTURE of s01_couplers_imp_5X0UYK is
  component kv260_video_auto_ds_1 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awregion : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_arid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arregion : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC;
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    m_axi_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wlast : out STD_LOGIC;
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    m_axi_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rlast : in STD_LOGIC;
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC
  );
  end component kv260_video_auto_ds_1;
  component kv260_video_auto_pc_1 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awregion : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arregion : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC;
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC
  );
  end component kv260_video_auto_pc_1;
  signal S_ACLK_1 : STD_LOGIC;
  signal S_ARESETN_1 : STD_LOGIC;
  signal auto_ds_to_auto_pc_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal auto_ds_to_auto_pc_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_ds_to_auto_pc_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal auto_ds_to_auto_pc_ARLOCK : STD_LOGIC_VECTOR ( 0 to 0 );
  signal auto_ds_to_auto_pc_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_ds_to_auto_pc_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_ARREADY : STD_LOGIC;
  signal auto_ds_to_auto_pc_ARREGION : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_ds_to_auto_pc_ARVALID : STD_LOGIC;
  signal auto_ds_to_auto_pc_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal auto_ds_to_auto_pc_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_ds_to_auto_pc_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal auto_ds_to_auto_pc_AWLOCK : STD_LOGIC_VECTOR ( 0 to 0 );
  signal auto_ds_to_auto_pc_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_ds_to_auto_pc_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_AWREADY : STD_LOGIC;
  signal auto_ds_to_auto_pc_AWREGION : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_ds_to_auto_pc_AWVALID : STD_LOGIC;
  signal auto_ds_to_auto_pc_BREADY : STD_LOGIC;
  signal auto_ds_to_auto_pc_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_ds_to_auto_pc_BVALID : STD_LOGIC;
  signal auto_ds_to_auto_pc_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_ds_to_auto_pc_RLAST : STD_LOGIC;
  signal auto_ds_to_auto_pc_RREADY : STD_LOGIC;
  signal auto_ds_to_auto_pc_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_ds_to_auto_pc_RVALID : STD_LOGIC;
  signal auto_ds_to_auto_pc_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_ds_to_auto_pc_WLAST : STD_LOGIC;
  signal auto_ds_to_auto_pc_WREADY : STD_LOGIC;
  signal auto_ds_to_auto_pc_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_ds_to_auto_pc_WVALID : STD_LOGIC;
  signal auto_pc_to_s01_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal auto_pc_to_s01_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_pc_to_s01_couplers_ARREADY : STD_LOGIC;
  signal auto_pc_to_s01_couplers_ARVALID : STD_LOGIC;
  signal auto_pc_to_s01_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal auto_pc_to_s01_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_pc_to_s01_couplers_AWREADY : STD_LOGIC;
  signal auto_pc_to_s01_couplers_AWVALID : STD_LOGIC;
  signal auto_pc_to_s01_couplers_BREADY : STD_LOGIC;
  signal auto_pc_to_s01_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_pc_to_s01_couplers_BVALID : STD_LOGIC;
  signal auto_pc_to_s01_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_pc_to_s01_couplers_RREADY : STD_LOGIC;
  signal auto_pc_to_s01_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_pc_to_s01_couplers_RVALID : STD_LOGIC;
  signal auto_pc_to_s01_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_pc_to_s01_couplers_WREADY : STD_LOGIC;
  signal auto_pc_to_s01_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_pc_to_s01_couplers_WVALID : STD_LOGIC;
  signal s01_couplers_to_auto_ds_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal s01_couplers_to_auto_ds_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s01_couplers_to_auto_ds_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s01_couplers_to_auto_ds_ARID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s01_couplers_to_auto_ds_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal s01_couplers_to_auto_ds_ARLOCK : STD_LOGIC;
  signal s01_couplers_to_auto_ds_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s01_couplers_to_auto_ds_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s01_couplers_to_auto_ds_ARREADY : STD_LOGIC;
  signal s01_couplers_to_auto_ds_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s01_couplers_to_auto_ds_ARVALID : STD_LOGIC;
  signal s01_couplers_to_auto_ds_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal s01_couplers_to_auto_ds_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s01_couplers_to_auto_ds_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s01_couplers_to_auto_ds_AWID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s01_couplers_to_auto_ds_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal s01_couplers_to_auto_ds_AWLOCK : STD_LOGIC;
  signal s01_couplers_to_auto_ds_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s01_couplers_to_auto_ds_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s01_couplers_to_auto_ds_AWREADY : STD_LOGIC;
  signal s01_couplers_to_auto_ds_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s01_couplers_to_auto_ds_AWVALID : STD_LOGIC;
  signal s01_couplers_to_auto_ds_BID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s01_couplers_to_auto_ds_BREADY : STD_LOGIC;
  signal s01_couplers_to_auto_ds_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s01_couplers_to_auto_ds_BVALID : STD_LOGIC;
  signal s01_couplers_to_auto_ds_RDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal s01_couplers_to_auto_ds_RID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s01_couplers_to_auto_ds_RLAST : STD_LOGIC;
  signal s01_couplers_to_auto_ds_RREADY : STD_LOGIC;
  signal s01_couplers_to_auto_ds_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s01_couplers_to_auto_ds_RVALID : STD_LOGIC;
  signal s01_couplers_to_auto_ds_WDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal s01_couplers_to_auto_ds_WLAST : STD_LOGIC;
  signal s01_couplers_to_auto_ds_WREADY : STD_LOGIC;
  signal s01_couplers_to_auto_ds_WSTRB : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s01_couplers_to_auto_ds_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(39 downto 0) <= auto_pc_to_s01_couplers_ARADDR(39 downto 0);
  M_AXI_arprot(2 downto 0) <= auto_pc_to_s01_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= auto_pc_to_s01_couplers_ARVALID;
  M_AXI_awaddr(39 downto 0) <= auto_pc_to_s01_couplers_AWADDR(39 downto 0);
  M_AXI_awprot(2 downto 0) <= auto_pc_to_s01_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= auto_pc_to_s01_couplers_AWVALID;
  M_AXI_bready <= auto_pc_to_s01_couplers_BREADY;
  M_AXI_rready <= auto_pc_to_s01_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= auto_pc_to_s01_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= auto_pc_to_s01_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= auto_pc_to_s01_couplers_WVALID;
  S_ACLK_1 <= S_ACLK;
  S_ARESETN_1 <= S_ARESETN;
  S_AXI_arready <= s01_couplers_to_auto_ds_ARREADY;
  S_AXI_awready <= s01_couplers_to_auto_ds_AWREADY;
  S_AXI_bid(15 downto 0) <= s01_couplers_to_auto_ds_BID(15 downto 0);
  S_AXI_bresp(1 downto 0) <= s01_couplers_to_auto_ds_BRESP(1 downto 0);
  S_AXI_bvalid <= s01_couplers_to_auto_ds_BVALID;
  S_AXI_rdata(127 downto 0) <= s01_couplers_to_auto_ds_RDATA(127 downto 0);
  S_AXI_rid(15 downto 0) <= s01_couplers_to_auto_ds_RID(15 downto 0);
  S_AXI_rlast <= s01_couplers_to_auto_ds_RLAST;
  S_AXI_rresp(1 downto 0) <= s01_couplers_to_auto_ds_RRESP(1 downto 0);
  S_AXI_rvalid <= s01_couplers_to_auto_ds_RVALID;
  S_AXI_wready <= s01_couplers_to_auto_ds_WREADY;
  auto_pc_to_s01_couplers_ARREADY <= M_AXI_arready;
  auto_pc_to_s01_couplers_AWREADY <= M_AXI_awready;
  auto_pc_to_s01_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  auto_pc_to_s01_couplers_BVALID <= M_AXI_bvalid;
  auto_pc_to_s01_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  auto_pc_to_s01_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  auto_pc_to_s01_couplers_RVALID <= M_AXI_rvalid;
  auto_pc_to_s01_couplers_WREADY <= M_AXI_wready;
  s01_couplers_to_auto_ds_ARADDR(39 downto 0) <= S_AXI_araddr(39 downto 0);
  s01_couplers_to_auto_ds_ARBURST(1 downto 0) <= S_AXI_arburst(1 downto 0);
  s01_couplers_to_auto_ds_ARCACHE(3 downto 0) <= S_AXI_arcache(3 downto 0);
  s01_couplers_to_auto_ds_ARID(15 downto 0) <= S_AXI_arid(15 downto 0);
  s01_couplers_to_auto_ds_ARLEN(7 downto 0) <= S_AXI_arlen(7 downto 0);
  s01_couplers_to_auto_ds_ARLOCK <= S_AXI_arlock;
  s01_couplers_to_auto_ds_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  s01_couplers_to_auto_ds_ARQOS(3 downto 0) <= S_AXI_arqos(3 downto 0);
  s01_couplers_to_auto_ds_ARSIZE(2 downto 0) <= S_AXI_arsize(2 downto 0);
  s01_couplers_to_auto_ds_ARVALID <= S_AXI_arvalid;
  s01_couplers_to_auto_ds_AWADDR(39 downto 0) <= S_AXI_awaddr(39 downto 0);
  s01_couplers_to_auto_ds_AWBURST(1 downto 0) <= S_AXI_awburst(1 downto 0);
  s01_couplers_to_auto_ds_AWCACHE(3 downto 0) <= S_AXI_awcache(3 downto 0);
  s01_couplers_to_auto_ds_AWID(15 downto 0) <= S_AXI_awid(15 downto 0);
  s01_couplers_to_auto_ds_AWLEN(7 downto 0) <= S_AXI_awlen(7 downto 0);
  s01_couplers_to_auto_ds_AWLOCK <= S_AXI_awlock;
  s01_couplers_to_auto_ds_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  s01_couplers_to_auto_ds_AWQOS(3 downto 0) <= S_AXI_awqos(3 downto 0);
  s01_couplers_to_auto_ds_AWSIZE(2 downto 0) <= S_AXI_awsize(2 downto 0);
  s01_couplers_to_auto_ds_AWVALID <= S_AXI_awvalid;
  s01_couplers_to_auto_ds_BREADY <= S_AXI_bready;
  s01_couplers_to_auto_ds_RREADY <= S_AXI_rready;
  s01_couplers_to_auto_ds_WDATA(127 downto 0) <= S_AXI_wdata(127 downto 0);
  s01_couplers_to_auto_ds_WLAST <= S_AXI_wlast;
  s01_couplers_to_auto_ds_WSTRB(15 downto 0) <= S_AXI_wstrb(15 downto 0);
  s01_couplers_to_auto_ds_WVALID <= S_AXI_wvalid;
auto_ds: component kv260_video_auto_ds_1
     port map (
      m_axi_araddr(39 downto 0) => auto_ds_to_auto_pc_ARADDR(39 downto 0),
      m_axi_arburst(1 downto 0) => auto_ds_to_auto_pc_ARBURST(1 downto 0),
      m_axi_arcache(3 downto 0) => auto_ds_to_auto_pc_ARCACHE(3 downto 0),
      m_axi_arlen(7 downto 0) => auto_ds_to_auto_pc_ARLEN(7 downto 0),
      m_axi_arlock(0) => auto_ds_to_auto_pc_ARLOCK(0),
      m_axi_arprot(2 downto 0) => auto_ds_to_auto_pc_ARPROT(2 downto 0),
      m_axi_arqos(3 downto 0) => auto_ds_to_auto_pc_ARQOS(3 downto 0),
      m_axi_arready => auto_ds_to_auto_pc_ARREADY,
      m_axi_arregion(3 downto 0) => auto_ds_to_auto_pc_ARREGION(3 downto 0),
      m_axi_arsize(2 downto 0) => auto_ds_to_auto_pc_ARSIZE(2 downto 0),
      m_axi_arvalid => auto_ds_to_auto_pc_ARVALID,
      m_axi_awaddr(39 downto 0) => auto_ds_to_auto_pc_AWADDR(39 downto 0),
      m_axi_awburst(1 downto 0) => auto_ds_to_auto_pc_AWBURST(1 downto 0),
      m_axi_awcache(3 downto 0) => auto_ds_to_auto_pc_AWCACHE(3 downto 0),
      m_axi_awlen(7 downto 0) => auto_ds_to_auto_pc_AWLEN(7 downto 0),
      m_axi_awlock(0) => auto_ds_to_auto_pc_AWLOCK(0),
      m_axi_awprot(2 downto 0) => auto_ds_to_auto_pc_AWPROT(2 downto 0),
      m_axi_awqos(3 downto 0) => auto_ds_to_auto_pc_AWQOS(3 downto 0),
      m_axi_awready => auto_ds_to_auto_pc_AWREADY,
      m_axi_awregion(3 downto 0) => auto_ds_to_auto_pc_AWREGION(3 downto 0),
      m_axi_awsize(2 downto 0) => auto_ds_to_auto_pc_AWSIZE(2 downto 0),
      m_axi_awvalid => auto_ds_to_auto_pc_AWVALID,
      m_axi_bready => auto_ds_to_auto_pc_BREADY,
      m_axi_bresp(1 downto 0) => auto_ds_to_auto_pc_BRESP(1 downto 0),
      m_axi_bvalid => auto_ds_to_auto_pc_BVALID,
      m_axi_rdata(31 downto 0) => auto_ds_to_auto_pc_RDATA(31 downto 0),
      m_axi_rlast => auto_ds_to_auto_pc_RLAST,
      m_axi_rready => auto_ds_to_auto_pc_RREADY,
      m_axi_rresp(1 downto 0) => auto_ds_to_auto_pc_RRESP(1 downto 0),
      m_axi_rvalid => auto_ds_to_auto_pc_RVALID,
      m_axi_wdata(31 downto 0) => auto_ds_to_auto_pc_WDATA(31 downto 0),
      m_axi_wlast => auto_ds_to_auto_pc_WLAST,
      m_axi_wready => auto_ds_to_auto_pc_WREADY,
      m_axi_wstrb(3 downto 0) => auto_ds_to_auto_pc_WSTRB(3 downto 0),
      m_axi_wvalid => auto_ds_to_auto_pc_WVALID,
      s_axi_aclk => S_ACLK_1,
      s_axi_araddr(39 downto 0) => s01_couplers_to_auto_ds_ARADDR(39 downto 0),
      s_axi_arburst(1 downto 0) => s01_couplers_to_auto_ds_ARBURST(1 downto 0),
      s_axi_arcache(3 downto 0) => s01_couplers_to_auto_ds_ARCACHE(3 downto 0),
      s_axi_aresetn => S_ARESETN_1,
      s_axi_arid(15 downto 0) => s01_couplers_to_auto_ds_ARID(15 downto 0),
      s_axi_arlen(7 downto 0) => s01_couplers_to_auto_ds_ARLEN(7 downto 0),
      s_axi_arlock(0) => s01_couplers_to_auto_ds_ARLOCK,
      s_axi_arprot(2 downto 0) => s01_couplers_to_auto_ds_ARPROT(2 downto 0),
      s_axi_arqos(3 downto 0) => s01_couplers_to_auto_ds_ARQOS(3 downto 0),
      s_axi_arready => s01_couplers_to_auto_ds_ARREADY,
      s_axi_arregion(3 downto 0) => B"0000",
      s_axi_arsize(2 downto 0) => s01_couplers_to_auto_ds_ARSIZE(2 downto 0),
      s_axi_arvalid => s01_couplers_to_auto_ds_ARVALID,
      s_axi_awaddr(39 downto 0) => s01_couplers_to_auto_ds_AWADDR(39 downto 0),
      s_axi_awburst(1 downto 0) => s01_couplers_to_auto_ds_AWBURST(1 downto 0),
      s_axi_awcache(3 downto 0) => s01_couplers_to_auto_ds_AWCACHE(3 downto 0),
      s_axi_awid(15 downto 0) => s01_couplers_to_auto_ds_AWID(15 downto 0),
      s_axi_awlen(7 downto 0) => s01_couplers_to_auto_ds_AWLEN(7 downto 0),
      s_axi_awlock(0) => s01_couplers_to_auto_ds_AWLOCK,
      s_axi_awprot(2 downto 0) => s01_couplers_to_auto_ds_AWPROT(2 downto 0),
      s_axi_awqos(3 downto 0) => s01_couplers_to_auto_ds_AWQOS(3 downto 0),
      s_axi_awready => s01_couplers_to_auto_ds_AWREADY,
      s_axi_awregion(3 downto 0) => B"0000",
      s_axi_awsize(2 downto 0) => s01_couplers_to_auto_ds_AWSIZE(2 downto 0),
      s_axi_awvalid => s01_couplers_to_auto_ds_AWVALID,
      s_axi_bid(15 downto 0) => s01_couplers_to_auto_ds_BID(15 downto 0),
      s_axi_bready => s01_couplers_to_auto_ds_BREADY,
      s_axi_bresp(1 downto 0) => s01_couplers_to_auto_ds_BRESP(1 downto 0),
      s_axi_bvalid => s01_couplers_to_auto_ds_BVALID,
      s_axi_rdata(127 downto 0) => s01_couplers_to_auto_ds_RDATA(127 downto 0),
      s_axi_rid(15 downto 0) => s01_couplers_to_auto_ds_RID(15 downto 0),
      s_axi_rlast => s01_couplers_to_auto_ds_RLAST,
      s_axi_rready => s01_couplers_to_auto_ds_RREADY,
      s_axi_rresp(1 downto 0) => s01_couplers_to_auto_ds_RRESP(1 downto 0),
      s_axi_rvalid => s01_couplers_to_auto_ds_RVALID,
      s_axi_wdata(127 downto 0) => s01_couplers_to_auto_ds_WDATA(127 downto 0),
      s_axi_wlast => s01_couplers_to_auto_ds_WLAST,
      s_axi_wready => s01_couplers_to_auto_ds_WREADY,
      s_axi_wstrb(15 downto 0) => s01_couplers_to_auto_ds_WSTRB(15 downto 0),
      s_axi_wvalid => s01_couplers_to_auto_ds_WVALID
    );
auto_pc: component kv260_video_auto_pc_1
     port map (
      aclk => S_ACLK_1,
      aresetn => S_ARESETN_1,
      m_axi_araddr(39 downto 0) => auto_pc_to_s01_couplers_ARADDR(39 downto 0),
      m_axi_arprot(2 downto 0) => auto_pc_to_s01_couplers_ARPROT(2 downto 0),
      m_axi_arready => auto_pc_to_s01_couplers_ARREADY,
      m_axi_arvalid => auto_pc_to_s01_couplers_ARVALID,
      m_axi_awaddr(39 downto 0) => auto_pc_to_s01_couplers_AWADDR(39 downto 0),
      m_axi_awprot(2 downto 0) => auto_pc_to_s01_couplers_AWPROT(2 downto 0),
      m_axi_awready => auto_pc_to_s01_couplers_AWREADY,
      m_axi_awvalid => auto_pc_to_s01_couplers_AWVALID,
      m_axi_bready => auto_pc_to_s01_couplers_BREADY,
      m_axi_bresp(1 downto 0) => auto_pc_to_s01_couplers_BRESP(1 downto 0),
      m_axi_bvalid => auto_pc_to_s01_couplers_BVALID,
      m_axi_rdata(31 downto 0) => auto_pc_to_s01_couplers_RDATA(31 downto 0),
      m_axi_rready => auto_pc_to_s01_couplers_RREADY,
      m_axi_rresp(1 downto 0) => auto_pc_to_s01_couplers_RRESP(1 downto 0),
      m_axi_rvalid => auto_pc_to_s01_couplers_RVALID,
      m_axi_wdata(31 downto 0) => auto_pc_to_s01_couplers_WDATA(31 downto 0),
      m_axi_wready => auto_pc_to_s01_couplers_WREADY,
      m_axi_wstrb(3 downto 0) => auto_pc_to_s01_couplers_WSTRB(3 downto 0),
      m_axi_wvalid => auto_pc_to_s01_couplers_WVALID,
      s_axi_araddr(39 downto 0) => auto_ds_to_auto_pc_ARADDR(39 downto 0),
      s_axi_arburst(1 downto 0) => auto_ds_to_auto_pc_ARBURST(1 downto 0),
      s_axi_arcache(3 downto 0) => auto_ds_to_auto_pc_ARCACHE(3 downto 0),
      s_axi_arlen(7 downto 0) => auto_ds_to_auto_pc_ARLEN(7 downto 0),
      s_axi_arlock(0) => auto_ds_to_auto_pc_ARLOCK(0),
      s_axi_arprot(2 downto 0) => auto_ds_to_auto_pc_ARPROT(2 downto 0),
      s_axi_arqos(3 downto 0) => auto_ds_to_auto_pc_ARQOS(3 downto 0),
      s_axi_arready => auto_ds_to_auto_pc_ARREADY,
      s_axi_arregion(3 downto 0) => auto_ds_to_auto_pc_ARREGION(3 downto 0),
      s_axi_arsize(2 downto 0) => auto_ds_to_auto_pc_ARSIZE(2 downto 0),
      s_axi_arvalid => auto_ds_to_auto_pc_ARVALID,
      s_axi_awaddr(39 downto 0) => auto_ds_to_auto_pc_AWADDR(39 downto 0),
      s_axi_awburst(1 downto 0) => auto_ds_to_auto_pc_AWBURST(1 downto 0),
      s_axi_awcache(3 downto 0) => auto_ds_to_auto_pc_AWCACHE(3 downto 0),
      s_axi_awlen(7 downto 0) => auto_ds_to_auto_pc_AWLEN(7 downto 0),
      s_axi_awlock(0) => auto_ds_to_auto_pc_AWLOCK(0),
      s_axi_awprot(2 downto 0) => auto_ds_to_auto_pc_AWPROT(2 downto 0),
      s_axi_awqos(3 downto 0) => auto_ds_to_auto_pc_AWQOS(3 downto 0),
      s_axi_awready => auto_ds_to_auto_pc_AWREADY,
      s_axi_awregion(3 downto 0) => auto_ds_to_auto_pc_AWREGION(3 downto 0),
      s_axi_awsize(2 downto 0) => auto_ds_to_auto_pc_AWSIZE(2 downto 0),
      s_axi_awvalid => auto_ds_to_auto_pc_AWVALID,
      s_axi_bready => auto_ds_to_auto_pc_BREADY,
      s_axi_bresp(1 downto 0) => auto_ds_to_auto_pc_BRESP(1 downto 0),
      s_axi_bvalid => auto_ds_to_auto_pc_BVALID,
      s_axi_rdata(31 downto 0) => auto_ds_to_auto_pc_RDATA(31 downto 0),
      s_axi_rlast => auto_ds_to_auto_pc_RLAST,
      s_axi_rready => auto_ds_to_auto_pc_RREADY,
      s_axi_rresp(1 downto 0) => auto_ds_to_auto_pc_RRESP(1 downto 0),
      s_axi_rvalid => auto_ds_to_auto_pc_RVALID,
      s_axi_wdata(31 downto 0) => auto_ds_to_auto_pc_WDATA(31 downto 0),
      s_axi_wlast => auto_ds_to_auto_pc_WLAST,
      s_axi_wready => auto_ds_to_auto_pc_WREADY,
      s_axi_wstrb(3 downto 0) => auto_ds_to_auto_pc_WSTRB(3 downto 0),
      s_axi_wvalid => auto_ds_to_auto_pc_WVALID
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity kv260_video_ps8_0_axi_periph_0 is
  port (
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC;
    M00_ACLK : in STD_LOGIC;
    M00_ARESETN : in STD_LOGIC;
    M00_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M00_AXI_arready : in STD_LOGIC;
    M00_AXI_arvalid : out STD_LOGIC;
    M00_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M00_AXI_awready : in STD_LOGIC;
    M00_AXI_awvalid : out STD_LOGIC;
    M00_AXI_bready : out STD_LOGIC;
    M00_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_bvalid : in STD_LOGIC;
    M00_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_rready : out STD_LOGIC;
    M00_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_rvalid : in STD_LOGIC;
    M00_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_wready : in STD_LOGIC;
    M00_AXI_wvalid : out STD_LOGIC;
    M01_ACLK : in STD_LOGIC;
    M01_ARESETN : in STD_LOGIC;
    M01_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M01_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M01_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M01_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_ACLK : in STD_LOGIC;
    M02_ARESETN : in STD_LOGIC;
    M02_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M02_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M02_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M02_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M02_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M02_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_ACLK : in STD_LOGIC;
    M03_ARESETN : in STD_LOGIC;
    M03_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M03_AXI_arready : in STD_LOGIC;
    M03_AXI_arvalid : out STD_LOGIC;
    M03_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M03_AXI_awready : in STD_LOGIC;
    M03_AXI_awvalid : out STD_LOGIC;
    M03_AXI_bready : out STD_LOGIC;
    M03_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M03_AXI_bvalid : in STD_LOGIC;
    M03_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_rready : out STD_LOGIC;
    M03_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M03_AXI_rvalid : in STD_LOGIC;
    M03_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_wready : in STD_LOGIC;
    M03_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M03_AXI_wvalid : out STD_LOGIC;
    M04_ACLK : in STD_LOGIC;
    M04_ARESETN : in STD_LOGIC;
    M04_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M04_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M04_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M04_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M04_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M04_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M04_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M04_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M04_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M04_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_ACLK : in STD_LOGIC;
    M05_ARESETN : in STD_LOGIC;
    M05_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI_arready : in STD_LOGIC;
    M05_AXI_arvalid : out STD_LOGIC;
    M05_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI_awready : in STD_LOGIC;
    M05_AXI_awvalid : out STD_LOGIC;
    M05_AXI_bready : out STD_LOGIC;
    M05_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_bvalid : in STD_LOGIC;
    M05_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_rready : out STD_LOGIC;
    M05_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_rvalid : in STD_LOGIC;
    M05_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_wready : in STD_LOGIC;
    M05_AXI_wvalid : out STD_LOGIC;
    M06_ACLK : in STD_LOGIC;
    M06_ARESETN : in STD_LOGIC;
    M06_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M06_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M06_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M06_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M06_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M06_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_ACLK : in STD_LOGIC;
    M07_ARESETN : in STD_LOGIC;
    M07_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M07_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_ACLK : in STD_LOGIC;
    M08_ARESETN : in STD_LOGIC;
    M08_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M08_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M08_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M08_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M08_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M08_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M08_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M08_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M09_ACLK : in STD_LOGIC;
    M09_ARESETN : in STD_LOGIC;
    M09_AXI_araddr : out STD_LOGIC_VECTOR ( 10 downto 0 );
    M09_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M09_AXI_arready : in STD_LOGIC;
    M09_AXI_arvalid : out STD_LOGIC;
    M09_AXI_awaddr : out STD_LOGIC_VECTOR ( 10 downto 0 );
    M09_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M09_AXI_awready : in STD_LOGIC;
    M09_AXI_awvalid : out STD_LOGIC;
    M09_AXI_bready : out STD_LOGIC;
    M09_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M09_AXI_bvalid : in STD_LOGIC;
    M09_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M09_AXI_rready : out STD_LOGIC;
    M09_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M09_AXI_rvalid : in STD_LOGIC;
    M09_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M09_AXI_wready : in STD_LOGIC;
    M09_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M09_AXI_wvalid : out STD_LOGIC;
    S00_ACLK : in STD_LOGIC;
    S00_ARESETN : in STD_LOGIC;
    S00_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S00_AXI_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_arid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S00_AXI_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S00_AXI_arlock : in STD_LOGIC;
    S00_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_arready : out STD_LOGIC;
    S00_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_arvalid : in STD_LOGIC;
    S00_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S00_AXI_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_awid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S00_AXI_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S00_AXI_awlock : in STD_LOGIC;
    S00_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_awready : out STD_LOGIC;
    S00_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_awvalid : in STD_LOGIC;
    S00_AXI_bid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    S00_AXI_bready : in STD_LOGIC;
    S00_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_bvalid : out STD_LOGIC;
    S00_AXI_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S00_AXI_rid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    S00_AXI_rlast : out STD_LOGIC;
    S00_AXI_rready : in STD_LOGIC;
    S00_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_rvalid : out STD_LOGIC;
    S00_AXI_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S00_AXI_wlast : in STD_LOGIC;
    S00_AXI_wready : out STD_LOGIC;
    S00_AXI_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S00_AXI_wvalid : in STD_LOGIC;
    S01_ACLK : in STD_LOGIC;
    S01_ARESETN : in STD_LOGIC;
    S01_AXI_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S01_AXI_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S01_AXI_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S01_AXI_arid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S01_AXI_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S01_AXI_arlock : in STD_LOGIC;
    S01_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S01_AXI_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S01_AXI_arready : out STD_LOGIC;
    S01_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S01_AXI_arvalid : in STD_LOGIC;
    S01_AXI_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    S01_AXI_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S01_AXI_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S01_AXI_awid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S01_AXI_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S01_AXI_awlock : in STD_LOGIC;
    S01_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S01_AXI_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S01_AXI_awready : out STD_LOGIC;
    S01_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S01_AXI_awvalid : in STD_LOGIC;
    S01_AXI_bid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    S01_AXI_bready : in STD_LOGIC;
    S01_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S01_AXI_bvalid : out STD_LOGIC;
    S01_AXI_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S01_AXI_rid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    S01_AXI_rlast : out STD_LOGIC;
    S01_AXI_rready : in STD_LOGIC;
    S01_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S01_AXI_rvalid : out STD_LOGIC;
    S01_AXI_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S01_AXI_wlast : in STD_LOGIC;
    S01_AXI_wready : out STD_LOGIC;
    S01_AXI_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S01_AXI_wvalid : in STD_LOGIC
  );
end kv260_video_ps8_0_axi_periph_0;

architecture STRUCTURE of kv260_video_ps8_0_axi_periph_0 is
  component kv260_video_xbar_0 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 79 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_awvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awready : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_wvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wready : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_bvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 79 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_arvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arready : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_rvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 399 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 29 downto 0 );
    m_axi_awvalid : out STD_LOGIC_VECTOR ( 9 downto 0 );
    m_axi_awready : in STD_LOGIC_VECTOR ( 9 downto 0 );
    m_axi_wdata : out STD_LOGIC_VECTOR ( 319 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 39 downto 0 );
    m_axi_wvalid : out STD_LOGIC_VECTOR ( 9 downto 0 );
    m_axi_wready : in STD_LOGIC_VECTOR ( 9 downto 0 );
    m_axi_bresp : in STD_LOGIC_VECTOR ( 19 downto 0 );
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 9 downto 0 );
    m_axi_bready : out STD_LOGIC_VECTOR ( 9 downto 0 );
    m_axi_araddr : out STD_LOGIC_VECTOR ( 399 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 29 downto 0 );
    m_axi_arvalid : out STD_LOGIC_VECTOR ( 9 downto 0 );
    m_axi_arready : in STD_LOGIC_VECTOR ( 9 downto 0 );
    m_axi_rdata : in STD_LOGIC_VECTOR ( 319 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 19 downto 0 );
    m_axi_rvalid : in STD_LOGIC_VECTOR ( 9 downto 0 );
    m_axi_rready : out STD_LOGIC_VECTOR ( 9 downto 0 )
  );
  end component kv260_video_xbar_0;
  signal M00_ACLK_1 : STD_LOGIC;
  signal M00_ARESETN_1 : STD_LOGIC;
  signal M01_ACLK_1 : STD_LOGIC;
  signal M01_ARESETN_1 : STD_LOGIC;
  signal M02_ACLK_1 : STD_LOGIC;
  signal M02_ARESETN_1 : STD_LOGIC;
  signal M03_ACLK_1 : STD_LOGIC;
  signal M03_ARESETN_1 : STD_LOGIC;
  signal M04_ACLK_1 : STD_LOGIC;
  signal M04_ARESETN_1 : STD_LOGIC;
  signal M05_ACLK_1 : STD_LOGIC;
  signal M05_ARESETN_1 : STD_LOGIC;
  signal M06_ACLK_1 : STD_LOGIC;
  signal M06_ARESETN_1 : STD_LOGIC;
  signal M07_ACLK_1 : STD_LOGIC;
  signal M07_ARESETN_1 : STD_LOGIC;
  signal M08_ACLK_1 : STD_LOGIC;
  signal M08_ARESETN_1 : STD_LOGIC;
  signal M09_ACLK_1 : STD_LOGIC;
  signal M09_ARESETN_1 : STD_LOGIC;
  signal S00_ACLK_1 : STD_LOGIC;
  signal S00_ARESETN_1 : STD_LOGIC;
  signal S01_ACLK_1 : STD_LOGIC;
  signal S01_ARESETN_1 : STD_LOGIC;
  signal m00_couplers_to_ps8_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m00_couplers_to_ps8_0_axi_periph_ARREADY : STD_LOGIC;
  signal m00_couplers_to_ps8_0_axi_periph_ARVALID : STD_LOGIC;
  signal m00_couplers_to_ps8_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m00_couplers_to_ps8_0_axi_periph_AWREADY : STD_LOGIC;
  signal m00_couplers_to_ps8_0_axi_periph_AWVALID : STD_LOGIC;
  signal m00_couplers_to_ps8_0_axi_periph_BREADY : STD_LOGIC;
  signal m00_couplers_to_ps8_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m00_couplers_to_ps8_0_axi_periph_BVALID : STD_LOGIC;
  signal m00_couplers_to_ps8_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_ps8_0_axi_periph_RREADY : STD_LOGIC;
  signal m00_couplers_to_ps8_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m00_couplers_to_ps8_0_axi_periph_RVALID : STD_LOGIC;
  signal m00_couplers_to_ps8_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_ps8_0_axi_periph_WREADY : STD_LOGIC;
  signal m00_couplers_to_ps8_0_axi_periph_WVALID : STD_LOGIC;
  signal m01_couplers_to_ps8_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m01_couplers_to_ps8_0_axi_periph_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_ps8_0_axi_periph_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_ps8_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m01_couplers_to_ps8_0_axi_periph_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_ps8_0_axi_periph_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_ps8_0_axi_periph_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_ps8_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m01_couplers_to_ps8_0_axi_periph_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_ps8_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_ps8_0_axi_periph_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_ps8_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m01_couplers_to_ps8_0_axi_periph_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_ps8_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_ps8_0_axi_periph_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_ps8_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m01_couplers_to_ps8_0_axi_periph_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_ps8_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m02_couplers_to_ps8_0_axi_periph_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_ps8_0_axi_periph_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_ps8_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m02_couplers_to_ps8_0_axi_periph_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_ps8_0_axi_periph_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_ps8_0_axi_periph_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_ps8_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m02_couplers_to_ps8_0_axi_periph_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_ps8_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_ps8_0_axi_periph_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_ps8_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m02_couplers_to_ps8_0_axi_periph_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_ps8_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_ps8_0_axi_periph_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m02_couplers_to_ps8_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m02_couplers_to_ps8_0_axi_periph_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m03_couplers_to_ps8_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m03_couplers_to_ps8_0_axi_periph_ARREADY : STD_LOGIC;
  signal m03_couplers_to_ps8_0_axi_periph_ARVALID : STD_LOGIC;
  signal m03_couplers_to_ps8_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m03_couplers_to_ps8_0_axi_periph_AWREADY : STD_LOGIC;
  signal m03_couplers_to_ps8_0_axi_periph_AWVALID : STD_LOGIC;
  signal m03_couplers_to_ps8_0_axi_periph_BREADY : STD_LOGIC;
  signal m03_couplers_to_ps8_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m03_couplers_to_ps8_0_axi_periph_BVALID : STD_LOGIC;
  signal m03_couplers_to_ps8_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_ps8_0_axi_periph_RREADY : STD_LOGIC;
  signal m03_couplers_to_ps8_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m03_couplers_to_ps8_0_axi_periph_RVALID : STD_LOGIC;
  signal m03_couplers_to_ps8_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_ps8_0_axi_periph_WREADY : STD_LOGIC;
  signal m03_couplers_to_ps8_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m03_couplers_to_ps8_0_axi_periph_WVALID : STD_LOGIC;
  signal m04_couplers_to_ps8_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m04_couplers_to_ps8_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m04_couplers_to_ps8_0_axi_periph_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_ps8_0_axi_periph_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_ps8_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m04_couplers_to_ps8_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m04_couplers_to_ps8_0_axi_periph_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_ps8_0_axi_periph_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_ps8_0_axi_periph_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_ps8_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m04_couplers_to_ps8_0_axi_periph_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_ps8_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_ps8_0_axi_periph_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_ps8_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m04_couplers_to_ps8_0_axi_periph_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_ps8_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_ps8_0_axi_periph_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m04_couplers_to_ps8_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m04_couplers_to_ps8_0_axi_periph_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m05_couplers_to_ps8_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m05_couplers_to_ps8_0_axi_periph_ARREADY : STD_LOGIC;
  signal m05_couplers_to_ps8_0_axi_periph_ARVALID : STD_LOGIC;
  signal m05_couplers_to_ps8_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m05_couplers_to_ps8_0_axi_periph_AWREADY : STD_LOGIC;
  signal m05_couplers_to_ps8_0_axi_periph_AWVALID : STD_LOGIC;
  signal m05_couplers_to_ps8_0_axi_periph_BREADY : STD_LOGIC;
  signal m05_couplers_to_ps8_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m05_couplers_to_ps8_0_axi_periph_BVALID : STD_LOGIC;
  signal m05_couplers_to_ps8_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_ps8_0_axi_periph_RREADY : STD_LOGIC;
  signal m05_couplers_to_ps8_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m05_couplers_to_ps8_0_axi_periph_RVALID : STD_LOGIC;
  signal m05_couplers_to_ps8_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_ps8_0_axi_periph_WREADY : STD_LOGIC;
  signal m05_couplers_to_ps8_0_axi_periph_WVALID : STD_LOGIC;
  signal m06_couplers_to_ps8_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m06_couplers_to_ps8_0_axi_periph_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_ps8_0_axi_periph_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_ps8_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m06_couplers_to_ps8_0_axi_periph_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_ps8_0_axi_periph_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_ps8_0_axi_periph_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_ps8_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m06_couplers_to_ps8_0_axi_periph_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_ps8_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_ps8_0_axi_periph_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_ps8_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m06_couplers_to_ps8_0_axi_periph_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_ps8_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_ps8_0_axi_periph_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m06_couplers_to_ps8_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m06_couplers_to_ps8_0_axi_periph_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps8_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m07_couplers_to_ps8_0_axi_periph_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps8_0_axi_periph_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps8_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m07_couplers_to_ps8_0_axi_periph_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps8_0_axi_periph_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps8_0_axi_periph_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps8_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m07_couplers_to_ps8_0_axi_periph_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps8_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_ps8_0_axi_periph_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps8_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m07_couplers_to_ps8_0_axi_periph_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps8_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_ps8_0_axi_periph_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps8_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m07_couplers_to_ps8_0_axi_periph_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps8_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m08_couplers_to_ps8_0_axi_periph_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps8_0_axi_periph_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps8_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal m08_couplers_to_ps8_0_axi_periph_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps8_0_axi_periph_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps8_0_axi_periph_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps8_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m08_couplers_to_ps8_0_axi_periph_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps8_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_ps8_0_axi_periph_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps8_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m08_couplers_to_ps8_0_axi_periph_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps8_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_ps8_0_axi_periph_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps8_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m08_couplers_to_ps8_0_axi_periph_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps8_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal m09_couplers_to_ps8_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m09_couplers_to_ps8_0_axi_periph_ARREADY : STD_LOGIC;
  signal m09_couplers_to_ps8_0_axi_periph_ARVALID : STD_LOGIC;
  signal m09_couplers_to_ps8_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal m09_couplers_to_ps8_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m09_couplers_to_ps8_0_axi_periph_AWREADY : STD_LOGIC;
  signal m09_couplers_to_ps8_0_axi_periph_AWVALID : STD_LOGIC;
  signal m09_couplers_to_ps8_0_axi_periph_BREADY : STD_LOGIC;
  signal m09_couplers_to_ps8_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m09_couplers_to_ps8_0_axi_periph_BVALID : STD_LOGIC;
  signal m09_couplers_to_ps8_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_ps8_0_axi_periph_RREADY : STD_LOGIC;
  signal m09_couplers_to_ps8_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m09_couplers_to_ps8_0_axi_periph_RVALID : STD_LOGIC;
  signal m09_couplers_to_ps8_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_ps8_0_axi_periph_WREADY : STD_LOGIC;
  signal m09_couplers_to_ps8_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m09_couplers_to_ps8_0_axi_periph_WVALID : STD_LOGIC;
  signal ps8_0_axi_periph_ACLK_net : STD_LOGIC;
  signal ps8_0_axi_periph_ARESETN_net : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_ARID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_ARLOCK : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_ARVALID : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_AWID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_AWLOCK : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_AWVALID : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_BID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_BREADY : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_RDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_RID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_RLAST : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_RREADY : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_WDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_WLAST : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_to_s00_couplers_WSTRB : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ps8_0_axi_periph_to_s00_couplers_WVALID : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_ARID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_ARLOCK : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_ARVALID : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_AWID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_AWLOCK : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_AWVALID : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_BID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_BREADY : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_RDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_RID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_RLAST : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_RREADY : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_WDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_WLAST : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_to_s01_couplers_WSTRB : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ps8_0_axi_periph_to_s01_couplers_WVALID : STD_LOGIC;
  signal s00_couplers_to_xbar_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal s00_couplers_to_xbar_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_xbar_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s00_couplers_to_xbar_ARVALID : STD_LOGIC;
  signal s00_couplers_to_xbar_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal s00_couplers_to_xbar_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_xbar_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s00_couplers_to_xbar_AWVALID : STD_LOGIC;
  signal s00_couplers_to_xbar_BREADY : STD_LOGIC;
  signal s00_couplers_to_xbar_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_xbar_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s00_couplers_to_xbar_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s00_couplers_to_xbar_RREADY : STD_LOGIC;
  signal s00_couplers_to_xbar_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_xbar_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s00_couplers_to_xbar_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s00_couplers_to_xbar_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s00_couplers_to_xbar_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_xbar_WVALID : STD_LOGIC;
  signal s01_couplers_to_xbar_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal s01_couplers_to_xbar_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s01_couplers_to_xbar_ARREADY : STD_LOGIC_VECTOR ( 1 to 1 );
  signal s01_couplers_to_xbar_ARVALID : STD_LOGIC;
  signal s01_couplers_to_xbar_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal s01_couplers_to_xbar_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s01_couplers_to_xbar_AWREADY : STD_LOGIC_VECTOR ( 1 to 1 );
  signal s01_couplers_to_xbar_AWVALID : STD_LOGIC;
  signal s01_couplers_to_xbar_BREADY : STD_LOGIC;
  signal s01_couplers_to_xbar_BRESP : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal s01_couplers_to_xbar_BVALID : STD_LOGIC_VECTOR ( 1 to 1 );
  signal s01_couplers_to_xbar_RDATA : STD_LOGIC_VECTOR ( 63 downto 32 );
  signal s01_couplers_to_xbar_RREADY : STD_LOGIC;
  signal s01_couplers_to_xbar_RRESP : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal s01_couplers_to_xbar_RVALID : STD_LOGIC_VECTOR ( 1 to 1 );
  signal s01_couplers_to_xbar_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s01_couplers_to_xbar_WREADY : STD_LOGIC_VECTOR ( 1 to 1 );
  signal s01_couplers_to_xbar_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s01_couplers_to_xbar_WVALID : STD_LOGIC;
  signal xbar_to_m00_couplers_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal xbar_to_m00_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m00_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal xbar_to_m00_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m00_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m00_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m00_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m00_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m00_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m00_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m00_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m00_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m01_couplers_ARADDR : STD_LOGIC_VECTOR ( 79 downto 40 );
  signal xbar_to_m01_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m01_couplers_ARVALID : STD_LOGIC_VECTOR ( 1 to 1 );
  signal xbar_to_m01_couplers_AWADDR : STD_LOGIC_VECTOR ( 79 downto 40 );
  signal xbar_to_m01_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m01_couplers_AWVALID : STD_LOGIC_VECTOR ( 1 to 1 );
  signal xbar_to_m01_couplers_BREADY : STD_LOGIC_VECTOR ( 1 to 1 );
  signal xbar_to_m01_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m01_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m01_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m01_couplers_RREADY : STD_LOGIC_VECTOR ( 1 to 1 );
  signal xbar_to_m01_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m01_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m01_couplers_WDATA : STD_LOGIC_VECTOR ( 63 downto 32 );
  signal xbar_to_m01_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m01_couplers_WSTRB : STD_LOGIC_VECTOR ( 7 downto 4 );
  signal xbar_to_m01_couplers_WVALID : STD_LOGIC_VECTOR ( 1 to 1 );
  signal xbar_to_m02_couplers_ARADDR : STD_LOGIC_VECTOR ( 119 downto 80 );
  signal xbar_to_m02_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m02_couplers_ARVALID : STD_LOGIC_VECTOR ( 2 to 2 );
  signal xbar_to_m02_couplers_AWADDR : STD_LOGIC_VECTOR ( 119 downto 80 );
  signal xbar_to_m02_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m02_couplers_AWVALID : STD_LOGIC_VECTOR ( 2 to 2 );
  signal xbar_to_m02_couplers_BREADY : STD_LOGIC_VECTOR ( 2 to 2 );
  signal xbar_to_m02_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m02_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m02_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m02_couplers_RREADY : STD_LOGIC_VECTOR ( 2 to 2 );
  signal xbar_to_m02_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m02_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m02_couplers_WDATA : STD_LOGIC_VECTOR ( 95 downto 64 );
  signal xbar_to_m02_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m02_couplers_WSTRB : STD_LOGIC_VECTOR ( 11 downto 8 );
  signal xbar_to_m02_couplers_WVALID : STD_LOGIC_VECTOR ( 2 to 2 );
  signal xbar_to_m03_couplers_ARADDR : STD_LOGIC_VECTOR ( 159 downto 120 );
  signal xbar_to_m03_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m03_couplers_ARVALID : STD_LOGIC_VECTOR ( 3 to 3 );
  signal xbar_to_m03_couplers_AWADDR : STD_LOGIC_VECTOR ( 159 downto 120 );
  signal xbar_to_m03_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m03_couplers_AWVALID : STD_LOGIC_VECTOR ( 3 to 3 );
  signal xbar_to_m03_couplers_BREADY : STD_LOGIC_VECTOR ( 3 to 3 );
  signal xbar_to_m03_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m03_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m03_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m03_couplers_RREADY : STD_LOGIC_VECTOR ( 3 to 3 );
  signal xbar_to_m03_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m03_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m03_couplers_WDATA : STD_LOGIC_VECTOR ( 127 downto 96 );
  signal xbar_to_m03_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m03_couplers_WSTRB : STD_LOGIC_VECTOR ( 15 downto 12 );
  signal xbar_to_m03_couplers_WVALID : STD_LOGIC_VECTOR ( 3 to 3 );
  signal xbar_to_m04_couplers_ARADDR : STD_LOGIC_VECTOR ( 199 downto 160 );
  signal xbar_to_m04_couplers_ARPROT : STD_LOGIC_VECTOR ( 14 downto 12 );
  signal xbar_to_m04_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m04_couplers_ARVALID : STD_LOGIC_VECTOR ( 4 to 4 );
  signal xbar_to_m04_couplers_AWADDR : STD_LOGIC_VECTOR ( 199 downto 160 );
  signal xbar_to_m04_couplers_AWPROT : STD_LOGIC_VECTOR ( 14 downto 12 );
  signal xbar_to_m04_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m04_couplers_AWVALID : STD_LOGIC_VECTOR ( 4 to 4 );
  signal xbar_to_m04_couplers_BREADY : STD_LOGIC_VECTOR ( 4 to 4 );
  signal xbar_to_m04_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m04_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m04_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m04_couplers_RREADY : STD_LOGIC_VECTOR ( 4 to 4 );
  signal xbar_to_m04_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m04_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m04_couplers_WDATA : STD_LOGIC_VECTOR ( 159 downto 128 );
  signal xbar_to_m04_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m04_couplers_WSTRB : STD_LOGIC_VECTOR ( 19 downto 16 );
  signal xbar_to_m04_couplers_WVALID : STD_LOGIC_VECTOR ( 4 to 4 );
  signal xbar_to_m05_couplers_ARADDR : STD_LOGIC_VECTOR ( 239 downto 200 );
  signal xbar_to_m05_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m05_couplers_ARVALID : STD_LOGIC_VECTOR ( 5 to 5 );
  signal xbar_to_m05_couplers_AWADDR : STD_LOGIC_VECTOR ( 239 downto 200 );
  signal xbar_to_m05_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m05_couplers_AWVALID : STD_LOGIC_VECTOR ( 5 to 5 );
  signal xbar_to_m05_couplers_BREADY : STD_LOGIC_VECTOR ( 5 to 5 );
  signal xbar_to_m05_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m05_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m05_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m05_couplers_RREADY : STD_LOGIC_VECTOR ( 5 to 5 );
  signal xbar_to_m05_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m05_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m05_couplers_WDATA : STD_LOGIC_VECTOR ( 191 downto 160 );
  signal xbar_to_m05_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m05_couplers_WVALID : STD_LOGIC_VECTOR ( 5 to 5 );
  signal xbar_to_m06_couplers_ARADDR : STD_LOGIC_VECTOR ( 279 downto 240 );
  signal xbar_to_m06_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m06_couplers_ARVALID : STD_LOGIC_VECTOR ( 6 to 6 );
  signal xbar_to_m06_couplers_AWADDR : STD_LOGIC_VECTOR ( 279 downto 240 );
  signal xbar_to_m06_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m06_couplers_AWVALID : STD_LOGIC_VECTOR ( 6 to 6 );
  signal xbar_to_m06_couplers_BREADY : STD_LOGIC_VECTOR ( 6 to 6 );
  signal xbar_to_m06_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m06_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m06_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m06_couplers_RREADY : STD_LOGIC_VECTOR ( 6 to 6 );
  signal xbar_to_m06_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m06_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m06_couplers_WDATA : STD_LOGIC_VECTOR ( 223 downto 192 );
  signal xbar_to_m06_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m06_couplers_WSTRB : STD_LOGIC_VECTOR ( 27 downto 24 );
  signal xbar_to_m06_couplers_WVALID : STD_LOGIC_VECTOR ( 6 to 6 );
  signal xbar_to_m07_couplers_ARADDR : STD_LOGIC_VECTOR ( 319 downto 280 );
  signal xbar_to_m07_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m07_couplers_ARVALID : STD_LOGIC_VECTOR ( 7 to 7 );
  signal xbar_to_m07_couplers_AWADDR : STD_LOGIC_VECTOR ( 319 downto 280 );
  signal xbar_to_m07_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m07_couplers_AWVALID : STD_LOGIC_VECTOR ( 7 to 7 );
  signal xbar_to_m07_couplers_BREADY : STD_LOGIC_VECTOR ( 7 to 7 );
  signal xbar_to_m07_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m07_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m07_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m07_couplers_RREADY : STD_LOGIC_VECTOR ( 7 to 7 );
  signal xbar_to_m07_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m07_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m07_couplers_WDATA : STD_LOGIC_VECTOR ( 255 downto 224 );
  signal xbar_to_m07_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m07_couplers_WSTRB : STD_LOGIC_VECTOR ( 31 downto 28 );
  signal xbar_to_m07_couplers_WVALID : STD_LOGIC_VECTOR ( 7 to 7 );
  signal xbar_to_m08_couplers_ARADDR : STD_LOGIC_VECTOR ( 359 downto 320 );
  signal xbar_to_m08_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m08_couplers_ARVALID : STD_LOGIC_VECTOR ( 8 to 8 );
  signal xbar_to_m08_couplers_AWADDR : STD_LOGIC_VECTOR ( 359 downto 320 );
  signal xbar_to_m08_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m08_couplers_AWVALID : STD_LOGIC_VECTOR ( 8 to 8 );
  signal xbar_to_m08_couplers_BREADY : STD_LOGIC_VECTOR ( 8 to 8 );
  signal xbar_to_m08_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m08_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m08_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m08_couplers_RREADY : STD_LOGIC_VECTOR ( 8 to 8 );
  signal xbar_to_m08_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m08_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m08_couplers_WDATA : STD_LOGIC_VECTOR ( 287 downto 256 );
  signal xbar_to_m08_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m08_couplers_WSTRB : STD_LOGIC_VECTOR ( 35 downto 32 );
  signal xbar_to_m08_couplers_WVALID : STD_LOGIC_VECTOR ( 8 to 8 );
  signal xbar_to_m09_couplers_ARADDR : STD_LOGIC_VECTOR ( 399 downto 360 );
  signal xbar_to_m09_couplers_ARPROT : STD_LOGIC_VECTOR ( 29 downto 27 );
  signal xbar_to_m09_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m09_couplers_ARVALID : STD_LOGIC_VECTOR ( 9 to 9 );
  signal xbar_to_m09_couplers_AWADDR : STD_LOGIC_VECTOR ( 399 downto 360 );
  signal xbar_to_m09_couplers_AWPROT : STD_LOGIC_VECTOR ( 29 downto 27 );
  signal xbar_to_m09_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m09_couplers_AWVALID : STD_LOGIC_VECTOR ( 9 to 9 );
  signal xbar_to_m09_couplers_BREADY : STD_LOGIC_VECTOR ( 9 to 9 );
  signal xbar_to_m09_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m09_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m09_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m09_couplers_RREADY : STD_LOGIC_VECTOR ( 9 to 9 );
  signal xbar_to_m09_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m09_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m09_couplers_WDATA : STD_LOGIC_VECTOR ( 319 downto 288 );
  signal xbar_to_m09_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m09_couplers_WSTRB : STD_LOGIC_VECTOR ( 39 downto 36 );
  signal xbar_to_m09_couplers_WVALID : STD_LOGIC_VECTOR ( 9 to 9 );
  signal NLW_xbar_m_axi_arprot_UNCONNECTED : STD_LOGIC_VECTOR ( 26 downto 0 );
  signal NLW_xbar_m_axi_awprot_UNCONNECTED : STD_LOGIC_VECTOR ( 26 downto 0 );
  signal NLW_xbar_m_axi_wstrb_UNCONNECTED : STD_LOGIC_VECTOR ( 23 downto 0 );
begin
  M00_ACLK_1 <= M00_ACLK;
  M00_ARESETN_1 <= M00_ARESETN;
  M00_AXI_araddr(39 downto 0) <= m00_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0);
  M00_AXI_arvalid <= m00_couplers_to_ps8_0_axi_periph_ARVALID;
  M00_AXI_awaddr(39 downto 0) <= m00_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0);
  M00_AXI_awvalid <= m00_couplers_to_ps8_0_axi_periph_AWVALID;
  M00_AXI_bready <= m00_couplers_to_ps8_0_axi_periph_BREADY;
  M00_AXI_rready <= m00_couplers_to_ps8_0_axi_periph_RREADY;
  M00_AXI_wdata(31 downto 0) <= m00_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0);
  M00_AXI_wvalid <= m00_couplers_to_ps8_0_axi_periph_WVALID;
  M01_ACLK_1 <= M01_ACLK;
  M01_ARESETN_1 <= M01_ARESETN;
  M01_AXI_araddr(39 downto 0) <= m01_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0);
  M01_AXI_arvalid(0) <= m01_couplers_to_ps8_0_axi_periph_ARVALID(0);
  M01_AXI_awaddr(39 downto 0) <= m01_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0);
  M01_AXI_awvalid(0) <= m01_couplers_to_ps8_0_axi_periph_AWVALID(0);
  M01_AXI_bready(0) <= m01_couplers_to_ps8_0_axi_periph_BREADY(0);
  M01_AXI_rready(0) <= m01_couplers_to_ps8_0_axi_periph_RREADY(0);
  M01_AXI_wdata(31 downto 0) <= m01_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0);
  M01_AXI_wstrb(3 downto 0) <= m01_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0);
  M01_AXI_wvalid(0) <= m01_couplers_to_ps8_0_axi_periph_WVALID(0);
  M02_ACLK_1 <= M02_ACLK;
  M02_ARESETN_1 <= M02_ARESETN;
  M02_AXI_araddr(39 downto 0) <= m02_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0);
  M02_AXI_arvalid(0) <= m02_couplers_to_ps8_0_axi_periph_ARVALID(0);
  M02_AXI_awaddr(39 downto 0) <= m02_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0);
  M02_AXI_awvalid(0) <= m02_couplers_to_ps8_0_axi_periph_AWVALID(0);
  M02_AXI_bready(0) <= m02_couplers_to_ps8_0_axi_periph_BREADY(0);
  M02_AXI_rready(0) <= m02_couplers_to_ps8_0_axi_periph_RREADY(0);
  M02_AXI_wdata(31 downto 0) <= m02_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0);
  M02_AXI_wstrb(3 downto 0) <= m02_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0);
  M02_AXI_wvalid(0) <= m02_couplers_to_ps8_0_axi_periph_WVALID(0);
  M03_ACLK_1 <= M03_ACLK;
  M03_ARESETN_1 <= M03_ARESETN;
  M03_AXI_araddr(39 downto 0) <= m03_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0);
  M03_AXI_arvalid <= m03_couplers_to_ps8_0_axi_periph_ARVALID;
  M03_AXI_awaddr(39 downto 0) <= m03_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0);
  M03_AXI_awvalid <= m03_couplers_to_ps8_0_axi_periph_AWVALID;
  M03_AXI_bready <= m03_couplers_to_ps8_0_axi_periph_BREADY;
  M03_AXI_rready <= m03_couplers_to_ps8_0_axi_periph_RREADY;
  M03_AXI_wdata(31 downto 0) <= m03_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0);
  M03_AXI_wstrb(3 downto 0) <= m03_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0);
  M03_AXI_wvalid <= m03_couplers_to_ps8_0_axi_periph_WVALID;
  M04_ACLK_1 <= M04_ACLK;
  M04_ARESETN_1 <= M04_ARESETN;
  M04_AXI_araddr(39 downto 0) <= m04_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0);
  M04_AXI_arprot(2 downto 0) <= m04_couplers_to_ps8_0_axi_periph_ARPROT(2 downto 0);
  M04_AXI_arvalid(0) <= m04_couplers_to_ps8_0_axi_periph_ARVALID(0);
  M04_AXI_awaddr(39 downto 0) <= m04_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0);
  M04_AXI_awprot(2 downto 0) <= m04_couplers_to_ps8_0_axi_periph_AWPROT(2 downto 0);
  M04_AXI_awvalid(0) <= m04_couplers_to_ps8_0_axi_periph_AWVALID(0);
  M04_AXI_bready(0) <= m04_couplers_to_ps8_0_axi_periph_BREADY(0);
  M04_AXI_rready(0) <= m04_couplers_to_ps8_0_axi_periph_RREADY(0);
  M04_AXI_wdata(31 downto 0) <= m04_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0);
  M04_AXI_wstrb(3 downto 0) <= m04_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0);
  M04_AXI_wvalid(0) <= m04_couplers_to_ps8_0_axi_periph_WVALID(0);
  M05_ACLK_1 <= M05_ACLK;
  M05_ARESETN_1 <= M05_ARESETN;
  M05_AXI_araddr(39 downto 0) <= m05_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0);
  M05_AXI_arvalid <= m05_couplers_to_ps8_0_axi_periph_ARVALID;
  M05_AXI_awaddr(39 downto 0) <= m05_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0);
  M05_AXI_awvalid <= m05_couplers_to_ps8_0_axi_periph_AWVALID;
  M05_AXI_bready <= m05_couplers_to_ps8_0_axi_periph_BREADY;
  M05_AXI_rready <= m05_couplers_to_ps8_0_axi_periph_RREADY;
  M05_AXI_wdata(31 downto 0) <= m05_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0);
  M05_AXI_wvalid <= m05_couplers_to_ps8_0_axi_periph_WVALID;
  M06_ACLK_1 <= M06_ACLK;
  M06_ARESETN_1 <= M06_ARESETN;
  M06_AXI_araddr(39 downto 0) <= m06_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0);
  M06_AXI_arvalid(0) <= m06_couplers_to_ps8_0_axi_periph_ARVALID(0);
  M06_AXI_awaddr(39 downto 0) <= m06_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0);
  M06_AXI_awvalid(0) <= m06_couplers_to_ps8_0_axi_periph_AWVALID(0);
  M06_AXI_bready(0) <= m06_couplers_to_ps8_0_axi_periph_BREADY(0);
  M06_AXI_rready(0) <= m06_couplers_to_ps8_0_axi_periph_RREADY(0);
  M06_AXI_wdata(31 downto 0) <= m06_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0);
  M06_AXI_wstrb(3 downto 0) <= m06_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0);
  M06_AXI_wvalid(0) <= m06_couplers_to_ps8_0_axi_periph_WVALID(0);
  M07_ACLK_1 <= M07_ACLK;
  M07_ARESETN_1 <= M07_ARESETN;
  M07_AXI_araddr(39 downto 0) <= m07_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0);
  M07_AXI_arvalid(0) <= m07_couplers_to_ps8_0_axi_periph_ARVALID(0);
  M07_AXI_awaddr(39 downto 0) <= m07_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0);
  M07_AXI_awvalid(0) <= m07_couplers_to_ps8_0_axi_periph_AWVALID(0);
  M07_AXI_bready(0) <= m07_couplers_to_ps8_0_axi_periph_BREADY(0);
  M07_AXI_rready(0) <= m07_couplers_to_ps8_0_axi_periph_RREADY(0);
  M07_AXI_wdata(31 downto 0) <= m07_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0);
  M07_AXI_wstrb(3 downto 0) <= m07_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0);
  M07_AXI_wvalid(0) <= m07_couplers_to_ps8_0_axi_periph_WVALID(0);
  M08_ACLK_1 <= M08_ACLK;
  M08_ARESETN_1 <= M08_ARESETN;
  M08_AXI_araddr(39 downto 0) <= m08_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0);
  M08_AXI_arvalid(0) <= m08_couplers_to_ps8_0_axi_periph_ARVALID(0);
  M08_AXI_awaddr(39 downto 0) <= m08_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0);
  M08_AXI_awvalid(0) <= m08_couplers_to_ps8_0_axi_periph_AWVALID(0);
  M08_AXI_bready(0) <= m08_couplers_to_ps8_0_axi_periph_BREADY(0);
  M08_AXI_rready(0) <= m08_couplers_to_ps8_0_axi_periph_RREADY(0);
  M08_AXI_wdata(31 downto 0) <= m08_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0);
  M08_AXI_wstrb(3 downto 0) <= m08_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0);
  M08_AXI_wvalid(0) <= m08_couplers_to_ps8_0_axi_periph_WVALID(0);
  M09_ACLK_1 <= M09_ACLK;
  M09_ARESETN_1 <= M09_ARESETN;
  M09_AXI_araddr(10 downto 0) <= m09_couplers_to_ps8_0_axi_periph_ARADDR(10 downto 0);
  M09_AXI_arprot(2 downto 0) <= m09_couplers_to_ps8_0_axi_periph_ARPROT(2 downto 0);
  M09_AXI_arvalid <= m09_couplers_to_ps8_0_axi_periph_ARVALID;
  M09_AXI_awaddr(10 downto 0) <= m09_couplers_to_ps8_0_axi_periph_AWADDR(10 downto 0);
  M09_AXI_awprot(2 downto 0) <= m09_couplers_to_ps8_0_axi_periph_AWPROT(2 downto 0);
  M09_AXI_awvalid <= m09_couplers_to_ps8_0_axi_periph_AWVALID;
  M09_AXI_bready <= m09_couplers_to_ps8_0_axi_periph_BREADY;
  M09_AXI_rready <= m09_couplers_to_ps8_0_axi_periph_RREADY;
  M09_AXI_wdata(31 downto 0) <= m09_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0);
  M09_AXI_wstrb(3 downto 0) <= m09_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0);
  M09_AXI_wvalid <= m09_couplers_to_ps8_0_axi_periph_WVALID;
  S00_ACLK_1 <= S00_ACLK;
  S00_ARESETN_1 <= S00_ARESETN;
  S00_AXI_arready <= ps8_0_axi_periph_to_s00_couplers_ARREADY;
  S00_AXI_awready <= ps8_0_axi_periph_to_s00_couplers_AWREADY;
  S00_AXI_bid(15 downto 0) <= ps8_0_axi_periph_to_s00_couplers_BID(15 downto 0);
  S00_AXI_bresp(1 downto 0) <= ps8_0_axi_periph_to_s00_couplers_BRESP(1 downto 0);
  S00_AXI_bvalid <= ps8_0_axi_periph_to_s00_couplers_BVALID;
  S00_AXI_rdata(127 downto 0) <= ps8_0_axi_periph_to_s00_couplers_RDATA(127 downto 0);
  S00_AXI_rid(15 downto 0) <= ps8_0_axi_periph_to_s00_couplers_RID(15 downto 0);
  S00_AXI_rlast <= ps8_0_axi_periph_to_s00_couplers_RLAST;
  S00_AXI_rresp(1 downto 0) <= ps8_0_axi_periph_to_s00_couplers_RRESP(1 downto 0);
  S00_AXI_rvalid <= ps8_0_axi_periph_to_s00_couplers_RVALID;
  S00_AXI_wready <= ps8_0_axi_periph_to_s00_couplers_WREADY;
  S01_ACLK_1 <= S01_ACLK;
  S01_ARESETN_1 <= S01_ARESETN;
  S01_AXI_arready <= ps8_0_axi_periph_to_s01_couplers_ARREADY;
  S01_AXI_awready <= ps8_0_axi_periph_to_s01_couplers_AWREADY;
  S01_AXI_bid(15 downto 0) <= ps8_0_axi_periph_to_s01_couplers_BID(15 downto 0);
  S01_AXI_bresp(1 downto 0) <= ps8_0_axi_periph_to_s01_couplers_BRESP(1 downto 0);
  S01_AXI_bvalid <= ps8_0_axi_periph_to_s01_couplers_BVALID;
  S01_AXI_rdata(127 downto 0) <= ps8_0_axi_periph_to_s01_couplers_RDATA(127 downto 0);
  S01_AXI_rid(15 downto 0) <= ps8_0_axi_periph_to_s01_couplers_RID(15 downto 0);
  S01_AXI_rlast <= ps8_0_axi_periph_to_s01_couplers_RLAST;
  S01_AXI_rresp(1 downto 0) <= ps8_0_axi_periph_to_s01_couplers_RRESP(1 downto 0);
  S01_AXI_rvalid <= ps8_0_axi_periph_to_s01_couplers_RVALID;
  S01_AXI_wready <= ps8_0_axi_periph_to_s01_couplers_WREADY;
  m00_couplers_to_ps8_0_axi_periph_ARREADY <= M00_AXI_arready;
  m00_couplers_to_ps8_0_axi_periph_AWREADY <= M00_AXI_awready;
  m00_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0) <= M00_AXI_bresp(1 downto 0);
  m00_couplers_to_ps8_0_axi_periph_BVALID <= M00_AXI_bvalid;
  m00_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0) <= M00_AXI_rdata(31 downto 0);
  m00_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0) <= M00_AXI_rresp(1 downto 0);
  m00_couplers_to_ps8_0_axi_periph_RVALID <= M00_AXI_rvalid;
  m00_couplers_to_ps8_0_axi_periph_WREADY <= M00_AXI_wready;
  m01_couplers_to_ps8_0_axi_periph_ARREADY(0) <= M01_AXI_arready(0);
  m01_couplers_to_ps8_0_axi_periph_AWREADY(0) <= M01_AXI_awready(0);
  m01_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0) <= M01_AXI_bresp(1 downto 0);
  m01_couplers_to_ps8_0_axi_periph_BVALID(0) <= M01_AXI_bvalid(0);
  m01_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0) <= M01_AXI_rdata(31 downto 0);
  m01_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0) <= M01_AXI_rresp(1 downto 0);
  m01_couplers_to_ps8_0_axi_periph_RVALID(0) <= M01_AXI_rvalid(0);
  m01_couplers_to_ps8_0_axi_periph_WREADY(0) <= M01_AXI_wready(0);
  m02_couplers_to_ps8_0_axi_periph_ARREADY(0) <= M02_AXI_arready(0);
  m02_couplers_to_ps8_0_axi_periph_AWREADY(0) <= M02_AXI_awready(0);
  m02_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0) <= M02_AXI_bresp(1 downto 0);
  m02_couplers_to_ps8_0_axi_periph_BVALID(0) <= M02_AXI_bvalid(0);
  m02_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0) <= M02_AXI_rdata(31 downto 0);
  m02_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0) <= M02_AXI_rresp(1 downto 0);
  m02_couplers_to_ps8_0_axi_periph_RVALID(0) <= M02_AXI_rvalid(0);
  m02_couplers_to_ps8_0_axi_periph_WREADY(0) <= M02_AXI_wready(0);
  m03_couplers_to_ps8_0_axi_periph_ARREADY <= M03_AXI_arready;
  m03_couplers_to_ps8_0_axi_periph_AWREADY <= M03_AXI_awready;
  m03_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0) <= M03_AXI_bresp(1 downto 0);
  m03_couplers_to_ps8_0_axi_periph_BVALID <= M03_AXI_bvalid;
  m03_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0) <= M03_AXI_rdata(31 downto 0);
  m03_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0) <= M03_AXI_rresp(1 downto 0);
  m03_couplers_to_ps8_0_axi_periph_RVALID <= M03_AXI_rvalid;
  m03_couplers_to_ps8_0_axi_periph_WREADY <= M03_AXI_wready;
  m04_couplers_to_ps8_0_axi_periph_ARREADY(0) <= M04_AXI_arready(0);
  m04_couplers_to_ps8_0_axi_periph_AWREADY(0) <= M04_AXI_awready(0);
  m04_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0) <= M04_AXI_bresp(1 downto 0);
  m04_couplers_to_ps8_0_axi_periph_BVALID(0) <= M04_AXI_bvalid(0);
  m04_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0) <= M04_AXI_rdata(31 downto 0);
  m04_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0) <= M04_AXI_rresp(1 downto 0);
  m04_couplers_to_ps8_0_axi_periph_RVALID(0) <= M04_AXI_rvalid(0);
  m04_couplers_to_ps8_0_axi_periph_WREADY(0) <= M04_AXI_wready(0);
  m05_couplers_to_ps8_0_axi_periph_ARREADY <= M05_AXI_arready;
  m05_couplers_to_ps8_0_axi_periph_AWREADY <= M05_AXI_awready;
  m05_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0) <= M05_AXI_bresp(1 downto 0);
  m05_couplers_to_ps8_0_axi_periph_BVALID <= M05_AXI_bvalid;
  m05_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0) <= M05_AXI_rdata(31 downto 0);
  m05_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0) <= M05_AXI_rresp(1 downto 0);
  m05_couplers_to_ps8_0_axi_periph_RVALID <= M05_AXI_rvalid;
  m05_couplers_to_ps8_0_axi_periph_WREADY <= M05_AXI_wready;
  m06_couplers_to_ps8_0_axi_periph_ARREADY(0) <= M06_AXI_arready(0);
  m06_couplers_to_ps8_0_axi_periph_AWREADY(0) <= M06_AXI_awready(0);
  m06_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0) <= M06_AXI_bresp(1 downto 0);
  m06_couplers_to_ps8_0_axi_periph_BVALID(0) <= M06_AXI_bvalid(0);
  m06_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0) <= M06_AXI_rdata(31 downto 0);
  m06_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0) <= M06_AXI_rresp(1 downto 0);
  m06_couplers_to_ps8_0_axi_periph_RVALID(0) <= M06_AXI_rvalid(0);
  m06_couplers_to_ps8_0_axi_periph_WREADY(0) <= M06_AXI_wready(0);
  m07_couplers_to_ps8_0_axi_periph_ARREADY(0) <= M07_AXI_arready(0);
  m07_couplers_to_ps8_0_axi_periph_AWREADY(0) <= M07_AXI_awready(0);
  m07_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0) <= M07_AXI_bresp(1 downto 0);
  m07_couplers_to_ps8_0_axi_periph_BVALID(0) <= M07_AXI_bvalid(0);
  m07_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0) <= M07_AXI_rdata(31 downto 0);
  m07_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0) <= M07_AXI_rresp(1 downto 0);
  m07_couplers_to_ps8_0_axi_periph_RVALID(0) <= M07_AXI_rvalid(0);
  m07_couplers_to_ps8_0_axi_periph_WREADY(0) <= M07_AXI_wready(0);
  m08_couplers_to_ps8_0_axi_periph_ARREADY(0) <= M08_AXI_arready(0);
  m08_couplers_to_ps8_0_axi_periph_AWREADY(0) <= M08_AXI_awready(0);
  m08_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0) <= M08_AXI_bresp(1 downto 0);
  m08_couplers_to_ps8_0_axi_periph_BVALID(0) <= M08_AXI_bvalid(0);
  m08_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0) <= M08_AXI_rdata(31 downto 0);
  m08_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0) <= M08_AXI_rresp(1 downto 0);
  m08_couplers_to_ps8_0_axi_periph_RVALID(0) <= M08_AXI_rvalid(0);
  m08_couplers_to_ps8_0_axi_periph_WREADY(0) <= M08_AXI_wready(0);
  m09_couplers_to_ps8_0_axi_periph_ARREADY <= M09_AXI_arready;
  m09_couplers_to_ps8_0_axi_periph_AWREADY <= M09_AXI_awready;
  m09_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0) <= M09_AXI_bresp(1 downto 0);
  m09_couplers_to_ps8_0_axi_periph_BVALID <= M09_AXI_bvalid;
  m09_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0) <= M09_AXI_rdata(31 downto 0);
  m09_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0) <= M09_AXI_rresp(1 downto 0);
  m09_couplers_to_ps8_0_axi_periph_RVALID <= M09_AXI_rvalid;
  m09_couplers_to_ps8_0_axi_periph_WREADY <= M09_AXI_wready;
  ps8_0_axi_periph_ACLK_net <= ACLK;
  ps8_0_axi_periph_ARESETN_net <= ARESETN;
  ps8_0_axi_periph_to_s00_couplers_ARADDR(39 downto 0) <= S00_AXI_araddr(39 downto 0);
  ps8_0_axi_periph_to_s00_couplers_ARBURST(1 downto 0) <= S00_AXI_arburst(1 downto 0);
  ps8_0_axi_periph_to_s00_couplers_ARCACHE(3 downto 0) <= S00_AXI_arcache(3 downto 0);
  ps8_0_axi_periph_to_s00_couplers_ARID(15 downto 0) <= S00_AXI_arid(15 downto 0);
  ps8_0_axi_periph_to_s00_couplers_ARLEN(7 downto 0) <= S00_AXI_arlen(7 downto 0);
  ps8_0_axi_periph_to_s00_couplers_ARLOCK <= S00_AXI_arlock;
  ps8_0_axi_periph_to_s00_couplers_ARPROT(2 downto 0) <= S00_AXI_arprot(2 downto 0);
  ps8_0_axi_periph_to_s00_couplers_ARQOS(3 downto 0) <= S00_AXI_arqos(3 downto 0);
  ps8_0_axi_periph_to_s00_couplers_ARSIZE(2 downto 0) <= S00_AXI_arsize(2 downto 0);
  ps8_0_axi_periph_to_s00_couplers_ARVALID <= S00_AXI_arvalid;
  ps8_0_axi_periph_to_s00_couplers_AWADDR(39 downto 0) <= S00_AXI_awaddr(39 downto 0);
  ps8_0_axi_periph_to_s00_couplers_AWBURST(1 downto 0) <= S00_AXI_awburst(1 downto 0);
  ps8_0_axi_periph_to_s00_couplers_AWCACHE(3 downto 0) <= S00_AXI_awcache(3 downto 0);
  ps8_0_axi_periph_to_s00_couplers_AWID(15 downto 0) <= S00_AXI_awid(15 downto 0);
  ps8_0_axi_periph_to_s00_couplers_AWLEN(7 downto 0) <= S00_AXI_awlen(7 downto 0);
  ps8_0_axi_periph_to_s00_couplers_AWLOCK <= S00_AXI_awlock;
  ps8_0_axi_periph_to_s00_couplers_AWPROT(2 downto 0) <= S00_AXI_awprot(2 downto 0);
  ps8_0_axi_periph_to_s00_couplers_AWQOS(3 downto 0) <= S00_AXI_awqos(3 downto 0);
  ps8_0_axi_periph_to_s00_couplers_AWSIZE(2 downto 0) <= S00_AXI_awsize(2 downto 0);
  ps8_0_axi_periph_to_s00_couplers_AWVALID <= S00_AXI_awvalid;
  ps8_0_axi_periph_to_s00_couplers_BREADY <= S00_AXI_bready;
  ps8_0_axi_periph_to_s00_couplers_RREADY <= S00_AXI_rready;
  ps8_0_axi_periph_to_s00_couplers_WDATA(127 downto 0) <= S00_AXI_wdata(127 downto 0);
  ps8_0_axi_periph_to_s00_couplers_WLAST <= S00_AXI_wlast;
  ps8_0_axi_periph_to_s00_couplers_WSTRB(15 downto 0) <= S00_AXI_wstrb(15 downto 0);
  ps8_0_axi_periph_to_s00_couplers_WVALID <= S00_AXI_wvalid;
  ps8_0_axi_periph_to_s01_couplers_ARADDR(39 downto 0) <= S01_AXI_araddr(39 downto 0);
  ps8_0_axi_periph_to_s01_couplers_ARBURST(1 downto 0) <= S01_AXI_arburst(1 downto 0);
  ps8_0_axi_periph_to_s01_couplers_ARCACHE(3 downto 0) <= S01_AXI_arcache(3 downto 0);
  ps8_0_axi_periph_to_s01_couplers_ARID(15 downto 0) <= S01_AXI_arid(15 downto 0);
  ps8_0_axi_periph_to_s01_couplers_ARLEN(7 downto 0) <= S01_AXI_arlen(7 downto 0);
  ps8_0_axi_periph_to_s01_couplers_ARLOCK <= S01_AXI_arlock;
  ps8_0_axi_periph_to_s01_couplers_ARPROT(2 downto 0) <= S01_AXI_arprot(2 downto 0);
  ps8_0_axi_periph_to_s01_couplers_ARQOS(3 downto 0) <= S01_AXI_arqos(3 downto 0);
  ps8_0_axi_periph_to_s01_couplers_ARSIZE(2 downto 0) <= S01_AXI_arsize(2 downto 0);
  ps8_0_axi_periph_to_s01_couplers_ARVALID <= S01_AXI_arvalid;
  ps8_0_axi_periph_to_s01_couplers_AWADDR(39 downto 0) <= S01_AXI_awaddr(39 downto 0);
  ps8_0_axi_periph_to_s01_couplers_AWBURST(1 downto 0) <= S01_AXI_awburst(1 downto 0);
  ps8_0_axi_periph_to_s01_couplers_AWCACHE(3 downto 0) <= S01_AXI_awcache(3 downto 0);
  ps8_0_axi_periph_to_s01_couplers_AWID(15 downto 0) <= S01_AXI_awid(15 downto 0);
  ps8_0_axi_periph_to_s01_couplers_AWLEN(7 downto 0) <= S01_AXI_awlen(7 downto 0);
  ps8_0_axi_periph_to_s01_couplers_AWLOCK <= S01_AXI_awlock;
  ps8_0_axi_periph_to_s01_couplers_AWPROT(2 downto 0) <= S01_AXI_awprot(2 downto 0);
  ps8_0_axi_periph_to_s01_couplers_AWQOS(3 downto 0) <= S01_AXI_awqos(3 downto 0);
  ps8_0_axi_periph_to_s01_couplers_AWSIZE(2 downto 0) <= S01_AXI_awsize(2 downto 0);
  ps8_0_axi_periph_to_s01_couplers_AWVALID <= S01_AXI_awvalid;
  ps8_0_axi_periph_to_s01_couplers_BREADY <= S01_AXI_bready;
  ps8_0_axi_periph_to_s01_couplers_RREADY <= S01_AXI_rready;
  ps8_0_axi_periph_to_s01_couplers_WDATA(127 downto 0) <= S01_AXI_wdata(127 downto 0);
  ps8_0_axi_periph_to_s01_couplers_WLAST <= S01_AXI_wlast;
  ps8_0_axi_periph_to_s01_couplers_WSTRB(15 downto 0) <= S01_AXI_wstrb(15 downto 0);
  ps8_0_axi_periph_to_s01_couplers_WVALID <= S01_AXI_wvalid;
m00_couplers: entity work.m00_couplers_imp_SG6IWI
     port map (
      M_ACLK => M00_ACLK_1,
      M_ARESETN => M00_ARESETN_1,
      M_AXI_araddr(39 downto 0) => m00_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0),
      M_AXI_arready => m00_couplers_to_ps8_0_axi_periph_ARREADY,
      M_AXI_arvalid => m00_couplers_to_ps8_0_axi_periph_ARVALID,
      M_AXI_awaddr(39 downto 0) => m00_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0),
      M_AXI_awready => m00_couplers_to_ps8_0_axi_periph_AWREADY,
      M_AXI_awvalid => m00_couplers_to_ps8_0_axi_periph_AWVALID,
      M_AXI_bready => m00_couplers_to_ps8_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m00_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m00_couplers_to_ps8_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m00_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m00_couplers_to_ps8_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m00_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m00_couplers_to_ps8_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m00_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m00_couplers_to_ps8_0_axi_periph_WREADY,
      M_AXI_wvalid => m00_couplers_to_ps8_0_axi_periph_WVALID,
      S_ACLK => ps8_0_axi_periph_ACLK_net,
      S_ARESETN => ps8_0_axi_periph_ARESETN_net,
      S_AXI_araddr(39 downto 0) => xbar_to_m00_couplers_ARADDR(39 downto 0),
      S_AXI_arready => xbar_to_m00_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m00_couplers_ARVALID(0),
      S_AXI_awaddr(39 downto 0) => xbar_to_m00_couplers_AWADDR(39 downto 0),
      S_AXI_awready => xbar_to_m00_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m00_couplers_AWVALID(0),
      S_AXI_bready => xbar_to_m00_couplers_BREADY(0),
      S_AXI_bresp(1 downto 0) => xbar_to_m00_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m00_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m00_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m00_couplers_RREADY(0),
      S_AXI_rresp(1 downto 0) => xbar_to_m00_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m00_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m00_couplers_WDATA(31 downto 0),
      S_AXI_wready => xbar_to_m00_couplers_WREADY,
      S_AXI_wvalid => xbar_to_m00_couplers_WVALID(0)
    );
m01_couplers: entity work.m01_couplers_imp_1X6EAI4
     port map (
      M_ACLK => M01_ACLK_1,
      M_ARESETN => M01_ARESETN_1,
      M_AXI_araddr(39 downto 0) => m01_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0),
      M_AXI_arready(0) => m01_couplers_to_ps8_0_axi_periph_ARREADY(0),
      M_AXI_arvalid(0) => m01_couplers_to_ps8_0_axi_periph_ARVALID(0),
      M_AXI_awaddr(39 downto 0) => m01_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0),
      M_AXI_awready(0) => m01_couplers_to_ps8_0_axi_periph_AWREADY(0),
      M_AXI_awvalid(0) => m01_couplers_to_ps8_0_axi_periph_AWVALID(0),
      M_AXI_bready(0) => m01_couplers_to_ps8_0_axi_periph_BREADY(0),
      M_AXI_bresp(1 downto 0) => m01_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid(0) => m01_couplers_to_ps8_0_axi_periph_BVALID(0),
      M_AXI_rdata(31 downto 0) => m01_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready(0) => m01_couplers_to_ps8_0_axi_periph_RREADY(0),
      M_AXI_rresp(1 downto 0) => m01_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid(0) => m01_couplers_to_ps8_0_axi_periph_RVALID(0),
      M_AXI_wdata(31 downto 0) => m01_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready(0) => m01_couplers_to_ps8_0_axi_periph_WREADY(0),
      M_AXI_wstrb(3 downto 0) => m01_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid(0) => m01_couplers_to_ps8_0_axi_periph_WVALID(0),
      S_ACLK => ps8_0_axi_periph_ACLK_net,
      S_ARESETN => ps8_0_axi_periph_ARESETN_net,
      S_AXI_araddr(39 downto 0) => xbar_to_m01_couplers_ARADDR(79 downto 40),
      S_AXI_arready(0) => xbar_to_m01_couplers_ARREADY(0),
      S_AXI_arvalid(0) => xbar_to_m01_couplers_ARVALID(1),
      S_AXI_awaddr(39 downto 0) => xbar_to_m01_couplers_AWADDR(79 downto 40),
      S_AXI_awready(0) => xbar_to_m01_couplers_AWREADY(0),
      S_AXI_awvalid(0) => xbar_to_m01_couplers_AWVALID(1),
      S_AXI_bready(0) => xbar_to_m01_couplers_BREADY(1),
      S_AXI_bresp(1 downto 0) => xbar_to_m01_couplers_BRESP(1 downto 0),
      S_AXI_bvalid(0) => xbar_to_m01_couplers_BVALID(0),
      S_AXI_rdata(31 downto 0) => xbar_to_m01_couplers_RDATA(31 downto 0),
      S_AXI_rready(0) => xbar_to_m01_couplers_RREADY(1),
      S_AXI_rresp(1 downto 0) => xbar_to_m01_couplers_RRESP(1 downto 0),
      S_AXI_rvalid(0) => xbar_to_m01_couplers_RVALID(0),
      S_AXI_wdata(31 downto 0) => xbar_to_m01_couplers_WDATA(63 downto 32),
      S_AXI_wready(0) => xbar_to_m01_couplers_WREADY(0),
      S_AXI_wstrb(3 downto 0) => xbar_to_m01_couplers_WSTRB(7 downto 4),
      S_AXI_wvalid(0) => xbar_to_m01_couplers_WVALID(1)
    );
m02_couplers: entity work.m02_couplers_imp_105IVDB
     port map (
      M_ACLK => M02_ACLK_1,
      M_ARESETN => M02_ARESETN_1,
      M_AXI_araddr(39 downto 0) => m02_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0),
      M_AXI_arready(0) => m02_couplers_to_ps8_0_axi_periph_ARREADY(0),
      M_AXI_arvalid(0) => m02_couplers_to_ps8_0_axi_periph_ARVALID(0),
      M_AXI_awaddr(39 downto 0) => m02_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0),
      M_AXI_awready(0) => m02_couplers_to_ps8_0_axi_periph_AWREADY(0),
      M_AXI_awvalid(0) => m02_couplers_to_ps8_0_axi_periph_AWVALID(0),
      M_AXI_bready(0) => m02_couplers_to_ps8_0_axi_periph_BREADY(0),
      M_AXI_bresp(1 downto 0) => m02_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid(0) => m02_couplers_to_ps8_0_axi_periph_BVALID(0),
      M_AXI_rdata(31 downto 0) => m02_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready(0) => m02_couplers_to_ps8_0_axi_periph_RREADY(0),
      M_AXI_rresp(1 downto 0) => m02_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid(0) => m02_couplers_to_ps8_0_axi_periph_RVALID(0),
      M_AXI_wdata(31 downto 0) => m02_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready(0) => m02_couplers_to_ps8_0_axi_periph_WREADY(0),
      M_AXI_wstrb(3 downto 0) => m02_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid(0) => m02_couplers_to_ps8_0_axi_periph_WVALID(0),
      S_ACLK => ps8_0_axi_periph_ACLK_net,
      S_ARESETN => ps8_0_axi_periph_ARESETN_net,
      S_AXI_araddr(39 downto 0) => xbar_to_m02_couplers_ARADDR(119 downto 80),
      S_AXI_arready(0) => xbar_to_m02_couplers_ARREADY(0),
      S_AXI_arvalid(0) => xbar_to_m02_couplers_ARVALID(2),
      S_AXI_awaddr(39 downto 0) => xbar_to_m02_couplers_AWADDR(119 downto 80),
      S_AXI_awready(0) => xbar_to_m02_couplers_AWREADY(0),
      S_AXI_awvalid(0) => xbar_to_m02_couplers_AWVALID(2),
      S_AXI_bready(0) => xbar_to_m02_couplers_BREADY(2),
      S_AXI_bresp(1 downto 0) => xbar_to_m02_couplers_BRESP(1 downto 0),
      S_AXI_bvalid(0) => xbar_to_m02_couplers_BVALID(0),
      S_AXI_rdata(31 downto 0) => xbar_to_m02_couplers_RDATA(31 downto 0),
      S_AXI_rready(0) => xbar_to_m02_couplers_RREADY(2),
      S_AXI_rresp(1 downto 0) => xbar_to_m02_couplers_RRESP(1 downto 0),
      S_AXI_rvalid(0) => xbar_to_m02_couplers_RVALID(0),
      S_AXI_wdata(31 downto 0) => xbar_to_m02_couplers_WDATA(95 downto 64),
      S_AXI_wready(0) => xbar_to_m02_couplers_WREADY(0),
      S_AXI_wstrb(3 downto 0) => xbar_to_m02_couplers_WSTRB(11 downto 8),
      S_AXI_wvalid(0) => xbar_to_m02_couplers_WVALID(2)
    );
m03_couplers: entity work.m03_couplers_imp_87J55D
     port map (
      M_ACLK => M03_ACLK_1,
      M_ARESETN => M03_ARESETN_1,
      M_AXI_araddr(39 downto 0) => m03_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0),
      M_AXI_arready => m03_couplers_to_ps8_0_axi_periph_ARREADY,
      M_AXI_arvalid => m03_couplers_to_ps8_0_axi_periph_ARVALID,
      M_AXI_awaddr(39 downto 0) => m03_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0),
      M_AXI_awready => m03_couplers_to_ps8_0_axi_periph_AWREADY,
      M_AXI_awvalid => m03_couplers_to_ps8_0_axi_periph_AWVALID,
      M_AXI_bready => m03_couplers_to_ps8_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m03_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m03_couplers_to_ps8_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m03_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m03_couplers_to_ps8_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m03_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m03_couplers_to_ps8_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m03_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m03_couplers_to_ps8_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m03_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m03_couplers_to_ps8_0_axi_periph_WVALID,
      S_ACLK => ps8_0_axi_periph_ACLK_net,
      S_ARESETN => ps8_0_axi_periph_ARESETN_net,
      S_AXI_araddr(39 downto 0) => xbar_to_m03_couplers_ARADDR(159 downto 120),
      S_AXI_arready => xbar_to_m03_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m03_couplers_ARVALID(3),
      S_AXI_awaddr(39 downto 0) => xbar_to_m03_couplers_AWADDR(159 downto 120),
      S_AXI_awready => xbar_to_m03_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m03_couplers_AWVALID(3),
      S_AXI_bready => xbar_to_m03_couplers_BREADY(3),
      S_AXI_bresp(1 downto 0) => xbar_to_m03_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m03_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m03_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m03_couplers_RREADY(3),
      S_AXI_rresp(1 downto 0) => xbar_to_m03_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m03_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m03_couplers_WDATA(127 downto 96),
      S_AXI_wready => xbar_to_m03_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m03_couplers_WSTRB(15 downto 12),
      S_AXI_wvalid => xbar_to_m03_couplers_WVALID(3)
    );
m04_couplers: entity work.m04_couplers_imp_WB4IH5
     port map (
      M_ACLK => M04_ACLK_1,
      M_ARESETN => M04_ARESETN_1,
      M_AXI_araddr(39 downto 0) => m04_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0),
      M_AXI_arprot(2 downto 0) => m04_couplers_to_ps8_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready(0) => m04_couplers_to_ps8_0_axi_periph_ARREADY(0),
      M_AXI_arvalid(0) => m04_couplers_to_ps8_0_axi_periph_ARVALID(0),
      M_AXI_awaddr(39 downto 0) => m04_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0),
      M_AXI_awprot(2 downto 0) => m04_couplers_to_ps8_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready(0) => m04_couplers_to_ps8_0_axi_periph_AWREADY(0),
      M_AXI_awvalid(0) => m04_couplers_to_ps8_0_axi_periph_AWVALID(0),
      M_AXI_bready(0) => m04_couplers_to_ps8_0_axi_periph_BREADY(0),
      M_AXI_bresp(1 downto 0) => m04_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid(0) => m04_couplers_to_ps8_0_axi_periph_BVALID(0),
      M_AXI_rdata(31 downto 0) => m04_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready(0) => m04_couplers_to_ps8_0_axi_periph_RREADY(0),
      M_AXI_rresp(1 downto 0) => m04_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid(0) => m04_couplers_to_ps8_0_axi_periph_RVALID(0),
      M_AXI_wdata(31 downto 0) => m04_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready(0) => m04_couplers_to_ps8_0_axi_periph_WREADY(0),
      M_AXI_wstrb(3 downto 0) => m04_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid(0) => m04_couplers_to_ps8_0_axi_periph_WVALID(0),
      S_ACLK => ps8_0_axi_periph_ACLK_net,
      S_ARESETN => ps8_0_axi_periph_ARESETN_net,
      S_AXI_araddr(39 downto 0) => xbar_to_m04_couplers_ARADDR(199 downto 160),
      S_AXI_arprot(2 downto 0) => xbar_to_m04_couplers_ARPROT(14 downto 12),
      S_AXI_arready(0) => xbar_to_m04_couplers_ARREADY(0),
      S_AXI_arvalid(0) => xbar_to_m04_couplers_ARVALID(4),
      S_AXI_awaddr(39 downto 0) => xbar_to_m04_couplers_AWADDR(199 downto 160),
      S_AXI_awprot(2 downto 0) => xbar_to_m04_couplers_AWPROT(14 downto 12),
      S_AXI_awready(0) => xbar_to_m04_couplers_AWREADY(0),
      S_AXI_awvalid(0) => xbar_to_m04_couplers_AWVALID(4),
      S_AXI_bready(0) => xbar_to_m04_couplers_BREADY(4),
      S_AXI_bresp(1 downto 0) => xbar_to_m04_couplers_BRESP(1 downto 0),
      S_AXI_bvalid(0) => xbar_to_m04_couplers_BVALID(0),
      S_AXI_rdata(31 downto 0) => xbar_to_m04_couplers_RDATA(31 downto 0),
      S_AXI_rready(0) => xbar_to_m04_couplers_RREADY(4),
      S_AXI_rresp(1 downto 0) => xbar_to_m04_couplers_RRESP(1 downto 0),
      S_AXI_rvalid(0) => xbar_to_m04_couplers_RVALID(0),
      S_AXI_wdata(31 downto 0) => xbar_to_m04_couplers_WDATA(159 downto 128),
      S_AXI_wready(0) => xbar_to_m04_couplers_WREADY(0),
      S_AXI_wstrb(3 downto 0) => xbar_to_m04_couplers_WSTRB(19 downto 16),
      S_AXI_wvalid(0) => xbar_to_m04_couplers_WVALID(4)
    );
m05_couplers: entity work.m05_couplers_imp_1TE0YS7
     port map (
      M_ACLK => M05_ACLK_1,
      M_ARESETN => M05_ARESETN_1,
      M_AXI_araddr(39 downto 0) => m05_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0),
      M_AXI_arready => m05_couplers_to_ps8_0_axi_periph_ARREADY,
      M_AXI_arvalid => m05_couplers_to_ps8_0_axi_periph_ARVALID,
      M_AXI_awaddr(39 downto 0) => m05_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0),
      M_AXI_awready => m05_couplers_to_ps8_0_axi_periph_AWREADY,
      M_AXI_awvalid => m05_couplers_to_ps8_0_axi_periph_AWVALID,
      M_AXI_bready => m05_couplers_to_ps8_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m05_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m05_couplers_to_ps8_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m05_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m05_couplers_to_ps8_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m05_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m05_couplers_to_ps8_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m05_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m05_couplers_to_ps8_0_axi_periph_WREADY,
      M_AXI_wvalid => m05_couplers_to_ps8_0_axi_periph_WVALID,
      S_ACLK => ps8_0_axi_periph_ACLK_net,
      S_ARESETN => ps8_0_axi_periph_ARESETN_net,
      S_AXI_araddr(39 downto 0) => xbar_to_m05_couplers_ARADDR(239 downto 200),
      S_AXI_arready => xbar_to_m05_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m05_couplers_ARVALID(5),
      S_AXI_awaddr(39 downto 0) => xbar_to_m05_couplers_AWADDR(239 downto 200),
      S_AXI_awready => xbar_to_m05_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m05_couplers_AWVALID(5),
      S_AXI_bready => xbar_to_m05_couplers_BREADY(5),
      S_AXI_bresp(1 downto 0) => xbar_to_m05_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m05_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m05_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m05_couplers_RREADY(5),
      S_AXI_rresp(1 downto 0) => xbar_to_m05_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m05_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m05_couplers_WDATA(191 downto 160),
      S_AXI_wready => xbar_to_m05_couplers_WREADY,
      S_AXI_wvalid => xbar_to_m05_couplers_WVALID(5)
    );
m06_couplers: entity work.m06_couplers_imp_145GNP0
     port map (
      M_ACLK => M06_ACLK_1,
      M_ARESETN => M06_ARESETN_1,
      M_AXI_araddr(39 downto 0) => m06_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0),
      M_AXI_arready(0) => m06_couplers_to_ps8_0_axi_periph_ARREADY(0),
      M_AXI_arvalid(0) => m06_couplers_to_ps8_0_axi_periph_ARVALID(0),
      M_AXI_awaddr(39 downto 0) => m06_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0),
      M_AXI_awready(0) => m06_couplers_to_ps8_0_axi_periph_AWREADY(0),
      M_AXI_awvalid(0) => m06_couplers_to_ps8_0_axi_periph_AWVALID(0),
      M_AXI_bready(0) => m06_couplers_to_ps8_0_axi_periph_BREADY(0),
      M_AXI_bresp(1 downto 0) => m06_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid(0) => m06_couplers_to_ps8_0_axi_periph_BVALID(0),
      M_AXI_rdata(31 downto 0) => m06_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready(0) => m06_couplers_to_ps8_0_axi_periph_RREADY(0),
      M_AXI_rresp(1 downto 0) => m06_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid(0) => m06_couplers_to_ps8_0_axi_periph_RVALID(0),
      M_AXI_wdata(31 downto 0) => m06_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready(0) => m06_couplers_to_ps8_0_axi_periph_WREADY(0),
      M_AXI_wstrb(3 downto 0) => m06_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid(0) => m06_couplers_to_ps8_0_axi_periph_WVALID(0),
      S_ACLK => ps8_0_axi_periph_ACLK_net,
      S_ARESETN => ps8_0_axi_periph_ARESETN_net,
      S_AXI_araddr(39 downto 0) => xbar_to_m06_couplers_ARADDR(279 downto 240),
      S_AXI_arready(0) => xbar_to_m06_couplers_ARREADY(0),
      S_AXI_arvalid(0) => xbar_to_m06_couplers_ARVALID(6),
      S_AXI_awaddr(39 downto 0) => xbar_to_m06_couplers_AWADDR(279 downto 240),
      S_AXI_awready(0) => xbar_to_m06_couplers_AWREADY(0),
      S_AXI_awvalid(0) => xbar_to_m06_couplers_AWVALID(6),
      S_AXI_bready(0) => xbar_to_m06_couplers_BREADY(6),
      S_AXI_bresp(1 downto 0) => xbar_to_m06_couplers_BRESP(1 downto 0),
      S_AXI_bvalid(0) => xbar_to_m06_couplers_BVALID(0),
      S_AXI_rdata(31 downto 0) => xbar_to_m06_couplers_RDATA(31 downto 0),
      S_AXI_rready(0) => xbar_to_m06_couplers_RREADY(6),
      S_AXI_rresp(1 downto 0) => xbar_to_m06_couplers_RRESP(1 downto 0),
      S_AXI_rvalid(0) => xbar_to_m06_couplers_RVALID(0),
      S_AXI_wdata(31 downto 0) => xbar_to_m06_couplers_WDATA(223 downto 192),
      S_AXI_wready(0) => xbar_to_m06_couplers_WREADY(0),
      S_AXI_wstrb(3 downto 0) => xbar_to_m06_couplers_WSTRB(27 downto 24),
      S_AXI_wvalid(0) => xbar_to_m06_couplers_WVALID(6)
    );
m07_couplers: entity work.m07_couplers_imp_4A60RU
     port map (
      M_ACLK => M07_ACLK_1,
      M_ARESETN => M07_ARESETN_1,
      M_AXI_araddr(39 downto 0) => m07_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0),
      M_AXI_arready(0) => m07_couplers_to_ps8_0_axi_periph_ARREADY(0),
      M_AXI_arvalid(0) => m07_couplers_to_ps8_0_axi_periph_ARVALID(0),
      M_AXI_awaddr(39 downto 0) => m07_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0),
      M_AXI_awready(0) => m07_couplers_to_ps8_0_axi_periph_AWREADY(0),
      M_AXI_awvalid(0) => m07_couplers_to_ps8_0_axi_periph_AWVALID(0),
      M_AXI_bready(0) => m07_couplers_to_ps8_0_axi_periph_BREADY(0),
      M_AXI_bresp(1 downto 0) => m07_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid(0) => m07_couplers_to_ps8_0_axi_periph_BVALID(0),
      M_AXI_rdata(31 downto 0) => m07_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready(0) => m07_couplers_to_ps8_0_axi_periph_RREADY(0),
      M_AXI_rresp(1 downto 0) => m07_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid(0) => m07_couplers_to_ps8_0_axi_periph_RVALID(0),
      M_AXI_wdata(31 downto 0) => m07_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready(0) => m07_couplers_to_ps8_0_axi_periph_WREADY(0),
      M_AXI_wstrb(3 downto 0) => m07_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid(0) => m07_couplers_to_ps8_0_axi_periph_WVALID(0),
      S_ACLK => ps8_0_axi_periph_ACLK_net,
      S_ARESETN => ps8_0_axi_periph_ARESETN_net,
      S_AXI_araddr(39 downto 0) => xbar_to_m07_couplers_ARADDR(319 downto 280),
      S_AXI_arready(0) => xbar_to_m07_couplers_ARREADY(0),
      S_AXI_arvalid(0) => xbar_to_m07_couplers_ARVALID(7),
      S_AXI_awaddr(39 downto 0) => xbar_to_m07_couplers_AWADDR(319 downto 280),
      S_AXI_awready(0) => xbar_to_m07_couplers_AWREADY(0),
      S_AXI_awvalid(0) => xbar_to_m07_couplers_AWVALID(7),
      S_AXI_bready(0) => xbar_to_m07_couplers_BREADY(7),
      S_AXI_bresp(1 downto 0) => xbar_to_m07_couplers_BRESP(1 downto 0),
      S_AXI_bvalid(0) => xbar_to_m07_couplers_BVALID(0),
      S_AXI_rdata(31 downto 0) => xbar_to_m07_couplers_RDATA(31 downto 0),
      S_AXI_rready(0) => xbar_to_m07_couplers_RREADY(7),
      S_AXI_rresp(1 downto 0) => xbar_to_m07_couplers_RRESP(1 downto 0),
      S_AXI_rvalid(0) => xbar_to_m07_couplers_RVALID(0),
      S_AXI_wdata(31 downto 0) => xbar_to_m07_couplers_WDATA(255 downto 224),
      S_AXI_wready(0) => xbar_to_m07_couplers_WREADY(0),
      S_AXI_wstrb(3 downto 0) => xbar_to_m07_couplers_WSTRB(31 downto 28),
      S_AXI_wvalid(0) => xbar_to_m07_couplers_WVALID(7)
    );
m08_couplers: entity work.m08_couplers_imp_IQ13YC
     port map (
      M_ACLK => M08_ACLK_1,
      M_ARESETN => M08_ARESETN_1,
      M_AXI_araddr(39 downto 0) => m08_couplers_to_ps8_0_axi_periph_ARADDR(39 downto 0),
      M_AXI_arready(0) => m08_couplers_to_ps8_0_axi_periph_ARREADY(0),
      M_AXI_arvalid(0) => m08_couplers_to_ps8_0_axi_periph_ARVALID(0),
      M_AXI_awaddr(39 downto 0) => m08_couplers_to_ps8_0_axi_periph_AWADDR(39 downto 0),
      M_AXI_awready(0) => m08_couplers_to_ps8_0_axi_periph_AWREADY(0),
      M_AXI_awvalid(0) => m08_couplers_to_ps8_0_axi_periph_AWVALID(0),
      M_AXI_bready(0) => m08_couplers_to_ps8_0_axi_periph_BREADY(0),
      M_AXI_bresp(1 downto 0) => m08_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid(0) => m08_couplers_to_ps8_0_axi_periph_BVALID(0),
      M_AXI_rdata(31 downto 0) => m08_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready(0) => m08_couplers_to_ps8_0_axi_periph_RREADY(0),
      M_AXI_rresp(1 downto 0) => m08_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid(0) => m08_couplers_to_ps8_0_axi_periph_RVALID(0),
      M_AXI_wdata(31 downto 0) => m08_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready(0) => m08_couplers_to_ps8_0_axi_periph_WREADY(0),
      M_AXI_wstrb(3 downto 0) => m08_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid(0) => m08_couplers_to_ps8_0_axi_periph_WVALID(0),
      S_ACLK => ps8_0_axi_periph_ACLK_net,
      S_ARESETN => ps8_0_axi_periph_ARESETN_net,
      S_AXI_araddr(39 downto 0) => xbar_to_m08_couplers_ARADDR(359 downto 320),
      S_AXI_arready(0) => xbar_to_m08_couplers_ARREADY(0),
      S_AXI_arvalid(0) => xbar_to_m08_couplers_ARVALID(8),
      S_AXI_awaddr(39 downto 0) => xbar_to_m08_couplers_AWADDR(359 downto 320),
      S_AXI_awready(0) => xbar_to_m08_couplers_AWREADY(0),
      S_AXI_awvalid(0) => xbar_to_m08_couplers_AWVALID(8),
      S_AXI_bready(0) => xbar_to_m08_couplers_BREADY(8),
      S_AXI_bresp(1 downto 0) => xbar_to_m08_couplers_BRESP(1 downto 0),
      S_AXI_bvalid(0) => xbar_to_m08_couplers_BVALID(0),
      S_AXI_rdata(31 downto 0) => xbar_to_m08_couplers_RDATA(31 downto 0),
      S_AXI_rready(0) => xbar_to_m08_couplers_RREADY(8),
      S_AXI_rresp(1 downto 0) => xbar_to_m08_couplers_RRESP(1 downto 0),
      S_AXI_rvalid(0) => xbar_to_m08_couplers_RVALID(0),
      S_AXI_wdata(31 downto 0) => xbar_to_m08_couplers_WDATA(287 downto 256),
      S_AXI_wready(0) => xbar_to_m08_couplers_WREADY(0),
      S_AXI_wstrb(3 downto 0) => xbar_to_m08_couplers_WSTRB(35 downto 32),
      S_AXI_wvalid(0) => xbar_to_m08_couplers_WVALID(8)
    );
m09_couplers: entity work.m09_couplers_imp_1P7ROII
     port map (
      M_ACLK => M09_ACLK_1,
      M_ARESETN => M09_ARESETN_1,
      M_AXI_araddr(10 downto 0) => m09_couplers_to_ps8_0_axi_periph_ARADDR(10 downto 0),
      M_AXI_arprot(2 downto 0) => m09_couplers_to_ps8_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m09_couplers_to_ps8_0_axi_periph_ARREADY,
      M_AXI_arvalid => m09_couplers_to_ps8_0_axi_periph_ARVALID,
      M_AXI_awaddr(10 downto 0) => m09_couplers_to_ps8_0_axi_periph_AWADDR(10 downto 0),
      M_AXI_awprot(2 downto 0) => m09_couplers_to_ps8_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m09_couplers_to_ps8_0_axi_periph_AWREADY,
      M_AXI_awvalid => m09_couplers_to_ps8_0_axi_periph_AWVALID,
      M_AXI_bready => m09_couplers_to_ps8_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m09_couplers_to_ps8_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m09_couplers_to_ps8_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m09_couplers_to_ps8_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m09_couplers_to_ps8_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m09_couplers_to_ps8_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m09_couplers_to_ps8_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m09_couplers_to_ps8_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m09_couplers_to_ps8_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m09_couplers_to_ps8_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m09_couplers_to_ps8_0_axi_periph_WVALID,
      S_ACLK => ps8_0_axi_periph_ACLK_net,
      S_ARESETN => ps8_0_axi_periph_ARESETN_net,
      S_AXI_araddr(39 downto 0) => xbar_to_m09_couplers_ARADDR(399 downto 360),
      S_AXI_arprot(2 downto 0) => xbar_to_m09_couplers_ARPROT(29 downto 27),
      S_AXI_arready => xbar_to_m09_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m09_couplers_ARVALID(9),
      S_AXI_awaddr(39 downto 0) => xbar_to_m09_couplers_AWADDR(399 downto 360),
      S_AXI_awprot(2 downto 0) => xbar_to_m09_couplers_AWPROT(29 downto 27),
      S_AXI_awready => xbar_to_m09_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m09_couplers_AWVALID(9),
      S_AXI_bready => xbar_to_m09_couplers_BREADY(9),
      S_AXI_bresp(1 downto 0) => xbar_to_m09_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m09_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m09_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m09_couplers_RREADY(9),
      S_AXI_rresp(1 downto 0) => xbar_to_m09_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m09_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m09_couplers_WDATA(319 downto 288),
      S_AXI_wready => xbar_to_m09_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m09_couplers_WSTRB(39 downto 36),
      S_AXI_wvalid => xbar_to_m09_couplers_WVALID(9)
    );
s00_couplers: entity work.s00_couplers_imp_12FSI76
     port map (
      M_ACLK => ps8_0_axi_periph_ACLK_net,
      M_ARESETN => ps8_0_axi_periph_ARESETN_net,
      M_AXI_araddr(39 downto 0) => s00_couplers_to_xbar_ARADDR(39 downto 0),
      M_AXI_arprot(2 downto 0) => s00_couplers_to_xbar_ARPROT(2 downto 0),
      M_AXI_arready => s00_couplers_to_xbar_ARREADY(0),
      M_AXI_arvalid => s00_couplers_to_xbar_ARVALID,
      M_AXI_awaddr(39 downto 0) => s00_couplers_to_xbar_AWADDR(39 downto 0),
      M_AXI_awprot(2 downto 0) => s00_couplers_to_xbar_AWPROT(2 downto 0),
      M_AXI_awready => s00_couplers_to_xbar_AWREADY(0),
      M_AXI_awvalid => s00_couplers_to_xbar_AWVALID,
      M_AXI_bready => s00_couplers_to_xbar_BREADY,
      M_AXI_bresp(1 downto 0) => s00_couplers_to_xbar_BRESP(1 downto 0),
      M_AXI_bvalid => s00_couplers_to_xbar_BVALID(0),
      M_AXI_rdata(31 downto 0) => s00_couplers_to_xbar_RDATA(31 downto 0),
      M_AXI_rready => s00_couplers_to_xbar_RREADY,
      M_AXI_rresp(1 downto 0) => s00_couplers_to_xbar_RRESP(1 downto 0),
      M_AXI_rvalid => s00_couplers_to_xbar_RVALID(0),
      M_AXI_wdata(31 downto 0) => s00_couplers_to_xbar_WDATA(31 downto 0),
      M_AXI_wready => s00_couplers_to_xbar_WREADY(0),
      M_AXI_wstrb(3 downto 0) => s00_couplers_to_xbar_WSTRB(3 downto 0),
      M_AXI_wvalid => s00_couplers_to_xbar_WVALID,
      S_ACLK => S00_ACLK_1,
      S_ARESETN => S00_ARESETN_1,
      S_AXI_araddr(39 downto 0) => ps8_0_axi_periph_to_s00_couplers_ARADDR(39 downto 0),
      S_AXI_arburst(1 downto 0) => ps8_0_axi_periph_to_s00_couplers_ARBURST(1 downto 0),
      S_AXI_arcache(3 downto 0) => ps8_0_axi_periph_to_s00_couplers_ARCACHE(3 downto 0),
      S_AXI_arid(15 downto 0) => ps8_0_axi_periph_to_s00_couplers_ARID(15 downto 0),
      S_AXI_arlen(7 downto 0) => ps8_0_axi_periph_to_s00_couplers_ARLEN(7 downto 0),
      S_AXI_arlock => ps8_0_axi_periph_to_s00_couplers_ARLOCK,
      S_AXI_arprot(2 downto 0) => ps8_0_axi_periph_to_s00_couplers_ARPROT(2 downto 0),
      S_AXI_arqos(3 downto 0) => ps8_0_axi_periph_to_s00_couplers_ARQOS(3 downto 0),
      S_AXI_arready => ps8_0_axi_periph_to_s00_couplers_ARREADY,
      S_AXI_arsize(2 downto 0) => ps8_0_axi_periph_to_s00_couplers_ARSIZE(2 downto 0),
      S_AXI_arvalid => ps8_0_axi_periph_to_s00_couplers_ARVALID,
      S_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_to_s00_couplers_AWADDR(39 downto 0),
      S_AXI_awburst(1 downto 0) => ps8_0_axi_periph_to_s00_couplers_AWBURST(1 downto 0),
      S_AXI_awcache(3 downto 0) => ps8_0_axi_periph_to_s00_couplers_AWCACHE(3 downto 0),
      S_AXI_awid(15 downto 0) => ps8_0_axi_periph_to_s00_couplers_AWID(15 downto 0),
      S_AXI_awlen(7 downto 0) => ps8_0_axi_periph_to_s00_couplers_AWLEN(7 downto 0),
      S_AXI_awlock => ps8_0_axi_periph_to_s00_couplers_AWLOCK,
      S_AXI_awprot(2 downto 0) => ps8_0_axi_periph_to_s00_couplers_AWPROT(2 downto 0),
      S_AXI_awqos(3 downto 0) => ps8_0_axi_periph_to_s00_couplers_AWQOS(3 downto 0),
      S_AXI_awready => ps8_0_axi_periph_to_s00_couplers_AWREADY,
      S_AXI_awsize(2 downto 0) => ps8_0_axi_periph_to_s00_couplers_AWSIZE(2 downto 0),
      S_AXI_awvalid => ps8_0_axi_periph_to_s00_couplers_AWVALID,
      S_AXI_bid(15 downto 0) => ps8_0_axi_periph_to_s00_couplers_BID(15 downto 0),
      S_AXI_bready => ps8_0_axi_periph_to_s00_couplers_BREADY,
      S_AXI_bresp(1 downto 0) => ps8_0_axi_periph_to_s00_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => ps8_0_axi_periph_to_s00_couplers_BVALID,
      S_AXI_rdata(127 downto 0) => ps8_0_axi_periph_to_s00_couplers_RDATA(127 downto 0),
      S_AXI_rid(15 downto 0) => ps8_0_axi_periph_to_s00_couplers_RID(15 downto 0),
      S_AXI_rlast => ps8_0_axi_periph_to_s00_couplers_RLAST,
      S_AXI_rready => ps8_0_axi_periph_to_s00_couplers_RREADY,
      S_AXI_rresp(1 downto 0) => ps8_0_axi_periph_to_s00_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => ps8_0_axi_periph_to_s00_couplers_RVALID,
      S_AXI_wdata(127 downto 0) => ps8_0_axi_periph_to_s00_couplers_WDATA(127 downto 0),
      S_AXI_wlast => ps8_0_axi_periph_to_s00_couplers_WLAST,
      S_AXI_wready => ps8_0_axi_periph_to_s00_couplers_WREADY,
      S_AXI_wstrb(15 downto 0) => ps8_0_axi_periph_to_s00_couplers_WSTRB(15 downto 0),
      S_AXI_wvalid => ps8_0_axi_periph_to_s00_couplers_WVALID
    );
s01_couplers: entity work.s01_couplers_imp_5X0UYK
     port map (
      M_ACLK => ps8_0_axi_periph_ACLK_net,
      M_ARESETN => ps8_0_axi_periph_ARESETN_net,
      M_AXI_araddr(39 downto 0) => s01_couplers_to_xbar_ARADDR(39 downto 0),
      M_AXI_arprot(2 downto 0) => s01_couplers_to_xbar_ARPROT(2 downto 0),
      M_AXI_arready => s01_couplers_to_xbar_ARREADY(1),
      M_AXI_arvalid => s01_couplers_to_xbar_ARVALID,
      M_AXI_awaddr(39 downto 0) => s01_couplers_to_xbar_AWADDR(39 downto 0),
      M_AXI_awprot(2 downto 0) => s01_couplers_to_xbar_AWPROT(2 downto 0),
      M_AXI_awready => s01_couplers_to_xbar_AWREADY(1),
      M_AXI_awvalid => s01_couplers_to_xbar_AWVALID,
      M_AXI_bready => s01_couplers_to_xbar_BREADY,
      M_AXI_bresp(1 downto 0) => s01_couplers_to_xbar_BRESP(3 downto 2),
      M_AXI_bvalid => s01_couplers_to_xbar_BVALID(1),
      M_AXI_rdata(31 downto 0) => s01_couplers_to_xbar_RDATA(63 downto 32),
      M_AXI_rready => s01_couplers_to_xbar_RREADY,
      M_AXI_rresp(1 downto 0) => s01_couplers_to_xbar_RRESP(3 downto 2),
      M_AXI_rvalid => s01_couplers_to_xbar_RVALID(1),
      M_AXI_wdata(31 downto 0) => s01_couplers_to_xbar_WDATA(31 downto 0),
      M_AXI_wready => s01_couplers_to_xbar_WREADY(1),
      M_AXI_wstrb(3 downto 0) => s01_couplers_to_xbar_WSTRB(3 downto 0),
      M_AXI_wvalid => s01_couplers_to_xbar_WVALID,
      S_ACLK => S01_ACLK_1,
      S_ARESETN => S01_ARESETN_1,
      S_AXI_araddr(39 downto 0) => ps8_0_axi_periph_to_s01_couplers_ARADDR(39 downto 0),
      S_AXI_arburst(1 downto 0) => ps8_0_axi_periph_to_s01_couplers_ARBURST(1 downto 0),
      S_AXI_arcache(3 downto 0) => ps8_0_axi_periph_to_s01_couplers_ARCACHE(3 downto 0),
      S_AXI_arid(15 downto 0) => ps8_0_axi_periph_to_s01_couplers_ARID(15 downto 0),
      S_AXI_arlen(7 downto 0) => ps8_0_axi_periph_to_s01_couplers_ARLEN(7 downto 0),
      S_AXI_arlock => ps8_0_axi_periph_to_s01_couplers_ARLOCK,
      S_AXI_arprot(2 downto 0) => ps8_0_axi_periph_to_s01_couplers_ARPROT(2 downto 0),
      S_AXI_arqos(3 downto 0) => ps8_0_axi_periph_to_s01_couplers_ARQOS(3 downto 0),
      S_AXI_arready => ps8_0_axi_periph_to_s01_couplers_ARREADY,
      S_AXI_arsize(2 downto 0) => ps8_0_axi_periph_to_s01_couplers_ARSIZE(2 downto 0),
      S_AXI_arvalid => ps8_0_axi_periph_to_s01_couplers_ARVALID,
      S_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_to_s01_couplers_AWADDR(39 downto 0),
      S_AXI_awburst(1 downto 0) => ps8_0_axi_periph_to_s01_couplers_AWBURST(1 downto 0),
      S_AXI_awcache(3 downto 0) => ps8_0_axi_periph_to_s01_couplers_AWCACHE(3 downto 0),
      S_AXI_awid(15 downto 0) => ps8_0_axi_periph_to_s01_couplers_AWID(15 downto 0),
      S_AXI_awlen(7 downto 0) => ps8_0_axi_periph_to_s01_couplers_AWLEN(7 downto 0),
      S_AXI_awlock => ps8_0_axi_periph_to_s01_couplers_AWLOCK,
      S_AXI_awprot(2 downto 0) => ps8_0_axi_periph_to_s01_couplers_AWPROT(2 downto 0),
      S_AXI_awqos(3 downto 0) => ps8_0_axi_periph_to_s01_couplers_AWQOS(3 downto 0),
      S_AXI_awready => ps8_0_axi_periph_to_s01_couplers_AWREADY,
      S_AXI_awsize(2 downto 0) => ps8_0_axi_periph_to_s01_couplers_AWSIZE(2 downto 0),
      S_AXI_awvalid => ps8_0_axi_periph_to_s01_couplers_AWVALID,
      S_AXI_bid(15 downto 0) => ps8_0_axi_periph_to_s01_couplers_BID(15 downto 0),
      S_AXI_bready => ps8_0_axi_periph_to_s01_couplers_BREADY,
      S_AXI_bresp(1 downto 0) => ps8_0_axi_periph_to_s01_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => ps8_0_axi_periph_to_s01_couplers_BVALID,
      S_AXI_rdata(127 downto 0) => ps8_0_axi_periph_to_s01_couplers_RDATA(127 downto 0),
      S_AXI_rid(15 downto 0) => ps8_0_axi_periph_to_s01_couplers_RID(15 downto 0),
      S_AXI_rlast => ps8_0_axi_periph_to_s01_couplers_RLAST,
      S_AXI_rready => ps8_0_axi_periph_to_s01_couplers_RREADY,
      S_AXI_rresp(1 downto 0) => ps8_0_axi_periph_to_s01_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => ps8_0_axi_periph_to_s01_couplers_RVALID,
      S_AXI_wdata(127 downto 0) => ps8_0_axi_periph_to_s01_couplers_WDATA(127 downto 0),
      S_AXI_wlast => ps8_0_axi_periph_to_s01_couplers_WLAST,
      S_AXI_wready => ps8_0_axi_periph_to_s01_couplers_WREADY,
      S_AXI_wstrb(15 downto 0) => ps8_0_axi_periph_to_s01_couplers_WSTRB(15 downto 0),
      S_AXI_wvalid => ps8_0_axi_periph_to_s01_couplers_WVALID
    );
xbar: component kv260_video_xbar_0
     port map (
      aclk => ps8_0_axi_periph_ACLK_net,
      aresetn => ps8_0_axi_periph_ARESETN_net,
      m_axi_araddr(399 downto 360) => xbar_to_m09_couplers_ARADDR(399 downto 360),
      m_axi_araddr(359 downto 320) => xbar_to_m08_couplers_ARADDR(359 downto 320),
      m_axi_araddr(319 downto 280) => xbar_to_m07_couplers_ARADDR(319 downto 280),
      m_axi_araddr(279 downto 240) => xbar_to_m06_couplers_ARADDR(279 downto 240),
      m_axi_araddr(239 downto 200) => xbar_to_m05_couplers_ARADDR(239 downto 200),
      m_axi_araddr(199 downto 160) => xbar_to_m04_couplers_ARADDR(199 downto 160),
      m_axi_araddr(159 downto 120) => xbar_to_m03_couplers_ARADDR(159 downto 120),
      m_axi_araddr(119 downto 80) => xbar_to_m02_couplers_ARADDR(119 downto 80),
      m_axi_araddr(79 downto 40) => xbar_to_m01_couplers_ARADDR(79 downto 40),
      m_axi_araddr(39 downto 0) => xbar_to_m00_couplers_ARADDR(39 downto 0),
      m_axi_arprot(29 downto 27) => xbar_to_m09_couplers_ARPROT(29 downto 27),
      m_axi_arprot(26 downto 15) => NLW_xbar_m_axi_arprot_UNCONNECTED(26 downto 15),
      m_axi_arprot(14 downto 12) => xbar_to_m04_couplers_ARPROT(14 downto 12),
      m_axi_arprot(11 downto 0) => NLW_xbar_m_axi_arprot_UNCONNECTED(11 downto 0),
      m_axi_arready(9) => xbar_to_m09_couplers_ARREADY,
      m_axi_arready(8) => xbar_to_m08_couplers_ARREADY(0),
      m_axi_arready(7) => xbar_to_m07_couplers_ARREADY(0),
      m_axi_arready(6) => xbar_to_m06_couplers_ARREADY(0),
      m_axi_arready(5) => xbar_to_m05_couplers_ARREADY,
      m_axi_arready(4) => xbar_to_m04_couplers_ARREADY(0),
      m_axi_arready(3) => xbar_to_m03_couplers_ARREADY,
      m_axi_arready(2) => xbar_to_m02_couplers_ARREADY(0),
      m_axi_arready(1) => xbar_to_m01_couplers_ARREADY(0),
      m_axi_arready(0) => xbar_to_m00_couplers_ARREADY,
      m_axi_arvalid(9) => xbar_to_m09_couplers_ARVALID(9),
      m_axi_arvalid(8) => xbar_to_m08_couplers_ARVALID(8),
      m_axi_arvalid(7) => xbar_to_m07_couplers_ARVALID(7),
      m_axi_arvalid(6) => xbar_to_m06_couplers_ARVALID(6),
      m_axi_arvalid(5) => xbar_to_m05_couplers_ARVALID(5),
      m_axi_arvalid(4) => xbar_to_m04_couplers_ARVALID(4),
      m_axi_arvalid(3) => xbar_to_m03_couplers_ARVALID(3),
      m_axi_arvalid(2) => xbar_to_m02_couplers_ARVALID(2),
      m_axi_arvalid(1) => xbar_to_m01_couplers_ARVALID(1),
      m_axi_arvalid(0) => xbar_to_m00_couplers_ARVALID(0),
      m_axi_awaddr(399 downto 360) => xbar_to_m09_couplers_AWADDR(399 downto 360),
      m_axi_awaddr(359 downto 320) => xbar_to_m08_couplers_AWADDR(359 downto 320),
      m_axi_awaddr(319 downto 280) => xbar_to_m07_couplers_AWADDR(319 downto 280),
      m_axi_awaddr(279 downto 240) => xbar_to_m06_couplers_AWADDR(279 downto 240),
      m_axi_awaddr(239 downto 200) => xbar_to_m05_couplers_AWADDR(239 downto 200),
      m_axi_awaddr(199 downto 160) => xbar_to_m04_couplers_AWADDR(199 downto 160),
      m_axi_awaddr(159 downto 120) => xbar_to_m03_couplers_AWADDR(159 downto 120),
      m_axi_awaddr(119 downto 80) => xbar_to_m02_couplers_AWADDR(119 downto 80),
      m_axi_awaddr(79 downto 40) => xbar_to_m01_couplers_AWADDR(79 downto 40),
      m_axi_awaddr(39 downto 0) => xbar_to_m00_couplers_AWADDR(39 downto 0),
      m_axi_awprot(29 downto 27) => xbar_to_m09_couplers_AWPROT(29 downto 27),
      m_axi_awprot(26 downto 15) => NLW_xbar_m_axi_awprot_UNCONNECTED(26 downto 15),
      m_axi_awprot(14 downto 12) => xbar_to_m04_couplers_AWPROT(14 downto 12),
      m_axi_awprot(11 downto 0) => NLW_xbar_m_axi_awprot_UNCONNECTED(11 downto 0),
      m_axi_awready(9) => xbar_to_m09_couplers_AWREADY,
      m_axi_awready(8) => xbar_to_m08_couplers_AWREADY(0),
      m_axi_awready(7) => xbar_to_m07_couplers_AWREADY(0),
      m_axi_awready(6) => xbar_to_m06_couplers_AWREADY(0),
      m_axi_awready(5) => xbar_to_m05_couplers_AWREADY,
      m_axi_awready(4) => xbar_to_m04_couplers_AWREADY(0),
      m_axi_awready(3) => xbar_to_m03_couplers_AWREADY,
      m_axi_awready(2) => xbar_to_m02_couplers_AWREADY(0),
      m_axi_awready(1) => xbar_to_m01_couplers_AWREADY(0),
      m_axi_awready(0) => xbar_to_m00_couplers_AWREADY,
      m_axi_awvalid(9) => xbar_to_m09_couplers_AWVALID(9),
      m_axi_awvalid(8) => xbar_to_m08_couplers_AWVALID(8),
      m_axi_awvalid(7) => xbar_to_m07_couplers_AWVALID(7),
      m_axi_awvalid(6) => xbar_to_m06_couplers_AWVALID(6),
      m_axi_awvalid(5) => xbar_to_m05_couplers_AWVALID(5),
      m_axi_awvalid(4) => xbar_to_m04_couplers_AWVALID(4),
      m_axi_awvalid(3) => xbar_to_m03_couplers_AWVALID(3),
      m_axi_awvalid(2) => xbar_to_m02_couplers_AWVALID(2),
      m_axi_awvalid(1) => xbar_to_m01_couplers_AWVALID(1),
      m_axi_awvalid(0) => xbar_to_m00_couplers_AWVALID(0),
      m_axi_bready(9) => xbar_to_m09_couplers_BREADY(9),
      m_axi_bready(8) => xbar_to_m08_couplers_BREADY(8),
      m_axi_bready(7) => xbar_to_m07_couplers_BREADY(7),
      m_axi_bready(6) => xbar_to_m06_couplers_BREADY(6),
      m_axi_bready(5) => xbar_to_m05_couplers_BREADY(5),
      m_axi_bready(4) => xbar_to_m04_couplers_BREADY(4),
      m_axi_bready(3) => xbar_to_m03_couplers_BREADY(3),
      m_axi_bready(2) => xbar_to_m02_couplers_BREADY(2),
      m_axi_bready(1) => xbar_to_m01_couplers_BREADY(1),
      m_axi_bready(0) => xbar_to_m00_couplers_BREADY(0),
      m_axi_bresp(19 downto 18) => xbar_to_m09_couplers_BRESP(1 downto 0),
      m_axi_bresp(17 downto 16) => xbar_to_m08_couplers_BRESP(1 downto 0),
      m_axi_bresp(15 downto 14) => xbar_to_m07_couplers_BRESP(1 downto 0),
      m_axi_bresp(13 downto 12) => xbar_to_m06_couplers_BRESP(1 downto 0),
      m_axi_bresp(11 downto 10) => xbar_to_m05_couplers_BRESP(1 downto 0),
      m_axi_bresp(9 downto 8) => xbar_to_m04_couplers_BRESP(1 downto 0),
      m_axi_bresp(7 downto 6) => xbar_to_m03_couplers_BRESP(1 downto 0),
      m_axi_bresp(5 downto 4) => xbar_to_m02_couplers_BRESP(1 downto 0),
      m_axi_bresp(3 downto 2) => xbar_to_m01_couplers_BRESP(1 downto 0),
      m_axi_bresp(1 downto 0) => xbar_to_m00_couplers_BRESP(1 downto 0),
      m_axi_bvalid(9) => xbar_to_m09_couplers_BVALID,
      m_axi_bvalid(8) => xbar_to_m08_couplers_BVALID(0),
      m_axi_bvalid(7) => xbar_to_m07_couplers_BVALID(0),
      m_axi_bvalid(6) => xbar_to_m06_couplers_BVALID(0),
      m_axi_bvalid(5) => xbar_to_m05_couplers_BVALID,
      m_axi_bvalid(4) => xbar_to_m04_couplers_BVALID(0),
      m_axi_bvalid(3) => xbar_to_m03_couplers_BVALID,
      m_axi_bvalid(2) => xbar_to_m02_couplers_BVALID(0),
      m_axi_bvalid(1) => xbar_to_m01_couplers_BVALID(0),
      m_axi_bvalid(0) => xbar_to_m00_couplers_BVALID,
      m_axi_rdata(319 downto 288) => xbar_to_m09_couplers_RDATA(31 downto 0),
      m_axi_rdata(287 downto 256) => xbar_to_m08_couplers_RDATA(31 downto 0),
      m_axi_rdata(255 downto 224) => xbar_to_m07_couplers_RDATA(31 downto 0),
      m_axi_rdata(223 downto 192) => xbar_to_m06_couplers_RDATA(31 downto 0),
      m_axi_rdata(191 downto 160) => xbar_to_m05_couplers_RDATA(31 downto 0),
      m_axi_rdata(159 downto 128) => xbar_to_m04_couplers_RDATA(31 downto 0),
      m_axi_rdata(127 downto 96) => xbar_to_m03_couplers_RDATA(31 downto 0),
      m_axi_rdata(95 downto 64) => xbar_to_m02_couplers_RDATA(31 downto 0),
      m_axi_rdata(63 downto 32) => xbar_to_m01_couplers_RDATA(31 downto 0),
      m_axi_rdata(31 downto 0) => xbar_to_m00_couplers_RDATA(31 downto 0),
      m_axi_rready(9) => xbar_to_m09_couplers_RREADY(9),
      m_axi_rready(8) => xbar_to_m08_couplers_RREADY(8),
      m_axi_rready(7) => xbar_to_m07_couplers_RREADY(7),
      m_axi_rready(6) => xbar_to_m06_couplers_RREADY(6),
      m_axi_rready(5) => xbar_to_m05_couplers_RREADY(5),
      m_axi_rready(4) => xbar_to_m04_couplers_RREADY(4),
      m_axi_rready(3) => xbar_to_m03_couplers_RREADY(3),
      m_axi_rready(2) => xbar_to_m02_couplers_RREADY(2),
      m_axi_rready(1) => xbar_to_m01_couplers_RREADY(1),
      m_axi_rready(0) => xbar_to_m00_couplers_RREADY(0),
      m_axi_rresp(19 downto 18) => xbar_to_m09_couplers_RRESP(1 downto 0),
      m_axi_rresp(17 downto 16) => xbar_to_m08_couplers_RRESP(1 downto 0),
      m_axi_rresp(15 downto 14) => xbar_to_m07_couplers_RRESP(1 downto 0),
      m_axi_rresp(13 downto 12) => xbar_to_m06_couplers_RRESP(1 downto 0),
      m_axi_rresp(11 downto 10) => xbar_to_m05_couplers_RRESP(1 downto 0),
      m_axi_rresp(9 downto 8) => xbar_to_m04_couplers_RRESP(1 downto 0),
      m_axi_rresp(7 downto 6) => xbar_to_m03_couplers_RRESP(1 downto 0),
      m_axi_rresp(5 downto 4) => xbar_to_m02_couplers_RRESP(1 downto 0),
      m_axi_rresp(3 downto 2) => xbar_to_m01_couplers_RRESP(1 downto 0),
      m_axi_rresp(1 downto 0) => xbar_to_m00_couplers_RRESP(1 downto 0),
      m_axi_rvalid(9) => xbar_to_m09_couplers_RVALID,
      m_axi_rvalid(8) => xbar_to_m08_couplers_RVALID(0),
      m_axi_rvalid(7) => xbar_to_m07_couplers_RVALID(0),
      m_axi_rvalid(6) => xbar_to_m06_couplers_RVALID(0),
      m_axi_rvalid(5) => xbar_to_m05_couplers_RVALID,
      m_axi_rvalid(4) => xbar_to_m04_couplers_RVALID(0),
      m_axi_rvalid(3) => xbar_to_m03_couplers_RVALID,
      m_axi_rvalid(2) => xbar_to_m02_couplers_RVALID(0),
      m_axi_rvalid(1) => xbar_to_m01_couplers_RVALID(0),
      m_axi_rvalid(0) => xbar_to_m00_couplers_RVALID,
      m_axi_wdata(319 downto 288) => xbar_to_m09_couplers_WDATA(319 downto 288),
      m_axi_wdata(287 downto 256) => xbar_to_m08_couplers_WDATA(287 downto 256),
      m_axi_wdata(255 downto 224) => xbar_to_m07_couplers_WDATA(255 downto 224),
      m_axi_wdata(223 downto 192) => xbar_to_m06_couplers_WDATA(223 downto 192),
      m_axi_wdata(191 downto 160) => xbar_to_m05_couplers_WDATA(191 downto 160),
      m_axi_wdata(159 downto 128) => xbar_to_m04_couplers_WDATA(159 downto 128),
      m_axi_wdata(127 downto 96) => xbar_to_m03_couplers_WDATA(127 downto 96),
      m_axi_wdata(95 downto 64) => xbar_to_m02_couplers_WDATA(95 downto 64),
      m_axi_wdata(63 downto 32) => xbar_to_m01_couplers_WDATA(63 downto 32),
      m_axi_wdata(31 downto 0) => xbar_to_m00_couplers_WDATA(31 downto 0),
      m_axi_wready(9) => xbar_to_m09_couplers_WREADY,
      m_axi_wready(8) => xbar_to_m08_couplers_WREADY(0),
      m_axi_wready(7) => xbar_to_m07_couplers_WREADY(0),
      m_axi_wready(6) => xbar_to_m06_couplers_WREADY(0),
      m_axi_wready(5) => xbar_to_m05_couplers_WREADY,
      m_axi_wready(4) => xbar_to_m04_couplers_WREADY(0),
      m_axi_wready(3) => xbar_to_m03_couplers_WREADY,
      m_axi_wready(2) => xbar_to_m02_couplers_WREADY(0),
      m_axi_wready(1) => xbar_to_m01_couplers_WREADY(0),
      m_axi_wready(0) => xbar_to_m00_couplers_WREADY,
      m_axi_wstrb(39 downto 36) => xbar_to_m09_couplers_WSTRB(39 downto 36),
      m_axi_wstrb(35 downto 32) => xbar_to_m08_couplers_WSTRB(35 downto 32),
      m_axi_wstrb(31 downto 28) => xbar_to_m07_couplers_WSTRB(31 downto 28),
      m_axi_wstrb(27 downto 24) => xbar_to_m06_couplers_WSTRB(27 downto 24),
      m_axi_wstrb(23 downto 20) => NLW_xbar_m_axi_wstrb_UNCONNECTED(23 downto 20),
      m_axi_wstrb(19 downto 16) => xbar_to_m04_couplers_WSTRB(19 downto 16),
      m_axi_wstrb(15 downto 12) => xbar_to_m03_couplers_WSTRB(15 downto 12),
      m_axi_wstrb(11 downto 8) => xbar_to_m02_couplers_WSTRB(11 downto 8),
      m_axi_wstrb(7 downto 4) => xbar_to_m01_couplers_WSTRB(7 downto 4),
      m_axi_wstrb(3 downto 0) => NLW_xbar_m_axi_wstrb_UNCONNECTED(3 downto 0),
      m_axi_wvalid(9) => xbar_to_m09_couplers_WVALID(9),
      m_axi_wvalid(8) => xbar_to_m08_couplers_WVALID(8),
      m_axi_wvalid(7) => xbar_to_m07_couplers_WVALID(7),
      m_axi_wvalid(6) => xbar_to_m06_couplers_WVALID(6),
      m_axi_wvalid(5) => xbar_to_m05_couplers_WVALID(5),
      m_axi_wvalid(4) => xbar_to_m04_couplers_WVALID(4),
      m_axi_wvalid(3) => xbar_to_m03_couplers_WVALID(3),
      m_axi_wvalid(2) => xbar_to_m02_couplers_WVALID(2),
      m_axi_wvalid(1) => xbar_to_m01_couplers_WVALID(1),
      m_axi_wvalid(0) => xbar_to_m00_couplers_WVALID(0),
      s_axi_araddr(79 downto 40) => s01_couplers_to_xbar_ARADDR(39 downto 0),
      s_axi_araddr(39 downto 0) => s00_couplers_to_xbar_ARADDR(39 downto 0),
      s_axi_arprot(5 downto 3) => s01_couplers_to_xbar_ARPROT(2 downto 0),
      s_axi_arprot(2 downto 0) => s00_couplers_to_xbar_ARPROT(2 downto 0),
      s_axi_arready(1) => s01_couplers_to_xbar_ARREADY(1),
      s_axi_arready(0) => s00_couplers_to_xbar_ARREADY(0),
      s_axi_arvalid(1) => s01_couplers_to_xbar_ARVALID,
      s_axi_arvalid(0) => s00_couplers_to_xbar_ARVALID,
      s_axi_awaddr(79 downto 40) => s01_couplers_to_xbar_AWADDR(39 downto 0),
      s_axi_awaddr(39 downto 0) => s00_couplers_to_xbar_AWADDR(39 downto 0),
      s_axi_awprot(5 downto 3) => s01_couplers_to_xbar_AWPROT(2 downto 0),
      s_axi_awprot(2 downto 0) => s00_couplers_to_xbar_AWPROT(2 downto 0),
      s_axi_awready(1) => s01_couplers_to_xbar_AWREADY(1),
      s_axi_awready(0) => s00_couplers_to_xbar_AWREADY(0),
      s_axi_awvalid(1) => s01_couplers_to_xbar_AWVALID,
      s_axi_awvalid(0) => s00_couplers_to_xbar_AWVALID,
      s_axi_bready(1) => s01_couplers_to_xbar_BREADY,
      s_axi_bready(0) => s00_couplers_to_xbar_BREADY,
      s_axi_bresp(3 downto 2) => s01_couplers_to_xbar_BRESP(3 downto 2),
      s_axi_bresp(1 downto 0) => s00_couplers_to_xbar_BRESP(1 downto 0),
      s_axi_bvalid(1) => s01_couplers_to_xbar_BVALID(1),
      s_axi_bvalid(0) => s00_couplers_to_xbar_BVALID(0),
      s_axi_rdata(63 downto 32) => s01_couplers_to_xbar_RDATA(63 downto 32),
      s_axi_rdata(31 downto 0) => s00_couplers_to_xbar_RDATA(31 downto 0),
      s_axi_rready(1) => s01_couplers_to_xbar_RREADY,
      s_axi_rready(0) => s00_couplers_to_xbar_RREADY,
      s_axi_rresp(3 downto 2) => s01_couplers_to_xbar_RRESP(3 downto 2),
      s_axi_rresp(1 downto 0) => s00_couplers_to_xbar_RRESP(1 downto 0),
      s_axi_rvalid(1) => s01_couplers_to_xbar_RVALID(1),
      s_axi_rvalid(0) => s00_couplers_to_xbar_RVALID(0),
      s_axi_wdata(63 downto 32) => s01_couplers_to_xbar_WDATA(31 downto 0),
      s_axi_wdata(31 downto 0) => s00_couplers_to_xbar_WDATA(31 downto 0),
      s_axi_wready(1) => s01_couplers_to_xbar_WREADY(1),
      s_axi_wready(0) => s00_couplers_to_xbar_WREADY(0),
      s_axi_wstrb(7 downto 4) => s01_couplers_to_xbar_WSTRB(3 downto 0),
      s_axi_wstrb(3 downto 0) => s00_couplers_to_xbar_WSTRB(3 downto 0),
      s_axi_wvalid(1) => s01_couplers_to_xbar_WVALID,
      s_axi_wvalid(0) => s00_couplers_to_xbar_WVALID
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity TO_PS_imp_PC26XI is
  port (
    M01_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M01_AXI_arready : in STD_LOGIC;
    M01_AXI_arvalid : out STD_LOGIC;
    M01_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M01_AXI_awready : in STD_LOGIC;
    M01_AXI_awvalid : out STD_LOGIC;
    M01_AXI_bready : out STD_LOGIC;
    M01_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_bvalid : in STD_LOGIC;
    M01_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_rready : out STD_LOGIC;
    M01_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_rvalid : in STD_LOGIC;
    M01_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_wready : in STD_LOGIC;
    M01_AXI_wvalid : out STD_LOGIC;
    M02_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M02_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M02_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M02_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M02_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M02_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M03_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M03_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M03_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M03_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M03_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI1_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI1_arready : in STD_LOGIC;
    M05_AXI1_arvalid : out STD_LOGIC;
    M05_AXI1_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI1_awready : in STD_LOGIC;
    M05_AXI1_awvalid : out STD_LOGIC;
    M05_AXI1_bready : out STD_LOGIC;
    M05_AXI1_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI1_bvalid : in STD_LOGIC;
    M05_AXI1_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI1_rready : out STD_LOGIC;
    M05_AXI1_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI1_rvalid : in STD_LOGIC;
    M05_AXI1_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI1_wready : in STD_LOGIC;
    M05_AXI1_wvalid : out STD_LOGIC;
    M05_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI_arready : in STD_LOGIC;
    M05_AXI_arvalid : out STD_LOGIC;
    M05_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI_awready : in STD_LOGIC;
    M05_AXI_awvalid : out STD_LOGIC;
    M05_AXI_bready : out STD_LOGIC;
    M05_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_bvalid : in STD_LOGIC;
    M05_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_rready : out STD_LOGIC;
    M05_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_rvalid : in STD_LOGIC;
    M05_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_wready : in STD_LOGIC;
    M05_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_wvalid : out STD_LOGIC;
    M06_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M06_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M06_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M06_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M06_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M06_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M06_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M06_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M07_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M08_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M08_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M08_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M08_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M08_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M08_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M08_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_HPC0_FPD_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HPC0_FPD_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HPC0_FPD_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_HPC0_FPD_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_arready : out STD_LOGIC;
    S_AXI_HPC0_FPD_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_arvalid : in STD_LOGIC;
    S_AXI_HPC0_FPD_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HPC0_FPD_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HPC0_FPD_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_HPC0_FPD_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_awready : out STD_LOGIC;
    S_AXI_HPC0_FPD_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_awvalid : in STD_LOGIC;
    S_AXI_HPC0_FPD_bready : in STD_LOGIC;
    S_AXI_HPC0_FPD_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_bvalid : out STD_LOGIC;
    S_AXI_HPC0_FPD_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HPC0_FPD_rlast : out STD_LOGIC;
    S_AXI_HPC0_FPD_rready : in STD_LOGIC;
    S_AXI_HPC0_FPD_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_rvalid : out STD_LOGIC;
    S_AXI_HPC0_FPD_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HPC0_FPD_wlast : in STD_LOGIC;
    S_AXI_HPC0_FPD_wready : out STD_LOGIC;
    S_AXI_HPC0_FPD_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HPC0_FPD_wvalid : in STD_LOGIC;
    clk_out1 : out STD_LOGIC;
    dp_live_video_in_de : in STD_LOGIC;
    dp_live_video_in_hsync : in STD_LOGIC;
    dp_live_video_in_pixel1 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    dp_live_video_in_vsync : in STD_LOGIC;
    dp_video_in_clk : out STD_LOGIC;
    gpio_tri_o : out STD_LOGIC_VECTOR ( 2 downto 0 );
    iic_scl_i : in STD_LOGIC;
    iic_scl_o : out STD_LOGIC;
    iic_scl_t : out STD_LOGIC;
    iic_sda_i : in STD_LOGIC;
    iic_sda_o : out STD_LOGIC;
    iic_sda_t : out STD_LOGIC;
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    pl_clk0 : out STD_LOGIC;
    pl_ps_irq0 : in STD_LOGIC
  );
end TO_PS_imp_PC26XI;

architecture STRUCTURE of TO_PS_imp_PC26XI is
  component kv260_video_axi_gpio_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    gpio_io_o : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  end component kv260_video_axi_gpio_0;
  component kv260_video_clk_wiz_0_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 10 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 10 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    clk_in1 : in STD_LOGIC;
    clk_out1 : out STD_LOGIC;
    locked : out STD_LOGIC
  );
  end component kv260_video_clk_wiz_0_0;
  component kv260_video_clk_wiz_1_0 is
  port (
    clk_in1 : in STD_LOGIC;
    clk_out1 : out STD_LOGIC;
    clk_out2 : out STD_LOGIC
  );
  end component kv260_video_clk_wiz_1_0;
  component kv260_video_clk_wiz_ila_0 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe1 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe4 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe5 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe7 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe8 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe9 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe10 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe11 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe12 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe13 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe14 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe15 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe16 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe17 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe18 : in STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  end component kv260_video_clk_wiz_ila_0;
  component kv260_video_rst_ps8_0_249M_0 is
  port (
    slowest_sync_clk : in STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    dcm_locked : in STD_LOGIC;
    mb_reset : out STD_LOGIC;
    bus_struct_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    interconnect_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component kv260_video_rst_ps8_0_249M_0;
  component kv260_video_zynq_ultra_ps_e_0_0 is
  port (
    maxihpm0_fpd_aclk : in STD_LOGIC;
    maxigp0_awid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    maxigp0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    maxigp0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    maxigp0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    maxigp0_awlock : out STD_LOGIC;
    maxigp0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    maxigp0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    maxigp0_awvalid : out STD_LOGIC;
    maxigp0_awuser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp0_awready : in STD_LOGIC;
    maxigp0_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    maxigp0_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp0_wlast : out STD_LOGIC;
    maxigp0_wvalid : out STD_LOGIC;
    maxigp0_wready : in STD_LOGIC;
    maxigp0_bid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    maxigp0_bvalid : in STD_LOGIC;
    maxigp0_bready : out STD_LOGIC;
    maxigp0_arid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    maxigp0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    maxigp0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    maxigp0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    maxigp0_arlock : out STD_LOGIC;
    maxigp0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    maxigp0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    maxigp0_arvalid : out STD_LOGIC;
    maxigp0_aruser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp0_arready : in STD_LOGIC;
    maxigp0_rid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp0_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    maxigp0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    maxigp0_rlast : in STD_LOGIC;
    maxigp0_rvalid : in STD_LOGIC;
    maxigp0_rready : out STD_LOGIC;
    maxigp0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    maxigp0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    maxihpm1_fpd_aclk : in STD_LOGIC;
    maxigp1_awid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp1_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    maxigp1_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    maxigp1_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    maxigp1_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    maxigp1_awlock : out STD_LOGIC;
    maxigp1_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    maxigp1_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    maxigp1_awvalid : out STD_LOGIC;
    maxigp1_awuser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp1_awready : in STD_LOGIC;
    maxigp1_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    maxigp1_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp1_wlast : out STD_LOGIC;
    maxigp1_wvalid : out STD_LOGIC;
    maxigp1_wready : in STD_LOGIC;
    maxigp1_bid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp1_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    maxigp1_bvalid : in STD_LOGIC;
    maxigp1_bready : out STD_LOGIC;
    maxigp1_arid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp1_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    maxigp1_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    maxigp1_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    maxigp1_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    maxigp1_arlock : out STD_LOGIC;
    maxigp1_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    maxigp1_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    maxigp1_arvalid : out STD_LOGIC;
    maxigp1_aruser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp1_arready : in STD_LOGIC;
    maxigp1_rid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    maxigp1_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    maxigp1_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    maxigp1_rlast : in STD_LOGIC;
    maxigp1_rvalid : in STD_LOGIC;
    maxigp1_rready : out STD_LOGIC;
    maxigp1_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    maxigp1_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    saxihpc0_fpd_aclk : in STD_LOGIC;
    saxigp0_aruser : in STD_LOGIC;
    saxigp0_awuser : in STD_LOGIC;
    saxigp0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    saxigp0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    saxigp0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    saxigp0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    saxigp0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    saxigp0_awlock : in STD_LOGIC;
    saxigp0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    saxigp0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    saxigp0_awvalid : in STD_LOGIC;
    saxigp0_awready : out STD_LOGIC;
    saxigp0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    saxigp0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    saxigp0_wlast : in STD_LOGIC;
    saxigp0_wvalid : in STD_LOGIC;
    saxigp0_wready : out STD_LOGIC;
    saxigp0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    saxigp0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    saxigp0_bvalid : out STD_LOGIC;
    saxigp0_bready : in STD_LOGIC;
    saxigp0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    saxigp0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    saxigp0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    saxigp0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    saxigp0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    saxigp0_arlock : in STD_LOGIC;
    saxigp0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    saxigp0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    saxigp0_arvalid : in STD_LOGIC;
    saxigp0_arready : out STD_LOGIC;
    saxigp0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    saxigp0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    saxigp0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    saxigp0_rlast : out STD_LOGIC;
    saxigp0_rvalid : out STD_LOGIC;
    saxigp0_rready : in STD_LOGIC;
    saxigp0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    saxigp0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    emio_i2c0_scl_i : in STD_LOGIC;
    emio_i2c0_scl_o : out STD_LOGIC;
    emio_i2c0_scl_t : out STD_LOGIC;
    emio_i2c0_sda_i : in STD_LOGIC;
    emio_i2c0_sda_o : out STD_LOGIC;
    emio_i2c0_sda_t : out STD_LOGIC;
    dp_video_ref_clk : out STD_LOGIC;
    dp_live_video_in_vsync : in STD_LOGIC;
    dp_live_video_in_hsync : in STD_LOGIC;
    dp_live_video_in_de : in STD_LOGIC;
    dp_live_video_in_pixel1 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    dp_video_in_clk : in STD_LOGIC;
    dp_video_out_hsync : out STD_LOGIC;
    dp_video_out_vsync : out STD_LOGIC;
    dp_video_out_pixel1 : out STD_LOGIC_VECTOR ( 35 downto 0 );
    dp_live_gfx_alpha_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
    dp_live_gfx_pixel1_in : in STD_LOGIC_VECTOR ( 35 downto 0 );
    dp_external_custom_event1 : in STD_LOGIC;
    dp_external_custom_event2 : in STD_LOGIC;
    dp_external_vsync_event : in STD_LOGIC;
    dp_live_video_de_out : out STD_LOGIC;
    pl_ps_irq0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    pl_resetn0 : out STD_LOGIC;
    pl_clk0 : out STD_LOGIC
  );
  end component kv260_video_zynq_ultra_ps_e_0_0;
  component kv260_video_rst_clk_wiz_ctrl_0 is
  port (
    slowest_sync_clk : in STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    dcm_locked : in STD_LOGIC;
    mb_reset : out STD_LOGIC;
    bus_struct_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    interconnect_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component kv260_video_rst_clk_wiz_ctrl_0;
  signal Conn1_TRI_O : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal Conn2_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal Conn2_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn2_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn2_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal Conn2_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn2_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn2_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn2_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal Conn2_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn2_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn2_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn2_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal Conn2_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn2_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn2_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn2_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal Conn2_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn3_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal Conn3_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn3_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn3_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal Conn3_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn3_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn3_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn3_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal Conn3_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn3_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn3_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn3_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal Conn3_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn3_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn3_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal Conn3_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal Conn3_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axi_smc_M00_AXI_ARADDR : STD_LOGIC_VECTOR ( 48 downto 0 );
  signal axi_smc_M00_AXI_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_smc_M00_AXI_ARLOCK : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axi_smc_M00_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_ARREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_ARVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_AWADDR : STD_LOGIC_VECTOR ( 48 downto 0 );
  signal axi_smc_M00_AXI_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_smc_M00_AXI_AWLOCK : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axi_smc_M00_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_AWREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_AWVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_BREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_BVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_RDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal axi_smc_M00_AXI_RLAST : STD_LOGIC;
  signal axi_smc_M00_AXI_RREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_RVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_WDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal axi_smc_M00_AXI_WLAST : STD_LOGIC;
  signal axi_smc_M00_AXI_WREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_WSTRB : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal axi_smc_M00_AXI_WVALID : STD_LOGIC;
  signal clk_wiz_0_clk_out1 : STD_LOGIC;
  signal dphy_clk_200M_1 : STD_LOGIC;
  signal pl_ps_irq0_1 : STD_LOGIC;
  signal ps8_0_axi_periph_M00_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M00_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M00_AXI_ARVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M00_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M00_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M00_AXI_AWVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M00_AXI_BREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M00_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M00_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M00_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M00_AXI_RREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M00_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M00_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M00_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M00_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M00_AXI_WVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M01_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M01_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M01_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M01_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M01_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M01_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M01_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M01_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M01_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_ARVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_AWVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_BREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_RREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M03_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_WVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M04_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M04_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_M04_AXI_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M04_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M04_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M04_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_M04_AXI_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M04_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M04_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M04_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M04_AXI_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M04_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M04_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M04_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M04_AXI_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M04_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M04_AXI_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M04_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M04_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M05_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_ARVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_AWVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_BREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_RREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_WVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M09_AXI_ARADDR : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal ps8_0_axi_periph_M09_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_M09_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M09_AXI_ARVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M09_AXI_AWADDR : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal ps8_0_axi_periph_M09_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_M09_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M09_AXI_AWVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M09_AXI_BREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M09_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M09_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M09_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M09_AXI_RREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M09_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M09_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M09_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M09_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M09_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M09_AXI_WVALID : STD_LOGIC;
  signal rst_clk_wiz_ctrl_peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  signal rst_ps8_0_249M_peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  signal v_axi4s_vid_out_0_vid_active_video : STD_LOGIC;
  signal v_axi4s_vid_out_0_vid_data : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal v_axi4s_vid_out_0_vid_hsync : STD_LOGIC;
  signal v_axi4s_vid_out_0_vid_vsync : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SCL_I : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SCL_O : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SCL_T : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SDA_I : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SDA_O : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SDA_T : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARLOCK : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARREADY : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWLOCK : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWREADY : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BREADY : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RLAST : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RREADY : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WLAST : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WREADY : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WSTRB : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARLOCK : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARREADY : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWLOCK : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWREADY : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BREADY : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RID : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RLAST : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RREADY : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WLAST : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WREADY : STD_LOGIC;
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WSTRB : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_pl_clk0 : STD_LOGIC;
  signal zynq_ultra_ps_e_0_pl_clk1 : STD_LOGIC;
  signal zynq_ultra_ps_e_0_pl_resetn0 : STD_LOGIC;
  signal NLW_clk_wiz_0_locked_UNCONNECTED : STD_LOGIC;
  signal NLW_rst_clk_wiz_ctrl_mb_reset_UNCONNECTED : STD_LOGIC;
  signal NLW_rst_clk_wiz_ctrl_bus_struct_reset_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_rst_clk_wiz_ctrl_interconnect_aresetn_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_rst_clk_wiz_ctrl_peripheral_reset_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_rst_ps8_0_249M_mb_reset_UNCONNECTED : STD_LOGIC;
  signal NLW_rst_ps8_0_249M_bus_struct_reset_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_rst_ps8_0_249M_interconnect_aresetn_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_rst_ps8_0_249M_peripheral_reset_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_zynq_ultra_ps_e_0_dp_live_video_de_out_UNCONNECTED : STD_LOGIC;
  signal NLW_zynq_ultra_ps_e_0_dp_video_out_hsync_UNCONNECTED : STD_LOGIC;
  signal NLW_zynq_ultra_ps_e_0_dp_video_out_vsync_UNCONNECTED : STD_LOGIC;
  signal NLW_zynq_ultra_ps_e_0_dp_video_ref_clk_UNCONNECTED : STD_LOGIC;
  signal NLW_zynq_ultra_ps_e_0_dp_video_out_pixel1_UNCONNECTED : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal NLW_zynq_ultra_ps_e_0_maxigp0_aruser_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_zynq_ultra_ps_e_0_maxigp0_awuser_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_zynq_ultra_ps_e_0_maxigp1_aruser_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_zynq_ultra_ps_e_0_maxigp1_awuser_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_zynq_ultra_ps_e_0_saxigp0_bid_UNCONNECTED : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal NLW_zynq_ultra_ps_e_0_saxigp0_rid_UNCONNECTED : STD_LOGIC_VECTOR ( 5 downto 0 );
begin
  Conn2_ARREADY(0) <= M07_AXI_arready(0);
  Conn2_AWREADY(0) <= M07_AXI_awready(0);
  Conn2_BRESP(1 downto 0) <= M07_AXI_bresp(1 downto 0);
  Conn2_BVALID(0) <= M07_AXI_bvalid(0);
  Conn2_RDATA(31 downto 0) <= M07_AXI_rdata(31 downto 0);
  Conn2_RRESP(1 downto 0) <= M07_AXI_rresp(1 downto 0);
  Conn2_RVALID(0) <= M07_AXI_rvalid(0);
  Conn2_WREADY(0) <= M07_AXI_wready(0);
  Conn3_ARREADY(0) <= M08_AXI_arready(0);
  Conn3_AWREADY(0) <= M08_AXI_awready(0);
  Conn3_BRESP(1 downto 0) <= M08_AXI_bresp(1 downto 0);
  Conn3_BVALID(0) <= M08_AXI_bvalid(0);
  Conn3_RDATA(31 downto 0) <= M08_AXI_rdata(31 downto 0);
  Conn3_RRESP(1 downto 0) <= M08_AXI_rresp(1 downto 0);
  Conn3_RVALID(0) <= M08_AXI_rvalid(0);
  Conn3_WREADY(0) <= M08_AXI_wready(0);
  M01_AXI_araddr(39 downto 0) <= ps8_0_axi_periph_M00_AXI_ARADDR(39 downto 0);
  M01_AXI_arvalid <= ps8_0_axi_periph_M00_AXI_ARVALID;
  M01_AXI_awaddr(39 downto 0) <= ps8_0_axi_periph_M00_AXI_AWADDR(39 downto 0);
  M01_AXI_awvalid <= ps8_0_axi_periph_M00_AXI_AWVALID;
  M01_AXI_bready <= ps8_0_axi_periph_M00_AXI_BREADY;
  M01_AXI_rready <= ps8_0_axi_periph_M00_AXI_RREADY;
  M01_AXI_wdata(31 downto 0) <= ps8_0_axi_periph_M00_AXI_WDATA(31 downto 0);
  M01_AXI_wvalid <= ps8_0_axi_periph_M00_AXI_WVALID;
  M02_AXI_araddr(39 downto 0) <= ps8_0_axi_periph_M01_AXI_ARADDR(39 downto 0);
  M02_AXI_arvalid(0) <= ps8_0_axi_periph_M01_AXI_ARVALID(0);
  M02_AXI_awaddr(39 downto 0) <= ps8_0_axi_periph_M01_AXI_AWADDR(39 downto 0);
  M02_AXI_awvalid(0) <= ps8_0_axi_periph_M01_AXI_AWVALID(0);
  M02_AXI_bready(0) <= ps8_0_axi_periph_M01_AXI_BREADY(0);
  M02_AXI_rready(0) <= ps8_0_axi_periph_M01_AXI_RREADY(0);
  M02_AXI_wdata(31 downto 0) <= ps8_0_axi_periph_M01_AXI_WDATA(31 downto 0);
  M02_AXI_wstrb(3 downto 0) <= ps8_0_axi_periph_M01_AXI_WSTRB(3 downto 0);
  M02_AXI_wvalid(0) <= ps8_0_axi_periph_M01_AXI_WVALID(0);
  M03_AXI_araddr(39 downto 0) <= ps8_0_axi_periph_M02_AXI_ARADDR(39 downto 0);
  M03_AXI_arvalid(0) <= ps8_0_axi_periph_M02_AXI_ARVALID(0);
  M03_AXI_awaddr(39 downto 0) <= ps8_0_axi_periph_M02_AXI_AWADDR(39 downto 0);
  M03_AXI_awvalid(0) <= ps8_0_axi_periph_M02_AXI_AWVALID(0);
  M03_AXI_bready(0) <= ps8_0_axi_periph_M02_AXI_BREADY(0);
  M03_AXI_rready(0) <= ps8_0_axi_periph_M02_AXI_RREADY(0);
  M03_AXI_wdata(31 downto 0) <= ps8_0_axi_periph_M02_AXI_WDATA(31 downto 0);
  M03_AXI_wstrb(3 downto 0) <= ps8_0_axi_periph_M02_AXI_WSTRB(3 downto 0);
  M03_AXI_wvalid(0) <= ps8_0_axi_periph_M02_AXI_WVALID(0);
  M05_AXI1_araddr(39 downto 0) <= ps8_0_axi_periph_M05_AXI_ARADDR(39 downto 0);
  M05_AXI1_arvalid <= ps8_0_axi_periph_M05_AXI_ARVALID;
  M05_AXI1_awaddr(39 downto 0) <= ps8_0_axi_periph_M05_AXI_AWADDR(39 downto 0);
  M05_AXI1_awvalid <= ps8_0_axi_periph_M05_AXI_AWVALID;
  M05_AXI1_bready <= ps8_0_axi_periph_M05_AXI_BREADY;
  M05_AXI1_rready <= ps8_0_axi_periph_M05_AXI_RREADY;
  M05_AXI1_wdata(31 downto 0) <= ps8_0_axi_periph_M05_AXI_WDATA(31 downto 0);
  M05_AXI1_wvalid <= ps8_0_axi_periph_M05_AXI_WVALID;
  M05_AXI_araddr(39 downto 0) <= ps8_0_axi_periph_M03_AXI_ARADDR(39 downto 0);
  M05_AXI_arvalid <= ps8_0_axi_periph_M03_AXI_ARVALID;
  M05_AXI_awaddr(39 downto 0) <= ps8_0_axi_periph_M03_AXI_AWADDR(39 downto 0);
  M05_AXI_awvalid <= ps8_0_axi_periph_M03_AXI_AWVALID;
  M05_AXI_bready <= ps8_0_axi_periph_M03_AXI_BREADY;
  M05_AXI_rready <= ps8_0_axi_periph_M03_AXI_RREADY;
  M05_AXI_wdata(31 downto 0) <= ps8_0_axi_periph_M03_AXI_WDATA(31 downto 0);
  M05_AXI_wstrb(3 downto 0) <= ps8_0_axi_periph_M03_AXI_WSTRB(3 downto 0);
  M05_AXI_wvalid <= ps8_0_axi_periph_M03_AXI_WVALID;
  M06_AXI_araddr(39 downto 0) <= ps8_0_axi_periph_M04_AXI_ARADDR(39 downto 0);
  M06_AXI_arprot(2 downto 0) <= ps8_0_axi_periph_M04_AXI_ARPROT(2 downto 0);
  M06_AXI_arvalid(0) <= ps8_0_axi_periph_M04_AXI_ARVALID(0);
  M06_AXI_awaddr(39 downto 0) <= ps8_0_axi_periph_M04_AXI_AWADDR(39 downto 0);
  M06_AXI_awprot(2 downto 0) <= ps8_0_axi_periph_M04_AXI_AWPROT(2 downto 0);
  M06_AXI_awvalid(0) <= ps8_0_axi_periph_M04_AXI_AWVALID(0);
  M06_AXI_bready(0) <= ps8_0_axi_periph_M04_AXI_BREADY(0);
  M06_AXI_rready(0) <= ps8_0_axi_periph_M04_AXI_RREADY(0);
  M06_AXI_wdata(31 downto 0) <= ps8_0_axi_periph_M04_AXI_WDATA(31 downto 0);
  M06_AXI_wstrb(3 downto 0) <= ps8_0_axi_periph_M04_AXI_WSTRB(3 downto 0);
  M06_AXI_wvalid(0) <= ps8_0_axi_periph_M04_AXI_WVALID(0);
  M07_AXI_araddr(39 downto 0) <= Conn2_ARADDR(39 downto 0);
  M07_AXI_arvalid(0) <= Conn2_ARVALID(0);
  M07_AXI_awaddr(39 downto 0) <= Conn2_AWADDR(39 downto 0);
  M07_AXI_awvalid(0) <= Conn2_AWVALID(0);
  M07_AXI_bready(0) <= Conn2_BREADY(0);
  M07_AXI_rready(0) <= Conn2_RREADY(0);
  M07_AXI_wdata(31 downto 0) <= Conn2_WDATA(31 downto 0);
  M07_AXI_wstrb(3 downto 0) <= Conn2_WSTRB(3 downto 0);
  M07_AXI_wvalid(0) <= Conn2_WVALID(0);
  M08_AXI_araddr(39 downto 0) <= Conn3_ARADDR(39 downto 0);
  M08_AXI_arvalid(0) <= Conn3_ARVALID(0);
  M08_AXI_awaddr(39 downto 0) <= Conn3_AWADDR(39 downto 0);
  M08_AXI_awvalid(0) <= Conn3_AWVALID(0);
  M08_AXI_bready(0) <= Conn3_BREADY(0);
  M08_AXI_rready(0) <= Conn3_RREADY(0);
  M08_AXI_wdata(31 downto 0) <= Conn3_WDATA(31 downto 0);
  M08_AXI_wstrb(3 downto 0) <= Conn3_WSTRB(3 downto 0);
  M08_AXI_wvalid(0) <= Conn3_WVALID(0);
  S_AXI_HPC0_FPD_arready <= axi_smc_M00_AXI_ARREADY;
  S_AXI_HPC0_FPD_awready <= axi_smc_M00_AXI_AWREADY;
  S_AXI_HPC0_FPD_bresp(1 downto 0) <= axi_smc_M00_AXI_BRESP(1 downto 0);
  S_AXI_HPC0_FPD_bvalid <= axi_smc_M00_AXI_BVALID;
  S_AXI_HPC0_FPD_rdata(127 downto 0) <= axi_smc_M00_AXI_RDATA(127 downto 0);
  S_AXI_HPC0_FPD_rlast <= axi_smc_M00_AXI_RLAST;
  S_AXI_HPC0_FPD_rresp(1 downto 0) <= axi_smc_M00_AXI_RRESP(1 downto 0);
  S_AXI_HPC0_FPD_rvalid <= axi_smc_M00_AXI_RVALID;
  S_AXI_HPC0_FPD_wready <= axi_smc_M00_AXI_WREADY;
  axi_smc_M00_AXI_ARADDR(48 downto 0) <= S_AXI_HPC0_FPD_araddr(48 downto 0);
  axi_smc_M00_AXI_ARBURST(1 downto 0) <= S_AXI_HPC0_FPD_arburst(1 downto 0);
  axi_smc_M00_AXI_ARCACHE(3 downto 0) <= S_AXI_HPC0_FPD_arcache(3 downto 0);
  axi_smc_M00_AXI_ARLEN(7 downto 0) <= S_AXI_HPC0_FPD_arlen(7 downto 0);
  axi_smc_M00_AXI_ARLOCK(0) <= S_AXI_HPC0_FPD_arlock(0);
  axi_smc_M00_AXI_ARPROT(2 downto 0) <= S_AXI_HPC0_FPD_arprot(2 downto 0);
  axi_smc_M00_AXI_ARQOS(3 downto 0) <= S_AXI_HPC0_FPD_arqos(3 downto 0);
  axi_smc_M00_AXI_ARSIZE(2 downto 0) <= S_AXI_HPC0_FPD_arsize(2 downto 0);
  axi_smc_M00_AXI_ARVALID <= S_AXI_HPC0_FPD_arvalid;
  axi_smc_M00_AXI_AWADDR(48 downto 0) <= S_AXI_HPC0_FPD_awaddr(48 downto 0);
  axi_smc_M00_AXI_AWBURST(1 downto 0) <= S_AXI_HPC0_FPD_awburst(1 downto 0);
  axi_smc_M00_AXI_AWCACHE(3 downto 0) <= S_AXI_HPC0_FPD_awcache(3 downto 0);
  axi_smc_M00_AXI_AWLEN(7 downto 0) <= S_AXI_HPC0_FPD_awlen(7 downto 0);
  axi_smc_M00_AXI_AWLOCK(0) <= S_AXI_HPC0_FPD_awlock(0);
  axi_smc_M00_AXI_AWPROT(2 downto 0) <= S_AXI_HPC0_FPD_awprot(2 downto 0);
  axi_smc_M00_AXI_AWQOS(3 downto 0) <= S_AXI_HPC0_FPD_awqos(3 downto 0);
  axi_smc_M00_AXI_AWSIZE(2 downto 0) <= S_AXI_HPC0_FPD_awsize(2 downto 0);
  axi_smc_M00_AXI_AWVALID <= S_AXI_HPC0_FPD_awvalid;
  axi_smc_M00_AXI_BREADY <= S_AXI_HPC0_FPD_bready;
  axi_smc_M00_AXI_RREADY <= S_AXI_HPC0_FPD_rready;
  axi_smc_M00_AXI_WDATA(127 downto 0) <= S_AXI_HPC0_FPD_wdata(127 downto 0);
  axi_smc_M00_AXI_WLAST <= S_AXI_HPC0_FPD_wlast;
  axi_smc_M00_AXI_WSTRB(15 downto 0) <= S_AXI_HPC0_FPD_wstrb(15 downto 0);
  axi_smc_M00_AXI_WVALID <= S_AXI_HPC0_FPD_wvalid;
  clk_out1 <= dphy_clk_200M_1;
  dp_video_in_clk <= clk_wiz_0_clk_out1;
  gpio_tri_o(2 downto 0) <= Conn1_TRI_O(2 downto 0);
  iic_scl_o <= zynq_ultra_ps_e_0_IIC_0_SCL_O;
  iic_scl_t <= zynq_ultra_ps_e_0_IIC_0_SCL_T;
  iic_sda_o <= zynq_ultra_ps_e_0_IIC_0_SDA_O;
  iic_sda_t <= zynq_ultra_ps_e_0_IIC_0_SDA_T;
  peripheral_aresetn(0) <= rst_ps8_0_249M_peripheral_aresetn(0);
  pl_clk0 <= zynq_ultra_ps_e_0_pl_clk0;
  pl_ps_irq0_1 <= pl_ps_irq0;
  ps8_0_axi_periph_M00_AXI_ARREADY <= M01_AXI_arready;
  ps8_0_axi_periph_M00_AXI_AWREADY <= M01_AXI_awready;
  ps8_0_axi_periph_M00_AXI_BRESP(1 downto 0) <= M01_AXI_bresp(1 downto 0);
  ps8_0_axi_periph_M00_AXI_BVALID <= M01_AXI_bvalid;
  ps8_0_axi_periph_M00_AXI_RDATA(31 downto 0) <= M01_AXI_rdata(31 downto 0);
  ps8_0_axi_periph_M00_AXI_RRESP(1 downto 0) <= M01_AXI_rresp(1 downto 0);
  ps8_0_axi_periph_M00_AXI_RVALID <= M01_AXI_rvalid;
  ps8_0_axi_periph_M00_AXI_WREADY <= M01_AXI_wready;
  ps8_0_axi_periph_M01_AXI_ARREADY(0) <= M02_AXI_arready(0);
  ps8_0_axi_periph_M01_AXI_AWREADY(0) <= M02_AXI_awready(0);
  ps8_0_axi_periph_M01_AXI_BRESP(1 downto 0) <= M02_AXI_bresp(1 downto 0);
  ps8_0_axi_periph_M01_AXI_BVALID(0) <= M02_AXI_bvalid(0);
  ps8_0_axi_periph_M01_AXI_RDATA(31 downto 0) <= M02_AXI_rdata(31 downto 0);
  ps8_0_axi_periph_M01_AXI_RRESP(1 downto 0) <= M02_AXI_rresp(1 downto 0);
  ps8_0_axi_periph_M01_AXI_RVALID(0) <= M02_AXI_rvalid(0);
  ps8_0_axi_periph_M01_AXI_WREADY(0) <= M02_AXI_wready(0);
  ps8_0_axi_periph_M02_AXI_ARREADY(0) <= M03_AXI_arready(0);
  ps8_0_axi_periph_M02_AXI_AWREADY(0) <= M03_AXI_awready(0);
  ps8_0_axi_periph_M02_AXI_BRESP(1 downto 0) <= M03_AXI_bresp(1 downto 0);
  ps8_0_axi_periph_M02_AXI_BVALID(0) <= M03_AXI_bvalid(0);
  ps8_0_axi_periph_M02_AXI_RDATA(31 downto 0) <= M03_AXI_rdata(31 downto 0);
  ps8_0_axi_periph_M02_AXI_RRESP(1 downto 0) <= M03_AXI_rresp(1 downto 0);
  ps8_0_axi_periph_M02_AXI_RVALID(0) <= M03_AXI_rvalid(0);
  ps8_0_axi_periph_M02_AXI_WREADY(0) <= M03_AXI_wready(0);
  ps8_0_axi_periph_M03_AXI_ARREADY <= M05_AXI_arready;
  ps8_0_axi_periph_M03_AXI_AWREADY <= M05_AXI_awready;
  ps8_0_axi_periph_M03_AXI_BRESP(1 downto 0) <= M05_AXI_bresp(1 downto 0);
  ps8_0_axi_periph_M03_AXI_BVALID <= M05_AXI_bvalid;
  ps8_0_axi_periph_M03_AXI_RDATA(31 downto 0) <= M05_AXI_rdata(31 downto 0);
  ps8_0_axi_periph_M03_AXI_RRESP(1 downto 0) <= M05_AXI_rresp(1 downto 0);
  ps8_0_axi_periph_M03_AXI_RVALID <= M05_AXI_rvalid;
  ps8_0_axi_periph_M03_AXI_WREADY <= M05_AXI_wready;
  ps8_0_axi_periph_M04_AXI_ARREADY(0) <= M06_AXI_arready(0);
  ps8_0_axi_periph_M04_AXI_AWREADY(0) <= M06_AXI_awready(0);
  ps8_0_axi_periph_M04_AXI_BRESP(1 downto 0) <= M06_AXI_bresp(1 downto 0);
  ps8_0_axi_periph_M04_AXI_BVALID(0) <= M06_AXI_bvalid(0);
  ps8_0_axi_periph_M04_AXI_RDATA(31 downto 0) <= M06_AXI_rdata(31 downto 0);
  ps8_0_axi_periph_M04_AXI_RRESP(1 downto 0) <= M06_AXI_rresp(1 downto 0);
  ps8_0_axi_periph_M04_AXI_RVALID(0) <= M06_AXI_rvalid(0);
  ps8_0_axi_periph_M04_AXI_WREADY(0) <= M06_AXI_wready(0);
  ps8_0_axi_periph_M05_AXI_ARREADY <= M05_AXI1_arready;
  ps8_0_axi_periph_M05_AXI_AWREADY <= M05_AXI1_awready;
  ps8_0_axi_periph_M05_AXI_BRESP(1 downto 0) <= M05_AXI1_bresp(1 downto 0);
  ps8_0_axi_periph_M05_AXI_BVALID <= M05_AXI1_bvalid;
  ps8_0_axi_periph_M05_AXI_RDATA(31 downto 0) <= M05_AXI1_rdata(31 downto 0);
  ps8_0_axi_periph_M05_AXI_RRESP(1 downto 0) <= M05_AXI1_rresp(1 downto 0);
  ps8_0_axi_periph_M05_AXI_RVALID <= M05_AXI1_rvalid;
  ps8_0_axi_periph_M05_AXI_WREADY <= M05_AXI1_wready;
  v_axi4s_vid_out_0_vid_active_video <= dp_live_video_in_de;
  v_axi4s_vid_out_0_vid_data(35 downto 0) <= dp_live_video_in_pixel1(35 downto 0);
  v_axi4s_vid_out_0_vid_hsync <= dp_live_video_in_hsync;
  v_axi4s_vid_out_0_vid_vsync <= dp_live_video_in_vsync;
  zynq_ultra_ps_e_0_IIC_0_SCL_I <= iic_scl_i;
  zynq_ultra_ps_e_0_IIC_0_SDA_I <= iic_sda_i;
axi_gpio: component kv260_video_axi_gpio_0
     port map (
      gpio_io_o(2 downto 0) => Conn1_TRI_O(2 downto 0),
      s_axi_aclk => zynq_ultra_ps_e_0_pl_clk0,
      s_axi_araddr(8 downto 0) => ps8_0_axi_periph_M06_AXI_ARADDR(8 downto 0),
      s_axi_aresetn => rst_ps8_0_249M_peripheral_aresetn(0),
      s_axi_arready => ps8_0_axi_periph_M06_AXI_ARREADY,
      s_axi_arvalid => ps8_0_axi_periph_M06_AXI_ARVALID(0),
      s_axi_awaddr(8 downto 0) => ps8_0_axi_periph_M06_AXI_AWADDR(8 downto 0),
      s_axi_awready => ps8_0_axi_periph_M06_AXI_AWREADY,
      s_axi_awvalid => ps8_0_axi_periph_M06_AXI_AWVALID(0),
      s_axi_bready => ps8_0_axi_periph_M06_AXI_BREADY(0),
      s_axi_bresp(1 downto 0) => ps8_0_axi_periph_M06_AXI_BRESP(1 downto 0),
      s_axi_bvalid => ps8_0_axi_periph_M06_AXI_BVALID,
      s_axi_rdata(31 downto 0) => ps8_0_axi_periph_M06_AXI_RDATA(31 downto 0),
      s_axi_rready => ps8_0_axi_periph_M06_AXI_RREADY(0),
      s_axi_rresp(1 downto 0) => ps8_0_axi_periph_M06_AXI_RRESP(1 downto 0),
      s_axi_rvalid => ps8_0_axi_periph_M06_AXI_RVALID,
      s_axi_wdata(31 downto 0) => ps8_0_axi_periph_M06_AXI_WDATA(31 downto 0),
      s_axi_wready => ps8_0_axi_periph_M06_AXI_WREADY,
      s_axi_wstrb(3 downto 0) => ps8_0_axi_periph_M06_AXI_WSTRB(3 downto 0),
      s_axi_wvalid => ps8_0_axi_periph_M06_AXI_WVALID(0)
    );
clk_wiz_0: component kv260_video_clk_wiz_0_0
     port map (
      clk_in1 => zynq_ultra_ps_e_0_pl_clk1,
      clk_out1 => clk_wiz_0_clk_out1,
      locked => NLW_clk_wiz_0_locked_UNCONNECTED,
      s_axi_aclk => zynq_ultra_ps_e_0_pl_clk1,
      s_axi_araddr(10 downto 0) => ps8_0_axi_periph_M09_AXI_ARADDR(10 downto 0),
      s_axi_aresetn => rst_clk_wiz_ctrl_peripheral_aresetn(0),
      s_axi_arready => ps8_0_axi_periph_M09_AXI_ARREADY,
      s_axi_arvalid => ps8_0_axi_periph_M09_AXI_ARVALID,
      s_axi_awaddr(10 downto 0) => ps8_0_axi_periph_M09_AXI_AWADDR(10 downto 0),
      s_axi_awready => ps8_0_axi_periph_M09_AXI_AWREADY,
      s_axi_awvalid => ps8_0_axi_periph_M09_AXI_AWVALID,
      s_axi_bready => ps8_0_axi_periph_M09_AXI_BREADY,
      s_axi_bresp(1 downto 0) => ps8_0_axi_periph_M09_AXI_BRESP(1 downto 0),
      s_axi_bvalid => ps8_0_axi_periph_M09_AXI_BVALID,
      s_axi_rdata(31 downto 0) => ps8_0_axi_periph_M09_AXI_RDATA(31 downto 0),
      s_axi_rready => ps8_0_axi_periph_M09_AXI_RREADY,
      s_axi_rresp(1 downto 0) => ps8_0_axi_periph_M09_AXI_RRESP(1 downto 0),
      s_axi_rvalid => ps8_0_axi_periph_M09_AXI_RVALID,
      s_axi_wdata(31 downto 0) => ps8_0_axi_periph_M09_AXI_WDATA(31 downto 0),
      s_axi_wready => ps8_0_axi_periph_M09_AXI_WREADY,
      s_axi_wstrb(3 downto 0) => ps8_0_axi_periph_M09_AXI_WSTRB(3 downto 0),
      s_axi_wvalid => ps8_0_axi_periph_M09_AXI_WVALID
    );
clk_wiz_1: component kv260_video_clk_wiz_1_0
     port map (
      clk_in1 => zynq_ultra_ps_e_0_pl_clk1,
      clk_out1 => dphy_clk_200M_1,
      clk_out2 => zynq_ultra_ps_e_0_pl_clk0
    );
clk_wiz_ila: component kv260_video_clk_wiz_ila_0
     port map (
      clk => zynq_ultra_ps_e_0_pl_clk1,
      probe0(0) => ps8_0_axi_periph_M09_AXI_WREADY,
      probe1(10 downto 0) => ps8_0_axi_periph_M09_AXI_AWADDR(10 downto 0),
      probe10(31 downto 0) => ps8_0_axi_periph_M09_AXI_RDATA(31 downto 0),
      probe11(0) => ps8_0_axi_periph_M09_AXI_AWVALID,
      probe12(0) => ps8_0_axi_periph_M09_AXI_AWREADY,
      probe13(1 downto 0) => ps8_0_axi_periph_M09_AXI_RRESP(1 downto 0),
      probe14(31 downto 0) => ps8_0_axi_periph_M09_AXI_WDATA(31 downto 0),
      probe15(3 downto 0) => ps8_0_axi_periph_M09_AXI_WSTRB(3 downto 0),
      probe16(0) => ps8_0_axi_periph_M09_AXI_RVALID,
      probe17(2 downto 0) => ps8_0_axi_periph_M09_AXI_ARPROT(2 downto 0),
      probe18(2 downto 0) => ps8_0_axi_periph_M09_AXI_AWPROT(2 downto 0),
      probe2(1 downto 0) => ps8_0_axi_periph_M09_AXI_BRESP(1 downto 0),
      probe3(0) => ps8_0_axi_periph_M09_AXI_BVALID,
      probe4(0) => ps8_0_axi_periph_M09_AXI_BREADY,
      probe5(10 downto 0) => ps8_0_axi_periph_M09_AXI_ARADDR(10 downto 0),
      probe6(0) => ps8_0_axi_periph_M09_AXI_RREADY,
      probe7(0) => ps8_0_axi_periph_M09_AXI_WVALID,
      probe8(0) => ps8_0_axi_periph_M09_AXI_ARVALID,
      probe9(0) => ps8_0_axi_periph_M09_AXI_ARREADY
    );
ps8_0_axi_periph: entity work.kv260_video_ps8_0_axi_periph_0
     port map (
      ACLK => zynq_ultra_ps_e_0_pl_clk0,
      ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      M00_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      M00_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      M00_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M00_AXI_ARADDR(39 downto 0),
      M00_AXI_arready => ps8_0_axi_periph_M00_AXI_ARREADY,
      M00_AXI_arvalid => ps8_0_axi_periph_M00_AXI_ARVALID,
      M00_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M00_AXI_AWADDR(39 downto 0),
      M00_AXI_awready => ps8_0_axi_periph_M00_AXI_AWREADY,
      M00_AXI_awvalid => ps8_0_axi_periph_M00_AXI_AWVALID,
      M00_AXI_bready => ps8_0_axi_periph_M00_AXI_BREADY,
      M00_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M00_AXI_BRESP(1 downto 0),
      M00_AXI_bvalid => ps8_0_axi_periph_M00_AXI_BVALID,
      M00_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M00_AXI_RDATA(31 downto 0),
      M00_AXI_rready => ps8_0_axi_periph_M00_AXI_RREADY,
      M00_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M00_AXI_RRESP(1 downto 0),
      M00_AXI_rvalid => ps8_0_axi_periph_M00_AXI_RVALID,
      M00_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M00_AXI_WDATA(31 downto 0),
      M00_AXI_wready => ps8_0_axi_periph_M00_AXI_WREADY,
      M00_AXI_wvalid => ps8_0_axi_periph_M00_AXI_WVALID,
      M01_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      M01_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      M01_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M01_AXI_ARADDR(39 downto 0),
      M01_AXI_arready(0) => ps8_0_axi_periph_M01_AXI_ARREADY(0),
      M01_AXI_arvalid(0) => ps8_0_axi_periph_M01_AXI_ARVALID(0),
      M01_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M01_AXI_AWADDR(39 downto 0),
      M01_AXI_awready(0) => ps8_0_axi_periph_M01_AXI_AWREADY(0),
      M01_AXI_awvalid(0) => ps8_0_axi_periph_M01_AXI_AWVALID(0),
      M01_AXI_bready(0) => ps8_0_axi_periph_M01_AXI_BREADY(0),
      M01_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M01_AXI_BRESP(1 downto 0),
      M01_AXI_bvalid(0) => ps8_0_axi_periph_M01_AXI_BVALID(0),
      M01_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M01_AXI_RDATA(31 downto 0),
      M01_AXI_rready(0) => ps8_0_axi_periph_M01_AXI_RREADY(0),
      M01_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M01_AXI_RRESP(1 downto 0),
      M01_AXI_rvalid(0) => ps8_0_axi_periph_M01_AXI_RVALID(0),
      M01_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M01_AXI_WDATA(31 downto 0),
      M01_AXI_wready(0) => ps8_0_axi_periph_M01_AXI_WREADY(0),
      M01_AXI_wstrb(3 downto 0) => ps8_0_axi_periph_M01_AXI_WSTRB(3 downto 0),
      M01_AXI_wvalid(0) => ps8_0_axi_periph_M01_AXI_WVALID(0),
      M02_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      M02_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      M02_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M02_AXI_ARADDR(39 downto 0),
      M02_AXI_arready(0) => ps8_0_axi_periph_M02_AXI_ARREADY(0),
      M02_AXI_arvalid(0) => ps8_0_axi_periph_M02_AXI_ARVALID(0),
      M02_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M02_AXI_AWADDR(39 downto 0),
      M02_AXI_awready(0) => ps8_0_axi_periph_M02_AXI_AWREADY(0),
      M02_AXI_awvalid(0) => ps8_0_axi_periph_M02_AXI_AWVALID(0),
      M02_AXI_bready(0) => ps8_0_axi_periph_M02_AXI_BREADY(0),
      M02_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M02_AXI_BRESP(1 downto 0),
      M02_AXI_bvalid(0) => ps8_0_axi_periph_M02_AXI_BVALID(0),
      M02_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M02_AXI_RDATA(31 downto 0),
      M02_AXI_rready(0) => ps8_0_axi_periph_M02_AXI_RREADY(0),
      M02_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M02_AXI_RRESP(1 downto 0),
      M02_AXI_rvalid(0) => ps8_0_axi_periph_M02_AXI_RVALID(0),
      M02_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M02_AXI_WDATA(31 downto 0),
      M02_AXI_wready(0) => ps8_0_axi_periph_M02_AXI_WREADY(0),
      M02_AXI_wstrb(3 downto 0) => ps8_0_axi_periph_M02_AXI_WSTRB(3 downto 0),
      M02_AXI_wvalid(0) => ps8_0_axi_periph_M02_AXI_WVALID(0),
      M03_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      M03_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      M03_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M03_AXI_ARADDR(39 downto 0),
      M03_AXI_arready => ps8_0_axi_periph_M03_AXI_ARREADY,
      M03_AXI_arvalid => ps8_0_axi_periph_M03_AXI_ARVALID,
      M03_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M03_AXI_AWADDR(39 downto 0),
      M03_AXI_awready => ps8_0_axi_periph_M03_AXI_AWREADY,
      M03_AXI_awvalid => ps8_0_axi_periph_M03_AXI_AWVALID,
      M03_AXI_bready => ps8_0_axi_periph_M03_AXI_BREADY,
      M03_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M03_AXI_BRESP(1 downto 0),
      M03_AXI_bvalid => ps8_0_axi_periph_M03_AXI_BVALID,
      M03_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M03_AXI_RDATA(31 downto 0),
      M03_AXI_rready => ps8_0_axi_periph_M03_AXI_RREADY,
      M03_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M03_AXI_RRESP(1 downto 0),
      M03_AXI_rvalid => ps8_0_axi_periph_M03_AXI_RVALID,
      M03_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M03_AXI_WDATA(31 downto 0),
      M03_AXI_wready => ps8_0_axi_periph_M03_AXI_WREADY,
      M03_AXI_wstrb(3 downto 0) => ps8_0_axi_periph_M03_AXI_WSTRB(3 downto 0),
      M03_AXI_wvalid => ps8_0_axi_periph_M03_AXI_WVALID,
      M04_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      M04_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      M04_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M04_AXI_ARADDR(39 downto 0),
      M04_AXI_arprot(2 downto 0) => ps8_0_axi_periph_M04_AXI_ARPROT(2 downto 0),
      M04_AXI_arready(0) => ps8_0_axi_periph_M04_AXI_ARREADY(0),
      M04_AXI_arvalid(0) => ps8_0_axi_periph_M04_AXI_ARVALID(0),
      M04_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M04_AXI_AWADDR(39 downto 0),
      M04_AXI_awprot(2 downto 0) => ps8_0_axi_periph_M04_AXI_AWPROT(2 downto 0),
      M04_AXI_awready(0) => ps8_0_axi_periph_M04_AXI_AWREADY(0),
      M04_AXI_awvalid(0) => ps8_0_axi_periph_M04_AXI_AWVALID(0),
      M04_AXI_bready(0) => ps8_0_axi_periph_M04_AXI_BREADY(0),
      M04_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M04_AXI_BRESP(1 downto 0),
      M04_AXI_bvalid(0) => ps8_0_axi_periph_M04_AXI_BVALID(0),
      M04_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M04_AXI_RDATA(31 downto 0),
      M04_AXI_rready(0) => ps8_0_axi_periph_M04_AXI_RREADY(0),
      M04_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M04_AXI_RRESP(1 downto 0),
      M04_AXI_rvalid(0) => ps8_0_axi_periph_M04_AXI_RVALID(0),
      M04_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M04_AXI_WDATA(31 downto 0),
      M04_AXI_wready(0) => ps8_0_axi_periph_M04_AXI_WREADY(0),
      M04_AXI_wstrb(3 downto 0) => ps8_0_axi_periph_M04_AXI_WSTRB(3 downto 0),
      M04_AXI_wvalid(0) => ps8_0_axi_periph_M04_AXI_WVALID(0),
      M05_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      M05_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      M05_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M05_AXI_ARADDR(39 downto 0),
      M05_AXI_arready => ps8_0_axi_periph_M05_AXI_ARREADY,
      M05_AXI_arvalid => ps8_0_axi_periph_M05_AXI_ARVALID,
      M05_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M05_AXI_AWADDR(39 downto 0),
      M05_AXI_awready => ps8_0_axi_periph_M05_AXI_AWREADY,
      M05_AXI_awvalid => ps8_0_axi_periph_M05_AXI_AWVALID,
      M05_AXI_bready => ps8_0_axi_periph_M05_AXI_BREADY,
      M05_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M05_AXI_BRESP(1 downto 0),
      M05_AXI_bvalid => ps8_0_axi_periph_M05_AXI_BVALID,
      M05_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M05_AXI_RDATA(31 downto 0),
      M05_AXI_rready => ps8_0_axi_periph_M05_AXI_RREADY,
      M05_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M05_AXI_RRESP(1 downto 0),
      M05_AXI_rvalid => ps8_0_axi_periph_M05_AXI_RVALID,
      M05_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M05_AXI_WDATA(31 downto 0),
      M05_AXI_wready => ps8_0_axi_periph_M05_AXI_WREADY,
      M05_AXI_wvalid => ps8_0_axi_periph_M05_AXI_WVALID,
      M06_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      M06_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      M06_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M06_AXI_ARADDR(39 downto 0),
      M06_AXI_arready(0) => ps8_0_axi_periph_M06_AXI_ARREADY,
      M06_AXI_arvalid(0) => ps8_0_axi_periph_M06_AXI_ARVALID(0),
      M06_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M06_AXI_AWADDR(39 downto 0),
      M06_AXI_awready(0) => ps8_0_axi_periph_M06_AXI_AWREADY,
      M06_AXI_awvalid(0) => ps8_0_axi_periph_M06_AXI_AWVALID(0),
      M06_AXI_bready(0) => ps8_0_axi_periph_M06_AXI_BREADY(0),
      M06_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M06_AXI_BRESP(1 downto 0),
      M06_AXI_bvalid(0) => ps8_0_axi_periph_M06_AXI_BVALID,
      M06_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M06_AXI_RDATA(31 downto 0),
      M06_AXI_rready(0) => ps8_0_axi_periph_M06_AXI_RREADY(0),
      M06_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M06_AXI_RRESP(1 downto 0),
      M06_AXI_rvalid(0) => ps8_0_axi_periph_M06_AXI_RVALID,
      M06_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M06_AXI_WDATA(31 downto 0),
      M06_AXI_wready(0) => ps8_0_axi_periph_M06_AXI_WREADY,
      M06_AXI_wstrb(3 downto 0) => ps8_0_axi_periph_M06_AXI_WSTRB(3 downto 0),
      M06_AXI_wvalid(0) => ps8_0_axi_periph_M06_AXI_WVALID(0),
      M07_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      M07_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      M07_AXI_araddr(39 downto 0) => Conn2_ARADDR(39 downto 0),
      M07_AXI_arready(0) => Conn2_ARREADY(0),
      M07_AXI_arvalid(0) => Conn2_ARVALID(0),
      M07_AXI_awaddr(39 downto 0) => Conn2_AWADDR(39 downto 0),
      M07_AXI_awready(0) => Conn2_AWREADY(0),
      M07_AXI_awvalid(0) => Conn2_AWVALID(0),
      M07_AXI_bready(0) => Conn2_BREADY(0),
      M07_AXI_bresp(1 downto 0) => Conn2_BRESP(1 downto 0),
      M07_AXI_bvalid(0) => Conn2_BVALID(0),
      M07_AXI_rdata(31 downto 0) => Conn2_RDATA(31 downto 0),
      M07_AXI_rready(0) => Conn2_RREADY(0),
      M07_AXI_rresp(1 downto 0) => Conn2_RRESP(1 downto 0),
      M07_AXI_rvalid(0) => Conn2_RVALID(0),
      M07_AXI_wdata(31 downto 0) => Conn2_WDATA(31 downto 0),
      M07_AXI_wready(0) => Conn2_WREADY(0),
      M07_AXI_wstrb(3 downto 0) => Conn2_WSTRB(3 downto 0),
      M07_AXI_wvalid(0) => Conn2_WVALID(0),
      M08_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      M08_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      M08_AXI_araddr(39 downto 0) => Conn3_ARADDR(39 downto 0),
      M08_AXI_arready(0) => Conn3_ARREADY(0),
      M08_AXI_arvalid(0) => Conn3_ARVALID(0),
      M08_AXI_awaddr(39 downto 0) => Conn3_AWADDR(39 downto 0),
      M08_AXI_awready(0) => Conn3_AWREADY(0),
      M08_AXI_awvalid(0) => Conn3_AWVALID(0),
      M08_AXI_bready(0) => Conn3_BREADY(0),
      M08_AXI_bresp(1 downto 0) => Conn3_BRESP(1 downto 0),
      M08_AXI_bvalid(0) => Conn3_BVALID(0),
      M08_AXI_rdata(31 downto 0) => Conn3_RDATA(31 downto 0),
      M08_AXI_rready(0) => Conn3_RREADY(0),
      M08_AXI_rresp(1 downto 0) => Conn3_RRESP(1 downto 0),
      M08_AXI_rvalid(0) => Conn3_RVALID(0),
      M08_AXI_wdata(31 downto 0) => Conn3_WDATA(31 downto 0),
      M08_AXI_wready(0) => Conn3_WREADY(0),
      M08_AXI_wstrb(3 downto 0) => Conn3_WSTRB(3 downto 0),
      M08_AXI_wvalid(0) => Conn3_WVALID(0),
      M09_ACLK => zynq_ultra_ps_e_0_pl_clk1,
      M09_ARESETN => rst_clk_wiz_ctrl_peripheral_aresetn(0),
      M09_AXI_araddr(10 downto 0) => ps8_0_axi_periph_M09_AXI_ARADDR(10 downto 0),
      M09_AXI_arprot(2 downto 0) => ps8_0_axi_periph_M09_AXI_ARPROT(2 downto 0),
      M09_AXI_arready => ps8_0_axi_periph_M09_AXI_ARREADY,
      M09_AXI_arvalid => ps8_0_axi_periph_M09_AXI_ARVALID,
      M09_AXI_awaddr(10 downto 0) => ps8_0_axi_periph_M09_AXI_AWADDR(10 downto 0),
      M09_AXI_awprot(2 downto 0) => ps8_0_axi_periph_M09_AXI_AWPROT(2 downto 0),
      M09_AXI_awready => ps8_0_axi_periph_M09_AXI_AWREADY,
      M09_AXI_awvalid => ps8_0_axi_periph_M09_AXI_AWVALID,
      M09_AXI_bready => ps8_0_axi_periph_M09_AXI_BREADY,
      M09_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M09_AXI_BRESP(1 downto 0),
      M09_AXI_bvalid => ps8_0_axi_periph_M09_AXI_BVALID,
      M09_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M09_AXI_RDATA(31 downto 0),
      M09_AXI_rready => ps8_0_axi_periph_M09_AXI_RREADY,
      M09_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M09_AXI_RRESP(1 downto 0),
      M09_AXI_rvalid => ps8_0_axi_periph_M09_AXI_RVALID,
      M09_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M09_AXI_WDATA(31 downto 0),
      M09_AXI_wready => ps8_0_axi_periph_M09_AXI_WREADY,
      M09_AXI_wstrb(3 downto 0) => ps8_0_axi_periph_M09_AXI_WSTRB(3 downto 0),
      M09_AXI_wvalid => ps8_0_axi_periph_M09_AXI_WVALID,
      S00_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      S00_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      S00_AXI_araddr(39 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARADDR(39 downto 0),
      S00_AXI_arburst(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARBURST(1 downto 0),
      S00_AXI_arcache(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARCACHE(3 downto 0),
      S00_AXI_arid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARID(15 downto 0),
      S00_AXI_arlen(7 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARLEN(7 downto 0),
      S00_AXI_arlock => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARLOCK,
      S00_AXI_arprot(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARPROT(2 downto 0),
      S00_AXI_arqos(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARQOS(3 downto 0),
      S00_AXI_arready => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARREADY,
      S00_AXI_arsize(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARSIZE(2 downto 0),
      S00_AXI_arvalid => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARVALID,
      S00_AXI_awaddr(39 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWADDR(39 downto 0),
      S00_AXI_awburst(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWBURST(1 downto 0),
      S00_AXI_awcache(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWCACHE(3 downto 0),
      S00_AXI_awid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWID(15 downto 0),
      S00_AXI_awlen(7 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWLEN(7 downto 0),
      S00_AXI_awlock => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWLOCK,
      S00_AXI_awprot(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWPROT(2 downto 0),
      S00_AXI_awqos(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWQOS(3 downto 0),
      S00_AXI_awready => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWREADY,
      S00_AXI_awsize(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWSIZE(2 downto 0),
      S00_AXI_awvalid => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWVALID,
      S00_AXI_bid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BID(15 downto 0),
      S00_AXI_bready => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BREADY,
      S00_AXI_bresp(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BRESP(1 downto 0),
      S00_AXI_bvalid => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BVALID,
      S00_AXI_rdata(127 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RDATA(127 downto 0),
      S00_AXI_rid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RID(15 downto 0),
      S00_AXI_rlast => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RLAST,
      S00_AXI_rready => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RREADY,
      S00_AXI_rresp(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RRESP(1 downto 0),
      S00_AXI_rvalid => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RVALID,
      S00_AXI_wdata(127 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WDATA(127 downto 0),
      S00_AXI_wlast => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WLAST,
      S00_AXI_wready => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WREADY,
      S00_AXI_wstrb(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WSTRB(15 downto 0),
      S00_AXI_wvalid => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WVALID,
      S01_ACLK => zynq_ultra_ps_e_0_pl_clk0,
      S01_ARESETN => rst_ps8_0_249M_peripheral_aresetn(0),
      S01_AXI_araddr(39 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARADDR(39 downto 0),
      S01_AXI_arburst(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARBURST(1 downto 0),
      S01_AXI_arcache(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARCACHE(3 downto 0),
      S01_AXI_arid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARID(15 downto 0),
      S01_AXI_arlen(7 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARLEN(7 downto 0),
      S01_AXI_arlock => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARLOCK,
      S01_AXI_arprot(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARPROT(2 downto 0),
      S01_AXI_arqos(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARQOS(3 downto 0),
      S01_AXI_arready => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARREADY,
      S01_AXI_arsize(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARSIZE(2 downto 0),
      S01_AXI_arvalid => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARVALID,
      S01_AXI_awaddr(39 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWADDR(39 downto 0),
      S01_AXI_awburst(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWBURST(1 downto 0),
      S01_AXI_awcache(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWCACHE(3 downto 0),
      S01_AXI_awid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWID(15 downto 0),
      S01_AXI_awlen(7 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWLEN(7 downto 0),
      S01_AXI_awlock => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWLOCK,
      S01_AXI_awprot(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWPROT(2 downto 0),
      S01_AXI_awqos(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWQOS(3 downto 0),
      S01_AXI_awready => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWREADY,
      S01_AXI_awsize(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWSIZE(2 downto 0),
      S01_AXI_awvalid => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWVALID,
      S01_AXI_bid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BID(15 downto 0),
      S01_AXI_bready => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BREADY,
      S01_AXI_bresp(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BRESP(1 downto 0),
      S01_AXI_bvalid => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BVALID,
      S01_AXI_rdata(127 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RDATA(127 downto 0),
      S01_AXI_rid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RID(15 downto 0),
      S01_AXI_rlast => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RLAST,
      S01_AXI_rready => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RREADY,
      S01_AXI_rresp(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RRESP(1 downto 0),
      S01_AXI_rvalid => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RVALID,
      S01_AXI_wdata(127 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WDATA(127 downto 0),
      S01_AXI_wlast => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WLAST,
      S01_AXI_wready => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WREADY,
      S01_AXI_wstrb(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WSTRB(15 downto 0),
      S01_AXI_wvalid => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WVALID
    );
rst_clk_wiz_ctrl: component kv260_video_rst_clk_wiz_ctrl_0
     port map (
      aux_reset_in => '1',
      bus_struct_reset(0) => NLW_rst_clk_wiz_ctrl_bus_struct_reset_UNCONNECTED(0),
      dcm_locked => '1',
      ext_reset_in => zynq_ultra_ps_e_0_pl_resetn0,
      interconnect_aresetn(0) => NLW_rst_clk_wiz_ctrl_interconnect_aresetn_UNCONNECTED(0),
      mb_debug_sys_rst => '0',
      mb_reset => NLW_rst_clk_wiz_ctrl_mb_reset_UNCONNECTED,
      peripheral_aresetn(0) => rst_clk_wiz_ctrl_peripheral_aresetn(0),
      peripheral_reset(0) => NLW_rst_clk_wiz_ctrl_peripheral_reset_UNCONNECTED(0),
      slowest_sync_clk => zynq_ultra_ps_e_0_pl_clk1
    );
rst_ps8_0_249M: component kv260_video_rst_ps8_0_249M_0
     port map (
      aux_reset_in => '1',
      bus_struct_reset(0) => NLW_rst_ps8_0_249M_bus_struct_reset_UNCONNECTED(0),
      dcm_locked => '1',
      ext_reset_in => zynq_ultra_ps_e_0_pl_resetn0,
      interconnect_aresetn(0) => NLW_rst_ps8_0_249M_interconnect_aresetn_UNCONNECTED(0),
      mb_debug_sys_rst => '0',
      mb_reset => NLW_rst_ps8_0_249M_mb_reset_UNCONNECTED,
      peripheral_aresetn(0) => rst_ps8_0_249M_peripheral_aresetn(0),
      peripheral_reset(0) => NLW_rst_ps8_0_249M_peripheral_reset_UNCONNECTED(0),
      slowest_sync_clk => zynq_ultra_ps_e_0_pl_clk0
    );
zynq_ultra_ps_e_0: component kv260_video_zynq_ultra_ps_e_0_0
     port map (
      dp_external_custom_event1 => '0',
      dp_external_custom_event2 => '0',
      dp_external_vsync_event => '0',
      dp_live_gfx_alpha_in(7 downto 0) => B"00000000",
      dp_live_gfx_pixel1_in(35 downto 0) => B"000000000000000000000000000000000000",
      dp_live_video_de_out => NLW_zynq_ultra_ps_e_0_dp_live_video_de_out_UNCONNECTED,
      dp_live_video_in_de => v_axi4s_vid_out_0_vid_active_video,
      dp_live_video_in_hsync => v_axi4s_vid_out_0_vid_hsync,
      dp_live_video_in_pixel1(35 downto 0) => v_axi4s_vid_out_0_vid_data(35 downto 0),
      dp_live_video_in_vsync => v_axi4s_vid_out_0_vid_vsync,
      dp_video_in_clk => clk_wiz_0_clk_out1,
      dp_video_out_hsync => NLW_zynq_ultra_ps_e_0_dp_video_out_hsync_UNCONNECTED,
      dp_video_out_pixel1(35 downto 0) => NLW_zynq_ultra_ps_e_0_dp_video_out_pixel1_UNCONNECTED(35 downto 0),
      dp_video_out_vsync => NLW_zynq_ultra_ps_e_0_dp_video_out_vsync_UNCONNECTED,
      dp_video_ref_clk => NLW_zynq_ultra_ps_e_0_dp_video_ref_clk_UNCONNECTED,
      emio_i2c0_scl_i => zynq_ultra_ps_e_0_IIC_0_SCL_I,
      emio_i2c0_scl_o => zynq_ultra_ps_e_0_IIC_0_SCL_O,
      emio_i2c0_scl_t => zynq_ultra_ps_e_0_IIC_0_SCL_T,
      emio_i2c0_sda_i => zynq_ultra_ps_e_0_IIC_0_SDA_I,
      emio_i2c0_sda_o => zynq_ultra_ps_e_0_IIC_0_SDA_O,
      emio_i2c0_sda_t => zynq_ultra_ps_e_0_IIC_0_SDA_T,
      maxigp0_araddr(39 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARADDR(39 downto 0),
      maxigp0_arburst(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARBURST(1 downto 0),
      maxigp0_arcache(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARCACHE(3 downto 0),
      maxigp0_arid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARID(15 downto 0),
      maxigp0_arlen(7 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARLEN(7 downto 0),
      maxigp0_arlock => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARLOCK,
      maxigp0_arprot(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARPROT(2 downto 0),
      maxigp0_arqos(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARQOS(3 downto 0),
      maxigp0_arready => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARREADY,
      maxigp0_arsize(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARSIZE(2 downto 0),
      maxigp0_aruser(15 downto 0) => NLW_zynq_ultra_ps_e_0_maxigp0_aruser_UNCONNECTED(15 downto 0),
      maxigp0_arvalid => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_ARVALID,
      maxigp0_awaddr(39 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWADDR(39 downto 0),
      maxigp0_awburst(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWBURST(1 downto 0),
      maxigp0_awcache(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWCACHE(3 downto 0),
      maxigp0_awid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWID(15 downto 0),
      maxigp0_awlen(7 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWLEN(7 downto 0),
      maxigp0_awlock => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWLOCK,
      maxigp0_awprot(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWPROT(2 downto 0),
      maxigp0_awqos(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWQOS(3 downto 0),
      maxigp0_awready => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWREADY,
      maxigp0_awsize(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWSIZE(2 downto 0),
      maxigp0_awuser(15 downto 0) => NLW_zynq_ultra_ps_e_0_maxigp0_awuser_UNCONNECTED(15 downto 0),
      maxigp0_awvalid => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_AWVALID,
      maxigp0_bid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BID(15 downto 0),
      maxigp0_bready => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BREADY,
      maxigp0_bresp(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BRESP(1 downto 0),
      maxigp0_bvalid => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_BVALID,
      maxigp0_rdata(127 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RDATA(127 downto 0),
      maxigp0_rid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RID(15 downto 0),
      maxigp0_rlast => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RLAST,
      maxigp0_rready => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RREADY,
      maxigp0_rresp(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RRESP(1 downto 0),
      maxigp0_rvalid => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_RVALID,
      maxigp0_wdata(127 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WDATA(127 downto 0),
      maxigp0_wlast => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WLAST,
      maxigp0_wready => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WREADY,
      maxigp0_wstrb(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WSTRB(15 downto 0),
      maxigp0_wvalid => zynq_ultra_ps_e_0_M_AXI_HPM0_FPD_WVALID,
      maxigp1_araddr(39 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARADDR(39 downto 0),
      maxigp1_arburst(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARBURST(1 downto 0),
      maxigp1_arcache(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARCACHE(3 downto 0),
      maxigp1_arid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARID(15 downto 0),
      maxigp1_arlen(7 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARLEN(7 downto 0),
      maxigp1_arlock => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARLOCK,
      maxigp1_arprot(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARPROT(2 downto 0),
      maxigp1_arqos(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARQOS(3 downto 0),
      maxigp1_arready => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARREADY,
      maxigp1_arsize(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARSIZE(2 downto 0),
      maxigp1_aruser(15 downto 0) => NLW_zynq_ultra_ps_e_0_maxigp1_aruser_UNCONNECTED(15 downto 0),
      maxigp1_arvalid => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_ARVALID,
      maxigp1_awaddr(39 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWADDR(39 downto 0),
      maxigp1_awburst(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWBURST(1 downto 0),
      maxigp1_awcache(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWCACHE(3 downto 0),
      maxigp1_awid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWID(15 downto 0),
      maxigp1_awlen(7 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWLEN(7 downto 0),
      maxigp1_awlock => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWLOCK,
      maxigp1_awprot(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWPROT(2 downto 0),
      maxigp1_awqos(3 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWQOS(3 downto 0),
      maxigp1_awready => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWREADY,
      maxigp1_awsize(2 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWSIZE(2 downto 0),
      maxigp1_awuser(15 downto 0) => NLW_zynq_ultra_ps_e_0_maxigp1_awuser_UNCONNECTED(15 downto 0),
      maxigp1_awvalid => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_AWVALID,
      maxigp1_bid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BID(15 downto 0),
      maxigp1_bready => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BREADY,
      maxigp1_bresp(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BRESP(1 downto 0),
      maxigp1_bvalid => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_BVALID,
      maxigp1_rdata(127 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RDATA(127 downto 0),
      maxigp1_rid(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RID(15 downto 0),
      maxigp1_rlast => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RLAST,
      maxigp1_rready => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RREADY,
      maxigp1_rresp(1 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RRESP(1 downto 0),
      maxigp1_rvalid => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_RVALID,
      maxigp1_wdata(127 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WDATA(127 downto 0),
      maxigp1_wlast => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WLAST,
      maxigp1_wready => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WREADY,
      maxigp1_wstrb(15 downto 0) => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WSTRB(15 downto 0),
      maxigp1_wvalid => zynq_ultra_ps_e_0_M_AXI_HPM1_FPD_WVALID,
      maxihpm0_fpd_aclk => zynq_ultra_ps_e_0_pl_clk0,
      maxihpm1_fpd_aclk => zynq_ultra_ps_e_0_pl_clk0,
      pl_clk0 => zynq_ultra_ps_e_0_pl_clk1,
      pl_ps_irq0(0) => pl_ps_irq0_1,
      pl_resetn0 => zynq_ultra_ps_e_0_pl_resetn0,
      saxigp0_araddr(48 downto 0) => axi_smc_M00_AXI_ARADDR(48 downto 0),
      saxigp0_arburst(1 downto 0) => axi_smc_M00_AXI_ARBURST(1 downto 0),
      saxigp0_arcache(3 downto 0) => axi_smc_M00_AXI_ARCACHE(3 downto 0),
      saxigp0_arid(5 downto 0) => B"000000",
      saxigp0_arlen(7 downto 0) => axi_smc_M00_AXI_ARLEN(7 downto 0),
      saxigp0_arlock => axi_smc_M00_AXI_ARLOCK(0),
      saxigp0_arprot(2 downto 0) => axi_smc_M00_AXI_ARPROT(2 downto 0),
      saxigp0_arqos(3 downto 0) => axi_smc_M00_AXI_ARQOS(3 downto 0),
      saxigp0_arready => axi_smc_M00_AXI_ARREADY,
      saxigp0_arsize(2 downto 0) => axi_smc_M00_AXI_ARSIZE(2 downto 0),
      saxigp0_aruser => '0',
      saxigp0_arvalid => axi_smc_M00_AXI_ARVALID,
      saxigp0_awaddr(48 downto 0) => axi_smc_M00_AXI_AWADDR(48 downto 0),
      saxigp0_awburst(1 downto 0) => axi_smc_M00_AXI_AWBURST(1 downto 0),
      saxigp0_awcache(3 downto 0) => axi_smc_M00_AXI_AWCACHE(3 downto 0),
      saxigp0_awid(5 downto 0) => B"000000",
      saxigp0_awlen(7 downto 0) => axi_smc_M00_AXI_AWLEN(7 downto 0),
      saxigp0_awlock => axi_smc_M00_AXI_AWLOCK(0),
      saxigp0_awprot(2 downto 0) => axi_smc_M00_AXI_AWPROT(2 downto 0),
      saxigp0_awqos(3 downto 0) => axi_smc_M00_AXI_AWQOS(3 downto 0),
      saxigp0_awready => axi_smc_M00_AXI_AWREADY,
      saxigp0_awsize(2 downto 0) => axi_smc_M00_AXI_AWSIZE(2 downto 0),
      saxigp0_awuser => '0',
      saxigp0_awvalid => axi_smc_M00_AXI_AWVALID,
      saxigp0_bid(5 downto 0) => NLW_zynq_ultra_ps_e_0_saxigp0_bid_UNCONNECTED(5 downto 0),
      saxigp0_bready => axi_smc_M00_AXI_BREADY,
      saxigp0_bresp(1 downto 0) => axi_smc_M00_AXI_BRESP(1 downto 0),
      saxigp0_bvalid => axi_smc_M00_AXI_BVALID,
      saxigp0_rdata(127 downto 0) => axi_smc_M00_AXI_RDATA(127 downto 0),
      saxigp0_rid(5 downto 0) => NLW_zynq_ultra_ps_e_0_saxigp0_rid_UNCONNECTED(5 downto 0),
      saxigp0_rlast => axi_smc_M00_AXI_RLAST,
      saxigp0_rready => axi_smc_M00_AXI_RREADY,
      saxigp0_rresp(1 downto 0) => axi_smc_M00_AXI_RRESP(1 downto 0),
      saxigp0_rvalid => axi_smc_M00_AXI_RVALID,
      saxigp0_wdata(127 downto 0) => axi_smc_M00_AXI_WDATA(127 downto 0),
      saxigp0_wlast => axi_smc_M00_AXI_WLAST,
      saxigp0_wready => axi_smc_M00_AXI_WREADY,
      saxigp0_wstrb(15 downto 0) => axi_smc_M00_AXI_WSTRB(15 downto 0),
      saxigp0_wvalid => axi_smc_M00_AXI_WVALID,
      saxihpc0_fpd_aclk => zynq_ultra_ps_e_0_pl_clk0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity PS_VIDEO_imp_YI3F7Y is
  port (
    gpio_tri_o : out STD_LOGIC_VECTOR ( 2 downto 0 );
    iic_scl_i : in STD_LOGIC;
    iic_scl_o : out STD_LOGIC;
    iic_scl_t : out STD_LOGIC;
    iic_sda_i : in STD_LOGIC;
    iic_sda_o : out STD_LOGIC;
    iic_sda_t : out STD_LOGIC;
    mipi_phy_if_clk_n : in STD_LOGIC;
    mipi_phy_if_clk_p : in STD_LOGIC;
    mipi_phy_if_data_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_phy_if_data_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_rx_ias_clk_n : in STD_LOGIC;
    mipi_rx_ias_clk_p : in STD_LOGIC;
    mipi_rx_ias_data_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mipi_rx_ias_data_p : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end PS_VIDEO_imp_YI3F7Y;

architecture STRUCTURE of PS_VIDEO_imp_YI3F7Y is
  signal Conn1_TRI_O : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S_AXIS_S2MM1_1_TDATA : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal S_AXIS_S2MM1_1_TKEEP : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S_AXIS_S2MM1_1_TLAST : STD_LOGIC;
  signal S_AXIS_S2MM1_1_TREADY : STD_LOGIC;
  signal S_AXIS_S2MM1_1_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal S_AXIS_S2MM1_1_TVALID : STD_LOGIC;
  signal S_AXIS_S2MM_1_TDATA : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal S_AXIS_S2MM_1_TKEEP : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S_AXIS_S2MM_1_TLAST : STD_LOGIC;
  signal S_AXIS_S2MM_1_TREADY : STD_LOGIC;
  signal S_AXIS_S2MM_1_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal S_AXIS_S2MM_1_TVALID : STD_LOGIC;
  signal TO_PS_M05_AXI1_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal TO_PS_M05_AXI1_ARREADY : STD_LOGIC;
  signal TO_PS_M05_AXI1_ARVALID : STD_LOGIC;
  signal TO_PS_M05_AXI1_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal TO_PS_M05_AXI1_AWREADY : STD_LOGIC;
  signal TO_PS_M05_AXI1_AWVALID : STD_LOGIC;
  signal TO_PS_M05_AXI1_BREADY : STD_LOGIC;
  signal TO_PS_M05_AXI1_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal TO_PS_M05_AXI1_BVALID : STD_LOGIC;
  signal TO_PS_M05_AXI1_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal TO_PS_M05_AXI1_RREADY : STD_LOGIC;
  signal TO_PS_M05_AXI1_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal TO_PS_M05_AXI1_RVALID : STD_LOGIC;
  signal TO_PS_M05_AXI1_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal TO_PS_M05_AXI1_WREADY : STD_LOGIC;
  signal TO_PS_M05_AXI1_WVALID : STD_LOGIC;
  signal TO_PS_M07_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal TO_PS_M07_AXI_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M07_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M07_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal TO_PS_M07_AXI_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M07_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M07_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M07_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal TO_PS_M07_AXI_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M07_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal TO_PS_M07_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M07_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal TO_PS_M07_AXI_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M07_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal TO_PS_M07_AXI_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M07_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal TO_PS_M07_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M08_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal TO_PS_M08_AXI_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M08_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M08_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal TO_PS_M08_AXI_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M08_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M08_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M08_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal TO_PS_M08_AXI_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M08_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal TO_PS_M08_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M08_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal TO_PS_M08_AXI_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M08_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal TO_PS_M08_AXI_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TO_PS_M08_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal TO_PS_M08_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal V_DMA_s2mm_introut : STD_LOGIC;
  signal axi_smc_M00_AXI_ARADDR : STD_LOGIC_VECTOR ( 48 downto 0 );
  signal axi_smc_M00_AXI_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_ARLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_smc_M00_AXI_ARLOCK : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axi_smc_M00_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_ARREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_ARVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_AWADDR : STD_LOGIC_VECTOR ( 48 downto 0 );
  signal axi_smc_M00_AXI_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_AWLEN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_smc_M00_AXI_AWLOCK : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axi_smc_M00_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_smc_M00_AXI_AWREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_smc_M00_AXI_AWVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_BREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_BVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_RDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal axi_smc_M00_AXI_RLAST : STD_LOGIC;
  signal axi_smc_M00_AXI_RREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_smc_M00_AXI_RVALID : STD_LOGIC;
  signal axi_smc_M00_AXI_WDATA : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal axi_smc_M00_AXI_WLAST : STD_LOGIC;
  signal axi_smc_M00_AXI_WREADY : STD_LOGIC;
  signal axi_smc_M00_AXI_WSTRB : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal axi_smc_M00_AXI_WVALID : STD_LOGIC;
  signal clk_wiz_0_clk_out1 : STD_LOGIC;
  signal dphy_clk_200M_1 : STD_LOGIC;
  signal mipi_phy_if_0_1_CLK_N : STD_LOGIC;
  signal mipi_phy_if_0_1_CLK_P : STD_LOGIC;
  signal mipi_phy_if_0_1_DATA_N : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal mipi_phy_if_0_1_DATA_P : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal mipi_rx_ias1_1_CLK_N : STD_LOGIC;
  signal mipi_rx_ias1_1_CLK_P : STD_LOGIC;
  signal mipi_rx_ias1_1_DATA_N : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal mipi_rx_ias1_1_DATA_P : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_ARVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_AWVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_BREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_RREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M01_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M01_AXI_WVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M02_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M02_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M02_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M03_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M03_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M05_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_ARREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_ARVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_AWREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_AWVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_BREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_BVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_RREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_RVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_WREADY : STD_LOGIC;
  signal ps8_0_axi_periph_M05_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M05_AXI_WVALID : STD_LOGIC;
  signal ps8_0_axi_periph_M06_AXI_ARADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_AWADDR : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps8_0_axi_periph_M06_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps8_0_axi_periph_M06_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal rst_ps8_0_249M_peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  signal v_axi4s_vid_out_0_vid_active_video : STD_LOGIC;
  signal v_axi4s_vid_out_0_vid_data : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal v_axi4s_vid_out_0_vid_hsync : STD_LOGIC;
  signal v_axi4s_vid_out_0_vid_vsync : STD_LOGIC;
  signal video_in_1_TDATA : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal video_in_1_TLAST : STD_LOGIC;
  signal video_in_1_TREADY : STD_LOGIC;
  signal video_in_1_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal video_in_1_TVALID : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SCL_I : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SCL_O : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SCL_T : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SDA_I : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SDA_O : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SDA_T : STD_LOGIC;
  signal zynq_ultra_ps_e_0_pl_clk0 : STD_LOGIC;
  signal NLW_V_DMA_M_AXIS_MM2S_tkeep_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
begin
  gpio_tri_o(2 downto 0) <= Conn1_TRI_O(2 downto 0);
  iic_scl_o <= zynq_ultra_ps_e_0_IIC_0_SCL_O;
  iic_scl_t <= zynq_ultra_ps_e_0_IIC_0_SCL_T;
  iic_sda_o <= zynq_ultra_ps_e_0_IIC_0_SDA_O;
  iic_sda_t <= zynq_ultra_ps_e_0_IIC_0_SDA_T;
  mipi_phy_if_0_1_CLK_N <= mipi_phy_if_clk_n;
  mipi_phy_if_0_1_CLK_P <= mipi_phy_if_clk_p;
  mipi_phy_if_0_1_DATA_N(1 downto 0) <= mipi_phy_if_data_n(1 downto 0);
  mipi_phy_if_0_1_DATA_P(1 downto 0) <= mipi_phy_if_data_p(1 downto 0);
  mipi_rx_ias1_1_CLK_N <= mipi_rx_ias_clk_n;
  mipi_rx_ias1_1_CLK_P <= mipi_rx_ias_clk_p;
  mipi_rx_ias1_1_DATA_N(3 downto 0) <= mipi_rx_ias_data_n(3 downto 0);
  mipi_rx_ias1_1_DATA_P(3 downto 0) <= mipi_rx_ias_data_p(3 downto 0);
  zynq_ultra_ps_e_0_IIC_0_SCL_I <= iic_scl_i;
  zynq_ultra_ps_e_0_IIC_0_SDA_I <= iic_sda_i;
RX_VIDEO: entity work.RX_VIDEO_imp_QQ232Y
     port map (
      aclk => zynq_ultra_ps_e_0_pl_clk0,
      aresetn => rst_ps8_0_249M_peripheral_aresetn(0),
      csirxss_s_axi1_araddr(39 downto 0) => TO_PS_M07_AXI_ARADDR(39 downto 0),
      csirxss_s_axi1_arready(0) => TO_PS_M07_AXI_ARREADY(0),
      csirxss_s_axi1_arvalid(0) => TO_PS_M07_AXI_ARVALID(0),
      csirxss_s_axi1_awaddr(39 downto 0) => TO_PS_M07_AXI_AWADDR(39 downto 0),
      csirxss_s_axi1_awready(0) => TO_PS_M07_AXI_AWREADY(0),
      csirxss_s_axi1_awvalid(0) => TO_PS_M07_AXI_AWVALID(0),
      csirxss_s_axi1_bready(0) => TO_PS_M07_AXI_BREADY(0),
      csirxss_s_axi1_bresp(1 downto 0) => TO_PS_M07_AXI_BRESP(1 downto 0),
      csirxss_s_axi1_bvalid(0) => TO_PS_M07_AXI_BVALID(0),
      csirxss_s_axi1_rdata(31 downto 0) => TO_PS_M07_AXI_RDATA(31 downto 0),
      csirxss_s_axi1_rready(0) => TO_PS_M07_AXI_RREADY(0),
      csirxss_s_axi1_rresp(1 downto 0) => TO_PS_M07_AXI_RRESP(1 downto 0),
      csirxss_s_axi1_rvalid(0) => TO_PS_M07_AXI_RVALID(0),
      csirxss_s_axi1_wdata(31 downto 0) => TO_PS_M07_AXI_WDATA(31 downto 0),
      csirxss_s_axi1_wready(0) => TO_PS_M07_AXI_WREADY(0),
      csirxss_s_axi1_wstrb(3 downto 0) => TO_PS_M07_AXI_WSTRB(3 downto 0),
      csirxss_s_axi1_wvalid(0) => TO_PS_M07_AXI_WVALID(0),
      csirxss_s_axi_araddr(39 downto 0) => ps8_0_axi_periph_M02_AXI_ARADDR(39 downto 0),
      csirxss_s_axi_arready(0) => ps8_0_axi_periph_M02_AXI_ARREADY(0),
      csirxss_s_axi_arvalid(0) => ps8_0_axi_periph_M02_AXI_ARVALID(0),
      csirxss_s_axi_awaddr(39 downto 0) => ps8_0_axi_periph_M02_AXI_AWADDR(39 downto 0),
      csirxss_s_axi_awready(0) => ps8_0_axi_periph_M02_AXI_AWREADY(0),
      csirxss_s_axi_awvalid(0) => ps8_0_axi_periph_M02_AXI_AWVALID(0),
      csirxss_s_axi_bready(0) => ps8_0_axi_periph_M02_AXI_BREADY(0),
      csirxss_s_axi_bresp(1 downto 0) => ps8_0_axi_periph_M02_AXI_BRESP(1 downto 0),
      csirxss_s_axi_bvalid(0) => ps8_0_axi_periph_M02_AXI_BVALID(0),
      csirxss_s_axi_rdata(31 downto 0) => ps8_0_axi_periph_M02_AXI_RDATA(31 downto 0),
      csirxss_s_axi_rready(0) => ps8_0_axi_periph_M02_AXI_RREADY(0),
      csirxss_s_axi_rresp(1 downto 0) => ps8_0_axi_periph_M02_AXI_RRESP(1 downto 0),
      csirxss_s_axi_rvalid(0) => ps8_0_axi_periph_M02_AXI_RVALID(0),
      csirxss_s_axi_wdata(31 downto 0) => ps8_0_axi_periph_M02_AXI_WDATA(31 downto 0),
      csirxss_s_axi_wready(0) => ps8_0_axi_periph_M02_AXI_WREADY(0),
      csirxss_s_axi_wstrb(3 downto 0) => ps8_0_axi_periph_M02_AXI_WSTRB(3 downto 0),
      csirxss_s_axi_wvalid(0) => ps8_0_axi_periph_M02_AXI_WVALID(0),
      dphy_clk_200M => dphy_clk_200M_1,
      m_axis_video_tdata(23 downto 0) => S_AXIS_S2MM_1_TDATA(23 downto 0),
      m_axis_video_tkeep(2 downto 0) => S_AXIS_S2MM_1_TKEEP(2 downto 0),
      m_axis_video_tlast => S_AXIS_S2MM_1_TLAST,
      m_axis_video_tready => S_AXIS_S2MM_1_TREADY,
      m_axis_video_tuser(0) => S_AXIS_S2MM_1_TUSER(0),
      m_axis_video_tvalid => S_AXIS_S2MM_1_TVALID,
      mipi_phy_if_clk_n => mipi_phy_if_0_1_CLK_N,
      mipi_phy_if_clk_p => mipi_phy_if_0_1_CLK_P,
      mipi_phy_if_data_n(1 downto 0) => mipi_phy_if_0_1_DATA_N(1 downto 0),
      mipi_phy_if_data_p(1 downto 0) => mipi_phy_if_0_1_DATA_P(1 downto 0),
      mipi_rx_ias_clk_n => mipi_rx_ias1_1_CLK_N,
      mipi_rx_ias_clk_p => mipi_rx_ias1_1_CLK_P,
      mipi_rx_ias_data_n(3 downto 0) => mipi_rx_ias1_1_DATA_N(3 downto 0),
      mipi_rx_ias_data_p(3 downto 0) => mipi_rx_ias1_1_DATA_P(3 downto 0),
      o1video_tdata(23 downto 0) => S_AXIS_S2MM1_1_TDATA(23 downto 0),
      o1video_tkeep(2 downto 0) => S_AXIS_S2MM1_1_TKEEP(2 downto 0),
      o1video_tlast => S_AXIS_S2MM1_1_TLAST,
      o1video_tready => S_AXIS_S2MM1_1_TREADY,
      o1video_tuser(0) => S_AXIS_S2MM1_1_TUSER(0),
      o1video_tvalid => S_AXIS_S2MM1_1_TVALID,
      s_axi_CTRL1_araddr(39 downto 0) => TO_PS_M08_AXI_ARADDR(39 downto 0),
      s_axi_CTRL1_arready(0) => TO_PS_M08_AXI_ARREADY(0),
      s_axi_CTRL1_arvalid(0) => TO_PS_M08_AXI_ARVALID(0),
      s_axi_CTRL1_awaddr(39 downto 0) => TO_PS_M08_AXI_AWADDR(39 downto 0),
      s_axi_CTRL1_awready(0) => TO_PS_M08_AXI_AWREADY(0),
      s_axi_CTRL1_awvalid(0) => TO_PS_M08_AXI_AWVALID(0),
      s_axi_CTRL1_bready(0) => TO_PS_M08_AXI_BREADY(0),
      s_axi_CTRL1_bresp(1 downto 0) => TO_PS_M08_AXI_BRESP(1 downto 0),
      s_axi_CTRL1_bvalid(0) => TO_PS_M08_AXI_BVALID(0),
      s_axi_CTRL1_rdata(31 downto 0) => TO_PS_M08_AXI_RDATA(31 downto 0),
      s_axi_CTRL1_rready(0) => TO_PS_M08_AXI_RREADY(0),
      s_axi_CTRL1_rresp(1 downto 0) => TO_PS_M08_AXI_RRESP(1 downto 0),
      s_axi_CTRL1_rvalid(0) => TO_PS_M08_AXI_RVALID(0),
      s_axi_CTRL1_wdata(31 downto 0) => TO_PS_M08_AXI_WDATA(31 downto 0),
      s_axi_CTRL1_wready(0) => TO_PS_M08_AXI_WREADY(0),
      s_axi_CTRL1_wstrb(3 downto 0) => TO_PS_M08_AXI_WSTRB(3 downto 0),
      s_axi_CTRL1_wvalid(0) => TO_PS_M08_AXI_WVALID(0),
      s_axi_CTRL_araddr(39 downto 0) => ps8_0_axi_periph_M03_AXI_ARADDR(39 downto 0),
      s_axi_CTRL_arready(0) => ps8_0_axi_periph_M03_AXI_ARREADY(0),
      s_axi_CTRL_arvalid(0) => ps8_0_axi_periph_M03_AXI_ARVALID(0),
      s_axi_CTRL_awaddr(39 downto 0) => ps8_0_axi_periph_M03_AXI_AWADDR(39 downto 0),
      s_axi_CTRL_awready(0) => ps8_0_axi_periph_M03_AXI_AWREADY(0),
      s_axi_CTRL_awvalid(0) => ps8_0_axi_periph_M03_AXI_AWVALID(0),
      s_axi_CTRL_bready(0) => ps8_0_axi_periph_M03_AXI_BREADY(0),
      s_axi_CTRL_bresp(1 downto 0) => ps8_0_axi_periph_M03_AXI_BRESP(1 downto 0),
      s_axi_CTRL_bvalid(0) => ps8_0_axi_periph_M03_AXI_BVALID(0),
      s_axi_CTRL_rdata(31 downto 0) => ps8_0_axi_periph_M03_AXI_RDATA(31 downto 0),
      s_axi_CTRL_rready(0) => ps8_0_axi_periph_M03_AXI_RREADY(0),
      s_axi_CTRL_rresp(1 downto 0) => ps8_0_axi_periph_M03_AXI_RRESP(1 downto 0),
      s_axi_CTRL_rvalid(0) => ps8_0_axi_periph_M03_AXI_RVALID(0),
      s_axi_CTRL_wdata(31 downto 0) => ps8_0_axi_periph_M03_AXI_WDATA(31 downto 0),
      s_axi_CTRL_wready(0) => ps8_0_axi_periph_M03_AXI_WREADY(0),
      s_axi_CTRL_wstrb(3 downto 0) => ps8_0_axi_periph_M03_AXI_WSTRB(3 downto 0),
      s_axi_CTRL_wvalid(0) => ps8_0_axi_periph_M03_AXI_WVALID(0),
      vfpconfig_araddr(39 downto 0) => ps8_0_axi_periph_M06_AXI_ARADDR(39 downto 0),
      vfpconfig_arprot(2 downto 0) => ps8_0_axi_periph_M06_AXI_ARPROT(2 downto 0),
      vfpconfig_arready(0) => ps8_0_axi_periph_M06_AXI_ARREADY(0),
      vfpconfig_arvalid(0) => ps8_0_axi_periph_M06_AXI_ARVALID(0),
      vfpconfig_awaddr(39 downto 0) => ps8_0_axi_periph_M06_AXI_AWADDR(39 downto 0),
      vfpconfig_awprot(2 downto 0) => ps8_0_axi_periph_M06_AXI_AWPROT(2 downto 0),
      vfpconfig_awready(0) => ps8_0_axi_periph_M06_AXI_AWREADY(0),
      vfpconfig_awvalid(0) => ps8_0_axi_periph_M06_AXI_AWVALID(0),
      vfpconfig_bready(0) => ps8_0_axi_periph_M06_AXI_BREADY(0),
      vfpconfig_bresp(1 downto 0) => ps8_0_axi_periph_M06_AXI_BRESP(1 downto 0),
      vfpconfig_bvalid(0) => ps8_0_axi_periph_M06_AXI_BVALID(0),
      vfpconfig_rdata(31 downto 0) => ps8_0_axi_periph_M06_AXI_RDATA(31 downto 0),
      vfpconfig_rready(0) => ps8_0_axi_periph_M06_AXI_RREADY(0),
      vfpconfig_rresp(1 downto 0) => ps8_0_axi_periph_M06_AXI_RRESP(1 downto 0),
      vfpconfig_rvalid(0) => ps8_0_axi_periph_M06_AXI_RVALID(0),
      vfpconfig_wdata(31 downto 0) => ps8_0_axi_periph_M06_AXI_WDATA(31 downto 0),
      vfpconfig_wready(0) => ps8_0_axi_periph_M06_AXI_WREADY(0),
      vfpconfig_wstrb(3 downto 0) => ps8_0_axi_periph_M06_AXI_WSTRB(3 downto 0),
      vfpconfig_wvalid(0) => ps8_0_axi_periph_M06_AXI_WVALID(0)
    );
TO_PS: entity work.TO_PS_imp_PC26XI
     port map (
      M01_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M01_AXI_ARADDR(39 downto 0),
      M01_AXI_arready => ps8_0_axi_periph_M01_AXI_ARREADY,
      M01_AXI_arvalid => ps8_0_axi_periph_M01_AXI_ARVALID,
      M01_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M01_AXI_AWADDR(39 downto 0),
      M01_AXI_awready => ps8_0_axi_periph_M01_AXI_AWREADY,
      M01_AXI_awvalid => ps8_0_axi_periph_M01_AXI_AWVALID,
      M01_AXI_bready => ps8_0_axi_periph_M01_AXI_BREADY,
      M01_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M01_AXI_BRESP(1 downto 0),
      M01_AXI_bvalid => ps8_0_axi_periph_M01_AXI_BVALID,
      M01_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M01_AXI_RDATA(31 downto 0),
      M01_AXI_rready => ps8_0_axi_periph_M01_AXI_RREADY,
      M01_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M01_AXI_RRESP(1 downto 0),
      M01_AXI_rvalid => ps8_0_axi_periph_M01_AXI_RVALID,
      M01_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M01_AXI_WDATA(31 downto 0),
      M01_AXI_wready => ps8_0_axi_periph_M01_AXI_WREADY,
      M01_AXI_wvalid => ps8_0_axi_periph_M01_AXI_WVALID,
      M02_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M02_AXI_ARADDR(39 downto 0),
      M02_AXI_arready(0) => ps8_0_axi_periph_M02_AXI_ARREADY(0),
      M02_AXI_arvalid(0) => ps8_0_axi_periph_M02_AXI_ARVALID(0),
      M02_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M02_AXI_AWADDR(39 downto 0),
      M02_AXI_awready(0) => ps8_0_axi_periph_M02_AXI_AWREADY(0),
      M02_AXI_awvalid(0) => ps8_0_axi_periph_M02_AXI_AWVALID(0),
      M02_AXI_bready(0) => ps8_0_axi_periph_M02_AXI_BREADY(0),
      M02_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M02_AXI_BRESP(1 downto 0),
      M02_AXI_bvalid(0) => ps8_0_axi_periph_M02_AXI_BVALID(0),
      M02_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M02_AXI_RDATA(31 downto 0),
      M02_AXI_rready(0) => ps8_0_axi_periph_M02_AXI_RREADY(0),
      M02_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M02_AXI_RRESP(1 downto 0),
      M02_AXI_rvalid(0) => ps8_0_axi_periph_M02_AXI_RVALID(0),
      M02_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M02_AXI_WDATA(31 downto 0),
      M02_AXI_wready(0) => ps8_0_axi_periph_M02_AXI_WREADY(0),
      M02_AXI_wstrb(3 downto 0) => ps8_0_axi_periph_M02_AXI_WSTRB(3 downto 0),
      M02_AXI_wvalid(0) => ps8_0_axi_periph_M02_AXI_WVALID(0),
      M03_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M03_AXI_ARADDR(39 downto 0),
      M03_AXI_arready(0) => ps8_0_axi_periph_M03_AXI_ARREADY(0),
      M03_AXI_arvalid(0) => ps8_0_axi_periph_M03_AXI_ARVALID(0),
      M03_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M03_AXI_AWADDR(39 downto 0),
      M03_AXI_awready(0) => ps8_0_axi_periph_M03_AXI_AWREADY(0),
      M03_AXI_awvalid(0) => ps8_0_axi_periph_M03_AXI_AWVALID(0),
      M03_AXI_bready(0) => ps8_0_axi_periph_M03_AXI_BREADY(0),
      M03_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M03_AXI_BRESP(1 downto 0),
      M03_AXI_bvalid(0) => ps8_0_axi_periph_M03_AXI_BVALID(0),
      M03_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M03_AXI_RDATA(31 downto 0),
      M03_AXI_rready(0) => ps8_0_axi_periph_M03_AXI_RREADY(0),
      M03_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M03_AXI_RRESP(1 downto 0),
      M03_AXI_rvalid(0) => ps8_0_axi_periph_M03_AXI_RVALID(0),
      M03_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M03_AXI_WDATA(31 downto 0),
      M03_AXI_wready(0) => ps8_0_axi_periph_M03_AXI_WREADY(0),
      M03_AXI_wstrb(3 downto 0) => ps8_0_axi_periph_M03_AXI_WSTRB(3 downto 0),
      M03_AXI_wvalid(0) => ps8_0_axi_periph_M03_AXI_WVALID(0),
      M05_AXI1_araddr(39 downto 0) => TO_PS_M05_AXI1_ARADDR(39 downto 0),
      M05_AXI1_arready => TO_PS_M05_AXI1_ARREADY,
      M05_AXI1_arvalid => TO_PS_M05_AXI1_ARVALID,
      M05_AXI1_awaddr(39 downto 0) => TO_PS_M05_AXI1_AWADDR(39 downto 0),
      M05_AXI1_awready => TO_PS_M05_AXI1_AWREADY,
      M05_AXI1_awvalid => TO_PS_M05_AXI1_AWVALID,
      M05_AXI1_bready => TO_PS_M05_AXI1_BREADY,
      M05_AXI1_bresp(1 downto 0) => TO_PS_M05_AXI1_BRESP(1 downto 0),
      M05_AXI1_bvalid => TO_PS_M05_AXI1_BVALID,
      M05_AXI1_rdata(31 downto 0) => TO_PS_M05_AXI1_RDATA(31 downto 0),
      M05_AXI1_rready => TO_PS_M05_AXI1_RREADY,
      M05_AXI1_rresp(1 downto 0) => TO_PS_M05_AXI1_RRESP(1 downto 0),
      M05_AXI1_rvalid => TO_PS_M05_AXI1_RVALID,
      M05_AXI1_wdata(31 downto 0) => TO_PS_M05_AXI1_WDATA(31 downto 0),
      M05_AXI1_wready => TO_PS_M05_AXI1_WREADY,
      M05_AXI1_wvalid => TO_PS_M05_AXI1_WVALID,
      M05_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M05_AXI_ARADDR(39 downto 0),
      M05_AXI_arready => ps8_0_axi_periph_M05_AXI_ARREADY,
      M05_AXI_arvalid => ps8_0_axi_periph_M05_AXI_ARVALID,
      M05_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M05_AXI_AWADDR(39 downto 0),
      M05_AXI_awready => ps8_0_axi_periph_M05_AXI_AWREADY,
      M05_AXI_awvalid => ps8_0_axi_periph_M05_AXI_AWVALID,
      M05_AXI_bready => ps8_0_axi_periph_M05_AXI_BREADY,
      M05_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M05_AXI_BRESP(1 downto 0),
      M05_AXI_bvalid => ps8_0_axi_periph_M05_AXI_BVALID,
      M05_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M05_AXI_RDATA(31 downto 0),
      M05_AXI_rready => ps8_0_axi_periph_M05_AXI_RREADY,
      M05_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M05_AXI_RRESP(1 downto 0),
      M05_AXI_rvalid => ps8_0_axi_periph_M05_AXI_RVALID,
      M05_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M05_AXI_WDATA(31 downto 0),
      M05_AXI_wready => ps8_0_axi_periph_M05_AXI_WREADY,
      M05_AXI_wstrb(3 downto 0) => ps8_0_axi_periph_M05_AXI_WSTRB(3 downto 0),
      M05_AXI_wvalid => ps8_0_axi_periph_M05_AXI_WVALID,
      M06_AXI_araddr(39 downto 0) => ps8_0_axi_periph_M06_AXI_ARADDR(39 downto 0),
      M06_AXI_arprot(2 downto 0) => ps8_0_axi_periph_M06_AXI_ARPROT(2 downto 0),
      M06_AXI_arready(0) => ps8_0_axi_periph_M06_AXI_ARREADY(0),
      M06_AXI_arvalid(0) => ps8_0_axi_periph_M06_AXI_ARVALID(0),
      M06_AXI_awaddr(39 downto 0) => ps8_0_axi_periph_M06_AXI_AWADDR(39 downto 0),
      M06_AXI_awprot(2 downto 0) => ps8_0_axi_periph_M06_AXI_AWPROT(2 downto 0),
      M06_AXI_awready(0) => ps8_0_axi_periph_M06_AXI_AWREADY(0),
      M06_AXI_awvalid(0) => ps8_0_axi_periph_M06_AXI_AWVALID(0),
      M06_AXI_bready(0) => ps8_0_axi_periph_M06_AXI_BREADY(0),
      M06_AXI_bresp(1 downto 0) => ps8_0_axi_periph_M06_AXI_BRESP(1 downto 0),
      M06_AXI_bvalid(0) => ps8_0_axi_periph_M06_AXI_BVALID(0),
      M06_AXI_rdata(31 downto 0) => ps8_0_axi_periph_M06_AXI_RDATA(31 downto 0),
      M06_AXI_rready(0) => ps8_0_axi_periph_M06_AXI_RREADY(0),
      M06_AXI_rresp(1 downto 0) => ps8_0_axi_periph_M06_AXI_RRESP(1 downto 0),
      M06_AXI_rvalid(0) => ps8_0_axi_periph_M06_AXI_RVALID(0),
      M06_AXI_wdata(31 downto 0) => ps8_0_axi_periph_M06_AXI_WDATA(31 downto 0),
      M06_AXI_wready(0) => ps8_0_axi_periph_M06_AXI_WREADY(0),
      M06_AXI_wstrb(3 downto 0) => ps8_0_axi_periph_M06_AXI_WSTRB(3 downto 0),
      M06_AXI_wvalid(0) => ps8_0_axi_periph_M06_AXI_WVALID(0),
      M07_AXI_araddr(39 downto 0) => TO_PS_M07_AXI_ARADDR(39 downto 0),
      M07_AXI_arready(0) => TO_PS_M07_AXI_ARREADY(0),
      M07_AXI_arvalid(0) => TO_PS_M07_AXI_ARVALID(0),
      M07_AXI_awaddr(39 downto 0) => TO_PS_M07_AXI_AWADDR(39 downto 0),
      M07_AXI_awready(0) => TO_PS_M07_AXI_AWREADY(0),
      M07_AXI_awvalid(0) => TO_PS_M07_AXI_AWVALID(0),
      M07_AXI_bready(0) => TO_PS_M07_AXI_BREADY(0),
      M07_AXI_bresp(1 downto 0) => TO_PS_M07_AXI_BRESP(1 downto 0),
      M07_AXI_bvalid(0) => TO_PS_M07_AXI_BVALID(0),
      M07_AXI_rdata(31 downto 0) => TO_PS_M07_AXI_RDATA(31 downto 0),
      M07_AXI_rready(0) => TO_PS_M07_AXI_RREADY(0),
      M07_AXI_rresp(1 downto 0) => TO_PS_M07_AXI_RRESP(1 downto 0),
      M07_AXI_rvalid(0) => TO_PS_M07_AXI_RVALID(0),
      M07_AXI_wdata(31 downto 0) => TO_PS_M07_AXI_WDATA(31 downto 0),
      M07_AXI_wready(0) => TO_PS_M07_AXI_WREADY(0),
      M07_AXI_wstrb(3 downto 0) => TO_PS_M07_AXI_WSTRB(3 downto 0),
      M07_AXI_wvalid(0) => TO_PS_M07_AXI_WVALID(0),
      M08_AXI_araddr(39 downto 0) => TO_PS_M08_AXI_ARADDR(39 downto 0),
      M08_AXI_arready(0) => TO_PS_M08_AXI_ARREADY(0),
      M08_AXI_arvalid(0) => TO_PS_M08_AXI_ARVALID(0),
      M08_AXI_awaddr(39 downto 0) => TO_PS_M08_AXI_AWADDR(39 downto 0),
      M08_AXI_awready(0) => TO_PS_M08_AXI_AWREADY(0),
      M08_AXI_awvalid(0) => TO_PS_M08_AXI_AWVALID(0),
      M08_AXI_bready(0) => TO_PS_M08_AXI_BREADY(0),
      M08_AXI_bresp(1 downto 0) => TO_PS_M08_AXI_BRESP(1 downto 0),
      M08_AXI_bvalid(0) => TO_PS_M08_AXI_BVALID(0),
      M08_AXI_rdata(31 downto 0) => TO_PS_M08_AXI_RDATA(31 downto 0),
      M08_AXI_rready(0) => TO_PS_M08_AXI_RREADY(0),
      M08_AXI_rresp(1 downto 0) => TO_PS_M08_AXI_RRESP(1 downto 0),
      M08_AXI_rvalid(0) => TO_PS_M08_AXI_RVALID(0),
      M08_AXI_wdata(31 downto 0) => TO_PS_M08_AXI_WDATA(31 downto 0),
      M08_AXI_wready(0) => TO_PS_M08_AXI_WREADY(0),
      M08_AXI_wstrb(3 downto 0) => TO_PS_M08_AXI_WSTRB(3 downto 0),
      M08_AXI_wvalid(0) => TO_PS_M08_AXI_WVALID(0),
      S_AXI_HPC0_FPD_araddr(48 downto 0) => axi_smc_M00_AXI_ARADDR(48 downto 0),
      S_AXI_HPC0_FPD_arburst(1 downto 0) => axi_smc_M00_AXI_ARBURST(1 downto 0),
      S_AXI_HPC0_FPD_arcache(3 downto 0) => axi_smc_M00_AXI_ARCACHE(3 downto 0),
      S_AXI_HPC0_FPD_arlen(7 downto 0) => axi_smc_M00_AXI_ARLEN(7 downto 0),
      S_AXI_HPC0_FPD_arlock(0) => axi_smc_M00_AXI_ARLOCK(0),
      S_AXI_HPC0_FPD_arprot(2 downto 0) => axi_smc_M00_AXI_ARPROT(2 downto 0),
      S_AXI_HPC0_FPD_arqos(3 downto 0) => axi_smc_M00_AXI_ARQOS(3 downto 0),
      S_AXI_HPC0_FPD_arready => axi_smc_M00_AXI_ARREADY,
      S_AXI_HPC0_FPD_arsize(2 downto 0) => axi_smc_M00_AXI_ARSIZE(2 downto 0),
      S_AXI_HPC0_FPD_arvalid => axi_smc_M00_AXI_ARVALID,
      S_AXI_HPC0_FPD_awaddr(48 downto 0) => axi_smc_M00_AXI_AWADDR(48 downto 0),
      S_AXI_HPC0_FPD_awburst(1 downto 0) => axi_smc_M00_AXI_AWBURST(1 downto 0),
      S_AXI_HPC0_FPD_awcache(3 downto 0) => axi_smc_M00_AXI_AWCACHE(3 downto 0),
      S_AXI_HPC0_FPD_awlen(7 downto 0) => axi_smc_M00_AXI_AWLEN(7 downto 0),
      S_AXI_HPC0_FPD_awlock(0) => axi_smc_M00_AXI_AWLOCK(0),
      S_AXI_HPC0_FPD_awprot(2 downto 0) => axi_smc_M00_AXI_AWPROT(2 downto 0),
      S_AXI_HPC0_FPD_awqos(3 downto 0) => axi_smc_M00_AXI_AWQOS(3 downto 0),
      S_AXI_HPC0_FPD_awready => axi_smc_M00_AXI_AWREADY,
      S_AXI_HPC0_FPD_awsize(2 downto 0) => axi_smc_M00_AXI_AWSIZE(2 downto 0),
      S_AXI_HPC0_FPD_awvalid => axi_smc_M00_AXI_AWVALID,
      S_AXI_HPC0_FPD_bready => axi_smc_M00_AXI_BREADY,
      S_AXI_HPC0_FPD_bresp(1 downto 0) => axi_smc_M00_AXI_BRESP(1 downto 0),
      S_AXI_HPC0_FPD_bvalid => axi_smc_M00_AXI_BVALID,
      S_AXI_HPC0_FPD_rdata(127 downto 0) => axi_smc_M00_AXI_RDATA(127 downto 0),
      S_AXI_HPC0_FPD_rlast => axi_smc_M00_AXI_RLAST,
      S_AXI_HPC0_FPD_rready => axi_smc_M00_AXI_RREADY,
      S_AXI_HPC0_FPD_rresp(1 downto 0) => axi_smc_M00_AXI_RRESP(1 downto 0),
      S_AXI_HPC0_FPD_rvalid => axi_smc_M00_AXI_RVALID,
      S_AXI_HPC0_FPD_wdata(127 downto 0) => axi_smc_M00_AXI_WDATA(127 downto 0),
      S_AXI_HPC0_FPD_wlast => axi_smc_M00_AXI_WLAST,
      S_AXI_HPC0_FPD_wready => axi_smc_M00_AXI_WREADY,
      S_AXI_HPC0_FPD_wstrb(15 downto 0) => axi_smc_M00_AXI_WSTRB(15 downto 0),
      S_AXI_HPC0_FPD_wvalid => axi_smc_M00_AXI_WVALID,
      clk_out1 => dphy_clk_200M_1,
      dp_live_video_in_de => v_axi4s_vid_out_0_vid_active_video,
      dp_live_video_in_hsync => v_axi4s_vid_out_0_vid_hsync,
      dp_live_video_in_pixel1(35 downto 0) => v_axi4s_vid_out_0_vid_data(35 downto 0),
      dp_live_video_in_vsync => v_axi4s_vid_out_0_vid_vsync,
      dp_video_in_clk => clk_wiz_0_clk_out1,
      gpio_tri_o(2 downto 0) => Conn1_TRI_O(2 downto 0),
      iic_scl_i => zynq_ultra_ps_e_0_IIC_0_SCL_I,
      iic_scl_o => zynq_ultra_ps_e_0_IIC_0_SCL_O,
      iic_scl_t => zynq_ultra_ps_e_0_IIC_0_SCL_T,
      iic_sda_i => zynq_ultra_ps_e_0_IIC_0_SDA_I,
      iic_sda_o => zynq_ultra_ps_e_0_IIC_0_SDA_O,
      iic_sda_t => zynq_ultra_ps_e_0_IIC_0_SDA_T,
      peripheral_aresetn(0) => rst_ps8_0_249M_peripheral_aresetn(0),
      pl_clk0 => zynq_ultra_ps_e_0_pl_clk0,
      pl_ps_irq0 => V_DMA_s2mm_introut
    );
VIDEO_PIPELINE: entity work.VIDEO_PIPELINE_imp_U9ZAJD
     port map (
      ctrl_araddr(39 downto 0) => ps8_0_axi_periph_M05_AXI_ARADDR(39 downto 0),
      ctrl_arready => ps8_0_axi_periph_M05_AXI_ARREADY,
      ctrl_arvalid => ps8_0_axi_periph_M05_AXI_ARVALID,
      ctrl_awaddr(39 downto 0) => ps8_0_axi_periph_M05_AXI_AWADDR(39 downto 0),
      ctrl_awready => ps8_0_axi_periph_M05_AXI_AWREADY,
      ctrl_awvalid => ps8_0_axi_periph_M05_AXI_AWVALID,
      ctrl_bready => ps8_0_axi_periph_M05_AXI_BREADY,
      ctrl_bresp(1 downto 0) => ps8_0_axi_periph_M05_AXI_BRESP(1 downto 0),
      ctrl_bvalid => ps8_0_axi_periph_M05_AXI_BVALID,
      ctrl_rdata(31 downto 0) => ps8_0_axi_periph_M05_AXI_RDATA(31 downto 0),
      ctrl_rready => ps8_0_axi_periph_M05_AXI_RREADY,
      ctrl_rresp(1 downto 0) => ps8_0_axi_periph_M05_AXI_RRESP(1 downto 0),
      ctrl_rvalid => ps8_0_axi_periph_M05_AXI_RVALID,
      ctrl_wdata(31 downto 0) => ps8_0_axi_periph_M05_AXI_WDATA(31 downto 0),
      ctrl_wready => ps8_0_axi_periph_M05_AXI_WREADY,
      ctrl_wstrb(3 downto 0) => ps8_0_axi_periph_M05_AXI_WSTRB(3 downto 0),
      ctrl_wvalid => ps8_0_axi_periph_M05_AXI_WVALID,
      s_axi_aclk => zynq_ultra_ps_e_0_pl_clk0,
      s_axi_aresetn => rst_ps8_0_249M_peripheral_aresetn(0),
      vid_active_video => v_axi4s_vid_out_0_vid_active_video,
      vid_data(35 downto 0) => v_axi4s_vid_out_0_vid_data(35 downto 0),
      vid_hsync => v_axi4s_vid_out_0_vid_hsync,
      vid_io_out_clk => clk_wiz_0_clk_out1,
      vid_vsync => v_axi4s_vid_out_0_vid_vsync,
      video_in_tdata(23 downto 0) => video_in_1_TDATA(23 downto 0),
      video_in_tlast => video_in_1_TLAST,
      video_in_tready => video_in_1_TREADY,
      video_in_tuser(0) => video_in_1_TUSER(0),
      video_in_tvalid => video_in_1_TVALID
    );
V_DMA: entity work.V_DMA_imp_18YRF98
     port map (
      M00_AXI_araddr(48 downto 0) => axi_smc_M00_AXI_ARADDR(48 downto 0),
      M00_AXI_arburst(1 downto 0) => axi_smc_M00_AXI_ARBURST(1 downto 0),
      M00_AXI_arcache(3 downto 0) => axi_smc_M00_AXI_ARCACHE(3 downto 0),
      M00_AXI_arlen(7 downto 0) => axi_smc_M00_AXI_ARLEN(7 downto 0),
      M00_AXI_arlock(0) => axi_smc_M00_AXI_ARLOCK(0),
      M00_AXI_arprot(2 downto 0) => axi_smc_M00_AXI_ARPROT(2 downto 0),
      M00_AXI_arqos(3 downto 0) => axi_smc_M00_AXI_ARQOS(3 downto 0),
      M00_AXI_arready => axi_smc_M00_AXI_ARREADY,
      M00_AXI_arsize(2 downto 0) => axi_smc_M00_AXI_ARSIZE(2 downto 0),
      M00_AXI_arvalid => axi_smc_M00_AXI_ARVALID,
      M00_AXI_awaddr(48 downto 0) => axi_smc_M00_AXI_AWADDR(48 downto 0),
      M00_AXI_awburst(1 downto 0) => axi_smc_M00_AXI_AWBURST(1 downto 0),
      M00_AXI_awcache(3 downto 0) => axi_smc_M00_AXI_AWCACHE(3 downto 0),
      M00_AXI_awlen(7 downto 0) => axi_smc_M00_AXI_AWLEN(7 downto 0),
      M00_AXI_awlock(0) => axi_smc_M00_AXI_AWLOCK(0),
      M00_AXI_awprot(2 downto 0) => axi_smc_M00_AXI_AWPROT(2 downto 0),
      M00_AXI_awqos(3 downto 0) => axi_smc_M00_AXI_AWQOS(3 downto 0),
      M00_AXI_awready => axi_smc_M00_AXI_AWREADY,
      M00_AXI_awsize(2 downto 0) => axi_smc_M00_AXI_AWSIZE(2 downto 0),
      M00_AXI_awvalid => axi_smc_M00_AXI_AWVALID,
      M00_AXI_bready => axi_smc_M00_AXI_BREADY,
      M00_AXI_bresp(1 downto 0) => axi_smc_M00_AXI_BRESP(1 downto 0),
      M00_AXI_bvalid => axi_smc_M00_AXI_BVALID,
      M00_AXI_rdata(127 downto 0) => axi_smc_M00_AXI_RDATA(127 downto 0),
      M00_AXI_rlast => axi_smc_M00_AXI_RLAST,
      M00_AXI_rready => axi_smc_M00_AXI_RREADY,
      M00_AXI_rresp(1 downto 0) => axi_smc_M00_AXI_RRESP(1 downto 0),
      M00_AXI_rvalid => axi_smc_M00_AXI_RVALID,
      M00_AXI_wdata(127 downto 0) => axi_smc_M00_AXI_WDATA(127 downto 0),
      M00_AXI_wlast => axi_smc_M00_AXI_WLAST,
      M00_AXI_wready => axi_smc_M00_AXI_WREADY,
      M00_AXI_wstrb(15 downto 0) => axi_smc_M00_AXI_WSTRB(15 downto 0),
      M00_AXI_wvalid => axi_smc_M00_AXI_WVALID,
      M_AXIS_MM2S_tdata(23 downto 0) => video_in_1_TDATA(23 downto 0),
      M_AXIS_MM2S_tkeep(2 downto 0) => NLW_V_DMA_M_AXIS_MM2S_tkeep_UNCONNECTED(2 downto 0),
      M_AXIS_MM2S_tlast => video_in_1_TLAST,
      M_AXIS_MM2S_tready => video_in_1_TREADY,
      M_AXIS_MM2S_tuser(0) => video_in_1_TUSER(0),
      M_AXIS_MM2S_tvalid => video_in_1_TVALID,
      S_AXIS_S2MM1_tdata(23 downto 0) => S_AXIS_S2MM1_1_TDATA(23 downto 0),
      S_AXIS_S2MM1_tkeep(2 downto 0) => S_AXIS_S2MM1_1_TKEEP(2 downto 0),
      S_AXIS_S2MM1_tlast => S_AXIS_S2MM1_1_TLAST,
      S_AXIS_S2MM1_tready => S_AXIS_S2MM1_1_TREADY,
      S_AXIS_S2MM1_tuser(0) => S_AXIS_S2MM1_1_TUSER(0),
      S_AXIS_S2MM1_tvalid => S_AXIS_S2MM1_1_TVALID,
      S_AXIS_S2MM_tdata(23 downto 0) => S_AXIS_S2MM_1_TDATA(23 downto 0),
      S_AXIS_S2MM_tkeep(2 downto 0) => S_AXIS_S2MM_1_TKEEP(2 downto 0),
      S_AXIS_S2MM_tlast => S_AXIS_S2MM_1_TLAST,
      S_AXIS_S2MM_tready => S_AXIS_S2MM_1_TREADY,
      S_AXIS_S2MM_tuser(0) => S_AXIS_S2MM_1_TUSER(0),
      S_AXIS_S2MM_tvalid => S_AXIS_S2MM_1_TVALID,
      S_AXI_LITE1_araddr(39 downto 0) => TO_PS_M05_AXI1_ARADDR(39 downto 0),
      S_AXI_LITE1_arready => TO_PS_M05_AXI1_ARREADY,
      S_AXI_LITE1_arvalid => TO_PS_M05_AXI1_ARVALID,
      S_AXI_LITE1_awaddr(39 downto 0) => TO_PS_M05_AXI1_AWADDR(39 downto 0),
      S_AXI_LITE1_awready => TO_PS_M05_AXI1_AWREADY,
      S_AXI_LITE1_awvalid => TO_PS_M05_AXI1_AWVALID,
      S_AXI_LITE1_bready => TO_PS_M05_AXI1_BREADY,
      S_AXI_LITE1_bresp(1 downto 0) => TO_PS_M05_AXI1_BRESP(1 downto 0),
      S_AXI_LITE1_bvalid => TO_PS_M05_AXI1_BVALID,
      S_AXI_LITE1_rdata(31 downto 0) => TO_PS_M05_AXI1_RDATA(31 downto 0),
      S_AXI_LITE1_rready => TO_PS_M05_AXI1_RREADY,
      S_AXI_LITE1_rresp(1 downto 0) => TO_PS_M05_AXI1_RRESP(1 downto 0),
      S_AXI_LITE1_rvalid => TO_PS_M05_AXI1_RVALID,
      S_AXI_LITE1_wdata(31 downto 0) => TO_PS_M05_AXI1_WDATA(31 downto 0),
      S_AXI_LITE1_wready => TO_PS_M05_AXI1_WREADY,
      S_AXI_LITE1_wvalid => TO_PS_M05_AXI1_WVALID,
      S_AXI_LITE_araddr(39 downto 0) => ps8_0_axi_periph_M01_AXI_ARADDR(39 downto 0),
      S_AXI_LITE_arready => ps8_0_axi_periph_M01_AXI_ARREADY,
      S_AXI_LITE_arvalid => ps8_0_axi_periph_M01_AXI_ARVALID,
      S_AXI_LITE_awaddr(39 downto 0) => ps8_0_axi_periph_M01_AXI_AWADDR(39 downto 0),
      S_AXI_LITE_awready => ps8_0_axi_periph_M01_AXI_AWREADY,
      S_AXI_LITE_awvalid => ps8_0_axi_periph_M01_AXI_AWVALID,
      S_AXI_LITE_bready => ps8_0_axi_periph_M01_AXI_BREADY,
      S_AXI_LITE_bresp(1 downto 0) => ps8_0_axi_periph_M01_AXI_BRESP(1 downto 0),
      S_AXI_LITE_bvalid => ps8_0_axi_periph_M01_AXI_BVALID,
      S_AXI_LITE_rdata(31 downto 0) => ps8_0_axi_periph_M01_AXI_RDATA(31 downto 0),
      S_AXI_LITE_rready => ps8_0_axi_periph_M01_AXI_RREADY,
      S_AXI_LITE_rresp(1 downto 0) => ps8_0_axi_periph_M01_AXI_RRESP(1 downto 0),
      S_AXI_LITE_rvalid => ps8_0_axi_periph_M01_AXI_RVALID,
      S_AXI_LITE_wdata(31 downto 0) => ps8_0_axi_periph_M01_AXI_WDATA(31 downto 0),
      S_AXI_LITE_wready => ps8_0_axi_periph_M01_AXI_WREADY,
      S_AXI_LITE_wvalid => ps8_0_axi_periph_M01_AXI_WVALID,
      aclk => zynq_ultra_ps_e_0_pl_clk0,
      aresetn => rst_ps8_0_249M_peripheral_aresetn(0),
      s2mm_introut => V_DMA_s2mm_introut
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity kv260_video is
  port (
    gpio_tri_o : out STD_LOGIC_VECTOR ( 2 downto 0 );
    iic_scl_i : in STD_LOGIC;
    iic_scl_o : out STD_LOGIC;
    iic_scl_t : out STD_LOGIC;
    iic_sda_i : in STD_LOGIC;
    iic_sda_o : out STD_LOGIC;
    iic_sda_t : out STD_LOGIC;
    mipi_phy_if_clk_n : in STD_LOGIC;
    mipi_phy_if_clk_p : in STD_LOGIC;
    mipi_phy_if_data_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_phy_if_data_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_rx_ias_clk_n : in STD_LOGIC;
    mipi_rx_ias_clk_p : in STD_LOGIC;
    mipi_rx_ias_data_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mipi_rx_ias_data_p : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of kv260_video : entity is "kv260_video,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=kv260_video,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=45,numReposBlks=27,numNonXlnxBlks=0,numHierBlks=18,maxHierDepth=2,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of kv260_video : entity is "kv260_video.hwdef";
end kv260_video;

architecture STRUCTURE of kv260_video is
  signal PS_VIDEO_gpio_rtl_TRI_O : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal mipi_phy_if_0_1_CLK_N : STD_LOGIC;
  signal mipi_phy_if_0_1_CLK_P : STD_LOGIC;
  signal mipi_phy_if_0_1_DATA_N : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal mipi_phy_if_0_1_DATA_P : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal mipi_rx_ias1_0_1_CLK_N : STD_LOGIC;
  signal mipi_rx_ias1_0_1_CLK_P : STD_LOGIC;
  signal mipi_rx_ias1_0_1_DATA_N : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal mipi_rx_ias1_0_1_DATA_P : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal zynq_ultra_ps_e_0_IIC_0_SCL_I : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SCL_O : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SCL_T : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SDA_I : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SDA_O : STD_LOGIC;
  signal zynq_ultra_ps_e_0_IIC_0_SDA_T : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of iic_scl_i : signal is "xilinx.com:interface:iic:1.0 iic SCL_I";
  attribute X_INTERFACE_INFO of iic_scl_o : signal is "xilinx.com:interface:iic:1.0 iic SCL_O";
  attribute X_INTERFACE_INFO of iic_scl_t : signal is "xilinx.com:interface:iic:1.0 iic SCL_T";
  attribute X_INTERFACE_INFO of iic_sda_i : signal is "xilinx.com:interface:iic:1.0 iic SDA_I";
  attribute X_INTERFACE_INFO of iic_sda_o : signal is "xilinx.com:interface:iic:1.0 iic SDA_O";
  attribute X_INTERFACE_INFO of iic_sda_t : signal is "xilinx.com:interface:iic:1.0 iic SDA_T";
  attribute X_INTERFACE_INFO of mipi_phy_if_clk_n : signal is "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if CLK_N";
  attribute X_INTERFACE_INFO of mipi_phy_if_clk_p : signal is "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if CLK_P";
  attribute X_INTERFACE_INFO of mipi_rx_ias_clk_n : signal is "xilinx.com:interface:mipi_phy:1.0 mipi_rx_ias CLK_N";
  attribute X_INTERFACE_INFO of mipi_rx_ias_clk_p : signal is "xilinx.com:interface:mipi_phy:1.0 mipi_rx_ias CLK_P";
  attribute X_INTERFACE_INFO of gpio_tri_o : signal is "xilinx.com:interface:gpio:1.0 gpio TRI_O";
  attribute X_INTERFACE_INFO of mipi_phy_if_data_n : signal is "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if DATA_N";
  attribute X_INTERFACE_INFO of mipi_phy_if_data_p : signal is "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if DATA_P";
  attribute X_INTERFACE_INFO of mipi_rx_ias_data_n : signal is "xilinx.com:interface:mipi_phy:1.0 mipi_rx_ias DATA_N";
  attribute X_INTERFACE_INFO of mipi_rx_ias_data_p : signal is "xilinx.com:interface:mipi_phy:1.0 mipi_rx_ias DATA_P";
begin
  gpio_tri_o(2 downto 0) <= PS_VIDEO_gpio_rtl_TRI_O(2 downto 0);
  iic_scl_o <= zynq_ultra_ps_e_0_IIC_0_SCL_O;
  iic_scl_t <= zynq_ultra_ps_e_0_IIC_0_SCL_T;
  iic_sda_o <= zynq_ultra_ps_e_0_IIC_0_SDA_O;
  iic_sda_t <= zynq_ultra_ps_e_0_IIC_0_SDA_T;
  mipi_phy_if_0_1_CLK_N <= mipi_phy_if_clk_n;
  mipi_phy_if_0_1_CLK_P <= mipi_phy_if_clk_p;
  mipi_phy_if_0_1_DATA_N(1 downto 0) <= mipi_phy_if_data_n(1 downto 0);
  mipi_phy_if_0_1_DATA_P(1 downto 0) <= mipi_phy_if_data_p(1 downto 0);
  mipi_rx_ias1_0_1_CLK_N <= mipi_rx_ias_clk_n;
  mipi_rx_ias1_0_1_CLK_P <= mipi_rx_ias_clk_p;
  mipi_rx_ias1_0_1_DATA_N(3 downto 0) <= mipi_rx_ias_data_n(3 downto 0);
  mipi_rx_ias1_0_1_DATA_P(3 downto 0) <= mipi_rx_ias_data_p(3 downto 0);
  zynq_ultra_ps_e_0_IIC_0_SCL_I <= iic_scl_i;
  zynq_ultra_ps_e_0_IIC_0_SDA_I <= iic_sda_i;
PS_VIDEO: entity work.PS_VIDEO_imp_YI3F7Y
     port map (
      gpio_tri_o(2 downto 0) => PS_VIDEO_gpio_rtl_TRI_O(2 downto 0),
      iic_scl_i => zynq_ultra_ps_e_0_IIC_0_SCL_I,
      iic_scl_o => zynq_ultra_ps_e_0_IIC_0_SCL_O,
      iic_scl_t => zynq_ultra_ps_e_0_IIC_0_SCL_T,
      iic_sda_i => zynq_ultra_ps_e_0_IIC_0_SDA_I,
      iic_sda_o => zynq_ultra_ps_e_0_IIC_0_SDA_O,
      iic_sda_t => zynq_ultra_ps_e_0_IIC_0_SDA_T,
      mipi_phy_if_clk_n => mipi_phy_if_0_1_CLK_N,
      mipi_phy_if_clk_p => mipi_phy_if_0_1_CLK_P,
      mipi_phy_if_data_n(1 downto 0) => mipi_phy_if_0_1_DATA_N(1 downto 0),
      mipi_phy_if_data_p(1 downto 0) => mipi_phy_if_0_1_DATA_P(1 downto 0),
      mipi_rx_ias_clk_n => mipi_rx_ias1_0_1_CLK_N,
      mipi_rx_ias_clk_p => mipi_rx_ias1_0_1_CLK_P,
      mipi_rx_ias_data_n(3 downto 0) => mipi_rx_ias1_0_1_DATA_N(3 downto 0),
      mipi_rx_ias_data_p(3 downto 0) => mipi_rx_ias1_0_1_DATA_P(3 downto 0)
    );
end STRUCTURE;
