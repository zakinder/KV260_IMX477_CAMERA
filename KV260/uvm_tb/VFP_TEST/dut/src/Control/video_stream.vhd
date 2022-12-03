-------------------------------------------------------------------------------
--
-- Filename    : video_stream.vhd
-- Create Date : 01062019 [01-06-2019]
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

entity video_stream is
generic (
    revision_number      : std_logic_vector(31 downto 0) := x"00000000";
    i_data_width         : integer := 8;
    s_data_width         : integer := 16;
    b_data_width         : integer := 32;
    img_width            : integer := 256;
    adwrWidth            : integer := 16;
    addrWidth            : integer := 12;
    bmp_width            : integer := 1920;
    bmp_height           : integer := 1080;
    F_TES                : boolean := false;
    F_LUM                : boolean := false;
    F_TRM                : boolean := false;
    F_RGB                : boolean := false;
    F_SHP                : boolean := false;
    F_BLU                : boolean := false;
    F_EMB                : boolean := false;
    F_YCC                : boolean := false;
    F_SOB                : boolean := false;
    F_CGA                : boolean := false;
    F_HSV                : boolean := false;
    F_HSL                : boolean := false);
port (
    clk                  : in std_logic;
    rst_l                : in std_logic;
    iWrRegs              : in mRegs;
    oRdRegs              : out mRegs;
    iRgbSet              : in rRgb;
    oVideoData           : out vStreamData;
    oMmAxi               : out integer);
end video_stream;

architecture arch_imp of video_stream is

    signal sSec          : std_logic_vector(i_data_width-3 downto 0);
    signal sMin          : std_logic_vector(i_data_width-3 downto 0);
    signal sHou          : std_logic_vector(i_data_width/2 downto 0);


    signal sFifoStatus   : std_logic_vector(b_data_width-1 downto 0);
    signal sGridLockData : std_logic_vector(b_data_width-1 downto 0);
    
    signal sRgbRoiLimits : region;
    signal sRoi          : poi;
    signal sFrameData    : fcolors;
    signal sKls          : coefficient;
    signal sAls          : coefficient;
    signal sKcoeff       : kernelCoeff;

    signal sSobelThresh  : integer;
    signal sViChannel    : integer;
    signal sRgbSelect    : integer;
    signal sFilterId     : integer;
    signal sLumTh        : integer;
    signal sHsvPerCh     : integer;
    signal sYccPerCh     : integer;
    
begin


frameProcessInst: frame_process
generic map(
    i_data_width         => i_data_width,
    s_data_width         => s_data_width,
    b_data_width         => b_data_width,
    img_width            => img_width,
    adwrWidth            => adwrWidth,
    addrWidth            => addrWidth,
    bmp_width            => bmp_width,
    bmp_height           => bmp_height,
    F_TES                => F_TES,
    F_LUM                => F_LUM,
    F_TRM                => F_TRM,
    F_RGB                => F_RGB,
    F_SHP                => F_SHP,
    F_BLU                => F_BLU,
    F_EMB                => F_EMB,
    F_YCC                => F_YCC,
    F_SOB                => F_SOB,
    F_CGA                => F_CGA,
    F_HSV                => F_HSV,
    F_HSL                => F_HSL)
port map(
    clk                  => clk,
    rst_l                => rst_l,
    iRgbSet              => iRgbSet,
    iVideoChannel        => sViChannel,
    iRoi                 => sRoi,
    iSobelTh             => sSobelThresh,
    iKls                 => sKls,
    iAls                 => sAls,
    iLumTh               => sLumTh,
    iHsvPerCh            => sHsvPerCh,
    iYccPerCh            => sYccPerCh,
    iRgbCoord            => sRgbRoiLimits,
    iFilterId            => sFilterId,
    oKcoeff              => sKcoeff,
    oFifoStatus          => sFifoStatus,
    oGridLockData        => sGridLockData,
    oFrameData           => sFrameData);

digiClkInst: digital_clock
port map(
    clk                  => clk,
    oSec                 => sSec,
    oMin                 => sMin,
    oHou                 => sHou);

mWrRdInst: mWrRd
generic map(
    revision_number      => revision_number,
    s_data_width         => s_data_width,
    b_data_width         => b_data_width)
port map(
    iWrRegs              => iWrRegs,
    oReRegs              => oRdRegs,
    iSeconds             => sSec,
    iMinutes             => sMin,
    iHours               => sHou,
    iFifoStatus          => sFifoStatus,
    iGridLockData        => sGridLockData,
    iKcoeff              => sKcoeff,
    oAls                 => sAls,
    oKls                 => sKls,
    oLumTh               => sLumTh,
    oHsvPerCh            => sHsvPerCh,
    oYccPerCh            => sYccPerCh,
    oRgbRoiLimits        => sRgbRoiLimits,
    oFilterId            => sFilterId,
    oMmAxi               => oMmAxi,
    oSobelThresh         => sSobelThresh,
    oVideoChannel        => sViChannel,
    oRgbSelect           => sRgbSelect,
    oRoi                 => sRoi);

videoSelectInst: video_select
generic map (
    bmp_width            => bmp_width,
    bmp_height           => bmp_height,
    i_data_width         => i_data_width,
    b_data_width         => b_data_width,
    s_data_width         => s_data_width)
port map (
    clk                  => clk,
    rst_l                => rst_l,
    iViChannel           => sViChannel,
    iRgbSelect           => sRgbSelect,
    iFrameData           => sFrameData,
    oVideoData           => oVideoData);
end arch_imp;