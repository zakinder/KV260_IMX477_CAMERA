-------------------------------------------------------------------------------
--
-- Filename    : color_space_limits.vhd
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

entity color_space_limits is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    rgbColors      : out type_RgbArray(0 to i_data_width-1));
end color_space_limits;

architecture behavioral of color_space_limits is

    signal Rgb1              : channel;
    signal Rgb2              : channel;
    signal int1Rgb           : intChannel;
    signal int2Rgb           : intChannel;
    signal ilm               : rgbConstraint;
    signal rgbMax            : integer;
    signal rgbMin            : integer;
    signal rgbDelta          : integer;
    signal maxMinSum         : integer;
    signal bMin,gMin,rMin    : std_logic;
    signal bMax,gMax,rMax    : std_logic;
    signal R_MinValue        : natural := 255;
    signal G_MinValue        : natural := 255;
    signal B_MinValue        : natural := 255;
    signal R_MinValueRow     : natural := 255;
    signal rMr               : natural := 255;
    signal rMrm              : natural := 255;
    signal G_MinValueRow     : natural := 255;
    signal B_MinValueRow     : natural := 255;
    signal R_MinFValue       : natural := 255;
    signal R_MinMFValue      : natural;
    signal G_MinFValue       : natural := 255;
    signal B_MinFValue       : natural := 255;
    signal rgbFedge          : std_logic :=lo;
    signal rgbFedgeSync      : std_logic :=lo;

begin

rgbFedge <= hi when (int1Rgb.valid = hi and iRgb.valid = lo) else lo;

process (clk) begin
    if rising_edge(clk) then
        rgbFedgeSync <= rgbFedge;
    end if;
end process;

process (clk)
variable MaxRGB : integer;
begin
    if rising_edge(clk) then
        if ((iRgb.red >= iRgb.green) and (iRgb.red >= iRgb.blue)) then
            MaxRGB := to_integer(unsigned(iRgb.red));
        elsif((iRgb.green >= iRgb.red) and (iRgb.green >= iRgb.blue))then
            MaxRGB := to_integer(unsigned(iRgb.green));
        else
            MaxRGB := to_integer(unsigned(iRgb.blue));
        end if;
            rgbMax <= MaxRGB;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        int2Rgb <= int1Rgb;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
            Rgb1          <= iRgb;
            Rgb2.valid    <= Rgb1.valid;
            Rgb2.red      <= Rgb1.red;
            Rgb2.green    <= Rgb1.green;
            Rgb2.blue     <= Rgb1.blue;
        -- if (int1Rgb.red = rgbMax) then
        -- else
            -- Rgb2.red      <=  black;
            -- Rgb2.green    <=  black;
            -- Rgb2.blue     <=  black;
        -- end if;
  end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        rMr  <= R_MinFValue;
        rMrm <= R_MinMFValue;
        if (int1Rgb.red < R_MinValue) and (int1Rgb.red > 60) then
                R_MinValue <= int1Rgb.red;
        end if;
        if (rgbFedge = hi) then
            if (R_MinValue < 255) then
                R_MinValueRow <= R_MinValue;
                R_MinValue <= 300;
            end if;
        end if;
    end if;
end process;

R_MinMFValue <= max_select(R_MinValueRow,rMrm) when rgbFedgeSync = hi;
R_MinFValue  <= min_select(R_MinValueRow,rMr) when rgbFedgeSync = hi;

process (clk) begin
    if rising_edge(clk) then
        if (int1Rgb.green < G_MinValue) and (int1Rgb.red > 90) then
                G_MinValue <= int1Rgb.green;
        end if;
        if (int1Rgb.valid = lo) then
            if (G_MinValue < 300) then
                G_MinValueRow <= G_MinValue;
            end if;
                G_MinValue <= 300;
        end if;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if (int1Rgb.blue < G_MinValue) and (int1Rgb.red > 90) then
                B_MinValue <= int1Rgb.blue;
        end if;
        if (int1Rgb.valid = lo) then
            if (B_MinValue < 300) then
                B_MinValueRow <= B_MinValue;
            end if;
                B_MinValue <= 300;
        end if;
    end if;
end process;

    ilm.rl <= 80;
    ilm.rh <= 230;
    ilm.gl <= 80;
    ilm.gh <= 236;
    ilm.bl <= 40;
    ilm.bh <= 170;
    -- ilm.rl <= R_MinValueRow;
    -- ilm.rh <= 255;
    -- ilm.gl <= G_MinValueRow;
    -- ilm.gh <= 255;
    -- ilm.bl <= B_MinValueRow;
    -- ilm.bh <= 255;
process (clk,reset)begin
    if (reset = lo) then
        int1Rgb.red    <= 0;
        int1Rgb.green  <= 0;
        int1Rgb.blue   <= 0;
    elsif rising_edge(clk) then
        int1Rgb.red    <= to_integer(unsigned(iRgb.red));
        int1Rgb.green  <= to_integer(unsigned(iRgb.green));
        int1Rgb.blue   <= to_integer(unsigned(iRgb.blue));
        int1Rgb.valid  <= iRgb.valid;
    end if;
end process;

rgbMinP: process (clk) begin
    if rising_edge(clk) then
        if ((int1Rgb.red <= int1Rgb.green) and (int1Rgb.red <= int1Rgb.blue)) then
            rgbMin <= int1Rgb.red;
        elsif((int1Rgb.green <= int1Rgb.red) and (int1Rgb.green <= int1Rgb.blue)) then
            rgbMin <= int1Rgb.green;
        else
            rgbMin <= int1Rgb.blue;
        end if;
    end if;
end process rgbMinP;

process (clk) begin
    if rising_edge(clk) then
        rgbDelta      <= rgbMax - rgbMin;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        maxMinSum    <= rgbMax + rgbMin;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if (int2Rgb.red  = rgbMax) and (int2Rgb.red  /= zero)then
            rMax <= hi;
        else
            rMax <= lo;
        end if;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if (int2Rgb.green  = rgbMax) and (int2Rgb.red  /= zero)then
            gMax <= hi;
        else
            gMax <= lo;
        end if;
  end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if (int2Rgb.blue  = rgbMax) and (int2Rgb.red  /= zero)then
            bMax <= hi;
        else
            bMax <= lo;
        end if;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if (int2Rgb.red  = rgbMin) and (int2Rgb.red  /= zero)then
            rMin <= hi;
        else
            rMin <= lo;
        end if;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if (int2Rgb.green  = rgbMin) and (int2Rgb.red  /= zero)then
            gMin <= hi;
        else
            gMin <= lo;
        end if;
  end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if (int2Rgb.blue  = rgbMin) and (int2Rgb.red  /= zero)then
            bMin <= hi;
        else
            bMin <= lo;
        end if;
    end if;
end process;

process (clk) begin
  if rising_edge(clk) then
        rgbColors(0).valid    <=  Rgb1.valid;
    if  (int1Rgb.red = rgbMax) and (int1Rgb.green > int1Rgb.blue) and (int1Rgb.red - int1Rgb.green > 80) then
        rgbColors(0).red      <=  Rgb1.red;
        rgbColors(0).green    <=  Rgb1.green;
        rgbColors(0).blue     <=  Rgb1.blue;
    else
        rgbColors(0).red      <=  black;
        rgbColors(0).green    <=  black;
        rgbColors(0).blue     <=  black;
    end if;
  end if;
end process;

process (clk) begin
  if rising_edge(clk) then
        rgbColors(1).valid    <=  Rgb1.valid;
    if  (int1Rgb.red - int1Rgb.green > 80) then
        rgbColors(1).red      <=  Rgb1.red;
        rgbColors(1).green    <=  Rgb1.green;
        rgbColors(1).blue     <=  Rgb1.blue;
    else
        rgbColors(1).red      <=  black;
        rgbColors(1).green    <=  black;
        rgbColors(1).blue     <=  black;
    end if;
  end if;
end process;

process (clk) begin
  if rising_edge(clk) then
        rgbColors(2).valid    <=  Rgb1.valid;
    if  (rgbDelta > 100) then
        rgbColors(2).red      <=  Rgb1.red;
        rgbColors(2).green    <=  Rgb1.green;
        rgbColors(2).blue     <=  Rgb1.blue;
    else
        rgbColors(2).red      <=  black;
        rgbColors(2).green    <=  black;
        rgbColors(2).blue     <=  black;
    end if;
  end if;
end process;

-- process (clk) begin
  -- if rising_edge(clk) then
        -- rgbColors(1).valid    <=  Rgb1.valid;
    -- if (int1Rgb.red > ilm.rl and int1Rgb.red < ilm.rh) then
        -- rgbColors(1).red      <=  Rgb1.red;
    -- else
        -- rgbColors(1).red      <=  black;
    -- end if;
    -- if (int1Rgb.green > ilm.gl and int1Rgb.green < ilm.gh)  then
        -- rgbColors(1).green    <=  Rgb1.green;
    -- else
        -- rgbColors(1).green    <=  black;
    -- end if;
    -- if (int1Rgb.blue > ilm.bl and int1Rgb.blue < ilm.bh)  then
        -- rgbColors(1).blue     <=  Rgb1.blue;
    -- else
        -- rgbColors(1).blue     <=  black;
    -- end if;
  -- end if;
-- end process;
-- process (clk) begin
  -- if rising_edge(clk) then
        -- rgbColors(2).valid     <=  Rgb2.valid;
    -- if (int2Rgb.blue > ilm.bl and int2Rgb.blue < ilm.bh)  then
        -- rgbColors(2).red     <=  Rgb2.red;
    -- else
        -- rgbColors(2).red     <=  black;
    -- end if;
    -- if (int2Rgb.green > ilm.gl and int2Rgb.green < ilm.gh)  then
        -- rgbColors(2).green    <=  Rgb2.green;
    -- else
        -- rgbColors(2).green    <=  black;
    -- end if;
    -- if (int2Rgb.blue > ilm.bl and int2Rgb.blue < ilm.bh)   then
        -- rgbColors(2).blue     <=  Rgb2.blue;
    -- else
        -- rgbColors(2).blue     <=  black;
    -- end if;
  -- end if;
-- end process;

process (clk) begin
  if rising_edge(clk) then
        rgbColors(3).valid     <=  Rgb2.valid;
    if  (int2Rgb.green > ilm.gl and int2Rgb.green < ilm.gh) and (int2Rgb.blue > ilm.bl and int2Rgb.blue < ilm.bh)  then
        rgbColors(3).red       <=  Rgb2.red;
    else
        rgbColors(3).red       <=  black;
    end if;
    if (int2Rgb.red > ilm.rl and int2Rgb.red < ilm.rh)  then
        rgbColors(3).green     <=  Rgb2.green;
    else
        rgbColors(3).green     <=  black;
    end if;
    if (int2Rgb.blue > ilm.bl and int2Rgb.blue < ilm.bh) and (int2Rgb.green > ilm.gl and int2Rgb.green < ilm.gh)  then
        rgbColors(3).blue      <=  Rgb2.blue;
    else
        rgbColors(3).blue      <=  black;
    end if;
  end if;
end process;

process (clk) begin
  if rising_edge(clk) then
        rgbColors(4).valid   <=  Rgb2.valid;
    if (int2Rgb.green > ilm.gl and int2Rgb.green < ilm.gh) then
        rgbColors(4).red     <=  Rgb2.red;
    else
        rgbColors(4).red     <=  black;
    end if;
    if (int2Rgb.green > ilm.gl and int2Rgb.green < ilm.gh)  then
        rgbColors(4).green     <=  Rgb2.green;
    else
        rgbColors(4).green     <=  black;
    end if;
    if (int2Rgb.green > ilm.gl and int2Rgb.green < ilm.gh)   then
        rgbColors(4).blue     <=  Rgb2.blue;
    else
        rgbColors(4).blue     <=  black;
    end if;
  end if;
end process;

process (clk) begin
  if rising_edge(clk) then
        rgbColors(5).valid     <=  Rgb2.valid;
    if  (int2Rgb.blue > ilm.bl and int2Rgb.blue < ilm.bh)  then
        rgbColors(5).red     <=  Rgb2.red;
    else
        rgbColors(5).red     <=  black;
    end if;
    if (int2Rgb.blue > ilm.bl and int2Rgb.blue < ilm.bh)  then
        rgbColors(5).green     <=  Rgb2.green;
    else
        rgbColors(5).green     <=  black;
    end if;
    if (int2Rgb.blue > ilm.bl and int2Rgb.blue < ilm.bh)   then
        rgbColors(5).blue     <=  Rgb2.blue;
    else
        rgbColors(5).blue     <=  black;
    end if;
  end if;
end process;

process (clk) begin
  if rising_edge(clk) then
        rgbColors(6).valid     <=  Rgb2.valid;
    if  (int2Rgb.red > ilm.rl and int2Rgb.red < ilm.rh)  then
        rgbColors(6).red     <=  Rgb2.red;
    else
        rgbColors(6).red     <=  black;
    end if;
    if (int2Rgb.red > ilm.rl and int2Rgb.red < ilm.rh)  then
        rgbColors(6).green     <=  Rgb2.green;
    else
        rgbColors(6).green     <=  black;
    end if;
    if (int2Rgb.red > ilm.rl and int2Rgb.red < ilm.rh)  then
        rgbColors(6).blue     <=  Rgb2.blue;
    else
        rgbColors(6).blue     <=  black;
    end if;
  end if;
end process;

process (clk) begin
  if rising_edge(clk) then
        rgbColors(7).valid    <=  Rgb2.valid;
        rgbColors(7).red      <=  Rgb2.red;
        rgbColors(7).green    <=  Rgb2.green;
        rgbColors(7).blue     <=  Rgb2.blue;
  end if;
end process;

end behavioral;