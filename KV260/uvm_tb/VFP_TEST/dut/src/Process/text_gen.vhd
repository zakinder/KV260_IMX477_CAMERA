-------------------------------------------------------------------------------
--
-- Filename    : text_gen.vhd
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

entity text_gen is
generic(
    img_width_bmp    : integer := 1920;
    img_height_bmp   : integer := 1080;
    b_data_width     : integer := 32);
port (
    clk              : in std_logic;
    rst_l            : in std_logic;
    iViChannel       : in integer;
    txCord           : in coord;
    location         : in cord;
    iRgb             : in channel;
    oRgb             : out channel);
end text_gen;
architecture Behavioral of text_gen is

    signal grid,s_grid  :  cord;
    signal pixOn : std_logic := '0';

begin

s_grid.x <= to_integer(unsigned(txCord.x(11 downto 0)));
s_grid.y <= (img_height_bmp-1) - (to_integer(unsigned(txCord.y(11 downto 0))));

pipCoordP: process (clk) begin
    if rising_edge(clk) then
        grid          <= s_grid;
    end if;
end process pipCoordP;


textElement2: pixel_on_display
generic map (
    img_width_bmp  => img_width_bmp,
    img_height_bmp => img_height_bmp,
    b_data_width   => b_data_width)
port map(
    clk          => clk,
    rst_l        => rst_l,
    iViChannel   => iViChannel,
    location     => location,
    grid         => grid,
    pixel        => pixOn);

process (clk) begin
    if rising_edge(clk) then
    if (rst_l = lo) then
        oRgb.red   <= black;
        oRgb.green <= black;
        oRgb.blue  <= black;
    else
     oRgb.valid  <= iRgb.valid;
        if (iRgb.valid = hi) then
            if (pixOn = hi) then
                oRgb.red   <= black;
                oRgb.green <= black;
                oRgb.blue  <= black;
            else
                oRgb.red   <= iRgb.red;
                oRgb.green <= iRgb.green;
                oRgb.blue  <= iRgb.blue;
            end if;
        end if;
    end if;
    end if;
end process;
end Behavioral;