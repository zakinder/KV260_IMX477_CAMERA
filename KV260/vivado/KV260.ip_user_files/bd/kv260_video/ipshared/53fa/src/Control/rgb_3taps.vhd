-------------------------------------------------------------------------------
--
-- Filename    : taps_controller.vhd
-- Create Date : 01062019 [01-06-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation axi4 components.
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity rgb_3taps is
generic (
    img_width     : integer := 4096;
    tpDataWidth   : integer := 8);
port (
    clk         : in std_logic;
    rst_l       : in std_logic;
    iRgb        : in channel;
    tpValid     : out std_logic;
    tp0         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp1         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp2         : out std_logic_vector(tpDataWidth - 1 downto 0));
end entity;
architecture arch of rgb_3taps is
    signal tap0_data      : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap1_data      : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap2_data      : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');


    signal dS_1RGB        : channel;
    signal rgbPixel       : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_1     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_2     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_3     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_4     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_5     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_6     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal read_en        : std_logic := lo;
    signal iRgb_1_valid   : std_logic;
    signal iRgb_2_valid   : std_logic;
    signal iRgb_3_valid   : std_logic;
    signal iRgb_4_valid   : std_logic;
begin
process (clk) begin
    if (rising_edge(clk)) then
        iRgb_1_valid   <= iRgb.valid;
        iRgb_2_valid   <= iRgb_1_valid;
        iRgb_3_valid   <= iRgb_2_valid;
        iRgb_4_valid   <= iRgb_3_valid;
    end if;
end process;
    read_en      <= '1' when (iRgb_4_valid = hi)  else '0';
process (clk) begin
    if (rising_edge(clk)) then
        dS_1RGB   <= iRgb;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        tp0      <= tap0_data;
        tp1      <= tap1_data;
        tp2      <= tap2_data;
        tpValid  <= dS_1RGB.valid;
    end if;
end process;
TPDATAWIDTH1_ENABLED: if (tpDataWidth = 8) generate
begin
process (clk,rst_l) begin
    if (rst_l = lo) then
        rgbPixel      <= (others => '0');
    elsif rising_edge(clk) then
        rgbPixel      <= dS_1RGB.green;
    end if;
end process;
end generate TPDATAWIDTH1_ENABLED;
TPDATAWIDTH3_ENABLED: if (tpDataWidth = 30) generate
begin
process (iRgb) begin
        rgbPixel     <= iRgb.red & iRgb.green & iRgb.blue;
end process;
end generate TPDATAWIDTH3_ENABLED;
process (clk) begin
    if (rising_edge(clk)) then
        rgbPixel_1   <= rgbPixel;
        tap0_data    <= rgbPixel_1;
        --rgbPixel_3   <= rgbPixel_2;
        --rgbPixel_4   <= rgbPixel_3;
        --rgbPixel_5   <= rgbPixel_4;
        --rgbPixel_6   <= rgbPixel_5;
        --tap0_data    <= rgbPixel_6;
    end if;
end process;
tapLineD1: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => read_en,
    idata       => rgbPixel,
    read_en     => read_en,
    odata       => tap1_data);
tapLineD2: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => read_en,
    idata       => tap1_data,
    read_en     => read_en,
    odata       => tap2_data);
end architecture;