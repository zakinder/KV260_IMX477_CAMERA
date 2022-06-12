-------------------------------------------------------------------------------
--
-- Filename    : blur_mac.vhd
-- Create Date : 02092019 [02-09-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity blur_mac is
generic (
    i_data_width  : integer := 8);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iTap1          : in std_logic_vector(i_data_width-1 downto 0);
    iTap2          : in std_logic_vector(i_data_width-1 downto 0);
    iTap3          : in std_logic_vector(i_data_width-1 downto 0);
    oBlurData      : out std_logic_vector(i_data_width+3 downto 0));
end entity;
architecture arch of blur_mac is

    signal wind3x3     : w_pixels;
    signal mac1X       : unsig_pixel_mac;
    signal mac2X       : unsig_pixel_mac;
    signal mac3X       : unsig_pixel_mac;
    signal tpd1        : itaps;
    signal tpd2        : itaps;
    signal tpd3        : itaps;
    signal pa_data     : unsigned(i_data_width+3 downto 0);
    
    constant blur_Mac_Kernel_1                    : unsigned(i_data_width-1 downto 0)         :="0000000001";
    constant blur_Mac_Kernel_2                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blur_Mac_Kernel_3                    : unsigned(i_data_width-1 downto 0)         :="0000000001";
    constant blur_Mac_Kernel_4                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blur_Mac_Kernel_5                    : unsigned(i_data_width-1 downto 0)         :="0000000100";
    constant blur_Mac_Kernel_6                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blur_Mac_Kernel_7                    : unsigned(i_data_width-1 downto 0)         :="0000000001";
    constant blur_Mac_Kernel_8                    : unsigned(i_data_width-1 downto 0)         :="0000000010";
    constant blur_Mac_Kernel_9                    : unsigned(i_data_width-1 downto 0)         :="0000000001";
    
begin

-- Each input vTapn represent row of window which is delayed by clk cycle tpdn to make a 3x3 window.
window_3x3: process (clk) begin
    if rising_edge(clk) then
        if rst_l = '0' then
            tpd1.iTap1    <= (others => '0');
            tpd1.iTap2    <= (others => '0');
            tpd1.iTap3    <= (others => '0');
            tpd2.iTap1    <= (others => '0');
            tpd2.iTap2    <= (others => '0');
            tpd2.iTap3    <= (others => '0');
            tpd3.iTap1    <= (others => '0');
            tpd3.iTap2    <= (others => '0');
            tpd3.iTap3    <= (others => '0');
        else
           tpd1.iTap1     <= unsigned('0' & iTap1);
           tpd1.iTap2     <= unsigned('0' & iTap2);
           tpd1.iTap3     <= unsigned('0' & iTap3);
           tpd2.iTap1     <= tpd1.iTap1;
           tpd2.iTap2     <= tpd1.iTap2;
           tpd2.iTap3     <= tpd1.iTap3;
           tpd3.iTap1     <= tpd2.iTap1;
           tpd3.iTap2     <= tpd2.iTap2;
           tpd3.iTap3     <= tpd2.iTap3;
        end if;
    end if;
end process window_3x3;

    wind3x3.pix1 <=  tpd1.iTap1;-- 1st Row 1st pixel
    wind3x3.pix2 <=  tpd2.iTap1;-- 1st Row 2nd pixel
    wind3x3.pix3 <=  tpd3.iTap1;-- 1st Row 3rd pixel

    wind3x3.pix4 <=  tpd1.iTap2;-- 2nd Row 1st pixel
    wind3x3.pix5 <=  tpd2.iTap2;-- 2nd Row 2nd pixel
    wind3x3.pix6 <=  tpd3.iTap2;-- 2nd Row 3rd pixel

    wind3x3.pix7 <=  tpd1.iTap3;-- 3rd Row 1st pixel
    wind3x3.pix8 <=  tpd2.iTap3;-- 3rd Row 2nd pixel
    wind3x3.pix9 <=  tpd3.iTap3;-- 3rd Row 3rd pixel

-- 1st row of 3x3 window
-- Multiplier–accumulator MAC_X_A
MAC_X_A: process (clk) begin
  if rising_edge(clk) then
      mac1X.m1    <= (wind3x3.pix1 * blur_Mac_Kernel_9);
      mac1X.m2    <= (wind3x3.pix2 * blur_Mac_Kernel_8);
      mac1X.m3    <= (wind3x3.pix3 * blur_Mac_Kernel_7);
      mac1X.mac   <= mac1X.m1(i_data_width+3 downto 0) + mac1X.m2(i_data_width+3 downto 0) + mac1X.m3(i_data_width+3 downto 0);
  end if;
end process MAC_X_A;


-- 2nd row of 3x3 window
-- Multiplier–accumulator MAC_X_B
MAC_X_B: process (clk) begin
  if rising_edge(clk) then
      mac2X.m1    <= (wind3x3.pix4 * blur_Mac_Kernel_6);
      mac2X.m2    <= (wind3x3.pix5 * blur_Mac_Kernel_5);
      mac2X.m3    <= (wind3x3.pix6 * blur_Mac_Kernel_4);
      mac2X.mac   <= mac2X.m1(i_data_width+3 downto 0) + mac2X.m2(i_data_width+3 downto 0) + mac2X.m3(i_data_width+3 downto 0);
  end if;
end process MAC_X_B;


-- 3rd row of 3x3 window
-- Multiplier–accumulator MAC_X_C
MAC_X_C: process (clk) begin
  if rising_edge(clk) then
      mac3X.m1    <= (wind3x3.pix7 * blur_Mac_Kernel_3);
      mac3X.m2    <= (wind3x3.pix8 * blur_Mac_Kernel_2);
      mac3X.m3    <= (wind3x3.pix9 * blur_Mac_Kernel_1);
      mac3X.mac   <= mac3X.m1(i_data_width+3 downto 0) + mac3X.m2(i_data_width+3 downto 0) + mac3X.m3(i_data_width+3 downto 0);
  end if;
end process MAC_X_C;

-- Sum of Mac
PA_X: process (clk, rst_l) begin
  if rst_l = '0' then
      pa_data <= (others => '0');
  elsif rising_edge(clk) then
      pa_data <= mac1X.mac + mac2X.mac + mac3X.mac;
  end if;
end process PA_X;

oBlurData <= std_logic_vector(pa_data(i_data_width+3 downto 0));

end architecture;