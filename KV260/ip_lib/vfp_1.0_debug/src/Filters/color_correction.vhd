-------------------------------------------------------------------------------
--
-- Filename    : color_correction.vhd
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
use work.float_pkg.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity color_correction is
  generic (
    i_k_config_number  : integer := 8);
  port (
    clk       : in std_logic;
    rst_l     : in std_logic;
    iRgb      : in channel;
    als       : in coefficient;
    oRgb      : out channel);
end color_correction;
architecture Behavioral of color_correction is

  signal cc                   : ccKernel;
  signal ccRgb                : ccRgbRecord;
  signal threshold            : sfixed(9 downto 0) := "0100000000";
  signal rgbSyncValid         : std_logic_vector(7 downto 0) := x"00";

begin

rgbToSf_P: process (clk,rst_l)begin
    if rst_l = '0' then
        ccRgb.rgbToSf.red    <= (others => '0');
        ccRgb.rgbToSf.green  <= (others => '0');
        ccRgb.rgbToSf.blue   <= (others => '0');
    elsif rising_edge(clk) then
        ccRgb.rgbToSf.red    <= to_sfixed("00" & iRgb.red,ccRgb.rgbToSf.red);
        ccRgb.rgbToSf.green  <= to_sfixed("00" & iRgb.green,ccRgb.rgbToSf.green);
        ccRgb.rgbToSf.blue   <= to_sfixed("00" & iRgb.blue,ccRgb.rgbToSf.blue);
    end if;
end process rgbToSf_P;
syncValid_P: process (clk,rst_l)begin
    if rising_edge(clk) then
      rgbSyncValid(0) <= iRgb.valid;
      rgbSyncValid(1) <= rgbSyncValid(0);
      rgbSyncValid(2) <= rgbSyncValid(1);
      rgbSyncValid(3) <= rgbSyncValid(2);
      rgbSyncValid(4) <= rgbSyncValid(3);
      rgbSyncValid(5) <= rgbSyncValid(4);
      rgbSyncValid(6) <= rgbSyncValid(5);
      rgbSyncValid(7) <= rgbSyncValid(6);
    end if;
end process syncValid_P;
process (rgbSyncValid)begin
    if (i_k_config_number=0) then
        oRgb.valid      <= rgbSyncValid(4);
      elsif(i_k_config_number=1)then
        oRgb.valid      <= rgbSyncValid(7);
      elsif(i_k_config_number=2)then
        oRgb.valid      <= rgbSyncValid(7);
      else
        oRgb.valid      <= rgbSyncValid(4);
    end if;
end process;




ccSfConfig_P: process (clk,rst_l)begin
    if rst_l = '0' then
        cc.ccSf.k1           <= to_sfixed(1.500,4,-3);  --  1.50
        cc.ccSf.k2           <= to_sfixed(-0.250,4,-3); -- -0.25
        cc.ccSf.k3           <= to_sfixed(-0.125,4,-3); -- -0.125
        
        cc.ccSf.k4           <= to_sfixed(-0.125,4,-3); -- -0.125
        cc.ccSf.k5           <= to_sfixed(1.500,4,-3);  --  1.50
        cc.ccSf.k6           <= to_sfixed(-0.250,4,-3); -- -0.25
        
        cc.ccSf.k7           <= to_sfixed(-0.125,4,-3); -- -0.125
        cc.ccSf.k8           <= to_sfixed(-0.250,4,-3); -- -0.25
        cc.ccSf.k9           <= to_sfixed(1.500,4,-3);  --  1.50
    elsif rising_edge(clk) then
    if(als.config = i_k_config_number) then
        cc.ccSf.k1           <= to_sfixed(als.k1(7 downto 0),cc.ccSf.k1);
        cc.ccSf.k2           <= to_sfixed(als.k2(7 downto 0),cc.ccSf.k2);
        cc.ccSf.k3           <= to_sfixed(als.k3(7 downto 0),cc.ccSf.k3);
        cc.ccSf.k4           <= to_sfixed(als.k4(7 downto 0),cc.ccSf.k4);
        cc.ccSf.k5           <= to_sfixed(als.k5(7 downto 0),cc.ccSf.k5);
        cc.ccSf.k6           <= to_sfixed(als.k6(7 downto 0),cc.ccSf.k6);
        cc.ccSf.k7           <= to_sfixed(als.k7(7 downto 0),cc.ccSf.k7);
        cc.ccSf.k8           <= to_sfixed(als.k8(7 downto 0),cc.ccSf.k8);
        cc.ccSf.k9           <= to_sfixed(als.k9(7 downto 0),cc.ccSf.k9);
    elsif(als.config = 3)then
        cc.ccSf.k1           <= to_sfixed(1.500,4,-3);  --  1.50
        cc.ccSf.k2           <= to_sfixed(-0.500,4,-3); -- -0.25
        cc.ccSf.k3           <= to_sfixed(-0.125,4,-3); -- -0.125
        
        cc.ccSf.k4           <= to_sfixed(-0.125,4,-3); -- -0.125
        cc.ccSf.k5           <= to_sfixed(1.500,4,-3);  --  1.50
        cc.ccSf.k6           <= to_sfixed(-0.500,4,-3); -- -0.25
        
        cc.ccSf.k7           <= to_sfixed(-0.125,4,-3); -- -0.125
        cc.ccSf.k8           <= to_sfixed(-0.500,4,-3); -- -0.25
        cc.ccSf.k9           <= to_sfixed(1.500,4,-3);  --  1.50
    end if;
    end if;
end process ccSfConfig_P;
ccProdSf_P: process (clk,rst_l)begin
    if rising_edge(clk) then
        cc.ccProdSf.k1       <= cc.ccSf.k1 * threshold * ccRgb.rgbToSf.red;
        cc.ccProdSf.k2       <= cc.ccSf.k2 * threshold * ccRgb.rgbToSf.green;
        cc.ccProdSf.k3       <= cc.ccSf.k3 * threshold * ccRgb.rgbToSf.blue;
        cc.ccProdSf.k4       <= cc.ccSf.k4 * threshold * ccRgb.rgbToSf.red;
        cc.ccProdSf.k5       <= cc.ccSf.k5 * threshold * ccRgb.rgbToSf.green;
        cc.ccProdSf.k6       <= cc.ccSf.k6 * threshold * ccRgb.rgbToSf.blue;
        cc.ccProdSf.k7       <= cc.ccSf.k7 * threshold * ccRgb.rgbToSf.red;
        cc.ccProdSf.k8       <= cc.ccSf.k8 * threshold * ccRgb.rgbToSf.green;
        cc.ccProdSf.k9       <= cc.ccSf.k9 * threshold * ccRgb.rgbToSf.blue;
    end if;
end process ccProdSf_P;
ccProdToSn_P: process (clk,rst_l)begin
    if rising_edge(clk) then
        cc.ccProdToSn.k1     <= to_signed(cc.ccProdSf.k1(19 downto 0), 20);
        cc.ccProdToSn.k2     <= to_signed(cc.ccProdSf.k2(19 downto 0), 20);
        cc.ccProdToSn.k3     <= to_signed(cc.ccProdSf.k3(19 downto 0), 20);
        cc.ccProdToSn.k4     <= to_signed(cc.ccProdSf.k4(19 downto 0), 20);
        cc.ccProdToSn.k5     <= to_signed(cc.ccProdSf.k5(19 downto 0), 20);
        cc.ccProdToSn.k6     <= to_signed(cc.ccProdSf.k6(19 downto 0), 20);
        cc.ccProdToSn.k7     <= to_signed(cc.ccProdSf.k7(19 downto 0), 20);
        cc.ccProdToSn.k8     <= to_signed(cc.ccProdSf.k8(19 downto 0), 20);
        cc.ccProdToSn.k9     <= to_signed(cc.ccProdSf.k9(19 downto 0), 20);
    end if;
end process ccProdToSn_P;
ccRgbSum_P: process (clk,rst_l)begin
    if rst_l = '0' then
      cc.ccProdTrSn.k1        <= (others => '0');
      cc.ccProdTrSn.k2        <= (others => '0');
      cc.ccProdTrSn.k3        <= (others => '0');
      cc.ccProdTrSn.k4        <= (others => '0');
      cc.ccProdTrSn.k5        <= (others => '0');
      cc.ccProdTrSn.k6        <= (others => '0');
      cc.ccProdTrSn.k7        <= (others => '0');
      cc.ccProdTrSn.k8        <= (others => '0');
      cc.ccProdTrSn.k9        <= (others => '0');
      ccRgb.rgbSnSum.red      <= (others => '0');
      ccRgb.rgbSnSum.green    <= (others => '0');
      ccRgb.rgbSnSum.blue     <= (others => '0');
      ccRgb.rgbSnSumTr.red    <= (others => '0');
      ccRgb.rgbSnSumTr.green  <= (others => '0');
      ccRgb.rgbSnSumTr.blue   <= (others => '0');
    elsif rising_edge(clk) then
      cc.ccProdTrSn.k1        <= cc.ccProdToSn.k1(19 downto 5);
      cc.ccProdTrSn.k2        <= cc.ccProdToSn.k2(19 downto 5);
      cc.ccProdTrSn.k3        <= cc.ccProdToSn.k3(19 downto 5);
      cc.ccProdTrSn.k4        <= cc.ccProdToSn.k4(19 downto 5);
      cc.ccProdTrSn.k5        <= cc.ccProdToSn.k5(19 downto 5);
      cc.ccProdTrSn.k6        <= cc.ccProdToSn.k6(19 downto 5);
      cc.ccProdTrSn.k7        <= cc.ccProdToSn.k7(19 downto 5);
      cc.ccProdTrSn.k8        <= cc.ccProdToSn.k8(19 downto 5);
      cc.ccProdTrSn.k9        <= cc.ccProdToSn.k9(19 downto 5);
      ccRgb.rgbSnSum.red      <= resize(cc.ccProdTrSn.k1, ADD_RESULT_WIDTH) +
                                 resize(cc.ccProdTrSn.k2, ADD_RESULT_WIDTH) +
                                 resize(cc.ccProdTrSn.k3, ADD_RESULT_WIDTH) + ROUND;
      ccRgb.rgbSnSum.green    <= resize(cc.ccProdTrSn.k4, ADD_RESULT_WIDTH) +
                                 resize(cc.ccProdTrSn.k5, ADD_RESULT_WIDTH) +
                                 resize(cc.ccProdTrSn.k6, ADD_RESULT_WIDTH) + ROUND;
      ccRgb.rgbSnSum.blue     <= resize(cc.ccProdTrSn.k7, ADD_RESULT_WIDTH) +
                                 resize(cc.ccProdTrSn.k8, ADD_RESULT_WIDTH) +
                                 resize(cc.ccProdTrSn.k9, ADD_RESULT_WIDTH) + ROUND;
      ccRgb.rgbSnSumTr.red    <= ccRgb.rgbSnSum.red(ccRgb.rgbSnSum.red'left downto FRAC_BITS_TO_KEEP);
      ccRgb.rgbSnSumTr.green  <= ccRgb.rgbSnSum.green(ccRgb.rgbSnSum.green'left downto FRAC_BITS_TO_KEEP);
      ccRgb.rgbSnSumTr.blue   <= ccRgb.rgbSnSum.blue(ccRgb.rgbSnSum.blue'left downto FRAC_BITS_TO_KEEP);
    end if;
end process ccRgbSum_P;
rgbSnSumTr_P : process (clk, rst_l)
  begin
    if rst_l = '0' then
      oRgb.red    <= (others => '0');
      oRgb.green  <= (others => '0');
      oRgb.blue   <= (others => '0');
    elsif clk'event and clk = '1' then
      if ccRgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-1) = '1' then
        oRgb.red <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        oRgb.red <= (others => '1');
      else
        oRgb.red <= std_logic_vector(ccRgb.rgbSnSumTr.red(i_data_width-1 downto 0));
      end if;
      if ccRgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-1) = '1' then
        oRgb.green <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        oRgb.green <= (others => '1');
      else
        oRgb.green <= std_logic_vector(ccRgb.rgbSnSumTr.green(i_data_width-1 downto 0));
      end if;
      if ccRgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-1) = '1' then
        oRgb.blue <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        oRgb.blue <= (others => '1');
      else
        oRgb.blue <= std_logic_vector(ccRgb.rgbSnSumTr.blue(i_data_width-1 downto 0));
      end if;
    end if;
end process rgbSnSumTr_P;
end Behavioral;