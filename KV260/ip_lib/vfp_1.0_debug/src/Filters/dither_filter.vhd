-------------------------------------------------------------------------------
--
-- Filename    : dither_filter.vhd
-- Create Date : 05022019 [05-02-2019]
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

entity dither_filter  is
generic(
    img_width         : integer := 512;
    img_height        : integer := 512;
    color_width       : integer := 8;
    reduced_width     : integer := 4);
port (
    clk               : in  std_logic;
    iCord_x           : in  std_logic_vector(15 downto 0);
    iRgb              : in  channel;
    oRgb              : out  channel);
end entity;
architecture arch of dither_filter is
    signal cord_x            : integer range 0 to img_width-1;
    constant dither_bits     : integer := color_width - reduced_width;
    -------------------------------------------------
    -- intermediate signals for caclulation
    -------------------------------------------------
    type t_dither_rgb is array(1 to 3) of unsigned(dither_bits-1 downto 0);
    signal dither_buffer_next      : t_dither_rgb := (others => (others =>'0'));
    signal dither_buffer_new_line  : t_dither_rgb := (others => (others =>'0'));
    signal dither_buffer_to_ram    : t_dither_rgb := (others => (others =>'0'));
    signal dither_buffer_from_ram  : t_dither_rgb := (others => (others =>'0'));
    -------------------------------------------------
    -- infered ram for holding old pixel information
    -------------------------------------------------
    type t_dither_buffer is array(0 to img_width-1) of unsigned((dither_bits * 3)-1 downto 0);
    signal dither_buffer          : t_dither_buffer := (others => (others => '0'));
    signal index                  : integer range 0 to img_width-1 := 0;
    signal addra                  : integer range 0 to img_width-1 := 0;
    signal addrb                  : integer range 0 to img_width-1 := 0;
    signal wea                    : std_logic := lo;
begin
    cord_x     <= to_integer(unsigned(iCord_x));
    oRgb.valid <= wea;
image_process:process (clk)
    type t_intermediate is array(1 to 3) of unsigned(color_width downto 0);
    variable intermediate_color : t_intermediate;
    begin
    if rising_edge(clk) then
    -------------------------------------------------
    -- calculate dithered colors
    -------------------------------------------------
    if (iRgb.valid = hi) then
        intermediate_color(1) := ("0" & unsigned(iRgb.red)) + dither_buffer_next(1) + unsigned(dither_buffer_from_ram(1));
        intermediate_color(2) := ("0" & unsigned(iRgb.green)) + dither_buffer_next(2) + unsigned(dither_buffer_from_ram(2));
        intermediate_color(3) := ("0" & unsigned(iRgb.blue)) + dither_buffer_next(3) + unsigned(dither_buffer_from_ram(3));
    -------------------------------------------------
    --
    -------------------------------------------------
    for c in 1 to 3 loop
        if (intermediate_color(c)(8) = hi) then
            intermediate_color(c) := lo & to_unsigned((2**color_width) - 1, color_width);
        end if;
        dither_buffer_next(c)      <= "0" & intermediate_color(c)(dither_bits-1 downto 1);
        dither_buffer_new_line(c)  <= "00" & intermediate_color(c)(dither_bits-1 downto 2);
        dither_buffer_to_ram(c)    <= ("00" & intermediate_color(c)(dither_bits-1 downto 2)) + dither_buffer_new_line(c);
    end loop;
    -------------------------------------------------
    else
    intermediate_color(1) := "0" & unsigned(iRgb.red);
    intermediate_color(2) := "0" & unsigned(iRgb.green);
    intermediate_color(3) := "0" & unsigned(iRgb.blue);
    end if;
    -------------------------------------------------
    -- calculate address for line buffer + enable
    -------------------------------------------------
    if (cord_x<img_width-2) then
        addrb <= cord_x+2;
    elsif (cord_x=img_width-2) then
        addrb <= 0;
    else
        addrb <= 1;
    end if;
    -------------------------------------------------
    index <= cord_x;
    addra <= index;
    -------------------------------------------------
    if (iRgb.valid = hi) then
        wea <= hi;
    else
        wea <= lo;
    end if;
    -------------------------------------------------
    -- line buffer memory
    if (wea = hi) then
        dither_buffer(addra) <= dither_buffer_to_ram(1) & dither_buffer_to_ram(2) & dither_buffer_to_ram(3);
    end if;
    -------------------------------------------------
    dither_buffer_from_ram(1) <= dither_buffer(addrb)((dither_bits * 3)-1 downto (dither_bits * 2));
    dither_buffer_from_ram(2) <= dither_buffer(addrb)((dither_bits * 2)-1 downto dither_bits);
    dither_buffer_from_ram(3) <= dither_buffer(addrb)(dither_bits-1 downto 0);
    -------------------------------------------------
    -- map outputs
    -------------------------------------------------
    oRgb.red    <= std_logic_vector(intermediate_color(1)(color_width-1 downto 0));
    oRgb.green  <= std_logic_vector(intermediate_color(2)(color_width-1 downto 0));
    oRgb.blue   <= std_logic_vector(intermediate_color(3)(color_width-1 downto 0));
    -------------------------------------------------
    end if;
end process image_process;
end architecture;