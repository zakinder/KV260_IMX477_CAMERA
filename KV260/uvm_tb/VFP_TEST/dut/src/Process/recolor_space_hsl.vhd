-------------------------------------------------------------------------------
--
-- Filename    : recolor_space_hsl.vhd
-- Create Date : 05062019 [05-06-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity recolor_space_hsl is
generic (
    img_width      : integer := 1920;
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end recolor_space_hsl;
architecture behavioral of recolor_space_hsl is
--------------------------- ---------------------------------------------------
  signal o1Rgb           : channel;
  signal o2Rgb           : channel;
  signal o3Rgb           : channel;
  signal o4Rgb           : channel;
-- 01 = +0.125    F1 = -0.125
-- 02 = +0.250    F2 = -0.250
-- 03 = +0.375    F3 = -0.375
-- 04 = +0.500    F4 = -0.500
-- 05 = +0.625    F5 = -0.625
-- 06 = +0.750    F6 = -0.750
-- 07 = +0.875    F7 = -0.875
-- 08 = +1.000    F8 = -1.000
-- 09 = +1.125    F9 = -1.125
-- 0A = +1.250    FA = -1.250
-- 0B = +1.375    FB = -1.375
-- 0C = +1.500    FC = -1.500
-- 0D = +1.625    FD = -1.625
-- 0E = +1.750    FE = -1.750
-- 0F = +1.875    FF = -1.875
  signal pixel_threshold          : sfixed(9 downto 0)  := to_sfixed(40.0,9,0);   -- Delta between pixels threshold value
  signal point_five               : sfixed(4 downto -3) := to_sfixed(0.250,4,-3); -- Average detected pixels by 1/4

  signal pixel_threshold_2        : sfixed(9 downto 0)  := to_sfixed(10.0,9,0);
  signal point_one_two_five       : sfixed(4 downto -3) := to_sfixed(0.250,4,-3);
  signal Rgb1                     : channel;
  signal Rgb2                     : channel;
  signal Rgb3                     : channel;
  signal Rgb6                     : channel;
  signal Rgb8                     : channel;
  signal Rgb11                    : channel;
  signal Rgb12                    : channel;
  signal Rgb13                    : channel;
  signal Rgb14                    : channel;
  signal Rgb15                    : channel;
  signal Rgb16                    : channel;
  signal Rgb17                    : channel;
  signal Rgb18                    : channel;
  signal Rgb21                    : channel;
  signal Rgb22                    : channel;
  signal Rgb23                    : channel;
  signal Rgb24                    : channel;
  signal Rgb25                    : channel;
  signal Rgb26                    : channel;
  signal Rgb27                    : channel;
  signal Rgb28                    : channel;
  signal cc                       : ccKernel;
  signal ccRgb                    : ccRgbRecord;
  signal cc1Rgb                   : ccRgbRecord;
  signal cc2Rgb                   : ccRgbRecord;
  signal threshold                : sfixed(9 downto 0)  := "0100000000";
---------------------------------------------------------------------------------
  signal tpd1                    : k_3by3;
  signal tpd2                    : k_3by3;
  signal tpd3                    : k_3by3;
  signal vTapRGB0x               : std_logic_vector(23 downto 0) := (others => '0');
  signal vTapRGB1x               : std_logic_vector(23 downto 0) := (others => '0');
  signal vTapRGB2x               : std_logic_vector(23 downto 0) := (others => '0');
  signal v1TapRGB0x              : std_logic_vector(23 downto 0) := (others => '0');
  signal v1TapRGB1x              : std_logic_vector(23 downto 0) := (others => '0');
  signal v1TapRGB2x              : std_logic_vector(23 downto 0) := (others => '0');
  signal enable                  : std_logic;
  signal rCountAddress           : integer;
  signal wCountAddress           : natural range 0 to 2;
  signal cCountAddress           : natural range 1 to 3 := 1;
  signal rAddress                : std_logic_vector(15 downto 0);
  signal rgb1x                   : channel;
  signal rgb2x                   : channel;
  signal d2RGB                   : std_logic_vector(23 downto 0) := (others => '0');
  signal d3RGB                   : std_logic_vector(23 downto 0) := (others => '0');
  signal kn_red                  : tyksn;
  signal kn_gre                  : tyksn;
  signal kn_blu                  : tyksn;
  signal rgbSyncValid            : std_logic_vector(36 downto 0)   := (others => '0');
---------------------------------------------------------------------------------
  signal red                     : rgb_delta;
  signal gre                     : rgb_delta;
  signal blu                     : rgb_delta;
  signal red_delta               : t12ksn;
  signal red_delta_1syn          : t12ksn;
  signal red_delta_2syn          : t12ksn;
  signal red_select              : rgb_sumprod;
  signal gre_select              : rgb_sumprod;
  signal blu_select              : rgb_sumprod;
---------------------------------------------------------------------------------
  signal red_line11              : type_line_array(0 to 2);
  signal red_line12              : type_line_array(0 to 2);
  signal red_line13              : type_line_array(0 to 2);
  signal red_line21              : type_line_array(0 to 2);
  signal red_line22              : type_line_array(0 to 2);
  signal red_line23              : type_line_array(0 to 2);
  signal red_line31              : type_line_array(0 to 2);
  signal red_line32              : type_line_array(0 to 2);
  signal red_line33              : type_line_array(0 to 2);
  signal red_line_n              : type_line_array(0 to 5);
  signal red_line0n              : type_line_array(0 to 2);
  signal red_line1n              : type_line_array(0 to 2);
  signal red_line2n              : type_line_array(0 to 2);
  signal red_line3n              : type_line_array(0 to 2);
  signal red_line4n              : type_line_array(0 to 2);
  signal red_line5n              : type_line_array(0 to 2);
  signal red_line6n              : type_line_array(0 to 2);
  signal red_line7n              : type_line_array(0 to 2);
  signal red_line8n              : type_line_array(0 to 2);
---------------------------------------------------------------------------------
  signal gre_line11              : type_line_array(0 to 2);
  signal gre_line12              : type_line_array(0 to 2);
  signal gre_line13              : type_line_array(0 to 2);
  signal gre_line21              : type_line_array(0 to 2);
  signal gre_line22              : type_line_array(0 to 2);
  signal gre_line23              : type_line_array(0 to 2);
  signal gre_line31              : type_line_array(0 to 2);
  signal gre_line32              : type_line_array(0 to 2);
  signal gre_line33              : type_line_array(0 to 2);
  signal gre_line_n              : type_line_array(0 to 2);
---------------------------------------------------------------------------------
  signal blu_line11              : type_line_array(0 to 2);
  signal blu_line12              : type_line_array(0 to 2);
  signal blu_line13              : type_line_array(0 to 2);
  signal blu_line21              : type_line_array(0 to 2);
  signal blu_line22              : type_line_array(0 to 2);
  signal blu_line23              : type_line_array(0 to 2);
  signal blu_line31              : type_line_array(0 to 2);
  signal blu_line32              : type_line_array(0 to 2);
  signal blu_line33              : type_line_array(0 to 2);
  signal blu_line_n              : type_line_array(0 to 2);
---------------------------------------------------------------------------------
  signal imgWidth                : integer   := 64;
  signal imgHight                : integer   := 64;
  signal pWrAdr                  : natural   := zero;
  signal pLine                   : std_logic :=lo;
  signal pSol                    : std_logic :=lo;
  signal pEol                    : std_logic :=lo;
  signal pSig                    : std_logic :=lo;
---------------------------------------------------------------------------------
  signal hsvColor                : hsvChannel;
  signal hsvSyncr                : channel;
  signal rgb_ool4                : channel;
  signal rgb_colo                : rgbToSfRecord;
  signal rgb_oolo                : rgbToSfRecord;
  signal rgb_ool1                : rgbToSfRecord;
  signal rgb_ool2                : rgbToSf12Record;
  signal rgb_ool3                : rgbToSfRecord;
---------------------------------------------------------------------------------
  signal iAls                    : coefficient;

begin 

  iAls.config       <= 1;
  iAls.k1           <= x"0000000F"; -- +1.875
  iAls.k2           <= x"000000FE"; -- -0.25
  iAls.k3           <= x"000000F3"; -- -0.375
  iAls.k4           <= x"000000F3"; -- -0.375
  iAls.k5           <= x"0000000F"; -- +1.875
  iAls.k6           <= x"000000FE"; -- -0.25
  iAls.k7           <= x"000000F3"; -- -0.375
  iAls.k8           <= x"000000FE"; -- -0.25
  iAls.k9           <= x"0000000F"; -- +1.875


--================================================================================================
--hsvInst: hsl_c
--generic map(
--    i_data_width       => i_data_width)
--port map(
--    clk                => clk,
--    reset              => reset,
--    iRgb               => iRgb,
--    oHsl               => hsvSyncr);
rgb_ool1_inst: sync_frames
generic map(
    pixelDelay => 7)
port map(
    clk        => clk,
    reset      => reset,
    iRgb       => iRgb,
    oRgb       => rgb_ool4);
process (clk) begin
    if rising_edge(clk) then
        rgb_colo.red    <= to_sfixed("00" & hsvSyncr.red,rgb_colo.red);
        rgb_colo.green  <= to_sfixed("00" & hsvSyncr.green,rgb_colo.green);
        rgb_colo.blue   <= to_sfixed("00" & hsvSyncr.blue,rgb_colo.blue);
        rgb_oolo.red    <= to_sfixed("00" & rgb_ool4.red,rgb_oolo.red);
        rgb_oolo.green  <= to_sfixed("00" & rgb_ool4.green,rgb_oolo.green);
        rgb_oolo.blue   <= to_sfixed("00" & rgb_ool4.blue,rgb_oolo.blue);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then

        rgb_ool2.red   <= abs(rgb_oolo.red - rgb_colo.red);
        rgb_ool2.green <= abs(rgb_oolo.green - rgb_colo.green);
        rgb_ool2.blue  <= abs(rgb_oolo.blue - rgb_colo.blue);

        rgb_ool3.red   <= resize(rgb_ool2.red,rgb_ool3.red);
        rgb_ool3.green <= resize(rgb_ool2.green,rgb_ool3.green);
        rgb_ool3.blue  <= resize(rgb_ool2.blue,rgb_ool3.blue);
    end if;
end process;

    -- rgb - hsl values
    o4Rgb.red    <= std_logic_vector(rgb_ool3.red(i_data_width-1 downto 0));
    o4Rgb.green  <= std_logic_vector(rgb_ool3.green(i_data_width-1 downto 0));
    o4Rgb.blue   <= std_logic_vector(rgb_ool3.blue(i_data_width-1 downto 0));
    o4Rgb.valid  <= rgb_ool4.valid;

l_cga_inst  : color_correction
generic map(
    i_k_config_number   => 0)
port map(
    clk            => clk,
    rst_l          => reset,
    iRgb           => o4Rgb,
    als            => iAls,
    oRgb           => o3Rgb);
sharp_f_valid_inst : d_valid
generic map (
    pixelDelay     => 0)
port map(
    clk            => clk,
    iRgb           => o3Rgb,
    oRgb           => Rgb6);
rgb5_syncr_inst  : sync_frames
generic map(
    pixelDelay     => 3)
port map(
    clk            => clk,
    reset          => reset,
    iRgb           => Rgb6,
    oRgb           => oRgb);

--================================================================================================
process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= enable;
        rgbSyncValid(1)  <= rgbSyncValid(0);
        rgbSyncValid(2)  <= rgbSyncValid(1);
        rgbSyncValid(3)  <= rgbSyncValid(2);
        rgbSyncValid(4)  <= rgbSyncValid(3);
        rgbSyncValid(5)  <= rgbSyncValid(4);
        rgbSyncValid(6)  <= rgbSyncValid(5);
        rgbSyncValid(7)  <= rgbSyncValid(6);
        rgbSyncValid(8)  <= rgbSyncValid(7);
        rgbSyncValid(9)  <= rgbSyncValid(8);
        rgbSyncValid(10) <= rgbSyncValid(9);
        rgbSyncValid(11) <= rgbSyncValid(10);
        rgbSyncValid(12) <= rgbSyncValid(11);
        rgbSyncValid(13) <= rgbSyncValid(12);
        rgbSyncValid(14) <= rgbSyncValid(13);
        rgbSyncValid(15) <= rgbSyncValid(14);
        rgbSyncValid(16) <= rgbSyncValid(15);
        rgbSyncValid(17) <= rgbSyncValid(16);
        rgbSyncValid(18) <= rgbSyncValid(17);
        rgbSyncValid(19) <= rgbSyncValid(18);
    end if;
end process;




-----------------------------------------------------------------------------------------------
-- STAGE 2
-----------------------------------------------------------------------------------------------
--01 = +0.125    F1 = -0.125
--02 = +0.250    F2 = -0.250
--03 = +0.375    F3 = -0.375
--04 = +0.500    F4 = -0.500
--05 = +0.625    F5 = -0.625
--06 = +0.750    F6 = -0.750
--07 = +0.875    F7 = -0.875
--08 = +1.000    F8 = -1.000
--09 = +1.125    F9 = -1.125
--0A = +1.250    FA = -1.250
--0B = +1.375    FB = -1.375
--0C = +1.500    FC = -1.500
--0D = +1.625    FD = -1.625
--0E = +1.750    FE = -1.750
--0F = +1.875    FF = -1.875
ccSfConfig_P: process (clk,reset)begin
    if reset = '0' then
        cc.ccSf.k1             <= x"0B";
        cc.ccSf.k2             <= x"FE";
        cc.ccSf.k3             <= x"FF";
        cc.ccSf.k4             <= x"FF";
        cc.ccSf.k5             <= x"0B";
        cc.ccSf.k6             <= x"FE";
        cc.ccSf.k7             <= x"FE";
        cc.ccSf.k8             <= x"FF";
        cc.ccSf.k9             <= x"0B";
    elsif rising_edge(clk) then
        cc.ccSf.k1             <= x"08";
        cc.ccSf.k2             <= x"08";
        cc.ccSf.k3             <= x"08";
        cc.ccSf.k4             <= x"08";
        cc.ccSf.k5             <= x"08";
        cc.ccSf.k6             <= x"08";
        cc.ccSf.k7             <= x"08";
        cc.ccSf.k8             <= x"08";
        cc.ccSf.k9             <= x"08";
    end if;
end process ccSfConfig_P;
ccProdSf_P: process (clk,reset)begin
    if rising_edge(clk) then
        cc.ccProdSf.k1         <= cc.ccSf.k1 * threshold * kn_red.k1;
        cc.ccProdSf.k2         <= cc.ccSf.k2 * threshold * kn_red.k2;
        cc.ccProdSf.k3         <= cc.ccSf.k3 * threshold * kn_red.k3;
        cc.ccProdSf.k4         <= cc.ccSf.k4 * threshold * kn_red.k4;
        cc.ccProdSf.k5         <= cc.ccSf.k5 * threshold * kn_red.k5;
        cc.ccProdSf.k6         <= cc.ccSf.k6 * threshold * kn_red.k6;
        cc.ccProdSf.k7         <= cc.ccSf.k7 * threshold * kn_red.k7;
        cc.ccProdSf.k8         <= cc.ccSf.k8 * threshold * kn_red.k8;
        cc.ccProdSf.k9         <= cc.ccSf.k9 * threshold * kn_red.k9;
    end if;
end process ccProdSf_P;
ccProdToSn_P: process (clk,reset)begin
    if rising_edge(clk) then
        cc.ccProdToSn.k1       <= to_signed(cc.ccProdSf.k1(19 downto 0), 20);
        cc.ccProdToSn.k2       <= to_signed(cc.ccProdSf.k2(19 downto 0), 20);
        cc.ccProdToSn.k3       <= to_signed(cc.ccProdSf.k3(19 downto 0), 20);
        cc.ccProdToSn.k4       <= to_signed(cc.ccProdSf.k4(19 downto 0), 20);
        cc.ccProdToSn.k5       <= to_signed(cc.ccProdSf.k5(19 downto 0), 20);
        cc.ccProdToSn.k6       <= to_signed(cc.ccProdSf.k6(19 downto 0), 20);
        cc.ccProdToSn.k7       <= to_signed(cc.ccProdSf.k7(19 downto 0), 20);
        cc.ccProdToSn.k8       <= to_signed(cc.ccProdSf.k8(19 downto 0), 20);
        cc.ccProdToSn.k9       <= to_signed(cc.ccProdSf.k9(19 downto 0), 20);
    end if;
end process ccProdToSn_P;
ccRgbSum_P: process (clk,reset)begin
    if reset = '0' then
      cc.ccProdTrSn.k1         <= (others => '0');
      cc.ccProdTrSn.k2         <= (others => '0');
      cc.ccProdTrSn.k3         <= (others => '0');
      cc.ccProdTrSn.k4         <= (others => '0');
      cc.ccProdTrSn.k5         <= (others => '0');
      cc.ccProdTrSn.k6         <= (others => '0');
      cc.ccProdTrSn.k7         <= (others => '0');
      cc.ccProdTrSn.k8         <= (others => '0');
      cc.ccProdTrSn.k9         <= (others => '0');
      ccRgb.rgbSnSum.red       <= (others => '0');
      ccRgb.rgbSnSum.green     <= (others => '0');
      ccRgb.rgbSnSum.blue      <= (others => '0');
      ccRgb.rgbSnSumTr.red     <= (others => '0');
      ccRgb.rgbSnSumTr.green   <= (others => '0');
      ccRgb.rgbSnSumTr.blue    <= (others => '0');
      cc1Rgb.rgbSnSum.red      <= (others => '0');
      cc1Rgb.rgbSnSum.green    <= (others => '0');
      cc1Rgb.rgbSnSum.blue     <= (others => '0');
      cc1Rgb.rgbSnSumTr.red    <= (others => '0');
      cc1Rgb.rgbSnSumTr.green  <= (others => '0');
      cc1Rgb.rgbSnSumTr.blue   <= (others => '0');
      cc2Rgb.rgbSnSum.red      <= (others => '0');
      cc2Rgb.rgbSnSum.green    <= (others => '0');
      cc2Rgb.rgbSnSum.blue     <= (others => '0');
      cc2Rgb.rgbSnSumTr.red    <= (others => '0');
      cc2Rgb.rgbSnSumTr.green  <= (others => '0');
      cc2Rgb.rgbSnSumTr.blue   <= (others => '0');
    elsif rising_edge(clk) then
      cc.ccProdTrSn.k1         <= cc.ccProdToSn.k1(19 downto 5);
      cc.ccProdTrSn.k2         <= cc.ccProdToSn.k2(19 downto 5);
      cc.ccProdTrSn.k3         <= cc.ccProdToSn.k3(19 downto 5);
      cc.ccProdTrSn.k4         <= cc.ccProdToSn.k4(19 downto 5);
      cc.ccProdTrSn.k5         <= cc.ccProdToSn.k5(19 downto 5);
      cc.ccProdTrSn.k6         <= cc.ccProdToSn.k6(19 downto 5);
      cc.ccProdTrSn.k7         <= cc.ccProdToSn.k7(19 downto 5);
      cc.ccProdTrSn.k8         <= cc.ccProdToSn.k8(19 downto 5);
      cc.ccProdTrSn.k9         <= cc.ccProdToSn.k9(19 downto 5);
      ccRgb.rgbSnSum.red       <= resize(cc.ccProdTrSn.k1, ADD_RESULT_WIDTH) + ROUND;
      ccRgb.rgbSnSum.green     <= resize(cc.ccProdTrSn.k4, ADD_RESULT_WIDTH) + ROUND;
      ccRgb.rgbSnSum.blue      <= resize(cc.ccProdTrSn.k7, ADD_RESULT_WIDTH) + ROUND; 
      cc1Rgb.rgbSnSum.red      <= resize(cc.ccProdTrSn.k2, ADD_RESULT_WIDTH) + ROUND;
      cc1Rgb.rgbSnSum.green    <= resize(cc.ccProdTrSn.k5, ADD_RESULT_WIDTH) + ROUND;
      cc1Rgb.rgbSnSum.blue     <= resize(cc.ccProdTrSn.k8, ADD_RESULT_WIDTH) + ROUND; 
      cc2Rgb.rgbSnSum.red      <= resize(cc.ccProdTrSn.k3, ADD_RESULT_WIDTH) + ROUND;
      cc2Rgb.rgbSnSum.green    <= resize(cc.ccProdTrSn.k6, ADD_RESULT_WIDTH) + ROUND;
      cc2Rgb.rgbSnSum.blue     <= resize(cc.ccProdTrSn.k9, ADD_RESULT_WIDTH) + ROUND; 
      ccRgb.rgbSnSumTr.red     <= ccRgb.rgbSnSum.red(ccRgb.rgbSnSum.red'left downto FRAC_BITS_TO_KEEP);
      ccRgb.rgbSnSumTr.green   <= ccRgb.rgbSnSum.green(ccRgb.rgbSnSum.green'left downto FRAC_BITS_TO_KEEP);
      ccRgb.rgbSnSumTr.blue    <= ccRgb.rgbSnSum.blue(ccRgb.rgbSnSum.blue'left downto FRAC_BITS_TO_KEEP);
      cc1Rgb.rgbSnSumTr.red    <= cc1Rgb.rgbSnSum.red(cc1Rgb.rgbSnSum.red'left downto FRAC_BITS_TO_KEEP);
      cc1Rgb.rgbSnSumTr.green  <= cc1Rgb.rgbSnSum.green(cc1Rgb.rgbSnSum.green'left downto FRAC_BITS_TO_KEEP);
      cc1Rgb.rgbSnSumTr.blue   <= cc1Rgb.rgbSnSum.blue(cc1Rgb.rgbSnSum.blue'left downto FRAC_BITS_TO_KEEP);
      cc2Rgb.rgbSnSumTr.red    <= cc2Rgb.rgbSnSum.red(cc2Rgb.rgbSnSum.red'left downto FRAC_BITS_TO_KEEP);
      cc2Rgb.rgbSnSumTr.green  <= cc2Rgb.rgbSnSum.green(cc2Rgb.rgbSnSum.green'left downto FRAC_BITS_TO_KEEP);
      cc2Rgb.rgbSnSumTr.blue   <= cc2Rgb.rgbSnSum.blue(cc2Rgb.rgbSnSum.blue'left downto FRAC_BITS_TO_KEEP);
    end if;
end process ccRgbSum_P;
cc1Rgb_P : process (clk, reset)
  begin
    if reset = '0' then
      Rgb1.red    <= (others => '0');
      Rgb1.green  <= (others => '0');
      Rgb1.blue   <= (others => '0');
    elsif clk'event and clk = '1' then
      if cc1Rgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-1) = '1' then
        Rgb1.red <= (others => '0');
      elsif unsigned(cc1Rgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        Rgb1.red <= (others => '1');
      else
        Rgb1.red <= std_logic_vector(cc1Rgb.rgbSnSumTr.red(i_data_width-1 downto 0));
      end if;
      if cc1Rgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-1) = '1' then
        Rgb1.green <= (others => '0');
      elsif unsigned(cc1Rgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        Rgb1.green <= (others => '1');
      else
        Rgb1.green <= std_logic_vector(cc1Rgb.rgbSnSumTr.green(i_data_width-1 downto 0));
      end if;
      if cc1Rgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-1) = '1' then
        Rgb1.blue <= (others => '0');
      elsif unsigned(cc1Rgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        Rgb1.blue <= (others => '1');
      else
        Rgb1.blue <= std_logic_vector(cc1Rgb.rgbSnSumTr.blue(i_data_width-1 downto 0));
      end if;
    end if;
end process cc1Rgb_P;
cc2Rgb_P : process (clk, reset)
  begin
    if reset = '0' then
      Rgb2.red    <= (others => '0');
      Rgb2.green  <= (others => '0');
      Rgb2.blue   <= (others => '0');
    elsif clk'event and clk = '1' then
      if cc2Rgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-1) = '1' then
        Rgb2.red <= (others => '0');
      elsif unsigned(cc2Rgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        Rgb2.red <= (others => '1');
      else
        Rgb2.red <= std_logic_vector(cc2Rgb.rgbSnSumTr.red(i_data_width-1 downto 0));
      end if;
      if cc2Rgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-1) = '1' then
        Rgb2.green <= (others => '0');
      elsif unsigned(cc2Rgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        Rgb2.green <= (others => '1');
      else
        Rgb2.green <= std_logic_vector(cc2Rgb.rgbSnSumTr.green(i_data_width-1 downto 0));
      end if;
      if cc2Rgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-1) = '1' then
        Rgb2.blue <= (others => '0');
      elsif unsigned(cc2Rgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        Rgb2.blue <= (others => '1');
      else
        Rgb2.blue <= std_logic_vector(cc2Rgb.rgbSnSumTr.blue(i_data_width-1 downto 0));
      end if;
    end if;
end process cc2Rgb_P;
--cc3Rgb_P : process (clk, reset)
--  begin
--    if reset = '0' then
--      Rgb3.red    <= (others => '0');
--      Rgb3.green  <= (others => '0');
--      --Rgb3.blue   <= (others => '0');
--    elsif clk'event and clk = '1' then
--      if ccRgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-1) = '1' then
--        Rgb3.red <= (others => '0');
--      elsif unsigned(ccRgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
--        Rgb3.red <= (others => '1');
--      else
--        Rgb3.red <= std_logic_vector(ccRgb.rgbSnSumTr.red(i_data_width-1 downto 0));
--      end if;
--      if ccRgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-1) = '1' then
--        Rgb3.green <= (others => '0');
--      elsif unsigned(ccRgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
--        Rgb3.green <= (others => '1');
--      else
--        Rgb3.green <= std_logic_vector(ccRgb.rgbSnSumTr.green(i_data_width-1 downto 0));
--      end if;
--      --if ccRgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-1) = '1' then
--      --  Rgb3.blue <= (others => '0');
--      --elsif unsigned(ccRgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
--      --  Rgb3.blue <= (others => '1');
--      --else
--      --  Rgb3.blue <= std_logic_vector(ccRgb.rgbSnSumTr.blue(i_data_width-1 downto 0));
--      --end if;
--    end if;
--end process cc3Rgb_P;
end behavioral;