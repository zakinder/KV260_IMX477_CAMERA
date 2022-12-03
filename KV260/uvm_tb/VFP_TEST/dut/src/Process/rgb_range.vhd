-------------------------------------------------------------------------------
--
-- Filename    : rgb_range.vhd
-- Create Date : 02092019 [02-17-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation axi4 components.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity rgb_range is
generic (
    i_data_width      : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end rgb_range;

architecture Behavioral of rgb_range is

    signal i1Rgb       : intChannel;
    signal i2Rgb       : intChannel;
    signal i3Rgb       : intChannel;


begin

process (clk,reset)begin
    if (reset = lo) then
        i1Rgb.red    <= zero;
        i1Rgb.green  <= zero;
        i1Rgb.blue   <= zero;
    elsif rising_edge(clk) then
        i1Rgb.red    <= to_integer(unsigned(iRgb.red));
        i1Rgb.green  <= to_integer(unsigned(iRgb.green));
        i1Rgb.blue   <= to_integer(unsigned(iRgb.blue));
        i1Rgb.valid  <= iRgb.valid;
        i2Rgb.valid  <= i1Rgb.valid;
        i3Rgb        <= i2Rgb;
    end if;
end process;

---------------------------------------------------------------------------------
-- i2Rgb.valid must be 2nd condition else valid value
---------------------------------------------------------------------------------
videoOutP: process (clk) begin
    if rising_edge(clk) then
        if (i1Rgb.red   >= 0 and i1Rgb.red   <= 19) then
            i2Rgb.red           <= 0;
        elsif (i1Rgb.red   >= 20 and i1Rgb.red    <= 39) then
            i2Rgb.red           <= 20;
        elsif (i1Rgb.red   >= 40 and i1Rgb.red    <= 59) then
            i2Rgb.red           <= 40;
        elsif (i1Rgb.red   >= 60 and i1Rgb.red    <= 79) then
            i2Rgb.red           <= 60;
        elsif (i1Rgb.red   >= 80 and i1Rgb.red    <= 89) then
            i2Rgb.red           <= 80;
        elsif (i1Rgb.red   >= 90 and i1Rgb.red    <= 99) then
            i2Rgb.red           <= 80;
        elsif (i1Rgb.red   >= 100 and i1Rgb.red   <= 109) then
            i2Rgb.red           <= 100;
        elsif (i1Rgb.red   >= 110 and i1Rgb.red   <= 119) then
            i2Rgb.red           <= 110;
        elsif (i1Rgb.red   >= 120 and i1Rgb.red   <= 139) then
            i2Rgb.red           <= 120;
        elsif (i1Rgb.red   >= 140 and i1Rgb.red   <= 159) then
            i2Rgb.red           <= 140;
        elsif (i1Rgb.red   >= 160 and i1Rgb.red   <= 179) then
            i2Rgb.red           <= 160;
        elsif (i1Rgb.red   >= 180 and i1Rgb.red   <= 199) then
            i2Rgb.red           <= 180;
        elsif (i1Rgb.red   >= 200 and i1Rgb.red   <= 219) then
            i2Rgb.red           <= 200;
        elsif (i1Rgb.red   >= 220 and i1Rgb.red   <= 239) then
            i2Rgb.red           <= 220;
        elsif (i1Rgb.red   >= 240 and i1Rgb.red   <= 250) then
            i2Rgb.red           <= 240;
        elsif (i1Rgb.red   >= 251 and i1Rgb.red   <= 255) then
            i2Rgb.red           <= 255;
        end if;
    end if;
end process videoOutP;
process (clk) begin
    if rising_edge(clk) then
        if (i1Rgb.green   >= 0 and i1Rgb.green   <= 19) then
            i2Rgb.green           <= 0;
        elsif (i1Rgb.green   >= 20 and i1Rgb.green    <= 39) then
            i2Rgb.green           <= 20;
        elsif (i1Rgb.green   >= 40 and i1Rgb.green    <= 59) then
            i2Rgb.green           <= 40;
        elsif (i1Rgb.green   >= 60 and i1Rgb.green    <= 79) then
            i2Rgb.green           <= 60;
        elsif (i1Rgb.green   >= 80 and i1Rgb.green    <= 89) then
            i2Rgb.green           <= 80;
        elsif (i1Rgb.green   >= 90 and i1Rgb.green    <= 99) then
            i2Rgb.green           <= 80;
        elsif (i1Rgb.green   >= 100 and i1Rgb.green   <= 109) then
            i2Rgb.green           <= 100;
        elsif (i1Rgb.green   >= 110 and i1Rgb.green   <= 119) then
            i2Rgb.green           <= 110;
        elsif (i1Rgb.green   >= 120 and i1Rgb.green   <= 139) then
            i2Rgb.green           <= 120;
        elsif (i1Rgb.green   >= 140 and i1Rgb.green   <= 159) then
            i2Rgb.green           <= 140;
        elsif (i1Rgb.green   >= 160 and i1Rgb.green   <= 179) then
            i2Rgb.green           <= 160;
        elsif (i1Rgb.green   >= 180 and i1Rgb.green   <= 199) then
            i2Rgb.green           <= 180;
        elsif (i1Rgb.green   >= 200 and i1Rgb.green   <= 219) then
            i2Rgb.green           <= 200;
        elsif (i1Rgb.green   >= 220 and i1Rgb.green   <= 239) then
            i2Rgb.green           <= 220;
        elsif (i1Rgb.green   >= 240 and i1Rgb.green   <= 250) then
            i2Rgb.green           <= 240;
        elsif (i1Rgb.green   >= 251 and i1Rgb.green   <= 255) then
            i2Rgb.green           <= 255;
        end if;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if (i1Rgb.blue   >= 0 and i1Rgb.blue   <= 19) then
            i2Rgb.blue           <= 0;
        elsif (i1Rgb.blue   >= 20 and i1Rgb.blue    <= 39) then
            i2Rgb.blue           <= 20;
        elsif (i1Rgb.blue   >= 40 and i1Rgb.blue    <= 59) then
            i2Rgb.blue           <= 40;
        elsif (i1Rgb.blue   >= 60 and i1Rgb.blue    <= 79) then
            i2Rgb.blue           <= 60;
        elsif (i1Rgb.blue   >= 80 and i1Rgb.blue    <= 89) then
            i2Rgb.blue           <= 80;
        elsif (i1Rgb.blue   >= 90 and i1Rgb.blue    <= 99) then
            i2Rgb.blue           <= 80;
        elsif (i1Rgb.blue   >= 100 and i1Rgb.blue   <= 109) then
            i2Rgb.blue           <= 100;
        elsif (i1Rgb.blue   >= 110 and i1Rgb.blue   <= 119) then
            i2Rgb.blue           <= 110;
        elsif (i1Rgb.blue   >= 120 and i1Rgb.blue   <= 139) then
            i2Rgb.blue           <= 120;
        elsif (i1Rgb.blue   >= 140 and i1Rgb.blue   <= 159) then
            i2Rgb.blue           <= 140;
        elsif (i1Rgb.blue   >= 160 and i1Rgb.blue   <= 179) then
            i2Rgb.blue           <= 160;
        elsif (i1Rgb.blue   >= 180 and i1Rgb.blue   <= 199) then
            i2Rgb.blue           <= 180;
        elsif (i1Rgb.blue   >= 200 and i1Rgb.blue   <= 219) then
            i2Rgb.blue           <= 200;
        elsif (i1Rgb.blue   >= 220 and i1Rgb.blue   <= 239) then
            i2Rgb.blue           <= 220;
        elsif (i1Rgb.blue   >= 240 and i1Rgb.blue   <= 250) then
            i2Rgb.blue           <= 240;
        elsif (i1Rgb.blue   >= 251 and i1Rgb.blue   <= 255) then
            i2Rgb.blue           <= 255;
        end if;
    end if;
end process;

 oRgb.red   <= std_logic_vector(to_unsigned(i2Rgb.red, 8));
 oRgb.green <= std_logic_vector(to_unsigned(i2Rgb.green, 8));
 oRgb.blue  <= std_logic_vector(to_unsigned(i2Rgb.blue, 8));
 oRgb.valid <= i3Rgb.valid;
 
end Behavioral;