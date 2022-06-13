-------------------------------------------------------------------------------
--
-- Filename    : sharp_mac.vhd
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

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity sharp_mac is
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    vTap0x         : in std_logic_vector(9 downto 0);
    vTap1x         : in std_logic_vector(9 downto 0);
    vTap2x         : in std_logic_vector(9 downto 0);
    kls            : in coefficient;
    DataO          : out std_logic_vector(9 downto 0));
end entity;
architecture arch of sharp_mac is
---------------------------------------------------------------------------------
    constant i_data_width : integer := 10;
    type detap is record
        vTap0x    : signed(i_data_width downto 0);
        vTap1x    : signed(i_data_width downto 0);
        vTap2x    : signed(i_data_width downto 0);
    end record;
    type s_pixel is record
        m1        : signed (20 downto 0);
        m2        : signed (20 downto 0);
        m3        : signed (20 downto 0);
        mac       : signed (i_data_width+3 downto 0);
    end record;
---------------------------------------------------------------------------------
    signal mac1X      : s_pixel;
    signal mac2X      : s_pixel;
    signal mac3X      : s_pixel;
    signal tpd1       : detap;
    signal tpd2       : detap;
    signal tpd3       : detap;
    signal o1Data     : signed(i_data_width+3 downto 0);
    signal o2Data     : signed(i_data_width+3 downto 0);
    signal Kernel_1   : signed(9 downto 0) :="0000000000";-- [ 0]
    signal Kernel_2   : signed(9 downto 0) :="1111111111";-- [-1]
    signal Kernel_3   : signed(9 downto 0) :="0000000000";-- [ 0]
    signal Kernel_4   : signed(9 downto 0) :="1111111111";-- [-1]
    signal Kernel_5   : signed(9 downto 0) :="0000000101";-- [ 5]
    signal Kernel_6   : signed(9 downto 0) :="1111111111";-- [-1]
    signal Kernel_7   : signed(9 downto 0) :="0000000000";-- [ 0]
    signal Kernel_8   : signed(9 downto 0) :="1111111111";-- [-1]
    signal Kernel_9   : signed(9 downto 0) :="0000000000";-- [ 0]
---------------------------------------------------------------------------------
begin
KUPDATE : process (clk) begin
  if rising_edge(clk) then
  if (kls.config = 2) then
      Kernel_1    <= signed(kls.k1(i_data_width-1 downto 0));
      Kernel_2    <= signed(kls.k2(i_data_width-1 downto 0));
      Kernel_3    <= signed(kls.k3(i_data_width-1 downto 0));
      Kernel_4    <= signed(kls.k4(i_data_width-1 downto 0));
      Kernel_5    <= signed(kls.k5(i_data_width-1 downto 0));
      Kernel_6    <= signed(kls.k6(i_data_width-1 downto 0));
      Kernel_7    <= signed(kls.k7(i_data_width-1 downto 0));
      Kernel_8    <= signed(kls.k8(i_data_width-1 downto 0));
      Kernel_9    <= signed(kls.k9(i_data_width-1 downto 0));
  end if;
  end if;
end process KUPDATE;
  TAP_DELAY : process (clk) begin
    if rising_edge(clk) then
        if rst_l = '0' then
            tpd1.vTap0x    <= (others => '0');
            tpd1.vTap1x    <= (others => '0');
            tpd1.vTap2x    <= (others => '0');
            tpd2.vTap0x    <= (others => '0');
            tpd2.vTap1x    <= (others => '0');
            tpd2.vTap2x    <= (others => '0');
            tpd3.vTap0x    <= (others => '0');
            tpd3.vTap1x    <= (others => '0');
            tpd3.vTap2x    <= (others => '0');
        else
            tpd1.vTap0x    <= signed('0' & vTap0x);
            tpd1.vTap1x    <= signed('0' & vTap1x);
            tpd1.vTap2x    <= signed('0' & vTap2x);
            tpd2.vTap0x    <= tpd1.vTap0x;
            tpd2.vTap1x    <= tpd1.vTap1x;
            tpd2.vTap2x    <= tpd1.vTap2x;
            tpd3.vTap0x    <= tpd2.vTap0x;
            tpd3.vTap1x    <= tpd2.vTap1x;
            tpd3.vTap2x    <= tpd2.vTap2x;
        end if;
    end if;
  end process TAP_DELAY;
  --1st Row Pixels
  MAC_X_A : process (clk) begin
    if rising_edge(clk) then
        mac1X.m1    <= (tpd1.vTap0x * Kernel_9);--1st Row 1st pixel
        mac1X.m2    <= (tpd2.vTap0x * Kernel_8);--1st Row 2nd pixel
        mac1X.m3    <= (tpd3.vTap0x * Kernel_7);--1st Row 3rd pixel
        mac1X.mac   <= mac1X.m1(i_data_width+3 downto 0) + mac1X.m2(i_data_width+3 downto 0) + mac1X.m3(i_data_width+3 downto 0);
    end if;
  end process MAC_X_A;
  MAC_X_B : process (clk) begin
    if rising_edge(clk) then
        mac2X.m1    <= (tpd1.vTap1x * Kernel_6);--2nd Row 1st pixel
        mac2X.m2    <= (tpd2.vTap1x * Kernel_5);--2nd Row 2nd pixel
        mac2X.m3    <= (tpd3.vTap1x * Kernel_4);--2nd Row 3rd pixel
        mac2X.mac   <= mac2X.m1(i_data_width+3 downto 0) + mac2X.m2(i_data_width+3 downto 0) + mac2X.m3(i_data_width+3 downto 0);
    end if;
  end process MAC_X_B;
  MAC_X_C : process (clk) begin
    if rising_edge(clk) then
        mac3X.m1    <= (tpd1.vTap2x * Kernel_3);--3rd Row 1st pixel
        mac3X.m2    <= (tpd2.vTap2x * Kernel_2);--3rd Row 2nd pixel
        mac3X.m3    <= (tpd3.vTap2x * Kernel_1);--3rd Row 3rd pixel
        mac3X.mac   <= mac3X.m1(i_data_width+3 downto 0) + mac3X.m2(i_data_width+3 downto 0) + mac3X.m3(i_data_width+3 downto 0);
    end if;
  end process MAC_X_C;
  PA_X : process (clk) begin
    if rising_edge(clk) then
        o1Data <= mac1X.mac + mac2X.mac + mac3X.mac;
    end if;
  end process PA_X;
  U_DATA : process(o1Data)begin
    if(o1Data(13) = '1')then
        o2Data <= (others => '0');
    else
        o2Data <= o1Data;
    end if;
  end process U_DATA;
  O_DATA : process(o2Data)begin
    if(o2Data(10) = '1')then
        DataO <= (others => '1');
    else
        DataO <= std_logic_vector(o2Data(9 downto 0));
    end if;
  end process O_DATA;
end architecture;