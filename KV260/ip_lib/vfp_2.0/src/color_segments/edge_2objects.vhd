-------------------------------------------------------------------------------
--
-- Filename    : edge_objects.vhd
-- Create Date : 04282019 [04-28-2019]
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

entity edge_objects2 is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    oRgbRemix      : out channel);
end entity;

architecture arch of edge_objects2 is

    signal rgb1Int          : intChannel;
    signal rgb2Int          : intChannel;
    signal rgb3Int          : intChannel;
    signal rgbMax           : integer;
    signal rgbMin           : integer;
    signal rgbSyncEol       : std_logic_vector(3 downto 0) := x"0";
    signal rgbSyncSof       : std_logic_vector(3 downto 0) := x"0";
    signal rgbSyncEof       : std_logic_vector(3 downto 0) := x"0";
    signal rgbSyncValid     : std_logic_vector(3 downto 0) := x"0";
    signal degRed           : integer;
    signal degGreen         : integer;
    signal degBlue           : integer;
begin
process (clk)begin
    if rising_edge(clk) then
      rgbSyncValid(0)  <= iRgb.valid;
      rgbSyncValid(1)  <= rgbSyncValid(0);
      rgbSyncValid(2)  <= rgbSyncValid(1);
      rgbSyncValid(3)  <= rgbSyncValid(2);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEol(0)  <= iRgb.eol;
      rgbSyncEol(1)  <= rgbSyncEol(0);
      rgbSyncEol(2)  <= rgbSyncEol(1);
      rgbSyncEol(3)  <= rgbSyncEol(2);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncSof(0)  <= iRgb.sof;
      rgbSyncSof(1)  <= rgbSyncSof(0);
      rgbSyncSof(2)  <= rgbSyncSof(1);
      rgbSyncSof(3)  <= rgbSyncSof(2);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEof(0)  <= iRgb.eof;
      rgbSyncEof(1)  <= rgbSyncEof(0);
      rgbSyncEof(2)  <= rgbSyncEof(1);
      rgbSyncEof(3)  <= rgbSyncEof(2);
    end if;
end process;
piplRgbBlurXP : process (clk) begin
    if rising_edge(clk) then
      rgb1Int.red      <= to_integer(unsigned(iRgb.red));
      rgb1Int.green    <= to_integer(unsigned(iRgb.green));
      rgb1Int.blue     <= to_integer(unsigned(iRgb.blue));
      rgb1Int.valid    <= iRgb.valid;
      rgb2Int          <= rgb1Int;
      rgb3Int          <= rgb2Int;
    end if;
end process piplRgbBlurXP;
process (clk) begin
    if rising_edge(clk) then
        if ((rgb1Int.red >= rgb1Int.green) and (rgb1Int.red >= rgb1Int.blue)) then
            rgbMax <= rgb1Int.red;
        elsif((rgb1Int.green >= rgb1Int.red) and (rgb1Int.green >= rgb1Int.blue))then
            rgbMax <= rgb1Int.green;
        else
            rgbMax <= rgb1Int.blue;
        end if;
    end if;
end process;

rgbMaxP: process (clk) begin
    if rising_edge(clk) then 
    if (rgb2Int.green = 0) and (rgb2Int.blue = 0) then
        if (rgb2Int.red >= 250 and rgb2Int.red <= 255) then
            degRed <= 255;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 240 and rgb2Int.red < 250) then
            degRed <= 240;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 200 and rgb2Int.red < 225) then
            degRed <= 200;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 175 and rgb2Int.red < 200) then
            degRed <= 175;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 150 and rgb2Int.red < 175) then
            degRed <= 150;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 125 and rgb2Int.red < 150) then
            degRed <= 125;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 100 and rgb2Int.red < 125) then
            degRed <= 100;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 75 and rgb2Int.red < 100) then
            degRed <= 75;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 50 and rgb2Int.red < 75) then
            degRed <= 50;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 25 and rgb2Int.red < 50) then
            degRed <= 25;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 10 and rgb2Int.red < 25) then
            degRed <= 10;degGreen <= 0;degBlue <= 0;
        elsif(rgb2Int.red >= 0 and rgb2Int.red < 10) then
            degRed <= 0;degGreen <= 0;degBlue <= 0;
        else
            degRed <= 255;degGreen <= 255;degBlue <= 255;
        end if;
    elsif (rgb2Int.red = 0) and (rgb2Int.blue = 0) then
        if (rgb2Int.green >= 250 and rgb2Int.green <= 255) then
            degGreen <= 255;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 240 and rgb2Int.green < 250) then
            degGreen <= 240;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 200 and rgb2Int.green < 225) then
            degGreen <= 200;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 175 and rgb2Int.green < 200) then
            degGreen <= 175;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 150 and rgb2Int.green < 175) then
            degGreen <= 150;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 125 and rgb2Int.green < 150) then
            degGreen <= 125;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 100 and rgb2Int.green < 125) then
            degGreen <= 100;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 75 and rgb2Int.green < 100) then
            degGreen <= 75;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 50 and rgb2Int.green < 75) then
            degGreen <= 50;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 25 and rgb2Int.green < 50) then
            degGreen <= 25;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 10 and rgb2Int.green < 25) then
            degGreen <= 10;degRed <= 0;degBlue <= 0;
        elsif(rgb2Int.green >= 0 and rgb2Int.green < 10) then
            degGreen <= 0; degRed <= 0;degBlue <= 0;
        else
            degGreen <= 255; degRed <= 255;degBlue <= 255;
        end if;
    elsif (rgb2Int.green = 0) and (rgb2Int.red = 0) then
        if (rgb2Int.blue >= 250 and rgb2Int.blue <= 255) then
            degBlue <= 255;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 240 and rgb2Int.blue < 250) then
            degBlue <= 240;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 200 and rgb2Int.blue < 225) then
            degBlue <= 200;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 175 and rgb2Int.blue < 200) then
            degBlue <= 175;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 150 and rgb2Int.blue < 175) then
            degBlue <= 150;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 125 and rgb2Int.blue < 150) then
            degBlue <= 125;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 100 and rgb2Int.blue < 125) then
            degBlue <= 100;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 75 and rgb2Int.blue < 100) then
            degBlue <= 75;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 50 and rgb2Int.blue < 75) then
            degBlue <= 50;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 25 and rgb2Int.blue < 50) then
            degBlue <= 25;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 10 and rgb2Int.blue < 25) then
            degBlue <= 10;degGreen <= 0;degRed <= 0;
        elsif(rgb2Int.blue >= 0 and rgb2Int.blue < 10) then
            degBlue <= 0;degGreen <= 0;degRed <= 0;
        else
            degBlue <= 255;degGreen <= 255;degRed <= 255;
        end if;
    elsif (rgb2Int.red = 255) and (rgb2Int.blue = 0) then
        if (rgb2Int.green >= 250 and rgb2Int.green <= 255) then
            degGreen <= 255;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 240 and rgb2Int.green < 250) then
            degGreen <= 240;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 200 and rgb2Int.green < 225) then
            degGreen <= 200;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 175 and rgb2Int.green < 200) then
            degGreen <= 175;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 150 and rgb2Int.green < 175) then
            degGreen <= 150;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 125 and rgb2Int.green < 150) then
            degGreen <= 125;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 100 and rgb2Int.green < 125) then
            degGreen <= 100;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 75 and rgb2Int.green < 100) then
            degGreen <= 75;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 50 and rgb2Int.green < 75) then
            degGreen <= 50;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 25 and rgb2Int.green < 50) then
            degGreen <= 25;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 10 and rgb2Int.green < 25) then
            degGreen <= 10;degRed <= 255;degBlue <= 0;
        elsif(rgb2Int.green >= 0 and rgb2Int.green < 10) then
            degGreen <= 255;degRed <= 255;degBlue <= 0;
        else
            degGreen <= 255; degRed <= 255;degBlue <= 255;
        end if;
    elsif (rgb2Int.blue = 255) and (rgb2Int.red = 0) then
        if (rgb2Int.green >= 250 and rgb2Int.green <= 255) then
            degGreen <= 255;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 240 and rgb2Int.green < 250) then
            degGreen <= 240;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 200 and rgb2Int.green < 225) then
            degGreen <= 200;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 175 and rgb2Int.green < 200) then
            degGreen <= 175;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 150 and rgb2Int.green < 175) then
            degGreen <= 150;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 125 and rgb2Int.green < 150) then
            degGreen <= 125;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 100 and rgb2Int.green < 125) then
            degGreen <= 100;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 75 and rgb2Int.green < 100) then
            degGreen <= 75;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 50 and rgb2Int.green < 75) then
            degGreen <= 50;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 25 and rgb2Int.green < 50) then
            degGreen <= 25;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 10 and rgb2Int.green < 25) then
            degGreen <= 10;degRed <= 0;degBlue <= 255;
        elsif(rgb2Int.green >= 0 and rgb2Int.green < 10) then
            degGreen <= 0;degRed <= 0;degBlue <= 255;
        end if;
--    elsif (rgb2Int.green = 255) then
--        if(rgb2Int.blue >= 224 and rgb2Int.blue < 256) then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 224;degGreen <= 255;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 224;degGreen <= 255;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 224;degGreen <= 255;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 224;degGreen <= 255;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 224;degGreen <= 255;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 224;degGreen <= 255;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 224;degGreen <= 255;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 224;degGreen <= 255;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224)then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 192;degGreen <= 255;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 192;degGreen <= 255;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 192;degGreen <= 255;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 192;degGreen <= 255;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 192;degGreen <= 255;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 192;degGreen <= 255;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 192;degGreen <= 255;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 192;degGreen <= 255;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 192)then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 160;degGreen <= 255;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 160;degGreen <= 255;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 160;degGreen <= 255;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 160;degGreen <= 255;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 160;degGreen <= 255;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 160;degGreen <= 255;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 160;degGreen <= 255;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 160;degGreen <= 255;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 160)then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 128;degGreen <= 255;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 128;degGreen <= 255;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 128;degGreen <= 255;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 128;degGreen <= 255;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 128;degGreen <= 255;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 128;degGreen <= 255;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 128;degGreen <= 255;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 128;degGreen <= 255;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 128)then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 96;degGreen <= 255;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 96;degGreen <= 255;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 96;degGreen <= 255;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 96;degGreen <= 255;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 96;degGreen <= 255;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 96;degGreen <= 255;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 96;degGreen <= 255;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 96;degGreen <= 255;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 96) then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 64;degGreen <= 255;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 64;degGreen <= 255;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 64;degGreen <= 255;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 64;degGreen <= 255;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 64;degGreen <= 255;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 64;degGreen <= 255;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 64;degGreen <= 255;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 64;degGreen <= 255;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 32;degGreen <= 255;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 32;degGreen <= 255;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 32;degGreen <= 255;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 32;degGreen <= 255;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 32;degGreen <= 255;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 32;degGreen <= 255;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 32;degGreen <= 255;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 32;degGreen <= 255;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 0;degGreen <= 255;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 0;degGreen <= 255;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 0;degGreen <= 255;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 0;degGreen <= 255;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 0;degGreen <= 255;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 0;degGreen <= 255;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 0;degGreen <= 255;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 0;degGreen <= 255;degRed <= 224;
--            end if;
--        end if;
--    elsif (rgb2Int.blue = 255) then
--        if(rgb2Int.red >= 224 and rgb2Int.red < 256) then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 224;degBlue <= 255;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 224;degBlue <= 255;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 224;degBlue <= 255;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 224;degBlue <= 255;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 224;degBlue <= 255;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 224;degBlue <= 255;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 224;degBlue <= 255;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 224;degBlue <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 192 and rgb2Int.red < 224)then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 192;degBlue <= 255;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 192;degBlue <= 255;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 192;degBlue <= 255;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 192;degBlue <= 255;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 192;degBlue <= 255;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 192;degBlue <= 255;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 192;degBlue <= 255;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 192;degBlue <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 160 and rgb2Int.red < 192)then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 160;degBlue <= 255;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 160;degBlue <= 255;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 160;degBlue <= 255;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 160;degBlue <= 255;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 160;degBlue <= 255;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 160;degBlue <= 255;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 160;degBlue <= 255;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 160;degBlue <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 128 and rgb2Int.red < 160)then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 128;degBlue <= 255;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 128;degBlue <= 255;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 128;degBlue <= 255;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 128;degBlue <= 255;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 128;degBlue <= 255;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 128;degBlue <= 255;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 128;degBlue <= 255;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 128;degBlue <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 96 and rgb2Int.red < 128)then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 96;degBlue <= 255;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 96;degBlue <= 255;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 96;degBlue <= 255;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 96;degBlue <= 255;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 96;degBlue <= 255;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 96;degBlue <= 255;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 96;degBlue <= 255;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 96;degBlue <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 64 and rgb2Int.red < 96) then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 64;degBlue <= 255;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 64;degBlue <= 255;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 64;degBlue <= 255;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 64;degBlue <= 255;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 64;degBlue <= 255;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 64;degBlue <= 255;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 64;degBlue <= 255;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 64;degBlue <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 32;degBlue <= 255;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 32;degBlue <= 255;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 32;degBlue <= 255;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 32;degBlue <= 255;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 32;degBlue <= 255;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 32;degBlue <= 255;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 32;degBlue <= 255;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 32;degBlue <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 0 and rgb2Int.red < 32) then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 0;degBlue <= 255;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 0;degBlue <= 255;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 0;degBlue <= 255;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 0;degBlue <= 255;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 0;degBlue <= 255;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 0;degBlue <= 255;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 0;degBlue <= 255;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 0;degBlue <= 255;degGreen <= 224;
--            end if;
--        end if;
--    elsif (rgb2Int.red = 255) then
--        if(rgb2Int.green >= 224 and rgb2Int.green < 256) then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 224;degRed <= 255;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 224;degRed <= 255;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 224;degRed <= 255;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 224;degRed <= 255;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 224;degRed <= 255;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 224;degRed <= 255;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 224;degRed <= 255;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 224;degRed <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 192 and rgb2Int.green < 224)then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 192;degRed <= 255;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 192;degRed <= 255;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 192;degRed <= 255;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 192;degRed <= 255;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 192;degRed <= 255;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 192;degRed <= 255;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 192;degRed <= 255;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 192;degRed <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 160 and rgb2Int.green < 192)then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 160;degRed <= 255;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 160;degRed <= 255;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 160;degRed <= 255;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 160;degRed <= 255;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 160;degRed <= 255;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 160;degRed <= 255;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 160;degRed <= 255;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 160;degRed <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 128 and rgb2Int.green < 160)then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 128;degRed <= 255;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 128;degRed <= 255;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 128;degRed <= 255;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 128;degRed <= 255;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 128;degRed <= 255;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 128;degRed <= 255;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 128;degRed <= 255;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 128;degRed <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 96 and rgb2Int.green < 128)then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 96;degRed <= 255;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 96;degRed <= 255;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 96;degRed <= 255;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 96;degRed <= 255;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 96;degRed <= 255;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 96;degRed <= 255;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 96;degRed <= 255;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 96;degRed <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 64 and rgb2Int.green < 96) then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 64;degRed <= 255;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 64;degRed <= 255;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 64;degRed <= 255;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 64;degRed <= 255;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 64;degRed <= 255;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 64;degRed <= 255;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 64;degRed <= 255;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 64;degRed <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 32;degRed <= 255;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 32;degRed <= 255;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 32;degRed <= 255;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 32;degRed <= 255;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 32;degRed <= 255;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 32;degRed <= 255;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 32;degRed <= 255;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 32;degRed <= 255;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 0 and rgb2Int.green < 32) then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 0;degRed <= 255;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 0;degRed <= 255;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 0;degRed <= 255;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 0;degRed <= 255;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 0;degRed <= 255;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 0;degRed <= 255;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 0;degRed <= 255;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 0;degRed <= 255;degGreen <= 224;
--            end if;
--        end if;
--    elsif (rgb2Int.red = 0) then
--        if(rgb2Int.green >= 224 and rgb2Int.green < 256) then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 224;degRed <= 0;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 224;degRed <= 0;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 224;degRed <= 0;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 224;degRed <= 0;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 224;degRed <= 0;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 224;degRed <= 0;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 224;degRed <= 0;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 224;degRed <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 192 and rgb2Int.green < 224)then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 192;degRed <= 0;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 192;degRed <= 0;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 192;degRed <= 0;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 192;degRed <= 0;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 192;degRed <= 0;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 192;degRed <= 0;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 192;degRed <= 0;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 192;degRed <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 160 and rgb2Int.green < 192)then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 160;degRed <= 0;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 160;degRed <= 0;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 160;degRed <= 0;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 160;degRed <= 0;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 160;degRed <= 0;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 160;degRed <= 0;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 160;degRed <= 0;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 160;degRed <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 128 and rgb2Int.green < 160)then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 128;degRed <= 0;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 128;degRed <= 0;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 128;degRed <= 0;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 128;degRed <= 0;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 128;degRed <= 0;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 128;degRed <= 0;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 128;degRed <= 0;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 128;degRed <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 96 and rgb2Int.green < 128)then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 96;degRed <= 0;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 96;degRed <= 0;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 96;degRed <= 0;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 96;degRed <= 0;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 96;degRed <= 0;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 96;degRed <= 0;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 96;degRed <= 0;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 96;degRed <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 64 and rgb2Int.green < 96) then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 64;degRed <= 0;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 64;degRed <= 0;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 64;degRed <= 0;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 64;degRed <= 0;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 64;degRed <= 0;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 64;degRed <= 0;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 64;degRed <= 0;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 64;degRed <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 32;degRed <= 0;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 32;degRed <= 0;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 32;degRed <= 0;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 32;degRed <= 0;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 32;degRed <= 0;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 32;degRed <= 0;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 32;degRed <= 0;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 32;degRed <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.green >= 0 and rgb2Int.green < 32) then
--            if (rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--                degBlue <= 0;degRed <= 0;degGreen <= 0;
--            elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--                degBlue <= 0;degRed <= 0;degGreen <= 32;
--            elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128) then
--                degBlue <= 0;degRed <= 0;degGreen <= 64;
--            elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 64) then
--                degBlue <= 0;degRed <= 0;degGreen <= 96;
--            elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 96) then
--                degBlue <= 0;degRed <= 0;degGreen <= 128;
--            elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 128) then
--                degBlue <= 0;degRed <= 0;degGreen <= 160;
--            elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224) then
--                degBlue <= 0;degRed <= 0;degGreen <= 192;
--            elsif(rgb2Int.blue >= 224 and rgb2Int.blue <= 256) then
--                degBlue <= 0;degRed <= 0;degGreen <= 224;
--            end if;
--        end if;
--    elsif (rgb2Int.blue = 0) then
--        if(rgb2Int.red >= 224 and rgb2Int.red < 256) then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 224;degBlue <= 0;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 224;degBlue <= 0;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 224;degBlue <= 0;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 224;degBlue <= 0;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 224;degBlue <= 0;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 224;degBlue <= 0;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 224;degBlue <= 0;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 224;degBlue <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 192 and rgb2Int.red < 224)then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 192;degBlue <= 0;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 192;degBlue <= 0;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 192;degBlue <= 0;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 192;degBlue <= 0;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 192;degBlue <= 0;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 192;degBlue <= 0;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 192;degBlue <= 0;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 192;degBlue <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 160 and rgb2Int.red < 192)then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 160;degBlue <= 0;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 160;degBlue <= 0;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 160;degBlue <= 0;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 160;degBlue <= 0;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 160;degBlue <= 0;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 160;degBlue <= 0;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 160;degBlue <= 0;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 160;degBlue <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 128 and rgb2Int.red < 160)then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 128;degBlue <= 0;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 128;degBlue <= 0;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 128;degBlue <= 0;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 128;degBlue <= 0;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 128;degBlue <= 0;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 128;degBlue <= 0;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 128;degBlue <= 0;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 128;degBlue <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 96 and rgb2Int.red < 128)then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 96;degBlue <= 0;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 96;degBlue <= 0;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 96;degBlue <= 0;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 96;degBlue <= 0;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 96;degBlue <= 0;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 96;degBlue <= 0;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 96;degBlue <= 0;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 96;degBlue <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 64 and rgb2Int.red < 96) then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 64;degBlue <= 0;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 64;degBlue <= 0;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 64;degBlue <= 0;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 64;degBlue <= 0;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 64;degBlue <= 0;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 64;degBlue <= 0;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 64;degBlue <= 0;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 64;degBlue <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 32;degBlue <= 0;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 32;degBlue <= 0;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 32;degBlue <= 0;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 32;degBlue <= 0;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 32;degBlue <= 0;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 32;degBlue <= 0;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 32;degBlue <= 0;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 32;degBlue <= 0;degGreen <= 224;
--            end if;
--        elsif(rgb2Int.red >= 0 and rgb2Int.red < 32) then
--            if (rgb2Int.green >= 0 and rgb2Int.green < 32) then
--                degRed <= 0;degBlue <= 0;degGreen <= 0;
--            elsif(rgb2Int.green >= 32 and rgb2Int.green < 64) then
--                degRed <= 0;degBlue <= 0;degGreen <= 32;
--            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) then
--                degRed <= 0;degBlue <= 0;degGreen <= 64;
--            elsif(rgb2Int.green >= 96 and rgb2Int.green < 64) then
--                degRed <= 0;degBlue <= 0;degGreen <= 96;
--            elsif(rgb2Int.green >= 128 and rgb2Int.green < 96) then
--                degRed <= 0;degBlue <= 0;degGreen <= 128;
--            elsif(rgb2Int.green >= 160 and rgb2Int.green < 128) then
--                degRed <= 0;degBlue <= 0;degGreen <= 160;
--            elsif(rgb2Int.green >= 192 and rgb2Int.green < 224) then
--                degRed <= 0;degBlue <= 0;degGreen <= 192;
--            elsif(rgb2Int.green >= 224 and rgb2Int.green <= 256) then
--                degRed <= 0;degBlue <= 0;degGreen <= 224;
--            end if;
--        end if;
--    elsif (rgb2Int.green = 0) then
--        if(rgb2Int.blue >= 224 and rgb2Int.blue < 256) then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 224;degGreen <= 0;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 224;degGreen <= 0;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 224;degGreen <= 0;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 224;degGreen <= 0;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 224;degGreen <= 0;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 224;degGreen <= 0;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 224;degGreen <= 0;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 224;degGreen <= 0;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 192 and rgb2Int.blue < 224)then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 192;degGreen <= 0;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 192;degGreen <= 0;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 192;degGreen <= 0;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 192;degGreen <= 0;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 192;degGreen <= 0;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 192;degGreen <= 0;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 192;degGreen <= 0;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 192;degGreen <= 0;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 160 and rgb2Int.blue < 192)then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 160;degGreen <= 0;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 160;degGreen <= 0;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 160;degGreen <= 0;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 160;degGreen <= 0;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 160;degGreen <= 0;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 160;degGreen <= 0;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 160;degGreen <= 0;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 160;degGreen <= 0;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 160)then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 128;degGreen <= 0;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 128;degGreen <= 0;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 128;degGreen <= 0;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 128;degGreen <= 0;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 128;degGreen <= 0;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 128;degGreen <= 0;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 128;degGreen <= 0;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 128;degGreen <= 0;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 96 and rgb2Int.blue < 128)then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 96;degGreen <= 0;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 96;degGreen <= 0;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 96;degGreen <= 0;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 96;degGreen <= 0;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 96;degGreen <= 0;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 96;degGreen <= 0;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 96;degGreen <= 0;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 96;degGreen <= 0;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 96) then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 64;degGreen <= 0;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 64;degGreen <= 0;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 64;degGreen <= 0;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 64;degGreen <= 0;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 64;degGreen <= 0;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 64;degGreen <= 0;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 64;degGreen <= 0;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 64;degGreen <= 0;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 32 and rgb2Int.blue < 64) then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 32;degGreen <= 0;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 32;degGreen <= 0;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 32;degGreen <= 0;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 32;degGreen <= 0;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 32;degGreen <= 0;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 32;degGreen <= 0;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 32;degGreen <= 0;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 32;degGreen <= 0;degRed <= 224;
--            end if;
--        elsif(rgb2Int.blue >= 0 and rgb2Int.blue < 32) then
--            if (rgb2Int.red >= 0 and rgb2Int.red < 32) then
--                degBlue <= 0;degGreen <= 0;degRed <= 0;
--            elsif(rgb2Int.red >= 32 and rgb2Int.red < 64) then
--                degBlue <= 0;degGreen <= 0;degRed <= 32;
--            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) then
--                degBlue <= 0;degGreen <= 0;degRed <= 64;
--            elsif(rgb2Int.red >= 96 and rgb2Int.red < 64) then
--                degBlue <= 0;degGreen <= 0;degRed <= 96;
--            elsif(rgb2Int.red >= 128 and rgb2Int.red < 96) then
--                degBlue <= 0;degGreen <= 0;degRed <= 128;
--            elsif(rgb2Int.red >= 160 and rgb2Int.red < 128) then
--                degBlue <= 0;degGreen <= 0;degRed <= 160;
--            elsif(rgb2Int.red >= 192 and rgb2Int.red < 224) then
--                degBlue <= 0;degGreen <= 0;degRed <= 192;
--            elsif(rgb2Int.red >= 224 and rgb2Int.red <= 256) then
--                degBlue <= 0;degGreen <= 0;degRed <= 224;
--            end if;
--        end if;
--    ------------------------------------------------------------------------------------------
--    -- GRAY
--    ------------------------------------------------------------------------------------------
--    
--    
    
    elsif ((abs(rgb2Int.red - rgb2Int.green) <= 3) and (abs(rgb2Int.red - rgb2Int.blue) <= 3 )) then
        if (rgb2Int.blue >= 250 and rgb2Int.blue <= 255) then
            degRed <= 255;degGreen <= 255;degBlue <= 255;
        elsif(rgb2Int.blue >= 240 and rgb2Int.blue < 250) then
            degRed <= 240;degGreen <= 240;degBlue <= 240;
        elsif(rgb2Int.blue >= 200 and rgb2Int.blue < 225) then
            degRed <= 200;degGreen <= 200;degBlue <= 200;
        elsif(rgb2Int.blue >= 175 and rgb2Int.blue < 200) then
            degRed <= 175;degGreen <= 175;degBlue <= 175;
        elsif(rgb2Int.blue >= 150 and rgb2Int.blue < 175) then
            degRed <= 150;degGreen <= 150;degBlue <= 150;
        elsif(rgb2Int.blue >= 125 and rgb2Int.blue < 150) then
            degRed <= 125;degGreen <= 125;degBlue <= 125;
        elsif(rgb2Int.blue >= 100 and rgb2Int.blue < 125) then
            degRed <= 100;degGreen <= 100;degBlue <= 100;
        elsif(rgb2Int.blue >= 75 and rgb2Int.blue < 100) then
            degRed <= 75;degGreen <= 75;degBlue <= 75;
        elsif(rgb2Int.blue >= 50 and rgb2Int.blue < 75) then
            degRed <= 50;degGreen <= 50;degBlue <= 50;
        elsif(rgb2Int.blue >= 25 and rgb2Int.blue < 50) then
            degRed <= 25;degGreen <= 25;degBlue <= 25;
        elsif(rgb2Int.blue >= 10 and rgb2Int.blue < 25) then
            degRed <= 10;degGreen <= 10;degBlue <= 10;
        elsif(rgb2Int.blue >= 0 and rgb2Int.blue < 10) then
            degRed <= 0;degGreen <= 0;degBlue <= 50;
        end if;
    ------------------------------------------------------------------------------------------
    -- RED IS MAX
    ------------------------------------------------------------------------------------------
    elsif(rgb2Int.red = rgbMax) then
                    if (rgb2Int.red >= 200 and rgb2Int.red <= 255) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 245;degGreen <= 230;degBlue <= 220;--223
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 230;degGreen <= 224;degBlue <= 208;--223
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 236;degGreen <= 225;degBlue <= 127;--222
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 213;degGreen <= 199;degBlue <= 80;--221
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 200;degBlue <= 50;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 200;degGreen <= 175;degBlue <= 200;--219
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 239;degGreen <= 186;degBlue <= 170;--218
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 229;degGreen <= 180;degBlue <= 156;--217
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 202;degGreen <= 188;degBlue <= 93;--216
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 205;degGreen <= 193;degBlue <= 39;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                                  if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 253;degGreen <= 96;degBlue <= 203;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 111;degGreen <= 105;degBlue <= 133;--213
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 231;degGreen <= 170;degBlue <= 156;--212
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 232;degGreen <= 99;degBlue <= 89;--211
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 225;degGreen <= 125;degBlue <= 25;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 219;degGreen <= 55;degBlue <= 88;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 212;degGreen <= 53;degBlue <= 85;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 228;degGreen <= 93;degBlue <= 94;--207
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 233;degGreen <= 95;degBlue <= 90;--206
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 107;degGreen <= 37;degBlue <= 34;
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 240;degGreen <= 100;degBlue <= 210;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 231;degGreen <= 39;degBlue <= 205;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 199;degGreen <= 50;degBlue <= 80;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 214;degGreen <= 54;degBlue <= 86;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 89;degGreen <= 31;degBlue <= 28;
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 150 and rgb2Int.red < 200) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 178;degGreen <= 223;degBlue <= 255;--199
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 199;degGreen <= 255;degBlue <= 175;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 199;degGreen <= 255;degBlue <= 125;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 196;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 195;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 161;degGreen <= 205;degBlue <= 230;--194
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 108;degGreen <= 102;degBlue <= 100;--193
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 192;degGreen <= 150;degBlue <= 127;--192
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 69;degGreen <= 56;degBlue <= 30;--191
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 199;degGreen <= 200;degBlue <= 25;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 189;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 145;degGreen <= 121;degBlue <= 117;--188
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 181;degGreen <= 145;degBlue <= 127;--187
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 159;degGreen <= 116;degBlue <= 99;--186
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 160;degGreen <= 151;degBlue <= 34;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 184;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 183;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 109;degGreen <= 113;degBlue <= 140;--182
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 150;degGreen <= 100;degBlue <= 91;--181
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 58;degGreen <= 13;degBlue <= 9;--180
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 179;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 178;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 201;degGreen <= 51;degBlue <= 81;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 200;degGreen <= 50;degBlue <= 80;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 83;degGreen <= 13;degBlue <= 14;--175
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 100 and rgb2Int.red < 150) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 147;degGreen <= 201;degBlue <= 251;--174
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 173;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 172;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 171;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 170;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 136;degGreen <= 184;degBlue <= 224;--169
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 132;degGreen <= 167;degBlue <= 197;--168
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 167;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 166;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 165;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 164;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 106;degGreen <= 140;degBlue <= 165;--190
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 149;degGreen <= 147;degBlue <= 146;--162
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 150;degGreen <= 150;degBlue <= 75;--161
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 153;degGreen <= 145;degBlue <= 27;--160
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 159;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 158;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 135;degGreen <= 148;degBlue <= 177;--157
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 155;degGreen <= 109;degBlue <= 89;--156
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 103;degGreen <= 56;degBlue <= 43;--155
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 154;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 153;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 146;degGreen <= 100;degBlue <= 150;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 202;degGreen <= 84;degBlue <= 87;--151
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 86;degGreen <= 30;degBlue <= 27;--150
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 50 and rgb2Int.red < 100) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 149;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 148;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 147;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 146;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 145;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 76;degGreen <= 180;degBlue <= 231;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 143;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 142;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 141;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 140;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 139;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 93;degGreen <= 134;degBlue <= 170;--138
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 103;degGreen <= 124;degBlue <= 141;--137
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 136;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 135;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 134;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 133;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 84;degGreen <= 99;degBlue <= 106;--132
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 86;degGreen <= 71;degBlue <= 67;--131
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 93;degGreen <= 59;degBlue <= 49;--130
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 129;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 128;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 127;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 100;degGreen <= 50;degBlue <= 75;--126
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 64;degGreen <= 37;degBlue <= 30;--125
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 0 and rgb2Int.red < 50) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 124;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 123;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 122;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 121;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 120;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 119;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 118;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 117;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 116;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 115;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 114;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 113;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 112;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 111;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 110;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 109;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 108;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 51;degGreen <= 80;degBlue <= 109;--107
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 41;degGreen <= 49;degBlue <= 59;--106
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 63;degGreen <= 64;degBlue <= 59;--105
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 104;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 103;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 102;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 39;degGreen <= 48;degBlue <= 57;--101
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 44;degGreen <= 41;degBlue <= 41;--101
                            end if;
                        end if;
                 end if;
    ------------------------------------------------------------------------------------------
    -- GREEN IS MAX
    ------------------------------------------------------------------------------------------
    elsif(rgb2Int.green = rgbMax) then
                    if (rgb2Int.red >= 200 and rgb2Int.red <= 255) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 255;degGreen <= 255;degBlue <= 255;--223
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 150;degGreen <= 255;degBlue <= 200;--223
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 230;degGreen <= 255;degBlue <= 100;--222
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 220;degGreen <= 255;degBlue <= 50;--221
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 200;degGreen <= 255;degBlue <= 10;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 126;degGreen <= 200;degBlue <= 95;--219
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 239;degGreen <= 200;degBlue <= 170;--218
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 229;degGreen <= 200;degBlue <= 156;--217
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 202;degGreen <= 200;degBlue <= 93;--216
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 200;degBlue <= 215;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                                  if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 214;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 111;degGreen <= 105;degBlue <= 133;--213
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 231;degGreen <= 170;degBlue <= 156;--212
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 232;degGreen <= 99;degBlue <= 89;--211
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 210;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 209;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 208;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 228;degGreen <= 93;degBlue <= 94;--207
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 233;degGreen <= 95;degBlue <= 90;--206
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 205;
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 204;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 200;degGreen <= 31;degBlue <= 195;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 202;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 201;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 200;
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 150 and rgb2Int.red < 200) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 178;degGreen <= 223;degBlue <= 255;--199
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 140;degGreen <= 200;degBlue <= 230;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 197;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 119;degGreen <= 158;degBlue <= 130;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 190;degGreen <= 255;degBlue <= 57;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 150;degGreen <= 200;degBlue <= 200;--194
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 150;degGreen <= 200;degBlue <= 150;--193
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 180;degGreen <= 200;degBlue <= 100;--192
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 170;degGreen <= 200;degBlue <= 50;--191
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 150;degGreen <= 200;degBlue <= 10;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 189;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 145;degGreen <= 121;degBlue <= 117;--188
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 181;degGreen <= 145;degBlue <= 127;--187
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 159;degGreen <= 116;degBlue <= 99;--186
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 185;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 184;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 183;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 109;degGreen <= 113;degBlue <= 140;--182
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 182;degGreen <= 69;degBlue <= 62;--181
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 58;degGreen <= 13;degBlue <= 9;--180
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 179;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 178;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 177;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 176;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 83;degGreen <= 13;degBlue <= 14;--175
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 100 and rgb2Int.red < 150) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 147;degGreen <= 201;degBlue <= 251;--174
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 130;degGreen <= 180;degBlue <= 150;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 145;degGreen <= 201;degBlue <= 102;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 137;degGreen <= 201;degBlue <= 102;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 70;degGreen <= 180;degBlue <= 50;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 136;degGreen <= 184;degBlue <= 224;--169
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 132;degGreen <= 167;degBlue <= 197;--168
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 138;degGreen <= 191;degBlue <= 97;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 130;degGreen <= 191;degBlue <= 97;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 75;degGreen <= 90;degBlue <= 45;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 150;degGreen <= 150;degBlue <= 200;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 150;degGreen <= 150;degBlue <= 150;--190
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 140;degGreen <= 150;degBlue <= 100;--162
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 130;degGreen <= 150;degBlue <= 50;--161
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 130;degGreen <= 150;degBlue <= 10;--160
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 159;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 158;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 135;degGreen <= 148;degBlue <= 177;--157
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 155;degGreen <= 109;degBlue <= 89;--156
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 103;degGreen <= 56;degBlue <= 43;--155
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 154;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 153;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 152;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 202;degGreen <= 84;degBlue <= 87;--151
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 86;degGreen <= 30;degBlue <= 27;--150
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 50 and rgb2Int.red < 100) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 99;degGreen <= 224;degBlue <= 149;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 99;degGreen <= 224;degBlue <= 148;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 99;degGreen <= 224;degBlue <= 147;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 99;degGreen <= 224;degBlue <= 146;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 99;degGreen <= 224;degBlue <= 145;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 99;degGreen <= 224;degBlue <= 144;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 120;degGreen <= 224;degBlue <= 143;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 130;degGreen <= 191;degBlue <= 97;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 99;degGreen <= 224;degBlue <= 141;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 99;degGreen <= 224;degBlue <= 140;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 99;degGreen <= 224;degBlue <= 200;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 99;degGreen <= 134;degBlue <= 150;--138
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 99;degGreen <= 124;degBlue <= 100;--137
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 99;degGreen <= 120;degBlue <= 50;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 99;degGreen <= 100;degBlue <= 10;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 99;degGreen <= 100;degBlue <= 255;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 99;degGreen <= 100;degBlue <= 150;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 99;degGreen <= 100;degBlue <= 100;--132
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 99;degGreen <= 100;degBlue <= 50;--131
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 99;degGreen <= 100;degBlue <= 10;--130
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 50;degGreen <= 50;degBlue <= 255;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 50;degGreen <= 50;degBlue <= 200;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 50;degGreen <= 50;degBlue <= 150;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 50;degGreen <= 50;degBlue <= 50;--126
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 30;degGreen <= 50;degBlue <= 15;--125
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 0 and rgb2Int.red < 50) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 15;degGreen <= 249;degBlue <= 230;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 123;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 122;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 80;degGreen <= 120;degBlue <= 16;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 120;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 119;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 118;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 117;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 94;degGreen <= 140;degBlue <= 19;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 80;degGreen <= 120;degBlue <= 16;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 114;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 113;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 112;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 103;degGreen <= 125;degBlue <= 52;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 68;degGreen <= 102;degBlue <= 14;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 163;degGreen <= 47;degBlue <= 217;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 108;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 51;degGreen <= 80;degBlue <= 109;--107
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 41;degGreen <= 49;degBlue <= 59;--106
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 65;degGreen <= 97;degBlue <= 13;--105
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 40;degGreen <= 50;degBlue <= 200;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 30;degGreen <= 50;degBlue <= 150;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 35;degGreen <= 50;degBlue <= 75;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 45;degGreen <= 50;degBlue <= 50;--101
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 15;degGreen <= 25;degBlue <= 10;--101
                            end if;
                        end if;
                 end if;
    ------------------------------------------------------------------------------------------
    -- Blue IS MAX
    ------------------------------------------------------------------------------------------
    elsif(rgb2Int.blue = rgbMax) then
                    if (rgb2Int.red >= 200 and rgb2Int.red <= 255) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 211;degGreen <= 247;degBlue <= 255;--223
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 230;degGreen <= 224;degBlue <= 208;--223
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 236;degGreen <= 225;degBlue <= 127;--222
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 213;degGreen <= 199;degBlue <= 102;--221
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 220;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 126;degGreen <= 75;degBlue <= 95;--219
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 239;degGreen <= 186;degBlue <= 170;--218
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 229;degGreen <= 180;degBlue <= 156;--217
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 202;degGreen <= 188;degBlue <= 93;--216
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 215;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                                  if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 214;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 255;degGreen <= 150;degBlue <= 175;--213
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 231;degGreen <= 170;degBlue <= 156;--212
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 232;degGreen <= 99;degBlue <= 89;--211
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 210;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 209;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 208;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 228;degGreen <= 93;degBlue <= 94;--207
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 233;degGreen <= 95;degBlue <= 90;--206
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 205;
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 204;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 203;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 202;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 201;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 200;
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 150 and rgb2Int.red < 200) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 178;degGreen <= 223;degBlue <= 255;--199
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 198;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 197;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 196;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 195;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 161;degGreen <= 205;degBlue <= 230;--194
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 108;degGreen <= 102;degBlue <= 100;--193
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 192;degGreen <= 150;degBlue <= 127;--192
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 69;degGreen <= 56;degBlue <= 30;--191
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 170;degGreen <= 161;degBlue <= 34;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 189;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 145;degGreen <= 121;degBlue <= 117;--188
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 181;degGreen <= 145;degBlue <= 127;--187
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 159;degGreen <= 116;degBlue <= 99;--186
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 185;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 184;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 183;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 109;degGreen <= 113;degBlue <= 140;--182
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 182;degGreen <= 69;degBlue <= 62;--181
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 58;degGreen <= 13;degBlue <= 9;--180
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 179;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 178;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 177;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 176;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 66;degGreen <= 23;degBlue <= 21;--175
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 100 and rgb2Int.red < 150) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 147;degGreen <= 201;degBlue <= 251;--174
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 173;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 172;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 171;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 170;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 136;degGreen <= 184;degBlue <= 224;--169
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 132;degGreen <= 167;degBlue <= 197;--168
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 167;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 166;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 165;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 149;degGreen <= 200;degBlue <= 245;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 106;degGreen <= 140;degBlue <= 165;--190
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 149;degGreen <= 147;degBlue <= 146;--162
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 161;degGreen <= 113;degBlue <= 92;--161
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 212;degGreen <= 198;degBlue <= 95;--160
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 103;degGreen <= 96;degBlue <= 247;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 150;degGreen <= 100;degBlue <= 150;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 149;degGreen <= 100;degBlue <= 150;--157
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 155;degGreen <= 109;degBlue <= 89;--156
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 103;degGreen <= 56;degBlue <= 43;--155
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 154;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 153;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 152;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 202;degGreen <= 84;degBlue <= 87;--151
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 86;degGreen <= 30;degBlue <= 27;--150
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 50 and rgb2Int.red < 100) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 143;degGreen <= 193;degBlue <= 235;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 120;degGreen <= 130;degBlue <= 148;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 100;degGreen <= 120;degBlue <= 147;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 50;degGreen <= 60;degBlue <= 100;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 30;degGreen <= 50;degBlue <= 75;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 141;degGreen <= 191;degBlue <= 232;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 132;degGreen <= 160;degBlue <= 200;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 100;degGreen <= 118;degBlue <= 142;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 50;degGreen <= 80;degBlue <= 100;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 20;degGreen <= 30;degBlue <= 50;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 144;degGreen <= 194;degBlue <= 237;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 93;degGreen <= 134;degBlue <= 170;--138
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 103;degGreen <= 124;degBlue <= 141;--137
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 136;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 135;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 100;degGreen <= 95;degBlue <= 244;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 83;degGreen <= 79;degBlue <= 204;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 84;degGreen <= 99;degBlue <= 106;--132
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 57;degGreen <= 70;degBlue <= 58;--131
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 93;degGreen <= 59;degBlue <= 49;--130
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 150;degGreen <= 120;degBlue <= 230;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 102;degGreen <= 97;degBlue <= 250;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 80;degGreen <= 70;degBlue <= 127;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 75;degGreen <= 50;degBlue <= 100;--126
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 64;degGreen <= 37;degBlue <= 30;--125
                            end if;
                        end if;
                    elsif(rgb2Int.red >= 0 and rgb2Int.red < 50) then
                        if (rgb2Int.green >= 200 and rgb2Int.green <= 255) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 0;degGreen <= 221;degBlue <= 253;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 123;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 122;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 121;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 120;
                            end if;
                        elsif(rgb2Int.green >= 150 and rgb2Int.green <= 200) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 141;degGreen <= 191;degBlue <= 232;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 224;degGreen <= 224;degBlue <= 118;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 117;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 10;degGreen <= 190;degBlue <= 192;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 10;degGreen <= 120;degBlue <= 25;
                            end if;
                        elsif(rgb2Int.green >= 100 and rgb2Int.green <= 150) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 147;degGreen <= 199;degBlue <= 242;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 152;degGreen <= 205;degBlue <= 250;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 224;degGreen <= 224;degBlue <= 112;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 224;degGreen <= 224;degBlue <= 111;
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 224;degGreen <= 224;degBlue <= 110;
                            end if;
                        elsif(rgb2Int.green >= 50 and rgb2Int.green <= 100) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 224;degGreen <= 224;degBlue <= 109;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 51;degGreen <= 80;degBlue <= 150;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 51;degGreen <= 80;degBlue <= 109;--107
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 41;degGreen <= 49;degBlue <= 59;--106
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 63;degGreen <= 64;degBlue <= 59;--105
                            end if;
                        elsif(rgb2Int.green >= 0 and rgb2Int.green <= 50) then
                            if (rgb2Int.blue >= 200 and rgb2Int.blue <= 255) then
                                degRed <= 40;degGreen <= 40;degBlue <= 255;
                            elsif(rgb2Int.blue >= 150 and rgb2Int.blue <= 200) then
                                degRed <= 40;degGreen <= 40;degBlue <= 200;
                            elsif(rgb2Int.blue >= 100 and rgb2Int.blue <= 150) then
                                degRed <= 40;degGreen <= 40;degBlue <= 150;
                            elsif(rgb2Int.blue >= 50 and rgb2Int.blue <= 100) then
                                degRed <= 40;degGreen <= 40;degBlue <= 100;--101
                            elsif(rgb2Int.blue >= 0 and rgb2Int.blue <= 50) then
                                degRed <= 40;degGreen <= 40;degBlue <= 50;--101
                            else
                                degGreen <= 255; degRed <= 255;degBlue <= 255;
                            end if;
                        end if;
                    else
                        degGreen <= 255; degRed <= 255;degBlue <= 255;
                  end if;
    else
        degGreen <= 255; degRed <= 255;degBlue <= 255;
    end if;
    end if;
end process rgbMaxP;




rgbP: process (clk) begin
  if rising_edge(clk) then
    oRgbRemix.red   <= std_logic_vector(to_unsigned(degRed,8)) & "00";
    oRgbRemix.green <= std_logic_vector(to_unsigned(degGreen,8)) & "00";
    oRgbRemix.blue  <= std_logic_vector(to_unsigned(degBlue,8)) & "00";
    oRgbRemix.eol   <= rgbSyncEol(1);
    oRgbRemix.sof   <= rgbSyncSof(1);
    oRgbRemix.eof   <= rgbSyncEof(1);
    oRgbRemix.valid <= rgbSyncValid(1);
  end if;
end process rgbP;




end architecture;