-------------------------------------------------------------------------------
--
-- Filename    : testpattern.vhd
-- Create Date : 01062019 [01-06-2019]
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

entity testpattern is
port (
    clk                   : in std_logic;
    iValid                : in std_logic;
    iCord                 : in coord;
    tpSelect              : in integer;
    oRgb                  : out channel);
end testpattern;
architecture arch_imp of testpattern is

    signal fTestPattern        : blurchannel;
    signal rTestPattern        : channel;
    signal rgbCo               : channel;
    signal rgbRed              : channel;
    signal rgbGre              : channel;
    signal rgbBlu              : channel;

begin

FrameTestPatternInst: frame_testpattern
generic map(
    s_data_width => 16)
port map(
    clk          => clk,
    iValid       => iValid,
    iCord        => iCord,
    oRgb         => fTestPattern);
ResoTestPatternInst: ResoTestPattern
generic map(
    s_data_width => 16)
port map(
    clk          => clk,
    iValid       => iValid,
    iCord        => iCord,
    oRgbCo       => rgbCo,
    oRgbRed      => rgbRed,
    oRgbGre      => rgbGre,
    oRgbBlu      => rgbBlu);
process (clk) begin
    if rising_edge(clk) then
        if(tpSelect = 0)then
            oRgb.valid     <= fTestPattern.valid;
            oRgb.red       <= fTestPattern.red(7 downto 0);
            oRgb.green     <= fTestPattern.green(7 downto 0);
            oRgb.blue      <= fTestPattern.blue(7 downto 0);
        elsif(tpSelect = 1)then
            oRgb.valid     <= fTestPattern.valid;
            oRgb.red       <= x"0" & fTestPattern.red(3 downto 0);
            oRgb.green     <= x"0" & fTestPattern.green(7 downto 4);
            oRgb.blue      <= x"0" & fTestPattern.blue(11 downto 8);
        elsif(tpSelect = 2)then
            oRgb.valid     <= fTestPattern.valid;
            oRgb.red       <= fTestPattern.red(7 downto 0);
            oRgb.green     <= x"0" & fTestPattern.green(7 downto 4);
            oRgb.blue      <= x"0" & fTestPattern.blue(11 downto 8);
        elsif(tpSelect = 3)then
            oRgb.valid     <= fTestPattern.valid;
            oRgb.red       <= x"0" & fTestPattern.red(3 downto 0);
            oRgb.green     <= fTestPattern.green(7 downto 0);
            oRgb.blue      <= x"0" & fTestPattern.blue(11 downto 8);
        elsif(tpSelect = 4)then
            oRgb.valid     <= fTestPattern.valid;
            oRgb.red       <= x"0" & fTestPattern.red(3 downto 0);
            oRgb.green     <= x"0" & fTestPattern.green(7 downto 4);
            oRgb.blue      <= fTestPattern.blue(7 downto 0);
        elsif(tpSelect = 5)then
            oRgb.valid     <= rgbCo.valid;
            oRgb.red       <= rgbCo.red;
            oRgb.green     <= rgbCo.green;
            oRgb.blue      <= rgbCo.blue;
        elsif(tpSelect = 6)then
            oRgb.valid     <= rgbRed.valid;
            oRgb.red       <= rgbRed.red;
            oRgb.green     <= rgbRed.green;
            oRgb.blue      <= rgbRed.blue;
        elsif(tpSelect = 7)then
            oRgb.valid     <= rgbGre.valid;
            oRgb.red       <= rgbGre.red;
            oRgb.green     <= rgbGre.green;
            oRgb.blue      <= rgbGre.blue;
        else
            oRgb.valid     <= rgbBlu.valid;
            oRgb.red       <= rgbBlu.red;
            oRgb.green     <= rgbBlu.green;
            oRgb.blue      <= rgbBlu.blue;
        end if;
    end if;
end process;
end arch_imp;