--04112019 [04-11-2019]
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
package dutPortsPackage is
component VFP_v1_0 is
generic (
    revision_number             : std_logic_vector(31 downto 0) := x"02172019";
    C_rgb_m_axis_TDATA_WIDTH    : integer := 16;
    C_rgb_m_axis_START_COUNT    : integer := 32;
    C_rgb_s_axis_TDATA_WIDTH    : integer := 16;
    C_m_axis_mm2s_TDATA_WIDTH   : integer := 16;
    C_m_axis_mm2s_START_COUNT   : integer := 32;
    C_vfpConfig_DATA_WIDTH      : integer := 32;
    C_vfpConfig_ADDR_WIDTH      : integer := 8;
    i_data_width                : integer := 8;
    s_data_width                : integer := 16;
    b_data_width                : integer := 32;
    i_precision                 : integer := 12;
    i_full_range                : boolean := FALSE;
    conf_data_width             : integer := 32;
    conf_addr_width             : integer := 4;
    img_width                   : integer := 4096;
    dataWidth                   : integer := 12);
port (
    -- d5m input
    pixclk                      : in std_logic;
    ifval                       : in std_logic;
    ilval                       : in std_logic;
    idata                       : in std_logic_vector(dataWidth - 1 downto 0);
    --tx channel                
    rgb_m_axis_aclk             : in std_logic;
    rgb_m_axis_aresetn          : in std_logic;
    rgb_m_axis_tvalid           : out std_logic;
    rgb_m_axis_tlast            : out std_logic;
    rgb_m_axis_tuser            : out std_logic;
    rgb_m_axis_tready           : in std_logic;
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
end component VFP_v1_0;
component dut_d5m is
generic (
    pixclk_freq                 : real    := 90.00e6;
    img_width                   : integer := 112;
    line_hight                  : integer := 122;
    dataWidth                   : integer := 12);
port (
    pixclk                      : out std_logic;
    ifval                       : out std_logic;
    ilval                       : out std_logic;
    idata                       : out std_logic_vector(dataWidth - 1 downto 0));
end component dut_d5m;
component dut_config_axis is
generic (
    aclk_freq                   : real    := 75.00e6;
    C_vfpConfig_DATA_WIDTH      : integer := 32;
    C_vfpConfig_ADDR_WIDTH      : integer := 8);
port (
    vfpconfig_aclk              : out std_logic;
    vfpconfig_aresetn           : out std_logic;
    vfpconfig_awaddr            : out std_logic_vector(C_vfpConfig_ADDR_WIDTH-1 downto 0);
    vfpconfig_awprot            : out std_logic_vector(2 downto 0);
    vfpconfig_awvalid           : out std_logic;
    vfpconfig_awready           : in std_logic;
    vfpconfig_wdata             : out std_logic_vector(C_vfpConfig_DATA_WIDTH-1 downto 0);
    vfpconfig_wstrb             : out std_logic_vector((C_vfpConfig_DATA_WIDTH/8)-1 downto 0);
    vfpconfig_wvalid            : out std_logic;
    vfpconfig_wready            : in std_logic;
    vfpconfig_bresp             : in std_logic_vector(1 downto 0);
    vfpconfig_bvalid            : in std_logic;
    vfpconfig_bready            : out std_logic;
    vfpconfig_araddr            : out std_logic_vector(C_vfpConfig_ADDR_WIDTH-1 downto 0);
    vfpconfig_arprot            : out std_logic_vector(2 downto 0);
    vfpconfig_arvalid           : out std_logic;
    vfpconfig_arready           : in std_logic;
    vfpconfig_rdata             : in std_logic_vector(C_vfpConfig_DATA_WIDTH-1 downto 0);
    vfpconfig_rresp             : in std_logic_vector(1 downto 0);
    vfpconfig_rvalid            : in std_logic;
    vfpconfig_rready            : out std_logic);
end component dut_config_axis;
component dut_frame_process is
port (
    clk                         : in std_logic;
    resetn                      : in std_logic);
end component dut_frame_process;
component image_read is
generic (
    i_data_width                : integer := 8;
    input_file                  : string  := "input_image");
port (                
    clk           : in  std_logic;
    reset         : in  std_logic;
    oRgb          : out channel;
    oCord         : out coord;
    olm           : out rgbConstraint;
    endOfFrame    : out std_logic);
end component image_read;
component image_write is
generic (
    enImageText                 : boolean := false;
    enImageIndex                : boolean := false;
    i_data_width                : integer := 8;
    test                        : string  := "folder";
    input_file                  : string  := "input_image";
    output_file                 : string  := "output_image");
port (                
    pixclk                      : in  std_logic;
    enableWrite                 : in  std_logic;
    iRgb                        : in channel);
end component image_write;

component write_image is
generic (
    enImageText                 : boolean := false;
    enImageIndex                : boolean := false;
    i_data_width                : integer := 8;
    test                        : string  := "folder";
    input_file                  : string  := "input_image";
    output_file                 : string  := "output_image");
port (                
    pixclk        : in  std_logic;
    iRgb          : in channel);
end component write_image;
component write_valid_image is
generic (
    enImageText                 : boolean := false;
    enImageIndex                : boolean := false;
    i_data_width                : integer := 8;
    test                        : string  := "folder";
    input_file                  : string  := "input_image";
    output_file                 : string  := "output_image");
port (                
    pixclk        : in  std_logic;
    iRgb          : in channel);
end component write_valid_image;
component write_image_filter_logs is
generic (
    F_TES                       : boolean := false;
    F_LUM                       : boolean := false;
    F_TRM                       : boolean := false;
    F_RGB                       : boolean := false;
    F_SHP                       : boolean := false;
    F_BLU                       : boolean := false;
    F_EMB                       : boolean := false;
    F_YCC                       : boolean := false;
    F_SOB                       : boolean := false;
    F_CGA                       : boolean := false;
    F_HSV                       : boolean := false;
    F_HSL                       : boolean := false;
    L_BLU                       : boolean := false;
    L_AVG                       : boolean := false;
    L_OBJ                       : boolean := false;
    L_CGA                       : boolean := false;
    L_YCC                       : boolean := false;
    L_SHP                       : boolean := false;
    L_D1T                       : boolean := false;
    L_B1T                       : boolean := false;
    enImageText                 : boolean := false;
    enImageIndex                : boolean := false;
    i_data_width                : integer := 8;
    test                        : string  := "folder";
    input_file                  : string  := "input_image";
    output_file                 : string  := "output_image");
port (                
    pixclk                      : in  std_logic;
    iRgb                        : in frameColors);
end component write_image_filter_logs;

--component read_kernel1_coefs is
--generic (
--    s_data_width    : integer := 16;
--    input_file      : string  := "input_image");
--port (                
--    clk             : in std_logic;
--    reset           : in std_logic;
--    kSet1Out        : out  coeffData);
--end component read_kernel1_coefs;
component sync_cord is
generic (
    cordDelay       : integer := 16);
port (                
    clk             : in std_logic;
    reset           : in std_logic;
    iCord           : in cord;
    oCord           : out  cord);
end component sync_cord;
end package;