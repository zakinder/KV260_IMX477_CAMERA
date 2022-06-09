-------------------------------------------------------------------------------
--
-- Filename    : segment_colors.vhd
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

use work.fixed_pkg.all;
use work.float_pkg.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity segment_colors is
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iLumTh         : in  integer;
    iRgb           : in channel;
    oRgb           : out channel);
end segment_colors;

architecture behavioral of segment_colors is
    signal uFl1Rgb          : tpToFloatRecord;
    signal uFl2Rgb          : tpToFloatRecord;
    signal uFl3Rgb          : tpToFloatRecord;
    signal uFs4Rgb          : tpToFloatRecord;
    signal uFs5Rgb          : tpToFloatRecord;
    signal uFl6Rgb          : tpToFloatRecord;
    signal uFl7Rgb          : tpToFloatRecord;
    signal uFlRgbDrk        : tpToFloatRecord;
    signal uFlrgbLDt        : tpToFloatRecord;
    signal rgbMax           : float32  :=(others => '0');
    signal rgbMin           : float32  :=(others => '0');
    signal rgbxDeltaSum     : float32  :=(others => '0');
    signal rgbxDeltaValue   : float32  :=(others => '0');
    signal rgbAvg1s         : float32  :=(others => '0');
    signal rgbAvg2s         : float32  :=(others => '0');
    signal rgbAvg3s         : float32  :=(others => '0');
    signal rgbAvg4s         : float32  :=(others => '0');
    signal rgbDark          : float32  :=(others => '0');
    signal rgbBright        : float32  :=(others => '0');
    signal rgb2xBright      : float32  :=(others => '0');
    signal rgbBrightDark    : float32  :=(others => '0');
    signal LumValue         : float32  :=(others => '0');
    signal rgbLum           : float32  :=(others => '0');
    signal thresh           : std_logic_vector(7 downto 0);
    signal rgbLgt           : channel;
    signal rgbDrk           : channel;
    signal rgbLDt           : channel;
begin


thresh      <= std_logic_vector(to_unsigned(iLumTh,thresh'length));

-- RGB.DELTA.SUM = [MAX + MIN]
-- RGB.DELTA     = [MAX - MIN]
-- RGB.AVG       = [R+G+B/3]
-- RGB.DARK      = [RGB.DELTA.SUM]/[RGB.AVG]
-- LUM.V.DARK    = [RGB.DELTA] * [RGB.DARK]
-- RGB.L.DARK    = [RGB.AVG] / [LUM.V.DARK]


-- RGB.DELTA.SUM = [MAX + MIN]
-- RGB.DELTA     = [MAX - MIN]
-- RGB.AVG       = [R+G+B/3]
-- RGB.BRIGHT    = [RGB.AVG]/[RGB.DELTA.SUM]
-- LUM.V.BRIGHT  = [RGB.DELTA] * [RGB.BRIGHT]
-- RGB.L.BRIGHT  = [RGB.AVG] / [LUM.V.BRIGHT]
-----------------------------------------------------------------------------------------------
-- STAGE 1
-----------------------------------------------------------------------------------------------
process (clk,reset)begin
    if (reset = lo) then
        uFl1Rgb.red    <= (others => '0');
        uFl1Rgb.green  <= (others => '0');
        uFl1Rgb.blue   <= (others => '0');
    elsif rising_edge(clk) then
        uFl1Rgb.red    <= to_float(unsigned(iRgb.red),uFl1Rgb.red);
        uFl1Rgb.green  <= to_float(unsigned(iRgb.green),uFl1Rgb.green);
        uFl1Rgb.blue   <= to_float(unsigned(iRgb.blue),uFl1Rgb.blue);
        uFl1Rgb.valid  <= iRgb.valid;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 2 RGB.AVG = R+G+B
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgbAvg1s         <= uFl1Rgb.red + uFl1Rgb.green + uFl1Rgb.blue;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 3 RGB.AVG = R+G+B/3
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        if(rgbAvg1s > 0)then
            rgbAvg2s  <= rgbAvg1s / 3.0;
        end if;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 4
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgbAvg3s  <= rgbAvg2s;
        rgbAvg4s  <= rgbAvg3s;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 5
-- RGB.DELTA.SUM = MAX + MIN
-- RGB.AVG       = R+G+B/3
-- RGB.DARK      = [RGB.DELTA.SUM]/[RGB.AVG]
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        if(rgbAvg2s > 0) and (rgbxDeltaSum > 0) then
            rgbDark       <= rgbxDeltaSum / rgbAvg2s;--Dark
            rgbBright     <= rgbAvg2s / rgbxDeltaSum;--Light
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbBrightDark   <= (rgbDark - rgbBright);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb2xBright    <= rgbBright * 1.5;
    end if;
end process;


-----------------------------------------------------------------------------------------------
-- STAGE 6
-- RGB.DELTA.SUM = [MAX + MIN]
-- RGB.DELTA     = [MAX - MIN]
-- RGB.AVG       = [R+G+B/3]
-- RGB.DARK      = [RGB.DELTA.SUM]/[RGB.AVG]
-- LumValue      = [RGB.DELTA] * [RGB.DARK]
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        LumValue     <= (rgbxDeltaValue * rgbBrightDark);
    end if;
end process;

-----------------------------------------------------------------------------------------------
-- STAGE 7
-- RGB.DELTA.SUM = [MAX + MIN]
-- RGB.DELTA     = [MAX - MIN]
-- RGB.AVG       = [R+G+B/3]
-- RGB.DARK      = [RGB.DELTA.SUM]/[RGB.AVG]
-- LumValue      = [RGB.DELTA] * [RGB.DARK]
-- rgbLum        = [RGB.AVG] / [LumValue]
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        if(LumValue > 0) and  (rgbAvg4s > 0) then
            rgbLum             <= rgbAvg4s / LumValue;
        end if;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 8
-----------------------------------------------------------------------------------------------

process (clk) begin
    if rising_edge(clk) then
        uFlrgbLDt.red         <= (uFl6Rgb.red   * rgb2xBright);
        uFlrgbLDt.green       <= (uFl6Rgb.green * rgb2xBright);
        uFlrgbLDt.blue        <= (uFl6Rgb.blue  * rgb2xBright);
        uFlrgbLDt.valid       <= uFl6Rgb.valid;
    end if;
end process;


process (clk) begin
    if rising_edge(clk) then
        uFlRgbDrk.red         <= (uFl6Rgb.red   * rgbLum);
        uFlRgbDrk.green       <= (uFl6Rgb.green * rgbLum);
        uFlRgbDrk.blue        <= (uFl6Rgb.blue  * rgbLum);
        uFlRgbDrk.valid       <= uFl6Rgb.valid;
    end if;
end process;



process (clk) begin
    if rising_edge(clk) then
        rgbLDt.red   <= std_logic_vector(to_unsigned(uFlrgbLDt.red,8));
        rgbLDt.green <= std_logic_vector(to_unsigned(uFlrgbLDt.green,8));
        rgbLDt.blue  <= std_logic_vector(to_unsigned(uFlrgbLDt.blue,8));
        rgbLDt.valid <= uFlrgbLDt.valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if (uFlRgbDrk.red > 150.0) and (uFlRgbDrk.green > 150.0) and (uFlRgbDrk.blue > 150.0)  then
            rgbDrk.red   <= std_logic_vector(to_unsigned(uFlrgbLDt.red,8));
            rgbDrk.green <= std_logic_vector(to_unsigned(uFlrgbLDt.green,8));
            rgbDrk.blue  <= std_logic_vector(to_unsigned(uFlrgbLDt.blue,8));
            rgbDrk.valid <= uFlrgbLDt.valid;
        else
            rgbDrk.red   <= std_logic_vector(to_unsigned(uFlRgbDrk.red,8));
            rgbDrk.green <= std_logic_vector(to_unsigned(uFlRgbDrk.green,8));
            rgbDrk.blue  <= std_logic_vector(to_unsigned(uFlRgbDrk.blue,8));
            rgbDrk.valid <= uFlRgbDrk.valid;
        end if;
        
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbLgt.red   <= std_logic_vector(to_unsigned(uFl7Rgb.red,8));
        rgbLgt.green <= std_logic_vector(to_unsigned(uFl7Rgb.green,8));
        rgbLgt.blue  <= std_logic_vector(to_unsigned(uFl7Rgb.blue,8));
        rgbLgt.valid <= uFl7Rgb.valid;
    end if;
end process;



-----------------------------------------------------------------------------------------------
-- STAGE 12
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        if (rgbLgt.red > thresh) or (rgbLgt.green > thresh) or (rgbLgt.blue > thresh)  then
            oRgb       <= rgbLgt;
        else
            oRgb       <= rgbDrk;
        end if;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 3
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgbxDeltaValue   <= rgbMax - rgbMin;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 3
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgbxDeltaSum   <= rgbMax + rgbMin;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        uFl2Rgb <= uFl1Rgb;
        uFl3Rgb <= uFl2Rgb;
        uFs4Rgb <= uFl3Rgb;
        uFs5Rgb <= uFs4Rgb;
        uFl6Rgb <= uFs5Rgb;
        uFl7Rgb <= uFl6Rgb;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 2
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        if ((uFl1Rgb.red >= uFl1Rgb.green) and (uFl1Rgb.red >= uFl1Rgb.blue)) then
            rgbMax <= uFl1Rgb.red;
        elsif((uFl1Rgb.green >= uFl1Rgb.red) and (uFl1Rgb.green >= uFl1Rgb.blue))then
            rgbMax <= uFl1Rgb.green;
        else
            rgbMax <= uFl1Rgb.blue;
        end if;
        if ((uFl1Rgb.red <= uFl1Rgb.green) and (uFl1Rgb.red <= uFl1Rgb.blue)) then
            rgbMin <= uFl1Rgb.red;
        elsif((uFl1Rgb.green <= uFl1Rgb.red) and (uFl1Rgb.green <= uFl1Rgb.blue)) then
            rgbMin <= uFl1Rgb.green;
        else
            rgbMin <= uFl1Rgb.blue;
        end if;
    end if;
end process;
end behavioral;