-------------------------------------------------------------------------------
--
-- Filename    : rgb_histogram.vhd
-- Create Date : 05062019 [05-06-2019]
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
entity rgb_histogram is
generic (
    img_width      : integer := 1920;
    img_height     : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    txCord         : in coord;
    iRgb           : in channel;
    oRgb           : out channel);
end rgb_histogram;
architecture behavioral of rgb_histogram is
    type ram_type is array (0 to 255) of natural;
    signal red_histogram_buffer        : ram_type;
    signal gre_histogram_buffer        : ram_type;
    signal blu_histogram_buffer        : ram_type;
    signal red_io_data          : natural   := zero;
    signal gre_io_data          : natural   := zero;
    signal blu_io_data          : natural   := zero;
    signal red_io_addr          : std_logic_vector(7 downto 0)   := (others => '0');
    signal gre_io_addr          : std_logic_vector(7 downto 0)   := (others => '0');
    signal blu_io_addr          : std_logic_vector(7 downto 0)   := (others => '0');
    signal red_rowdist          : natural   := zero;
    signal red_rowdistNext      : natural   := zero;
    signal red_lines            : pix_line_array(0 to 10);
    signal gre_rowdist          : natural   := zero;
    signal gre_rowdistNext      : natural   := zero;
    signal gre_lines            : pix_line_array(0 to 10);
    signal blu_rowdist          : natural   := zero;
    signal blu_rowdistNext      : natural   := zero;
    signal blu_lines            : pix_line_array(0 to 10);
    signal cordinates           : cord;
    signal cord_xy              : cord;
    signal frame_done           : std_logic := lo;
    signal frame_valid          : std_logic := lo;
    signal valid_on             : std_logic := lo;
    signal cord_xy_x            : natural   := zero;
    signal pWrAdr               : natural   := zero;
begin
cordinates.x  <= (to_integer(unsigned(txCord.x)));
cordinates.y  <= (to_integer(unsigned(txCord.y)));
-- Assign memory location as rgb red channel input integer between 0 to 255 which equally 8 bits to express 256 levels address. Every input value would accumlated to its location to show how many hits per level.
process (clk) begin
if rising_edge(clk) then
    if (iRgb.valid = hi) then
        red_io_data   <= red_histogram_buffer(to_integer(unsigned(iRgb.red)));
        red_io_addr   <= iRgb.red;
        red_histogram_buffer(to_integer(unsigned(red_io_addr))) <= red_io_data + 1;
    end if;
end if;
end process;
process (clk) begin
if rising_edge(clk) then
    if (iRgb.valid = hi) then
        gre_io_data   <= gre_histogram_buffer(to_integer(unsigned(iRgb.green)));
        gre_io_addr   <= iRgb.green;
        gre_histogram_buffer(to_integer(unsigned(gre_io_addr))) <= gre_io_data + 1;
    end if;
end if;
end process;
process (clk) begin
if rising_edge(clk) then
    if (iRgb.valid = hi) then
        blu_io_data   <= blu_histogram_buffer(to_integer(unsigned(iRgb.blue)));
        blu_io_addr   <= iRgb.blue;
        blu_histogram_buffer(to_integer(unsigned(blu_io_addr))) <= blu_io_data + 1;
    end if;
end if;
end process;
frame_done <= hi when (cordinates.x = img_width-1 and cordinates.y = img_height-1 and pWrAdr /= 255);
-----------------------------------------------------------------------------------------
process(clk) begin
    if rising_edge(clk) then
        if (frame_done = hi and iRgb.valid = lo) then
            if (pWrAdr < 256) then
                frame_valid <= hi;
                pWrAdr      <= pWrAdr + one;
            else
                frame_valid <= lo;
                pWrAdr      <= pWrAdr;
            end if;
        end if;
    end if;
end process;
-----------------------------------------------------------------------------------------
process(clk) begin
    if rising_edge(clk) then
        if ((pWrAdr < 256) and (frame_done = hi)) then
            red_rowdist     <= red_histogram_buffer(pWrAdr);
        end if;
    end if;
end process;
Process (clk) begin
    if rising_edge(clk) then
        if (frame_done = hi) then
            if (pWrAdr <= 25) then
                if (pWrAdr = 0) then
                    red_rowdistNext  <= red_rowdist;
                elsif (pWrAdr = 25) then
                    red_lines(1).red <= red_rowdistNext /102;
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                else
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                end if;
            elsif(pWrAdr <= 50) then
                if (pWrAdr = 26) then
                    red_rowdistNext  <= red_rowdist;
                elsif (pWrAdr = 50) then
                    red_lines(2).red <= red_rowdistNext /100;
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                else
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                end if;
            elsif(pWrAdr <= 75) then
                if (pWrAdr = 51) then
                    red_rowdistNext  <= red_rowdist;
                elsif (pWrAdr = 75) then
                    red_lines(3).red <= red_rowdistNext /100;
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                else
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                end if;
            elsif(pWrAdr <= 100) then
                if (pWrAdr = 76) then
                    red_rowdistNext  <= red_rowdist;
                elsif (pWrAdr = 100) then
                    red_lines(4).red <= red_rowdistNext /100;
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                else
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                end if;
            elsif(pWrAdr <= 125) then
                if (pWrAdr = 101) then
                    red_rowdistNext  <= red_rowdist;
                elsif (pWrAdr = 125) then
                    red_lines(5).red <= red_rowdistNext /100;
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                else
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                end if;
            elsif(pWrAdr <= 150) then
                if (pWrAdr = 126) then
                    red_rowdistNext  <= red_rowdist;
                elsif (pWrAdr = 150) then
                    red_lines(6).red <= red_rowdistNext /100;
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                else
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                end if;
            elsif(pWrAdr <= 175) then
                if (pWrAdr = 151) then
                    red_rowdistNext  <= red_rowdist;
                elsif (pWrAdr = 175) then
                    red_lines(7).red <= red_rowdistNext /100;
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                else
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                end if;
            elsif(pWrAdr <= 200) then
                if (pWrAdr = 176) then
                    red_rowdistNext  <= red_rowdist;
                elsif (pWrAdr = 200) then
                    red_lines(8).red <= red_rowdistNext /100;
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                else
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                end if;
            elsif(pWrAdr <= 225) then
                if (pWrAdr = 201) then
                    red_rowdistNext  <= red_rowdist;
                elsif (pWrAdr = 225) then
                    red_lines(9).red <= red_rowdistNext /100;
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                else
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                end if;
            elsif(pWrAdr <= 255) then
                if (pWrAdr = 226) then
                    red_rowdistNext  <= red_rowdist;
                elsif (pWrAdr = 255) then
                    red_lines(10).red <= red_rowdistNext /100;
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                else
                    red_rowdistNext  <= (red_rowdist + red_rowdistNext);
                end if;
            end if;
        end if;
    end if;
end process;
process(clk) begin
    if rising_edge(clk) then
        if ((pWrAdr < 256) and (frame_done = hi)) then
            gre_rowdist     <= gre_histogram_buffer(pWrAdr);
        end if;
    end if;
end process;
Process (clk) begin
    if rising_edge(clk) then
        if (frame_done = hi) then
            if (pWrAdr <= 25) then
                if (pWrAdr = 0) then
                    gre_rowdistNext  <= gre_rowdist;
                elsif (pWrAdr = 25) then
                    gre_lines(1).green <= gre_rowdistNext /102;
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                else
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                end if;
            elsif(pWrAdr <= 50) then
                if (pWrAdr = 26) then
                    gre_rowdistNext  <= gre_rowdist;
                elsif (pWrAdr = 50) then
                    gre_lines(2).green <= gre_rowdistNext /100;
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                else
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                end if;
            elsif(pWrAdr <= 75) then
                if (pWrAdr = 51) then
                    gre_rowdistNext  <= gre_rowdist;
                elsif (pWrAdr = 75) then
                    gre_lines(3).green <= gre_rowdistNext /100;
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                else
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                end if;
            elsif(pWrAdr <= 100) then
                if (pWrAdr = 76) then
                    gre_rowdistNext  <= gre_rowdist;
                elsif (pWrAdr = 100) then
                    gre_lines(4).green <= gre_rowdistNext /100;
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                else
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                end if;
            elsif(pWrAdr <= 125) then
                if (pWrAdr = 101) then
                    gre_rowdistNext  <= gre_rowdist;
                elsif (pWrAdr = 125) then
                    gre_lines(5).green <= gre_rowdistNext /100;
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                else
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                end if;
            elsif(pWrAdr <= 150) then
                if (pWrAdr = 126) then
                    gre_rowdistNext  <= gre_rowdist;
                elsif (pWrAdr = 150) then
                    gre_lines(6).green <= gre_rowdistNext /100;
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                else
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                end if;
            elsif(pWrAdr <= 175) then
                if (pWrAdr = 151) then
                    gre_rowdistNext  <= gre_rowdist;
                elsif (pWrAdr = 175) then
                    gre_lines(7).green <= gre_rowdistNext /100;
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                else
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                end if;
            elsif(pWrAdr <= 200) then
                if (pWrAdr = 176) then
                    gre_rowdistNext  <= gre_rowdist;
                elsif (pWrAdr = 200) then
                    gre_lines(8).green <= gre_rowdistNext /100;
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                else
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                end if;
            elsif(pWrAdr <= 225) then
                if (pWrAdr = 201) then
                    gre_rowdistNext  <= gre_rowdist;
                elsif (pWrAdr = 225) then
                    gre_lines(9).green <= gre_rowdistNext /100;
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                else
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                end if;
            elsif(pWrAdr <= 255) then
                if (pWrAdr = 226) then
                    gre_rowdistNext  <= gre_rowdist;
                elsif (pWrAdr = 255) then
                    gre_lines(10).green <= gre_rowdistNext /100;
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                else
                    gre_rowdistNext  <= (gre_rowdist + gre_rowdistNext);
                end if;
            end if;
        end if;
    end if;
end process;
process(clk) begin
    if rising_edge(clk) then
        if ((pWrAdr < 256) and (frame_done = hi)) then
            blu_rowdist     <= blu_histogram_buffer(pWrAdr);
        end if;
    end if;
end process;
Process (clk) begin
    if rising_edge(clk) then
        if (frame_done = hi) then
            if (pWrAdr <= 25) then
                if (pWrAdr = 0) then
                    blu_rowdistNext  <= blu_rowdist;
                elsif (pWrAdr = 25) then
                    blu_lines(1).blue <= blu_rowdistNext /102;
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                else
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                end if;
            elsif(pWrAdr <= 50) then
                if (pWrAdr = 26) then
                    blu_rowdistNext  <= blu_rowdist;
                elsif (pWrAdr = 50) then
                    blu_lines(2).blue <= blu_rowdistNext /100;
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                else
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                end if;
            elsif(pWrAdr <= 75) then
                if (pWrAdr = 51) then
                    blu_rowdistNext  <= blu_rowdist;
                elsif (pWrAdr = 75) then
                    blu_lines(3).blue <= blu_rowdistNext /100;
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                else
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                end if;
            elsif(pWrAdr <= 100) then
                if (pWrAdr = 76) then
                    blu_rowdistNext  <= blu_rowdist;
                elsif (pWrAdr = 100) then
                    blu_lines(4).blue <= blu_rowdistNext /100;
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                else
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                end if;
            elsif(pWrAdr <= 125) then
                if (pWrAdr = 101) then
                    blu_rowdistNext  <= blu_rowdist;
                elsif (pWrAdr = 125) then
                    blu_lines(5).blue <= blu_rowdistNext /100;
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                else
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                end if;
            elsif(pWrAdr <= 150) then
                if (pWrAdr = 126) then
                    blu_rowdistNext  <= blu_rowdist;
                elsif (pWrAdr = 150) then
                    blu_lines(6).blue <= blu_rowdistNext /100;
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                else
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                end if;
            elsif(pWrAdr <= 175) then
                if (pWrAdr = 151) then
                    blu_rowdistNext  <= blu_rowdist;
                elsif (pWrAdr = 175) then
                    blu_lines(7).blue <= blu_rowdistNext /100;
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                else
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                end if;
            elsif(pWrAdr <= 200) then
                if (pWrAdr = 176) then
                    blu_rowdistNext  <= blu_rowdist;
                elsif (pWrAdr = 200) then
                    blu_lines(8).blue <= blu_rowdistNext /100;
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                else
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                end if;
            elsif(pWrAdr <= 225) then
                if (pWrAdr = 201) then
                    blu_rowdistNext  <= blu_rowdist;
                elsif (pWrAdr = 225) then
                    blu_lines(9).blue <= blu_rowdistNext /100;
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                else
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                end if;
            elsif(pWrAdr <= 255) then
                if (pWrAdr = 226) then
                    blu_rowdistNext  <= blu_rowdist;
                elsif (pWrAdr = 255) then
                    blu_lines(10).blue <= blu_rowdistNext /100;
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                else
                    blu_rowdistNext  <= (blu_rowdist + blu_rowdistNext);
                end if;
            end if;
        end if;
    end if;
end process;
process(clk) begin
    if rising_edge(clk) then
        if (pWrAdr = 256) then
            if ((cord_xy_x < (256 + 10)) and (cord_xy.y < 256+1)) then
                    cord_xy_x   <= cord_xy_x + one;
                if (cord_xy_x < 256) then
                    cord_xy.x   <= cord_xy_x;
                end if;
                if (cord_xy_x < 256) then
                    valid_on    <= hi;
                else
                    valid_on    <= lo;
                end if;
            else
                valid_on    <= lo;
                cord_xy_x   <= zero;
            end if;
            if (cord_xy_x = zero) then
                cord_xy.y   <= cord_xy.y + one;
            else
                if (cord_xy.y = 256 - 1) then
                    cord_xy.y   <= 256 - 1;
                end if;
            end if;
        end if;
    end if;
end process;
process(clk) begin
    if rising_edge(clk) then
        if(cord_xy.y <= 25) then
            if (cord_xy.x <= red_lines(10).red) then
                oRgb.red    <= std_logic_vector(to_unsigned(red_lines(10).red,8));
            else
                oRgb.red    <= std_logic_vector(to_unsigned(255,8));
            end if;
            oRgb.valid  <= valid_on;
        elsif(cord_xy.y <= 50) then
            if (cord_xy.x <= red_lines(9).red) then
                oRgb.red    <= std_logic_vector(to_unsigned(red_lines(9).red,8));
            else
                oRgb.red    <= std_logic_vector(to_unsigned(255,8));
            end if;
            oRgb.valid  <= valid_on;
        elsif(cord_xy.y <= 75) then
            if (cord_xy.x <= red_lines(8).red) then
                oRgb.red    <= std_logic_vector(to_unsigned(red_lines(8).red,8));
            else
                oRgb.red    <= std_logic_vector(to_unsigned(255,8));
            end if;
            oRgb.valid  <= valid_on;
        elsif(cord_xy.y <= 100) then
            if (cord_xy.x <= red_lines(7).red) then
                oRgb.red    <= std_logic_vector(to_unsigned(red_lines(7).red,8));
            else
                oRgb.red    <= std_logic_vector(to_unsigned(255,8));
            end if;
            oRgb.valid  <= valid_on;
        elsif(cord_xy.y <= 125) then
            if (cord_xy.x <= red_lines(6).red) then
                oRgb.red    <= std_logic_vector(to_unsigned(red_lines(6).red,8));
            else
                oRgb.red    <= std_logic_vector(to_unsigned(255,8));
            end if;
            oRgb.valid  <= valid_on;
        elsif(cord_xy.y <= 150) then
            if (cord_xy.x <= red_lines(5).red) then
                oRgb.red    <= std_logic_vector(to_unsigned(red_lines(5).red,8));
            else
                oRgb.red    <= std_logic_vector(to_unsigned(255,8));
            end if;
            oRgb.valid  <= valid_on;
        elsif(cord_xy.y <= 175) then
            if (cord_xy.x <= red_lines(4).red) then
                oRgb.red    <= std_logic_vector(to_unsigned(red_lines(4).red,8));
            else
                oRgb.red    <= std_logic_vector(to_unsigned(255,8));
            end if;
            oRgb.valid  <= valid_on;
        elsif(cord_xy.y <= 200) then
            if (cord_xy.x <= red_lines(3).red) then
                oRgb.red    <= std_logic_vector(to_unsigned(red_lines(3).red,8));
            else
                oRgb.red    <= std_logic_vector(to_unsigned(255,8));
            end if;
            oRgb.valid  <= valid_on;
        elsif(cord_xy.y <= 225) then
            if (cord_xy.x <= red_lines(2).red) then
                oRgb.red    <= std_logic_vector(to_unsigned(red_lines(2).red,8));
            else
                oRgb.red    <= std_logic_vector(to_unsigned(255,8));
            end if;
            oRgb.valid  <= valid_on;
        elsif(cord_xy.y <= 255) then
            if (cord_xy.x <= red_lines(1).red) then
                oRgb.red    <= std_logic_vector(to_unsigned(red_lines(1).red,8));
            else
                oRgb.red    <= std_logic_vector(to_unsigned(255,8));
            end if;
            oRgb.valid  <= valid_on;
        end if;
    end if;
end process;
process(clk) begin
    if rising_edge(clk) then
        if(cord_xy.y <= 25) then
            if (cord_xy.x <= gre_lines(10).green) then
                oRgb.green    <= std_logic_vector(to_unsigned(gre_lines(10).green,8));
            else
                oRgb.green    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 50) then
            if (cord_xy.x <= gre_lines(9).green) then
                oRgb.green    <= std_logic_vector(to_unsigned(gre_lines(9).green,8));
            else
                oRgb.green    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 75) then
            if (cord_xy.x <= gre_lines(8).green) then
                oRgb.green    <= std_logic_vector(to_unsigned(gre_lines(8).green,8));
            else
                oRgb.green    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 100) then
            if (cord_xy.x <= gre_lines(7).green) then
                oRgb.green    <= std_logic_vector(to_unsigned(gre_lines(7).green,8));
            else
                oRgb.green    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 125) then
            if (cord_xy.x <= gre_lines(6).green) then
                oRgb.green    <= std_logic_vector(to_unsigned(gre_lines(6).green,8));
            else
                oRgb.green    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 150) then
            if (cord_xy.x <= gre_lines(5).green) then
                oRgb.green    <= std_logic_vector(to_unsigned(gre_lines(5).green,8));
            else
                oRgb.green    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 175) then
            if (cord_xy.x <= gre_lines(4).green) then
                oRgb.green    <= std_logic_vector(to_unsigned(gre_lines(4).green,8));
            else
                oRgb.green    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 200) then
            if (cord_xy.x <= gre_lines(3).green) then
                oRgb.green    <= std_logic_vector(to_unsigned(gre_lines(3).green,8));
            else
                oRgb.green    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 225) then
            if (cord_xy.x <= gre_lines(2).green) then
                oRgb.green    <= std_logic_vector(to_unsigned(gre_lines(2).green,8));
            else
                oRgb.green    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 255) then
            if (cord_xy.x <= gre_lines(1).green) then
                oRgb.green    <= std_logic_vector(to_unsigned(gre_lines(1).green,8));
            else
                oRgb.green    <= std_logic_vector(to_unsigned(255,8));
            end if;
        end if;
    end if;
end process;
process(clk) begin
    if rising_edge(clk) then
        if(cord_xy.y <= 25) then
            if (cord_xy.x <= blu_lines(10).blue) then
                oRgb.blue    <= std_logic_vector(to_unsigned(blu_lines(10).blue,8));
            else
                oRgb.blue    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 50) then
            if (cord_xy.x <= blu_lines(9).blue) then
                oRgb.blue    <= std_logic_vector(to_unsigned(blu_lines(9).blue,8));
            else
                oRgb.blue    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 75) then
            if (cord_xy.x <= blu_lines(8).blue) then
                oRgb.blue    <= std_logic_vector(to_unsigned(blu_lines(8).blue,8));
            else
                oRgb.blue    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 100) then
            if (cord_xy.x <= blu_lines(7).blue) then
                oRgb.blue    <= std_logic_vector(to_unsigned(blu_lines(7).blue,8));
            else
                oRgb.blue    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 125) then
            if (cord_xy.x <= blu_lines(6).blue) then
                oRgb.blue    <= std_logic_vector(to_unsigned(blu_lines(6).blue,8));
            else
                oRgb.blue    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 150) then
            if (cord_xy.x <= blu_lines(5).blue) then
                oRgb.blue    <= std_logic_vector(to_unsigned(blu_lines(5).blue,8));
            else
                oRgb.blue    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 175) then
            if (cord_xy.x <= blu_lines(4).blue) then
                oRgb.blue    <= std_logic_vector(to_unsigned(blu_lines(4).blue,8));
            else
                oRgb.blue    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 200) then
            if (cord_xy.x <= blu_lines(3).blue) then
                oRgb.blue    <= std_logic_vector(to_unsigned(blu_lines(3).blue,8));
            else
                oRgb.blue    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 225) then
            if (cord_xy.x <= blu_lines(2).blue) then
                oRgb.blue    <= std_logic_vector(to_unsigned(blu_lines(2).blue,8));
            else
                oRgb.blue    <= std_logic_vector(to_unsigned(255,8));
            end if;
        elsif(cord_xy.y <= 255) then
            if (cord_xy.x <= blu_lines(1).blue) then
                oRgb.blue    <= std_logic_vector(to_unsigned(blu_lines(1).blue,8));
            else
                oRgb.blue    <= std_logic_vector(to_unsigned(255,8));
            end if;
        end if;
    end if;
end process;
end behavioral;