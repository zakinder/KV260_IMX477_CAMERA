-------------------------------------------------------------------------------
--
-- Filename      : blur_filter_4by4.vhd
-- Create Date   : 02092019 [02-09-2019]
-- Modified Date : 12302021 [12-30-2021]
-- Author        : Zakinder
--
-- Description   :
-- This file instantiation
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity blur_filter_4by4 is
generic (
    iMSB          : integer := 11;
    iLSB          : integer := 4;
    i_data_width  : integer := 8;
    img_width     : integer := 256;
    adwrWidth     : integer := 16;
    addrWidth     : integer := 12);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end entity;
architecture arch of blur_filter_4by4 is
    signal blurRgb                 : blurchannel;
    signal blur_rgb                : channel;
    signal v1TapRGB0x              : std_logic_vector(29 downto 0) := (others => '0');
    signal v1TapRGB1x              : std_logic_vector(29 downto 0) := (others => '0');
    signal v1TapRGB2x              : std_logic_vector(29 downto 0) := (others => '0');
    signal v1TapRGB3x              : std_logic_vector(29 downto 0) := (others => '0'); 
    signal tpValid                 : std_logic;
    signal tpd1                    : k_3by3;
    signal tpd2                    : k_3by3;
    signal tpd3                    : k_3by3;
    signal tpd4                    : k_3by3;
    signal syn1KernalData_red      : kkkCoeff;
    signal syn2KernalData_red      : kkkCoeff;
    signal syn3KernalData_red      : kkkCoeff;
    signal syn4KernalData_red      : kkkCoeff;
    signal syn5KernalData_red      : kkkCoeff;
    signal synaKernalData_red      : kkkCoeff;
    signal synbKernalData_red      : kkkCoeff;
    signal syn6KernalData_red      : kkkCoeff;
    signal syn1KernalData_gre      : kkkCoeff;
    signal syn2KernalData_gre      : kkkCoeff;
    signal syn3KernalData_gre      : kkkCoeff;
    signal syn4KernalData_gre      : kkkCoeff;
    signal syn5KernalData_gre      : kkkCoeff;
    signal synaKernalData_gre      : kkkCoeff;
    signal synbKernalData_gre      : kkkCoeff;
    signal syn6KernalData_gre      : kkkCoeff;
    signal syn1KernalData_blu      : kkkCoeff;
    signal syn2KernalData_blu      : kkkCoeff;
    signal syn3KernalData_blu      : kkkCoeff;
    signal syn4KernalData_blu      : kkkCoeff;
    signal syn5KernalData_blu      : kkkCoeff;
    signal synaKernalData_blu      : kkkCoeff;
    signal synbKernalData_blu      : kkkCoeff;
    signal syn6KernalData_blu      : kkkCoeff;
    signal k_4_x_4_red             : w_4_by_4_pixels;
    signal k_4_x_4_gre             : w_4_by_4_pixels;
    signal k_4_x_4_blu             : w_4_by_4_pixels;
    signal rgbSyncValid            : std_logic_vector(15 downto 0)  := x"0000";
    signal mac1X_red               : unsig_pixel_4by4mac;
    signal mac2X_red               : unsig_pixel_4by4mac;
    signal mac3X_red               : unsig_pixel_4by4mac;
    signal mac4X_red               : unsig_pixel_4by4mac;
    signal pa_data_red             : unsigned(i_data_width+5 downto 0);
    signal mac1X_gre               : unsig_pixel_4by4mac;
    signal mac2X_gre               : unsig_pixel_4by4mac;
    signal mac3X_gre               : unsig_pixel_4by4mac;
    signal mac4X_gre               : unsig_pixel_4by4mac;
    signal pa_data_gre             : unsigned(i_data_width+5 downto 0);
    signal mac1X_blu               : unsig_pixel_4by4mac;
    signal mac2X_blu               : unsig_pixel_4by4mac;
    signal mac3X_blu               : unsig_pixel_4by4mac;
    signal mac4X_blu               : unsig_pixel_4by4mac;
    signal pa_data_blu             : unsigned(i_data_width+5 downto 0);
begin
RGBInst: rgb_4taps
generic map(
    img_width       => img_width,
    tpDataWidth     => 30)
port map(
    clk             => clk,
    rst_l           => rst_l,
    iRgb            => iRgb,
    tpValid         => tpValid,
    tp0             => v1TapRGB0x,
    tp1             => v1TapRGB1x,
    tp2             => v1TapRGB2x,
    tp3             => v1TapRGB3x);
process (clk) begin
    if rising_edge(clk) then
        if rst_l = '0' then
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
            syn1KernalData_red.k1  <= tpd4.row_1(29 downto 20);
            syn1KernalData_red.k2  <= tpd3.row_1(29 downto 20);
            syn1KernalData_red.k3  <= tpd2.row_1(29 downto 20);
            syn1KernalData_red.k4  <= tpd1.row_1(29 downto 20);
            syn1KernalData_red.k5  <= tpd4.row_2(29 downto 20);
            syn1KernalData_red.k6  <= tpd3.row_2(29 downto 20);
            syn1KernalData_red.k7  <= tpd2.row_2(29 downto 20);
            syn1KernalData_red.k8  <= tpd1.row_2(29 downto 20);
            syn1KernalData_red.k9  <= tpd4.row_3(29 downto 20);
            syn1KernalData_red.k10 <= tpd3.row_3(29 downto 20);
            syn1KernalData_red.k11 <= tpd2.row_3(29 downto 20);
            syn1KernalData_red.k12 <= tpd1.row_3(29 downto 20);
            syn1KernalData_red.k13 <= tpd4.row_4(29 downto 20);
            syn1KernalData_red.k14 <= tpd3.row_4(29 downto 20);
            syn1KernalData_red.k15 <= tpd2.row_4(29 downto 20);
            syn1KernalData_red.k16 <= tpd1.row_4(29 downto 20);
            syn2KernalData_red     <= syn1KernalData_red;
            syn3KernalData_red     <= syn2KernalData_red;
            syn4KernalData_red     <= syn3KernalData_red;
            syn5KernalData_red     <= syn4KernalData_red;
            synaKernalData_red     <= syn5KernalData_red;
            synbKernalData_red     <= synaKernalData_red;
            syn1KernalData_gre.k1  <= tpd4.row_1(19 downto 10);
            syn1KernalData_gre.k2  <= tpd3.row_1(19 downto 10);
            syn1KernalData_gre.k3  <= tpd2.row_1(19 downto 10);
            syn1KernalData_gre.k4  <= tpd1.row_1(19 downto 10);
            syn1KernalData_gre.k5  <= tpd4.row_2(19 downto 10);
            syn1KernalData_gre.k6  <= tpd3.row_2(19 downto 10);
            syn1KernalData_gre.k7  <= tpd2.row_2(19 downto 10);
            syn1KernalData_gre.k8  <= tpd1.row_2(19 downto 10);
            syn1KernalData_gre.k9  <= tpd4.row_3(19 downto 10);
            syn1KernalData_gre.k10 <= tpd3.row_3(19 downto 10);
            syn1KernalData_gre.k11 <= tpd2.row_3(19 downto 10);
            syn1KernalData_gre.k12 <= tpd1.row_3(19 downto 10);
            syn1KernalData_gre.k13 <= tpd4.row_4(19 downto 10);
            syn1KernalData_gre.k14 <= tpd3.row_4(19 downto 10);
            syn1KernalData_gre.k15 <= tpd2.row_4(19 downto 10);
            syn1KernalData_gre.k16 <= tpd1.row_4(19 downto 10);
            syn2KernalData_gre     <= syn1KernalData_gre;
            syn3KernalData_gre     <= syn2KernalData_gre;
            syn4KernalData_gre     <= syn3KernalData_gre;
            syn5KernalData_gre     <= syn4KernalData_gre;
            synaKernalData_gre     <= syn5KernalData_gre;
            synbKernalData_gre     <= synaKernalData_gre;
            syn1KernalData_blu.k1  <= tpd4.row_1(9 downto 0);
            syn1KernalData_blu.k2  <= tpd3.row_1(9 downto 0);
            syn1KernalData_blu.k3  <= tpd2.row_1(9 downto 0);
            syn1KernalData_blu.k4  <= tpd1.row_1(9 downto 0);
            syn1KernalData_blu.k5  <= tpd4.row_2(9 downto 0);
            syn1KernalData_blu.k6  <= tpd3.row_2(9 downto 0);
            syn1KernalData_blu.k7  <= tpd2.row_2(9 downto 0);
            syn1KernalData_blu.k8  <= tpd1.row_2(9 downto 0);
            syn1KernalData_blu.k9  <= tpd4.row_3(9 downto 0);
            syn1KernalData_blu.k10 <= tpd3.row_3(9 downto 0);
            syn1KernalData_blu.k11 <= tpd2.row_3(9 downto 0);
            syn1KernalData_blu.k12 <= tpd1.row_3(9 downto 0);
            syn1KernalData_blu.k13 <= tpd4.row_4(9 downto 0);
            syn1KernalData_blu.k14 <= tpd3.row_4(9 downto 0);
            syn1KernalData_blu.k15 <= tpd2.row_4(9 downto 0);
            syn1KernalData_blu.k16 <= tpd1.row_4(9 downto 0);
            syn2KernalData_blu     <= syn1KernalData_blu;
            syn3KernalData_blu     <= syn2KernalData_blu;
            syn4KernalData_blu     <= syn3KernalData_blu;
            syn5KernalData_blu     <= syn4KernalData_blu;
            synaKernalData_blu     <= syn5KernalData_blu;
            synbKernalData_blu     <= synaKernalData_blu;
        end if;
    end if;
end process;
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
process (clk) begin
    if rising_edge(clk) then
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
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        k_4_x_4_red.k1  <= unsigned('0' & syn6KernalData_red.k1);
        k_4_x_4_red.k2  <= unsigned('0' & syn6KernalData_red.k2);
        k_4_x_4_red.k3  <= unsigned('0' & syn6KernalData_red.k3);
        k_4_x_4_red.k4  <= unsigned('0' & syn6KernalData_red.k4);
        k_4_x_4_red.k5  <= unsigned('0' & syn6KernalData_red.k5);
        k_4_x_4_red.k6  <= unsigned('0' & syn6KernalData_red.k6);
        k_4_x_4_red.k7  <= unsigned('0' & syn6KernalData_red.k7);
        k_4_x_4_red.k8  <= unsigned('0' & syn6KernalData_red.k8);
        k_4_x_4_red.k9  <= unsigned('0' & syn6KernalData_red.k9);
        k_4_x_4_red.k10 <= unsigned('0' & syn6KernalData_red.k10);
        k_4_x_4_red.k11 <= unsigned('0' & syn6KernalData_red.k11);
        k_4_x_4_red.k12 <= unsigned('0' & syn6KernalData_red.k12);
        k_4_x_4_red.k13 <= unsigned('0' & syn6KernalData_red.k13);
        k_4_x_4_red.k14 <= unsigned('0' & syn6KernalData_red.k14);
        k_4_x_4_red.k15 <= unsigned('0' & syn6KernalData_red.k15);
        k_4_x_4_red.k16 <= unsigned('0' & syn6KernalData_red.k16);
        k_4_x_4_gre.k1  <= unsigned('0' & syn6KernalData_gre.k1);
        k_4_x_4_gre.k2  <= unsigned('0' & syn6KernalData_gre.k2);
        k_4_x_4_gre.k3  <= unsigned('0' & syn6KernalData_gre.k3);
        k_4_x_4_gre.k4  <= unsigned('0' & syn6KernalData_gre.k4);
        k_4_x_4_gre.k5  <= unsigned('0' & syn6KernalData_gre.k5);
        k_4_x_4_gre.k6  <= unsigned('0' & syn6KernalData_gre.k6);
        k_4_x_4_gre.k7  <= unsigned('0' & syn6KernalData_gre.k7);
        k_4_x_4_gre.k8  <= unsigned('0' & syn6KernalData_gre.k8);
        k_4_x_4_gre.k9  <= unsigned('0' & syn6KernalData_gre.k9);
        k_4_x_4_gre.k10 <= unsigned('0' & syn6KernalData_gre.k10);
        k_4_x_4_gre.k11 <= unsigned('0' & syn6KernalData_gre.k11);
        k_4_x_4_gre.k12 <= unsigned('0' & syn6KernalData_gre.k12);
        k_4_x_4_gre.k13 <= unsigned('0' & syn6KernalData_gre.k13);
        k_4_x_4_gre.k14 <= unsigned('0' & syn6KernalData_gre.k14);
        k_4_x_4_gre.k15 <= unsigned('0' & syn6KernalData_gre.k15);
        k_4_x_4_gre.k16 <= unsigned('0' & syn6KernalData_gre.k16);
        k_4_x_4_blu.k1  <= unsigned('0' & syn6KernalData_blu.k1);
        k_4_x_4_blu.k2  <= unsigned('0' & syn6KernalData_blu.k2);
        k_4_x_4_blu.k3  <= unsigned('0' & syn6KernalData_blu.k3);
        k_4_x_4_blu.k4  <= unsigned('0' & syn6KernalData_blu.k4);
        k_4_x_4_blu.k5  <= unsigned('0' & syn6KernalData_blu.k5);
        k_4_x_4_blu.k6  <= unsigned('0' & syn6KernalData_blu.k6);
        k_4_x_4_blu.k7  <= unsigned('0' & syn6KernalData_blu.k7);
        k_4_x_4_blu.k8  <= unsigned('0' & syn6KernalData_blu.k8);
        k_4_x_4_blu.k9  <= unsigned('0' & syn6KernalData_blu.k9);
        k_4_x_4_blu.k10 <= unsigned('0' & syn6KernalData_blu.k10);
        k_4_x_4_blu.k11 <= unsigned('0' & syn6KernalData_blu.k11);
        k_4_x_4_blu.k12 <= unsigned('0' & syn6KernalData_blu.k12);
        k_4_x_4_blu.k13 <= unsigned('0' & syn6KernalData_blu.k13);
        k_4_x_4_blu.k14 <= unsigned('0' & syn6KernalData_blu.k14);
        k_4_x_4_blu.k15 <= unsigned('0' & syn6KernalData_blu.k15);
        k_4_x_4_blu.k16 <= unsigned('0' & syn6KernalData_blu.k16);
    end if;
end process;
MAC_X_1_red: process (clk) begin
  if rising_edge(clk) then
      mac1X_red.m1    <= (k_4_x_4_red.k1 * blurMacKernel_16);
      mac1X_red.m2    <= (k_4_x_4_red.k2 * blurMacKernel_15);
      mac1X_red.m3    <= (k_4_x_4_red.k3 * blurMacKernel_14);
      mac1X_red.m4    <= (k_4_x_4_red.k4 * blurMacKernel_13);
      mac1X_red.mac   <= mac1X_red.m1(i_data_width+5 downto 0) + mac1X_red.m2(i_data_width+5 downto 0) + mac1X_red.m3(i_data_width+5 downto 0) + mac1X_red.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_1_red;
MAC_X_2_red: process (clk) begin
  if rising_edge(clk) then
      mac2X_red.m1    <= (k_4_x_4_red.k5 * blurMacKernel_12);
      mac2X_red.m2    <= (k_4_x_4_red.k6 * blurMacKernel_11);
      mac2X_red.m3    <= (k_4_x_4_red.k7 * blurMacKernel_10);
      mac2X_red.m4    <= (k_4_x_4_red.k8 * blurMacKernel_9);
      mac2X_red.mac   <= mac2X_red.m1(i_data_width+5 downto 0) + mac2X_red.m2(i_data_width+5 downto 0) + mac2X_red.m3(i_data_width+5 downto 0) + mac2X_red.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_2_red;
MAC_X_3_red: process (clk) begin
  if rising_edge(clk) then
      mac3X_red.m1    <= (k_4_x_4_red.k9  * blurMacKernel_8);
      mac3X_red.m2    <= (k_4_x_4_red.k10 * blurMacKernel_7);
      mac3X_red.m3    <= (k_4_x_4_red.k11 * blurMacKernel_6);
      mac3X_red.m4    <= (k_4_x_4_red.k12 * blurMacKernel_5);
      mac3X_red.mac   <= mac3X_red.m1(i_data_width+5 downto 0) + mac3X_red.m2(i_data_width+5 downto 0) + mac3X_red.m3(i_data_width+5 downto 0) + mac3X_red.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_3_red;
MAC_X_4_red: process (clk) begin
  if rising_edge(clk) then
      mac4X_red.m1    <= (k_4_x_4_red.k13 * blurMacKernel_4);
      mac4X_red.m2    <= (k_4_x_4_red.k14 * blurMacKernel_3);
      mac4X_red.m3    <= (k_4_x_4_red.k15 * blurMacKernel_2);
      mac4X_red.m4    <= (k_4_x_4_red.k16 * blurMacKernel_1);
      mac4X_red.mac   <= mac4X_red.m1(i_data_width+5 downto 0) + mac4X_red.m2(i_data_width+5 downto 0) + mac4X_red.m3(i_data_width+5 downto 0) + mac4X_red.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_4_red;
PA_X_red: process (clk, rst_l) begin
  if rst_l = '0' then
      pa_data_red <= (others => '0');
  elsif rising_edge(clk) then
      pa_data_red <= mac1X_red.mac + mac2X_red.mac + mac3X_red.mac + mac4X_red.mac;
  end if;
end process PA_X_red;
blurRgb.red <= std_logic_vector(pa_data_red(i_data_width+5 downto 2));
MAC_X_1_gre: process (clk) begin
  if rising_edge(clk) then
      mac1X_gre.m1    <= (k_4_x_4_gre.k1 * blurMacKernel_16);
      mac1X_gre.m2    <= (k_4_x_4_gre.k2 * blurMacKernel_15);
      mac1X_gre.m3    <= (k_4_x_4_gre.k3 * blurMacKernel_14);
      mac1X_gre.m4    <= (k_4_x_4_gre.k4 * blurMacKernel_13);
      mac1X_gre.mac   <= mac1X_gre.m1(i_data_width+5 downto 0) + mac1X_gre.m2(i_data_width+5 downto 0) + mac1X_gre.m3(i_data_width+5 downto 0) + mac1X_gre.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_1_gre;
MAC_X_2_gre: process (clk) begin
  if rising_edge(clk) then
      mac2X_gre.m1    <= (k_4_x_4_gre.k5 * blurMacKernel_12);
      mac2X_gre.m2    <= (k_4_x_4_gre.k6 * blurMacKernel_11);
      mac2X_gre.m3    <= (k_4_x_4_gre.k7 * blurMacKernel_10);
      mac2X_gre.m4    <= (k_4_x_4_gre.k8 * blurMacKernel_9);
      mac2X_gre.mac   <= mac2X_gre.m1(i_data_width+5 downto 0) + mac2X_gre.m2(i_data_width+5 downto 0) + mac2X_gre.m3(i_data_width+5 downto 0) + mac2X_gre.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_2_gre;
MAC_X_3_gre: process (clk) begin
  if rising_edge(clk) then
      mac3X_gre.m1    <= (k_4_x_4_gre.k9  * blurMacKernel_8);
      mac3X_gre.m2    <= (k_4_x_4_gre.k10 * blurMacKernel_7);
      mac3X_gre.m3    <= (k_4_x_4_gre.k11 * blurMacKernel_6);
      mac3X_gre.m4    <= (k_4_x_4_gre.k12 * blurMacKernel_5);
      mac3X_gre.mac   <= mac3X_gre.m1(i_data_width+5 downto 0) + mac3X_gre.m2(i_data_width+5 downto 0) + mac3X_gre.m3(i_data_width+5 downto 0) + mac3X_gre.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_3_gre;
MAC_X_4_gre: process (clk) begin
  if rising_edge(clk) then
      mac4X_gre.m1    <= (k_4_x_4_gre.k13 * blurMacKernel_4);
      mac4X_gre.m2    <= (k_4_x_4_gre.k14 * blurMacKernel_3);
      mac4X_gre.m3    <= (k_4_x_4_gre.k15 * blurMacKernel_2);
      mac4X_gre.m4    <= (k_4_x_4_gre.k16 * blurMacKernel_1);
      mac4X_gre.mac   <= mac4X_gre.m1(i_data_width+5 downto 0) + mac4X_gre.m2(i_data_width+5 downto 0) + mac4X_gre.m3(i_data_width+5 downto 0) + mac4X_gre.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_4_gre;
PA_X_gre: process (clk, rst_l) begin
  if rst_l = '0' then
      pa_data_gre <= (others => '0');
  elsif rising_edge(clk) then
      pa_data_gre <= mac1X_gre.mac + mac2X_gre.mac + mac3X_gre.mac + mac4X_gre.mac;
  end if;
end process PA_X_gre;
blurRgb.green <= std_logic_vector(pa_data_gre(i_data_width+5 downto 2));
MAC_X_1_blu: process (clk) begin
  if rising_edge(clk) then
      mac1X_blu.m1    <= (k_4_x_4_blu.k1 * blurMacKernel_16);
      mac1X_blu.m2    <= (k_4_x_4_blu.k2 * blurMacKernel_15);
      mac1X_blu.m3    <= (k_4_x_4_blu.k3 * blurMacKernel_14);
      mac1X_blu.m4    <= (k_4_x_4_blu.k4 * blurMacKernel_13);
      mac1X_blu.mac   <= mac1X_blu.m1(i_data_width+5 downto 0) + mac1X_blu.m2(i_data_width+5 downto 0) + mac1X_blu.m3(i_data_width+5 downto 0) + mac1X_blu.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_1_blu;
MAC_X_2_blu: process (clk) begin
  if rising_edge(clk) then
      mac2X_blu.m1    <= (k_4_x_4_blu.k5 * blurMacKernel_12);
      mac2X_blu.m2    <= (k_4_x_4_blu.k6 * blurMacKernel_11);
      mac2X_blu.m3    <= (k_4_x_4_blu.k7 * blurMacKernel_10);
      mac2X_blu.m4    <= (k_4_x_4_blu.k8 * blurMacKernel_9);
      mac2X_blu.mac   <= mac2X_blu.m1(i_data_width+5 downto 0) + mac2X_blu.m2(i_data_width+5 downto 0) + mac2X_blu.m3(i_data_width+5 downto 0) + mac2X_blu.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_2_blu;
MAC_X_3_blu: process (clk) begin
  if rising_edge(clk) then
      mac3X_blu.m1    <= (k_4_x_4_blu.k9  * blurMacKernel_8);
      mac3X_blu.m2    <= (k_4_x_4_blu.k10 * blurMacKernel_7);
      mac3X_blu.m3    <= (k_4_x_4_blu.k11 * blurMacKernel_6);
      mac3X_blu.m4    <= (k_4_x_4_blu.k12 * blurMacKernel_5);
      mac3X_blu.mac   <= mac3X_blu.m1(i_data_width+5 downto 0) + mac3X_blu.m2(i_data_width+5 downto 0) + mac3X_blu.m3(i_data_width+5 downto 0) + mac3X_blu.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_3_blu;
MAC_X_4_blu: process (clk) begin
  if rising_edge(clk) then
      mac4X_blu.m1    <= (k_4_x_4_blu.k13 * blurMacKernel_4);
      mac4X_blu.m2    <= (k_4_x_4_blu.k14 * blurMacKernel_3);
      mac4X_blu.m3    <= (k_4_x_4_blu.k15 * blurMacKernel_2);
      mac4X_blu.m4    <= (k_4_x_4_blu.k16 * blurMacKernel_1);
      mac4X_blu.mac   <= mac4X_blu.m1(i_data_width+5 downto 0) + mac4X_blu.m2(i_data_width+5 downto 0) + mac4X_blu.m3(i_data_width+5 downto 0) + mac4X_blu.m4(i_data_width+5 downto 0);
  end if;
end process MAC_X_4_blu;
PA_X_blu: process (clk, rst_l) begin
  if rst_l = '0' then
      pa_data_blu <= (others => '0');
  elsif rising_edge(clk) then
      pa_data_blu <= mac1X_blu.mac + mac2X_blu.mac + mac3X_blu.mac + mac4X_blu.mac;
  end if;
end process PA_X_blu;
blurRgb.blue <= std_logic_vector(pa_data_blu(i_data_width+5 downto 2));
    blur_rgb.red   <= blurRgb.red(iMSB downto iLSB);
    blur_rgb.green <= blurRgb.green(iMSB downto iLSB);
    blur_rgb.blue  <= blurRgb.blue(iMSB downto iLSB);
    blur_rgb.valid <= iRgb.valid;
    blur_rgb.eol   <= iRgb.eol;
    blur_rgb.sof   <= iRgb.sof;
    blur_rgb.eof   <= iRgb.eof;
blur_valid_inst: d_valid
generic map (
    pixelDelay   => 11)
port map(
    clk      => clk,
    iRgb     => blur_rgb,
    oRgb     => oRgb);
end architecture;