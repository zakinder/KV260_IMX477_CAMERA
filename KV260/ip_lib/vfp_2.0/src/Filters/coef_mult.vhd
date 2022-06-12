-------------------------------------------------------------------------------
--
-- Filename    : coef_mult.vhd
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

entity coef_mult is
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iKcoeff        : in kernelCoeff;
    iFilterId      : in integer;
    oKcoeff        : out kernelCoeff;
    oCoeffProd     : out kCoefFiltFloat);
end coef_mult;

architecture behavioral of coef_mult is

    constant fractValue     : std_logic_vector(31 downto 0):= x"3a83126f";--0.001
    constant rgbLevelValue  : std_logic_vector(31 downto 0):= x"43800000";--256
    constant FloatMaxLat    : integer   := 20;
    type kCoefSt is (kCoefSetState,kCoefYcbcrState,kCoefCgainState,kCoefSharpState,kCoefBlureState,kCoefXSobeState,kCoefYSobeState,kCoefEmbosState,kCoefUpdaterState,kCoefIdleState);
    signal kCoefStates      : kCoefSt;
    signal kCoefVals        : kCoefFilters;
    signal userCoefVals     : kCoefFilters;
    signal kCoeffDWord      : kernelCoeDWord;
    signal kCofFrtProd      : kernelCoeDWord;
    signal upCtr            : integer   :=zero;
    signal kCoeffValid      : std_logic := hi;
    signal fractLevel       : std_logic_vector(31 downto 0):= (others => lo);
    signal kCof             : kernelCoeff;
    
begin

NewUserCoeffValuesP: process(clk) begin
    if (rising_edge (clk)) then
        if (iKcoeff.kSet = kCoefYcbcrIndex) then
            userCoefVals.kCoeffYcbcr   <= iKcoeff;
        elsif(iKcoeff.kSet = kCoefCgainIndex)then
            userCoefVals.kCoeffCgain   <= iKcoeff;
        elsif(iKcoeff.kSet = kCoefSharpIndex)then
            userCoefVals.kCoeffSharp   <= iKcoeff;
        elsif(iKcoeff.kSet = kCoefBlureIndex)then
            userCoefVals.kCoeffBlure   <= iKcoeff;
        elsif(iKcoeff.kSet = kCoefSobeXIndex)then
            userCoefVals.kCoefXSobel   <= iKcoeff;
        elsif(iKcoeff.kSet = kCoefSobeYIndex)then
            userCoefVals.kCoefYSobel   <= iKcoeff;
        elsif(iKcoeff.kSet = kCoefEmbosIndex)then
            userCoefVals.kCoeffEmbos   <= iKcoeff;
        elsif(iKcoeff.kSet = kCoefCgai1Index)then
            userCoefVals.kCoef1Cgain   <= iKcoeff;
        end if;
    end if;
end process NewUserCoeffValuesP;



FloatMaxLatP: process(clk) begin
    if (rising_edge (clk)) then
        if (rst_l = lo) then
            upCtr <= zero;
        else
            if (upCtr < (FloatMaxLat + one)) then
                upCtr  <= upCtr + one;
            else
                upCtr <= zero;
            end if;
        end if;
    end if;
end process FloatMaxLatP;


kCoefStP: process (clk) begin
    if (rising_edge (clk)) then
        if (rst_l = lo) then
            kCoefStates <= kCoefSetState;
        else
        case (kCoefStates) is
        when kCoefSetState =>
        
            ---------------------------------------------
            --           [-2]  [-1]   [+0]
            --           [-1]  [+1]   [+1]
            --           [+0]  [+1]   [+2]
            kCoefVals.kCoeffYcbcr.k1   <= x"0101";--  0.257
            kCoefVals.kCoeffYcbcr.k2   <= x"01F8";--  0.504
            kCoefVals.kCoeffYcbcr.k3   <= x"0062";--  0.098
            
            kCoefVals.kCoeffYcbcr.k4   <= x"FF6C";-- -0.148
            kCoefVals.kCoeffYcbcr.k5   <= x"FEDD";-- -0.291
            kCoefVals.kCoeffYcbcr.k6   <= x"01B7";--  0.439
            
            kCoefVals.kCoeffYcbcr.k7   <= x"01B7";--  0.439
            kCoefVals.kCoeffYcbcr.k8   <= x"FE90";-- -0.368
            kCoefVals.kCoeffYcbcr.k9   <= x"FFB9";-- -0.071
            kCoefVals.kCoeffYcbcr.kSet <= kCoefYcbcrIndex;
            ---------------------------------------------
            -- x"05DC";--  1500
            -- x"0FF5";--  1375
            -- x"FF06";--  -250
            -- x"FE0C";--  -500
            -- x"FF83";--  -125
            ---------------------------------------------
            kCoefVals.kCoeffCgain.k1   <= x"05DC";--  1375  =  1.375
            kCoefVals.kCoeffCgain.k2   <= x"FF06";-- -250   = -0.250
            kCoefVals.kCoeffCgain.k3   <= x"FF83";-- -125   = -0.500
            
            kCoefVals.kCoeffCgain.k4   <= x"FF83";-- -125   = -0.500
            kCoefVals.kCoeffCgain.k5   <= x"05DC";--  1375  =  1.375
            kCoefVals.kCoeffCgain.k6   <= x"FF06";-- -250   = -0.250
            
            kCoefVals.kCoeffCgain.k7   <= x"FF83";-- -125   = -0.250
            kCoefVals.kCoeffCgain.k8   <= x"FF06";-- -250   = -0.500
            kCoefVals.kCoeffCgain.k9   <= x"05DC";--  1500  =  1.500
            kCoefVals.kCoeffCgain.kSet <= kCoefCgainIndex;
            ---------------------------------------------
            
            ---------------------------------------------
            --           [-2]  [-1]   [+0]
            --           [-1]  [+1]   [+1]
            --           [+0]  [+1]   [+2]
            kCoefVals.kCoeffSharp.k1   <= x"0000";--  0
            kCoefVals.kCoeffSharp.k2   <= x"FE0C";-- -0.5
            kCoefVals.kCoeffSharp.k3   <= x"0000";--  0
            kCoefVals.kCoeffSharp.k4   <= x"FE0C";-- -0.5
            kCoefVals.kCoeffSharp.k5   <= x"0BB8";--  3
            kCoefVals.kCoeffSharp.k6   <= x"FE0C";-- -0.5
            kCoefVals.kCoeffSharp.k7   <= x"0000";--  0
            kCoefVals.kCoeffSharp.k8   <= x"FE0C";-- -0.5
            kCoefVals.kCoeffSharp.k9   <= x"0000";--  0
            kCoefVals.kCoeffSharp.kSet <= kCoefSharpIndex;
            
            ---------------------------------------------
            kCoefVals.kCoeffBlure.k1   <= x"006F";-- 0.111
            kCoefVals.kCoeffBlure.k2   <= x"006F";-- 0.111
            kCoefVals.kCoeffBlure.k3   <= x"006F";-- 0.111
            kCoefVals.kCoeffBlure.k4   <= x"006F";-- 0.111
            kCoefVals.kCoeffBlure.k5   <= x"006F";-- 0.111
            kCoefVals.kCoeffBlure.k6   <= x"006F";-- 0.111
            kCoefVals.kCoeffBlure.k7   <= x"006F";-- 0.111
            kCoefVals.kCoeffBlure.k8   <= x"006F";-- 0.111
            kCoefVals.kCoeffBlure.k9   <= x"006F";-- 0.111
            kCoefVals.kCoeffBlure.kSet <= kCoefBlureIndex;
            
            ---------------------------------------------
            --           Sobel kernel Gx
            --           [-1]  [+0]   [+1]
            --           [-1]  [+0]   [+1]
            --           [-1]  [+0]   [+1]
            kCoefVals.kCoefXSobel.k1   <= x"FC18";--  [-1]
            kCoefVals.kCoefXSobel.k2   <= x"0000";--  [+0]
            kCoefVals.kCoefXSobel.k3   <= x"03E8";--  [+1]
            kCoefVals.kCoefXSobel.k4   <= x"FC18";--  [-1]--<= x"F830";--  [-2]
            kCoefVals.kCoefXSobel.k5   <= x"0000";--  [+0]
            kCoefVals.kCoefXSobel.k6   <= x"03E8";--  [+1]--<= x"07D0";--  [+2]
            kCoefVals.kCoefXSobel.k7   <= x"FC18";--  [-1]
            kCoefVals.kCoefXSobel.k8   <= x"0000";--  [+0]
            kCoefVals.kCoefXSobel.k9   <= x"03E8";--  [+1]
            
            --           Sobel kernel Gy
            --           [+1]  [+1]   [+1]
            --           [+0]  [+0]   [+0]
            --           [-1]  [-2]   [-1]
            kCoefVals.kCoefXSobel.kSet <= kCoefSobeXIndex;
            kCoefVals.kCoefYSobel.k1   <= x"03E8";--  [+1]
            kCoefVals.kCoefYSobel.k2   <= x"03E8";--  [+1]--<= x"07D0";--  [+2]
            kCoefVals.kCoefYSobel.k3   <= x"03E8";--  [+1]
            kCoefVals.kCoefYSobel.k4   <= x"0000";--  [+0]
            kCoefVals.kCoefYSobel.k5   <= x"0000";--  [+0]
            kCoefVals.kCoefYSobel.k6   <= x"0000";--  [+0]
            kCoefVals.kCoefYSobel.k7   <= x"FC18";--  [-1]
            kCoefVals.kCoefYSobel.k8   <= x"FC18";--  [-1]--<= x"F830";--  [-2]
            kCoefVals.kCoefYSobel.k9   <= x"FC18";--  [-1]
            kCoefVals.kCoefYSobel.kSet <= kCoefSobeYIndex;
            ---------------------------------------------
            
            
            --           Emboss kernel
            --           [-2]  [-1]   [+0]
            --           [-1]  [+1]   [+1]
            --           [+0]  [+1]   [+2]
            ---------------------------------------------
            kCoefVals.kCoeffEmbos.k1   <= x"F830";--  [-2]
            kCoefVals.kCoeffEmbos.k2   <= x"FC18";--  [-1]
            kCoefVals.kCoeffEmbos.k3   <= x"0000";--  [+0]
            
            kCoefVals.kCoeffEmbos.k4   <= x"FC18";--  [-1]
            kCoefVals.kCoeffEmbos.k5   <= x"03E8";--  [+1]
            kCoefVals.kCoeffEmbos.k6   <= x"03E8";--  [+1]
            
            kCoefVals.kCoeffEmbos.k7   <= x"0000";--  [+0]
            kCoefVals.kCoeffEmbos.k8   <= x"03E8";--  [+1]
            kCoefVals.kCoeffEmbos.k9   <= x"07D0";--  [+2]
            kCoefVals.kCoeffEmbos.kSet <= kCoefEmbosIndex;
            ---------------------------------------------
            
            
            ---------------------------------------------
            kCoefVals.kCoef1Cgain.k1   <= x"055F";--  1375  =  1.375
            kCoefVals.kCoef1Cgain.k2   <= x"FF83";-- -125   = -0.125
            kCoefVals.kCoef1Cgain.k3   <= x"FF06";-- -250   = -0.250
            
            kCoefVals.kCoef1Cgain.k4   <= x"FF06";-- -250   = -0.250
            kCoefVals.kCoef1Cgain.k5   <= x"055F";--  1375  =  1.375
            kCoefVals.kCoef1Cgain.k6   <= x"FF83";-- -125   = -0.125
            
            kCoefVals.kCoef1Cgain.k7   <= x"FF83";-- -125   = -0.125
            kCoefVals.kCoef1Cgain.k8   <= x"FF06";-- -250   = -0.250
            kCoefVals.kCoef1Cgain.k9   <= x"055F";--  1375  =  1.375
            
            kCoefVals.kCoef1Cgain.kSet <= kCoefCgai1Index;
            ---------------------------------------------
            
            
            kCoefStates <= kCoefYcbcrState;
            
            
        when kCoefYcbcrState =>
            if (userCoefVals.kCoeffYcbcr.kSet = kCoefVals.kCoeffYcbcr.kSet) then
                -- Updated User Coefficients Values
                kCof <= userCoefVals.kCoeffYcbcr;
            else
                -- Default Coefficients Values
                kCof <= kCoefVals.kCoeffYcbcr;
            end if;

            if (upCtr = FloatMaxLat) then
                -- Updated Default Coefficients Values
                oCoeffProd.kCoeffYcbcr      <= kCofFrtProd;
                oCoeffProd.kCoeffYcbcr.kSet <= kCoefVals.kCoeffYcbcr.kSet;
                kCoefStates <= kCoefCgainState;
            end if;
            
        when kCoefCgainState =>
            if (userCoefVals.kCoeffCgain.kSet = kCoefVals.kCoeffCgain.kSet) then
                -- Updated User Coefficients Values
                kCof <= userCoefVals.kCoeffCgain;
            else
                -- Default Coefficients Values
                kCof <= kCoefVals.kCoeffCgain;
            end if;
            if (upCtr = FloatMaxLat) then
                oCoeffProd.kCoeffCgain <= kCofFrtProd;
                oCoeffProd.kCoeffCgain.kSet <= kCoefVals.kCoeffCgain.kSet;
                kCoefStates <= kCoefSharpState;
            end if;
        when kCoefSharpState =>
            if (userCoefVals.kCoeffSharp.kSet = kCoefVals.kCoeffSharp.kSet) then
                -- Updated User Coefficients Values
                kCof <= userCoefVals.kCoeffSharp;
            else
                -- Default Coefficients Values
                kCof <= kCoefVals.kCoeffSharp;
            end if;
            if (upCtr = FloatMaxLat) then
                oCoeffProd.kCoeffSharp <= kCofFrtProd;
                oCoeffProd.kCoeffSharp.kSet <= kCoefVals.kCoeffSharp.kSet;
                kCoefStates <= kCoefBlureState;
            end if;
        when kCoefBlureState =>
            if (userCoefVals.kCoeffBlure.kSet = kCoefVals.kCoeffBlure.kSet) then
                -- Updated User Coefficients Values
                kCof <= userCoefVals.kCoeffBlure;
            else
                -- Default Coefficients Values
                kCof <= kCoefVals.kCoeffBlure;
            end if;
            if (upCtr = FloatMaxLat) then
                oCoeffProd.kCoeffBlure <= kCofFrtProd;
                oCoeffProd.kCoeffBlure.kSet <= kCoefVals.kCoeffBlure.kSet;
                kCoefStates <= kCoefXSobeState;
            end if;
        when kCoefXSobeState =>
            if (userCoefVals.kCoefXSobel.kSet = kCoefVals.kCoefXSobel.kSet) then
                -- Updated User Coefficients Values
                kCof <= userCoefVals.kCoefXSobel;
            else
                -- Default Coefficients Values
                kCof <= kCoefVals.kCoefXSobel;
            end if;
            if (upCtr = FloatMaxLat) then
                oCoeffProd.kCoefXSobel <= kCofFrtProd;
                oCoeffProd.kCoefXSobel.kSet <= kCoefVals.kCoefXSobel.kSet;
                kCoefStates <= kCoefYSobeState;
            end if;
        when kCoefYSobeState =>
            if (userCoefVals.kCoefYSobel.kSet = kCoefVals.kCoefYSobel.kSet) then
                -- Updated User Coefficients Values
                kCof <= userCoefVals.kCoefYSobel;
            else
                -- Default Coefficients Values
                kCof <= kCoefVals.kCoefYSobel;
            end if;

            if (upCtr = FloatMaxLat) then
                oCoeffProd.kCoefYSobel <= kCofFrtProd;
                oCoeffProd.kCoefYSobel.kSet <= kCoefVals.kCoefYSobel.kSet;
                kCoefStates <= kCoefEmbosState;
            end if;
        when kCoefEmbosState =>
            if (userCoefVals.kCoeffEmbos.kSet = kCoefVals.kCoeffEmbos.kSet) then
                -- Updated User Coefficients Values
                kCof <= userCoefVals.kCoeffEmbos;
            else
                -- Default Coefficients Values
                kCof <= kCoefVals.kCoeffEmbos;
            end if;

            if (upCtr = FloatMaxLat) then
                oCoeffProd.kCoeffEmbos <= kCofFrtProd;
                oCoeffProd.kCoeffEmbos.kSet <= kCoefVals.kCoeffEmbos.kSet;
                kCoefStates <= kCoefUpdaterState;
            end if;
            

        when kCoefUpdaterState =>
            -- baremetal os last write readback
            if (iFilterId = kCoefYcbcrIndex) then
                oKcoeff                      <= userCoefVals.kCoeffYcbcr;
            elsif(iFilterId = kCoefCgainIndex)then
                oKcoeff                      <= userCoefVals.kCoeffCgain;
            elsif(iFilterId = kCoefSharpIndex)then
                oKcoeff                      <= userCoefVals.kCoeffSharp;
            elsif(iFilterId = kCoefBlureIndex)then
                oKcoeff                      <= userCoefVals.kCoeffBlure;
            elsif(iFilterId = kCoefSobeXIndex)then
                oKcoeff                      <= userCoefVals.kCoefXSobel;
            elsif(iFilterId = kCoefSobeYIndex)then
                oKcoeff                      <= userCoefVals.kCoefYSobel;
            elsif(iFilterId = kCoefEmbosIndex)then
                oKcoeff                      <= userCoefVals.kCoeffEmbos;
            else
                oKcoeff                      <= userCoefVals.kCoef1Cgain;
            end if;
            kCoefStates <= kCoefYcbcrState;
        when others =>
            kCoefStates <= kCoefUpdaterState;
        end case;
        end if;
    end if;
end process kCoefStP;
-----------------------------------------------------------------------------------------------
--Coeff To Float
-----------------------------------------------------------------------------------------------
FloatMultiplyTopFractLevelInst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => fractValue,
      iBdata     => rgbLevelValue,
      oRdata     => fractLevel);
-----------------------------------------------------------------------------------------------
WordToFloatTopK1inst: WordToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => kCoeffValid,
      iData      => kCof.k1,
      oValid     => open,
      oDataFloat => kCoeffDWord.k1);
WordToFloatTopK2inst: WordToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => kCoeffValid,
      iData      => kCof.k2,
      oValid     => open,
      oDataFloat => kCoeffDWord.k2);
WordToFloatTopK3inst: WordToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => kCoeffValid,
      iData      => kCof.k3,
      oValid     => open,
      oDataFloat => kCoeffDWord.k3);
WordToFloatTopK4inst: WordToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => kCoeffValid,
      iData      => kCof.k4,
      oValid     => open,
      oDataFloat => kCoeffDWord.k4);
WordToFloatTopK5inst: WordToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => kCoeffValid,
      iData      => kCof.k5,
      oValid     => open,
      oDataFloat => kCoeffDWord.k5);
WordToFloatTopK6inst: WordToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => kCoeffValid,
      iData      => kCof.k6,
      oValid     => open,
      oDataFloat => kCoeffDWord.k6);
WordToFloatTopK7inst: WordToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => kCoeffValid,
      iData      => kCof.k7,
      oValid     => open,
      oDataFloat => kCoeffDWord.k7);
WordToFloatTopK8inst: WordToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => kCoeffValid,
      iData      => kCof.k8,
      oValid     => open,
      oDataFloat => kCoeffDWord.k8);
WordToFloatTopK9inst: WordToFloatTop
    port map (
      aclk       => clk,
      rst_l      => rst_l,
      iValid     => kCoeffValid,
      iData      => kCof.k9,
      oValid     => open,
      oDataFloat => kCoeffDWord.k9);
      
      
FloatMultiplyTopK1Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => kCoeffDWord.k1,
      iBdata     => fractLevel,
      oRdata     => kCofFrtProd.k1);
FloatMultiplyTopK2Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => kCoeffDWord.k2,
      iBdata     => fractLevel,
      oRdata     => kCofFrtProd.k2);
FloatMultiplyTopK3Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => kCoeffDWord.k3,
      iBdata     => fractLevel,
      oRdata     => kCofFrtProd.k3);
FloatMultiplyTopK4Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => kCoeffDWord.k4,
      iBdata     => fractLevel,
      oRdata     => kCofFrtProd.k4);
FloatMultiplyTopK5Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => kCoeffDWord.k5,
      iBdata     => fractLevel,
      oRdata     => kCofFrtProd.k5);
FloatMultiplyTopK6Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => kCoeffDWord.k6,
      iBdata     => fractLevel,
      oRdata     => kCofFrtProd.k6);
FloatMultiplyTopK7Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => kCoeffDWord.k7,
      iBdata     => fractLevel,
      oRdata     => kCofFrtProd.k7);
FloatMultiplyTopK8Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => kCoeffDWord.k8,
      iBdata     => fractLevel,
      oRdata     => kCofFrtProd.k8);
FloatMultiplyTopK9Inst: FloatMultiplyTop
    port map (
      clk        => clk,
      iAdata     => kCoeffDWord.k9,
      iBdata     => fractLevel,
      oRdata     => kCofFrtProd.k9);
end behavioral;