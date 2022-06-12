-------------------------------------------------------------------------------
--
-- Filename    : hsl_c.vhd
-- Create Date : 05062019 [05-06-2019]
-- Author      : Zakinder
--
-- Description:
-- This module converts rgb color space to hsl color space. First logic 
-- calculates maximum and minimum value of rgb values. Hue is calculated 
-- first determining the hue fraction from greatest rgb channel value. 
-- If current max channel is red than Hue numerator will be set to be green 
-- subtract blue only if green is greater than blue else blue is subtracted 
-- from green and Hue degree would be zero.  If current max channel is green 
-- than Hue numerator will be set to be blue subtract red only if blue is greater 
-- than red else red is subtracted from blue and Hue degree would be 129. 
-- Similarly, if current channel is blue than Hue numerator will be set to be 
-- red subtract green only if red is greater than green else green subtracted from 
-- red and Hue degree would be 212. Hue denominator would be rgb delta. 
-- Once Hue fraction values are calculated than fraction values would be added 
-- to hue degree which would give final hue value as done logic.Saturate value 
-- is calculated from difference between rgb max and min over rgb max whereas 
-- Intensity value rgb max value.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;
entity hsl_c is
generic (
    i_data_width   : natural := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end hsl_c;
architecture behavioral of hsl_c is
    signal rgb_sync_1                : intChannel;
    signal rgb_sync_2                : intChannel;
    signal rgb_sync_3                : intChannel;
    signal rgb_max                   : natural := zero;
    signal rgb_min                   : natural := zero;
    signal rgb_max_value             : natural := zero;
    signal rgb_delta                 : natural := zero;
    signal rgb_delta_1               : integer := zero;
    signal rgb_delta_sum             : natural := zero;
    signal rgb_delta_sum_1           : natural := zero;
    signal rgb_delta_max_1           : natural := zero;
    signal rgb_delta_max_2           : natural := zero;
    signal rgb_delta_max             : natural := zero;
    signal rgb_delta_sum_denominator : ufixed(17 downto 0)    :=(others => '0');
    signal rgb_delta_numerator       : ufixed(8 downto 0)    :=(others => '0');
    signal rgb_delta_numerator_1     : ufixed(8 downto 0)    :=(others => '0');
    signal rgb_delta_quotient_1      : ufixed(17 downto -9)   :=(others => '0');
    signal rgb_delta_quotient_2      : ufixed(8 downto -9)   :=(others => '0');
    signal rgb_delta_quot_1          : ufixed(8 downto 0)    :=(others => '0');
    signal rgb_delta_quot_2          : ufixed(8 downto 0)    :=(others => '0');
    --H
    signal hue_quotient       : ufixed(17 downto -9) :=(others => '0');
    signal hue_numerator      : natural := zero;
    signal hue_denominator    : natural := zero;
    signal hue_quot           : ufixed(17 downto 0)  :=(others => '0');
    signal uuFiXhueTop        : ufixed(17 downto 0)  :=(others => '0');
    signal uuFiXhueBot        : ufixed(8 downto 0)   :=(others => '0');
    signal uFiXhueQuot        : natural := zero;
    signal hue_quotient_value : natural := zero;
    signal hue_degree         : natural := zero;
    signal hue_degree_sync    : natural := zero;
    signal hue_result         : natural := zero;
    signal hue                : natural := zero;
    --S
    signal saturate           : unsigned(7 downto 0);
    signal saturate_sync1     : unsigned(7 downto 0);
    signal saturate_sync2     : unsigned(7 downto 0);
    --V
    signal luminosity         : natural;
    signal luminosity_sync1   : unsigned(7 downto 0);
    signal luminosity_sync2   : unsigned(7 downto 0);
    --Valid
    signal valid1_rgb         : std_logic := '0';
    signal valid2_rgb         : std_logic := '0';
    signal valid3_rgb         : std_logic := '0';
    signal sHsl               : channel;
    signal rgb_ool4           : channel;
    signal rgb_colo           : rgbToSfRecord;
    signal rgb_oolo           : rgbToSfRecord;
    signal rgb_ool2           : rgbToSf12Record;
    signal rgb_ool3           : rgbToSfRecord;
    signal valid4_rgb         : std_logic := '0';
    signal valid5_rgb         : std_logic := '0';
    signal valid6_rgb         : std_logic := '0';
    signal valid7_rgb         : std_logic := '0';
    signal valid8_rgb         : std_logic := '0';
begin
rgbToUfP: process (clk,reset)begin
    if (reset = lo) then
        rgb_sync_1.red    <= zero;
        rgb_sync_1.green  <= zero;
        rgb_sync_1.blue   <= zero;
    elsif rising_edge(clk) then
        rgb_sync_1.red    <= to_integer(unsigned(iRgb.red));
        rgb_sync_1.green  <= to_integer(unsigned(iRgb.green));
        rgb_sync_1.blue   <= to_integer(unsigned(iRgb.blue));
        rgb_sync_1.valid  <= iRgb.valid;
    end if;
end process rgbToUfP;
-- RGB.max = max(R, G, B)
rgbMaxP: process (clk) begin
    if rising_edge(clk) then
        if ((rgb_sync_1.red >= rgb_sync_1.green) and (rgb_sync_1.red >= rgb_sync_1.blue)) then
            rgb_max <= rgb_sync_1.red;
        elsif((rgb_sync_1.green >= rgb_sync_1.red) and (rgb_sync_1.green >= rgb_sync_1.blue))then
            rgb_max <= rgb_sync_1.green;
        else
            rgb_max <= rgb_sync_1.blue;
        end if;
    end if;
end process rgbMaxP;
--RGB.min = min(R, G, B)
rgbMinP: process (clk) begin
    if rising_edge(clk) then
        if ((rgb_sync_1.red <= rgb_sync_1.green) and (rgb_sync_1.red <= rgb_sync_1.blue)) then
            rgb_min <= rgb_sync_1.red;
        elsif((rgb_sync_1.green <= rgb_sync_1.red) and (rgb_sync_1.green <= rgb_sync_1.blue)) then
            rgb_min <= rgb_sync_1.green;
        else
            rgb_min <= rgb_sync_1.blue;
        end if;
    end if;
end process rgbMinP;
-- RGB.∆ = RGB.max − RGB.min
pipRgbMaxUfD1P: process (clk) begin
    if rising_edge(clk) then
        rgb_max_value    <= rgb_max;
    end if;
end process pipRgbMaxUfD1P;
-- RGB.∆ = RGB.max − RGB.min
rgbDeltaP: process (clk) begin
    if rising_edge(clk) then
        rgb_delta      <= (rgb_max - rgb_min);
        rgb_delta_1    <= (rgb_max - rgb_min);
        rgb_delta_sum  <= (rgb_max + rgb_min);
    end if;
end process rgbDeltaP;
rgb_delta_sum_denominator   <= to_ufixed(rgb_delta_sum,uuFiXhueTop);
rgb_delta_numerator         <= to_ufixed(rgb_delta_sum,uuFiXhueBot);
rgb_delta_numerator_1       <= to_ufixed(rgb_delta_1,uuFiXhueBot);
rgb_delta_quotient_1        <= (rgb_delta_numerator / rgb_delta_sum_denominator);
rgb_delta_quotient_2        <= (rgb_delta_numerator / rgb_delta_numerator_1);
rgb_delta_quot_1            <= resize(rgb_delta_quotient_1,rgb_delta_quot_1);
rgb_delta_quot_2            <= resize(rgb_delta_quotient_2,rgb_delta_quot_2);
rgb_delta_max_1             <= to_integer(unsigned(rgb_delta_quot_1));
rgb_delta_max_2             <= to_integer(unsigned(rgb_delta_quot_2));

process(rgb_delta_max_2)begin
    if (rgb_delta_max_2 < 256) then
        rgb_delta_max     <= rgb_delta_max_2;
    end if;
end process;


-------------------------------------------------
pipRgbD2P: process (clk) begin
    if rising_edge(clk) then
        rgb_sync_2 <= rgb_sync_1;
        rgb_sync_3 <= rgb_sync_2;
    end if;
end process pipRgbD2P;
-------------------------------------------------
-- HUE
-- RGB.∆ = RGB.MAX − RGB.MIN
-- IF (RED== RGB.MAX) *H = 0 + ( GRE - BLU ) / RGB.∆; BETWEEN ← YELLOW & MAGENTA
-- IF (GRE== RGB.MAX) *H = 2 + ( BLU - RED ) / RGB.∆; BETWEEN ← CYAN & YELLOW
-- IF (BLU== RGB.MAX) *H = 4 + ( RED - GRE ) / RGB.∆; BETWEEN ← MAGENTA & CYAN
-------------------------------------------------
hueP: process (clk) begin
  if rising_edge(clk) then
    if (rgb_sync_3.red  = rgb_max_value) then
        if (rgb_sync_3.green >= rgb_sync_3.blue) then
            hue_degree <= 0;
            hue_numerator        <= (rgb_sync_3.green - rgb_sync_3.blue) * 44;
        else
            hue_degree <= 0;
            hue_numerator        <= (rgb_sync_3.blue - rgb_sync_3.green) * 85;
        end if;
    elsif(rgb_sync_3.green = rgb_max_value)  then
        if (rgb_sync_3.blue >= rgb_sync_3.red ) then
            hue_degree <= 129;
            hue_numerator       <= (rgb_sync_3.blue - rgb_sync_3.red ) * 43;
        else
            hue_degree <= 86;
            hue_numerator       <= (rgb_sync_3.red  - rgb_sync_3.blue) * 84;
        end if;
    elsif(rgb_sync_3.blue = rgb_max_value)  then
        if (rgb_sync_3.red  >= rgb_sync_3.green) then
            hue_degree <= 212;
            hue_numerator       <= (rgb_sync_3.red  - rgb_sync_3.green) * 43;
        else
            hue_degree <= 171;
            hue_numerator       <= (rgb_sync_3.green - rgb_sync_3.red ) * 84;
        end if;
    end if;
  end if;
end process hueP;

-------------------------------------------------
-- HUE
-- RGB.∆ = RGB.max − RGB.min
-------------------------------------------------
hueBottomP: process (clk) begin
    if rising_edge(clk) then
        if (rgb_delta > 0) then
            hue_denominator <= rgb_delta;
        else
            hue_denominator <= 6;
        end if;
    end if;
end process hueBottomP;
-------------------------------------------------
-- HUE DIVISION
-------------------------------------------------
uuFiXhueTop   <= to_ufixed(hue_numerator,uuFiXhueTop);
uuFiXhueBot   <= to_ufixed(hue_denominator,uuFiXhueBot);
hue_quotient  <= (uuFiXhueTop / uuFiXhueBot);
hue_quot      <= resize(hue_quotient,hue_quot);
uFiXhueQuot   <= to_integer(unsigned(hue_quot));
-------------------------------------------------
hueDegreeP: process (clk) begin
    if rising_edge(clk) then
        hue_degree_sync  <= hue_degree;
    end if;
end process hueDegreeP;
hueDividerResizeP: process (clk) begin
    if rising_edge(clk) then
        hue_quotient_value  <= uFiXhueQuot;
    end if;
end process hueDividerResizeP;
hue  <= hue_quotient_value + hue_degree_sync;
-------------------------------------------------
-- SATURATE
-------------------------------------------------     
satValueP: process (clk) begin
    if rising_edge(clk) then
        if(rgb_max /= 0)then
            saturate <= to_unsigned((rgb_delta_max),8);
        else
            saturate <= to_unsigned(0, 8);
        end if;
    end if;
end process satValueP; 
-------------------------------------------------
-- VALUE
-------------------------------------------------
valValueP: process (clk) begin
    if rising_edge(clk) then
        luminosity <= (rgb_max + rgb_min) /2;
    end if;
end process valValueP;

process (clk) begin
    if rising_edge(clk) then
        luminosity_sync1 <= to_unsigned(luminosity, 8);
    end if;
end process;

pipValidP: process (clk) begin
    if rising_edge(clk) then
        valid1_rgb    <= rgb_sync_3.valid;
        valid2_rgb    <= valid1_rgb;
        valid3_rgb    <= valid2_rgb;
        valid4_rgb    <= valid3_rgb;
        valid5_rgb    <= valid4_rgb;
        valid6_rgb    <= valid5_rgb;
        valid7_rgb    <= valid6_rgb;
        valid8_rgb    <= valid7_rgb;
    end if;
end process pipValidP;

process (clk) begin
    if rising_edge(clk) then
        luminosity_sync2        <= luminosity_sync1;
        saturate_sync1          <= saturate;
        saturate_sync2          <= saturate_sync1;
    end if;
end process;

oHsl.red   <= std_logic_vector(to_unsigned(hue, 8));
oHsl.green <= std_logic_vector(saturate_sync2);
oHsl.blue  <= std_logic_vector(luminosity_sync2);
oHsl.valid <= valid4_rgb;
        
end behavioral;