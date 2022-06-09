-------------------------------------------------------------------------------
--
-- Filename    : detect_pixel.vhd
-- Create Date : 05022019 [05-02-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity detect_pixel is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    oRgb           : out channel;
    rgbCoord       : in region;
    iCord          : in coord;
    endOfFrame     : in std_logic;
    pDetect        : out std_logic);
end entity;

architecture arch of detect_pixel is
    signal pEnable         : std_logic;
    signal pCont           : cord;

begin

pDetect        <= pEnable;

pixelRangeP: process (clk)begin
if rising_edge(clk) then
    if((iRgb.red>rgbCoord.rl and iRgb.red<rgbCoord.rh) and (iRgb.green>rgbCoord.gl and iRgb.green<rgbCoord.gh) and (iRgb.blue>rgbCoord.bl and iRgb.blue<rgbCoord.bh))then
        pEnable <= hi;
    else
        pEnable <= lo;
    end if;
end if;
end process pixelRangeP;

pipCordP: process (clk)begin
    if rising_edge(clk) then
        pCont.x      <= to_integer((unsigned(iCord.x)));
        pCont.y      <= to_integer((unsigned(iCord.y)));
    end if;
end process pipCordP;

pixelCordInt : pixel_cord
port map(
    clk      => clk,
    iRgb     => iRgb,
    iPixelEn => pEnable,
    iEof     => endOfFrame,
    iCord    => pCont,
    oRgb     => oRgb);

end architecture;