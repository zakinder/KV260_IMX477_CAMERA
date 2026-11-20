-------------------------------------------------------------------------------
--
-- Filename    : sync_frames.vhd
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

entity sync_frames is
generic (
    pixelDelay     : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end sync_frames;
architecture behavioral of sync_frames is
    signal rgbDelays      : rgbArray(0 to 80);
begin
oRgb <= rgbDelays(pixelDelay).rgb;
process (clk) begin
    if rising_edge(clk) then
        rgbDelays(0).rgb      <= iRgb;
        rgbDelays(1)          <= rgbDelays(0);
        rgbDelays(2)          <= rgbDelays(1);
        rgbDelays(3)          <= rgbDelays(2);
        rgbDelays(4)          <= rgbDelays(3);
        rgbDelays(5)          <= rgbDelays(4);
        rgbDelays(6)          <= rgbDelays(5);
        rgbDelays(7)          <= rgbDelays(6);
        rgbDelays(8)          <= rgbDelays(7);
        rgbDelays(9)          <= rgbDelays(8);
        rgbDelays(10)         <= rgbDelays(9);
        rgbDelays(11)         <= rgbDelays(10);
        rgbDelays(12)         <= rgbDelays(11);
        rgbDelays(13)         <= rgbDelays(12);
        rgbDelays(14)         <= rgbDelays(13);
        rgbDelays(15)         <= rgbDelays(14);
        rgbDelays(16)         <= rgbDelays(15);
        rgbDelays(17)         <= rgbDelays(16);
        rgbDelays(18)         <= rgbDelays(17);
        rgbDelays(19)         <= rgbDelays(18);
        rgbDelays(20)         <= rgbDelays(19);
        rgbDelays(21)         <= rgbDelays(20);
        rgbDelays(22)         <= rgbDelays(21);
        rgbDelays(23)         <= rgbDelays(22);
        rgbDelays(24)         <= rgbDelays(23);
        rgbDelays(25)         <= rgbDelays(24);
        rgbDelays(26)         <= rgbDelays(25);
        rgbDelays(27)         <= rgbDelays(26);
        rgbDelays(28)         <= rgbDelays(27);
        rgbDelays(29)         <= rgbDelays(28);
        rgbDelays(30)         <= rgbDelays(29);
        rgbDelays(31)         <= rgbDelays(30);
        rgbDelays(32)         <= rgbDelays(31);
        rgbDelays(33)         <= rgbDelays(32);
        rgbDelays(34)         <= rgbDelays(33);
        rgbDelays(35)         <= rgbDelays(34);
        rgbDelays(36)         <= rgbDelays(35);
        rgbDelays(37)         <= rgbDelays(36);
        rgbDelays(38)         <= rgbDelays(37);
        rgbDelays(39)         <= rgbDelays(38);
        rgbDelays(40)         <= rgbDelays(39);
        rgbDelays(41)         <= rgbDelays(40);
        rgbDelays(42)         <= rgbDelays(41);
        rgbDelays(43)         <= rgbDelays(42);
        rgbDelays(44)         <= rgbDelays(43);
        rgbDelays(45)         <= rgbDelays(44);
        rgbDelays(46)         <= rgbDelays(45);
        rgbDelays(47)         <= rgbDelays(46);
        rgbDelays(48)         <= rgbDelays(47);
        rgbDelays(49)         <= rgbDelays(48);
        rgbDelays(50)         <= rgbDelays(49);
        rgbDelays(51)         <= rgbDelays(50);
        rgbDelays(52)         <= rgbDelays(51);
        rgbDelays(53)         <= rgbDelays(52);
        rgbDelays(54)         <= rgbDelays(53);
        rgbDelays(55)         <= rgbDelays(54);
        rgbDelays(56)         <= rgbDelays(55);
        rgbDelays(57)         <= rgbDelays(56);
        rgbDelays(58)         <= rgbDelays(57);
        rgbDelays(59)         <= rgbDelays(58);
        rgbDelays(60)         <= rgbDelays(59);
        rgbDelays(61)         <= rgbDelays(60);
        rgbDelays(62)         <= rgbDelays(61);
        rgbDelays(63)         <= rgbDelays(62);
        rgbDelays(64)         <= rgbDelays(63);
        rgbDelays(65)         <= rgbDelays(64);
        rgbDelays(66)         <= rgbDelays(65);
        rgbDelays(67)         <= rgbDelays(66);
        rgbDelays(68)         <= rgbDelays(67);
        rgbDelays(69)         <= rgbDelays(68);
        rgbDelays(70)         <= rgbDelays(69);
        rgbDelays(71)         <= rgbDelays(70);
        rgbDelays(72)         <= rgbDelays(71);
        rgbDelays(73)         <= rgbDelays(72);
        rgbDelays(74)         <= rgbDelays(73);
        rgbDelays(75)         <= rgbDelays(74);
        rgbDelays(76)         <= rgbDelays(75);
        rgbDelays(77)         <= rgbDelays(76);
        rgbDelays(78)         <= rgbDelays(77);
        rgbDelays(79)         <= rgbDelays(78);
        rgbDelays(80)         <= rgbDelays(79);
    end if;
end process;
end behavioral;