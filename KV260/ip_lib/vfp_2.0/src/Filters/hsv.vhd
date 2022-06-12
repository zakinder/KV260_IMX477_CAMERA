-------------------------------------------------------------------------------
--
-- Filename    : hsv_c.vhd
-- Create Date : 05062019 [05-06-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
-- p ← RGB2HSV(p)
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
entity hsv_c is
generic (
    i_data_width   : natural := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsv           : out channel);
end hsv_c;
architecture behavioral of hsv_c is
    signal uFs1Rgb       : intChannel;
    signal uFs2Rgb       : intChannel;
    signal uFs3Rgb       : intChannel;
    signal uFs11Rgb      : intChannel;
    signal uFs22Rgb      : intChannel;
    signal rgbMax        : natural;
    signal rgb2Max       : natural;
    signal rgbMin        : natural;
    signal maxValue      : natural;
    signal minValue      : natural;
    signal rgbDelta      : natural;
    --H
    signal hue_quot      : ufixed(17 downto 0) :=(others => '0');
    signal uuFiXhueQuot  : ufixed(17 downto -9) :=(others => '0');
    signal uuFiXhueTop   : ufixed(17 downto 0)  :=(others => '0');
    signal uuFiXhueBot   : ufixed(8 downto 0)   :=(others => '0');
    signal uFiXhueTop    : natural := zero;
    signal uFiXhueBot    : natural := zero;
    signal uFiXhueQuot   : natural := zero;
    signal hueQuot1x     : natural := zero;
    signal hueDeg        : natural := zero;
    signal hueDeg1x      : natural := zero;
    signal h_value       : natural := zero;
    --S
    signal s1value       : unsigned(7 downto 0);
    signal s2value       : unsigned(7 downto 0);
    signal s3value       : unsigned(7 downto 0);
    --V
    signal v1value       : unsigned(7 downto 0);
    signal v2value       : unsigned(7 downto 0);
    signal v3value       : unsigned(7 downto 0);
    signal v4value       : unsigned(7 downto 0);
    signal v5value       : unsigned(7 downto 0);
    --Valid
    signal valid1_rgb    : std_logic := '0';
    signal valid2_rgb    : std_logic := '0';
    signal valid3_rgb    : std_logic := '0';
    signal sHsl          : channel;
    signal lHsl          : channel;
    signal rgb_ol1_red       : sfixed(9 downto 0);
    signal rgb_ol2_red       : sfixed(9 downto 0);
    signal rgb_ol3_red       : sfixed(9 downto 0);
    signal rgb_ol4_red       : sfixed(9 downto 0);
    signal rgb_ool4      : channel;
    signal rgb_colo      : rgbToSfRecord;
    signal rgb_oolo      : rgbToSfRecord;
    signal rgb_ool2      : rgbToSf12Record;
    signal rgb_ool3      : rgbToSfRecord;
    signal valid4_rgb    : std_logic := '0';
    signal valid5_rgb    : std_logic := '0';
    signal valid6_rgb    : std_logic := '0';
    signal valid7_rgb    : std_logic := '0';
    signal valid8_rgb    : std_logic := '0';
begin
rgbToUfP: process (clk,reset)begin
    if (reset = lo) then
        uFs1Rgb.red    <= zero;
        uFs1Rgb.green  <= zero;
        uFs1Rgb.blue   <= zero;
    elsif rising_edge(clk) then
        uFs1Rgb.red    <= to_integer(unsigned(iRgb.red));
        uFs1Rgb.green  <= to_integer(unsigned(iRgb.green));
        uFs1Rgb.blue   <= to_integer(unsigned(iRgb.blue));
        uFs1Rgb.valid  <= iRgb.valid;
    end if;
end process rgbToUfP;
-- RGB.max = max(R, G, B)
rgbMaxP: process (clk) begin
    if rising_edge(clk) then
        if ((uFs1Rgb.red >= uFs1Rgb.green) and (uFs1Rgb.red >= uFs1Rgb.blue)) then
            rgbMax <= uFs1Rgb.red;
        elsif((uFs1Rgb.green >= uFs1Rgb.red) and (uFs1Rgb.green >= uFs1Rgb.blue))then
            rgbMax <= uFs1Rgb.green;
        else
            rgbMax <= uFs1Rgb.blue;
        end if;
    end if;
end process rgbMaxP;
--RGB.min = min(R, G, B)
rgbMinP: process (clk) begin
    if rising_edge(clk) then
        if ((uFs1Rgb.red <= uFs1Rgb.green) and (uFs1Rgb.red <= uFs1Rgb.blue)) then
            rgbMin <= uFs1Rgb.red;
        elsif((uFs1Rgb.green <= uFs1Rgb.red) and (uFs1Rgb.green <= uFs1Rgb.blue)) then
            rgbMin <= uFs1Rgb.green;
        else
            rgbMin <= uFs1Rgb.blue;
        end if;
    end if;
end process rgbMinP;
-- RGB.∆ = RGB.max − RGB.min
pipRgbMaxUfD1P: process (clk) begin
    if rising_edge(clk) then
        maxValue          <= rgbMax;
        minValue          <= rgbMin;
    end if;
end process pipRgbMaxUfD1P;
-- RGB.∆ = RGB.max − RGB.min
rgbDeltaP: process (clk) begin
    if rising_edge(clk) then
        rgbDelta      <= rgbMax - rgbMin;
    end if;
end process rgbDeltaP;
pipRgbD2P: process (clk) begin
    if rising_edge(clk) then
        uFs2Rgb <= uFs1Rgb;
        uFs3Rgb <= uFs2Rgb;
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
    if (uFs3Rgb.red  = maxValue) then
        if (uFs3Rgb.green >= uFs3Rgb.blue) then
            hueDeg <= 0;
            uFiXhueTop        <= (uFs3Rgb.green - uFs3Rgb.blue) * 44;
        else
            hueDeg <= 0;
            uFiXhueTop        <= (uFs3Rgb.blue - uFs3Rgb.green) * 85;
        end if;
    elsif(uFs3Rgb.green = maxValue)  then
        if (uFs3Rgb.blue >= uFs3Rgb.red ) then
            hueDeg <= 129;
            uFiXhueTop       <= (uFs3Rgb.blue - uFs3Rgb.red ) * 43;
        else
            hueDeg <= 86;
            uFiXhueTop       <= (uFs3Rgb.red  - uFs3Rgb.blue) * 84;
        end if;
    elsif(uFs3Rgb.blue = maxValue)  then

        if (uFs3Rgb.red  >= uFs3Rgb.green) then
            hueDeg <= 212;
            uFiXhueTop       <= (uFs3Rgb.red  - uFs3Rgb.green) * 43;
        else
            hueDeg <= 171;
            uFiXhueTop       <= (uFs3Rgb.green - uFs3Rgb.red ) * 84;
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
        if (rgbDelta > 0) then
            uFiXhueBot <= rgbDelta;
        else
            uFiXhueBot <= 6;
        end if;
    end if;
end process hueBottomP;
uuFiXhueTop   <= to_ufixed(uFiXhueTop,uuFiXhueTop);
uuFiXhueBot   <= to_ufixed(uFiXhueBot,uuFiXhueBot);
uuFiXhueQuot  <= (uuFiXhueTop / uuFiXhueBot);
hue_quot      <= resize(uuFiXhueQuot,hue_quot);
uFiXhueQuot   <= to_integer(unsigned(hue_quot));
hueDegreeP: process (clk) begin
    if rising_edge(clk) then
        hueDeg1x       <= hueDeg;
    end if;
end process hueDegreeP;
hueDividerResizeP: process (clk) begin
    if rising_edge(clk) then
            hueQuot1x <= uFiXhueQuot;
    end if;
end process hueDividerResizeP;
hueValueP: process (clk) begin
    if rising_edge(clk) then
        h_value <= hueQuot1x + hueDeg1x;
    end if;
end process hueValueP;    
-------------------------------------------------
-- SATURATE
-------------------------------------------------     
satValueP: process (clk) begin
    if rising_edge(clk) then
        if(rgbMax /= 0)then
            s1value <= to_unsigned((rgbDelta),8);
        else
            s1value <= to_unsigned(0, 8);
        end if;
    end if;
end process satValueP; 
-------------------------------------------------
-- VALUE
-------------------------------------------------
valValueP: process (clk) begin
    if rising_edge(clk) then
        v1value <= to_unsigned(rgbMax, 8);
        v2value <= v2value;
        v3value <= v1value;
        v4value <= v3value;
        v5value <= v4value;
    end if;
end process valValueP;
process (clk) begin
    if rising_edge(clk) then
        valid1_rgb    <= uFs3Rgb.valid;
        valid2_rgb    <= valid1_rgb;
        valid3_rgb    <= valid2_rgb;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        s2value    <= s1value;
        s3value    <= s2value;
    end if;
end process;
-------------------------------------------------
lHsl.red   <= std_logic_vector(to_unsigned(h_value, 8));
lHsl.green <= std_logic_vector(s3value);
lHsl.blue  <= std_logic_vector(v5value);
lHsl.valid <= valid3_rgb;
process (clk,reset)begin
    if (reset = lo) then
        uFs11Rgb.red    <= zero;
        uFs11Rgb.green  <= zero;
        uFs11Rgb.blue   <= zero;
    elsif rising_edge(clk) then
        uFs11Rgb.red    <= to_integer(unsigned(lHsl.red));
        uFs11Rgb.green  <= to_integer(unsigned(lHsl.green));
        uFs11Rgb.blue   <= to_integer(unsigned(lHsl.blue));
        uFs11Rgb.valid  <= lHsl.valid;
    end if;
end process;
rgb_ool1_inst: sync_frames
generic map(
    pixelDelay => 5)
port map(
    clk        => clk,
    reset      => reset,
    iRgb       => iRgb,
    oRgb       => rgb_ool4);
process (clk) begin
    if rising_edge(clk) then
        rgb_colo.red    <= to_sfixed("00" & lHsl.red,rgb_colo.red);
        rgb_colo.green  <= to_sfixed("00" & lHsl.green,rgb_colo.green);
        rgb_colo.blue   <= to_sfixed("00" & lHsl.blue,rgb_colo.blue);
        rgb_oolo.red    <= to_sfixed("00" & rgb_ool4.red,rgb_oolo.red);
        rgb_oolo.green  <= to_sfixed("00" & rgb_ool4.green,rgb_oolo.green);
        rgb_oolo.blue   <= to_sfixed("00" & rgb_ool4.blue,rgb_oolo.blue);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_ool2.red   <= abs(rgb_oolo.red - rgb_colo.red);
        rgb_ool2.green <= abs(rgb_oolo.green - rgb_colo.green);
        rgb_ool2.blue  <= abs(rgb_oolo.blue - rgb_colo.blue);
        rgb_ool3.red   <= resize(rgb_ool2.red,rgb_ool3.red);
        rgb_ool3.green <= resize(rgb_ool2.green,rgb_ool3.green);
        rgb_ool3.blue  <= resize(rgb_ool2.blue,rgb_ool3.blue);
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        rgb_ol1_red     <= rgb_colo.red;
        rgb_ol2_red     <= rgb_ol1_red;
        rgb_ol3_red     <= rgb_ol2_red;
        rgb_ol4_red     <= rgb_ol3_red;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        valid4_rgb    <= rgb_ool4.valid;
        valid5_rgb    <= valid4_rgb;
        valid6_rgb    <= valid5_rgb;
        valid7_rgb    <= valid6_rgb;
        valid8_rgb    <= valid7_rgb;
    end if;
end process;
pipRgbwD2P: process (clk) begin
    if rising_edge(clk) then
        oHsv.red   <= std_logic_vector(rgb_ol4_red(i_data_width-1 downto 0));
        oHsv.green <= std_logic_vector(rgb_ool3.green(i_data_width-1 downto 0));
        oHsv.blue  <= std_logic_vector(rgb_ool3.blue(i_data_width-1 downto 0));
        oHsv.valid <= valid8_rgb;
    end if;
end process pipRgbwD2P;
-- RGB.max = max(R, G, B)
--process (clk) begin
--    if rising_edge(clk) then
--    
--    sHsl.valid <= uFs11Rgb.valid;
--    sHsl.green <= std_logic_vector(to_unsigned(uFs11Rgb.green, 8));
--    sHsl.blue  <= std_logic_vector(to_unsigned(uFs11Rgb.blue,  8));
--    
--        if ((uFs11Rgb.red >= uFs11Rgb.green) and (uFs11Rgb.red >= uFs11Rgb.blue)) then
--            --if (uFs11Rgb.green >= uFs11Rgb.blue) then
--            --    sHsl.red   <= std_logic_vector(to_unsigned(2, 2)) & std_logic_vector(to_unsigned(uFs11Rgb.red,   6));
--            --    sHsl.green <= std_logic_vector(to_unsigned(2, 3)) & std_logic_vector(to_unsigned(uFs11Rgb.green, 5));
--            --    sHsl.blue  <= std_logic_vector(to_unsigned(2, 3)) & std_logic_vector(to_unsigned(uFs11Rgb.blue,  5));
--            --else
--                --if (uFs11Rgb.red >= 150) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(uFs11Rgb.red,   8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(uFs11Rgb.green, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(uFs11Rgb.blue,  8));
--                --elsif (uFs11Rgb.red >= 130  and uFs11Rgb.red <= 149) then
--                --    sHsl.red   <= std_logic_vector(to_unsigned(130, 8));
--                --    sHsl.green <= std_logic_vector(to_unsigned(130, 8));
--                --    sHsl.blue  <= std_logic_vector(to_unsigned(130, 8));
--                --elsif (uFs11Rgb.red >= 100  and uFs11Rgb.red <= 129) then
--                --    sHsl.red   <= std_logic_vector(to_unsigned(110, 8));
--                --    sHsl.green <= std_logic_vector(to_unsigned(110, 8));
--                --    sHsl.blue  <= std_logic_vector(to_unsigned(110, 8));
--                --elsif (uFs11Rgb.red >= 80  and uFs11Rgb.red <= 99) then
--                --    sHsl.red   <= std_logic_vector(to_unsigned(80, 8));
--                --    sHsl.green <= std_logic_vector(to_unsigned(80, 8));
--                --    sHsl.blue  <= std_logic_vector(to_unsigned(80, 8));
--                --elsif (uFs11Rgb.red >= 40  and uFs11Rgb.red <= 79) then
--                --    sHsl.red   <= std_logic_vector(to_unsigned(40, 8));
--                --    sHsl.green <= std_logic_vector(to_unsigned(40, 8));
--                --    sHsl.blue  <= std_logic_vector(to_unsigned(40, 8));
--                --elsif (uFs11Rgb.red >= 21  and uFs11Rgb.red <= 39) then
--                --    sHsl.red   <= std_logic_vector(to_unsigned(30, 8));
--                --    sHsl.green <= std_logic_vector(to_unsigned(30, 8));
--                --    sHsl.blue  <= std_logic_vector(to_unsigned(30, 8));
--                --elsif (uFs11Rgb.red >= 20 and uFs11Rgb.red <= 0) then
--                --    sHsl.red   <= std_logic_vector(to_unsigned(20, 8));
--                --    sHsl.green <= std_logic_vector(to_unsigned(20, 8));
--                --    sHsl.blue  <= std_logic_vector(to_unsigned(20, 8));
--                --end if;
--            --end if;
--        elsif((uFs11Rgb.green >= uFs11Rgb.red) and (uFs11Rgb.green >= uFs11Rgb.blue))then
--        
--               if (uFs11Rgb.green >= 150) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(uFs11Rgb.red,   8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(uFs11Rgb.green, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(uFs11Rgb.blue,  8));
--                elsif (uFs11Rgb.green >= 130  and uFs11Rgb.green <= 149) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(130, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(130, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(130, 8));
--                elsif (uFs11Rgb.green >= 100  and uFs11Rgb.green <= 129) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(110, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(110, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(110, 8));
--                elsif (uFs11Rgb.green >= 80  and uFs11Rgb.green <= 99) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(80, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(80, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(80, 8));
--                elsif (uFs11Rgb.green >= 40  and uFs11Rgb.green <= 79) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(40, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(40, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(40, 8));
--                elsif (uFs11Rgb.green >= 21  and uFs11Rgb.green <= 39) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(30, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(30, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(30, 8));
--                elsif (uFs11Rgb.green >= 20 and uFs11Rgb.green <= 0) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(20, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(20, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(20, 8));
--                end if;
--        
--            --if (uFs11Rgb.blue >= uFs11Rgb.red ) then
--            --    sHsl.red   <= std_logic_vector(to_unsigned(0, 2)) & std_logic_vector(to_unsigned(uFs11Rgb.red,   6));
--            --    sHsl.green <= std_logic_vector(to_unsigned(0, 1)) & std_logic_vector(to_unsigned(uFs11Rgb.green, 7));
--            --    sHsl.blue  <= std_logic_vector(to_unsigned(0, 3)) & std_logic_vector(to_unsigned(uFs11Rgb.blue,  5));
--            --else
--            --    if (uFs11Rgb.green >= 50) then
--            --        sHsl.red   <= std_logic_vector(to_unsigned(0, 2)) & std_logic_vector(to_unsigned(uFs11Rgb.red,   6));
--            --        sHsl.green <= std_logic_vector(to_unsigned(0, 3)) & std_logic_vector(to_unsigned(uFs11Rgb.green, 5));
--            --        sHsl.blue  <= std_logic_vector(to_unsigned(0, 3)) & std_logic_vector(to_unsigned(uFs11Rgb.blue,  5));
--            --    elsif (uFs11Rgb.green >= 40) then
--            --        sHsl.red   <= std_logic_vector(to_unsigned(40, 8));
--            --        sHsl.green <= std_logic_vector(to_unsigned(40, 8));
--            --        sHsl.blue  <= std_logic_vector(to_unsigned(40, 8));
--            --    elsif (uFs11Rgb.green >= 30) then
--            --        sHsl.red   <= std_logic_vector(to_unsigned(30, 8));
--            --        sHsl.green <= std_logic_vector(to_unsigned(30, 8));
--            --        sHsl.blue  <= std_logic_vector(to_unsigned(30, 8));
--            --    elsif (uFs11Rgb.green >= 20) then
--            --        sHsl.red   <= std_logic_vector(to_unsigned(20, 8));
--            --        sHsl.green <= std_logic_vector(to_unsigned(20, 8));
--            --        sHsl.blue  <= std_logic_vector(to_unsigned(20, 8));
--            --    else
--            --        sHsl.red   <= std_logic_vector(to_unsigned(10, 8));
--            --        sHsl.green <= std_logic_vector(to_unsigned(10, 8));
--            --        sHsl.blue  <= std_logic_vector(to_unsigned(10, 8));
--            --    end if;
--            --end if;
--        else
--               if (uFs11Rgb.blue >= 150) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(uFs11Rgb.red,   8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(uFs11Rgb.green, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(uFs11Rgb.blue,  8));
--                elsif (uFs11Rgb.blue >= 130  and uFs11Rgb.blue <= 149) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(130, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(130, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(130, 8));
--                elsif (uFs11Rgb.blue >= 100  and uFs11Rgb.blue <= 129) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(110, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(110, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(110, 8));
--                elsif (uFs11Rgb.blue >= 80  and uFs11Rgb.blue <= 99) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(80, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(80, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(80, 8));
--                elsif (uFs11Rgb.blue >= 40  and uFs11Rgb.blue <= 79) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(40, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(40, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(40, 8));
--                elsif (uFs11Rgb.blue >= 21  and uFs11Rgb.blue <= 39) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(30, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(30, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(30, 8));
--                elsif (uFs11Rgb.blue >= 20 and uFs11Rgb.blue <= 0) then
--                    sHsl.red   <= std_logic_vector(to_unsigned(20, 8));
--                    --sHsl.green <= std_logic_vector(to_unsigned(20, 8));
--                    --sHsl.blue  <= std_logic_vector(to_unsigned(20, 8));
--                end if;
--        
--         --if (uFs11Rgb.red  >= uFs11Rgb.green) then
--         --    sHsl.red   <= std_logic_vector(to_unsigned(0, 2)) & std_logic_vector(to_unsigned(uFs11Rgb.red,   6));
--         --    sHsl.green <= std_logic_vector(to_unsigned(0, 3)) & std_logic_vector(to_unsigned(uFs11Rgb.green, 5));
--         --    sHsl.blue  <= std_logic_vector(to_unsigned(0, 3)) & std_logic_vector(to_unsigned(uFs11Rgb.blue,  5));
--         --else
--         --   if (uFs11Rgb.blue >= 50) then
--         --        sHsl.red   <= std_logic_vector(to_unsigned(0, 2)) & std_logic_vector(to_unsigned(uFs11Rgb.red,   6));
--         --        sHsl.green <= std_logic_vector(to_unsigned(0, 3)) & std_logic_vector(to_unsigned(uFs11Rgb.green, 5));
--         --        sHsl.blue  <= std_logic_vector(to_unsigned(0, 3)) & std_logic_vector(to_unsigned(uFs11Rgb.blue,  5));
--         --    elsif (uFs11Rgb.blue >= 40) then
--         --        sHsl.red   <= std_logic_vector(to_unsigned(40, 8));
--         --        sHsl.green <= std_logic_vector(to_unsigned(40, 8));
--         --        sHsl.blue  <= std_logic_vector(to_unsigned(40, 8));
--         --    elsif (uFs11Rgb.blue >= 30) then
--         --        sHsl.red   <= std_logic_vector(to_unsigned(30, 8));
--         --        sHsl.green <= std_logic_vector(to_unsigned(30, 8));
--         --        sHsl.blue  <= std_logic_vector(to_unsigned(30, 8));
--         --    elsif (uFs11Rgb.blue >= 20) then
--         --        sHsl.red   <= std_logic_vector(to_unsigned(20, 8));
--         --        sHsl.green <= std_logic_vector(to_unsigned(20, 8));
--         --        sHsl.blue  <= std_logic_vector(to_unsigned(20, 8));
--         --    else
--         --        sHsl.red   <= std_logic_vector(to_unsigned(10, 8));
--         --        sHsl.green <= std_logic_vector(to_unsigned(10, 8));
--         --        sHsl.blue  <= std_logic_vector(to_unsigned(10, 8));
--         --    end if;
--         --end if;
--        end if;
--    end if;
--end process;
end behavioral;