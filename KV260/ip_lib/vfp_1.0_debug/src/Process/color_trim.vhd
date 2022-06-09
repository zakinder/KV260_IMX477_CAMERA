-------------------------------------------------------------------------------
--
-- Filename    : color_trim.vhd
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
entity color_trim is
generic (
    img_width      : integer := 1920;
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end color_trim;
architecture behavioral of color_trim is
--------------------------- ---------------------------------------------------
  signal o1Rgb           : channel;
  signal o2Rgb           : channel;
  signal o3Rgb           : channel;
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
    type ram_type is array (0 to 255) of natural;
    signal rowbuffer      : ram_type;
    signal io_data,io1data        : natural   := zero;
  signal iRgbValid        : std_logic_vector(7 downto 0)   := (others => '0');
begin 
process (clk) begin
if rising_edge(clk) then
    if (iRgb.valid = hi) then
        io_data   <= rowbuffer(to_integer(unsigned(iRgb.red)));
        iRgbValid <= iRgb.red;
        io1data   <= io_data;
        rowbuffer(to_integer(unsigned(iRgbValid))) <= io_data + 1;
    end if;
end if;
end process;
--================================================================================================
hsvInst: hsv_c
generic map(
    i_data_width       => i_data_width)
port map(
    clk                => clk,
    reset              => reset,
    iRgb               => iRgb,
    oHsv               => hsvSyncr);
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
        rgb_ool3.green <= resize(rgb_ool2.red,rgb_ool3.red);
        rgb_ool3.blue  <= resize(rgb_ool2.red,rgb_ool3.red);
    end if;
end process;
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
tapValidAdressP: process(clk)begin
    if rising_edge(clk) then
        if (iRgb.valid = '1') then
            rCountAddress  <= rCountAddress + 1;
        else
            rCountAddress  <= 0;
        end if;
    end if;
end process tapValidAdressP;
rAddress  <= std_logic_vector(to_unsigned(rCountAddress, 16));
RGBInst: buffer_controller
generic map(
    img_width       => img_width,
    adwrWidth       => 16,
    dataWidth       => 24,
    addrWidth       => 12)
port map(
    aclk            => clk,
    i_enable        => iRgb.valid,
    i_data          => d2RGB,
    i_wadd          => rAddress,
    i_radd          => rAddress,
    en_datao        => enable,
    taps0x          => v1TapRGB0x,
    taps1x          => v1TapRGB1x,
    taps2x          => v1TapRGB2x);
tapSignedP : process (clk) begin
    if rising_edge(clk) then
        rgb1x      <= iRgb;
        rgb2x      <= rgb1x;
        d2RGB      <= rgb2x.red & rgb2x.green & rgb2x.blue;
  end if;
end process tapSignedP;
pSol <= hi when (pLine = lo and iRgb.valid = hi) else lo;
pEol <= hi when (pLine = hi and iRgb.valid = lo and pSig = lo) else lo;
process(clk) begin
    if rising_edge(clk) then
        pLine <= iRgb.valid;
        if (pSol = hi) then
            pWrAdr  <= pWrAdr + one;
            if (pWrAdr = 2) then
                pWrAdr <= 2;
            end if;
        end if;
    end if;
end process;
process (clk,reset)begin
    if rising_edge(clk) then
        if(pWrAdr = zero) then
            d3RGB      <= d2RGB;
            vTapRGB0x  <= v1TapRGB0x;
            vTapRGB1x  <= v1TapRGB1x;
            vTapRGB2x  <= d2RGB;
        else
            d3RGB      <= d2RGB;
            vTapRGB0x  <= v1TapRGB0x;
            vTapRGB1x  <= v1TapRGB1x;
            vTapRGB2x  <= v1TapRGB2x;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if reset = '0' then
            tpd1.row_1    <= (others => '0');
            tpd1.row_2    <= (others => '0');
            tpd1.row_3    <= (others => '0');
            tpd2.row_1    <= (others => '0');
            tpd2.row_2    <= (others => '0');
            tpd2.row_3    <= (others => '0');
            tpd3.row_1    <= (others => '0');
            tpd3.row_2    <= (others => '0');
            tpd3.row_3    <= (others => '0');
        else
            tpd1.row_1    <= vTapRGB0x;
            tpd1.row_2    <= vTapRGB1x;
            tpd1.row_3    <= vTapRGB2x;
            tpd2.row_1    <= tpd1.row_1;
            tpd2.row_2    <= tpd1.row_2;
            tpd2.row_3    <= tpd1.row_3;
            tpd3.row_1    <= tpd2.row_1;
            tpd3.row_2    <= tpd2.row_2;
            tpd3.row_3    <= tpd2.row_3;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        kn_red.k1    <= to_sfixed("00" & tpd3.row_1(23 downto 16),kn_red.k1);
        kn_red.k2    <= to_sfixed("00" & tpd2.row_1(23 downto 16),kn_red.k2);
        kn_red.k3    <= to_sfixed("00" & tpd1.row_1(23 downto 16),kn_red.k3);
        kn_red.k4    <= to_sfixed("00" & tpd3.row_2(23 downto 16),kn_red.k4);
        kn_red.k5    <= to_sfixed("00" & tpd2.row_2(23 downto 16),kn_red.k5);
        kn_red.k6    <= to_sfixed("00" & tpd1.row_2(23 downto 16),kn_red.k6);
        kn_red.k7    <= to_sfixed("00" & tpd3.row_3(23 downto 16),kn_red.k7);
        kn_red.k8    <= to_sfixed("00" & tpd2.row_3(23 downto 16),kn_red.k8);
        kn_red.k9    <= to_sfixed("00" & tpd1.row_3(23 downto 16),kn_red.k9);
        kn_gre.k1    <= to_sfixed("00" & tpd3.row_1(15 downto 8),kn_gre.k1);
        kn_gre.k2    <= to_sfixed("00" & tpd2.row_1(15 downto 8),kn_gre.k2);
        kn_gre.k3    <= to_sfixed("00" & tpd1.row_1(15 downto 8),kn_gre.k3);
        kn_gre.k4    <= to_sfixed("00" & tpd3.row_2(15 downto 8),kn_gre.k4);
        kn_gre.k5    <= to_sfixed("00" & tpd2.row_2(15 downto 8),kn_gre.k5);
        kn_gre.k6    <= to_sfixed("00" & tpd1.row_2(15 downto 8),kn_gre.k6);
        kn_gre.k7    <= to_sfixed("00" & tpd3.row_3(15 downto 8),kn_gre.k7);
        kn_gre.k8    <= to_sfixed("00" & tpd2.row_3(15 downto 8),kn_gre.k8);
        kn_gre.k9    <= to_sfixed("00" & tpd1.row_3(15 downto 8),kn_gre.k9);
        kn_blu.k1    <= to_sfixed("00" & tpd3.row_1(7 downto 0),kn_blu.k1);
        kn_blu.k2    <= to_sfixed("00" & tpd2.row_1(7 downto 0),kn_blu.k2);
        kn_blu.k3    <= to_sfixed("00" & tpd1.row_1(7 downto 0),kn_blu.k3);
        kn_blu.k4    <= to_sfixed("00" & tpd3.row_2(7 downto 0),kn_blu.k4);
        kn_blu.k5    <= to_sfixed("00" & tpd2.row_2(7 downto 0),kn_blu.k5);
        kn_blu.k6    <= to_sfixed("00" & tpd1.row_2(7 downto 0),kn_blu.k6);
        kn_blu.k7    <= to_sfixed("00" & tpd3.row_3(7 downto 0),kn_blu.k7);
        kn_blu.k8    <= to_sfixed("00" & tpd2.row_3(7 downto 0),kn_blu.k8);
        kn_blu.k9    <= to_sfixed("00" & tpd1.row_3(7 downto 0),kn_blu.k9);
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 1
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        --P|11| P|12|
        ------------------------------------------------
        red_delta.k1      <= abs(kn_red.k1 - kn_red.k1);
        red_delta.k2      <= abs(kn_red.k1 - kn_red.k2);
        red_delta.k3      <= abs(kn_red.k1 - kn_red.k3);
        red_delta.k4      <= abs(kn_red.k1 - kn_red.k4);
        red_delta.k5      <= abs(kn_red.k1 - kn_red.k5);
        red_delta.k6      <= abs(kn_red.k1 - kn_red.k6);
        red_delta.k7      <= abs(kn_red.k1 - kn_red.k7);
        red_delta.k8      <= abs(kn_red.k1 - kn_red.k8);
        red_delta.k9      <= abs(kn_red.k1 - kn_red.k9);
        red.delta.k1      <= abs(kn_red.k1 - kn_red.k1);
        red.delta.k2      <= abs(kn_red.k1 - kn_red.k2);
        red.delta.k3      <= abs(kn_red.k1 - kn_red.k3);
        red.delta.k4      <= abs(kn_red.k1 - kn_red.k4);
        red.delta.k5      <= abs(kn_red.k1 - kn_red.k5);
        red.delta.k6      <= abs(kn_red.k1 - kn_red.k6);
        red.delta.k7      <= abs(kn_red.k1 - kn_red.k7);
        red.delta.k8      <= abs(kn_red.k1 - kn_red.k8);
        red.delta.k9      <= abs(kn_red.k1 - kn_red.k9);
        gre.delta.k1      <= abs(kn_gre.k1 - kn_gre.k1);
        gre.delta.k2      <= abs(kn_gre.k1 - kn_gre.k2);
        gre.delta.k3      <= abs(kn_gre.k1 - kn_gre.k3);
        gre.delta.k4      <= abs(kn_gre.k1 - kn_gre.k4);
        gre.delta.k5      <= abs(kn_gre.k1 - kn_gre.k5);
        gre.delta.k6      <= abs(kn_gre.k1 - kn_gre.k6);
        gre.delta.k7      <= abs(kn_gre.k1 - kn_gre.k7);
        gre.delta.k8      <= abs(kn_gre.k1 - kn_gre.k8);
        gre.delta.k9      <= abs(kn_gre.k1 - kn_gre.k9);
        blu.delta.k1      <= abs(kn_blu.k1 - kn_blu.k1);
        blu.delta.k2      <= abs(kn_blu.k1 - kn_blu.k2);
        blu.delta.k3      <= abs(kn_blu.k1 - kn_blu.k3);
        blu.delta.k4      <= abs(kn_blu.k1 - kn_blu.k4);
        blu.delta.k5      <= abs(kn_blu.k1 - kn_blu.k5);
        blu.delta.k6      <= abs(kn_blu.k1 - kn_blu.k6);
        blu.delta.k7      <= abs(kn_blu.k1 - kn_blu.k7);
        blu.delta.k8      <= abs(kn_blu.k1 - kn_blu.k8);
        blu.delta.k9      <= abs(kn_blu.k1 - kn_blu.k9);
        ------------------------------------------------
        red_delta_1syn    <= red_delta;
        red_delta_2syn    <= red_delta_1syn;
        red.delta_1syn    <= red.delta;
        red.delta_2syn    <= red.delta_1syn;
        gre.delta_1syn    <= gre.delta;
        gre.delta_2syn    <= gre.delta_1syn;
        blu.delta_1syn    <= blu.delta;
        blu.delta_2syn    <= blu.delta_1syn;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        red.delta_sum_0.k1            <= kn_red.k1 + kn_red.k1;
        red.delta_sum_0.k2            <= kn_red.k1 + kn_red.k2;
        red.delta_sum_0.k3            <= kn_red.k1 + kn_red.k3;
        red.delta_sum_0.k4            <= kn_red.k1 + kn_red.k4;
        red.delta_sum_0.k5            <= kn_red.k1 + kn_red.k5;
        red.delta_sum_0.k6            <= kn_red.k1 + kn_red.k6;
        red.delta_sum_0.k7            <= kn_red.k1 + kn_red.k7;
        red.delta_sum_0.k8            <= kn_red.k1 + kn_red.k8;
        red.delta_sum_0.k9            <= kn_red.k1 + kn_red.k9;
        red.delta_sum_prod_0.k1       <= red.delta_sum_0.k1 * point_five;
        red.delta_sum_prod_0.k1       <= red.delta_sum_0.k1 * point_five;
        red.delta_sum_prod_0.k2       <= red.delta_sum_0.k2 * point_five;
        red.delta_sum_prod_0.k3       <= red.delta_sum_0.k3 * point_five;
        red.delta_sum_prod_0.k4       <= red.delta_sum_0.k4 * point_five;
        red.delta_sum_prod_0.k5       <= red.delta_sum_0.k5 * point_five;
        red.delta_sum_prod_0.k6       <= red.delta_sum_0.k6 * point_five;
        red.delta_sum_prod_0.k7       <= red.delta_sum_0.k7 * point_five;
        red.delta_sum_prod_0.k8       <= red.delta_sum_0.k8 * point_five;
        red.delta_sum_prod_0.k9       <= red.delta_sum_0.k9 * point_five;
        red.delta_sum_1.k1            <= resize(kn_red.k1,red.delta_sum_1.k1);
        red.delta_sum_1.k2            <= resize(kn_red.k2,red.delta_sum_1.k2);
        red.delta_sum_1.k3            <= resize(kn_red.k3,red.delta_sum_1.k3);
        red.delta_sum_1.k4            <= resize(kn_red.k4,red.delta_sum_1.k4);
        red.delta_sum_1.k5            <= resize(kn_red.k5,red.delta_sum_1.k5);
        red.delta_sum_1.k6            <= resize(kn_red.k6,red.delta_sum_1.k6);
        red.delta_sum_1.k7            <= resize(kn_red.k7,red.delta_sum_1.k7);
        red.delta_sum_1.k8            <= resize(kn_red.k8,red.delta_sum_1.k8);
        red.delta_sum_1.k9            <= resize(kn_red.k9,red.delta_sum_1.k9);
        red.delta_sum_2               <= red.delta_sum_1;
        red.delta_sum_3               <= red.delta_sum_2;
        red.delta_sum_prod_1.k1       <= resize(red.delta_sum_prod_0.k1,red.delta_sum_prod_1.k1);
        red.delta_sum_prod_1.k2       <= resize(red.delta_sum_prod_0.k2,red.delta_sum_prod_1.k2);
        red.delta_sum_prod_1.k3       <= resize(red.delta_sum_prod_0.k3,red.delta_sum_prod_1.k3);
        red.delta_sum_prod_1.k4       <= resize(red.delta_sum_prod_0.k4,red.delta_sum_prod_1.k4);
        red.delta_sum_prod_1.k5       <= resize(red.delta_sum_prod_0.k5,red.delta_sum_prod_1.k5);
        red.delta_sum_prod_1.k6       <= resize(red.delta_sum_prod_0.k6,red.delta_sum_prod_1.k6);
        red.delta_sum_prod_1.k7       <= resize(red.delta_sum_prod_0.k7,red.delta_sum_prod_1.k7);
        red.delta_sum_prod_1.k8       <= resize(red.delta_sum_prod_0.k8,red.delta_sum_prod_1.k8);
        red.delta_sum_prod_1.k9       <= resize(red.delta_sum_prod_0.k9,red.delta_sum_prod_1.k9);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        gre.delta_sum_0.k1            <= kn_gre.k1 + kn_gre.k1;
        gre.delta_sum_0.k2            <= kn_gre.k1 + kn_gre.k2;
        gre.delta_sum_0.k3            <= kn_gre.k1 + kn_gre.k3;
        gre.delta_sum_0.k4            <= kn_gre.k1 + kn_gre.k4;
        gre.delta_sum_0.k5            <= kn_gre.k1 + kn_gre.k5;
        gre.delta_sum_0.k6            <= kn_gre.k1 + kn_gre.k6;
        gre.delta_sum_0.k7            <= kn_gre.k1 + kn_gre.k7;
        gre.delta_sum_0.k8            <= kn_gre.k1 + kn_gre.k8;
        gre.delta_sum_0.k9            <= kn_gre.k1 + kn_gre.k9;
        gre.delta_sum_prod_0.k1       <= gre.delta_sum_0.k1 * point_five;
        gre.delta_sum_prod_0.k1       <= gre.delta_sum_0.k1 * point_five;
        gre.delta_sum_prod_0.k2       <= gre.delta_sum_0.k2 * point_five;
        gre.delta_sum_prod_0.k3       <= gre.delta_sum_0.k3 * point_five;
        gre.delta_sum_prod_0.k4       <= gre.delta_sum_0.k4 * point_five;
        gre.delta_sum_prod_0.k5       <= gre.delta_sum_0.k5 * point_five;
        gre.delta_sum_prod_0.k6       <= gre.delta_sum_0.k6 * point_five;
        gre.delta_sum_prod_0.k7       <= gre.delta_sum_0.k7 * point_five;
        gre.delta_sum_prod_0.k8       <= gre.delta_sum_0.k8 * point_five;
        gre.delta_sum_prod_0.k9       <= gre.delta_sum_0.k9 * point_five;
        gre.delta_sum_1.k1            <= resize(kn_red.k1,gre.delta_sum_1.k1);
        gre.delta_sum_1.k2            <= resize(kn_red.k2,gre.delta_sum_1.k2);
        gre.delta_sum_1.k3            <= resize(kn_red.k3,gre.delta_sum_1.k3);
        gre.delta_sum_1.k4            <= resize(kn_red.k4,gre.delta_sum_1.k4);
        gre.delta_sum_1.k5            <= resize(kn_red.k5,gre.delta_sum_1.k5);
        gre.delta_sum_1.k6            <= resize(kn_red.k6,gre.delta_sum_1.k6);
        gre.delta_sum_1.k7            <= resize(kn_red.k7,gre.delta_sum_1.k7);
        gre.delta_sum_1.k8            <= resize(kn_red.k8,gre.delta_sum_1.k8);
        gre.delta_sum_1.k9            <= resize(kn_red.k9,gre.delta_sum_1.k9);
        gre.delta_sum_2               <= gre.delta_sum_1;
        gre.delta_sum_3               <= gre.delta_sum_2;
        gre.delta_sum_prod_1.k1       <= resize(gre.delta_sum_prod_0.k1,gre.delta_sum_prod_1.k1);
        gre.delta_sum_prod_1.k2       <= resize(gre.delta_sum_prod_0.k2,gre.delta_sum_prod_1.k2);
        gre.delta_sum_prod_1.k3       <= resize(gre.delta_sum_prod_0.k3,gre.delta_sum_prod_1.k3);
        gre.delta_sum_prod_1.k4       <= resize(gre.delta_sum_prod_0.k4,gre.delta_sum_prod_1.k4);
        gre.delta_sum_prod_1.k5       <= resize(gre.delta_sum_prod_0.k5,gre.delta_sum_prod_1.k5);
        gre.delta_sum_prod_1.k6       <= resize(gre.delta_sum_prod_0.k6,gre.delta_sum_prod_1.k6);
        gre.delta_sum_prod_1.k7       <= resize(gre.delta_sum_prod_0.k7,gre.delta_sum_prod_1.k7);
        gre.delta_sum_prod_1.k8       <= resize(gre.delta_sum_prod_0.k8,gre.delta_sum_prod_1.k8);
        gre.delta_sum_prod_1.k9       <= resize(gre.delta_sum_prod_0.k9,gre.delta_sum_prod_1.k9);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        blu.delta_sum_0.k1            <= kn_blu.k1 + kn_blu.k1;
        blu.delta_sum_0.k2            <= kn_blu.k1 + kn_blu.k2;
        blu.delta_sum_0.k3            <= kn_blu.k1 + kn_blu.k3;
        blu.delta_sum_0.k4            <= kn_blu.k1 + kn_blu.k4;
        blu.delta_sum_0.k5            <= kn_blu.k1 + kn_blu.k5;
        blu.delta_sum_0.k6            <= kn_blu.k1 + kn_blu.k6;
        blu.delta_sum_0.k7            <= kn_blu.k1 + kn_blu.k7;
        blu.delta_sum_0.k8            <= kn_blu.k1 + kn_blu.k8;
        blu.delta_sum_0.k9            <= kn_blu.k1 + kn_blu.k9;
        blu.delta_sum_prod_0.k1       <= blu.delta_sum_0.k1 * point_five;
        blu.delta_sum_prod_0.k2       <= blu.delta_sum_0.k2 * point_five;
        blu.delta_sum_prod_0.k3       <= blu.delta_sum_0.k3 * point_five;
        blu.delta_sum_prod_0.k4       <= blu.delta_sum_0.k4 * point_five;
        blu.delta_sum_prod_0.k5       <= blu.delta_sum_0.k5 * point_five;
        blu.delta_sum_prod_0.k6       <= blu.delta_sum_0.k6 * point_five;
        blu.delta_sum_prod_0.k7       <= blu.delta_sum_0.k7 * point_five;
        blu.delta_sum_prod_0.k8       <= blu.delta_sum_0.k8 * point_five;
        blu.delta_sum_prod_0.k9       <= blu.delta_sum_0.k9 * point_five;
        blu.delta_sum_1.k1            <= resize(kn_red.k1,blu.delta_sum_1.k1);
        blu.delta_sum_1.k2            <= resize(kn_red.k2,blu.delta_sum_1.k2);
        blu.delta_sum_1.k3            <= resize(kn_red.k3,blu.delta_sum_1.k3);
        blu.delta_sum_1.k4            <= resize(kn_red.k4,blu.delta_sum_1.k4);
        blu.delta_sum_1.k5            <= resize(kn_red.k5,blu.delta_sum_1.k5);
        blu.delta_sum_1.k6            <= resize(kn_red.k6,blu.delta_sum_1.k6);
        blu.delta_sum_1.k7            <= resize(kn_red.k7,blu.delta_sum_1.k7);
        blu.delta_sum_1.k8            <= resize(kn_red.k8,blu.delta_sum_1.k8);
        blu.delta_sum_1.k9            <= resize(kn_red.k9,blu.delta_sum_1.k9);
        blu.delta_sum_2               <= blu.delta_sum_1;
        blu.delta_sum_3               <= blu.delta_sum_2;
        blu.delta_sum_prod_1.k1       <= resize(blu.delta_sum_prod_0.k1,blu.delta_sum_prod_1.k1);
        blu.delta_sum_prod_1.k2       <= resize(blu.delta_sum_prod_0.k2,blu.delta_sum_prod_1.k2);
        blu.delta_sum_prod_1.k3       <= resize(blu.delta_sum_prod_0.k3,blu.delta_sum_prod_1.k3);
        blu.delta_sum_prod_1.k4       <= resize(blu.delta_sum_prod_0.k4,blu.delta_sum_prod_1.k4);
        blu.delta_sum_prod_1.k5       <= resize(blu.delta_sum_prod_0.k5,blu.delta_sum_prod_1.k5);
        blu.delta_sum_prod_1.k6       <= resize(blu.delta_sum_prod_0.k6,blu.delta_sum_prod_1.k6);
        blu.delta_sum_prod_1.k7       <= resize(blu.delta_sum_prod_0.k7,blu.delta_sum_prod_1.k7);
        blu.delta_sum_prod_1.k8       <= resize(blu.delta_sum_prod_0.k8,blu.delta_sum_prod_1.k8);
        blu.delta_sum_prod_1.k9       <= resize(blu.delta_sum_prod_0.k9,blu.delta_sum_prod_1.k9);
    end if;
end process;
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
       -- ∆P|xy| <- TH {set [Pn(xy)+Pn+1(xy)]}
        if(red_delta_2syn.k1 <= pixel_threshold_2) then
            red_select.sumprod_2.k1  <= red.delta_sum_prod_1.k1;
            red_select.k(1).n  <= 1;
        else
            red_select.k(1).n  <= 0;
            red_select.sumprod_2.k1       <= resize(red.delta_sum_3.k1,red_select.sumprod_2.k1);
        end if;
        if(red_delta_2syn.k2 <= pixel_threshold_2) then
            red_select.sumprod_2.k2  <= red.delta_sum_prod_1.k2;
            red_select.k(2).n  <= 2;
        else
            red_select.k(2).n  <= 0;
            red_select.sumprod_2.k2       <= resize(red.delta_sum_3.k2,red_select.sumprod_2.k2);
        end if;
        if(red_delta_2syn.k3 <= pixel_threshold_2) then
            red_select.sumprod_2.k3  <= red.delta_sum_prod_1.k3;
            red_select.k(3).n  <= 3;
        else
            red_select.k(3).n  <= 0;
            red_select.sumprod_2.k3       <= resize(red.delta_sum_3.k3,red_select.sumprod_2.k3);
        end if;
        if(red_delta_2syn.k4 <= pixel_threshold_2) then
            red_select.sumprod_2.k4  <= red.delta_sum_prod_1.k4;
            red_select.k(4).n  <= 4;
        else
            red_select.k(4).n  <= 0;
            red_select.sumprod_2.k4       <= resize(red.delta_sum_3.k4,red_select.sumprod_2.k4);
        end if;
        if(red_delta_2syn.k5 <= pixel_threshold_2) then
            red_select.sumprod_2.k5  <= red.delta_sum_prod_1.k5;
            red_select.k(5).n  <= 5;
        else
            red_select.k(5).n  <= 0;
            red_select.sumprod_2.k5       <= resize(red.delta_sum_3.k5,red_select.sumprod_2.k5);
        end if;
        if(red_delta_2syn.k6 <= pixel_threshold_2) then
            red_select.sumprod_2.k6  <= red.delta_sum_prod_1.k6;
            red_select.k(6).n  <= 6;
        else
            red_select.k(6).n  <= 0;
            red_select.sumprod_2.k6       <= resize(red.delta_sum_3.k6,red_select.sumprod_2.k6);
        end if;
        if(red_delta_2syn.k7 <= pixel_threshold_2) then
            red_select.sumprod_2.k7  <= red.delta_sum_prod_1.k7;
            red_select.k(7).n  <= 7;
        else
            red_select.k(7).n  <= 0;
            red_select.sumprod_2.k7       <= resize(red.delta_sum_3.k7,red_select.sumprod_2.k7);
        end if;
        if(red_delta_2syn.k8 <= pixel_threshold_2) then
            red_select.sumprod_2.k8  <= red.delta_sum_prod_1.k8;
            red_select.k(8).n  <= 8;
        else
            red_select.k(8).n  <= 0;
            red_select.sumprod_2.k8       <= resize(red.delta_sum_3.k8,red_select.sumprod_2.k8);
        end if;
        if(red_delta_2syn.k9 <= pixel_threshold_2) then
            red_select.sumprod_2.k9  <= red.delta_sum_prod_1.k9;
            red_select.k(9).n  <= 9;
        else
            red_select.k(9).n  <= 0;
            red_select.sumprod_2.k9       <= resize(red.delta_sum_3.k9,red_select.sumprod_2.k9);
        end if;
    end if;
end process;
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
            red_select.sumprod_2n   <=red_select.sumprod_2;
            red_select.sumprod_3n   <=red_select.sumprod_2n;
            red_select.sumprod_4n   <=red_select.sumprod_3n;
            red_select.sumprod_5n   <=red_select.sumprod_4n;
            red_select.sumprod_6n   <=red_select.sumprod_5n;
            red_select.sumprod_7n   <=red_select.sumprod_6n;
            red_select.sumprod_8n   <=red_select.sumprod_7n;
            red_select.sumprod_9n   <=red_select.sumprod_8n;
            red_select.sumprod_An   <=red_select.sumprod_9n;
            red_select.sumprod_Bn   <=red_select.sumprod_An;
            red_select.sumprod_Cn   <=red_select.sumprod_Cn;
            ------------------------------------------------------------
            red_select.add_12       <= red_select.sumprod_5n.k1 + red_select.sumprod_5n.k2;--  12
            red_select.add_s12      <= resize(red_select.add_12,red_select.add_s12);
            red_select.add_34       <= red_select.sumprod_5n.k3 + red_select.sumprod_5n.k4;--  34
            red_select.add_s34      <= resize(red_select.add_34,red_select.add_s34);
            red_select.add_56       <= red_select.sumprod_5n.k5 + red_select.sumprod_5n.k6;--  56
            red_select.add_s56      <= resize(red_select.add_56,red_select.add_s56);
            red_select.add_78       <= red_select.sumprod_5n.k7 + red_select.sumprod_5n.k8;--  78
            red_select.add_s78      <= resize(red_select.add_78,red_select.add_s78);
            ------------------------------------------------------------
            --==========================================================
            --12345678
            red_select.add_1234     <= red_select.add_s12 + red_select.add_s34;
            red_select.add_s1234    <= resize(red_select.add_1234,red_select.add_s1234);--===
            red_select.add_5678     <= red_select.add_s56 + red_select.add_s78;
            red_select.add_s5678    <= resize(red_select.add_5678,red_select.add_s5678);--===
            --==========================================================
            --__________________________________________________________
            red_select.add_1_to_8   <= red_select.add_s1234 + red_select.add_s5678;
            red_select.add_s1_to_8  <= resize(red_select.add_1_to_8,red_select.add_s1_to_8);
            red_select.add_1to8sp   <= red_select.add_s1_to_8 * point_one_two_five;
            red_select.sp1_to_8     <= resize(red_select.add_1to8sp,red_select.sp1_to_8);
            red_select.add_s9       <= red_select.sp1_to_8;
            --__________________________________________________________
            ------------------------------------------------------------
            red_select.add_45        <= red_select.sumprod_5n.k4 + red_select.sumprod_5n.k5;--  45
            red_select.add_s45       <= resize(red_select.add_45,red_select.add_s45);
            red_select.add_14        <= red_select.sumprod_5n.k1 + red_select.sumprod_5n.k4;--  14
            red_select.add_s14       <= resize(red_select.add_14,red_select.add_s14);
            red_select.add_17        <= red_select.sumprod_5n.k1 + red_select.sumprod_5n.k7;--  17
            red_select.add_s17       <= resize(red_select.add_17,red_select.add_s17);
            red_select.add_13        <= red_select.sumprod_5n.k1 + red_select.sumprod_5n.k3;--  13
            red_select.add_s13       <= resize(red_select.add_13,red_select.add_s13);
            red_select.add_15        <= red_select.sumprod_5n.k1 + red_select.sumprod_5n.k5;--  15
            red_select.add_s15       <= resize(red_select.add_15,red_select.add_s15);
            ------------------------------------------------------------
            --==========================================================
            --1245
            red_select.add_1245      <= red_select.add_s12 + red_select.add_s45;
            red_select.add_s1245     <= resize(red_select.add_1245,red_select.add_s1245);--==
            red_select.add_sp1245    <= red_select.add_s1245 * point_one_two_five;
            red_select.sp1245        <= resize(red_select.add_sp1245,red_select.sp1245);--===
            --==========================================================
            --==========================================================
            --125
            red_select.add_125        <= red_select.add_s12 + red_select.add_s15;
            red_select.add_s125       <= resize(red_select.add_125,red_select.add_s125);--===
            red_select.add_sp125      <= red_select.add_s125 * point_one_two_five;
            red_select.sp125          <= resize(red_select.add_sp125,red_select.sp125); --===
            --==========================================================
            --==========================================================
            --123
            red_select.add_123        <= red_select.add_s12 + red_select.add_s13;
            red_select.add_s123       <= resize(red_select.add_123,red_select.add_s123);--===
            red_select.add_sp123      <= red_select.add_s123 * point_one_two_five;
            red_select.sp123          <= resize(red_select.add_sp123,red_select.sp123); --===
            --==========================================================
            --==========================================================
            --124
            red_select.add_124        <= red_select.add_s12 + red_select.add_s14;
            red_select.add_s124       <= resize(red_select.add_124,red_select.add_s124);--===
            red_select.add_sp124      <= red_select.add_s124 * point_one_two_five;
            red_select.sp124          <= resize(red_select.add_sp124,red_select.sp124); --===
            --==========================================================
            --==========================================================
            -- 147
            red_select.add_147        <= red_select.add_s14 + red_select.add_s17;
            red_select.add_s147       <= resize(red_select.add_147,red_select.add_s147);--===
            red_select.add_sp147      <= red_select.add_s147 * point_one_two_five;
            red_select.sp147          <= resize(red_select.add_sp147,red_select.sp147); --===
            --==========================================================
            --==========================================================
            -- 145
            red_select.add_145        <= red_select.add_s14 + red_select.add_s15;
            red_select.add_s145       <= resize(red_select.add_145,red_select.add_s145);--===
            red_select.add_sp145      <= red_select.add_s145 * point_one_two_five;
            red_select.sp145          <= resize(red_select.add_sp145,red_select.sp145); --===
            --==========================================================
    end if;
end process;
--=================================================================================================
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
        if (red_select.k_syn_12(2).n=2 and red_select.k_syn_12(3).n=3 and red_select.k_syn_12(4).n=4 and red_select.k_syn_12(5).n=5 and red_select.k_syn_12(6).n=6 and red_select.k_syn_12(7).n=7 and red_select.k_syn_12(8).n=8 and red_select.k_syn_12(9).n=9) then
            -- 123456789
            red_select.result <= std_logic_vector(red_select.add_s9(i_data_width-1 downto 0));
        elsif (red_select.k_syn_12(2).n=2 and red_select.k_syn_12(4).n=4 and red_select.k_syn_12(5).n=5) then
            -- 1245
            red_select.result   <= std_logic_vector(red_select.sp1245(i_data_width-1 downto 0));
        elsif (red_select.k_syn_12(2).n=2 and red_select.k_syn_12(3).n=3) then
            -- 123
            red_select.result   <= std_logic_vector(red_select.sp123(i_data_width-1 downto 0));
        elsif (red_select.k_syn_12(2).n=2 and red_select.k_syn_12(4).n=4) then
            -- 124
            red_select.result   <= std_logic_vector(red_select.sp124(i_data_width-1 downto 0));
        elsif (red_select.k_syn_12(2).n=2 and red_select.k_syn_12(5).n=5) then
            -- 125
            red_select.result   <= std_logic_vector(red_select.sp125(i_data_width-1 downto 0));
        elsif (red_select.k_syn_12(4).n=4 and red_select.k_syn_12(5).n=5) then
            -- 145
            red_select.result   <= std_logic_vector(red_select.sp145(i_data_width-1 downto 0));
        elsif (red_select.k_syn_12(4).n=4 and red_select.k_syn_12(7).n=7) then
            -- 147
            red_select.result   <= std_logic_vector(red_select.sp147(i_data_width-1 downto 0));
        else
            red_select.result <= std_logic_vector(red_select.sumprod_Bn.k1(i_data_width-1 downto 0));
        end if;
    end if;
end process;
--=================================================================================================
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
       -- ∆P|xy| <- TH {set [Pn(xy)+Pn+1(xy)]}
        if(gre.delta_2syn.k1 <= pixel_threshold_2) then
            gre_select.sumprod_2.k1  <= gre.delta_sum_prod_1.k1;
            gre_select.k(1).n  <= 1;
        else
            gre_select.k(1).n  <= 0;
            gre_select.sumprod_2.k1  <= resize(gre.delta_sum_3.k1,gre_select.sumprod_2.k1);
        end if;
        if(gre.delta_2syn.k2 <= pixel_threshold_2) then
            gre_select.sumprod_2.k2  <= gre.delta_sum_prod_1.k2;
            gre_select.k(2).n  <= 2;
        else
            gre_select.k(2).n  <= 0;
            gre_select.sumprod_2.k2 <= resize(gre.delta_sum_3.k2,gre_select.sumprod_2.k2);
        end if;
        if(gre.delta_2syn.k3 <= pixel_threshold_2) then
            gre_select.sumprod_2.k3  <= gre.delta_sum_prod_1.k3;
            gre_select.k(3).n  <= 3;
        else
            gre_select.k(3).n  <= 0;
            gre_select.sumprod_2.k3 <= resize(gre.delta_sum_3.k3,gre_select.sumprod_2.k3);
        end if;
        if(gre.delta_2syn.k4 <= pixel_threshold_2) then
            gre_select.sumprod_2.k4  <= gre.delta_sum_prod_1.k4;
            gre_select.k(4).n  <= 4;
        else
            gre_select.k(4).n  <= 0;
            gre_select.sumprod_2.k4 <= resize(gre.delta_sum_3.k4,gre_select.sumprod_2.k4);
        end if;
        if(gre.delta_2syn.k5 <= pixel_threshold_2) then
            gre_select.sumprod_2.k5  <= gre.delta_sum_prod_1.k5;
            gre_select.k(5).n  <= 5;
        else
            gre_select.k(5).n  <= 0;
            gre_select.sumprod_2.k5 <= resize(gre.delta_sum_3.k5,gre_select.sumprod_2.k5);
        end if;
        if(gre.delta_2syn.k6    <= pixel_threshold_2) then
            gre_select.sumprod_2.k6   <= gre.delta_sum_prod_1.k6;
            gre_select.k(6).n  <= 6;
        else
            gre_select.k(6).n  <= 0;
            gre_select.sumprod_2.k6   <= resize(gre.delta_sum_3.k6,gre_select.sumprod_2.k6);
        end if;
        if(gre.delta_2syn.k7    <= pixel_threshold_2) then
            gre_select.sumprod_2.k7   <= gre.delta_sum_prod_1.k7;
            gre_select.k(7).n  <= 7;
        else
            gre_select.k(7).n  <= 0;
            gre_select.sumprod_2.k7   <= resize(gre.delta_sum_3.k7,gre_select.sumprod_2.k7);
        end if;
        if(gre.delta_2syn.k8 <= pixel_threshold_2) then
            gre_select.sumprod_2.k8  <= gre.delta_sum_prod_1.k8;
            gre_select.k(8).n  <= 8;
        else
            gre_select.k(8).n  <= 0;
            gre_select.sumprod_2.k8       <= resize(gre.delta_sum_3.k8,gre_select.sumprod_2.k8);
        end if;
        if(gre.delta_2syn.k9 <= pixel_threshold_2) then
            gre_select.sumprod_2.k9  <= gre.delta_sum_prod_1.k9;
            gre_select.k(9).n  <= 9;
        else
            gre_select.k(9).n  <= 0;
            gre_select.sumprod_2.k9       <= resize(gre.delta_sum_3.k9,gre_select.sumprod_2.k9);
        end if;
    end if;
end process;
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
            gre_select.sumprod_2n <=gre_select.sumprod_2;
            gre_select.sumprod_3n <=gre_select.sumprod_2n;
            gre_select.sumprod_4n <=gre_select.sumprod_3n;
            gre_select.sumprod_5n <=gre_select.sumprod_4n;
            gre_select.sumprod_6n <=gre_select.sumprod_5n;
            gre_select.sumprod_7n <=gre_select.sumprod_6n;
            gre_select.sumprod_8n <=gre_select.sumprod_7n;
            gre_select.sumprod_9n <=gre_select.sumprod_8n;
            gre_select.sumprod_An <=gre_select.sumprod_9n;
            gre_select.sumprod_Bn <=gre_select.sumprod_An;
            gre_select.sumprod_Cn <=gre_select.sumprod_Cn;
            ------------------------------------------------------------
            gre_select.add_12       <= gre_select.sumprod_5n.k1 + gre_select.sumprod_5n.k2;--  12
            gre_select.add_s12      <= resize(gre_select.add_12,gre_select.add_s12);
            gre_select.add_34       <= gre_select.sumprod_5n.k3 + gre_select.sumprod_5n.k4;--  34
            gre_select.add_s34      <= resize(gre_select.add_34,gre_select.add_s34);
            gre_select.add_56       <= gre_select.sumprod_5n.k5 + gre_select.sumprod_5n.k6;--  56
            gre_select.add_s56      <= resize(gre_select.add_56,gre_select.add_s56);
            gre_select.add_78       <= gre_select.sumprod_5n.k7 + gre_select.sumprod_5n.k8;--  78
            gre_select.add_s78      <= resize(gre_select.add_78,gre_select.add_s78);
            ------------------------------------------------------------
            --==========================================================
            --12345678
            gre_select.add_1234     <= gre_select.add_s12 + gre_select.add_s34;
            gre_select.add_s1234    <= resize(gre_select.add_1234,gre_select.add_s1234);--===
            gre_select.add_5678     <= gre_select.add_s56 + gre_select.add_s78;
            gre_select.add_s5678    <= resize(gre_select.add_5678,gre_select.add_s5678);--===
            --==========================================================
            --__________________________________________________________
            gre_select.add_1_to_8   <= gre_select.add_s1234 + gre_select.add_s5678;
            gre_select.add_s1_to_8  <= resize(gre_select.add_1_to_8,gre_select.add_s1_to_8);
            gre_select.add_1to8sp   <= gre_select.add_s1_to_8 * point_one_two_five;
            gre_select.sp1_to_8     <= resize(gre_select.add_1to8sp,gre_select.sp1_to_8);
            gre_select.add_s9       <= gre_select.sp1_to_8;
            --__________________________________________________________
            ------------------------------------------------------------
            gre_select.add_45        <= gre_select.sumprod_5n.k4 + gre_select.sumprod_5n.k5;--  45
            gre_select.add_s45       <= resize(gre_select.add_45,gre_select.add_s45);
            gre_select.add_14        <= gre_select.sumprod_5n.k1 + gre_select.sumprod_5n.k4;--  14
            gre_select.add_s14       <= resize(gre_select.add_14,gre_select.add_s14);
            gre_select.add_17        <= gre_select.sumprod_5n.k1 + gre_select.sumprod_5n.k7;--  17
            gre_select.add_s17       <= resize(gre_select.add_17,gre_select.add_s17);
            gre_select.add_13        <= gre_select.sumprod_5n.k1 + gre_select.sumprod_5n.k3;--  13
            gre_select.add_s13       <= resize(gre_select.add_13,gre_select.add_s13);
            gre_select.add_15        <= gre_select.sumprod_5n.k1 + gre_select.sumprod_5n.k5;--  15
            gre_select.add_s15       <= resize(gre_select.add_15,gre_select.add_s15);
            ------------------------------------------------------------
            --==========================================================
            --1245
            gre_select.add_1245      <= gre_select.add_s12 + gre_select.add_s45;
            gre_select.add_s1245     <= resize(gre_select.add_1245,gre_select.add_s1245);--==
            gre_select.add_sp1245    <= gre_select.add_s1245 * point_one_two_five;
            gre_select.sp1245        <= resize(gre_select.add_sp1245,gre_select.sp1245);--===
            --==========================================================
            --==========================================================
            --125
            gre_select.add_125        <= gre_select.add_s12 + gre_select.add_s15;
            gre_select.add_s125       <= resize(gre_select.add_125,gre_select.add_s125);--===
            gre_select.add_sp125      <= gre_select.add_s125 * point_one_two_five;
            gre_select.sp125          <= resize(gre_select.add_sp125,gre_select.sp125); --===
            --==========================================================
            --==========================================================
            --123
            gre_select.add_123        <= gre_select.add_s12 + gre_select.add_s13;
            gre_select.add_s123       <= resize(gre_select.add_123,gre_select.add_s123);--===
            gre_select.add_sp123      <= gre_select.add_s123 * point_one_two_five;
            gre_select.sp123          <= resize(gre_select.add_sp123,gre_select.sp123); --===
            --==========================================================
            --==========================================================
            --124
            gre_select.add_124        <= gre_select.add_s12 + gre_select.add_s14;
            gre_select.add_s124       <= resize(gre_select.add_124,gre_select.add_s124);--===
            gre_select.add_sp124      <= gre_select.add_s124 * point_one_two_five;
            gre_select.sp124          <= resize(gre_select.add_sp124,gre_select.sp124); --===
            --==========================================================
            --==========================================================
            -- 147
            gre_select.add_147        <= gre_select.add_s14 + gre_select.add_s17;
            gre_select.add_s147       <= resize(gre_select.add_147,gre_select.add_s147);--===
            gre_select.add_sp147      <= gre_select.add_s147 * point_one_two_five;
            gre_select.sp147          <= resize(gre_select.add_sp147,gre_select.sp147); --===
            --==========================================================
            --==========================================================
            -- 145
            gre_select.add_145        <= gre_select.add_s14 + gre_select.add_s15;
            gre_select.add_s145       <= resize(gre_select.add_145,gre_select.add_s145);--===
            gre_select.add_sp145      <= gre_select.add_s145 * point_one_two_five;
            gre_select.sp145          <= resize(gre_select.add_sp145,gre_select.sp145); --===
            --==========================================================
    end if;
end process;
--=================================================================================================
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
        if (gre_select.k_syn_12(2).n=2 and gre_select.k_syn_12(3).n=3 and gre_select.k_syn_12(4).n=4 and gre_select.k_syn_12(5).n=5 and gre_select.k_syn_12(6).n=6 and gre_select.k_syn_12(7).n=7 and gre_select.k_syn_12(8).n=8 and gre_select.k_syn_12(9).n=9) then
            gre_select.result <= std_logic_vector(gre_select.add_s9(i_data_width-1 downto 0));
        elsif (gre_select.k_syn_12(2).n=2 and gre_select.k_syn_12(4).n=4 and gre_select.k_syn_12(5).n=5) then
            gre_select.result   <= std_logic_vector(gre_select.sp1245(i_data_width-1 downto 0));
        elsif (gre_select.k_syn_12(2).n=2 and gre_select.k_syn_12(3).n=3) then
            gre_select.result   <= std_logic_vector(gre_select.sp123(i_data_width-1 downto 0));
        elsif (gre_select.k_syn_12(2).n=2 and gre_select.k_syn_12(4).n=4) then
            gre_select.result   <= std_logic_vector(gre_select.sp124(i_data_width-1 downto 0));
        elsif (gre_select.k_syn_12(2).n=2 and gre_select.k_syn_12(5).n=5) then
            gre_select.result   <= std_logic_vector(gre_select.sp125(i_data_width-1 downto 0));
        elsif (gre_select.k_syn_12(4).n=4 and gre_select.k_syn_12(5).n=5) then
            gre_select.result   <= std_logic_vector(gre_select.sp145(i_data_width-1 downto 0));
        elsif (gre_select.k_syn_12(4).n=4 and gre_select.k_syn_12(7).n=7) then
            gre_select.result   <= std_logic_vector(gre_select.sp147(i_data_width-1 downto 0));
        else
            gre_select.result <= std_logic_vector(gre_select.sumprod_Bn.k1(i_data_width-1 downto 0));
        end if;
    end if;
end process;
--=================================================================================================
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
       -- ∆P|xy| <- TH {set [Pn(xy)+Pn+1(xy)]}
        if(blu.delta_2syn.k1 <= pixel_threshold_2) then
            blu_select.sumprod_2.k1       <= blu.delta_sum_prod_1.k1;
            blu_select.k(1).n  <= 1;
        else
            blu_select.k(1).n  <= 0;
            blu_select.sumprod_2.k1       <= resize(blu.delta_sum_3.k1,blu_select.sumprod_2.k1);
        end if;
        if(blu.delta_2syn.k2 <= pixel_threshold_2) then
            blu_select.sumprod_2.k2       <= blu.delta_sum_prod_1.k2;
            blu_select.k(2).n  <= 2;
        else
            blu_select.k(2).n  <= 0;
            blu_select.sumprod_2.k2       <= resize(blu.delta_sum_3.k2,blu_select.sumprod_2.k2);
        end if;
        if(blu.delta_2syn.k3 <= pixel_threshold_2) then
            blu_select.sumprod_2.k3       <= blu.delta_sum_prod_1.k3;
            blu_select.k(3).n  <= 3;
        else
            blu_select.k(3).n  <= 0;
            blu_select.sumprod_2.k3       <= resize(blu.delta_sum_3.k3,blu_select.sumprod_2.k3);
        end if;
        if(blu.delta_2syn.k4 <= pixel_threshold_2) then
            blu_select.sumprod_2.k4       <= blu.delta_sum_prod_1.k4;
            blu_select.k(4).n  <= 4;
        else
            blu_select.k(4).n  <= 0;
            blu_select.sumprod_2.k4       <= resize(blu.delta_sum_3.k4,blu_select.sumprod_2.k4);
        end if;
        if(blu.delta_2syn.k5 <= pixel_threshold_2) then
            blu_select.sumprod_2.k5       <= blu.delta_sum_prod_1.k5;
            blu_select.k(5).n  <= 5;
        else
            blu_select.k(5).n  <= 0;
            blu_select.sumprod_2.k5       <= resize(blu.delta_sum_3.k5,blu_select.sumprod_2.k5);
        end if;
        if(blu.delta_2syn.k6 <= pixel_threshold_2) then
            blu_select.sumprod_2.k6       <= blu.delta_sum_prod_1.k6;
            blu_select.k(6).n  <= 6;
        else
            blu_select.k(6).n  <= 0;
            blu_select.sumprod_2.k6       <= resize(blu.delta_sum_3.k6,blu_select.sumprod_2.k6);
        end if;
        if(blu.delta_2syn.k7        <= pixel_threshold_2) then
            blu_select.sumprod_2.k7       <= blu.delta_sum_prod_1.k7;
            blu_select.k(7).n  <= 7;
        else
            blu_select.k(7).n  <= 0;
            blu_select.sumprod_2.k7       <= resize(blu.delta_sum_3.k7,blu_select.sumprod_2.k7);
        end if;
        if(blu.delta_2syn.k8        <= pixel_threshold_2) then
            blu_select.sumprod_2.k8       <= blu.delta_sum_prod_1.k8;
            blu_select.k(8).n  <= 8;
        else
            blu_select.k(8).n  <= 0;
            blu_select.sumprod_2.k8       <= resize(blu.delta_sum_3.k8,blu_select.sumprod_2.k8);
        end if;
        if(blu.delta_2syn.k9        <= pixel_threshold_2) then
            blu_select.sumprod_2.k9       <= blu.delta_sum_prod_1.k9;
            blu_select.k(9).n  <= 9;
        else
            blu_select.k(9).n  <= 0;
            blu_select.sumprod_2.k9       <= resize(blu.delta_sum_3.k9,blu_select.sumprod_2.k9);
        end if;
    end if;
end process;
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
            blu_select.sumprod_2n <=blu_select.sumprod_2;
            blu_select.sumprod_3n <=blu_select.sumprod_2n;
            blu_select.sumprod_4n <=blu_select.sumprod_3n;
            blu_select.sumprod_5n <=blu_select.sumprod_4n;
            blu_select.sumprod_6n <=blu_select.sumprod_5n;
            blu_select.sumprod_7n <=blu_select.sumprod_6n;
            blu_select.sumprod_8n <=blu_select.sumprod_7n;
            blu_select.sumprod_9n <=blu_select.sumprod_8n;
            blu_select.sumprod_An <=blu_select.sumprod_9n;
            blu_select.sumprod_Bn <=blu_select.sumprod_An;
            blu_select.sumprod_Cn <=blu_select.sumprod_Cn;
            ------------------------------------------------------------
            blu_select.add_12       <= blu_select.sumprod_5n.k1 + blu_select.sumprod_5n.k2;--  12
            blu_select.add_s12      <= resize(blu_select.add_12,blu_select.add_s12);
            blu_select.add_34       <= blu_select.sumprod_5n.k3 + blu_select.sumprod_5n.k4;--  34
            blu_select.add_s34      <= resize(blu_select.add_34,blu_select.add_s34);
            blu_select.add_56       <= blu_select.sumprod_5n.k5 + blu_select.sumprod_5n.k6;--  56
            blu_select.add_s56      <= resize(blu_select.add_56,blu_select.add_s56);
            blu_select.add_78       <= blu_select.sumprod_5n.k7 + blu_select.sumprod_5n.k8;--  78
            blu_select.add_s78      <= resize(blu_select.add_78,blu_select.add_s78);
            ------------------------------------------------------------
            --==========================================================
            --12345678
            blu_select.add_1234     <= blu_select.add_s12 + blu_select.add_s34;
            blu_select.add_s1234    <= resize(blu_select.add_1234,blu_select.add_s1234);--===
            blu_select.add_5678     <= blu_select.add_s56 + blu_select.add_s78;
            blu_select.add_s5678    <= resize(blu_select.add_5678,blu_select.add_s5678);--===
            --==========================================================
            --__________________________________________________________
            blu_select.add_1_to_8   <= blu_select.add_s1234 + blu_select.add_s5678;
            blu_select.add_s1_to_8  <= resize(blu_select.add_1_to_8,blu_select.add_s1_to_8);
            blu_select.add_1to8sp   <= blu_select.add_s1_to_8 * point_one_two_five;
            blu_select.sp1_to_8     <= resize(blu_select.add_1to8sp,blu_select.sp1_to_8);
            blu_select.add_s9       <= blu_select.sp1_to_8;
            --__________________________________________________________
            ------------------------------------------------------------
            blu_select.add_45        <= blu_select.sumprod_5n.k4 + blu_select.sumprod_5n.k5;--  45
            blu_select.add_s45       <= resize(blu_select.add_45,blu_select.add_s45);
            blu_select.add_14        <= blu_select.sumprod_5n.k1 + blu_select.sumprod_5n.k4;--  14
            blu_select.add_s14       <= resize(blu_select.add_14,blu_select.add_s14);
            blu_select.add_17        <= blu_select.sumprod_5n.k1 + blu_select.sumprod_5n.k7;--  17
            blu_select.add_s17       <= resize(blu_select.add_17,blu_select.add_s17);
            blu_select.add_13        <= blu_select.sumprod_5n.k1 + blu_select.sumprod_5n.k3;--  13
            blu_select.add_s13       <= resize(blu_select.add_13,blu_select.add_s13);
            blu_select.add_15        <= blu_select.sumprod_5n.k1 + blu_select.sumprod_5n.k5;--  15
            blu_select.add_s15       <= resize(blu_select.add_15,blu_select.add_s15);
            ------------------------------------------------------------
            --==========================================================
            --1245
            blu_select.add_1245      <= blu_select.add_s12 + blu_select.add_s45;
            blu_select.add_s1245     <= resize(blu_select.add_1245,blu_select.add_s1245);--==
            blu_select.add_sp1245    <= blu_select.add_s1245 * point_one_two_five;
            blu_select.sp1245        <= resize(blu_select.add_sp1245,blu_select.sp1245);--===
            --==========================================================
            --==========================================================
            --125
            blu_select.add_125        <= blu_select.add_s12 + blu_select.add_s15;
            blu_select.add_s125       <= resize(blu_select.add_125,blu_select.add_s125);--===
            blu_select.add_sp125      <= blu_select.add_s125 * point_one_two_five;
            blu_select.sp125          <= resize(blu_select.add_sp125,blu_select.sp125); --===
            --==========================================================
            --==========================================================
            --123
            blu_select.add_123        <= blu_select.add_s12 + blu_select.add_s13;
            blu_select.add_s123       <= resize(blu_select.add_123,blu_select.add_s123);--===
            blu_select.add_sp123      <= blu_select.add_s123 * point_one_two_five;
            blu_select.sp123          <= resize(blu_select.add_sp123,blu_select.sp123); --===
            --==========================================================
            --==========================================================
            --124
            blu_select.add_124        <= blu_select.add_s12 + blu_select.add_s14;
            blu_select.add_s124       <= resize(blu_select.add_124,blu_select.add_s124);--===
            blu_select.add_sp124      <= blu_select.add_s124 * point_one_two_five;
            blu_select.sp124          <= resize(blu_select.add_sp124,blu_select.sp124); --===
            --==========================================================
            --==========================================================
            -- 147
            blu_select.add_147        <= blu_select.add_s14 + blu_select.add_s17;
            blu_select.add_s147       <= resize(blu_select.add_147,blu_select.add_s147);--===
            blu_select.add_sp147      <= blu_select.add_s147 * point_one_two_five;
            blu_select.sp147          <= resize(blu_select.add_sp147,blu_select.sp147); --===
            --==========================================================
            --==========================================================
            -- 145
            blu_select.add_145        <= blu_select.add_s14 + blu_select.add_s15;
            blu_select.add_s145       <= resize(blu_select.add_145,blu_select.add_s145);--===
            blu_select.add_sp145      <= blu_select.add_s145 * point_one_two_five;
            blu_select.sp145          <= resize(blu_select.add_sp145,blu_select.sp145); --===
            --==========================================================
    end if;
end process;
--=================================================================================================
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
        if (blu_select.k_syn_12(2).n=2 and blu_select.k_syn_12(3).n=3 and blu_select.k_syn_12(4).n=4 and blu_select.k_syn_12(5).n=5 and blu_select.k_syn_12(6).n=6 and blu_select.k_syn_12(7).n=7 and blu_select.k_syn_12(8).n=8 and blu_select.k_syn_12(9).n=9) then
            blu_select.result <= std_logic_vector(blu_select.add_s9(i_data_width-1 downto 0));
        elsif (blu_select.k_syn_12(2).n=2 and blu_select.k_syn_12(4).n=4 and blu_select.k_syn_12(5).n=5) then
            blu_select.result   <= std_logic_vector(blu_select.sp1245(i_data_width-1 downto 0));
        elsif (blu_select.k_syn_12(2).n=2 and blu_select.k_syn_12(3).n=3) then
            blu_select.result   <= std_logic_vector(blu_select.sp123(i_data_width-1 downto 0));
        elsif (blu_select.k_syn_12(2).n=2 and blu_select.k_syn_12(4).n=4) then
            blu_select.result   <= std_logic_vector(blu_select.sp124(i_data_width-1 downto 0));
        elsif (blu_select.k_syn_12(2).n=2 and blu_select.k_syn_12(5).n=5) then
            blu_select.result   <= std_logic_vector(blu_select.sp125(i_data_width-1 downto 0));
        elsif (blu_select.k_syn_12(4).n=4 and blu_select.k_syn_12(5).n=5) then
            blu_select.result   <= std_logic_vector(blu_select.sp145(i_data_width-1 downto 0));
        elsif (blu_select.k_syn_12(4).n=4 and blu_select.k_syn_12(7).n=7) then
            blu_select.result   <= std_logic_vector(blu_select.sp147(i_data_width-1 downto 0));
        else
            blu_select.result <= std_logic_vector(blu_select.sumprod_Bn.k1(i_data_width-1 downto 0));
        end if;
    end if;
end process;
--=================================================================================================
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
        red_select.k_syn_1  <= red_select.k;
        red_select.k_syn_2  <= red_select.k_syn_1;
        red_select.k_syn_3  <= red_select.k_syn_2;
        red_select.k_syn_4  <= red_select.k_syn_3;
        red_select.k_syn_5  <= red_select.k_syn_4;
        red_select.k_syn_6  <= red_select.k_syn_5;
        red_select.k_syn_7  <= red_select.k_syn_6;
        red_select.k_syn_8  <= red_select.k_syn_7;
        red_select.k_syn_9  <= red_select.k_syn_8;
        red_select.k_syn_10 <= red_select.k_syn_9;
        red_select.k_syn_11 <= red_select.k_syn_10;
        red_select.k_syn_12 <= red_select.k_syn_11;
        gre_select.k_syn_1  <= gre_select.k;
        gre_select.k_syn_2  <= gre_select.k_syn_1;
        gre_select.k_syn_3  <= gre_select.k_syn_2;
        gre_select.k_syn_4  <= gre_select.k_syn_3;
        gre_select.k_syn_5  <= gre_select.k_syn_4;
        gre_select.k_syn_6  <= gre_select.k_syn_5;
        gre_select.k_syn_7  <= gre_select.k_syn_6;
        gre_select.k_syn_8  <= gre_select.k_syn_7;
        gre_select.k_syn_9  <= gre_select.k_syn_8;
        gre_select.k_syn_10 <= gre_select.k_syn_9;
        gre_select.k_syn_11 <= gre_select.k_syn_10;
        gre_select.k_syn_12 <= gre_select.k_syn_11;
        blu_select.k_syn_1  <= blu_select.k;
        blu_select.k_syn_2  <= blu_select.k_syn_1;
        blu_select.k_syn_3  <= blu_select.k_syn_2;
        blu_select.k_syn_4  <= blu_select.k_syn_3;
        blu_select.k_syn_5  <= blu_select.k_syn_4;
        blu_select.k_syn_6  <= blu_select.k_syn_5;
        blu_select.k_syn_7  <= blu_select.k_syn_6;
        blu_select.k_syn_8  <= blu_select.k_syn_7;
        blu_select.k_syn_9  <= blu_select.k_syn_8;
        blu_select.k_syn_10 <= blu_select.k_syn_9;
        blu_select.k_syn_11 <= blu_select.k_syn_10;
        blu_select.k_syn_12 <= blu_select.k_syn_11;
    end if;
end process;
--=================================================================================================
--process (clk) begin
--    if rising_edge(clk) then
--        if (red_select.k_syn_9(2).n=2 and red_select.k_syn_9(3).n=3 and red_select.k_syn_9(4).n=4 and red_select.k_syn_9(5).n=5 and red_select.k_syn_9(6).n=6 and red_select.k_syn_9(7).n=7 and red_select.k_syn_9(8).n=8 and red_select.k_syn_9(9).n=9) then
--                red_select.result   <= std_logic_vector(red_select.add_s9(i_data_width-1 downto 0));
--            else
--                red_select.result <= std_logic_vector(red_select.sumprod_Bn.k1(i_data_width-1 downto 0));
--        end if;
--    end if;
--end process;
process (clk) begin
    if rising_edge(clk) then
        if(red.delta_2syn.k1 <= pixel_threshold) then
            red.delta_sum_prod_2.k1  <= red.delta_sum_prod_1.k1;
        else
            red.delta_sum_prod_2.k1  <= red.delta_sum_3.k1;
        end if;
        if(red.delta_2syn.k2 <= pixel_threshold) then
            red.delta_sum_prod_2.k2  <= red.delta_sum_prod_1.k2;
        else
            red.delta_sum_prod_2.k2  <= red.delta_sum_3.k2;
        end if;
        if(red.delta_2syn.k3 <= pixel_threshold) then
            red.delta_sum_prod_2.k3  <= red.delta_sum_prod_1.k3;
        else
            red.delta_sum_prod_2.k3  <= red.delta_sum_3.k3;
        end if;
        if(red.delta_2syn.k4 <= pixel_threshold) then
            red.delta_sum_prod_2.k4  <= red.delta_sum_prod_1.k4;
        else
            red.delta_sum_prod_2.k4  <= red.delta_sum_3.k4;
        end if;
        if(red.delta_2syn.k5 <= pixel_threshold) then
            red.delta_sum_prod_2.k5  <= red.delta_sum_prod_1.k5;
        else
            red.delta_sum_prod_2.k5  <= red.delta_sum_3.k5;
        end if;
        if(red.delta_2syn.k6 <= pixel_threshold) then
            red.delta_sum_prod_2.k6  <= red.delta_sum_prod_1.k6;
        else
            red.delta_sum_prod_2.k6  <= red.delta_sum_3.k6;
        end if;
        if(red.delta_2syn.k7 <= pixel_threshold) then
            red.delta_sum_prod_2.k7  <= red.delta_sum_prod_1.k7;
        else
            red.delta_sum_prod_2.k7  <= red.delta_sum_3.k7;
        end if;
        if(red.delta_2syn.k8 <= pixel_threshold) then
            red.delta_sum_prod_2.k8  <= red.delta_sum_prod_1.k8;
        else
            red.delta_sum_prod_2.k8  <= red.delta_sum_3.k8;
        end if;
        if(red.delta_2syn.k9 <= pixel_threshold) then
            red.delta_sum_prod_2.k9  <= red.delta_sum_prod_1.k9;
        else
            red.delta_sum_prod_2.k9  <= red.delta_sum_3.k9;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(gre.delta_2syn.k1 <= pixel_threshold) then
            gre.delta_sum_prod_2.k1  <= gre.delta_sum_prod_1.k1;
        else
            gre.delta_sum_prod_2.k1  <= gre.delta_sum_3.k1;
        end if;
        if(gre.delta_2syn.k2 <= pixel_threshold) then
            gre.delta_sum_prod_2.k2  <= gre.delta_sum_prod_1.k2;
        else
            gre.delta_sum_prod_2.k2  <= gre.delta_sum_3.k2;
        end if;
        if(gre.delta_2syn.k3 <= pixel_threshold) then
            gre.delta_sum_prod_2.k3  <= gre.delta_sum_prod_1.k3;
        else
            gre.delta_sum_prod_2.k3  <= gre.delta_sum_3.k3;
        end if;
        if(gre.delta_2syn.k4 <= pixel_threshold) then
            gre.delta_sum_prod_2.k4  <= gre.delta_sum_prod_1.k4;
        else
            gre.delta_sum_prod_2.k4  <= gre.delta_sum_3.k4;
        end if;
        if(gre.delta_2syn.k5 <= pixel_threshold) then
            gre.delta_sum_prod_2.k5  <= gre.delta_sum_prod_1.k5;
        else
            gre.delta_sum_prod_2.k5  <= gre.delta_sum_3.k5;
        end if;
        if(gre.delta_2syn.k6 <= pixel_threshold) then
            gre.delta_sum_prod_2.k6  <= gre.delta_sum_prod_1.k6;
        else
            gre.delta_sum_prod_2.k6  <= gre.delta_sum_3.k6;
        end if;
        if(gre.delta_2syn.k7 <= pixel_threshold) then
            gre.delta_sum_prod_2.k7  <= gre.delta_sum_prod_1.k7;
        else
            gre.delta_sum_prod_2.k7  <= gre.delta_sum_3.k7;
        end if;
        if(gre.delta_2syn.k8 <= pixel_threshold) then
            gre.delta_sum_prod_2.k8  <= gre.delta_sum_prod_1.k8;
        else
            gre.delta_sum_prod_2.k8  <= gre.delta_sum_3.k8;
        end if;
        if(gre.delta_2syn.k9 <= pixel_threshold) then
            gre.delta_sum_prod_2.k9  <= gre.delta_sum_prod_1.k9;
        else
            gre.delta_sum_prod_2.k9  <= gre.delta_sum_3.k9;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(blu.delta_2syn.k1 <= pixel_threshold) then
            blu.delta_sum_prod_2.k1  <= blu.delta_sum_prod_1.k1;
        else
            blu.delta_sum_prod_2.k1  <= blu.delta_sum_3.k1;
        end if;
        if(blu.delta_2syn.k2 <= pixel_threshold) then
            blu.delta_sum_prod_2.k2  <= blu.delta_sum_prod_1.k2;
        else
            blu.delta_sum_prod_2.k2  <= blu.delta_sum_3.k2;
        end if;
        if(blu.delta_2syn.k3 <= pixel_threshold) then
            blu.delta_sum_prod_2.k3  <= blu.delta_sum_prod_1.k3;
        else
            blu.delta_sum_prod_2.k3  <= blu.delta_sum_3.k3;
        end if;
        if(blu.delta_2syn.k4 <= pixel_threshold) then
            blu.delta_sum_prod_2.k4  <= blu.delta_sum_prod_1.k4;
        else
            blu.delta_sum_prod_2.k4  <= blu.delta_sum_3.k4;
        end if;
        if(blu.delta_2syn.k5 <= pixel_threshold) then
            blu.delta_sum_prod_2.k5  <= blu.delta_sum_prod_1.k5;
        else
            blu.delta_sum_prod_2.k5  <= blu.delta_sum_3.k5;
        end if;
        if(blu.delta_2syn.k6 <= pixel_threshold) then
            blu.delta_sum_prod_2.k6  <= blu.delta_sum_prod_1.k6;
        else
            blu.delta_sum_prod_2.k6  <= blu.delta_sum_3.k6;
        end if;
        if(blu.delta_2syn.k7 <= pixel_threshold) then
            blu.delta_sum_prod_2.k7  <= blu.delta_sum_prod_1.k7;
        else
            blu.delta_sum_prod_2.k7  <= blu.delta_sum_3.k7;
        end if;
        if(blu.delta_2syn.k8 <= pixel_threshold) then
            blu.delta_sum_prod_2.k8  <= blu.delta_sum_prod_1.k8;
        else
            blu.delta_sum_prod_2.k8  <= blu.delta_sum_3.k8;
        end if;
        if(blu.delta_2syn.k9 <= pixel_threshold) then
            blu.delta_sum_prod_2.k9  <= blu.delta_sum_prod_1.k9;
        else
            blu.delta_sum_prod_2.k9  <= blu.delta_sum_3.k9;
        end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        if (wCountAddress = ch1) then
            red.delta_sum_prod_3.k1    <= red.delta_sum_prod_2.k1;
            red.delta_sum_prod_3.k2    <= red.delta_sum_prod_2.k2;
            red.delta_sum_prod_3.k3    <= red.delta_sum_prod_2.k3;
            red.delta_sum_prod_3.k4    <= red.delta_sum_prod_2.k4;
            red.delta_sum_prod_3.k5    <= red.delta_sum_prod_2.k5;
            red.delta_sum_prod_3.k6    <= red.delta_sum_prod_2.k6;
            red.delta_sum_prod_3.k7    <= red.delta_sum_prod_2.k7;
            red.delta_sum_prod_3.k8    <= red.delta_sum_prod_2.k8;
            red.delta_sum_prod_3.k9    <= red.delta_sum_prod_2.k9;
        end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        if (wCountAddress = ch1) then
            gre.delta_sum_prod_3.k1    <= gre.delta_sum_prod_2.k1;
            gre.delta_sum_prod_3.k2    <= gre.delta_sum_prod_2.k2;
            gre.delta_sum_prod_3.k3    <= gre.delta_sum_prod_2.k3;
            gre.delta_sum_prod_3.k4    <= gre.delta_sum_prod_2.k4;
            gre.delta_sum_prod_3.k5    <= gre.delta_sum_prod_2.k5;
            gre.delta_sum_prod_3.k6    <= gre.delta_sum_prod_2.k6;
            gre.delta_sum_prod_3.k7    <= gre.delta_sum_prod_2.k7;
            gre.delta_sum_prod_3.k8    <= gre.delta_sum_prod_2.k8;
            gre.delta_sum_prod_3.k9    <= gre.delta_sum_prod_2.k9;
        end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        if (wCountAddress = ch1) then
            blu.delta_sum_prod_3.k1    <= blu.delta_sum_prod_2.k1;
            blu.delta_sum_prod_3.k2    <= blu.delta_sum_prod_2.k2;
            blu.delta_sum_prod_3.k3    <= blu.delta_sum_prod_2.k3;
            blu.delta_sum_prod_3.k4    <= blu.delta_sum_prod_2.k4;
            blu.delta_sum_prod_3.k5    <= blu.delta_sum_prod_2.k5;
            blu.delta_sum_prod_3.k6    <= blu.delta_sum_prod_2.k6;
            blu.delta_sum_prod_3.k7    <= blu.delta_sum_prod_2.k7;
            blu.delta_sum_prod_3.k8    <= blu.delta_sum_prod_2.k8;
            blu.delta_sum_prod_3.k9    <= blu.delta_sum_prod_2.k9;
        end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        red_line11(0).pix <= std_logic_vector(red.delta_sum_prod_3.k1(i_data_width-1 downto 0));
        red_line12(0).pix <= std_logic_vector(red.delta_sum_prod_3.k2(i_data_width-1 downto 0));
        red_line11(1).pix <= red_line12(0).pix;
        red_line13(0).pix <= std_logic_vector(red.delta_sum_prod_3.k3(i_data_width-1 downto 0));
        red_line13(1).pix <= red_line13(0).pix;
        red_line11(2).pix <= red_line13(1).pix;
        red_line22(0).pix <= std_logic_vector(red.delta_sum_prod_3.k4(i_data_width-1 downto 0));
        red_line21(0).pix <= std_logic_vector(red.delta_sum_prod_3.k5(i_data_width-1 downto 0));
        red_line22(1).pix <= red_line21(0).pix;
        red_line23(0).pix <= std_logic_vector(red.delta_sum_prod_3.k6(i_data_width-1 downto 0));
        red_line23(1).pix <= red_line23(0).pix;
        red_line22(2).pix <= red_line23(1).pix;
        red_line33(0).pix <= std_logic_vector(red.delta_sum_prod_3.k7(i_data_width-1 downto 0));
        red_line31(0).pix <= std_logic_vector(red.delta_sum_prod_3.k8(i_data_width-1 downto 0));
        red_line33(1).pix <= red_line31(0).pix;
        red_line32(0).pix <= std_logic_vector(red.delta_sum_prod_3.k9(i_data_width-1 downto 0));
        red_line32(1).pix <= red_line32(0).pix;
        red_line33(2).pix <= red_line32(1).pix;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        gre_line11(0).pix <= std_logic_vector(gre.delta_sum_prod_3.k1(i_data_width-1 downto 0));
        gre_line12(0).pix <= std_logic_vector(gre.delta_sum_prod_3.k2(i_data_width-1 downto 0));
        gre_line11(1).pix <= gre_line12(0).pix;
        gre_line13(0).pix <= std_logic_vector(gre.delta_sum_prod_3.k3(i_data_width-1 downto 0));
        gre_line13(1).pix <= gre_line13(0).pix;
        gre_line11(2).pix <= gre_line13(1).pix;
        gre_line22(0).pix <= std_logic_vector(gre.delta_sum_prod_3.k4(i_data_width-1 downto 0));
        gre_line21(0).pix <= std_logic_vector(gre.delta_sum_prod_3.k5(i_data_width-1 downto 0));
        gre_line22(1).pix <= gre_line21(0).pix;
        gre_line23(0).pix <= std_logic_vector(gre.delta_sum_prod_3.k6(i_data_width-1 downto 0));
        gre_line23(1).pix <= gre_line23(0).pix;
        gre_line22(2).pix <= gre_line23(1).pix;
        gre_line33(0).pix <= std_logic_vector(gre.delta_sum_prod_3.k7(i_data_width-1 downto 0));
        gre_line31(0).pix <= std_logic_vector(gre.delta_sum_prod_3.k8(i_data_width-1 downto 0));
        gre_line33(1).pix <= gre_line31(0).pix;
        gre_line32(0).pix <= std_logic_vector(gre.delta_sum_prod_3.k9(i_data_width-1 downto 0));
        gre_line32(1).pix <= gre_line32(0).pix;
        gre_line33(2).pix <= gre_line32(1).pix;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        blu_line11(0).pix <= std_logic_vector(blu.delta_sum_prod_3.k1(i_data_width-1 downto 0));
        blu_line12(0).pix <= std_logic_vector(blu.delta_sum_prod_3.k2(i_data_width-1 downto 0));
        blu_line11(1).pix <= blu_line12(0).pix;
        blu_line13(0).pix <= std_logic_vector(blu.delta_sum_prod_3.k3(i_data_width-1 downto 0));
        blu_line13(1).pix <= blu_line13(0).pix;
        blu_line11(2).pix <= blu_line13(1).pix;
        blu_line22(0).pix <= std_logic_vector(blu.delta_sum_prod_3.k4(i_data_width-1 downto 0));
        blu_line21(0).pix <= std_logic_vector(blu.delta_sum_prod_3.k5(i_data_width-1 downto 0));
        blu_line22(1).pix <= blu_line21(0).pix;
        blu_line23(0).pix <= std_logic_vector(blu.delta_sum_prod_3.k6(i_data_width-1 downto 0));
        blu_line23(1).pix <= blu_line23(0).pix;
        blu_line22(2).pix <= blu_line23(1).pix;
        blu_line33(0).pix <= std_logic_vector(blu.delta_sum_prod_3.k7(i_data_width-1 downto 0));
        blu_line31(0).pix <= std_logic_vector(blu.delta_sum_prod_3.k8(i_data_width-1 downto 0));
        blu_line33(1).pix <= blu_line31(0).pix;
        blu_line32(0).pix <= std_logic_vector(blu.delta_sum_prod_3.k9(i_data_width-1 downto 0));
        blu_line32(1).pix <= blu_line32(0).pix;
        blu_line33(2).pix <= blu_line32(1).pix;
    end if;
end process;
process (clk)begin -- 10 cycles away from taps
    if rising_edge(clk) then
        red_line0n(0).pix <= red_line11(wCountAddress).pix;
        red_line0n(1).pix <= red_line22(wCountAddress).pix;
        red_line0n(2).pix <= red_line33(wCountAddress).pix;
        red_line1n        <= red_line0n;
        red_line2n        <= red_line1n;
        red_line3n        <= red_line2n;
        red_line4n        <= red_line3n;
        red_line5n        <= red_line4n;
        red_line6n        <= red_line5n;
        red_line7n        <= red_line6n;
        red_line8n        <= red_line7n;
    end if;
end process;
process (clk)begin -- 10 cycles away from taps
    if rising_edge(clk) then
        red_line_n(3).pix <= red_select.result;
        red_line_n(4).pix <= gre_select.result;
        red_line_n(5).pix <= blu_select.result;
        red_line_n(0).pix <= red_line11(wCountAddress).pix;
        red_line_n(1).pix <= red_line22(wCountAddress).pix;
        red_line_n(2).pix <= red_line33(wCountAddress).pix;
    end if;
end process;
process (clk)begin -- 10 cycles away from taps
    if rising_edge(clk) then
        gre_line_n(0).pix <= gre_line11(wCountAddress).pix;
        gre_line_n(1).pix <= gre_line22(wCountAddress).pix;
        gre_line_n(2).pix <= gre_line33(wCountAddress).pix;
    end if;
end process;
process (clk)begin -- 10 cycles away from taps
    if rising_edge(clk) then
        blu_line_n(0).pix <= blu_line11(wCountAddress).pix;
        blu_line_n(1).pix <= blu_line22(wCountAddress).pix;
        blu_line_n(2).pix <= blu_line33(wCountAddress).pix;
    end if;
end process;
process(clk)begin
    if rising_edge(clk) then
        if (wCountAddress = ch2) then
            wCountAddress <= ch0;
        else
            wCountAddress <= wCountAddress + 1;
        end if;
    end if;
end process;
    -- auto detect shape delta values
    Rgb3.red     <= red_line_n(3).pix;
    Rgb3.green   <= red_line_n(4).pix;
    Rgb3.blue    <= red_line_n(5).pix;
    Rgb3.valid   <= rgbSyncValid(0);
    -- fixed delta values
    o2Rgb.red    <= red_line_n(0).pix;
    o2Rgb.green  <= gre_line_n(0).pix;
    o2Rgb.blue   <= blu_line_n(0).pix;
    o2Rgb.valid   <= rgbSyncValid(0);
    -- rgb - hsl values
    o3Rgb.red    <= std_logic_vector(rgb_ool3.red(i_data_width-1 downto 0));
    o3Rgb.green  <= std_logic_vector(rgb_ool3.green(i_data_width-1 downto 0));
    o3Rgb.blue   <= std_logic_vector(rgb_ool3.blue(i_data_width-1 downto 0));
    o3Rgb.valid  <= rgbSyncValid(7);
sharp_f_valid_inst : d_valid
generic map (
    pixelDelay   => 20)--10 -- fixed delta values
port map(
    clk      => clk,
    iRgb     => o3Rgb,
    oRgb     => Rgb6);
rgb5_syncr_inst  : sync_frames
generic map(
    pixelDelay => 41)
port map(
    clk        => clk,
    reset      => reset,
    iRgb       => Rgb6,
    oRgb       => oRgb);

end behavioral;