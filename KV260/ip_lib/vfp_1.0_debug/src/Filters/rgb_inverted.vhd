-------------------------------------------------------------------------------
--
-- Filename    : rgb_inverted.vhd
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

use work.fixed_pkg.all;
use work.float_pkg.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity rgb_inverted is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end rgb_inverted;
architecture behavioral of rgb_inverted is
    --RGB Floating
    signal uFs1Rgb       : rgbToUfRecord;
    signal uFs2Rgb       : rgbToUf1Record;
    signal uFs3Rgb       : rgbToUfRecord;
    signal rgbMaxVal     : ufixed(7 downto 0) :=(others => '0');
begin

rgbMaxVal <= to_ufixed (255.0,rgbMaxVal);

process (clk,reset)begin
    if (reset = lo) then
        uFs1Rgb.red    <= (others => '0');
        uFs1Rgb.green  <= (others => '0');
        uFs1Rgb.blue   <= (others => '0');
        uFs1Rgb.valid  <= lo;
    elsif rising_edge(clk) then
        uFs1Rgb.red    <= to_ufixed(iRgb.red,uFs1Rgb.red);
        uFs1Rgb.green  <= to_ufixed(iRgb.green,uFs1Rgb.green);
        uFs1Rgb.blue   <= to_ufixed(iRgb.blue,uFs1Rgb.blue);
        uFs1Rgb.valid  <= iRgb.valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        uFs2Rgb.red        <= rgbMaxVal - uFs1Rgb.red;
        uFs2Rgb.green      <= rgbMaxVal - uFs1Rgb.green;
        uFs2Rgb.blue       <= rgbMaxVal - uFs1Rgb.blue;
        uFs2Rgb.valid      <= uFs1Rgb.valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        uFs3Rgb.red        <= resize(uFs2Rgb.red,uFs3Rgb.red);
        uFs3Rgb.green      <= resize(uFs2Rgb.green,uFs3Rgb.green);
        uFs3Rgb.blue       <= resize(uFs2Rgb.blue,uFs3Rgb.blue);
        uFs3Rgb.valid      <= uFs2Rgb.valid;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        oRgb.red    <= std_logic_vector(uFs3Rgb.red(i_data_width-1 downto 0));
        oRgb.green  <= std_logic_vector(uFs3Rgb.green(i_data_width-1 downto 0));
        oRgb.blue   <= std_logic_vector(uFs3Rgb.blue(i_data_width-1 downto 0));
        oRgb.valid  <= uFs3Rgb.valid;
    end if;
end process;

end behavioral;