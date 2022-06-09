-------------------------------------------------------------------------------
--
-- Filename    : ccm_frame.vhd
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
entity ccm_frame is
  generic (
    k_config_number  : integer := 8);
  port (
    clk       : in std_logic;
    rst_l     : in std_logic;
    iRgb      : in channel;
    oRgb      : out channel);
end ccm_frame;
architecture Behavioral of ccm_frame is
  signal ccRgb                : ccRgbRecord;
  signal rgbSyncValid         : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncEol           : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncSof           : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncEof           : std_logic_vector(11 downto 0) := x"000";
  signal rgb_ccm_frame        : channel;
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
        oRgb.eol <= rgbSyncEol(6);
        oRgb.sof <= rgbSyncSof(6);
        oRgb.eof <= rgbSyncEof(6);
    end if;
end process;
ccSfConfig_P: process (clk,rst_l)begin
    if rst_l = '0' then
        ccRgb.ccSf.k1           <= to_sfixed(1.500,16,-3);
        ccRgb.ccSf.k2           <= to_sfixed(-0.125,16,-3); 
        ccRgb.ccSf.k3           <= to_sfixed(-0.125,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0.125,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(1.500,16,-3);  
        ccRgb.ccSf.k6           <= to_sfixed(-0.250,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(-0.125,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0.250,16,-3); 
        ccRgb.ccSf.k9           <= to_sfixed(1.500,16,-3);  
    elsif rising_edge(clk) then
    if(k_config_number = 0) then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.k1           <= to_sfixed(1.900,16,-3);  
        ccRgb.ccSf.k2           <= to_sfixed(-0.250,16,-3); 
        ccRgb.ccSf.k3           <= to_sfixed(-0.125,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0.125,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(1.900,16,-3);  
        ccRgb.ccSf.k6           <= to_sfixed(-0.250,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(-0.250,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0.125,16,-3); 
        ccRgb.ccSf.k9           <= to_sfixed(1.900,16,-3);  
    elsif(k_config_number = 1)then
    oRgb.valid <= rgbSyncValid(6);
        --ccRgb.ccSf.k1           <= to_sfixed(3000.000,16,-3); 
        --ccRgb.ccSf.k2           <= to_sfixed(-1000.000,16,-3);
        --ccRgb.ccSf.k3           <= to_sfixed(-1000.000,16,-3); 
        --
        --ccRgb.ccSf.k4           <= to_sfixed(-1000.000,16,-3); 
        --ccRgb.ccSf.k5           <= to_sfixed(3000.000,16,-3);
        --ccRgb.ccSf.k6           <= to_sfixed(-1000.000,16,-3); 
        --
        --ccRgb.ccSf.k7           <= to_sfixed(-1000.000,16,-3); 
        --ccRgb.ccSf.k8           <= to_sfixed(-1000.000,16,-3);
        --ccRgb.ccSf.k9           <= to_sfixed(3000.000,16,-3);
        --ccRgb.ccSf.k1           <= to_sfixed(1900.000,16,-3); 
        --ccRgb.ccSf.k2           <= to_sfixed(-400.000,16,-3);
        --ccRgb.ccSf.k3           <= to_sfixed(-500.000,16,-3); 
        --ccRgb.ccSf.k4           <= to_sfixed(-500.000,16,-3); 
        --ccRgb.ccSf.k5           <= to_sfixed(1900.000,16,-3);
        --ccRgb.ccSf.k6           <= to_sfixed(-400.000,16,-3); 
        --ccRgb.ccSf.k7           <= to_sfixed(-400.000,16,-3); 
        --ccRgb.ccSf.k8           <= to_sfixed(-500.000,16,-3);
        --ccRgb.ccSf.k9           <= to_sfixed(1900.000,16,-3);
        -----------------------------------
        ccRgb.ccSf.n1           <= 925;
        ccRgb.ccSf.n2           <= -425;
        ccRgb.ccSf.n3           <= -200;
        --light_ccm_frame CCC  ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    elsif(k_config_number = 2)then
    oRgb.valid <= rgbSyncValid(6);
        ----image base matrix
        --ccRgb.ccSf.k1           <= to_sfixed(3000.000,16,-3); 
        --ccRgb.ccSf.k2           <= to_sfixed(-1000.000,16,-3);
        --ccRgb.ccSf.k3           <= to_sfixed(-1000.000,16,-3); 
        ---- Green Get Extra Gain
        --ccRgb.ccSf.k4           <= to_sfixed(-700.000,16,-3); 
        --ccRgb.ccSf.k5           <= to_sfixed(3000.000,16,-3);
        --ccRgb.ccSf.k6           <= to_sfixed(-800.000,16,-3); 
        --
        --ccRgb.ccSf.k7           <= to_sfixed(-1000.000,16,-3); 
        --ccRgb.ccSf.k8           <= to_sfixed(-1000.000,16,-3);
        --ccRgb.ccSf.k9           <= to_sfixed(3000.000,16,-3);
        -- This color-space select unique per rgb color range.
       ccRgb.ccSf.k1           <= to_sfixed(300.000,16,-3); 
       ccRgb.ccSf.k2           <= to_sfixed(600.000,16,-3);
       ccRgb.ccSf.k3           <= to_sfixed(100.000,16,-3); 
       ccRgb.ccSf.k4           <= to_sfixed(-1687.000,16,-3); 
       ccRgb.ccSf.k5           <= to_sfixed(-3313.000,16,-3);
       ccRgb.ccSf.k6           <= to_sfixed(5000.000,16,-3); 
       ccRgb.ccSf.k7           <= to_sfixed(5000.000,16,-3); 
       ccRgb.ccSf.k8           <= to_sfixed(-4187.000,16,-3);
       ccRgb.ccSf.k9           <= to_sfixed(-0813.000,16,-3); 
    elsif(k_config_number = 3)then
    oRgb.valid <= rgbSyncValid(6);
        -- Contrast = 76,69,60 Exposer = 5
        --ccRgb.ccSf.k1           <= to_sfixed(0400.000,16,-3); 
        --ccRgb.ccSf.k2           <= to_sfixed(0350.000,16,-3);
        --ccRgb.ccSf.k3           <= to_sfixed(0100.000,16,-3); 
        --ccRgb.ccSf.k4           <= to_sfixed(0200.000,16,-3); 
        --ccRgb.ccSf.k5           <= to_sfixed(0750.000,16,-3);
        --ccRgb.ccSf.k6           <= to_sfixed(0100.000,16,-3); 
        --ccRgb.ccSf.k7           <= to_sfixed(0050.000,16,-3); 
        --ccRgb.ccSf.k8           <= to_sfixed(0100.000,16,-3);
        --ccRgb.ccSf.k9           <= to_sfixed(0950.000,16,-3);
      ----------------------------------------------------------
        -- This color-space select seperate red, green and blue channels.
        --ccRgb.ccSf.k1           <= to_sfixed(3000.000,16,-3); 
        --ccRgb.ccSf.k2           <= to_sfixed(-1000.000,16,-3);
        --ccRgb.ccSf.k3           <= to_sfixed(2000.000,16,-3);
        --ccRgb.ccSf.k4           <= to_sfixed(2000.000,16,-3); 
        --ccRgb.ccSf.k5           <= to_sfixed(3000.000,16,-3);
        --ccRgb.ccSf.k6           <= to_sfixed(-1000.000,16,-3);
        --ccRgb.ccSf.k7           <= to_sfixed(-1000.000,16,-3); 
        --ccRgb.ccSf.k8           <= to_sfixed(2000.000,16,-3);
        --ccRgb.ccSf.k9           <= to_sfixed(3000.000,16,-3);
        ccRgb.ccSf.k1           <= to_sfixed(5000.000,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(-3313.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-1687.000,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-1687.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(5000.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-3313.000,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(-3313.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-1687.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(5000.000,16,-3);
    elsif(k_config_number = 4)then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.n1           <= 1250;
        ccRgb.ccSf.n2           <= -850;
        ccRgb.ccSf.n3           <= -400;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    elsif(k_config_number = 5)then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.n1           <= 2500;
        ccRgb.ccSf.n2           <= -1000;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
      ----------------------------------------------------------
        --Contrast = 160,31,38 Exposer = 5
        --ccRgb.ccSf.k1           <= to_sfixed(1500.000,16,-3); 
        --ccRgb.ccSf.k2           <= to_sfixed(-250.000,16,-3);
        --ccRgb.ccSf.k3           <= to_sfixed(-250.000,16,-3); 
        --ccRgb.ccSf.k4           <= to_sfixed(-250.000,16,-3); 
        --ccRgb.ccSf.k5           <= to_sfixed(1500.000,16,-3);
        --ccRgb.ccSf.k6           <= to_sfixed(-250.000,16,-3); 
        --ccRgb.ccSf.k7           <= to_sfixed(-250.000,16,-3); 
        --ccRgb.ccSf.k8           <= to_sfixed(-250.000,16,-3);
        --ccRgb.ccSf.k9           <= to_sfixed(1500.000,16,-3);
    elsif(k_config_number = 6)then
    oRgb.valid <= rgbSyncValid(6);
        -- Contrast = 202,0,0 Exposer = 4
        ccRgb.ccSf.k1           <= to_sfixed(3000.000,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(-1000.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-1000.000,16,-3);
        ccRgb.ccSf.k4           <= to_sfixed(-1500.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(3000.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-0500.000,16,-3);
        ccRgb.ccSf.k7           <= to_sfixed(-0500.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-1500.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(3000.000,16,-3);
      ----------------------------------------------------------
        --Contrast = 202,0,0 Exposer = 4
        --ccRgb.ccSf.k1           <= to_sfixed(2500.000,16,-3); 
        --ccRgb.ccSf.k2           <= to_sfixed(-1000.000,16,-3);
        --ccRgb.ccSf.k3           <= to_sfixed(-1000.000,16,-3); 
        --ccRgb.ccSf.k4           <= to_sfixed(-1000.000,16,-3); 
        --ccRgb.ccSf.k5           <= to_sfixed(2500.000,16,-3);
        --ccRgb.ccSf.k6           <= to_sfixed(-1000.000,16,-3); 
        --ccRgb.ccSf.k7           <= to_sfixed(-1000.000,16,-3); 
        --ccRgb.ccSf.k8           <= to_sfixed(-1000.000,16,-3);
        --ccRgb.ccSf.k9           <= to_sfixed(2500.000,16,-3);
    elsif(k_config_number = 7)then
    oRgb.valid <= rgbSyncValid(6);
      -- Contrast = 230,0,0 Exposer = 6
        ccRgb.ccSf.k1           <= to_sfixed(2700.000,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(-1000.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-1000.000,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-1200.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(2700.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-1000.000,16,-3);
        ccRgb.ccSf.k7           <= to_sfixed(-1000.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-1200.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(2700.000,16,-3);
      ----------------------------------------------------------
      --Contrast = 230,0,0 Exposer = 6
      --ccRgb.ccSf.k1           <= to_sfixed(2700.000,16,-3); 
      --ccRgb.ccSf.k2           <= to_sfixed(-1000.000,16,-3);
      --ccRgb.ccSf.k3           <= to_sfixed(-1000.000,16,-3); 
      --ccRgb.ccSf.k4           <= to_sfixed(-1000.000,16,-3); 
      --ccRgb.ccSf.k5           <= to_sfixed(2700.000,16,-3);
      --ccRgb.ccSf.k6           <= to_sfixed(-1000.000,16,-3); 
      --ccRgb.ccSf.k7           <= to_sfixed(-1000.000,16,-3); 
      --ccRgb.ccSf.k8           <= to_sfixed(-1000.000,16,-3);
      --ccRgb.ccSf.k9           <= to_sfixed(2700.000,16,-3);
    elsif(k_config_number = 8)then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.n1           <= 4900;
        ccRgb.ccSf.n2           <= -3400;
        ccRgb.ccSf.n3           <= -1600;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
      ----------------------------------------------------------
      --Contrast = 240,0,0 Exposer = 6
      --ccRgb.ccSf.k1           <= to_sfixed(2800.000,16,-3); 
      --ccRgb.ccSf.k2           <= to_sfixed(-1000.000,16,-3);
      --ccRgb.ccSf.k3           <= to_sfixed(-1000.000,16,-3); 
      --ccRgb.ccSf.k4           <= to_sfixed(-1000.000,16,-3); 
      --ccRgb.ccSf.k5           <= to_sfixed(2800.000,16,-3);
      --ccRgb.ccSf.k6           <= to_sfixed(-1000.000,16,-3); 
      --ccRgb.ccSf.k7           <= to_sfixed(-1000.000,16,-3); 
      --ccRgb.ccSf.k8           <= to_sfixed(-1000.000,16,-3);
      --ccRgb.ccSf.k9           <= to_sfixed(2800.000,16,-3);
      ----------------------------------------------------------
      --assign red channel green values
      --ccRgb.ccSf.k1           <= to_sfixed(0000.000,16,-3); 
      --ccRgb.ccSf.k2           <= to_sfixed(1000.000,16,-3);
      --ccRgb.ccSf.k3           <= to_sfixed(-1000.000,16,-3); 
      --assign green channel blue values
      --ccRgb.ccSf.k4           <= to_sfixed(-1000.000,16,-3); 
      --ccRgb.ccSf.k5           <= to_sfixed(0000.000,16,-3);
      --ccRgb.ccSf.k6           <= to_sfixed(1000.000,16,-3); 
      --assign blue channel green values
      --ccRgb.ccSf.k7           <= to_sfixed(1000.000,16,-3); 
      --ccRgb.ccSf.k8           <= to_sfixed(-1000.000,16,-3);
      --ccRgb.ccSf.k9           <= to_sfixed(0000.000,16,-3);
      ----------------------------------------------------------
    elsif(k_config_number = 9) then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.k1           <= to_sfixed(1.500,16,-3);  
        ccRgb.ccSf.k2           <= to_sfixed(-0.250,16,-3); 
        ccRgb.ccSf.k3           <= to_sfixed(-0.125,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0.125,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(1.500,16,-3);  
        ccRgb.ccSf.k6           <= to_sfixed(-0.250,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(-0.250,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0.125,16,-3); 
        ccRgb.ccSf.k9           <= to_sfixed(1.500,16,-3);  
    elsif(k_config_number = 10)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_XYZ_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0412.000,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0357.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0180.000,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(0212.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(0715.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(0072.000,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0019.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(0119.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(0950.000,16,-3);
    elsif(k_config_number = 11)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_LMS_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0400.000,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0707.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-0080.000,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0228.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(1150.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(0061.000,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0000.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(0000.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(0918.000,16,-3); 
    elsif(k_config_number = 12)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- YPBPR_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0213.000,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0715.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0072.000,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0115.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-0385.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(0500.000,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0500.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0454.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(-0046.000,16,-3); 
    elsif(k_config_number = 13)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_YUV_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0299.000,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0587.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0114.000,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0147.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-0289.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(0436.000,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0615.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0515.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(-0100.000,16,-3);
    elsif(k_config_number = 14)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_YIQ_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0299.000,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0587.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0114.000,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(0595.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-0274.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-0321.000,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0211.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0522.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(-0311.000,16,-3);
    elsif(k_config_number = 15)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_YDRDB_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0299.000,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0587.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0114.000,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0450.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-0883.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(1333.000,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(-1333.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-1160.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(0217.000,16,-3);
    elsif(k_config_number = 16)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_HED_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(1880.000,16,-3);
        ccRgb.ccSf.k2           <= to_sfixed(-0070.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-0600.000,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-1020.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-1130.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-0480.000,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(-0550.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0130.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(1570.000,16,-3);
    elsif(k_config_number = 17)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_IPT_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0400.000,16,-3);
        ccRgb.ccSf.k2           <= to_sfixed(0400.000,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0200.000,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(4455.000,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-4851.000,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(3960.000,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(8056.000,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(3572.000,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(-1162.000,16,-3);
    elsif(k_config_number = 101)then
        --DARK_ccm_frame CCC1 -------------------
        ccRgb.ccSf.n1           <= 950;
        ccRgb.ccSf.n2           <= -450;
        ccRgb.ccSf.n3           <= -250;
        --DARK_ccm_frame CCC1 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 102)then
        --LIGHT_ccm_frame CCC1 ------------------
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= -50;
        ccRgb.ccSf.n3           <= -100;
        --LIGHT_ccm_frame CCC1 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 103)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= 700;
        ccRgb.ccSf.n3           <= 700;
        --balance_ccm_frame CCC1 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 104)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 820;
        ccRgb.ccSf.n2           <= -180;
        ccRgb.ccSf.n3           <= -100;
        --dark_ccm_frame CCC2 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 105)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1600;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -600;
        --light_ccm_frame CCC2 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 106)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= 800;
        ccRgb.ccSf.n3           <= 750;
        --balance_ccm_frame CCC2 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 107)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 925;
        ccRgb.ccSf.n2           <= -425;
        ccRgb.ccSf.n3           <= -200;
        --dark_ccm_frame CCC3 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 108)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= -400;
        ccRgb.ccSf.n3           <= -600;
        --light_ccm_frame CCC3 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 109)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 3200;
        ccRgb.ccSf.n2           <= 2400;
        ccRgb.ccSf.n3           <= 1600;
        --balance_ccm_frame CCC3 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(3200,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(1200,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(800,16,-3);
        
        ccRgb.ccSf.k4           <= to_sfixed(1600,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(2800,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(2000,16,-3); 
        
        ccRgb.ccSf.k7           <= to_sfixed(1400,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(1800,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(3200,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 110)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1840;
        ccRgb.ccSf.n2           <= -850;
        ccRgb.ccSf.n3           <= -400;
        --dark_ccm_frame CCC4 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 111)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= -570;
        ccRgb.ccSf.n3           <= -430;
        --light_ccm_frame CCC4 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 112)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 2400;
        ccRgb.ccSf.n2           <= 950;
        ccRgb.ccSf.n3           <= 800;
        --balance_ccm_frame CCC4 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(3400,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(950,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(800,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 113)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1600;
        ccRgb.ccSf.n2           <= -800;
        ccRgb.ccSf.n3           <= -400;
        --dark_ccm_frame CCC5 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 114)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1600;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -300;
        --light_ccm_frame CCC5 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 115)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 950;
        ccRgb.ccSf.n2           <= 650;
        ccRgb.ccSf.n3           <= 550;
        --balance_ccm_frame CCC5 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 116)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1850;
        ccRgb.ccSf.n2           <= -850;
        ccRgb.ccSf.n3           <= -400;
        --dark_ccm_frame CCC6 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 117)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1700;
        ccRgb.ccSf.n2           <= -600;
        ccRgb.ccSf.n3           <= -200;
        --light_ccm_frame CCC6 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 118)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 550;
        ccRgb.ccSf.n2           <= 375;
        ccRgb.ccSf.n3           <= 350;
        --balance_ccm_frame CCC6 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 119)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1500;
        ccRgb.ccSf.n2           <= -650;
        ccRgb.ccSf.n3           <= -650;
        --dark_ccm_frame CCC7 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 120)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1000;
        ccRgb.ccSf.n2           <= -125;
        ccRgb.ccSf.n3           <= -125;
        --light_ccm_frame CCC7 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 121)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1800;
        ccRgb.ccSf.n2           <= 1400;
        ccRgb.ccSf.n3           <= 1400;
        --balance_ccm_frame CCC7 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 122)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1650;
        ccRgb.ccSf.n2           <= -850;
        ccRgb.ccSf.n3           <= -400;
        --dark_ccm_frame CCC8 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 123)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1800;
        ccRgb.ccSf.n2           <= -200;
        ccRgb.ccSf.n3           <= -600;
        -- light_ccm_frame CCC8 -----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 124)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 800;
        ccRgb.ccSf.n2           <= 350;
        ccRgb.ccSf.n3           <= 550;
        -- balance_ccm_frame CCC8 ---------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 201)then
        --dark_ccm_frame CCC1
        ccRgb.ccSf.n1           <= 1000;
        ccRgb.ccSf.n2           <= -400;
        ccRgb.ccSf.n3           <= -350;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 202)then
        --light_ccm_frame CCC1
        ccRgb.ccSf.n1           <= 3500;
        ccRgb.ccSf.n2           <= -750;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 203)then
        --balance_ccm_frame CCC1
        ccRgb.ccSf.n1           <= 1000;
        ccRgb.ccSf.n2           <= 450;
        ccRgb.ccSf.n3           <= 500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 204)then
        --dark_ccm_frame CCC2
        ccRgb.ccSf.n1           <= 1300;
        ccRgb.ccSf.n2           <= -600;
        ccRgb.ccSf.n3           <= -550;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 205)then
        --light_ccm_frame CCC2
        ccRgb.ccSf.n1           <= 3000;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 206)then
        --balance_ccm_frame CCC2
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= 500;
        ccRgb.ccSf.n3           <= 700;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 207)then
        --dark_ccm_frame CCC3
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -450;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 208)then
        --light_ccm_frame CCC3
        ccRgb.ccSf.n1           <= 3000;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 209)then
        --balance_ccm_frame CCC3
        ccRgb.ccSf.n1           <= 900;
        ccRgb.ccSf.n2           <= 450;
        ccRgb.ccSf.n3           <= 650;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 210)then
        --dark_ccm_frame CCC4
        ccRgb.ccSf.n1           <= 1100;
        ccRgb.ccSf.n2           <= -100;
        ccRgb.ccSf.n3           <= -100;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 211)then
        --light_ccm_frame CCC4
        ccRgb.ccSf.n1           <= 2000;
        ccRgb.ccSf.n2           <= -850;
        ccRgb.ccSf.n3           <= -850;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 212)then
        --balance_ccm_frame CCC4
        ccRgb.ccSf.n1           <= 900;
        ccRgb.ccSf.n2           <= 650;
        ccRgb.ccSf.n3           <= 600;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 213)then
        --dark_ccm_frame CCC5
        ccRgb.ccSf.n1           <= 1000;
        ccRgb.ccSf.n2           <= -400;
        ccRgb.ccSf.n3           <= -350;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 214)then
        --light_ccm_frame CCC5
        ccRgb.ccSf.n1           <= 3000;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 215)then
        --balance_ccm_frame CCC5
        ccRgb.ccSf.n1           <= 900;
        ccRgb.ccSf.n2           <= 400;
        ccRgb.ccSf.n3           <= 450;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 216)then
        --dark_ccm_frame CCC6
        ccRgb.ccSf.n1           <= 900;
        ccRgb.ccSf.n2           <= -400;
        ccRgb.ccSf.n3           <= -350;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 217)then
        --light_ccm_frame CCC6
        ccRgb.ccSf.n1           <= 4000;
        ccRgb.ccSf.n2           <= -1000;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 218)then
        --balance_ccm_frame CCC6
        ccRgb.ccSf.n1           <= 1100;
        ccRgb.ccSf.n2           <= 700;
        ccRgb.ccSf.n3           <= 800;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 219)then
        --dark_ccm_frame CCC7
        ccRgb.ccSf.n1           <= 1000;
        ccRgb.ccSf.n2           <= -100;
        ccRgb.ccSf.n3           <= -100;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 220)then
        --light_ccm_frame CCC7
        ccRgb.ccSf.n1           <= 2000;
        ccRgb.ccSf.n2           <= -750;
        ccRgb.ccSf.n3           <= -1000;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 221)then
        --balance_ccm_frame CCC7
        ccRgb.ccSf.n1           <= 1250;
        ccRgb.ccSf.n2           <= 700;
        ccRgb.ccSf.n3           <= 800;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 222)then
        --dark_ccm_frame CCC8
        ccRgb.ccSf.n1           <= 500;
        ccRgb.ccSf.n2           <= 200;
        ccRgb.ccSf.n3           <= 100;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 223)then
        --light_ccm_frame CCC8
        ccRgb.ccSf.n1           <= 2600;
        ccRgb.ccSf.n2           <= -1200;
        ccRgb.ccSf.n3           <= -1200;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(k_config_number = 224)then
        --balance_ccm_frame CCC8
        ccRgb.ccSf.n1           <= 2500;
        ccRgb.ccSf.n2           <= 1400;
        ccRgb.ccSf.n3           <= 1600;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,16,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,16,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,16,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,16,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,16,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,16,-3);
    oRgb.valid <= rgbSyncValid(6);
    end if;
    end if;
end process ccSfConfig_P;
ccProdSf_P: process (clk,rst_l)begin
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
ccProdToSn_P: process (clk,rst_l)begin
    if rising_edge(clk) then
        ccRgb.ccProdToSn.k1     <= to_signed(ccRgb.ccProdSf.k1(21 downto 0), 22);
        ccRgb.ccProdToSn.k2     <= to_signed(ccRgb.ccProdSf.k2(21 downto 0), 22);
        ccRgb.ccProdToSn.k3     <= to_signed(ccRgb.ccProdSf.k3(21 downto 0), 22);
        ccRgb.ccProdToSn.k4     <= to_signed(ccRgb.ccProdSf.k4(21 downto 0), 22);
        ccRgb.ccProdToSn.k5     <= to_signed(ccRgb.ccProdSf.k5(21 downto 0), 22);
        ccRgb.ccProdToSn.k6     <= to_signed(ccRgb.ccProdSf.k6(21 downto 0), 22);
        ccRgb.ccProdToSn.k7     <= to_signed(ccRgb.ccProdSf.k7(21 downto 0), 22);
        ccRgb.ccProdToSn.k8     <= to_signed(ccRgb.ccProdSf.k8(21 downto 0), 22);
        ccRgb.ccProdToSn.k9     <= to_signed(ccRgb.ccProdSf.k9(21 downto 0), 22);
    end if;
end process ccProdToSn_P;
process (clk,rst_l)begin
    if rising_edge(clk) then
      ccRgb.ccProdTrSn.k1        <= ccRgb.ccProdToSn.k1(21 downto 7);
      ccRgb.ccProdTrSn.k2        <= ccRgb.ccProdToSn.k2(21 downto 7);
      ccRgb.ccProdTrSn.k3        <= ccRgb.ccProdToSn.k3(21 downto 7);
      ccRgb.ccProdTrSn.k4        <= ccRgb.ccProdToSn.k4(21 downto 7);
      ccRgb.ccProdTrSn.k5        <= ccRgb.ccProdToSn.k5(21 downto 7);
      ccRgb.ccProdTrSn.k6        <= ccRgb.ccProdToSn.k6(21 downto 7);
      ccRgb.ccProdTrSn.k7        <= ccRgb.ccProdToSn.k7(21 downto 7);
      ccRgb.ccProdTrSn.k8        <= ccRgb.ccProdToSn.k8(21 downto 7);
      ccRgb.ccProdTrSn.k9        <= ccRgb.ccProdToSn.k9(21 downto 7);
      ccRgb.rgbSnSum.red      <= resize(ccRgb.ccProdTrSn.k1, ADD_RESULT_WIDTH) +
                                 resize(ccRgb.ccProdTrSn.k2, ADD_RESULT_WIDTH) +
                                 resize(ccRgb.ccProdTrSn.k3, ADD_RESULT_WIDTH) + ROUND;
      ccRgb.rgbSnSum.green    <= resize(ccRgb.ccProdTrSn.k4, ADD_RESULT_WIDTH) +
                                 resize(ccRgb.ccProdTrSn.k5, ADD_RESULT_WIDTH) +
                                 resize(ccRgb.ccProdTrSn.k6, ADD_RESULT_WIDTH) + ROUND;
      ccRgb.rgbSnSum.blue     <= resize(ccRgb.ccProdTrSn.k7, ADD_RESULT_WIDTH) +
                                 resize(ccRgb.ccProdTrSn.k8, ADD_RESULT_WIDTH) +
                                 resize(ccRgb.ccProdTrSn.k9, ADD_RESULT_WIDTH) + ROUND;
      ccRgb.rgbSnSumTr.red    <= ccRgb.rgbSnSum.red(ccRgb.rgbSnSum.red'left downto FRAC_BITS_TO_KEEP);
      ccRgb.rgbSnSumTr.green  <= ccRgb.rgbSnSum.green(ccRgb.rgbSnSum.green'left downto FRAC_BITS_TO_KEEP);
      ccRgb.rgbSnSumTr.blue   <= ccRgb.rgbSnSum.blue(ccRgb.rgbSnSum.blue'left downto FRAC_BITS_TO_KEEP);
    end if;
end process;
rgbSnSumTr_P : process (clk, rst_l)
  begin
    if rising_edge(clk) then
      if ccRgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-1) = '1' then
        rgb_ccm_frame.red <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.red(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        rgb_ccm_frame.red <= (others => '1');
      else
        rgb_ccm_frame.red <= std_logic_vector(ccRgb.rgbSnSumTr.red(i_data_width-1 downto 0));
      end if;
      if ccRgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-1) = '1' then
        rgb_ccm_frame.green <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.green(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        rgb_ccm_frame.green <= (others => '1');
      else
        rgb_ccm_frame.green <= std_logic_vector(ccRgb.rgbSnSumTr.green(i_data_width-1 downto 0));
      end if;
      if ccRgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-1) = '1' then
        rgb_ccm_frame.blue <= (others => '0');
      elsif unsigned(ccRgb.rgbSnSumTr.blue(ROUND_RESULT_WIDTH-2 downto i_data_width)) /= 0 then
        rgb_ccm_frame.blue <= (others => '1');
      else
        rgb_ccm_frame.blue <= std_logic_vector(ccRgb.rgbSnSumTr.blue(i_data_width-1 downto 0));
      end if;
    end if;
end process rgbSnSumTr_P;
process (clk)begin
    if rising_edge(clk) then
        oRgb.red   <= rgb_ccm_frame.red;
        oRgb.green <= rgb_ccm_frame.green;
        oRgb.blue  <= rgb_ccm_frame.blue;
    end if;
end process;
end Behavioral;