--------------------------------------------------------------------------------
--
-- Filename      : recolor_rgb.vhd
-- Create Date   : 05022019 [05-02-2019]
-- Modified Date : 12302021 [12-30-2021]
-- Author        : Zakinder
--
-- Description:
-- This file instantiation
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity recolor_rgb is
  generic (
    CCC1               : boolean := false;
    CCC2               : boolean := false;
    CCC3               : boolean := false;
    CCC4               : boolean := false;
    CCC5               : boolean := false;
    CCC6               : boolean := false;
    CCC7               : boolean := false;
    CCC8               : boolean := false;
    CCM1               : boolean := false;
    CCM2               : boolean := false;
    CCM3               : boolean := false;
    CCM4               : boolean := false;
    CCM5               : boolean := false;
    CCM6               : boolean := false;
    CCM7               : boolean := false;
    CCM8               : boolean := false;
    img_width          : integer := 8);
  port (
    clk       : in std_logic;
    rst_l     : in std_logic;
    iRgb      : in channel;
    txCord    : in coord;
    oRgb      : out channel);
end recolor_rgb;
architecture Behavioral of recolor_rgb is
    signal ccm0rgb_range   : channel;
    signal ccm1rgb_range   : channel;
    signal ccm2rgb_range   : channel;
    signal ccm3rgb_range   : channel;
    signal ccm4rgb_range   : channel;
    signal ccm5rgb_range   : channel;
    signal ccm6rgb_range   : channel;
    signal ccm7rgb_range   : channel;
    signal ccm8rgb_range   : channel;
    signal ccm9rgb_range   : channel;
    signal ccm10rgb_range  : channel;
    signal ccm11rgb_range  : channel;
    signal ccm12rgb_range  : channel;
    signal ccm13rgb_range  : channel;
    signal ccm14rgb_range  : channel;
    signal ccm15rgb_range  : channel;
    signal ccm16rgb_range  : channel;
    signal ccm17rgb_range  : channel;
    signal ccm18rgb_range  : channel;
    signal ccm1brgb_range  : channel;
    signal ccm2brgb_range  : channel;
    signal ccc0rgb_range   : channel;
    signal ccc1rgb_range   : channel;
    signal ccc2rgb_range   : channel;
    signal ccc3rgb_range   : channel;
    signal ccc4rgb_range   : channel;
begin
--rgb_contrast_brightness_1inst: rgb_contrast_brightness_level_1
--generic map (
--    contrast_val  => to_sfixed(1.00,16,-3),
--    exposer_val  => 0)
--port map (                  
--    clk               => clk,
--    rst_l             => rst_l,
--    iRgb              => iRgb,
--    oRgb              => ccm0rgb_range);
--    
recolor_space_0_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccm0rgb_range);
CCC1_FRAME_ENABLE: if (CCC1 = true and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 101)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 102)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 103)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCC1_FRAME_ENABLE;
CCC2_FRAME_ENABLE: if (CCC1 = false and CCC2 = true and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 104)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 105)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 106)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCC2_FRAME_ENABLE;
CCC3_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = true and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 107)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 108)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 109)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCC3_FRAME_ENABLE;
CCC4_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = true and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 110)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 111)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 112)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCC4_FRAME_ENABLE;
CCC5_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = true and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 113)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm3rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 114)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm3rgb_range,
    oRgb                => ccm4rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 115)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm4rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCC5_FRAME_ENABLE;
CCC6_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = true and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 116)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 117)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm3rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 118)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm3rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCC6_FRAME_ENABLE;
CCC7_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = true and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 119)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 120)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 121)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCC7_FRAME_ENABLE;
CCC8_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = true) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 122)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 123)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 124)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCC8_FRAME_ENABLE;
CCM1_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = true and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 201)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 202)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 203)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCM1_FRAME_ENABLE;
CCM2_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = true and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 204)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 205)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 206)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCM2_FRAME_ENABLE;
CCM3_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = true and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 207)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 208)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 209)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCM3_FRAME_ENABLE;
CCM4_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = true and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 210)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 211)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 212)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCM4_FRAME_ENABLE;
CCM5_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = true and CCM6 = false and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 213)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 214)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 215)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCM5_FRAME_ENABLE;
CCM6_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = true and CCM7 = false and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 216)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 217)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 218)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCM6_FRAME_ENABLE;
CCM7_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = true and CCM8 = false) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 219)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 220)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 221)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCM7_FRAME_ENABLE;
CCM8_FRAME_ENABLE: if (CCC1 = false and CCC2 = false and CCC3 = false and CCC4 = false and CCC5 = false and CCC6 = false and CCC7 = false and CCC8 = false) and 
(CCM1 = false and CCM2 = false and CCM3 = false and CCM4 = false and CCM5 = false and CCM6 = false and CCM7 = false and CCM8 = true) generate
begin
--------------------------------------------------------------------------
-- DARK_CCM
--------------------------------------------------------------------------
dark_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 222)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm0rgb_range,
    oRgb                => ccm1rgb_range);
--------------------------------------------------------------------------
-- LIGHT_CCM
--------------------------------------------------------------------------
light_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 223)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1rgb_range,
    oRgb                => ccm2rgb_range);
--------------------------------------------------------------------------
-- BALANCE_CCM
--------------------------------------------------------------------------
balance_ccm_inst  : ccm_frame
generic map(
    k_config_number   => 224)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm2rgb_range,
    oRgb                => ccm6rgb_range);
end generate CCM8_FRAME_ENABLE;

recolor_space_1_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width                   => img_width,
    i_data_width                => i_data_width)
port map(
    clk                         => clk,
    reset                       => rst_l,
    iRgb                        => ccm6rgb_range,
    txCord                      => txCord,
    oRgb                        => oRgb);
    



--ccm_valid_inst: d_valid
--generic map (
--    pixelDelay   => 3)
--port map(
--    clk      => clk,
--    iRgb     => ccm15rgb_range,
--    oRgb     => ccm16rgb_range);
--ccm_syncr_inst  : sync_frames
--generic map(
--    pixelDelay          => 58)
--port map(
--    clk                 => clk,
--    reset               => rst_l,
--    iRgb                => ccm16rgb_range,
--    oRgb                => oRgb);
end Behavioral;