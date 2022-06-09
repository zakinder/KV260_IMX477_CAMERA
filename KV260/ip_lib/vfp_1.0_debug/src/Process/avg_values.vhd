-------------------------------------------------------------------------------
--
-- Filename    : avg_values.vhd
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

entity avg_values is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    aRgb           : in channel;
    bRgb           : in channel;
    cRgb           : in channel;
    oRgb           : out channel);
end avg_values;
architecture behavioral of avg_values is
    signal uFl1Rgb  : tpToFloatRecord;
    signal uFl2Rgb  : tpToFloatRecord;
    signal uFl3Rgb  : tpToFloatRecord;
    signal uFl4Rgb  : tpToFloatRecord;
    signal uFl5Rgb  : tpToFloatRecord;
begin
-----------------------------------------------------------------------------------------------
-- STAGE 1
-----------------------------------------------------------------------------------------------
process (clk,reset)begin
    if (reset = lo) then
        uFl1Rgb.red    <= (others => '0');
        uFl1Rgb.green  <= (others => '0');
        uFl1Rgb.blue   <= (others => '0');
    elsif rising_edge(clk) then
        uFl1Rgb.red    <= to_float(unsigned(aRgb.red),uFl1Rgb.red);
        uFl1Rgb.green  <= to_float(unsigned(aRgb.green),uFl1Rgb.green);
        uFl1Rgb.blue   <= to_float(unsigned(aRgb.blue),uFl1Rgb.blue);
        uFl1Rgb.valid  <= aRgb.valid;
    end if;
end process;
process (clk,reset)begin
    if (reset = lo) then
        uFl2Rgb.red    <= (others => '0');
        uFl2Rgb.green  <= (others => '0');
        uFl2Rgb.blue   <= (others => '0');
    elsif rising_edge(clk) then
        uFl2Rgb.red    <= to_float(unsigned(bRgb.red),uFl2Rgb.red);
        uFl2Rgb.green  <= to_float(unsigned(bRgb.green),uFl2Rgb.green);
        uFl2Rgb.blue   <= to_float(unsigned(bRgb.blue),uFl2Rgb.blue);
        uFl2Rgb.valid  <= bRgb.valid;
    end if;
end process;
process (clk,reset)begin
    if (reset = lo) then
        uFl3Rgb.red    <= (others => '0');
        uFl3Rgb.green  <= (others => '0');
        uFl3Rgb.blue   <= (others => '0');
    elsif rising_edge(clk) then
        uFl3Rgb.red    <= to_float(unsigned(cRgb.red),uFl2Rgb.red);
        uFl3Rgb.green  <= to_float(unsigned(cRgb.green),uFl2Rgb.green);
        uFl3Rgb.blue   <= to_float(unsigned(cRgb.blue),uFl2Rgb.blue);
        uFl3Rgb.valid  <= cRgb.valid;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 2
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        uFl4Rgb.red         <= uFl1Rgb.red + uFl2Rgb.red + uFl3Rgb.red;
        uFl4Rgb.green       <= uFl1Rgb.green + uFl2Rgb.green + uFl3Rgb.green;
        uFl4Rgb.blue        <= uFl1Rgb.blue + uFl2Rgb.blue + uFl3Rgb.blue;
        uFl4Rgb.valid       <= uFl1Rgb.valid or uFl2Rgb.valid or uFl3Rgb.valid;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 3
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        if(uFl4Rgb.red > 0) and (uFl4Rgb.green > 0) and (uFl4Rgb.blue > 0) then
            uFl5Rgb.red    <= uFl4Rgb.red / 3.0;
            uFl5Rgb.green  <= uFl4Rgb.green / 3.0;
            uFl5Rgb.blue   <= uFl4Rgb.blue / 3.0;
            uFl5Rgb.valid  <= uFl4Rgb.valid;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        oRgb.red   <= std_logic_vector(to_unsigned(uFl5Rgb.red,8));
        oRgb.green <= std_logic_vector(to_unsigned(uFl5Rgb.green,8));
        oRgb.blue  <= std_logic_vector(to_unsigned(uFl5Rgb.blue,8));
        oRgb.valid <= uFl5Rgb.valid;
    end if;
end process;
end behavioral;