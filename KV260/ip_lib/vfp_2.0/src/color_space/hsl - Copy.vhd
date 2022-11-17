-------------------------------------------------------------------------------
--
-- Filename    : hsl_c.vhd
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
    signal rgb_sync_n           : rgbToUfRecord;
    signal rgb_sync_1           : rgb_to_uf_record;
    signal rgb_sync_2           : rgb_to_uf_record;
    signal rgb_sync_3           : rgb_to_uf_record;
    signal rgb_max              : ufixed(0 downto -8) :=(others => '0');
    signal rgb_min              : ufixed(0 downto -8) :=(others => '0');
    signal rgb_max_value        : ufixed(0 downto -8) :=(others => '0');
    signal rgb_delta            : ufixed(1 downto -8) :=(others => '0');
    signal rgb_delta_1          : ufixed(1 downto -8) :=(others => '0');
    signal rgb_delta_sum        : ufixed(1 downto -8) :=(others => '0');
    signal rgb_delta_max        : ufixed(9 downto -9) :=(others => '0');
    signal rgb_delta_quotient_1 : ufixed(17 downto -9):=(others => '0');
    signal rgb_delta_quotient_2 : ufixed(8 downto -9) :=(others => '0');
    signal rgb_delta_quot_1     : ufixed(8 downto -9) :=(others => '0');
    signal rgb_delta_quot_2     : ufixed(8 downto -9) :=(others => '0');
    ----H
    signal hue_quotient         : ufixed(1 downto -8) :=(others => '0');
    signal hue_numerator        : ufixed(0 downto -8) :=(others => '0');
    signal hue_denominator      : ufixed(1 downto -8) :=(others => '0');
    signal hue_quotient_value   : ufixed(1 downto -8) :=(others => '0');
    signal hue_degree           : ufixed(7 downto 0)  :=(others => '0');
    signal hue_degree_sync      : ufixed(7 downto 0)  :=(others => '0');
    --signal hue_result         : natural := zero;
    signal hue                  : ufixed(8 downto -8) :=(others => '0');
    ----S
    signal saturate             : unsigned(7 downto 0):=(others => '0');
    signal saturate_sync1       : unsigned(7 downto 0):=(others => '0');
    signal saturate_sync2       : unsigned(7 downto 0):=(others => '0');
    ----V
    signal luminosity           : ufixed(7 downto -9) :=(others => '0');
    signal luminosity_value     : ufixed(8 downto -9) :=(others => '0');
    signal luminosity_sync1     : unsigned(7 downto 0):=(others => '0');
    signal luminosity_sync2     : unsigned(7 downto 0):=(others => '0');
    ----Valid
    signal valid1_rgb           : std_logic := '0';
    signal valid2_rgb           : std_logic := '0';
    signal valid3_rgb           : std_logic := '0';
    signal valid4_rgb           : std_logic := '0';
    signal valid5_rgb           : std_logic := '0';
    signal valid6_rgb           : std_logic := '0';
    signal valid7_rgb           : std_logic := '0';
    signal valid8_rgb           : std_logic := '0';
begin
rgbToUfP: process (clk)begin
    if rising_edge(clk) then
        rgb_sync_n.red    <= to_ufixed(iRgb.red,rgb_sync_n.red);
        rgb_sync_n.green  <= to_ufixed(iRgb.green,rgb_sync_n.green);
        rgb_sync_n.blue   <= to_ufixed(iRgb.blue,rgb_sync_n.blue);
        rgb_sync_n.valid  <= iRgb.valid;
    end if;
end process rgbToUfP;
rgb_sync_1.red    <= resize((rgb_sync_n.red /255),rgb_sync_1.red);
rgb_sync_1.green  <= resize((rgb_sync_n.green /255),rgb_sync_1.green);
rgb_sync_1.blue   <= resize((rgb_sync_n.blue /255),rgb_sync_1.blue);
rgb_sync_1.valid  <= rgb_sync_n.valid;
---- RGB.max = max(R, G, B)
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
        rgb_delta      <= resize((rgb_max - rgb_min),rgb_delta);
        rgb_delta_1    <= resize((to_ufixed(1.0,7,0) - rgb_max - rgb_min),rgb_delta_1);
        rgb_delta_sum  <= resize((rgb_max + rgb_min),rgb_delta_sum);
    end if;
end process rgbDeltaP;
rgb_delta_quotient_1        <= resize((rgb_delta/rgb_delta_1),rgb_delta_quotient_1);
rgb_delta_quotient_2        <= resize((rgb_delta/rgb_delta_sum),rgb_delta_quotient_2);
rgb_delta_quot_1            <= resize(rgb_delta_quotient_1,rgb_delta_quot_1);
rgb_delta_quot_2            <= resize(rgb_delta_quotient_2,rgb_delta_quot_2);
process(rgb_delta_quot_1,rgb_delta_quot_2)begin
    if (rgb_delta_quot_1 <= 0.50) then
        rgb_delta_max     <= resize((rgb_delta_quot_2*255),rgb_delta_max);
    else
        rgb_delta_max     <= resize((rgb_delta_quot_1*255),rgb_delta_max);
    end if;
end process;
---------------------------------------------------
pipRgbD2P: process (clk) begin
    if rising_edge(clk) then
        rgb_sync_2 <= rgb_sync_1;
        rgb_sync_3 <= rgb_sync_2;
    end if;
end process pipRgbD2P;
---------------------------------------------------
---- HUE
---- RGB.∆ = RGB.MAX − RGB.MIN
---- IF (RED== RGB.MAX) *H = 0 + ( GRE - BLU ) / RGB.∆; BETWEEN ← YELLOW & MAGENTA
---- IF (GRE== RGB.MAX) *H = 2 + ( BLU - RED ) / RGB.∆; BETWEEN ← CYAN & YELLOW
---- IF (BLU== RGB.MAX) *H = 4 + ( RED - GRE ) / RGB.∆; BETWEEN ← MAGENTA & CYAN
---------------------------------------------------
hueP: process (clk) begin
  if rising_edge(clk) then
    if (rgb_sync_3.red  = rgb_max_value) then
        if (rgb_sync_3.green >= rgb_sync_3.blue) then
            hue_degree <= to_ufixed(0.00,7,0);
            hue_numerator        <= resize((rgb_sync_3.green - rgb_sync_3.blue),hue_numerator);
        else
            hue_degree <= to_ufixed(1.00,7,0);
            hue_numerator        <= resize((rgb_sync_3.blue - rgb_sync_3.green),hue_numerator);
        end if;
    elsif(rgb_sync_3.green = rgb_max_value)  then
        if (rgb_sync_3.blue >= rgb_sync_3.red ) then
            hue_degree <= to_ufixed(2.00,7,0);
            hue_numerator       <= resize((rgb_sync_3.blue - rgb_sync_3.red ),hue_numerator);
        else
            hue_degree <= to_ufixed(3.00,7,0);
            hue_numerator       <= resize((rgb_sync_3.red  - rgb_sync_3.blue),hue_numerator);
        end if;
    elsif(rgb_sync_3.blue = rgb_max_value)  then
        if (rgb_sync_3.red  >= rgb_sync_3.green) then
            hue_degree <= to_ufixed(4.00,7,0);
            hue_numerator       <= resize((rgb_sync_3.red  - rgb_sync_3.green),hue_numerator);
        else
            hue_degree <= to_ufixed(5.00,7,0);
            hue_numerator       <= resize((rgb_sync_3.green - rgb_sync_3.red ),hue_numerator);
        end if;
    end if;
  end if;
end process hueP;
--
---------------------------------------------------
---- HUE
---- RGB.∆ = RGB.max − RGB.min
---------------------------------------------------
hueBottomP: process (clk) begin
    if rising_edge(clk) then
        if (rgb_delta > 0) then
            hue_denominator <= rgb_delta;
        else
            hue_denominator <= to_ufixed(3.0,1,-8);
        end if;
    end if;
end process hueBottomP;
---------------------------------------------------
---- HUE DIVISION
---------------------------------------------------
hue_quotient  <= resize((hue_numerator / hue_denominator),hue_quotient);
---------------------------------------------------
hueDegreeP: process (clk) begin
    if rising_edge(clk) then
        hue_degree_sync  <= hue_degree;
    end if;
end process hueDegreeP;
hueDividerResizeP: process (clk) begin
    if rising_edge(clk) then
        hue_quotient_value  <= hue_quotient;
    end if;
end process hueDividerResizeP;
hue  <= resize(((hue_quotient_value + hue_degree_sync) * 42),hue);
---------------------------------------------------
---- SATURATE
---------------------------------------------------     
satValueP: process (clk) begin
    if rising_edge(clk) then
        if(rgb_max /= 0)then
            saturate <= to_unsigned((rgb_delta_max),8);
        else
            saturate <= to_unsigned(0, 8);
        end if;
    end if;
end process satValueP; 
---------------------------------------------------
---- VALUE
---------------------------------------------------
valValueP: process (clk) begin
    if rising_edge(clk) then
        luminosity <= resize(((rgb_max + rgb_min) /2),luminosity);
    end if;
end process valValueP;
        luminosity_value <= resize(luminosity*255,luminosity_value);
process (clk) begin
    if rising_edge(clk) then
        luminosity_sync1 <= to_unsigned(luminosity_value, 8);
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
        luminosity_sync2 <= luminosity_sync1;
        saturate_sync1   <= saturate;
        saturate_sync2   <= saturate_sync1;
    end if;
end process;
oHsl.red   <= std_logic_vector(to_unsigned(hue, 8));
oHsl.green <= std_logic_vector(saturate_sync2);
oHsl.blue  <= std_logic_vector(luminosity_sync2);
oHsl.valid <= valid4_rgb;
end behavioral;