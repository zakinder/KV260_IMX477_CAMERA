-------------------------------------------------------------------------------
--
-- Filename    : rgb_to_cmyk.vhd
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
entity rgb_to_cmyk is
generic (
    i_data_width   : natural := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end rgb_to_cmyk;
architecture behavioral of rgb_to_cmyk is

    signal rgb_sync_1                : rgbToUfRecord;
    signal rgb_sync_2                : rgbToUfRecord;
    signal rgb_sync_3                : rgbToUfRecord;
    --signal rgb_max                   : ufixed(7 downto 0) :=(others => '0');
    --
    ----CMYK
    --signal k_value                   : ufixed(7 downto 0)    :=(others => '0');
    --
    --signal c_numerator               : ufixed(7 downto 0)   :=(others => '0');
    --signal c_denominator             : ufixed(7 downto 0)    :=(others => '0');
    --signal c_value                   : ufixed(8 downto 0)   :=(others => '0');
    --
    --
    --signal m_numerator               : ufixed(7 downto 0)    :=(others => '0');
    --signal m_denominator             : ufixed(7 downto 0)    :=(others => '0');
    --signal m_value                   : ufixed(8 downto 0)    :=(others => '0');
    --
    --
    --
    --signal y_numerator               : ufixed(7 downto 0)   :=(others => '0');
    --signal y_denominator             : ufixed(7 downto 0)    :=(others => '0');
    --signal y_value                   : ufixed(8 downto 0)    :=(others => '0');

    
    signal cp                        : ufixed(7 downto 0)   :=(others => '0');
    signal mp                        : ufixed(7 downto 0)   :=(others => '0');
    signal yp                        : ufixed(7 downto 0)   :=(others => '0');
    signal kp                        : ufixed(7 downto 0)   :=(others => '0');
    
    
    signal tp                        : ufixed(7 downto 0)   :=(others => '0');

    signal cmy_c                     : ufixed(17 downto -8)   :=(others => '0');
    signal cmy_m                     : ufixed(17 downto -8)   :=(others => '0');
    signal cmy_y                     : ufixed(17 downto -8)   :=(others => '0');
    
begin

rgbToUfP: process (clk)begin
    if rising_edge(clk) then
        rgb_sync_1.red    <= to_ufixed(iRgb.red,rgb_sync_1.red);
        rgb_sync_1.green  <= to_ufixed(iRgb.green,rgb_sync_1.green);
        rgb_sync_1.blue   <= to_ufixed(iRgb.blue,rgb_sync_1.blue);
        rgb_sync_1.valid  <= iRgb.valid;
    end if;
end process rgbToUfP;






process (clk) begin
    if rising_edge(clk) then
        rgb_sync_2 <= rgb_sync_1;
        rgb_sync_3 <= rgb_sync_2;
    end if;
end process;

-- RGB.max = max(R, G, B)
--rgbMaxP: process (clk) begin
--    if rising_edge(clk) then
--        if ((rgb_sync_1.red >= rgb_sync_1.green) and (rgb_sync_1.red >= rgb_sync_1.blue)) then
--            rgb_max <= rgb_sync_1.red;
--        elsif((rgb_sync_1.green >= rgb_sync_1.red) and (rgb_sync_1.green >= rgb_sync_1.blue))then
--            rgb_max <= rgb_sync_1.green;
--        else
--            rgb_max <= rgb_sync_1.blue;
--        end if;
--    end if;
--end process rgbMaxP;




cp                 <= resize((to_ufixed(255,7,0)-rgb_sync_1.red),cp);
mp                 <= resize((to_ufixed(255,7,0)-rgb_sync_1.green),mp);
yp                 <= resize((to_ufixed(255,7,0)-rgb_sync_1.blue),yp);





process (mp,cp,yp) begin
    if ((cp <= mp) and (cp <= yp)) then
        kp <= cp;
    elsif((mp <= cp) and (mp <= yp)) then
        kp <= mp;
    else
        kp <= yp;
    end if;
end process;

tp <= resize(255-kp,tp);


process (clk) begin
    if rising_edge(clk) then
        if (tp = 0) then
            cmy_c <= to_ufixed(0,17,-8);
            cmy_m <= to_ufixed(0,17,-8);
            cmy_y <= to_ufixed(0,17,-8);
        else
            cmy_c <= ((cp-kp)/tp)*255;
            cmy_m <= ((mp-kp)/tp)*255;
            cmy_y <= ((yp-kp)/tp)*255;
        end if;
    end if;
end process;


--k_value                 <= resize((to_ufixed(256,8,0)-rgb_max),k_value);
--
--c_numerator             <= resize((256 - rgb_max - rgb_sync_1.red),c_numerator);
--c_denominator           <= resize((256 - k_value),c_denominator);
--c_value                 <= resize((c_numerator/c_denominator),c_value);
--
--m_numerator             <= resize((256 - rgb_max - rgb_sync_1.green),m_numerator);
--m_denominator           <= resize((256 - k_value),m_denominator);
--m_value                 <= resize((m_numerator/m_denominator),m_value);
--
--y_numerator             <= resize((256 - rgb_max - rgb_sync_1.blue),y_numerator);
--y_denominator           <= resize((256 - k_value),y_denominator);
--y_value                 <= resize((y_numerator/y_denominator),y_value);

oRgb.red   <= std_logic_vector(cmy_c(7 downto 0));
oRgb.green <= std_logic_vector(cmy_m(7 downto 0));
oRgb.blue  <= std_logic_vector(cmy_y(7 downto 0));
oRgb.valid <= rgb_sync_3.valid;
        
end behavioral;