-------------------------------------------------------------------------------
--
-- Filename    : rgb_contrast_brightness_level_1.vhd
-- Create Date : 05022019 [05-02-2019]
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
entity rgb_contrast_brightness_level_1 is
  generic (
    contrast_val  : sfixed(15 downto -3) := to_sfixed(5.0,15,-3);
    exposer_val   : integer := 8);
  port (
    clk       : in std_logic;
    rst_l     : in std_logic;
    iRgb      : in channel;
    oRgb      : out channel);
end rgb_contrast_brightness_level_1;
architecture Behavioral of rgb_contrast_brightness_level_1 is
  signal ccRgb                : cc_rgb_record;
  signal rgbSyncValid         : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncEol           : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncSof           : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncEof           : std_logic_vector(11 downto 0) := x"000";
  signal rgb_ccm              : channel;
begin
rgbToSf_P: process (clk,rst_l)begin
    if (rst_l = '0') then
        ccRgb.rgbToSf.red    <= (others => '0');
        ccRgb.rgbToSf.green  <= (others => '0');
        ccRgb.rgbToSf.blue   <= (others => '0');
    elsif rising_edge(clk) then
        ccRgb.rgbToSf.red    <= to_sfixed('0' & iRgb.red,ccRgb.rgbToSf.red);
        ccRgb.rgbToSf.green  <= to_sfixed('0' & iRgb.green,ccRgb.rgbToSf.green);
        ccRgb.rgbToSf.blue   <= to_sfixed('0' & iRgb.blue,ccRgb.rgbToSf.blue);
    end if;
end process rgbToSf_P;
syncValid_P: process (clk,rst_l)begin
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
    end if;
end process syncValid_P;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEol(0)  <= iRgb.eol;
      rgbSyncEol(1)  <= rgbSyncEol(0);
      rgbSyncEol(2)  <= rgbSyncEol(1);
      rgbSyncEol(3)  <= rgbSyncEol(2);
      rgbSyncEol(4)  <= rgbSyncEol(3);
      rgbSyncEol(5)  <= rgbSyncEol(4);
      rgbSyncEol(6)  <= rgbSyncEol(5);
      rgbSyncEol(7)  <= rgbSyncEol(6);
      rgbSyncEol(8)  <= rgbSyncEol(4);
      rgbSyncEol(9)  <= rgbSyncEol(8);
      rgbSyncEol(10) <= rgbSyncEol(9);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncSof(0)  <= iRgb.sof;
      rgbSyncSof(1)  <= rgbSyncSof(0);
      rgbSyncSof(2)  <= rgbSyncSof(1);
      rgbSyncSof(3)  <= rgbSyncSof(2);
      rgbSyncSof(4)  <= rgbSyncSof(3);
      rgbSyncSof(5)  <= rgbSyncSof(4);
      rgbSyncSof(6)  <= rgbSyncSof(5);
      rgbSyncSof(7)  <= rgbSyncSof(6);
      rgbSyncSof(8)  <= rgbSyncSof(4);
      rgbSyncSof(9)  <= rgbSyncSof(8);
      rgbSyncSof(10) <= rgbSyncSof(9);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEof(0)  <= iRgb.eof;
      rgbSyncEof(1)  <= rgbSyncEof(0);
      rgbSyncEof(2)  <= rgbSyncEof(1);
      rgbSyncEof(3)  <= rgbSyncEof(2);
      rgbSyncEof(4)  <= rgbSyncEof(3);
      rgbSyncEof(5)  <= rgbSyncEof(4);
      rgbSyncEof(6)  <= rgbSyncEof(5);
      rgbSyncEof(7)  <= rgbSyncEof(6);
      rgbSyncEof(8)  <= rgbSyncEof(4);
      rgbSyncEof(9)  <= rgbSyncEof(8);
      rgbSyncEof(10) <= rgbSyncEof(9);
    end if;
end process;
-- red = alpha(red-128)+128+b
process (clk)begin
    if rising_edge(clk) then
        ccRgb.ccSf.k1           <= contrast_val;
        ccRgb.ccSf.k2           <= to_sfixed(128.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(exposer_val,15,-3);
    end if;
end process;



-- aplha*(rgb_in-128) + 128 + gain
ccRgb.ccProdSf.k1       <=  ((ccRgb.ccSf.k1  * ((ccRgb.rgbToSf.red)   - (ccRgb.ccSf.k2)))   + ccRgb.ccSf.k2 + ccRgb.ccSf.k3);
ccRgb.ccProdSf.k5       <=  ((ccRgb.ccSf.k1  * ((ccRgb.rgbToSf.green) - (ccRgb.ccSf.k2)))   + ccRgb.ccSf.k2 + ccRgb.ccSf.k3);
ccRgb.ccProdSf.k9       <=  ((ccRgb.ccSf.k1  * ((ccRgb.rgbToSf.blue)  - (ccRgb.ccSf.k2)))   + ccRgb.ccSf.k2 + ccRgb.ccSf.k3);

process (clk)begin
    if rising_edge(clk) then
        ccRgb.ccProdToSn.k1     <= to_signed(ccRgb.ccProdSf.k1(21 downto 0), 22);
        ccRgb.ccProdToSn.k5     <= to_signed(ccRgb.ccProdSf.k5(21 downto 0), 22);
        ccRgb.ccProdToSn.k9     <= to_signed(ccRgb.ccProdSf.k9(21 downto 0), 22);
    end if;
end process;


process (clk)begin
    if rising_edge(clk) then
      ccRgb.ccProdTrSn.k1     <= ccRgb.ccProdToSn.k1(14 downto 0);
      ccRgb.ccProdTrSn.k5     <= ccRgb.ccProdToSn.k5(14 downto 0);
      ccRgb.ccProdTrSn.k9     <= ccRgb.ccProdToSn.k9(14 downto 0);
      ccRgb.rgbSnSum.red      <= resize(ccRgb.ccProdTrSn.k1, ADD_RESULT_WIDTH);
      ccRgb.rgbSnSum.green    <= resize(ccRgb.ccProdTrSn.k5, ADD_RESULT_WIDTH);
      ccRgb.rgbSnSum.blue     <= resize(ccRgb.ccProdTrSn.k9, ADD_RESULT_WIDTH);
      ccRgb.rgbSnSumTr.red    <= ccRgb.rgbSnSum.red(14 downto 0);
      ccRgb.rgbSnSumTr.green  <= ccRgb.rgbSnSum.green(14 downto 0);
      ccRgb.rgbSnSumTr.blue   <= ccRgb.rgbSnSum.blue(14 downto 0);
    end if;
end process;


process (clk, rst_l)
  begin
    if rising_edge(clk) then

      if ccRgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-1) = '1' then
        rgb_ccm.red <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        rgb_ccm.red <= (others => '1');
      else
        rgb_ccm.red <= std_logic_vector(ccRgb.rgbSnSumTr.red(i_data_width-1 downto 0));
      end if;

      if ccRgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-1) = '1' then
        rgb_ccm.green <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        rgb_ccm.green <= (others => '1');
      else
        rgb_ccm.green <= std_logic_vector(ccRgb.rgbSnSumTr.green(i_data_width-1 downto 0));
      end if;

     if ccRgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-1) = '1' then
        rgb_ccm.blue <= (others => '0');
     elsif unsigned(ccRgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        rgb_ccm.blue <= (others => '1');
     else
        rgb_ccm.blue <= std_logic_vector(ccRgb.rgbSnSumTr.blue(i_data_width-1 downto 0));
     end if;

    end if;
end process;

process (clk)begin
    if rising_edge(clk) then
        oRgb.red   <= rgb_ccm.red;
        oRgb.green <= rgb_ccm.green;
        oRgb.blue  <= rgb_ccm.blue;
        oRgb.valid <= rgbSyncValid(5);
        oRgb.eol   <= rgbSyncEol(5);
        oRgb.sof   <= rgbSyncSof(5);
        oRgb.eof   <= rgbSyncEof(5);
    end if;
end process;
end Behavioral;