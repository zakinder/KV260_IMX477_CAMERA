-------------------------------------------------------------------------------
--
-- Filename    : color_k_clustering2.vhd
-- Create Date : 04282019 [04-28-2019]
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
use work.vfp_pkg.all;
entity color_k5_clustering is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    k_lut_selected : in natural;
    k_lut_in       : in std_logic_vector(23 downto 0);
    k_lut_out      : out std_logic_vector(31 downto 0);
    k_ind_w        : in natural;
    k_ind_r        : in natural;
    oRgb           : out channel);
end entity;
architecture arch of color_k5_clustering is
    signal rgbSyncEol    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncSof    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncEof    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncValid  : std_logic_vector(31 downto 0) := x"00000000";
    signal k_rgb         : rgb_k_lut(0 to 30);
    constant k_rgb_lut_1_l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (255,240,230), 
    (240,220,210), 
    (240,220,170), 
    (240,210,150),
    (240,210,180),
    (240,200,140),  
    (240,200,160),  
    (240,180,150),  
    (240,150,140), 
    (180,140,160),  
    (180,160,140),  
    (180,170,120),  
    (180,145,100),  
    (180,140, 90),  
    (180,130, 80),
    (150,140,130),  
    (150,120,110),  
    (150,100, 80),  
    (150, 80, 50),  
    (130,120,100),  
    (130,100, 80),  
    (130, 80, 60),  
    (130, 60, 30),
    (120,110,100),  
    (120,100, 90), 
    (120, 80, 70),  
    (120, 60, 30),
    (100, 90, 70),  
    (100, 70, 40),  
    (100, 50, 10)); 
    signal k_rgb_lut_2_l             : rgb_k_range(0 to 30) := (
    (  0,  0,  6),
    ( 90, 90,  0),
    ( 90, 50, 20),
    ( 90, 40, 10),
    ( 90, 40, 10),
    ( 90, 30,  0),
    ( 90, 30,  0),
    ( 90, 20,  0),
    ( 80, 80,  0),
    ( 80, 50, 20),
    ( 80, 40, 10),
    ( 80, 40, 10),
    ( 80, 30,  0),
    ( 80, 30,  0),
    ( 70, 70,  0),
    ( 70, 50, 15),
    ( 70, 30, 15),
    ( 70, 10,  0),
    ( 60, 60,  0),
    ( 60, 30, 20),
    ( 60, 20, 10),
    ( 60, 10,  0),
    ( 40, 40,  0),
    ( 40, 20, 10),
    ( 40, 10,  5),
    ( 40, 10,  0),
    ( 30, 30,  0),
    ( 30, 20, 15),
    ( 30, 15,  0),
    ( 30, 10,  0),
    ( 20, 10,  0));
    signal k_rgb_lut_2ll             : rgb_k_range(0 to 30) := (
    (  0,  0,  6),
    ( 90, 90,  0),
    ( 90, 50, 20),
    ( 90, 40, 10),
    ( 90, 40, 10),
    ( 90, 30,  0),
    ( 90, 30,  0),
    ( 90, 20,  0),
    ( 80, 80,  0),
    ( 80, 50, 20),
    ( 80, 40, 10),
    ( 80, 40, 10),
    ( 80, 30,  0),
    ( 80, 30,  0),
    ( 70, 70,  0),
    ( 70, 50, 15),
    ( 70, 30, 15),
    ( 70, 10,  0),
    ( 60, 60,  0),
    ( 60, 30, 20),
    ( 60, 20, 10),
    ( 60, 10,  0),
    ( 40, 40,  0),
    ( 40, 20, 10),
    ( 40, 10,  5),
    ( 40, 10,  0),
    ( 30, 30,  0),
    ( 30, 20, 15),
    ( 30, 15,  0),
    ( 30, 10,  0),
    ( 20, 10,  0));
    constant k_rgb_lut_22l             : rgb_k_range(0 to 30) := (
    (  0,  0,  6),
    ( 90, 90,  0),
    ( 90, 50, 20),
    ( 90, 40, 10),
    ( 90, 40, 10),
    ( 90, 30,  0),
    ( 90, 30,  0),
    ( 90, 20,  0),
    ( 80, 80,  0),
    ( 80, 50, 20),
    ( 80, 40, 10),
    ( 80, 40, 10),
    ( 80, 30,  0),
    ( 80, 30,  0),
    ( 70, 70,  0),
    ( 70, 50, 15),
    ( 70, 30, 15),
    ( 70, 10,  0),
    ( 60, 60,  0),
    ( 60, 30, 20),
    ( 60, 20, 10),
    ( 60, 10,  0),
    ( 40, 40,  0),
    ( 40, 20, 10),
    ( 40, 10,  5),
    ( 40, 10,  0),
    ( 30, 30,  0),
    ( 30, 20, 15),
    ( 30, 15,  0),
    ( 30, 10,  0),
    ( 20, 10,  0));
    constant k_rgb_lut_0_l             : rgb_k_range(0 to 30) := (
    ( 0,  0,  6),
    (255,255,255),
    (250,250,250),
    (240,240,240),
    (230,230,230),
    (220,220,220),
    (210,210,210),
    (200,200,200),
    (190,190,190),
    (180,180,180),
    (170,170,170),
    (160,160,160),
    (150,150,150),
    (140,140,140),
    (130,130,130),
    (120,120,120),
    (110,110,110),
    (100,100,100),
    ( 90, 90, 90),
    ( 80, 80, 80),
    ( 70, 70, 70),
    ( 60, 60, 60),
    ( 50, 50, 50),
    ( 40, 40, 40),
    ( 30, 30, 30),
    ( 20, 20, 20),
    ( 10, 10, 10),
    (  0,  0,  0),
    (255,255,255),
    (150,150,150),
    (100,100,100));
    signal k_rgb_lut_4_l               : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,200,  0),
    (240,180,  0),
    (230,180,  0),
    (230,170,  0),
    (230,160,  0),
    (230,180,  0),
    (200,160,  0),
    (200,150,  0),
    (200,140,  0),
    (200,130,  0),
    (200,100,  0),
    (160,160,  0),
    (160,120, 70),
    (160,110, 50),
    (160,100, 40),
    (160, 90, 30),
    (160, 50, 10),
    (150, 80, 20),
    (140,140,  0),
    (140,100, 40),
    (140, 80, 40),
    (140, 60,  0),
    (120,120,  0),
    (120, 50,  0),
    (120, 80,  0),
    (120, 70,  0),
    (100,100,  0),
    (100, 50,  0),
    (100, 90,  0),
    (100, 25,  0));
    signal k_rgb_lut_4ll               : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,200,  0),
    (240,180,  0),
    (230,180,  0),
    (230,170,  0),
    (230,160,  0),
    (230,180,  0),
    (200,160,  0),
    (200,150,  0),
    (200,140,  0),
    (200,130,  0),
    (200,100,  0),
    (160,160,  0),
    (160,120, 70),
    (160,110, 50),
    (160,100, 40),
    (160, 90, 30),
    (160, 50, 10),
    (150, 80, 20),
    (140,140,  0),
    (140,100, 40),
    (140, 80, 40),
    (140, 60,  0),
    (120,120,  0),
    (120, 50,  0),
    (120, 80,  0),
    (120, 70,  0),
    (100,100,  0),
    (100, 50,  0),
    (100, 90,  0),
    (100, 25,  0));
    signal k_rgb_lut_3ll               : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,200,  0),
    (240,180,  0),
    (230,180,  0),
    (230,170,  0),
    (230,160,  0),
    (230,180,  0),
    (200,160,  0),
    (200,150,  0),
    (200,140,  0),
    (200,130,  0),
    (200,100,  0),
    (160,160,  0),
    (160,120, 70),
    (160,110, 50),
    (160,100, 40),
    (160, 90, 30),
    (160, 50, 10),
    (150, 80, 20),
    (140,140,  0),
    (140,100, 40),
    (140, 80, 40),
    (140, 60,  0),
    (120,120,  0),
    (120, 50,  0),
    (120, 80,  0),
    (120, 70,  0),
    (100,100,  0),
    (100, 50,  0),
    (100, 90,  0),
    (100, 25,  0));
    signal k_rgb_lut_3_l               : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,200,  0),
    (240,180,  0),
    (230,180,  0),
    (230,170,  0),
    (230,160,  0),
    (230,180,  0),
    (200,160,  0),
    (200,150,  0),
    (200,140,  0),
    (200,130,  0),
    (200,100,  0),
    (160,160,  0),
    (160,120, 70),
    (160,110, 50),
    (160,100, 40),
    (160, 90, 30),
    (160, 50, 10),
    (150, 80, 20),
    (140,140,  0),
    (140,100, 40),
    (140, 80, 40),
    (140, 60,  0),
    (120,120,  0),
    (120, 50,  0),
    (120, 80,  0),
    (120, 70,  0),
    (100,100,  0),
    (100, 50,  0),
    (100, 90,  0),
    (100, 25,  0));
    constant k_rgb_lut_41l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (255,240,150),
    (240,230,140),
    (220,200,120),
    (255,230, 75),
    (240,220, 75),
    (220,120, 75),
    (200,180,158),
    (180,160,128),
    (160,140,118),
    (140,120, 98),
    (120,100, 88),
    (100, 80, 78),
    (255,210,128),
    (240,190,120),
    (220,170,110),
    (200,150,100),
    (180,130, 80),
    (160,110, 60),
    (140, 90, 40),
    (120, 70, 20),
    (100, 50,  0),
    (255,150, 75),
    (240,100, 75),
    (220, 80, 75),
    (200,140,100),
    (180,120, 80),
    (160,100, 60),
    (140, 80, 40),
    (120, 60, 20),
    (100, 40,  0));
    constant k_rgb_lut_42l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (255,251,242),
    (255,241,232),
    (255,231,202),
    (255,221,182),
    (255,211,122),
    (255,201,142),
    (255,191,132),
    (255,181,122),
    (255,171,112),
    (230,191,172),
    (230,181,162),
    (230, 81, 62),
    (220,181,142),
    (220,171,132),
    (200, 51, 12),
    (200,181, 92),
    (180,161,132),
    (180,151,122),
    (170,151,112),
    (170,141,102),
    (150, 31, 22),
    (150, 71, 42),
    (130, 91, 62),
    (130, 81, 52),
    (120, 81, 42),
    (120, 71, 32),
    (100, 51, 22),
    (100, 51, 22),
    (100, 51, 22),
    ( 40, 21, 12));
    constant k_rgb_lut_43l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,230,140),
    (240,230,140),
    (240,230,140),
    (240,220, 75),
    (240,220, 75),
    (240,220, 75),
    (200,180,158),
    (180,160,128),
    (180,160,128),
    (180,160,128),
    (120,100, 88),
    (120,100, 88),
    (240,190,120),
    (240,190,120),
    (240,190,120),
    (200,150,100),
    (200,150,100),
    (160,110, 60),
    (160,110, 60),
    (120, 70, 20),
    (120, 70, 20),
    (255,240,230),
    (246,216,192),
    (236,192,145),
    (207,150, 95),
    (161,110, 75),
    (127, 68, 34),
    (140, 80, 40),
    (120, 60, 20),
    (100, 40,  0));
    constant k_rgb_lut_44l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,230,140),
    (240,230,140),
    (240,230,140),
    (240,230,140),
    (240,230,140),
    (240,230,140),
    (180,160,128),
    (180,160,128),
    (180,160,128),
    (180,160,128),
    (180,160,128),
    (120,100, 88),
    (120,100, 88),
    (120,100, 88),
    (120,100, 88),
    (200,150,100),
    (200,150,100),
    (200,150,100),
    (200,150,100),
    (120, 70, 20),
    (120, 70, 20),
    (255,240,230),
    (246,216,192),
    (236,192,145),
    (207,150, 95),
    (161,110, 75),
    (127, 68, 34),
    (140, 80, 40),
    (120, 60, 20),
    (100, 40,  0));
    constant k_rgb_lut_45l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (255,240,150),
    (220,200,120),
    (220,200,120),
    (220,200,120),
    (220,200,120),
    (220,120, 75),
    (160,140,118),
    (160,140,118),
    (160,140,118),
    (100, 80, 78),
    (100, 80, 78),
    (100, 80, 78),
    (255,240,230),
    (255,240,230),
    (246,216,192),
    (236,192,145),
    (207,150, 95),
    (161,110, 75),
    (127, 68, 34),
    (120, 70, 20),
    (100, 50,  0),
    (255,150, 75),
    (240,100, 75),
    (220, 80, 75),
    (200,140,100),
    (180,120, 80),
    (160,100, 60),
    (140, 80, 40),
    (120, 60, 20),
    (100, 40,  0));
    constant k_rgb_lut_46l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (255,240,  0),
    (240,230,  0),
    (220,200,  0),
    (255,230,  0),
    (255,240,  0),
    (246,216,  0),
    (236,192,  0),
    (220,120,  0),
    (207,150,  0),
    (165,100,  0),
    (127, 68,  0),
    (209,168,  0),
    (200,180,  0),
    (180,160,  0),
    (160,140,  0),
    (140,120,  0),
    (120,100,  0),
    (100, 80,  0),
    (240,190,  0),
    (200,150,  0),
    (180,130,  0),
    (160,110,  0),
    (140, 90,  0),
    (240,100,  0),
    (220, 80,  0),
    (180,120,  0),
    (160,100,  0),
    (140, 80,  0),
    (120, 60,  0),
    (100, 40,  0));
    constant k_rgb_lut_47l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (255,251,242),
    (255,241,232),
    (255,231,202),
    (255,221,182),
    (209,168,138),
    (255,201,142),
    (255,191,132),
    (255,181,122),
    (255,240,230),
    (255,240,230),
    (246,216,192),
    (236,192,145),
    (220,120, 75),
    (207,150, 95),
    (200,150,100),
    (127, 68, 34),
    (209,168,138),
    (180,151,122),
    (170,151,112),
    (170,141,102),
    (200,150,100),
    (150, 71, 42),
    (130, 91, 62),
    (130, 81, 52),
    (120, 81, 42),
    (120, 71, 32),
    (100, 51, 22),
    (100, 51, 22),
    (100, 51, 22),
    ( 40, 21, 12));
    constant k_rgb_lut_48l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,230,140),
    (240,220, 75),
    (240,220, 75),
    (255,240,230),
    (255,240,230),
    (246,216,192),
    (236,192,145),
    (220,120, 75),
    (207,150, 95),
    (165,100, 80),
    (127, 68, 34),
    (209,168,138),
    (240,190,120),
    (240,190,120),
    (240,190,120),
    (200,150,100),
    (200,150,100),
    (160,110, 60),
    (160,110, 60),
    (120, 70, 20),
    (120, 70, 20),
    (255,240,230),
    (246,216,192),
    (236,192,145),
    (207,150, 95),
    (161,110, 75),
    (127, 68, 34),
    (140, 80, 40),
    (120, 60, 20),
    (100, 40,  0));
    constant k_rgb_lut_49l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,230,140),
    (240,230,140),
    (240,230,140),
    (240,230,140),
    (240,230,140),
    (240,230,140),
    (180,160,128),
    (180,160,128),
    (180,160,128),
    (180,160,128),
    (180,160,128),
    (120,100, 88),
    (120,100, 88),
    (120,100, 88),
    (120,100, 88),
    (200,150,100),
    (200,150,100),
    (200,150,100),
    (200,150,100),
    (120, 70, 20),
    (120, 70, 20),
    (255,240,230),
    (246,216,192),
    (236,192,145),
    (207,150, 95),
    (161,110, 75),
    (127, 68, 34),
    (140, 80, 40),
    (120, 60, 20),
    (100, 40,  0));
    constant k_rgb_lut_50l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (255,240,150),
    (220,200,120),
    (220,200,120),
    (220,200,120),
    (209,168,138),
    (220,120, 75),
    (165,100, 80),
    (165,100, 80),
    (165,100, 80),
    (100, 80, 78),
    (100, 80, 78),
    (100, 80, 78),
    (255,240,230),
    (255,240,230),
    (246,216,192),
    (236,192,145),
    (207,150, 95),
    (161,110, 75),
    (127, 68, 34),
    (120, 70, 20),
    (100, 50,  0),
    (255,150, 75),
    (240,100, 75),
    (220, 80, 75),
    (200,140,100),
    (180,120, 80),
    (160,100, 60),
    (140, 80, 40),
    (120, 60, 20),
    (100, 40,  0));
    constant k_rgb_lut_51l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (150,140,130),
    (148,137,120),
    (146,134,110),
    (144,131,100),
    (142,128, 90),
    (140,125, 80),
    (138,122, 70),
    (136,119, 60),
    (134,116, 50),
    (132,113, 40),
    (130,110, 30),
    (128,107, 20),
    (126,104, 10),
    (124,101, 0),
    (122, 98, 10),
    (120, 95, 20),
    (118, 92, 30),
    (116, 89, 40),
    (114, 86, 50),
    (112, 83, 60),
    (110, 80, 70),
    (108, 77, 10),
    (106, 74, 20),
    (104, 71, 30),
    (102, 68, 40),
    (100, 65, 50),
    (100, 62, 20),
    (100, 59, 30),
    (100, 56, 40),
    (100, 53, 0));
    constant k_rgb_lut_52l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,200,150),
    (200,160,120),
    (170,110, 60),
    (144,131,100),
    (142,128, 90),
    (140,125, 80),
    (138,122, 70),
    (136,119, 60),
    (134,116, 50),
    (132,113, 40),
    (130,110, 30),
    (128,107, 20),
    (126,104, 10),
    (124,101, 0),
    (122, 98, 10),
    (120, 95, 20),
    (118, 92, 30),
    (116, 89, 40),
    (114, 86, 50),
    (112, 83, 60),
    (110, 80, 70),
    (108, 77, 10),
    (106, 74, 20),
    (104, 71, 30),
    (102, 68, 40),
    (100, 65, 50),
    (100, 62, 20),
    (100, 59, 30),
    (100, 56, 40),
    (100, 53, 0));
    constant k_rgb_lut_53l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,200,150),
    (200,160,120),
    (170,110, 60),
    (144,131,100),
    (144,131,100),
    (144,131,100),
    (144,131,100),
    (128,107, 20),
    (128,107, 20),
    (128,107, 20),
    (128,107, 20),
    (128,107, 20),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (110, 80, 70),
    (108, 77, 10),
    (106, 74, 20),
    (104, 71, 30),
    (102, 68, 40),
    (100, 65, 50),
    (100, 62, 20),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40));
    constant k_rgb_lut_54l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,200,150),
    (200,160,120),
    (170,110, 60),
    (144,131,100),
    (144,131,100),
    (144,131,100),
    (144,131,100),
    (128,107, 20),
    (128,107, 20),
    (128,107, 20),
    (128,107, 20),
    (128,107, 20),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40));
    constant k_rgb_lut_55l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,200,150),
    (144,131,100),
    (144,131,100),
    (144,131,100),
    (144,131,100),
    (144,131,100),
    (144,131,100),
    (128,107, 20),
    (128,107, 20),
    (128,107, 20),
    (128,107, 20),
    (128,107, 20),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (112, 83, 60),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40),
    (100, 56, 40));
    constant k_rgb_lut_56l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,200,  0),
    (240,180,  0),
    (230,180,  0),
    (230,170,  0),
    (230,160,  0),
    (230,180,  0),
    (200,160,  0),
    (200,150,  0),
    (200,140,  0),
    (200,130,  0),
    (200,200,  0),
    (160,160,  0),
    (140,140,  0),
    (120,120,  0),
    (100,100,  0),
    (160,120, 70),
    (160,110, 50),
    (160,100, 40),
    (160, 90, 30),
    (160, 80, 20),
    (160, 70, 10),
    (140,100, 40),
    (140,100, 30),
    (140,100, 20),
    (140,100, 10),
    (120, 80,  0),
    (120, 70,  0),
    (100, 90,  0),
    (100, 80,  0),
    (100, 70,  0));
    constant k_rgb_lut_57l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,240,  0),
    (240,200,  0),
    (240,180,  0),
    (230,230,  0),
    (230,160,  0),
    (230,180,  0),
    (200,160,  0),
    (200,150,  0),
    (200,140,  0),
    (200,130,  0),
    (200,200,  0),
    (160,160,  0),
    (140,140,  0),
    (120,120,  0),
    (100,100,  0),
    (160,120,  0),
    (160,110,  0),
    (160,100,  0),
    (160, 90,  0),
    (160, 80,  0),
    (160, 70,  0),
    (140,100,  0),
    (140,100,  0),
    (140,100,  0),
    (140,100,  0),
    (120, 80,  0),
    (120, 70,  0),
    (100, 90,  0),
    (100, 80,  0),
    (100, 70,  0));
    constant k_rgb_lut_58l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,240,  0),
    (240,200,  0),
    (240,180,  0),
    (230,230,  0),
    (230,160,  0),
    (230,180,  0),
    (255,240,230),-- required brown colors
    (246,216,192),-- required brown colors
    (236,192,145),-- required brown colors
    (220,120, 75),-- required brown colors
    (207,150, 95),-- required brown colors
    (165,100, 80),-- required brown colors
    (127, 68, 34),-- required brown colors
    (209,168,138),-- required brown colors
    (200,150,100),-- required brown colors
    (200,100,100),
    (200,200,  0),
    (160,160,  0),
    (120,120,  0),
    (100,100,  0),
    (160,120,  0),
    (160,110,  0),
    (160,100,  0),
    (160, 90,  0),
    (160, 80,  0),
    (140,100,  0),
    (100, 50, 50),
    (120, 80,  0),
    (100, 90,  0),
    (100, 80,  0));
    constant k_rgb_lut_59l             : rgb_k_range(0 to 30) := (
    (  0,  0,  0),
    (240,200,  0),
    (240,180,  0),
    (230,180,  0),
    (230,170,  0),
    (230,160,  0),
    (230,180,  0),
    (200,160,  0),
    (200,150,  0),
    (200,140,  0),
    (200,130,  0),
    (200,100,  0),
    (160,160,  0),
    (160,120, 70),
    (160,110, 50),
    (160,100, 40),
    (160, 90, 30),
    (160, 50, 10),
    (150, 80, 20),
    (140,140,  0),
    (140,100, 40),
    (140, 80, 40),
    (140, 60,  0),
    (120,120,  0),
    (120, 50,  0),
    (120, 80,  0),
    (120, 70,  0),
    (100,100,  0),
    (100, 50,  0),
    (100, 90,  0),
    (100, 25,  0));
    signal k1_rgb                : rgb_k_lut(0 to 30);
    signal k2_rgb                : rgb_k_lut(0 to 30);
    signal k3_rgb                : rgb_k_lut(0 to 30);
    signal k4_rgb                : rgb_k_lut(0 to 30);
    signal k5_rgb                : rgb_k_lut(0 to 30);
    signal k6_rgb                : rgb_k_lut(0 to 30);
    signal k7_rgb                : rgb_k_lut(0 to 30);
    signal k8_rgb                : rgb_k_lut(0 to 30);
    signal k9_rgb                : rgb_k_lut(0 to 30);
    signal k10rgb                : rgb_k_lut(0 to 30);
    signal k11rgb                : rgb_k_lut(0 to 30);
    signal k12rgb                : rgb_k_lut(0 to 30);
    signal k13rgb                : rgb_k_lut(0 to 30);
    signal k14rgb                : rgb_k_lut(0 to 30);
    signal k15rgb                : rgb_k_lut(0 to 30);
    signal k16rgb                : rgb_k_lut(0 to 30);
    signal k17rgb                : rgb_k_lut(0 to 30);
    signal k18rgb                : rgb_k_lut(0 to 30);
    signal k19rgb                : rgb_k_lut(0 to 30);
    signal k20rgb                : rgb_k_lut(0 to 30);
    signal k21rgb                : rgb_k_lut(0 to 30);
    signal k22rgb                : rgb_k_lut(0 to 30);
    signal k23rgb                : rgb_k_lut(0 to 30);
    signal k24rgb                : rgb_k_lut(0 to 30);
    signal k25rgb                : rgb_k_lut(0 to 30);
    signal k26rgb                : rgb_k_lut(0 to 30);
    signal k27rgb                : rgb_k_lut(0 to 30);
    signal rgb                   : k_val_rgb(0 to 30);
    signal thr1                  : thr_record;
    signal thr2                  : thr_record;
    signal thr3                  : thr_record;
    signal thr4                  : thr_record;
    signal thr5                  : thr_record;
    signal threshold             : integer;
    signal threshold_lms_1       : integer;
    signal threshold_lms_2       : integer;
    signal threshold_lms_3       : integer;
    signal threshold_lms_4       : integer;
    signal threshold_lms_5       : integer;
    signal threshold_lms_6       : integer;
    signal threshold_lms_7       : integer;
    signal threshold_lms_8       : integer;
    signal threshold_lms_9       : integer;
    signal threshold_lms10       : integer;
    signal threshold_lms11       : integer;
    signal threshold_lms12       : integer;
    signal threshold_lms13       : integer;
    signal threshold_lms14       : integer;
    signal threshold_lms15       : integer;
    signal threshold_lms16       : integer;
    signal threshold_lms17       : integer;
    signal threshold_lms18       : integer;
    signal threshold_lms19       : integer;
    signal threshold_lms20       : integer;
    signal threshold_lms21       : integer;
    signal threshold_red1        : integer;
    signal threshold_red2        : integer;
    signal threshold_gre1        : integer;
    signal threshold_gre2        : integer;
    signal threshold_blu1        : integer;
    signal threshold_blu2        : integer;
    signal threshold_lms         : integer;
    signal rgb_min1              : integer;
    signal rgb_max1              : integer;
    signal rgb_max2              : integer;
    signal rgb_max3              : integer;
    signal rgb_max4              : integer;
    signal rgb_max5              : integer;
    signal rgb_max6              : integer;
    signal rgb_max7              : integer;
    signal rgb_max8              : integer;
    signal rgb_max9              : integer;
    signal rgb_max10             : integer;
    signal rgb_max11             : integer;
    signal rgb_max12             : integer;
    signal rgb_max13             : integer;
    signal rgb_max14             : integer;
    signal rgb_max15             : integer;
    signal rgb_max16             : integer;
    signal rgb_max17             : integer;
    signal rgb_max18             : integer;
    signal rgb_max19             : integer;
    signal rgb_max20             : integer;
    signal rgb_max21             : integer;
    signal rgb_max22             : integer;
    signal rgb_std1sync          : channel;
    signal rgb_std2sync          : channel;
    signal rgb_std3sync          : channel;
    signal rgb_std4sync          : channel;
    signal rgb_sync1             : intChannel;
    signal rgb_sync2             : intChannel;
    signal rgb_sync3             : intChannel;
    signal rgb_sync4             : intChannel;
    signal rgb_sync5             : intChannel;
    signal rgb_sync6             : intChannel;
    signal rgb_sync7             : intChannel;
    signal rgb_sync8             : intChannel;
    signal rgb_sync9             : intChannel;
    signal rgb_sync10            : intChannel;
    signal rgb_sync11            : intChannel;
    signal rgb_sync12            : intChannel;
    signal rgb_sync13            : intChannel;
    signal rgb_sync14            : intChannel;
    signal rgb_sync15            : intChannel;
    signal rgb_sync16            : intChannel;
    signal rgb_sync17            : intChannel;
    signal rgb_sync18            : intChannel;
    signal rgb_sync19            : intChannel;
    signal rgb_sync20            : intChannel;
    signal rgb_sync21            : intChannel;
    signal rgb_sync22            : intChannel;
    signal rgb_sync23            : intChannel;
    signal rgb_red               : std_logic_vector(7 downto 0);
    signal rgb_gre               : std_logic_vector(7 downto 0);
    signal rgb_blu               : std_logic_vector(7 downto 0);
    constant K_VALUE             : integer := 11;
begin
process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= iRgb.valid;
        for i in 0 to 30 loop
          rgbSyncValid(i+1)  <= rgbSyncValid(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEol(0)  <= iRgb.eol;
        for i in 0 to 30 loop
          rgbSyncEol(i+1)  <= rgbSyncEol(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncSof(0)  <= iRgb.sof;
        for i in 0 to 30 loop
          rgbSyncSof(i+1)  <= rgbSyncSof(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEof(0)  <= iRgb.eof;
        for i in 0 to 30 loop
          rgbSyncEof(i+1)  <= rgbSyncEof(i);
        end loop;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        rgb_std1sync.red    <= iRgb.red;
        rgb_std1sync.green  <= iRgb.green;
        rgb_std1sync.blue   <= iRgb.blue;
        rgb_std1sync.valid  <= iRgb.valid;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        rgb_std2sync    <= rgb_std1sync;
        rgb_std3sync    <= rgb_std2sync;
        rgb_std4sync    <= rgb_std3sync;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
            rgb_sync1.red    <= to_integer(unsigned(rgb_std1sync.red(9 downto 2)));
            rgb_sync1.green  <= to_integer(unsigned(rgb_std1sync.green(9 downto 2)));
            rgb_sync1.blue   <= to_integer(unsigned(rgb_std1sync.blue(9 downto 2)));
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if ((rgb_sync1.red >= rgb_sync1.green) and (rgb_sync1.red >= rgb_sync1.blue)) then
            rgb_max1 <= rgb_sync1.red;
        elsif ((rgb_sync1.green >= rgb_sync1.red) and (rgb_sync1.green >= rgb_sync1.blue)) then
            rgb_max1 <= rgb_sync1.green;
        else
            rgb_max1 <= rgb_sync1.blue;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if ((rgb_sync1.red <= rgb_sync1.green) and (rgb_sync1.red <= rgb_sync1.blue)) then
            rgb_min1 <= rgb_sync1.red;
        elsif((rgb_sync1.green <= rgb_sync1.red) and (rgb_sync1.green <= rgb_sync1.blue)) then
            rgb_min1 <= rgb_sync1.green;
        else
            rgb_min1 <= rgb_sync1.blue;
        end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgb_max2        <= rgb_max1;
      rgb_max3        <= rgb_max2;
      rgb_max4        <= rgb_max3;
      rgb_max5        <= rgb_max4;
      rgb_max6        <= rgb_max5;
      rgb_max7        <= rgb_max6;
      rgb_max8        <= rgb_max7;
      rgb_max9        <= rgb_max8;
      rgb_max10       <= rgb_max9;
      rgb_max11       <= rgb_max10;
      rgb_max12       <= rgb_max11;
      rgb_max13       <= rgb_max12;
      rgb_max14       <= rgb_max13;
      rgb_max15       <= rgb_max14;
      rgb_max16       <= rgb_max15;
      rgb_max17       <= rgb_max16;
      rgb_max18       <= rgb_max17;
      rgb_max19       <= rgb_max18;
      rgb_max20       <= rgb_max19;
      rgb_max21       <= rgb_max20;
      rgb_max22       <= rgb_max21;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgb_sync2        <= rgb_sync1;
      rgb_sync3        <= rgb_sync2;
      rgb_sync4        <= rgb_sync3;
      rgb_sync5        <= rgb_sync4;
      rgb_sync6        <= rgb_sync5;
      rgb_sync7        <= rgb_sync6;
      rgb_sync8        <= rgb_sync7;
      rgb_sync9        <= rgb_sync8;
      rgb_sync10       <= rgb_sync9;
      rgb_sync11       <= rgb_sync10;
      rgb_sync12       <= rgb_sync11;
      rgb_sync13       <= rgb_sync12;
      rgb_sync14       <= rgb_sync13;
      rgb_sync15       <= rgb_sync14;
      rgb_sync16       <= rgb_sync15;
      rgb_sync17       <= rgb_sync16;
      rgb_sync18       <= rgb_sync17;
      rgb_sync19       <= rgb_sync18;
      rgb_sync20       <= rgb_sync19;
      rgb_sync21       <= rgb_sync20;
      rgb_sync22       <= rgb_sync21;
      rgb_sync23       <= rgb_sync22;
    end if;
end process;
-- best select is 18/17/16
process (clk)begin
    if rising_edge(clk) then
        if (k_ind_w <= 30)then
            k_rgb_lut_4ll(k_ind_w).max  <= to_integer((unsigned(k_lut_in(23 downto 16)))); k_rgb_lut_4ll(k_ind_w).mid <= to_integer((unsigned(k_lut_in(15 downto 8))));   k_rgb_lut_4ll(k_ind_w).min <= to_integer((unsigned(k_lut_in(7 downto 0))));
        end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        if (k_ind_w >= 31 and k_ind_w <= 60) then
            k_rgb_lut_2ll(61-k_ind_w).max  <= to_integer((unsigned(k_lut_in(23 downto 16)))); k_rgb_lut_2ll(61-k_ind_w).mid <= to_integer((unsigned(k_lut_in(15 downto 8))));   k_rgb_lut_2ll(61-k_ind_w).min <= to_integer((unsigned(k_lut_in(7 downto 0))));
        end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        if (k_ind_w >= 61 and k_ind_w <= 90) then
            k_rgb_lut_3ll(91-k_ind_w).max  <= to_integer((unsigned(k_lut_in(23 downto 16)))); k_rgb_lut_3ll(91-k_ind_w).mid <= to_integer((unsigned(k_lut_in(15 downto 8))));   k_rgb_lut_3ll(91-k_ind_w).min <= to_integer((unsigned(k_lut_in(7 downto 0))));
        end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        if (k_ind_r <= 30)then
            k_lut_out                 <= x"00" & std_logic_vector(to_unsigned(k_rgb_lut_4_l(k_ind_r).max, 8)) & std_logic_vector(to_unsigned(k_rgb_lut_4_l(k_ind_r).mid, 8)) & std_logic_vector(to_unsigned(k_rgb_lut_4_l(k_ind_r).min, 8));
        elsif(k_ind_w >= 31 and k_ind_w <= 60)then
            k_lut_out                 <= x"00" & std_logic_vector(to_unsigned(k_rgb_lut_2_l(61-k_ind_r).max, 8)) & std_logic_vector(to_unsigned(k_rgb_lut_2_l(61-k_ind_r).mid, 8)) & std_logic_vector(to_unsigned(k_rgb_lut_2_l(61-k_ind_r).min, 8));
        elsif(k_ind_w >= 61 and k_ind_w <= 90)then
            k_lut_out                 <= x"00" & std_logic_vector(to_unsigned(k_rgb_lut_3_l(91-k_ind_r).max, 8)) & std_logic_vector(to_unsigned(k_rgb_lut_3_l(91-k_ind_r).mid, 8)) & std_logic_vector(to_unsigned(k_rgb_lut_3_l(91-k_ind_r).min, 8));
        else
            k_lut_out                 <= x"00" & std_logic_vector(to_unsigned(k_rgb_lut_4_l(61-k_ind_r).max, 8)) & std_logic_vector(to_unsigned(k_rgb_lut_4_l(61-k_ind_r).mid, 8)) & std_logic_vector(to_unsigned(k_rgb_lut_4_l(61-k_ind_r).min, 8));
        end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        if (k_ind_w <= 90)then
            k_rgb_lut_4_l <= k_rgb_lut_4ll;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_2ll;
        elsif(k_ind_w = 201)then
            k_rgb_lut_4_l <= k_rgb_lut_42l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w = 202)then
            k_rgb_lut_4_l <= k_rgb_lut_43l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w = 203)then
            k_rgb_lut_4_l <= k_rgb_lut_41l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w = 204)then
            k_rgb_lut_4_l <= k_rgb_lut_42l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w = 205)then
            k_rgb_lut_4_l <= k_rgb_lut_43l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w = 206)then
            k_rgb_lut_4_l <= k_rgb_lut_44l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w = 207)then
            k_rgb_lut_4_l <= k_rgb_lut_45l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w = 208)then
            k_rgb_lut_4_l <= k_rgb_lut_46l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w = 209)then
            k_rgb_lut_4_l <= k_rgb_lut_47l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =210)then
            k_rgb_lut_4_l <= k_rgb_lut_48l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =211)then
            k_rgb_lut_4_l <= k_rgb_lut_49l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =212)then
            k_rgb_lut_4_l <= k_rgb_lut_50l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =213)then
            k_rgb_lut_4_l <= k_rgb_lut_51l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =214)then
            k_rgb_lut_4_l <= k_rgb_lut_52l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =215)then
            k_rgb_lut_4_l <= k_rgb_lut_53l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =216)then
            k_rgb_lut_4_l <= k_rgb_lut_54l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =217)then
            k_rgb_lut_4_l <= k_rgb_lut_55l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =218)then
            k_rgb_lut_4_l <= k_rgb_lut_56l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =219)then
            k_rgb_lut_4_l <= k_rgb_lut_57l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =220)then
            k_rgb_lut_4_l <= k_rgb_lut_58l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        elsif(k_ind_w =221)then
            k_rgb_lut_4_l <= k_rgb_lut_59l;
            k_rgb_lut_3_l <= k_rgb_lut_3ll;
            k_rgb_lut_2_l <= k_rgb_lut_22l;
        end if;
    end if;
end process;
-- best select is 0
process (clk)begin
    if rising_edge(clk) then
        if (k_lut_selected   = 0)then
            ---------------------------------------------------------------------------------------------------------
            if ((abs(rgb_sync2.red - rgb_sync2.green) <= 6) and (abs(rgb_sync2.red - rgb_sync2.blue) <= 6)) or (abs(rgb_sync2.red - rgb_sync2.blue) <= 6 and (abs(rgb_sync2.red - rgb_sync2.green) <= 6)) or (abs(rgb_sync2.green - rgb_sync2.blue) <= 6  and (abs(rgb_sync2.red - rgb_sync2.blue) <= 6))then
              for i in 0 to 30 loop
                k_rgb(i).red <=   k_rgb_lut_0_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_0_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_0_l(i).mid;
              end loop;
            elsif (rgb_sync2.red = rgb_max1) then
                if (rgb_max1 - rgb_min1 >= 100) then
                    if (rgb_sync2.green = rgb_min1) then
                      for i in 0 to 30 loop
                        k_rgb(i).red <=   k_rgb_lut_1_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_1_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_1_l(i).mid;
                      end loop;
                    else
                      for i in 0 to 30 loop
                        k_rgb(i).red <=   k_rgb_lut_1_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_1_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_1_l(i).min;
                      end loop;
                    end if;
                elsif (rgb_sync2.red >= 100) then
                    if (rgb_sync2.green = rgb_min1) then
                      for i in 0 to 30 loop
                        k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                      end loop;
                    else
                      for i in 0 to 30 loop
                        k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).min;
                      end loop;
                    end if;
                else
                    if (rgb_sync2.green = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).min;
                          end loop;
                    end if;                                                        
                end if;
            elsif (rgb_sync2.green = rgb_max1) then
                if (rgb_max1 - rgb_min1 >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_1_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_1_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_1_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_1_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_1_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_1_l(i).min;
                          end loop;
                    end if;
                elsif(rgb_sync2.green >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).min;
                          end loop;
                    end if;
                else
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).min;
                          end loop;
                    end if;                                                        
                end if;  
            else
                if (rgb_max1 - rgb_min1 >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_1_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_1_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_1_l(i).max;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_1_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_1_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_1_l(i).max;
                          end loop;
                    end if;
                elsif(rgb_sync2.blue >= 100) then
                        if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                          end loop;
                        else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                          end loop;
                        end if;
                else
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    end if;                                                        
                end if;                                                            
            end if;
            ---------------------------------------------------------------------------------------------------------
        elsif(k_lut_selected = 1) then
            ---------------------------------------------------------------------------------------------------------
            if ((abs(rgb_sync2.red - rgb_sync2.green) <= 6) and (abs(rgb_sync2.red - rgb_sync2.blue) <= 6)) or (abs(rgb_sync2.red - rgb_sync2.blue) <= 6 and (abs(rgb_sync2.red - rgb_sync2.green) <= 6)) or (abs(rgb_sync2.green - rgb_sync2.blue) <= 6  and (abs(rgb_sync2.red - rgb_sync2.blue) <= 6))then
                for i in 0 to 30 loop
                    k_rgb(i).red <=   k_rgb_lut_0_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_0_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_0_l(i).mid;
                end loop;
            -- RED MAX
            elsif (rgb_sync2.red = rgb_max1) then
                if (rgb_sync2.red >= 100) then
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).min;
                        end loop;
                    end if;
                else
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).min;
                        end loop;
                    end if;                                                        
                end if;
            -- GREEN MAX
            elsif (rgb_sync2.green = rgb_max1) then
                if(rgb_sync2.green >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).min;
                          end loop;
                    end if;
                else
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).min;
                          end loop;
                    end if;                                                        
                end if;
            else
            -- BLUE MAX
                if(rgb_sync2.blue >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).min;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).min;
                        end loop;
                    end if;
                else
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).min;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).min;
                          end loop;
                    end if;                                                        
                end if;                                                            
            end if;
            ---------------------------------------------------------------------------------------------------------
        elsif(k_lut_selected = 2) then
            ---------------------------------------------------------------------------------------------------------
            if (rgb_sync2.red = rgb_max1) then
                if (rgb_sync2.red >= 100) then
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).min;
                        end loop;
                    end if;
                else
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).min;
                        end loop;
                    end if;                                                        
                end if;
            -- GREEN MAX
            elsif (rgb_sync2.green = rgb_max1) then
                if(rgb_sync2.green >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).min;
                          end loop;
                    end if;
                else
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).min;
                          end loop;
                    end if;                                                        
                end if;
            else
            -- BLUE MAX
                if(rgb_sync2.blue >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                        end loop;
                    end if;
                else
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    end if;                                                        
                end if;                                                            
            end if;
            ---------------------------------------------------------------------------------------------------------
        elsif(k_lut_selected = 3) then
            ---------------------------------------------------------------------------------------------------------
            if (rgb_sync2.red = rgb_max1) then
                if (rgb_sync2.red >= 100) then
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    end if;
                else
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                        end loop;
                    end if;                                                        
                end if;
            -- GREEN MAX
            elsif (rgb_sync2.green = rgb_max1) then
                if(rgb_sync2.green >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).min;
                          end loop;
                    end if;
                else
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).min;
                          end loop;
                    end if;                                                        
                end if;
            else
            -- BLUE MAX
                if(rgb_sync2.blue >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                        end loop;
                    end if;
                else
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    end if;                                                        
                end if;                                                            
            end if;
            ---------------------------------------------------------------------------------------------------------
        elsif(k_lut_selected = 4) then
            ---------------------------------------------------------------------------------------------------------
            if (rgb_sync2.red = rgb_max1) then
                if (rgb_sync2.red >= 100) then
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    end if;
                else
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                        end loop;
                    end if;                                                        
                end if;
            -- GREEN MAX
            elsif (rgb_sync2.green = rgb_max1) then
                if(rgb_sync2.green >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).min;
                          end loop;
                    end if;
                else
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).min;
                          end loop;
                    end if;                                                        
                end if;
            else
            -- BLUE MAX
                if(rgb_sync2.blue >= 100) then
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                        end loop;
                    end if;
                else
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).mid;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    end if;                                                        
                end if;                                                            
            end if;
            ---------------------------------------------------------------------------------------------------------
        elsif(k_lut_selected = 5) then
            ---------------------------------------------------------------------------------------------------------
            if (rgb_sync2.red = rgb_max1) then
                if (rgb_sync2.red >= 170) then
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_3_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                elsif(rgb_sync2.red >= 85) then
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                else
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                        end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                end if;
            -- GREEN MAX
            elsif (rgb_sync2.green = rgb_max1) then
                if(rgb_sync2.green >= 170) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_3_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_3_l(i).mid;
                          end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                elsif(rgb_sync2.red >= 85) then
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                          end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                else
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                          end loop;
                    end if;                                                        
                end if;
            else
            -- BLUE MAX
                if(rgb_sync2.blue >= 170) then
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_3_l(i).max;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_3_l(i).max;
                        end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                elsif(rgb_sync2.red >= 85) then
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                        end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                else
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    end if;                                                        
                end if;                                                            
            end if;
            ---------------------------------------------------------------------------------------------------------
        elsif(k_lut_selected = 6) then
            ---------------------------------------------------------------------------------------------------------
            if ((abs(rgb_sync2.red - rgb_sync2.green) <= 6) and (abs(rgb_sync2.red - rgb_sync2.blue) <= 6)) or (abs(rgb_sync2.red - rgb_sync2.blue) <= 6 and (abs(rgb_sync2.red - rgb_sync2.green) <= 6)) or (abs(rgb_sync2.green - rgb_sync2.blue) <= 6  and (abs(rgb_sync2.red - rgb_sync2.blue) <= 6))then
              for i in 0 to 30 loop
                k_rgb(i).red <=   k_rgb_lut_0_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_0_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_0_l(i).mid;
              end loop;
            ---------------------------------------------------------------------------------------------------------
            elsif(rgb_sync2.red = rgb_max1) then
                if (rgb_sync2.red >= 170) then
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_3_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                elsif(rgb_sync2.red >= 85) then
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                        end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                else
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).max;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).min;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                        end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                end if;
            -- GREEN MAX
            elsif (rgb_sync2.green = rgb_max1) then
                if(rgb_sync2.green >= 170) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_3_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_3_l(i).mid;
                          end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                elsif(rgb_sync2.red >= 85) then
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).mid;
                          end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                else
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).max;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).mid;
                          end loop;
                    end if;                                                        
                end if;
            else
            -- BLUE MAX
                if(rgb_sync2.blue >= 170) then
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_3_l(i).max;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_3_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_3_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_3_l(i).max;
                        end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                elsif(rgb_sync2.red >= 85) then
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                        end loop;
                    else
                        for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_4_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_4_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_4_l(i).max;
                        end loop;
                    end if;
                    -------------------------------------------------------------------------------------------------
                else
                    -------------------------------------------------------------------------------------------------
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    else
                          for i in 0 to 30 loop
                            k_rgb(i).red <=   k_rgb_lut_2_l(i).min;   k_rgb(i).gre <=  k_rgb_lut_2_l(i).mid;   k_rgb(i).blu <=  k_rgb_lut_2_l(i).max;
                          end loop;
                    end if;                                                        
                end if;                                                            
            end if;
            ---------------------------------------------------------------------------------------------------------
        end if;
    end if;
end process;


process (clk)begin
    if rising_edge(clk) then
      k1_rgb      <= k_rgb;
      k2_rgb      <= k1_rgb;
      k3_rgb      <= k2_rgb;
      k4_rgb      <= k3_rgb;
      k5_rgb      <= k4_rgb;
      k6_rgb      <= k5_rgb;
      k7_rgb      <= k6_rgb;
      k8_rgb      <= k7_rgb;
      k9_rgb      <= k8_rgb;
      k10rgb      <= k9_rgb;
      k11rgb      <= k10rgb;
      k12rgb      <= k11rgb;
      k13rgb      <= k12rgb;
      k14rgb      <= k13rgb;
      k15rgb      <= k14rgb;
      k16rgb      <= k15rgb;
      k17rgb      <= k16rgb;
      k18rgb      <= k17rgb;
      k19rgb      <= k18rgb;
      k20rgb      <= k19rgb;
      k21rgb      <= k20rgb;
      k22rgb      <= k21rgb;
      k23rgb      <= k22rgb;
      k24rgb      <= k23rgb;
      k25rgb      <= k24rgb;
      k26rgb      <= k25rgb;
      k27rgb      <= k26rgb;
    end if;
end process;

process (clk)begin
    if rising_edge(clk) then
        rgb(1).red     <= std_logic_vector(to_unsigned(k26rgb(1).red, 8)) & "00";
        rgb(1).gre     <= std_logic_vector(to_unsigned(k26rgb(1).gre, 8)) & "00";
        rgb(1).blu     <= std_logic_vector(to_unsigned(k26rgb(1).blu, 8)) & "00";
        rgb(2).red     <= std_logic_vector(to_unsigned(k26rgb(2).red, 8)) & "00";
        rgb(2).gre     <= std_logic_vector(to_unsigned(k26rgb(2).gre, 8)) & "00";
        rgb(2).blu     <= std_logic_vector(to_unsigned(k26rgb(2).blu, 8)) & "00";
        rgb(3).red     <= std_logic_vector(to_unsigned(k26rgb(3).red, 8)) & "00";
        rgb(3).gre     <= std_logic_vector(to_unsigned(k26rgb(3).gre, 8)) & "00";
        rgb(3).blu     <= std_logic_vector(to_unsigned(k26rgb(3).blu, 8)) & "00";
        rgb(4).red     <= std_logic_vector(to_unsigned(k26rgb(4).red, 8)) & "00";
        rgb(4).gre     <= std_logic_vector(to_unsigned(k26rgb(4).gre, 8)) & "00";
        rgb(4).blu     <= std_logic_vector(to_unsigned(k26rgb(4).blu, 8)) & "00";
        rgb(5).red     <= std_logic_vector(to_unsigned(k26rgb(5).red, 8)) & "00";
        rgb(5).gre     <= std_logic_vector(to_unsigned(k26rgb(5).gre, 8)) & "00";
        rgb(5).blu     <= std_logic_vector(to_unsigned(k26rgb(5).blu, 8)) & "00";
        rgb(6).red     <= std_logic_vector(to_unsigned(k26rgb(6).red, 8)) & "00";
        rgb(6).gre     <= std_logic_vector(to_unsigned(k26rgb(6).gre, 8)) & "00";
        rgb(6).blu     <= std_logic_vector(to_unsigned(k26rgb(6).blu, 8)) & "00";
        rgb(7).red     <= std_logic_vector(to_unsigned(k26rgb(7).red, 8)) & "00";
        rgb(7).gre     <= std_logic_vector(to_unsigned(k26rgb(7).gre, 8)) & "00";
        rgb(7).blu     <= std_logic_vector(to_unsigned(k26rgb(7).blu, 8)) & "00";
        rgb(8).red     <= std_logic_vector(to_unsigned(k26rgb(8).red, 8)) & "00";
        rgb(8).gre     <= std_logic_vector(to_unsigned(k26rgb(8).gre, 8)) & "00";
        rgb(8).blu     <= std_logic_vector(to_unsigned(k26rgb(8).blu, 8)) & "00";
        rgb(9).red     <= std_logic_vector(to_unsigned(k26rgb(9).red, 8)) & "00";
        rgb(9).gre     <= std_logic_vector(to_unsigned(k26rgb(9).gre, 8)) & "00";
        rgb(9).blu     <= std_logic_vector(to_unsigned(k26rgb(9).blu, 8)) & "00";
        rgb(10).red    <= std_logic_vector(to_unsigned(k26rgb(10).red, 8)) & "00";
        rgb(10).gre    <= std_logic_vector(to_unsigned(k26rgb(10).gre, 8)) & "00";
        rgb(10).blu    <= std_logic_vector(to_unsigned(k26rgb(10).blu, 8)) & "00";
        rgb(11).red    <= std_logic_vector(to_unsigned(k26rgb(11).red, 8)) & "00";
        rgb(11).gre    <= std_logic_vector(to_unsigned(k26rgb(11).gre, 8)) & "00";
        rgb(11).blu    <= std_logic_vector(to_unsigned(k26rgb(11).blu, 8)) & "00";
        rgb(12).red    <= std_logic_vector(to_unsigned(k26rgb(12).red, 8)) & "00";
        rgb(12).gre    <= std_logic_vector(to_unsigned(k26rgb(12).gre, 8)) & "00";
        rgb(12).blu    <= std_logic_vector(to_unsigned(k26rgb(12).blu, 8)) & "00";
        rgb(13).red    <= std_logic_vector(to_unsigned(k26rgb(13).red, 8)) & "00";
        rgb(13).gre    <= std_logic_vector(to_unsigned(k26rgb(13).gre, 8)) & "00";
        rgb(13).blu    <= std_logic_vector(to_unsigned(k26rgb(13).blu, 8)) & "00";
        rgb(14).red    <= std_logic_vector(to_unsigned(k26rgb(14).red, 8)) & "00";
        rgb(14).gre    <= std_logic_vector(to_unsigned(k26rgb(14).gre, 8)) & "00";
        rgb(14).blu    <= std_logic_vector(to_unsigned(k26rgb(14).blu, 8)) & "00";
        rgb(15).red    <= std_logic_vector(to_unsigned(k26rgb(15).red, 8)) & "00";
        rgb(15).gre    <= std_logic_vector(to_unsigned(k26rgb(15).gre, 8)) & "00";
        rgb(15).blu    <= std_logic_vector(to_unsigned(k26rgb(15).blu, 8)) & "00";
        rgb(16).red    <= std_logic_vector(to_unsigned(k26rgb(16).red, 8)) & "00";
        rgb(16).gre    <= std_logic_vector(to_unsigned(k26rgb(16).gre, 8)) & "00";
        rgb(16).blu    <= std_logic_vector(to_unsigned(k26rgb(16).blu, 8)) & "00";
        rgb(17).red    <= std_logic_vector(to_unsigned(k26rgb(17).red, 8)) & "00";
        rgb(17).gre    <= std_logic_vector(to_unsigned(k26rgb(17).gre, 8)) & "00";
        rgb(17).blu    <= std_logic_vector(to_unsigned(k26rgb(17).blu, 8)) & "00";
        rgb(18).red    <= std_logic_vector(to_unsigned(k26rgb(18).red, 8)) & "00";
        rgb(18).gre    <= std_logic_vector(to_unsigned(k26rgb(18).gre, 8)) & "00";
        rgb(18).blu    <= std_logic_vector(to_unsigned(k26rgb(18).blu, 8)) & "00";
        rgb(19).red    <= std_logic_vector(to_unsigned(k26rgb(19).red, 8)) & "00";
        rgb(19).gre    <= std_logic_vector(to_unsigned(k26rgb(19).gre, 8)) & "00";
        rgb(19).blu    <= std_logic_vector(to_unsigned(k26rgb(19).blu, 8)) & "00";
        rgb(20).red    <= std_logic_vector(to_unsigned(k26rgb(20).red, 8)) & "00";
        rgb(20).gre    <= std_logic_vector(to_unsigned(k26rgb(20).gre, 8)) & "00";
        rgb(20).blu    <= std_logic_vector(to_unsigned(k26rgb(20).blu, 8)) & "00";
        rgb(21).red    <= std_logic_vector(to_unsigned(k26rgb(21).red, 8)) & "00";
        rgb(21).gre    <= std_logic_vector(to_unsigned(k26rgb(21).gre, 8)) & "00";
        rgb(21).blu    <= std_logic_vector(to_unsigned(k26rgb(21).blu, 8)) & "00";
        rgb(22).red    <= std_logic_vector(to_unsigned(k26rgb(22).red, 8)) & "00";
        rgb(22).gre    <= std_logic_vector(to_unsigned(k26rgb(22).gre, 8)) & "00";
        rgb(22).blu    <= std_logic_vector(to_unsigned(k26rgb(22).blu, 8)) & "00";
        rgb(23).red    <= std_logic_vector(to_unsigned(k26rgb(23).red, 8)) & "00";
        rgb(23).gre    <= std_logic_vector(to_unsigned(k26rgb(23).gre, 8)) & "00";
        rgb(23).blu    <= std_logic_vector(to_unsigned(k26rgb(23).blu, 8)) & "00";
        rgb(24).red    <= std_logic_vector(to_unsigned(k26rgb(24).red, 8)) & "00";
        rgb(24).gre    <= std_logic_vector(to_unsigned(k26rgb(24).gre, 8)) & "00";
        rgb(24).blu    <= std_logic_vector(to_unsigned(k26rgb(24).blu, 8)) & "00";
        rgb(25).red    <= std_logic_vector(to_unsigned(k26rgb(25).red, 8)) & "00";
        rgb(25).gre    <= std_logic_vector(to_unsigned(k26rgb(25).gre, 8)) & "00";
        rgb(25).blu    <= std_logic_vector(to_unsigned(k26rgb(25).blu, 8)) & "00";
        rgb(26).red    <= std_logic_vector(to_unsigned(k26rgb(26).red, 8)) & "00";
        rgb(26).gre    <= std_logic_vector(to_unsigned(k26rgb(26).gre, 8)) & "00";
        rgb(26).blu    <= std_logic_vector(to_unsigned(k26rgb(26).blu, 8)) & "00";
        rgb(27).red    <= std_logic_vector(to_unsigned(k26rgb(27).red, 8)) & "00";
        rgb(27).gre    <= std_logic_vector(to_unsigned(k26rgb(27).gre, 8)) & "00";
        rgb(27).blu    <= std_logic_vector(to_unsigned(k26rgb(27).blu, 8)) & "00";
        rgb(28).red    <= std_logic_vector(to_unsigned(k26rgb(28).red, 8)) & "00";
        rgb(28).gre    <= std_logic_vector(to_unsigned(k26rgb(28).gre, 8)) & "00";
        rgb(28).blu    <= std_logic_vector(to_unsigned(k26rgb(28).blu, 8)) & "00";
        rgb(29).red    <= std_logic_vector(to_unsigned(k26rgb(29).red, 8)) & "00";
        rgb(29).gre    <= std_logic_vector(to_unsigned(k26rgb(29).gre, 8)) & "00";
        rgb(29).blu    <= std_logic_vector(to_unsigned(k26rgb(29).blu, 8)) & "00";
        rgb(30).red    <= std_logic_vector(to_unsigned(k26rgb(30).red, 8)) & "00";
        rgb(30).gre    <= std_logic_vector(to_unsigned(k26rgb(30).gre, 8)) & "00";
        rgb(30).blu    <= std_logic_vector(to_unsigned(k26rgb(30).blu, 8)) & "00";
    end if;
end process;




color_k1_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(1).red,
    k_rgb.gre          => k_rgb(1).gre,
    k_rgb.blu          => k_rgb(1).blu,
    threshold          => thr1.threshold1);
color_k2_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(2).red,
    k_rgb.gre          => k_rgb(2).gre,
    k_rgb.blu          => k_rgb(2).blu,
    threshold          => thr1.threshold2);
color_k3_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(3).red,
    k_rgb.gre          => k_rgb(3).gre,
    k_rgb.blu          => k_rgb(3).blu,
    threshold          => thr1.threshold3);
color_k4_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(4).red,
    k_rgb.gre          => k_rgb(4).gre,
    k_rgb.blu          => k_rgb(4).blu,
    threshold          => thr1.threshold4);
color_k5_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(5).red,
    k_rgb.gre          => k_rgb(5).gre,
    k_rgb.blu          => k_rgb(5).blu,
    threshold          => thr1.threshold5);
color_k6_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(6).red,
    k_rgb.gre          => k_rgb(6).gre,
    k_rgb.blu          => k_rgb(6).blu,
    threshold          => thr1.threshold6);
color_k7_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(7).red,
    k_rgb.gre          => k_rgb(7).gre,
    k_rgb.blu          => k_rgb(7).blu,
    threshold          => thr1.threshold7);
color_k8_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(8).red,
    k_rgb.gre          => k_rgb(8).gre,
    k_rgb.blu          => k_rgb(8).blu,
    threshold          => thr1.threshold8);
color_k9_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(9).red,
    k_rgb.gre          => k_rgb(9).gre,
    k_rgb.blu          => k_rgb(9).blu,
    threshold          => thr1.threshold9);
color_k10_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(10).red,
    k_rgb.gre          => k_rgb(10).gre,
    k_rgb.blu          => k_rgb(10).blu,
    threshold          => thr1.threshold10);
color_k11_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(11).red,
    k_rgb.gre          => k_rgb(11).gre,
    k_rgb.blu          => k_rgb(11).blu,
    threshold          => thr1.threshold11);
color_k12_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(12).red,
    k_rgb.gre          => k_rgb(12).gre,
    k_rgb.blu          => k_rgb(12).blu,
    threshold          => thr1.threshold12);
color_k13_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(13).red,
    k_rgb.gre          => k_rgb(13).gre,
    k_rgb.blu          => k_rgb(13).blu,
    threshold          => thr1.threshold13);
color_k14_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(14).red,
    k_rgb.gre          => k_rgb(14).gre,
    k_rgb.blu          => k_rgb(14).blu,
    threshold          => thr1.threshold14);
color_k15_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(15).red,
    k_rgb.gre          => k_rgb(15).gre,
    k_rgb.blu          => k_rgb(15).blu,
    threshold          => thr1.threshold15);
color_k16clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(16).red,
    k_rgb.gre          => k_rgb(16).gre,
    k_rgb.blu          => k_rgb(16).blu,
    threshold          => thr1.threshold16);
color_k17_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(17).red,
    k_rgb.gre          => k_rgb(17).gre,
    k_rgb.blu          => k_rgb(17).blu,
    threshold          => thr1.threshold17);
color_k18_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(18).red,
    k_rgb.gre          => k_rgb(18).gre,
    k_rgb.blu          => k_rgb(18).blu,
    threshold          => thr1.threshold18);
color_k19_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(19).red,
    k_rgb.gre          => k_rgb(19).gre,
    k_rgb.blu          => k_rgb(19).blu,
    threshold          => thr1.threshold19);
color_k20_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(20).red,
    k_rgb.gre          => k_rgb(20).gre,
    k_rgb.blu          => k_rgb(20).blu,
    threshold          => thr1.threshold20);
color_k21_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(21).red,
    k_rgb.gre          => k_rgb(21).gre,
    k_rgb.blu          => k_rgb(21).blu,
    threshold          => thr1.threshold21);
color_k22_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(22).red,
    k_rgb.gre          => k_rgb(22).gre,
    k_rgb.blu          => k_rgb(22).blu,
    threshold          => thr1.threshold22);
color_k23_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(23).red,
    k_rgb.gre          => k_rgb(23).gre,
    k_rgb.blu          => k_rgb(23).blu,
    threshold          => thr1.threshold23);
color_k24_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(24).red,
    k_rgb.gre          => k_rgb(24).gre,
    k_rgb.blu          => k_rgb(24).blu,
    threshold          => thr1.threshold24);
color_k25_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(25).red,
    k_rgb.gre          => k_rgb(25).gre,
    k_rgb.blu          => k_rgb(25).blu,
    threshold          => thr1.threshold25);
color_k26_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(26).red,
    k_rgb.gre          => k_rgb(26).gre,
    k_rgb.blu          => k_rgb(26).blu,
    threshold          => thr1.threshold26);
color_k27_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(27).red,
    k_rgb.gre          => k_rgb(27).gre,
    k_rgb.blu          => k_rgb(27).blu,
    threshold          => thr1.threshold27);
color_k28_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(28).red,
    k_rgb.gre          => k_rgb(28).gre,
    k_rgb.blu          => k_rgb(28).blu,
    threshold          => thr1.threshold28);
color_k29_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(29).red,
    k_rgb.gre          => k_rgb(29).gre,
    k_rgb.blu          => k_rgb(29).blu,
    threshold          => thr1.threshold29);
color_k30_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_std4sync,
    k_rgb.red          => k_rgb(30).red,
    k_rgb.gre          => k_rgb(30).gre,
    k_rgb.blu          => k_rgb(30).blu,
    threshold          => thr1.threshold30);
process (clk) begin
    if rising_edge(clk) then
        threshold_lms_1  <= int_min_val(thr1.threshold1,thr1.threshold2,thr1.threshold3,thr1.threshold4,thr1.threshold5);
        threshold_lms_2  <= int_min_val(thr1.threshold6,thr1.threshold7,thr1.threshold8,thr1.threshold9,thr1.threshold10);
        threshold_lms_3  <= int_min_val(thr1.threshold11,thr1.threshold12,thr1.threshold13,thr1.threshold14,thr1.threshold15);
        threshold_lms_4  <= int_min_val(thr1.threshold16,thr1.threshold17,thr1.threshold18,thr1.threshold19,thr1.threshold20);
        threshold_lms_5  <= int_min_val(thr1.threshold21,thr1.threshold22,thr1.threshold23,thr1.threshold24,thr1.threshold25);
        threshold_lms_6  <= int_min_val(thr1.threshold26,thr1.threshold27,thr1.threshold28,thr1.threshold29,thr1.threshold30);
    end if; 
end process;
process (clk) begin
    if rising_edge(clk) then
        threshold_red1   <= int_min_val(threshold_lms_1,threshold_lms_2,threshold_lms_3);
        threshold_red2   <= int_min_val(threshold_lms_4,threshold_lms_5,threshold_lms_6);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        threshold_lms    <= int_min_val(threshold_red1,threshold_red2);
        threshold        <= threshold_lms;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        thr2 <= thr1;
        thr3 <= thr2;
        thr4 <= thr3;
        thr5 <= thr4;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if ((thr5.threshold1  = threshold)) then
            oRgb.red     <= rgb(1).red;
            oRgb.green   <= rgb(1).gre;
            oRgb.blue    <= rgb(1).blu;
        elsif((thr5.threshold2 = threshold)) then
            oRgb.red     <= rgb(2).red;
            oRgb.green   <= rgb(2).gre;
            oRgb.blue    <= rgb(2).blu;
        elsif((thr5.threshold3 = threshold)) then
            oRgb.red     <= rgb(3).red;
            oRgb.green   <= rgb(3).gre;
            oRgb.blue    <= rgb(3).blu;
        elsif((thr5.threshold4 = threshold)) then
            oRgb.red     <= rgb(4).red;
            oRgb.green   <= rgb(4).gre;
            oRgb.blue    <= rgb(4).blu;
        elsif((thr5.threshold5 = threshold)) then
            oRgb.red     <= rgb(5).red;
            oRgb.green   <= rgb(5).gre;
            oRgb.blue    <= rgb(5).blu;
        elsif((thr5.threshold6 = threshold)) then
            oRgb.red     <= rgb(6).red;
            oRgb.green   <= rgb(6).gre;
            oRgb.blue    <= rgb(6).blu;
        elsif((thr5.threshold7 = threshold)) then
            oRgb.red     <= rgb(7).red;
            oRgb.green   <= rgb(7).gre;
            oRgb.blue    <= rgb(7).blu;
        elsif((thr5.threshold8 = threshold)) then
            oRgb.red     <= rgb(8).red;
            oRgb.green   <= rgb(8).gre;
            oRgb.blue    <= rgb(8).blu;
        elsif((thr5.threshold9 = threshold)) then
            oRgb.red     <= rgb(9).red;
            oRgb.green   <= rgb(9).gre;
            oRgb.blue    <= rgb(9).blu;
        elsif((thr5.threshold10 = threshold)) then
            oRgb.red     <= rgb(10).red;
            oRgb.green   <= rgb(10).gre;
            oRgb.blue    <= rgb(10).blu;
        elsif((thr5.threshold11 = threshold)) then
            oRgb.red     <= rgb(11).red;
            oRgb.green   <= rgb(11).gre;
            oRgb.blue    <= rgb(11).blu;
        elsif((thr5.threshold12 = threshold)) then
            oRgb.red     <= rgb(12).red;
            oRgb.green   <= rgb(12).gre;
            oRgb.blue    <= rgb(12).blu;
        elsif((thr5.threshold13 = threshold)) then
            oRgb.red     <= rgb(13).red;
            oRgb.green   <= rgb(13).gre;
            oRgb.blue    <= rgb(13).blu;
        elsif((thr5.threshold14 = threshold)) then
            oRgb.red     <= rgb(14).red;
            oRgb.green   <= rgb(14).gre;
            oRgb.blue    <= rgb(14).blu;
        elsif((thr5.threshold15 = threshold)) then
            oRgb.red     <= rgb(15).red;
            oRgb.green   <= rgb(15).gre;
            oRgb.blue    <= rgb(15).blu;
        elsif((thr5.threshold16 = threshold)) then
            oRgb.red     <= rgb(16).red;
            oRgb.green   <= rgb(16).gre;
            oRgb.blue    <= rgb(16).blu;
        elsif((thr5.threshold17 = threshold)) then
            oRgb.red     <= rgb(17).red;
            oRgb.green   <= rgb(17).gre;
            oRgb.blue    <= rgb(17).blu;
        elsif((thr5.threshold18 = threshold)) then
            oRgb.red     <= rgb(18).red;
            oRgb.green   <= rgb(18).gre;
            oRgb.blue    <= rgb(18).blu;
        elsif((thr5.threshold19 = threshold)) then
            oRgb.red     <= rgb(19).red;
            oRgb.green   <= rgb(19).gre;
            oRgb.blue    <= rgb(19).blu;
        elsif((thr5.threshold20 = threshold)) then
            oRgb.red     <= rgb(20).red;
            oRgb.green   <= rgb(20).gre;
            oRgb.blue    <= rgb(20).blu;
        elsif((thr5.threshold21 = threshold)) then
            oRgb.red     <= rgb(21).red;
            oRgb.green   <= rgb(21).gre;
            oRgb.blue    <= rgb(21).blu;
        elsif((thr5.threshold22 = threshold)) then
            oRgb.red     <= rgb(22).red;
            oRgb.green   <= rgb(22).gre;
            oRgb.blue    <= rgb(22).blu;
        elsif((thr5.threshold23 = threshold)) then
            oRgb.red     <= rgb(23).red;
            oRgb.green   <= rgb(23).gre;
            oRgb.blue    <= rgb(23).blu;
        elsif((thr5.threshold24 = threshold)) then
            oRgb.red     <= rgb(24).red;
            oRgb.green   <= rgb(24).gre;
            oRgb.blue    <= rgb(24).blu;
        elsif((thr5.threshold25 = threshold)) then
            oRgb.red     <= rgb(25).red;
            oRgb.green   <= rgb(25).gre;
            oRgb.blue    <= rgb(25).blu;
        elsif((thr5.threshold26 = threshold)) then
            oRgb.red     <= rgb(26).red;
            oRgb.green   <= rgb(26).gre;
            oRgb.blue    <= rgb(26).blu;
        elsif((thr5.threshold27 = threshold)) then
            oRgb.red     <= rgb(27).red;
            oRgb.green   <= rgb(27).gre;
            oRgb.blue    <= rgb(27).blu;
        elsif((thr5.threshold28 = threshold)) then
            oRgb.red     <= rgb(28).red;
            oRgb.green   <= rgb(28).gre;
            oRgb.blue    <= rgb(28).blu;
        elsif((thr5.threshold29 = threshold)) then
            oRgb.red     <= rgb(29).red;
            oRgb.green   <= rgb(29).gre;
            oRgb.blue    <= rgb(29).blu;
        elsif((thr5.threshold30 = threshold)) then
            oRgb.red     <= rgb(30).red;
            oRgb.green   <= rgb(30).gre;
            oRgb.blue    <= rgb(30).blu;
        else
            oRgb.red     <= (others => '1');
            oRgb.green   <= (others => '1');
            oRgb.blue    <= (others => '1');
        end if;
    end if;
end process;

oRgb.valid <= rgbSyncValid(27);
oRgb.eol   <= rgbSyncEol(27);
oRgb.sof   <= rgbSyncSof(27);
oRgb.eof   <= rgbSyncEof(27);
end architecture;