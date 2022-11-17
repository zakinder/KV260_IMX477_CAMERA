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
entity edge_3objects is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    oRgbRemix      : out channel);
end entity;
architecture arch of edge_3objects is
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
rgbMinP: process (clk) begin
    if rising_edge(clk) then
        if ((rgb1Int.red <= rgb1Int.green) and (rgb1Int.red <= rgb1Int.blue)) then
            rgbMin <= rgb1Int.red;
        elsif((rgb1Int.green <= rgb1Int.red) and (rgb1Int.green <= rgb1Int.blue)) then
            rgbMin <= rgb1Int.green;
        else
            rgbMin <= rgb1Int.blue;
        end if;
    end if;
end process rgbMinP;
rgbMaxP: process (clk) begin
    if rising_edge(clk) then
    
    
    ------------------------------------------------------------------------------------------
    -- GRAY
    ------------------------------------------------------------------------------------------
    
    
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
    -- if ((abs(rgb2Int.red - rgb2Int.green) <= 11) and (abs(rgb2Int.red - rgb2Int.blue) <= 11)) then
        -- if (rgb2Int.blue >= 250 and rgb2Int.blue <= 255) then
            -- degRed <= 255;degGreen <= 255;degBlue <= 255;
        -- elsif(rgb2Int.blue >= 240 and rgb2Int.blue < 250)  then
            -- degRed <= 240;degGreen <= 240;degBlue <= 240;
        -- elsif(rgb2Int.blue >= 200 and rgb2Int.blue < 225)  then
            -- degRed <= 200;degGreen <= 200;degBlue <= 200;
        -- elsif(rgb2Int.blue >= 175 and rgb2Int.blue < 200)  then
            -- degRed <= 175;degGreen <= 175;degBlue <= 175;
        -- elsif(rgb2Int.blue >= 150 and rgb2Int.blue < 175)  then
            -- degRed <= 150;degGreen <= 150;degBlue <= 150;
        -- elsif(rgb2Int.blue >= 125 and rgb2Int.blue < 150)  then
            -- degRed <= 125;degGreen <= 125;degBlue <= 125;
        -- elsif(rgb2Int.blue >= 100 and rgb2Int.blue < 125)  then
            -- degRed <= 100;degGreen <= 100;degBlue <= 100;
        -- elsif(rgb2Int.blue >= 75 and rgb2Int.blue < 100)  then
            -- degRed <= 75;degGreen <= 75;degBlue <= 75;
        -- elsif(rgb2Int.blue >= 50 and rgb2Int.blue < 75)  then
            -- degRed <= 50;degGreen <= 50;degBlue <= 50;
        -- elsif(rgb2Int.blue >= 25 and rgb2Int.blue < 50)  then
            -- degRed <= 25;degGreen <= 25;degBlue <= 25;
        -- elsif(rgb2Int.blue >= 10 and rgb2Int.blue < 25)  then
            -- degRed <= 10;degGreen <= 10;degBlue <= 10;
        -- elsif(rgb2Int.blue >= 0 and rgb2Int.blue < 10)  then
            -- degRed <= 0;degGreen <= 0;degBlue <= 50;
        -- else
            -- degRed <= 255;degGreen <= 255;degBlue <= 255;
        -- end if;
    ------------------------------------------------------------
    -- [0:63]
    ------------------------------------------------------------
    ------------------------------------------------------------
    -- [0:32]
    ------------------------------------------------------------
    elsif (rgb2Int.red <= 32) and (rgb2Int.green <= 32)  and (rgb2Int.blue <= 32) then
        if(rgb2Int.red = rgbMax)  then
            degRed <= 32;degGreen <= 16;degBlue <= 16;
        elsif(rgb2Int.green = rgbMax)  then
            degRed <= 16;degGreen <= 32;degBlue <= 16;
        else
            degRed <= 16;degGreen <= 16;degBlue <= 32;
        end if;
    ------------------------------------------------------------
    -- [32:63]
    ------------------------------------------------------------
    elsif(rgb2Int.red > 32 and rgb2Int.red < 64) and (rgb2Int.green > 32 and rgb2Int.green < 64)  and (rgb2Int.blue > 32 and rgb2Int.blue < 64) then
        if(rgb2Int.red = rgbMax)  then
            degRed <= 64;degGreen <= 48;degBlue <= 48;
        elsif(rgb2Int.green = rgbMax)  then
            degRed <= 48;degGreen <= 64;degBlue <= 48;
        else
            degRed <= 48;degGreen <= 16;degBlue <= 64;
        end if;
    elsif(rgb2Int.red > 32 and rgb2Int.red < 64) and (rgb2Int.green > 32 and rgb2Int.green < 64)  and (rgb2Int.blue < 32) then
        if(rgb2Int.red = rgbMax)  then
            degRed <= 64;degGreen <= 48;degBlue <= 16;
        elsif(rgb2Int.green = rgbMax)  then
            degRed <= 48;degGreen <= 64;degBlue <= 16;
        else
            degRed <= 48;degGreen <= 64;degBlue <= 16;
        end if;
    elsif(rgb2Int.red > 32 and rgb2Int.red < 64) and (rgb2Int.green < 32)  and (rgb2Int.blue > 32 and rgb2Int.blue < 64) then
        if(rgb2Int.red = rgbMax)  then
            degRed <= 64;degGreen <= 16;degBlue <= 48;
        elsif(rgb2Int.green = rgbMax)  then
            degRed <= 48;degGreen <= 16;degBlue <= 48;
        else
            degRed <= 48;degGreen <= 16;degBlue <= 64;
        end if;
    elsif(rgb2Int.red < 32) and (rgb2Int.green > 32 and rgb2Int.green < 64)  and (rgb2Int.blue > 32 and rgb2Int.blue < 64) then
        if(rgb2Int.red = rgbMax)  then
            degRed <= 16;degGreen <= 48;degBlue <= 48;
        elsif(rgb2Int.green = rgbMax)  then
            degRed <= 16;degGreen <= 64;degBlue <= 48;
        else
            degRed <= 16;degGreen <= 16;degBlue <= 64;
        end if;
    elsif(rgb2Int.red > 32 and rgb2Int.red < 64) and (rgb2Int.green < 32)  and (rgb2Int.blue < 32) then
        if(rgb2Int.green = rgbMin)  then
            degRed <= 64;degGreen <= 16;degBlue <= 32;
        else
            degRed <= 64;degGreen <= 32;degBlue <= 16;
        end if;
    elsif(rgb2Int.red < 32) and (rgb2Int.green < 32)  and (rgb2Int.blue > 32 and rgb2Int.blue < 64) then
        if(rgb2Int.red = rgbMax)  then
            degRed <= 20;degGreen <= 16;degBlue <= 48;
        elsif(rgb2Int.green = rgbMax)  then
            degRed <= 16;degGreen <= 20;degBlue <= 48;
        else
            degRed <= 16;degGreen <= 16;degBlue <= 64;
        end if;
    elsif(rgb2Int.red < 32) and (rgb2Int.green > 32 and rgb2Int.green < 64)  and (rgb2Int.blue < 32) then
        if(rgb2Int.red = rgbMax)  then
            degRed <= 20;degGreen <= 48;degBlue <= 16;
        elsif(rgb2Int.green = rgbMax)  then
            degRed <= 16;degGreen <= 64;degBlue <= 16;
        else
            degRed <= 16;degGreen <= 16;degBlue <= 20;
        end if;
    ------------------------------------------------------------
    -- [240:256]
    ------------------------------------------------------------
    elsif (rgb2Int.red > 240) and (rgb2Int.green > 240)  and (rgb2Int.blue > 240) then
        if(rgb2Int.red = rgbMax)  then
            degRed <= 255;degGreen <= 240;degBlue <= 240;
        elsif(rgb2Int.green = rgbMax)  then
            degRed <= 240;degGreen <= 255;degBlue <= 240;
        else
            degRed <= 240;degGreen <= 240;degBlue <= 255;
        end if;
    ------------------------------------------------------------
    -- [224:240]and[240:256]
    ------------------------------------------------------------
    elsif(rgb2Int.red > 240) and (rgb2Int.green > 224 and rgb2Int.green <= 240)  and (rgb2Int.blue > 224 and rgb2Int.blue <= 240) then
        if(rgb2Int.green = rgbMin)  then
            degRed <= 255;degGreen <= 224;degBlue <= 240;
        else
            degRed <= 255;degGreen <= 240;degBlue <= 224;
        end if;
    elsif(rgb2Int.red > 224 and rgb2Int.red <= 240) and (rgb2Int.green > 240)  and (rgb2Int.blue > 224 and rgb2Int.blue <= 240) then
        if(rgb2Int.red = rgbMin)  then
            degRed <= 224;degGreen <= 255;degBlue <= 240;
        else
            degRed <= 240;degGreen <= 255;degBlue <= 224;
        end if;
    elsif(rgb2Int.red > 224 and rgb2Int.red <= 240) and (rgb2Int.green > 224 and rgb2Int.green <= 240)  and (rgb2Int.blue > 240) then
        if(rgb2Int.red = rgbMin)  then
            degRed <= 224;degGreen <= 240;degBlue <= 255;
        else
            degRed <= 240;degGreen <= 224;degBlue <= 255;
        end if;
    elsif(rgb2Int.red > 240) and (rgb2Int.green > 240)  and (rgb2Int.blue > 224 and rgb2Int.blue <= 240) then
        if(rgb2Int.red = rgbMax)  then
            degRed <= 255;degGreen <= 240;degBlue <= 224;
        else
            degRed <= 240;degGreen <= 255;degBlue <= 224;
        end if;
    elsif(rgb2Int.red > 224 and rgb2Int.red <= 240) and (rgb2Int.green > 240)  and (rgb2Int.blue > 240) then
        if(rgb2Int.green = rgbMax)  then
            degRed <= 224;degGreen <= 255;degBlue <= 240;
        else
            degRed <= 224;degGreen <= 240;degBlue <= 255;
        end if;
    elsif(rgb2Int.red > 240) and (rgb2Int.green > 224 and rgb2Int.green <= 240)  and (rgb2Int.blue > 240) then
        if(rgb2Int.red = rgbMax)  then
            degRed <= 255;degGreen <= 224;degBlue <= 240;
        else
            degRed <= 240;degGreen <= 224;degBlue <= 255;
        end if;
    -------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------
    elsif(rgb2Int.red = rgbMax)  then
        ------------------------------------------------------------
        -- [0:63]
        ------------------------------------------------------------
        if (rgb2Int.red >= 0 and rgb2Int.red < 64)  then
            degRed <= 64;degGreen <= 32;degBlue <= 32;
        ------------------------------------------------------------
        -- [64:127]
        ------------------------------------------------------------
        elsif(rgb2Int.red >= 64 and rgb2Int.red < 128)  then
            if (rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64) then
                if(rgb2Int.green = rgbMin)  then
                    degRed <= 128;degGreen <= 64;degBlue <= 64;
                else
                    degRed <= 100;degGreen <= 64;degBlue <= 32;
                end if;
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
                if(rgb2Int.red = rgbMax)  then
                    degRed <= 128;degGreen <= 64;degBlue <= 32;
                else
                    degRed <= 64;degGreen <= 128;degBlue <= 32;
                end if;
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 128;degGreen <= 32;degBlue <= 128;
                if(rgb2Int.green = rgbMin)  then
                    degRed <= 128;degGreen <= 90;degBlue <= 100;
                else
                    degRed <= 128;degGreen <= 100;degBlue <= 90;
                end if;
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
              degRed <= 128;degGreen <= 100;degBlue <= 100;
            else
              degRed <= 255;degGreen <= 255;degBlue <= 255;
            end if;
        ------------------------------------------------------------
        -- [128:191]
        ------------------------------------------------------------
        elsif(rgb2Int.red >= 128 and rgb2Int.red < 192)  then
            if (rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64) then
                degRed <= 192;degGreen <= 32;degBlue <= 32;
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
                degRed <= 192;degGreen <= 128;degBlue <= 32;
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 192;degGreen <= 32;degBlue <= 128;
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 192;degGreen <= 100;degBlue <= 100;
                if(rgb2Int.green = rgbMin)  then
                    degRed <= 192;degGreen <= 64;degBlue <= 128;
                else
                    degRed <= 192;degGreen <= 128;degBlue <= 64;
                end if;
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
                degRed <= 192;degGreen <= 192;degBlue <= 32;
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.blue >= 128 and rgb2Int.blue < 192)then
               degRed <= 192;degGreen <= 32;degBlue <= 192;
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.blue >= 128 and rgb2Int.blue < 192)then
                if(rgb2Int.red = rgbMax)  then
                    if(rgb2Int.green = rgbMin)  then
                        degRed <= 192;degGreen <= 129;degBlue <= 150;
                    else
                        degRed <= 192;degGreen <= 150;degBlue <= 129;
                    end if;
                elsif(rgb2Int.green = rgbMax)  then
                    if(rgb2Int.red = rgbMin)  then
                        degRed <= 129;degGreen <= 192;degBlue <= 150;
                    else
                        degRed <= 150;degGreen <= 192;degBlue <= 129;
                    end if;
                else
                    if(rgb2Int.red = rgbMin)  then
                        degRed <= 129;degGreen <= 150;degBlue <= 192;
                    else
                        degRed <= 150;degGreen <= 129;degBlue <= 192;
                    end if;
                end if;
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                if(rgb2Int.green = rgbMin)  then
                    degRed <= 192;degGreen <= 128;degBlue <= 128;
                else
                    degRed <= 192;degGreen <= 128;degBlue <= 64;
                end if;
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.blue >= 128 and rgb2Int.green < 192)then
              degRed <= 192;degGreen <= 128;degBlue <= 192;
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
              degRed <= 192;degGreen <= 128;degBlue <= 128;
            else
              degRed <= 192;degGreen <= 255;degBlue <= 255;
            end if;
        else
        ------------------------------------------------------------
        -- [192:256] <--- Max Red
        ------------------------------------------------------------
            if (rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64) then
                degRed <= 255;degGreen <= 32;degBlue <= 32;
           -- SET1:SET1
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
                degRed <= 255;degGreen <= 128;degBlue <= 32;
           -- SET2:SET1
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 255;degGreen <= 32;degBlue <= 128;
           -- SET2:SET2
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 255;degGreen <= 128;degBlue <= 128;
           -- SET2:SET1
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
                degRed <= 255;degGreen <= 192;degBlue <= 32;
           -- SET1:SET2
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.blue >= 128 and rgb2Int.blue < 192)then
               degRed <= 255;degGreen <= 32;degBlue <= 192;
           -- SET3:SET3
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.blue >= 128 and rgb2Int.blue < 192)then
                if(rgb2Int.green = rgbMin)  then
                    degRed <= 255;degGreen <= 128;degBlue <= 192;
                else
                    degRed <= 255;degGreen <= 192;degBlue <= 128;
                end if;
           -- SET3:SET2
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
              degRed <= 255;degGreen <= 160;degBlue <= 64;
           -- SET2:SET3
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.blue >= 128 and rgb2Int.green < 192)then
              degRed <= 255;degGreen <= 128;degBlue <= 160;
           -- SET1:SET3
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.blue >= 128 and rgb2Int.green < 192)then
              degRed <= 255;degGreen <= 32;degBlue <= 160;
           -- SET3:SET1
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.blue >= 0 and rgb2Int.green < 64)then
              degRed <= 255;degGreen <= 160;degBlue <= 32;
            --------------------
            -- SET4:SET4
            elsif(rgb2Int.green >= 192 and rgb2Int.green < 256) and (rgb2Int.blue >= 192 and rgb2Int.blue < 256) then
                if(rgb2Int.green = rgbMax)  then
                    degRed <= 255;degGreen <= 230;degBlue <= 210;
                else
                    degRed <= 255;degGreen <= 210;degBlue <= 230;
                end if;
            -- SET2:SET4
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.blue >= 192 and rgb2Int.blue < 256)then
                degRed <= 255;degGreen <= 128;degBlue <= 192;
            -- SET4:SET2
            elsif(rgb2Int.green >= 192 and rgb2Int.green < 256) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 255;degGreen <= 192;degBlue <= 128;
            -- SET3:SET4
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.blue >= 192 and rgb2Int.blue < 256)then
                degRed <= 255;degGreen <= 160;degBlue <= 192;
                if(rgb2Int.green = rgbMin)  then
                    degRed <= 255;degGreen <= 128;degBlue <= 192;
                else
                    degRed <= 255;degGreen <= 192;degBlue <= 128;
                end if;
            -- SET4:SET3
            elsif(rgb2Int.green >= 192 and rgb2Int.green < 256) and (rgb2Int.blue >= 128 and rgb2Int.blue < 192)then
               degRed <= 255;degGreen <= 192;degBlue <= 160;
            -- SET1:SET4
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.blue >= 192 and rgb2Int.blue < 256)then
              degRed <= 255;degGreen <= 32;degBlue <= 192;
            -- SET4:SET1
            elsif(rgb2Int.green >= 192 and rgb2Int.green < 256) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
              degRed <= 255;degGreen <= 220;degBlue <= 32;
            --------------------
            else
              degRed <= 255;degGreen <= 255;degBlue <= 255;
            end if;
        end if;
    elsif(rgb2Int.green = rgbMax)  then
        ------------------------------------------------------------
        -- [0:63]
        ------------------------------------------------------------
        if (rgb2Int.green >= 0 and rgb2Int.green < 64)  then
            degRed <= 32;degGreen <= 32;degBlue <= 32;
        ------------------------------------------------------------
        -- [64:127]
        ------------------------------------------------------------
        elsif(rgb2Int.green >= 64 and rgb2Int.green < 128)  then
            if (rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64) then
                degRed <= 32;degGreen <= 128;degBlue <= 32;
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
                if(rgb2Int.red = rgbMin)  then
                    degRed <= 80;degGreen <= 127;degBlue <= 64;
                else
                    degRed <= 80;degGreen <= 64;degBlue <= 50;
                end if;
            elsif(rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 32;degGreen <= 128;degBlue <= 128;
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
              degRed <= 100;degGreen <= 128;degBlue <= 100;
            else
              degRed <= 255;degGreen <= 255;degBlue <= 255;
            end if;
        ------------------------------------------------------------
        -- [128:191]
        ------------------------------------------------------------
        elsif(rgb2Int.green >= 128 and rgb2Int.green < 192)  then
            if (rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64) then
                degRed <= 32;degGreen <= 192;degBlue <= 32;
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
                degRed <= 128;degGreen <= 192;degBlue <= 32;
            elsif(rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 32;degGreen <= 192;degBlue <= 128;
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 100;degGreen <= 192;degBlue <= 100;
            elsif(rgb2Int.red >= 128 and rgb2Int.red < 192) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
                degRed <= 192;degGreen <= 192;degBlue <= 32;
            elsif(rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.blue >= 128 and rgb2Int.blue < 192)then
               degRed <= 32;degGreen <= 192;degBlue <= 192;
            elsif(rgb2Int.red >= 128 and rgb2Int.red < 192) and (rgb2Int.blue >= 128 and rgb2Int.blue < 192)then
              degRed <= 192;degGreen <= 192;degBlue <= 192;
            elsif(rgb2Int.red >= 128 and rgb2Int.red < 192) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
              degRed <= 192;degGreen <= 192;degBlue <= 64;
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.blue >= 128 and rgb2Int.red < 192)then
              degRed <= 128;degGreen <= 192;degBlue <= 192;
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
              degRed <= 128;degGreen <= 192;degBlue <= 128;
            else
              degRed <= 192;degGreen <= 255;degBlue <= 255;
            end if;
        else
        ------------------------------------------------------------
        -- [192:255] <-- Max Green
        ------------------------------------------------------------
            if (rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64) then
                degRed <= 32;degGreen <= 255;degBlue <= 32;
           -- SET1:SET1
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
                degRed <= 128;degGreen <= 255;degBlue <= 32;
           -- SET2:SET1
            elsif(rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 32;degGreen <= 255;degBlue <= 128;
           -- SET2:SET2
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 128;degGreen <= 255;degBlue <= 128;
           -- SET2:SET1
            elsif(rgb2Int.red >= 128 and rgb2Int.red < 192) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
                degRed <= 192;degGreen <= 255;degBlue <= 32;
           -- SET1:SET2
            elsif(rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.blue >= 128 and rgb2Int.blue < 192)then
               degRed <= 32;degGreen <= 255;degBlue <= 192;
           -- SET3:SET3
            elsif(rgb2Int.red >= 128 and rgb2Int.red < 192) and (rgb2Int.blue >= 128 and rgb2Int.blue < 192)then
              degRed <= 160;degGreen <= 255;degBlue <= 192;
           -- SET3:SET2
            elsif(rgb2Int.red >= 128 and rgb2Int.red < 192) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
              degRed <= 160;degGreen <= 255;degBlue <= 64;
           -- SET2:SET3
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.blue >= 128 and rgb2Int.red < 192)then
              degRed <= 128;degGreen <= 255;degBlue <= 160;
           -- SET1:SET3
            elsif(rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.blue >= 128 and rgb2Int.red < 192)then
              degRed <= 32;degGreen <= 255;degBlue <= 160;
           -- SET3:SET1
            elsif(rgb2Int.red >= 128 and rgb2Int.red < 192) and (rgb2Int.blue >= 0 and rgb2Int.red < 64)then
              degRed <= 160;degGreen <= 255;degBlue <= 32;
            --------------------
            -- SET4:SET4
            elsif(rgb2Int.red >= 192 and rgb2Int.red < 256) and (rgb2Int.blue >= 192 and rgb2Int.blue < 256) then
                degRed <= 192;degGreen <= 255;degBlue <= 192;
            -- SET2:SET4
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.blue >= 192 and rgb2Int.blue < 256)then
                degRed <= 128;degGreen <= 255;degBlue <= 192;
            -- SET4:SET2
            elsif(rgb2Int.red >= 192 and rgb2Int.red < 256) and (rgb2Int.blue >= 64 and rgb2Int.blue < 128)then
                degRed <= 192;degGreen <= 255;degBlue <= 128;
            -- SET3:SET4
            elsif(rgb2Int.red >= 128 and rgb2Int.red < 192) and (rgb2Int.blue >= 192 and rgb2Int.blue < 256)then
                degRed <= 160;degGreen <= 255;degBlue <= 192;
            -- SET4:SET3
            elsif(rgb2Int.red >= 192 and rgb2Int.red < 256) and (rgb2Int.blue >= 128 and rgb2Int.blue < 192)then
               degRed <= 192;degGreen <= 255;degBlue <= 160;
            -- SET1:SET4
            elsif(rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.blue >= 192 and rgb2Int.blue < 256)then
              degRed <= 32;degGreen <= 255;degBlue <= 192;
            -- SET4:SET1
            elsif(rgb2Int.red >= 192 and rgb2Int.red < 256) and (rgb2Int.blue >= 0 and rgb2Int.blue < 64)then
              degRed <= 220;degGreen <= 255;degBlue <= 32;
            --------------------
            else
                if(rgb2Int.red = rgbMin)  then
                    degRed <= 224;degGreen <= 255;degBlue <= 240;
                else
                    degRed <= 240;degGreen <= 255;degBlue <= 224;
                end if;
            end if;
        end if;
    else
        ------------------------------------------------------------
        --  Max Blue
        ------------------------------------------------------------
        if (rgb2Int.blue >= 0 and rgb2Int.blue < 64)  then
            degRed <= 32;degGreen <= 32;degBlue <= 64;
        elsif(rgb2Int.blue >= 64 and rgb2Int.blue < 128)  then
            if (rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.green >= 0 and rgb2Int.green < 64) then
                degRed <= 32;degGreen <= 32;degBlue <= 128;
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.green >= 0 and rgb2Int.green < 64)then
                degRed <= 128;degGreen <= 32;degBlue <= 128;
            elsif(rgb2Int.red >= 0 and rgb2Int.red < 64) and (rgb2Int.green >= 64 and rgb2Int.green < 128)then
                degRed <= 32;degGreen <= 128;degBlue <= 128;
            elsif(rgb2Int.red >= 64 and rgb2Int.red < 128) and (rgb2Int.green >= 64 and rgb2Int.green < 128)then
              degRed <= 100;degGreen <= 100;degBlue <= 128;
            else
              degRed <= 255;degGreen <= 255;degBlue <= 255;
            end if;
        ------------------------------------------------------------
        -- [128:191]
        ------------------------------------------------------------
        elsif(rgb2Int.blue >= 128 and rgb2Int.blue < 192)  then
            if (rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.red >= 0 and rgb2Int.red < 64) then
                degBlue <= 192;degGreen <= 32;degRed <= 32;
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.red >= 0 and rgb2Int.red < 64)then
                degBlue <= 192;degGreen <= 128;degRed <= 32;
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.red >= 64 and rgb2Int.red < 128)then
                degBlue <= 192;degGreen <= 32;degRed <= 128;
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.red >= 64 and rgb2Int.red < 128)then
                degBlue <= 192;degGreen <= 100;degRed <= 100;
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.red >= 0 and rgb2Int.red < 64)then
                degBlue <= 192;degGreen <= 192;degRed <= 32;
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.red >= 128 and rgb2Int.red < 192)then
               degBlue <= 192;degGreen <= 32;degRed <= 192;
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.red >= 128 and rgb2Int.red < 192)then
              degBlue <= 192;degGreen <= 192;degRed <= 192;
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.red >= 64 and rgb2Int.red < 128)then
                if(rgb2Int.red = rgbMin)  then
                    degRed <= 64;degGreen <= 150;degBlue <= 192;
                else
                    degRed <= 100;degGreen <= 128;degBlue <= 192;
                end if;
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.red >= 128 and rgb2Int.green < 192)then
              degBlue <= 192;degGreen <= 128;degRed <= 192;
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.red >= 64 and rgb2Int.red < 128)then
              degBlue <= 192;degGreen <= 128;degRed <= 128;
            else
              degBlue <= 192;degGreen <= 255;degRed <= 255;
            end if;
        else
        ------------------------------------------------------------
        -- [192:256] <-- Max Blue
        ------------------------------------------------------------
            if (rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.red >= 0 and rgb2Int.red < 64) then
                degBlue <= 255;degGreen <= 32;degRed <= 32;
           -- SET1:SET1
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.red >= 0 and rgb2Int.red < 64)then
                degBlue <= 255;degGreen <= 128;degRed <= 32;
           -- SET2:SET1
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.red >= 64 and rgb2Int.red < 128)then
                degBlue <= 255;degGreen <= 32;degRed <= 128;
           -- SET2:SET2
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.red >= 64 and rgb2Int.red < 128)then
                degBlue <= 255;degGreen <= 128;degRed <= 128;
           -- SET2:SET1
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.red >= 0 and rgb2Int.red < 64)then
                degBlue <= 255;degGreen <= 192;degRed <= 32;
           -- SET1:SET2
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.red >= 128 and rgb2Int.red < 192)then
               degBlue <= 255;degGreen <= 32;degRed <= 192;
           -- SET3:SET3
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.red >= 128 and rgb2Int.red < 192)then
                if(rgb2Int.red = rgbMin)  then
                    degRed <= 128;degGreen <= 192;degBlue <= 255;
                else
                    degRed <= 192;degGreen <= 128;degBlue <= 255;
                end if;
           -- SET3:SET2
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.red >= 64 and rgb2Int.red < 128)then
              degBlue <= 255;degGreen <= 160;degRed <= 64;
           -- SET2:SET3
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.red >= 128 and rgb2Int.green < 192)then
              degBlue <= 255;degGreen <= 128;degRed <= 160;
           -- SET1:SET3
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.red >= 128 and rgb2Int.green < 192)then
              degBlue <= 255;degGreen <= 32;degRed <= 160;
           -- SET3:SET1
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.red >= 0 and rgb2Int.green < 64)then
              degBlue <= 255;degGreen <= 160;degRed <= 32;
            --------------------
            -- SET4:SET4
            elsif(rgb2Int.green >= 192 and rgb2Int.green < 256) and (rgb2Int.red >= 192 and rgb2Int.red < 256) then
                degBlue <= 255;degGreen <= 192;degRed <= 192;
            -- SET2:SET4
            elsif(rgb2Int.green >= 64 and rgb2Int.green < 128) and (rgb2Int.red >= 192 and rgb2Int.red < 256)then
                degBlue <= 255;degGreen <= 128;degRed <= 192;
            -- SET4:SET2
            elsif(rgb2Int.green >= 192 and rgb2Int.green < 256) and (rgb2Int.red >= 64 and rgb2Int.red < 128)then
                degBlue <= 255;degGreen <= 192;degRed <= 128;
            -- SET3:SET4
            elsif(rgb2Int.green >= 128 and rgb2Int.green < 192) and (rgb2Int.red >= 192 and rgb2Int.red < 256)then
                degBlue <= 255;degGreen <= 160;degRed <= 192;
            -- SET4:SET3
            elsif(rgb2Int.green >= 192 and rgb2Int.green < 256) and (rgb2Int.red >= 128 and rgb2Int.red < 192)then
                if(rgb2Int.red = rgbMin)  then
                    degRed <= 160;degGreen <= 210;degBlue <= 255;
                else
                    degRed <= 210;degGreen <= 160;degBlue <= 255;
                end if;
            -- SET1:SET4
            elsif(rgb2Int.green >= 0 and rgb2Int.green < 64) and (rgb2Int.red >= 192 and rgb2Int.red < 256)then
              degBlue <= 255;degGreen <= 32;degRed <= 192;
            -- SET4:SET1
            elsif(rgb2Int.green >= 192 and rgb2Int.green < 256) and (rgb2Int.red >= 0 and rgb2Int.red < 64)then
              degBlue <= 255;degGreen <= 220;degRed <= 32;
            --------------------
            else
              degBlue <= 255;degGreen <= 255;degRed <= 255;
            end if;
        end if;
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