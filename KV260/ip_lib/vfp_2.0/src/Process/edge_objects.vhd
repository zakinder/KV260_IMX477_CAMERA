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

entity edge_objects is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    oRgbRemix      : out channel);
end entity;

architecture arch of edge_objects is

    signal rMax             : std_logic_vector(i_data_width-1 downto 0);
    signal rMin             : std_logic_vector(i_data_width-1 downto 0);
    signal gMax             : std_logic_vector(i_data_width-1 downto 0);
    signal gMin             : std_logic_vector(i_data_width-1 downto 0);
    signal bMax             : std_logic_vector(i_data_width-1 downto 0);
    signal bMin             : std_logic_vector(i_data_width-1 downto 0);
    signal dGrid            : std_logic;
    signal rgb1Int          : intChannel;
    signal rgb2Int          : intChannel;
    signal rgb3Int          : intChannel;
    signal rgb4Int          : intChannel;
    signal rgb1b            : channel;
    signal rgb2b            : channel;
    signal rgb3b            : channel;
    signal rgb4b            : channel;
    signal rgbMax           : integer;
    signal rgbMin           : integer;
    signal rgbDelta         : integer;
    signal minValue         : integer;
    signal maxValue         : integer;
    signal rgbRInt          : integer;
    signal rgbSyncValid     : std_logic_vector(3 downto 0)  := x"0";
begin
process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= iRgb.valid;
        rgbSyncValid(1)  <= rgbSyncValid(0);
        rgbSyncValid(2)  <= rgbSyncValid(1);
        rgbSyncValid(3)  <= rgbSyncValid(2);
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
      rgb4Int          <= rgb3Int;
      rgb1b            <= iRgb;
      rgb2b            <= rgb1b;
      rgb3b            <= rgb2b;
    end if;
end process piplRgbBlurXP;
rgbMaxP: process (clk) begin
    if rising_edge(clk) then
        if ((rgb1Int.red >= rgb1Int.green) and (rgb1Int.red >= rgb1Int.blue)) then
            rgbMax <= rgb1Int.red;
        elsif((rgb1Int.green >= rgb1Int.red) and (rgb1Int.green >= rgb1Int.blue))then
            rgbMax <= rgb1Int.green;
        else
            rgbMax <= rgb1Int.blue;
        end if;
    end if;
end process rgbMaxP;
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
rgbDeltaP: process (clk) begin
    if rising_edge(clk) then
        rgbDelta      <= rgbMax - rgbMin;
    end if;
end process rgbDeltaP;

rgbP: process (clk) begin
  if rising_edge(clk) then
    oRgbRemix.red   <= std_logic_vector(to_unsigned(rgbDelta,8));
    oRgbRemix.green <= std_logic_vector(to_unsigned(rgbDelta,8));
    oRgbRemix.blue  <= std_logic_vector(to_unsigned(rgbDelta,8));
    oRgbRemix.valid <= rgbSyncValid(2);
  end if;
end process rgbP;



ipRgbMaxUfD1P: process (clk) begin
    if rising_edge(clk) then
        maxValue          <= rgbMax;
        minValue          <= rgbMin;
    end if;
end process ipRgbMaxUfD1P;
process (clk) begin
    if rising_edge(clk) then
        if (rgb1Int.red > rgb1Int.green) then
            rgbRInt        <= (rgb1Int.red - rgb1Int.green);
        else
            rgbRInt        <= 0;
        end if;
    end if;
end process;
--hueP: process (clk) begin
--  if rising_edge(clk) then
--    if((rgb2Int.red = rgbMax) and (rgb2Int.green > 40 and rgb2Int.green < 150) and (rgb2Int.blue > 40 and rgb2Int.blue< 150)) then
--            oRgbRemix.red   <= rgb3b.red;
--            oRgbRemix.green <= rgb3b.green;
--            oRgbRemix.blue  <= rgb3b.blue;
--    else
--            oRgbRemix.red   <= black;
--            oRgbRemix.green <= black;
--            oRgbRemix.blue  <= black;
--    end if;
--  end if;
--end process hueP;
--oRgbRemix.valid <= iRgb.valid;
------------------------------------------------------------------------------------------------
-- rgbRemix : process (clk) begin
    -- if rising_edge(clk) then
    -- if rst_l = '0' then
        -- oRgbRemix.red   <= (others => '0');
        -- oRgbRemix.green <= (others => '0');
        -- oRgbRemix.blue  <= (others => '0');
        -- rMax            <= (others => '0');
        -- rMin            <= (others => '1');
        -- gMax            <= (others => '0');
        -- gMin            <= (others => '1');
        -- bMax            <= (others => '0');
        -- bMin            <= (others => '1');
        -- dGrid           <= lo;
    -- else
        -- if (iRgb.valid = hi) then
        -- if((rgb2Int.red > 40 and rgb2Int.red < 150) and (rgb2Int.green > 40 and rgb2Int.green < 150) and (rgb2Int.blue > 40 and rgb2Int.blue< 150)) then
        -----if(rgb2Int.red < 72 and rgb2Int.green < 100) and (rgb2Int.green < rgb2Int.blue) then -- blue is red and vice versa
            -- if(rgb2Int.green < rgb2Int.blue) then -- blue is red and vice versa
                    -------------------------------------
                    -- oRgbRemix.red   <= rgb2b.red;
                    -- oRgbRemix.green <= rgb2b.green;
                    -- oRgbRemix.blue  <= rgb2b.blue;
                    -------------------------------------
                    -- dGrid      <= hi;
                    -- if(rgb2b.red > rMax) then
                        -- rMax   <= rgb2b.red;
                    -- end if;
                    -- if(rgb2b.red < rMin) then
                        -- rMin   <= rgb2b.red;
                    -- end if;
                    -- if(rgb2b.green > gMax) then
                        -- gMax   <= rgb2b.green;
                    -- end if;
                    -- if(rgb2b.green < gMin) then
                        -- gMin   <= rgb2b.green;
                    -- end if;
                    -- if(rgb2b.red > bMax) then
                        -- bMax   <= rgb2b.red;
                    -- end if;
                    -- if(rgb2b.blue < bMin) then
                        -- bMin   <= rgb2b.blue;
                    -- end if;
                    -------------------------------------
                -- else
                    -- oRgbRemix.red   <= black;
                    -- oRgbRemix.green <= black;
                    -- oRgbRemix.blue  <= black;
                    -- dGrid           <= lo;
                -- end if;
        -- else
            -- oRgbRemix.red   <= black;
            -- oRgbRemix.green <= black;
            -- oRgbRemix.blue  <= black;
        -- end if;

        -- end if;
    -- end if;
    -- end if;
-- end process rgbRemix;
------------------------------------------------------------------------------------------------
end architecture;