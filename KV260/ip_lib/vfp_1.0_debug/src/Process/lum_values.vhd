-------------------------------------------------------------------------------
--
-- Filename    : lum_values.vhd
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

entity lum_values is
generic (
    F_LGT          : boolean := false;
    F_DRK          : boolean := false;
    F_LUM          : boolean := false;
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end lum_values;
architecture behavioral of lum_values is
    signal uFl1Rgb          : tpToFloatRecord;
    signal uFl2Rgb          : tpToFloatRecord;
    signal uFl3Rgb          : tpToFloatRecord;
    signal uFs4Rgb          : tpToFloatRecord;
    signal uFs5Rgb          : tpToFloatRecord;
    signal uFl6Rgb          : tpToFloatRecord;
    signal uFl7Rgb          : tpToFloatRecord;
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
begin
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
        rgb2xBright    <= rgbBright * 2.3;
    end if;
end process;
LGT_FRAME_ENABLE: if (F_LGT = true) and (F_DRK = false) generate
-----------------------------------------------------------------------------------------------
-- STAGE 6
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        LumValue     <= (rgbxDeltaValue * rgbBright);
    end if;
end process;
end generate LGT_FRAME_ENABLE;
DRK_FRAME_ENABLE: if (F_DRK = true) and (F_LGT = false) generate
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
        LumValue     <= (rgbxDeltaValue * rgbDark);
    end if;
end process;
end generate DRK_FRAME_ENABLE;
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
LUM_FRAME_ENABLE: if (F_LUM = true) and (F_DRK = false) and (F_LGT = false) generate
process (clk) begin
    if rising_edge(clk) then
        uFl7Rgb.red         <= (uFl6Rgb.red   * rgb2xBright);
        uFl7Rgb.green       <= (uFl6Rgb.green * rgb2xBright);
        uFl7Rgb.blue        <= (uFl6Rgb.blue  * rgb2xBright);
        uFl7Rgb.valid       <= uFl6Rgb.valid;
    end if;
end process;
end generate LUM_FRAME_ENABLE;
LUM_FRAME_DISABLE: if (F_LUM = false) generate
process (clk) begin
    if rising_edge(clk) then
        uFl7Rgb.red         <= (uFl6Rgb.red   * rgbLum);
        uFl7Rgb.green       <= (uFl6Rgb.green * rgbLum);
        uFl7Rgb.blue        <= (uFl6Rgb.blue  * rgbLum);
        uFl7Rgb.valid       <= uFl6Rgb.valid;
    end if;
end process;
end generate LUM_FRAME_DISABLE;
-----------------------------------------------------------------------------------------------
-- STAGE 12
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        oRgb.red   <= std_logic_vector(to_unsigned(uFl7Rgb.red,8));
        oRgb.green <= std_logic_vector(to_unsigned(uFl7Rgb.green,8));
        oRgb.blue  <= std_logic_vector(to_unsigned(uFl7Rgb.blue,8));
        oRgb.valid <= uFl7Rgb.valid;
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