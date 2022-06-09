--05012019 [05-01-2019]
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
package ports_package is
component filters is
generic (
    HSV_L                    : boolean := false;
    HSV_1                    : boolean := false;
    HSV_2                    : boolean := false;
    HSV_3                    : boolean := false;
    HSV_4                    : boolean := false;
    HSVL1                    : boolean := false;
    HSVL2                    : boolean := false;
    HSVL3                    : boolean := false;
    HSVL4                    : boolean := false;
    F_RE1                    : boolean := false;
    F_RE2                    : boolean := false;
    F_RE3                    : boolean := false;
    F_RE4                    : boolean := false;
    F_RE5                    : boolean := false;
    F_RE6                    : boolean := false;
    F_RE7                    : boolean := false;
    F_RE8                    : boolean := false;
    FCMYK                    : boolean := false;
    F_XYZ                    : boolean := false;
    F_LMS                    : boolean := false;
    YPBPR                    : boolean := false;
    F_YUV                    : boolean := false;
    YDRDB                    : boolean := false;
    YC1C2                    : boolean := false;
    F_IPT                    : boolean := false;
    F_YIQ                    : boolean := false;
    F_HED                    : boolean := false;
    FOHTA                    : boolean := false;
    FMICC                    : boolean := false;
    F_CC1                    : boolean := false;
    F_CC2                    : boolean := false;
    F_CC3                    : boolean := false;
    F_CC4                    : boolean := false;
    F_CC5                    : boolean := false;
    F_CC6                    : boolean := false;
    F_CC7                    : boolean := false;
    F_CC8                    : boolean := false;
    F_TES                    : boolean := false;
    F_LUM                    : boolean := false;
    F_TRM                    : boolean := false;
    F_RGB                    : boolean := false;
    F_OHS                    : boolean := false;
    F_SHP                    : boolean := false;
    F_BLU                    : boolean := false;
    F_EMB                    : boolean := false;
    F_YCC                    : boolean := false;
    F_SOB                    : boolean := false;
    F_CGA                    : boolean := false;
    F_HSV                    : boolean := false;
    F_HSL                    : boolean := false;
    L_BLU                    : boolean := false;
    L_AVG                    : boolean := false;
    L_OBJ                    : boolean := false;
    L1CGA                    : boolean := false;
    L2CGA                    : boolean := false;
    L3CGA                    : boolean := false;
    L4CGA                    : boolean := false;
    L5CGA                    : boolean := false;
    L6CGA                    : boolean := false;
    L7CGA                    : boolean := false;
    L8CGA                    : boolean := false;
    LCCM1                    : boolean := false;
    LCCM2                    : boolean := false;
    LCCM3                    : boolean := false;
    LCCM4                    : boolean := false;
    LCCM5                    : boolean := false;
    LCCM6                    : boolean := false;
    LCCM7                    : boolean := false;
    LCCM8                    : boolean := false;
    L_YCC                    : boolean := false;
    L_SHP                    : boolean := false;
    L_D1T                    : boolean := false;
    L_B1T                    : boolean := false;
    L_HIS                    : boolean := false;
    L_SPC                    : boolean := false;
    M_SOB_LUM                : boolean := false;
    M_SOB_TRM                : boolean := false;
    M_SOB_RGB                : boolean := false;
    M_SOB_SHP                : boolean := false;
    M_SOB_BLU                : boolean := false;
    M_SOB_YCC                : boolean := false;
    M_SOB_CGA                : boolean := false;
    M_SOB_HSV                : boolean := false;
    M_SOB_HSL                : boolean := false;
    F_BLUR_CHANNELS          : boolean := false;
    F_DITH_CHANNELS          : boolean := false;
    img_width             : integer := 4096;
    img_height            : integer := 4096;
    adwrWidth             : integer := 16;
    addrWidth             : integer := 12;
    s_data_width          : integer := 16;
    i_data_width          : integer := 8);
port (
    clk                      : in std_logic;
    rst_l                    : in std_logic;
    txCord                   : in coord;
    iRgb                     : in channel;
    iLumTh                   : in integer;
    iSobelTh                 : in integer;
    iVideoChannel            : in integer;
    iFilterId                : in integer;
    iHsvPerCh                : in integer;
    iYccPerCh                : in integer;
    iAls                     : in coefficient;
    iKcoeff                  : in kernelCoeff;
    oKcoeff                  : out kernelCoeff;
    edgeValid                : out std_logic;
    blur_channels            : out blur_frames;
    oRgb                     : out frameColors);
end component filters;
component color_space_limits is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    rgbColors      : out type_RgbArray(0 to i_data_width-1));
end component color_space_limits;
component sync_frames is
generic (
    pixelDelay     : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component sync_frames;
component d_valid is
generic (
    pixelDelay     : integer := 8);
port (
    clk            : in std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component d_valid;
component rgb_select is
    port (
        clk            : in std_logic;
        iPerCh         : in integer;
        iRgb           : in channel;
        oRgb           : out channel);
end component rgb_select;
component rgbAssertion is
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    valid          : in  std_logic;
    iRed           : in  std_logic_vector(7 downto 0);
    iGreen         : in  std_logic_vector(7 downto 0);
    iBlue          : in  std_logic_vector(7 downto 0));
end component rgbAssertion;
component kernel is
generic (
    HSV_1_FRAME        : boolean := false;
    HSV_2_FRAME        : boolean := false;
    HSV_3_FRAME        : boolean := false;
    HSV_4_FRAME        : boolean := false;
    HSVL1_FRAME        : boolean := false;
    HSVL2_FRAME        : boolean := false;
    HSVL3_FRAME        : boolean := false;
    HSVL4_FRAME        : boolean := false;
    F_RE1_FRAME        : boolean := false;
    F_RE2_FRAME        : boolean := false;
    F_RE3_FRAME        : boolean := false;
    F_RE4_FRAME        : boolean := false;
    F_RE5_FRAME        : boolean := false;
    F_RE6_FRAME        : boolean := false;
    F_RE7_FRAME        : boolean := false;
    F_RE8_FRAME        : boolean := false;
    FCMYK_FRAME        : boolean := false;
    F_XYZ_FRAME        : boolean := false;
    F_LMS_FRAME        : boolean := false;
    YPBPR_FRAME        : boolean := false;
    F_YUV_FRAME        : boolean := false;
    YDRDB_FRAME        : boolean := false;
    YC1C2_FRAME        : boolean := false;
    F_IPT_FRAME        : boolean := false;
    F_YIQ_FRAME        : boolean := false;
    F_HED_FRAME        : boolean := false;
    FOHTA_FRAME        : boolean := false;
    FMICC_FRAME        : boolean := false;
    F_CC1_FRAME        : boolean := false;
    F_CC2_FRAME        : boolean := false;
    F_CC3_FRAME        : boolean := false;
    F_CC4_FRAME        : boolean := false;
    F_CC5_FRAME        : boolean := false;
    F_CC6_FRAME        : boolean := false;
    F_CC7_FRAME        : boolean := false;
    F_CC8_FRAME        : boolean := false;
    INRGB_FRAME        : boolean := false;
    RGBLP_FRAME        : boolean := false;
    RGBTR_FRAME        : boolean := false;
    COHSL_FRAME        : boolean := false;
    SHARP_FRAME        : boolean := false;
    BLURE_FRAME        : boolean := false;
    EMBOS_FRAME        : boolean := false;
    YCBCR_FRAME        : boolean := false;
    SOBEL_FRAME        : boolean := false;
    CGAIN_FRAME        : boolean := false;
    CCGAIN_FRAME       : boolean := false;
    HSV_FRAME          : boolean := false;
    HSL_FRAME          : boolean := false;
    img_width          : integer := 4096;
    img_height         : integer := 4096;
    s_data_width       : integer := 16;
    i_data_width       : integer := 8);
port (
    clk                : in std_logic;
    rst_l              : in std_logic;
    iLumTh             : in integer;
    iSobelTh           : in integer;
    txCord             : in coord;
    iRgb               : in channel;
    iKcoeff            : in kernelCoeff;
    iFilterId          : in integer;
    oKcoeff            : out kernelCoeff;
    oEdgeValid         : out std_logic;
    oRgb               : out colors);
end component kernel;
component text_gen is
generic (
    img_width_bmp        : integer := 4096;
    img_height_bmp       : integer := 4096;
    b_data_width         : integer := 32);
port (
    clk              : in std_logic;
    rst_l            : in std_logic;
    iViChannel       : in integer;
    txCord           : in coord;
    location         : in cord;
    iRgb             : in channel;
    oRgb             : out channel);
end component text_gen;
component font_rom is
port (
    clk     : in std_logic;
    addr    : in integer;
    fontRow : out std_logic_vector(FONT_WIDTH-1 downto 0));
end component font_rom;
component pixel_on_display is
generic (
    img_width_bmp               : integer := 1920;
    img_height_bmp              : integer := 1080;
    b_data_width                : integer := 32);
port (
    clk          : in std_logic;
    rst_l        : in std_logic;
    location     : in cord;
    grid         : in cord;
    iViChannel   : in integer;
    pixel        : out std_logic);
end component pixel_on_display;
component rgb_histogram is
generic (
    img_width     : integer := 1920;
    img_height    : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    txCord         : in coord;
    iRgb           : in channel;
    oRgb           : out channel);
end component rgb_histogram;
component rgb_to_cmyk is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component rgb_to_cmyk;
component rgb_to_I1I2I3_ohta is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component rgb_to_I1I2I3_ohta;
component rgb_to_I1I2I3_micc is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component rgb_to_I1I2I3_micc;
component color_trim is
generic (
    img_width     : integer := 1920;
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component color_trim;
component rgb_range is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component rgb_range;
component rgb_inverted is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component rgb_inverted;
component rgb_to_xyz_color_space is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component rgb_to_xyz_color_space;
component hsvl is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end component hsvl;
component hsvl_1range is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end component hsvl_1range;
component hsvl_2range is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end component hsvl_2range;
component hsvl_3range is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end component hsvl_3range;
component hsvl_4range is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end component hsvl_4range;
component hsl_1range is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end component hsl_1range;
component hsl_2range is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end component hsl_2range;
component hsl_3range is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end component hsl_3range;
component hsl_4range is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end component hsl_4range;
component recolor_space_hsl is
generic (
    img_width     : integer := 1920;
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component recolor_space_hsl;
component recolor_space is
generic (
    neighboring_pixel_threshold : integer := 1920;
    img_width                   : integer := 1920;
    i_data_width                : integer := 8);
port (
    clk                         : in  std_logic;
    reset                       : in  std_logic;
    iRgb                        : in channel;
    oRgb                        : out channel);
end component recolor_space;
component pixel_localization is
generic (
    neighboring_pixel_threshold : integer := 1920;
    img_width                   : integer := 1920;
    i_data_width                : integer := 8);
port (
    clk                         : in  std_logic;
    reset                       : in  std_logic;
    iRgb                        : in channel;
    txCord                      : in coord;
    oRgb                        : out channel);
end component pixel_localization;
component pixel_localization_9x9_window is
generic (
    img_width                   : integer := 1920;
    i_data_width                : integer := 8);
port (
    clk                         : in  std_logic;
    reset                       : in  std_logic;
    iRgb                        : in channel;
    neighboring_pixel_threshold : integer;
    txCord                      : in coord;
    oRgb                        : out channel);
end component pixel_localization_9x9_window;
component vfp_axi_stream is
    generic (
    TDATA_WIDTH                     : natural    := 32;
    FRAME_PIXEL_DEPTH               : natural    := 10;
    FRAME_WIDTH                     : natural    := 1920;
    FRAME_HEIGHT                    : natural    := 1080);
    port (
    s_axis_aclk                     : in std_logic;
    s_axis_aresetn                  : in std_logic;
    s_axis_tready                   : out std_logic;
    s_axis_tdata                    : in std_logic_vector(TDATA_WIDTH-1 downto 0);     
    s_axis_tlast                    : in std_logic;
    s_axis_tuser                    : in std_logic;
    s_axis_tvalid                   : in std_logic;
    oCord_x                         : out std_logic_vector(15 downto 0);
    oCord_y                         : out std_logic_vector(15 downto 0);
    oRgb                            : out channel);
end component vfp_axi_stream;
component recolor_space_cluster is
generic (
    neighboring_pixel_threshold : integer := 1920;
    img_width                   : integer := 1920;
    i_data_width                : integer := 8);
port (
    clk                         : in  std_logic;
    reset                       : in  std_logic;
    iRgb                        : in channel;
    txCord                      : in coord;
    oRgb                        : out channel);
end component recolor_space_cluster;
component color_avg is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end component color_avg;
component video_select is
generic (
    bmp_width         : integer := 1920;
    bmp_height        : integer := 1080;
    i_data_width      : integer := 8;
    b_data_width      : integer := 32;
    s_data_width      : integer := 16);
port (
    clk               : in std_logic;
    rst_l             : in std_logic;
    iViChannel        : in integer;
    iRgbSelect        : in integer;
    iFrameData        : in fcolors;
    oVideoData        : out vStreamData);
end component video_select;
component vfp_s_axis is
generic (
    i_data_width                : integer := 8;
    b_data_width                : integer := 32;
    s_data_width                : integer := 16);
port (
    m_axis_mm2s_aclk            : in std_logic;
    m_axis_mm2s_aresetn         : in std_logic;
    iMmAxi                      : in integer;
    iStreamData                 : in vStreamData;
    rx_axis_tready_o            : in std_logic;
    rx_axis_tvalid              : out std_logic;
    rx_axis_tuser               : out std_logic;
    rx_axis_tlast               : out std_logic;
    rx_axis_tdata               : out std_logic_vector(s_data_width-1 downto 0);
    rgb_m_axis_tvalid           : out std_logic;
    rgb_m_axis_tlast            : out std_logic;
    rgb_m_axis_tuser            : out std_logic;
    rgb_m_axis_tready           : in std_logic;
    rgb_m_axis_tdata            : out std_logic_vector(s_data_width-1 downto 0);
    rgb_s_axis_tready           : out std_logic;
    rgb_s_axis_tvalid           : in std_logic;
    rgb_s_axis_tuser            : in std_logic;
    rgb_s_axis_tlast            : in std_logic;
    rgb_s_axis_tdata            : in std_logic_vector(s_data_width-1 downto 0));
end component vfp_s_axis;
component vfp_m_axis is
generic (
    s_data_width                : integer := 16);
port (
    aclk                        : in std_logic;
    aresetn                     : in std_logic;
    rgb_s_axis_tready           : out std_logic;
    rgb_s_axis_tvalid           : in std_logic;
    rgb_s_axis_tuser            : in std_logic;
    rgb_s_axis_tlast            : in std_logic;
    rgb_s_axis_tdata            : in std_logic_vector(s_data_width-1  downto 0);
    m_axis_mm2s_tkeep           : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tstrb           : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tid             : out std_logic_vector(0 downto 0);
    m_axis_mm2s_tdest           : out std_logic_vector(0 downto 0);
    m_axis_mm2s_tready          : in std_logic;
    m_axis_mm2s_tvalid          : out std_logic;
    m_axis_mm2s_tuser           : out std_logic;
    m_axis_mm2s_tlast           : out std_logic;
    m_axis_mm2s_tdata           : out std_logic_vector(s_data_width-1 downto 0));
end component vfp_m_axis;
component camera_raw_data is
generic (
    dataWidth         : integer := 12;
    img_width         : integer := 8);
port (
    m_axis_aclk       : in std_logic;
    m_axis_aresetn    : in std_logic;
    pixclk            : in std_logic;
    ifval             : in std_logic;
    ilval             : in std_logic;
    idata             : in std_logic_vector(dataWidth-1 downto 0);
    oRawData          : out r2xData);
end component camera_raw_data;
component camera_raw_to_rgb is
generic (
    img_width                   : integer := 8;
    dataWidth                   : integer := 12;
    addrWidth                   : integer := 12);
port (
    m_axis_mm2s_aclk            : in std_logic;
    m_axis_mm2s_aresetn         : in std_logic;
    pixclk                      : in std_logic;
    ifval                       : in std_logic;
    ilval                       : in std_logic;
    idata                       : in std_logic_vector(dataWidth-1 downto 0);
    oRgbSet                     : out rRgb);
end component camera_raw_to_rgb;
component video_stream is
generic (
    revision_number             : std_logic_vector(31 downto 0) := x"00000000";
    i_data_width                : integer := 8;
    s_data_width                : integer := 16;
    b_data_width                : integer := 32;
    img_width                   : integer := 256;
    adwrWidth                   : integer := 16;
    addrWidth                   : integer := 12;
    bmp_width                   : integer := 1920;
    bmp_height                  : integer := 1080;
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
    F_HSL                       : boolean := false);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iWrRegs                     : in mRegs;
    oRdRegs                     : out mRegs;
    iRgbSet                     : in rRgb;
    oVideoData                  : out vStreamData;
    oMmAxi                      : out integer);
end component video_stream;
component vfp_config is
generic (
    revision_number             : std_logic_vector(31 downto 0) := x"02052019";
    conf_data_width             : integer:= 32;
    conf_addr_width             : integer:= 4);
port (
    wrRegsOut                   : out mRegs;
    rdRegsIn                    : in mRegs;
    S_AXI_ACLK                  : in std_logic;
    S_AXI_ARESETN               : in std_logic;
    S_AXI_AWADDR                : in std_logic_vector(conf_addr_width-1 downto 0);
    S_AXI_AWPROT                : in std_logic_vector(2 downto 0);
    S_AXI_AWVALID               : in std_logic;
    S_AXI_AWREADY               : out std_logic;
    S_AXI_WDATA                 : in std_logic_vector(conf_data_width-1 downto 0);
    S_AXI_WSTRB                 : in std_logic_vector((conf_data_width/8)-1 downto 0);
    S_AXI_WVALID                : in std_logic;
    S_AXI_WREADY                : out std_logic;
    S_AXI_BRESP                 : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                : out std_logic;
    S_AXI_BREADY                : in std_logic;
    S_AXI_ARADDR                : in std_logic_vector(conf_addr_width-1 downto 0);
    S_AXI_ARPROT                : in std_logic_vector(2 downto 0);
    S_AXI_ARVALID               : in std_logic;
    S_AXI_ARREADY               : out std_logic;
    S_AXI_RDATA                 : out std_logic_vector(conf_data_width-1 downto 0);
    S_AXI_RRESP                 : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                : out std_logic;
    S_AXI_RREADY                : in std_logic);
end component vfp_config;
component buffer_controller is
generic (
    img_width                   : integer := 4096;
    adwrWidth                   : integer := 16;
    dataWidth                   : integer := 12;
    addrWidth                   : integer := 12);
port (
    aclk                        : in std_logic;
    i_enable                    : in std_logic;
    i_data                      : in std_logic_vector(dataWidth - 1 downto 0);
    i_wadd                      : in std_logic_vector(adwrWidth - 1 downto 0);
    i_radd                      : in std_logic_vector(adwrWidth - 1 downto 0);
    en_datao                    : out std_logic;
    taps0x                      : out std_logic_vector(dataWidth - 1 downto 0);
    taps1x                      : out std_logic_vector(dataWidth - 1 downto 0);
    taps2x                      : out std_logic_vector(dataWidth - 1 downto 0));
end component buffer_controller;
component taps_controller is
generic (
    img_width     : integer := 4096;
    tpDataWidth   : integer := 8);
port (
    clk         : in std_logic;
    iRgb        : in channel;
    rst_l       : in std_logic;
    tpValid     : out std_logic;
    tp0         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp1         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp2         : out std_logic_vector(tpDataWidth - 1 downto 0));
end component taps_controller;
component rgb_4taps is
generic (
    img_width     : integer := 4096;
    tpDataWidth   : integer := 8);
port (
    clk         : in std_logic;
    iRgb        : in channel;
    rst_l       : in std_logic;
    tpValid     : out std_logic;
    tp0         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp1         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp2         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp3         : out std_logic_vector(tpDataWidth - 1 downto 0));
end component rgb_4taps;
component rgb_4_taps is
generic (
    img_width     : integer := 4096;
    tpDataWidth   : integer := 8);
port (
    clk         : in std_logic;
    iRgb        : in channel;
    rst_l       : in std_logic;
    tpValid     : out std_logic;
    tap_1       : out std_logic_vector(tpDataWidth - 1 downto 0);
    tap_2       : out std_logic_vector(tpDataWidth - 1 downto 0);
    tap_3       : out std_logic_vector(tpDataWidth - 1 downto 0);
    tap_4       : out std_logic_vector(tpDataWidth - 1 downto 0));
end component rgb_4_taps;
component rgb_3_taps is
generic (
    img_width     : integer := 4096;
    tpDataWidth   : integer := 8);
port (
    clk         : in std_logic;
    iRgb        : in channel;
    rst_l       : in std_logic;
    tpValid     : out std_logic;
    tap_1       : out std_logic_vector(tpDataWidth - 1 downto 0);
    tap_2       : out std_logic_vector(tpDataWidth - 1 downto 0);
    tap_3       : out std_logic_vector(tpDataWidth - 1 downto 0));
end component rgb_3_taps;
component rgb_8taps is
generic (
    img_width     : integer := 4096;
    tpDataWidth   : integer := 8);
port (
    clk         : in std_logic;
    iRgb        : in channel;
    rst_l       : in std_logic;
    tpValid     : out std_logic;
    tp0         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp1         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp2         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp3         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp4         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp5         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp6         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp7         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp8         : out std_logic_vector(tpDataWidth - 1 downto 0));
end component rgb_8taps;
component tapLine is
generic (
    img_width    : integer := 4095;
    tpDataWidth  : integer := 12);
port (
    clk          : in std_logic;
    rst_l       : in std_logic;
    valid        : in std_logic;
    idata        : in std_logic_vector(tpDataWidth - 1 downto 0);
    odata        : out std_logic_vector(tpDataWidth - 1 downto 0));
end component tapLine;
component tap4Line is
generic (
    img_width    : integer := 4095;
    tpDataWidth  : integer := 12);
port (
    clk          : in std_logic;
    rst_l        : in std_logic;
    write_en     : in std_logic;
    idata        : in std_logic_vector(tpDataWidth - 1 downto 0);
    read_en      : in std_logic;
    odata        : out std_logic_vector(tpDataWidth - 1 downto 0));
end component tap4Line;
component sharp_mac is
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    vTap0x                      : in std_logic_vector(7 downto 0);
    vTap1x                      : in std_logic_vector(7 downto 0);
    vTap2x                      : in std_logic_vector(7 downto 0);
    kls                         : in coefficient;
    DataO                       : out std_logic_vector(7 downto 0));
end component sharp_mac;
component data_taps is
generic (
    img_width                   : integer := 4096;
    dataWidth                   : integer := 11;
    addrWidth                   : integer := 12);
port (
    aclk                        : in std_logic;
    iRawData                    : in rData;
    oTpData                     : out rTp);
end component data_taps;
component read_kernel2_coefs is
generic (
    s_data_width  : integer := 16;
    input_file    : string  := "Null");
port (
    clk             : in std_logic;
    reset           : in std_logic;
    iCord           : in coord;
    kSet1out        : out  kernelCoeff);
end component read_kernel2_coefs;
component raw_to_rgb is
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iTpData                     : in rTp;
    oRgbSet                     : out rRgb);
end component raw_to_rgb;
component digital_clock is
port (
    clk     : in std_logic;
    oSec    : out std_logic_vector(5 downto 0);
    oMin    : out std_logic_vector(5 downto 0);
    oHou    : out std_logic_vector(4 downto 0));
end component digital_clock;
component frame_process is
generic (
    i_data_width                : integer := 8;
    s_data_width                : integer := 16;
    b_data_width                : integer := 32;
    bmp_width                   : integer := 1920;
    bmp_height                  : integer := 1080;
    img_width                   : integer := 256;
    adwrWidth                   : integer := 16;
    addrWidth                   : integer := 12;
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
    F_HSL                       : boolean := false);
port (
    clk                     : in std_logic;
    rst_l                   : in std_logic;
    iRgbSet                 : in rRgb;
    --cpu side in
    iRgbCoord               : in region;
    iRoi                    : in poi;
    iKls                    : in coefficient;
    iAls                    : in coefficient;
    iLumTh                  : in integer;
    iHsvPerCh               : in integer;
    iYccPerCh               : in integer;
    iSobelTh                : in integer;
    iVideoChannel           : in integer;
    iFilterId               : in integer;
    oKcoeff                 : out kernelCoeff;
    --out
    oFrameData              : out fcolors;
    --to cpu
    oFifoStatus             : out std_logic_vector(b_data_width-1 downto 0);
    oGridLockData           : out std_logic_vector(b_data_width-1 downto 0));
end component frame_process;
component sharp_filter is
generic (
    i_data_width                : integer := 8;
    img_width                   : integer := 256;
    adwrWidth                   : integer := 16;
    addrWidth                   : integer := 12);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iRgb                        : in channel;
    kls                         : in coefficient;
    oRgb                        : out channel);
end component sharp_filter;
component frame_mask is
generic (
    eBlack         : boolean := false);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iEdgeValid     : in  std_logic;
    i1Rgb          : in channel;
    i2Rgb          : in channel;
    oRgb           : out channel);
end component frame_mask;
component frame_remake is
port (
    clk            : in std_logic;
    reset          : in std_logic;
    iEdgeValid     : in std_logic;
    iRgb           : in frameColors);
end component frame_remake;
component dither_filter is
generic (
    img_width         : integer := 512;
    img_height        : integer := 512;
    color_width       : integer := 8;
    reduced_width     : integer := 4);
port (
    clk               : in  std_logic;
    iCord_x           : in  std_logic_vector(15 downto 0);
    iRgb              : in  channel;
    oRgb              : out  channel);
end component dither_filter;
component blur_filter is
generic (
    iMSB                        : integer := 11;
    iLSB                        : integer := 4;
    i_data_width                : integer := 8;
    img_width                   : integer := 256;
    adwrWidth                   : integer := 16;
    addrWidth                   : integer := 12);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iRgb                        : in channel;
    oRgb                        : out channel);
end component blur_filter;
component blur_filter_4by4 is
generic (
    iMSB                        : integer := 11;
    iLSB                        : integer := 4;
    i_data_width                : integer := 8;
    img_width                   : integer := 256;
    adwrWidth                   : integer := 16;
    addrWidth                   : integer := 12);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iRgb                        : in channel;
    oRgb                        : out channel);
end component blur_filter_4by4;
component blur_mac is
generic (
    i_data_width        : integer := 8);
port (
    clk                 : in std_logic;
    rst_l               : in std_logic;
    iTap1               : in std_logic_vector(i_data_width-1 downto 0);
    iTap2               : in std_logic_vector(i_data_width-1 downto 0);
    iTap3               : in std_logic_vector(i_data_width-1 downto 0);
    oBlurData           : out std_logic_vector(i_data_width+3 downto 0));
end component blur_mac;
component testpattern is
port (
    clk                   : in std_logic;
    iValid                : in std_logic;
    iCord                 : in coord;
    tpSelect              : in integer;
    oRgb                  : out channel);
end component testpattern;
component frame_testpattern is
generic (
    s_data_width                : integer := 16);
port (
    clk                         : in std_logic;
    iValid                      : in std_logic;
    iCord                       : in coord;
    oRgb                        : out blurchannel);
end component frame_testpattern;
component ResoTestPattern is
generic (
    s_data_width                : integer := 16);
port (
    clk                   : in std_logic;
    iValid                : in std_logic;
    iCord                 : in coord;
    oRgbCo                : out channel;
    oRgbRed               : out channel;
    oRgbGre               : out channel;
    oRgbBlu               : out channel);
end component ResoTestPattern;
component edge_objects is
generic (
    i_data_width                : integer := 8);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iRgb                        : in channel;
    oRgbRemix                   : out channel);
end component edge_objects;
component detect_pixel is
generic (
    i_data_width                : integer := 8);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    endOfFrame                  : in std_logic;
    iRgb                        : in channel;
    oRgb                        : out channel;
    rgbCoord                    : in region;
    iCord                       : in coord;
    pDetect                     : out std_logic);
end component detect_pixel;
component point_of_interest is
generic (
    i_data_width                : integer := 8;
    s_data_width                : integer := 16;
    b_data_width                : integer := 32);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iRgb                        : in channel;
    oRgb                        : out channel;
    iCord                       : in coord;
    endOfFrame                  : in std_logic;
    iRoi                     : in poi;
    gridLockDatao               : out std_logic_vector(b_data_width-1 downto 0);
    fifoStatus                  : out std_logic_vector(b_data_width-1 downto 0);
    oGridLocation               : out std_logic);
end component point_of_interest;
component grid_lock_fifo is
generic (
    FIFO_DEPTH                  : integer := 24;
    FIFO_DATA_WIDTH             : integer := 24;
    FIFO_ADDR_WIDTH             : integer := 14);
port (
    clk                         : in  std_logic;
    clrStatus                   : in  std_logic;
    rdEn                        : in  std_logic;
    rdAddress                   : in  std_logic_vector (FIFO_ADDR_WIDTH-1 downto 0);
    dataO                       : out std_logic_vector (FIFO_DATA_WIDTH-1 downto 0);
    wrEn                        : in  std_logic;
    wrAddress                   : in  std_logic_vector (FIFO_ADDR_WIDTH-1 downto 0);
    datain                      : in  std_logic_vector (FIFO_DATA_WIDTH-1 downto 0);
    wrDone                      : out std_logic;
    rdDone                      : out std_logic;
    emptyO                      : out std_logic;
    fullO                       : out std_logic);
end component;
component hsv_c is
generic (
    i_data_width                : integer := 8);
port (
    clk                         : in  std_logic;
    reset                       : in  std_logic;
    iRgb                        : in channel;
    oHsv                        : out channel);
end component hsv_c;
component lum_values is
generic (
    F_LGT                       : boolean := false;
    F_DRK                       : boolean := false;
    F_LUM                       : boolean := false;
    i_data_width                : integer := 8);
port (
    clk                         : in  std_logic;
    reset                       : in  std_logic;
    iRgb                        : in channel;
    oRgb                        : out channel);
end component lum_values;
component segment_colors is
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iLumTh         : in  integer;
    iRgb           : in channel;
    oRgb           : out channel);
end component segment_colors;
component avg_values is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    aRgb           : in channel;
    bRgb           : in channel;
    cRgb           : in channel;
    oRgb           : out channel);
end component avg_values;
component hsl_c is
generic (
    i_data_width                : integer := 8);
port (
    clk                         : in  std_logic;
    reset                       : in  std_logic;
    iRgb                        : in channel;
    oHsl                        : out channel);
end component hsl_c;
component rgb_ycbcr is
generic (
    i_data_width                : integer:= 8;
    i_precision                 : integer:= 12;
    i_full_range                : boolean:= FALSE);
port (
    clk                         : in  std_logic;
    rst_l                       : in  std_logic;
    iRgb                        : in channel;
    y                           : out std_logic_vector(i_data_width-1 downto 0);
    cb                          : out std_logic_vector(i_data_width-1 downto 0);
    cr                          : out std_logic_vector(i_data_width-1 downto 0);
    oValid                      : out std_logic);
end component rgb_ycbcr;
component color_correction is
generic (
    i_k_config_number           : integer := 8);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iRgb                        : in channel;
    als                         : in coefficient;
    oRgb                        : out channel);
end component color_correction;
component rgb_contrast_brightness is
generic (
    exposer_val                 : integer := 8);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iRgb                        : in channel;
    oRgb                        : out channel);
end component rgb_contrast_brightness;
component rgb_contrast_brightness_level_1 is
generic (
    contrast_val  : sfixed(15 downto -3) := to_sfixed(5.0,15,-3);
    exposer_val                 : integer := 8);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iRgb                        : in channel;
    oRgb                        : out channel);
end component rgb_contrast_brightness_level_1;
component rgb_contrast_brightness_level_2 is
generic (
    exposer_val                 : integer := 8);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iRgb                        : in channel;
    oRgb                        : out channel);
end component rgb_contrast_brightness_level_2;
component recolor_rgb is
generic (
    CCC1               : boolean := false;
    CCC2               : boolean := false;
    CCC3               : boolean := false;
    CCC4               : boolean := false;
    CCC5               : boolean := false;
    CCC6               : boolean := false;
    CCC7               : boolean := false;
    CCC8               : boolean := false;
    CCM1               : boolean := false;
    CCM2               : boolean := false;
    CCM3               : boolean := false;
    CCM4               : boolean := false;
    CCM5               : boolean := false;
    CCM6               : boolean := false;
    CCM7               : boolean := false;
    CCM8               : boolean := false;
    img_width          : integer := 8);
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    iRgb                        : in channel;
    txCord                      : in coord;
    oRgb                        : out channel);
end component recolor_rgb;
component ccm is
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    k_config_number             : in integer;
    coefficients_in             : in coefficient_values;
    coefficients_out            : out coefficient_values;
    iRgb                        : in channel;
    oRgb                        : out channel);
end component ccm;

component ccm_frame is
generic (
    k_config_number   : integer := 8);
port (
    clk                : in std_logic;
    rst_l              : in std_logic;
    iRgb               : in channel;
    oRgb               : out channel);
end component ccm_frame;

component ImageKernel is
generic (
    SHARP_FRAME           : boolean := false;
    BLURE_FRAME           : boolean := false;
    EMBOS_FRAME           : boolean := false;
    YCBCR_FRAME           : boolean := false;
    SOBEL_FRAME           : boolean := false;
    CGAin_FRAME           : boolean := false;
    img_width             : integer := 4096;
    i_data_width          : integer := 8);
port (
    clk                   : in std_logic;
    rst_l                 : in std_logic;
    iRgb                  : in channel;
    als                   : in coefficient;
    oEdgeValid            : out std_logic;
    oRgb                  : out colors);
end component ImageKernel;
component kernel_core is
generic (
    SHARP_FRAME           : boolean := false;
    BLURE_FRAME           : boolean := false;
    EMBOS_FRAME           : boolean := false;
    YCBCR_FRAME           : boolean := false;
    SOBEL_FRAME           : boolean := false;
    CGAin_FRAME           : boolean := false;
    img_width             : integer := 4096;
    i_data_width          : integer := 8);
port (
    clk              : in std_logic;
    rst_l            : in std_logic;
    iRgb             : in channel;
    kCoeff           : in kernelCoeDWord;
    oRgb             : out channel);
end component kernel_core;
component rgb_kernal_prod is
port (
    clk              : in std_logic;
    rst_l            : in std_logic;
    iRgb             : in channel;
    iCoeff           : in kernelCoeDWord;
    iTaps            : in TapsRecord;
    oRgbFloat        : out rgbFloat;
    oRgbSnFix        : out rgbToSnSumTrRecord);
end component rgb_kernal_prod;
component sign_fixed_resize is
port (
    clk              : in std_logic;
    kCoeffProd       : in kCoeffFloat;
    oRgb             : out rgbToSnSumTrRecord);
end component sign_fixed_resize;
component tap_buffer
generic (
    img_width                   : integer := 4096;
    dataWidth                   : integer := 12;
    addrWidth                   : integer := 12);
port (
    write_clk                   : in std_logic;
    write_enb                   : in std_logic;
    w_address                   : in std_logic_vector(addrWidth - 1 downto 0);
    idata                       : in std_logic_vector(dataWidth - 1 downto 0);
    read_clk                    : in std_logic;
    r_address                   : in std_logic_vector(addrWidth - 1 downto 0);
    odata                       : out std_logic_vector(dataWidth - 1 downto 0));
end component;
component mWrRd
generic (
    revision_number             : std_logic_vector(31 downto 0) := x"00000000";
    s_data_width                : integer    := 16;
    b_data_width                : integer    := 32);
port (
    -- Master Write Read Registers
    iWrRegs           : in mRegs;
    oReRegs           : out mRegs;
    -- System Time
    iSeconds          : in std_logic_vector(5 downto 0);
    iMinutes          : in std_logic_vector(5 downto 0);
    iHours            : in std_logic_vector(4 downto 0);
    -- Fifo Data
    iFifoStatus       : in std_logic_vector(b_data_width-1 downto 0);
    iGridLockData     : in std_logic_vector(b_data_width-1 downto 0);
    -- Configured filters coeffs
    iKcoeff           : in kernelCoeff;
    -- Fixed filters kernal coeffs
    oAls              : out coefficient;
    -- Customizable filters kernal coeffs
    oKls              : out coefficient;
    -- Filter lum theshold value
    oLumTh            : out integer;
    -- Hsv filter per color select
    oHsvPerCh         : out integer;
    -- Ycbcr filter per color select
    oYccPerCh         : out integer;
    -- Rgb max min limits
    oRgbRoiLimits     : out region;
    -- Filters id
    oFilterId         : out integer;
    -- oMmAxi end node bus select
    oMmAxi            : out integer;
    -- Sobel filter Threshold
    oSobelThresh      : out integer;
    -- Video channel
    oVideoChannel     : out integer;
    -- Rgb select id
    oRgbSelect        : out integer;
    -- Region of interest
    oRoi              : out poi);
end component;
component pixel_cord is
port (
    clk                         : in std_logic;
    iRgb                        : in channel;
    iPixelEn                    : in std_logic;
    iEof                        : in std_logic;
    iCord                       : in cord;
    oRgb                        : out channel);
end component pixel_cord;
component axis_external
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
    rgb_m_axis_aclk             : in std_logic;
    rgb_m_axis_aresetn          : in std_logic;
    rgb_m_axis_tready           : in std_logic;
    rgb_m_axis_tvalid           : out std_logic;
    rgb_m_axis_tlast            : out std_logic;
    rgb_m_axis_tuser            : out std_logic;
    rgb_m_axis_tdata            : out std_logic_vector(C_rgb_m_axis_TDATA_WIDTH-1 downto 0);
    rgb_s_axis_aclk             : in std_logic;
    rgb_s_axis_aresetn          : in std_logic;
    rgb_s_axis_tready           : out std_logic;
    rgb_s_axis_tvalid           : in std_logic;
    rgb_s_axis_tuser            : in std_logic;
    rgb_s_axis_tlast            : in std_logic;
    rgb_s_axis_tdata            : in std_logic_vector(C_rgb_s_axis_TDATA_WIDTH-1 downto 0);
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
end component;
component fixedToFloat is
port (
    aclk                    : in std_logic;
    s_axis_a_tvalid         : in std_logic;
    s_axis_a_tdata          : in std_logic_vector (31 downto 0 );
    m_axis_result_tvalid    : out std_logic;
    m_axis_result_tdata     : out std_logic_vector (31 downto 0));
end component fixedToFloat;
component floatToFixed is
port (
    aclk                    : in std_logic;
    s_axis_a_tvalid         : in std_logic;
    s_axis_a_tdata          : in std_logic_vector (31 downto 0 );
    m_axis_result_tvalid    : out std_logic;
    m_axis_result_tdata     : out std_logic_vector (31 downto 0));
end component floatToFixed;
component squareRootTop is
port (
    clk                         : in std_logic;
    ivalid                      : in std_logic;
    idata                       : in std_logic_vector(31 downto 0);
    ovalid                      : out std_logic;
    odata                       : out std_logic_vector(31 downto 0));
end component squareRootTop;
component squareRoot is
port (
    aclk                    : in std_logic;
    s_axis_a_tvalid         : in std_logic;
    s_axis_a_tdata          : in std_logic_vector (31 downto 0);
    m_axis_result_tvalid    : out std_logic;
    m_axis_result_tdata     : out std_logic_vector (31 downto 0));
end component squareRoot;
component ByteToFloat is
port (
    aclk                 : in std_logic;
    s_axis_a_tvalid      : in std_logic;
    s_axis_a_tdata       : in std_logic_vector(15 DOWNTO 0);
    m_axis_result_tvalid : out std_logic;
    m_axis_result_tdata  : out std_logic_vector(31 DOWNTO 0));
end component ByteToFloat;
component ByteToFloatTop is
port (
    aclk           : in std_logic;
    rst_l          : in std_logic;
    iValid         : in std_logic;
    iData          : in std_logic_vector(7 downto 0);
    oValid         : out std_logic;
    oDataFloat     : out std_logic_vector(31 downto 0));
end component ByteToFloatTop;
component WordToFloat is
port (
    aclk                 : in std_logic;
    s_axis_a_tvalid      : in std_logic;
    s_axis_a_tdata       : in std_logic_vector(15 DOWNTO 0);
    m_axis_result_tvalid : out std_logic;
    m_axis_result_tdata  : out std_logic_vector(31 DOWNTO 0));
end component WordToFloat;
component WordToFloatTop is
port (
    aclk           : in std_logic;
    rst_l          : in std_logic;
    iValid         : in std_logic;
    iData          : in std_logic_vector(15 downto 0);
    oValid         : out std_logic;
    oDataFloat     : out std_logic_vector(31 downto 0));
end component WordToFloatTop;
component FloatMultiply is
port (
    aclk                    : in std_logic;
    s_axis_a_tvalid         : in std_logic;
    s_axis_a_tdata          : in std_logic_vector(31 DOWNTO 0);
    s_axis_b_tvalid         : in std_logic;
    s_axis_b_tdata          : in std_logic_vector(31 DOWNTO 0);
    m_axis_result_tvalid    : out std_logic;
    m_axis_result_tdata     : out std_logic_vector(31 DOWNTO 0));
end component FloatMultiply;
component FloatMultiplyTop is
port (
    clk            : in std_logic;
    iAdata         : in std_logic_vector(31 downto 0);
    iBdata         : in std_logic_vector(31 downto 0);
    oRdata         : out std_logic_vector(31 downto 0));
end component FloatMultiplyTop;
component FloatToFixedv1 is
port (
    aclk                    : in std_logic;
    s_axis_a_tvalid         : in std_logic;
    s_axis_a_tdata          : in std_logic_vector(31 DOWNTO 0);
    m_axis_result_tvalid    : out std_logic;
    m_axis_result_tdata     : out std_logic_vector(31 DOWNTO 0));
end component FloatToFixedv1;
component FloatToFixedv1Top is
port (
    aclk           : in std_logic;
    iData          : in std_logic_vector(31 downto 0);
    oData          : out std_logic_vector(27 downto 0));
end component FloatToFixedv1Top;
component coef_mult is
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iKcoeff        : in kernelCoeff;
    iFilterId      : in integer;
    oKcoeff        : out kernelCoeff;
    oCoeffProd     : out kCoefFiltFloat);
end component coef_mult;
component imageRead is
generic (
    i_data_width                : integer := 8;
    img_frames_cnt_bmp          : integer := 2;
    img_width_bmp               : integer := 400;
    img_height_bmp              : integer := 300;
    input_file                  : string  := "input_image");
port (                
    clk                : in  std_logic;
    reset              : in  std_logic;
    readyToRead        : in  std_logic;
    fvalid             : out std_logic;
    lvalid             : out std_logic;
    oRgb               : out channel;
    oFileCont          : out cord;
    oCord              : out coord;
    endOfFrame         : out std_logic);
end component imageRead;
component imageWrite is
generic (
    enImageText                 : boolean := false;
    enImageIndex                : boolean := false;
    i_data_width                : integer := 8;
    img_width_bmp               : integer := 400;
    img_height_bmp              : integer := 300;
    input_file                  : string  := "input_image";
    output_file                 : string  := "output_image");
port (                
    clk                         : in  std_logic;
    iFile                       : in  channel;
    iFileCont                   : in  cord;
    pixclk                      : in  std_logic;
    enableWrite                 : in  std_logic;
    doneWrite                   : out std_logic;
    oFrameEnable                : out std_logic;
    oCord                       : out coord;
    iRgb                        : in  channel);
end component imageWrite;
component videoProcess_v1_0_m_axis_mm2s is
generic (
    s_data_width                : integer := 16);
port (
    aclk                        : in std_logic;
    aresetn                     : in std_logic;
    rgb_s_axis_tready           : out std_logic;
    rgb_s_axis_tvalid           : in std_logic;
    rgb_s_axis_tuser            : in std_logic;
    rgb_s_axis_tlast            : in std_logic;
    rgb_s_axis_tdata            : in std_logic_vector(s_data_width-1  downto 0);
    m_axis_mm2s_tkeep           : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tstrb           : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tid             : out std_logic_vector(0 downto 0);
    m_axis_mm2s_tdest           : out std_logic_vector(0 downto 0);  
    m_axis_mm2s_tready          : in std_logic;
    m_axis_mm2s_tvalid          : out std_logic;
    m_axis_mm2s_tuser           : out std_logic;
    m_axis_mm2s_tlast           : out std_logic;
    m_axis_mm2s_tdata           : out std_logic_vector(s_data_width-1 downto 0));
end component videoProcess_v1_0_m_axis_mm2s;
component videoProcess_v1_0_rgb_m_axis is
generic (
    i_data_width                : integer := 8;
    b_data_width                : integer := 32;
    s_data_width                : integer := 16);
port (                          
    m_axis_mm2s_aclk            : in std_logic;
    m_axis_mm2s_aresetn         : in std_logic;
    aBusSelect                  : in std_logic_vector(b_data_width-1 downto 0);
    iStreamData                 : in vStreamData;
    rx_axis_tready_o            : in std_logic;
    rx_axis_tvalid              : out std_logic;
    rx_axis_tuser               : out std_logic;
    rx_axis_tlast               : out std_logic;
    rx_axis_tdata               : out std_logic_vector(s_data_width-1 downto 0);
    rgb_m_axis_tvalid           : out std_logic;
    rgb_m_axis_tlast            : out std_logic;
    rgb_m_axis_tuser            : out std_logic;
    rgb_m_axis_tready           : in std_logic;
    rgb_m_axis_tdata            : out std_logic_vector(s_data_width-1 downto 0);
    rgb_s_axis_tready           : out std_logic;
    rgb_s_axis_tvalid           : in std_logic;
    rgb_s_axis_tuser            : in std_logic;
    rgb_s_axis_tlast            : in std_logic;
    rgb_s_axis_tdata            : in std_logic_vector(s_data_width-1 downto 0));
end component videoProcess_v1_0_rgb_m_axis;
component videoProcess_v1_0_Config is
generic (
    revision_number             : std_logic_vector(31 downto 0) := x"02052019";
    C_S_AXI_DATA_WIDTH          : integer:= 32;
    C_S_AXI_ADDR_WIDTH          : integer:= 4);
port (
    wrRegsOut                   : out mRegs;
    rdRegsIn                    : in mRegs;
    S_AXI_ACLK                  : in std_logic;
    S_AXI_ARESETN               : in std_logic;
    S_AXI_AWADDR                : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWPROT                : in std_logic_vector(2 downto 0);
    S_AXI_AWVALID               : in std_logic;
    S_AXI_AWREADY               : out std_logic;
    S_AXI_WDATA                 : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB                 : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID                : in std_logic;
    S_AXI_WREADY                : out std_logic;
    S_AXI_BRESP                 : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                : out std_logic;
    S_AXI_BREADY                : in std_logic;
    S_AXI_ARADDR                : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARPROT                : in std_logic_vector(2 downto 0);
    S_AXI_ARVALID               : in std_logic;
    S_AXI_ARREADY               : out std_logic;
    S_AXI_RDATA                 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP                 : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                : out std_logic;
    S_AXI_RREADY                : in std_logic);
end component videoProcess_v1_0_Config;
component AxisExternal
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
    iBusSelect                  : in std_logic_vector(b_data_width-1 downto 0);
    iStreamData                 : in vStreamData;
    oWrRegs                     : out mRegs;
    iRdRegs                     : in mRegs;
    rgb_m_axis_aclk             : in std_logic;
    rgb_m_axis_aresetn          : in std_logic;
    rgb_m_axis_tready           : in std_logic;
    rgb_m_axis_tvalid           : out std_logic;
    rgb_m_axis_tlast            : out std_logic;
    rgb_m_axis_tuser            : out std_logic;
    rgb_m_axis_tdata            : out std_logic_vector(C_rgb_m_axis_TDATA_WIDTH-1 downto 0);
    rgb_s_axis_aclk             : in std_logic;
    rgb_s_axis_aresetn          : in std_logic;
    rgb_s_axis_tready           : out std_logic;
    rgb_s_axis_tvalid           : in std_logic;
    rgb_s_axis_tuser            : in std_logic;
    rgb_s_axis_tlast            : in std_logic;
    rgb_s_axis_tdata            : in std_logic_vector(C_rgb_s_axis_TDATA_WIDTH-1 downto 0);
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
end component;
component read_image is
generic (
    enImageText   : boolean := false;
    enImageIndex  : boolean := false;
    i_data_width  : integer := 8;
    test          : string  := "folder";
    input_file    : string  := "input_image";
    output_file   : string  := "output_image");
port (
    pixclk        : in  std_logic;
    oCord         : out coord;
    oRgb          : out channel);
end component read_image;


component vfp_v1_0
generic (
        revision_number           : std_logic_vector(31 downto 0) := x"05202022";
        C_vfpConfig_DATA_WIDTH    : integer    := 32;
        C_vfpConfig_ADDR_WIDTH    : integer    := 8;
        C_oVideo_TDATA_WIDTH      : integer    := 24;
        C_oVideo_START_COUNT      : integer    := 32;
        C_iVideo_TDATA_WIDTH      : integer    := 24;
        FRAME_WIDTH               : natural    := 1280;
        FRAME_HEIGHT              : natural    := 720);
port (
        vfpconfig_aclk            : in std_logic;
        vfpconfig_aresetn         : in std_logic;
        vfpconfig_awaddr          : in std_logic_vector(7 downto 0);
        vfpconfig_awprot          : in std_logic_vector(2 downto 0);
        vfpconfig_awvalid         : in std_logic;
        vfpconfig_awready         : out std_logic;
        vfpconfig_wdata           : in std_logic_vector(31 downto 0);
        vfpconfig_wstrb           : in std_logic_vector(3 downto 0);
        vfpconfig_wvalid          : in std_logic;
        vfpconfig_wready          : out std_logic;
        vfpconfig_bresp           : out std_logic_vector(1 downto 0);
        vfpconfig_bvalid          : out std_logic;
        vfpconfig_bready          : in std_logic;
        vfpconfig_araddr          : in std_logic_vector(7 downto 0);
        vfpconfig_arprot          : in std_logic_vector(2 downto 0);
        vfpconfig_arvalid         : in std_logic;
        vfpconfig_arready         : out std_logic;
        vfpconfig_rdata           : out std_logic_vector(31 downto 0);
        vfpconfig_rresp           : out std_logic_vector(1 downto 0);
        vfpconfig_rvalid          : out std_logic;
        vfpconfig_rready          : in std_logic;
        ovideo_aclk               : in std_logic;
        ovideo_aresetn            : in std_logic;
        ovideo_tvalid             : out std_logic;
        ovideo_tkeep              : out std_logic_vector(2 downto 0);
        ovideo_tdata              : out std_logic_vector(23 downto 0);
        ovideo_tstrb              : out std_logic_vector(2 downto 0);
        ovideo_tlast              : out std_logic;
        ovideo_tready             : in std_logic;
        ovideo_tuser              : out std_logic;
        rgb_fr_plw_red            : out std_logic_vector(7 downto 0);
        rgb_fr_plw_gre            : out std_logic_vector(7 downto 0);
        rgb_fr_plw_blu            : out std_logic_vector(7 downto 0);
        rgb_fr_plw_sof            : out std_logic;
        rgb_fr_plw_eol            : out std_logic;
        rgb_fr_plw_eof            : out std_logic;
        rgb_fr_plw_val            : out std_logic;
        rgb_fr_plw_xcnt           : out std_logic_vector(15 downto 0);
        rgb_fr_plw_ycnt           : out std_logic_vector(15 downto 0);
        crd_x                     : out std_logic_vector(15 downto 0);
        crd_y                     : out std_logic_vector(15 downto 0);
        ivideo_aclk               : in std_logic;
        ivideo_aresetn            : in std_logic;
        ivideo_tready             : out std_logic;
        ivideo_tkeep              : in std_logic_vector(2 downto 0);  
        ivideo_tdata              : in std_logic_vector(23 downto 0);
        ivideo_tstrb              : in std_logic_vector(2 downto 0);
        ivideo_tlast              : in std_logic;
        ivideo_tuser              : in std_logic; 
        ivideo_tvalid             : in std_logic);
end component;


component image_read_axi4_stream_interface
generic (
    enImageText   : boolean := false;
    enImageIndex  : boolean := false;
    i_data_width  : integer := 8;
    test          : string  := "folder";
    input_file    : string  := "input_image";
    output_file   : string  := "output_image");
port (
    clk                : in  std_logic;
    reset              : in  std_logic;
    tdata              : out std_logic_vector(31 downto 0);
    tstrb              : out std_logic_vector(3 downto 0);
    tkeep              : out std_logic_vector(3 downto 0);
    tlast              : out std_logic;
    tuser              : out std_logic;
    tvalid             : out std_logic);
end component;


end package;