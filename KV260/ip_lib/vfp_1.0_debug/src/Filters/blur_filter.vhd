-------------------------------------------------------------------------------
--
-- Filename      : blur_filter.vhd
-- Create Date   : 02092019 [02-09-2019]
-- Modified Date : 12302021 [12-30-2021]
-- Author        : Zakinder
--
-- Description   :
-- This file instantiation
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity blur_filter is
generic (
    iMSB          : integer := 11;
    iLSB          : integer := 4;
    i_data_width  : integer := 8;
    img_width     : integer := 256;
    adwrWidth     : integer := 16;
    addrWidth     : integer := 12);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end entity;
architecture arch of blur_filter is
    signal vTapRgb1         : std_logic_vector(23 downto 0);
    signal vTapRgb2         : std_logic_vector(23 downto 0);
    signal vTapRgb3         : std_logic_vector(23 downto 0);
    signal dTapRgb1         : std_logic_vector(23 downto 0);
    signal dTapRgb2         : std_logic_vector(23 downto 0);
    signal dTapRgb3         : std_logic_vector(23 downto 0);
    signal enable           : std_logic;
    signal d1En             : std_logic;
    signal d2En             : std_logic;
    signal d3En             : std_logic;
    signal d4En             : std_logic;
    signal d3Rgb            : std_logic_vector(23 downto 0);
    signal rCountAddress    : integer;
    signal rAddress         : std_logic_vector(15 downto 0);
    signal rgb1x            : channel;
    signal rgb2x            : channel;
    signal rgb3x            : channel;
    signal blurRgb          : blurchannel;
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
begin
    oRgb.red   <= blurRgb.red(iMSB downto iLSB);
    oRgb.green <= blurRgb.green(iMSB downto iLSB);
    oRgb.blue  <= blurRgb.blue(iMSB downto iLSB);
    oRgb.valid <= blurRgb.valid;
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
RGB_inst: buffer_controller
generic map(
    img_width       => img_width,
    adwrWidth       => adwrWidth,
    dataWidth       => 24,
    addrWidth       => addrWidth)
port map(
    aclk            => clk,
    i_enable        => rgb2x.valid,
    i_data          => d3Rgb,
    i_wadd          => rAddress,
    i_radd          => rAddress,
    en_datao        => enable,
    taps0x          => dTapRgb1,
    taps1x          => dTapRgb2,
    taps2x          => dTapRgb3);
MAC_R_inst: blur_mac
generic map(
    i_data_width    => 8)
port map(
    clk             => clk,
    rst_l           => rst_l,
    iTap1           => vTapRgb1(23 downto 16),
    iTap2           => vTapRgb2(23 downto 16),
    iTap3           => vTapRgb3(23 downto 16),
    oBlurData       => blurRgb.red);
MAC_G_inst: blur_mac
generic map(
    i_data_width    => 8)
port map(
    clk             => clk,
    rst_l           => rst_l,
    iTap1           => vTapRgb1(15 downto 8),
    iTap2           => vTapRgb2(15 downto 8),
    iTap3           => vTapRgb3(15 downto 8),
    oBlurData       => blurRgb.green);
MAC_B_inst: blur_mac
generic map(
    i_data_width    => 8)
port map(
    clk             => clk,
    rst_l           => rst_l,
    iTap1           => vTapRgb1(i_data_width-1 downto 0),
    iTap2           => vTapRgb2(i_data_width-1 downto 0),
    iTap3           => vTapRgb3(i_data_width-1 downto 0),
    oBlurData       => blurRgb.blue);
pipValidP: process (clk) begin
    if rising_edge(clk) then
        valid1_rgb    <= rgb3x.valid;
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
        blurRgb.valid <= valid9_rgb;
    end if;
end process pipValidP;
tapSignedP : process (clk) begin
    if rising_edge(clk) then
        rgb1x         <= iRgb;
        rgb2x         <= rgb1x;
        rgb3x         <= rgb2x;
        d3Rgb         <= rgb3x.red & rgb3x.green & rgb3x.blue;
        d1En          <= enable;
        d2En          <= d1En;
        d3En          <= d2En;
        vTapRgb1      <= dTapRgb1;
        vTapRgb2      <= dTapRgb2;
        vTapRgb3      <= dTapRgb3;
    end if;
end process tapSignedP;
end architecture;