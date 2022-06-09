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

entity rgb_3_taps is
generic (
    img_width     : integer := 4096;
    tpDataWidth   : integer := 8);
port (
    clk         : in std_logic;
    rst_l       : in std_logic;
    iRgb        : in channel;
    tpValid     : out std_logic;
    tap_1       : out std_logic_vector(tpDataWidth - 1 downto 0);
    tap_2       : out std_logic_vector(tpDataWidth - 1 downto 0);
    tap_3       : out std_logic_vector(tpDataWidth - 1 downto 0));
end entity;
architecture arch of rgb_3_taps is
    signal tap1_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap2_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap3_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');

    signal dS_1RGB      : channel;
    signal rgbPixel     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal readCnt      : natural range 0 to 9 := 0;
    signal read_en      : std_logic := lo;
    signal write_s      : std_logic;
    signal writess      : std_logic;
    signal writesss     : std_logic;
    signal writepp      : std_logic;
    signal write_p      : std_logic;
    signal write_v      : std_logic;
    signal tap_d1_valid : std_logic;
    signal tap_d2_valid : std_logic;
    signal tap_d3_valid : std_logic;

    signal iRgb_1_valid : std_logic;
    signal iRgb_2_valid : std_logic;
    signal iRgb_3_valid : std_logic;
    signal iRgb_4_valid : std_logic;
    signal xy           : cord;
    signal x2y          : cord;
    signal iRgb_valid_value : natural;
begin

process (clk) begin
    if (rising_edge(clk)) then
        iRgb_1_valid   <= iRgb.valid;
        iRgb_2_valid   <= iRgb_1_valid;
        iRgb_3_valid   <= iRgb_2_valid;
        iRgb_4_valid   <= iRgb_3_valid;
    end if;
end process;

    tap_d1_valid <= '1' when (readCnt =0 and iRgb_2_valid = hi) or (writess = hi)  else '0';
    tap_d2_valid <= '1' when (readCnt =1 and iRgb_2_valid = hi) or (writess = hi)  else '0';
    tap_d3_valid <= '1' when (readCnt =2 and iRgb_2_valid = hi) or (writess = hi)  else '0';
    read_en      <= '1' when (iRgb_4_valid = hi)  else '0';


process (clk) begin
    if (rising_edge(clk)) then
        write_s   <= iRgb_4_valid;
        dS_1RGB   <= iRgb;
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
write_p          <= '1' when (write_s ='1' and iRgb_4_valid ='0') else '0';
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
        readCnt     <= 0;
    elsif rising_edge(clk) then
        if (write_p = hi)then
            if ((readCnt < 2)) then 
                readCnt  <= readCnt + 1;
            else
                readCnt  <= 0;
            end if;
        end if;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        tap_1      <= tap1_data;
        tap_2      <= tap2_data;
        tap_3      <= tap3_data;
        tpValid  <= dS_1RGB.valid;
    end if;
end process;
process (iRgb) begin
        rgbPixel     <= iRgb.red & iRgb.green & iRgb.blue;
end process;
tapLineD1: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => tap_d1_valid,
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
    write_en    => tap_d2_valid,
    idata       => rgbPixel,
    read_en     => read_en,
    odata       => tap2_data);
tapLineD3: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => tap_d3_valid,
    idata       => rgbPixel,
    read_en     => read_en,
    odata       => tap3_data);


end architecture;



