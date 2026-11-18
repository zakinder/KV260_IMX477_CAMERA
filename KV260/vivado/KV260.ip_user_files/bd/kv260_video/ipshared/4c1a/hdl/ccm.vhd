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
    coefficients_in  : in coefficient_values;
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
  signal iCoefficients        : coefficient_values;
  signal oCoefficients        : coefficient_values;
begin
process (clk)begin
    if rising_edge(clk) then
        i_k_config_number <= k_config_number;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        iCoefficients <= coefficients_in;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        coefficients_out <= oCoefficients;
    end if;
end process;
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
process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= iRgb.valid;
        for i in 0 to 10 loop
          rgbSyncValid(i+1)  <= rgbSyncValid(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEol(0)  <= iRgb.eol;
        for i in 0 to 10 loop
          rgbSyncEol(i+1)  <= rgbSyncEol(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncSof(0)  <= iRgb.sof;
        for i in 0 to 10 loop
          rgbSyncSof(i+1)  <= rgbSyncSof(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEof(0)  <= iRgb.eof;
        for i in 0 to 10 loop
          rgbSyncEof(i+1)  <= rgbSyncEof(i);
        end loop;
    end if;
end process;

process (clk)begin
    if rising_edge(clk) then
        oRgb.eol     <= rgbSyncEol(4);
        oRgb.sof     <= rgbSyncSof(4);
        oRgb.eof     <= rgbSyncEof(4);
        oRgb.valid   <= rgbSyncValid(4);
    end if;
end process;
ccSfConfig_P: process (clk,rst_l)begin
    if (rst_l = '0') then
        ccRgb.ccSf.k1           <= 1300;
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 1300;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0;
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 1300;
    elsif rising_edge(clk) then
    if(i_k_config_number = 0)then
        ccRgb.ccSf.k1           <= 1300;
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 1300;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0;
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 1300;
     elsif(i_k_config_number = 1) then
        ccRgb.ccSf.k1           <= 2000;
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 1300;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0;
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 1300;
     elsif(i_k_config_number = 2) then
        ccRgb.ccSf.k1           <= 1000;
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 1500;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0;
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 900;
     elsif(i_k_config_number = 3) then
        ccRgb.ccSf.k1           <= 1000;
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 1200;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0;
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 900;
     elsif(i_k_config_number = 4) then
        ccRgb.ccSf.k1           <= 1000;
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 1500;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0;
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 2000;
     elsif(i_k_config_number = 5) then
        ccRgb.ccSf.k1           <= 1000;
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 2000;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0;
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 2000;
     elsif(i_k_config_number = 6) then
        ccRgb.ccSf.k1           <= 1000;
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 2000;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0;
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 1500;
     elsif(i_k_config_number = 7) then
        ccRgb.ccSf.k1           <= 1000;
        ccRgb.ccSf.k2           <= 0;
        ccRgb.ccSf.k3           <= 0;
        ccRgb.ccSf.k4           <= 0; 
        ccRgb.ccSf.k5           <= 2000;
        ccRgb.ccSf.k6           <= 0;
        ccRgb.ccSf.k7           <= 0;
        ccRgb.ccSf.k8           <= 0;
        ccRgb.ccSf.k9           <= 900;
     -- elsif(i_k_config_number = 2) then
        -- ccRgb.ccSf.k1           <= 700; 
        -- ccRgb.ccSf.k2           <= 200;
        -- ccRgb.ccSf.k3           <= 300;
        -- ccRgb.ccSf.k4           <= 300; 
        -- ccRgb.ccSf.k5           <= 700;
        -- ccRgb.ccSf.k6           <= 200;
        -- ccRgb.ccSf.k7           <= 200; 
        -- ccRgb.ccSf.k8           <= 300;
        -- ccRgb.ccSf.k9           <= 700;
     -- elsif(i_k_config_number = 3) then
        -- ccRgb.ccSf.k1           <= 800; 
        -- ccRgb.ccSf.k2           <= 200;
        -- ccRgb.ccSf.k3           <= 300;
        -- ccRgb.ccSf.k4           <= 300; 
        -- ccRgb.ccSf.k5           <= 800;
        -- ccRgb.ccSf.k6           <= 200;
        -- ccRgb.ccSf.k7           <= 200; 
        -- ccRgb.ccSf.k8           <= 300;
        -- ccRgb.ccSf.k9           <= 800;
     -- elsif(i_k_config_number = 4) then
        -- ccRgb.ccSf.k1           <= 1000; 
        -- ccRgb.ccSf.k2           <= 200;
        -- ccRgb.ccSf.k3           <= 300;
        -- ccRgb.ccSf.k4           <= 300; 
        -- ccRgb.ccSf.k5           <= 1000;
        -- ccRgb.ccSf.k6           <= 200;
        -- ccRgb.ccSf.k7           <= 200; 
        -- ccRgb.ccSf.k8           <= 300;
        -- ccRgb.ccSf.k9           <= 1000;
     -- elsif(i_k_config_number = 5) then
        -- ccRgb.ccSf.k1           <= 1000; 
        -- ccRgb.ccSf.k2           <= 100;
        -- ccRgb.ccSf.k3           <= 300;
        -- ccRgb.ccSf.k4           <= 300; 
        -- ccRgb.ccSf.k5           <= 1000;
        -- ccRgb.ccSf.k6           <= 100;
        -- ccRgb.ccSf.k7           <= 100; 
        -- ccRgb.ccSf.k8           <= 300;
        -- ccRgb.ccSf.k9           <= 1000;
     -- elsif(i_k_config_number = 6) then
        -- ccRgb.ccSf.k1           <= 1000; 
        -- ccRgb.ccSf.k2           <= 100;
        -- ccRgb.ccSf.k3           <= 200;
        -- ccRgb.ccSf.k4           <= 200; 
        -- ccRgb.ccSf.k5           <= 1000;
        -- ccRgb.ccSf.k6           <= 100;
        -- ccRgb.ccSf.k7           <= 100; 
        -- ccRgb.ccSf.k8           <= 200;
        -- ccRgb.ccSf.k9           <= 1000;
     -- elsif(i_k_config_number = 7) then
        -- ccRgb.ccSf.k1           <= 1000; 
        -- ccRgb.ccSf.k2           <= 100;
        -- ccRgb.ccSf.k3           <= 100;
        -- ccRgb.ccSf.k4           <= 100; 
        -- ccRgb.ccSf.k5           <= 1000;
        -- ccRgb.ccSf.k6           <= 100;
        -- ccRgb.ccSf.k7           <= 100; 
        -- ccRgb.ccSf.k8           <= 100;
        -- ccRgb.ccSf.k9           <= 1000;
     -- elsif(i_k_config_number = 8) then
        -- ccRgb.ccSf.k1           <= 700; 
        -- ccRgb.ccSf.k2           <= 100;
        -- ccRgb.ccSf.k3           <= 200;
        -- ccRgb.ccSf.k4           <= 200; 
        -- ccRgb.ccSf.k5           <= 700;
        -- ccRgb.ccSf.k6           <= 100;
        -- ccRgb.ccSf.k7           <= 100; 
        -- ccRgb.ccSf.k8           <= 200;
        -- ccRgb.ccSf.k9           <= 700;
     -- elsif(i_k_config_number = 9) then
        -- ccRgb.ccSf.k1           <= 1700; 
        -- ccRgb.ccSf.k2           <= 200;
        -- ccRgb.ccSf.k3           <= 300;
        -- ccRgb.ccSf.k4           <= 300; 
        -- ccRgb.ccSf.k5           <= 1700;
        -- ccRgb.ccSf.k6           <= 200;
        -- ccRgb.ccSf.k7           <= 200; 
        -- ccRgb.ccSf.k8           <= 300;
        -- ccRgb.ccSf.k9           <= 1700;
     -- elsif(i_k_config_number = 10) then
        -- ccRgb.ccSf.k1           <= 2700; 
        -- ccRgb.ccSf.k2           <= 200;
        -- ccRgb.ccSf.k3           <= 300;
        -- ccRgb.ccSf.k4           <= 300; 
        -- ccRgb.ccSf.k5           <= 2700;
        -- ccRgb.ccSf.k6           <= 200;
        -- ccRgb.ccSf.k7           <= 200; 
        -- ccRgb.ccSf.k8           <= 300;
        -- ccRgb.ccSf.k9           <= 2700;
     -- elsif(i_k_config_number = 11) then
        -- ccRgb.ccSf.k1           <= 1500; 
        -- ccRgb.ccSf.k2           <= 200;
        -- ccRgb.ccSf.k3           <= 300;
        -- ccRgb.ccSf.k4           <= 300; 
        -- ccRgb.ccSf.k5           <= 1500;
        -- ccRgb.ccSf.k6           <= 200;
        -- ccRgb.ccSf.k7           <= 200; 
        -- ccRgb.ccSf.k8           <= 300;
        -- ccRgb.ccSf.k9           <= 1500; 
     -- elsif(i_k_config_number = 12) then
        -- ccRgb.ccSf.k1           <= to_integer(unsigned(iCoefficients.k1(15 downto 0)));
        -- ccRgb.ccSf.k2           <= to_integer(unsigned(iCoefficients.k2(15 downto 0)));
        -- ccRgb.ccSf.k3           <= to_integer(signed(iCoefficients.k3(15 downto 0)));
        -- ccRgb.ccSf.k4           <= to_integer(unsigned(iCoefficients.k4(15 downto 0)));
        -- ccRgb.ccSf.k5           <= to_integer(unsigned(iCoefficients.k5(15 downto 0)));
        -- ccRgb.ccSf.k6           <= to_integer(signed(iCoefficients.k6(15 downto 0)));
        -- ccRgb.ccSf.k7           <= to_integer(signed(iCoefficients.k7(15 downto 0)));
        -- ccRgb.ccSf.k8           <= to_integer(signed(iCoefficients.k8(15 downto 0)));
        -- ccRgb.ccSf.k9           <= to_integer(unsigned(iCoefficients.k9(15 downto 0)));
     -- elsif(i_k_config_number = 13) then
        -- ccRgb.ccSf.k1           <= to_integer(signed(iCoefficients.k1(15 downto 0)));
        -- ccRgb.ccSf.k2           <= to_integer(unsigned(iCoefficients.k2(15 downto 0)));
        -- ccRgb.ccSf.k3           <= to_integer(unsigned(iCoefficients.k3(15 downto 0)));
        -- ccRgb.ccSf.k4           <= to_integer(unsigned(iCoefficients.k4(15 downto 0)));
        -- ccRgb.ccSf.k5           <= to_integer(signed(iCoefficients.k5(15 downto 0)));
        -- ccRgb.ccSf.k6           <= to_integer(unsigned(iCoefficients.k6(15 downto 0)));
        -- ccRgb.ccSf.k7           <= to_integer(unsigned(iCoefficients.k7(15 downto 0)));
        -- ccRgb.ccSf.k8           <= to_integer(unsigned(iCoefficients.k8(15 downto 0)));
        -- ccRgb.ccSf.k9           <= to_integer(signed(iCoefficients.k9(15 downto 0)));
     elsif(i_k_config_number = 14) then
        ccRgb.ccSf.k1           <= to_integer(unsigned(iCoefficients.k1(15 downto 0)));
        ccRgb.ccSf.k2           <= to_integer(unsigned(iCoefficients.k2(15 downto 0)));
        ccRgb.ccSf.k3           <= to_integer(unsigned(iCoefficients.k3(15 downto 0)));
        ccRgb.ccSf.k4           <= to_integer(unsigned(iCoefficients.k4(15 downto 0)));
        ccRgb.ccSf.k5           <= to_integer(unsigned(iCoefficients.k5(15 downto 0)));
        ccRgb.ccSf.k6           <= to_integer(unsigned(iCoefficients.k6(15 downto 0)));
        ccRgb.ccSf.k7           <= to_integer(unsigned(iCoefficients.k7(15 downto 0)));
        ccRgb.ccSf.k8           <= to_integer(unsigned(iCoefficients.k8(15 downto 0)));
        ccRgb.ccSf.k9           <= to_integer(unsigned(iCoefficients.k9(15 downto 0)));
     else
        ccRgb.ccSf.k1           <= to_integer(unsigned(iCoefficients.k1(15 downto 0)));
        ccRgb.ccSf.k2           <= to_integer(signed(iCoefficients.k2(15 downto 0)));
        ccRgb.ccSf.k3           <= to_integer(signed(iCoefficients.k3(15 downto 0)));
        ccRgb.ccSf.k4           <= to_integer(signed(iCoefficients.k4(15 downto 0)));
        ccRgb.ccSf.k5           <= to_integer(unsigned(iCoefficients.k5(15 downto 0)));
        ccRgb.ccSf.k6           <= to_integer(signed(iCoefficients.k6(15 downto 0)));
        ccRgb.ccSf.k7           <= to_integer(signed(iCoefficients.k7(15 downto 0)));
        ccRgb.ccSf.k8           <= to_integer(signed(iCoefficients.k8(15 downto 0)));
        ccRgb.ccSf.k9           <= to_integer(unsigned(iCoefficients.k9(15 downto 0)));
     end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        oCoefficients.k1 <= x"0000" & std_logic_vector(to_unsigned(ccRgb.ccSf.k1,16));
        oCoefficients.k2 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k2,16));
        oCoefficients.k3 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k3,16));
        oCoefficients.k4 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k4,16));
        oCoefficients.k5 <= x"0000" & std_logic_vector(to_unsigned(ccRgb.ccSf.k5,16));
        oCoefficients.k6 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k6,16));
        oCoefficients.k7 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k7,16));
        oCoefficients.k8 <= x"FFFF" & std_logic_vector(to_unsigned(ccRgb.ccSf.k8,16));
        oCoefficients.k9 <= x"0000" & std_logic_vector(to_unsigned(ccRgb.ccSf.k9,16));
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