-------------------------------------------------------------------------------
--
-- Filename    : raw_to_rgb.vhd
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

entity raw_to_rgb is
port (
    clk             : in std_logic;
    rst_l           : in std_logic;
    iTpData         : in rTp;
    oRgbSet         : out rRgb);
end entity;

architecture arch of raw_to_rgb is

    signal rgb      : rawRgb;
    signal tpd1     : uTp;
    signal r1Valid  : std_logic := lo;
    signal r2Valid  : std_logic := lo;
    signal d1TpData : rTp;
    signal d2TpData : rTp;

begin

validSyncP: process(clk) begin
    if rising_edge(clk) then
        r1Valid       <= iTpData.valid;
        r2Valid       <= r1Valid;
        oRgbSet.valid <= r2Valid;
        d1TpData      <= iTpData;
        d2TpData      <= d1TpData;
        oRgbSet.pEof  <= d2TpData.pEof;
        oRgbSet.pSof  <= d2TpData.pSof;
        oRgbSet.cord  <= d2TpData.cord;
    end if;
end process validSyncP;

syncDataP: process (clk) begin
    if rising_edge(clk) then
        if rst_l = '0' then
            tpd1.tp3  <=(others => '0');
            tpd1.tp2  <=(others => '0');
            tpd1.tp1  <=(others => '0');
            else
            tpd1.tp1  <=unsigned(iTpData.taps.tp1);
            tpd1.tp2  <=unsigned(iTpData.taps.tp2);
            tpd1.tp3  <=unsigned(iTpData.taps.tp3);
            end if;
        end if;
end process syncDataP;
rawToRgbP: process (clk)
    variable loc_addr : std_logic_vector(1 downto 0);
    begin
        if rising_edge(clk) then
        if rst_l = lo then
            rgb.red   <=(others => '0');
            rgb.green <=(others => '0');
            rgb.blue  <=(others => '0');
        else
        loc_addr := iTpData.cord.y(0) & iTpData.cord.x(0);
        case loc_addr IS
            when b"11" =>
                rgb.red   <= tpd1.tp2;
                rgb.green <= (unsigned(iTpData.taps.tp2) + tpd1.tp1) & lo;
                rgb.blue  <= unsigned(iTpData.taps.tp1);
            when b"10" =>
                rgb.red   <= unsigned(iTpData.taps.tp2);
                rgb.green <= (tpd1.tp2 + unsigned(iTpData.taps.tp3)) & lo;
                rgb.blue  <= tpd1.tp3;
            when b"01" =>
                rgb.red   <= tpd1.tp1;
                rgb.green <= (unsigned(iTpData.taps.tp1) + tpd1.tp2) & lo;
                rgb.blue  <= unsigned(iTpData.taps.tp2);
            when b"00" =>
                rgb.red   <= unsigned(iTpData.taps.tp1);
                rgb.green <= (tpd1.tp1 + unsigned(iTpData.taps.tp2)) & lo;
                rgb.blue  <= tpd1.tp2;
            when others =>
                rgb.red   <= rgb.red;
                rgb.green <= rgb.green;
                rgb.blue  <= rgb.blue;
        end case;
        end if;
        end if;
end process rawToRgbP;
    oRgbSet.red    <= std_logic_vector(rgb.red(11 downto 4));
    oRgbSet.green  <= std_logic_vector(rgb.green(12 downto 5));
    oRgbSet.blue   <= std_logic_vector(rgb.blue(11 downto 4));
end architecture;