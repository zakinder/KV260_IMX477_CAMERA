-------------------------------------------------------------------------------
--
-- Filename    : recolor_space_cluster.vhd
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
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity recolor_space_cluster is
generic (
    neighboring_pixel_threshold : integer := 255;
    img_width                   : integer := 1920;
    i_data_width                : integer := 8);
port (
    clk                         : in  std_logic;
    reset                       : in  std_logic;
    iRgb                        : in channel;
    txCord                      : in coord;
    oRgb                        : out channel);
end recolor_space_cluster;
architecture behavioral of recolor_space_cluster is
    signal re_00_space     : channel;
    signal re_01_space     : channel;
    signal re_02_space     : channel;
    signal re_03_space     : channel;
    signal re_04_space     : channel;
    signal re_05_space     : channel;
    signal re_06_space     : channel;
    signal re_07_space     : channel;
    signal re_08_space     : channel;
    signal re_09_space     : channel;
    signal re_10_space     : channel;
    signal re_11_space     : channel;
begin 
------------------------------------------------------------------------------
recolor_space_1_inst: pixel_localization_9x9_window
generic map(
    img_width                   => img_width,
    i_data_width                => i_data_width)
port map(
    clk                         => clk,
    reset                       => reset,
    iRgb                        => iRgb,
    neighboring_pixel_threshold => 6,
    txCord                      => txCord,
    oRgb                        => re_00_space);
rgb_contrast_brightness_1_inst: rgb_contrast_brightness_level_1
generic map (
    contrast_val  => to_sfixed(0.98,16,-3),
    exposer_val  => 0)
port map (                  
    clk               => clk,
    rst_l             => reset,
    iRgb              => re_00_space,
    oRgb              => re_01_space);
rgb_range_1_inst: rgb_range
generic map (
    i_data_width       => i_data_width)
port map (                  
    clk                => clk,
    reset              => reset,
    iRgb               => re_01_space,
    oRgb               => re_02_space);
------------------------------------------------------------------------------
------------------------------------------------------------------------------
recolor_space_2_inst: pixel_localization_9x9_window
generic map(
    img_width                   => img_width,
    i_data_width                => i_data_width)
port map(
    clk                         => clk,
    reset                       => reset,
    txCord                      => txCord,
    neighboring_pixel_threshold => 7,
    iRgb                        => re_02_space,
    oRgb                        => re_03_space);
rgb_contrast_brightness_2_inst: rgb_contrast_brightness_level_1
generic map (
    contrast_val  => to_sfixed(1.02,16,-3),
    exposer_val   => 0)
port map (                  
    clk               => clk,
    rst_l             => reset,
    iRgb              => re_03_space,
    oRgb              => re_04_space);
rgb_range_2_inst: rgb_range
generic map (
    i_data_width       => i_data_width)
port map (                  
    clk                => clk,
    reset              => reset,
    iRgb               => re_04_space,
    oRgb               => re_05_space);
------------------------------------------------------------------------------
------------------------------------------------------------------------------
recolor_space_3_inst: pixel_localization_9x9_window
generic map(
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => reset,
    txCord             => txCord,
    neighboring_pixel_threshold => 8,
    iRgb               => re_05_space,
    oRgb               => re_06_space);
rgb_contrast_brightness_3_inst: rgb_contrast_brightness_level_1
generic map (
    contrast_val  => to_sfixed(1.20,16,-3),
    exposer_val   => 0)
port map (                  
    clk               => clk,
    rst_l             => reset,
    iRgb              => re_06_space,
    oRgb              => re_07_space);
rgb_range_3_inst: rgb_range
generic map (
    i_data_width       => i_data_width)
port map (                  
    clk                => clk,
    reset              => reset,
    iRgb               => re_06_space,
    oRgb               => re_08_space);
recolor_space_5_inst: pixel_localization_9x9_window
generic map(
    img_width                   => img_width,
    i_data_width                => i_data_width)
port map(
    clk                         => clk,
    reset                       => reset,
    txCord                      => txCord,
    neighboring_pixel_threshold => 10,
    iRgb                        => re_08_space,
    oRgb                        => oRgb);
end behavioral;