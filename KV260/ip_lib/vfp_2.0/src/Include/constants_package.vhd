--12302021 [12-30-2021]
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package constants_package is
    -------------------------------------------------------------------------
    constant yes                                : std_logic := '1';
    constant no                                 : std_logic := '0';
    constant hi                                 : std_logic := '1';
    constant lo                                 : std_logic := '0';
    constant one                                : integer   := 1;
    constant zero                               : integer   := 0;
    constant ch0                                : integer   := 0;
    constant ch1                                : integer   := 1;
    constant ch2                                : integer   := 2;
    constant ch3                                : integer   := 3;
    constant FILTER_CGA                         : integer   := 0;
    constant FILTER_SHP                         : integer   := 1;
    constant FILTER_BLU                         : integer   := 2;
    constant FILTER_HSL                         : integer   := 3;
    constant FILTER_HSV                         : integer   := 4;
    constant FILTER_RGB                         : integer   := 5;
    constant FILTER_SOB                         : integer   := 6;
    constant FILTER_EMB                         : integer   := 7;
    constant FILTER_MSK_SOB_LUM                 : integer   := 8;
    constant FILTER_MSK_SOB_TRM                 : integer   := 9;
    constant FILTER_MSK_SOB_RGB                 : integer   := 10;
    constant FILTER_MSK_SOB_SHP                 : integer   := 11;
    constant FILTER_MSK_SOB_DET                 : integer   := 12;
    constant FILTER_MSK_SOB_BLU                 : integer   := 13;
    constant FILTER_MSK_SOB_YCC                 : integer   := 14;
    constant FILTER_MSK_SOB_HSV                 : integer   := 15;
    constant FILTER_MSK_SOB_HSL                 : integer   := 16;
    constant FILTER_MSK_SOB_CGA                 : integer   := 17;
    constant FILTER_COR_TRM                     : integer   := 18;
    constant FILTER_COR_LMP                     : integer   := 19;
    constant FILTER_TST_PAT                     : integer   := 20;
    constant FILTER_CGA_TO_CGA                  : integer   := 21;
    constant FILTER_CGA_TO_HSL                  : integer   := 22;
    constant FILTER_CGA_TO_HSV                  : integer   := 23;
    constant FILTER_CGA_TO_YCC                  : integer   := 24;
    constant FILTER_CGA_TO_SHP                  : integer   := 25;
    constant FILTER_CGA_TO_BLU                  : integer   := 26;
    constant FILTER_SHP_TO_CGA                  : integer   := 27;
    constant FILTER_SHP_TO_HSL                  : integer   := 28;
    constant FILTER_SHP_TO_HSV                  : integer   := 29;
    constant FILTER_SHP_TO_YCC                  : integer   := 30;
    constant FILTER_SHP_TO_SHP                  : integer   := 31;
    constant FILTER_SHP_TO_BLU                  : integer   := 32;
    constant FILTER_BLU_TO_BLU                  : integer   := 33;
    constant FILTER_BLU_TO_CGA                  : integer   := 34;
    constant FILTER_BLU_TO_SHP                  : integer   := 35;
    constant FILTER_BLU_TO_YCC                  : integer   := 36;
    constant FILTER_BLU_TO_HSV                  : integer   := 37;
    constant FILTER_BLU_TO_HSL                  : integer   := 38;
    constant FILTER_BLU_TO_CGA_TO_SHP           : integer   := 39;
    constant FILTER_BLU_TO_CGA_TO_SHP_TO_YCC    : integer   := 40;
    constant FILTER_BLU_TO_CGA_TO_SHP_TO_HSV    : integer   := 41;
    constant FILTER_BLU_TO_SHP_TO_CGA           : integer   := 42;
    constant FILTER_BLU_TO_SHP_TO_CGA_TO_YCC    : integer   := 43;
    constant FILTER_BLU_TO_SHP_TO_CGA_TO_HSV    : integer   := 44;
    constant FILTER_RGB_CORRECT                 : integer   := 45;
    constant FILTER_RGB_REMIX                   : integer   := 46;
    constant FILTER_RGB_DETECT                  : integer   := 47;
    constant FILTER_RGB_POI                     : integer   := 48;
    constant FILTER_YCC                         : integer   := 49;
    constant FILTER_K_CGA                       : integer   := 50;
    -------------------------------------------------------------------------
    constant kCoefYcbcrIndex                    : integer   := 1;
    constant kCoefCgainIndex                    : integer   := 2;
    constant kCoefSharpIndex                    : integer   := 3;
    constant kCoefBlureIndex                    : integer   := 4;
    constant kCoefSobeXIndex                    : integer   := 5;
    constant kCoefSobeYIndex                    : integer   := 6;
    constant kCoefEmbosIndex                    : integer   := 7;
    constant kCoefCgai1Index                    : integer   := 8;
    -------------------------------------------------------------------------
    constant soble                              : integer   := 0;
    constant sobRgb                             : integer   := 1;
    constant sobPoi                             : integer   := 2;
    constant hsvPoi                             : integer   := 3;
    constant sharp                              : integer   := 4;
    constant blur1x                             : integer   := 5;
    constant blur2x                             : integer   := 6;
    constant blur3x                             : integer   := 7;
    constant blur4x                             : integer   := 8;
    constant hsv                                : integer   := 9;
    constant rgb                                : integer   := 10;
    constant rgbRemix                           : integer   := 11;
    constant tPatter1                           : integer   := 12;
    constant tPatter2                           : integer   := 13;
    constant tPatter3                           : integer   := 14;
    constant tPatter4                           : integer   := 15;
    constant tPatter5                           : integer   := 16;
    constant rgbCorrect                         : integer   := 17;
    constant hsl                                : integer   := 18;
    constant hsvCcBl                            : integer   := 19;
    constant ycbcr                              : integer   := 0;
    -------------------------------------------------------------------------
    -- videoProcess constants
    -------------------------------------------------------------------------
    constant C_S_AXI_DATA_WIDTH                 : integer := 32;
    constant C_rgb_m_axis_TDATA_WIDTH           : integer := 16;
    constant C_rgb_m_axis_START_COUNT           : integer := 32;
    constant C_rgb_s_axis_TDATA_WIDTH           : integer := 16;
    constant C_m_axis_mm2s_TDATA_WIDTH          : integer := 16;
    constant C_m_axis_mm2s_START_COUNT          : integer := 32;
    constant C_vfpConfig_DATA_WIDTH             : integer := 32;
    constant C_vfpConfig_ADDR_WIDTH             : integer := 8;
    constant i_data_width                       : integer := 10;
    constant s_data_width                       : integer := 16;
    constant b_data_width                       : integer := 32;
    constant i_precision                        : integer := 12;
    constant i_full_range                       : boolean := FALSE;
    constant conf_data_width                    : integer := 32;
    constant conf_addr_width                    : integer := 8;
    -------------------------------------------------------------------------
    constant blurMsb                            : integer := 13;
    constant blurLsb                            : integer := 4;
    constant rgb_msb                            : integer := 12;
    constant rgb_lsb                            : integer := 5;
    constant XYCOORD                            : integer := 16;
    -------------------------------------------------------------------------
    constant initCordValueRht                   : integer := 0;
    constant initCordValueLft                   : integer := 65535;
    constant initCordValueTop                   : integer := 65535;
    constant initCordValueBot                   : integer := 0;
    constant frameSizeLft                       : integer := 1;
    constant frameSizeRht                       : integer := 128;
    constant frameSizeTop                       : integer := 5;
    constant frameSizeBot                       : integer := 128;
    constant pInterestWidth                     : integer := 127;
    constant pInterestHight                     : integer := 127;
    -------------------------------------------------------------------------
    constant EXTERNAL_AXIS_STREAM               : integer :=0;
    constant STREAM_TESTPATTERN1                : integer :=1;
    constant STREAM_TESTPATTERN2                : integer :=2;
    constant STREAM_TESTPATTERN3                : integer :=3;
    constant STREAM_TESTPATTERN4                : integer :=4;
    constant STREAM_TESTPATTERN5                : integer :=5;
    constant STREAM_TESTPATTERN6                : integer :=6;
    constant STREAM_TESTPATTERN7                : integer :=7;
    constant STREAM_TESTPATTERN8                : integer :=8;
    -------------------------------------------------------------------------
    
    constant blurMacKernel_1                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_2                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_3                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_4                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_5                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_6                    : unsigned(i_data_width-1 downto 0)         :="0000000101";
    constant blurMacKernel_7                    : unsigned(i_data_width-1 downto 0)         :="0000000101";
    constant blurMacKernel_8                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_9                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_10                   : unsigned(i_data_width-1 downto 0)         :="0000000101";
    constant blurMacKernel_11                   : unsigned(i_data_width-1 downto 0)         :="0000000101";
    constant blurMacKernel_12                   : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_13                   : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_14                   : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_15                   : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blurMacKernel_16                   : unsigned(i_data_width-1 downto 0)         :="0000000010";
    
    
    constant white                              : std_logic_vector(i_data_width-1 downto 0) :="1111111111";
    constant black                              : std_logic_vector(i_data_width-1 downto 0) :="0000000000";
    constant whiteUn                            : unsigned(i_data_width-1 downto 0)         :="1111111111";
    constant blackUn                            : unsigned(i_data_width-1 downto 0)         :="0000000000";
    -------------------------------------------------------------------------
    constant FONT_WIDTH                         : integer := 8;
    constant FONT_HEIGHT                        : integer := 16;
    -------------------------------------------------------------------------
    constant C_WHOLE_WIDTH                      : integer := 3;
    constant DATA_EXT_WIDTH                     : natural := i_data_width + 1;
    constant FRAC_BITS_TO_KEEP                  : natural := 3;
    constant MULT_RESULT_WIDTH                  : natural := DATA_EXT_WIDTH + C_WHOLE_WIDTH + FRAC_BITS_TO_KEEP;
    constant ADD_RESULT_WIDTH                   : natural := MULT_RESULT_WIDTH + 1;
    constant ROUND_RESULT_WIDTH                 : natural := ADD_RESULT_WIDTH - FRAC_BITS_TO_KEEP;
    constant ROUND                              : signed(ADD_RESULT_WIDTH-1 downto 0) := to_signed(0, ADD_RESULT_WIDTH-FRAC_BITS_TO_KEEP)&'1' & to_signed(0, FRAC_BITS_TO_KEEP-1);
    -------------------------------------------------------------------------
    constant pixclk_freq                        : real    := 150.00e6;
    constant aclk_freq                          : real    := 150.00e6;
    constant mm2s_aclk                          : real    := 150.00e6;
    constant maxis_aclk                         : real    := 150.00e6;
    constant saxis_aclk                         : real    := 150.00e6;
    subtype rgb_u8bits is std_logic_vector (7 downto 0);
    subtype rgb_u24bits is std_logic_vector (23 downto 0);
    -------------------------------------------------------------------------
end package;