-------------------------------------------------------------------------------
--
-- Filename    : recolor_space_3.vhd
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
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;
entity recolor_space_3 is
generic (
    img_width      : integer := 1920;
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end recolor_space_3;
architecture behavioral of recolor_space_3 is
--------------------------- ---------------------------------------------------
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
  signal point_five              : sfixed(4 downto -3) := to_sfixed(0.500,4,-3); -- Average detected pixels by 1/4
  signal pixel_threshold_2       : sfixed(11 downto 0)  := to_sfixed(200.0,11,0);   -- [60% with 20] [70% with 40] 
  signal pixel_threshold_zero    : sfixed(11 downto 0)  := to_sfixed(0.0,11,0);   -- [60% with 20] [70% with 40] 
  signal tpd1                    : k_3by3;
  signal tpd2                    : k_3by3;
  signal tpd3                    : k_3by3;
  signal tpd4                    : k_3by3;
  signal v1TapRGB0x              : std_logic_vector(23 downto 0) := (others => '0');
  signal v1TapRGB1x              : std_logic_vector(23 downto 0) := (others => '0');
  signal v1TapRGB2x              : std_logic_vector(23 downto 0) := (others => '0');
  signal v1TapRGB3x              : std_logic_vector(23 downto 0) := (others => '0'); 
  signal tpValid                 : std_logic;
  --==============================================================================================
  signal Rgb1                    : channel;
  signal Rgb2                    : channel;
  signal red_on                  : rgbSumProd;
  signal gre_on                  : rgbSumProd;
  signal blu_on                  : rgbSumProd;
  signal red_select              : rgb_sum_prod;
  signal gre_select              : rgb_sum_prod;
  signal blu_select              : rgb_sum_prod;
  signal red_add                 : rgb_add_range;
  signal gre_add                 : rgb_add_range;
  signal blu_add                 : rgb_add_range;
  signal red_detect              : rgb_detect_kernal;
  signal gre_detect              : rgb_detect_kernal;
  signal blu_detect              : rgb_detect_kernal;
  --==============================================================================================
  signal syn1KernalData_red      : kkkCoeff;
  signal syn2KernalData_red      : kkkCoeff;
  signal syn3KernalData_red      : kkkCoeff;
  signal syn4KernalData_red      : kkkCoeff;
  signal syn5KernalData_red      : kkkCoeff;
  signal synaKernalData_red      : kkkCoeff;
  signal synbKernalData_red      : kkkCoeff;
  signal syn6KernalData_red      : kkkCoeff;
  --==============================================================================================
  signal syn1KernalData_gre      : kkkCoeff;
  signal syn2KernalData_gre      : kkkCoeff;
  signal syn3KernalData_gre      : kkkCoeff;
  signal syn4KernalData_gre      : kkkCoeff;
  signal syn5KernalData_gre      : kkkCoeff;
  signal synaKernalData_gre      : kkkCoeff;
  signal synbKernalData_gre      : kkkCoeff;
  signal syn6KernalData_gre      : kkkCoeff;
  --==============================================================================================
  signal syn1KernalData_blu      : kkkCoeff;
  signal syn2KernalData_blu      : kkkCoeff;
  signal syn3KernalData_blu      : kkkCoeff;
  signal syn4KernalData_blu      : kkkCoeff;
  signal syn5KernalData_blu      : kkkCoeff;
  signal synaKernalData_blu      : kkkCoeff;
  signal synbKernalData_blu      : kkkCoeff;
  signal syn6KernalData_blu      : kkkCoeff;
  --==============================================================================================
  signal rgbSyncValid            : std_logic_vector(15 downto 0)  := x"0000";
begin 
--================================================================================================
process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= iRgb.valid;
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
    end if;
end process;
RGBInst: rgb_4taps
generic map(
    img_width       => img_width,
    tpDataWidth     => 24)
port map(
    clk             => clk,
    rst_l           => reset,
    iRgb            => iRgb,
    tpValid         => tpValid,
    tp0             => v1TapRGB0x,
    tp1             => v1TapRGB1x,
    tp2             => v1TapRGB2x,
    tp3             => v1TapRGB3x);
process (clk) begin
    if rising_edge(clk) then
        if reset = '0' then
            tpd1.row_1    <= (others => '0');
            tpd1.row_2    <= (others => '0');
            tpd1.row_3    <= (others => '0');
            tpd1.row_4    <= (others => '0');
            tpd2.row_1    <= (others => '0');
            tpd2.row_2    <= (others => '0');
            tpd2.row_3    <= (others => '0');
            tpd2.row_4    <= (others => '0');
            tpd3.row_1    <= (others => '0');
            tpd3.row_2    <= (others => '0');
            tpd3.row_3    <= (others => '0');
            tpd3.row_4    <= (others => '0');
            tpd4.row_1    <= (others => '0');
            tpd4.row_2    <= (others => '0');
            tpd4.row_3    <= (others => '0');
            tpd4.row_4    <= (others => '0');
        else
            tpd1.row_1    <= v1TapRGB0x;
            tpd2.row_1    <= tpd1.row_1;
            tpd3.row_1    <= tpd2.row_1;
            tpd4.row_1    <= tpd3.row_1;
            tpd1.row_2    <= v1TapRGB1x;
            tpd2.row_2    <= tpd1.row_2;
            tpd3.row_2    <= tpd2.row_2;
            tpd4.row_2    <= tpd3.row_2;
            tpd1.row_3    <= v1TapRGB2x;
            tpd2.row_3    <= tpd1.row_3;
            tpd3.row_3    <= tpd2.row_3;
            tpd4.row_3    <= tpd3.row_3;
            tpd1.row_4    <= v1TapRGB3x;
            tpd2.row_4    <= tpd1.row_4;
            tpd3.row_4    <= tpd2.row_4;
            tpd4.row_4    <= tpd3.row_4;
            syn1KernalData_red.k1  <= tpd4.row_1(23 downto 16);
            syn1KernalData_red.k2  <= tpd3.row_1(23 downto 16);
            syn1KernalData_red.k3  <= tpd2.row_1(23 downto 16);
            syn1KernalData_red.k4  <= tpd1.row_1(23 downto 16);
            syn1KernalData_red.k5  <= tpd4.row_2(23 downto 16);
            syn1KernalData_red.k6  <= tpd3.row_2(23 downto 16);
            syn1KernalData_red.k7  <= tpd2.row_2(23 downto 16);
            syn1KernalData_red.k8  <= tpd1.row_2(23 downto 16);
            syn1KernalData_red.k9  <= tpd4.row_3(23 downto 16);
            syn1KernalData_red.k10 <= tpd3.row_3(23 downto 16);
            syn1KernalData_red.k11 <= tpd2.row_3(23 downto 16);
            syn1KernalData_red.k12 <= tpd1.row_3(23 downto 16);
            syn1KernalData_red.k13 <= tpd4.row_4(23 downto 16);
            syn1KernalData_red.k14 <= tpd3.row_4(23 downto 16);
            syn1KernalData_red.k15 <= tpd2.row_4(23 downto 16);
            syn1KernalData_red.k16 <= tpd1.row_4(23 downto 16);
            syn2KernalData_red     <= syn1KernalData_red;
            syn3KernalData_red     <= syn2KernalData_red;
            syn4KernalData_red     <= syn3KernalData_red;
            syn5KernalData_red     <= syn4KernalData_red;
            synaKernalData_red     <= syn5KernalData_red;
            synbKernalData_red     <= synaKernalData_red;
        --========================================================================================
            syn1KernalData_gre.k1  <= tpd4.row_1(15 downto 8);
            syn1KernalData_gre.k2  <= tpd3.row_1(15 downto 8);
            syn1KernalData_gre.k3  <= tpd2.row_1(15 downto 8);
            syn1KernalData_gre.k4  <= tpd1.row_1(15 downto 8);
            syn1KernalData_gre.k5  <= tpd4.row_2(15 downto 8);
            syn1KernalData_gre.k6  <= tpd3.row_2(15 downto 8);
            syn1KernalData_gre.k7  <= tpd2.row_2(15 downto 8);
            syn1KernalData_gre.k8  <= tpd1.row_2(15 downto 8);
            syn1KernalData_gre.k9  <= tpd4.row_3(15 downto 8);
            syn1KernalData_gre.k10 <= tpd3.row_3(15 downto 8);
            syn1KernalData_gre.k11 <= tpd2.row_3(15 downto 8);
            syn1KernalData_gre.k12 <= tpd1.row_3(15 downto 8);
            syn1KernalData_gre.k13 <= tpd4.row_4(15 downto 8);
            syn1KernalData_gre.k14 <= tpd3.row_4(15 downto 8);
            syn1KernalData_gre.k15 <= tpd2.row_4(15 downto 8);
            syn1KernalData_gre.k16 <= tpd1.row_4(15 downto 8);
            syn2KernalData_gre     <= syn1KernalData_gre;
            syn3KernalData_gre     <= syn2KernalData_gre;
            syn4KernalData_gre     <= syn3KernalData_gre;
            syn5KernalData_gre     <= syn4KernalData_gre;
            synaKernalData_gre     <= syn5KernalData_gre;
            synbKernalData_gre     <= synaKernalData_gre;
        --========================================================================================
            syn1KernalData_blu.k1  <= tpd4.row_1(7 downto 0);
            syn1KernalData_blu.k2  <= tpd3.row_1(7 downto 0);
            syn1KernalData_blu.k3  <= tpd2.row_1(7 downto 0);
            syn1KernalData_blu.k4  <= tpd1.row_1(7 downto 0);
            syn1KernalData_blu.k5  <= tpd4.row_2(7 downto 0);
            syn1KernalData_blu.k6  <= tpd3.row_2(7 downto 0);
            syn1KernalData_blu.k7  <= tpd2.row_2(7 downto 0);
            syn1KernalData_blu.k8  <= tpd1.row_2(7 downto 0);
            syn1KernalData_blu.k9  <= tpd4.row_3(7 downto 0);
            syn1KernalData_blu.k10 <= tpd3.row_3(7 downto 0);
            syn1KernalData_blu.k11 <= tpd2.row_3(7 downto 0);
            syn1KernalData_blu.k12 <= tpd1.row_3(7 downto 0);
            syn1KernalData_blu.k13 <= tpd4.row_4(7 downto 0);
            syn1KernalData_blu.k14 <= tpd3.row_4(7 downto 0);
            syn1KernalData_blu.k15 <= tpd2.row_4(7 downto 0);
            syn1KernalData_blu.k16 <= tpd1.row_4(7 downto 0);
            syn2KernalData_blu     <= syn1KernalData_blu;
            syn3KernalData_blu     <= syn2KernalData_blu;
            syn4KernalData_blu     <= syn3KernalData_blu;
            syn5KernalData_blu     <= syn4KernalData_blu;
            synaKernalData_blu     <= syn5KernalData_blu;
            synbKernalData_blu     <= synaKernalData_blu;
        --========================================================================================
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgbSyncValid(13) = hi)then
            syn6KernalData_red.k1  <= synbKernalData_red.k1;
            syn6KernalData_red.k2  <= synbKernalData_red.k2;
            syn6KernalData_red.k3  <= synbKernalData_red.k3;
            syn6KernalData_red.k4  <= synbKernalData_red.k4;
            syn6KernalData_red.k5  <= syn4KernalData_red.k5;
            syn6KernalData_red.k6  <= syn4KernalData_red.k6;
            syn6KernalData_red.k7  <= syn4KernalData_red.k7;
            syn6KernalData_red.k8  <= syn4KernalData_red.k8;
            syn6KernalData_red.k9  <= syn3KernalData_red.k9;
            syn6KernalData_red.k10 <= syn3KernalData_red.k10;
            syn6KernalData_red.k11 <= syn3KernalData_red.k11;
            syn6KernalData_red.k12 <= syn3KernalData_red.k12;
            syn6KernalData_red.k13 <= syn2KernalData_red.k13;
            syn6KernalData_red.k14 <= syn2KernalData_red.k14;
            syn6KernalData_red.k15 <= syn2KernalData_red.k15;
            syn6KernalData_red.k16 <= syn2KernalData_red.k16;
        --========================================================================================
            syn6KernalData_gre.k1  <= synbKernalData_gre.k1;
            syn6KernalData_gre.k2  <= synbKernalData_gre.k2;
            syn6KernalData_gre.k3  <= synbKernalData_gre.k3;
            syn6KernalData_gre.k4  <= synbKernalData_gre.k4;
            syn6KernalData_gre.k5  <= syn4KernalData_gre.k5;
            syn6KernalData_gre.k6  <= syn4KernalData_gre.k6;
            syn6KernalData_gre.k7  <= syn4KernalData_gre.k7;
            syn6KernalData_gre.k8  <= syn4KernalData_gre.k8;
            syn6KernalData_gre.k9  <= syn3KernalData_gre.k9;
            syn6KernalData_gre.k10 <= syn3KernalData_gre.k10;
            syn6KernalData_gre.k11 <= syn3KernalData_gre.k11;
            syn6KernalData_gre.k12 <= syn3KernalData_gre.k12;
            syn6KernalData_gre.k13 <= syn2KernalData_gre.k13;
            syn6KernalData_gre.k14 <= syn2KernalData_gre.k14;
            syn6KernalData_gre.k15 <= syn2KernalData_gre.k15;
            syn6KernalData_gre.k16 <= syn2KernalData_gre.k16;
        --========================================================================================
            syn6KernalData_blu.k1  <= synbKernalData_blu.k1;
            syn6KernalData_blu.k2  <= synbKernalData_blu.k2;
            syn6KernalData_blu.k3  <= synbKernalData_blu.k3;
            syn6KernalData_blu.k4  <= synbKernalData_blu.k4;
            syn6KernalData_blu.k5  <= syn4KernalData_blu.k5;
            syn6KernalData_blu.k6  <= syn4KernalData_blu.k6;
            syn6KernalData_blu.k7  <= syn4KernalData_blu.k7;
            syn6KernalData_blu.k8  <= syn4KernalData_blu.k8;
            syn6KernalData_blu.k9  <= syn3KernalData_blu.k9;
            syn6KernalData_blu.k10 <= syn3KernalData_blu.k10;
            syn6KernalData_blu.k11 <= syn3KernalData_blu.k11;
            syn6KernalData_blu.k12 <= syn3KernalData_blu.k12;
            syn6KernalData_blu.k13 <= syn2KernalData_blu.k13;
            syn6KernalData_blu.k14 <= syn2KernalData_blu.k14;
            syn6KernalData_blu.k15 <= syn2KernalData_blu.k15;
            syn6KernalData_blu.k16 <= syn2KernalData_blu.k16;
        else
            syn6KernalData_red.k1  <= (others => '0');
            syn6KernalData_red.k2  <= (others => '0');
            syn6KernalData_red.k3  <= (others => '0');
            syn6KernalData_red.k4  <= (others => '0');
            syn6KernalData_red.k5  <= (others => '0');
            syn6KernalData_red.k6  <= (others => '0');
            syn6KernalData_red.k7  <= (others => '0');
            syn6KernalData_red.k8  <= (others => '0');
            syn6KernalData_red.k9  <= (others => '0');
            syn6KernalData_red.k9  <= (others => '0');
            syn6KernalData_red.k10 <= (others => '0');
            syn6KernalData_red.k11 <= (others => '0');
            syn6KernalData_red.k12 <= (others => '0');
            syn6KernalData_red.k13 <= (others => '0');
            syn6KernalData_red.k14 <= (others => '0');
            syn6KernalData_red.k15 <= (others => '0');
            syn6KernalData_red.k16 <= (others => '0');
        --========================================================================================
            syn6KernalData_gre.k1  <= (others => '0');
            syn6KernalData_gre.k2  <= (others => '0');
            syn6KernalData_gre.k3  <= (others => '0');
            syn6KernalData_gre.k4  <= (others => '0');
            syn6KernalData_gre.k5  <= (others => '0');
            syn6KernalData_gre.k6  <= (others => '0');
            syn6KernalData_gre.k7  <= (others => '0');
            syn6KernalData_gre.k8  <= (others => '0');
            syn6KernalData_gre.k9  <= (others => '0');
            syn6KernalData_gre.k9  <= (others => '0');
            syn6KernalData_gre.k10 <= (others => '0');
            syn6KernalData_gre.k11 <= (others => '0');
            syn6KernalData_gre.k12 <= (others => '0');
            syn6KernalData_gre.k13 <= (others => '0');
            syn6KernalData_gre.k14 <= (others => '0');
            syn6KernalData_gre.k15 <= (others => '0');
            syn6KernalData_gre.k16 <= (others => '0');
        --========================================================================================
            syn6KernalData_blu.k1  <= (others => '0');
            syn6KernalData_blu.k2  <= (others => '0');
            syn6KernalData_blu.k3  <= (others => '0');
            syn6KernalData_blu.k4  <= (others => '0');
            syn6KernalData_blu.k5  <= (others => '0');
            syn6KernalData_blu.k6  <= (others => '0');
            syn6KernalData_blu.k7  <= (others => '0');
            syn6KernalData_blu.k8  <= (others => '0');
            syn6KernalData_blu.k9  <= (others => '0');
            syn6KernalData_blu.k9  <= (others => '0');
            syn6KernalData_blu.k10 <= (others => '0');
            syn6KernalData_blu.k11 <= (others => '0');
            syn6KernalData_blu.k12 <= (others => '0');
            syn6KernalData_blu.k13 <= (others => '0');
            syn6KernalData_blu.k14 <= (others => '0');
            syn6KernalData_blu.k15 <= (others => '0');
            syn6KernalData_blu.k16 <= (others => '0');
        --========================================================================================
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        --========================================================================================
        red_on.k1    <= to_sfixed("00" & syn6KernalData_red.k1, red_on.k1);
        red_on.k2    <= to_sfixed("00" & syn6KernalData_red.k2, red_on.k2);
        red_on.k3    <= to_sfixed("00" & syn6KernalData_red.k3, red_on.k3);
        red_on.k4    <= to_sfixed("00" & syn6KernalData_red.k4, red_on.k4);
        red_on.k5    <= to_sfixed("00" & syn6KernalData_red.k5, red_on.k5);
        red_on.k6    <= to_sfixed("00" & syn6KernalData_red.k6, red_on.k6);
        red_on.k7    <= to_sfixed("00" & syn6KernalData_red.k7, red_on.k7);
        red_on.k8    <= to_sfixed("00" & syn6KernalData_red.k8, red_on.k8);
        red_on.k9    <= to_sfixed("00" & syn6KernalData_red.k9, red_on.k9);
        red_on.k10   <= to_sfixed("00" & syn6KernalData_red.k10, red_on.k10);
        red_on.k11   <= to_sfixed("00" & syn6KernalData_red.k11, red_on.k11);
        red_on.k12   <= to_sfixed("00" & syn6KernalData_red.k12, red_on.k12);
        red_on.k13   <= to_sfixed("00" & syn6KernalData_red.k13, red_on.k13);
        red_on.k14   <= to_sfixed("00" & syn6KernalData_red.k14, red_on.k14);
        red_on.k15   <= to_sfixed("00" & syn6KernalData_red.k15, red_on.k15);
        red_on.k16   <= to_sfixed("00" & syn6KernalData_red.k16, red_on.k16);
        --========================================================================================
        gre_on.k1    <= to_sfixed("00" & syn6KernalData_gre.k1, gre_on.k1);
        gre_on.k2    <= to_sfixed("00" & syn6KernalData_gre.k2, gre_on.k2);
        gre_on.k3    <= to_sfixed("00" & syn6KernalData_gre.k3, gre_on.k3);
        gre_on.k4    <= to_sfixed("00" & syn6KernalData_gre.k4, gre_on.k4);
        gre_on.k5    <= to_sfixed("00" & syn6KernalData_gre.k5, gre_on.k5);
        gre_on.k6    <= to_sfixed("00" & syn6KernalData_gre.k6, gre_on.k6);
        gre_on.k7    <= to_sfixed("00" & syn6KernalData_gre.k7, gre_on.k7);
        gre_on.k8    <= to_sfixed("00" & syn6KernalData_gre.k8, gre_on.k8);
        gre_on.k9    <= to_sfixed("00" & syn6KernalData_gre.k9, gre_on.k9);
        gre_on.k10   <= to_sfixed("00" & syn6KernalData_gre.k10, gre_on.k10);
        gre_on.k11   <= to_sfixed("00" & syn6KernalData_gre.k11, gre_on.k11);
        gre_on.k12   <= to_sfixed("00" & syn6KernalData_gre.k12, gre_on.k12);
        gre_on.k13   <= to_sfixed("00" & syn6KernalData_gre.k13, gre_on.k13);
        gre_on.k14   <= to_sfixed("00" & syn6KernalData_gre.k14, gre_on.k14);
        gre_on.k15   <= to_sfixed("00" & syn6KernalData_gre.k15, gre_on.k15);
        gre_on.k16   <= to_sfixed("00" & syn6KernalData_gre.k16, gre_on.k16);
        --========================================================================================
        blu_on.k1    <= to_sfixed("00" & syn6KernalData_blu.k1, blu_on.k1);
        blu_on.k2    <= to_sfixed("00" & syn6KernalData_blu.k2, blu_on.k2);
        blu_on.k3    <= to_sfixed("00" & syn6KernalData_blu.k3, blu_on.k3);
        blu_on.k4    <= to_sfixed("00" & syn6KernalData_blu.k4, blu_on.k4);
        blu_on.k5    <= to_sfixed("00" & syn6KernalData_blu.k5, blu_on.k5);
        blu_on.k6    <= to_sfixed("00" & syn6KernalData_blu.k6, blu_on.k6);
        blu_on.k7    <= to_sfixed("00" & syn6KernalData_blu.k7, blu_on.k7);
        blu_on.k8    <= to_sfixed("00" & syn6KernalData_blu.k8, blu_on.k8);
        blu_on.k9    <= to_sfixed("00" & syn6KernalData_blu.k9, blu_on.k9);
        blu_on.k10   <= to_sfixed("00" & syn6KernalData_blu.k10, blu_on.k10);
        blu_on.k11   <= to_sfixed("00" & syn6KernalData_blu.k11, blu_on.k11);
        blu_on.k12   <= to_sfixed("00" & syn6KernalData_blu.k12, blu_on.k12);
        blu_on.k13   <= to_sfixed("00" & syn6KernalData_blu.k13, blu_on.k13);
        blu_on.k14   <= to_sfixed("00" & syn6KernalData_blu.k14, blu_on.k14);
        blu_on.k15   <= to_sfixed("00" & syn6KernalData_blu.k15, blu_on.k15);
        blu_on.k16   <= to_sfixed("00" & syn6KernalData_blu.k16, blu_on.k16);
    end if;
end process;
        --========================================================================================
        -- STAGE 1
        --========================================================================================
process (clk) begin
    if rising_edge(clk) then
        --P|11| P|12|
        --========================================================================================
        red_on.delta.k1      <= abs(red_on.k1 - red_on.k2);
        red_on.delta.k2      <= abs(red_on.k1 - red_on.k2);
        red_on.delta.k3      <= abs(red_on.k1 - red_on.k3);
        red_on.delta.k4      <= abs(red_on.k1 - red_on.k4);
        red_on.delta.k5      <= abs(red_on.k1 - red_on.k5);
        red_on.delta.k6      <= abs(red_on.k1 - red_on.k6);
        red_on.delta.k7      <= abs(red_on.k1 - red_on.k7);
        red_on.delta.k8      <= abs(red_on.k1 - red_on.k8);
        red_on.delta.k9      <= abs(red_on.k1 - red_on.k9);
        red_on.delta.k10     <= abs(red_on.k1 - red_on.k10);
        red_on.delta.k11     <= abs(red_on.k1 - red_on.k11);
        red_on.delta.k12     <= abs(red_on.k1 - red_on.k12);
        red_on.delta.k13     <= abs(red_on.k1 - red_on.k13);
        red_on.delta.k14     <= abs(red_on.k1 - red_on.k14);
        red_on.delta.k15     <= abs(red_on.k1 - red_on.k15);
        red_on.delta.k16     <= abs(red_on.k1 - red_on.k16);
        --========================================================================================
        gre_on.delta.k1      <= abs(gre_on.k1 - gre_on.k1);
        gre_on.delta.k2      <= abs(gre_on.k1 - gre_on.k2);
        gre_on.delta.k3      <= abs(gre_on.k1 - gre_on.k3);
        gre_on.delta.k4      <= abs(gre_on.k1 - gre_on.k4);
        gre_on.delta.k5      <= abs(gre_on.k1 - gre_on.k5);
        gre_on.delta.k6      <= abs(gre_on.k1 - gre_on.k6);
        gre_on.delta.k7      <= abs(gre_on.k1 - gre_on.k7);
        gre_on.delta.k8      <= abs(gre_on.k1 - gre_on.k8);
        gre_on.delta.k9      <= abs(gre_on.k1 - gre_on.k9);
        gre_on.delta.k10     <= abs(gre_on.k1 - gre_on.k10);
        gre_on.delta.k11     <= abs(gre_on.k1 - gre_on.k11);
        gre_on.delta.k12     <= abs(gre_on.k1 - gre_on.k12);
        gre_on.delta.k13     <= abs(gre_on.k1 - gre_on.k13);
        gre_on.delta.k14     <= abs(gre_on.k1 - gre_on.k14);
        gre_on.delta.k15     <= abs(gre_on.k1 - gre_on.k15);
        gre_on.delta.k16     <= abs(gre_on.k1 - gre_on.k16);
        --========================================================================================
        blu_on.delta.k1      <= abs(blu_on.k1 - blu_on.k1);
        blu_on.delta.k2      <= abs(blu_on.k1 - blu_on.k2);
        blu_on.delta.k3      <= abs(blu_on.k1 - blu_on.k3);
        blu_on.delta.k4      <= abs(blu_on.k1 - blu_on.k4);
        blu_on.delta.k5      <= abs(blu_on.k1 - blu_on.k5);
        blu_on.delta.k6      <= abs(blu_on.k1 - blu_on.k6);
        blu_on.delta.k7      <= abs(blu_on.k1 - blu_on.k7);
        blu_on.delta.k8      <= abs(blu_on.k1 - blu_on.k8);
        blu_on.delta.k9      <= abs(blu_on.k1 - blu_on.k9);
        blu_on.delta.k10     <= abs(blu_on.k1 - blu_on.k10);
        blu_on.delta.k11     <= abs(blu_on.k1 - blu_on.k11);
        blu_on.delta.k12     <= abs(blu_on.k1 - blu_on.k12);
        blu_on.delta.k13     <= abs(blu_on.k1 - blu_on.k13);
        blu_on.delta.k14     <= abs(blu_on.k1 - blu_on.k14);
        blu_on.delta.k15     <= abs(blu_on.k1 - blu_on.k15);
        blu_on.delta.k16     <= abs(blu_on.k1 - blu_on.k16);
        --========================================================================================
        red_on.delta_1syn    <= red_on.delta;
        red_on.delta_2syn    <= red_on.delta_1syn;
        --========================================================================================
        gre_on.delta_1syn    <= gre_on.delta;
        gre_on.delta_2syn    <= gre_on.delta_1syn;
        --========================================================================================
        blu_on.delta_1syn    <= blu_on.delta;
        blu_on.delta_2syn    <= blu_on.delta_1syn;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        red_on.delta_sum_0.k1             <= red_on.k1  + red_on.k1;
        red_on.delta_sum_0.k2             <= red_on.k2  + red_on.k2;
        red_on.delta_sum_0.k3             <= red_on.k3  + red_on.k3;
        red_on.delta_sum_0.k4             <= red_on.k4  + red_on.k4;
        red_on.delta_sum_0.k5             <= red_on.k5  + red_on.k5;
        red_on.delta_sum_0.k6             <= red_on.k6  + red_on.k6;
        red_on.delta_sum_0.k7             <= red_on.k7  + red_on.k7;
        red_on.delta_sum_0.k8             <= red_on.k8  + red_on.k8;
        red_on.delta_sum_0.k9             <= red_on.k9  + red_on.k9;
        red_on.delta_sum_0.k10            <= red_on.k10 + red_on.k10;
        red_on.delta_sum_0.k11            <= red_on.k11 + red_on.k11;
        red_on.delta_sum_0.k12            <= red_on.k12 + red_on.k12;
        red_on.delta_sum_0.k13            <= red_on.k13 + red_on.k13;
        red_on.delta_sum_0.k14            <= red_on.k14 + red_on.k14;
        red_on.delta_sum_0.k15            <= red_on.k15 + red_on.k15;
        red_on.delta_sum_0.k16            <= red_on.k16 + red_on.k16;
        red_on.delta_sum_prod_0.k1        <= red_on.delta_sum_0.k1  * point_five;
        red_on.delta_sum_prod_0.k2        <= red_on.delta_sum_0.k2  * point_five;
        red_on.delta_sum_prod_0.k3        <= red_on.delta_sum_0.k3  * point_five;
        red_on.delta_sum_prod_0.k4        <= red_on.delta_sum_0.k4  * point_five;
        red_on.delta_sum_prod_0.k5        <= red_on.delta_sum_0.k5  * point_five;
        red_on.delta_sum_prod_0.k6        <= red_on.delta_sum_0.k6  * point_five;
        red_on.delta_sum_prod_0.k7        <= red_on.delta_sum_0.k7  * point_five;
        red_on.delta_sum_prod_0.k8        <= red_on.delta_sum_0.k8  * point_five;
        red_on.delta_sum_prod_0.k9        <= red_on.delta_sum_0.k9  * point_five;
        red_on.delta_sum_prod_0.k10       <= red_on.delta_sum_0.k10 * point_five;
        red_on.delta_sum_prod_0.k11       <= red_on.delta_sum_0.k11 * point_five;
        red_on.delta_sum_prod_0.k12       <= red_on.delta_sum_0.k12 * point_five;
        red_on.delta_sum_prod_0.k13       <= red_on.delta_sum_0.k13 * point_five;
        red_on.delta_sum_prod_0.k14       <= red_on.delta_sum_0.k14 * point_five;
        red_on.delta_sum_prod_0.k15       <= red_on.delta_sum_0.k15 * point_five;
        red_on.delta_sum_prod_0.k16       <= red_on.delta_sum_0.k16 * point_five;
        red_on.delta_sum_1.k1             <= resize(red_on.k1, red_on.delta_sum_1.k1);
        red_on.delta_sum_1.k2             <= resize(red_on.k2, red_on.delta_sum_1.k2);
        red_on.delta_sum_1.k3             <= resize(red_on.k3, red_on.delta_sum_1.k3);
        red_on.delta_sum_1.k4             <= resize(red_on.k4, red_on.delta_sum_1.k4);
        red_on.delta_sum_1.k5             <= resize(red_on.k5, red_on.delta_sum_1.k5);
        red_on.delta_sum_1.k6             <= resize(red_on.k6, red_on.delta_sum_1.k6);
        red_on.delta_sum_1.k7             <= resize(red_on.k7, red_on.delta_sum_1.k7);
        red_on.delta_sum_1.k8             <= resize(red_on.k8, red_on.delta_sum_1.k8);
        red_on.delta_sum_1.k9             <= resize(red_on.k9, red_on.delta_sum_1.k9);
        red_on.delta_sum_1.k10            <= resize(red_on.k10,red_on.delta_sum_1.k10);
        red_on.delta_sum_1.k11            <= resize(red_on.k11,red_on.delta_sum_1.k11);
        red_on.delta_sum_1.k12            <= resize(red_on.k12,red_on.delta_sum_1.k12);
        red_on.delta_sum_1.k13            <= resize(red_on.k13,red_on.delta_sum_1.k13);
        red_on.delta_sum_1.k14            <= resize(red_on.k14,red_on.delta_sum_1.k14);
        red_on.delta_sum_1.k15            <= resize(red_on.k15,red_on.delta_sum_1.k15);
        red_on.delta_sum_1.k16            <= resize(red_on.k16,red_on.delta_sum_1.k16);
        red_on.delta_sum_2               <= red_on.delta_sum_1;
        red_on.delta_sum_3               <= red_on.delta_sum_2;
        red_on.delta_sum_prod_1.k1       <= resize(red_on.delta_sum_prod_0.k1,red_on.delta_sum_prod_1.k1);
        red_on.delta_sum_prod_1.k2       <= resize(red_on.delta_sum_prod_0.k2,red_on.delta_sum_prod_1.k2);
        red_on.delta_sum_prod_1.k3       <= resize(red_on.delta_sum_prod_0.k3,red_on.delta_sum_prod_1.k3);
        red_on.delta_sum_prod_1.k4       <= resize(red_on.delta_sum_prod_0.k4,red_on.delta_sum_prod_1.k4);
        red_on.delta_sum_prod_1.k5       <= resize(red_on.delta_sum_prod_0.k5,red_on.delta_sum_prod_1.k5);
        red_on.delta_sum_prod_1.k6       <= resize(red_on.delta_sum_prod_0.k6,red_on.delta_sum_prod_1.k6);
        red_on.delta_sum_prod_1.k7       <= resize(red_on.delta_sum_prod_0.k7,red_on.delta_sum_prod_1.k7);
        red_on.delta_sum_prod_1.k8       <= resize(red_on.delta_sum_prod_0.k8,red_on.delta_sum_prod_1.k8);
        red_on.delta_sum_prod_1.k9       <= resize(red_on.delta_sum_prod_0.k9,red_on.delta_sum_prod_1.k9);
        red_on.delta_sum_prod_1.k10      <= resize(red_on.delta_sum_prod_0.k10,red_on.delta_sum_prod_1.k10);
        red_on.delta_sum_prod_1.k11      <= resize(red_on.delta_sum_prod_0.k11,red_on.delta_sum_prod_1.k11);
        red_on.delta_sum_prod_1.k12      <= resize(red_on.delta_sum_prod_0.k12,red_on.delta_sum_prod_1.k12);
        red_on.delta_sum_prod_1.k13      <= resize(red_on.delta_sum_prod_0.k13,red_on.delta_sum_prod_1.k13);
        red_on.delta_sum_prod_1.k14      <= resize(red_on.delta_sum_prod_0.k14,red_on.delta_sum_prod_1.k14);
        red_on.delta_sum_prod_1.k15      <= resize(red_on.delta_sum_prod_0.k15,red_on.delta_sum_prod_1.k15);
        red_on.delta_sum_prod_1.k16      <= resize(red_on.delta_sum_prod_0.k16,red_on.delta_sum_prod_1.k16);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        gre_on.delta_sum_0.k1             <= gre_on.k1  + gre_on.k1;
        gre_on.delta_sum_0.k2             <= gre_on.k2  + gre_on.k2;
        gre_on.delta_sum_0.k3             <= gre_on.k3  + gre_on.k3;
        gre_on.delta_sum_0.k4             <= gre_on.k4  + gre_on.k4;
        gre_on.delta_sum_0.k5             <= gre_on.k5  + gre_on.k5;
        gre_on.delta_sum_0.k6             <= gre_on.k6  + gre_on.k6;
        gre_on.delta_sum_0.k7             <= gre_on.k7  + gre_on.k7;
        gre_on.delta_sum_0.k8             <= gre_on.k8  + gre_on.k8;
        gre_on.delta_sum_0.k9             <= gre_on.k9  + gre_on.k9;
        gre_on.delta_sum_0.k10            <= gre_on.k10 + gre_on.k10;
        gre_on.delta_sum_0.k11            <= gre_on.k11 + gre_on.k11;
        gre_on.delta_sum_0.k12            <= gre_on.k12 + gre_on.k12;
        gre_on.delta_sum_0.k13            <= gre_on.k13 + gre_on.k13;
        gre_on.delta_sum_0.k14            <= gre_on.k14 + gre_on.k14;
        gre_on.delta_sum_0.k15            <= gre_on.k15 + gre_on.k15;
        gre_on.delta_sum_0.k16            <= gre_on.k16 + gre_on.k16;
        gre_on.delta_sum_prod_0.k1        <= gre_on.delta_sum_0.k1  * point_five;
        gre_on.delta_sum_prod_0.k2        <= gre_on.delta_sum_0.k2  * point_five;
        gre_on.delta_sum_prod_0.k3        <= gre_on.delta_sum_0.k3  * point_five;
        gre_on.delta_sum_prod_0.k4        <= gre_on.delta_sum_0.k4  * point_five;
        gre_on.delta_sum_prod_0.k5        <= gre_on.delta_sum_0.k5  * point_five;
        gre_on.delta_sum_prod_0.k6        <= gre_on.delta_sum_0.k6  * point_five;
        gre_on.delta_sum_prod_0.k7        <= gre_on.delta_sum_0.k7  * point_five;
        gre_on.delta_sum_prod_0.k8        <= gre_on.delta_sum_0.k8  * point_five;
        gre_on.delta_sum_prod_0.k9        <= gre_on.delta_sum_0.k9  * point_five;
        gre_on.delta_sum_prod_0.k10       <= gre_on.delta_sum_0.k10 * point_five;
        gre_on.delta_sum_prod_0.k11       <= gre_on.delta_sum_0.k11 * point_five;
        gre_on.delta_sum_prod_0.k12       <= gre_on.delta_sum_0.k12 * point_five;
        gre_on.delta_sum_prod_0.k13       <= gre_on.delta_sum_0.k13 * point_five;
        gre_on.delta_sum_prod_0.k14       <= gre_on.delta_sum_0.k14 * point_five;
        gre_on.delta_sum_prod_0.k15       <= gre_on.delta_sum_0.k15 * point_five;
        gre_on.delta_sum_prod_0.k16       <= gre_on.delta_sum_0.k16 * point_five;
        gre_on.delta_sum_1.k1             <= resize(gre_on.k1, gre_on.delta_sum_1.k1);
        gre_on.delta_sum_1.k2             <= resize(gre_on.k2, gre_on.delta_sum_1.k2);
        gre_on.delta_sum_1.k3             <= resize(gre_on.k3, gre_on.delta_sum_1.k3);
        gre_on.delta_sum_1.k4             <= resize(gre_on.k4, gre_on.delta_sum_1.k4);
        gre_on.delta_sum_1.k5             <= resize(gre_on.k5, gre_on.delta_sum_1.k5);
        gre_on.delta_sum_1.k6             <= resize(gre_on.k6, gre_on.delta_sum_1.k6);
        gre_on.delta_sum_1.k7             <= resize(gre_on.k7, gre_on.delta_sum_1.k7);
        gre_on.delta_sum_1.k8             <= resize(gre_on.k8, gre_on.delta_sum_1.k8);
        gre_on.delta_sum_1.k9             <= resize(gre_on.k9, gre_on.delta_sum_1.k9);
        gre_on.delta_sum_1.k10            <= resize(gre_on.k10,gre_on.delta_sum_1.k10);
        gre_on.delta_sum_1.k11            <= resize(gre_on.k11,gre_on.delta_sum_1.k11);
        gre_on.delta_sum_1.k12            <= resize(gre_on.k12,gre_on.delta_sum_1.k12);
        gre_on.delta_sum_1.k13            <= resize(gre_on.k13,gre_on.delta_sum_1.k13);
        gre_on.delta_sum_1.k14            <= resize(gre_on.k14,gre_on.delta_sum_1.k14);
        gre_on.delta_sum_1.k15            <= resize(gre_on.k15,gre_on.delta_sum_1.k15);
        gre_on.delta_sum_1.k16            <= resize(gre_on.k16,gre_on.delta_sum_1.k16);
        gre_on.delta_sum_2               <= gre_on.delta_sum_1;
        gre_on.delta_sum_3               <= gre_on.delta_sum_2;
        gre_on.delta_sum_prod_1.k1       <= resize(gre_on.delta_sum_prod_0.k1,gre_on.delta_sum_prod_1.k1);
        gre_on.delta_sum_prod_1.k2       <= resize(gre_on.delta_sum_prod_0.k2,gre_on.delta_sum_prod_1.k2);
        gre_on.delta_sum_prod_1.k3       <= resize(gre_on.delta_sum_prod_0.k3,gre_on.delta_sum_prod_1.k3);
        gre_on.delta_sum_prod_1.k4       <= resize(gre_on.delta_sum_prod_0.k4,gre_on.delta_sum_prod_1.k4);
        gre_on.delta_sum_prod_1.k5       <= resize(gre_on.delta_sum_prod_0.k5,gre_on.delta_sum_prod_1.k5);
        gre_on.delta_sum_prod_1.k6       <= resize(gre_on.delta_sum_prod_0.k6,gre_on.delta_sum_prod_1.k6);
        gre_on.delta_sum_prod_1.k7       <= resize(gre_on.delta_sum_prod_0.k7,gre_on.delta_sum_prod_1.k7);
        gre_on.delta_sum_prod_1.k8       <= resize(gre_on.delta_sum_prod_0.k8,gre_on.delta_sum_prod_1.k8);
        gre_on.delta_sum_prod_1.k9       <= resize(gre_on.delta_sum_prod_0.k9,gre_on.delta_sum_prod_1.k9);
        gre_on.delta_sum_prod_1.k10      <= resize(gre_on.delta_sum_prod_0.k10,gre_on.delta_sum_prod_1.k10);
        gre_on.delta_sum_prod_1.k11      <= resize(gre_on.delta_sum_prod_0.k11,gre_on.delta_sum_prod_1.k11);
        gre_on.delta_sum_prod_1.k12      <= resize(gre_on.delta_sum_prod_0.k12,gre_on.delta_sum_prod_1.k12);
        gre_on.delta_sum_prod_1.k13      <= resize(gre_on.delta_sum_prod_0.k13,gre_on.delta_sum_prod_1.k13);
        gre_on.delta_sum_prod_1.k14      <= resize(gre_on.delta_sum_prod_0.k14,gre_on.delta_sum_prod_1.k14);
        gre_on.delta_sum_prod_1.k15      <= resize(gre_on.delta_sum_prod_0.k15,gre_on.delta_sum_prod_1.k15);
        gre_on.delta_sum_prod_1.k16      <= resize(gre_on.delta_sum_prod_0.k16,gre_on.delta_sum_prod_1.k16);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        blu_on.delta_sum_0.k1             <= blu_on.k1  + blu_on.k1;
        blu_on.delta_sum_0.k2             <= blu_on.k2  + blu_on.k2;
        blu_on.delta_sum_0.k3             <= blu_on.k3  + blu_on.k3;
        blu_on.delta_sum_0.k4             <= blu_on.k4  + blu_on.k4;
        blu_on.delta_sum_0.k5             <= blu_on.k5  + blu_on.k5;
        blu_on.delta_sum_0.k6             <= blu_on.k6  + blu_on.k6;
        blu_on.delta_sum_0.k7             <= blu_on.k7  + blu_on.k7;
        blu_on.delta_sum_0.k8             <= blu_on.k8  + blu_on.k8;
        blu_on.delta_sum_0.k9             <= blu_on.k9  + blu_on.k9;
        blu_on.delta_sum_0.k10            <= blu_on.k10 + blu_on.k10;
        blu_on.delta_sum_0.k11            <= blu_on.k11 + blu_on.k11;
        blu_on.delta_sum_0.k12            <= blu_on.k12 + blu_on.k12;
        blu_on.delta_sum_0.k13            <= blu_on.k13 + blu_on.k13;
        blu_on.delta_sum_0.k14            <= blu_on.k14 + blu_on.k14;
        blu_on.delta_sum_0.k15            <= blu_on.k15 + blu_on.k15;
        blu_on.delta_sum_0.k16            <= blu_on.k16 + blu_on.k16;
        blu_on.delta_sum_prod_0.k1        <= blu_on.delta_sum_0.k1  * point_five;
        blu_on.delta_sum_prod_0.k2        <= blu_on.delta_sum_0.k2  * point_five;
        blu_on.delta_sum_prod_0.k3        <= blu_on.delta_sum_0.k3  * point_five;
        blu_on.delta_sum_prod_0.k4        <= blu_on.delta_sum_0.k4  * point_five;
        blu_on.delta_sum_prod_0.k5        <= blu_on.delta_sum_0.k5  * point_five;
        blu_on.delta_sum_prod_0.k6        <= blu_on.delta_sum_0.k6  * point_five;
        blu_on.delta_sum_prod_0.k7        <= blu_on.delta_sum_0.k7  * point_five;
        blu_on.delta_sum_prod_0.k8        <= blu_on.delta_sum_0.k8  * point_five;
        blu_on.delta_sum_prod_0.k9        <= blu_on.delta_sum_0.k9  * point_five;
        blu_on.delta_sum_prod_0.k10       <= blu_on.delta_sum_0.k10 * point_five;
        blu_on.delta_sum_prod_0.k11       <= blu_on.delta_sum_0.k11 * point_five;
        blu_on.delta_sum_prod_0.k12       <= blu_on.delta_sum_0.k12 * point_five;
        blu_on.delta_sum_prod_0.k13       <= blu_on.delta_sum_0.k13 * point_five;
        blu_on.delta_sum_prod_0.k14       <= blu_on.delta_sum_0.k14 * point_five;
        blu_on.delta_sum_prod_0.k15       <= blu_on.delta_sum_0.k15 * point_five;
        blu_on.delta_sum_prod_0.k16       <= blu_on.delta_sum_0.k16 * point_five;
        blu_on.delta_sum_1.k1             <= resize(blu_on.k1, blu_on.delta_sum_1.k1);
        blu_on.delta_sum_1.k2             <= resize(blu_on.k2, blu_on.delta_sum_1.k2);
        blu_on.delta_sum_1.k3             <= resize(blu_on.k3, blu_on.delta_sum_1.k3);
        blu_on.delta_sum_1.k4             <= resize(blu_on.k4, blu_on.delta_sum_1.k4);
        blu_on.delta_sum_1.k5             <= resize(blu_on.k5, blu_on.delta_sum_1.k5);
        blu_on.delta_sum_1.k6             <= resize(blu_on.k6, blu_on.delta_sum_1.k6);
        blu_on.delta_sum_1.k7             <= resize(blu_on.k7, blu_on.delta_sum_1.k7);
        blu_on.delta_sum_1.k8             <= resize(blu_on.k8, blu_on.delta_sum_1.k8);
        blu_on.delta_sum_1.k9             <= resize(blu_on.k9, blu_on.delta_sum_1.k9);
        blu_on.delta_sum_1.k10            <= resize(blu_on.k10,blu_on.delta_sum_1.k10);
        blu_on.delta_sum_1.k11            <= resize(blu_on.k11,blu_on.delta_sum_1.k11);
        blu_on.delta_sum_1.k12            <= resize(blu_on.k12,blu_on.delta_sum_1.k12);
        blu_on.delta_sum_1.k13            <= resize(blu_on.k13,blu_on.delta_sum_1.k13);
        blu_on.delta_sum_1.k14            <= resize(blu_on.k14,blu_on.delta_sum_1.k14);
        blu_on.delta_sum_1.k15            <= resize(blu_on.k15,blu_on.delta_sum_1.k15);
        blu_on.delta_sum_1.k16            <= resize(blu_on.k16,blu_on.delta_sum_1.k16);
        blu_on.delta_sum_2                <= blu_on.delta_sum_1;
        blu_on.delta_sum_3                <= blu_on.delta_sum_2;
        blu_on.delta_sum_prod_1.k1        <= resize(blu_on.delta_sum_prod_0.k1,blu_on.delta_sum_prod_1.k1);
        blu_on.delta_sum_prod_1.k2        <= resize(blu_on.delta_sum_prod_0.k2,blu_on.delta_sum_prod_1.k2);
        blu_on.delta_sum_prod_1.k3        <= resize(blu_on.delta_sum_prod_0.k3,blu_on.delta_sum_prod_1.k3);
        blu_on.delta_sum_prod_1.k4        <= resize(blu_on.delta_sum_prod_0.k4,blu_on.delta_sum_prod_1.k4);
        blu_on.delta_sum_prod_1.k5        <= resize(blu_on.delta_sum_prod_0.k5,blu_on.delta_sum_prod_1.k5);
        blu_on.delta_sum_prod_1.k6        <= resize(blu_on.delta_sum_prod_0.k6,blu_on.delta_sum_prod_1.k6);
        blu_on.delta_sum_prod_1.k7        <= resize(blu_on.delta_sum_prod_0.k7,blu_on.delta_sum_prod_1.k7);
        blu_on.delta_sum_prod_1.k8        <= resize(blu_on.delta_sum_prod_0.k8,blu_on.delta_sum_prod_1.k8);
        blu_on.delta_sum_prod_1.k9        <= resize(blu_on.delta_sum_prod_0.k9,blu_on.delta_sum_prod_1.k9);
        blu_on.delta_sum_prod_1.k10       <= resize(blu_on.delta_sum_prod_0.k10,blu_on.delta_sum_prod_1.k10);
        blu_on.delta_sum_prod_1.k11       <= resize(blu_on.delta_sum_prod_0.k11,blu_on.delta_sum_prod_1.k11);
        blu_on.delta_sum_prod_1.k12       <= resize(blu_on.delta_sum_prod_0.k12,blu_on.delta_sum_prod_1.k12);
        blu_on.delta_sum_prod_1.k13       <= resize(blu_on.delta_sum_prod_0.k13,blu_on.delta_sum_prod_1.k13);
        blu_on.delta_sum_prod_1.k14       <= resize(blu_on.delta_sum_prod_0.k14,blu_on.delta_sum_prod_1.k14);
        blu_on.delta_sum_prod_1.k15       <= resize(blu_on.delta_sum_prod_0.k15,blu_on.delta_sum_prod_1.k15);
        blu_on.delta_sum_prod_1.k16       <= resize(blu_on.delta_sum_prod_0.k16,blu_on.delta_sum_prod_1.k16);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        red_detect.k_syn_1  <= red_detect.k;
        red_detect.k_syn_2  <= red_detect.k_syn_1;
        red_detect.k_syn_3  <= red_detect.k_syn_2;
        red_detect.k_syn_4  <= red_detect.k_syn_3;
        red_detect.k_syn_5  <= red_detect.k_syn_4;
        red_detect.k_syn_6  <= red_detect.k_syn_5;
        red_detect.k_syn_7  <= red_detect.k_syn_6;
        red_detect.k_syn_8  <= red_detect.k_syn_7;
        red_detect.k_syn_9  <= red_detect.k_syn_8;
        red_detect.k_syn_10 <= red_detect.k_syn_9;
        red_detect.k_syn_11 <= red_detect.k_syn_10;
        red_detect.k_syn_12 <= red_detect.k_syn_11;
        gre_detect.k_syn_1  <= gre_detect.k;
        gre_detect.k_syn_2  <= gre_detect.k_syn_1;
        gre_detect.k_syn_3  <= gre_detect.k_syn_2;
        gre_detect.k_syn_4  <= gre_detect.k_syn_3;
        gre_detect.k_syn_5  <= gre_detect.k_syn_4;
        gre_detect.k_syn_6  <= gre_detect.k_syn_5;
        gre_detect.k_syn_7  <= gre_detect.k_syn_6;
        gre_detect.k_syn_8  <= gre_detect.k_syn_7;
        gre_detect.k_syn_9  <= gre_detect.k_syn_8;
        gre_detect.k_syn_10 <= gre_detect.k_syn_9;
        gre_detect.k_syn_11 <= gre_detect.k_syn_10;
        gre_detect.k_syn_12 <= gre_detect.k_syn_11;
        blu_detect.k_syn_1  <= blu_detect.k;
        blu_detect.k_syn_2  <= blu_detect.k_syn_1;
        blu_detect.k_syn_3  <= blu_detect.k_syn_2;
        blu_detect.k_syn_4  <= blu_detect.k_syn_3;
        blu_detect.k_syn_5  <= blu_detect.k_syn_4;
        blu_detect.k_syn_6  <= blu_detect.k_syn_5;
        blu_detect.k_syn_7  <= blu_detect.k_syn_6;
        blu_detect.k_syn_8  <= blu_detect.k_syn_7;
        blu_detect.k_syn_9  <= blu_detect.k_syn_8;
        blu_detect.k_syn_10 <= blu_detect.k_syn_9;
        blu_detect.k_syn_11 <= blu_detect.k_syn_10;
        blu_detect.k_syn_12 <= blu_detect.k_syn_11;
    end if;
end process;
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
       -- ∆P|xy| <- TH {set [Pn(xy)+Pn+1(xy)]}
        if(red_on.delta_2syn.k1 <= pixel_threshold_2) then
            red_select.sumprod_2.k1  <= red_on.delta_sum_prod_1.k1;
            red_detect.k(1).n  <= 1;
        else
            red_detect.k(1).n  <= 0;
            red_select.sumprod_2.k1  <= resize(red_on.delta_sum_3.k1,red_select.sumprod_2.k1);
        end if;
        if(red_on.delta_2syn.k2 <= pixel_threshold_2) then
            red_select.sumprod_2.k2  <= red_on.delta_sum_prod_1.k2;
            red_detect.k(2).n  <= 2;
        else
            red_detect.k(2).n  <= 0;
            red_select.sumprod_2.k2  <= resize(red_on.delta_sum_3.k2,red_select.sumprod_2.k2);
        end if;
        if(red_on.delta_2syn.k3 <= pixel_threshold_2) then
            red_select.sumprod_2.k3  <= red_on.delta_sum_prod_1.k3;
            red_detect.k(3).n  <= 3;
        else
            red_detect.k(3).n  <= 0;
            red_select.sumprod_2.k3  <= resize(red_on.delta_sum_3.k3,red_select.sumprod_2.k3);
        end if;
        if(red_on.delta_2syn.k4 <= pixel_threshold_2) then
            red_select.sumprod_2.k4  <= red_on.delta_sum_prod_1.k4;
            red_detect.k(4).n  <= 4;
        else
            red_detect.k(4).n  <= 0;
            red_select.sumprod_2.k4  <= resize(red_on.delta_sum_3.k4,red_select.sumprod_2.k4);
        end if;
        if(red_on.delta_2syn.k5 <= pixel_threshold_2) then
            red_select.sumprod_2.k5  <= red_on.delta_sum_prod_1.k5;
            red_detect.k(5).n  <= 5;
        else
            red_detect.k(5).n  <= 0;
            red_select.sumprod_2.k5  <= resize(red_on.delta_sum_3.k5,red_select.sumprod_2.k5);
        end if;
        if(red_on.delta_2syn.k6 <= pixel_threshold_2) then
            red_select.sumprod_2.k6  <= red_on.delta_sum_prod_1.k6;
            red_detect.k(6).n  <= 6;
        else
            red_detect.k(6).n  <= 0;
            red_select.sumprod_2.k6  <= resize(red_on.delta_sum_3.k6,red_select.sumprod_2.k6);
        end if;
        if(red_on.delta_2syn.k7 <= pixel_threshold_2) then
            red_select.sumprod_2.k7  <= red_on.delta_sum_prod_1.k7;
            red_detect.k(7).n  <= 7;
        else
            red_detect.k(7).n  <= 0;
            red_select.sumprod_2.k7  <= resize(red_on.delta_sum_3.k7,red_select.sumprod_2.k7);
        end if;
        if(red_on.delta_2syn.k8 <= pixel_threshold_2) then
            red_select.sumprod_2.k8  <= red_on.delta_sum_prod_1.k8;
            red_detect.k(8).n  <= 8;
        else
            red_detect.k(8).n  <= 0;
            red_select.sumprod_2.k8  <= resize(red_on.delta_sum_3.k8,red_select.sumprod_2.k8);
        end if;
        if(red_on.delta_2syn.k9 <= pixel_threshold_2) then
            red_select.sumprod_2.k9  <= red_on.delta_sum_prod_1.k9;
            red_detect.k(9).n  <= 9;
        else
            red_detect.k(9).n  <= 0;
            red_select.sumprod_2.k9  <= resize(red_on.delta_sum_3.k9,red_select.sumprod_2.k9);
        end if;
        if(red_on.delta_2syn.k10 <= pixel_threshold_2) then
            red_select.sumprod_2.k10  <= red_on.delta_sum_prod_1.k10;
            red_detect.k(10).n  <= 10;
        else
            red_detect.k(10).n  <= 0;
            red_select.sumprod_2.k10  <= resize(red_on.delta_sum_3.k10,red_select.sumprod_2.k10);
        end if;
        if(red_on.delta_2syn.k11 <= pixel_threshold_2) then
            red_select.sumprod_2.k11  <= red_on.delta_sum_prod_1.k11;
            red_detect.k(11).n  <= 11;
        else
            red_detect.k(11).n  <= 0;
            red_select.sumprod_2.k11  <= resize(red_on.delta_sum_3.k11,red_select.sumprod_2.k11);
        end if;
        if(red_on.delta_2syn.k12 <= pixel_threshold_2) then
            red_select.sumprod_2.k12  <= red_on.delta_sum_prod_1.k12;
            red_detect.k(12).n  <= 12;
        else
            red_detect.k(12).n  <= 0;
            red_select.sumprod_2.k12  <= resize(red_on.delta_sum_3.k12,red_select.sumprod_2.k12);
        end if;
        if(red_on.delta_2syn.k13 <= pixel_threshold_2) then
            red_select.sumprod_2.k13  <= red_on.delta_sum_prod_1.k13;
            red_detect.k(13).n  <= 13;
        else
            red_detect.k(13).n  <= 0;
            red_select.sumprod_2.k13  <= resize(red_on.delta_sum_3.k13,red_select.sumprod_2.k13);
        end if;
        if(red_on.delta_2syn.k14 <= pixel_threshold_2) then
            red_select.sumprod_2.k14  <= red_on.delta_sum_prod_1.k14;
            red_detect.k(14).n  <= 14;
        else
            red_detect.k(14).n  <= 0;
            red_select.sumprod_2.k14  <= resize(red_on.delta_sum_3.k14,red_select.sumprod_2.k14);
        end if;
        if(red_on.delta_2syn.k15 <= pixel_threshold_2) then
            red_select.sumprod_2.k15  <= red_on.delta_sum_prod_1.k15;
            red_detect.k(15).n  <= 15;
        else
            red_detect.k(15).n  <= 0;
            red_select.sumprod_2.k15  <= resize(red_on.delta_sum_3.k15,red_select.sumprod_2.k15);
        end if;
        if(red_on.delta_2syn.k16 <= pixel_threshold_2) then
            red_select.sumprod_2.k16  <= red_on.delta_sum_prod_1.k16;
            red_detect.k(16).n  <= 16;
        else
            red_detect.k(16).n  <= 0;
            red_select.sumprod_2.k16  <= resize(red_on.delta_sum_3.k16,red_select.sumprod_2.k16);
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
       -- ∆P|xy| <- TH {set [Pn(xy)+Pn+1(xy)]}
        if(gre_on.delta_2syn.k1 <= pixel_threshold_2) then
            gre_select.sumprod_2.k1  <= gre_on.delta_sum_prod_1.k1;
            gre_detect.k(1).n  <= 1;
        else
            gre_detect.k(1).n  <= 0;
            gre_select.sumprod_2.k1  <= resize(gre_on.delta_sum_3.k1,gre_select.sumprod_2.k1);
        end if;
        if(gre_on.delta_2syn.k2 <= pixel_threshold_2) then
            gre_select.sumprod_2.k2  <= gre_on.delta_sum_prod_1.k2;
            gre_detect.k(2).n  <= 2;
        else
            gre_detect.k(2).n  <= 0;
            gre_select.sumprod_2.k2  <= resize(gre_on.delta_sum_3.k2,gre_select.sumprod_2.k2);
        end if;
        if(gre_on.delta_2syn.k3 <= pixel_threshold_2) then
            gre_select.sumprod_2.k3  <= gre_on.delta_sum_prod_1.k3;
            gre_detect.k(3).n  <= 3;
        else
            gre_detect.k(3).n  <= 0;
            gre_select.sumprod_2.k3       <= resize(gre_on.delta_sum_3.k3,gre_select.sumprod_2.k3);
        end if;
        if(gre_on.delta_2syn.k4 <= pixel_threshold_2) then
            gre_select.sumprod_2.k4  <= gre_on.delta_sum_prod_1.k4;
            gre_detect.k(4).n  <= 4;
        else
            gre_detect.k(4).n  <= 0;
            gre_select.sumprod_2.k4       <= resize(gre_on.delta_sum_3.k4,gre_select.sumprod_2.k4);
        end if;
        if(gre_on.delta_2syn.k5 <= pixel_threshold_2) then
            gre_select.sumprod_2.k5  <= gre_on.delta_sum_prod_1.k5;
            gre_detect.k(5).n  <= 5;
        else
            gre_detect.k(5).n  <= 0;
            gre_select.sumprod_2.k5       <= resize(gre_on.delta_sum_3.k5,gre_select.sumprod_2.k5);
        end if;
        if(gre_on.delta_2syn.k6 <= pixel_threshold_2) then
            gre_select.sumprod_2.k6  <= gre_on.delta_sum_prod_1.k6;
            gre_detect.k(6).n  <= 6;
        else
            gre_detect.k(6).n  <= 0;
            gre_select.sumprod_2.k6       <= resize(gre_on.delta_sum_3.k6,gre_select.sumprod_2.k6);
        end if;
        if(gre_on.delta_2syn.k7 <= pixel_threshold_2) then
            gre_select.sumprod_2.k7  <= gre_on.delta_sum_prod_1.k7;
            gre_detect.k(7).n  <= 7;
        else
            gre_detect.k(7).n  <= 0;
            gre_select.sumprod_2.k7       <= resize(gre_on.delta_sum_3.k7,gre_select.sumprod_2.k7);
        end if;
        if(gre_on.delta_2syn.k8 <= pixel_threshold_2) then
            gre_select.sumprod_2.k8  <= gre_on.delta_sum_prod_1.k8;
            gre_detect.k(8).n  <= 8;
        else
            gre_detect.k(8).n  <= 0;
            gre_select.sumprod_2.k8       <= resize(gre_on.delta_sum_3.k8,gre_select.sumprod_2.k8);
        end if;
        if(gre_on.delta_2syn.k9 <= pixel_threshold_2) then
            gre_select.sumprod_2.k9  <= gre_on.delta_sum_prod_1.k9;
            gre_detect.k(9).n  <= 9;
        else
            gre_detect.k(9).n  <= 0;
            gre_select.sumprod_2.k9       <= resize(gre_on.delta_sum_3.k9,gre_select.sumprod_2.k9);
        end if;
        if(gre_on.delta_2syn.k10 <= pixel_threshold_2) then
            gre_select.sumprod_2.k10  <= gre_on.delta_sum_prod_1.k10;
            gre_detect.k(10).n  <= 10;
        else
            gre_detect.k(10).n  <= 0;
            gre_select.sumprod_2.k10       <= resize(gre_on.delta_sum_3.k10,gre_select.sumprod_2.k10);
        end if;
        if(gre_on.delta_2syn.k11 <= pixel_threshold_2) then
            gre_select.sumprod_2.k11  <= gre_on.delta_sum_prod_1.k11;
            gre_detect.k(11).n  <= 11;
        else
            gre_detect.k(11).n  <= 0;
            gre_select.sumprod_2.k11       <= resize(gre_on.delta_sum_3.k11,gre_select.sumprod_2.k11);
        end if;
        if(gre_on.delta_2syn.k12 <= pixel_threshold_2) then
            gre_select.sumprod_2.k12  <= gre_on.delta_sum_prod_1.k12;
            gre_detect.k(12).n  <= 12;
        else
            gre_detect.k(12).n  <= 0;
            gre_select.sumprod_2.k12       <= resize(gre_on.delta_sum_3.k12,gre_select.sumprod_2.k12);
        end if;
        if(gre_on.delta_2syn.k13 <= pixel_threshold_2) then
            gre_select.sumprod_2.k13  <= gre_on.delta_sum_prod_1.k13;
            gre_detect.k(13).n  <= 13;
        else
            gre_detect.k(13).n  <= 0;
            gre_select.sumprod_2.k13       <= resize(gre_on.delta_sum_3.k13,gre_select.sumprod_2.k13);
        end if;
        if(gre_on.delta_2syn.k14 <= pixel_threshold_2) then
            gre_select.sumprod_2.k14  <= gre_on.delta_sum_prod_1.k14;
            gre_detect.k(14).n  <= 14;
        else
            gre_detect.k(14).n  <= 0;
            gre_select.sumprod_2.k14       <= resize(gre_on.delta_sum_3.k14,gre_select.sumprod_2.k14);
        end if;
        if(gre_on.delta_2syn.k15 <= pixel_threshold_2) then
            gre_select.sumprod_2.k15  <= gre_on.delta_sum_prod_1.k15;
            gre_detect.k(15).n  <= 15;
        else
            gre_detect.k(15).n  <= 0;
            gre_select.sumprod_2.k15       <= resize(gre_on.delta_sum_3.k15,gre_select.sumprod_2.k15);
        end if;
        if(gre_on.delta_2syn.k16 <= pixel_threshold_2) then
            gre_select.sumprod_2.k16  <= gre_on.delta_sum_prod_1.k16;
            gre_detect.k(16).n  <= 16;
        else
            gre_detect.k(16).n  <= 0;
            gre_select.sumprod_2.k16       <= resize(gre_on.delta_sum_3.k16,gre_select.sumprod_2.k16);
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
       -- ∆P|xy| <- TH {set [Pn(xy)+Pn+1(xy)]}
        if(blu_on.delta_2syn.k1 <= pixel_threshold_2) then
            blu_select.sumprod_2.k1  <= blu_on.delta_sum_prod_1.k1;
            blu_detect.k(1).n  <= 1;
        else
            blu_detect.k(1).n  <= 0;
            blu_select.sumprod_2.k1  <= resize(blu_on.delta_sum_3.k1,blu_select.sumprod_2.k1);
        end if;
        if(blu_on.delta_2syn.k2 <= pixel_threshold_2) then
            blu_select.sumprod_2.k2  <= blu_on.delta_sum_prod_1.k2;
            blu_detect.k(2).n  <= 2;
        else
            blu_detect.k(2).n  <= 0;
            blu_select.sumprod_2.k2  <= resize(blu_on.delta_sum_3.k2,blu_select.sumprod_2.k2);
        end if;
        if(blu_on.delta_2syn.k3 <= pixel_threshold_2) then
            blu_select.sumprod_2.k3  <= blu_on.delta_sum_prod_1.k3;
            blu_detect.k(3).n  <= 3;
        else
            blu_detect.k(3).n  <= 0;
            blu_select.sumprod_2.k3       <= resize(blu_on.delta_sum_3.k3,blu_select.sumprod_2.k3);
        end if;
        if(blu_on.delta_2syn.k4 <= pixel_threshold_2) then
            blu_select.sumprod_2.k4  <= blu_on.delta_sum_prod_1.k4;
            blu_detect.k(4).n  <= 4;
        else
            blu_detect.k(4).n  <= 0;
            blu_select.sumprod_2.k4       <= resize(blu_on.delta_sum_3.k4,blu_select.sumprod_2.k4);
        end if;
        if(blu_on.delta_2syn.k5 <= pixel_threshold_2) then
            blu_select.sumprod_2.k5  <= blu_on.delta_sum_prod_1.k5;
            blu_detect.k(5).n  <= 5;
        else
            blu_detect.k(5).n  <= 0;
            blu_select.sumprod_2.k5       <= resize(blu_on.delta_sum_3.k5,blu_select.sumprod_2.k5);
        end if;
        if(blu_on.delta_2syn.k6 <= pixel_threshold_2) then
            blu_select.sumprod_2.k6  <= blu_on.delta_sum_prod_1.k6;
            blu_detect.k(6).n  <= 6;
        else
            blu_detect.k(6).n  <= 0;
            blu_select.sumprod_2.k6       <= resize(blu_on.delta_sum_3.k6,blu_select.sumprod_2.k6);
        end if;
        if(blu_on.delta_2syn.k7 <= pixel_threshold_2) then
            blu_select.sumprod_2.k7  <= blu_on.delta_sum_prod_1.k7;
            blu_detect.k(7).n  <= 7;
        else
            blu_detect.k(7).n  <= 0;
            blu_select.sumprod_2.k7       <= resize(blu_on.delta_sum_3.k7,blu_select.sumprod_2.k7);
        end if;
        if(blu_on.delta_2syn.k8 <= pixel_threshold_2) then
            blu_select.sumprod_2.k8  <= blu_on.delta_sum_prod_1.k8;
            blu_detect.k(8).n  <= 8;
        else
            blu_detect.k(8).n  <= 0;
            blu_select.sumprod_2.k8       <= resize(blu_on.delta_sum_3.k8,blu_select.sumprod_2.k8);
        end if;
        if(blu_on.delta_2syn.k9 <= pixel_threshold_2) then
            blu_select.sumprod_2.k9  <= blu_on.delta_sum_prod_1.k9;
            blu_detect.k(9).n  <= 9;
        else
            blu_detect.k(9).n  <= 0;
            blu_select.sumprod_2.k9       <= resize(blu_on.delta_sum_3.k9,blu_select.sumprod_2.k9);
        end if;
        if(blu_on.delta_2syn.k10 <= pixel_threshold_2) then
            blu_select.sumprod_2.k10  <= blu_on.delta_sum_prod_1.k10;
            blu_detect.k(10).n  <= 10;
        else
            blu_detect.k(10).n  <= 0;
            blu_select.sumprod_2.k10       <= resize(blu_on.delta_sum_3.k10,blu_select.sumprod_2.k10);
        end if;
        if(blu_on.delta_2syn.k11 <= pixel_threshold_2) then
            blu_select.sumprod_2.k11  <= blu_on.delta_sum_prod_1.k11;
            blu_detect.k(11).n  <= 11;
        else
            blu_detect.k(11).n  <= 0;
            blu_select.sumprod_2.k11       <= resize(blu_on.delta_sum_3.k11,blu_select.sumprod_2.k11);
        end if;
        if(blu_on.delta_2syn.k12 <= pixel_threshold_2) then
            blu_select.sumprod_2.k12  <= blu_on.delta_sum_prod_1.k12;
            blu_detect.k(12).n  <= 12;
        else
            blu_detect.k(12).n  <= 0;
            blu_select.sumprod_2.k12       <= resize(blu_on.delta_sum_3.k12,blu_select.sumprod_2.k12);
        end if;
        if(blu_on.delta_2syn.k13 <= pixel_threshold_2) then
            blu_select.sumprod_2.k13  <= blu_on.delta_sum_prod_1.k13;
            blu_detect.k(13).n  <= 13;
        else
            blu_detect.k(13).n  <= 0;
            blu_select.sumprod_2.k13       <= resize(blu_on.delta_sum_3.k13,blu_select.sumprod_2.k13);
        end if;
        if(blu_on.delta_2syn.k14 <= pixel_threshold_2) then
            blu_select.sumprod_2.k14  <= blu_on.delta_sum_prod_1.k14;
            blu_detect.k(14).n  <= 14;
        else
            blu_detect.k(14).n  <= 0;
            blu_select.sumprod_2.k14       <= resize(blu_on.delta_sum_3.k14,blu_select.sumprod_2.k14);
        end if;
        if(blu_on.delta_2syn.k15 <= pixel_threshold_2) then
            blu_select.sumprod_2.k15  <= blu_on.delta_sum_prod_1.k15;
            blu_detect.k(15).n  <= 15;
        else
            blu_detect.k(15).n  <= 0;
            blu_select.sumprod_2.k15       <= resize(blu_on.delta_sum_3.k15,blu_select.sumprod_2.k15);
        end if;
        if(blu_on.delta_2syn.k16 <= pixel_threshold_2) then
            blu_select.sumprod_2.k16  <= blu_on.delta_sum_prod_1.k16;
            blu_detect.k(16).n  <= 16;
        else
            blu_detect.k(16).n  <= 0;
            blu_select.sumprod_2.k16       <= resize(blu_on.delta_sum_3.k16,blu_select.sumprod_2.k16);
        end if;
    end if;
end process;
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
            red_select.sumprod_2n       <= red_select.sumprod_2;
            red_select.sumprod_3n       <= red_select.sumprod_2n;
            red_select.sumprod_4n       <= red_select.sumprod_3n;
            red_select.sumprod_5n       <= red_select.sumprod_4n;
            red_select.sumprod_6n       <= red_select.sumprod_5n;
            red_select.sumprod_7n       <= red_select.sumprod_6n;
            red_select.sumprod_8n       <= red_select.sumprod_7n;
            red_select.sumprod_9n       <= red_select.sumprod_8n;
            red_select.sumprod_An.k1    <= to_integer(unsigned(red_select.sumprod_9n.k1)); 
            red_select.sumprod_An.k2    <= to_integer(unsigned(red_select.sumprod_9n.k2)); 
            red_select.sumprod_An.k3    <= to_integer(unsigned(red_select.sumprod_9n.k3)); 
            red_select.sumprod_An.k4    <= to_integer(unsigned(red_select.sumprod_9n.k4)); 
            red_select.sumprod_An.k5    <= to_integer(unsigned(red_select.sumprod_9n.k5)); 
            red_select.sumprod_An.k6    <= to_integer(unsigned(red_select.sumprod_9n.k6)); 
            red_select.sumprod_An.k7    <= to_integer(unsigned(red_select.sumprod_9n.k7)); 
            red_select.sumprod_An.k8    <= to_integer(unsigned(red_select.sumprod_9n.k8)); 
            red_select.sumprod_An.k9    <= to_integer(unsigned(red_select.sumprod_9n.k9)); 
            red_select.sumprod_An.k10   <= to_integer(unsigned(red_select.sumprod_9n.k10));
            red_select.sumprod_An.k11   <= to_integer(unsigned(red_select.sumprod_9n.k11));
            red_select.sumprod_An.k12   <= to_integer(unsigned(red_select.sumprod_9n.k12));
            red_select.sumprod_An.k13   <= to_integer(unsigned(red_select.sumprod_9n.k13));
            red_select.sumprod_An.k14   <= to_integer(unsigned(red_select.sumprod_9n.k14));
            red_select.sumprod_An.k15   <= to_integer(unsigned(red_select.sumprod_9n.k15));
            red_select.sumprod_An.k16   <= to_integer(unsigned(red_select.sumprod_9n.k16));
            red_select.sumprod_Bn       <= red_select.sumprod_An;
            red_select.sumprod_Cn       <= red_select.sumprod_Bn;
            
            red_add.add_12345678  <= (red_select.sumprod_An.k1 + red_select.sumprod_An.k2 + red_select.sumprod_An.k3 + red_select.sumprod_An.k4 + red_select.sumprod_An.k5 + red_select.sumprod_An.k6 + red_select.sumprod_An.k7 + red_select.sumprod_An.k8) / 8;
            red_add.add_9ABCDEFF  <= (red_select.sumprod_An.k9 + red_select.sumprod_An.k10 + red_select.sumprod_An.k11 + red_select.sumprod_An.k12 + red_select.sumprod_An.k13 + red_select.sumprod_An.k14 + red_select.sumprod_An.k15 + red_select.sumprod_An.k16) / 8;
            red_add.add_123456789ABCDEFF  <= (red_add.add_12345678 + red_add.add_9ABCDEFF);
            
            --  1,2
            red_add.add_12              <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2) / 2;
            --  1,5                        
            red_add.add_15              <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k5) / 2;
            -- 1,2,5                       
            red_add.add_125             <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k5) / 3;
            -- 1,2,5,6                     
            red_add.add_1256            <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k5 + red_select.sumprod_Bn.k6) / 3;
            -- 1,2,5,6,3,9                 
            red_add.add_125639          <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k5 + red_select.sumprod_Bn.k6 + red_select.sumprod_Bn.k3 + red_select.sumprod_Bn.k9) / 3;
            -- 1,2,5,6,3,9,4               
            red_add.add_1256394         <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k5 + red_select.sumprod_Bn.k6 + red_select.sumprod_Bn.k3 + red_select.sumprod_Bn.k9 + red_select.sumprod_Bn.k4) / 3;
            -- 1,2,5,6,3,9,13              
            red_add.add_125639_13       <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k5 + red_select.sumprod_Bn.k6 + red_select.sumprod_Bn.k3 + red_select.sumprod_Bn.k9 + red_select.sumprod_Bn.k13) / 3;
            -- 1,2,5,6,3,9,4,13            
            red_add.add_1256394_13      <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k5 + red_select.sumprod_Bn.k6 + red_select.sumprod_Bn.k3 + red_select.sumprod_Bn.k9 + red_select.sumprod_Bn.k4 + red_select.sumprod_Bn.k13) / 3;
            -- 1,2,5,6,3,9,4,13,7,10
            red_add.add_12563947_13_10  <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k5 + red_select.sumprod_Bn.k6 + red_select.sumprod_Bn.k3 + red_select.sumprod_Bn.k9 + red_select.sumprod_Bn.k4 + red_select.sumprod_Bn.k13 + red_select.sumprod_Bn.k7 + red_select.sumprod_Bn.k10) / 3;
            --  1,6
            red_add.add_16              <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k6) / 2;
            --  3,4                        
            red_add.add_34              <= (red_select.sumprod_Bn.k3 + red_select.sumprod_Bn.k4) / 2;
            --  5,6                        
            red_add.add_56              <= (red_select.sumprod_Bn.k5 + red_select.sumprod_Bn.k6) / 2;
            --  7,8                        
            red_add.add_78              <= (red_select.sumprod_Bn.k7 + red_select.sumprod_Bn.k8) / 2;
            -- 1234                        
            red_add.add_1234            <= (int_max_val(red_select.sumprod_Bn.k1,red_select.sumprod_Bn.k2,red_select.sumprod_Bn.k3,red_select.sumprod_Bn.k4) + int_max_val(red_select.sumprod_Bn.k5,red_select.sumprod_Bn.k6,red_select.sumprod_Bn.k7,red_select.sumprod_Bn.k8)) / 2;
            -- 5678                        
            red_add.add_5678            <= (int_max_val(red_select.sumprod_Bn.k9,red_select.sumprod_Bn.k10,red_select.sumprod_Bn.k11,red_select.sumprod_Bn.k12) + int_max_val(red_select.sumprod_Bn.k13,red_select.sumprod_Bn.k14,red_select.sumprod_Bn.k15,red_select.sumprod_Bn.k16)) / 2;
            -- 12345678
            --red_add.add_1_to_8   <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k3 + red_select.sumprod_Bn.k4 + red_select.sumprod_Bn.k5 + red_select.sumprod_Bn.k6 + red_select.sumprod_Bn.k7 + red_select.sumprod_Bn.k8 + red_select.sumprod_Bn.k9 + red_select.sumprod_Bn.k10 + red_select.sumprod_Bn.k11 + red_select.sumprod_Bn.k12 + red_select.sumprod_Bn.k13 + red_select.sumprod_Bn.k14 + red_select.sumprod_Bn.k15 + red_select.sumprod_Bn.k16) / 16;
            red_add.add_1_to_8   <= (red_add.add_1234 + red_add.add_5678) / 2;
            --  45
            red_add.add_45        <= (red_select.sumprod_Bn.k4 + red_select.sumprod_Bn.k5) / 2;
            --  14
            red_add.add_14        <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k4) / 2;
            --  17
            red_add.add_17        <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k7) / 2;
            --  13
            red_add.add_13        <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k3) / 2;
            --  79
            red_add.add_79        <= (red_select.sumprod_Bn.k7 + red_select.sumprod_Bn.k9) / 2;
            --  1,13
            red_add.add_113       <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k13) / 2;
            --  1,16
            red_add.add_116       <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k16) / 2;
            --  13,16
            red_add.add_1316      <= (red_select.sumprod_Bn.k13 + red_select.sumprod_Bn.k16) / 2;
            --  1,4,13,16
            red_add.add_141316    <= (red_add.add_s14 + red_add.add_s1316) / 2;
            --1245
            red_add.add_1245      <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k4 + red_select.sumprod_Bn.k5) / 4;
            --1379
            red_add.add_1379      <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k3 + red_select.sumprod_Bn.k7 + red_select.sumprod_Bn.k9) / 4;
            --123
            red_add.add_123        <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k3) / 3;
            --124
            red_add.add_124        <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k2 + red_select.sumprod_Bn.k4) / 3;
            -- 147
            red_add.add_147        <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k4 + red_select.sumprod_Bn.k7) / 3;
            -- 145
            red_add.add_145        <= (red_select.sumprod_Bn.k1 + red_select.sumprod_Bn.k4 + red_select.sumprod_Bn.k5) / 3;
    end if;
end process;
--=================================================================================================
--
--  +-----+-----+-----+-----+
--  | k1  | k2  | k3  | k4  |
--  |-----|-----|-----|-----|
--  | k5  | k6  | k7  | k8  |
--  |-----|-----|-----|-----|
--  | k9  | k10 | k11 | k12 |
--  |-----|-----|-----|-----| 
--  | k13 | k14 | k15 | k16 |
--  +-----+-----+-----+-----+
--
--
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
        if (red_detect.k_syn_12(2).n=2 and red_detect.k_syn_12(3).n=3 and red_detect.k_syn_12(4).n=4 
           and red_detect.k_syn_12(5).n=5 and red_detect.k_syn_12(6).n=6 and red_detect.k_syn_12(7).n=7  
           and red_detect.k_syn_12(8).n=8 and red_detect.k_syn_12(9).n=9 and red_detect.k_syn_12(10).n=10 
           and red_detect.k_syn_12(11).n=11 and red_detect.k_syn_12(12).n=12 and red_detect.k_syn_12(13).n=13  
           and red_detect.k_syn_12(14).n=14 and red_detect.k_syn_12(15).n=15 and red_detect.k_syn_12(16).n=16) then
            red_select.result   <= std_logic_vector(to_unsigned((red_add.add_123456789ABCDEFF), 14));
        elsif (red_detect.k_syn_12(2).n=2 and red_detect.k_syn_12(3).n=3 and red_detect.k_syn_12(4).n=4 
           and red_detect.k_syn_12(5).n=5 and red_detect.k_syn_12(6).n=6 and red_detect.k_syn_12(7).n=7  
           and red_detect.k_syn_12(9).n=9 and red_detect.k_syn_12(10).n=10   
           and red_detect.k_syn_12(13).n=13) then
            red_select.result   <= std_logic_vector(to_unsigned((red_add.add_12563947_13_10), 14));
        elsif (red_detect.k_syn_12(2).n=2 and red_detect.k_syn_12(3).n=3 and red_detect.k_syn_12(4).n=4 
           and red_detect.k_syn_12(5).n=5 and red_detect.k_syn_12(6).n=6 and red_detect.k_syn_12(7).n=0  
           and red_detect.k_syn_12(9).n=9 and red_detect.k_syn_12(10).n=0   
           and red_detect.k_syn_12(13).n=13) then
            red_select.result   <= std_logic_vector(to_unsigned((red_add.add_1256394_13), 14));
        elsif (red_detect.k_syn_12(2).n=2 and red_detect.k_syn_12(3).n=3 and red_detect.k_syn_12(4).n=0 
           and red_detect.k_syn_12(5).n=5 and red_detect.k_syn_12(6).n=6 and red_detect.k_syn_12(7).n=0  
           and red_detect.k_syn_12(9).n=9 and red_detect.k_syn_12(10).n=0   
           and red_detect.k_syn_12(13).n=13) then
            red_select.result   <= std_logic_vector(to_unsigned((red_add.add_125639_13), 14));
        elsif (red_detect.k_syn_12(2).n=2 and red_detect.k_syn_12(3).n=3 and red_detect.k_syn_12(4).n=4 
           and red_detect.k_syn_12(5).n=5 and red_detect.k_syn_12(6).n=6 and red_detect.k_syn_12(7).n=0  
           and red_detect.k_syn_12(9).n=9) then
            red_select.result   <= std_logic_vector(to_unsigned((red_add.add_1256394), 14));
        elsif (red_detect.k_syn_12(2).n=2 and red_detect.k_syn_12(3).n=3 and red_detect.k_syn_12(4).n=0 
           and red_detect.k_syn_12(5).n=5 and red_detect.k_syn_12(6).n=6 and red_detect.k_syn_12(7).n=0  
           and red_detect.k_syn_12(9).n=9) then
            red_select.result   <= std_logic_vector(to_unsigned((red_add.add_125639), 14));
        elsif (red_detect.k_syn_12(2).n=2 and red_detect.k_syn_12(3).n=0 and red_detect.k_syn_12(4).n=0 
           and red_detect.k_syn_12(5).n=5 and red_detect.k_syn_12(6).n=6) then
            red_select.result   <= std_logic_vector(to_unsigned((red_add.add_1256), 14));
        elsif (red_detect.k_syn_12(2).n=2 and red_detect.k_syn_12(3).n=0 and red_detect.k_syn_12(4).n=0 
           and red_detect.k_syn_12(5).n=5) then
            red_select.result   <= std_logic_vector(to_unsigned((red_add.add_125), 14));
        elsif (red_detect.k_syn_12(2).n=0 and red_detect.k_syn_12(3).n=0 and red_detect.k_syn_12(4).n=0 
           and red_detect.k_syn_12(5).n=5) then
            red_select.result   <= std_logic_vector(to_unsigned((red_add.add_15), 14));
        elsif (red_detect.k_syn_12(2).n=2) then
            red_select.result   <= std_logic_vector(to_unsigned((red_add.add_12), 14));
        else
            red_select.result   <= std_logic_vector(to_unsigned((red_select.sumprod_Bn.k1), 14));
        end if;
    end if;
end process;
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
            gre_select.sumprod_2n       <= gre_select.sumprod_2;
            gre_select.sumprod_3n       <= gre_select.sumprod_2n;
            gre_select.sumprod_4n       <= gre_select.sumprod_3n;
            gre_select.sumprod_5n       <= gre_select.sumprod_4n;
            gre_select.sumprod_6n       <= gre_select.sumprod_5n;
            gre_select.sumprod_7n       <= gre_select.sumprod_6n;
            gre_select.sumprod_8n       <= gre_select.sumprod_7n;
            gre_select.sumprod_9n       <= gre_select.sumprod_8n;
            gre_select.sumprod_An.k1    <= to_integer(unsigned(gre_select.sumprod_9n.k1)); 
            gre_select.sumprod_An.k2    <= to_integer(unsigned(gre_select.sumprod_9n.k2)); 
            gre_select.sumprod_An.k3    <= to_integer(unsigned(gre_select.sumprod_9n.k3)); 
            gre_select.sumprod_An.k4    <= to_integer(unsigned(gre_select.sumprod_9n.k4)); 
            gre_select.sumprod_An.k5    <= to_integer(unsigned(gre_select.sumprod_9n.k5)); 
            gre_select.sumprod_An.k6    <= to_integer(unsigned(gre_select.sumprod_9n.k6)); 
            gre_select.sumprod_An.k7    <= to_integer(unsigned(gre_select.sumprod_9n.k7)); 
            gre_select.sumprod_An.k8    <= to_integer(unsigned(gre_select.sumprod_9n.k8)); 
            gre_select.sumprod_An.k9    <= to_integer(unsigned(gre_select.sumprod_9n.k9)); 
            gre_select.sumprod_An.k10   <= to_integer(unsigned(gre_select.sumprod_9n.k11));
            gre_select.sumprod_An.k11   <= to_integer(unsigned(gre_select.sumprod_9n.k11));
            gre_select.sumprod_An.k12   <= to_integer(unsigned(gre_select.sumprod_9n.k12));
            gre_select.sumprod_An.k13   <= to_integer(unsigned(gre_select.sumprod_9n.k13));
            gre_select.sumprod_An.k14   <= to_integer(unsigned(gre_select.sumprod_9n.k14));
            gre_select.sumprod_An.k15   <= to_integer(unsigned(gre_select.sumprod_9n.k15));
            gre_select.sumprod_An.k16   <= to_integer(unsigned(gre_select.sumprod_9n.k16));
            gre_select.sumprod_Bn       <= gre_select.sumprod_An;
            gre_select.sumprod_Cn       <= gre_select.sumprod_Bn;
            
            gre_add.add_12345678        <= (gre_select.sumprod_An.k1 + gre_select.sumprod_An.k2 + gre_select.sumprod_An.k3 + gre_select.sumprod_An.k4 + gre_select.sumprod_An.k5 + gre_select.sumprod_An.k6 + gre_select.sumprod_An.k7 + gre_select.sumprod_An.k8) / 8;
            gre_add.add_9ABCDEFF        <= (gre_select.sumprod_An.k9 + gre_select.sumprod_An.k10 + gre_select.sumprod_An.k11 + gre_select.sumprod_An.k12 + gre_select.sumprod_An.k13 + gre_select.sumprod_An.k14 + gre_select.sumprod_An.k15 + gre_select.sumprod_An.k16) / 8;
            gre_add.add_123456789ABCDEFF  <= (gre_add.add_12345678 + gre_add.add_9ABCDEFF);
            --  1,2
            gre_add.add_12              <= (gre_select.sumprod_Bn.k1 + gre_select.sumprod_Bn.k12) / 2;
            --  1,5                        
            gre_add.add_15              <= (gre_select.sumprod_Bn.k1 + gre_select.sumprod_Bn.k5) / 2;
            -- 1,2,5                       
            gre_add.add_125             <= (gre_select.sumprod_Bn.k1 + gre_select.sumprod_Bn.k2 + gre_select.sumprod_Bn.k5) / 3;
            -- 1,2,5,6                     
            gre_add.add_1256            <= (gre_select.sumprod_Bn.k1 + gre_select.sumprod_Bn.k2 + gre_select.sumprod_Bn.k5 + gre_select.sumprod_Bn.k6) / 3;
            -- 1,2,5,6,3,9                 
            gre_add.add_125639          <= (gre_select.sumprod_Bn.k1 + gre_select.sumprod_Bn.k2 + gre_select.sumprod_Bn.k5 + gre_select.sumprod_Bn.k6 + gre_select.sumprod_Bn.k3 + gre_select.sumprod_Bn.k9) / 3;
            -- 1,2,5,6,3,9,4               
            gre_add.add_1256394         <= (gre_select.sumprod_Bn.k1 + gre_select.sumprod_Bn.k2 + gre_select.sumprod_Bn.k5 + gre_select.sumprod_Bn.k6 + gre_select.sumprod_Bn.k3 + gre_select.sumprod_Bn.k9 + gre_select.sumprod_Bn.k4) / 3;
            -- 1,2,5,6,3,9,13              
            gre_add.add_125639_13       <= (gre_select.sumprod_Bn.k1 + gre_select.sumprod_Bn.k2 + gre_select.sumprod_Bn.k5 + gre_select.sumprod_Bn.k6 + gre_select.sumprod_Bn.k3 + gre_select.sumprod_Bn.k9 + gre_select.sumprod_Bn.k13) / 3;
            -- 1,2,5,6,3,9,4,13            
            gre_add.add_1256394_13      <= (gre_select.sumprod_Bn.k1 + gre_select.sumprod_Bn.k2 + gre_select.sumprod_Bn.k5 + gre_select.sumprod_Bn.k6 + gre_select.sumprod_Bn.k3 + gre_select.sumprod_Bn.k9 + gre_select.sumprod_Bn.k4 + gre_select.sumprod_Bn.k13) / 3;
            -- 1,2,5,6,3,9,4,13,7,10
            gre_add.add_12563947_13_10  <= (gre_select.sumprod_Bn.k1 + gre_select.sumprod_Bn.k2 + gre_select.sumprod_Bn.k5 + gre_select.sumprod_Bn.k6 + gre_select.sumprod_Bn.k3 + gre_select.sumprod_Bn.k9 + gre_select.sumprod_Bn.k4 + gre_select.sumprod_Bn.k13 + gre_select.sumprod_Bn.k7 + gre_select.sumprod_Bn.k10) / 3;
    end if;
end process;
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
        if (gre_detect.k_syn_12(2).n=2 and gre_detect.k_syn_12(3).n=3 and gre_detect.k_syn_12(4).n=4 
           and gre_detect.k_syn_12(5).n=5 and gre_detect.k_syn_12(6).n=6 and gre_detect.k_syn_12(7).n=7  
           and gre_detect.k_syn_12(8).n=8 and gre_detect.k_syn_12(9).n=9 and gre_detect.k_syn_12(10).n=10 
           and gre_detect.k_syn_12(11).n=11 and gre_detect.k_syn_12(12).n=12 and gre_detect.k_syn_12(13).n=13  
           and gre_detect.k_syn_12(14).n=14 and gre_detect.k_syn_12(15).n=15 and gre_detect.k_syn_12(16).n=16) then
            gre_select.result   <= std_logic_vector(to_unsigned((gre_add.add_123456789ABCDEFF), 14));
        elsif (gre_detect.k_syn_12(2).n=2 and gre_detect.k_syn_12(3).n=3 and gre_detect.k_syn_12(4).n=4 
           and gre_detect.k_syn_12(5).n=5 and gre_detect.k_syn_12(6).n=6 and gre_detect.k_syn_12(7).n=7  
           and gre_detect.k_syn_12(9).n=9 and gre_detect.k_syn_12(10).n=10   
           and gre_detect.k_syn_12(13).n=13) then
            gre_select.result   <= std_logic_vector(to_unsigned((gre_add.add_12563947_13_10), 14));
        elsif (gre_detect.k_syn_12(2).n=2 and gre_detect.k_syn_12(3).n=3 and gre_detect.k_syn_12(4).n=4 
           and gre_detect.k_syn_12(5).n=5 and gre_detect.k_syn_12(6).n=6 and gre_detect.k_syn_12(7).n=0  
           and gre_detect.k_syn_12(9).n=9 and gre_detect.k_syn_12(10).n=0   
           and gre_detect.k_syn_12(13).n=13) then
            gre_select.result   <= std_logic_vector(to_unsigned((gre_add.add_1256394_13), 14));
        elsif (gre_detect.k_syn_12(2).n=2 and gre_detect.k_syn_12(3).n=3 and gre_detect.k_syn_12(4).n=0 
           and gre_detect.k_syn_12(5).n=5 and gre_detect.k_syn_12(6).n=6 and gre_detect.k_syn_12(7).n=0  
           and gre_detect.k_syn_12(9).n=9 and gre_detect.k_syn_12(10).n=0   
           and gre_detect.k_syn_12(13).n=13) then
            gre_select.result   <= std_logic_vector(to_unsigned((gre_add.add_125639_13), 14));
        elsif (gre_detect.k_syn_12(2).n=2 and gre_detect.k_syn_12(3).n=3 and gre_detect.k_syn_12(4).n=4 
           and gre_detect.k_syn_12(5).n=5 and gre_detect.k_syn_12(6).n=6 and gre_detect.k_syn_12(7).n=0  
           and gre_detect.k_syn_12(9).n=9) then
            gre_select.result   <= std_logic_vector(to_unsigned((gre_add.add_1256394), 14));
        elsif (gre_detect.k_syn_12(2).n=2 and gre_detect.k_syn_12(3).n=3 and gre_detect.k_syn_12(4).n=0 
           and gre_detect.k_syn_12(5).n=5 and gre_detect.k_syn_12(6).n=6 and gre_detect.k_syn_12(7).n=0  
           and gre_detect.k_syn_12(9).n=9) then
            gre_select.result   <= std_logic_vector(to_unsigned((gre_add.add_125639), 14));
        elsif (gre_detect.k_syn_12(2).n=2 and gre_detect.k_syn_12(3).n=0 and gre_detect.k_syn_12(4).n=0 
           and gre_detect.k_syn_12(5).n=5 and gre_detect.k_syn_12(6).n=6) then
            gre_select.result   <= std_logic_vector(to_unsigned((gre_add.add_1256), 14));
        elsif (gre_detect.k_syn_12(2).n=2 and gre_detect.k_syn_12(3).n=0 and gre_detect.k_syn_12(4).n=0 
           and gre_detect.k_syn_12(5).n=5) then
            gre_select.result   <= std_logic_vector(to_unsigned((gre_add.add_125), 14));
        elsif (gre_detect.k_syn_12(2).n=0 and gre_detect.k_syn_12(3).n=0 and gre_detect.k_syn_12(4).n=0 
           and gre_detect.k_syn_12(5).n=5) then
            gre_select.result   <= std_logic_vector(to_unsigned((gre_add.add_15), 14));
        elsif (gre_detect.k_syn_12(2).n=2) then
            gre_select.result   <= std_logic_vector(to_unsigned((gre_add.add_12), 14));
        else
            gre_select.result   <= std_logic_vector(to_unsigned((gre_select.sumprod_Bn.k1), 14));
        end if;
    end if;
end process;
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
            blu_select.sumprod_2n        <= blu_select.sumprod_2;
            blu_select.sumprod_3n        <= blu_select.sumprod_2n;
            blu_select.sumprod_4n        <= blu_select.sumprod_3n;
            blu_select.sumprod_5n        <= blu_select.sumprod_4n;
            blu_select.sumprod_6n        <= blu_select.sumprod_5n;
            blu_select.sumprod_7n        <= blu_select.sumprod_6n;
            blu_select.sumprod_8n        <= blu_select.sumprod_7n;
            blu_select.sumprod_9n        <= blu_select.sumprod_8n;
            blu_select.sumprod_An.k1     <= to_integer(unsigned(blu_select.sumprod_9n.k1)); 
            blu_select.sumprod_An.k2     <= to_integer(unsigned(blu_select.sumprod_9n.k2)); 
            blu_select.sumprod_An.k3     <= to_integer(unsigned(blu_select.sumprod_9n.k3)); 
            blu_select.sumprod_An.k4     <= to_integer(unsigned(blu_select.sumprod_9n.k4)); 
            blu_select.sumprod_An.k5     <= to_integer(unsigned(blu_select.sumprod_9n.k5)); 
            blu_select.sumprod_An.k6     <= to_integer(unsigned(blu_select.sumprod_9n.k6)); 
            blu_select.sumprod_An.k7     <= to_integer(unsigned(blu_select.sumprod_9n.k7)); 
            blu_select.sumprod_An.k8     <= to_integer(unsigned(blu_select.sumprod_9n.k8)); 
            blu_select.sumprod_An.k9     <= to_integer(unsigned(blu_select.sumprod_9n.k9)); 
            blu_select.sumprod_An.k10    <= to_integer(unsigned(blu_select.sumprod_9n.k10));
            blu_select.sumprod_An.k11    <= to_integer(unsigned(blu_select.sumprod_9n.k11));
            blu_select.sumprod_An.k12    <= to_integer(unsigned(blu_select.sumprod_9n.k12));
            blu_select.sumprod_An.k13    <= to_integer(unsigned(blu_select.sumprod_9n.k13));
            blu_select.sumprod_An.k14    <= to_integer(unsigned(blu_select.sumprod_9n.k14));
            blu_select.sumprod_An.k15    <= to_integer(unsigned(blu_select.sumprod_9n.k15));
            blu_select.sumprod_An.k16    <= to_integer(unsigned(blu_select.sumprod_9n.k16));
            blu_select.sumprod_Bn        <= blu_select.sumprod_An;
            blu_select.sumprod_Cn        <= blu_select.sumprod_Bn;
            blu_add.add_12345678         <= (blu_select.sumprod_An.k1 + blu_select.sumprod_An.k2 + blu_select.sumprod_An.k3 + blu_select.sumprod_An.k4 + blu_select.sumprod_An.k5 + blu_select.sumprod_An.k6 + blu_select.sumprod_An.k7 + blu_select.sumprod_An.k8) / 8;
            blu_add.add_9ABCDEFF         <= (blu_select.sumprod_An.k9 + blu_select.sumprod_An.k10 + blu_select.sumprod_An.k11 + blu_select.sumprod_An.k12 + blu_select.sumprod_An.k13 + blu_select.sumprod_An.k14 + blu_select.sumprod_An.k15 + blu_select.sumprod_An.k16) / 8;
            blu_add.add_123456789ABCDEFF <= (blu_add.add_12345678 + blu_add.add_9ABCDEFF);
            --  1,2
            blu_add.add_12              <= (blu_select.sumprod_Bn.k1 + blu_select.sumprod_Bn.k12) / 2;
            --  1,5                        
            blu_add.add_15              <= (blu_select.sumprod_Bn.k1 + blu_select.sumprod_Bn.k5) / 2;
            -- 1,2,5                       
            blu_add.add_125             <= (blu_select.sumprod_Bn.k1 + blu_select.sumprod_Bn.k2 + blu_select.sumprod_Bn.k5) / 3;
            -- 1,2,5,6                     
            blu_add.add_1256            <= (blu_select.sumprod_Bn.k1 + blu_select.sumprod_Bn.k2 + blu_select.sumprod_Bn.k5 + blu_select.sumprod_Bn.k6) / 3;
            -- 1,2,5,6,3,9                 
            blu_add.add_125639          <= (blu_select.sumprod_Bn.k1 + blu_select.sumprod_Bn.k2 + blu_select.sumprod_Bn.k5 + blu_select.sumprod_Bn.k6 + blu_select.sumprod_Bn.k3 + blu_select.sumprod_Bn.k9) / 3;
            -- 1,2,5,6,3,9,4               
            blu_add.add_1256394         <= (blu_select.sumprod_Bn.k1 + blu_select.sumprod_Bn.k2 + blu_select.sumprod_Bn.k5 + blu_select.sumprod_Bn.k6 + blu_select.sumprod_Bn.k3 + blu_select.sumprod_Bn.k9 + blu_select.sumprod_Bn.k4) / 3;
            -- 1,2,5,6,3,9,13              
            blu_add.add_125639_13       <= (blu_select.sumprod_Bn.k1 + blu_select.sumprod_Bn.k2 + blu_select.sumprod_Bn.k5 + blu_select.sumprod_Bn.k6 + blu_select.sumprod_Bn.k3 + blu_select.sumprod_Bn.k9 + blu_select.sumprod_Bn.k13) / 3;
            -- 1,2,5,6,3,9,4,13            
            blu_add.add_1256394_13      <= (blu_select.sumprod_Bn.k1 + blu_select.sumprod_Bn.k2 + blu_select.sumprod_Bn.k5 + blu_select.sumprod_Bn.k6 + blu_select.sumprod_Bn.k3 + blu_select.sumprod_Bn.k9 + blu_select.sumprod_Bn.k4 + blu_select.sumprod_Bn.k13) / 3;
            -- 1,2,5,6,3,9,4,13,7,10
            blu_add.add_12563947_13_10  <= (blu_select.sumprod_Bn.k1 + blu_select.sumprod_Bn.k2 + blu_select.sumprod_Bn.k5 + blu_select.sumprod_Bn.k6 + blu_select.sumprod_Bn.k3 + blu_select.sumprod_Bn.k9 + blu_select.sumprod_Bn.k4 + blu_select.sumprod_Bn.k13 + blu_select.sumprod_Bn.k7 + blu_select.sumprod_Bn.k10) / 3;
    end if;
end process;
--=================================================================================================
process (clk) begin
    if rising_edge(clk) then
        if (blu_detect.k_syn_12(2).n=2 and blu_detect.k_syn_12(3).n=3 and blu_detect.k_syn_12(4).n=4 
           and blu_detect.k_syn_12(5).n=5 and blu_detect.k_syn_12(6).n=6 and blu_detect.k_syn_12(7).n=7  
           and blu_detect.k_syn_12(8).n=8 and blu_detect.k_syn_12(9).n=9 and blu_detect.k_syn_12(10).n=10 
           and blu_detect.k_syn_12(11).n=11 and blu_detect.k_syn_12(12).n=12 and blu_detect.k_syn_12(13).n=13  
           and blu_detect.k_syn_12(14).n=14 and blu_detect.k_syn_12(15).n=15 and blu_detect.k_syn_12(16).n=16) then
            blu_select.result   <= std_logic_vector(to_unsigned((blu_add.add_123456789ABCDEFF), 14));
        elsif (blu_detect.k_syn_12(2).n=2 and blu_detect.k_syn_12(3).n=3 and blu_detect.k_syn_12(4).n=4 
           and blu_detect.k_syn_12(5).n=5 and blu_detect.k_syn_12(6).n=6 and blu_detect.k_syn_12(7).n=7  
           and blu_detect.k_syn_12(9).n=9 and blu_detect.k_syn_12(10).n=10   
           and blu_detect.k_syn_12(13).n=13) then
            blu_select.result   <= std_logic_vector(to_unsigned((blu_add.add_12563947_13_10), 14));
        elsif (blu_detect.k_syn_12(2).n=2 and blu_detect.k_syn_12(3).n=3 and blu_detect.k_syn_12(4).n=4 
           and blu_detect.k_syn_12(5).n=5 and blu_detect.k_syn_12(6).n=6 and blu_detect.k_syn_12(7).n=0  
           and blu_detect.k_syn_12(9).n=9 and blu_detect.k_syn_12(10).n=0   
           and blu_detect.k_syn_12(13).n=13) then
            blu_select.result   <= std_logic_vector(to_unsigned((blu_add.add_1256394_13), 14));
        elsif (blu_detect.k_syn_12(2).n=2 and blu_detect.k_syn_12(3).n=3 and blu_detect.k_syn_12(4).n=0 
           and blu_detect.k_syn_12(5).n=5 and blu_detect.k_syn_12(6).n=6 and blu_detect.k_syn_12(7).n=0  
           and blu_detect.k_syn_12(9).n=9 and blu_detect.k_syn_12(10).n=0   
           and blu_detect.k_syn_12(13).n=13) then
            blu_select.result   <= std_logic_vector(to_unsigned((blu_add.add_125639_13), 14));
        elsif (blu_detect.k_syn_12(2).n=2 and blu_detect.k_syn_12(3).n=3 and blu_detect.k_syn_12(4).n=4 
           and blu_detect.k_syn_12(5).n=5 and blu_detect.k_syn_12(6).n=6 and blu_detect.k_syn_12(7).n=0  
           and blu_detect.k_syn_12(9).n=9) then
            blu_select.result   <= std_logic_vector(to_unsigned((blu_add.add_1256394), 14));
        elsif (blu_detect.k_syn_12(2).n=2 and blu_detect.k_syn_12(3).n=3 and blu_detect.k_syn_12(4).n=0 
           and blu_detect.k_syn_12(5).n=5 and blu_detect.k_syn_12(6).n=6 and blu_detect.k_syn_12(7).n=0  
           and blu_detect.k_syn_12(9).n=9) then
            blu_select.result   <= std_logic_vector(to_unsigned((blu_add.add_125639), 14));
        elsif (blu_detect.k_syn_12(2).n=2 and blu_detect.k_syn_12(3).n=0 and blu_detect.k_syn_12(4).n=0 
           and blu_detect.k_syn_12(5).n=5 and blu_detect.k_syn_12(6).n=6) then
            blu_select.result   <= std_logic_vector(to_unsigned((blu_add.add_1256), 14));
        elsif (blu_detect.k_syn_12(2).n=2 and blu_detect.k_syn_12(3).n=0 and blu_detect.k_syn_12(4).n=0 
           and blu_detect.k_syn_12(5).n=5) then
            blu_select.result   <= std_logic_vector(to_unsigned((blu_add.add_125), 14));
        elsif (blu_detect.k_syn_12(2).n=0 and blu_detect.k_syn_12(3).n=0 and blu_detect.k_syn_12(4).n=0 
           and blu_detect.k_syn_12(5).n=5) then
            blu_select.result   <= std_logic_vector(to_unsigned((blu_add.add_15), 14));
        elsif (blu_detect.k_syn_12(2).n=2) then
            blu_select.result   <= std_logic_vector(to_unsigned((blu_add.add_12), 14));
        else
            blu_select.result   <= std_logic_vector(to_unsigned((blu_select.sumprod_Bn.k1), 14));
        end if;
    end if;
end process;
--=================================================================================================
    -- auto detect shape delta values
    Rgb1.red     <= red_select.result(11 downto 4);
    Rgb1.green   <= gre_select.result(11 downto 4);
    Rgb1.blue    <= blu_select.result(11 downto 4);
    Rgb1.valid   <= tpValid;
sharp_f_valid_inst : d_valid
generic map (
    pixelDelay   => 30)
port map(
    clk      => clk,
    iRgb     => Rgb1,
    oRgb     => Rgb2);
rgb5_syncr_inst  : sync_frames
generic map(
    pixelDelay => 46)
port map(
    clk        => clk,
    reset      => reset,
    iRgb       => Rgb2,
    oRgb       => oRgb);
end behavioral;