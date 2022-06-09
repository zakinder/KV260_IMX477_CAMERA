-------------------------------------------------------------------------------
--
-- Filename    : rgb_kernal_prod.vhd
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

entity rgb_kernal_prod is
port (
    clk              : in std_logic;
    rst_l            : in std_logic;
    iRgb             : in channel;
    iCoeff           : in kernelCoeDWord;
    iTaps            : in TapsRecord;
    oRgbFloat        : out rgbFloat;
    oRgbSnFix        : out rgbToSnSumTrRecord);
end rgb_kernal_prod;
architecture Behavioral of rgb_kernal_prod is
    signal FractLevelProd   : kernelCoeDWord;
    signal kCoeffProd       : kCoeffFloat;
begin
-----------------------------------------------------------------------------------------------
-- STAGE 1
-----------------------------------------------------------------------------------------------
ByteToFloatTopRedinst: ByteToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => iRgb.valid,
      iData      => iRgb.red,
      oValid     => open,
      oDataFloat => oRgbFloat.red);
ByteToFloatTopGreeninst: ByteToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => iRgb.valid,
      iData      => iRgb.green,
      oValid     => open,
      oDataFloat => oRgbFloat.green);
ByteToFloatTopBlueinst: ByteToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => iRgb.valid,
      iData      => iRgb.blue,
      oValid     => open,
      oDataFloat => oRgbFloat.blue);
-----------------------------------------------------------------------------------------------
-- STAGE 2
-----------------------------------------------------------------------------------------------
FloatMultiplyK1Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => iCoeff.k1,
      iBdata     => iTaps.tpsd3.vTap2x,
      oRdata     => FractLevelProd.k1);
FloatMultiplyK2Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => iCoeff.k2,
      iBdata     => iTaps.tpsd2.vTap2x,
      oRdata     => FractLevelProd.k2);
FloatMultiplyK3Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => iCoeff.k3,
      iBdata     => iTaps.tpsd1.vTap2x,
      oRdata     => FractLevelProd.k3);
FloatMultiplyK4Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => iCoeff.k4,
      iBdata     => iTaps.tpsd3.vTap1x,
      oRdata     => FractLevelProd.k4);
FloatMultiplyK5Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => iCoeff.k5,
      iBdata     => iTaps.tpsd2.vTap1x,
      oRdata     => FractLevelProd.k5);
FloatMultiplyK6Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => iCoeff.k6,
      iBdata     => iTaps.tpsd1.vTap1x,
      oRdata     => FractLevelProd.k6);
FloatMultiplyK7Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => iCoeff.k7,
      iBdata     => iTaps.tpsd3.vTap0x,
      oRdata     => FractLevelProd.k7);
FloatMultiplyK8Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => iCoeff.k8,
      iBdata     => iTaps.tpsd2.vTap0x,
      oRdata     => FractLevelProd.k8);
FloatMultiplyK9Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => iCoeff.k9,
      iBdata     => iTaps.tpsd1.vTap0x,
      oRdata     => FractLevelProd.k9);
-----------------------------------------------------------------------------------------------
-- STAGE 3
-----------------------------------------------------------------------------------------------
FloatToFixedv1TopK1Inst: FloatToFixedv1Top
    port map (
      aclk       => clk,
      iData      => FractLevelProd.k1,
      oData      => kCoeffProd.k1);
FloatToFixedv1TopK2Inst: FloatToFixedv1Top
    port map (
      aclk       => clk,
      iData      => FractLevelProd.k2,
      oData      => kCoeffProd.k2);
FloatToFixedv1TopK3Inst: FloatToFixedv1Top
    port map (
      aclk       => clk,
      iData      => FractLevelProd.k3,
      oData      => kCoeffProd.k3);
FloatToFixedv1TopK4Inst: FloatToFixedv1Top
    port map (
      aclk       => clk,
      iData      => FractLevelProd.k4,
      oData      => kCoeffProd.k4);
FloatToFixedv1TopK5Inst: FloatToFixedv1Top
    port map (
      aclk       => clk,
      iData      => FractLevelProd.k5,
      oData      => kCoeffProd.k5);
FloatToFixedv1TopK6Inst: FloatToFixedv1Top
    port map (
      aclk       => clk,
      iData      => FractLevelProd.k6,
      oData      => kCoeffProd.k6);
FloatToFixedv1TopK7Inst: FloatToFixedv1Top
    port map (
      aclk       => clk,
      iData      => FractLevelProd.k7,
      oData      => kCoeffProd.k7);
FloatToFixedv1TopK8Inst: FloatToFixedv1Top
    port map (
      aclk       => clk,
      iData      => FractLevelProd.k8,
      oData      => kCoeffProd.k8);
FloatToFixedv1TopK9Inst: FloatToFixedv1Top
    port map (
      aclk       => clk,
      iData      => FractLevelProd.k9,
      oData      => kCoeffProd.k9);
-----------------------------------------------------------------------------------------------
-- STAGE 4-8
-----------------------------------------------------------------------------------------------
sign_fixed_resize_inst: sign_fixed_resize
    port map (
    clk          => clk,
    kCoeffProd   => kCoeffProd,
    oRgb         => oRgbSnFix);
-----------------------------------------------------------------------------------------------
end Behavioral;