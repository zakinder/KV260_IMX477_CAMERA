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
    signal vTapRGB0x        : std_logic_vector(23 downto 0) := (others => '0');
    signal vTapRGB1x        : std_logic_vector(23 downto 0) := (others => '0');
    signal vTapRGB2x        : std_logic_vector(23 downto 0) := (others => '0');
    signal v1TapRGB0x       : std_logic_vector(23 downto 0) := (others => '0');
    signal v1TapRGB1x       : std_logic_vector(23 downto 0) := (others => '0');
    signal v1TapRGB2x       : std_logic_vector(23 downto 0) := (others => '0');
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
    signal d2RGB            : std_logic_vector(23 downto 0) := (others => '0');
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
begin
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
    dataWidth       => 24,
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
    vTap0x          => vTapRGB0x(23 downto 16),
    vTap1x          => vTapRGB1x(23 downto 16),
    vTap2x          => vTapRGB2x(23 downto 16),
    kls             => kls,
    DataO           => oRgb.red);
MACgInst: sharp_mac
port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(15 downto 8),
    vTap1x          => vTapRGB1x(15 downto 8),
    vTap2x          => vTapRGB2x(15 downto 8),
    kls             => kls,
    DataO           => oRgb.green);
MACbInst: sharp_mac
port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(i_data_width-1 downto 0),
    vTap1x          => vTapRGB1x(i_data_width-1 downto 0),
    vTap2x          => vTapRGB2x(i_data_width-1 downto 0),
    kls             => kls,
    DataO           => oRgb.blue);
pipValidP: process (clk) begin
    if rising_edge(clk) then
        valid1_rgb    <= rgb2x.valid;
        valid2_rgb    <= valid1_rgb;
        valid3_rgb    <= valid2_rgb;
        valid4_rgb    <= valid3_rgb;
        valid5_rgb    <= valid4_rgb;
        valid6_rgb    <= valid5_rgb;
        valid7_rgb    <= valid6_rgb;
        valid8_rgb    <= valid7_rgb;
        valid9_rgb    <= valid8_rgb;
        valid10rgb    <= valid9_rgb;
        valid11rgb    <= valid10rgb;
        valid12rgb    <= valid11rgb;
        valid13rgb    <= valid12rgb;
        oRgb.valid    <= valid11rgb;
    end if;
end process pipValidP;
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
end arch;