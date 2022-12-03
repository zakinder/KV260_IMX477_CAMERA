--05062019 [05-06-2019]
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity VFP_v1_0 is
generic (
    revision_number           : std_logic_vector(31 downto 0) := x"09072019";
    C_rgb_m_axis_TDATA_WIDTH  : integer := 16;
    C_rgb_m_axis_START_COUNT  : integer := 32;
    C_rgb_s_axis_TDATA_WIDTH  : integer := 16;
    C_m_axis_mm2s_TDATA_WIDTH : integer := 16;
    C_m_axis_mm2s_START_COUNT : integer := 32;
    C_vfpConfig_DATA_WIDTH    : integer := 32;
    C_vfpConfig_ADDR_WIDTH    : integer := 8;
    conf_data_width           : integer := 32;
    conf_addr_width           : integer := 8;
    i_data_width              : integer := 8;
    s_data_width              : integer := 16;
    b_data_width              : integer := 32;
    i_precision               : integer := 12;
    i_full_range              : boolean := FALSE;
    img_width                 : integer := 4096;
    dataWidth                 : integer := 12;
    img_width_bmp             : integer := 1920;
    img_height_bmp            : integer := 1080;
    F_TES                     : boolean := false;
    F_LUM                     : boolean := false;
    F_TRM                     : boolean := false;
    F_RGB                     : boolean := false;
    F_SHP                     : boolean := false;
    F_BLU                     : boolean := false;
    F_EMB                     : boolean := false;
    F_YCC                     : boolean := false;
    F_SOB                     : boolean := false;
    F_CGA                     : boolean := false;
    F_HSV                     : boolean := false;
    F_HSL                     : boolean := false);
port (
    -- d5m input
    pixclk                    : in std_logic;
    ifval                     : in std_logic;
    ilval                     : in std_logic;
    idata                     : in std_logic_vector(dataWidth - 1 downto 0);
    --tx channel
    rgb_m_axis_aclk           : in std_logic;
    rgb_m_axis_aresetn        : in std_logic;
    rgb_m_axis_tready         : in std_logic;
    rgb_m_axis_tvalid         : out std_logic;
    rgb_m_axis_tlast          : out std_logic;
    rgb_m_axis_tuser          : out std_logic;
    rgb_m_axis_tdata          : out std_logic_vector(C_rgb_m_axis_TDATA_WIDTH-1 downto 0);
    --rx channel
    rgb_s_axis_aclk           : in std_logic;
    rgb_s_axis_aresetn        : in std_logic;
    rgb_s_axis_tready         : out std_logic;
    rgb_s_axis_tvalid         : in std_logic;
    rgb_s_axis_tuser          : in std_logic;
    rgb_s_axis_tlast          : in std_logic;
    rgb_s_axis_tdata          : in std_logic_vector(C_rgb_s_axis_TDATA_WIDTH-1 downto 0);
    --destination channel
    m_axis_mm2s_aclk          : in std_logic;
    m_axis_mm2s_aresetn       : in std_logic;
    m_axis_mm2s_tready        : in std_logic;
    m_axis_mm2s_tvalid        : out std_logic;
    m_axis_mm2s_tuser         : out std_logic;
    m_axis_mm2s_tlast         : out std_logic;
    m_axis_mm2s_tdata         : out std_logic_vector(C_m_axis_mm2s_TDATA_WIDTH-1 downto 0);
    m_axis_mm2s_tkeep         : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tstrb         : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tid           : out std_logic_vector(0 downto 0);
    m_axis_mm2s_tdest         : out std_logic_vector(0 downto 0);
    --video configuration       
    vfpconfig_aclk            : in std_logic;
    vfpconfig_aresetn         : in std_logic;
    vfpconfig_awaddr          : in std_logic_vector(C_vfpConfig_ADDR_WIDTH-1 downto 0);
    vfpconfig_awprot          : in std_logic_vector(2 downto 0);
    vfpconfig_awvalid         : in std_logic;
    vfpconfig_awready         : out std_logic;
    vfpconfig_wdata           : in std_logic_vector(C_vfpConfig_DATA_WIDTH-1 downto 0);
    vfpconfig_wstrb           : in std_logic_vector((C_vfpConfig_DATA_WIDTH/8)-1 downto 0);
    vfpconfig_wvalid          : in std_logic;
    vfpconfig_wready          : out std_logic;
    vfpconfig_bresp           : out std_logic_vector(1 downto 0);
    vfpconfig_bvalid          : out std_logic;
    vfpconfig_bready          : in std_logic;
    vfpconfig_araddr          : in std_logic_vector(C_vfpConfig_ADDR_WIDTH-1 downto 0);
    vfpconfig_arprot          : in std_logic_vector(2 downto 0);
    vfpconfig_arvalid         : in std_logic;
    vfpconfig_arready         : out std_logic;
    vfpconfig_rdata           : out std_logic_vector(C_vfpConfig_DATA_WIDTH-1 downto 0);
    vfpconfig_rresp           : out std_logic_vector(1 downto 0);
    vfpconfig_rvalid          : out std_logic;
    vfpconfig_rready          : in std_logic);
end VFP_v1_0;
architecture arch_imp of VFP_v1_0 is
    constant adwrWidth                 : integer := 16;
    constant addrWidth                 : integer := 12;
    -- D5m Camera Raw Data Settings
    constant d5m_data_width            : integer := dataWidth;
    constant d5m_frame_width           : integer := img_width;
    -- HD Video
    constant bmp_width                 : integer := img_width_bmp;
    constant bmp_height                : integer := img_height_bmp;
    constant bmp_precision             : integer := i_precision;
    -- Set filters
    constant F_CGA_FULL_RANGE          : boolean := i_full_range;
    signal aBusSelect                  : std_logic_vector(vfpconfig_wdata'range):= (others => '0');
    signal sMmAxi                      : integer := 0;
    signal rgbSet                      : rRgb;
    signal wrRegs                      : mRegs;
    signal rdRegs                      : mRegs;
    signal streamData                  : vStreamData;
    signal rgb_set                     : rRgb;
    signal wr_regs                     : mRegs;
    signal rd_regs                     : mRegs;
    signal video_data                  : vStreamData;
begin

aBusSelect   <= std_logic_vector(to_unsigned(sMmAxi,C_vfpConfig_DATA_WIDTH));

camera_raw_to_rgb_inst: camera_raw_to_rgb
generic map(
    img_width                 => img_width,
    dataWidth                 => dataWidth,
    addrWidth                 => addrWidth)
port map(
    m_axis_mm2s_aclk          => m_axis_mm2s_aclk,
    m_axis_mm2s_aresetn       => m_axis_mm2s_aresetn,
    pixclk                    => pixclk,
    ifval                     => ifval,
    ilval                     => ilval,
    idata                     => idata,
    oRgbSet                   => rgb_set);

--CameraRawToRgbInst: camera_raw_to_rgb
--generic map(
--    img_width                 => img_width,
--    dataWidth                 => dataWidth,
--    addrWidth                 => addrWidth)
--port map(
--    m_axis_mm2s_aclk          => m_axis_mm2s_aclk,
--    m_axis_mm2s_aresetn       => m_axis_mm2s_aresetn,
--    pixclk                    => pixclk,
--    ifval                     => ifval,
--    ilval                     => ilval,
--    idata                     => idata,
--    oRgbSet                   => rgbSet);
--    
-- Filter rgb data module
video_stream_inst: video_stream
generic map(
    revision_number           => revision_number,
    i_data_width              => i_data_width,
    s_data_width              => s_data_width,
    b_data_width              => b_data_width,
    img_width                 => d5m_frame_width,
    adwrWidth                 => adwrWidth,
    addrWidth                 => addrWidth,
    bmp_width                 => img_width_bmp,
    bmp_height                => img_height_bmp,
    F_TES                     => F_TES,
    F_LUM                     => F_LUM,
    F_TRM                     => F_TRM,
    F_RGB                     => F_RGB,
    F_SHP                     => F_SHP,
    F_BLU                     => F_BLU,
    F_EMB                     => F_EMB,
    F_YCC                     => F_YCC,
    F_SOB                     => F_SOB,
    F_CGA                     => F_CGA,
    F_HSV                     => F_HSV,
    F_HSL                     => F_HSL)
port map(
    clk                       => m_axis_mm2s_aclk,
    rst_l                     => m_axis_mm2s_aresetn,
    iWrRegs                   => wr_regs,
    oRdRegs                   => rd_regs,
    iRgbSet                   => rgb_set,
    oVideoData                => video_data,
    oMmAxi                    => sMmAxi);

AxisExternalInst: AxisExternal
generic map(
    revision_number           => revision_number,
    C_rgb_m_axis_TDATA_WIDTH  => C_rgb_m_axis_TDATA_WIDTH,
    C_rgb_s_axis_TDATA_WIDTH  => C_rgb_s_axis_TDATA_WIDTH,
    C_m_axis_mm2s_TDATA_WIDTH => C_m_axis_mm2s_TDATA_WIDTH,
    C_vfpConfig_DATA_WIDTH    => C_vfpConfig_DATA_WIDTH,
    C_vfpConfig_ADDR_WIDTH    => C_vfpConfig_ADDR_WIDTH,
    conf_data_width           => conf_data_width,
    conf_addr_width           => conf_addr_width,
    i_data_width              => i_data_width,
    s_data_width              => s_data_width,
    b_data_width              => b_data_width)
port map(
    iBusSelect                => aBusSelect,
    iStreamData               => video_data,
    oWrRegs                   => wr_regs,
    iRdRegs                   => rd_regs,
    --tx channel
    rgb_m_axis_aclk           => rgb_m_axis_aclk,
    rgb_m_axis_aresetn        => rgb_m_axis_aresetn,
    rgb_m_axis_tready         => rgb_m_axis_tready,
    rgb_m_axis_tvalid         => rgb_m_axis_tvalid,
    rgb_m_axis_tlast          => rgb_m_axis_tlast,
    rgb_m_axis_tuser          => rgb_m_axis_tuser,
    rgb_m_axis_tdata          => rgb_m_axis_tdata,
    --rx channel
    rgb_s_axis_aclk           => rgb_s_axis_aclk,
    rgb_s_axis_aresetn        => rgb_s_axis_aresetn,
    rgb_s_axis_tready         => rgb_s_axis_tready,
    rgb_s_axis_tvalid         => rgb_s_axis_tvalid,
    rgb_s_axis_tuser          => rgb_s_axis_tuser,
    rgb_s_axis_tlast          => rgb_s_axis_tlast,
    rgb_s_axis_tdata          => rgb_s_axis_tdata,
    --destination channel
    m_axis_mm2s_aclk          => m_axis_mm2s_aclk,
    m_axis_mm2s_aresetn       => m_axis_mm2s_aresetn,
    m_axis_mm2s_tready        => m_axis_mm2s_tready,
    m_axis_mm2s_tvalid        => m_axis_mm2s_tvalid,
    m_axis_mm2s_tuser         => m_axis_mm2s_tuser,
    m_axis_mm2s_tlast         => m_axis_mm2s_tlast,
    m_axis_mm2s_tdata         => m_axis_mm2s_tdata,
    m_axis_mm2s_tkeep         => m_axis_mm2s_tkeep,
    m_axis_mm2s_tstrb         => m_axis_mm2s_tstrb,
    m_axis_mm2s_tid           => m_axis_mm2s_tid,
    m_axis_mm2s_tdest         => m_axis_mm2s_tdest,
    --video configuration
    vfpconfig_aclk            => vfpconfig_aclk,
    vfpconfig_aresetn         => vfpconfig_aresetn,
    vfpconfig_awaddr          => vfpconfig_awaddr,
    vfpconfig_awprot          => vfpconfig_awprot,
    vfpconfig_awvalid         => vfpconfig_awvalid,
    vfpconfig_awready         => vfpconfig_awready,
    vfpconfig_wdata           => vfpconfig_wdata,
    vfpconfig_wstrb           => vfpconfig_wstrb,
    vfpconfig_wvalid          => vfpconfig_wvalid,
    vfpconfig_wready          => vfpconfig_wready,
    vfpconfig_bresp           => vfpconfig_bresp,
    vfpconfig_bvalid          => vfpconfig_bvalid,
    vfpconfig_bready          => vfpconfig_bready,
    vfpconfig_araddr          => vfpconfig_araddr,
    vfpconfig_arprot          => vfpconfig_arprot,
    vfpconfig_arvalid         => vfpconfig_arvalid,
    vfpconfig_arready         => vfpconfig_arready,
    vfpconfig_rdata           => vfpconfig_rdata,
    vfpconfig_rresp           => vfpconfig_rresp,
    vfpconfig_rvalid          => vfpconfig_rvalid,
    vfpconfig_rready          => vfpconfig_rready);
end arch_imp;