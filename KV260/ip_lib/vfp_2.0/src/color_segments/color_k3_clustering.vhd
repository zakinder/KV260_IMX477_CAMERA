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
entity color_k3_clustering is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    iLutNum        : in integer;
    k_lut          : in integer;
    oRgb           : out channel);
end entity;
architecture arch of color_k3_clustering is
    signal rgbSyncEol    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncSof    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncEof    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncValid  : std_logic_vector(31 downto 0) := x"00000000";
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --             RED                                                GREEEN                                              BLUE
   --constant    k_rgb(1_red    : integer  :=  255;  constant    k_rgb(1_gre    : integer   := 250;  constant    k_rgb(1_blu    : integer  :=  99;
   --constant    k_rgb(2_red    : integer  :=  250;  constant    k_rgb(2_gre    : integer   := 245;  constant    k_rgb(2_blu    : integer  :=  99;
   --constant    k_rgb(3_red    : integer  :=  240;  constant    k_rgb(3_gre    : integer   := 230;  constant    k_rgb(3_blu    : integer  :=  99;
   --constant    k_rgb(4_red    : integer  :=  230;  constant    k_rgb(4_gre    : integer   := 220;  constant    k_rgb(4_blu    : integer  :=  99;
   --constant    k_rgb(5_red    : integer  :=  220;  constant    k_rgb(5_gre    : integer   := 210;  constant    k_rgb(5_blu    : integer  :=  99;
   --constant    k_rgb(6_red    : integer  :=  255;  constant    k_rgb(6_gre    : integer   := 250;  constant    k_rgb(6_blu    : integer  :=  191;
   --constant    k_rgb(7_red    : integer  :=  255;  constant    k_rgb(7_gre    : integer   := 250;  constant    k_rgb(7_blu    : integer  :=  181;
   --constant    k_rgb(8_red    : integer  :=  250;  constant    k_rgb(8_gre    : integer   := 230;  constant    k_rgb(8_blu    : integer  :=  181;
   --constant    k_rgb(9_red    : integer  :=  240;  constant    k_rgb(9_gre    : integer   := 230;  constant    k_rgb(9_blu    : integer  :=  171;
   --constant    k_rgb(10_red    : integer  :=  240;  constant    k_rgb(10_gre    : integer   := 210;  constant    k_rgb(10_blu    : integer  :=  171;
   --constant    k_rgb(11_red    : integer  :=  230;  constant    k_rgb(11_gre    : integer   := 210;  constant    k_rgb(11_blu    : integer  :=  161;
   --constant    k_rgb(12_red    : integer  :=  225;  constant    k_rgb(12_gre    : integer   := 200;  constant    k_rgb(12_blu    : integer  :=  161;
   --constant    k_rgb(13_red    : integer  :=  220;  constant    k_rgb(13_gre    : integer   := 200;  constant    k_rgb(13_blu    : integer  :=  151;
   --constant    k_rgb(14_red    : integer  :=  210;  constant    k_rgb(14_gre    : integer   := 180;  constant    k_rgb(14_blu    : integer  :=  151;
   --constant    k_rgb(15_red    : integer  :=  210;  constant    k_rgb(15_gre    : integer   := 170;  constant    k_rgb(15_blu    : integer  :=  141;
   --constant    k_rgb(16_red    : integer  :=  200;  constant    k_rgb(16_gre    : integer   := 170;  constant    k_rgb(16_blu    : integer  :=  141;
   --constant    k_rgb(17_red    : integer  :=  195;  constant    k_rgb(17_gre    : integer   := 160;  constant    k_rgb(17_blu    : integer  :=  131;
   --constant    k_rgb(18_red    : integer  :=  190;  constant    k_rgb(18_gre    : integer   := 160;  constant    k_rgb(18_blu    : integer  :=  131;
   --constant    k_rgb(19_red    : integer  :=  180;  constant    k_rgb(19_gre    : integer   := 150;  constant    k_rgb(19_blu    : integer  :=  121;
   --constant    k_rgb(20_red    : integer  :=  180;  constant    k_rgb(20_gre    : integer   := 150;  constant    k_rgb(20_blu    : integer  :=  121;
   --constant    k_rgb(21_red    : integer  :=  170;  constant    k_rgb(21_gre    : integer   := 130;  constant    k_rgb(21_blu    : integer  :=  111;
   --constant    k_rgb(22_red    : integer  :=  170;  constant    k_rgb(22_gre    : integer   := 130;  constant    k_rgb(22_blu    : integer  :=  111;
   --constant    k_rgb(23_red    : integer  :=  150;  constant    k_rgb(23_gre    : integer   := 140;  constant    k_rgb(23_blu    : integer  :=  101;
   --constant    k_rgb(24_red    : integer  :=  150;  constant    k_rgb(24_gre    : integer   := 120;  constant    k_rgb(24_blu    : integer  :=  101;
   --constant    k_rgb(25_red    : integer  :=  150;  constant    k_rgb(25_gre    : integer   := 100;  constant    k_rgb(25_blu    : integer  :=   91;
   --constant    k_rgb(26_red    : integer  :=  130;  constant    k_rgb(26_gre    : integer   := 100;  constant    k_rgb(26_blu    : integer  :=   91;
   --constant    k_rgb(27_red    : integer  :=  130;  constant    k_rgb(27_gre    : integer   := 100;  constant    k_rgb(27_blu    : integer  :=   81;
   --constant    k_rgb(28_red    : integer  :=  110;  constant    k_rgb(28_gre    : integer   :=  90;  constant    k_rgb(28_blu    : integer  :=   81;
   --constant    k_rgb(29_red    : integer  :=  110;  constant    k_rgb(29_gre    : integer   :=  90;  constant    k_rgb(29_blu    : integer  :=   71;
   --constant    k_rgb(30_red    : integer  :=  100;  constant    k_rgb(30_gre    : integer   :=  80;  constant    k_rgb(30_blu    : integer  :=   71;
   --constant    k_rgb(31_red    : integer  :=  100;  constant    k_rgb(31_gre    : integer   :=  70;  constant    k_rgb(31_blu    : integer  :=   61;
   --constant    k_rgb(32_red    : integer  :=  75;   constant    k_rgb(32_gre    : integer   :=  50;  constant    k_rgb(32_blu    : integer  :=   31;
   --constant    k_rgb(33_red    : integer  :=  75;   constant    k_rgb(33_gre    : integer   :=  50;  constant    k_rgb(33_blu    : integer  :=   11;
   --constant    k_rgb(34_red    : integer  :=  50;   constant    k_rgb(34_gre    : integer   :=  40;  constant    k_rgb(34_blu    : integer  :=   31;
   --constant    k_rgb(35_red    : integer  :=  50;   constant    k_rgb(35_gre    : integer   :=  40;  constant    k_rgb(35_blu    : integer  :=   11;
   --constant    k_rgb(36_red    : integer  :=  250;  constant    k_rgb(36_gre    : integer   := 255;  constant    k_rgb(36_blu    : integer  :=  101;
   --constant    k_rgb(37_red    : integer  :=  245;  constant    k_rgb(37_gre    : integer   := 250;  constant    k_rgb(37_blu    : integer  :=  101;
   --constant    k_rgb(38_red    : integer  :=  230;  constant    k_rgb(38_gre    : integer   := 240;  constant    k_rgb(38_blu    : integer  :=  101;
   --constant    k_rgb(39_red    : integer  :=  220;  constant    k_rgb(39_gre    : integer   := 230;  constant    k_rgb(39_blu    : integer  :=  101;
   --constant    k_rgb(40_red    : integer  :=  210;  constant    k_rgb(40_gre    : integer   := 220;  constant    k_rgb(40_blu    : integer  :=  101;
   --constant    k_rgb(41_red    : integer  :=  250;  constant    k_rgb(41_gre    : integer   := 255;  constant    k_rgb(41_blu    : integer  :=  193;
   --constant    k_rgb(42_red    : integer  :=  250;  constant    k_rgb(42_gre    : integer   := 255;  constant    k_rgb(42_blu    : integer  :=  183;
   --constant    k_rgb(43_red    : integer  :=  230;  constant    k_rgb(43_gre    : integer   := 250;  constant    k_rgb(43_blu    : integer  :=  183;
   --constant    k_rgb(44_red    : integer  :=  230;  constant    k_rgb(44_gre    : integer   := 240;  constant    k_rgb(44_blu    : integer  :=  173;
   --constant    k_rgb(45_red    : integer  :=  210;  constant    k_rgb(45_gre    : integer   := 240;  constant    k_rgb(45_blu    : integer  :=  173;
   --constant    k_rgb(46_red    : integer  :=  210;  constant    k_rgb(46_gre    : integer   := 230;  constant    k_rgb(46_blu    : integer  :=  163;
   --constant    k_rgb(47_red    : integer  :=  200;  constant    k_rgb(47_gre    : integer   := 225;  constant    k_rgb(47_blu    : integer  :=  163;
   --constant    k_rgb(48_red    : integer  :=  200;  constant    k_rgb(48_gre    : integer   := 220;  constant    k_rgb(48_blu    : integer  :=  153;
   --constant    k_rgb(49_red    : integer  :=  180;  constant    k_rgb(49_gre    : integer   := 210;  constant    k_rgb(49_blu    : integer  :=  153;
   --constant    k_rgb(50_red    : integer  :=  170;  constant    k_rgb(50_gre    : integer   := 210;  constant    k_rgb(50_blu    : integer  :=  143;
   --constant    k_rgb(51_red    : integer  :=  170;  constant    k_rgb(51_gre    : integer   := 200;  constant    k_rgb(51_blu    : integer  :=  143;
   --constant    k_rgb(52_red    : integer  :=  160;  constant    k_rgb(52_gre    : integer   := 195;  constant    k_rgb(52_blu    : integer  :=  133;
   --constant    k_rgb(53_red    : integer  :=  160;  constant    k_rgb(53_gre    : integer   := 190;  constant    k_rgb(53_blu    : integer  :=  133;
   --constant    k_rgb(54_red    : integer  :=  150;  constant    k_rgb(54_gre    : integer   := 180;  constant    k_rgb(54_blu    : integer  :=  123;
   --constant    k_rgb(55_red    : integer  :=  150;  constant    k_rgb(55_gre    : integer   := 180;  constant    k_rgb(55_blu    : integer  :=  123;
   --constant    k_rgb(56_red    : integer  :=  130;  constant    k_rgb(56_gre    : integer   := 170;  constant    k_rgb(56_blu    : integer  :=  113;
   --constant    k_rgb(57_red    : integer  :=  130;  constant    k_rgb(57_gre    : integer   := 170;  constant    k_rgb(57_blu    : integer  :=  113;
   --constant    k_rgb(58_red    : integer  :=  140;  constant    k_rgb(58_gre    : integer   := 150;  constant    k_rgb(58_blu    : integer  :=  103;
   --constant    k_rgb(59_red    : integer  :=  120;  constant    k_rgb(59_gre    : integer   := 150;  constant    k_rgb(59_blu    : integer  :=  103;
   --constant    k_rgb(60_red    : integer  :=  100;  constant    k_rgb(60_gre    : integer   := 150;  constant    k_rgb(60_blu    : integer  :=   93;
   --constant    k_rgb(61_red    : integer  :=  100;  constant    k_rgb(61_gre    : integer   := 130;  constant    k_rgb(61_blu    : integer  :=   93;
   --constant    k_rgb(62_red    : integer  :=  100;  constant    k_rgb(62_gre    : integer   := 130;  constant    k_rgb(62_blu    : integer  :=   83;
   --constant    k_rgb(63_red    : integer  :=   90;  constant    k_rgb(63_gre    : integer   := 110;  constant    k_rgb(63_blu    : integer  :=   83;
   --constant    k_rgb(64_red    : integer  :=   90;  constant    k_rgb(64_gre    : integer   := 110;  constant    k_rgb(64_blu    : integer  :=   73;
   --constant    k_rgb(65_red    : integer  :=   80;  constant    k_rgb(65_gre    : integer   := 100;  constant    k_rgb(65_blu    : integer  :=   73;
   --constant    k_rgb(66_red    : integer  :=   70;  constant    k_rgb(66_gre    : integer   := 100;  constant    k_rgb(66_blu    : integer  :=   63;
   --constant    k_rgb(67_red    : integer  :=   50;  constant    k_rgb(67_gre    : integer   := 75;   constant    k_rgb(67_blu    : integer  :=   33;
   --constant    k_rgb(68_red    : integer  :=   50;  constant    k_rgb(68_gre    : integer   := 75;   constant    k_rgb(68_blu    : integer  :=   13;
   --constant    k_rgb(69_red    : integer  :=   40;  constant    k_rgb(69_gre    : integer   := 50;   constant    k_rgb(69_blu    : integer  :=   33;
   --constant    k_rgb(70_red    : integer  :=   40;  constant    k_rgb(70_gre    : integer   := 50;   constant    k_rgb(70_blu    : integer  :=   13;
   --constant    k_rgb(71_red    : integer  :=  190;  constant    k_rgb(71_gre    : integer   := 250;  constant    k_rgb(71_blu    : integer  :=  255;
   --constant    k_rgb(72_red    : integer  :=  185;  constant    k_rgb(72_gre    : integer   := 250;  constant    k_rgb(72_blu    : integer  :=  255;
   --constant    k_rgb(73_red    : integer  :=  180;  constant    k_rgb(73_gre    : integer   := 230;  constant    k_rgb(73_blu    : integer  :=  250;
   --constant    k_rgb(74_red    : integer  :=  175;  constant    k_rgb(74_gre    : integer   := 230;  constant    k_rgb(74_blu    : integer  :=  240;
   --constant    k_rgb(75_red    : integer  :=  170;  constant    k_rgb(75_gre    : integer   := 210;  constant    k_rgb(75_blu    : integer  :=  240;
   --constant    k_rgb(76_red    : integer  :=  165;  constant    k_rgb(76_gre    : integer   := 210;  constant    k_rgb(76_blu    : integer  :=  230;
   --constant    k_rgb(77_red    : integer  :=  160;  constant    k_rgb(77_gre    : integer   := 200;  constant    k_rgb(77_blu    : integer  :=  225;
   --constant    k_rgb(78_red    : integer  :=  155;  constant    k_rgb(78_gre    : integer   := 200;  constant    k_rgb(78_blu    : integer  :=  220;
   --constant    k_rgb(79_red    : integer  :=  150;  constant    k_rgb(79_gre    : integer   := 180;  constant    k_rgb(79_blu    : integer  :=  210;
   --constant    k_rgb(80_red    : integer  :=  145;  constant    k_rgb(80_gre    : integer   := 170;  constant    k_rgb(80_blu    : integer  :=  210;
   --constant    k_rgb(81_red    : integer  :=  140;  constant    k_rgb(81_gre    : integer   := 170;  constant    k_rgb(81_blu    : integer  :=  200;
   --constant    k_rgb(82_red    : integer  :=  135;  constant    k_rgb(82_gre    : integer   := 160;  constant    k_rgb(82_blu    : integer  :=  195;
   --constant    k_rgb(83_red    : integer  :=  130;  constant    k_rgb(83_gre    : integer   := 160;  constant    k_rgb(83_blu    : integer  :=  190;
   --constant    k_rgb(84_red    : integer  :=  125;  constant    k_rgb(84_gre    : integer   := 150;  constant    k_rgb(84_blu    : integer  :=  180;
   --constant    k_rgb(85_red    : integer  :=  120;  constant    k_rgb(85_gre    : integer   := 150;  constant    k_rgb(85_blu    : integer  :=  180;
   --constant    k_rgb(86_red    : integer  :=  115;  constant    k_rgb(86_gre    : integer   := 130;  constant    k_rgb(86_blu    : integer  :=  170;
   --constant    k_rgb(87_red    : integer  :=  110;  constant    k_rgb(87_gre    : integer   := 130;  constant    k_rgb(87_blu    : integer  :=  170;
   --constant    k_rgb(88_red    : integer  :=  105;  constant    k_rgb(88_gre    : integer   := 140;  constant    k_rgb(88_blu    : integer  :=  150;
   --constant    k_rgb(89_red    : integer  :=  100;  constant    k_rgb(89_gre    : integer   := 120;  constant    k_rgb(89_blu    : integer  :=  150;
   --constant    k_rgb(90_red    : integer  :=   95;  constant    k_rgb(90_gre    : integer   := 100;  constant    k_rgb(90_blu    : integer  :=  150;
   --constant    k_rgb(91_red    : integer  :=   90;  constant    k_rgb(91_gre    : integer   := 100;  constant    k_rgb(91_blu    : integer  :=  130;
   --constant    k_rgb(92_red    : integer  :=   85;  constant    k_rgb(92_gre    : integer   := 100;  constant    k_rgb(92_blu    : integer  :=  130;
   --constant    k_rgb(93_red    : integer  :=   80;  constant    k_rgb(93_gre    : integer   :=  90;  constant    k_rgb(93_blu    : integer  :=  110;
   --constant    k_rgb(94_red    : integer  :=   75;  constant    k_rgb(94_gre    : integer   :=  90;  constant    k_rgb(94_blu    : integer  :=  110;
   --constant    k_rgb(95_red    : integer  :=   70;  constant    k_rgb(95_gre    : integer   :=  70;  constant    k_rgb(95_blu    : integer  :=  100;
   --constant    k_rgb(96_red    : integer  :=   65;  constant    k_rgb(96_gre    : integer   :=  70;  constant    k_rgb(96_blu    : integer  :=  100;
   --constant    k_rgb(97_red    : integer  :=   30;  constant    k_rgb(97_gre    : integer   :=  50;  constant    k_rgb(97_blu    : integer  :=  75;
   --constant    k_rgb(98_red    : integer  :=   10;  constant    k_rgb(98_gre    : integer   :=  50;  constant    k_rgb(98_blu    : integer  :=  75;
   --constant    k_rgb(99_red    : integer  :=   30;  constant    k_rgb(99_gre    : integer   :=  40;  constant    k_rgb(99_blu    : integer  :=  50;
   --constant    k_rgb(100red    : integer  :=   10;  constant    k_rgb(100green    : integer   :=  40;  constant    k_rgb(100blue    : integer  :=  50;
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
    signal k_rgb             : rgb_k_lut(0 to 106) := (
    (  0,  0,  0),
    (255,251,242),--RED  255
    (255,241,232),--RED  255
    (255,231,202),--RED  255
    (255,221,182),--RED  255
    (255,211,122),--RED  255
    (255,201,142),--RED  255
    (255,191,132),--RED  255
    (255,181,122),--RED  255
    (255,171,112),--RED  255
    (230,191,172),--RED  200
    (230,181,162),--RED  220
    (230, 81, 62),--RED  ---
    (220,181,142),--RED  220
    (220,171,132),--RED  220
    (200, 51, 12),--RED  ---
    (200,181, 92),--RED  ---
    (180,161,132),--RED  180
    (180,151,122),--RED  180
    (170,151,112),--RED  180
    (170,141,102),--RED  180
    (150, 31, 22),--RED  ---
    (150, 71, 42),--RED  ---
    (130, 91, 62),--RED  120
    (130, 81, 52),--RED  120
    (120, 81, 42),--RED  120
    (120, 71, 32),--RED  120
    (100, 51, 22),--RED  ---
    ( 70, 51, 42),--RED  60
    ( 70, 41, 32),--RED  60
    ( 60, 41, 22),--RED  60
    ( 60, 31, 12),--RED  60
    ( 50, 31, 32),--RED  50
    ( 50, 31, 22),--RED  50
    ( 40, 31, 22),--RED  50
    ( 40, 21, 12),--RED  50
    (244,255,253),--GREEN  255
    (234,255,243),--GREEN  255
    (204,255,233),--GREEN  255
    (184,255,223),--GREEN  255
    (124,255,213),--GREEN  255
    (144,255,203),--GREEN  255
    (134,255,193),--GREEN  255
    (124,255,183),--GREEN  255
    (114,255,173),--GREEN  255
    (174,230,193),--GREEN  200
    (164,230,183),--GREEN  220
    ( 64,230, 83),--GREEN  ---
    (144,220,183),--GREEN  220
    (134,220,173),--GREEN  220
    ( 14,200, 53),--GREEN  ---
    ( 94,200,183),--GREEN  ---
    (134,180,163),--GREEN  180
    (124,180,153),--GREEN  180
    (114,170,153),--GREEN  180
    (104,170,143),--GREEN  180
    ( 44,150,143),--GREEN  ---
    ( 64,130, 73),--GREEN  120
    ( 54,130, 93),--GREEN  120
    ( 44,120, 83),--GREEN  120
    ( 34,120, 83),--GREEN  120
    ( 24,100, 73),--GREEN  ---
    ( 24,100, 33),--GREEN  ---
    ( 44, 70, 53),--GREEN  60
    ( 34, 70, 43),--GREEN  60
    ( 24, 60, 43),--GREEN  60
    ( 14, 60, 33),--GREEN  60
    ( 34, 50, 33),--GREEN  50
    ( 24, 50, 23),--GREEN  50
    ( 24, 40, 33),--GREEN  50
    ( 14, 40, 23),--GREEN  50
    (245,256,255),--BLUE
    (235,246,255),--BLUE
    (205,236,255),--BLUE
    (185,226,255),--BLUE
    (125,216,255),--BLUE
    (145,206,255),--BLUE
    (135,196,255),--BLUE
    (125,186,255),--BLUE
    (115,176,255),--BLUE
    (175,196,230),--BLUE
    (165,186,230),--BLUE
    ( 65, 86,230),--BLUE
    (145,186,220),--BLUE
    (135,176,220),--BLUE
    ( 15, 56,200),--BLUE
    ( 95,186,200),--BLUE
    (135,166,180),--BLUE
    (125,156,180),--BLUE
    (115,156,170),--BLUE
    (105,146,170),--BLUE
    ( 25, 36,150),--BLUE
    ( 45, 76,150),--BLUE
    ( 65, 96,130),--BLUE
    ( 55, 86,130),--BLUE
    ( 45, 86,120),--BLUE
    ( 35, 76,120),--BLUE
    ( 25, 56,100),--BLUE
    ( 45, 56, 70),--BLUE
    ( 35, 46, 70),--BLUE
    ( 25, 46, 60),--BLUE
    ( 15, 36, 60),--BLUE
    ( 35, 36, 50),--BLUE
    ( 25, 36, 50),--BLUE
    ( 25, 36, 40),--BLUE
    ( 15, 26, 40),--BLUE
    (255,255,255));
    signal k_rgb_index            : rgb_k_lut(0 to 106) := (
    (  0,  0,  0),
    (255,251,242),--RED  255
    (255,241,232),--RED  255
    (255,231,202),--RED  255
    (255,221,182),--RED  255
    (255,211,122),--RED  255
    (255,201,142),--RED  255
    (255,191,132),--RED  255
    (255,181,122),--RED  255
    (255,171,112),--RED  255
    (230,191,172),--RED  200
    (230,181,162),--RED  220
    (230, 81, 62),--RED  ---
    (220,181,142),--RED  220
    (220,171,132),--RED  220
    (200, 51, 12),--RED  ---
    (200,181, 92),--RED  ---
    (180,161,132),--RED  180
    (180,151,122),--RED  180
    (170,151,112),--RED  180
    (170,141,102),--RED  180
    (150, 31, 22),--RED  ---
    (150, 71, 42),--RED  ---
    (130, 91, 62),--RED  120
    (130, 81, 52),--RED  120
    (120, 81, 42),--RED  120
    (120, 71, 32),--RED  120
    (100, 51, 22),--RED  ---
    ( 70, 51, 42),--RED  60
    ( 70, 41, 32),--RED  60
    ( 60, 41, 22),--RED  60
    ( 60, 31, 12),--RED  60
    ( 50, 31, 32),--RED  50
    ( 50, 31, 22),--RED  50
    ( 40, 31, 22),--RED  50
    ( 40, 21, 12),--RED  50
    (244,255,253),--GREEN  255
    (234,255,243),--GREEN  255
    (204,255,233),--GREEN  255
    (184,255,223),--GREEN  255
    (124,255,213),--GREEN  255
    (144,255,203),--GREEN  255
    (134,255,193),--GREEN  255
    (124,255,183),--GREEN  255
    (114,255,173),--GREEN  255
    (174,230,193),--GREEN  200
    (164,230,183),--GREEN  220
    ( 64,230, 83),--GREEN  ---
    (144,220,183),--GREEN  220
    (134,220,173),--GREEN  220
    ( 14,200, 53),--GREEN  ---
    ( 94,200,183),--GREEN  ---
    (134,180,163),--GREEN  180
    (124,180,153),--GREEN  180
    (114,170,153),--GREEN  180
    (104,170,143),--GREEN  180
    ( 44,150,143),--GREEN  ---
    ( 64,130, 73),--GREEN  120
    ( 54,130, 93),--GREEN  120
    ( 44,120, 83),--GREEN  120
    ( 34,120, 83),--GREEN  120
    ( 24,100, 73),--GREEN  ---
    ( 24,100, 33),--GREEN  ---
    ( 44, 70, 53),--GREEN  60
    ( 34, 70, 43),--GREEN  60
    ( 24, 60, 43),--GREEN  60
    ( 14, 60, 33),--GREEN  60
    ( 34, 50, 33),--GREEN  50
    ( 24, 50, 23),--GREEN  50
    ( 24, 40, 33),--GREEN  50
    ( 14, 40, 23),--GREEN  50
    (245,256,255),--BLUE
    (235,246,255),--BLUE
    (205,236,255),--BLUE
    (185,226,255),--BLUE
    (125,216,255),--BLUE
    (145,206,255),--BLUE
    (135,196,255),--BLUE
    (125,186,255),--BLUE
    (115,176,255),--BLUE
    (175,196,230),--BLUE
    (165,186,230),--BLUE
    ( 65, 86,230),--BLUE
    (145,186,220),--BLUE
    (135,176,220),--BLUE
    ( 15, 56,200),--BLUE
    ( 95,186,200),--BLUE
    (135,166,180),--BLUE
    (125,156,180),--BLUE
    (115,156,170),--BLUE
    (105,146,170),--BLUE
    ( 25, 36,150),--BLUE
    ( 45, 76,150),--BLUE
    ( 65, 96,130),--BLUE
    ( 55, 86,130),--BLUE
    ( 45, 86,120),--BLUE
    ( 35, 76,120),--BLUE
    ( 25, 56,100),--BLUE
    ( 45, 56, 70),--BLUE
    ( 35, 46, 70),--BLUE
    ( 25, 46, 60),--BLUE
    ( 15, 36, 60),--BLUE
    ( 35, 36, 50),--BLUE
    ( 25, 36, 50),--BLUE
    ( 25, 36, 40),--BLUE
    ( 15, 26, 40),--BLUE
    (255,255,255));
    
    signal k1_rgb                 : rgb_k_lut(0 to 106);
    signal k2_rgb                 : rgb_k_lut(0 to 106);
    signal k3_rgb                 : rgb_k_lut(0 to 106);
    signal k4_rgb                 : rgb_k_lut(0 to 106);
    signal k5_rgb                 : rgb_k_lut(0 to 106);
    signal k6_rgb                 : rgb_k_lut(0 to 106);
    signal k7_rgb                 : rgb_k_lut(0 to 106);
    signal k8_rgb                 : rgb_k_lut(0 to 106);
    signal k9_rgb                 : rgb_k_lut(0 to 106);
    signal k10rgb                 : rgb_k_lut(0 to 106);
    signal k11rgb                 : rgb_k_lut(0 to 106);
    signal k12rgb                 : rgb_k_lut(0 to 106);
    signal k13rgb                 : rgb_k_lut(0 to 106);
    signal k14rgb                 : rgb_k_lut(0 to 106);
    signal k15rgb                 : rgb_k_lut(0 to 106);
    signal k16rgb                 : rgb_k_lut(0 to 106);
    signal k17rgb                 : rgb_k_lut(0 to 106);
    signal k18rgb                 : rgb_k_lut(0 to 106);
    signal k19rgb                 : rgb_k_lut(0 to 106);
    signal k20rgb                 : rgb_k_lut(0 to 106);
    signal k21rgb                 : rgb_k_lut(0 to 106);
    signal k22rgb                 : rgb_k_lut(0 to 106);
    signal k23rgb                 : rgb_k_lut(0 to 106);
    signal k24rgb                 : rgb_k_lut(0 to 106);
    signal k25rgb                 : rgb_k_lut(0 to 106);
    signal k26rgb                 : rgb_k_lut(0 to 106);
    signal k27rgb                 : rgb_k_lut(0 to 106);
    signal thr1                  : thr_record;
    signal thr2                  : thr_record;
    signal thr3                  : thr_record;
    signal thr4                  : thr_record;
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
    signal rgb_sync              : channel;
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
        rgbSyncValid(11) <= rgbSyncValid(10);
        rgbSyncValid(12) <= rgbSyncValid(11);
        rgbSyncValid(13) <= rgbSyncValid(12);
        rgbSyncValid(14) <= rgbSyncValid(13);
        rgbSyncValid(15) <= rgbSyncValid(14);
        rgbSyncValid(16) <= rgbSyncValid(15);
        rgbSyncValid(17) <= rgbSyncValid(16);
        rgbSyncValid(18) <= rgbSyncValid(17);
        rgbSyncValid(19) <= rgbSyncValid(18);
        rgbSyncValid(20) <= rgbSyncValid(19);
        rgbSyncValid(21) <= rgbSyncValid(20);
        rgbSyncValid(22) <= rgbSyncValid(21);
        rgbSyncValid(23) <= rgbSyncValid(22);
        rgbSyncValid(24) <= rgbSyncValid(23);
        rgbSyncValid(25) <= rgbSyncValid(24);
        rgbSyncValid(26) <= rgbSyncValid(25);
        rgbSyncValid(27) <= rgbSyncValid(26);
        rgbSyncValid(28) <= rgbSyncValid(27);
        rgbSyncValid(29) <= rgbSyncValid(28);
        rgbSyncValid(30) <= rgbSyncValid(29);
        rgbSyncValid(31) <= rgbSyncValid(30);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEol(0)  <= iRgb.eol;
        rgbSyncEol(1)  <= rgbSyncEol(0);
        rgbSyncEol(2)  <= rgbSyncEol(1);
        rgbSyncEol(3)  <= rgbSyncEol(2);
        rgbSyncEol(4)  <= rgbSyncEol(3);
        rgbSyncEol(5)  <= rgbSyncEol(4);
        rgbSyncEol(6)  <= rgbSyncEol(5);
        rgbSyncEol(7)  <= rgbSyncEol(6);
        rgbSyncEol(8)  <= rgbSyncEol(7);
        rgbSyncEol(9)  <= rgbSyncEol(8);
        rgbSyncEol(10) <= rgbSyncEol(9);
        rgbSyncEol(11) <= rgbSyncEol(10);
        rgbSyncEol(12) <= rgbSyncEol(11);
        rgbSyncEol(13) <= rgbSyncEol(12);
        rgbSyncEol(14) <= rgbSyncEol(13);
        rgbSyncEol(15) <= rgbSyncEol(14);
        rgbSyncEol(16) <= rgbSyncEol(15);
        rgbSyncEol(17) <= rgbSyncEol(16);
        rgbSyncEol(18) <= rgbSyncEol(17);
        rgbSyncEol(19) <= rgbSyncEol(18);
        rgbSyncEol(20) <= rgbSyncEol(19);
        rgbSyncEol(21) <= rgbSyncEol(20);
        rgbSyncEol(22) <= rgbSyncEol(21);
        rgbSyncEol(23) <= rgbSyncEol(22);
        rgbSyncEol(24) <= rgbSyncEol(23);
        rgbSyncEol(25) <= rgbSyncEol(24);
        rgbSyncEol(26) <= rgbSyncEol(25);
        rgbSyncEol(27) <= rgbSyncEol(26);
        rgbSyncEol(28) <= rgbSyncEol(27);
        rgbSyncEol(29) <= rgbSyncEol(28);
        rgbSyncEol(30) <= rgbSyncEol(29);
        rgbSyncEol(31) <= rgbSyncEol(30);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncSof(0)  <= iRgb.sof;
        rgbSyncSof(1)  <= rgbSyncSof(0);
        rgbSyncSof(2)  <= rgbSyncSof(1);
        rgbSyncSof(3)  <= rgbSyncSof(2);
        rgbSyncSof(4)  <= rgbSyncSof(3);
        rgbSyncSof(5)  <= rgbSyncSof(4);
        rgbSyncSof(6)  <= rgbSyncSof(5);
        rgbSyncSof(7)  <= rgbSyncSof(6);
        rgbSyncSof(8)  <= rgbSyncSof(7);
        rgbSyncSof(9)  <= rgbSyncSof(8);
        rgbSyncSof(10) <= rgbSyncSof(9);
        rgbSyncSof(11) <= rgbSyncSof(10);
        rgbSyncSof(12) <= rgbSyncSof(11);
        rgbSyncSof(13) <= rgbSyncSof(12);
        rgbSyncSof(14) <= rgbSyncSof(13);
        rgbSyncSof(15) <= rgbSyncSof(14);
        rgbSyncSof(16) <= rgbSyncSof(15);
        rgbSyncSof(17) <= rgbSyncSof(16);
        rgbSyncSof(18) <= rgbSyncSof(17);
        rgbSyncSof(19) <= rgbSyncSof(18);
        rgbSyncSof(20) <= rgbSyncSof(19);
        rgbSyncSof(21) <= rgbSyncSof(20);
        rgbSyncSof(22) <= rgbSyncSof(21);
        rgbSyncSof(23) <= rgbSyncSof(22);
        rgbSyncSof(24) <= rgbSyncSof(23);
        rgbSyncSof(25) <= rgbSyncSof(24);
        rgbSyncSof(26) <= rgbSyncSof(25);
        rgbSyncSof(27) <= rgbSyncSof(26);
        rgbSyncSof(28) <= rgbSyncSof(27);
        rgbSyncSof(29) <= rgbSyncSof(28);
        rgbSyncSof(30) <= rgbSyncSof(29);
        rgbSyncSof(31) <= rgbSyncSof(30);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEof(0)  <= iRgb.eof;
        rgbSyncEof(1)  <= rgbSyncEof(0);
        rgbSyncEof(2)  <= rgbSyncEof(1);
        rgbSyncEof(3)  <= rgbSyncEof(2);
        rgbSyncEof(4)  <= rgbSyncEof(3);
        rgbSyncEof(5)  <= rgbSyncEof(4);
        rgbSyncEof(6)  <= rgbSyncEof(5);
        rgbSyncEof(7)  <= rgbSyncEof(6);
        rgbSyncEof(8)  <= rgbSyncEof(7);
        rgbSyncEof(9)  <= rgbSyncEof(8);
        rgbSyncEof(10) <= rgbSyncEof(9);
        rgbSyncEof(11) <= rgbSyncEof(10);
        rgbSyncEof(12) <= rgbSyncEof(11);
        rgbSyncEof(13) <= rgbSyncEof(12);
        rgbSyncEof(14) <= rgbSyncEof(13);
        rgbSyncEof(15) <= rgbSyncEof(14);
        rgbSyncEof(16) <= rgbSyncEof(15);
        rgbSyncEof(17) <= rgbSyncEof(16);
        rgbSyncEof(18) <= rgbSyncEof(17);
        rgbSyncEof(19) <= rgbSyncEof(18);
        rgbSyncEof(20) <= rgbSyncEof(19);
        rgbSyncEof(21) <= rgbSyncEof(20);
        rgbSyncEof(22) <= rgbSyncEof(21);
        rgbSyncEof(23) <= rgbSyncEof(22);
        rgbSyncEof(24) <= rgbSyncEof(23);
        rgbSyncEof(25) <= rgbSyncEof(24);
        rgbSyncEof(26) <= rgbSyncEof(25);
        rgbSyncEof(27) <= rgbSyncEof(26);
        rgbSyncEof(28) <= rgbSyncEof(27);
        rgbSyncEof(29) <= rgbSyncEof(28);
        rgbSyncEof(30) <= rgbSyncEof(29);
        rgbSyncEof(31) <= rgbSyncEof(30);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        rgb_sync.red    <= iRgb.red;
        rgb_sync.green  <= iRgb.green;
        rgb_sync.blue   <= iRgb.blue;
        rgb_sync.valid  <= iRgb.valid;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
            rgb_sync1.red    <= to_integer(unsigned(rgb_sync.red(9 downto 2)));
            rgb_sync1.green  <= to_integer(unsigned(rgb_sync.green(9 downto 2)));
            rgb_sync1.blue   <= to_integer(unsigned(rgb_sync.blue(9 downto 2)));
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



process (clk)begin
    if rising_edge(clk) then
        if (iLutNum = 0) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 251;   k_rgb_index(1).blu <= 242;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 241;   k_rgb_index(2).blu <= 232;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <= 231;   k_rgb_index(3).blu <= 202;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <= 221;   k_rgb_index(4).blu <= 182;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <= 211;   k_rgb_index(5).blu <= 122;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 201;   k_rgb_index(6).blu <= 142;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 191;   k_rgb_index(7).blu <= 132;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 181;   k_rgb_index(8).blu <= 122;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <= 171;   k_rgb_index(9).blu <= 112;
             k_rgb_index(10).red <= 230;  k_rgb_index(10).gre <= 191;  k_rgb_index(10).blu <= 172;
             k_rgb_index(11).red <= 230;  k_rgb_index(11).gre <= 181;  k_rgb_index(11).blu <= 162;
             k_rgb_index(12).red <= 230;  k_rgb_index(12).gre <=  81;  k_rgb_index(12).blu <=  62;
             k_rgb_index(13).red <= 220;  k_rgb_index(13).gre <= 181;  k_rgb_index(13).blu <= 142;
             k_rgb_index(14).red <= 220;  k_rgb_index(14).gre <= 171;  k_rgb_index(14).blu <= 132;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <=  51;  k_rgb_index(15).blu <=  12;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 181;  k_rgb_index(16).blu <=  92;
             k_rgb_index(17).red <= 180;  k_rgb_index(17).gre <= 161;  k_rgb_index(17).blu <= 132;
             k_rgb_index(18).red <= 180;  k_rgb_index(18).gre <= 151;  k_rgb_index(18).blu <= 122;
             k_rgb_index(19).red <= 170;  k_rgb_index(19).gre <= 151;  k_rgb_index(19).blu <= 112;
             k_rgb_index(20).red <= 170;  k_rgb_index(20).gre <= 141;  k_rgb_index(20).blu <= 102;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <=  31;  k_rgb_index(21).blu <=  22;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <=  71;  k_rgb_index(22).blu <=  42;
             k_rgb_index(23).red <= 130;  k_rgb_index(23).gre <=  91;  k_rgb_index(23).blu <=  62;
             k_rgb_index(24).red <= 130;  k_rgb_index(24).gre <=  81;  k_rgb_index(24).blu <=  52;
             k_rgb_index(25).red <= 120;  k_rgb_index(25).gre <=  81;  k_rgb_index(25).blu <=  42;
             k_rgb_index(26).red <= 120;  k_rgb_index(26).gre <=  71;  k_rgb_index(26).blu <=  32;
             k_rgb_index(27).red <= 100;  k_rgb_index(27).gre <=  51;  k_rgb_index(27).blu <=  22;
             k_rgb_index(28).red <=  70;  k_rgb_index(28).gre <=  51;  k_rgb_index(28).blu <=  42;
             k_rgb_index(29).red <=  70;  k_rgb_index(29).gre <=  41;  k_rgb_index(29).blu <=  32;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  41;  k_rgb_index(30).blu <=  22;
             k_rgb_index(31).red <=  60;  k_rgb_index(31).gre <=  31;  k_rgb_index(31).blu <=  12;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  31;  k_rgb_index(32).blu <=  32;
             k_rgb_index(33).red <=  50;  k_rgb_index(33).gre <=  31;  k_rgb_index(33).blu <=  22;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  31;  k_rgb_index(34).blu <=  22;
             k_rgb_index(35).red <=  40;  k_rgb_index(35).gre <=  21;  k_rgb_index(35).blu <=  12;
             k_rgb_index(36).red <= 244;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 253;
             k_rgb_index(37).red <= 234;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 243;
             k_rgb_index(38).red <= 204;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <= 233;
             k_rgb_index(39).red <= 184;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <= 223;
             k_rgb_index(40).red <= 124;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <= 213;
             k_rgb_index(41).red <= 144;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 203;
             k_rgb_index(42).red <= 134;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 193;
             k_rgb_index(43).red <= 124;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 183;
             k_rgb_index(44).red <= 114;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <= 173;
             k_rgb_index(45).red <= 174;  k_rgb_index(45).gre <= 230;  k_rgb_index(45).blu <= 193;
             k_rgb_index(46).red <= 164;  k_rgb_index(46).gre <= 230;  k_rgb_index(46).blu <= 183;
             k_rgb_index(47).red <=  64;  k_rgb_index(47).gre <= 230;  k_rgb_index(47).blu <=  83;
             k_rgb_index(48).red <= 144;  k_rgb_index(48).gre <= 220;  k_rgb_index(48).blu <= 183;
             k_rgb_index(49).red <= 134;  k_rgb_index(49).gre <= 220;  k_rgb_index(49).blu <= 173;
             k_rgb_index(50).red <=  14;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <=  53;
             k_rgb_index(51).red <=  94;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 183;
             k_rgb_index(52).red <= 134;  k_rgb_index(52).gre <= 180;  k_rgb_index(52).blu <= 163;
             k_rgb_index(53).red <= 124;  k_rgb_index(53).gre <= 180;  k_rgb_index(53).blu <= 153;
             k_rgb_index(54).red <= 114;  k_rgb_index(54).gre <= 170;  k_rgb_index(54).blu <= 153;
             k_rgb_index(55).red <= 104;  k_rgb_index(55).gre <= 170;  k_rgb_index(55).blu <= 143;
             k_rgb_index(56).red <=  44;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 143;
             k_rgb_index(57).red <=  64;  k_rgb_index(57).gre <= 130;  k_rgb_index(57).blu <=  73;
             k_rgb_index(58).red <=  54;  k_rgb_index(58).gre <= 130;  k_rgb_index(58).blu <=  93;
             k_rgb_index(59).red <=  44;  k_rgb_index(59).gre <= 120;  k_rgb_index(59).blu <=  83;
             k_rgb_index(60).red <=  34;  k_rgb_index(60).gre <= 120;  k_rgb_index(60).blu <=  83;
             k_rgb_index(61).red <=  24;  k_rgb_index(61).gre <= 100;  k_rgb_index(61).blu <=  73;
             k_rgb_index(62).red <=  24;  k_rgb_index(62).gre <= 100;  k_rgb_index(62).blu <=  33;
             k_rgb_index(63).red <=  44;  k_rgb_index(63).gre <=  70;  k_rgb_index(63).blu <=  53;
             k_rgb_index(64).red <=  34;  k_rgb_index(64).gre <=  70;  k_rgb_index(64).blu <=  43;
             k_rgb_index(65).red <=  24;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  43;
             k_rgb_index(66).red <=  14;  k_rgb_index(66).gre <=  60;  k_rgb_index(66).blu <=  33;
             k_rgb_index(67).red <=  34;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  33;
             k_rgb_index(68).red <=  24;  k_rgb_index(68).gre <=  50;  k_rgb_index(68).blu <=  23;
             k_rgb_index(69).red <=  24;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  33;
             k_rgb_index(70).red <=  14;  k_rgb_index(70).gre <=  40;  k_rgb_index(70).blu <=  23;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 246;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <= 236;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <= 226;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <= 216;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <= 145;  k_rgb_index(76).gre <= 206;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <= 135;  k_rgb_index(77).gre <= 196;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <= 125;  k_rgb_index(78).gre <= 186;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <= 115;  k_rgb_index(79).gre <= 176;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 175;  k_rgb_index(80).gre <= 196;  k_rgb_index(80).blu <= 230;
             k_rgb_index(81).red <= 165;  k_rgb_index(81).gre <= 186;  k_rgb_index(81).blu <= 230;
             k_rgb_index(82).red <=  65;  k_rgb_index(82).gre <=  86;  k_rgb_index(82).blu <= 230;
             k_rgb_index(83).red <= 145;  k_rgb_index(83).gre <= 186;  k_rgb_index(83).blu <= 220;
             k_rgb_index(84).red <= 135;  k_rgb_index(84).gre <= 176;  k_rgb_index(84).blu <= 220;
             k_rgb_index(85).red <=  15;  k_rgb_index(85).gre <=  56;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <=  95;  k_rgb_index(86).gre <= 186;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 135;  k_rgb_index(87).gre <= 166;  k_rgb_index(87).blu <= 180;
             k_rgb_index(88).red <= 125;  k_rgb_index(88).gre <= 156;  k_rgb_index(88).blu <= 180;
             k_rgb_index(89).red <= 115;  k_rgb_index(89).gre <= 156;  k_rgb_index(89).blu <= 170;
             k_rgb_index(90).red <= 105;  k_rgb_index(90).gre <= 146;  k_rgb_index(90).blu <= 170;
             k_rgb_index(91).red <=  25;  k_rgb_index(91).gre <=  36;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  45;  k_rgb_index(92).gre <=  76;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  65;  k_rgb_index(93).gre <=  96;  k_rgb_index(93).blu <= 130;
             k_rgb_index(94).red <=  55;  k_rgb_index(94).gre <=  86;  k_rgb_index(94).blu <= 130;
             k_rgb_index(95).red <=  45;  k_rgb_index(95).gre <=  86;  k_rgb_index(95).blu <= 120;
             k_rgb_index(96).red <=  35;  k_rgb_index(96).gre <=  76;  k_rgb_index(96).blu <= 120;
             k_rgb_index(97).red <=  25;  k_rgb_index(97).gre <=  56;  k_rgb_index(97).blu <= 100;
             k_rgb_index(98).red <=  45;  k_rgb_index(98).gre <=  56;  k_rgb_index(98).blu <=  70;
             k_rgb_index(99).red <=  35;  k_rgb_index(99).gre <=  46;  k_rgb_index(99).blu <=  70;
            k_rgb_index(100).red <=  25; k_rgb_index(100).gre <=  46; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  60;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  36; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  25; k_rgb_index(104).gre <=  36; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  15; k_rgb_index(105).gre <=  26; k_rgb_index(105).blu <=  40;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 1) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 250;   k_rgb_index(1).blu <= 240;
              k_rgb_index(2).red <= 230;   k_rgb_index(2).gre <= 200;   k_rgb_index(2).blu <= 150;
              k_rgb_index(3).red <= 220;   k_rgb_index(3).gre <= 190;   k_rgb_index(3).blu <= 140;
              k_rgb_index(4).red <= 240;   k_rgb_index(4).gre <= 180;   k_rgb_index(4).blu <= 120;
              k_rgb_index(5).red <= 230;   k_rgb_index(5).gre <= 170;   k_rgb_index(5).blu <= 120;
              k_rgb_index(6).red <= 220;   k_rgb_index(6).gre <= 160;   k_rgb_index(6).blu <= 150;
              k_rgb_index(7).red <= 210;   k_rgb_index(7).gre <= 160;   k_rgb_index(7).blu <= 130;
              k_rgb_index(8).red <= 200;   k_rgb_index(8).gre <= 160;   k_rgb_index(8).blu <= 100;
              k_rgb_index(9).red <= 180;   k_rgb_index(9).gre <= 120;   k_rgb_index(9).blu <=  80;
             k_rgb_index(10).red <= 160;  k_rgb_index(10).gre <= 100;  k_rgb_index(10).blu <=  70;
             k_rgb_index(11).red <= 150;  k_rgb_index(11).gre <=  80;  k_rgb_index(11).blu <=  60;
             k_rgb_index(12).red <= 140;  k_rgb_index(12).gre <=  80;  k_rgb_index(12).blu <=  60;
             k_rgb_index(13).red <= 120;  k_rgb_index(13).gre <=  80;  k_rgb_index(13).blu <=  55;
             k_rgb_index(14).red <= 110;  k_rgb_index(14).gre <=  80;  k_rgb_index(14).blu <=  50;
             k_rgb_index(15).red <= 100;  k_rgb_index(15).gre <=  76;  k_rgb_index(15).blu <=  51;
             k_rgb_index(16).red <=  95;  k_rgb_index(16).gre <=  71;  k_rgb_index(16).blu <=  46;
             k_rgb_index(17).red <=  90;  k_rgb_index(17).gre <=  66;  k_rgb_index(17).blu <=  41;
             k_rgb_index(18).red <=  80;  k_rgb_index(18).gre <=  56;  k_rgb_index(18).blu <=  31;
             k_rgb_index(19).red <=  76;  k_rgb_index(19).gre <=  52;  k_rgb_index(19).blu <=  30;
             k_rgb_index(20).red <=  70;  k_rgb_index(20).gre <=  46;  k_rgb_index(20).blu <=  30;
             k_rgb_index(21).red <= 160;  k_rgb_index(21).gre <=  80;  k_rgb_index(21).blu <=  60;
             k_rgb_index(22).red <= 140;  k_rgb_index(22).gre <= 100;  k_rgb_index(22).blu <=  50;
             k_rgb_index(23).red <= 140;  k_rgb_index(23).gre <=  70;  k_rgb_index(23).blu <=  50;
             k_rgb_index(24).red <= 120;  k_rgb_index(24).gre <=  80;  k_rgb_index(24).blu <=  30;
             k_rgb_index(25).red <= 120;  k_rgb_index(25).gre <=  60;  k_rgb_index(25).blu <=  30;
             k_rgb_index(26).red <= 100;  k_rgb_index(26).gre <=  75;  k_rgb_index(26).blu <=  25;
             k_rgb_index(27).red <= 100;  k_rgb_index(27).gre <=  50;  k_rgb_index(27).blu <=  25;
             k_rgb_index(28).red <=  80;  k_rgb_index(28).gre <=  60;  k_rgb_index(28).blu <=  30;
             k_rgb_index(29).red <=  80;  k_rgb_index(29).gre <=  40;  k_rgb_index(29).blu <=  30;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  40;  k_rgb_index(30).blu <=  15;
             k_rgb_index(31).red <=  60;  k_rgb_index(31).gre <=  30;  k_rgb_index(31).blu <=  15;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  20;  k_rgb_index(32).blu <=  10;
             k_rgb_index(33).red <=  50;  k_rgb_index(33).gre <=  15;  k_rgb_index(33).blu <=  10;
             k_rgb_index(34).red <= 201;  k_rgb_index(34).gre <=  51;  k_rgb_index(34).blu <=   1;
             k_rgb_index(35).red <= 101;  k_rgb_index(35).gre <=  53;  k_rgb_index(35).blu <=   3;
             k_rgb_index(36).red <= 255;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 200;
             k_rgb_index(37).red <= 200;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 230;
             k_rgb_index(38).red <= 200;  k_rgb_index(38).gre <= 224;  k_rgb_index(38).blu <= 190;
             k_rgb_index(39).red <= 190;  k_rgb_index(39).gre <= 224;  k_rgb_index(39).blu <= 200;
             k_rgb_index(40).red <= 150;  k_rgb_index(40).gre <= 200;  k_rgb_index(40).blu <= 130;
             k_rgb_index(41).red <= 130;  k_rgb_index(41).gre <= 200;  k_rgb_index(41).blu <= 150;
             k_rgb_index(42).red <= 150;  k_rgb_index(42).gre <= 180;  k_rgb_index(42).blu <= 120;
             k_rgb_index(43).red <= 120;  k_rgb_index(43).gre <= 180;  k_rgb_index(43).blu <= 150;
             k_rgb_index(44).red <= 120;  k_rgb_index(44).gre <= 150;  k_rgb_index(44).blu <= 100;
             k_rgb_index(45).red <= 100;  k_rgb_index(45).gre <= 150;  k_rgb_index(45).blu <= 120;
             k_rgb_index(46).red <=  50;  k_rgb_index(46).gre <= 100;  k_rgb_index(46).blu <=  30;
             k_rgb_index(47).red <=  30;  k_rgb_index(47).gre <= 100;  k_rgb_index(47).blu <=  50;
             k_rgb_index(48).red <=  50;  k_rgb_index(48).gre <=  75;  k_rgb_index(48).blu <=  30;
             k_rgb_index(49).red <=  30;  k_rgb_index(49).gre <=  75;  k_rgb_index(49).blu <=  50;
             k_rgb_index(50).red <=  40;  k_rgb_index(50).gre <=  50;  k_rgb_index(50).blu <=  20;
             k_rgb_index(51).red <=  20;  k_rgb_index(51).gre <=  50;  k_rgb_index(51).blu <=  40;
             k_rgb_index(52).red <=  30;  k_rgb_index(52).gre <=  40;  k_rgb_index(52).blu <=  30;
             k_rgb_index(53).red <=  25;  k_rgb_index(53).gre <=  30;  k_rgb_index(53).blu <=  20;
             k_rgb_index(54).red <=  53;  k_rgb_index(54).gre <= 126;  k_rgb_index(54).blu <=  47;
             k_rgb_index(55).red <=  20;  k_rgb_index(55).gre <= 161;  k_rgb_index(55).blu <=  31;
             k_rgb_index(56).red <=  15;  k_rgb_index(56).gre <= 220;  k_rgb_index(56).blu <=  15;
             k_rgb_index(57).red <=  15;  k_rgb_index(57).gre <= 230;  k_rgb_index(57).blu <=  15;
             k_rgb_index(58).red <=  15;  k_rgb_index(58).gre <= 140;  k_rgb_index(58).blu <=  15;
             k_rgb_index(59).red <=  25;  k_rgb_index(59).gre <= 250;  k_rgb_index(59).blu <=  25;
             k_rgb_index(60).red <=  35;  k_rgb_index(60).gre <= 160;  k_rgb_index(60).blu <=  35;
             k_rgb_index(61).red <= 240;  k_rgb_index(61).gre <= 255;  k_rgb_index(61).blu <= 220;
             k_rgb_index(62).red <= 220;  k_rgb_index(62).gre <= 240;  k_rgb_index(62).blu <= 200;
             k_rgb_index(63).red <= 200;  k_rgb_index(63).gre <= 220;  k_rgb_index(63).blu <= 150;
             k_rgb_index(64).red <= 180;  k_rgb_index(64).gre <= 230;  k_rgb_index(64).blu <= 100;
             k_rgb_index(65).red <= 150;  k_rgb_index(65).gre <= 200;  k_rgb_index(65).blu <=  80;
             k_rgb_index(66).red <= 100;  k_rgb_index(66).gre <= 190;  k_rgb_index(66).blu <=  60;
             k_rgb_index(67).red <=  90;  k_rgb_index(67).gre <= 180;  k_rgb_index(67).blu <=  60;
             k_rgb_index(68).red <=  75;  k_rgb_index(68).gre <= 150;  k_rgb_index(68).blu <=  45;
             k_rgb_index(69).red <=  70;  k_rgb_index(69).gre <= 130;  k_rgb_index(69).blu <=  45;
             k_rgb_index(70).red <=  70;  k_rgb_index(70).gre <= 100;  k_rgb_index(70).blu <=  45;
             k_rgb_index(71).red <= 220;  k_rgb_index(71).gre <= 240;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 200;  k_rgb_index(72).gre <= 220;  k_rgb_index(72).blu <= 240;
             k_rgb_index(73).red <= 150;  k_rgb_index(73).gre <= 200;  k_rgb_index(73).blu <= 220;
             k_rgb_index(74).red <= 100;  k_rgb_index(74).gre <= 180;  k_rgb_index(74).blu <= 230;
             k_rgb_index(75).red <=  80;  k_rgb_index(75).gre <= 150;  k_rgb_index(75).blu <= 200;
             k_rgb_index(76).red <=  60;  k_rgb_index(76).gre <= 100;  k_rgb_index(76).blu <= 190;
             k_rgb_index(77).red <=  60;  k_rgb_index(77).gre <=  90;  k_rgb_index(77).blu <= 180;
             k_rgb_index(78).red <=  45;  k_rgb_index(78).gre <=  75;  k_rgb_index(78).blu <= 150;
             k_rgb_index(79).red <=  45;  k_rgb_index(79).gre <=  70;  k_rgb_index(79).blu <= 130;
             k_rgb_index(80).red <=  45;  k_rgb_index(80).gre <=  70;  k_rgb_index(80).blu <= 100;
             k_rgb_index(81).red <=  30;  k_rgb_index(81).gre <=  50;  k_rgb_index(81).blu <=  90;
             k_rgb_index(82).red <=  30;  k_rgb_index(82).gre <=  40;  k_rgb_index(82).blu <=  70;
             k_rgb_index(83).red <=  20;  k_rgb_index(83).gre <=  25;  k_rgb_index(83).blu <=  60;
             k_rgb_index(84).red <=  55;  k_rgb_index(84).gre <=  54;  k_rgb_index(84).blu <= 183;
             k_rgb_index(85).red <=  65;  k_rgb_index(85).gre <=  66;  k_rgb_index(85).blu <= 193;
             k_rgb_index(86).red <=  75;  k_rgb_index(86).gre <=  75;  k_rgb_index(86).blu <= 100;
             k_rgb_index(87).red <=  85;  k_rgb_index(87).gre <=  85;  k_rgb_index(87).blu <= 110;
             k_rgb_index(88).red <=  95;  k_rgb_index(88).gre <=  95;  k_rgb_index(88).blu <= 120;
             k_rgb_index(89).red <= 100;  k_rgb_index(89).gre <= 101;  k_rgb_index(89).blu <= 180;
             k_rgb_index(90).red <=  70;  k_rgb_index(90).gre <=  91;  k_rgb_index(90).blu <= 192;
             k_rgb_index(91).red <=   7;  k_rgb_index(91).gre <=   6;  k_rgb_index(91).blu <= 171;
             k_rgb_index(92).red <=  40;  k_rgb_index(92).gre <=  60;  k_rgb_index(92).blu <= 181;
             k_rgb_index(93).red <= 100;  k_rgb_index(93).gre <= 101;  k_rgb_index(93).blu <= 170;
             k_rgb_index(94).red <= 130;  k_rgb_index(94).gre <=  85;  k_rgb_index(94).blu <= 157;
             k_rgb_index(95).red <=   6;  k_rgb_index(95).gre <=  83;  k_rgb_index(95).blu <= 155;
             k_rgb_index(96).red <=  30;  k_rgb_index(96).gre <=  50;  k_rgb_index(96).blu <= 160;
             k_rgb_index(97).red <=  90;  k_rgb_index(97).gre <=  91;  k_rgb_index(97).blu <= 170;
             k_rgb_index(98).red <=   2;  k_rgb_index(98).gre <=  60;  k_rgb_index(98).blu <= 137;
             k_rgb_index(99).red <=  35;  k_rgb_index(99).gre <=  46;  k_rgb_index(99).blu <=  70;
            k_rgb_index(100).red <=  25; k_rgb_index(100).gre <=  46; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  60;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  36; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  25; k_rgb_index(104).gre <=  36; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  15; k_rgb_index(105).gre <=  26; k_rgb_index(105).blu <=  40;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 2) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 251;   k_rgb_index(1).blu <= 242;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 241;   k_rgb_index(2).blu <= 232;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <= 231;   k_rgb_index(3).blu <= 202;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <= 221;   k_rgb_index(4).blu <= 182;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <= 211;   k_rgb_index(5).blu <= 122;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 201;   k_rgb_index(6).blu <= 142;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 191;   k_rgb_index(7).blu <= 132;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 181;   k_rgb_index(8).blu <= 122;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <= 171;   k_rgb_index(9).blu <= 112;
             k_rgb_index(10).red <= 250;  k_rgb_index(10).gre <= 191;  k_rgb_index(10).blu <= 172;
             k_rgb_index(11).red <= 250;  k_rgb_index(11).gre <= 181;  k_rgb_index(11).blu <= 162;
             k_rgb_index(12).red <= 250;  k_rgb_index(12).gre <=  81;  k_rgb_index(12).blu <=  62;
             k_rgb_index(13).red <= 250;  k_rgb_index(13).gre <= 181;  k_rgb_index(13).blu <= 142;
             k_rgb_index(14).red <= 250;  k_rgb_index(14).gre <= 171;  k_rgb_index(14).blu <= 132;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <=  51;  k_rgb_index(15).blu <=  12;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 181;  k_rgb_index(16).blu <=  92;
             k_rgb_index(17).red <= 200;  k_rgb_index(17).gre <= 161;  k_rgb_index(17).blu <= 132;
             k_rgb_index(18).red <= 200;  k_rgb_index(18).gre <= 151;  k_rgb_index(18).blu <= 122;
             k_rgb_index(19).red <= 200;  k_rgb_index(19).gre <= 151;  k_rgb_index(19).blu <= 112;
             k_rgb_index(20).red <= 200;  k_rgb_index(20).gre <= 141;  k_rgb_index(20).blu <= 102;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <=  31;  k_rgb_index(21).blu <=  22;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <=  71;  k_rgb_index(22).blu <=  42;
             k_rgb_index(23).red <= 150;  k_rgb_index(23).gre <=  91;  k_rgb_index(23).blu <=  62;
             k_rgb_index(24).red <= 150;  k_rgb_index(24).gre <=  81;  k_rgb_index(24).blu <=  52;
             k_rgb_index(25).red <= 150;  k_rgb_index(25).gre <=  81;  k_rgb_index(25).blu <=  42;
             k_rgb_index(26).red <= 150;  k_rgb_index(26).gre <=  71;  k_rgb_index(26).blu <=  32;
             k_rgb_index(27).red <= 150;  k_rgb_index(27).gre <=  51;  k_rgb_index(27).blu <=  22;
             k_rgb_index(28).red <=  60;  k_rgb_index(28).gre <=  51;  k_rgb_index(28).blu <=  42;
             k_rgb_index(29).red <=  60;  k_rgb_index(29).gre <=  41;  k_rgb_index(29).blu <=  32;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  41;  k_rgb_index(30).blu <=  22;
             k_rgb_index(31).red <=  55;  k_rgb_index(31).gre <=  31;  k_rgb_index(31).blu <=  12;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  31;  k_rgb_index(32).blu <=  32;
             k_rgb_index(33).red <=  45;  k_rgb_index(33).gre <=  31;  k_rgb_index(33).blu <=  22;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  31;  k_rgb_index(34).blu <=  22;
             k_rgb_index(35).red <=  30;  k_rgb_index(35).gre <=  21;  k_rgb_index(35).blu <=  12;
             k_rgb_index(36).red <= 245;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 256;
             k_rgb_index(37).red <= 235;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 100;
             k_rgb_index(38).red <= 205;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <=  50;
             k_rgb_index(39).red <= 185;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <=  25;
             k_rgb_index(40).red <= 125;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <=  10;
             k_rgb_index(41).red <=  90;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 200;
             k_rgb_index(42).red <=  80;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 150;
             k_rgb_index(43).red <=  70;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 100;
             k_rgb_index(44).red <=  35;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <=  50;
             k_rgb_index(45).red <= 150;  k_rgb_index(45).gre <= 250;  k_rgb_index(45).blu <= 200;
             k_rgb_index(46).red <= 125;  k_rgb_index(46).gre <= 250;  k_rgb_index(46).blu <= 190;
             k_rgb_index(47).red <= 110;  k_rgb_index(47).gre <= 250;  k_rgb_index(47).blu <= 180;
             k_rgb_index(48).red <= 100;  k_rgb_index(48).gre <= 250;  k_rgb_index(48).blu <= 170;
             k_rgb_index(49).red <=  90;  k_rgb_index(49).gre <= 250;  k_rgb_index(49).blu <= 160;
             k_rgb_index(50).red <= 150;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <= 200;
             k_rgb_index(51).red <= 125;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 190;
             k_rgb_index(52).red <= 110;  k_rgb_index(52).gre <= 200;  k_rgb_index(52).blu <= 180;
             k_rgb_index(53).red <= 100;  k_rgb_index(53).gre <= 200;  k_rgb_index(53).blu <= 170;
             k_rgb_index(54).red <=  90;  k_rgb_index(54).gre <= 200;  k_rgb_index(54).blu <= 160;
             k_rgb_index(55).red <=  80;  k_rgb_index(55).gre <= 200;  k_rgb_index(55).blu <= 150;
             k_rgb_index(56).red <=  80;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 150;
             k_rgb_index(57).red <=  80;  k_rgb_index(57).gre <= 150;  k_rgb_index(57).blu <= 140;
             k_rgb_index(58).red <=  70;  k_rgb_index(58).gre <= 150;  k_rgb_index(58).blu <= 130;
             k_rgb_index(59).red <=  70;  k_rgb_index(59).gre <= 150;  k_rgb_index(59).blu <= 120;
             k_rgb_index(60).red <=  60;  k_rgb_index(60).gre <= 150;  k_rgb_index(60).blu <= 100;
             k_rgb_index(61).red <=  60;  k_rgb_index(61).gre <= 150;  k_rgb_index(61).blu <=  90;
             k_rgb_index(62).red <=  50;  k_rgb_index(62).gre <= 150;  k_rgb_index(62).blu <=  80;
             k_rgb_index(63).red <=  30;  k_rgb_index(63).gre <=  60;  k_rgb_index(63).blu <=  50;
             k_rgb_index(64).red <=  20;  k_rgb_index(64).gre <=  60;  k_rgb_index(64).blu <=  40;
             k_rgb_index(65).red <=  10;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  30;
             k_rgb_index(66).red <=  15;  k_rgb_index(66).gre <=  55;  k_rgb_index(66).blu <=  36;
             k_rgb_index(67).red <=  35;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  36;
             k_rgb_index(68).red <=  25;  k_rgb_index(68).gre <=  45;  k_rgb_index(68).blu <=  35;
             k_rgb_index(69).red <=  20;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  30;
             k_rgb_index(70).red <=  10;  k_rgb_index(70).gre <=  30;  k_rgb_index(70).blu <=  15;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 100;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <=  50;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <=  25;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <=  10;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <=  90;  k_rgb_index(76).gre <= 200;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <=  80;  k_rgb_index(77).gre <= 150;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <=  70;  k_rgb_index(78).gre <= 100;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <=  35;  k_rgb_index(79).gre <=  50;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 150;  k_rgb_index(80).gre <= 200;  k_rgb_index(80).blu <= 250;
             k_rgb_index(81).red <= 125;  k_rgb_index(81).gre <= 190;  k_rgb_index(81).blu <= 250;
             k_rgb_index(82).red <= 110;  k_rgb_index(82).gre <= 180;  k_rgb_index(82).blu <= 250;
             k_rgb_index(83).red <= 100;  k_rgb_index(83).gre <= 170;  k_rgb_index(83).blu <= 250;
             k_rgb_index(84).red <=  90;  k_rgb_index(84).gre <= 160;  k_rgb_index(84).blu <= 250;
             k_rgb_index(85).red <= 150;  k_rgb_index(85).gre <= 200;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <= 125;  k_rgb_index(86).gre <= 190;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 110;  k_rgb_index(87).gre <= 180;  k_rgb_index(87).blu <= 200;
             k_rgb_index(88).red <= 100;  k_rgb_index(88).gre <= 170;  k_rgb_index(88).blu <= 200;
             k_rgb_index(89).red <=  90;  k_rgb_index(89).gre <= 160;  k_rgb_index(89).blu <= 200;
             k_rgb_index(90).red <=  80;  k_rgb_index(90).gre <= 150;  k_rgb_index(90).blu <= 200;
             k_rgb_index(91).red <=  80;  k_rgb_index(91).gre <= 150;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  80;  k_rgb_index(92).gre <= 140;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  70;  k_rgb_index(93).gre <= 130;  k_rgb_index(93).blu <= 150;
             k_rgb_index(94).red <=  70;  k_rgb_index(94).gre <= 120;  k_rgb_index(94).blu <= 150;
             k_rgb_index(95).red <=  60;  k_rgb_index(95).gre <= 100;  k_rgb_index(95).blu <= 150;
             k_rgb_index(96).red <=  60;  k_rgb_index(96).gre <=  90;  k_rgb_index(96).blu <= 150;
             k_rgb_index(97).red <=  50;  k_rgb_index(97).gre <=  80;  k_rgb_index(97).blu <= 150;
             k_rgb_index(98).red <=  30;  k_rgb_index(98).gre <=  50;  k_rgb_index(98).blu <=  60;
             k_rgb_index(99).red <=  20;  k_rgb_index(99).gre <=  40;  k_rgb_index(99).blu <=  60;
            k_rgb_index(100).red <=  10; k_rgb_index(100).gre <=  30; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  55;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  35; k_rgb_index(103).blu <=  45;
            k_rgb_index(104).red <=  20; k_rgb_index(104).gre <=  30; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  10; k_rgb_index(105).gre <=  15; k_rgb_index(105).blu <=  30;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 3) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 256;   k_rgb_index(1).blu <= 245;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 100;   k_rgb_index(2).blu <= 235;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <=  50;   k_rgb_index(3).blu <= 205;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <=  25;   k_rgb_index(4).blu <= 185;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <=  10;   k_rgb_index(5).blu <= 125;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 200;   k_rgb_index(6).blu <=  90;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 150;   k_rgb_index(7).blu <=  80;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 100;   k_rgb_index(8).blu <=  70;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <=  50;   k_rgb_index(9).blu <=  35;
             k_rgb_index(10).red <= 250;  k_rgb_index(10).gre <= 200;  k_rgb_index(10).blu <= 150;
             k_rgb_index(11).red <= 250;  k_rgb_index(11).gre <= 190;  k_rgb_index(11).blu <= 125;
             k_rgb_index(12).red <= 250;  k_rgb_index(12).gre <= 180;  k_rgb_index(12).blu <= 110;
             k_rgb_index(13).red <= 250;  k_rgb_index(13).gre <= 170;  k_rgb_index(13).blu <= 100;
             k_rgb_index(14).red <= 250;  k_rgb_index(14).gre <= 160;  k_rgb_index(14).blu <=  90;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <= 200;  k_rgb_index(15).blu <= 150;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 190;  k_rgb_index(16).blu <= 125;
             k_rgb_index(17).red <= 200;  k_rgb_index(17).gre <= 180;  k_rgb_index(17).blu <= 110;
             k_rgb_index(18).red <= 200;  k_rgb_index(18).gre <= 170;  k_rgb_index(18).blu <= 100;
             k_rgb_index(19).red <= 200;  k_rgb_index(19).gre <= 160;  k_rgb_index(19).blu <=  90;
             k_rgb_index(20).red <= 200;  k_rgb_index(20).gre <= 150;  k_rgb_index(20).blu <=  80;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <= 150;  k_rgb_index(21).blu <=  80;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <= 140;  k_rgb_index(22).blu <=  80;
             k_rgb_index(23).red <= 150;  k_rgb_index(23).gre <= 130;  k_rgb_index(23).blu <=  70;
             k_rgb_index(24).red <= 150;  k_rgb_index(24).gre <= 120;  k_rgb_index(24).blu <=  70;
             k_rgb_index(25).red <= 150;  k_rgb_index(25).gre <= 100;  k_rgb_index(25).blu <=  60;
             k_rgb_index(26).red <= 150;  k_rgb_index(26).gre <=  90;  k_rgb_index(26).blu <=  60;
             k_rgb_index(27).red <= 150;  k_rgb_index(27).gre <=  80;  k_rgb_index(27).blu <=  50;
             k_rgb_index(28).red <=  60;  k_rgb_index(28).gre <=  50;  k_rgb_index(28).blu <=  30;
             k_rgb_index(29).red <=  60;  k_rgb_index(29).gre <=  40;  k_rgb_index(29).blu <=  20;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  30;  k_rgb_index(30).blu <=  10;
             k_rgb_index(31).red <=  55;  k_rgb_index(31).gre <=  36;  k_rgb_index(31).blu <=  15;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  36;  k_rgb_index(32).blu <=  35;
             k_rgb_index(33).red <=  45;  k_rgb_index(33).gre <=  35;  k_rgb_index(33).blu <=  25;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  30;  k_rgb_index(34).blu <=  20;
             k_rgb_index(35).red <=  30;  k_rgb_index(35).gre <=  15;  k_rgb_index(35).blu <=  10;
             k_rgb_index(36).red <= 245;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 256;
             k_rgb_index(37).red <= 235;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 100;
             k_rgb_index(38).red <= 205;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <=  50;
             k_rgb_index(39).red <= 185;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <=  25;
             k_rgb_index(40).red <= 125;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <=  10;
             k_rgb_index(41).red <=  90;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 200;
             k_rgb_index(42).red <=  80;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 150;
             k_rgb_index(43).red <=  70;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 100;
             k_rgb_index(44).red <=  35;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <=  50;
             k_rgb_index(45).red <= 150;  k_rgb_index(45).gre <= 250;  k_rgb_index(45).blu <= 200;
             k_rgb_index(46).red <= 125;  k_rgb_index(46).gre <= 250;  k_rgb_index(46).blu <= 190;
             k_rgb_index(47).red <= 110;  k_rgb_index(47).gre <= 250;  k_rgb_index(47).blu <= 180;
             k_rgb_index(48).red <= 100;  k_rgb_index(48).gre <= 250;  k_rgb_index(48).blu <= 170;
             k_rgb_index(49).red <=  90;  k_rgb_index(49).gre <= 250;  k_rgb_index(49).blu <= 160;
             k_rgb_index(50).red <= 150;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <= 200;
             k_rgb_index(51).red <= 125;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 190;
             k_rgb_index(52).red <= 110;  k_rgb_index(52).gre <= 200;  k_rgb_index(52).blu <= 180;
             k_rgb_index(53).red <= 100;  k_rgb_index(53).gre <= 200;  k_rgb_index(53).blu <= 170;
             k_rgb_index(54).red <=  90;  k_rgb_index(54).gre <= 200;  k_rgb_index(54).blu <= 160;
             k_rgb_index(55).red <=  80;  k_rgb_index(55).gre <= 200;  k_rgb_index(55).blu <= 150;
             k_rgb_index(56).red <=  80;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 150;
             k_rgb_index(57).red <=  80;  k_rgb_index(57).gre <= 150;  k_rgb_index(57).blu <= 140;
             k_rgb_index(58).red <=  70;  k_rgb_index(58).gre <= 150;  k_rgb_index(58).blu <= 130;
             k_rgb_index(59).red <=  70;  k_rgb_index(59).gre <= 150;  k_rgb_index(59).blu <= 120;
             k_rgb_index(60).red <=  60;  k_rgb_index(60).gre <= 150;  k_rgb_index(60).blu <= 100;
             k_rgb_index(61).red <=  60;  k_rgb_index(61).gre <= 150;  k_rgb_index(61).blu <=  90;
             k_rgb_index(62).red <=  50;  k_rgb_index(62).gre <= 150;  k_rgb_index(62).blu <=  80;
             k_rgb_index(63).red <=  30;  k_rgb_index(63).gre <=  60;  k_rgb_index(63).blu <=  50;
             k_rgb_index(64).red <=  20;  k_rgb_index(64).gre <=  60;  k_rgb_index(64).blu <=  40;
             k_rgb_index(65).red <=  10;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  30;
             k_rgb_index(66).red <=  15;  k_rgb_index(66).gre <=  55;  k_rgb_index(66).blu <=  36;
             k_rgb_index(67).red <=  35;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  36;
             k_rgb_index(68).red <=  25;  k_rgb_index(68).gre <=  45;  k_rgb_index(68).blu <=  35;
             k_rgb_index(69).red <=  20;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  30;
             k_rgb_index(70).red <=  10;  k_rgb_index(70).gre <=  30;  k_rgb_index(70).blu <=  15;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 100;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <=  50;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <=  25;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <=  10;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <=  90;  k_rgb_index(76).gre <= 200;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <=  80;  k_rgb_index(77).gre <= 150;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <=  70;  k_rgb_index(78).gre <= 100;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <=  35;  k_rgb_index(79).gre <=  50;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 150;  k_rgb_index(80).gre <= 200;  k_rgb_index(80).blu <= 250;
             k_rgb_index(81).red <= 125;  k_rgb_index(81).gre <= 190;  k_rgb_index(81).blu <= 250;
             k_rgb_index(82).red <= 110;  k_rgb_index(82).gre <= 180;  k_rgb_index(82).blu <= 250;
             k_rgb_index(83).red <= 100;  k_rgb_index(83).gre <= 170;  k_rgb_index(83).blu <= 250;
             k_rgb_index(84).red <=  90;  k_rgb_index(84).gre <= 160;  k_rgb_index(84).blu <= 250;
             k_rgb_index(85).red <= 150;  k_rgb_index(85).gre <= 200;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <= 125;  k_rgb_index(86).gre <= 190;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 110;  k_rgb_index(87).gre <= 180;  k_rgb_index(87).blu <= 200;
             k_rgb_index(88).red <= 100;  k_rgb_index(88).gre <= 170;  k_rgb_index(88).blu <= 200;
             k_rgb_index(89).red <=  90;  k_rgb_index(89).gre <= 160;  k_rgb_index(89).blu <= 200;
             k_rgb_index(90).red <=  80;  k_rgb_index(90).gre <= 150;  k_rgb_index(90).blu <= 200;
             k_rgb_index(91).red <=  80;  k_rgb_index(91).gre <= 150;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  80;  k_rgb_index(92).gre <= 140;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  70;  k_rgb_index(93).gre <= 130;  k_rgb_index(93).blu <= 150;
             k_rgb_index(94).red <=  70;  k_rgb_index(94).gre <= 120;  k_rgb_index(94).blu <= 150;
             k_rgb_index(95).red <=  60;  k_rgb_index(95).gre <= 100;  k_rgb_index(95).blu <= 150;
             k_rgb_index(96).red <=  60;  k_rgb_index(96).gre <=  90;  k_rgb_index(96).blu <= 150;
             k_rgb_index(97).red <=  50;  k_rgb_index(97).gre <=  80;  k_rgb_index(97).blu <= 150;
             k_rgb_index(98).red <=  30;  k_rgb_index(98).gre <=  50;  k_rgb_index(98).blu <=  60;
             k_rgb_index(99).red <=  20;  k_rgb_index(99).gre <=  40;  k_rgb_index(99).blu <=  60;
            k_rgb_index(100).red <=  10; k_rgb_index(100).gre <=  30; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  55;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  35; k_rgb_index(103).blu <=  45;
            k_rgb_index(104).red <=  20; k_rgb_index(104).gre <=  30; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  10; k_rgb_index(105).gre <=  15; k_rgb_index(105).blu <=  30;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 4) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 256;   k_rgb_index(1).blu <= 245;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 100;   k_rgb_index(2).blu <= 235;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <=  50;   k_rgb_index(3).blu <= 205;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <=  25;   k_rgb_index(4).blu <= 185;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <=  10;   k_rgb_index(5).blu <= 125;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 200;   k_rgb_index(6).blu <=  90;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 150;   k_rgb_index(7).blu <=  80;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 100;   k_rgb_index(8).blu <=  70;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <=  50;   k_rgb_index(9).blu <=  35;
             k_rgb_index(10).red <= 250;  k_rgb_index(10).gre <= 200;  k_rgb_index(10).blu <= 150;
             k_rgb_index(11).red <= 250;  k_rgb_index(11).gre <= 190;  k_rgb_index(11).blu <= 125;
             k_rgb_index(12).red <= 250;  k_rgb_index(12).gre <= 180;  k_rgb_index(12).blu <= 110;
             k_rgb_index(13).red <= 250;  k_rgb_index(13).gre <= 170;  k_rgb_index(13).blu <= 100;
             k_rgb_index(14).red <= 250;  k_rgb_index(14).gre <= 160;  k_rgb_index(14).blu <=  90;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <= 200;  k_rgb_index(15).blu <= 150;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 190;  k_rgb_index(16).blu <= 125;
             k_rgb_index(17).red <= 200;  k_rgb_index(17).gre <= 180;  k_rgb_index(17).blu <= 110;
             k_rgb_index(18).red <= 200;  k_rgb_index(18).gre <= 170;  k_rgb_index(18).blu <= 100;
             k_rgb_index(19).red <= 200;  k_rgb_index(19).gre <= 160;  k_rgb_index(19).blu <=  90;
             k_rgb_index(20).red <= 200;  k_rgb_index(20).gre <= 150;  k_rgb_index(20).blu <=  80;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <= 150;  k_rgb_index(21).blu <=  80;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <= 140;  k_rgb_index(22).blu <=  80;
             k_rgb_index(23).red <= 150;  k_rgb_index(23).gre <= 130;  k_rgb_index(23).blu <=  70;
             k_rgb_index(24).red <= 150;  k_rgb_index(24).gre <= 120;  k_rgb_index(24).blu <=  70;
             k_rgb_index(25).red <= 150;  k_rgb_index(25).gre <= 100;  k_rgb_index(25).blu <=  60;
             k_rgb_index(26).red <= 150;  k_rgb_index(26).gre <=  90;  k_rgb_index(26).blu <=  60;
             k_rgb_index(27).red <= 150;  k_rgb_index(27).gre <=  80;  k_rgb_index(27).blu <=  50;
             k_rgb_index(28).red <=  60;  k_rgb_index(28).gre <=  50;  k_rgb_index(28).blu <=  30;
             k_rgb_index(29).red <=  60;  k_rgb_index(29).gre <=  40;  k_rgb_index(29).blu <=  20;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  30;  k_rgb_index(30).blu <=  10;
             k_rgb_index(31).red <=  55;  k_rgb_index(31).gre <=  36;  k_rgb_index(31).blu <=  15;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  36;  k_rgb_index(32).blu <=  35;
             k_rgb_index(33).red <=  45;  k_rgb_index(33).gre <=  35;  k_rgb_index(33).blu <=  25;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  30;  k_rgb_index(34).blu <=  20;
             k_rgb_index(35).red <=  30;  k_rgb_index(35).gre <=  15;  k_rgb_index(35).blu <=  10;
             k_rgb_index(36).red <= 245;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 256;
             k_rgb_index(37).red <= 235;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 100;
             k_rgb_index(38).red <= 205;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <=  50;
             k_rgb_index(39).red <= 185;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <=  25;
             k_rgb_index(40).red <= 125;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <=  10;
             k_rgb_index(41).red <=  90;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 200;
             k_rgb_index(42).red <=  80;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 150;
             k_rgb_index(43).red <=  70;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 100;
             k_rgb_index(44).red <=  35;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <=  50;
             k_rgb_index(45).red <= 150;  k_rgb_index(45).gre <= 250;  k_rgb_index(45).blu <= 200;
             k_rgb_index(46).red <= 125;  k_rgb_index(46).gre <= 250;  k_rgb_index(46).blu <= 190;
             k_rgb_index(47).red <= 110;  k_rgb_index(47).gre <= 250;  k_rgb_index(47).blu <= 180;
             k_rgb_index(48).red <= 100;  k_rgb_index(48).gre <= 250;  k_rgb_index(48).blu <= 170;
             k_rgb_index(49).red <=  90;  k_rgb_index(49).gre <= 250;  k_rgb_index(49).blu <= 160;
             k_rgb_index(50).red <= 150;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <= 200;
             k_rgb_index(51).red <= 125;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 190;
             k_rgb_index(52).red <= 110;  k_rgb_index(52).gre <= 200;  k_rgb_index(52).blu <= 180;
             k_rgb_index(53).red <= 100;  k_rgb_index(53).gre <= 200;  k_rgb_index(53).blu <= 170;
             k_rgb_index(54).red <=  90;  k_rgb_index(54).gre <= 200;  k_rgb_index(54).blu <= 160;
             k_rgb_index(55).red <=  80;  k_rgb_index(55).gre <= 200;  k_rgb_index(55).blu <= 150;
             k_rgb_index(56).red <=  80;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 150;
             k_rgb_index(57).red <=  80;  k_rgb_index(57).gre <= 150;  k_rgb_index(57).blu <= 140;
             k_rgb_index(58).red <=  70;  k_rgb_index(58).gre <= 150;  k_rgb_index(58).blu <= 130;
             k_rgb_index(59).red <=  70;  k_rgb_index(59).gre <= 150;  k_rgb_index(59).blu <= 120;
             k_rgb_index(60).red <=  60;  k_rgb_index(60).gre <= 150;  k_rgb_index(60).blu <= 100;
             k_rgb_index(61).red <=  60;  k_rgb_index(61).gre <= 150;  k_rgb_index(61).blu <=  90;
             k_rgb_index(62).red <=  50;  k_rgb_index(62).gre <= 150;  k_rgb_index(62).blu <=  80;
             k_rgb_index(63).red <=  30;  k_rgb_index(63).gre <=  60;  k_rgb_index(63).blu <=  50;
             k_rgb_index(64).red <=  20;  k_rgb_index(64).gre <=  60;  k_rgb_index(64).blu <=  40;
             k_rgb_index(65).red <=  10;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  30;
             k_rgb_index(66).red <=  15;  k_rgb_index(66).gre <=  55;  k_rgb_index(66).blu <=  36;
             k_rgb_index(67).red <=  35;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  36;
             k_rgb_index(68).red <=  25;  k_rgb_index(68).gre <=  45;  k_rgb_index(68).blu <=  35;
             k_rgb_index(69).red <=  20;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  30;
             k_rgb_index(70).red <=  10;  k_rgb_index(70).gre <=  30;  k_rgb_index(70).blu <=  15;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 100;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <=  50;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <=  25;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <=  10;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <=  90;  k_rgb_index(76).gre <= 200;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <=  80;  k_rgb_index(77).gre <= 150;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <=  70;  k_rgb_index(78).gre <= 100;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <=  35;  k_rgb_index(79).gre <=  50;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 150;  k_rgb_index(80).gre <= 200;  k_rgb_index(80).blu <= 250;
             k_rgb_index(81).red <= 125;  k_rgb_index(81).gre <= 190;  k_rgb_index(81).blu <= 250;
             k_rgb_index(82).red <= 110;  k_rgb_index(82).gre <= 180;  k_rgb_index(82).blu <= 250;
             k_rgb_index(83).red <= 100;  k_rgb_index(83).gre <= 170;  k_rgb_index(83).blu <= 250;
             k_rgb_index(84).red <=  90;  k_rgb_index(84).gre <= 160;  k_rgb_index(84).blu <= 250;
             k_rgb_index(85).red <= 150;  k_rgb_index(85).gre <= 200;  k_rgb_index(85).blu <= 210;
             k_rgb_index(86).red <= 125;  k_rgb_index(86).gre <= 190;  k_rgb_index(86).blu <= 210;
             k_rgb_index(87).red <= 110;  k_rgb_index(87).gre <= 180;  k_rgb_index(87).blu <= 210;
             k_rgb_index(88).red <= 100;  k_rgb_index(88).gre <= 170;  k_rgb_index(88).blu <= 210;
             k_rgb_index(89).red <=  90;  k_rgb_index(89).gre <= 160;  k_rgb_index(89).blu <= 210;
             k_rgb_index(90).red <=  80;  k_rgb_index(90).gre <= 150;  k_rgb_index(90).blu <= 210;
             k_rgb_index(91).red <=  80;  k_rgb_index(91).gre <= 150;  k_rgb_index(91).blu <= 170;
             k_rgb_index(92).red <=  80;  k_rgb_index(92).gre <= 140;  k_rgb_index(92).blu <= 170;
             k_rgb_index(93).red <=  70;  k_rgb_index(93).gre <= 130;  k_rgb_index(93).blu <= 170;
             k_rgb_index(94).red <=  70;  k_rgb_index(94).gre <= 120;  k_rgb_index(94).blu <= 170;
             k_rgb_index(95).red <=  60;  k_rgb_index(95).gre <= 100;  k_rgb_index(95).blu <= 170;
             k_rgb_index(96).red <=  60;  k_rgb_index(96).gre <=  90;  k_rgb_index(96).blu <= 170;
             k_rgb_index(97).red <=  50;  k_rgb_index(97).gre <=  80;  k_rgb_index(97).blu <= 170;
             k_rgb_index(98).red <=  30;  k_rgb_index(98).gre <=  50;  k_rgb_index(98).blu <=  50;
             k_rgb_index(99).red <=  20;  k_rgb_index(99).gre <=  40;  k_rgb_index(99).blu <=  50;
            k_rgb_index(100).red <=  10; k_rgb_index(100).gre <=  30; k_rgb_index(100).blu <=  50;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  50;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  35; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  20; k_rgb_index(104).gre <=  30; k_rgb_index(104).blu <=  50;
            k_rgb_index(105).red <=  10; k_rgb_index(105).gre <=  15; k_rgb_index(105).blu <=  50;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 5) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 256;   k_rgb_index(1).blu <= 245;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 100;   k_rgb_index(2).blu <= 235;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <=  50;   k_rgb_index(3).blu <= 205;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <=  25;   k_rgb_index(4).blu <= 185;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <=  10;   k_rgb_index(5).blu <= 125;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 200;   k_rgb_index(6).blu <=  90;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 150;   k_rgb_index(7).blu <=  80;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 100;   k_rgb_index(8).blu <=  70;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <=  50;   k_rgb_index(9).blu <=  35;
             k_rgb_index(10).red <= 250;  k_rgb_index(10).gre <= 200;  k_rgb_index(10).blu <= 150;
             k_rgb_index(11).red <= 250;  k_rgb_index(11).gre <= 190;  k_rgb_index(11).blu <= 125;
             k_rgb_index(12).red <= 250;  k_rgb_index(12).gre <= 180;  k_rgb_index(12).blu <= 110;
             k_rgb_index(13).red <= 250;  k_rgb_index(13).gre <= 170;  k_rgb_index(13).blu <= 100;
             k_rgb_index(14).red <= 250;  k_rgb_index(14).gre <= 160;  k_rgb_index(14).blu <=  90;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <= 200;  k_rgb_index(15).blu <= 150;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 190;  k_rgb_index(16).blu <= 125;
             k_rgb_index(17).red <= 200;  k_rgb_index(17).gre <= 180;  k_rgb_index(17).blu <= 110;
             k_rgb_index(18).red <= 200;  k_rgb_index(18).gre <= 170;  k_rgb_index(18).blu <= 100;
             k_rgb_index(19).red <= 200;  k_rgb_index(19).gre <= 160;  k_rgb_index(19).blu <=  90;
             k_rgb_index(20).red <= 200;  k_rgb_index(20).gre <= 150;  k_rgb_index(20).blu <=  80;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <= 150;  k_rgb_index(21).blu <=  80;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <= 140;  k_rgb_index(22).blu <=  80;
             k_rgb_index(23).red <= 150;  k_rgb_index(23).gre <= 130;  k_rgb_index(23).blu <=  70;
             k_rgb_index(24).red <= 150;  k_rgb_index(24).gre <= 120;  k_rgb_index(24).blu <=  70;
             k_rgb_index(25).red <= 150;  k_rgb_index(25).gre <= 100;  k_rgb_index(25).blu <=  60;
             k_rgb_index(26).red <= 150;  k_rgb_index(26).gre <=  90;  k_rgb_index(26).blu <=  60;
             k_rgb_index(27).red <= 150;  k_rgb_index(27).gre <=  80;  k_rgb_index(27).blu <=  50;
             k_rgb_index(28).red <=  60;  k_rgb_index(28).gre <=  50;  k_rgb_index(28).blu <=  30;
             k_rgb_index(29).red <=  60;  k_rgb_index(29).gre <=  40;  k_rgb_index(29).blu <=  20;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  30;  k_rgb_index(30).blu <=  10;
             k_rgb_index(31).red <=  55;  k_rgb_index(31).gre <=  36;  k_rgb_index(31).blu <=  15;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  36;  k_rgb_index(32).blu <=  35;
             k_rgb_index(33).red <=  45;  k_rgb_index(33).gre <=  35;  k_rgb_index(33).blu <=  25;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  30;  k_rgb_index(34).blu <=  20;
             k_rgb_index(35).red <=  30;  k_rgb_index(35).gre <=  15;  k_rgb_index(35).blu <=  10;
             k_rgb_index(36).red <= 245;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 256;
             k_rgb_index(37).red <= 235;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 100;
             k_rgb_index(38).red <= 205;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <=  50;
             k_rgb_index(39).red <= 185;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <=  25;
             k_rgb_index(40).red <= 125;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <=  10;
             k_rgb_index(41).red <=  90;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 200;
             k_rgb_index(42).red <=  80;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 150;
             k_rgb_index(43).red <=  70;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 100;
             k_rgb_index(44).red <=  35;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <=  50;
             k_rgb_index(45).red <= 150;  k_rgb_index(45).gre <= 250;  k_rgb_index(45).blu <= 200;
             k_rgb_index(46).red <= 125;  k_rgb_index(46).gre <= 250;  k_rgb_index(46).blu <= 190;
             k_rgb_index(47).red <= 110;  k_rgb_index(47).gre <= 250;  k_rgb_index(47).blu <= 180;
             k_rgb_index(48).red <= 100;  k_rgb_index(48).gre <= 250;  k_rgb_index(48).blu <= 170;
             k_rgb_index(49).red <=  90;  k_rgb_index(49).gre <= 250;  k_rgb_index(49).blu <= 160;
             k_rgb_index(50).red <= 150;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <= 200;
             k_rgb_index(51).red <= 125;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 190;
             k_rgb_index(52).red <= 110;  k_rgb_index(52).gre <= 200;  k_rgb_index(52).blu <= 180;
             k_rgb_index(53).red <= 100;  k_rgb_index(53).gre <= 200;  k_rgb_index(53).blu <= 170;
             k_rgb_index(54).red <=  90;  k_rgb_index(54).gre <= 200;  k_rgb_index(54).blu <= 160;
             k_rgb_index(55).red <=  80;  k_rgb_index(55).gre <= 200;  k_rgb_index(55).blu <= 150;
             k_rgb_index(56).red <=  80;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 150;
             k_rgb_index(57).red <=  80;  k_rgb_index(57).gre <= 150;  k_rgb_index(57).blu <= 140;
             k_rgb_index(58).red <=  70;  k_rgb_index(58).gre <= 150;  k_rgb_index(58).blu <= 130;
             k_rgb_index(59).red <=  70;  k_rgb_index(59).gre <= 150;  k_rgb_index(59).blu <= 120;
             k_rgb_index(60).red <=  60;  k_rgb_index(60).gre <= 150;  k_rgb_index(60).blu <= 100;
             k_rgb_index(61).red <=  60;  k_rgb_index(61).gre <= 150;  k_rgb_index(61).blu <=  90;
             k_rgb_index(62).red <=  50;  k_rgb_index(62).gre <= 150;  k_rgb_index(62).blu <=  80;
             k_rgb_index(63).red <=  30;  k_rgb_index(63).gre <=  60;  k_rgb_index(63).blu <=  50;
             k_rgb_index(64).red <=  20;  k_rgb_index(64).gre <=  60;  k_rgb_index(64).blu <=  40;
             k_rgb_index(65).red <=  10;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  30;
             k_rgb_index(66).red <=  15;  k_rgb_index(66).gre <=  55;  k_rgb_index(66).blu <=  36;
             k_rgb_index(67).red <=  35;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  36;
             k_rgb_index(68).red <=  25;  k_rgb_index(68).gre <=  45;  k_rgb_index(68).blu <=  35;
             k_rgb_index(69).red <=  20;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  30;
             k_rgb_index(70).red <=  10;  k_rgb_index(70).gre <=  30;  k_rgb_index(70).blu <=  15;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 100;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <=  50;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <=  25;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <=  10;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <=  90;  k_rgb_index(76).gre <= 200;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <=  80;  k_rgb_index(77).gre <= 150;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <=  70;  k_rgb_index(78).gre <= 100;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <=  35;  k_rgb_index(79).gre <=  50;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 150;  k_rgb_index(80).gre <= 200;  k_rgb_index(80).blu <= 250;
             k_rgb_index(81).red <= 125;  k_rgb_index(81).gre <= 190;  k_rgb_index(81).blu <= 250;
             k_rgb_index(82).red <= 110;  k_rgb_index(82).gre <= 180;  k_rgb_index(82).blu <= 250;
             k_rgb_index(83).red <= 100;  k_rgb_index(83).gre <= 170;  k_rgb_index(83).blu <= 250;
             k_rgb_index(84).red <=  90;  k_rgb_index(84).gre <= 160;  k_rgb_index(84).blu <= 250;
             k_rgb_index(85).red <= 150;  k_rgb_index(85).gre <= 200;  k_rgb_index(85).blu <= 210;
             k_rgb_index(86).red <= 125;  k_rgb_index(86).gre <= 190;  k_rgb_index(86).blu <= 210;
             k_rgb_index(87).red <= 110;  k_rgb_index(87).gre <= 180;  k_rgb_index(87).blu <= 210;
             k_rgb_index(88).red <= 100;  k_rgb_index(88).gre <= 170;  k_rgb_index(88).blu <= 210;
             k_rgb_index(89).red <=  90;  k_rgb_index(89).gre <= 160;  k_rgb_index(89).blu <= 210;
             k_rgb_index(90).red <=  80;  k_rgb_index(90).gre <= 150;  k_rgb_index(90).blu <= 210;
             k_rgb_index(91).red <=  50;  k_rgb_index(91).gre <=  50;  k_rgb_index(91).blu <= 100;
             k_rgb_index(92).red <=  40;  k_rgb_index(92).gre <=  40;  k_rgb_index(92).blu <= 100;
             k_rgb_index(93).red <=  30;  k_rgb_index(93).gre <=  30;  k_rgb_index(93).blu <= 100;
             k_rgb_index(94).red <=  20;  k_rgb_index(94).gre <=  20;  k_rgb_index(94).blu <= 100;
             k_rgb_index(95).red <=  00;  k_rgb_index(95).gre <=  00;  k_rgb_index(95).blu <= 100;
             k_rgb_index(96).red <=  90;  k_rgb_index(96).gre <=  90;  k_rgb_index(96).blu <= 100;
             k_rgb_index(97).red <=  80;  k_rgb_index(97).gre <=  80;  k_rgb_index(97).blu <= 100;
             k_rgb_index(98).red <=  30;  k_rgb_index(98).gre <=  50;  k_rgb_index(98).blu <=  50;
             k_rgb_index(99).red <=  20;  k_rgb_index(99).gre <=  40;  k_rgb_index(99).blu <=  50;
            k_rgb_index(100).red <=  10; k_rgb_index(100).gre <=  30; k_rgb_index(100).blu <=  50;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  50;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  35; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  20; k_rgb_index(104).gre <=  30; k_rgb_index(104).blu <=  50;
            k_rgb_index(105).red <=  10; k_rgb_index(105).gre <=  15; k_rgb_index(105).blu <=  50;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 6) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 256;   k_rgb_index(1).blu <= 245;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 100;   k_rgb_index(2).blu <= 235;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <=  50;   k_rgb_index(3).blu <= 205;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <=  25;   k_rgb_index(4).blu <= 185;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <=  10;   k_rgb_index(5).blu <= 125;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 200;   k_rgb_index(6).blu <=  90;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 150;   k_rgb_index(7).blu <=  80;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 100;   k_rgb_index(8).blu <=  70;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <=  50;   k_rgb_index(9).blu <=  35;
             k_rgb_index(10).red <= 250;  k_rgb_index(10).gre <= 200;  k_rgb_index(10).blu <= 150;
             k_rgb_index(11).red <= 250;  k_rgb_index(11).gre <= 190;  k_rgb_index(11).blu <= 125;
             k_rgb_index(12).red <= 250;  k_rgb_index(12).gre <= 180;  k_rgb_index(12).blu <= 110;
             k_rgb_index(13).red <= 250;  k_rgb_index(13).gre <= 170;  k_rgb_index(13).blu <= 100;
             k_rgb_index(14).red <= 250;  k_rgb_index(14).gre <= 160;  k_rgb_index(14).blu <=  90;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <= 200;  k_rgb_index(15).blu <= 150;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 190;  k_rgb_index(16).blu <= 125;
             k_rgb_index(17).red <= 200;  k_rgb_index(17).gre <= 180;  k_rgb_index(17).blu <= 110;
             k_rgb_index(18).red <= 200;  k_rgb_index(18).gre <= 170;  k_rgb_index(18).blu <= 100;
             k_rgb_index(19).red <= 200;  k_rgb_index(19).gre <= 160;  k_rgb_index(19).blu <=  90;
             k_rgb_index(20).red <= 200;  k_rgb_index(20).gre <= 150;  k_rgb_index(20).blu <=  80;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <= 150;  k_rgb_index(21).blu <=  80;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <= 140;  k_rgb_index(22).blu <=  80;
             k_rgb_index(23).red <= 150;  k_rgb_index(23).gre <= 130;  k_rgb_index(23).blu <=  70;
             k_rgb_index(24).red <= 150;  k_rgb_index(24).gre <= 120;  k_rgb_index(24).blu <=  70;
             k_rgb_index(25).red <= 150;  k_rgb_index(25).gre <= 100;  k_rgb_index(25).blu <=  60;
             k_rgb_index(26).red <= 150;  k_rgb_index(26).gre <=  90;  k_rgb_index(26).blu <=  60;
             k_rgb_index(27).red <= 150;  k_rgb_index(27).gre <=  80;  k_rgb_index(27).blu <=  50;
             k_rgb_index(28).red <=  60;  k_rgb_index(28).gre <=  50;  k_rgb_index(28).blu <=  30;
             k_rgb_index(29).red <=  60;  k_rgb_index(29).gre <=  40;  k_rgb_index(29).blu <=  20;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  30;  k_rgb_index(30).blu <=  10;
             k_rgb_index(31).red <=  55;  k_rgb_index(31).gre <=  36;  k_rgb_index(31).blu <=  15;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  36;  k_rgb_index(32).blu <=  35;
             k_rgb_index(33).red <=  45;  k_rgb_index(33).gre <=  35;  k_rgb_index(33).blu <=  25;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  30;  k_rgb_index(34).blu <=  20;
             k_rgb_index(35).red <=  30;  k_rgb_index(35).gre <=  15;  k_rgb_index(35).blu <=  10;
             k_rgb_index(36).red <= 255;  k_rgb_index(36).gre <= 256;  k_rgb_index(36).blu <= 245; 
             k_rgb_index(37).red <= 255;  k_rgb_index(37).gre <= 100;  k_rgb_index(37).blu <= 235; 
             k_rgb_index(38).red <= 255;  k_rgb_index(38).gre <=  50;  k_rgb_index(38).blu <= 205; 
             k_rgb_index(39).red <= 255;  k_rgb_index(39).gre <=  25;  k_rgb_index(39).blu <= 185; 
             k_rgb_index(40).red <= 255;  k_rgb_index(40).gre <=  10;  k_rgb_index(40).blu <= 125; 
             k_rgb_index(41).red <= 255;  k_rgb_index(41).gre <= 200;  k_rgb_index(41).blu <=  90; 
             k_rgb_index(42).red <= 255;  k_rgb_index(42).gre <= 150;  k_rgb_index(42).blu <=  80; 
             k_rgb_index(43).red <= 255;  k_rgb_index(43).gre <= 100;  k_rgb_index(43).blu <=  70; 
             k_rgb_index(44).red <= 255;  k_rgb_index(44).gre <=  50;  k_rgb_index(44).blu <=  35; 
             k_rgb_index(45).red <= 250;  k_rgb_index(45).gre <= 200;  k_rgb_index(45).blu <= 150; 
             k_rgb_index(46).red <= 250;  k_rgb_index(46).gre <= 190;  k_rgb_index(46).blu <= 125; 
             k_rgb_index(47).red <= 250;  k_rgb_index(47).gre <= 180;  k_rgb_index(47).blu <= 110; 
             k_rgb_index(48).red <= 250;  k_rgb_index(48).gre <= 170;  k_rgb_index(48).blu <= 100; 
             k_rgb_index(49).red <= 250;  k_rgb_index(49).gre <= 160;  k_rgb_index(49).blu <=  90; 
             k_rgb_index(50).red <= 200;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <= 150; 
             k_rgb_index(51).red <= 200;  k_rgb_index(51).gre <= 190;  k_rgb_index(51).blu <= 125; 
             k_rgb_index(52).red <= 200;  k_rgb_index(52).gre <= 180;  k_rgb_index(52).blu <= 110; 
             k_rgb_index(53).red <= 200;  k_rgb_index(53).gre <= 170;  k_rgb_index(53).blu <= 100; 
             k_rgb_index(54).red <= 200;  k_rgb_index(54).gre <= 160;  k_rgb_index(54).blu <=  90; 
             k_rgb_index(55).red <= 200;  k_rgb_index(55).gre <= 150;  k_rgb_index(55).blu <=  80; 
             k_rgb_index(56).red <= 150;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <=  80; 
             k_rgb_index(57).red <= 150;  k_rgb_index(57).gre <= 140;  k_rgb_index(57).blu <=  80; 
             k_rgb_index(58).red <= 150;  k_rgb_index(58).gre <= 130;  k_rgb_index(58).blu <=  70; 
             k_rgb_index(59).red <= 150;  k_rgb_index(59).gre <= 120;  k_rgb_index(59).blu <=  70; 
             k_rgb_index(60).red <= 150;  k_rgb_index(60).gre <= 100;  k_rgb_index(60).blu <=  60; 
             k_rgb_index(61).red <= 150;  k_rgb_index(61).gre <=  90;  k_rgb_index(61).blu <=  60; 
             k_rgb_index(62).red <= 150;  k_rgb_index(62).gre <=  80;  k_rgb_index(62).blu <=  50; 
             k_rgb_index(63).red <=  60;  k_rgb_index(63).gre <=  50;  k_rgb_index(63).blu <=  30; 
             k_rgb_index(64).red <=  60;  k_rgb_index(64).gre <=  40;  k_rgb_index(64).blu <=  20; 
             k_rgb_index(65).red <=  60;  k_rgb_index(65).gre <=  30;  k_rgb_index(65).blu <=  10; 
             k_rgb_index(66).red <=  55;  k_rgb_index(66).gre <=  36;  k_rgb_index(66).blu <=  15; 
             k_rgb_index(67).red <=  50;  k_rgb_index(67).gre <=  36;  k_rgb_index(67).blu <=  35; 
             k_rgb_index(68).red <=  45;  k_rgb_index(68).gre <=  35;  k_rgb_index(68).blu <=  25; 
             k_rgb_index(69).red <=  40;  k_rgb_index(69).gre <=  30;  k_rgb_index(69).blu <=  20; 
             k_rgb_index(70).red <=  30;  k_rgb_index(70).gre <=  15;  k_rgb_index(70).blu <=  10; 
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 100;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <=  50;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <=  25;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <=  10;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <=  90;  k_rgb_index(76).gre <= 200;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <=  80;  k_rgb_index(77).gre <= 150;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <=  70;  k_rgb_index(78).gre <= 100;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <=  35;  k_rgb_index(79).gre <=  50;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 150;  k_rgb_index(80).gre <= 200;  k_rgb_index(80).blu <= 250;
             k_rgb_index(81).red <= 125;  k_rgb_index(81).gre <= 190;  k_rgb_index(81).blu <= 250;
             k_rgb_index(82).red <= 110;  k_rgb_index(82).gre <= 180;  k_rgb_index(82).blu <= 250;
             k_rgb_index(83).red <= 100;  k_rgb_index(83).gre <= 170;  k_rgb_index(83).blu <= 250;
             k_rgb_index(84).red <=  90;  k_rgb_index(84).gre <= 160;  k_rgb_index(84).blu <= 250;
             k_rgb_index(85).red <= 150;  k_rgb_index(85).gre <= 200;  k_rgb_index(85).blu <= 210;
             k_rgb_index(86).red <= 125;  k_rgb_index(86).gre <= 190;  k_rgb_index(86).blu <= 210;
             k_rgb_index(87).red <= 110;  k_rgb_index(87).gre <= 180;  k_rgb_index(87).blu <= 210;
             k_rgb_index(88).red <= 100;  k_rgb_index(88).gre <= 170;  k_rgb_index(88).blu <= 210;
             k_rgb_index(89).red <=  90;  k_rgb_index(89).gre <= 160;  k_rgb_index(89).blu <= 210;
             k_rgb_index(90).red <=  80;  k_rgb_index(90).gre <= 150;  k_rgb_index(90).blu <= 210;
             k_rgb_index(91).red <=  80;  k_rgb_index(91).gre <= 150;  k_rgb_index(91).blu <= 170;
             k_rgb_index(92).red <=  80;  k_rgb_index(92).gre <= 140;  k_rgb_index(92).blu <= 170;
             k_rgb_index(93).red <=  70;  k_rgb_index(93).gre <= 130;  k_rgb_index(93).blu <= 170;
             k_rgb_index(94).red <=  70;  k_rgb_index(94).gre <= 120;  k_rgb_index(94).blu <= 170;
             k_rgb_index(95).red <=  60;  k_rgb_index(95).gre <= 100;  k_rgb_index(95).blu <= 170;
             k_rgb_index(96).red <=  60;  k_rgb_index(96).gre <=  90;  k_rgb_index(96).blu <= 170;
             k_rgb_index(97).red <=  50;  k_rgb_index(97).gre <=  80;  k_rgb_index(97).blu <= 170;
             k_rgb_index(98).red <=  30;  k_rgb_index(98).gre <=  50;  k_rgb_index(98).blu <=  50;
             k_rgb_index(99).red <=  20;  k_rgb_index(99).gre <=  40;  k_rgb_index(99).blu <=  50;
            k_rgb_index(100).red <=  10; k_rgb_index(100).gre <=  30; k_rgb_index(100).blu <=  50;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  50;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  35; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  20; k_rgb_index(104).gre <=  30; k_rgb_index(104).blu <=  50;
            k_rgb_index(105).red <=  10; k_rgb_index(105).gre <=  15; k_rgb_index(105).blu <=  50;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 7) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 251;   k_rgb_index(1).blu <= 242;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 241;   k_rgb_index(2).blu <= 232;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <= 231;   k_rgb_index(3).blu <= 202;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <= 221;   k_rgb_index(4).blu <= 182;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <= 211;   k_rgb_index(5).blu <= 122;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 201;   k_rgb_index(6).blu <= 142;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 191;   k_rgb_index(7).blu <= 132;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 181;   k_rgb_index(8).blu <= 122;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <= 171;   k_rgb_index(9).blu <= 112;
             k_rgb_index(10).red <= 230;  k_rgb_index(10).gre <= 191;  k_rgb_index(10).blu <= 172;
             k_rgb_index(11).red <= 230;  k_rgb_index(11).gre <= 181;  k_rgb_index(11).blu <= 162;
             k_rgb_index(12).red <= 230;  k_rgb_index(12).gre <=  81;  k_rgb_index(12).blu <=  62;
             k_rgb_index(13).red <= 220;  k_rgb_index(13).gre <= 181;  k_rgb_index(13).blu <= 142;
             k_rgb_index(14).red <= 220;  k_rgb_index(14).gre <= 171;  k_rgb_index(14).blu <= 132;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <=  51;  k_rgb_index(15).blu <=  12;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 181;  k_rgb_index(16).blu <=  92;
             k_rgb_index(17).red <= 180;  k_rgb_index(17).gre <= 161;  k_rgb_index(17).blu <= 132;
             k_rgb_index(18).red <= 180;  k_rgb_index(18).gre <= 151;  k_rgb_index(18).blu <= 122;
             k_rgb_index(19).red <= 170;  k_rgb_index(19).gre <= 151;  k_rgb_index(19).blu <= 112;
             k_rgb_index(20).red <= 170;  k_rgb_index(20).gre <= 141;  k_rgb_index(20).blu <= 102;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <=  31;  k_rgb_index(21).blu <=  22;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <=  71;  k_rgb_index(22).blu <=  42;
             k_rgb_index(23).red <= 130;  k_rgb_index(23).gre <=  91;  k_rgb_index(23).blu <=  62;
             k_rgb_index(24).red <= 130;  k_rgb_index(24).gre <=  81;  k_rgb_index(24).blu <=  52;
             k_rgb_index(25).red <= 120;  k_rgb_index(25).gre <=  81;  k_rgb_index(25).blu <=  42;
             k_rgb_index(26).red <= 120;  k_rgb_index(26).gre <=  71;  k_rgb_index(26).blu <=  32;
             k_rgb_index(27).red <= 100;  k_rgb_index(27).gre <=  51;  k_rgb_index(27).blu <=  22;
             k_rgb_index(28).red <=  70;  k_rgb_index(28).gre <=  51;  k_rgb_index(28).blu <=  42;
             k_rgb_index(29).red <=  70;  k_rgb_index(29).gre <=  41;  k_rgb_index(29).blu <=  32;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  41;  k_rgb_index(30).blu <=  22;
             k_rgb_index(31).red <=  60;  k_rgb_index(31).gre <=  31;  k_rgb_index(31).blu <=  12;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  31;  k_rgb_index(32).blu <=  32;
             k_rgb_index(33).red <=  50;  k_rgb_index(33).gre <=  31;  k_rgb_index(33).blu <=  22;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  31;  k_rgb_index(34).blu <=  22;
             k_rgb_index(35).red <=  40;  k_rgb_index(35).gre <=  21;  k_rgb_index(35).blu <=  12;
             k_rgb_index(36).red <= 244;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 253;
             k_rgb_index(37).red <= 234;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 243;
             k_rgb_index(38).red <= 204;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <= 233;
             k_rgb_index(39).red <= 184;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <= 223;
             k_rgb_index(40).red <= 124;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <= 213;
             k_rgb_index(41).red <= 144;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 203;
             k_rgb_index(42).red <= 134;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 193;
             k_rgb_index(43).red <= 124;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 183;
             k_rgb_index(44).red <= 114;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <= 173;
             k_rgb_index(45).red <= 174;  k_rgb_index(45).gre <= 230;  k_rgb_index(45).blu <= 193;
             k_rgb_index(46).red <= 164;  k_rgb_index(46).gre <= 230;  k_rgb_index(46).blu <= 183;
             k_rgb_index(47).red <=  64;  k_rgb_index(47).gre <= 230;  k_rgb_index(47).blu <=  83;
             k_rgb_index(48).red <= 144;  k_rgb_index(48).gre <= 220;  k_rgb_index(48).blu <= 183;
             k_rgb_index(49).red <= 134;  k_rgb_index(49).gre <= 220;  k_rgb_index(49).blu <= 173;
             k_rgb_index(50).red <=  14;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <=  53;
             k_rgb_index(51).red <=  94;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 183;
             k_rgb_index(52).red <= 134;  k_rgb_index(52).gre <= 180;  k_rgb_index(52).blu <= 163;
             k_rgb_index(53).red <= 124;  k_rgb_index(53).gre <= 180;  k_rgb_index(53).blu <= 153;
             k_rgb_index(54).red <= 114;  k_rgb_index(54).gre <= 170;  k_rgb_index(54).blu <= 153;
             k_rgb_index(55).red <= 104;  k_rgb_index(55).gre <= 170;  k_rgb_index(55).blu <= 143;
             k_rgb_index(56).red <=  44;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 143;
             k_rgb_index(57).red <=  64;  k_rgb_index(57).gre <= 130;  k_rgb_index(57).blu <=  73;
             k_rgb_index(58).red <=  54;  k_rgb_index(58).gre <= 130;  k_rgb_index(58).blu <=  93;
             k_rgb_index(59).red <=  44;  k_rgb_index(59).gre <= 120;  k_rgb_index(59).blu <=  83;
             k_rgb_index(60).red <=  34;  k_rgb_index(60).gre <= 120;  k_rgb_index(60).blu <=  83;
             k_rgb_index(61).red <=  24;  k_rgb_index(61).gre <= 100;  k_rgb_index(61).blu <=  73;
             k_rgb_index(62).red <=  24;  k_rgb_index(62).gre <= 100;  k_rgb_index(62).blu <=  33;
             k_rgb_index(63).red <=  44;  k_rgb_index(63).gre <=  70;  k_rgb_index(63).blu <=  53;
             k_rgb_index(64).red <=  34;  k_rgb_index(64).gre <=  70;  k_rgb_index(64).blu <=  43;
             k_rgb_index(65).red <=  24;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  43;
             k_rgb_index(66).red <=  14;  k_rgb_index(66).gre <=  60;  k_rgb_index(66).blu <=  33;
             k_rgb_index(67).red <=  34;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  33;
             k_rgb_index(68).red <=  24;  k_rgb_index(68).gre <=  50;  k_rgb_index(68).blu <=  23;
             k_rgb_index(69).red <=  24;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  33;
             k_rgb_index(70).red <=  14;  k_rgb_index(70).gre <=  40;  k_rgb_index(70).blu <=  23;

             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 246;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <= 236;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <= 226;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <= 216;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <= 145;  k_rgb_index(76).gre <= 206;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <= 135;  k_rgb_index(77).gre <= 196;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <= 125;  k_rgb_index(78).gre <= 186;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <= 115;  k_rgb_index(79).gre <= 176;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 175;  k_rgb_index(80).gre <= 196;  k_rgb_index(80).blu <= 230;
             k_rgb_index(81).red <= 165;  k_rgb_index(81).gre <= 186;  k_rgb_index(81).blu <= 230;
             k_rgb_index(82).red <=  65;  k_rgb_index(82).gre <=  86;  k_rgb_index(82).blu <= 230;
             k_rgb_index(83).red <= 145;  k_rgb_index(83).gre <= 186;  k_rgb_index(83).blu <= 220;
             k_rgb_index(84).red <= 135;  k_rgb_index(84).gre <= 176;  k_rgb_index(84).blu <= 220;
             k_rgb_index(85).red <=  15;  k_rgb_index(85).gre <=  56;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <=  95;  k_rgb_index(86).gre <= 186;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 135;  k_rgb_index(87).gre <= 166;  k_rgb_index(87).blu <= 180;
             k_rgb_index(88).red <= 125;  k_rgb_index(88).gre <= 156;  k_rgb_index(88).blu <= 180;
             k_rgb_index(89).red <= 115;  k_rgb_index(89).gre <= 156;  k_rgb_index(89).blu <= 170;
             k_rgb_index(90).red <= 105;  k_rgb_index(90).gre <= 146;  k_rgb_index(90).blu <= 170;
             k_rgb_index(91).red <=  25;  k_rgb_index(91).gre <=  36;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  45;  k_rgb_index(92).gre <=  76;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  65;  k_rgb_index(93).gre <=  96;  k_rgb_index(93).blu <= 130;
             k_rgb_index(94).red <=  55;  k_rgb_index(94).gre <=  86;  k_rgb_index(94).blu <= 130;
             k_rgb_index(95).red <=  45;  k_rgb_index(95).gre <=  86;  k_rgb_index(95).blu <= 120;
             k_rgb_index(96).red <=  35;  k_rgb_index(96).gre <=  76;  k_rgb_index(96).blu <= 120;
             k_rgb_index(97).red <=  25;  k_rgb_index(97).gre <=  56;  k_rgb_index(97).blu <= 100;
             k_rgb_index(98).red <=  45;  k_rgb_index(98).gre <=  56;  k_rgb_index(98).blu <=  70;
             k_rgb_index(99).red <=  35;  k_rgb_index(99).gre <=  46;  k_rgb_index(99).blu <=  70;
            k_rgb_index(100).red <=  25; k_rgb_index(100).gre <=  46; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  60;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  36; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  25; k_rgb_index(104).gre <=  36; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  15; k_rgb_index(105).gre <=  26; k_rgb_index(105).blu <=  40;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 8) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 251;   k_rgb_index(1).blu <= 242;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 241;   k_rgb_index(2).blu <= 232;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <= 231;   k_rgb_index(3).blu <= 202;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <= 221;   k_rgb_index(4).blu <= 182;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <= 211;   k_rgb_index(5).blu <= 122;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 201;   k_rgb_index(6).blu <= 142;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 191;   k_rgb_index(7).blu <= 132;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 181;   k_rgb_index(8).blu <= 122;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <= 171;   k_rgb_index(9).blu <= 112;
             k_rgb_index(10).red <= 230;  k_rgb_index(10).gre <= 191;  k_rgb_index(10).blu <= 172;
             k_rgb_index(11).red <= 230;  k_rgb_index(11).gre <= 181;  k_rgb_index(11).blu <= 162;
             k_rgb_index(12).red <= 230;  k_rgb_index(12).gre <=  81;  k_rgb_index(12).blu <=  62;
             k_rgb_index(13).red <= 220;  k_rgb_index(13).gre <= 181;  k_rgb_index(13).blu <= 142;
             k_rgb_index(14).red <= 220;  k_rgb_index(14).gre <= 171;  k_rgb_index(14).blu <= 132;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <=  51;  k_rgb_index(15).blu <=  12;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 181;  k_rgb_index(16).blu <=  92;
             k_rgb_index(17).red <= 180;  k_rgb_index(17).gre <= 161;  k_rgb_index(17).blu <= 132;
             k_rgb_index(18).red <= 180;  k_rgb_index(18).gre <= 151;  k_rgb_index(18).blu <= 122;
             k_rgb_index(19).red <= 170;  k_rgb_index(19).gre <= 151;  k_rgb_index(19).blu <= 112;
             k_rgb_index(20).red <= 170;  k_rgb_index(20).gre <= 141;  k_rgb_index(20).blu <= 102;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <=  31;  k_rgb_index(21).blu <=  22;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <=  71;  k_rgb_index(22).blu <=  42;
             k_rgb_index(23).red <= 130;  k_rgb_index(23).gre <=  91;  k_rgb_index(23).blu <=  62;
             k_rgb_index(24).red <= 130;  k_rgb_index(24).gre <=  81;  k_rgb_index(24).blu <=  52;
             k_rgb_index(25).red <= 120;  k_rgb_index(25).gre <=  81;  k_rgb_index(25).blu <=  42;
             k_rgb_index(26).red <= 120;  k_rgb_index(26).gre <=  71;  k_rgb_index(26).blu <=  32;
             k_rgb_index(27).red <= 100;  k_rgb_index(27).gre <=  51;  k_rgb_index(27).blu <=  22;
             k_rgb_index(28).red <=  70;  k_rgb_index(28).gre <=  51;  k_rgb_index(28).blu <=  42;
             k_rgb_index(29).red <=  70;  k_rgb_index(29).gre <=  41;  k_rgb_index(29).blu <=  32;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  41;  k_rgb_index(30).blu <=  22;
             k_rgb_index(31).red <=  60;  k_rgb_index(31).gre <=  31;  k_rgb_index(31).blu <=  12;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  31;  k_rgb_index(32).blu <=  32;
             k_rgb_index(33).red <=  50;  k_rgb_index(33).gre <=  31;  k_rgb_index(33).blu <=  22;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  31;  k_rgb_index(34).blu <=  22;
             k_rgb_index(35).red <=  40;  k_rgb_index(35).gre <=  21;  k_rgb_index(35).blu <=  12;
             k_rgb_index(36).red <= 244;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 253;
             k_rgb_index(37).red <= 234;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 243;
             k_rgb_index(38).red <= 204;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <= 233;
             k_rgb_index(39).red <= 184;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <= 223;
             k_rgb_index(40).red <= 124;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <= 213;
             k_rgb_index(41).red <= 144;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 203;
             k_rgb_index(42).red <= 134;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 193;
             k_rgb_index(43).red <= 124;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 183;
             k_rgb_index(44).red <= 114;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <= 173;
             k_rgb_index(45).red <= 174;  k_rgb_index(45).gre <= 230;  k_rgb_index(45).blu <= 193;
             k_rgb_index(46).red <= 164;  k_rgb_index(46).gre <= 230;  k_rgb_index(46).blu <= 183;
             k_rgb_index(47).red <=  64;  k_rgb_index(47).gre <= 230;  k_rgb_index(47).blu <=  83;
             k_rgb_index(48).red <= 144;  k_rgb_index(48).gre <= 220;  k_rgb_index(48).blu <= 183;
             k_rgb_index(49).red <= 134;  k_rgb_index(49).gre <= 220;  k_rgb_index(49).blu <= 173;
             k_rgb_index(50).red <=  14;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <=  53;
             k_rgb_index(51).red <=  94;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 183;
             k_rgb_index(52).red <= 134;  k_rgb_index(52).gre <= 180;  k_rgb_index(52).blu <= 163;
             k_rgb_index(53).red <= 124;  k_rgb_index(53).gre <= 180;  k_rgb_index(53).blu <= 153;
             k_rgb_index(54).red <= 114;  k_rgb_index(54).gre <= 170;  k_rgb_index(54).blu <= 153;
             k_rgb_index(55).red <= 104;  k_rgb_index(55).gre <= 170;  k_rgb_index(55).blu <= 143;
             k_rgb_index(56).red <=  44;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 143;
             k_rgb_index(57).red <=  64;  k_rgb_index(57).gre <= 130;  k_rgb_index(57).blu <=  73;
             k_rgb_index(58).red <=  54;  k_rgb_index(58).gre <= 130;  k_rgb_index(58).blu <=  93;
             k_rgb_index(59).red <=  44;  k_rgb_index(59).gre <= 120;  k_rgb_index(59).blu <=  83;
             k_rgb_index(60).red <=  34;  k_rgb_index(60).gre <= 120;  k_rgb_index(60).blu <=  83;
             k_rgb_index(61).red <=  24;  k_rgb_index(61).gre <= 100;  k_rgb_index(61).blu <=  73;
             k_rgb_index(62).red <=  24;  k_rgb_index(62).gre <= 100;  k_rgb_index(62).blu <=  33;
             k_rgb_index(63).red <=  44;  k_rgb_index(63).gre <=  70;  k_rgb_index(63).blu <=  53;
             k_rgb_index(64).red <=  34;  k_rgb_index(64).gre <=  70;  k_rgb_index(64).blu <=  43;
             k_rgb_index(65).red <=  24;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  43;
             k_rgb_index(66).red <=  14;  k_rgb_index(66).gre <=  60;  k_rgb_index(66).blu <=  33;
             k_rgb_index(67).red <=  34;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  33;
             k_rgb_index(68).red <=  24;  k_rgb_index(68).gre <=  50;  k_rgb_index(68).blu <=  23;
             k_rgb_index(69).red <=  24;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  33;
             k_rgb_index(70).red <=  14;  k_rgb_index(70).gre <=  40;  k_rgb_index(70).blu <=  23;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 246;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <= 236;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <= 226;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <= 216;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <= 145;  k_rgb_index(76).gre <= 206;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <= 135;  k_rgb_index(77).gre <= 196;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <= 125;  k_rgb_index(78).gre <= 186;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <= 115;  k_rgb_index(79).gre <= 176;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 175;  k_rgb_index(80).gre <= 196;  k_rgb_index(80).blu <= 230;
             k_rgb_index(81).red <= 165;  k_rgb_index(81).gre <= 186;  k_rgb_index(81).blu <= 230;
             k_rgb_index(82).red <=  65;  k_rgb_index(82).gre <=  86;  k_rgb_index(82).blu <= 230;
             k_rgb_index(83).red <= 145;  k_rgb_index(83).gre <= 186;  k_rgb_index(83).blu <= 220;
             k_rgb_index(84).red <= 135;  k_rgb_index(84).gre <= 176;  k_rgb_index(84).blu <= 220;
             k_rgb_index(85).red <=  15;  k_rgb_index(85).gre <=  56;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <=  95;  k_rgb_index(86).gre <= 186;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 135;  k_rgb_index(87).gre <= 166;  k_rgb_index(87).blu <= 180;
             k_rgb_index(88).red <= 125;  k_rgb_index(88).gre <= 156;  k_rgb_index(88).blu <= 180;
             k_rgb_index(89).red <= 115;  k_rgb_index(89).gre <= 156;  k_rgb_index(89).blu <= 170;
             k_rgb_index(90).red <= 105;  k_rgb_index(90).gre <= 146;  k_rgb_index(90).blu <= 170;
             k_rgb_index(91).red <=  25;  k_rgb_index(91).gre <=  36;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  45;  k_rgb_index(92).gre <=  76;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  65;  k_rgb_index(93).gre <=  96;  k_rgb_index(93).blu <= 130;
             k_rgb_index(94).red <=  55;  k_rgb_index(94).gre <=  86;  k_rgb_index(94).blu <= 130;
             k_rgb_index(95).red <=  45;  k_rgb_index(95).gre <=  86;  k_rgb_index(95).blu <= 120;
             k_rgb_index(96).red <=  35;  k_rgb_index(96).gre <=  76;  k_rgb_index(96).blu <= 120;
             k_rgb_index(97).red <=  25;  k_rgb_index(97).gre <=  56;  k_rgb_index(97).blu <= 100;
             k_rgb_index(98).red <=  45;  k_rgb_index(98).gre <=  56;  k_rgb_index(98).blu <=  70;
             k_rgb_index(99).red <=  35;  k_rgb_index(99).gre <=  46;  k_rgb_index(99).blu <=  70;
            k_rgb_index(100).red <=  25; k_rgb_index(100).gre <=  46; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  60;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  36; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  25; k_rgb_index(104).gre <=  36; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  15; k_rgb_index(105).gre <=  26; k_rgb_index(105).blu <=  40;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 9) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 251;   k_rgb_index(1).blu <= 242;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 241;   k_rgb_index(2).blu <= 232;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <= 231;   k_rgb_index(3).blu <= 202;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <= 221;   k_rgb_index(4).blu <= 182;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <= 211;   k_rgb_index(5).blu <= 122;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 201;   k_rgb_index(6).blu <= 142;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 191;   k_rgb_index(7).blu <= 132;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 181;   k_rgb_index(8).blu <= 122;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <= 171;   k_rgb_index(9).blu <= 112;
             k_rgb_index(10).red <= 230;  k_rgb_index(10).gre <= 191;  k_rgb_index(10).blu <= 172;
             k_rgb_index(11).red <= 230;  k_rgb_index(11).gre <= 181;  k_rgb_index(11).blu <= 162;
             k_rgb_index(12).red <= 230;  k_rgb_index(12).gre <=  81;  k_rgb_index(12).blu <=  62;
             k_rgb_index(13).red <= 220;  k_rgb_index(13).gre <= 181;  k_rgb_index(13).blu <= 142;
             k_rgb_index(14).red <= 220;  k_rgb_index(14).gre <= 171;  k_rgb_index(14).blu <= 132;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <=  51;  k_rgb_index(15).blu <=  12;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 181;  k_rgb_index(16).blu <=  92;
             k_rgb_index(17).red <= 180;  k_rgb_index(17).gre <= 161;  k_rgb_index(17).blu <= 132;
             k_rgb_index(18).red <= 180;  k_rgb_index(18).gre <= 151;  k_rgb_index(18).blu <= 122;
             k_rgb_index(19).red <= 170;  k_rgb_index(19).gre <= 151;  k_rgb_index(19).blu <= 112;
             k_rgb_index(20).red <= 170;  k_rgb_index(20).gre <= 141;  k_rgb_index(20).blu <= 102;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <=  31;  k_rgb_index(21).blu <=  22;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <=  71;  k_rgb_index(22).blu <=  42;
             k_rgb_index(23).red <= 130;  k_rgb_index(23).gre <=  91;  k_rgb_index(23).blu <=  62;
             k_rgb_index(24).red <= 130;  k_rgb_index(24).gre <=  81;  k_rgb_index(24).blu <=  52;
             k_rgb_index(25).red <= 120;  k_rgb_index(25).gre <=  81;  k_rgb_index(25).blu <=  42;
             k_rgb_index(26).red <= 120;  k_rgb_index(26).gre <=  71;  k_rgb_index(26).blu <=  32;
             k_rgb_index(27).red <= 100;  k_rgb_index(27).gre <=  51;  k_rgb_index(27).blu <=  22;
             k_rgb_index(28).red <=  70;  k_rgb_index(28).gre <=  51;  k_rgb_index(28).blu <=  42;
             k_rgb_index(29).red <=  70;  k_rgb_index(29).gre <=  41;  k_rgb_index(29).blu <=  32;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  41;  k_rgb_index(30).blu <=  22;
             k_rgb_index(31).red <=  60;  k_rgb_index(31).gre <=  31;  k_rgb_index(31).blu <=  12;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  31;  k_rgb_index(32).blu <=  32;
             k_rgb_index(33).red <=  50;  k_rgb_index(33).gre <=  31;  k_rgb_index(33).blu <=  22;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  31;  k_rgb_index(34).blu <=  22;
             k_rgb_index(35).red <=  40;  k_rgb_index(35).gre <=  21;  k_rgb_index(35).blu <=  12;
             k_rgb_index(36).red <= 244;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 253;
             k_rgb_index(37).red <= 234;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 243;
             k_rgb_index(38).red <= 204;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <= 233;
             k_rgb_index(39).red <= 184;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <= 223;
             k_rgb_index(40).red <= 124;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <= 213;
             k_rgb_index(41).red <= 144;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 203;
             k_rgb_index(42).red <= 134;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 193;
             k_rgb_index(43).red <= 124;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 183;
             k_rgb_index(44).red <= 114;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <= 173;
             k_rgb_index(45).red <= 174;  k_rgb_index(45).gre <= 230;  k_rgb_index(45).blu <= 193;
             k_rgb_index(46).red <= 164;  k_rgb_index(46).gre <= 230;  k_rgb_index(46).blu <= 183;
             k_rgb_index(47).red <=  64;  k_rgb_index(47).gre <= 230;  k_rgb_index(47).blu <=  83;
             k_rgb_index(48).red <= 144;  k_rgb_index(48).gre <= 220;  k_rgb_index(48).blu <= 183;
             k_rgb_index(49).red <= 134;  k_rgb_index(49).gre <= 220;  k_rgb_index(49).blu <= 173;
             k_rgb_index(50).red <=  14;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <=  53;
             k_rgb_index(51).red <=  94;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 183;
             k_rgb_index(52).red <= 134;  k_rgb_index(52).gre <= 180;  k_rgb_index(52).blu <= 163;
             k_rgb_index(53).red <= 124;  k_rgb_index(53).gre <= 180;  k_rgb_index(53).blu <= 153;
             k_rgb_index(54).red <= 114;  k_rgb_index(54).gre <= 170;  k_rgb_index(54).blu <= 153;
             k_rgb_index(55).red <= 104;  k_rgb_index(55).gre <= 170;  k_rgb_index(55).blu <= 143;
             k_rgb_index(56).red <=  44;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 143;
             k_rgb_index(57).red <=  64;  k_rgb_index(57).gre <= 130;  k_rgb_index(57).blu <=  73;
             k_rgb_index(58).red <=  54;  k_rgb_index(58).gre <= 130;  k_rgb_index(58).blu <=  93;
             k_rgb_index(59).red <=  44;  k_rgb_index(59).gre <= 120;  k_rgb_index(59).blu <=  83;
             k_rgb_index(60).red <=  34;  k_rgb_index(60).gre <= 120;  k_rgb_index(60).blu <=  83;
             k_rgb_index(61).red <=  24;  k_rgb_index(61).gre <= 100;  k_rgb_index(61).blu <=  73;
             k_rgb_index(62).red <=  24;  k_rgb_index(62).gre <= 100;  k_rgb_index(62).blu <=  33;
             k_rgb_index(63).red <=  44;  k_rgb_index(63).gre <=  70;  k_rgb_index(63).blu <=  53;
             k_rgb_index(64).red <=  34;  k_rgb_index(64).gre <=  70;  k_rgb_index(64).blu <=  43;
             k_rgb_index(65).red <=  24;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  43;
             k_rgb_index(66).red <=  14;  k_rgb_index(66).gre <=  60;  k_rgb_index(66).blu <=  33;
             k_rgb_index(67).red <=  34;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  33;
             k_rgb_index(68).red <=  24;  k_rgb_index(68).gre <=  50;  k_rgb_index(68).blu <=  23;
             k_rgb_index(69).red <=  24;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  33;
             k_rgb_index(70).red <=  14;  k_rgb_index(70).gre <=  40;  k_rgb_index(70).blu <=  23;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 246;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <= 236;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <= 226;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <= 216;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <= 145;  k_rgb_index(76).gre <= 206;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <= 135;  k_rgb_index(77).gre <= 196;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <= 125;  k_rgb_index(78).gre <= 186;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <= 115;  k_rgb_index(79).gre <= 176;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 175;  k_rgb_index(80).gre <= 196;  k_rgb_index(80).blu <= 230;
             k_rgb_index(81).red <= 165;  k_rgb_index(81).gre <= 186;  k_rgb_index(81).blu <= 230;
             k_rgb_index(82).red <=  65;  k_rgb_index(82).gre <=  86;  k_rgb_index(82).blu <= 230;
             k_rgb_index(83).red <= 145;  k_rgb_index(83).gre <= 186;  k_rgb_index(83).blu <= 220;
             k_rgb_index(84).red <= 135;  k_rgb_index(84).gre <= 176;  k_rgb_index(84).blu <= 220;
             k_rgb_index(85).red <=  15;  k_rgb_index(85).gre <=  56;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <=  95;  k_rgb_index(86).gre <= 186;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 135;  k_rgb_index(87).gre <= 166;  k_rgb_index(87).blu <= 180;
             k_rgb_index(88).red <= 125;  k_rgb_index(88).gre <= 156;  k_rgb_index(88).blu <= 180;
             k_rgb_index(89).red <= 115;  k_rgb_index(89).gre <= 156;  k_rgb_index(89).blu <= 170;
             k_rgb_index(90).red <= 105;  k_rgb_index(90).gre <= 146;  k_rgb_index(90).blu <= 170;
             k_rgb_index(91).red <=  25;  k_rgb_index(91).gre <=  36;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  45;  k_rgb_index(92).gre <=  76;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  65;  k_rgb_index(93).gre <=  96;  k_rgb_index(93).blu <= 130;
             k_rgb_index(94).red <=  55;  k_rgb_index(94).gre <=  86;  k_rgb_index(94).blu <= 130;
             k_rgb_index(95).red <=  45;  k_rgb_index(95).gre <=  86;  k_rgb_index(95).blu <= 120;
             k_rgb_index(96).red <=  35;  k_rgb_index(96).gre <=  76;  k_rgb_index(96).blu <= 120;
             k_rgb_index(97).red <=  25;  k_rgb_index(97).gre <=  56;  k_rgb_index(97).blu <= 100;
             k_rgb_index(98).red <=  45;  k_rgb_index(98).gre <=  56;  k_rgb_index(98).blu <=  70;
             k_rgb_index(99).red <=  35;  k_rgb_index(99).gre <=  46;  k_rgb_index(99).blu <=  70;
            k_rgb_index(100).red <=  25; k_rgb_index(100).gre <=  46; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  60;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  36; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  25; k_rgb_index(104).gre <=  36; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  15; k_rgb_index(105).gre <=  26; k_rgb_index(105).blu <=  40;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 10) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 251;   k_rgb_index(1).blu <= 242;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 241;   k_rgb_index(2).blu <= 232;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <= 231;   k_rgb_index(3).blu <= 202;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <= 221;   k_rgb_index(4).blu <= 182;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <= 211;   k_rgb_index(5).blu <= 122;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 201;   k_rgb_index(6).blu <= 142;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 191;   k_rgb_index(7).blu <= 132;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 181;   k_rgb_index(8).blu <= 122;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <= 171;   k_rgb_index(9).blu <= 112;
             k_rgb_index(10).red <= 230;  k_rgb_index(10).gre <= 191;  k_rgb_index(10).blu <= 172;
             k_rgb_index(11).red <= 230;  k_rgb_index(11).gre <= 181;  k_rgb_index(11).blu <= 162;
             k_rgb_index(12).red <= 230;  k_rgb_index(12).gre <=  81;  k_rgb_index(12).blu <=  62;
             k_rgb_index(13).red <= 220;  k_rgb_index(13).gre <= 181;  k_rgb_index(13).blu <= 142;
             k_rgb_index(14).red <= 220;  k_rgb_index(14).gre <= 171;  k_rgb_index(14).blu <= 132;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <=  51;  k_rgb_index(15).blu <=  12;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 181;  k_rgb_index(16).blu <=  92;
             k_rgb_index(17).red <= 180;  k_rgb_index(17).gre <= 161;  k_rgb_index(17).blu <= 132;
             k_rgb_index(18).red <= 180;  k_rgb_index(18).gre <= 151;  k_rgb_index(18).blu <= 122;
             k_rgb_index(19).red <= 170;  k_rgb_index(19).gre <= 151;  k_rgb_index(19).blu <= 112;
             k_rgb_index(20).red <= 170;  k_rgb_index(20).gre <= 141;  k_rgb_index(20).blu <= 102;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <=  31;  k_rgb_index(21).blu <=  22;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <=  71;  k_rgb_index(22).blu <=  42;
             k_rgb_index(23).red <= 130;  k_rgb_index(23).gre <=  91;  k_rgb_index(23).blu <=  62;
             k_rgb_index(24).red <= 130;  k_rgb_index(24).gre <=  81;  k_rgb_index(24).blu <=  52;
             k_rgb_index(25).red <= 120;  k_rgb_index(25).gre <=  81;  k_rgb_index(25).blu <=  42;
             k_rgb_index(26).red <= 120;  k_rgb_index(26).gre <=  71;  k_rgb_index(26).blu <=  32;
             k_rgb_index(27).red <= 100;  k_rgb_index(27).gre <=  51;  k_rgb_index(27).blu <=  22;
             k_rgb_index(28).red <=  70;  k_rgb_index(28).gre <=  51;  k_rgb_index(28).blu <=  42;
             k_rgb_index(29).red <=  70;  k_rgb_index(29).gre <=  41;  k_rgb_index(29).blu <=  32;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  41;  k_rgb_index(30).blu <=  22;
             k_rgb_index(31).red <=  60;  k_rgb_index(31).gre <=  31;  k_rgb_index(31).blu <=  12;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  31;  k_rgb_index(32).blu <=  32;
             k_rgb_index(33).red <=  50;  k_rgb_index(33).gre <=  31;  k_rgb_index(33).blu <=  22;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  31;  k_rgb_index(34).blu <=  22;
             k_rgb_index(35).red <=  40;  k_rgb_index(35).gre <=  21;  k_rgb_index(35).blu <=  12;
             k_rgb_index(36).red <= 244;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 253;
             k_rgb_index(37).red <= 234;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 243;
             k_rgb_index(38).red <= 204;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <= 233;
             k_rgb_index(39).red <= 184;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <= 223;
             k_rgb_index(40).red <= 124;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <= 213;
             k_rgb_index(41).red <= 144;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 203;
             k_rgb_index(42).red <= 134;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 193;
             k_rgb_index(43).red <= 124;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 183;
             k_rgb_index(44).red <= 114;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <= 173;
             k_rgb_index(45).red <= 174;  k_rgb_index(45).gre <= 230;  k_rgb_index(45).blu <= 193;
             k_rgb_index(46).red <= 164;  k_rgb_index(46).gre <= 230;  k_rgb_index(46).blu <= 183;
             k_rgb_index(47).red <=  64;  k_rgb_index(47).gre <= 230;  k_rgb_index(47).blu <=  83;
             k_rgb_index(48).red <= 144;  k_rgb_index(48).gre <= 220;  k_rgb_index(48).blu <= 183;
             k_rgb_index(49).red <= 134;  k_rgb_index(49).gre <= 220;  k_rgb_index(49).blu <= 173;
             k_rgb_index(50).red <=  14;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <=  53;
             k_rgb_index(51).red <=  94;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 183;
             k_rgb_index(52).red <= 134;  k_rgb_index(52).gre <= 180;  k_rgb_index(52).blu <= 163;
             k_rgb_index(53).red <= 124;  k_rgb_index(53).gre <= 180;  k_rgb_index(53).blu <= 153;
             k_rgb_index(54).red <= 114;  k_rgb_index(54).gre <= 170;  k_rgb_index(54).blu <= 153;
             k_rgb_index(55).red <= 104;  k_rgb_index(55).gre <= 170;  k_rgb_index(55).blu <= 143;
             k_rgb_index(56).red <=  44;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 143;
             k_rgb_index(57).red <=  64;  k_rgb_index(57).gre <= 130;  k_rgb_index(57).blu <=  73;
             k_rgb_index(58).red <=  54;  k_rgb_index(58).gre <= 130;  k_rgb_index(58).blu <=  93;
             k_rgb_index(59).red <=  44;  k_rgb_index(59).gre <= 120;  k_rgb_index(59).blu <=  83;
             k_rgb_index(60).red <=  34;  k_rgb_index(60).gre <= 120;  k_rgb_index(60).blu <=  83;
             k_rgb_index(61).red <=  24;  k_rgb_index(61).gre <= 100;  k_rgb_index(61).blu <=  73;
             k_rgb_index(62).red <=  24;  k_rgb_index(62).gre <= 100;  k_rgb_index(62).blu <=  33;
             k_rgb_index(63).red <=  44;  k_rgb_index(63).gre <=  70;  k_rgb_index(63).blu <=  53;
             k_rgb_index(64).red <=  34;  k_rgb_index(64).gre <=  70;  k_rgb_index(64).blu <=  43;
             k_rgb_index(65).red <=  24;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  43;
             k_rgb_index(66).red <=  14;  k_rgb_index(66).gre <=  60;  k_rgb_index(66).blu <=  33;
             k_rgb_index(67).red <=  34;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  33;
             k_rgb_index(68).red <=  24;  k_rgb_index(68).gre <=  50;  k_rgb_index(68).blu <=  23;
             k_rgb_index(69).red <=  24;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  33;
             k_rgb_index(70).red <=  14;  k_rgb_index(70).gre <=  40;  k_rgb_index(70).blu <=  23;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 246;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <= 236;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <= 226;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <= 216;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <= 145;  k_rgb_index(76).gre <= 206;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <= 135;  k_rgb_index(77).gre <= 196;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <= 125;  k_rgb_index(78).gre <= 186;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <= 115;  k_rgb_index(79).gre <= 176;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 175;  k_rgb_index(80).gre <= 196;  k_rgb_index(80).blu <= 230;
             k_rgb_index(81).red <= 165;  k_rgb_index(81).gre <= 186;  k_rgb_index(81).blu <= 230;
             k_rgb_index(82).red <=  65;  k_rgb_index(82).gre <=  86;  k_rgb_index(82).blu <= 230;
             k_rgb_index(83).red <= 145;  k_rgb_index(83).gre <= 186;  k_rgb_index(83).blu <= 220;
             k_rgb_index(84).red <= 135;  k_rgb_index(84).gre <= 176;  k_rgb_index(84).blu <= 220;
             k_rgb_index(85).red <=  15;  k_rgb_index(85).gre <=  56;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <=  95;  k_rgb_index(86).gre <= 186;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 135;  k_rgb_index(87).gre <= 166;  k_rgb_index(87).blu <= 180;
             k_rgb_index(88).red <= 125;  k_rgb_index(88).gre <= 156;  k_rgb_index(88).blu <= 180;
             k_rgb_index(89).red <= 115;  k_rgb_index(89).gre <= 156;  k_rgb_index(89).blu <= 170;
             k_rgb_index(90).red <= 105;  k_rgb_index(90).gre <= 146;  k_rgb_index(90).blu <= 170;
             k_rgb_index(91).red <=  25;  k_rgb_index(91).gre <=  36;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  45;  k_rgb_index(92).gre <=  76;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  65;  k_rgb_index(93).gre <=  96;  k_rgb_index(93).blu <= 130;
             k_rgb_index(94).red <=  55;  k_rgb_index(94).gre <=  86;  k_rgb_index(94).blu <= 130;
             k_rgb_index(95).red <=  45;  k_rgb_index(95).gre <=  86;  k_rgb_index(95).blu <= 120;
             k_rgb_index(96).red <=  35;  k_rgb_index(96).gre <=  76;  k_rgb_index(96).blu <= 120;
             k_rgb_index(97).red <=  25;  k_rgb_index(97).gre <=  56;  k_rgb_index(97).blu <= 100;
             k_rgb_index(98).red <=  45;  k_rgb_index(98).gre <=  56;  k_rgb_index(98).blu <=  70;
             k_rgb_index(99).red <=  35;  k_rgb_index(99).gre <=  46;  k_rgb_index(99).blu <=  70;
            k_rgb_index(100).red <=  25; k_rgb_index(100).gre <=  46; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  60;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  36; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  25; k_rgb_index(104).gre <=  36; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  15; k_rgb_index(105).gre <=  26; k_rgb_index(105).blu <=  40;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 11) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 251;   k_rgb_index(1).blu <= 242;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 241;   k_rgb_index(2).blu <= 232;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <= 231;   k_rgb_index(3).blu <= 202;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <= 221;   k_rgb_index(4).blu <= 182;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <= 211;   k_rgb_index(5).blu <= 122;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 201;   k_rgb_index(6).blu <= 142;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 191;   k_rgb_index(7).blu <= 132;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 181;   k_rgb_index(8).blu <= 122;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <= 171;   k_rgb_index(9).blu <= 112;
             k_rgb_index(10).red <= 230;  k_rgb_index(10).gre <= 191;  k_rgb_index(10).blu <= 172;
             k_rgb_index(11).red <= 230;  k_rgb_index(11).gre <= 181;  k_rgb_index(11).blu <= 162;
             k_rgb_index(12).red <= 230;  k_rgb_index(12).gre <=  81;  k_rgb_index(12).blu <=  62;
             k_rgb_index(13).red <= 220;  k_rgb_index(13).gre <= 181;  k_rgb_index(13).blu <= 142;
             k_rgb_index(14).red <= 220;  k_rgb_index(14).gre <= 171;  k_rgb_index(14).blu <= 132;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <=  51;  k_rgb_index(15).blu <=  12;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 181;  k_rgb_index(16).blu <=  92;
             k_rgb_index(17).red <= 180;  k_rgb_index(17).gre <= 161;  k_rgb_index(17).blu <= 132;
             k_rgb_index(18).red <= 180;  k_rgb_index(18).gre <= 151;  k_rgb_index(18).blu <= 122;
             k_rgb_index(19).red <= 170;  k_rgb_index(19).gre <= 151;  k_rgb_index(19).blu <= 112;
             k_rgb_index(20).red <= 170;  k_rgb_index(20).gre <= 141;  k_rgb_index(20).blu <= 102;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <=  31;  k_rgb_index(21).blu <=  22;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <=  71;  k_rgb_index(22).blu <=  42;
             k_rgb_index(23).red <= 130;  k_rgb_index(23).gre <=  91;  k_rgb_index(23).blu <=  62;
             k_rgb_index(24).red <= 130;  k_rgb_index(24).gre <=  81;  k_rgb_index(24).blu <=  52;
             k_rgb_index(25).red <= 120;  k_rgb_index(25).gre <=  81;  k_rgb_index(25).blu <=  42;
             k_rgb_index(26).red <= 120;  k_rgb_index(26).gre <=  71;  k_rgb_index(26).blu <=  32;
             k_rgb_index(27).red <= 100;  k_rgb_index(27).gre <=  51;  k_rgb_index(27).blu <=  22;
             k_rgb_index(28).red <=  70;  k_rgb_index(28).gre <=  51;  k_rgb_index(28).blu <=  42;
             k_rgb_index(29).red <=  70;  k_rgb_index(29).gre <=  41;  k_rgb_index(29).blu <=  32;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  41;  k_rgb_index(30).blu <=  22;
             k_rgb_index(31).red <=  60;  k_rgb_index(31).gre <=  31;  k_rgb_index(31).blu <=  12;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  31;  k_rgb_index(32).blu <=  32;
             k_rgb_index(33).red <=  50;  k_rgb_index(33).gre <=  31;  k_rgb_index(33).blu <=  22;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  31;  k_rgb_index(34).blu <=  22;
             k_rgb_index(35).red <=  40;  k_rgb_index(35).gre <=  21;  k_rgb_index(35).blu <=  12;
             k_rgb_index(36).red <= 244;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 253;
             k_rgb_index(37).red <= 234;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 243;
             k_rgb_index(38).red <= 204;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <= 233;
             k_rgb_index(39).red <= 184;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <= 223;
             k_rgb_index(40).red <= 124;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <= 213;
             k_rgb_index(41).red <= 144;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 203;
             k_rgb_index(42).red <= 134;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 193;
             k_rgb_index(43).red <= 124;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 183;
             k_rgb_index(44).red <= 114;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <= 173;
             k_rgb_index(45).red <= 174;  k_rgb_index(45).gre <= 230;  k_rgb_index(45).blu <= 193;
             k_rgb_index(46).red <= 164;  k_rgb_index(46).gre <= 230;  k_rgb_index(46).blu <= 183;
             k_rgb_index(47).red <=  64;  k_rgb_index(47).gre <= 230;  k_rgb_index(47).blu <=  83;
             k_rgb_index(48).red <= 144;  k_rgb_index(48).gre <= 220;  k_rgb_index(48).blu <= 183;
             k_rgb_index(49).red <= 134;  k_rgb_index(49).gre <= 220;  k_rgb_index(49).blu <= 173;
             k_rgb_index(50).red <=  14;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <=  53;
             k_rgb_index(51).red <=  94;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 183;
             k_rgb_index(52).red <= 134;  k_rgb_index(52).gre <= 180;  k_rgb_index(52).blu <= 163;
             k_rgb_index(53).red <= 124;  k_rgb_index(53).gre <= 180;  k_rgb_index(53).blu <= 153;
             k_rgb_index(54).red <= 114;  k_rgb_index(54).gre <= 170;  k_rgb_index(54).blu <= 153;
             k_rgb_index(55).red <= 104;  k_rgb_index(55).gre <= 170;  k_rgb_index(55).blu <= 143;
             k_rgb_index(56).red <=  44;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 143;
             k_rgb_index(57).red <=  64;  k_rgb_index(57).gre <= 130;  k_rgb_index(57).blu <=  73;
             k_rgb_index(58).red <=  54;  k_rgb_index(58).gre <= 130;  k_rgb_index(58).blu <=  93;
             k_rgb_index(59).red <=  44;  k_rgb_index(59).gre <= 120;  k_rgb_index(59).blu <=  83;
             k_rgb_index(60).red <=  34;  k_rgb_index(60).gre <= 120;  k_rgb_index(60).blu <=  83;
             k_rgb_index(61).red <=  24;  k_rgb_index(61).gre <= 100;  k_rgb_index(61).blu <=  73;
             k_rgb_index(62).red <=  24;  k_rgb_index(62).gre <= 100;  k_rgb_index(62).blu <=  33;
             k_rgb_index(63).red <=  44;  k_rgb_index(63).gre <=  70;  k_rgb_index(63).blu <=  53;
             k_rgb_index(64).red <=  34;  k_rgb_index(64).gre <=  70;  k_rgb_index(64).blu <=  43;
             k_rgb_index(65).red <=  24;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  43;
             k_rgb_index(66).red <=  14;  k_rgb_index(66).gre <=  60;  k_rgb_index(66).blu <=  33;
             k_rgb_index(67).red <=  34;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  33;
             k_rgb_index(68).red <=  24;  k_rgb_index(68).gre <=  50;  k_rgb_index(68).blu <=  23;
             k_rgb_index(69).red <=  24;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  33;
             k_rgb_index(70).red <=  14;  k_rgb_index(70).gre <=  40;  k_rgb_index(70).blu <=  23;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 246;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <= 236;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <= 226;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <= 216;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <= 145;  k_rgb_index(76).gre <= 206;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <= 135;  k_rgb_index(77).gre <= 196;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <= 125;  k_rgb_index(78).gre <= 186;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <= 115;  k_rgb_index(79).gre <= 176;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 175;  k_rgb_index(80).gre <= 196;  k_rgb_index(80).blu <= 230;
             k_rgb_index(81).red <= 165;  k_rgb_index(81).gre <= 186;  k_rgb_index(81).blu <= 230;
             k_rgb_index(82).red <=  65;  k_rgb_index(82).gre <=  86;  k_rgb_index(82).blu <= 230;
             k_rgb_index(83).red <= 145;  k_rgb_index(83).gre <= 186;  k_rgb_index(83).blu <= 220;
             k_rgb_index(84).red <= 135;  k_rgb_index(84).gre <= 176;  k_rgb_index(84).blu <= 220;
             k_rgb_index(85).red <=  15;  k_rgb_index(85).gre <=  56;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <=  95;  k_rgb_index(86).gre <= 186;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 135;  k_rgb_index(87).gre <= 166;  k_rgb_index(87).blu <= 180;
             k_rgb_index(88).red <= 125;  k_rgb_index(88).gre <= 156;  k_rgb_index(88).blu <= 180;
             k_rgb_index(89).red <= 115;  k_rgb_index(89).gre <= 156;  k_rgb_index(89).blu <= 170;
             k_rgb_index(90).red <= 105;  k_rgb_index(90).gre <= 146;  k_rgb_index(90).blu <= 170;
             k_rgb_index(91).red <=  25;  k_rgb_index(91).gre <=  36;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  45;  k_rgb_index(92).gre <=  76;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  65;  k_rgb_index(93).gre <=  96;  k_rgb_index(93).blu <= 130;
             k_rgb_index(94).red <=  55;  k_rgb_index(94).gre <=  86;  k_rgb_index(94).blu <= 130;
             k_rgb_index(95).red <=  45;  k_rgb_index(95).gre <=  86;  k_rgb_index(95).blu <= 120;
             k_rgb_index(96).red <=  35;  k_rgb_index(96).gre <=  76;  k_rgb_index(96).blu <= 120;
             k_rgb_index(97).red <=  25;  k_rgb_index(97).gre <=  56;  k_rgb_index(97).blu <= 100;
             k_rgb_index(98).red <=  45;  k_rgb_index(98).gre <=  56;  k_rgb_index(98).blu <=  70;
             k_rgb_index(99).red <=  35;  k_rgb_index(99).gre <=  46;  k_rgb_index(99).blu <=  70;
            k_rgb_index(100).red <=  25; k_rgb_index(100).gre <=  46; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  60;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  36; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  25; k_rgb_index(104).gre <=  36; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  15; k_rgb_index(105).gre <=  26; k_rgb_index(105).blu <=  40;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 12) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 251;   k_rgb_index(1).blu <= 242;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 241;   k_rgb_index(2).blu <= 232;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <= 231;   k_rgb_index(3).blu <= 202;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <= 221;   k_rgb_index(4).blu <= 182;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <= 211;   k_rgb_index(5).blu <= 122;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 201;   k_rgb_index(6).blu <= 142;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 191;   k_rgb_index(7).blu <= 132;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 181;   k_rgb_index(8).blu <= 122;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <= 171;   k_rgb_index(9).blu <= 112;
             k_rgb_index(10).red <= 230;  k_rgb_index(10).gre <= 191;  k_rgb_index(10).blu <= 172;
             k_rgb_index(11).red <= 230;  k_rgb_index(11).gre <= 181;  k_rgb_index(11).blu <= 162;
             k_rgb_index(12).red <= 230;  k_rgb_index(12).gre <=  81;  k_rgb_index(12).blu <=  62;
             k_rgb_index(13).red <= 220;  k_rgb_index(13).gre <= 181;  k_rgb_index(13).blu <= 142;
             k_rgb_index(14).red <= 220;  k_rgb_index(14).gre <= 171;  k_rgb_index(14).blu <= 132;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <=  51;  k_rgb_index(15).blu <=  12;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 181;  k_rgb_index(16).blu <=  92;
             k_rgb_index(17).red <= 180;  k_rgb_index(17).gre <= 161;  k_rgb_index(17).blu <= 132;
             k_rgb_index(18).red <= 180;  k_rgb_index(18).gre <= 151;  k_rgb_index(18).blu <= 122;
             k_rgb_index(19).red <= 170;  k_rgb_index(19).gre <= 151;  k_rgb_index(19).blu <= 112;
             k_rgb_index(20).red <= 170;  k_rgb_index(20).gre <= 141;  k_rgb_index(20).blu <= 102;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <=  31;  k_rgb_index(21).blu <=  22;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <=  71;  k_rgb_index(22).blu <=  42;
             k_rgb_index(23).red <= 130;  k_rgb_index(23).gre <=  91;  k_rgb_index(23).blu <=  62;
             k_rgb_index(24).red <= 130;  k_rgb_index(24).gre <=  81;  k_rgb_index(24).blu <=  52;
             k_rgb_index(25).red <= 120;  k_rgb_index(25).gre <=  81;  k_rgb_index(25).blu <=  42;
             k_rgb_index(26).red <= 120;  k_rgb_index(26).gre <=  71;  k_rgb_index(26).blu <=  32;
             k_rgb_index(27).red <= 100;  k_rgb_index(27).gre <=  51;  k_rgb_index(27).blu <=  22;
             k_rgb_index(28).red <=  70;  k_rgb_index(28).gre <=  51;  k_rgb_index(28).blu <=  42;
             k_rgb_index(29).red <=  70;  k_rgb_index(29).gre <=  41;  k_rgb_index(29).blu <=  32;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  41;  k_rgb_index(30).blu <=  22;
             k_rgb_index(31).red <=  60;  k_rgb_index(31).gre <=  31;  k_rgb_index(31).blu <=  12;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  31;  k_rgb_index(32).blu <=  32;
             k_rgb_index(33).red <=  50;  k_rgb_index(33).gre <=  31;  k_rgb_index(33).blu <=  22;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  31;  k_rgb_index(34).blu <=  22;
             k_rgb_index(35).red <=  40;  k_rgb_index(35).gre <=  21;  k_rgb_index(35).blu <=  12;
             k_rgb_index(36).red <= 244;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 253;
             k_rgb_index(37).red <= 234;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 243;
             k_rgb_index(38).red <= 204;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <= 233;
             k_rgb_index(39).red <= 184;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <= 223;
             k_rgb_index(40).red <= 124;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <= 213;
             k_rgb_index(41).red <= 144;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 203;
             k_rgb_index(42).red <= 134;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 193;
             k_rgb_index(43).red <= 124;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 183;
             k_rgb_index(44).red <= 114;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <= 173;
             k_rgb_index(45).red <= 174;  k_rgb_index(45).gre <= 230;  k_rgb_index(45).blu <= 193;
             k_rgb_index(46).red <= 164;  k_rgb_index(46).gre <= 230;  k_rgb_index(46).blu <= 183;
             k_rgb_index(47).red <=  64;  k_rgb_index(47).gre <= 230;  k_rgb_index(47).blu <=  83;
             k_rgb_index(48).red <= 144;  k_rgb_index(48).gre <= 220;  k_rgb_index(48).blu <= 183;
             k_rgb_index(49).red <= 134;  k_rgb_index(49).gre <= 220;  k_rgb_index(49).blu <= 173;
             k_rgb_index(50).red <=  14;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <=  53;
             k_rgb_index(51).red <=  94;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 183;
             k_rgb_index(52).red <= 134;  k_rgb_index(52).gre <= 180;  k_rgb_index(52).blu <= 163;
             k_rgb_index(53).red <= 124;  k_rgb_index(53).gre <= 180;  k_rgb_index(53).blu <= 153;
             k_rgb_index(54).red <= 114;  k_rgb_index(54).gre <= 170;  k_rgb_index(54).blu <= 153;
             k_rgb_index(55).red <= 104;  k_rgb_index(55).gre <= 170;  k_rgb_index(55).blu <= 143;
             k_rgb_index(56).red <=  44;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 143;
             k_rgb_index(57).red <=  64;  k_rgb_index(57).gre <= 130;  k_rgb_index(57).blu <=  73;
             k_rgb_index(58).red <=  54;  k_rgb_index(58).gre <= 130;  k_rgb_index(58).blu <=  93;
             k_rgb_index(59).red <=  44;  k_rgb_index(59).gre <= 120;  k_rgb_index(59).blu <=  83;
             k_rgb_index(60).red <=  34;  k_rgb_index(60).gre <= 120;  k_rgb_index(60).blu <=  83;
             k_rgb_index(61).red <=  24;  k_rgb_index(61).gre <= 100;  k_rgb_index(61).blu <=  73;
             k_rgb_index(62).red <=  24;  k_rgb_index(62).gre <= 100;  k_rgb_index(62).blu <=  33;
             k_rgb_index(63).red <=  44;  k_rgb_index(63).gre <=  70;  k_rgb_index(63).blu <=  53;
             k_rgb_index(64).red <=  34;  k_rgb_index(64).gre <=  70;  k_rgb_index(64).blu <=  43;
             k_rgb_index(65).red <=  24;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  43;
             k_rgb_index(66).red <=  14;  k_rgb_index(66).gre <=  60;  k_rgb_index(66).blu <=  33;
             k_rgb_index(67).red <=  34;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  33;
             k_rgb_index(68).red <=  24;  k_rgb_index(68).gre <=  50;  k_rgb_index(68).blu <=  23;
             k_rgb_index(69).red <=  24;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  33;
             k_rgb_index(70).red <=  14;  k_rgb_index(70).gre <=  40;  k_rgb_index(70).blu <=  23;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 246;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <= 236;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <= 226;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <= 216;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <= 145;  k_rgb_index(76).gre <= 206;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <= 135;  k_rgb_index(77).gre <= 196;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <= 125;  k_rgb_index(78).gre <= 186;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <= 115;  k_rgb_index(79).gre <= 176;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 175;  k_rgb_index(80).gre <= 196;  k_rgb_index(80).blu <= 230;
             k_rgb_index(81).red <= 165;  k_rgb_index(81).gre <= 186;  k_rgb_index(81).blu <= 230;
             k_rgb_index(82).red <=  65;  k_rgb_index(82).gre <=  86;  k_rgb_index(82).blu <= 230;
             k_rgb_index(83).red <= 145;  k_rgb_index(83).gre <= 186;  k_rgb_index(83).blu <= 220;
             k_rgb_index(84).red <= 135;  k_rgb_index(84).gre <= 176;  k_rgb_index(84).blu <= 220;
             k_rgb_index(85).red <=  15;  k_rgb_index(85).gre <=  56;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <=  95;  k_rgb_index(86).gre <= 186;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 135;  k_rgb_index(87).gre <= 166;  k_rgb_index(87).blu <= 180;
             k_rgb_index(88).red <= 125;  k_rgb_index(88).gre <= 156;  k_rgb_index(88).blu <= 180;
             k_rgb_index(89).red <= 115;  k_rgb_index(89).gre <= 156;  k_rgb_index(89).blu <= 170;
             k_rgb_index(90).red <= 105;  k_rgb_index(90).gre <= 146;  k_rgb_index(90).blu <= 170;
             k_rgb_index(91).red <=  25;  k_rgb_index(91).gre <=  36;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  45;  k_rgb_index(92).gre <=  76;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  65;  k_rgb_index(93).gre <=  96;  k_rgb_index(93).blu <= 130;
             k_rgb_index(94).red <=  55;  k_rgb_index(94).gre <=  86;  k_rgb_index(94).blu <= 130;
             k_rgb_index(95).red <=  45;  k_rgb_index(95).gre <=  86;  k_rgb_index(95).blu <= 120;
             k_rgb_index(96).red <=  35;  k_rgb_index(96).gre <=  76;  k_rgb_index(96).blu <= 120;
             k_rgb_index(97).red <=  25;  k_rgb_index(97).gre <=  56;  k_rgb_index(97).blu <= 100;
             k_rgb_index(98).red <=  45;  k_rgb_index(98).gre <=  56;  k_rgb_index(98).blu <=  70;
             k_rgb_index(99).red <=  35;  k_rgb_index(99).gre <=  46;  k_rgb_index(99).blu <=  70;
            k_rgb_index(100).red <=  25; k_rgb_index(100).gre <=  46; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  60;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  36; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  25; k_rgb_index(104).gre <=  36; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  15; k_rgb_index(105).gre <=  26; k_rgb_index(105).blu <=  40;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        elsif (iLutNum = 13) then
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 251;   k_rgb_index(1).blu <= 242;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 241;   k_rgb_index(2).blu <= 232;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <= 231;   k_rgb_index(3).blu <= 202;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <= 221;   k_rgb_index(4).blu <= 182;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <= 211;   k_rgb_index(5).blu <= 122;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 201;   k_rgb_index(6).blu <= 142;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 191;   k_rgb_index(7).blu <= 132;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 181;   k_rgb_index(8).blu <= 122;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <= 171;   k_rgb_index(9).blu <= 112;
             k_rgb_index(10).red <= 230;  k_rgb_index(10).gre <= 191;  k_rgb_index(10).blu <= 172;
             k_rgb_index(11).red <= 230;  k_rgb_index(11).gre <= 181;  k_rgb_index(11).blu <= 162;
             k_rgb_index(12).red <= 230;  k_rgb_index(12).gre <=  81;  k_rgb_index(12).blu <=  62;
             k_rgb_index(13).red <= 220;  k_rgb_index(13).gre <= 181;  k_rgb_index(13).blu <= 142;
             k_rgb_index(14).red <= 220;  k_rgb_index(14).gre <= 171;  k_rgb_index(14).blu <= 132;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <=  51;  k_rgb_index(15).blu <=  12;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 181;  k_rgb_index(16).blu <=  92;
             k_rgb_index(17).red <= 180;  k_rgb_index(17).gre <= 161;  k_rgb_index(17).blu <= 132;
             k_rgb_index(18).red <= 180;  k_rgb_index(18).gre <= 151;  k_rgb_index(18).blu <= 122;
             k_rgb_index(19).red <= 170;  k_rgb_index(19).gre <= 151;  k_rgb_index(19).blu <= 112;
             k_rgb_index(20).red <= 170;  k_rgb_index(20).gre <= 141;  k_rgb_index(20).blu <= 102;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <=  31;  k_rgb_index(21).blu <=  22;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <=  71;  k_rgb_index(22).blu <=  42;
             k_rgb_index(23).red <= 130;  k_rgb_index(23).gre <=  91;  k_rgb_index(23).blu <=  62;
             k_rgb_index(24).red <= 130;  k_rgb_index(24).gre <=  81;  k_rgb_index(24).blu <=  52;
             k_rgb_index(25).red <= 120;  k_rgb_index(25).gre <=  81;  k_rgb_index(25).blu <=  42;
             k_rgb_index(26).red <= 120;  k_rgb_index(26).gre <=  71;  k_rgb_index(26).blu <=  32;
             k_rgb_index(27).red <= 100;  k_rgb_index(27).gre <=  51;  k_rgb_index(27).blu <=  22;
             k_rgb_index(28).red <=  70;  k_rgb_index(28).gre <=  51;  k_rgb_index(28).blu <=  42;
             k_rgb_index(29).red <=  70;  k_rgb_index(29).gre <=  41;  k_rgb_index(29).blu <=  32;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  41;  k_rgb_index(30).blu <=  22;
             k_rgb_index(31).red <=  60;  k_rgb_index(31).gre <=  31;  k_rgb_index(31).blu <=  12;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  31;  k_rgb_index(32).blu <=  32;
             k_rgb_index(33).red <=  50;  k_rgb_index(33).gre <=  31;  k_rgb_index(33).blu <=  22;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  31;  k_rgb_index(34).blu <=  22;
             k_rgb_index(35).red <=  40;  k_rgb_index(35).gre <=  21;  k_rgb_index(35).blu <=  12;
             k_rgb_index(36).red <= 244;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 253;
             k_rgb_index(37).red <= 234;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 243;
             k_rgb_index(38).red <= 204;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <= 233;
             k_rgb_index(39).red <= 184;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <= 223;
             k_rgb_index(40).red <= 124;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <= 213;
             k_rgb_index(41).red <= 144;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 203;
             k_rgb_index(42).red <= 134;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 193;
             k_rgb_index(43).red <= 124;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 183;
             k_rgb_index(44).red <= 114;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <= 173;
             k_rgb_index(45).red <= 174;  k_rgb_index(45).gre <= 230;  k_rgb_index(45).blu <= 193;
             k_rgb_index(46).red <= 164;  k_rgb_index(46).gre <= 230;  k_rgb_index(46).blu <= 183;
             k_rgb_index(47).red <=  64;  k_rgb_index(47).gre <= 230;  k_rgb_index(47).blu <=  83;
             k_rgb_index(48).red <= 144;  k_rgb_index(48).gre <= 220;  k_rgb_index(48).blu <= 183;
             k_rgb_index(49).red <= 134;  k_rgb_index(49).gre <= 220;  k_rgb_index(49).blu <= 173;
             k_rgb_index(50).red <=  14;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <=  53;
             k_rgb_index(51).red <=  94;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 183;
             k_rgb_index(52).red <= 134;  k_rgb_index(52).gre <= 180;  k_rgb_index(52).blu <= 163;
             k_rgb_index(53).red <= 124;  k_rgb_index(53).gre <= 180;  k_rgb_index(53).blu <= 153;
             k_rgb_index(54).red <= 114;  k_rgb_index(54).gre <= 170;  k_rgb_index(54).blu <= 153;
             k_rgb_index(55).red <= 104;  k_rgb_index(55).gre <= 170;  k_rgb_index(55).blu <= 143;
             k_rgb_index(56).red <=  44;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 143;
             k_rgb_index(57).red <=  64;  k_rgb_index(57).gre <= 130;  k_rgb_index(57).blu <=  73;
             k_rgb_index(58).red <=  54;  k_rgb_index(58).gre <= 130;  k_rgb_index(58).blu <=  93;
             k_rgb_index(59).red <=  44;  k_rgb_index(59).gre <= 120;  k_rgb_index(59).blu <=  83;
             k_rgb_index(60).red <=  34;  k_rgb_index(60).gre <= 120;  k_rgb_index(60).blu <=  83;
             k_rgb_index(61).red <=  24;  k_rgb_index(61).gre <= 100;  k_rgb_index(61).blu <=  73;
             k_rgb_index(62).red <=  24;  k_rgb_index(62).gre <= 100;  k_rgb_index(62).blu <=  33;
             k_rgb_index(63).red <=  44;  k_rgb_index(63).gre <=  70;  k_rgb_index(63).blu <=  53;
             k_rgb_index(64).red <=  34;  k_rgb_index(64).gre <=  70;  k_rgb_index(64).blu <=  43;
             k_rgb_index(65).red <=  24;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  43;
             k_rgb_index(66).red <=  14;  k_rgb_index(66).gre <=  60;  k_rgb_index(66).blu <=  33;
             k_rgb_index(67).red <=  34;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  33;
             k_rgb_index(68).red <=  24;  k_rgb_index(68).gre <=  50;  k_rgb_index(68).blu <=  23;
             k_rgb_index(69).red <=  24;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  33;
             k_rgb_index(70).red <=  14;  k_rgb_index(70).gre <=  40;  k_rgb_index(70).blu <=  23;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 246;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <= 236;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <= 226;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <= 216;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <= 145;  k_rgb_index(76).gre <= 206;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <= 135;  k_rgb_index(77).gre <= 196;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <= 125;  k_rgb_index(78).gre <= 186;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <= 115;  k_rgb_index(79).gre <= 176;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 175;  k_rgb_index(80).gre <= 196;  k_rgb_index(80).blu <= 230;
             k_rgb_index(81).red <= 165;  k_rgb_index(81).gre <= 186;  k_rgb_index(81).blu <= 230;
             k_rgb_index(82).red <=  65;  k_rgb_index(82).gre <=  86;  k_rgb_index(82).blu <= 230;
             k_rgb_index(83).red <= 145;  k_rgb_index(83).gre <= 186;  k_rgb_index(83).blu <= 220;
             k_rgb_index(84).red <= 135;  k_rgb_index(84).gre <= 176;  k_rgb_index(84).blu <= 220;
             k_rgb_index(85).red <=  15;  k_rgb_index(85).gre <=  56;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <=  95;  k_rgb_index(86).gre <= 186;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 135;  k_rgb_index(87).gre <= 166;  k_rgb_index(87).blu <= 180;
             k_rgb_index(88).red <= 125;  k_rgb_index(88).gre <= 156;  k_rgb_index(88).blu <= 180;
             k_rgb_index(89).red <= 115;  k_rgb_index(89).gre <= 156;  k_rgb_index(89).blu <= 170;
             k_rgb_index(90).red <= 105;  k_rgb_index(90).gre <= 146;  k_rgb_index(90).blu <= 170;
             k_rgb_index(91).red <=  25;  k_rgb_index(91).gre <=  36;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  45;  k_rgb_index(92).gre <=  76;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  65;  k_rgb_index(93).gre <=  96;  k_rgb_index(93).blu <= 130;
             k_rgb_index(94).red <=  55;  k_rgb_index(94).gre <=  86;  k_rgb_index(94).blu <= 130;
             k_rgb_index(95).red <=  45;  k_rgb_index(95).gre <=  86;  k_rgb_index(95).blu <= 120;
             k_rgb_index(96).red <=  35;  k_rgb_index(96).gre <=  76;  k_rgb_index(96).blu <= 120;
             k_rgb_index(97).red <=  25;  k_rgb_index(97).gre <=  56;  k_rgb_index(97).blu <= 100;
             k_rgb_index(98).red <=  45;  k_rgb_index(98).gre <=  56;  k_rgb_index(98).blu <=  70;
             k_rgb_index(99).red <=  35;  k_rgb_index(99).gre <=  46;  k_rgb_index(99).blu <=  70;
            k_rgb_index(100).red <=  25; k_rgb_index(100).gre <=  46; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  60;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  36; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  25; k_rgb_index(104).gre <=  36; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  15; k_rgb_index(105).gre <=  26; k_rgb_index(105).blu <=  40;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        else
              k_rgb_index(0).red <=   0;   k_rgb_index(0).gre <=   0;   k_rgb_index(0).blu <=   0;
              k_rgb_index(1).red <= 255;   k_rgb_index(1).gre <= 251;   k_rgb_index(1).blu <= 242;
              k_rgb_index(2).red <= 255;   k_rgb_index(2).gre <= 241;   k_rgb_index(2).blu <= 232;
              k_rgb_index(3).red <= 255;   k_rgb_index(3).gre <= 231;   k_rgb_index(3).blu <= 202;
              k_rgb_index(4).red <= 255;   k_rgb_index(4).gre <= 221;   k_rgb_index(4).blu <= 182;
              k_rgb_index(5).red <= 255;   k_rgb_index(5).gre <= 211;   k_rgb_index(5).blu <= 122;
              k_rgb_index(6).red <= 255;   k_rgb_index(6).gre <= 201;   k_rgb_index(6).blu <= 142;
              k_rgb_index(7).red <= 255;   k_rgb_index(7).gre <= 191;   k_rgb_index(7).blu <= 132;
              k_rgb_index(8).red <= 255;   k_rgb_index(8).gre <= 181;   k_rgb_index(8).blu <= 122;
              k_rgb_index(9).red <= 255;   k_rgb_index(9).gre <= 171;   k_rgb_index(9).blu <= 112;
             k_rgb_index(10).red <= 230;  k_rgb_index(10).gre <= 191;  k_rgb_index(10).blu <= 172;
             k_rgb_index(11).red <= 230;  k_rgb_index(11).gre <= 181;  k_rgb_index(11).blu <= 162;
             k_rgb_index(12).red <= 230;  k_rgb_index(12).gre <=  81;  k_rgb_index(12).blu <=  62;
             k_rgb_index(13).red <= 220;  k_rgb_index(13).gre <= 181;  k_rgb_index(13).blu <= 142;
             k_rgb_index(14).red <= 220;  k_rgb_index(14).gre <= 171;  k_rgb_index(14).blu <= 132;
             k_rgb_index(15).red <= 200;  k_rgb_index(15).gre <=  51;  k_rgb_index(15).blu <=  12;
             k_rgb_index(16).red <= 200;  k_rgb_index(16).gre <= 181;  k_rgb_index(16).blu <=  92;
             k_rgb_index(17).red <= 180;  k_rgb_index(17).gre <= 161;  k_rgb_index(17).blu <= 132;
             k_rgb_index(18).red <= 180;  k_rgb_index(18).gre <= 151;  k_rgb_index(18).blu <= 122;
             k_rgb_index(19).red <= 170;  k_rgb_index(19).gre <= 151;  k_rgb_index(19).blu <= 112;
             k_rgb_index(20).red <= 170;  k_rgb_index(20).gre <= 141;  k_rgb_index(20).blu <= 102;
             k_rgb_index(21).red <= 150;  k_rgb_index(21).gre <=  31;  k_rgb_index(21).blu <=  22;
             k_rgb_index(22).red <= 150;  k_rgb_index(22).gre <=  71;  k_rgb_index(22).blu <=  42;
             k_rgb_index(23).red <= 130;  k_rgb_index(23).gre <=  91;  k_rgb_index(23).blu <=  62;
             k_rgb_index(24).red <= 130;  k_rgb_index(24).gre <=  81;  k_rgb_index(24).blu <=  52;
             k_rgb_index(25).red <= 120;  k_rgb_index(25).gre <=  81;  k_rgb_index(25).blu <=  42;
             k_rgb_index(26).red <= 120;  k_rgb_index(26).gre <=  71;  k_rgb_index(26).blu <=  32;
             k_rgb_index(27).red <= 100;  k_rgb_index(27).gre <=  51;  k_rgb_index(27).blu <=  22;
             k_rgb_index(28).red <=  70;  k_rgb_index(28).gre <=  51;  k_rgb_index(28).blu <=  42;
             k_rgb_index(29).red <=  70;  k_rgb_index(29).gre <=  41;  k_rgb_index(29).blu <=  32;
             k_rgb_index(30).red <=  60;  k_rgb_index(30).gre <=  41;  k_rgb_index(30).blu <=  22;
             k_rgb_index(31).red <=  60;  k_rgb_index(31).gre <=  31;  k_rgb_index(31).blu <=  12;
             k_rgb_index(32).red <=  50;  k_rgb_index(32).gre <=  31;  k_rgb_index(32).blu <=  32;
             k_rgb_index(33).red <=  50;  k_rgb_index(33).gre <=  31;  k_rgb_index(33).blu <=  22;
             k_rgb_index(34).red <=  40;  k_rgb_index(34).gre <=  31;  k_rgb_index(34).blu <=  22;
             k_rgb_index(35).red <=  40;  k_rgb_index(35).gre <=  21;  k_rgb_index(35).blu <=  12;
             k_rgb_index(36).red <= 244;  k_rgb_index(36).gre <= 255;  k_rgb_index(36).blu <= 253;
             k_rgb_index(37).red <= 234;  k_rgb_index(37).gre <= 255;  k_rgb_index(37).blu <= 243;
             k_rgb_index(38).red <= 204;  k_rgb_index(38).gre <= 255;  k_rgb_index(38).blu <= 233;
             k_rgb_index(39).red <= 184;  k_rgb_index(39).gre <= 255;  k_rgb_index(39).blu <= 223;
             k_rgb_index(40).red <= 124;  k_rgb_index(40).gre <= 255;  k_rgb_index(40).blu <= 213;
             k_rgb_index(41).red <= 144;  k_rgb_index(41).gre <= 255;  k_rgb_index(41).blu <= 203;
             k_rgb_index(42).red <= 134;  k_rgb_index(42).gre <= 255;  k_rgb_index(42).blu <= 193;
             k_rgb_index(43).red <= 124;  k_rgb_index(43).gre <= 255;  k_rgb_index(43).blu <= 183;
             k_rgb_index(44).red <= 114;  k_rgb_index(44).gre <= 255;  k_rgb_index(44).blu <= 173;
             k_rgb_index(45).red <= 174;  k_rgb_index(45).gre <= 230;  k_rgb_index(45).blu <= 193;
             k_rgb_index(46).red <= 164;  k_rgb_index(46).gre <= 230;  k_rgb_index(46).blu <= 183;
             k_rgb_index(47).red <=  64;  k_rgb_index(47).gre <= 230;  k_rgb_index(47).blu <=  83;
             k_rgb_index(48).red <= 144;  k_rgb_index(48).gre <= 220;  k_rgb_index(48).blu <= 183;
             k_rgb_index(49).red <= 134;  k_rgb_index(49).gre <= 220;  k_rgb_index(49).blu <= 173;
             k_rgb_index(50).red <=  14;  k_rgb_index(50).gre <= 200;  k_rgb_index(50).blu <=  53;
             k_rgb_index(51).red <=  94;  k_rgb_index(51).gre <= 200;  k_rgb_index(51).blu <= 183;
             k_rgb_index(52).red <= 134;  k_rgb_index(52).gre <= 180;  k_rgb_index(52).blu <= 163;
             k_rgb_index(53).red <= 124;  k_rgb_index(53).gre <= 180;  k_rgb_index(53).blu <= 153;
             k_rgb_index(54).red <= 114;  k_rgb_index(54).gre <= 170;  k_rgb_index(54).blu <= 153;
             k_rgb_index(55).red <= 104;  k_rgb_index(55).gre <= 170;  k_rgb_index(55).blu <= 143;
             k_rgb_index(56).red <=  44;  k_rgb_index(56).gre <= 150;  k_rgb_index(56).blu <= 143;
             k_rgb_index(57).red <=  64;  k_rgb_index(57).gre <= 130;  k_rgb_index(57).blu <=  73;
             k_rgb_index(58).red <=  54;  k_rgb_index(58).gre <= 130;  k_rgb_index(58).blu <=  93;
             k_rgb_index(59).red <=  44;  k_rgb_index(59).gre <= 120;  k_rgb_index(59).blu <=  83;
             k_rgb_index(60).red <=  34;  k_rgb_index(60).gre <= 120;  k_rgb_index(60).blu <=  83;
             k_rgb_index(61).red <=  24;  k_rgb_index(61).gre <= 100;  k_rgb_index(61).blu <=  73;
             k_rgb_index(62).red <=  24;  k_rgb_index(62).gre <= 100;  k_rgb_index(62).blu <=  33;
             k_rgb_index(63).red <=  44;  k_rgb_index(63).gre <=  70;  k_rgb_index(63).blu <=  53;
             k_rgb_index(64).red <=  34;  k_rgb_index(64).gre <=  70;  k_rgb_index(64).blu <=  43;
             k_rgb_index(65).red <=  24;  k_rgb_index(65).gre <=  60;  k_rgb_index(65).blu <=  43;
             k_rgb_index(66).red <=  14;  k_rgb_index(66).gre <=  60;  k_rgb_index(66).blu <=  33;
             k_rgb_index(67).red <=  34;  k_rgb_index(67).gre <=  50;  k_rgb_index(67).blu <=  33;
             k_rgb_index(68).red <=  24;  k_rgb_index(68).gre <=  50;  k_rgb_index(68).blu <=  23;
             k_rgb_index(69).red <=  24;  k_rgb_index(69).gre <=  40;  k_rgb_index(69).blu <=  33;
             k_rgb_index(70).red <=  14;  k_rgb_index(70).gre <=  40;  k_rgb_index(70).blu <=  23;
             k_rgb_index(71).red <= 245;  k_rgb_index(71).gre <= 256;  k_rgb_index(71).blu <= 255;
             k_rgb_index(72).red <= 235;  k_rgb_index(72).gre <= 246;  k_rgb_index(72).blu <= 255;
             k_rgb_index(73).red <= 205;  k_rgb_index(73).gre <= 236;  k_rgb_index(73).blu <= 255;
             k_rgb_index(74).red <= 185;  k_rgb_index(74).gre <= 226;  k_rgb_index(74).blu <= 255;
             k_rgb_index(75).red <= 125;  k_rgb_index(75).gre <= 216;  k_rgb_index(75).blu <= 255;
             k_rgb_index(76).red <= 145;  k_rgb_index(76).gre <= 206;  k_rgb_index(76).blu <= 255;
             k_rgb_index(77).red <= 135;  k_rgb_index(77).gre <= 196;  k_rgb_index(77).blu <= 255;
             k_rgb_index(78).red <= 125;  k_rgb_index(78).gre <= 186;  k_rgb_index(78).blu <= 255;
             k_rgb_index(79).red <= 115;  k_rgb_index(79).gre <= 176;  k_rgb_index(79).blu <= 255;
             k_rgb_index(80).red <= 175;  k_rgb_index(80).gre <= 196;  k_rgb_index(80).blu <= 230;
             k_rgb_index(81).red <= 165;  k_rgb_index(81).gre <= 186;  k_rgb_index(81).blu <= 230;
             k_rgb_index(82).red <=  65;  k_rgb_index(82).gre <=  86;  k_rgb_index(82).blu <= 230;
             k_rgb_index(83).red <= 145;  k_rgb_index(83).gre <= 186;  k_rgb_index(83).blu <= 220;
             k_rgb_index(84).red <= 135;  k_rgb_index(84).gre <= 176;  k_rgb_index(84).blu <= 220;
             k_rgb_index(85).red <=  15;  k_rgb_index(85).gre <=  56;  k_rgb_index(85).blu <= 200;
             k_rgb_index(86).red <=  95;  k_rgb_index(86).gre <= 186;  k_rgb_index(86).blu <= 200;
             k_rgb_index(87).red <= 135;  k_rgb_index(87).gre <= 166;  k_rgb_index(87).blu <= 180;
             k_rgb_index(88).red <= 125;  k_rgb_index(88).gre <= 156;  k_rgb_index(88).blu <= 180;
             k_rgb_index(89).red <= 115;  k_rgb_index(89).gre <= 156;  k_rgb_index(89).blu <= 170;
             k_rgb_index(90).red <= 105;  k_rgb_index(90).gre <= 146;  k_rgb_index(90).blu <= 170;
             k_rgb_index(91).red <=  25;  k_rgb_index(91).gre <=  36;  k_rgb_index(91).blu <= 150;
             k_rgb_index(92).red <=  45;  k_rgb_index(92).gre <=  76;  k_rgb_index(92).blu <= 150;
             k_rgb_index(93).red <=  65;  k_rgb_index(93).gre <=  96;  k_rgb_index(93).blu <= 130;
             k_rgb_index(94).red <=  55;  k_rgb_index(94).gre <=  86;  k_rgb_index(94).blu <= 130;
             k_rgb_index(95).red <=  45;  k_rgb_index(95).gre <=  86;  k_rgb_index(95).blu <= 120;
             k_rgb_index(96).red <=  35;  k_rgb_index(96).gre <=  76;  k_rgb_index(96).blu <= 120;
             k_rgb_index(97).red <=  25;  k_rgb_index(97).gre <=  56;  k_rgb_index(97).blu <= 100;
             k_rgb_index(98).red <=  45;  k_rgb_index(98).gre <=  56;  k_rgb_index(98).blu <=  70;
             k_rgb_index(99).red <=  35;  k_rgb_index(99).gre <=  46;  k_rgb_index(99).blu <=  70;
            k_rgb_index(100).red <=  25; k_rgb_index(100).gre <=  46; k_rgb_index(100).blu <=  60;
            k_rgb_index(101).red <=  15; k_rgb_index(101).gre <=  36; k_rgb_index(101).blu <=  60;
            k_rgb_index(102).red <=  35; k_rgb_index(102).gre <=  36; k_rgb_index(102).blu <=  50;
            k_rgb_index(103).red <=  25; k_rgb_index(103).gre <=  36; k_rgb_index(103).blu <=  50;
            k_rgb_index(104).red <=  25; k_rgb_index(104).gre <=  36; k_rgb_index(104).blu <=  40;
            k_rgb_index(105).red <=  15; k_rgb_index(105).gre <=  26; k_rgb_index(105).blu <=  40;
            k_rgb_index(106).red <= 255; k_rgb_index(106).gre <= 255; k_rgb_index(106).blu <= 255;
        end if;
    end if;
end process;




process (clk)begin
    if rising_edge(clk) then
    
    if (k_lut = 0) then
            ---------------------------------------------------------------------------------------------------------
            if (rgb_sync2.red = rgb_max1) then
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i).red;   k_rgb(i).gre <=  k_rgb_index(i).blu;   k_rgb(i).blu <=  k_rgb_index(i).gre;
                        end loop;
                    else
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i).red;   k_rgb(i).gre <=  k_rgb_index(i).gre;   k_rgb(i).blu <=  k_rgb_index(i).blu;
                        end loop;
                    end if;
            -- GREEN MAX
            elsif (rgb_sync2.green = rgb_max1) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i).blu;   k_rgb(i).gre <=  k_rgb_index(i).red;   k_rgb(i).blu <=  k_rgb_index(i).gre;
                          end loop;
                    else
                          for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i).gre;   k_rgb(i).gre <=  k_rgb_index(i).red;   k_rgb(i).blu <=  k_rgb_index(i).blu;
                          end loop;
                    end if;
            else
            -- BLUE MAX
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i).blu;   k_rgb(i).gre <=  k_rgb_index(i).gre;   k_rgb(i).blu <=  k_rgb_index(i).red;
                        end loop;
                    else
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i).gre;   k_rgb(i).gre <=  k_rgb_index(i).blu;   k_rgb(i).blu <=  k_rgb_index(i).red;
                        end loop;
                    end if;
            end if;
            ---------------------------------------------------------------------------------------------------------
    elsif(k_lut = 1) then
            ---------------------------------------------------------------------------------------------------------
            if (rgb_sync2.red = rgb_max1) then
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+35).red;   k_rgb(i).gre <=  k_rgb_index(i+35).blu;   k_rgb(i).blu <=  k_rgb_index(i+35).gre;
                        end loop;
                    else
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+35).red;   k_rgb(i).gre <=  k_rgb_index(i+35).gre;   k_rgb(i).blu <=  k_rgb_index(i+35).blu;
                        end loop;
                    end if;
            -- GREEN MAX
            elsif (rgb_sync2.green = rgb_max1) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+35).blu;   k_rgb(i).gre <=  k_rgb_index(i+35).red;   k_rgb(i).blu <=  k_rgb_index(i+35).gre;
                          end loop;
                    else
                          for i in 0 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+35).gre;   k_rgb(i).gre <=  k_rgb_index(i+35).red;   k_rgb(i).blu <=  k_rgb_index(i+35).blu;
                          end loop;
                    end if;
            else
            -- BLUE MAX
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+35).blu;   k_rgb(i).gre <=  k_rgb_index(i+35).gre;   k_rgb(i).blu <=  k_rgb_index(i+35).red;
                        end loop;
                    else
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+35).gre;   k_rgb(i).gre <=  k_rgb_index(i+35).blu;   k_rgb(i).blu <=  k_rgb_index(i+35).red;
                        end loop;
                    end if;
            end if;
            ---------------------------------------------------------------------------------------------------------
    else
            ---------------------------------------------------------------------------------------------------------
            if (rgb_sync2.red = rgb_max1) then
                    if (rgb_sync2.green = rgb_min1) then
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+70).red;   k_rgb(i).gre <=  k_rgb_index(i+70).blu;   k_rgb(i).blu <=  k_rgb_index(i+70).gre;
                        end loop;
                    else
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+70).red;   k_rgb(i).gre <=  k_rgb_index(i+70).gre;   k_rgb(i).blu <=  k_rgb_index(i+70).blu;
                        end loop;
                    end if;
            -- GREEN MAX
            elsif (rgb_sync2.green = rgb_max1) then
                    if (rgb_sync2.red = rgb_min1) then
                          for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+70).blu;   k_rgb(i).gre <=  k_rgb_index(i+70).red;   k_rgb(i).blu <=  k_rgb_index(i+70).gre;
                          end loop;
                    else
                          for i in 0 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+70).gre;   k_rgb(i).gre <=  k_rgb_index(i+70).red;   k_rgb(i).blu <=  k_rgb_index(i+70).blu;
                          end loop;
                    end if;
            else
            -- BLUE MAX
                    if (rgb_sync2.red = rgb_min1) then
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+70).blu;   k_rgb(i).gre <=  k_rgb_index(i+70).gre;   k_rgb(i).blu <=  k_rgb_index(i+70).red;
                        end loop;
                    else
                        for i in 1 to 35 loop
                            k_rgb(i).red <=   k_rgb_index(i+70).gre;   k_rgb(i).gre <=  k_rgb_index(i+70).blu;   k_rgb(i).blu <=  k_rgb_index(i+70).red;
                        end loop;
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

color_k1_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
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
    iRgb               => rgb_sync,
    k_rgb.red          => k_rgb(30).red,
    k_rgb.gre          => k_rgb(30).gre,
    k_rgb.blu          => k_rgb(30).blu,
    threshold          => thr1.threshold30);
color_k31_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_sync,
    k_rgb.red          => k_rgb(31).red,
    k_rgb.gre          => k_rgb(31).gre,
    k_rgb.blu          => k_rgb(31).blu,
    threshold          => thr1.threshold31);
color_k32_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_sync,
    k_rgb.red          => k_rgb(32).red,
    k_rgb.gre          => k_rgb(32).gre,
    k_rgb.blu          => k_rgb(32).blu,
    threshold          => thr1.threshold32);
color_k33_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_sync,
    k_rgb.red          => k_rgb(33).red,
    k_rgb.gre          => k_rgb(33).gre,
    k_rgb.blu          => k_rgb(33).blu,
    threshold          => thr1.threshold33);
color_k34_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_sync,
    k_rgb.red          => k_rgb(34).red,
    k_rgb.gre          => k_rgb(34).gre,
    k_rgb.blu          => k_rgb(34).blu,
    threshold          => thr1.threshold34);
color_k35_clustering_inst: clustering
generic map(
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb_sync,
    k_rgb.red          => k_rgb(35).red,
    k_rgb.gre          => k_rgb(35).gre,
    k_rgb.blu          => k_rgb(35).blu,
    threshold          => thr1.threshold35);

process (clk) begin
    if rising_edge(clk) then
    if(K_VALUE = 1)then
      -- RED
      threshold_lms_1  <= thr1.threshold1;
      threshold_lms_2  <= thr1.threshold5;
      -- GREEN
      threshold_lms_3  <= thr1.threshold16;
      threshold_lms_4  <= thr1.threshold21;
      -- BLUE
      threshold_lms_5  <= thr1.threshold30;
      threshold_lms_6  <= thr1.threshold35;
    elsif(K_VALUE = 2)then
      -- RED
      threshold_lms_1  <= thr1.threshold1;
      threshold_lms_2  <= thr1.threshold5;
      -- GREEN
      threshold_lms_3  <= thr1.threshold16;
      threshold_lms_4  <= thr1.threshold21;
      -- BLUE
      threshold_lms_5  <= thr1.threshold30;
      threshold_lms_6  <= thr1.threshold35;
    elsif(K_VALUE = 3)then
      -- RED
      threshold_lms_1  <= thr1.threshold1;
      threshold_lms_2  <= thr1.threshold5;
      -- GREEN
      threshold_lms_3  <= thr1.threshold16;
      threshold_lms_4  <= thr1.threshold21;
      -- BLUE
      threshold_lms_5  <= thr1.threshold30;
      threshold_lms_6  <= thr1.threshold35;
    elsif(K_VALUE = 4)then
      -- RED
      threshold_lms_1  <= thr1.threshold1;
      threshold_lms_2  <= thr1.threshold5;
      -- GREEN
      threshold_lms_3  <= thr1.threshold16;
      threshold_lms_4  <= thr1.threshold21;
      -- BLUE
      threshold_lms_5  <= thr1.threshold30;
      threshold_lms_6  <= thr1.threshold35;
    elsif(K_VALUE = 5)then
      -- RED
      threshold_lms_1  <= thr1.threshold1;
      threshold_lms_2  <= thr1.threshold2;
      threshold_lms_3  <= thr1.threshold3;
      -- GREEN
      threshold_lms_4  <= thr1.threshold15;
      threshold_lms_5  <= thr1.threshold16;
      threshold_lms_6  <= thr1.threshold17;
      -- BLUE
      threshold_lms_7  <= thr1.threshold25;
      threshold_lms_8  <= thr1.threshold30;
      threshold_lms_9  <= thr1.threshold35;
    else
      -- RED
      threshold_lms_1  <= int_min_val(thr1.threshold1,thr1.threshold2,thr1.threshold3,thr1.threshold4,thr1.threshold5);
      threshold_lms_2  <= int_min_val(thr1.threshold6,thr1.threshold7,thr1.threshold8,thr1.threshold9,thr1.threshold10);
      threshold_lms_3  <= int_min_val(thr1.threshold11,thr1.threshold12,thr1.threshold13,thr1.threshold14,thr1.threshold15);
      threshold_lms_4  <= int_min_val(thr1.threshold16,thr1.threshold17,thr1.threshold18,thr1.threshold19,thr1.threshold20);
      threshold_lms_5  <= int_min_val(thr1.threshold21,thr1.threshold22,thr1.threshold23,thr1.threshold24,thr1.threshold25);
      threshold_lms_6  <= int_min_val(thr1.threshold26,thr1.threshold27,thr1.threshold28,thr1.threshold29,thr1.threshold30);
      threshold_lms_7  <= int_min_val(thr1.threshold31,thr1.threshold32,thr1.threshold33,thr1.threshold34,thr1.threshold35);
    end if; 
    end if; 
end process;
process (clk) begin
    if rising_edge(clk) then
        if(K_VALUE = 1 or K_VALUE = 2 or K_VALUE = 3 or K_VALUE = 4)then
        --------------------------------------------------------------------
        -- 6 k_rgb Schemes
        --------------------------------------------------------------------
          threshold_red1  <= int_min_val(threshold_lms_1,threshold_lms_2);
          threshold_gre1  <= int_min_val(threshold_lms_3,threshold_lms_4);
          threshold_blu1  <= int_min_val(threshold_lms_5,threshold_lms_6);
        elsif(K_VALUE = 5)then
        --------------------------------------------------------------------
        -- 9 k_rgb Schemes
        --------------------------------------------------------------------
          threshold_red1   <= int_min_val(threshold_lms_1,threshold_lms_2,threshold_lms_3,threshold_lms_4,threshold_lms_5);
          threshold_red2   <= int_min_val(threshold_lms_6,threshold_lms_7,threshold_lms_8,threshold_lms_9);
        else
          threshold_red1   <= int_min_val(threshold_lms_1,threshold_lms_2,threshold_lms_3,threshold_lms_4);
          threshold_red2   <= int_min_val(threshold_lms_5,threshold_lms_6,threshold_lms_7);
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        threshold_lms    <= int_min_val(threshold_red1,threshold_red2);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        thr2 <= thr1;
        thr3 <= thr2;
        thr4 <= thr3;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
    if(K_VALUE = 1)then
        if (thr4.threshold1  = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(1).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(1).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(1).blu, 8));
        elsif(thr4.threshold2 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(5).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(5).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(5).blu, 8));
        elsif(thr4.threshold3 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(16).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(16).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(16).blu, 8));
        elsif(thr4.threshold4 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(21).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(21).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(21).blu, 8));
        elsif(thr4.threshold5 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(30).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(30).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(30).blu, 8));
        elsif(thr4.threshold6 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(35).red, 8));
            rgb_gre     <= std_logic_vector(to_unsigned(k26rgb(35).gre, 8));
            rgb_blu     <= std_logic_vector(to_unsigned(k26rgb(35).blu, 8));
        else
            rgb_red     <= std_logic_vector(to_unsigned(255, 8));
            rgb_gre     <= std_logic_vector(to_unsigned(255, 8));
            rgb_blu     <= std_logic_vector(to_unsigned(255, 8));
        end if;
    elsif(K_VALUE = 2)then
        if (thr4.threshold5  = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(5).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(5).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(5).blu, 8));
        elsif(thr4.threshold16 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(16).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(16).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(16).blu, 8));
        elsif(thr4.threshold40 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(40).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(40).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(40).blu, 8));
        elsif(thr4.threshold51 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(51).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(51).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(51).blu, 8));
        elsif(thr4.threshold65 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(65).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(65).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(65).blu, 8));
        elsif(thr4.threshold71 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(71).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(71).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(71).blu, 8));
        else
            rgb_red     <= std_logic_vector(to_unsigned(255, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(255, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(255, 8));
        end if;
    elsif(K_VALUE = 3)then
        if (thr4.threshold6  = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(6).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(6).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(6).blu, 8));
        elsif(thr4.threshold15 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(15).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(15).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(15).blu, 8));
        elsif(thr4.threshold41 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(41).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(41).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(41).blu, 8));
        elsif(thr4.threshold50 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(50).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(50).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(50).blu, 8));
        elsif(thr4.threshold66 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(66).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(66).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(66).blu, 8));
        elsif(thr4.threshold70 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(70).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(70).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(70).blu, 8));
        else
            rgb_red     <= std_logic_vector(to_unsigned(255, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(255, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(255, 8));
        end if;
    elsif(K_VALUE = 4)then
        if (thr4.threshold7  = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(7).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(7).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(7).blu, 8));
        elsif(thr4.threshold14 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(14).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(14).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(14).blu, 8));
        elsif(thr4.threshold42 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(42).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(42).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(42).blu, 8));
        elsif(thr4.threshold49 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(49).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(49).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(49).blu, 8));
        elsif(thr4.threshold67 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(67).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(67).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(67).blu, 8));
        elsif(thr4.threshold69 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(69).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(69).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(69).blu, 8));
        else
            rgb_red     <= std_logic_vector(to_unsigned(255, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(255, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(255, 8));
        end if;
    elsif(K_VALUE = 5)then
        if (thr4.threshold1  = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(1).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(1).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(1).blu, 8));
        elsif(thr4.threshold15  = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(15).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(15).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(15).blu, 8));
        elsif(thr4.threshold22 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(22).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(22).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(22).blu, 8));
        elsif(thr4.threshold36 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(36).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(36).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(36).blu, 8));
        elsif(thr4.threshold46 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(46).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(46).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(46).blu, 8));
        elsif(thr4.threshold52 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(52).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(52).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(52).blu, 8));
        elsif(thr4.threshold71 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(71).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(71).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(71).blu, 8));
        elsif(thr4.threshold83 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(83).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(83).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(83).blu, 8));
        elsif(thr4.threshold85 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(85).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(85).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(85).blu, 8));
        else
            rgb_red     <= std_logic_vector(to_unsigned(255, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(255, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(255, 8));
        end if;
    elsif(K_VALUE = 9)then
        if (thr4.threshold1  = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(1).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(1).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(1).blu, 8));
        elsif(thr4.threshold3  = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(3).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(3).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(3).blu, 8));
        elsif(thr4.threshold5 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(5).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(5).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(5).blu, 8));
        elsif(thr4.threshold6 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(6).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(6).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(6).blu, 8));
        elsif(thr4.threshold7  = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(7).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(7).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(7).blu, 8));
        elsif(thr4.threshold8 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(8).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(8).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(8).blu, 8));
        elsif(thr4.threshold9 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(9).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(9).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(9).blu, 8));
        elsif(thr4.threshold16 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(16).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(16).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(16).blu, 8));
        ----------------------------------------------------------------------------------------
        elsif(thr4.threshold36 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(36).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(36).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(36).blu, 8));
        elsif(thr4.threshold37 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(37).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(37).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(37).blu, 8));
        elsif(thr4.threshold38 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(38).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(38).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(38).blu, 8));
        elsif(thr4.threshold39 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(39).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(39).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(39).blu, 8));
        elsif(thr4.threshold40 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(40).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(40).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(40).blu, 8));
        elsif(thr4.threshold41 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(41).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(41).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(41).blu, 8));
        elsif(thr4.threshold42 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(42).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(42).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(42).blu, 8));
        elsif(thr4.threshold50 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(50).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(50).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(50).blu, 8));
        ----------------------------------------------------------------------------------------
        elsif(thr4.threshold62 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(62).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(62).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(62).blu, 8));
        elsif(thr4.threshold63 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(63).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(63).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(63).blu, 8));
        elsif(thr4.threshold65 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(65).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(65).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(65).blu, 8));
        elsif(thr4.threshold66 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(66).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(66).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(66).blu, 8));
        elsif(thr4.threshold67 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(67).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(67).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(67).blu, 8));
        elsif(thr4.threshold68 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(68).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(68).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(68).blu, 8));
        elsif(thr4.threshold69 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(69).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(69).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(69).blu, 8));
        elsif(thr4.threshold73 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(73).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(73).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(73).blu, 8));
        else
            rgb_red     <= std_logic_vector(to_unsigned(255, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(255, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(255, 8));
        end if;
        -------------
    else
        if (thr4.threshold1  = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(1).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(1).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(1).blu, 8));
        elsif(thr4.threshold2 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(2).red,8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(2).gre,8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(2).blu, 8));
        elsif(thr4.threshold3 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(3).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(3).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(3).blu, 8));
        elsif(thr4.threshold4 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(4).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(4).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(4).blu, 8));
        elsif(thr4.threshold5 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(5).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(5).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(5).blu, 8));
        elsif(thr4.threshold6 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(6).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(6).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(6).blu, 8));
        elsif(thr4.threshold7 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(7).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(7).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(7).blu, 8));
        elsif(thr4.threshold8 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(8).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(8).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(8).blu, 8));
        elsif(thr4.threshold9 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(9).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(9).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(9).blu, 8));
        elsif(thr4.threshold10 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(10).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(10).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(10).blu, 8));
        elsif(thr4.threshold11 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(11).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(11).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(11).blu, 8));
        elsif(thr4.threshold12 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(12).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(12).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(12).blu, 8));
        elsif(thr4.threshold13 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(13).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(13).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(13).blu, 8));
        elsif(thr4.threshold14 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(14).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(14).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(14).blu, 8));
        elsif(thr4.threshold15 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(15).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(15).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(15).blu, 8));
        elsif(thr4.threshold16 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(16).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(16).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(16).blu, 8));
        elsif(thr4.threshold17 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(17).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(17).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(17).blu, 8));
        elsif(thr4.threshold18 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(18).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(18).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(18).blu, 8));
        elsif(thr4.threshold19 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(19).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(19).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(19).blu, 8));
        elsif(thr4.threshold20 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(20).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(20).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(20).blu, 8));
        elsif(thr4.threshold21 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(21).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(21).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(21).blu, 8));
        elsif(thr4.threshold22 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(22).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(22).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(22).blu, 8));
        elsif(thr4.threshold23 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(23).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(23).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(23).blu, 8));
        elsif(thr4.threshold24 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(24).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(24).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(24).blu, 8));
        elsif(thr4.threshold25 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(25).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(25).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(25).blu, 8));
        elsif(thr4.threshold26 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(26).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(26).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(26).blu, 8));
        elsif(thr4.threshold27 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(27).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(27).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(27).blu, 8));
        elsif(thr4.threshold28 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(28).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(28).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(28).blu, 8));
        elsif(thr4.threshold29 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(29).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(29).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(29).blu, 8));
        elsif(thr4.threshold30 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(30).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(30).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(30).blu, 8));
        elsif(thr4.threshold31 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(31).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(31).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(31).blu, 8));
        elsif(thr4.threshold32 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(32).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(32).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(32).blu, 8));
        elsif(thr4.threshold33 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(33).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(33).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(33).blu, 8));
        elsif(thr4.threshold34 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(34).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(34).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(34).blu, 8));
        elsif(thr4.threshold35 = threshold_lms) then
            rgb_red     <= std_logic_vector(to_unsigned(k26rgb(35).red, 8));
            rgb_gre   <= std_logic_vector(to_unsigned(k26rgb(35).gre, 8));
            rgb_blu    <= std_logic_vector(to_unsigned(k26rgb(35).blu, 8));
        else
            rgb_red     <= std_logic_vector(to_unsigned(255, 8));
            rgb_gre     <= std_logic_vector(to_unsigned(255, 8));
            rgb_blu     <= std_logic_vector(to_unsigned(255, 8));
        end if;
    end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
       oRgb.red    <= rgb_red & "00";
       oRgb.green  <= rgb_gre & "00";
       oRgb.blue   <= rgb_blu & "00";
    end if;
end process;
oRgb.valid <= rgbSyncValid(29);
oRgb.eol   <= rgbSyncEol(29);
oRgb.sof   <= rgbSyncSof(29);
oRgb.eof   <= rgbSyncEof(29);
end architecture;