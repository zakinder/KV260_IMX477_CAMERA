-------------------------------------------------------------------------------
--
-- Filename    : d_valid.vhd
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
entity d_valid is
generic (
    pixelDelay     : integer := 8);
port (
    clk            : in std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end d_valid;
architecture behavioral of d_valid is
signal rgbSyncValid    : std_logic_vector(56 downto 0)  := (others => '0');
begin
process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= iRgb.valid;
        rgbSyncValid(1)  <= rgbSyncValid(0);
        rgbSyncValid(2)  <= rgbSyncValid(1);
        rgbSyncValid(3)  <= rgbSyncValid(2);
        rgbSyncValid(4)  <= rgbSyncValid(3);
        rgbSyncValid(5)  <= rgbSyncValid(4);
        rgbSyncValid(6)  <= rgbSyncValid(5);
        rgbSyncValid(7)  <= rgbSyncValid(6);
        rgbSyncValid(8)  <= rgbSyncValid(7);
        rgbSyncValid(9)  <= rgbSyncValid(8);
        rgbSyncValid(10) <= rgbSyncValid(9);
        rgbSyncValid(11) <= rgbSyncValid(10);
        rgbSyncValid(12) <= rgbSyncValid(11);
        rgbSyncValid(13) <= rgbSyncValid(12);
        rgbSyncValid(14) <= rgbSyncValid(13);
        rgbSyncValid(15) <= rgbSyncValid(14);
        rgbSyncValid(16) <= rgbSyncValid(15);
        rgbSyncValid(17) <= rgbSyncValid(16);
        rgbSyncValid(18) <= rgbSyncValid(17);
        rgbSyncValid(19) <= rgbSyncValid(18);
        rgbSyncValid(20) <= rgbSyncValid(19);
        rgbSyncValid(21) <= rgbSyncValid(20);
        rgbSyncValid(22) <= rgbSyncValid(21);
        rgbSyncValid(23) <= rgbSyncValid(22);
        rgbSyncValid(24) <= rgbSyncValid(23);
        rgbSyncValid(25) <= rgbSyncValid(24);
        rgbSyncValid(26) <= rgbSyncValid(25);
        rgbSyncValid(27) <= rgbSyncValid(26);
        rgbSyncValid(28) <= rgbSyncValid(27);
        rgbSyncValid(29) <= rgbSyncValid(28);
        rgbSyncValid(30) <= rgbSyncValid(29);
        rgbSyncValid(31) <= rgbSyncValid(30);
        rgbSyncValid(32) <= rgbSyncValid(31);
        rgbSyncValid(33) <= rgbSyncValid(32);
        rgbSyncValid(34) <= rgbSyncValid(33);
        rgbSyncValid(35) <= rgbSyncValid(34);
        rgbSyncValid(36) <= rgbSyncValid(35);
        rgbSyncValid(37) <= rgbSyncValid(36);
        rgbSyncValid(38) <= rgbSyncValid(37);
        rgbSyncValid(39) <= rgbSyncValid(38);
        rgbSyncValid(40) <= rgbSyncValid(39);
        rgbSyncValid(41) <= rgbSyncValid(40);
        rgbSyncValid(42) <= rgbSyncValid(41);
        rgbSyncValid(43) <= rgbSyncValid(42);
        rgbSyncValid(44) <= rgbSyncValid(43);
        rgbSyncValid(45) <= rgbSyncValid(44);
        rgbSyncValid(46) <= rgbSyncValid(45);
        rgbSyncValid(47) <= rgbSyncValid(46);
        rgbSyncValid(48) <= rgbSyncValid(47);
        rgbSyncValid(49) <= rgbSyncValid(48);
        rgbSyncValid(50) <= rgbSyncValid(49);
        rgbSyncValid(51) <= rgbSyncValid(50);
        rgbSyncValid(52) <= rgbSyncValid(51);
        rgbSyncValid(53) <= rgbSyncValid(52);
        rgbSyncValid(54) <= rgbSyncValid(53);
        rgbSyncValid(55) <= rgbSyncValid(54);
        rgbSyncValid(56) <= rgbSyncValid(55);
    end if;
end process;
    oRgb.red      <= iRgb.red;
    oRgb.green    <= iRgb.green;
    oRgb.blue     <= iRgb.blue;
    oRgb.valid    <= rgbSyncValid(pixelDelay);
end behavioral;