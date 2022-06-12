-------------------------------------------------------------------------------
--
-- Filename    : sharp_filter.vhd
-- Create Date : 02092019 [02-09-2019]
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

entity sharp_filter is
generic (
    i_data_width  : integer := 8;
    img_width     : integer := 256;
    adwrWidth     : integer := 16;
    addrWidth     : integer := 12);
port (
    clk           : in std_logic;
    rst_l         : in std_logic;
    iRgb          : in channel;
    kls           : in coefficient;
    oRgb          : out channel);
end entity;
architecture arch of sharp_filter is
---------------------------------------------------------------------------------
    signal vTapRGB0x        : std_logic_vector(29 downto 0) := (others => '0');
    signal vTapRGB1x        : std_logic_vector(29 downto 0) := (others => '0');
    signal vTapRGB2x        : std_logic_vector(29 downto 0) := (others => '0');
    signal v1TapRGB0x       : std_logic_vector(29 downto 0) := (others => '0');
    signal v1TapRGB1x       : std_logic_vector(29 downto 0) := (others => '0');
    signal v1TapRGB2x       : std_logic_vector(29 downto 0) := (others => '0');
    signal enable           : std_logic;
    signal d1en             : std_logic;
    signal d2en             : std_logic;
    signal d3en             : std_logic;
    signal d4en             : std_logic;
    signal d5en             : std_logic;
    signal d6en             : std_logic;
    signal rCountAddress    : integer;
    signal rAddress         : std_logic_vector(15 downto 0);
    signal rgb1x            : channel;
    signal rgb2x            : channel;
    signal d2RGB            : std_logic_vector(29 downto 0) := (others => '0');
    signal valid1_rgb       : std_logic := '0';
    signal valid2_rgb       : std_logic := '0';
    signal valid3_rgb       : std_logic := '0';
    signal valid4_rgb       : std_logic := '0';
    signal valid5_rgb       : std_logic := '0';
    signal valid6_rgb       : std_logic := '0';
    signal valid7_rgb       : std_logic := '0';
    signal valid8_rgb       : std_logic := '0';
    signal valid9_rgb       : std_logic := '0';
    signal valid10rgb       : std_logic := '0';
    signal valid11rgb       : std_logic := '0';
    signal valid12rgb       : std_logic := '0';
    signal valid13rgb       : std_logic := '0';
---------------------------------------------------------------------------------
    signal rgbSyncValid     : std_logic_vector(31 downto 0)  := x"00000000";
    signal rgbSyncEol       : std_logic_vector(31 downto 0)  := x"00000000";
    signal rgbSyncSof       : std_logic_vector(31 downto 0)  := x"00000000";
    signal rgbSyncEof       : std_logic_vector(31 downto 0)  := x"00000000";
begin

    oRgb.valid <= rgbSyncValid(9);
    oRgb.eol   <= rgbSyncEol(9);
    oRgb.sof   <= rgbSyncSof(9);
    oRgb.eof   <= rgbSyncEof(9);

tapValidAdressP: process(clk)begin
    if rising_edge(clk) then
        if (iRgb.valid = '1') then
            rCountAddress  <= rCountAddress + 1;
        else
            rCountAddress  <= 0;
        end if;
    end if;
end process tapValidAdressP;
rAddress  <= std_logic_vector(to_unsigned(rCountAddress, 16));
RGBInst: buffer_controller
generic map(
    img_width       => img_width,
    adwrWidth       => adwrWidth,
    dataWidth       => 30,
    addrWidth       => addrWidth)
port map(
    aclk            => clk,
    i_enable        => iRgb.valid,
    i_data          => d2RGB,
    i_wadd          => rAddress,
    i_radd          => rAddress,
    en_datao        => enable,
    taps0x          => v1TapRGB0x,
    taps1x          => v1TapRGB1x,
    taps2x          => v1TapRGB2x);
MACrInst: sharp_mac
port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(29 downto 20),
    vTap1x          => vTapRGB1x(29 downto 20),
    vTap2x          => vTapRGB2x(29 downto 20),
    kls             => kls,
    DataO           => oRgb.red);
MACgInst: sharp_mac
port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(19 downto 10),
    vTap1x          => vTapRGB1x(19 downto 10),
    vTap2x          => vTapRGB2x(19 downto 10),
    kls             => kls,
    DataO           => oRgb.green);
MACbInst: sharp_mac
port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(9 downto 0),
    vTap1x          => vTapRGB1x(9 downto 0),
    vTap2x          => vTapRGB2x(9 downto 0),
    kls             => kls,
    DataO           => oRgb.blue);
tapSignedP : process (clk) begin
    if rising_edge(clk) then
        rgb1x      <= iRgb;
        rgb2x      <= rgb1x;
        d2RGB      <= rgb2x.red & rgb2x.green & rgb2x.blue;
        d1en       <= enable;
        d2en       <= d1en;
        d3en       <= d2en;
        d4en       <= d3en;
        d5en       <= d4en;
        d6en       <= d5en;
        vTapRGB0x  <=v1TapRGB0x;
        vTapRGB1x  <=v1TapRGB1x;
        vTapRGB2x  <=v1TapRGB2x;
  end if;
end process tapSignedP;

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
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEol(0)  <= iRgb.eol;
        rgbSyncEol(1)  <= rgbSyncEol(0);
        rgbSyncEol(2)  <= rgbSyncEol(1);
        rgbSyncEol(3)  <= rgbSyncEol(2);
        rgbSyncEol(4)  <= rgbSyncEol(3);
        rgbSyncEol(5)  <= rgbSyncEol(4);
        rgbSyncEol(6)  <= rgbSyncEol(5);
        rgbSyncEol(7)  <= rgbSyncEol(6);
        rgbSyncEol(8)  <= rgbSyncEol(7);
        rgbSyncEol(9)  <= rgbSyncEol(8);
        rgbSyncEol(10) <= rgbSyncEol(9);
        rgbSyncEol(11) <= rgbSyncEol(10);
        rgbSyncEol(12) <= rgbSyncEol(11);
        rgbSyncEol(13) <= rgbSyncEol(12);
        rgbSyncEol(14) <= rgbSyncEol(13);
        rgbSyncEol(15) <= rgbSyncEol(14);
        rgbSyncEol(16) <= rgbSyncEol(15);
        rgbSyncEol(17) <= rgbSyncEol(16);
        rgbSyncEol(18) <= rgbSyncEol(17);
        rgbSyncEol(19) <= rgbSyncEol(18);
        rgbSyncEol(20) <= rgbSyncEol(19);
        rgbSyncEol(21) <= rgbSyncEol(20);
        rgbSyncEol(22) <= rgbSyncEol(21);
        rgbSyncEol(23) <= rgbSyncEol(22);
        rgbSyncEol(24) <= rgbSyncEol(23);
        rgbSyncEol(25) <= rgbSyncEol(24);
        rgbSyncEol(26) <= rgbSyncEol(25);
        rgbSyncEol(27) <= rgbSyncEol(26);
        rgbSyncEol(28) <= rgbSyncEol(27);
        rgbSyncEol(29) <= rgbSyncEol(28);
        rgbSyncEol(30) <= rgbSyncEol(29);
        rgbSyncEol(31) <= rgbSyncEol(30);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncSof(0)  <= iRgb.sof;
        rgbSyncSof(1)  <= rgbSyncSof(0);
        rgbSyncSof(2)  <= rgbSyncSof(1);
        rgbSyncSof(3)  <= rgbSyncSof(2);
        rgbSyncSof(4)  <= rgbSyncSof(3);
        rgbSyncSof(5)  <= rgbSyncSof(4);
        rgbSyncSof(6)  <= rgbSyncSof(5);
        rgbSyncSof(7)  <= rgbSyncSof(6);
        rgbSyncSof(8)  <= rgbSyncSof(7);
        rgbSyncSof(9)  <= rgbSyncSof(8);
        rgbSyncSof(10) <= rgbSyncSof(9);
        rgbSyncSof(11) <= rgbSyncSof(10);
        rgbSyncSof(12) <= rgbSyncSof(11);
        rgbSyncSof(13) <= rgbSyncSof(12);
        rgbSyncSof(14) <= rgbSyncSof(13);
        rgbSyncSof(15) <= rgbSyncSof(14);
        rgbSyncSof(16) <= rgbSyncSof(15);
        rgbSyncSof(17) <= rgbSyncSof(16);
        rgbSyncSof(18) <= rgbSyncSof(17);
        rgbSyncSof(19) <= rgbSyncSof(18);
        rgbSyncSof(20) <= rgbSyncSof(19);
        rgbSyncSof(21) <= rgbSyncSof(20);
        rgbSyncSof(22) <= rgbSyncSof(21);
        rgbSyncSof(23) <= rgbSyncSof(22);
        rgbSyncSof(24) <= rgbSyncSof(23);
        rgbSyncSof(25) <= rgbSyncSof(24);
        rgbSyncSof(26) <= rgbSyncSof(25);
        rgbSyncSof(27) <= rgbSyncSof(26);
        rgbSyncSof(28) <= rgbSyncSof(27);
        rgbSyncSof(29) <= rgbSyncSof(28);
        rgbSyncSof(30) <= rgbSyncSof(29);
        rgbSyncSof(31) <= rgbSyncSof(30);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEof(0)  <= iRgb.eof;
        rgbSyncEof(1)  <= rgbSyncEof(0);
        rgbSyncEof(2)  <= rgbSyncEof(1);
        rgbSyncEof(3)  <= rgbSyncEof(2);
        rgbSyncEof(4)  <= rgbSyncEof(3);
        rgbSyncEof(5)  <= rgbSyncEof(4);
        rgbSyncEof(6)  <= rgbSyncEof(5);
        rgbSyncEof(7)  <= rgbSyncEof(6);
        rgbSyncEof(8)  <= rgbSyncEof(7);
        rgbSyncEof(9)  <= rgbSyncEof(8);
        rgbSyncEof(10) <= rgbSyncEof(9);
        rgbSyncEof(11) <= rgbSyncEof(10);
        rgbSyncEof(12) <= rgbSyncEof(11);
        rgbSyncEof(13) <= rgbSyncEof(12);
        rgbSyncEof(14) <= rgbSyncEof(13);
        rgbSyncEof(15) <= rgbSyncEof(14);
        rgbSyncEof(16) <= rgbSyncEof(15);
        rgbSyncEof(17) <= rgbSyncEof(16);
        rgbSyncEof(18) <= rgbSyncEof(17);
        rgbSyncEof(19) <= rgbSyncEof(18);
        rgbSyncEof(20) <= rgbSyncEof(19);
        rgbSyncEof(21) <= rgbSyncEof(20);
        rgbSyncEof(22) <= rgbSyncEof(21);
        rgbSyncEof(23) <= rgbSyncEof(22);
        rgbSyncEof(24) <= rgbSyncEof(23);
        rgbSyncEof(25) <= rgbSyncEof(24);
        rgbSyncEof(26) <= rgbSyncEof(25);
        rgbSyncEof(27) <= rgbSyncEof(26);
        rgbSyncEof(28) <= rgbSyncEof(27);
        rgbSyncEof(29) <= rgbSyncEof(28);
        rgbSyncEof(30) <= rgbSyncEof(29);
        rgbSyncEof(31) <= rgbSyncEof(30);
    end if;
end process;
end arch;