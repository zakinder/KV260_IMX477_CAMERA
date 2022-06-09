-------------------------------------------------------------------------------
--
-- Filename    : axis_external.vhd
-- Create Date : 05022019 [05-02-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation axi4 components.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity axis_external is
generic (
    revision_number             : std_logic_vector(31 downto 0) := x"05022019";
    C_rgb_m_axis_TDATA_WIDTH    : integer := 16;
    C_rgb_s_axis_TDATA_WIDTH    : integer := 16;
    C_m_axis_mm2s_TDATA_WIDTH   : integer := 16;
    C_vfpConfig_DATA_WIDTH      : integer := 32;
    C_vfpConfig_ADDR_WIDTH      : integer := 8;
    conf_data_width             : integer := 32;
    conf_addr_width             : integer := 8;
    i_data_width                : integer := 8;
    s_data_width                : integer := 16;
    b_data_width                : integer := 32);
port (
    iMmAxi                      : in integer;
    iStreamData                 : in vStreamData;
    oWrRegs                     : out mRegs;
    iRdRegs                     : in mRegs;
    --tx channel
    rgb_m_axis_aclk             : in std_logic;
    rgb_m_axis_aresetn          : in std_logic;
    rgb_m_axis_tready           : in std_logic;
    rgb_m_axis_tvalid           : out std_logic;
    rgb_m_axis_tlast            : out std_logic;
    rgb_m_axis_tuser            : out std_logic;
    rgb_m_axis_tdata            : out std_logic_vector(C_rgb_m_axis_TDATA_WIDTH-1 downto 0);
    --rx channel
    rgb_s_axis_aclk             : in std_logic;
    rgb_s_axis_aresetn          : in std_logic;
    rgb_s_axis_tready           : out std_logic;
    rgb_s_axis_tvalid           : in std_logic;
    rgb_s_axis_tuser            : in std_logic;
    rgb_s_axis_tlast            : in std_logic;
    rgb_s_axis_tdata            : in std_logic_vector(C_rgb_s_axis_TDATA_WIDTH-1 downto 0);
    --destination channel
    m_axis_mm2s_aclk            : in std_logic;
    m_axis_mm2s_aresetn         : in std_logic;
    m_axis_mm2s_tready          : in std_logic;
    m_axis_mm2s_tvalid          : out std_logic;
    m_axis_mm2s_tuser           : out std_logic;
    m_axis_mm2s_tlast           : out std_logic;
    m_axis_mm2s_tdata           : out std_logic_vector(C_m_axis_mm2s_TDATA_WIDTH-1 downto 0);
    m_axis_mm2s_tkeep           : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tstrb           : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tid             : out std_logic_vector(0 downto 0);
    m_axis_mm2s_tdest           : out std_logic_vector(0 downto 0);
    --video configuration
    vfpconfig_aclk              : in std_logic;
    vfpconfig_aresetn           : in std_logic;
    vfpconfig_awaddr            : in std_logic_vector(C_vfpConfig_ADDR_WIDTH-1 downto 0);
    vfpconfig_awprot            : in std_logic_vector(2 downto 0);
    vfpconfig_awvalid           : in std_logic;
    vfpconfig_awready           : out std_logic;
    vfpconfig_wdata             : in std_logic_vector(C_vfpConfig_DATA_WIDTH-1 downto 0);
    vfpconfig_wstrb             : in std_logic_vector((C_vfpConfig_DATA_WIDTH/8)-1 downto 0);
    vfpconfig_wvalid            : in std_logic;
    vfpconfig_wready            : out std_logic;
    vfpconfig_bresp             : out std_logic_vector(1 downto 0);
    vfpconfig_bvalid            : out std_logic;
    vfpconfig_bready            : in std_logic;
    vfpconfig_araddr            : in std_logic_vector(C_vfpConfig_ADDR_WIDTH-1 downto 0);
    vfpconfig_arprot            : in std_logic_vector(2 downto 0);
    vfpconfig_arvalid           : in std_logic;
    vfpconfig_arready           : out std_logic;
    vfpconfig_rdata             : out std_logic_vector(C_vfpConfig_DATA_WIDTH-1 downto 0);
    vfpconfig_rresp             : out std_logic_vector(1 downto 0);
    vfpconfig_rvalid            : out std_logic;
    vfpconfig_rready            : in std_logic);
end axis_external;

architecture arch_imp of axis_external is

    signal rx_axis_tready       : std_logic;
    signal rx_axis_tvalid       : std_logic;
    signal rx_axis_tuser        : std_logic;
    signal rx_axis_tlast        : std_logic;
    signal rx_axis_tdata        : std_logic_vector(m_axis_mm2s_tdata'range);

begin

-- this module convert ycbcr 444 to 422 and also generate basic test patten
-- for testing at hdmi level at cpu. Both selection controlled by cpu.
mAxisInst: vfp_s_axis
generic map (
    i_data_width         => i_data_width,
    b_data_width         => b_data_width,
    s_data_width         => s_data_width)
port map (
    --stream clock/reset
    m_axis_mm2s_aclk     =>  rgb_s_axis_aclk,
    m_axis_mm2s_aresetn  =>  rgb_s_axis_aresetn,
    -- config video stream according to bus select
    iMmAxi               =>  iMmAxi,
    -- filtered video stream data
    iStreamData          =>  iStreamData,
    -- stream to master
    rx_axis_tready_o     =>  rx_axis_tready,
    rx_axis_tvalid       =>  rx_axis_tvalid,
    rx_axis_tuser        =>  rx_axis_tuser,
    rx_axis_tlast        =>  rx_axis_tlast,
    rx_axis_tdata        =>  rx_axis_tdata,
    -- tx channel to outer loop for rx channel
    -- loop for future bd connectors
    rgb_m_axis_tvalid    =>  rgb_m_axis_tvalid,
    rgb_m_axis_tlast     =>  rgb_m_axis_tlast,
    rgb_m_axis_tuser     =>  rgb_m_axis_tuser,
    rgb_m_axis_tready    =>  rgb_m_axis_tready,
    rgb_m_axis_tdata     =>  rgb_m_axis_tdata,
    -- rx channel externally connected from tx channel
    rgb_s_axis_tready    =>  rgb_s_axis_tready,
    rgb_s_axis_tvalid    =>  rgb_s_axis_tvalid,
    rgb_s_axis_tuser     =>  rgb_s_axis_tuser,
    rgb_s_axis_tlast     =>  rgb_s_axis_tlast,
    rgb_s_axis_tdata     =>  rgb_s_axis_tdata);

--- this module transfer video stream data to master axi4 stream
mm2sInst: vfp_m_axis
generic map(
    s_data_width         => s_data_width)
port map(
    aclk                 => rgb_m_axis_aclk,
    aresetn              => rgb_m_axis_aresetn,
    -- rx video data
    rgb_s_axis_tready    => rx_axis_tready,
    rgb_s_axis_tvalid    => rx_axis_tvalid,
    rgb_s_axis_tuser     => rx_axis_tuser,
    rgb_s_axis_tlast     => rx_axis_tlast,
    rgb_s_axis_tdata     => rx_axis_tdata,
    -- tx video data to axi stream request.
    m_axis_mm2s_tkeep    => m_axis_mm2s_tkeep,
    m_axis_mm2s_tstrb    => m_axis_mm2s_tstrb,
    m_axis_mm2s_tid      => m_axis_mm2s_tid,
    m_axis_mm2s_tdest    => m_axis_mm2s_tdest,
    m_axis_mm2s_tready   => m_axis_mm2s_tready,
    m_axis_mm2s_tvalid   => m_axis_mm2s_tvalid,
    m_axis_mm2s_tuser    => m_axis_mm2s_tuser,
    m_axis_mm2s_tlast    => m_axis_mm2s_tlast,
    m_axis_mm2s_tdata    => m_axis_mm2s_tdata);

-- this module encode and decode cpu config data to slave components
vfpConfigInst: vfp_config
generic map(
    revision_number      => revision_number,
    conf_data_width      => conf_data_width,
    conf_addr_width      => conf_addr_width)
port map(
    -- config and requested registers
    wrRegsOut            => oWrRegs,
    rdRegsIn             => iRdRegs,
    -- cpu config axi4 lite channel
    S_AXI_ACLK           => vfpconfig_aclk,
    S_AXI_ARESETN        => vfpconfig_aresetn,
    S_AXI_AWADDR         => vfpconfig_awaddr,
    S_AXI_AWPROT         => vfpconfig_awprot,
    S_AXI_AWVALID        => vfpconfig_awvalid,
    S_AXI_AWREADY        => vfpconfig_awready,
    S_AXI_WDATA          => vfpconfig_wdata,
    S_AXI_WSTRB          => vfpconfig_wstrb,
    S_AXI_WVALID         => vfpconfig_wvalid,
    S_AXI_WREADY         => vfpconfig_wready,
    S_AXI_BRESP          => vfpconfig_bresp,
    S_AXI_BVALID         => vfpconfig_bvalid,
    S_AXI_BREADY         => vfpconfig_bready,
    S_AXI_ARADDR         => vfpconfig_araddr,
    S_AXI_ARPROT         => vfpconfig_arprot,
    S_AXI_ARVALID        => vfpconfig_arvalid,
    S_AXI_ARREADY        => vfpconfig_arready,
    S_AXI_RDATA          => vfpconfig_rdata,
    S_AXI_RRESP          => vfpconfig_rresp,
    S_AXI_RVALID         => vfpconfig_rvalid,
    S_AXI_RREADY         => vfpconfig_rready);
end arch_imp;