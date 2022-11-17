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
use work.vpf_records.all;
use work.ports_package.all;
entity hsl_c is
generic (
    i_data_width   : natural := 8);
port (
    clk                : in  std_logic;
    reset              : in  std_logic;
    iRgb               : in channel;
    config_number_31   : in integer;
    config_number_32   : in integer;
    config_number_33   : in integer;
    config_number_34   : in integer;
    config_number_35   : in integer;
    config_number_36   : in integer;
    config_number_37   : in integer;
    config_number_38   : in integer;
    config_number_39   : in integer;
    config_number_40   : in integer;
    config_number_41   : in integer;
    config_number_42   : in integer;
    oHueVal            : out std_logic;
    oHueRed            : out std_logic_vector(9 downto 0);
    oHueBlu            : out std_logic_vector(9 downto 0);
    oHueGre            : out std_logic_vector(9 downto 0);
    oHueTop            : out std_logic_vector(23 downto 0);
    oHueBot            : out std_logic_vector(9 downto 0);
    oHueQut            : out std_logic_vector(9 downto 0);
    oHueDeg            : out std_logic_vector(9 downto 0);
    oHueOut            : out std_logic_vector(9 downto 0);
    oHsl               : out channel);
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
begin
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
        rgb_delta      <= (rgb_max - rgb_min); --output rgb_delta 3 clks
        rgb_delta_1    <= (rgb_max - rgb_min);
        rgb_delta_sum  <= (rgb_max + rgb_min);
    end if;
end process rgbDeltaP;
--s2_axis_dividend_tdata <= std_logic_vector(to_unsigned((rgb_delta_sum),16));
--s2_axis_divisor_tdata  <= std_logic_vector(to_unsigned((rgb_delta_1),16));
--saturate_divider_inst: divider
--  port map (
--    aclk                      => clk,
--    s_axis_dividend_tvalid    => s2_axis_dividend_tvalid,
--    s_axis_dividend_tdata     => s2_axis_dividend_tdata,
--    s_axis_divisor_tvalid     => s2_axis_divisor_tvalid,
--    s_axis_divisor_tdata      => s2_axis_divisor_tdata,
--    m_axis_dout_tvalid        => m2_axis_dout_tvalid,
--    m_axis_dout_tdata         => m2_axis_dout_tdata);
--rgb_delta_max_2 <= to_integer(unsigned(m2_axis_dout_tdata(31 downto 16)));
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
        if (rgb_sync_3.green >= rgb_sync_3.blue) then
            hue_degree           <= 0;                                                          --0   ---\
            hue_numerator        <= abs(rgb_sync_3.green - rgb_sync_3.blue) * config_number_33; --170 ----= 170
        else
            hue_degree           <= config_number_32;                                           --0   ---\
            hue_numerator        <= abs(rgb_sync_3.blue - rgb_sync_3.green) * config_number_34; --341 ----= 341
        end if;
    elsif(rgb_sync_3.green = rgb_max_value)  then
        if (rgb_sync_3.blue >= rgb_sync_3.red ) then
            hue_degree          <= config_number_35;                                            --512 ---\
            hue_numerator       <= abs(rgb_sync_3.blue - rgb_sync_3.red) * config_number_37;    --170 ----= 682
        else
            hue_degree          <= config_number_36;                                            --341 ---\
            hue_numerator       <= abs(rgb_sync_3.red  - rgb_sync_3.blue) * config_number_38;   --341 ----= 682
        end if;
    elsif(rgb_sync_3.blue = rgb_max_value)  then
        if (rgb_sync_3.red  >= rgb_sync_3.green) then
            hue_degree          <= config_number_39;                                            --853 ---\
            hue_numerator       <= abs(rgb_sync_3.red  - rgb_sync_3.green) * config_number_41;  --170 ----= 1023
        else
            hue_degree          <= config_number_40;                                            --682 ---\
            hue_numerator       <= abs(rgb_sync_3.green - rgb_sync_3.red ) * config_number_42;  --341 ----= 1023
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
hue_quotient <= to_integer(unsigned(m_axis_dout_tdata(31 downto 16)));
-------------------------------------------------
oHueVal <= rgbSyncValid(22);
oHueRed <= std_logic_vector(to_unsigned(hue, 10));
oHueBlu <= std_logic_vector(to_unsigned(hsync(18).sat, 10));
oHueGre <= std_logic_vector(to_unsigned(hsync(19).lum, 10));
oHueTop <= std_logic_vector(to_unsigned((hue_numerator),24));
oHueBot <= std_logic_vector(to_unsigned((hue_denominator),10));
oHueQut <= std_logic_vector(to_unsigned((hue_quotient),10));
oHueDeg <= m_axis_dout_tdata(9 downto 0);
oHueOut <= std_logic_vector(to_unsigned((hue),10));
-------------------------------------------------
hue  <= hue_quotient + hue_degree;
-------------------------------------------------
-- SATURATE
-------------------------------------------------
process(rgb_delta)begin
    if (rgb_delta < 1024) then
        rgb_delta_max     <= rgb_delta;
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
process (clk)begin
    if rising_edge(clk) then
      rgbSyncValid(0)   <= iRgb.valid;
      rgbSyncValid(1)   <= rgbSyncValid(0);
      rgbSyncValid(2)   <= rgbSyncValid(1);
      rgbSyncValid(3)   <= rgbSyncValid(2);
      rgbSyncValid(4)   <= rgbSyncValid(3);
      rgbSyncValid(5)   <= rgbSyncValid(4);
      rgbSyncValid(6)   <= rgbSyncValid(5);
      rgbSyncValid(7)   <= rgbSyncValid(6);
      rgbSyncValid(8)   <= rgbSyncValid(7);
      rgbSyncValid(9)   <= rgbSyncValid(8);
      rgbSyncValid(10)  <= rgbSyncValid(9);
      rgbSyncValid(11)  <= rgbSyncValid(10);
      rgbSyncValid(12)  <= rgbSyncValid(11);
      rgbSyncValid(13)  <= rgbSyncValid(12);
      rgbSyncValid(14)  <= rgbSyncValid(13);
      rgbSyncValid(15)  <= rgbSyncValid(14);
      rgbSyncValid(16)  <= rgbSyncValid(15);
      rgbSyncValid(17)  <= rgbSyncValid(16);
      rgbSyncValid(18)  <= rgbSyncValid(17);
      rgbSyncValid(19)  <= rgbSyncValid(18);
      rgbSyncValid(20)  <= rgbSyncValid(19);
      rgbSyncValid(21)  <= rgbSyncValid(20);
      rgbSyncValid(22)  <= rgbSyncValid(21);
      rgbSyncValid(23)  <= rgbSyncValid(22);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEol(0)   <= iRgb.eol;
      rgbSyncEol(1)   <= rgbSyncEol(0);
      rgbSyncEol(2)   <= rgbSyncEol(1);
      rgbSyncEol(3)   <= rgbSyncEol(2);
      rgbSyncEol(4)   <= rgbSyncEol(3);
      rgbSyncEol(5)   <= rgbSyncEol(4);
      rgbSyncEol(6)   <= rgbSyncEol(5);
      rgbSyncEol(7)   <= rgbSyncEol(6);
      rgbSyncEol(8)   <= rgbSyncEol(7);
      rgbSyncEol(9)   <= rgbSyncEol(8);
      rgbSyncEol(10)  <= rgbSyncEol(9);
      rgbSyncEol(11)  <= rgbSyncEol(10);
      rgbSyncEol(12)  <= rgbSyncEol(11);
      rgbSyncEol(13)  <= rgbSyncEol(12);
      rgbSyncEol(14)  <= rgbSyncEol(13);
      rgbSyncEol(15)  <= rgbSyncEol(14);
      rgbSyncEol(16)  <= rgbSyncEol(15);
      rgbSyncEol(17)  <= rgbSyncEol(16);
      rgbSyncEol(18)  <= rgbSyncEol(17);
      rgbSyncEol(19)  <= rgbSyncEol(18);
      rgbSyncEol(20)  <= rgbSyncEol(19);
      rgbSyncEol(21)  <= rgbSyncEol(20);
      rgbSyncEol(22)  <= rgbSyncEol(21);
      rgbSyncEol(23)  <= rgbSyncEol(22);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncSof(0)   <= iRgb.sof;
      rgbSyncSof(1)   <= rgbSyncSof(0);
      rgbSyncSof(2)   <= rgbSyncSof(1);
      rgbSyncSof(3)   <= rgbSyncSof(2);
      rgbSyncSof(4)   <= rgbSyncSof(3);
      rgbSyncSof(5)   <= rgbSyncSof(4);
      rgbSyncSof(6)   <= rgbSyncSof(5);
      rgbSyncSof(7)   <= rgbSyncSof(6);
      rgbSyncSof(8)   <= rgbSyncSof(7);
      rgbSyncSof(9)   <= rgbSyncSof(8);
      rgbSyncSof(10)  <= rgbSyncSof(9);
      rgbSyncSof(11)  <= rgbSyncSof(10);
      rgbSyncSof(12)  <= rgbSyncSof(11);
      rgbSyncSof(13)  <= rgbSyncSof(12);
      rgbSyncSof(14)  <= rgbSyncSof(13);
      rgbSyncSof(15)  <= rgbSyncSof(14);
      rgbSyncSof(16)  <= rgbSyncSof(15);
      rgbSyncSof(17)  <= rgbSyncSof(16);
      rgbSyncSof(18)  <= rgbSyncSof(17);
      rgbSyncSof(19)  <= rgbSyncSof(18);
      rgbSyncSof(20)  <= rgbSyncSof(19);
      rgbSyncSof(21)  <= rgbSyncSof(20);
      rgbSyncSof(22)  <= rgbSyncSof(21);
      rgbSyncSof(23)  <= rgbSyncSof(22);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEof(0)   <= iRgb.eof;
      rgbSyncEof(1)   <= rgbSyncEof(0);
      rgbSyncEof(2)   <= rgbSyncEof(1);
      rgbSyncEof(3)   <= rgbSyncEof(2);
      rgbSyncEof(4)   <= rgbSyncEof(3);
      rgbSyncEof(5)   <= rgbSyncEof(4);
      rgbSyncEof(6)   <= rgbSyncEof(5);
      rgbSyncEof(7)   <= rgbSyncEof(6);
      rgbSyncEof(8)   <= rgbSyncEof(4);
      rgbSyncEof(9)   <= rgbSyncEof(8);
      rgbSyncEof(10)  <= rgbSyncEof(9);
      rgbSyncEof(11)  <= rgbSyncEof(10);
      rgbSyncEof(12)  <= rgbSyncEof(11);
      rgbSyncEof(13)  <= rgbSyncEof(12);
      rgbSyncEof(14)  <= rgbSyncEof(13);
      rgbSyncEof(15)  <= rgbSyncEof(14);
      rgbSyncEof(16)  <= rgbSyncEof(15);
      rgbSyncEof(17)  <= rgbSyncEof(16);
      rgbSyncEof(18)  <= rgbSyncEof(17);
      rgbSyncEof(19)  <= rgbSyncEof(18);
      rgbSyncEof(20)  <= rgbSyncEof(19);
      rgbSyncEof(21)  <= rgbSyncEof(20);
      rgbSyncEof(22)  <= rgbSyncEof(21);
      rgbSyncEof(23)  <= rgbSyncEof(22);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(config_number_31=0)then
            oHsl.red   <= std_logic_vector(to_unsigned(hue, 10));
            oHsl.green <= std_logic_vector(to_unsigned(hsync(18).sat, 10));
            oHsl.blue  <= std_logic_vector(to_unsigned(hsync(19).lum, 10));
        elsif(config_number_31=1)then
            oHsl.red   <= std_logic_vector(to_unsigned(hue, 10));
            oHsl.green <= std_logic_vector(to_unsigned(1023,10));
            oHsl.blue  <= std_logic_vector(to_unsigned(1023,10));
        elsif(config_number_31=2)then
            oHsl.red   <= std_logic_vector(to_unsigned(1023, 10));
            oHsl.green <= std_logic_vector(to_unsigned(hsync(18).sat, 10));
            oHsl.blue  <= std_logic_vector(to_unsigned(1023,10));
        elsif(config_number_31=3)then
            oHsl.red   <= std_logic_vector(to_unsigned(1023,10));
            oHsl.green <= std_logic_vector(to_unsigned(1023,10));
            oHsl.blue  <= std_logic_vector(to_unsigned(hsync(19).lum, 10));
        elsif(config_number_31=4)then
            oHsl.red     <= std_logic_vector(to_unsigned(hue, 10));
            oHsl.green   <= std_logic_vector(to_unsigned(hue, 10));
            oHsl.blue    <= std_logic_vector(to_unsigned(hue, 10));
        elsif(config_number_31=5)then
            oHsl.red   <= std_logic_vector(to_unsigned(hsync(18).sat, 10));
            oHsl.green <= std_logic_vector(to_unsigned(hsync(18).sat, 10));
            oHsl.blue  <= std_logic_vector(to_unsigned(hsync(18).sat, 10));
        else
            oHsl.red    <= std_logic_vector(to_unsigned(hsync(19).lum, 10));
            oHsl.green  <= std_logic_vector(to_unsigned(hsync(19).lum, 10));
            oHsl.blue   <= std_logic_vector(to_unsigned(hsync(19).lum, 10));
        end if;
    end if;
end process;
    oHsl.valid <= rgbSyncValid(22);
    oHsl.eol   <= rgbSyncEol(22);
    oHsl.sof   <= rgbSyncSof(22);
    oHsl.eof   <= rgbSyncEof(22);
end behavioral;