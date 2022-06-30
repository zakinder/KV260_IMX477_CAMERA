-------------------------------------------------------------------------------
--
-- Filename    : ccm.vhd
-- Create Date : 05022019 [05-02-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity ccm is
  port (
    clk              : in std_logic;
    rst_l            : in std_logic;
    k_config_number  : in integer;
    coefficients_in     : in coefficient_values;
    coefficients_out : out coefficient_values;
    iRgb             : in channel;
    oRgb             : out channel);
end ccm;
architecture Behavioral of ccm is
  signal ccRgb                : ccRgbRecord;
  signal rgbSyncValid         : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncEol           : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncSof           : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncEof           : std_logic_vector(11 downto 0) := x"000";
  signal rgb_ccm              : channel;
  signal i_k_config_number    : integer := 2;
begin
i_k_config_number <= k_config_number;
rgbToSf_P: process (clk,rst_l)begin
    if rst_l = '0' then
        ccRgb.rgbToSf.red    <= 0;
        ccRgb.rgbToSf.green  <= 0;
        ccRgb.rgbToSf.blue   <= 0;
    elsif rising_edge(clk) then
        ccRgb.rgbToSf.red    <= to_integer(unsigned(iRgb.red));
        ccRgb.rgbToSf.green  <= to_integer(unsigned(iRgb.green));
        ccRgb.rgbToSf.blue   <= to_integer(unsigned(iRgb.blue));
    end if;
end process rgbToSf_P;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncValid(0)  <= iRgb.valid;
      rgbSyncValid(1)  <= rgbSyncValid(0);
      rgbSyncValid(2)  <= rgbSyncValid(1);
      rgbSyncValid(3)  <= rgbSyncValid(2);
      rgbSyncValid(4)  <= rgbSyncValid(3);
      rgbSyncValid(5)  <= rgbSyncValid(4);
      rgbSyncValid(6)  <= rgbSyncValid(5);
      rgbSyncValid(7)  <= rgbSyncValid(6);
      rgbSyncValid(8)  <= rgbSyncValid(7);
      rgbSyncValid(9)  <= rgbSyncValid(8);
      rgbSyncValid(10) <= rgbSyncValid(9);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEol(0)  <= iRgb.eol;
      rgbSyncEol(1)  <= rgbSyncEol(0);
      rgbSyncEol(2)  <= rgbSyncEol(1);
      rgbSyncEol(3)  <= rgbSyncEol(2);
      rgbSyncEol(4)  <= rgbSyncEol(3);
      rgbSyncEol(5)  <= rgbSyncEol(4);
      rgbSyncEol(6)  <= rgbSyncEol(5);
      rgbSyncEol(7)  <= rgbSyncEol(6);
      rgbSyncEol(8)  <= rgbSyncEol(4);
      rgbSyncEol(9)  <= rgbSyncEol(8);
      rgbSyncEol(10) <= rgbSyncEol(9);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncSof(0)  <= iRgb.sof;
      rgbSyncSof(1)  <= rgbSyncSof(0);
      rgbSyncSof(2)  <= rgbSyncSof(1);
      rgbSyncSof(3)  <= rgbSyncSof(2);
      rgbSyncSof(4)  <= rgbSyncSof(3);
      rgbSyncSof(5)  <= rgbSyncSof(4);
      rgbSyncSof(6)  <= rgbSyncSof(5);
      rgbSyncSof(7)  <= rgbSyncSof(6);
      rgbSyncSof(8)  <= rgbSyncSof(4);
      rgbSyncSof(9)  <= rgbSyncSof(8);
      rgbSyncSof(10) <= rgbSyncSof(9);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEof(0)  <= iRgb.eof;
      rgbSyncEof(1)  <= rgbSyncEof(0);
      rgbSyncEof(2)  <= rgbSyncEof(1);
      rgbSyncEof(3)  <= rgbSyncEof(2);
      rgbSyncEof(4)  <= rgbSyncEof(3);
      rgbSyncEof(5)  <= rgbSyncEof(4);
      rgbSyncEof(6)  <= rgbSyncEof(5);
      rgbSyncEof(7)  <= rgbSyncEof(6);
      rgbSyncEof(8)  <= rgbSyncEof(4);
      rgbSyncEof(9)  <= rgbSyncEof(8);
      rgbSyncEof(10) <= rgbSyncEof(9);
    end if;
end process;

process (clk)begin
    if rising_edge(clk) then
        oRgb.eol     <= rgbSyncEol(6);
        oRgb.sof     <= rgbSyncSof(6);
        oRgb.eof     <= rgbSyncEof(6);
        oRgb.valid   <= rgbSyncValid(6);
    end if;
end process;

ccSfConfig_P: process (clk,rst_l)begin
    if rst_l = '0' then
        ccRgb.ccSf.k1           <= 1000;
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0;
        ccRgb.ccSf.k5           <= 1000;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0;
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 1000;
    elsif rising_edge(clk) then
    if(i_k_config_number = 0)then
        ccRgb.ccSf.k1           <= 5000; 
        ccRgb.ccSf.k2           <= -500;
        ccRgb.ccSf.k3           <= -500;
        ccRgb.ccSf.k4           <= -500; 
        ccRgb.ccSf.k5           <= 5000;
        ccRgb.ccSf.k6           <= -500;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 2000;
     elsif(i_k_config_number = 1) then
        ccRgb.ccSf.k1           <= 5000; 
        ccRgb.ccSf.k2           <= -500;
        ccRgb.ccSf.k3           <= -500;
        ccRgb.ccSf.k4           <= -500; 
        ccRgb.ccSf.k5           <= 6000;
        ccRgb.ccSf.k6           <= -500;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 2000;
     elsif(i_k_config_number = 2) then
        ccRgb.ccSf.k1           <= 4000; 
        ccRgb.ccSf.k2           <= -500;
        ccRgb.ccSf.k3           <= -500;
        ccRgb.ccSf.k4           <= -500; 
        ccRgb.ccSf.k5           <= 6000;
        ccRgb.ccSf.k6           <= -500;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 2000;
     elsif(i_k_config_number = 3) then
        ccRgb.ccSf.k1           <= 4500; 
        ccRgb.ccSf.k2           <= -500;
        ccRgb.ccSf.k3           <= -500;
        ccRgb.ccSf.k4           <= -500; 
        ccRgb.ccSf.k5           <= 6000;
        ccRgb.ccSf.k6           <= -500;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 2000;
     elsif(i_k_config_number = 4) then
        ccRgb.ccSf.k1           <= 3500; 
        ccRgb.ccSf.k2           <= -500;
        ccRgb.ccSf.k3           <= -500;
        ccRgb.ccSf.k4           <= -500; 
        ccRgb.ccSf.k5           <= 5000;
        ccRgb.ccSf.k6           <= -500;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 1500;
     elsif(i_k_config_number = 5) then
        ccRgb.ccSf.k1           <= 6000; 
        ccRgb.ccSf.k2           <= -500;
        ccRgb.ccSf.k3           <= -500;
        ccRgb.ccSf.k4           <= -500; 
        ccRgb.ccSf.k5           <= 6000;
        ccRgb.ccSf.k6           <= -500;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 2000;
     elsif(i_k_config_number = 6) then
        ccRgb.ccSf.k1           <= 5000; 
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 5000;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 2000;
     elsif(i_k_config_number = 7) then
        ccRgb.ccSf.k1           <= 4000; 
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 4000;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 2000;
     elsif(i_k_config_number = 8) then
        ccRgb.ccSf.k1           <= 6000; 
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 6000;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 3000;
     elsif(i_k_config_number = 9) then
        ccRgb.ccSf.k1           <= 8000; 
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 8000;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 5000;
     elsif(i_k_config_number = 10) then
        ccRgb.ccSf.k1           <= 8000; 
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 8000;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0; 
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 4000;
     elsif(i_k_config_number = 11) then
        ccRgb.ccSf.k1           <= 6500; 
        ccRgb.ccSf.k2           <= -1000;
        ccRgb.ccSf.k3           <= -1000;
        ccRgb.ccSf.k4           <= -1000; 
        ccRgb.ccSf.k5           <= 7000;
        ccRgb.ccSf.k6           <= -1000;
        ccRgb.ccSf.k7           <= -1000; 
        ccRgb.ccSf.k8           <= -1000;
        ccRgb.ccSf.k9           <= 3500;
     elsif(i_k_config_number = 12) then
        ccRgb.ccSf.k1           <= to_integer(unsigned(coefficients_in.k1(15 downto 0)));
        ccRgb.ccSf.k2           <= to_integer(unsigned(coefficients_in.k2(15 downto 0)));
        ccRgb.ccSf.k3           <= to_integer(signed(coefficients_in.k3(15 downto 0)));
        ccRgb.ccSf.k4           <= to_integer(unsigned(coefficients_in.k4(15 downto 0)));
        ccRgb.ccSf.k5           <= to_integer(unsigned(coefficients_in.k5(15 downto 0)));
        ccRgb.ccSf.k6           <= to_integer(signed(coefficients_in.k6(15 downto 0)));
        ccRgb.ccSf.k7           <= to_integer(signed(coefficients_in.k7(15 downto 0)));
        ccRgb.ccSf.k8           <= to_integer(signed(coefficients_in.k8(15 downto 0)));
        ccRgb.ccSf.k9           <= to_integer(unsigned(coefficients_in.k9(15 downto 0)));
     elsif(i_k_config_number = 13) then
        ccRgb.ccSf.k1           <= to_integer(signed(coefficients_in.k1(15 downto 0)));
        ccRgb.ccSf.k2           <= to_integer(unsigned(coefficients_in.k2(15 downto 0)));
        ccRgb.ccSf.k3           <= to_integer(unsigned(coefficients_in.k3(15 downto 0)));
        ccRgb.ccSf.k4           <= to_integer(unsigned(coefficients_in.k4(15 downto 0)));
        ccRgb.ccSf.k5           <= to_integer(signed(coefficients_in.k5(15 downto 0)));
        ccRgb.ccSf.k6           <= to_integer(unsigned(coefficients_in.k6(15 downto 0)));
        ccRgb.ccSf.k7           <= to_integer(unsigned(coefficients_in.k7(15 downto 0)));
        ccRgb.ccSf.k8           <= to_integer(unsigned(coefficients_in.k8(15 downto 0)));
        ccRgb.ccSf.k9           <= to_integer(signed(coefficients_in.k9(15 downto 0)));
     elsif(i_k_config_number = 14) then
        ccRgb.ccSf.k1           <= to_integer(unsigned(coefficients_in.k1(15 downto 0)));
        ccRgb.ccSf.k2           <= to_integer(unsigned(coefficients_in.k2(15 downto 0)));
        ccRgb.ccSf.k3           <= to_integer(unsigned(coefficients_in.k3(15 downto 0)));
        ccRgb.ccSf.k4           <= to_integer(unsigned(coefficients_in.k4(15 downto 0)));
        ccRgb.ccSf.k5           <= to_integer(unsigned(coefficients_in.k5(15 downto 0)));
        ccRgb.ccSf.k6           <= to_integer(unsigned(coefficients_in.k6(15 downto 0)));
        ccRgb.ccSf.k7           <= to_integer(unsigned(coefficients_in.k7(15 downto 0)));
        ccRgb.ccSf.k8           <= to_integer(unsigned(coefficients_in.k8(15 downto 0)));
        ccRgb.ccSf.k9           <= to_integer(unsigned(coefficients_in.k9(15 downto 0)));
     else
        ccRgb.ccSf.k1           <= to_integer(unsigned(coefficients_in.k1(15 downto 0)));
        ccRgb.ccSf.k2           <= to_integer(signed(coefficients_in.k2(15 downto 0)));
        ccRgb.ccSf.k3           <= to_integer(signed(coefficients_in.k3(15 downto 0)));
        ccRgb.ccSf.k4           <= to_integer(signed(coefficients_in.k4(15 downto 0)));
        ccRgb.ccSf.k5           <= to_integer(unsigned(coefficients_in.k5(15 downto 0)));
        ccRgb.ccSf.k6           <= to_integer(signed(coefficients_in.k6(15 downto 0)));
        ccRgb.ccSf.k7           <= to_integer(signed(coefficients_in.k7(15 downto 0)));
        ccRgb.ccSf.k8           <= to_integer(signed(coefficients_in.k8(15 downto 0)));
        ccRgb.ccSf.k9           <= to_integer(unsigned(coefficients_in.k9(15 downto 0)));
     end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        coefficients_out.k1 <= x"0000" & std_logic_vector(to_unsigned(ccRgb.ccSf.k1,16));
        coefficients_out.k2 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k2,16));
        coefficients_out.k3 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k3,16));
        coefficients_out.k4 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k4,16));
        coefficients_out.k5 <= x"0000" & std_logic_vector(to_unsigned(ccRgb.ccSf.k5,16));
        coefficients_out.k6 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k6,16));
        coefficients_out.k7 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k7,16));
        coefficients_out.k8 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k8,16));
        coefficients_out.k9 <= x"0000" & std_logic_vector(to_unsigned(ccRgb.ccSf.k9,16));
    end if;
end process;
ccProdSf_P: process (clk)begin
    if rising_edge(clk) then
        ccRgb.ccProdSf.k1       <= ccRgb.ccSf.k1  * ccRgb.rgbToSf.red;
        ccRgb.ccProdSf.k2       <= ccRgb.ccSf.k2  * ccRgb.rgbToSf.green;
        ccRgb.ccProdSf.k3       <= ccRgb.ccSf.k3  * ccRgb.rgbToSf.blue;
        ccRgb.ccProdSf.k4       <= ccRgb.ccSf.k4  * ccRgb.rgbToSf.red;
        ccRgb.ccProdSf.k5       <= ccRgb.ccSf.k5  * ccRgb.rgbToSf.green;
        ccRgb.ccProdSf.k6       <= ccRgb.ccSf.k6  * ccRgb.rgbToSf.blue;
        ccRgb.ccProdSf.k7       <= ccRgb.ccSf.k7  * ccRgb.rgbToSf.red;
        ccRgb.ccProdSf.k8       <= ccRgb.ccSf.k8  * ccRgb.rgbToSf.green;
        ccRgb.ccProdSf.k9       <= ccRgb.ccSf.k9  * ccRgb.rgbToSf.blue;
    end if;
end process ccProdSf_P;
process (clk)begin
    if rising_edge(clk) then
      ccRgb.rgbSnSum.red      <= ccRgb.ccProdSf.k1 + ccRgb.ccProdSf.k2 + ccRgb.ccProdSf.k3;
      ccRgb.rgbSnSum.green    <= ccRgb.ccProdSf.k4 + ccRgb.ccProdSf.k5 + ccRgb.ccProdSf.k6;
      ccRgb.rgbSnSum.blue     <= ccRgb.ccProdSf.k7 + ccRgb.ccProdSf.k8 + ccRgb.ccProdSf.k9;
    end if;
end process;
ccProdToSnP: process (clk)begin
    if rising_edge(clk) then
        ccRgb.rgbSnSumTr.red        <= to_signed(ccRgb.rgbSnSum.red, 24);
        ccRgb.rgbSnSumTr.green      <= to_signed(ccRgb.rgbSnSum.green, 24);
        ccRgb.rgbSnSumTr.blue       <= to_signed(ccRgb.rgbSnSum.blue, 24);
    end if;
end process ccProdToSnP;
ccProdToSn_P: process (clk)begin
    if rising_edge(clk) then
        ccRgb.rgb_Tr.red        <= resize(ccRgb.rgbSnSumTr.red(19 downto 10), 10);
        ccRgb.rgb_Tr.green      <= resize(ccRgb.rgbSnSumTr.green(19 downto 10), 10);
        ccRgb.rgb_Tr.blue       <= resize(ccRgb.rgbSnSumTr.blue(19 downto 10), 10);
    end if;
end process ccProdToSn_P;
rgbSnSumTr_P : process (clk)
  begin
    if rising_edge(clk) then
      if ccRgb.rgbSnSumTr.red(23) = '1' then
        rgb_ccm.red <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.red(22 downto 20)) /= 0 then
        rgb_ccm.red <= (others => '1');
      else
        rgb_ccm.red <= std_logic_vector(ccRgb.rgbSnSumTr.red(19 downto 10));
      end if;
      if ccRgb.rgbSnSumTr.green(23) = '1' then
        rgb_ccm.green <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.green(22 downto 20)) /= 0 then
        rgb_ccm.green <= (others => '1');
      else
        rgb_ccm.green <= std_logic_vector(ccRgb.rgbSnSumTr.green(19 downto 10));
      end if;
      if ccRgb.rgbSnSumTr.blue(23) = '1' then
        rgb_ccm.blue <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.blue(22 downto 20)) /= 0 then
        rgb_ccm.blue <= (others => '1');
      else
        rgb_ccm.blue <= std_logic_vector(ccRgb.rgbSnSumTr.blue(19 downto 10));
      end if;
    end if;
end process rgbSnSumTr_P;
process (clk)begin
    if rising_edge(clk) then
        oRgb.red   <= rgb_ccm.red;
        oRgb.green <= rgb_ccm.green;
        oRgb.blue  <= rgb_ccm.blue;
    end if;
end process;
end Behavioral;