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
    signal rgbSyncEol               : std_logic_vector(3 downto 0) := "0000";
    signal rgbSyncSof               : std_logic_vector(3 downto 0) := "0000";
    signal rgbSyncEof               : std_logic_vector(3 downto 0) := "0000";
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

    
    signal cp1,cp2                        : ufixed(7 downto 0)   :=(others => '0');
    signal mp1,mp2                        : ufixed(7 downto 0)   :=(others => '0');
    signal yp1,yp2                        : ufixed(7 downto 0)   :=(others => '0');
    
    
    
    
    signal kp                        : ufixed(7 downto 0)   :=(others => '0');
    
    
    signal tp                        : ufixed(7 downto 0)   :=(others => '0');

    signal cmy_c                     : ufixed(8 downto 0)   :=(others => '0');
    signal cmy_m                     : ufixed(8 downto 0)   :=(others => '0');
    signal cmy_y                     : ufixed(8 downto 0)   :=(others => '0');
    
begin

rgbToUfP: process (clk)begin
    if rising_edge(clk) then
        rgb_sync_1.red    <= to_ufixed(iRgb.red(9 downto 2),rgb_sync_1.red);
        rgb_sync_1.green  <= to_ufixed(iRgb.green(9 downto 2),rgb_sync_1.green);
        rgb_sync_1.blue   <= to_ufixed(iRgb.blue(9 downto 2),rgb_sync_1.blue);
        rgb_sync_1.valid  <= iRgb.valid;
    end if;
end process rgbToUfP;


process (clk) begin
    if rising_edge(clk) then
      rgbSyncEol(0)   <= iRgb.eol;
      rgbSyncEol(1)   <= rgbSyncEol(0);
      rgbSyncEol(2)   <= rgbSyncEol(1);
      rgbSyncEol(3)   <= rgbSyncEol(2);
      rgbSyncSof(0)   <= iRgb.sof;
      rgbSyncSof(1)   <= rgbSyncSof(0);
      rgbSyncSof(2)   <= rgbSyncSof(1);
      rgbSyncSof(3)   <= rgbSyncSof(2);
      rgbSyncEof(0)   <= iRgb.eof;
      rgbSyncEof(1)   <= rgbSyncEof(0);
      rgbSyncEof(2)   <= rgbSyncEof(1);
      rgbSyncEof(3)   <= rgbSyncEof(2);
    end if;
end process;



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






process (clk) begin
    if rising_edge(clk) then
        cp1                 <= resize((to_ufixed(255,7,0)-rgb_sync_1.red),cp1);
        mp1                 <= resize((to_ufixed(255,7,0)-rgb_sync_1.green),mp1);
        yp1                 <= resize((to_ufixed(255,7,0)-rgb_sync_1.blue),yp1);
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        cp2                 <= cp1;
        mp2                 <= mp1;
        yp2                 <= yp1;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if ((cp1 <= mp1) and (cp1 <= yp1)) then
            kp <= cp1;
        elsif((mp1 <= cp1) and (mp1 <= yp1)) then
            kp <= mp1;
        else
            kp <= yp1;
        end if;
    end if;
end process;






process (clk) begin
    if rising_edge(clk) then
        tp <= resize(255-kp,tp);
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if (tp = 0) then
            cmy_c <= to_ufixed(0,8,0);
            cmy_m <= to_ufixed(0,8,0);
            cmy_y <= to_ufixed(0,8,0);
        else
            cmy_c <= (cp2-kp);
            cmy_m <= (mp2-kp);
            cmy_y <= (yp2-kp);
        end if;
    end if;
end process;


--process (clk) begin
--    if rising_edge(clk) then
--        if (tp = 0) then
--            cmy_c <= to_ufixed(0,17,-8);
--            cmy_m <= to_ufixed(0,17,-8);
--            cmy_y <= to_ufixed(0,17,-8);
--        else
--            cmy_c <= ((cp2-kp)/tp)*255;
--            cmy_m <= ((mp2-kp)/tp)*255;
--            cmy_y <= ((yp2-kp)/tp)*255;
--        end if;
--    end if;
--end process;


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

oRgb.red   <= std_logic_vector(cmy_c(7 downto 0)) & "00";
oRgb.green <= std_logic_vector(cmy_m(7 downto 0)) & "00";
oRgb.blue  <= std_logic_vector(cmy_y(7 downto 0)) & "00";
oRgb.valid <= rgb_sync_3.valid;
oRgb.eol   <= rgbSyncEol(3);
oRgb.sof   <= rgbSyncSof(3);
oRgb.eof   <= rgbSyncEof(3);
end behavioral;