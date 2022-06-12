-------------------------------------------------------------------------------
--
-- Filename    : video_select.vhd
-- Create Date : 02092019 [02-17-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation axi4 components.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity video_select is
generic (
    bmp_width         : integer := 1920;
    bmp_height        : integer := 1080;
    i_data_width      : integer := 8;
    b_data_width      : integer := 32;
    s_data_width      : integer := 16);
port (
    clk               : in std_logic;
    rst_l             : in std_logic;
    iViChannel        : in integer;
    iRgbSelect        : in integer;
    iFrameData        : in fcolors;
    oVideoData        : out vStreamData);
end video_select;

architecture Behavioral of video_select is

    signal ycbcr              : channel;
    signal channels           : channel;
    signal location           : cord := (x => 512, y => 512);
    signal rgbText            : channel;
    signal sCord              : coord;
    signal sRgb               : channel;

begin

    oVideoData.ycbcr  <= sRgb;
    oVideoData.eof    <= iFrameData.pEof;
    oVideoData.sof    <= iFrameData.pSof;
    oVideoData.cord   <= sCord;

---------------------------------------------------------------------------------
-- oRgb.valid must be 2nd condition else valid value
---------------------------------------------------------------------------------
videoOutP: process (clk) begin
    if rising_edge(clk) then
        if (iViChannel   = FILTER_CGA) then
            channels           <= iFrameData.cgain;
        elsif(iViChannel = FILTER_SHP)then
            channels           <= iFrameData.sharp;
        elsif(iViChannel = FILTER_BLU)then
            channels           <= iFrameData.blur;
        elsif(iViChannel = FILTER_HSL)then
            channels           <= iFrameData.hsl;
        elsif(iViChannel = FILTER_HSV)then
            channels           <= iFrameData.hsv;
        elsif(iViChannel = FILTER_RGB)then
            channels           <= iFrameData.inrgb;
        elsif(iViChannel = FILTER_SOB)then
            channels           <= iFrameData.sobel;
        elsif(iViChannel = FILTER_EMB)then
            channels           <= iFrameData.embos;
        elsif(iViChannel = FILTER_MSK_SOB_LUM)then
            channels           <= iFrameData.maskSobelLum;
        elsif(iViChannel = FILTER_MSK_SOB_TRM)then
            channels           <= iFrameData.maskSobelTrm;
        elsif(iViChannel = FILTER_MSK_SOB_RGB)then
            channels           <= iFrameData.maskSobelRgb;
        elsif(iViChannel = FILTER_MSK_SOB_SHP)then
            channels           <= iFrameData.maskSobelShp;
        elsif(iViChannel = FILTER_MSK_SOB_SHP)then
            channels           <= iFrameData.maskSobelShp;
        elsif(iViChannel = FILTER_MSK_SOB_BLU)then
            channels           <= iFrameData.maskSobelBlu;
        elsif(iViChannel = FILTER_MSK_SOB_YCC)then
            channels           <= iFrameData.maskSobelYcc;
        elsif(iViChannel = FILTER_MSK_SOB_HSV)then
            channels           <= iFrameData.maskSobelHsv;
        elsif(iViChannel = FILTER_MSK_SOB_HSL)then
            channels           <= iFrameData.maskSobelHsl;
        elsif(iViChannel = FILTER_MSK_SOB_CGA)then
            channels           <= iFrameData.maskSobelCga;
        elsif(iViChannel = FILTER_COR_TRM)then
            channels           <= iFrameData.colorTrm;
        elsif(iViChannel = FILTER_COR_LMP)then
            channels           <= iFrameData.colorLmp;
        elsif(iViChannel = FILTER_TST_PAT)then
            channels           <= iFrameData.tPattern;
        elsif(iViChannel = FILTER_CGA_TO_CGA)then
            channels           <= iFrameData.cgainToCgain;
        elsif(iViChannel = FILTER_CGA_TO_HSL)then
            channels           <= iFrameData.cgainToHsl;
        elsif(iViChannel = FILTER_CGA_TO_HSV)then
            channels           <= iFrameData.cgainToHsv;
        elsif(iViChannel = FILTER_CGA_TO_YCC)then
            channels           <= iFrameData.cgainToYcbcr;
        elsif(iViChannel = FILTER_CGA_TO_SHP)then
            channels           <= iFrameData.cgainToShp;
        elsif(iViChannel = FILTER_CGA_TO_BLU)then
            channels           <= iFrameData.cgainToBlu;
        elsif(iViChannel = FILTER_SHP_TO_CGA)then
            channels           <= iFrameData.shpToCgain;
        elsif(iViChannel = FILTER_SHP_TO_HSL)then
            channels           <= iFrameData.shpToHsl;
        elsif(iViChannel = FILTER_SHP_TO_HSV)then
            channels           <= iFrameData.shpToHsv;
        elsif(iViChannel = FILTER_SHP_TO_YCC)then
            channels           <= iFrameData.shpToYcbcr;
        elsif(iViChannel = FILTER_SHP_TO_SHP)then
            channels           <= iFrameData.shpToShp;
        elsif(iViChannel = FILTER_SHP_TO_BLU)then
            channels           <= iFrameData.shpToBlu;
        elsif(iViChannel = FILTER_BLU_TO_BLU)then
            channels           <= iFrameData.bluToBlu;
        elsif(iViChannel = FILTER_BLU_TO_CGA)then
            channels           <= iFrameData.bluToCga;
        elsif(iViChannel = FILTER_BLU_TO_SHP)then
            channels           <= iFrameData.bluToShp;
        elsif(iViChannel = FILTER_BLU_TO_YCC)then
            channels           <= iFrameData.bluToYcc;
        elsif(iViChannel = FILTER_BLU_TO_HSV)then
            channels           <= iFrameData.bluToHsv;
        elsif(iViChannel = FILTER_BLU_TO_HSL)then
            channels           <= iFrameData.bluToHsl;
        elsif(iViChannel = FILTER_BLU_TO_CGA_TO_SHP)then
            channels           <= iFrameData.bluToCgaShp;
        elsif(iViChannel = FILTER_BLU_TO_CGA_TO_SHP_TO_YCC)then
            channels           <= iFrameData.bluToCgaShpYcc;
        elsif(iViChannel = FILTER_BLU_TO_CGA_TO_SHP_TO_HSV)then
            channels           <= iFrameData.bluToCgaShpHsv;
        elsif(iViChannel = FILTER_BLU_TO_SHP_TO_CGA)then
            channels           <= iFrameData.bluToShpCga;
        elsif(iViChannel = FILTER_BLU_TO_SHP_TO_CGA_TO_YCC)then
            channels           <= iFrameData.bluToShpCgaYcc;
        elsif(iViChannel = FILTER_BLU_TO_SHP_TO_CGA_TO_HSV)then
            channels           <= iFrameData.bluToShpCgaHsv;
        elsif(iViChannel = FILTER_RGB_CORRECT)then
            channels           <= iFrameData.rgbCorrect;
        elsif(iViChannel = FILTER_RGB_REMIX)then
            channels           <= iFrameData.rgbRemix;
        elsif(iViChannel = FILTER_RGB_DETECT)then
            channels           <= iFrameData.rgbDetect;
        elsif(iViChannel = FILTER_RGB_POI)then
            channels           <= iFrameData.rgbPoi;
        elsif(iViChannel = FILTER_YCC)then
            channels           <= iFrameData.ycbcr;
        else
            channels           <= iFrameData.rgbCorrect;
        end if;
    end if;
end process videoOutP;

ycbcrInst: rgb_ycbcr
generic map(
    i_data_width         => i_data_width,
    i_precision          => 12,
    i_full_range         => TRUE)
port map(
    clk                  => clk,
    rst_l                => rst_l,
    iRgb                 => channels,
    y                    => ycbcr.red,
    cb                   => ycbcr.green,
    cr                   => ycbcr.blue,
    oValid               => ycbcr.valid);
    
process (clk) begin
    if rising_edge(clk) then
        sCord <= iFrameData.cod;
    end if;
end process;

TextGenYcbcrInst: text_gen
generic map (
    img_width_bmp   => bmp_width,
    img_height_bmp  => bmp_height,
    b_data_width    => b_data_width)
port map(
    clk             => clk,
    rst_l           => rst_l,
    iViChannel      => iViChannel,
    txCord          => iFrameData.cod,
    location        => location,
    iRgb            => ycbcr,
    oRgb            => rgbText);

channelOutP: process (clk) begin
    if rising_edge(clk) then
        if (iRgbSelect = 0) then
            sRgb   <= ycbcr;
        elsif(iRgbSelect = 1)then
            sRgb   <= channels;
        elsif(iRgbSelect = 2)then
            sRgb   <= rgbText;
        elsif(iRgbSelect = 3)then
            sRgb.valid   <= ycbcr.valid;
            sRgb.red     <= ycbcr.red;
            sRgb.green   <= ycbcr.red;
            sRgb.blue    <= ycbcr.red;
        elsif(iRgbSelect = 4)then
            sRgb.valid   <= ycbcr.valid;
            sRgb.red     <= ycbcr.green;
            sRgb.green   <= ycbcr.green;
            sRgb.blue    <= ycbcr.green;
        elsif(iRgbSelect = 5)then
            sRgb.valid   <= ycbcr.valid;
            sRgb.red     <= ycbcr.blue;
            sRgb.green   <= ycbcr.blue;
            sRgb.blue    <= ycbcr.blue;
        elsif(iRgbSelect = 6)then
            sRgb.valid   <= ycbcr.valid;
            sRgb.red     <= ycbcr.red;
            sRgb.green   <= x"00";
            sRgb.blue    <= x"00";
        elsif(iRgbSelect = 7)then
            sRgb.valid   <= ycbcr.valid;
            sRgb.red     <= x"00";
            sRgb.green   <= ycbcr.green;
            sRgb.blue    <= x"00";
        elsif(iRgbSelect = 8)then
            sRgb.valid   <= ycbcr.valid;
            sRgb.red     <= x"00";
            sRgb.green   <= x"00";
            sRgb.blue    <= ycbcr.blue;
        elsif(iRgbSelect = 9)then
            sRgb.valid   <= ycbcr.valid;
            sRgb.red     <= ycbcr.red;
            sRgb.green   <= ycbcr.green;
            sRgb.blue    <= ycbcr.red;
        elsif(iRgbSelect = 10)then
            sRgb.valid   <= ycbcr.valid;
            sRgb.red     <= ycbcr.green;
            sRgb.green   <= ycbcr.green;
            sRgb.blue    <= ycbcr.blue;
        elsif(iRgbSelect = 11)then
            sRgb.valid   <= ycbcr.valid;
            sRgb.red     <= ycbcr.blue;
            sRgb.green   <= ycbcr.green;
            sRgb.blue    <= ycbcr.blue;
        else
            sRgb         <= ycbcr;
        end if;
    end if;
end process channelOutP;
end Behavioral;