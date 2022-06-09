-------------------------------------------------------------------------------
--
-- Filename    : two_pixels.vhd
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

entity two_pixels is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end two_pixels;
architecture behavioral of two_pixels is
    --RGB Floating
    signal uFs1Rgb       : rgbToUfRecord;
    signal uFs2Rgb       : rgbToUfRecord;
    signal uFs3Rgb       : rgbToUfRecord;
    signal uFs4Rgb       : rgbToUfRecord;
    signal uFs5Rgb       : rgbToUfRecord;
    --RGB Max Min
    signal rgbThresh     : ufixed(8 downto 0) :=(others => '0');
    signal rgbValue      : ufixed(8 downto 0) :=(others => '0');
	signal rgbVt         : ufixed(7 downto 0)  :=(others => '0');
	
begin

setThreshold <= to_ufixed (6.0,setThreshold);

rgbToUfP: process (clk,reset)begin
    if (reset = lo) then
        uFs1Rgb.red    <= (others => '0');
        uFs1Rgb.green  <= (others => '0');
        uFs1Rgb.blue   <= (others => '0');
    elsif rising_edge(clk) then
        uFs1Rgb.red    <= to_ufixed(iRgb.red,uFs1Rgb.red);
        uFs1Rgb.green  <= to_ufixed(iRgb.green,uFs1Rgb.green);
        uFs1Rgb.blue   <= to_ufixed(iRgb.blue,uFs1Rgb.blue);
        uFs1Rgb.valid  <= iRgb.valid;
    end if;
end process rgbToUfP;
pipRgbD2P: process (clk) begin
    if rising_edge(clk) then
        uFs2Rgb <= uFs1Rgb;
        uFs3Rgb <= uFs2Rgb;
        uFs4Rgb <= uFs3Rgb;
        uFs5Rgb <= uFs4Rgb;
    end if;
end process pipRgbD2P;
rgbThreshP: process (clk) begin
    if rising_edge(clk) then
        if ((uFs2Rgb.red >= uFs1Rgb.red )) then
            rgbThresh        <= (uFs2Rgb.red - uFs1Rgb.red);
        else
            rgbThresh        <= (uFs1Rgb.red - uFs2Rgb.red);
        end if;
    end if;
end process rgbThreshP;

rgbThreshP: process (clk) begin
    if rising_edge(clk) then
        if ((rgbThresh >= setThreshold)) then
            rgbValue        <= uFs3Rgb;
        else
            rgbValue        <= uFs3Rgb + uFs4Rgb;
        end if;
    end if;
end process rgbThreshP;
pixelResizeP: process (clk) begin
    if rising_edge(clk) then
        rgbVt <= resize(rgbValue,rgbVt);
    end if;
end process pixelResizeP;

pipValidP: process (clk) begin
    if rising_edge(clk) then
        valid1xD    <= uFs3Rgb.valid;
        valid2xD    <= valid1xD;
        valid3xD    <= valid2xD;
        valid4xD    <= valid3xD;
    end if;
end process pipValidP;
oRgbOut: process (clk) begin
    if rising_edge(clk) then
        oRgb.red      <= std_logic_vector(to_unsigned(rgbVt,8));
        oRgb.green    <= std_logic_vector(to_unsigned(rgbVt,8));
        oRgb.blue     <= std_logic_vector(to_unsigned(rgbVt,8));
        oRgb.valid    <= valid4xD;
    end if;
end process oRgbOut;
end behavioral;