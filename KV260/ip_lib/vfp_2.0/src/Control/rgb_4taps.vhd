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

entity rgb_4taps is
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
    tp2         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp3         : out std_logic_vector(tpDataWidth - 1 downto 0));
end entity;
architecture arch of rgb_4taps is
    signal tap0_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap1_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap2_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d6RGB        : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d5RGB        : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d4RGB        : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d3RGB        : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d2RGB        : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d1RGB        : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal dS_1RGB        : channel;
    signal dS_2RGB        : channel;
    signal dS_3RGB        : channel;
    signal rgbPixel     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal readCnt      : natural range 0 to 3 := zero;
    signal read_en      : std_logic := lo;
    signal write_s      : std_logic;
    signal writess      : std_logic;
    signal writesss      : std_logic;
    signal writepp      : std_logic;
    signal write_p      : std_logic;
    signal write_v      : std_logic;
    signal tap_d0_valid : std_logic;
    signal tap_d1_valid : std_logic;
    signal tap_d2_valid : std_logic;
    signal tap_d3_valid : std_logic;
    signal xy           : cord;
    signal x2y          : cord;
    signal iRgb_valid_value : natural;
    
begin

    tap_d0_valid <= '1' when (readCnt =0 and iRgb.valid = hi) or (writess = hi)  else '0';
    tap_d1_valid <= '1' when (readCnt =1 and iRgb.valid = hi) or (writess = hi)  else '0';
    tap_d2_valid <= '1' when (readCnt =2 and iRgb.valid = hi) or (writess = hi)  else '0';
    tap_d3_valid <= '1' when (readCnt =3 and iRgb.valid = hi) or (writess = hi)  else '0';

    
    read_en      <= '1' when (readCnt =0 and iRgb.valid = hi)  else '0';

    
process (clk) begin
    if (rising_edge(clk)) then
        write_s   <= iRgb.valid;
        dS_1RGB   <= iRgb;
        dS_2RGB   <= dS_1RGB;
        dS_3RGB   <= dS_2RGB;
    end if;
end process;
process (clk) begin
    if (rising_edge(clk)) then
        writesss <= writess;
        if ((write_v = lo) and (x2y.x <= (img_width + iRgb_valid_value))) then
            if (x2y.y <= 4) then
                x2y.x  <= x2y.x + 1;
            end if;
        else
            x2y.x  <= zero;
        end if;
    end if;
end process; 

process (clk) begin
    if (rising_edge(clk)) then
        if (writepp = hi) then
            if (x2y.y <= 5) then
                x2y.y  <= x2y.y + 1;
            end if;
        end if;
    end if;
end process; 

writepp          <= '1' when (writesss ='1' and writess ='0') else '0';
writess          <= '1' when (x2y.x > iRgb_valid_value) else '0';
write_p          <= '1' when (write_s ='1' and iRgb.valid ='0') else '0';
write_v          <= '1' when (xy.y <= img_width-1) else '0';
iRgb_valid_value <= xy.x when (xy.y = 4 and write_s = lo);


process (clk) begin
    if (rising_edge(clk)) then
        if ((write_s = lo) and (xy.x < (img_width))) then
            if (x2y.y <= 4) then
                xy.x  <= xy.x + 1;
            end if;
        else
            xy.x  <= zero;
        end if;
    end if;
end process; 
process (clk) begin
    if (rising_edge(clk)) then
        if (write_p = hi) then
            if(xy.y < (img_width+4)) then
                xy.y  <= xy.y + 1;
            else
                xy.y  <= zero;
            end if;
        end if;
    end if;
end process; 

process (clk,rst_l) begin
    if (rst_l = lo) then
        readCnt     <= zero;
    elsif rising_edge(clk) then
        if ((readCnt <= 3)) then
            if (write_p = hi)then
                readCnt  <= readCnt + 1;
            end if;
        else
            readCnt  <= 0;
        end if;
    end if;
end process;

process (clk,rst_l) begin
    if (rst_l = lo) then
        tp0      <= (others => '0');
        tp1      <= (others => '0');
        tp2      <= (others => '0');
        tp3      <= (others => '0');
        tpValid  <= lo;
    elsif rising_edge(clk) then
        --if (tap_d0_valid = hi) then
            tp3      <= d6RGB;
        --end if;
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
        rgbPixel <= (others => '0');
        d2RGB    <= (others => '0');
    elsif rising_edge(clk) then
        --if (iRgb.valid = hi) then
            rgbPixel      <= dS_1RGB.green;
        --end if;
        d1RGB <= rgbPixel;
        d2RGB <= d1RGB;
        d3RGB <= d2RGB;
        d4RGB <= d3RGB;
        d5RGB <= d4RGB;
        d6RGB <= d5RGB;
    end if;
end process;
end generate TPDATAWIDTH1_ENABLED;

TPDATAWIDTH3_ENABLED: if (tpDataWidth = 30) generate
begin
process (iRgb) begin
    --if (iRgb.valid = hi) then
        rgbPixel     <= iRgb.red & iRgb.green & iRgb.blue;
    --end if;
end process;
process (clk,rst_l) begin
    if (rst_l = lo) then
        d1RGB    <= (others => '0');
    elsif rising_edge(clk) then
        d1RGB <= rgbPixel;
        d2RGB <= d1RGB;
        d3RGB <= d2RGB;
        d4RGB <= d3RGB;
        d5RGB <= d4RGB;
        d6RGB <= d5RGB;
    end if;
end process;
end generate TPDATAWIDTH3_ENABLED;


tapLineD0: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => tap_d1_valid,
    idata       => rgbPixel,
    read_en     => read_en,
    odata       => tap0_data);
tapLineD1: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => tap_d2_valid,
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
    write_en    => tap_d3_valid,
    idata       => rgbPixel,
    read_en     => read_en,
    odata       => tap2_data);
end architecture;



