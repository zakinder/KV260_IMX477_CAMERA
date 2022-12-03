-------------------------------------------------------------------------------
--
-- Filename    : rgb_select.vhd
-- Create Date : 01162019 [01-16-2019]
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
entity rgb_select is
port (
    clk            : in std_logic;
	iPerCh         : in integer;
    iRgb           : in channel;
    oRgb           : out channel);
end rgb_select;
architecture behavioral of rgb_select is
begin
process (clk) begin
    if rising_edge(clk) then
        if(iPerCh = 1)then
            oRgb.red       <= iRgb.red;
            oRgb.green     <= iRgb.red;
            oRgb.blue      <= iRgb.red;
        elsif(iPerCh = 2)then
            oRgb.red       <= iRgb.green;
            oRgb.green     <= iRgb.green;
            oRgb.blue      <= iRgb.green;
        elsif(iPerCh = 3)then
            oRgb.red       <= iRgb.blue;
            oRgb.green     <= iRgb.blue;
            oRgb.blue      <= iRgb.blue;
        else
            oRgb.red       <= iRgb.red;
            oRgb.green     <= iRgb.green;
            oRgb.blue      <= iRgb.blue;
        end if;
			oRgb.valid     <= iRgb.valid;
    end if;
end process;
end behavioral;