-------------------------------------------------------------------------------
--
-- Filename    : frame_process.vhd
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
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;
entity frame_process is
generic (
    i_data_width            : integer := 8;
    s_data_width            : integer := 16;
    b_data_width            : integer := 32;
    bmp_width               : integer := 1920;
    bmp_height              : integer := 1080;
    img_width               : integer := 256;
    adwrWidth               : integer := 16;
    addrWidth               : integer := 12;
    F_TES                   : boolean := false;
    F_LUM                   : boolean := false;
    F_TRM                   : boolean := false;
    F_RGB                   : boolean := false;
    F_SHP                   : boolean := false;
    F_BLU                   : boolean := false;
    F_EMB                   : boolean := false;
    F_YCC                   : boolean := false;
    F_SOB                   : boolean := false;
    F_CGA                   : boolean := false;
    F_HSV                   : boolean := false;
    F_HSL                   : boolean := false);
port (
    clk                     : in std_logic;
    rst_l                   : in std_logic;
    iRgbSet                 : in rRgb;
    --cpu side in
    iRgbCoord               : in region;
    iRoi                    : in poi;
    iKls                    : in coefficient;
    iAls                    : in coefficient;
    iLumTh                  : in integer;
    iHsvPerCh               : in integer;
    iYccPerCh               : in integer;
    iSobelTh                : in integer;
    iVideoChannel           : in integer;
    iFilterId               : in integer;
    oKcoeff                 : out kernelCoeff;
    --out
    oFrameData              : out fcolors;
    --to cpu
    oFifoStatus             : out std_logic_vector(b_data_width-1 downto 0);
    oGridLockData           : out std_logic_vector(b_data_width-1 downto 0));
end entity;
architecture arch of frame_process is
    -------------------------------------------------
    constant HSV_L          : boolean := false;
    constant HSV_1          : boolean := false;
    constant HSV_2          : boolean := false;
    constant HSV_3          : boolean := false;
    constant HSV_4          : boolean := false;
    constant HSVL1          : boolean := false;
    constant HSVL2          : boolean := false;
    constant HSVL3          : boolean := false;
    constant HSVL4          : boolean := false;
    -------------------------------------------------
    constant F_RE1          : boolean := false;
    constant F_RE2          : boolean := false;
    constant F_RE3          : boolean := false;
    constant F_RE4          : boolean := false;
    constant F_RE5          : boolean := false;
    constant F_RE6          : boolean := false;
    constant F_RE7          : boolean := false;
    constant F_RE8          : boolean := false;
    -------------------------------------------------
    constant F_CC1          : boolean := false;
    constant F_CC2          : boolean := false;
    constant F_CC3          : boolean := false;
    constant F_CC4          : boolean := false;
    constant F_CC5          : boolean := false;
    constant F_CC6          : boolean := false;
    constant F_CC7          : boolean := false;
    constant F_CC8          : boolean := false;
    constant FCMYK          : boolean := false;
    constant F_XYZ          : boolean := false;
    constant F_LMS          : boolean := false;
    constant YPBPR          : boolean := false;
    constant F_YUV          : boolean := false;
    constant YC1C2          : boolean := false;
    constant YDRDB          : boolean := false;
    constant F_IPT          : boolean := false;
    constant F_YIQ          : boolean := false;
    constant F_HED          : boolean := false;
    constant FOHTA          : boolean := false;
    constant FMICC          : boolean := false;
    constant L_BLU          : boolean := false;  -- 8
    constant L_SHP          : boolean := false;  -- 9
    constant L1CGA          : boolean := false;  -- 9
    constant L2CGA          : boolean := false;  -- 9
    constant L_YCC          : boolean := false;  -- 5
    constant L_D1T          : boolean := false;  -- 1
    constant L_B1T          : boolean := false;  -- 9
    constant L_AVG          : boolean := false;  -- 7
    constant L_OBJ          : boolean := false;  -- 4
    constant F_OHS          : boolean := false;
    constant L_HIS          : boolean := false;
    constant L_SPC          : boolean := false;
    constant MASK_TRUE      : boolean := true;
    constant MASK_FLSE      : boolean := false;
    constant M_SOB_LUM      : boolean := SelFrame(F_SOB,F_LUM,MASK_FLSE);
    constant M_SOB_TRM      : boolean := SelFrame(F_SOB,F_TRM,MASK_FLSE);
    constant M_SOB_RGB      : boolean := SelFrame(F_SOB,F_RGB,MASK_TRUE);
    constant M_SOB_SHP      : boolean := SelFrame(F_SOB,F_SHP,MASK_TRUE);
    constant M_SOB_BLU      : boolean := SelFrame(F_SOB,F_BLU,MASK_FLSE);
    constant M_SOB_YCC      : boolean := SelFrame(F_SOB,F_YCC,MASK_FLSE);
    constant M_SOB_CGA      : boolean := SelFrame(F_SOB,F_CGA,MASK_TRUE);
    constant M_SOB_HSV      : boolean := SelFrame(F_SOB,F_HSV,MASK_TRUE);
    constant M_SOB_HSL      : boolean := SelFrame(F_SOB,F_HSL,MASK_TRUE);
    signal txCord           : coord;
    signal rgbV1Correct     : channel;
    signal rgbV2Correct     : channel;
    signal rgbIn            : channel;
    signal rgbRemix         : channel;
    signal rgbPoi           : channel;
    signal rgbDetect        : channel;
    signal hsv              : hsvChannel;
    signal hsl              : hslChannel;
    signal hsvCcBlur4vx     : hsvChannel;
    signal cord             : coord;
    signal syncxy           : coord;
    signal cordIn           : coord;
    signal rgbSum           : tpRgb;
    signal rgbImageKernelv1 : colors;
    signal rgbImageKernelv2 : colors;
    signal rgbImageKernelv3 : colors;
    signal rgbImageKernelv4 : colors;
    signal rgbImageKernelv5 : colors;
    signal iKcoeff          : kernelCoeff;
    signal rgbImageFilters  : frameColors;
    signal blur_channels    : blur_frames;
    signal edgeValid        : std_logic;
    signal rgbDetectLock    : std_logic;
    signal rgbPoiLock       : std_logic;
    signal sValid           : std_logic;
begin
    oFrameData.sobel             <= rgbImageFilters.sobel;
    oFrameData.embos             <= rgbImageFilters.embos;
    oFrameData.blur              <= rgbImageFilters.blur;
    oFrameData.sharp             <= rgbImageFilters.sharp;
    oFrameData.cgain             <= rgbImageFilters.cgain;
    oFrameData.ycbcr             <= rgbImageFilters.ycbcr;
    oFrameData.hsl               <= rgbImageFilters.hsl;
    oFrameData.hsv               <= rgbImageFilters.hsv;
    oFrameData.inrgb             <= rgbImageFilters.inrgb;
    oFrameData.maskSobelLum      <= rgbImageFilters.maskSobelLum;
    oFrameData.maskSobelTrm      <= rgbImageFilters.maskSobelTrm;
    oFrameData.maskSobelRgb      <= rgbImageFilters.maskSobelRgb;
    oFrameData.maskSobelShp      <= rgbImageFilters.maskSobelShp;
    oFrameData.maskSobelBlu      <= rgbImageFilters.maskSobelBlu;
    oFrameData.maskSobelYcc      <= rgbImageFilters.maskSobelYcc;
    oFrameData.maskSobelHsv      <= rgbImageFilters.maskSobelHsv;
    oFrameData.maskSobelHsl      <= rgbImageFilters.maskSobelHsl;
    oFrameData.maskSobelCga      <= rgbImageFilters.maskSobelCga;
    oFrameData.colorTrm          <= rgbImageFilters.colorTrm;
    oFrameData.colorLmp          <= rgbImageFilters.colorLmp;
    oFrameData.tPattern          <= rgbImageFilters.tPattern;
    oFrameData.cgainToCgain      <= rgbImageFilters.cgainToCgain;
    oFrameData.cgainToHsl        <= rgbImageFilters.cgainToHsl;
    oFrameData.cgainToHsv        <= rgbImageFilters.cgainToHsv;
    oFrameData.cgainToYcbcr      <= rgbImageFilters.cgainToYcbcr;
    oFrameData.cgainToShp        <= rgbImageFilters.cgainToShp;
    oFrameData.cgainToBlu        <= rgbImageFilters.cgainToBlu;
    oFrameData.shpToCgain        <= rgbImageFilters.shpToCgain;
    oFrameData.shpToHsl          <= rgbImageFilters.shpToHsl;
    oFrameData.shpToHsv          <= rgbImageFilters.shpToHsv;
    oFrameData.shpToYcbcr        <= rgbImageFilters.shpToYcbcr;
    oFrameData.shpToShp          <= rgbImageFilters.shpToShp;
    oFrameData.shpToBlu          <= rgbImageFilters.shpToBlu;
    oFrameData.bluToBlu          <= rgbImageFilters.bluToBlu;
    oFrameData.bluToCga          <= rgbImageFilters.bluToCga;
    oFrameData.bluToShp          <= rgbImageFilters.bluToShp;
    oFrameData.bluToYcc          <= rgbImageFilters.bluToYcc;
    oFrameData.bluToHsv          <= rgbImageFilters.bluToHsv;
    oFrameData.bluToHsl          <= rgbImageFilters.bluToHsl;
    oFrameData.bluToCgaShp       <= rgbImageFilters.bluToCgaShp;
    oFrameData.bluToCgaShpYcc    <= rgbImageFilters.bluToCgaShpYcc;
    oFrameData.bluToCgaShpHsv    <= rgbImageFilters.bluToCgaShpHsv;
    oFrameData.bluToShpCga       <= rgbImageFilters.bluToShpCga;
    oFrameData.bluToShpCgaYcc    <= rgbImageFilters.bluToShpCgaYcc;
    oFrameData.bluToShpCgaHsv    <= rgbImageFilters.bluToShpCgaHsv;
    oFrameData.rgbRemix          <= rgbRemix;
    oFrameData.rgbDetect         <= rgbDetect;
    oFrameData.rgbPoi            <= rgbPoi;
    oFrameData.rgbSum            <= rgbSum;
    oFrameData.rgbDetectLock     <= rgbDetectLock;
    oFrameData.rgbPoiLock        <= rgbPoiLock;
    oFrameData.cod               <= syncxy;
    oFrameData.pEof              <= iRgbSet.pEof;
    oFrameData.pSof              <= iRgbSet.pSof;
    rgbIn.red                    <= iRgbSet.red;
    rgbIn.green                  <= iRgbSet.green;
    rgbIn.blue                   <= iRgbSet.blue;
    rgbIn.valid                  <= iRgbSet.valid;
    cordIn.x                     <= iRgbSet.cord.x;
    cordIn.y                     <= iRgbSet.cord.y;
pipCoordP: process (clk) begin
    if rising_edge(clk) then
        syncxy          <= cordIn;
        cord            <= syncxy;
    end if;
end process pipCoordP;
    iKcoeff.k1   <= iKls.k1(15 downto 0);
    iKcoeff.k2   <= iKls.k2(15 downto 0);
    iKcoeff.k3   <= iKls.k3(15 downto 0);
    iKcoeff.k4   <= iKls.k4(15 downto 0);
    iKcoeff.k5   <= iKls.k5(15 downto 0);
    iKcoeff.k6   <= iKls.k6(15 downto 0);
    iKcoeff.k7   <= iKls.k7(15 downto 0);
    iKcoeff.k8   <= iKls.k8(15 downto 0);
    iKcoeff.k9   <= iKls.k9(15 downto 0);
    iKcoeff.kSet <= iKls.config;
FiltersInst: filters
generic map(
    HSV_L                 =>  HSV_L,
    HSV_1                 =>  HSV_1,
    HSV_2                 =>  HSV_2,
    HSV_3                 =>  HSV_3,
    HSV_4                 =>  HSV_4,
    HSVL1                 =>  HSVL1,
    HSVL2                 =>  HSVL2,
    HSVL3                 =>  HSVL3,
    HSVL4                 =>  HSVL4,
    F_RE1                 =>  F_RE1,
    F_RE2                 =>  F_RE2,
    F_RE3                 =>  F_RE3,
    F_RE4                 =>  F_RE4,
    F_RE5                 =>  F_RE5,
    F_RE6                 =>  F_RE6,
    F_RE7                 =>  F_RE7,
    F_RE8                 =>  F_RE8,
    FCMYK                 =>  FCMYK,
    F_XYZ                 =>  F_XYZ,
    F_LMS                 =>  F_LMS,
    YPBPR                 =>  YPBPR,
    F_YUV                 =>  F_YUV,
    YC1C2                 =>  YC1C2,
    YDRDB                 =>  YDRDB,
    F_IPT                 =>  F_IPT,
    F_YIQ                 =>  F_YIQ,
    F_HED                 =>  F_HED,
    FOHTA                 =>  FOHTA,
    FMICC                 =>  FMICC,
    F_CC1                 =>  F_CC1,
    F_CC2                 =>  F_CC2,
    F_CC3                 =>  F_CC3,
    F_CC4                 =>  F_CC4,
    F_CC5                 =>  F_CC5,
    F_CC6                 =>  F_CC6,
    F_CC7                 =>  F_CC7,
    F_CC8                 =>  F_CC8,
    F_TES                 =>  F_TES,
    F_LUM                 =>  F_LUM,
    F_TRM                 =>  F_TRM,
    F_RGB                 =>  F_RGB,
    F_OHS                 =>  F_OHS,
    F_SHP                 =>  F_SHP,
    F_BLU                 =>  F_BLU,
    F_EMB                 =>  F_EMB,
    F_YCC                 =>  F_YCC,
    F_SOB                 =>  F_SOB,
    F_CGA                 =>  F_CGA,
    F_HSV                 =>  F_HSV,
    F_HSL                 =>  F_HSL,
    L_BLU                 =>  L_BLU,
    L_SHP                 =>  L_SHP,
    L_AVG                 =>  L_AVG,
    L_OBJ                 =>  L_OBJ,
    L_D1T                 =>  L_D1T,
    L_B1T                 =>  L_B1T,
    L1CGA                 =>  L1CGA,
    L2CGA                 =>  L2CGA,
    L_YCC                 =>  L_YCC,
    L_HIS                 =>  L_HIS,
    L_SPC                 =>  L_SPC,
    M_SOB_LUM           =>  M_SOB_LUM,
    M_SOB_TRM           =>  M_SOB_TRM,
    M_SOB_RGB           =>  M_SOB_RGB,
    M_SOB_SHP           =>  M_SOB_SHP,
    M_SOB_BLU           =>  M_SOB_BLU,
    M_SOB_YCC           =>  M_SOB_YCC,
    M_SOB_CGA           =>  M_SOB_CGA,
    M_SOB_HSV           =>  M_SOB_HSV,
    M_SOB_HSL           =>  M_SOB_HSL,
    img_width           =>  img_width,
    img_height          =>  img_width + 100,
    adwrWidth           =>  adwrWidth,
    addrWidth           =>  addrWidth,
    s_data_width        =>  s_data_width,
    i_data_width        =>  i_data_width)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    txCord              => cord,
    iLumTh              => iLumTh,
    iSobelTh            => iSobelTh,
    iVideoChannel       => iVideoChannel,
    iRgb                => rgbIn,
    iHsvPerCh           => iHsvPerCh,
    iYccPerCh           => iYccPerCh,
    iAls                => iAls,
    iKcoeff             => iKcoeff,
    iFilterId           => iFilterId,
    oKcoeff             => oKcoeff,
    edgeValid           => edgeValid,
    blur_channels       => blur_channels,
    oRgb                => rgbImageFilters);
detectInst: detect_pixel
generic map(
    i_data_width        => i_data_width)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => rgbIn,
    rgbCoord            => iRgbCoord,
    endOfFrame          => iRgbSet.pEof,
    iCord               => cord,
    pDetect             => rgbDetectLock,
    oRgb                => rgbDetect);
pointOfInterestInst: point_of_interest
generic map(
    i_data_width        => i_data_width,
    s_data_width        => s_data_width,
    b_data_width        => b_data_width)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => rgbIn,
    iCord               => cord,
    endOfFrame          => iRgbSet.pEof,
    gridLockDatao       => oGridLockData,
    iRoi                => iRoi,
    fifoStatus          => oFifoStatus,
    oGridLocation       => rgbPoiLock,
    oRgb                => rgbPoi);
end architecture;