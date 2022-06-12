-------------------------------------------------------------------------------
--
-- Filename    : kernel_core.vhd
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

use work.fixed_pkg.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity kernel_core is
generic (
    SHARP_FRAME      : boolean := false;
    BLURE_FRAME      : boolean := false;
    EMBOS_FRAME      : boolean := false;
    YCBCR_FRAME      : boolean := false;
    SOBEL_FRAME      : boolean := false;
    CGAIN_FRAME      : boolean := false;
    img_width        : integer := 4096;
    i_data_width     : integer := 8);
port (
    clk              : in std_logic;
    rst_l            : in std_logic;
    iRgb             : in channel;
    kCoeff           : in kernelCoeDWord;
    oRgb             : out channel);
end kernel_core;
architecture Behavioral of kernel_core is
    signal taps             : TapsRecord;
    signal rgb_float        : rgbFloat;
    signal rgbSum           : signed(12 downto 0);
    signal snfixRgb         : rgbToSnSumTrRecord;
begin

rgb_kernal_prod_inst: rgb_kernal_prod
    port map (
    clk         => clk,
    rst_l       => rst_l,
    iRgb        => iRgb,
    iCoeff      => kCoeff,
    iTaps       => taps,
    oRgbFloat   => rgb_float,
    oRgbSnFix   => snfixRgb);
    
-----------------------------------------------------------------------------------------------
--FILTERS: SHARP BLURE EMBOS SOBEL
-----------------------------------------------------------------------------------------------
COLOR_DELAYED_ENABLED: if ((SHARP_FRAME = TRUE) or (BLURE_FRAME = TRUE)
                        or (EMBOS_FRAME = TRUE) or (SOBEL_FRAME = TRUE)) generate
signal cc_rgbSum : std_logic_vector(i_data_width-1 downto 0) := black;
signal rgb       : channel;
begin
-----------------------------------------------------------------------------------------------
-- STAGE 2
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        --Red
        taps.tpsd1.vTap0x <= rgb_float.red;
        taps.tpsd2.vTap0x <= taps.tpsd1.vTap0x;
        taps.tpsd3.vTap0x <= taps.tpsd2.vTap0x;
        --Green
        taps.tpsd1.vTap1x <= rgb_float.green;
        taps.tpsd2.vTap1x <= taps.tpsd1.vTap1x;
        taps.tpsd3.vTap1x <= taps.tpsd2.vTap1x;
        --Blue
        taps.tpsd1.vTap2x <= rgb_float.blue;
        taps.tpsd2.vTap2x <= taps.tpsd1.vTap2x;
        taps.tpsd3.vTap2x <= taps.tpsd2.vTap2x;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 9
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgbSum  <= (snfixRgb.red + snfixRgb.green + snfixRgb.blue);
        if (rgbSum(ROUND_RESULT_WIDTH-1) = hi) then
            cc_rgbSum <= black;
        elsif (unsigned(rgbSum(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= zero) then
            cc_rgbSum <= white;
        else
            cc_rgbSum <= std_logic_vector(rgbSum(i_data_width-1 downto 0));
        end if;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 10
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgb.red    <= cc_rgbSum;
        rgb.green  <= cc_rgbSum;
        rgb.blue   <= cc_rgbSum;
        rgb.valid  <= iRgb.valid;
    end if;
end process;

SHARP_FRAME_ENABLED: if (SHARP_FRAME = TRUE) generate
sharp_valid_inst: d_valid
generic map (
    pixelDelay   => 34)
port map(
    clk      => clk,
    iRgb     => rgb,
    oRgb     => oRgb);
end generate SHARP_FRAME_ENABLED;

BLURE_FRAME_ENABLED: if (BLURE_FRAME = TRUE) generate
blure_valid_inst: d_valid
generic map (
    pixelDelay   => 35)
port map(
    clk      => clk,
    iRgb     => rgb,
    oRgb     => oRgb);
end generate BLURE_FRAME_ENABLED;

EMBOS_FRAME_ENABLED: if (EMBOS_FRAME = TRUE) generate
embos_valid_inst: d_valid
generic map (
    pixelDelay   => 35)
port map(
    clk      => clk,
    iRgb     => rgb,
    oRgb     => oRgb);
end generate EMBOS_FRAME_ENABLED;

SOBEL_FRAME_ENABLED: if (SOBEL_FRAME = TRUE) generate
sobel_valid_inst: d_valid
generic map (
    pixelDelay   => 31)
port map(
    clk      => clk,
    iRgb     => rgb,
    oRgb     => oRgb);
end generate SOBEL_FRAME_ENABLED;

-----------------------------------------------------------------------------------------------
end generate COLOR_DELAYED_ENABLED;
-----------------------------------------------------------------------------------------------
--FILTERS: YCBCR
-----------------------------------------------------------------------------------------------
YCBCR_FRAME_ENABLED: if (YCBCR_FRAME = true) generate
    constant fullRange    : boolean := true;
    signal yCbCrRgb       : uChannel := (valid => lo, red => blackUn, green => blackUn, blue => blackUn);
    signal yCbCr128       : unsigned(i_data_width-1 downto 0);
    signal yCbCr16        : unsigned(i_data_width-1 downto 0);
    signal rgb            : channel;
begin
    yCbCr128        <= shift_left(to_unsigned(one,i_data_width), i_data_width - 1);
    yCbCr16         <= shift_left(to_unsigned(one,i_data_width), i_data_width - 4);
-----------------------------------------------------------------------------------------------
-- STAGE 2
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        taps.tpsd1.vTap0x <= rgb_float.blue;
        taps.tpsd2.vTap0x <= rgb_float.green;
        taps.tpsd3.vTap0x <= rgb_float.red;
        taps.tpsd1.vTap1x <= rgb_float.blue;
        taps.tpsd2.vTap1x <= rgb_float.green;
        taps.tpsd3.vTap1x <= rgb_float.red;
        taps.tpsd1.vTap2x <= rgb_float.blue;
        taps.tpsd2.vTap2x <= rgb_float.green;
        taps.tpsd3.vTap2x <= rgb_float.red;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 9
-----------------------------------------------------------------------------------------------
process (clk)
    variable yRound      : unsigned(i_data_width-1 downto 0);
    variable cbRound     : unsigned(i_data_width-1 downto 0);
    variable crRound     : unsigned(i_data_width-1 downto 0);
    begin
    if rising_edge(clk) then
        if (snfixRgb.red(ROUND_RESULT_WIDTH-1) = hi)  then
            if fullRange then
                yRound := yCbCr16 + 1;
            else
                yRound := to_unsigned(1, i_data_width);
            end if;
        else
            if fullRange then
                yRound := yCbCr16;
            else
                yRound := (others => '0');
            end if;
        end if;
        if (snfixRgb.green(ROUND_RESULT_WIDTH-1) = hi) then
            cbRound := resize(yCbCr128+1, i_data_width);
        else
            cbRound := yCbCr128;
        end if;
        if (snfixRgb.blue(ROUND_RESULT_WIDTH-1) = hi) then
            crRound := resize(yCbCr128+1, i_data_width);
        else
            crRound := yCbCr128;
        end if;
        ---------------------------------------------------------------------------------------
        yCbCrRgb.red   <= (unsigned(snfixRgb.red(i_data_width-1 downto 0))) + yRound;
        yCbCrRgb.green <= (unsigned(snfixRgb.green(i_data_width-1 downto 0))) + cbRound;
        yCbCrRgb.blue  <= (unsigned(snfixRgb.blue(i_data_width-1 downto 0))) + crRound;
        ---------------------------------------------------------------------------------------
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 10
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgb.red     <= std_logic_vector(yCbCrRgb.red);
        rgb.green   <= std_logic_vector(yCbCrRgb.green);
        rgb.blue    <= std_logic_vector(yCbCrRgb.blue);
        rgb.valid   <= iRgb.valid;
    end if;
end process;
yCbCr_valid_Inst: d_valid
generic map (
    pixelDelay   => 27)
port map(
    clk      => clk,
    iRgb     => rgb,
    oRgb     => oRgb);
-----------------------------------------------------------------------------------------------
end generate YCBCR_FRAME_ENABLED;
-----------------------------------------------------------------------------------------------
--FILTERS: CGAIN
-----------------------------------------------------------------------------------------------
CGAIN_FRAME_ENABLED: if (CGAIN_FRAME = true) generate
    signal cGain : channel := (valid => lo, red => black, green => black, blue => black);
    signal rgb   : channel;
begin
-----------------------------------------------------------------------------------------------
-- STAGE 2: PER PIXEL
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then

        
        -- tpsd1_vTap0x x k9-> p33
        taps.tpsd1.vTap0x <= rgb_float.blue;
        -- tpsd2_vTap0x x k8-> p32
        taps.tpsd2.vTap0x <= rgb_float.green;
        -- tpsd3_vTap0x x k7-> p31
        taps.tpsd3.vTap0x <= rgb_float.red;
        
        -- tpsd1_vTap1x x k6 -> p23
        taps.tpsd1.vTap1x <= rgb_float.blue;
        -- tpsd2_vTap1x x k5 -> p22
        taps.tpsd2.vTap1x <= rgb_float.green;
        -- tpsd3_vTap1x x k4 -> p21
        taps.tpsd3.vTap1x <= rgb_float.red;

        -- tpsd1_vTap2x x k3 -> p13
        taps.tpsd1.vTap2x <= rgb_float.blue;
        -- tpsd2_vTap2x x k2 -> p12
        taps.tpsd2.vTap2x <= rgb_float.green;
        -- tpsd3_vTap2x x k1 -> p11
        taps.tpsd3.vTap2x <= rgb_float.red;
        
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 9 PER PIXEL
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        -- cGain.red= snfixRgb.red(p11+p12+p13)
        if (snfixRgb.red(ROUND_RESULT_WIDTH-1) = hi) then
            cGain.red <= black;
        elsif (unsigned(snfixRgb.red(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= zero) then
            cGain.red <= white;
        else
            cGain.red <= std_logic_vector(snfixRgb.red(i_data_width-1 downto 0));
        end if;
        -- cGain.green= snfixRgb.green(p21+p22+p23)
        if (snfixRgb.green(ROUND_RESULT_WIDTH-1) = hi) then
            cGain.green <= black;
        elsif (unsigned(snfixRgb.green(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= zero) then
            cGain.green <= white;
        else
            cGain.green <= std_logic_vector(snfixRgb.green(i_data_width-1 downto 0));
        end if;
        -- cGain.blue= snfixRgb.blue(p31+p32+p33)
        if (snfixRgb.blue(ROUND_RESULT_WIDTH-1) = hi) then
            cGain.blue <= black;
        elsif (unsigned(snfixRgb.blue(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= zero) then
            cGain.blue <= white;
        else
            cGain.blue <= std_logic_vector(snfixRgb.blue(i_data_width-1 downto 0));
        end if;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 10
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgb.red     <= cGain.red;
        rgb.green   <= cGain.green;
        rgb.blue    <= cGain.blue;
        rgb.valid   <= iRgb.valid;
    end if;
end process;
cgain_valid_inst: d_valid
generic map (
    pixelDelay   => 27)
port map(
    clk      => clk,
    iRgb     => rgb,
    oRgb     => oRgb);
-----------------------------------------------------------------------------------------------
end generate CGAIN_FRAME_ENABLED;
end Behavioral;