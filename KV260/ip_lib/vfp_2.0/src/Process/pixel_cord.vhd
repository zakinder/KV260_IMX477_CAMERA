-------------------------------------------------------------------------------
--
-- Filename    : pixel_cord.vhd
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

entity pixel_cord is
port (
    clk            : in std_logic;
    iRgb           : in channel;
    iPixelEn       : in std_logic;
    iEof           : in std_logic;
    iCord          : in cord;
    oRgb           : out channel);
end entity;
architecture rtl of pixel_cord is
    signal frameSize       : intersectPoint;
    signal initCord        : intersectPoint;
    signal newCord         : intersectPoint;
    signal grid1Cord       : intersectPoint;
    signal grid2Cord       : intersectPoint;
    signal grid3Cord       : intersectPoint;
    signal grid4Cord       : intersectPoint;
    signal rgb             : channel;
begin
    initCord.rht   <= initCordValueRht;
    initCord.lft   <= initCordValueLft;
    initCord.top   <= initCordValueTop;
    initCord.bot   <= initCordValueBot;
    frameSize.lft  <= frameSizeLft;
    frameSize.rht  <= frameSizeRht;
    frameSize.top  <= frameSizeTop;
    frameSize.bot  <= frameSizeBot;
dataOutP: process (clk)begin
    if rising_edge(clk) then
        oRgb.valid  <= iRgb.valid;
        oRgb.red    <= rgb.red;
        oRgb.green  <= rgb.green;
        oRgb.blue   <= rgb.blue;
    end if;
end process dataOutP;
pixelCordP: process (clk)begin
    if rising_edge(clk) then
        if (iRgb.valid = hi) then
            ------------------------------------
            if (iPixelEn = hi) then
                ------------------------------------
                --Left Coordinates
                ------------------------------------
                if (iCord.x <= newCord.lft) then
                    if ( iCord.x >= frameSize.lft) then
                        newCord.lft <= iCord.x - 1;
                    end if;
                end if;
                ------------------------------------
                --Right Coordinates
                ------------------------------------
                if (iCord.x >= newCord.rht) then
                    if ( iCord.x <= frameSize.rht) then
                        newCord.rht <= iCord.x + 1;
                    end if;
                end if;
                ------------------------------------
                --Top Coordinates
                ------------------------------------
                if (iCord.y <= newCord.top) then
                    if ( iCord.y >= frameSize.top) then
                        newCord.top <= iCord.y - 1;
                    end if;
                end if;
                ------------------------------------
                --Bottom Coordinates
                ------------------------------------
                if (iCord.y >= newCord.bot) then
                    if ( iCord.y <= frameSize.bot) then
                        newCord.bot <= iCord.y + 1;
                    end if;
                end if;
            end if;--iPixelEn
            ------------------------------------
            -- 4TH FRAME
            ------------------------------------
            if ((iCord.y = grid4Cord.bot) and ((iCord.x >= grid4Cord.lft) and (iCord.x <= grid4Cord.rht)))then
                rgb.red        <= white;
                rgb.green      <= black;
                rgb.blue       <= black;
            elsif ((iCord.y = grid4Cord.top) and ((iCord.x >= grid4Cord.lft) and (iCord.x <= grid4Cord.rht)))then
                rgb.red        <= white;
                rgb.green      <= black;
                rgb.blue       <= black;
            elsif ((iCord.x = grid4Cord.lft) and ((iCord.y >= grid4Cord.top) and (iCord.y <= grid4Cord.bot)))then
                rgb.red        <= white;
                rgb.green      <= black;
                rgb.blue       <= black;
            elsif ((iCord.x = grid4Cord.rht) and ((iCord.y >= grid4Cord.top) and (iCord.y <= grid4Cord.bot)))then
                rgb.red        <= white;
                rgb.green      <= black;
                rgb.blue       <= black;
            ------------------------------------
           -- 3RD FRAME
            ------------------------------------
            elsif ((iCord.y = grid3Cord.bot) and ((iCord.x >= grid3Cord.lft) and (iCord.x <= grid3Cord.rht)))then
                rgb.red        <= black;
                rgb.green      <= white;
                rgb.blue       <= black;
            elsif ((iCord.y = grid3Cord.top) and ((iCord.x >= grid3Cord.lft) and (iCord.x <= grid3Cord.rht)))then
                rgb.red        <= black;
                rgb.green      <= white;
                rgb.blue       <= black;
            elsif ((iCord.x = grid3Cord.lft) and ((iCord.y >= grid3Cord.top) and (iCord.y <= grid3Cord.bot)))then
                rgb.red        <= black;
                rgb.green      <= white;
                rgb.blue       <= black;
            elsif ((iCord.x = grid3Cord.rht) and ((iCord.y >= grid3Cord.top) and (iCord.y <= grid3Cord.bot)))then
                rgb.red        <= black;
                rgb.green      <= white;
                rgb.blue       <= black;
            ------------------------------------
            -- 2ND FRAME
            ------------------------------------
            elsif ((iCord.y = grid2Cord.bot) and ((iCord.x >= grid2Cord.lft) and (iCord.x <= grid3Cord.rht)))then
                rgb.red        <= black;
                rgb.green      <= black;
                rgb.blue       <= white;
            elsif ((iCord.y = grid2Cord.top) and ((iCord.x >= grid2Cord.lft) and (iCord.x <= grid3Cord.rht)))then
                rgb.red        <= black;
                rgb.green      <= black;
                rgb.blue       <= white;
            elsif ((iCord.x = grid2Cord.lft) and ((iCord.y >= grid2Cord.top) and (iCord.y <= grid2Cord.bot)))then
                rgb.red        <= black;
                rgb.green      <= black;
                rgb.blue       <= white;
            elsif ((iCord.x = grid3Cord.rht) and ((iCord.y >= grid2Cord.top) and (iCord.y <= grid2Cord.bot)))then
                rgb.red        <= black;
                rgb.green      <= black;
                rgb.blue       <= white;
            ------------------------------------
            -- 1ST FRAME
            ------------------------------------
            elsif ((iCord.y = grid1Cord.bot) and ((iCord.x >= grid1Cord.lft) and (iCord.x <= grid1Cord.rht)))then
                rgb.red        <= x"80";
                rgb.green      <= black;
                rgb.blue       <= x"80";
            elsif ((iCord.y = grid1Cord.top) and ((iCord.x >= grid1Cord.lft) and (iCord.x <= grid1Cord.rht)))then
                rgb.red        <= x"80";
                rgb.green      <= black;
                rgb.blue       <= x"80";
            elsif ((iCord.x = grid1Cord.lft) and ((iCord.y >= grid1Cord.top) and (iCord.y <= grid1Cord.bot)))then
                rgb.red        <= x"80";
                rgb.green      <= black;
                rgb.blue       <= x"80";
            elsif ((iCord.x = grid1Cord.rht) and ((iCord.y >= grid1Cord.top) and (iCord.y <= grid1Cord.bot)))then
                rgb.red        <= x"80";
                rgb.green      <= black;
                rgb.blue       <= x"80";
            else
                rgb.red        <= iRgb.red;
                rgb.green      <= iRgb.green;
                rgb.blue       <= iRgb.blue;
            end if;
        end if;--iRgb.valid
        if (iEof = hi)then
            --RESET COORDINATES TO DEFAULT
            newCord.lft       <= initCord.lft;
            newCord.rht       <= initCord.rht;
            newCord.top       <= initCord.top;
            newCord.bot       <= initCord.bot;
            -- 1ST FRAME
            grid1Cord.lft     <= newCord.lft;
            grid1Cord.rht     <= newCord.rht;
            grid1Cord.top     <= newCord.top;
            grid1Cord.bot     <= newCord.bot;
            -- 2ND FRAME
            grid2Cord.lft     <= grid1Cord.lft;
            grid2Cord.rht     <= grid1Cord.rht;
            grid2Cord.top     <= grid1Cord.top;
            grid2Cord.bot     <= grid1Cord.bot;
            -- 3RD FRAME
            grid3Cord.lft     <= grid2Cord.lft;
            grid3Cord.rht     <= grid2Cord.rht;
            grid3Cord.top     <= grid2Cord.top;
            grid3Cord.bot     <= grid2Cord.bot;
            -- 4TH FRAME
            grid4Cord.lft     <= grid3Cord.lft;
            grid4Cord.rht     <= grid3Cord.rht;
            grid4Cord.top     <= grid3Cord.top;
            grid4Cord.bot     <= grid3Cord.bot;
        end if;--iEof
    end if;
end process pixelCordP;
end architecture;