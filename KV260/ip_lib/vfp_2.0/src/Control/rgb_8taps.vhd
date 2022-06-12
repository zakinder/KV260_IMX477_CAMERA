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

entity rgb_8taps is
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
    tp3         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp4         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp5         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp6         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp7         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp8         : out std_logic_vector(tpDataWidth - 1 downto 0));
end entity;
architecture arch of rgb_8taps is
    signal tap0_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap1_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap2_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap3_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap4_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap5_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap6_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap7_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap8_data    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal dS_1RGB      : channel;


    signal rgbPixel     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    
    
    signal rgbPixel_1     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_2     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_3     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_4     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_5     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel_6     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    
    
    signal readCnt      : natural range 0 to 9 := 0;
    signal read_en      : std_logic := lo;
    signal write_s      : std_logic;
    signal writess      : std_logic;
    signal writesss     : std_logic;
    signal writepp      : std_logic;
    signal write_p      : std_logic;
    signal write_v      : std_logic;
    signal tap_d0_valid : std_logic;
    signal tap_d1_valid : std_logic;
    signal tap_d2_valid : std_logic;
    signal tap_d3_valid : std_logic;
    signal tap_d4_valid : std_logic;
    signal tap_d5_valid : std_logic;
    signal tap_d6_valid : std_logic;
    signal tap_d7_valid : std_logic;
    signal tap_d8_valid : std_logic;
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

    tap_d0_valid <= '1' when (iRgb_4_valid = hi) or (writess = hi)  else '0';
    tap_d1_valid <= '1' when (iRgb_4_valid = hi) or (writess = hi)  else '0';
    tap_d2_valid <= '1' when (iRgb_4_valid = hi) or (writess = hi)  else '0';
    tap_d3_valid <= '1' when (iRgb_4_valid = hi) or (writess = hi)  else '0';
    tap_d4_valid <= '1' when (iRgb_4_valid = hi) or (writess = hi)  else '0';
    tap_d5_valid <= '1' when (iRgb_4_valid = hi) or (writess = hi)  else '0';
    tap_d6_valid <= '1' when (iRgb_4_valid = hi) or (writess = hi)  else '0';
    tap_d7_valid <= '1' when (iRgb_4_valid = hi) or (writess = hi)  else '0';
    tap_d8_valid <= '1' when (iRgb_4_valid = hi) or (writess = hi)  else '0';
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
            if ((readCnt < 9)) then 
                readCnt  <= readCnt + 1;
            else
                readCnt  <= 0;
            end if;
        end if;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        tp0      <= tap0_data;
        tp1      <= tap1_data;
        tp2      <= tap2_data;
        tp3      <= tap3_data;
        tp4      <= tap4_data;
        tp5      <= tap5_data;
        tp6      <= tap6_data;
        tp7      <= tap7_data;
        tp8      <= tap8_data;
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

TPDATAWIDTH3_ENABLED: if (tpDataWidth = 24) generate
begin
process (iRgb) begin
        rgbPixel     <= iRgb.red & iRgb.green & iRgb.blue;
end process;
end generate TPDATAWIDTH3_ENABLED;

process (clk) begin
    if (rising_edge(clk)) then
        rgbPixel_1   <= rgbPixel;
        rgbPixel_2   <= rgbPixel_1;
        rgbPixel_3   <= rgbPixel_2;
        rgbPixel_4   <= rgbPixel_3;
        rgbPixel_5   <= rgbPixel_4;
        rgbPixel_6   <= rgbPixel_5;
        tap0_data    <= rgbPixel_6;
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
    
tapLineD3: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => read_en,
    idata       => tap2_data,
    read_en     => read_en,
    odata       => tap3_data);
tapLineD4: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => read_en,
    idata       => tap3_data,
    read_en     => read_en,
    odata       => tap4_data);
tapLineD5: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => read_en,
    idata       => tap4_data,
    read_en     => read_en,
    odata       => tap5_data);
tapLineD6: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => read_en,
    idata       => tap5_data,
    read_en     => read_en,
    odata       => tap6_data);
tapLineD7: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => read_en,
    idata       => tap6_data,
    read_en     => read_en,
    odata       => tap7_data);
tapLineD8: tap4Line
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    write_en    => read_en,
    idata       => tap7_data,
    read_en     => read_en,
    odata       => tap8_data);
end architecture;



