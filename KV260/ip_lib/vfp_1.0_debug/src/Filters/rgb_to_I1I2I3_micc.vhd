-------------------------------------------------------------------------------
--
-- Filename    : rgb_to_I1I2I3_micc.vhd
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

entity rgb_to_I1I2I3_micc is
generic (
    i_data_width   : natural := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end rgb_to_I1I2I3_micc;

architecture behavioral of rgb_to_I1I2I3_micc is


    signal rgb_sync_1           : intChannel;
    signal rgb_sync_2           : intChannel;
    signal rgb_sync_3           : intChannel;


    signal i1_numerator         : integer;
    signal i1_denominator       : integer;
    signal i1_quotient          : integer;
    signal i1_value             : integer;
    signal i2_numerator         : integer;
    signal i2_denominator       : integer;
    signal i2_quotient          : integer;
    signal i2_value             : integer;
    signal i3_numerator         : integer;
    signal i3_denominator       : integer;
    signal i3_quotient          : integer;
    signal i3_value             : integer;


    signal red_gre              : integer;
    signal gre_blu              : integer;
    signal blu_red              : integer;
    
    signal red_gre_sqr          : integer;
    signal gre_blu_sqr          : integer;
    signal blu_red_sqr          : integer;
    
begin

process (clk)begin
    if rising_edge(clk) then
        rgb_sync_1.red    <= to_integer(unsigned(iRgb.red));
        rgb_sync_1.green  <= to_integer(unsigned(iRgb.green));
        rgb_sync_1.blue   <= to_integer(unsigned(iRgb.blue));
        rgb_sync_1.valid  <= iRgb.valid;
    end if;
end process;





process (clk) begin
    if rising_edge(clk) then
        rgb_sync_2 <= rgb_sync_1;
        rgb_sync_3 <= rgb_sync_2;
    end if;
end process;


process (rgb_sync_1) begin
    if (rgb_sync_1.red >= rgb_sync_1.green) then
        red_gre <= rgb_sync_1.red - rgb_sync_1.green;
    else
        red_gre <= rgb_sync_1.green - rgb_sync_1.red;
    end if;
end process;

process (rgb_sync_1) begin
    if (rgb_sync_1.green >= rgb_sync_1.blue) then
        gre_blu <= rgb_sync_1.green - rgb_sync_1.blue;
    else
        gre_blu <= rgb_sync_1.blue - rgb_sync_1.green;
    end if;
end process;

process (rgb_sync_1) begin
    if (rgb_sync_1.blue >= rgb_sync_1.red) then
        blu_red <= rgb_sync_1.blue - rgb_sync_1.red;
    else
        blu_red <= rgb_sync_1.red - rgb_sync_1.blue;
    end if;
end process;



process (clk) begin
    if rising_edge(clk) then
        red_gre_sqr <= red_gre * red_gre;
        gre_blu_sqr <= gre_blu * gre_blu;
        blu_red_sqr <= blu_red * blu_red;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        i1_numerator        <= red_gre_sqr;
        i1_denominator      <= red_gre_sqr + gre_blu_sqr + blu_red_sqr;
    end if;
end process;

        i1_quotient         <= ((i1_numerator/i1_denominator)) when i1_denominator /= 0;
        i1_value            <= i1_quotient;

process (clk) begin
    if rising_edge(clk) then
        i2_numerator        <= blu_red_sqr;
        i2_denominator      <= red_gre_sqr + gre_blu_sqr + blu_red_sqr;
    end if;
end process;

        i2_quotient         <= ((i2_numerator/i2_denominator)) when i2_denominator /= 0;
        i2_value            <= i2_quotient;

process (clk) begin
    if rising_edge(clk) then
        i3_numerator        <= gre_blu_sqr;
        i3_denominator      <= red_gre_sqr + gre_blu_sqr + blu_red_sqr;
    end if;
end process;

        i3_quotient         <= ((i3_numerator/i3_denominator)) when i3_denominator /= 0;
        i3_value            <= i3_quotient;

oRgb.red   <= std_logic_vector(to_unsigned(i1_value, 8));
oRgb.green <= std_logic_vector(to_unsigned(i2_value, 8));
oRgb.blue  <= std_logic_vector(to_unsigned(i3_value, 8));
oRgb.valid <= rgb_sync_2.valid;

end behavioral;