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
entity color_k2_clustering is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    color_channel  : in integer;
    K_VALUE        : in integer;
    oRgb           : out channel);
end entity;
architecture arch of color_k2_clustering is
    signal rgbSyncEol    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncSof    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncEof    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncValid  : std_logic_vector(31 downto 0) := x"00000000";
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --constant    color01_red     : integer :=     255;  constant    color01_green    : integer :=      200;  constant    color01_blue    : integer :=     240;    -- RED-PINK
    --constant    color02_red     : integer :=     255;  constant    color02_green    : integer :=      180;  constant    color02_blue    : integer :=     160;    -- RED-ORANGE
    --constant    color03_red     : integer :=     255;  constant    color03_green    : integer :=      160;  constant    color03_blue    : integer :=     170;    -- RED-PINK
    --constant    color04_red     : integer :=     240;  constant    color04_green    : integer :=      210;  constant    color04_blue    : integer :=     120;    -- RED-L-ORANGE
    --constant    color05_red     : integer :=     230;  constant    color05_green    : integer :=      200;  constant    color05_blue    : integer :=     120;    -- RED-L-YELLOW
    --constant    color06_red     : integer :=     220;  constant    color06_green    : integer :=      180;  constant    color06_blue    : integer :=     150;    -- RED-BROWN
    --constant    color07_red     : integer :=     210;  constant    color07_green    : integer :=      150;  constant    color07_blue    : integer :=     100;    -- RED-ORANGE
    --constant    color08_red     : integer :=     200;  constant    color08_green    : integer :=      100;  constant    color08_blue    : integer :=      50;    -- RED-DARK-PINK
    --constant    color09_red     : integer :=     180;  constant    color09_green    : integer :=      100;  constant    color09_blue    : integer :=      30;    -- RED
    --constant    color10_red     : integer :=     255;  constant    color10_green    : integer :=      200;  constant    color10_blue    : integer :=     110;    -- RED
    --constant    color11_red     : integer :=     255;  constant    color11_green    : integer :=      128;  constant    color11_blue    : integer :=     110;    -- RED
    --constant    color12_red     : integer :=     240;  constant    color12_green    : integer :=      200;  constant    color12_blue    : integer :=     100;    -- RED
    --constant    color13_red     : integer :=     240;  constant    color13_green    : integer :=      120;  constant    color13_blue    : integer :=     100;    -- RED
    --constant    color14_red     : integer :=     220;  constant    color14_green    : integer :=      170;  constant    color14_blue    : integer :=      90;    -- RED
    --constant    color15_red     : integer :=     220;  constant    color15_green    : integer :=      110;  constant    color15_blue    : integer :=      90;    -- RED
    --constant    color16_red     : integer :=     200;  constant    color16_green    : integer :=      150;  constant    color16_blue    : integer :=      80;    -- RED
    --constant    color17_red     : integer :=     200;  constant    color17_green    : integer :=      100;  constant    color17_blue    : integer :=      80;    -- RED
    --constant    color18_red     : integer :=     180;  constant    color18_green    : integer :=      140;  constant    color18_blue    : integer :=      70;    -- RED
    --constant    color19_red     : integer :=     180;  constant    color19_green    : integer :=       90;  constant    color19_blue    : integer :=      70;    -- RED
    --constant    color20_red     : integer :=     160;  constant    color20_green    : integer :=      120;  constant    color20_blue    : integer :=      60;    -- RED

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --constant    color36_red     : integer :=     230;  constant    color36_green    : integer :=      255;  constant    color36_blue     : integer :=     200;   -- GREEEN
    --constant    color37_red     : integer :=     200;  constant    color37_green    : integer :=      255;  constant    color37_blue     : integer :=     230;   -- GREEEN
    --constant    color38_red     : integer :=     200;  constant    color38_green    : integer :=      224;  constant    color38_blue     : integer :=     190;   -- GREEEN
    --constant    color39_red     : integer :=     190;  constant    color39_green    : integer :=      224;  constant    color39_blue     : integer :=     200;   -- GREEEN
    --constant    color40_red     : integer :=     150;  constant    color40_green    : integer :=      200;  constant    color40_blue     : integer :=     130;   -- GREEEN
    --constant    color41_red     : integer :=     130;  constant    color41_green    : integer :=      200;  constant    color41_blue     : integer :=     150;   -- GREEEN
    --constant    color42_red     : integer :=     120;  constant    color42_green    : integer :=      150;  constant    color42_blue     : integer :=     100;   -- GREEEN
    --constant    color43_red     : integer :=     100;  constant    color43_green    : integer :=      150;  constant    color43_blue     : integer :=     120;   -- GREEEN
    --constant    color44_red     : integer :=      80;  constant    color44_green    : integer :=      100;  constant    color44_blue     : integer :=      40;   -- GREEEN
    --constant    color45_red     : integer :=      40;  constant    color45_green    : integer :=      100;  constant    color45_blue     : integer :=      80;   -- GREEEN
    --constant    color46_red     : integer :=      50;  constant    color46_green    : integer :=       75;  constant    color46_blue     : integer :=      30;   -- GREEEN
    --constant    color47_red     : integer :=      30;  constant    color47_green    : integer :=       75;  constant    color47_blue     : integer :=      50;   -- GREEEN
    --constant    color48_red     : integer :=      40;  constant    color48_green    : integer :=       50;  constant    color48_blue     : integer :=      20;   -- GREEEN
    --constant    color49_red     : integer :=      20;  constant    color49_green    : integer :=       50;  constant    color49_blue     : integer :=      40;   -- GREEEN
    --constant    color50_red     : integer :=      10;  constant    color50_green    : integer :=       25;  constant    color50_blue     : integer :=      20;   -- GREEEN
    --constant    color51_red     : integer :=      20;  constant    color51_green    : integer :=       25;  constant    color51_blue     : integer :=      10;   -- GREEEN
    --constant    color52_red     : integer :=      15;  constant    color52_green    : integer :=       10;  constant    color52_blue     : integer :=       0;   -- GREEEN
    --constant    color53_red     : integer :=       0;   constant   color53_green    : integer :=       10;  constant    color53_blue     : integer :=       5;   -- GREEEN

    constant    color21_red     : integer := 160;      constant  color21_green   : integer :=  80;          constant    color21_blue    : integer :=      60;    -- RED
    constant    color22_red     : integer := 140;      constant  color22_green   : integer := 100;          constant    color22_blue    : integer :=      50;    -- RED
    constant    color23_red     : integer := 140;      constant  color23_green   : integer :=  70;          constant    color23_blue    : integer :=      50;    -- RED
    constant    color24_red     : integer := 120;      constant  color24_green   : integer :=  80;          constant    color24_blue    : integer :=      30;    -- RED
    constant    color25_red     : integer := 120;      constant  color25_green   : integer :=  60;          constant    color25_blue    : integer :=      30;    -- RED
    constant    color26_red     : integer := 100;      constant  color26_green   : integer :=  75;          constant    color26_blue    : integer :=      25;    -- RED
    constant    color27_red     : integer := 100;      constant  color27_green   : integer :=  50;          constant    color27_blue    : integer :=      25;    -- RED
    constant    color28_red     : integer :=  80;      constant  color28_green   : integer :=  60;          constant    color28_blue    : integer :=      30;    -- RED
    constant    color29_red     : integer :=  80;      constant  color29_green   : integer :=  40;          constant    color29_blue    : integer :=      30;    -- RED
    constant    color30_red     : integer :=  60;      constant  color30_green   : integer :=  40;          constant    color30_blue    : integer :=      15;    -- RED
    constant    color31_red     : integer :=  60;      constant  color31_green   : integer :=  30;          constant    color31_blue    : integer :=      15;    -- RED
    constant    color32_red     : integer :=  30;      constant  color32_green   : integer :=  20;          constant    color32_blue    : integer :=      10;    -- RED
    constant    color33_red     : integer :=  30;      constant  color33_green   : integer :=  15;          constant    color33_blue    : integer :=      10;    -- RED
    constant    color34_red     : integer :=  20;      constant  color34_green   : integer :=  10;          constant    color34_blue    : integer :=       5;    -- RED
    constant    color35_red     : integer :=  10;      constant  color35_green   : integer :=   5;          constant    color35_blue    : integer :=       5;    -- RED

    constant    color54_red     : integer :=  126;     constant  color54_green   : integer :=  47;          constant  color54_blue      : integer := 53;
    constant    color55_red     : integer :=  61;      constant  color55_green   : integer :=  31;          constant  color55_blue      : integer := 20;
    constant    color56_red     : integer :=  20;      constant  color56_green   : integer :=  15;          constant  color56_blue      : integer := 15;
    constant    color57_red     : integer :=  30;      constant  color57_green   : integer :=  15;          constant  color57_blue      : integer := 15;
    constant    color58_red     : integer :=  40;      constant  color58_green   : integer :=  15;          constant  color58_blue      : integer := 15;
    constant    color59_red     : integer :=  50;      constant  color59_green   : integer :=  25;          constant  color59_blue      : integer := 25;
    constant    color60_red     : integer :=  60;      constant  color60_green   : integer :=  35;          constant  color60_blue      : integer := 35;
    
    constant    color74_red     : integer :=  65;      constant  color74_green   : integer :=  90;          constant  color74_blue      : integer :=  65;
    constant    color75_red     : integer :=  75;      constant  color75_green   : integer := 100;          constant  color75_blue      : integer :=  75;
    constant    color76_red     : integer :=  85;      constant  color76_green   : integer := 110;          constant  color76_blue      : integer :=  85;
    constant    color77_red     : integer :=  95;      constant  color77_green   : integer := 120;          constant  color77_blue      : integer :=  95;
    constant    color78_red     : integer :=  15;      constant  color78_green   : integer :=  15;          constant  color78_blue      : integer :=  20;
    constant    color79_red     : integer :=  15;      constant  color79_green   : integer :=  15;          constant  color79_blue      : integer :=  30;
    constant    color80_red     : integer :=  15;      constant  color80_green   : integer :=  15;          constant  color80_blue      : integer :=  40;
    constant    color81_red     : integer :=  25;      constant  color81_green   : integer :=  25;          constant  color81_blue      : integer :=  50;
    constant    color82_red     : integer :=  35;      constant  color82_green   : integer :=  35;          constant  color82_blue      : integer :=  60;
    constant    color83_red     : integer :=  45;      constant  color83_green   : integer :=  45;          constant  color83_blue      : integer :=  70;
    constant    color84_red     : integer :=  55;      constant  color84_green   : integer :=  55;          constant  color84_blue      : integer :=  80;
    constant    color85_red     : integer :=  65;      constant  color85_green   : integer :=  65;          constant  color85_blue      : integer :=  90;
    constant    color86_red     : integer :=  75;      constant  color86_green   : integer :=  75;          constant  color86_blue      : integer := 100;
    constant    color87_red     : integer :=  85;      constant  color87_green   : integer :=  85;          constant  color87_blue      : integer := 110;
    constant    color88_red     : integer :=  95;      constant  color88_green   : integer :=  95;          constant  color88_blue      : integer := 120;
    constant    color89_red     : integer := 100;      constant  color89_green   : integer := 100;          constant  color89_blue      : integer :=  80;
    constant    color90_red     : integer :=  70;      constant  color90_green   : integer :=  90;          constant  color90_blue      : integer :=  90;
    constant    color91_red     : integer :=   7;      constant  color91_green   : integer :=   6;          constant  color91_blue      : integer :=  70;
    constant    color92_red     : integer :=  40;      constant  color92_green   : integer :=  60;          constant  color92_blue      : integer :=  80;
    constant    color93_red     : integer := 100;      constant  color93_green   : integer := 100;          constant  color93_blue      : integer :=  70;
    constant    color94_red     : integer := 130;      constant  color94_green   : integer :=  85;          constant  color94_blue      : integer :=  27;
    constant    color95_red     : integer :=   6;      constant  color95_green   : integer :=  83;          constant  color95_blue      : integer := 155;
    constant    color96_red     : integer :=  30;      constant  color96_green   : integer :=  50;          constant  color96_blue      : integer :=  60;
    constant    color97_red     : integer :=  90;      constant  color97_green   : integer :=  90;          constant  color97_blue      : integer :=  70;
    constant    color98_red     : integer :=   2;      constant  color98_green   : integer :=  60;          constant  color98_blue      : integer := 137;
    constant    color99_red     : integer :=  50;      constant  color99_green   : integer :=  80;          constant  color99_blue      : integer :=  70;
    constant    color100red     : integer :=  40;      constant  color100green   : integer :=  40;          constant  color100blue      : integer :=  30;
    
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --constant    color61_red     : integer :=     220;  constant    color61_green    : integer :=      240;  constant    color61_blue    : integer :=     255;   -- BLUE
    --constant    color62_red     : integer :=     150;  constant    color62_green    : integer :=      220;  constant    color62_blue    : integer :=     240;   -- BLUE
    --constant    color63_red     : integer :=     100;  constant    color63_green    : integer :=      200;  constant    color63_blue    : integer :=     220;   -- BLUE
    --constant    color64_red     : integer :=     90;   constant    color64_green    : integer :=      180;  constant    color64_blue    : integer :=     200;   -- BLUE
    --constant    color65_red     : integer :=     75;   constant    color65_green    : integer :=      150;  constant    color65_blue    : integer :=     180;   -- BLUE
    --constant    color66_red     : integer :=     50;   constant    color66_green    : integer :=      100;  constant    color66_blue    : integer :=     160;   -- BLUE
    --constant    color67_red     : integer :=     50;   constant    color67_green    : integer :=       80;  constant    color67_blue    : integer :=     140;   -- BLUE
    --constant    color68_red     : integer :=     50;   constant    color68_green    : integer :=       75;  constant    color68_blue    : integer :=     120;   -- BLUE
    --constant    color69_red     : integer :=     25;   constant    color69_green    : integer :=       50;  constant    color69_blue    : integer :=     100;   -- BLUE
    --constant    color70_red     : integer :=     20;   constant    color70_green    : integer :=       40;  constant    color70_blue    : integer :=      80;   -- BLUE
    --constant    color71_red     : integer :=     15;   constant    color71_green    : integer :=       30;  constant    color71_blue    : integer :=      60;   -- BLUE
    --constant    color72_red     : integer :=      5;   constant    color72_green    : integer :=       10;  constant    color72_blue    : integer :=      20;   -- BLUE
    --constant    color73_red     : integer :=      0;   constant    color73_green    : integer :=        5;  constant    color73_blue    : integer :=      10;   -- BLUE

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --             RED                                                GREEEN                                              BLUE
    constant    color01_red     : integer :=     255;  constant    color01_green    : integer :=      250;  constant    color01_blue     : integer :=     240;   -- RED
    constant    color02_red     : integer :=     230;  constant    color02_green    : integer :=      200;  constant    color02_blue     : integer :=     150;   -- RED
    constant    color03_red     : integer :=     220;  constant    color03_green    : integer :=      190;  constant    color03_blue     : integer :=     140;   -- RED
    constant    color04_red     : integer :=     240;  constant    color04_green    : integer :=      180;  constant    color04_blue     : integer :=     120;   -- RED
    constant    color05_red     : integer :=     230;  constant    color05_green    : integer :=      170;  constant    color05_blue     : integer :=     120;   -- RED
    constant    color06_red     : integer :=     220;  constant    color06_green    : integer :=      160;  constant    color06_blue     : integer :=     150;   -- RED
    constant    color07_red     : integer :=     210;  constant    color07_green    : integer :=      160;  constant    color07_blue     : integer :=     130;   -- RED
    constant    color08_red     : integer :=     200;  constant    color08_green    : integer :=      160;  constant    color08_blue     : integer :=     100;   -- RED
    constant    color09_red     : integer :=     180;  constant    color09_green    : integer :=      120;  constant    color09_blue     : integer :=     80;    -- RED
    constant    color10_red     : integer :=     160;  constant    color10_green    : integer :=      100;  constant    color10_blue     : integer :=     70;    -- RED
    constant    color11_red     : integer :=     150;  constant    color11_green    : integer :=      80;   constant    color11_blue     : integer :=     60;    -- RED
    constant    color12_red     : integer :=     140;  constant    color12_green    : integer :=      80;   constant    color12_blue     : integer :=     60;    -- RED
    constant    color13_red     : integer :=     120;  constant    color13_green    : integer :=      80;   constant    color13_blue     : integer :=     55;    -- RED
    constant    color14_red     : integer :=     100;  constant    color14_green    : integer :=      80;   constant    color14_blue     : integer :=     50;    -- RED
    constant    color15_red     : integer :=     80;   constant    color15_green    : integer :=      60;   constant    color15_blue     : integer :=     40;    -- RED
    constant    color16_red     : integer :=     70;   constant    color16_green    : integer :=      40;   constant    color16_blue     : integer :=     35;    -- RED
    constant    color17_red     : integer :=     60;   constant    color17_green    : integer :=      40;   constant    color17_blue     : integer :=     30;    -- RED
    constant    color18_red     : integer :=     50;   constant    color18_green    : integer :=      30;   constant    color18_blue     : integer :=     20;    -- RED
    constant    color19_red     : integer :=     40;   constant    color19_green    : integer :=      20;   constant    color19_blue     : integer :=     15;    -- RED
    constant    color20_red     : integer :=     25;   constant    color20_green    : integer :=      15;   constant    color20_blue     : integer :=     10;    -- RED
    
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
    constant    color36_red     : integer :=     255;  constant    color36_green    : integer :=      255;  constant    color36_blue     : integer :=     200;   -- GREEEN
    constant    color37_red     : integer :=     200;  constant    color37_green    : integer :=      255;  constant    color37_blue     : integer :=     230;   -- GREEEN
    constant    color38_red     : integer :=     200;  constant    color38_green    : integer :=      224;  constant    color38_blue     : integer :=     190;   -- GREEEN
    constant    color39_red     : integer :=     190;  constant    color39_green    : integer :=      224;  constant    color39_blue     : integer :=     200;   -- GREEEN
    constant    color40_red     : integer :=     150;  constant    color40_green    : integer :=      200;  constant    color40_blue     : integer :=     130;   -- GREEEN
    constant    color41_red     : integer :=     130;  constant    color41_green    : integer :=      200;  constant    color41_blue     : integer :=     150;   -- GREEEN
    constant    color42_red     : integer :=     150;  constant    color42_green    : integer :=      180;  constant    color42_blue     : integer :=     120;   -- GREEEN
    constant    color43_red     : integer :=     120;  constant    color43_green    : integer :=      180;  constant    color43_blue     : integer :=     150;   -- GREEEN
    constant    color44_red     : integer :=     120;  constant    color44_green    : integer :=      150;  constant    color44_blue     : integer :=     100;   -- GREEEN
    constant    color45_red     : integer :=     100;  constant    color45_green    : integer :=      150;  constant    color45_blue     : integer :=     120;   -- GREEEN
    constant    color46_red     : integer :=      50;  constant    color46_green    : integer :=      100;  constant    color46_blue     : integer :=      30;   -- GREEEN
    constant    color47_red     : integer :=      30;  constant    color47_green    : integer :=      100;  constant    color47_blue     : integer :=      50;   -- GREEEN
    constant    color48_red     : integer :=      50;  constant    color48_green    : integer :=       75;  constant    color48_blue     : integer :=      30;   -- GREEEN
    constant    color49_red     : integer :=      30;  constant    color49_green    : integer :=       75;  constant    color49_blue     : integer :=      50;   -- GREEEN
    constant    color50_red     : integer :=      40;  constant    color50_green    : integer :=       50;  constant    color50_blue     : integer :=      20;   -- GREEEN
    constant    color51_red     : integer :=      20;  constant    color51_green    : integer :=       50;  constant    color51_blue     : integer :=      40;   -- GREEEN
    constant    color52_red     : integer :=      30;  constant    color52_green    : integer :=       40;  constant    color52_blue     : integer :=      30;   -- GREEEN
    constant    color53_red     : integer :=      25;  constant   color53_green     : integer :=       30;  constant    color53_blue     : integer :=      20;   -- GREEEN
    
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
    constant    color61_red     : integer :=     220;  constant    color61_green    : integer :=      240;  constant    color61_blue    : integer :=     255;   -- BLUE
    constant    color62_red     : integer :=     200;  constant    color62_green    : integer :=      220;  constant    color62_blue    : integer :=     240;   -- BLUE
    constant    color63_red     : integer :=     150;  constant    color63_green    : integer :=      200;  constant    color63_blue    : integer :=     220;   -- BLUE
    constant    color64_red     : integer :=     100;   constant    color64_green   : integer :=      180;  constant    color64_blue    : integer :=     230;   -- BLUE
    constant    color65_red     : integer :=     80;   constant    color65_green    : integer :=      150;  constant    color65_blue    : integer :=     200;   -- BLUE
    constant    color66_red     : integer :=     60;   constant    color66_green    : integer :=      100;  constant    color66_blue    : integer :=     190;   -- BLUE
    constant    color67_red     : integer :=     60;   constant    color67_green    : integer :=       90;  constant    color67_blue    : integer :=     180;   -- BLUE
    constant    color68_red     : integer :=     45;   constant    color68_green    : integer :=       75;  constant    color68_blue    : integer :=     150;   -- BLUE
    constant    color69_red     : integer :=     45;   constant    color69_green    : integer :=       70;  constant    color69_blue    : integer :=     130;   -- BLUE
    constant    color70_red     : integer :=     45;   constant    color70_green    : integer :=       70;  constant    color70_blue    : integer :=     100;   -- BLUE
    constant    color71_red     : integer :=     30;   constant    color71_green    : integer :=       50;  constant    color71_blue    : integer :=      90;   -- BLUE
    constant    color72_red     : integer :=     30;   constant    color72_green    : integer :=       40;  constant    color72_blue    : integer :=      70;   -- BLUE
    
    constant    color73_red     : integer :=     20;   constant    color73_green    : integer :=       25;  constant    color73_blue    : integer :=      30;   -- BLUE
    
    
type thr_record is record
    threshold1       : integer;
    threshold2       : integer;
    threshold3       : integer;
    threshold4       : integer;
    threshold5       : integer;
    threshold6       : integer;
    threshold7       : integer;
    threshold8       : integer;
    threshold9       : integer;
    threshold10      : integer;
    threshold11      : integer;
    threshold12      : integer;
    threshold13      : integer;
    threshold14      : integer;
    threshold15      : integer;
    threshold16      : integer;
    threshold17      : integer;
    threshold18      : integer;
    threshold19      : integer;
    threshold20      : integer;
    threshold21      : integer;
    threshold22      : integer;
    threshold23      : integer;
    threshold24      : integer;
    threshold25      : integer;
    threshold26      : integer;
    threshold27      : integer;
    threshold28      : integer;
    threshold29      : integer;
    threshold30      : integer;
    threshold31      : integer;
    threshold32      : integer;
    threshold33      : integer;
    threshold34      : integer;
    threshold35      : integer;
    threshold36      : integer;
    threshold37      : integer;
    threshold38      : integer;
    threshold39      : integer;
    threshold40      : integer;
    threshold41      : integer;
    threshold42      : integer;
    threshold43      : integer;
    threshold44      : integer;
    threshold45      : integer;
    threshold46      : integer;
    threshold47      : integer;
    threshold48      : integer;
    threshold49      : integer;
    threshold50      : integer;
    threshold51      : integer;
    threshold52      : integer;
    threshold53      : integer;
    threshold54      : integer;
    threshold55      : integer;
    threshold56      : integer;
    threshold57      : integer;
    threshold58      : integer;
    threshold59      : integer;
    threshold60      : integer;
    threshold61      : integer;
    threshold62      : integer;
    threshold63      : integer;
    threshold64      : integer;
    threshold65      : integer;
    threshold66      : integer;
    threshold67      : integer;
    threshold68      : integer;
    threshold69      : integer;
    threshold70      : integer;
    threshold71      : integer;
    threshold72      : integer;
    threshold73      : integer;
    threshold74      : integer;
    threshold75      : integer;
    threshold76      : integer;
    threshold77      : integer;
    threshold78      : integer;
    threshold79      : integer;
    threshold80      : integer;
    threshold81      : integer;
    threshold82      : integer;
    threshold83      : integer;
    threshold84      : integer;
    threshold85      : integer;
    threshold86      : integer;
    threshold87      : integer;
    threshold88      : integer;
    threshold89      : integer;
    threshold90      : integer;
    threshold91      : integer;
    threshold92      : integer;
    threshold93      : integer;
    threshold94      : integer;
    threshold95      : integer;
    threshold96      : integer;
    threshold97      : integer;
    threshold98      : integer;
    threshold99      : integer;
    threshold100     : integer;
end record;
    
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
    signal threshold_lms22       : integer;
    signal threshold_lms23       : integer;
    signal threshold_lms24       : integer;
    signal threshold_lms25       : integer;
    signal threshold_red1        : integer;
    signal threshold_red2        : integer;
    signal threshold_gre1        : integer;
    signal threshold_gre2        : integer;
    signal threshold_blu1        : integer;
    signal threshold_blu2        : integer;
    signal threshold_lms         : integer;
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
    
    signal rgb_sync1              : intChannel;
    signal rgb_sync2              : intChannel;
    signal rgb_sync3              : intChannel;
    signal rgb_sync4              : intChannel;
    signal rgb_sync5              : intChannel;
    signal rgb_sync6              : intChannel;
    signal rgb_sync7              : intChannel;
    signal rgb_sync8              : intChannel;
    signal rgb_sync9              : intChannel;
    signal rgb_sync10             : intChannel;
    signal rgb_sync11             : intChannel;
    signal rgb_sync12             : intChannel;
    signal rgb_sync13             : intChannel;
    signal rgb_sync14             : intChannel;
    signal rgb_sync15             : intChannel;
    signal rgb_sync16             : intChannel;
    signal rgb_sync17             : intChannel;
    signal rgb_sync18             : intChannel;
    signal rgb_sync19             : intChannel;
    signal rgb_sync20             : intChannel;
    signal rgb_sync21             : intChannel;
    signal rgb_sync22             : intChannel;
    signal rgb_sync23             : intChannel;
    
    signal rgb                   :  channel;
    
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

            rgb.red     <= iRgb.red;
            rgb.green   <= iRgb.blue;
            rgb.blue    <= iRgb.green;
            rgb.valid   <= iRgb.valid;
            rgb.eol     <= iRgb.eol;
            rgb.eof     <= iRgb.eof;
            rgb.sof     <= iRgb.sof;
            
process (clk)begin
    if rising_edge(clk) then
        if(color_channel = 0)then
            rgb_sync1.red    <= to_integer(unsigned(iRgb.red));
            rgb_sync1.green  <= to_integer(unsigned(iRgb.green));
            rgb_sync1.blue   <= to_integer(unsigned(iRgb.blue));
        elsif(color_channel = 1)then
            rgb_sync1.red    <= to_integer(unsigned(iRgb.red));
            rgb_sync1.green  <= to_integer(unsigned(iRgb.blue));
            rgb_sync1.blue   <= to_integer(unsigned(iRgb.green));
        elsif(color_channel = 2)then
            rgb_sync1.red    <= to_integer(unsigned(iRgb.blue));
            rgb_sync1.green  <= to_integer(unsigned(iRgb.green));
            rgb_sync1.blue   <= to_integer(unsigned(iRgb.red));
        elsif(color_channel = 3)then
            rgb_sync1.red    <= to_integer(unsigned(iRgb.green));
            rgb_sync1.green  <= to_integer(unsigned(iRgb.blue));
            rgb_sync1.blue   <= to_integer(unsigned(iRgb.red));
        elsif(color_channel = 4)then
            rgb_sync1.red    <= to_integer(unsigned(iRgb.green));
            rgb_sync1.green  <= to_integer(unsigned(iRgb.red));
            rgb_sync1.blue   <= to_integer(unsigned(iRgb.blue));
        elsif(color_channel = 5)then
            rgb_sync1.red    <= to_integer(unsigned(iRgb.blue));
            rgb_sync1.green  <= to_integer(unsigned(iRgb.red));
            rgb_sync1.blue   <= to_integer(unsigned(iRgb.green));
        else
            rgb_sync1.red    <= to_integer(unsigned(iRgb.blue));
            rgb_sync1.green  <= to_integer(unsigned(iRgb.green));
            rgb_sync1.blue   <= to_integer(unsigned(iRgb.red));
        end if;
        rgb_sync1.valid  <= iRgb.valid;
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




color_k1_clustering_inst: clustering
generic map(
    k_red             => color01_red,
    k_gre             => color01_green,
    k_blu             => color01_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold1);
color_k2_clustering_inst: clustering
generic map(
    k_red             => color02_red,
    k_gre             => color02_green,
    k_blu             => color02_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold2);
color_k3_clustering_inst: clustering
generic map(
    k_red             => color03_red,
    k_gre             => color03_green,
    k_blu             => color03_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold3);
color_k4_clustering_inst: clustering
generic map(
    k_red             => color04_red,
    k_gre             => color04_green,
    k_blu             => color04_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold4);
color_k5_clustering_inst: clustering
generic map(
    k_red             => color05_red,
    k_gre             => color05_green,
    k_blu             => color05_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold5);
color_k6_clustering_inst: clustering
generic map(
    k_red             => color06_red,
    k_gre             => color06_green,
    k_blu             => color06_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold6);
color_k7_clustering_inst: clustering
generic map(
    k_red             => color07_red,
    k_gre             => color07_green,
    k_blu             => color07_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold7);
color_k8_clustering_inst: clustering
generic map(
    k_red             => color08_red,
    k_gre             => color08_green,
    k_blu             => color08_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold8);
color_k9_clustering_inst: clustering
generic map(
    k_red             => color09_red,
    k_gre             => color09_green,
    k_blu             => color09_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold9);
color_k10_clustering_inst: clustering
generic map(
    k_red             => color10_red,
    k_gre             => color10_green,
    k_blu             => color10_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold10);
color_k11_clustering_inst: clustering
generic map(
    k_red             => color11_red,
    k_gre             => color11_green,
    k_blu             => color11_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold11);
color_k12_clustering_inst: clustering
generic map(
    k_red             => color12_red,
    k_gre             => color12_green,
    k_blu             => color12_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold12);
color_k13_clustering_inst: clustering
generic map(
    k_red             => color13_red,
    k_gre             => color13_green,
    k_blu             => color13_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold13);
color_k14_clustering_inst: clustering
generic map(
    k_red             => color14_red,
    k_gre             => color14_green,
    k_blu             => color14_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold14);
color_k15_clustering_inst: clustering
generic map(
    k_red             => color15_red,
    k_gre             => color15_green,
    k_blu             => color15_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold15);
color_k16clustering_inst: clustering
generic map(
    k_red             => color16_red,
    k_gre             => color16_green,
    k_blu             => color16_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold16);
color_k17_clustering_inst: clustering
generic map(
    k_red             => color17_red,
    k_gre             => color17_green,
    k_blu             => color17_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold17);
color_k18_clustering_inst: clustering
generic map(
    k_red             => color18_red,
    k_gre             => color18_green,
    k_blu             => color18_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold18);
color_k19_clustering_inst: clustering
generic map(
    k_red             => color19_red,
    k_gre             => color19_green,
    k_blu             => color19_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold19);
color_k20_clustering_inst: clustering
generic map(
    k_red             => color20_red,
    k_gre             => color20_green,
    k_blu             => color20_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold20);
color_k21_clustering_inst: clustering
generic map(
    k_red             => color21_red,
    k_gre             => color21_green,
    k_blu             => color21_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold21);
color_k22_clustering_inst: clustering
generic map(
    k_red             => color22_red,
    k_gre             => color22_green,
    k_blu             => color22_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold22);
color_k23_clustering_inst: clustering
generic map(
    k_red             => color23_red,
    k_gre             => color23_green,
    k_blu             => color23_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold23);
color_k24_clustering_inst: clustering
generic map(
    k_red             => color24_red,
    k_gre             => color24_green,
    k_blu             => color24_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold24);
color_k25_clustering_inst: clustering
generic map(
    k_red             => color25_red,
    k_gre             => color25_green,
    k_blu             => color25_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold25);
color_k26_clustering_inst: clustering
generic map(
    k_red             => color26_red,
    k_gre             => color26_green,
    k_blu             => color26_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold26);
color_k27_clustering_inst: clustering
generic map(
    k_red             => color27_red,
    k_gre             => color27_green,
    k_blu             => color27_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold27);
color_k28_clustering_inst: clustering
generic map(
    k_red             => color28_red,
    k_gre             => color28_green,
    k_blu             => color28_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold28);
color_k29_clustering_inst: clustering
generic map(
    k_red             => color29_red,
    k_gre             => color29_green,
    k_blu             => color29_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold29);
color_k30_clustering_inst: clustering
generic map(
    k_red             => color30_red,
    k_gre             => color30_green,
    k_blu             => color30_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold30);
color_k31_clustering_inst: clustering
generic map(
    k_red             => color31_red,
    k_gre             => color31_green,
    k_blu             => color31_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold31);
color_k32_clustering_inst: clustering
generic map(
    k_red             => color32_red,
    k_gre             => color32_green,
    k_blu             => color32_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold32);
color_k33_clustering_inst: clustering
generic map(
    k_red             => color33_red,
    k_gre             => color33_green,
    k_blu             => color33_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold33);
color_k34_clustering_inst: clustering
generic map(
    k_red             => color34_red,
    k_gre             => color34_green,
    k_blu             => color34_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold34);
color_k35_clustering_inst: clustering
generic map(
    k_red             => color35_red,
    k_gre             => color35_green,
    k_blu             => color35_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold35);
color_k36_clustering_inst: clustering
generic map(
    k_red             => color36_red,
    k_gre             => color36_green,
    k_blu             => color36_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold36);
color_k37_clustering_inst: clustering
generic map(
    k_red             => color37_red,
    k_gre             => color37_green,
    k_blu             => color37_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold37);
color_k38clustering_inst: clustering
generic map(
    k_red             => color38_red,
    k_gre             => color38_green,
    k_blu             => color38_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold38);
color_k39_clustering_inst: clustering
generic map(
    k_red             => color39_red,
    k_gre             => color39_green,
    k_blu             => color39_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold39);
color_k40_clustering_inst: clustering
generic map(
    k_red             => color40_red,
    k_gre             => color40_green,
    k_blu             => color40_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold40);
color_k41_clustering_inst: clustering
generic map(
    k_red             => color41_red,
    k_gre             => color41_green,
    k_blu             => color41_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold41);
color_k42_clustering_inst: clustering
generic map(
    k_red             => color42_red,
    k_gre             => color42_green,
    k_blu             => color42_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold42);
color_k43_clustering_inst: clustering
generic map(
    k_red             => color43_red,
    k_gre             => color43_green,
    k_blu             => color43_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold43);
color_k44_clustering_inst: clustering
generic map(
    k_red             => color44_red,
    k_gre             => color44_green,
    k_blu             => color44_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold44);
color_k45_clustering_inst: clustering
generic map(
    k_red             => color45_red,
    k_gre             => color45_green,
    k_blu             => color45_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold45);
color_k46_clustering_inst: clustering
generic map(
    k_red             => color46_red,
    k_gre             => color46_green,
    k_blu             => color46_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold46);
color_k47_clustering_inst: clustering
generic map(
    k_red             => color47_red,
    k_gre             => color47_green,
    k_blu             => color47_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold47);
color_k48clustering_inst: clustering
generic map(
    k_red             => color48_red,
    k_gre             => color48_green,
    k_blu             => color48_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold48);
color_k49_clustering_inst: clustering
generic map(
    k_red             => color49_red,
    k_gre             => color49_green,
    k_blu             => color49_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold49);
color_k50_clustering_inst: clustering
generic map(
    k_red             => color50_red,
    k_gre             => color50_green,
    k_blu             => color50_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold50);
color_k51_clustering_inst: clustering
generic map(
    k_red             => color51_red,
    k_gre             => color51_green,
    k_blu             => color51_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold51);
color_k52_clustering_inst: clustering
generic map(
    k_red             => color52_red,
    k_gre             => color52_green,
    k_blu             => color52_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold52);
color_k53_clustering_inst: clustering
generic map(
    k_red             => color53_red,
    k_gre             => color53_green,
    k_blu             => color53_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold53);
color_k61_clustering_inst: clustering
generic map(
    k_red             => color61_red,
    k_gre             => color61_green,
    k_blu             => color61_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold61);
color_k62_clustering_inst: clustering
generic map(
    k_red             => color62_red,
    k_gre             => color62_green,
    k_blu             => color62_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold62);
color_k63_clustering_inst: clustering
generic map(
    k_red             => color63_red,
    k_gre             => color63_green,
    k_blu             => color63_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold63);
color_k64_clustering_inst: clustering
generic map(
    k_red             => color64_red,
    k_gre             => color64_green,
    k_blu             => color64_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold64);
color_k65_clustering_inst: clustering
generic map(
    k_red             => color65_red,
    k_gre             => color65_green,
    k_blu             => color65_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold65);
color_k66_clustering_inst: clustering
generic map(
    k_red             => color66_red,
    k_gre             => color66_green,
    k_blu             => color66_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold66);
color_k67_clustering_inst: clustering
generic map(
    k_red             => color67_red,
    k_gre             => color67_green,
    k_blu             => color67_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold67);
color_k68clustering_inst: clustering
generic map(
    k_red             => color68_red,
    k_gre             => color68_green,
    k_blu             => color68_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold68);
color_k69_clustering_inst: clustering
generic map(
    k_red             => color69_red,
    k_gre             => color69_green,
    k_blu             => color69_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold69);
color_k70_clustering_inst: clustering
generic map(
    k_red             => color70_red,
    k_gre             => color70_green,
    k_blu             => color70_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold70);
color_k71_clustering_inst: clustering
generic map(
    k_red             => color71_red,
    k_gre             => color71_green,
    k_blu             => color71_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold71);
color_k72_clustering_inst: clustering
generic map(
    k_red             => color72_red,
    k_gre             => color72_green,
    k_blu             => color72_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold72);
color_k73_clustering_inst: clustering
generic map(
    k_red             => color73_red,
    k_gre             => color73_green,
    k_blu             => color73_blue,
    data_width        => i_data_width)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    threshold          => thr1.threshold73);


process (clk) begin
    if rising_edge(clk) then
    if(K_VALUE = 0) then
      -- RED
      threshold_lms_1  <= int_min_val(thr1.threshold1,thr1.threshold2,thr1.threshold3,thr1.threshold4,thr1.threshold5);
      threshold_lms_2  <= int_min_val(thr1.threshold6,thr1.threshold7,thr1.threshold8,thr1.threshold9,thr1.threshold10);
      threshold_lms_3  <= int_min_val(thr1.threshold11,thr1.threshold12,thr1.threshold13,thr1.threshold14,thr1.threshold15);
      threshold_lms_4  <= int_min_val(thr1.threshold16,thr1.threshold17,thr1.threshold18,thr1.threshold19,thr1.threshold20);
      -- GREEN
      threshold_lms_8  <= int_min_val(thr1.threshold36,thr1.threshold37,thr1.threshold38,thr1.threshold39,thr1.threshold40);
      threshold_lms_9  <= int_min_val(thr1.threshold41,thr1.threshold42,thr1.threshold43,thr1.threshold44,thr1.threshold45);
      threshold_lms10  <= int_min_val(thr1.threshold46,thr1.threshold47,thr1.threshold48,thr1.threshold49,thr1.threshold50);
      threshold_lms11  <= int_min_val(thr1.threshold51,thr1.threshold52,thr1.threshold53);
      -- BLUE
      threshold_lms13  <= int_min_val(thr1.threshold61,thr1.threshold62,thr1.threshold63,thr1.threshold64,thr1.threshold65);
      threshold_lms14  <= int_min_val(thr1.threshold66,thr1.threshold67,thr1.threshold68,thr1.threshold69,thr1.threshold70);
      threshold_lms15  <= int_min_val(thr1.threshold71,thr1.threshold72,thr1.threshold73);
    elsif(K_VALUE = 1)then
      -- RED
      threshold_lms_1  <= thr1.threshold1;
      threshold_lms_4  <= thr1.threshold20;
      -- GREEN
      threshold_lms_8  <= thr1.threshold36;
      threshold_lms11  <= thr1.threshold53;
      -- BLUE
      threshold_lms13  <= thr1.threshold61;
      threshold_lms15  <= thr1.threshold73;
    elsif(K_VALUE = 2)then
      -- RED
      threshold_lms_1  <= thr1.threshold5;
      threshold_lms_4  <= thr1.threshold16;
      -- GREEN
      threshold_lms_8  <= thr1.threshold40;
      threshold_lms11  <= thr1.threshold51;
      -- BLUE
      threshold_lms13  <= thr1.threshold65;
      threshold_lms15  <= thr1.threshold71;
    elsif(K_VALUE = 3)then
      -- RED
      threshold_lms_1  <= thr1.threshold6;
      threshold_lms_4  <= thr1.threshold15;
      -- GREEN
      threshold_lms_8  <= thr1.threshold41;
      threshold_lms11  <= thr1.threshold50;
      -- BLUE
      threshold_lms13  <= thr1.threshold66;
      threshold_lms15  <= thr1.threshold70;
    elsif(K_VALUE = 4)then
      -- RED
      threshold_lms_1  <= thr1.threshold7;
      threshold_lms_4  <= thr1.threshold14;
      -- GREEN
      threshold_lms_8  <= thr1.threshold42;
      threshold_lms11  <= thr1.threshold49;
      -- BLUE
      threshold_lms13  <= thr1.threshold67;
      threshold_lms15  <= thr1.threshold69;
    elsif(K_VALUE = 5)then
      -- RED
      threshold_lms_1  <= thr1.threshold6;
      threshold_lms_2  <= thr1.threshold9;
      threshold_lms_4  <= thr1.threshold14;
      -- GREEN
      threshold_lms_8  <= thr1.threshold41;
      threshold_lms_9  <= thr1.threshold45;
      threshold_lms11  <= thr1.threshold49;
      -- BLUE
      threshold_lms13  <= thr1.threshold66;
      threshold_lms14  <= thr1.threshold67;
      threshold_lms15  <= thr1.threshold69;
    elsif(K_VALUE = 9)then
      -- RED
      threshold_lms_1  <= int_min_val(thr1.threshold1,thr1.threshold3,thr1.threshold5,thr1.threshold6);
      threshold_lms_2  <= int_min_val(thr1.threshold7,thr1.threshold8,thr1.threshold9,thr1.threshold16);
      -- GREEN
      threshold_lms_8  <= int_min_val(thr1.threshold36,thr1.threshold37,thr1.threshold38,thr1.threshold39);
      threshold_lms_9  <= int_min_val(thr1.threshold40,thr1.threshold41,thr1.threshold42,thr1.threshold50);
      -- BLUE
      threshold_lms13  <= int_min_val(thr1.threshold62,thr1.threshold63,thr1.threshold65,thr1.threshold66);
      threshold_lms14  <= int_min_val(thr1.threshold67,thr1.threshold68,thr1.threshold69,thr1.threshold73);
    else
      -- RED
      threshold_lms_1  <= int_min_val(thr1.threshold1,thr1.threshold2,thr1.threshold3,thr1.threshold4,thr1.threshold5);
      threshold_lms_2  <= int_min_val(thr1.threshold6,thr1.threshold7,thr1.threshold8,thr1.threshold9,thr1.threshold10);
      threshold_lms_3  <= int_min_val(thr1.threshold11,thr1.threshold12,thr1.threshold13,thr1.threshold14,thr1.threshold15);
      threshold_lms_4  <= int_min_val(thr1.threshold16,thr1.threshold17,thr1.threshold18,thr1.threshold19,thr1.threshold20);
      threshold_lms_5  <= int_min_val(thr1.threshold21,thr1.threshold22,thr1.threshold23,thr1.threshold24,thr1.threshold25);
      threshold_lms_6  <= int_min_val(thr1.threshold26,thr1.threshold27,thr1.threshold28,thr1.threshold29,thr1.threshold30);
      threshold_lms_7  <= int_min_val(thr1.threshold31,thr1.threshold32,thr1.threshold33,thr1.threshold34,thr1.threshold35);
      -- GREEN
      threshold_lms_8  <= int_min_val(thr1.threshold36,thr1.threshold37,thr1.threshold38,thr1.threshold39,thr1.threshold40);
      threshold_lms_9  <= int_min_val(thr1.threshold41,thr1.threshold42,thr1.threshold43,thr1.threshold44,thr1.threshold45);
      threshold_lms10  <= int_min_val(thr1.threshold46,thr1.threshold47,thr1.threshold48,thr1.threshold49,thr1.threshold50);
      threshold_lms11  <= int_min_val(thr1.threshold51,thr1.threshold52,thr1.threshold53);
      -- BLUE
      threshold_lms13  <= int_min_val(thr1.threshold61,thr1.threshold62,thr1.threshold63,thr1.threshold64,thr1.threshold65);
      threshold_lms14  <= int_min_val(thr1.threshold66,thr1.threshold67,thr1.threshold68,thr1.threshold69,thr1.threshold70);
      threshold_lms15  <= int_min_val(thr1.threshold71,thr1.threshold72,thr1.threshold73);
      --MAGENTA AND YELLOW AND WHITE AND BLACK
      threshold_lms19  <= int_min_val(thr1.threshold91,thr1.threshold92,thr1.threshold93,thr1.threshold94,thr1.threshold95);
      threshold_lms20  <= int_min_val(thr1.threshold96,thr1.threshold97,thr1.threshold98,thr1.threshold99,thr1.threshold100);
    end if; 
    end if; 
end process;



--process (clk) begin
--    if rising_edge(clk) then
--      threshold_red1  <= int_min_val(threshold_lms_1,threshold_lms_2,threshold_lms_3,threshold_lms_4,threshold_lms_5);
--      threshold_red2  <= int_min_val(threshold_lms_6,threshold_lms_7);
--      threshold_gre1  <= int_min_val(threshold_lms_8,threshold_lms_9);
--      threshold_gre2  <= int_min_val(threshold_lms10,threshold_lms11);
--      threshold_blu1  <= int_min_val(threshold_lms13,threshold_lms14,threshold_lms15);
--    end if;
--end process;


process (clk) begin
    if rising_edge(clk) then
        if(K_VALUE = 0) then
        --------------------------------------------------------------------
        -- 51 Colors Schemes
        --------------------------------------------------------------------
          threshold_red1  <= int_min_val(threshold_lms_1,threshold_lms_2);
          threshold_red2  <= int_min_val(threshold_lms_3,threshold_lms_4);
          threshold_gre1  <= int_min_val(threshold_lms_8,threshold_lms_9);
          threshold_gre2  <= int_min_val(threshold_lms10,threshold_lms11);
          threshold_blu1  <= int_min_val(threshold_lms13,threshold_lms14,threshold_lms15);
        elsif(K_VALUE = 1 or K_VALUE = 2 or K_VALUE = 3 or K_VALUE = 4)then
        --------------------------------------------------------------------
        -- 6 Colors Schemes
        --------------------------------------------------------------------
          threshold_red1  <= int_min_val(threshold_lms_1,threshold_lms_4);
          threshold_gre1  <= int_min_val(threshold_lms_8,threshold_lms11);
          threshold_blu1  <= int_min_val(threshold_lms13,threshold_lms15);
        elsif(K_VALUE = 5)then
        --------------------------------------------------------------------
        -- 9 Colors Schemes
        --------------------------------------------------------------------
          threshold_red1  <= int_min_val(threshold_lms_1,threshold_lms_2,threshold_lms_4);
          threshold_gre1  <= int_min_val(threshold_lms_8,threshold_lms_9,threshold_lms11);
          threshold_blu1  <= int_min_val(threshold_lms13,threshold_lms14,threshold_lms15);
        elsif(K_VALUE = 6)then
        --------------------------------------------------------------------
        -- 12 Colors Schemes
        --------------------------------------------------------------------
          threshold_red1  <= int_min_val(threshold_lms_1,threshold_lms_2,threshold_lms_4);
          threshold_gre1  <= int_min_val(threshold_lms_8,threshold_lms_9,threshold_lms11);
          threshold_blu1  <= int_min_val(threshold_lms13,threshold_lms14,threshold_lms15);
        elsif(K_VALUE = 7)then
        --------------------------------------------------------------------
        -- 15 Colors Schemes
        --------------------------------------------------------------------
          threshold_red1  <= int_min_val(threshold_lms_1,threshold_lms_2,threshold_lms_4);
          threshold_gre1  <= int_min_val(threshold_lms_8,threshold_lms_9,threshold_lms11);
          threshold_blu1  <= int_min_val(threshold_lms13,threshold_lms14,threshold_lms15);
        elsif(K_VALUE = 8)then
        --------------------------------------------------------------------
        -- 18 Colors Schemes
        --------------------------------------------------------------------
          threshold_red1  <= int_min_val(threshold_lms_1,threshold_lms_2,threshold_lms_4);
          threshold_gre1  <= int_min_val(threshold_lms_8,threshold_lms_9,threshold_lms11);
          threshold_blu1  <= int_min_val(threshold_lms13,threshold_lms14,threshold_lms15);
        elsif(K_VALUE = 9)then
        --------------------------------------------------------------------
        -- 24 Colors Schemes
        --------------------------------------------------------------------
          threshold_red1  <= int_min_val(threshold_lms_1,threshold_lms_2);
          threshold_gre1  <= int_min_val(threshold_lms_8,threshold_lms_9);
          threshold_blu1  <= int_min_val(threshold_lms13,threshold_lms14);
        else
          threshold_red1   <= int_min_val(threshold_lms_1,threshold_lms_2,threshold_lms_3,threshold_lms_4,threshold_lms_5);
          threshold_red2   <= int_min_val(threshold_lms_6,threshold_lms_7);
          threshold_gre1   <= int_min_val(threshold_lms_8,threshold_lms_9);
          threshold_gre2   <= int_min_val(threshold_lms10,threshold_lms11);
          threshold_blu1   <= int_min_val(threshold_lms13,threshold_lms14,threshold_lms15);
          threshold_lms24  <= int_min_val(threshold_lms19,threshold_lms20);--BLUE AND MAGENTA AND YELLOW AND WHITE AND BLACK
        end if;
    end if;
end process;


process (clk) begin
    if rising_edge(clk) then
    if(K_VALUE = 0) then
        if ((rgb_sync22.red >= rgb_sync22.green) and (rgb_sync22.red >= rgb_sync22.blue)) then
            threshold_lms    <= int_min_val(threshold_red1,threshold_red2);
        elsif ((rgb_sync22.green >= rgb_sync22.red) and (rgb_sync22.green >= rgb_sync22.blue)) then
            threshold_lms    <= int_min_val(threshold_gre1,threshold_gre2);
        elsif ((rgb_sync22.blue >= rgb_sync22.red) and (rgb_sync22.blue >= rgb_sync22.green)) then
           threshold_lms    <= int_min_val(threshold_blu1,threshold_blu1);
        else
           threshold_lms    <= int_min_val(threshold_red1,threshold_red2,threshold_gre1,threshold_gre2,threshold_blu1);
        end if;
    elsif(K_VALUE = 1 or K_VALUE = 2 or K_VALUE = 3 or K_VALUE = 4 or K_VALUE = 5 or K_VALUE = 9)then
        if ((rgb_sync22.red >= rgb_sync22.green) and (rgb_sync22.red >= rgb_sync22.blue)) then
            threshold_lms    <= int_min_val(threshold_red1,threshold_red1);
        elsif ((rgb_sync22.green >= rgb_sync22.red) and (rgb_sync22.green >= rgb_sync22.blue)) then
            threshold_lms    <= int_min_val(threshold_gre1,threshold_gre1);
        elsif ((rgb_sync22.blue >= rgb_sync22.red) and (rgb_sync22.blue >= rgb_sync22.green)) then
           threshold_lms    <= int_min_val(threshold_blu1,threshold_blu1);
        else
           threshold_lms    <= int_min_val(threshold_red1,threshold_red1,threshold_gre1,threshold_gre1,threshold_blu1);
        end if;
    else
        if ((rgb_sync22.red >= rgb_sync22.green) and (rgb_sync22.red >= rgb_sync22.blue)) then
            threshold_lms    <= int_min_val(threshold_red1,threshold_red2);
        elsif ((rgb_sync22.green >= rgb_sync22.red) and (rgb_sync22.green >= rgb_sync22.blue)) then
            threshold_lms    <= int_min_val(threshold_gre1,threshold_gre2);
        elsif ((rgb_sync22.blue >= rgb_sync22.red) and (rgb_sync22.blue >= rgb_sync22.green)) then
           threshold_lms    <= int_min_val(threshold_blu1,threshold_blu1);
        else
           threshold_lms    <= threshold_lms24;
        end if;
    end if;
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
    if(K_VALUE = 0) then
        if ((thr4.threshold1  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color01_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color01_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color01_blue, 8)) & "00";
        elsif((thr4.threshold2 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color02_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color02_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color02_blue, 8)) & "00";
        elsif((thr4.threshold3 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color03_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color03_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color03_blue, 8)) & "00";
        elsif((thr4.threshold4 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color04_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color04_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color04_blue, 8)) & "00";
        elsif((thr4.threshold5 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color05_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color05_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color05_blue, 8)) & "00";
        elsif((thr4.threshold6 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color06_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color06_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color06_blue, 8)) & "00";
        elsif((thr4.threshold7 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color07_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color07_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color07_blue, 8)) & "00";
        elsif((thr4.threshold8 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color08_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color08_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color08_blue, 8)) & "00";
        elsif((thr4.threshold9 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color09_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color09_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color09_blue, 8)) & "00";
        elsif((thr4.threshold10 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color10_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color10_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color10_blue, 8)) & "00";
        elsif((thr4.threshold11 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color11_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color11_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color11_blue, 8)) & "00";
        elsif((thr4.threshold12 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color12_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color12_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color12_blue, 8)) & "00";
        elsif((thr4.threshold13 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color13_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color13_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color13_blue, 8)) & "00";
        elsif((thr4.threshold14 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color14_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color14_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color14_blue, 8)) & "00";
        elsif((thr4.threshold15 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color15_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color15_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color15_blue, 8)) & "00";
        elsif((thr4.threshold16 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color16_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color16_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color16_blue, 8)) & "00";
        elsif((thr4.threshold17 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color17_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color17_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color17_blue, 8)) & "00";
        elsif((thr4.threshold18 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color18_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color18_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color18_blue, 8)) & "00";
        elsif((thr4.threshold19 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color19_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color19_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color19_blue, 8)) & "00";
        elsif((thr4.threshold20 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color20_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color20_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color20_blue, 8)) & "00";
        elsif((thr4.threshold21 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color21_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color21_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color21_blue, 8)) & "00";
        elsif((thr4.threshold22 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color22_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color22_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color22_blue, 8)) & "00";
        elsif((thr4.threshold23 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color23_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color23_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color23_blue, 8)) & "00";
        elsif((thr4.threshold24 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color24_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color24_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color24_blue, 8)) & "00";
        elsif((thr4.threshold25 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color25_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color25_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color25_blue, 8)) & "00";
        elsif((thr4.threshold26 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color26_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color26_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color26_blue, 8)) & "00";
        elsif((thr4.threshold27 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color27_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color27_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color27_blue, 8)) & "00";
        elsif((thr4.threshold28 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color28_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color28_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color28_blue, 8)) & "00";
        elsif((thr4.threshold29 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color29_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color29_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color29_blue, 8)) & "00";
        elsif((thr4.threshold30 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color30_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color30_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color30_blue, 8)) & "00";
        elsif((thr4.threshold31 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color31_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color31_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color31_blue, 8)) & "00";
        elsif((thr4.threshold32 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color32_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color32_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color32_blue, 8)) & "00";
        elsif((thr4.threshold33 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color33_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color33_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color33_blue, 8)) & "00";
        elsif((thr4.threshold34 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color34_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color34_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color34_blue, 8)) & "00";
        elsif((thr4.threshold35 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color35_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color35_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color35_blue, 8)) & "00";
        elsif((thr4.threshold36 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color36_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color36_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color36_blue, 8)) & "00";
        elsif((thr4.threshold37 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color37_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color37_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color37_blue, 8)) & "00";
        elsif((thr4.threshold38 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color38_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color38_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color38_blue, 8)) & "00";
        elsif((thr4.threshold39 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color39_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color39_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color39_blue, 8)) & "00";
        elsif((thr4.threshold40 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color40_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color40_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color40_blue, 8)) & "00";
        elsif((thr4.threshold41 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color41_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color41_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color41_blue, 8)) & "00";
        elsif((thr4.threshold42 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color42_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color42_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color42_blue, 8)) & "00";
        elsif((thr4.threshold43 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color43_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color43_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color43_blue, 8)) & "00";
        elsif((thr4.threshold44 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color44_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color44_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color44_blue, 8)) & "00";
        elsif((thr4.threshold45 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color45_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color45_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color45_blue, 8)) & "00";
        elsif((thr4.threshold46 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color46_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color46_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color46_blue, 8)) & "00";
        elsif((thr4.threshold47 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color47_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color47_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color47_blue, 8)) & "00";
        elsif((thr4.threshold48 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color48_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color48_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color48_blue, 8)) & "00";
        elsif((thr4.threshold49 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color49_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color49_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color49_blue, 8)) & "00";
        elsif((thr4.threshold50 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color50_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color50_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color50_blue, 8)) & "00";
        elsif((thr4.threshold51 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color51_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color51_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color51_blue, 8)) & "00";
        elsif((thr4.threshold52 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color52_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color52_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color52_blue, 8)) & "00";
        elsif((thr4.threshold53 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color53_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color53_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color53_blue, 8)) & "00";
        elsif((thr4.threshold61 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color61_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color61_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color61_blue, 8)) & "00";
        elsif((thr4.threshold62 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color62_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color62_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color62_blue, 8)) & "00";
        elsif((thr4.threshold63 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color63_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color63_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color63_blue, 8)) & "00";
        elsif((thr4.threshold64 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color64_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color64_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color64_blue, 8)) & "00";
        elsif((thr4.threshold65 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color65_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color65_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color65_blue, 8)) & "00";
        elsif((thr4.threshold66 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color66_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color66_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color66_blue, 8)) & "00";
        elsif((thr4.threshold67 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color67_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color67_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color67_blue, 8)) & "00";
        elsif((thr4.threshold68 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color68_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color68_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color68_blue, 8)) & "00";
        elsif((thr4.threshold69 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color69_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color69_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color69_blue, 8)) & "00";
        elsif((thr4.threshold70 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color70_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color70_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color70_blue, 8)) & "00";
        elsif((thr4.threshold71 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color71_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color71_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color71_blue, 8)) & "00";
        elsif((thr4.threshold72 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color72_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color72_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color72_blue, 8)) & "00";
        elsif((thr4.threshold73 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color73_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color73_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color73_blue, 8)) & "00";
        end if;
    elsif(K_VALUE = 1)then
        if ((thr4.threshold1  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color01_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color01_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color01_blue, 8)) & "00";
        elsif((thr4.threshold20 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color20_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color20_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color20_blue, 8)) & "00";
        elsif((thr4.threshold36 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color36_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color36_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color36_blue, 8)) & "00";
        elsif((thr4.threshold53 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color53_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color53_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color53_blue, 8)) & "00";
        elsif((thr4.threshold61 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color61_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color61_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color61_blue, 8)) & "00";
        elsif((thr4.threshold73 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color73_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color73_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color73_blue, 8)) & "00";
        else
            oRgb.red     <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(255, 8)) & "00";
        end if;
    elsif(K_VALUE = 2)then
        if ((thr4.threshold5  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color05_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color05_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color05_blue, 8)) & "00";
        elsif((thr4.threshold16 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color16_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color16_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color16_blue, 8)) & "00";
        elsif((thr4.threshold40 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color40_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color40_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color40_blue, 8)) & "00";
        elsif((thr4.threshold51 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color51_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color51_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color51_blue, 8)) & "00";
        elsif((thr4.threshold65 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color65_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color65_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color65_blue, 8)) & "00";
        elsif((thr4.threshold71 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color71_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color71_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color71_blue, 8)) & "00";
        else
            oRgb.red     <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(255, 8)) & "00";
        end if;
    elsif(K_VALUE = 3)then
        if ((thr4.threshold6  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color06_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color06_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color06_blue, 8)) & "00";
        elsif((thr4.threshold15 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color15_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color15_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color15_blue, 8)) & "00";
        elsif((thr4.threshold41 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color41_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color41_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color41_blue, 8)) & "00";
        elsif((thr4.threshold50 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color50_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color50_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color50_blue, 8)) & "00";
        elsif((thr4.threshold66 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color66_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color66_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color66_blue, 8)) & "00";
        elsif((thr4.threshold70 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color70_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color70_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color70_blue, 8)) & "00";
        else
            oRgb.red     <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(255, 8)) & "00";
        end if;
    elsif(K_VALUE = 4)then
        if ((thr4.threshold7  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color07_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color07_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color07_blue, 8)) & "00";
        elsif((thr4.threshold14 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color14_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color14_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color14_blue, 8)) & "00";
        elsif((thr4.threshold42 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color42_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color42_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color42_blue, 8)) & "00";
        elsif((thr4.threshold49 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color49_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color49_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color49_blue, 8)) & "00";
        elsif((thr4.threshold67 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color67_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color67_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color67_blue, 8)) & "00";
        elsif((thr4.threshold69 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color69_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color69_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color69_blue, 8)) & "00";
        else
            oRgb.red     <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(255, 8)) & "00";
        end if;
    elsif(K_VALUE = 5)then
        if ((thr4.threshold6  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color06_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color06_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color06_blue, 8)) & "00";
        elsif((thr4.threshold9  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color09_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color09_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color09_blue, 8)) & "00";
        elsif((thr4.threshold14 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color14_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color14_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color14_blue, 8)) & "00";
        elsif((thr4.threshold41 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color41_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color41_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color41_blue, 8)) & "00";
        elsif((thr4.threshold45 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color45_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color45_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color45_blue, 8)) & "00";
        elsif((thr4.threshold49 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color49_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color49_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color49_blue, 8)) & "00";
        elsif((thr4.threshold66 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color66_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color66_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color66_blue, 8)) & "00";
        elsif((thr4.threshold67 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color67_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color67_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color67_blue, 8)) & "00";
        elsif((thr4.threshold69 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color69_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color69_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color69_blue, 8)) & "00";
        else
            oRgb.red     <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(255, 8)) & "00";
        end if;
    elsif(K_VALUE = 9)then
        if ((thr4.threshold1  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color01_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color01_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color01_blue, 8)) & "00";
        elsif((thr4.threshold3  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color03_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color03_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color03_blue, 8)) & "00";
        elsif((thr4.threshold5 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color05_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color05_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color05_blue, 8)) & "00";
        elsif((thr4.threshold6 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color06_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color06_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color06_blue, 8)) & "00";
        elsif((thr4.threshold7  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color07_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color07_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color07_blue, 8)) & "00";
        elsif((thr4.threshold8 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color08_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color08_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color08_blue, 8)) & "00";
        elsif((thr4.threshold9 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color09_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color09_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color09_blue, 8)) & "00";
        elsif((thr4.threshold16 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color16_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color16_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color16_blue, 8)) & "00";
        ----------------------------------------------------------------------------------------
        elsif((thr4.threshold36 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color36_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color36_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color36_blue, 8)) & "00";
        elsif((thr4.threshold37 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color37_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color37_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color37_blue, 8)) & "00";
        elsif((thr4.threshold38 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color38_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color38_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color38_blue, 8)) & "00";
        elsif((thr4.threshold39 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color39_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color39_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color39_blue, 8)) & "00";
        elsif((thr4.threshold40 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color40_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color40_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color40_blue, 8)) & "00";
        elsif((thr4.threshold41 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color41_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color41_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color41_blue, 8)) & "00";
        elsif((thr4.threshold42 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color42_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color42_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color42_blue, 8)) & "00";
        elsif((thr4.threshold50 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color50_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color50_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color50_blue, 8)) & "00";
        ----------------------------------------------------------------------------------------
        elsif((thr4.threshold62 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color62_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color62_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color62_blue, 8)) & "00";
        elsif((thr4.threshold63 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color63_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color63_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color63_blue, 8)) & "00";
        elsif((thr4.threshold65 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color65_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color65_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color65_blue, 8)) & "00";
        elsif((thr4.threshold66 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color66_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color66_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color66_blue, 8)) & "00";
        elsif((thr4.threshold67 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color67_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color67_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color67_blue, 8)) & "00";
        elsif((thr4.threshold68 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color68_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color68_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color68_blue, 8)) & "00";
        elsif((thr4.threshold69 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color69_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color69_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color69_blue, 8)) & "00";
        elsif((thr4.threshold73 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color73_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color73_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color73_blue, 8)) & "00";
        else
            oRgb.red     <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(255, 8)) & "00";
        end if;
        -------------
    else
        if ((thr4.threshold1  = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color01_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color01_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color01_blue, 8)) & "00";
        elsif((thr4.threshold2 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color02_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color02_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color02_blue, 8)) & "00";
        elsif((thr4.threshold3 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color03_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color03_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color03_blue, 8)) & "00";
        elsif((thr4.threshold4 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color04_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color04_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color04_blue, 8)) & "00";
        elsif((thr4.threshold5 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color05_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color05_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color05_blue, 8)) & "00";
        elsif((thr4.threshold6 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color06_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color06_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color06_blue, 8)) & "00";
        elsif((thr4.threshold7 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color07_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color07_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color07_blue, 8)) & "00";
        elsif((thr4.threshold8 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color08_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color08_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color08_blue, 8)) & "00";
        elsif((thr4.threshold9 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color09_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color09_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color09_blue, 8)) & "00";
        elsif((thr4.threshold10 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color10_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color10_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color10_blue, 8)) & "00";
        elsif((thr4.threshold11 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color11_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color11_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color11_blue, 8)) & "00";
        elsif((thr4.threshold12 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color12_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color12_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color12_blue, 8)) & "00";
        elsif((thr4.threshold13 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color13_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color13_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color13_blue, 8)) & "00";
        elsif((thr4.threshold14 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color14_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color14_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color14_blue, 8)) & "00";
        elsif((thr4.threshold15 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color15_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color15_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color15_blue, 8)) & "00";
        elsif((thr4.threshold16 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color16_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color16_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color16_blue, 8)) & "00";
        elsif((thr4.threshold17 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color17_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color17_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color17_blue, 8)) & "00";
        elsif((thr4.threshold18 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color18_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color18_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color18_blue, 8)) & "00";
        elsif((thr4.threshold19 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color19_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color19_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color19_blue, 8)) & "00";
        elsif((thr4.threshold20 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color20_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color20_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color20_blue, 8)) & "00";
        elsif((thr4.threshold21 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color21_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color21_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color21_blue, 8)) & "00";
        elsif((thr4.threshold22 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color22_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color22_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color22_blue, 8)) & "00";
        elsif((thr4.threshold23 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color23_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color23_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color23_blue, 8)) & "00";
        elsif((thr4.threshold24 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color24_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color24_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color24_blue, 8)) & "00";
        elsif((thr4.threshold25 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color25_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color25_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color25_blue, 8)) & "00";
        elsif((thr4.threshold26 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color26_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color26_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color26_blue, 8)) & "00";
        elsif((thr4.threshold27 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color27_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color27_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color27_blue, 8)) & "00";
        elsif((thr4.threshold28 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color28_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color28_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color28_blue, 8)) & "00";
        elsif((thr4.threshold29 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color29_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color29_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color29_blue, 8)) & "00";
        elsif((thr4.threshold30 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color30_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color30_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color30_blue, 8)) & "00";
        elsif((thr4.threshold31 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color31_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color31_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color31_blue, 8)) & "00";
        elsif((thr4.threshold32 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color32_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color32_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color32_blue, 8)) & "00";
        elsif((thr4.threshold33 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color33_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color33_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color33_blue, 8)) & "00";
        elsif((thr4.threshold34 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color34_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color34_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color34_blue, 8)) & "00";
        elsif((thr4.threshold35 = threshold_lms) and (rgb_sync23.red  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color35_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color35_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color35_blue, 8)) & "00";
        elsif((thr4.threshold36 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color36_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color36_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color36_blue, 8)) & "00";
        elsif((thr4.threshold37 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color37_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color37_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color37_blue, 8)) & "00";
        elsif((thr4.threshold38 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color38_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color38_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color38_blue, 8)) & "00";
        elsif((thr4.threshold39 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color39_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color39_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color39_blue, 8)) & "00";
        elsif((thr4.threshold40 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color40_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color40_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color40_blue, 8)) & "00";
        elsif((thr4.threshold41 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color41_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color41_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color41_blue, 8)) & "00";
        elsif((thr4.threshold42 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color42_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color42_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color42_blue, 8)) & "00";
        elsif((thr4.threshold43 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color43_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color43_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color43_blue, 8)) & "00";
        elsif((thr4.threshold44 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color44_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color44_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color44_blue, 8)) & "00";
        elsif((thr4.threshold45 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color45_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color45_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color45_blue, 8)) & "00";
        elsif((thr4.threshold46 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color46_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color46_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color46_blue, 8)) & "00";
        elsif((thr4.threshold47 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color47_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color47_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color47_blue, 8)) & "00";
        elsif((thr4.threshold48 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color48_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color48_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color48_blue, 8)) & "00";
        elsif((thr4.threshold49 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color49_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color49_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color49_blue, 8)) & "00";
        elsif((thr4.threshold50 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color50_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color50_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color50_blue, 8)) & "00";
        elsif((thr4.threshold51 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color51_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color51_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color51_blue, 8)) & "00";
        elsif((thr4.threshold52 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color52_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color52_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color52_blue, 8)) & "00";
        elsif((thr4.threshold53 = threshold_lms) and (rgb_sync23.green  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color53_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color53_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color53_blue, 8)) & "00";
        elsif((thr4.threshold61 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color61_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color61_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color61_blue, 8)) & "00";
        elsif((thr4.threshold62 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color62_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color62_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color62_blue, 8)) & "00";
        elsif((thr4.threshold63 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color63_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color63_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color63_blue, 8)) & "00";
        elsif((thr4.threshold64 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color64_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color64_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color64_blue, 8)) & "00";
        elsif((thr4.threshold65 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color65_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color65_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color65_blue, 8)) & "00";
        elsif((thr4.threshold66 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color66_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color66_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color66_blue, 8)) & "00";
        elsif((thr4.threshold67 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color67_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color67_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color67_blue, 8)) & "00";
        elsif((thr4.threshold68 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color68_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color68_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color68_blue, 8)) & "00";
        elsif((thr4.threshold69 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color69_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color69_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color69_blue, 8)) & "00";
        elsif((thr4.threshold70 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color70_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color70_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color70_blue, 8)) & "00";
        elsif((thr4.threshold71 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color71_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color71_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color71_blue, 8)) & "00";
        elsif((thr4.threshold72 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color72_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color72_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color72_blue, 8)) & "00";
        elsif((thr4.threshold73 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color73_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color73_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color73_blue, 8)) & "00";
--        elsif((thr4.threshold74 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color74_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color74_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color74_blue, 8)) & "00";
--        elsif((thr4.threshold75 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color75_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color75_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color75_blue, 8)) & "00";
--        elsif((thr4.threshold76 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color76_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color76_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color76_blue, 8)) & "00";
--        elsif((thr4.threshold77 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color77_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color77_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color77_blue, 8)) & "00";
--        elsif((thr4.threshold78 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color78_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color78_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color78_blue, 8)) & "00";
--        elsif((thr4.threshold79 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color79_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color79_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color79_blue, 8)) & "00";
--        elsif((thr4.threshold80 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color80_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color80_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color80_blue, 8)) & "00";
--        elsif((thr4.threshold81 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color81_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color81_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color81_blue, 8)) & "00";
--        elsif((thr4.threshold82 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color82_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color82_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color82_blue, 8)) & "00";
--        elsif((thr4.threshold83 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color83_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color83_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color83_blue, 8)) & "00";
--        elsif((thr4.threshold84 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color84_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color84_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color84_blue, 8)) & "00";
--        elsif((thr4.threshold85 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color85_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color85_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color85_blue, 8)) & "00";
--        elsif((thr4.threshold86 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
--            oRgb.red     <= std_logic_vector(to_unsigned(color86_red, 8)) & "00";
--            oRgb.green   <= std_logic_vector(to_unsigned(color86_green, 8)) & "00";
--            oRgb.blue    <= std_logic_vector(to_unsigned(color86_blue, 8)) & "00";
        -- elsif((thr4.threshold87 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            -- oRgb.red     <= std_logic_vector(to_unsigned(color87_red, 8)) & "00";
            -- oRgb.green   <= std_logic_vector(to_unsigned(color87_green, 8)) & "00";
            -- oRgb.blue    <= std_logic_vector(to_unsigned(color87_blue, 8)) & "00";
        -- elsif((thr4.threshold88 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            -- oRgb.red     <= std_logic_vector(to_unsigned(color88_red, 8)) & "00";
            -- oRgb.green   <= std_logic_vector(to_unsigned(color88_green, 8)) & "00";
            -- oRgb.blue    <= std_logic_vector(to_unsigned(color88_blue, 8)) & "00";
        -- elsif((thr4.threshold89 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            -- oRgb.red     <= std_logic_vector(to_unsigned(color89_red, 8)) & "00";
            -- oRgb.green   <= std_logic_vector(to_unsigned(color89_green, 8)) & "00";
            -- oRgb.blue    <= std_logic_vector(to_unsigned(color89_blue, 8)) & "00";
        -- elsif((thr4.threshold90 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            -- oRgb.red     <= std_logic_vector(to_unsigned(color90_red, 8)) & "00";
            -- oRgb.green   <= std_logic_vector(to_unsigned(color90_green, 8)) & "00";
            -- oRgb.blue    <= std_logic_vector(to_unsigned(color90_blue, 8)) & "00";
        elsif((thr4.threshold91 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color91_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color91_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color91_blue, 8)) & "00";
        elsif((thr4.threshold92 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color92_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color92_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color92_blue, 8)) & "00";
        elsif((thr4.threshold93 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color93_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color93_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color93_blue, 8)) & "00";
        elsif((thr4.threshold94 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color94_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color94_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color94_blue, 8)) & "00";
        elsif((thr4.threshold95 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color95_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color95_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color95_blue, 8)) & "00";
        elsif((thr4.threshold96 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color96_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color96_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color96_blue, 8)) & "00";
        elsif((thr4.threshold97 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color97_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color97_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color97_blue, 8)) & "00";
        elsif((thr4.threshold98 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color98_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color98_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color98_blue, 8)) & "00";
        elsif((thr4.threshold99 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color99_red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color99_green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color99_blue, 8)) & "00";
        elsif((thr4.threshold100 = threshold_lms) and (rgb_sync23.blue  = rgb_max22)) then
            oRgb.red     <= std_logic_vector(to_unsigned(color100red, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(color100green, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(color100blue, 8)) & "00";
        else
            oRgb.red     <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.green   <= std_logic_vector(to_unsigned(255, 8)) & "00";
            oRgb.blue    <= std_logic_vector(to_unsigned(255, 8)) & "00";
        end if;
    end if;
    end if;
end process;


oRgb.valid <= rgbSyncValid(28);
oRgb.eol   <= rgbSyncEol(28);
oRgb.sof   <= rgbSyncSof(28);
oRgb.eof   <= rgbSyncEof(28);

end architecture;
