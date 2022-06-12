-------------------------------------------------------------------------------
--
-- Filename    : rgb_to_I1I2I3_ohta.vhd
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

use work.constants_package.all;
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;

entity rgb_to_I1I2I3_ohta is
generic (
    i_data_width   : natural := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end rgb_to_I1I2I3_ohta;

architecture behavioral of rgb_to_I1I2I3_ohta is


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
    signal g2                   : integer;

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






i1_numerator        <= rgb_sync_1.red + rgb_sync_1.green + rgb_sync_1.blue;
i1_denominator      <= 3;
i1_quotient         <= ((i1_numerator/i1_denominator));
i1_value            <= i1_quotient;



i2_numerator        <= rgb_sync_1.red - rgb_sync_1.blue;
i2_denominator      <= 2;
i2_quotient         <= ((i2_numerator/i2_denominator));
i2_value            <= i2_quotient;


g2                  <= 2 * rgb_sync_1.green;
i3_numerator        <= g2 - rgb_sync_1.red - rgb_sync_1.blue;
i3_denominator      <= 4;
i3_quotient         <= ((i3_numerator/i3_denominator));
i3_value            <= i3_quotient;





oRgb.red   <= std_logic_vector(to_unsigned(i1_value, 8));
oRgb.green <= std_logic_vector(to_unsigned(i2_value, 8));
oRgb.blue  <= std_logic_vector(to_unsigned(i3_value, 8));
oRgb.valid <= rgb_sync_3.valid;

end behavioral;