-------------------------------------------------------------------------------
--
-- Filename    : rgb_range.vhd
-- Create Date : 02092019 [02-17-2019]
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
entity rgb_range is
generic (
    i_data_width      : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end rgb_range;
architecture Behavioral of rgb_range is
    signal i1Rgb       : intChannel;
    signal i2Rgb       : intChannel;
    signal i3Rgb       : intChannel;
    signal rgbSyncEol  : std_logic;
    signal rgbSyncSof  : std_logic;
    signal rgbSyncEof  : std_logic;
    constant gain      : natural := 0;
    
begin

process (clk)begin
    if rising_edge(clk) then
        rgbSyncEol   <= iRgb.eol;
        rgbSyncSof   <= iRgb.sof;
        rgbSyncEof   <= iRgb.eof;
    end if;
end process;


process (clk,reset)begin
    if (reset = lo) then
        i1Rgb.red    <= zero;
        i1Rgb.green  <= zero;
        i1Rgb.blue   <= zero;
    elsif rising_edge(clk) then
        i1Rgb.red    <= to_integer(unsigned(iRgb.red));
        i1Rgb.green  <= to_integer(unsigned(iRgb.green));
        i1Rgb.blue   <= to_integer(unsigned(iRgb.blue));
        i1Rgb.valid  <= iRgb.valid;
        i2Rgb.valid  <= i1Rgb.valid;
        i3Rgb        <= i2Rgb;
    end if;
end process;
---------------------------------------------------------------------------------
-- i2Rgb.valid must be 2nd condition else valid value
---------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        if (i1Rgb.red   >= 0 and i1Rgb.red   <= 9) then
            i2Rgb.red           <= 7;
        elsif (i1Rgb.red   >= 10 and i1Rgb.red     <= (19)) then
            i2Rgb.red           <= 17;
        elsif (i1Rgb.red   >= 20 and i1Rgb.red     <= (29+gain)) then
            i2Rgb.red           <= 27;
        elsif (i1Rgb.red   >= 30 and i1Rgb.red     <= (39+gain)) then
            i2Rgb.red           <= 37;
        elsif (i1Rgb.red   >= 40 and i1Rgb.red     <= (49+gain)) then
            i2Rgb.red           <= 47;
        elsif (i1Rgb.red   >= 50 and i1Rgb.red     <= (59+gain)) then
            i2Rgb.red           <= 57;
        elsif (i1Rgb.red   >= 60 and i1Rgb.red     <= (69+gain)) then
            i2Rgb.red           <= 67;
        elsif (i1Rgb.red   >= 70 and i1Rgb.red     <= (79+gain)) then
            i2Rgb.red           <= 77;
        elsif (i1Rgb.red   >= 80 and i1Rgb.red     <= (89+gain)) then
            i2Rgb.red           <= 87;
        elsif (i1Rgb.red   >= 90 and i1Rgb.red     <= (99+gain)) then
            i2Rgb.red           <= 97;
        elsif (i1Rgb.red   >= 100 and i1Rgb.red    <= (109+gain)) then
            i2Rgb.red           <= 107;
        elsif (i1Rgb.red   >= 110 and i1Rgb.red    <= (119+gain)) then
            i2Rgb.red           <= 117;
        elsif (i1Rgb.red   >= 120 and i1Rgb.red    <= (129+gain)) then
            i2Rgb.red           <= 127;
        elsif (i1Rgb.red   >= 130 and i1Rgb.red    <= (139+gain)) then
            i2Rgb.red           <= 137;
        elsif (i1Rgb.red   >= 140 and i1Rgb.red    <= (149+gain)) then
            i2Rgb.red           <= 147;
        elsif (i1Rgb.red   >= 150 and i1Rgb.red    <= (159+gain)) then
            i2Rgb.red           <= 157;
        elsif (i1Rgb.red   >= 160 and i1Rgb.red   <= (169+gain)) then
            i2Rgb.red           <= 167;
        elsif (i1Rgb.red   >= 170 and i1Rgb.red   <= (179+gain)) then
            i2Rgb.red           <= 177;
        elsif (i1Rgb.red   >= 180 and i1Rgb.red   <= (189+gain)) then
            i2Rgb.red           <= 187;
        elsif (i1Rgb.red   >= 190 and i1Rgb.red   <= (199+gain)) then
            i2Rgb.red           <= 197;
        elsif (i1Rgb.red   >= 200 and i1Rgb.red   <= (209+gain)) then
            i2Rgb.red           <= 207;
        elsif (i1Rgb.red   >= 210 and i1Rgb.red   <= (219+gain)) then
            i2Rgb.red           <= 217;
        elsif (i1Rgb.red   >= 220 and i1Rgb.red   <= (229+gain)) then
            i2Rgb.red           <= 227;
        elsif (i1Rgb.red   >= 230 and i1Rgb.red   <= (239+gain)) then
            i2Rgb.red           <= 237;
        elsif (i1Rgb.red   >= 240 and i1Rgb.red   <= (249+gain)) then
            i2Rgb.red           <= 247;
        elsif (i1Rgb.red   >= 250 and i1Rgb.red   <= 255) then
            i2Rgb.red           <= 253;
        else
            i2Rgb.red           <= i1Rgb.red;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if (i1Rgb.green   >= 0 and i1Rgb.green   <= 9) then
            i2Rgb.green           <= 7;
        elsif (i1Rgb.green   >= 10 and i1Rgb.green     <= (19+gain)) then
            i2Rgb.green           <= 17;
        elsif (i1Rgb.green   >= 20 and i1Rgb.green     <= (29+gain)) then
            i2Rgb.green           <= 27;
        elsif (i1Rgb.green   >= 30 and i1Rgb.green     <= (39+gain)) then
            i2Rgb.green           <= 37;
        elsif (i1Rgb.green   >= 40 and i1Rgb.green     <= (49+gain)) then
            i2Rgb.green           <= 47;
        elsif (i1Rgb.green   >= 50 and i1Rgb.green     <= (59+gain)) then
            i2Rgb.green           <= 57;
        elsif (i1Rgb.green   >= 60 and i1Rgb.green     <= (69+gain)) then
            i2Rgb.green           <= 67;
        elsif (i1Rgb.green   >= 70 and i1Rgb.green     <= (79+gain)) then
            i2Rgb.green           <= 77;
        elsif (i1Rgb.green   >= 80 and i1Rgb.green     <= (89+gain)) then
            i2Rgb.green           <= 87;
        elsif (i1Rgb.green   >= 90 and i1Rgb.green     <= (99+gain)) then
            i2Rgb.green           <= 97;
        elsif (i1Rgb.green   >= 100 and i1Rgb.green    <= (109+gain)) then
            i2Rgb.green           <= 107;
        elsif (i1Rgb.green   >= 110 and i1Rgb.green    <= (119+gain)) then
            i2Rgb.green           <= 117;
        elsif (i1Rgb.green   >= 120 and i1Rgb.green    <= (129+gain)) then
            i2Rgb.green           <= 127;
        elsif (i1Rgb.green   >= 130 and i1Rgb.green    <= (139+gain)) then
            i2Rgb.green           <= 137;
        elsif (i1Rgb.green   >= 140 and i1Rgb.green    <= (149+gain)) then
            i2Rgb.green           <= 147;
        elsif (i1Rgb.green   >= 150 and i1Rgb.green    <= (159+gain)) then
            i2Rgb.green           <= 157;
        elsif (i1Rgb.green   >= 160 and i1Rgb.green   <= (169+gain)) then
            i2Rgb.green           <= 167;
        elsif (i1Rgb.green   >= 170 and i1Rgb.green   <= (179+gain)) then
            i2Rgb.green           <= 177;
        elsif (i1Rgb.green   >= 180 and i1Rgb.green   <= (189+gain)) then
            i2Rgb.green           <= 187;
        elsif (i1Rgb.green   >= 190 and i1Rgb.green   <= (199+gain)) then
            i2Rgb.green           <= 197;
        elsif (i1Rgb.green   >= 200 and i1Rgb.green   <= (209+gain)) then
            i2Rgb.green           <= 207;
        elsif (i1Rgb.green   >= 210 and i1Rgb.green   <= (219+gain)) then
            i2Rgb.green           <= 217;
        elsif (i1Rgb.green   >= 220 and i1Rgb.green   <= (229+gain)) then
            i2Rgb.green           <= 227;
        elsif (i1Rgb.green   >= 230 and i1Rgb.green   <= (239+gain)) then
            i2Rgb.green           <= 237;
        elsif (i1Rgb.green   >= 240 and i1Rgb.green   <= (249+gain)) then
            i2Rgb.green           <= 247;
        elsif (i1Rgb.green   >= 250 and i1Rgb.green   <= 255) then
            i2Rgb.green           <= 253;
        else
            i2Rgb.green           <= i1Rgb.green;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if (i1Rgb.blue   >= 0 and i1Rgb.blue   <= 9) then
            i2Rgb.blue           <= 7;
        elsif (i1Rgb.blue   >= 10 and i1Rgb.blue     <= (19+gain)) then
            i2Rgb.blue           <= 17;
        elsif (i1Rgb.blue   >= 20 and i1Rgb.blue     <= (29+gain)) then
            i2Rgb.blue           <= 27;
        elsif (i1Rgb.blue   >= 30 and i1Rgb.blue     <= (39+gain)) then
            i2Rgb.blue           <= 37;
        elsif (i1Rgb.blue   >= 40 and i1Rgb.blue     <= (49+gain)) then
            i2Rgb.blue           <= 47;
        elsif (i1Rgb.blue   >= 50 and i1Rgb.blue     <= (59+gain)) then
            i2Rgb.blue           <= 57;
        elsif (i1Rgb.blue   >= 60 and i1Rgb.blue     <= (69+gain)) then
            i2Rgb.blue           <= 67;
        elsif (i1Rgb.blue   >= 70 and i1Rgb.blue     <= (79+gain)) then
            i2Rgb.blue           <= 77;
        elsif (i1Rgb.blue   >= 80 and i1Rgb.blue     <= (89+gain)) then
            i2Rgb.blue           <= 87;
        elsif (i1Rgb.blue   >= 90 and i1Rgb.blue     <= (99+gain)) then
            i2Rgb.blue           <= 97;
        elsif (i1Rgb.blue   >= 100 and i1Rgb.blue    <= (109+gain)) then
            i2Rgb.blue           <= 107;
        elsif (i1Rgb.blue   >= 110 and i1Rgb.blue    <= (119+gain)) then
            i2Rgb.blue           <= 117;
        elsif (i1Rgb.blue   >= 120 and i1Rgb.blue    <= (129+gain)) then
            i2Rgb.blue           <= 127;
        elsif (i1Rgb.blue   >= 130 and i1Rgb.blue    <= (139+gain)) then
            i2Rgb.blue           <= 137;
        elsif (i1Rgb.blue   >= 140 and i1Rgb.blue    <= (149+gain)) then
            i2Rgb.blue           <= 147;
        elsif (i1Rgb.blue   >= 150 and i1Rgb.blue    <= (159+gain)) then
            i2Rgb.blue           <= 157;
        elsif (i1Rgb.blue   >= 160 and i1Rgb.blue   <= (169+gain)) then
            i2Rgb.blue           <= 167;
        elsif (i1Rgb.blue   >= 170 and i1Rgb.blue   <= (179+gain)) then
            i2Rgb.blue           <= 177;
        elsif (i1Rgb.blue   >= 180 and i1Rgb.blue   <= (189+gain)) then
            i2Rgb.blue           <= 187;
        elsif (i1Rgb.blue   >= 190 and i1Rgb.blue   <= (199+gain)) then
            i2Rgb.blue           <= 197;
        elsif (i1Rgb.blue   >= 200 and i1Rgb.blue   <= (209+gain)) then
            i2Rgb.blue           <= 207;
        elsif (i1Rgb.blue   >= 210 and i1Rgb.blue   <= (219+gain)) then
            i2Rgb.blue           <= 217;
        elsif (i1Rgb.blue   >= 220 and i1Rgb.blue   <= (229+gain)) then
            i2Rgb.blue           <= 227;
        elsif (i1Rgb.blue   >= 230 and i1Rgb.blue   <= (239+gain)) then
            i2Rgb.blue           <= 237;
        elsif (i1Rgb.blue   >= 240 and i1Rgb.blue   <= (249+gain)) then
            i2Rgb.blue           <= 247;
        elsif (i1Rgb.blue   >= 250 and i1Rgb.blue   <= 255) then
            i2Rgb.blue           <= 253;
        else
            i2Rgb.blue           <= i1Rgb.blue;
        end if;
    end if;
end process;
 oRgb.red   <= std_logic_vector(to_unsigned(i2Rgb.red, 10));
 oRgb.green <= std_logic_vector(to_unsigned(i2Rgb.green, 10));
 oRgb.blue  <= std_logic_vector(to_unsigned(i2Rgb.blue, 10));
 oRgb.valid <= i1Rgb.valid;
 oRgb.eol   <= rgbSyncEol;
 oRgb.sof   <= rgbSyncSof;
 oRgb.eof   <= rgbSyncEof;
end Behavioral;