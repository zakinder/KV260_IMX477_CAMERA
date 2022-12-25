-------------------------------------------------------------------------------
--
-- Filename    : rgb2hsv.vhd
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
use work.vpf_records.all;
use work.ports_package.all;
entity rgb2hsv is
port (
    clk                : in  std_logic;
    reset              : in  std_logic;
    iRgb               : in channel;
    oHsl               : out channel);
end rgb2hsv;
architecture behavioral of rgb2hsv is
    signal rgb_sync_1                : intChannel;
    signal rgb_sync_2                : intChannel;
    signal rgb_sync_3                : intChannel;
    signal rgb_max                   : natural := zero;
    signal rgb_min                   : natural := zero;
    signal rgb_max_value             : natural := zero;
    signal rgb_delta                 : natural := zero;
    signal rgb_delta_1               : integer := zero;
    signal rgb_delta_sum             : natural := zero;
    signal rgb_delta_max_2           : natural := zero;
    signal rgb_delta_max             : natural := zero;
    signal hsync                     : hueArray(0 to 19);
    --H
    signal hue_quotient       : natural;
    signal hue_numerator      : natural := 1;
    signal hue_denominator    : natural := 1;
    signal hue_degree         : natural := 1;
    signal hue                : natural := 1;
    --S
    signal saturate           : natural;
    --V
    signal luminosity         : natural;
    --Valid
    signal rgbSyncValid             : std_logic_vector(23 downto 0) := x"000000";
    signal rgbSyncEol               : std_logic_vector(23 downto 0) := x"000000";
    signal rgbSyncSof               : std_logic_vector(23 downto 0) := x"000000";
    signal rgbSyncEof               : std_logic_vector(23 downto 0) := x"000000";
    signal s_axis_dividend_tvalid   : std_logic := '1';
    signal s_axis_dividend_tdata    : std_logic_vector(15 downto 0) := (others => 'X');
    signal s_axis_divisor_tvalid    : std_logic := '1';
    signal s_axis_divisor_tdata     : std_logic_vector(31 downto 0) := (others => 'X');
    signal m_axis_dout_tvalid       : std_logic := '0';
    signal m_axis_dout_tdata        : std_logic_vector(31 downto 0) := (others => '0');
    signal s2_axis_dividend_tvalid  : std_logic := '1';
    signal s2_axis_dividend_tdata   : std_logic_vector(15 downto 0) := (others => 'X');
    signal s2_axis_divisor_tvalid   : std_logic := '1';
    signal s2_axis_divisor_tdata    : std_logic_vector(15 downto 0) := (others => 'X');
    signal m2_axis_dout_tvalid      : std_logic := '0';
    signal m2_axis_dout_tdata       : std_logic_vector(31 downto 0) := (others => '0');
    signal h_divided : std_logic_vector(16 downto 0);
    signal h_divisor : std_logic_vector(7 downto 0);
    signal h_result : std_logic_vector(8 downto 0);
    
begin
process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= iRgb.valid;
        for i in 0 to 22 loop
          rgbSyncValid(i+1)  <= rgbSyncValid(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEol(0)  <= iRgb.eol;
        for i in 0 to 22 loop
          rgbSyncEol(i+1)  <= rgbSyncEol(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncSof(0)  <= iRgb.sof;
        for i in 0 to 22 loop
          rgbSyncSof(i+1)  <= rgbSyncSof(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEof(0)  <= iRgb.eof;
        for i in 0 to 22 loop
          rgbSyncEof(i+1)  <= rgbSyncEof(i);
        end loop;
    end if;
end process;
hsync(0).hue      <= hue;
hsync(0).lum      <= luminosity;
hsync(0).sat      <= saturate;
process (clk) begin
    if rising_edge(clk) then
        hsync(1)          <= hsync(0);
        hsync(2)          <= hsync(1);
        hsync(3)          <= hsync(2);
        hsync(4)          <= hsync(3);
        hsync(5)          <= hsync(4);
        hsync(6)          <= hsync(5);
        hsync(7)          <= hsync(6);
        hsync(8)          <= hsync(7);
        hsync(9)          <= hsync(8);
        hsync(10)         <= hsync(9);
        hsync(11)         <= hsync(10);
        hsync(12)         <= hsync(11);
        hsync(13)         <= hsync(12);
        hsync(14)         <= hsync(13);
        hsync(15)         <= hsync(14);
        hsync(16)         <= hsync(15);
        hsync(17)         <= hsync(16);
        hsync(18)         <= hsync(17);
        hsync(19)         <= hsync(18);
    end if;
end process;
rgbToUfP: process (clk,reset)begin
    if (reset = lo) then
        rgb_sync_1.red    <= zero;
        rgb_sync_1.green  <= zero;
        rgb_sync_1.blue   <= zero;
    elsif rising_edge(clk) then
        rgb_sync_1.red    <= to_integer(unsigned(iRgb.red(9 downto 2)));
        rgb_sync_1.green  <= to_integer(unsigned(iRgb.green(9 downto 2)));
        rgb_sync_1.blue   <= to_integer(unsigned(iRgb.blue(9 downto 2)));
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
        rgb_delta      <= (rgb_max - rgb_min); --output rgb_delta 3 clks
        rgb_delta_1    <= (rgb_max);
        rgb_delta_sum  <= (rgb_max + rgb_min);
    end if;
end process rgbDeltaP;

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
-- IF (RED== RGB.MAX) *H = 0 + ( GRE - BLU ) / RGB.∆; BETWEEN CYAN & YELLOW & MAGENTA
-- IF (GRE== RGB.MAX) *H = 2 + ( BLU - RED ) / RGB.∆; BETWEEN MAGENTA & CYAN & YELLOW
-- IF (BLU== RGB.MAX) *H = 4 + ( RED - GRE ) / RGB.∆; BETWEEN YELLOW & MAGENTA & CYAN
-------------------------------------------------
hueP: process (clk) begin
  if rising_edge(clk) then
    if (rgb_sync_3.red  = rgb_max_value) then
            hue_degree <= 0;
            hue_numerator        <= abs(rgb_sync_3.green - rgb_sync_3.blue) * 43;
    elsif(rgb_sync_3.green = rgb_max_value)  then
            hue_degree <= 86;
            hue_numerator       <= abs(rgb_sync_3.red  - rgb_sync_3.blue) * 43;
    elsif(rgb_sync_3.blue = rgb_max_value)  then
            hue_degree <= 171;
            hue_numerator       <= abs(rgb_sync_3.green - rgb_sync_3.red ) * 43;
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
            hue_denominator <= rgb_delta; -- output 4clks
        else
            hue_denominator <= 6;
        end if;
    end if;
end process hueBottomP;
-------------------------------------------------
-- HUE DIVISION 4+18=22
-------------------------------------------------
s_axis_divisor_tdata  <= std_logic_vector(to_unsigned((hue_numerator),32));   -- 4 clks at this point
s_axis_dividend_tdata <= std_logic_vector(to_unsigned((hue_denominator),16)); -- 4 clks at this point


divider_inst: divider
  port map (
    aclk                      => clk,
    s_axis_dividend_tvalid    => s_axis_dividend_tvalid,
    s_axis_dividend_tdata     => s_axis_dividend_tdata,
    s_axis_divisor_tvalid     => s_axis_divisor_tvalid,
    s_axis_divisor_tdata      => s_axis_divisor_tdata,
    m_axis_dout_tvalid        => m_axis_dout_tvalid,
    m_axis_dout_tdata         => m_axis_dout_tdata);
    
-- h_divisor  <= std_logic_vector(to_unsigned((hue_numerator),8));   -- 4 clks at this point
-- h_divided  <= std_logic_vector(to_unsigned((hue_denominator),17)); -- 4 clks at this point
-- div_16_instance : div16_8_8
-- generic map (
   -- A_WIDTH          => 17,
   -- B_WIDTH          => 8,
   -- RESULT_WIDTH     => 9)
-- port map(
    -- clk    => clk,
    -- en     => '1',
    -- rstn   => reset,
    -- a      => h_divided,
    -- b      => h_divisor,
    -- result => h_result);
--hue_quotient <= to_integer(unsigned(h_result));
--hue_quotient <= hue_numerator / hue_denominator;
--hue_quotient <= hue_numerator / hue_denominator;
hue_quotient <= to_integer(unsigned(m_axis_dout_tdata(31 downto 16)));
-------------------------------------------------
hue  <= hue_quotient + hue_degree;
-------------------------------------------------
-- SATURATE
-------------------------------------------------
process(rgb_delta_1,rgb_delta)begin
    if (rgb_delta_1 > 0) then
        rgb_delta_max     <= (rgb_delta*255) / rgb_delta_1;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgb_max /= 0)then
            saturate <= rgb_delta_max; --output 4 clks ... need to make it 22 inorder to sync with rgb
        else
            saturate <= 0;
        end if;
    end if;
end process; 
-------------------------------------------------
-- VALUE
-------------------------------------------------
valValueP: process (clk) begin
    if rising_edge(clk) then
        luminosity <= (rgb_max + rgb_min) /2;-- output 3clks ... need to make it 22 inorder to sync with rgb
    end if;
end process valValueP;
-------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
       oHsl.red   <= std_logic_vector(to_unsigned(hsync(0).hue, 8)) & "00";
       oHsl.green <= std_logic_vector(to_unsigned(hsync(0).sat, 8)) & "00";
       oHsl.blue  <= std_logic_vector(to_unsigned(hsync(0).lum, 8)) & "00";
    end if;
end process;
    oHsl.valid <= rgbSyncValid(22);
    oHsl.eol   <= rgbSyncEol(22);
    oHsl.sof   <= rgbSyncSof(22);
    oHsl.eof   <= rgbSyncEof(22);
end behavioral;