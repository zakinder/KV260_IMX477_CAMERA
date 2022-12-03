-------------------------------------------------------------------------------
--
-- Filename    : hsvl_1range.vhd
-- Create Date : 05062019 [05-06-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
-- p ← RGB2HSV(p)
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity hsvl_1range is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end hsvl_1range;
architecture behavioral of hsvl_1range is
    signal uFs1Rgb       : intChannel;
    signal uFs2Rgb       : intChannel;
    signal uFs3Rgb       : intChannel;
    signal rgbMax        : integer;
    signal rgbMin        : integer;
    signal maxValue      : integer;
    signal rgbDelta      : integer;
    --H
    signal hue_quot      : ufixed(17 downto 0)  :=(others => '0');
    signal uuFiXhueQuot  : ufixed(17 downto -9) :=(others => '0');
    signal uuFiXhueTop   : ufixed(17 downto 0)  :=(others => '0');
    signal uuFiXhueBot   : ufixed(8 downto 0)   :=(others => '0');
    signal uFiXhueTop    : integer := zero;
    signal uFiXhueBot    : integer := zero;
    signal uFiXhueQuot   : integer := zero;
    signal hueQuot1x     : integer := zero;
    signal hueDeg        : integer := zero;
    signal hueDeg1x      : integer := zero;
    signal h_value       : integer := zero;
    --S
    signal s1value       : unsigned(7 downto 0);
    signal s2value       : unsigned(7 downto 0);
    signal s3value       : unsigned(7 downto 0);
    signal s4value       : unsigned(7 downto 0);
    signal s5value       : unsigned(7 downto 0);
    signal s6value       : unsigned(7 downto 0);
    signal s7value       : unsigned(7 downto 0);
    signal s8value       : unsigned(7 downto 0);
    --V
    signal v1value       : unsigned(7 downto 0);
    signal v2value       : unsigned(7 downto 0);
    signal v3value       : unsigned(7 downto 0);
    signal v4value       : unsigned(7 downto 0);
    signal v5value       : unsigned(7 downto 0);
    signal v6value       : unsigned(7 downto 0);
    signal v7value       : unsigned(7 downto 0);
    signal v8value       : unsigned(7 downto 0);
    --Valid
    signal valid1_rgb    : std_logic := '0';
    signal valid2_rgb    : std_logic := '0';
    signal valid3_rgb    : std_logic := '0';
    signal sHsl          : channel;
    signal rgb_ool4                : channel;
    signal rgb_colo                : rgbToSfRecord;
    signal rgb_oolo                : rgbToSfRecord;
    signal rgb_ool1                : rgbToSfRecord;
    signal rgb_ool2                : rgbToSf12Record;
    signal rgb_ool3                : rgbToSfRecord;

    
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
            hueDeg <= 0;
        if (uFs3Rgb.green >= uFs3Rgb.blue) then
            uFiXhueTop        <= (uFs3Rgb.green - uFs3Rgb.blue) * 10;
        else
            uFiXhueTop        <= (uFs3Rgb.blue - uFs3Rgb.green) * 10;
        end if;
    elsif(uFs3Rgb.green = maxValue)  then
            hueDeg <= 60;
        if (uFs3Rgb.blue >= uFs3Rgb.red ) then
            uFiXhueTop       <= (uFs3Rgb.blue - uFs3Rgb.red ) * 10;
        else
            uFiXhueTop       <= (uFs3Rgb.red  - uFs3Rgb.blue) * 10;
        end if;
    elsif(uFs3Rgb.blue = maxValue)  then
            hueDeg <= 120;
        if (uFs3Rgb.red  >= uFs3Rgb.green) then
            uFiXhueTop       <= (uFs3Rgb.red  - uFs3Rgb.green) * 10;
        else
            uFiXhueTop       <= (uFs3Rgb.green - uFs3Rgb.red ) * 10;
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
        hueQuot1x <= (uFiXhueQuot mod 45900) /255;
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
            s1value <= to_unsigned((255*rgbDelta)/rgbMax,8);
        else
            s1value <= to_unsigned(0, 8);
        end if;
    end if;
end process satValueP; 
process (clk) begin
    if rising_edge(clk) then
        s2value <= s1value;
        s3value <= s2value;
        s4value <= s3value;
        s5value <= s4value;
        s6value <= s5value;
        s7value <= s6value;
        s8value <= s7value;
        v2value <= v1value;
        v3value <= v2value;
        v4value <= v3value;
        v5value <= v4value;
        v6value <= v5value;
        v7value <= v6value;
        v8value <= v7value;
    end if;
end process;
-------------------------------------------------
-- VALUE
-------------------------------------------------
valValueP: process (clk) begin
    if rising_edge(clk) then
        v1value <= to_unsigned(rgbMax, 8);
    end if;
end process valValueP;
pipValidP: process (clk) begin
    if rising_edge(clk) then
        valid1_rgb    <= uFs3Rgb.valid;
        valid2_rgb    <= valid1_rgb;
        valid3_rgb    <= valid2_rgb;
    end if;
end process pipValidP;
        sHsl.red   <= std_logic_vector(to_unsigned(h_value, 8));
        sHsl.green <= std_logic_vector(s4value);
        sHsl.blue  <= std_logic_vector(v4value);
        sHsl.valid <= valid3_rgb;
rgb_ool1_inst: sync_frames
generic map(
    pixelDelay => 7)
port map(
    clk        => clk,
    reset      => reset,
    iRgb       => iRgb,
    oRgb       => rgb_ool4);
process (clk) begin
    if rising_edge(clk) then
        rgb_colo.red    <= to_sfixed("00" & sHsl.red,rgb_colo.red);
        rgb_colo.green  <= to_sfixed("00" & sHsl.green,rgb_colo.green);
        rgb_colo.blue   <= to_sfixed("00" & sHsl.blue,rgb_colo.blue);
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
pipRgbwD2P: process (clk) begin
    if rising_edge(clk) then
        oHsl.red   <= std_logic_vector(rgb_ool3.red(i_data_width-1 downto 0));
        oHsl.green <= std_logic_vector(rgb_ool3.green(i_data_width-1 downto 0));
        oHsl.blue  <= std_logic_vector(rgb_ool3.blue(i_data_width-1 downto 0));
        oHsl.valid <= rgb_ool4.valid;
    end if;
end process pipRgbwD2P;
end behavioral;