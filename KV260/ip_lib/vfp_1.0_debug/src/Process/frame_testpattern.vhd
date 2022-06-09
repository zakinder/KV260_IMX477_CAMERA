-------------------------------------------------------------------------------
--
-- Filename    : frame_testpattern.vhd
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

entity frame_testpattern is
generic (
    s_data_width           : integer := 16);
port (
    clk                   : in std_logic;
    iValid                : in std_logic;
    iCord                 : in coord;
    oRgb                  : out blurchannel);
end frame_testpattern;
architecture arch_imp of frame_testpattern is
    signal xCounter           : integer;
    signal yCounter           : integer;
    signal rowdist            : integer;
    signal nrowdist           : integer;
    signal coldist            : integer;
    signal ncoldist           : integer;
    signal irgbSum            : integer;
begin
    xCounter    <= to_integer(unsigned(iCord.x));
    yCounter    <= to_integer(unsigned(iCord.y));
tPattenP: Process (clk) begin
    if rising_edge(clk) then
        if (iValid = hi)  then
            if xcounter > 960 then
                rowdist <= xcounter - 960;
            else
                rowdist <= 960 - xcounter;
            end if;
            if rowdist > 480 then
                nrowdist <= rowdist - 480;
            else
                nrowdist <= 480 - rowdist;
            end if;
            if ycounter > 540 then
                coldist <= ycounter -540;
            else
                coldist <= 540 - ycounter;
            end if;
            if coldist > 270 then
                ncoldist <= coldist - 270;
            else
                ncoldist <= 270 - coldist;
            end if;
            irgbSum <= nrowdist + ncoldist;
        end if;
    end if;
end process tPattenP;
rgbSumP: Process (clk) begin
    if rising_edge(clk) then
        oRgb.valid    <= iValid;
        oRgb.red      <= std_logic_vector(to_unsigned(irgbSum,12));
        oRgb.green    <= std_logic_vector(to_unsigned(irgbSum,12));
        oRgb.blue     <= std_logic_vector(to_unsigned(irgbSum,12));
    end if;
end process rgbSumP;
end arch_imp;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity ResoTestPattern is
generic (
    s_data_width           : integer := 16);
port (
    clk                   : in std_logic;
    iValid                : in std_logic;
    iCord                 : in coord;
    oRgbCo                : out channel;
    oRgbRed               : out channel;
    oRgbGre               : out channel;
    oRgbBlu               : out channel);
end ResoTestPattern;
architecture arch_imp of ResoTestPattern is
    signal cWidth             : natural := 25;
    signal xCounter           : natural range 0 to (frameSizeRht-1) := 0;
    signal yCounter           : natural range 0 to (frameSizeBot-1) := 0;
    signal rowdist            : natural range 0 to 255 := 0;
    signal nrowdist           : natural range 0 to 2 := 0;
    signal bCoRed             : natural range 0 to 255 := 0;
    signal bCoGre             : natural range 0 to 255 := 0;
    signal bCoBlu             : natural range 0 to 255 := 0;
begin
    xCounter    <= to_integer(unsigned(iCord.x));
    yCounter    <= to_integer(unsigned(iCord.y));
nRowDistP: process(clk) begin
    if rising_edge(clk) then
        if (xCounter = frameSizeRht-1) then
            nrowdist  <= nrowdist + one;
        else
            if (nrowdist>2) then
                nrowdist <= zero;
            end if;
        end if;
    end if;
end process nRowDistP;
bCoP: process(clk) begin
    if rising_edge(clk) then
        if (nrowdist = 0) then
            bCoRed  <= rowdist;
            bCoGre  <= 0;
            bCoBlu  <= 0;
        elsif(nrowdist = 1) then
            bCoRed  <= 0;
            bCoGre  <= rowdist;
            bCoBlu  <= 0;
        else
            bCoRed  <= 0;
            bCoGre  <= 0;
            bCoBlu  <= rowdist;
        end if;
    end if;
end process bCoP;
tPattenP: Process (clk) begin
    if rising_edge(clk) then
        if (iValid = hi)  then
            if (xcounter <= ((frameSizeRht/10)*1)) then
                rowdist  <= 0;
            elsif(xcounter <= ((frameSizeRht/10)*2)) then
                rowdist  <= cWidth*2;
            elsif(xcounter <= ((frameSizeRht/10)*3)) then
                rowdist  <= cWidth*3;
            elsif(xcounter <= ((frameSizeRht/10)*4)) then
                rowdist  <= cWidth*4;
            elsif(xcounter <= ((frameSizeRht/10)*5)) then
                rowdist  <= cWidth*5;
            elsif(xcounter <= ((frameSizeRht/10)*6)) then
                rowdist  <= cWidth*6;
            elsif(xcounter <= ((frameSizeRht/10)*7)) then
                rowdist  <= cWidth*7;
            elsif(xcounter <= ((frameSizeRht/10)*8)) then
                rowdist  <= cWidth*8;
            elsif(xcounter <= ((frameSizeRht/10)*9)) then
                rowdist  <= cWidth*9;
            else
                rowdist  <= cWidth*10 + 5;
            end if;
        end if;
    end if;
end process tPattenP;
oRgbCoP: Process (clk) begin
    if rising_edge(clk) then
        oRgbCo.valid    <= iValid;
        oRgbCo.red      <= std_logic_vector(to_unsigned(bCoRed,8));
        oRgbCo.green    <= std_logic_vector(to_unsigned(bCoGre,8));
        oRgbCo.blue     <= std_logic_vector(to_unsigned(bCoBlu,8));
    end if;
end process oRgbCoP;
oRgbRedCoP: Process (clk) begin
    if rising_edge(clk) then
        oRgbRed.valid    <= iValid;
        oRgbRed.red      <= std_logic_vector(to_unsigned(rowdist,8));
        oRgbRed.green    <= std_logic_vector(to_unsigned(0,8));
        oRgbRed.blue     <= std_logic_vector(to_unsigned(0,8));
    end if;
end process oRgbRedCoP;
oRgbGreCoP: Process (clk) begin
    if rising_edge(clk) then
        oRgbGre.valid    <= iValid;
        oRgbGre.red      <= std_logic_vector(to_unsigned(0,8));
        oRgbGre.green    <= std_logic_vector(to_unsigned(rowdist,8));
        oRgbGre.blue     <= std_logic_vector(to_unsigned(0,8));
    end if;
end process oRgbGreCoP;
oRgbBluCoP: Process (clk) begin
    if rising_edge(clk) then
        oRgbBlu.valid    <= iValid;
        oRgbBlu.red      <= std_logic_vector(to_unsigned(0,8));
        oRgbBlu.green    <= std_logic_vector(to_unsigned(0,8));
        oRgbBlu.blue     <= std_logic_vector(to_unsigned(rowdist,8));
    end if;
end process oRgbBluCoP;
end arch_imp;