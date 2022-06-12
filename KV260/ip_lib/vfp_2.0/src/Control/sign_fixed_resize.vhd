-------------------------------------------------------------------------------
--
-- Filename    : sign_fixed_resize.vhd
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

entity sign_fixed_resize is
port (
    clk              : in std_logic;
    kCoeffProd       : in kCoeffFloat;
    oRgb             : out rgbToSnSumTrRecord);
end sign_fixed_resize;
architecture Behavioral of sign_fixed_resize is
    signal snfix     : snFixedResizeRecord;
begin

-----------------------------------------------------------------------------------------------
-- STAGE 4
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        snfix.fxToSnFxProd.k1 <= to_sfixed((kCoeffProd.k1), snfix.fxToSnFxProd.k1);
        snfix.fxToSnFxProd.k2 <= to_sfixed((kCoeffProd.k2), snfix.fxToSnFxProd.k2);
        snfix.fxToSnFxProd.k3 <= to_sfixed((kCoeffProd.k3), snfix.fxToSnFxProd.k3);
        snfix.fxToSnFxProd.k4 <= to_sfixed((kCoeffProd.k4), snfix.fxToSnFxProd.k4);
        snfix.fxToSnFxProd.k5 <= to_sfixed((kCoeffProd.k5), snfix.fxToSnFxProd.k5);
        snfix.fxToSnFxProd.k6 <= to_sfixed((kCoeffProd.k6), snfix.fxToSnFxProd.k6);
        snfix.fxToSnFxProd.k7 <= to_sfixed((kCoeffProd.k7), snfix.fxToSnFxProd.k7);
        snfix.fxToSnFxProd.k8 <= to_sfixed((kCoeffProd.k8), snfix.fxToSnFxProd.k8);
        snfix.fxToSnFxProd.k9 <= to_sfixed((kCoeffProd.k9), snfix.fxToSnFxProd.k9);
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 5
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        snfix.snFxToSnProd.k1 <= to_signed(snfix.fxToSnFxProd.k1(19 downto 0), 20);
        snfix.snFxToSnProd.k2 <= to_signed(snfix.fxToSnFxProd.k2(19 downto 0), 20);
        snfix.snFxToSnProd.k3 <= to_signed(snfix.fxToSnFxProd.k3(19 downto 0), 20);
        snfix.snFxToSnProd.k4 <= to_signed(snfix.fxToSnFxProd.k4(19 downto 0), 20);
        snfix.snFxToSnProd.k5 <= to_signed(snfix.fxToSnFxProd.k5(19 downto 0), 20);
        snfix.snFxToSnProd.k6 <= to_signed(snfix.fxToSnFxProd.k6(19 downto 0), 20);
        snfix.snFxToSnProd.k7 <= to_signed(snfix.fxToSnFxProd.k7(19 downto 0), 20);
        snfix.snFxToSnProd.k8 <= to_signed(snfix.fxToSnFxProd.k8(19 downto 0), 20);
        snfix.snFxToSnProd.k9 <= to_signed(snfix.fxToSnFxProd.k9(19 downto 0), 20);
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 6
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        snfix.snToTrimProd.k1 <= snfix.snFxToSnProd.k1(19 downto 5);
        snfix.snToTrimProd.k2 <= snfix.snFxToSnProd.k2(19 downto 5);
        snfix.snToTrimProd.k3 <= snfix.snFxToSnProd.k3(19 downto 5);
        snfix.snToTrimProd.k4 <= snfix.snFxToSnProd.k4(19 downto 5);
        snfix.snToTrimProd.k5 <= snfix.snFxToSnProd.k5(19 downto 5);
        snfix.snToTrimProd.k6 <= snfix.snFxToSnProd.k6(19 downto 5);
        snfix.snToTrimProd.k7 <= snfix.snFxToSnProd.k7(19 downto 5);
        snfix.snToTrimProd.k8 <= snfix.snFxToSnProd.k8(19 downto 5);
        snfix.snToTrimProd.k9 <= snfix.snFxToSnProd.k9(19 downto 5);
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 7
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        snfix.snSum.red   <= resize(snfix.snToTrimProd.k1, ADD_RESULT_WIDTH) +
                          resize(snfix.snToTrimProd.k2, ADD_RESULT_WIDTH) +
                          resize(snfix.snToTrimProd.k3, ADD_RESULT_WIDTH) + ROUND;
        snfix.snSum.green <= resize(snfix.snToTrimProd.k4, ADD_RESULT_WIDTH) +
                          resize(snfix.snToTrimProd.k5, ADD_RESULT_WIDTH) +
                          resize(snfix.snToTrimProd.k6, ADD_RESULT_WIDTH) + ROUND;
        snfix.snSum.blue  <= resize(snfix.snToTrimProd.k7, ADD_RESULT_WIDTH) +
                          resize(snfix.snToTrimProd.k8, ADD_RESULT_WIDTH) +
                          resize(snfix.snToTrimProd.k9, ADD_RESULT_WIDTH) + ROUND;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 8
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        oRgb.red    <= snfix.snSum.red(snfix.snSum.red'left downto FRAC_BITS_TO_KEEP);
        oRgb.green  <= snfix.snSum.green(snfix.snSum.green'left downto FRAC_BITS_TO_KEEP);
        oRgb.blue   <= snfix.snSum.blue(snfix.snSum.blue'left downto FRAC_BITS_TO_KEEP);
    end if;
end process;
-----------------------------------------------------------------------------------------------

end Behavioral;