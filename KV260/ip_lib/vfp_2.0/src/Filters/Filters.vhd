--------------------------------------------------------------------------------
--
-- Filename      : filters.vhd
-- Create Date   : 05022019 [05-02-2019]
-- Modified Date : 12302021 [12-30-2021]
-- Author        : Zakinder
--
-- Description:
-- This file instantiation
--
--------------------------------------------------------------------------------
-- filter_dith_1_inst  : dither_filter
-- filter_blur_1_inst  : blur_filter
-- filter_dith_2_inst  : dither_filter
-- filter_blur_2_inst  : blur_filter
-- filter_dith_3_inst  : dither_filter
-- filter_blur_3_inst  : blur_filter
-- filter_kernel_inst  : kernel
-- filter_blur_4_inst  : blur_filter
-- filter_colcor_inst  : color_correction
-- filter_sharpe_inst  : sharp_filter
-- sharp_f_valid_inst  : d_valid
-- filter_blur_5_inst  : blur_filter
-- blurr_f_valid_inst  : d_valid
-- filter_y_cbcr_inst  : rgb_ycbcr
-- test_patterns_inst  : testpattern
-- frame_masking_inst  : frame_mask
-- frame_masking_inst  : frame_mask
-- sob_hsv_syncr_inst  : sync_frames
-- frame_masking_inst  : frame_mask
-- sob_hsv_syncr_inst  : sync_frames
-- frame_masking_inst  : frame_mask
-- frame_masking_inst  : frame_mask
-- frame_masking_inst  : frame_mask
-- tap_mk_sobcga_inst  : taps_controller
-- sob_rgb_syncr_inst  : sync_frames
-- frame_masking_inst  : frame_mask
-- frame_masking_inst  : frame_mask
-- frame_masking_inst  : frame_mask
-- ycbcr_rgb_sel_inst  : rgb_select
-- ycbcr_f_valid_inst  : d_valid
-- k_hsv_rgb_sel_inst  : rgb_select
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity filters is
generic (
    HSV_L                    : boolean := false;
    HSV_1                    : boolean := false;
    HSV_2                    : boolean := false;
    HSV_3                    : boolean := false;
    HSV_4                    : boolean := false;
    HSVL1                    : boolean := false;
    HSVL2                    : boolean := false;
    HSVL3                    : boolean := false;
    HSVL4                    : boolean := false;
    F_RE1                    : boolean := false;
    F_RE2                    : boolean := false;
    F_RE3                    : boolean := false;
    F_RE4                    : boolean := false;
    F_RE5                    : boolean := false;
    F_RE6                    : boolean := false;
    F_RE7                    : boolean := false;
    F_RE8                    : boolean := false;
    FCMYK                    : boolean := false;
    F_XYZ                    : boolean := false;
    F_LMS                    : boolean := false;
    YPBPR                    : boolean := false;
    F_YUV                    : boolean := false;
    YDRDB                    : boolean := false;
    YC1C2                    : boolean := false;
    F_IPT                    : boolean := false;
    F_YIQ                    : boolean := false;
    F_HED                    : boolean := false;
    FOHTA                    : boolean := false;
    FMICC                    : boolean := false;
    F_CC1                    : boolean := false;
    F_CC2                    : boolean := false;
    F_CC3                    : boolean := false;
    F_CC4                    : boolean := false;
    F_CC5                    : boolean := false;
    F_CC6                    : boolean := false;
    F_CC7                    : boolean := false;
    F_CC8                    : boolean := false;
    F_TES                    : boolean := false;
    F_LUM                    : boolean := false;
    F_TRM                    : boolean := false;
    F_RGB                    : boolean := false;
    F_OHS                    : boolean := false;
    F_SHP                    : boolean := false;
    F_BLU                    : boolean := false;
    F_EMB                    : boolean := false;
    F_YCC                    : boolean := false;
    F_SOB                    : boolean := false;
    F_CGA                    : boolean := false;
    F_HSV                    : boolean := false;
    F_HSL                    : boolean := false;
    L_BLU                    : boolean := false;
    L_AVG                    : boolean := false;
    L_OBJ                    : boolean := false;
    L1CGA                    : boolean := false;
    L2CGA                    : boolean := false;
    L3CGA                    : boolean := false;
    L4CGA                    : boolean := false;
    L5CGA                    : boolean := false;
    L6CGA                    : boolean := false;
    L7CGA                    : boolean := false;
    L8CGA                    : boolean := false;
    LCCM1                    : boolean := false;
    LCCM2                    : boolean := false;
    LCCM3                    : boolean := false;
    LCCM4                    : boolean := false;
    LCCM5                    : boolean := false;
    LCCM6                    : boolean := false;
    LCCM7                    : boolean := false;
    LCCM8                    : boolean := false;
    L_YCC                    : boolean := false;
    L_SHP                    : boolean := false;
    L_D1T                    : boolean := false;
    L_B1T                    : boolean := false;
    L_HIS                    : boolean := false;
    L_SPC                    : boolean := false;
    M_SOB_LUM                : boolean := false;
    M_SOB_TRM                : boolean := false;
    M_SOB_RGB                : boolean := false;
    M_SOB_SHP                : boolean := false;
    M_SOB_BLU                : boolean := false;
    M_SOB_YCC                : boolean := false;
    M_SOB_CGA                : boolean := false;
    M_SOB_HSV                : boolean := false;
    M_SOB_HSL                : boolean := false;
    F_BLUR_CHANNELS          : boolean := false;
    F_DITH_CHANNELS          : boolean := false;
    img_width                : integer := 4096;
    img_height               : integer := 4096;
    adwrWidth                : integer := 16;
    addrWidth                : integer := 12;
    s_data_width             : integer := 16;
    i_data_width             : integer := 8);
port (
    clk                      : in std_logic;
    rst_l                    : in std_logic;
    txCord                   : in coord;
    iRgb                     : in channel;
    iLumTh                   : in integer;
    iSobelTh                 : in integer;
    iVideoChannel            : in integer;
    iFilterId                : in integer;
    iHsvPerCh                : in integer;
    iYccPerCh                : in integer;
    iAls                     : in coefficient;
    iKcoeff                  : in kernelCoeff;
    oKcoeff                  : out kernelCoeff;
    edgeValid                : out std_logic;
    blur_channels            : out blur_frames;
    oRgb                     : out frameColors);
end filters;
architecture Behavioral of filters is
    signal rgbImageKernel      : colors;
    signal rgbLocFilt          : local_filters;
    signal rgbLocSynSFilt      : local_filters;
    constant init_channel      : channel := (valid => lo, red => black, green => black, blue => black);
    signal fRgb                : frameColors;
    signal sEdgeValid          : std_logic;
    signal ycbcrValid          : std_logic;
    signal fRgb1               : colors;
    signal fRgb2               : colors;
    signal fRgb3               : colors;
    signal cgainIoIn           : channel;
    signal sharpIoIn           : channel;
    signal blurIoIn            : channel;
    signal YcbcrIoIn           : channel;
    signal cgainIoOut          : channel;
    signal cgainValidRgb       : channel;
    signal sharpIoOut          : channel;
    signal blurIoOut           : channel;
    signal sharpIodValid       : channel;
    signal blurIodValid        : channel;
    signal YcbcrIoOut          : channel;
    signal YcbcrIoOutSelect    : channel;
    signal blur1vx             : channel;
    signal blur11x             : channel;
    signal blur2vx             : channel;
    signal blur21x             : channel;
    signal blur3vx             : channel;
    signal blur31x             : channel;
    signal ditRgb1vx           : channel;
    signal ditRgb2vx           : channel;
    signal ditRgb3vx           : channel;
    signal rgbSel              : channel;
    signal vhsv                : channel;
    signal vh1s                : channel;
    signal vh2s                : channel;
    signal vh3s                : channel;
    signal rgb_hsvl            : channel;
    signal rgb_hsvl_sync       : channel;
    signal rgb_histo           : channel;
    signal eObject             : channel;
    signal color_limits        : type_RgbArray(0 to 7);
    signal valid_vhs           : std_logic;
    signal rgb                 : channel;
    signal rgbYcbcr            : channel;
    signal rgb1Ycbcr           : channel;
    signal ccc1                : channel;
    signal ccc2                : channel;
    signal ccc3                : channel;
    signal ccc4                : channel;
    signal ccc5                : channel;
    signal ccc6                : channel;
    signal ccc7                : channel;
    signal ccc8                : channel;
    signal ccm1                : channel;
    signal ccm2                : channel;
    signal ccm3                : channel;
    signal ccm4                : channel;
    signal ccm5                : channel;
    signal ccm6                : channel;
    signal ccm7                : channel;
    signal ccm8                : channel;
    signal rgb_contrast_bright : channel;
begin
    edgeValid                 <= sEdgeValid;
    oRgb                      <= fRgb;
    blur_channels.ditRgb1vx   <= ditRgb1vx;
    blur_channels.ditRgb2vx   <= ditRgb2vx;
    blur_channels.ditRgb3vx   <= ditRgb3vx;
    blur_channels.blur1vx     <= blur21x;
    blur_channels.blur2vx     <= blur31x;
    blur_channels.blur3vx     <= blur3vx;
    fRgb.blur1vx              <= blur1vx;
    fRgb.blur2vx              <= blur2vx;
    fRgb.blur3vx              <= blur3vx;
    fRgb.cgainToYcbcr         <= fRgb1.ycbcr;--CgainToYcbcr
    fRgb.cgainToShp           <= fRgb1.sharp;--CgainToSharp
    fRgb.cgainToBlu           <= fRgb1.blur; --CgainToBlur
    fRgb.cgainToCgain         <= fRgb1.cgain;--CgainToCgain
    fRgb.shpToYcbcr           <= fRgb2.ycbcr;--SharpToYcbcr
    fRgb.shpToShp             <= fRgb2.sharp;--SharpToSharp
    fRgb.shpToBlu             <= fRgb2.blur; --SharpToBlur
    fRgb.shpToCgain           <= fRgb2.cgain;--SharpToCgain
    fRgb.bluToYcc             <= fRgb3.ycbcr;--BlurToYcbcr
    fRgb.bluToShp             <= fRgb3.sharp;--BlurToSharp
    fRgb.bluToBlu             <= fRgb3.blur; --BlurToBlur
    fRgb.bluToCga             <= fRgb3.cgain;--BlurToCgain
    fRgb.cgainToHsl           <= fRgb1.hsl;  --CgainToHsl  ,HslToCgain
    fRgb.cgainToHsv           <= fRgb1.hsv;  --CgainToHsv  ,HsvToCgain
    fRgb.shpToHsl             <= fRgb2.hsl;  --SharpToHsl  ,HslToSharp
    fRgb.shpToHsv             <= fRgb2.hsv;  --SharpToHsv  ,HsvToSharp
    fRgb.bluToHsl             <= fRgb3.hsl;  --BlurToHsl   ,HslToBlur
    fRgb.bluToHsv             <= fRgb3.hsv;  --BlurToHsv   ,HsvToBlur
    fRgb.synBlur              <= rgbLocSynSFilt.blur;
    fRgb.vhsv                 <= vhsv;
    fRgb.hsvl                 <= rgb_hsvl;
    fRgb.histogram            <= rgb_histo;
    fRgb.eObject              <= eObject;
lThSelectP: process (clk) begin
    if rising_edge(clk) then
        if (iLumTh >= 0)  then
            rgbSel     <= iRgb;
        else
            rgbSel     <= blur3vx;
        end if;
    end if;
end process lThSelectP;

rgb_contrast_brightness_inst: rgb_contrast_brightness
generic map (
    exposer_val  => 0)
port map (                  
    clk               => clk,
    rst_l             => rst_l,
    iRgb              => iRgb,
    oRgb              => rgb_contrast_bright);

rgb_range_inst: rgb_range
generic map (
    i_data_width       => i_data_width)
port map (                  
    clk                => clk,
    reset              => rst_l,
    iRgb               => rgb_contrast_bright,
    oRgb               => rgb);
hsvl_ycc_inst  : rgb_ycbcr
generic map(
    i_data_width         => i_data_width,
    i_precision          => 12,
    i_full_range         => TRUE)
port map(
    clk                  => clk,
    rst_l                => rst_l,
    iRgb                 => rgb_contrast_bright,
    y                    => rgbYcbcr.red,
    cb                   => rgbYcbcr.green,
    cr                   => rgbYcbcr.blue,
    oValid               => rgbYcbcr.valid);
HSV_L_ENABLE: if (HSV_L = true) generate begin
hsv_hsvl_inst: hsvl
generic map (
    i_data_width       => i_data_width)
port map (                  
    clk                => clk,
    reset              => rst_l,
    iRgb               => rgbYcbcr,
    oHsl               => rgb_hsvl_sync);
hsv_hsvl_syncr_inst  : sync_frames
generic map(
    pixelDelay      => 67)
port map(
    clk             => clk,
    reset           => rst_l,
    iRgb            => rgb_hsvl_sync,
    oRgb            => rgb_hsvl);
end generate HSV_L_ENABLE;
edge_objectsInst: edge_objects
generic map (
    i_data_width       => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => rgb,
    oRgbRemix          => eObject);
L_HIS_ENABLE: if (L_HIS = true) generate begin
rgb_histogram_inst: rgb_histogram
generic map (
    img_width          => img_width,
    img_height         => img_height)
port map (                  
    clk                => clk,
    reset              => rst_l,
    txCord             => txCord,
    iRgb               => rgb_contrast_bright,
    oRgb               => rgb_histo);
end generate L_HIS_ENABLE;
L_SPC_ENABLE: if (L_SPC = true) generate
begin
color_space_limits_inst: color_space_limits
generic map (
    i_data_width       => 8)
port map (                  
    clk                => clk,
    reset              => rst_l,
    iRgb               => rgb,
    rgbColors          => color_limits);
    fRgb.space.ch0.red   <= color_limits(0).red;
    fRgb.space.ch0.green <= color_limits(0).green;
    fRgb.space.ch0.blue  <= color_limits(0).blue;
    fRgb.space.ch0.valid <= color_limits(0).valid;
    fRgb.space.ch1.red   <= color_limits(1).red;
    fRgb.space.ch1.green <= color_limits(1).green;
    fRgb.space.ch1.blue  <= color_limits(1).blue;
    fRgb.space.ch1.valid <= color_limits(1).valid;
    fRgb.space.ch2.red   <= color_limits(2).red;
    fRgb.space.ch2.green <= color_limits(2).green;
    fRgb.space.ch2.blue  <= color_limits(2).blue;
    fRgb.space.ch2.valid <= color_limits(2).valid;
    fRgb.space.ch3.red   <= color_limits(3).red;
    fRgb.space.ch3.green <= color_limits(3).green;
    fRgb.space.ch3.blue  <= color_limits(3).blue;
    fRgb.space.ch3.valid <= color_limits(3).valid;
    fRgb.space.ch4.red   <= color_limits(4).red;
    fRgb.space.ch4.green <= color_limits(4).green;
    fRgb.space.ch4.blue  <= color_limits(4).blue;
    fRgb.space.ch4.valid <= color_limits(4).valid;
    fRgb.space.ch5.red   <= color_limits(5).red;
    fRgb.space.ch5.green <= color_limits(5).green;
    fRgb.space.ch5.blue  <= color_limits(5).blue;
    fRgb.space.ch5.valid <= color_limits(5).valid;
    fRgb.space.ch6.red   <= color_limits(6).red;
    fRgb.space.ch6.green <= color_limits(6).green;
    fRgb.space.ch6.blue  <= color_limits(6).blue;
    fRgb.space.ch6.valid <= color_limits(6).valid;
    fRgb.space.ch7.red   <= color_limits(7).red;
    fRgb.space.ch7.green <= color_limits(7).green;
    fRgb.space.ch7.blue  <= color_limits(7).blue;
    fRgb.space.ch7.valid <= color_limits(7).valid;
end generate L_SPC_ENABLE;
-- cgainIoIn Input to local cgain module
-- cgainIoOut Output of local cgain module
CgainIoP: process (clk) begin
    if rising_edge(clk) then
        if (iVideoChannel = FILTER_SHP_TO_CGA) then
            cgainIoIn           <= rgbImageKernel.sharp;--SharpToCgain
            fRgb2.cgain         <= cgainIoOut;
        elsif(iVideoChannel = FILTER_CGA_TO_HSL)then
            cgainIoIn           <= rgbImageKernel.hsl;  --CgainToHsl  ,HslToCgain
            fRgb1.hsl           <= cgainIoOut;
        elsif(iVideoChannel = FILTER_CGA_TO_HSV)then
            cgainIoIn           <= rgbImageKernel.hsv;  --CgainToHsv  ,HsvToCgain
            fRgb1.hsv           <= cgainIoOut;
        elsif(iVideoChannel = FILTER_BLU_TO_CGA)then
            cgainIoIn           <= rgbLocFilt.blur; --BlurToCgain
            fRgb3.cgain         <= cgainIoOut;
        elsif(iVideoChannel = FILTER_K_CGA)then
            cgainIoIn           <= rgbImageKernel.hsl; --Kernal Cgain
            fRgb1.cgain         <= cgainIoOut;
            fRgb3.cgain         <= rgbImageKernel.cgain;
        else
            cgainIoIn           <= cgainValidRgb;--CgainToCgain
            fRgb1.cgain         <= cgainIoOut;
        end if;
    end if;
end process CgainIoP;
SharpIoP: process (clk) begin
    if rising_edge(clk) then
        if (iVideoChannel = FILTER_CGA_TO_SHP) then
            sharpIoIn           <= cgainValidRgb;--CgainToSharp
            fRgb1.sharp         <= sharpIoOut;
        elsif(iVideoChannel = FILTER_SHP_TO_HSL)then
            sharpIoIn           <= rgbImageKernel.hsl;  --SharpToHsl  ,HslToSharp
            fRgb2.hsl           <= sharpIoOut;
        elsif(iVideoChannel = FILTER_SHP_TO_HSV)then
            sharpIoIn           <= rgbImageKernel.hsv;  --SharpToHsv  ,HsvToSharp
            fRgb2.hsv           <= sharpIoOut;
        elsif(iVideoChannel = FILTER_BLU_TO_SHP)then
            sharpIoIn           <= rgbLocFilt.blur; --BlurToSharp
            fRgb3.sharp         <= sharpIoOut;
        else
            sharpIoIn           <= rgbImageKernel.sharp;--SharpToSharp
            fRgb2.sharp         <= sharpIoOut;
        end if;
    end if;
end process SharpIoP;
BlurIoP: process (clk) begin
    if rising_edge(clk) then
        if (iVideoChannel = FILTER_CGA_TO_BLU) then
            blurIoIn            <= cgainValidRgb; --CgainToBlur
            fRgb1.blur          <= blurIoOut;
        elsif(iVideoChannel = FILTER_SHP_TO_BLU)then
            blurIoIn            <= rgbImageKernel.sharp; --SharpToBlur
            fRgb2.blur          <= blurIoOut;
        elsif(iVideoChannel = FILTER_BLU_TO_BLU)then
            blurIoIn            <= rgbLocFilt.blur;   --BlurToHsl   ,HslToBlur
            fRgb3.blur          <= blurIoOut;
        elsif(iVideoChannel = FILTER_BLU_TO_HSV)then
            blurIoIn            <= rgbImageKernel.hsv;   --BlurToHsv   ,HsvToBlur
            fRgb3.hsv           <= blurIoOut;
        elsif(iVideoChannel = FILTER_BLU_TO_HSL)then
            blurIoIn            <= rgbImageKernel.hsl;   --BlurToHsl   ,HslToBlur
            fRgb3.hsl           <= blurIoOut;
        else
            blurIoIn            <= rgbLocFilt.blur;  --BlurToBlur
            fRgb3.blur          <= blurIoOut;
        end if;
    end if;
end process BlurIoP;
YcbcrIoP: process (clk) begin
    if rising_edge(clk) then
        if (iVideoChannel = FILTER_CGA_TO_YCC) then
            YcbcrIoIn           <= cgainValidRgb; --CgainToYcbcr
            YcbcrIoOut          <= YcbcrIoOutSelect;
            fRgb1.ycbcr         <= YcbcrIoOut;
        elsif(iVideoChannel = FILTER_BLU_TO_YCC)then
            YcbcrIoIn           <= rgbLocFilt.blur;  --BlurToYcbcr
            YcbcrIoOut          <= YcbcrIoOutSelect;
            fRgb3.ycbcr         <= YcbcrIoOut;
        elsif(iVideoChannel = FILTER_SHP_TO_YCC)then
            YcbcrIoIn           <= rgbImageKernel.sharp; --SharpToYcbcr
            YcbcrIoOut          <= YcbcrIoOutSelect;
            fRgb3.ycbcr         <= YcbcrIoOut;
        else
            YcbcrIoIn           <= rgb;
            YcbcrIoOut          <= YcbcrIoOutSelect;--SharpToYcbcr
            fRgb2.ycbcr         <= YcbcrIoOut;
        end if;
    end if;
end process YcbcrIoP;
F_BLUR_CHANNELS_ENABLE: if (F_BLUR_CHANNELS = true) generate
begin
filter_blur_1_inst  : blur_filter_4by4
generic map(
    iMSB                => blurMsb,
    iLSB                => blurLsb,
    i_data_width        => i_data_width,
    img_width           => img_width,
    adwrWidth           => adwrWidth,
    addrWidth           => addrWidth)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => rgb,
    oRgb                => blur11x);
blur_1_valid_inst: d_valid
generic map (
    pixelDelay          => 4)
port map(
    clk                 => clk,
    iRgb                => blur11x,
    oRgb                => blur1vx);
filter_blur_2_inst  : blur_filter_4by4
generic map(
    iMSB                => blurMsb,
    iLSB                => blurLsb,
    i_data_width        => i_data_width,
    img_width           => img_width,
    adwrWidth           => adwrWidth,
    addrWidth           => addrWidth)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => blur1vx,
    oRgb                => blur21x);
blur_2_valid_inst: d_valid
generic map (
    pixelDelay          => 4)
port map(
    clk                 => clk,
    iRgb                => blur21x,
    oRgb                => blur2vx);
filter_blur_3_inst  : blur_filter_4by4
generic map(
    iMSB                => blurMsb,
    iLSB                => blurLsb,
    i_data_width        => i_data_width,
    img_width           => img_width,
    adwrWidth           => adwrWidth,
    addrWidth           => addrWidth)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => blur2vx,
    oRgb                => blur31x);
blur_3_valid_inst: d_valid
generic map (
    pixelDelay          => 4)
port map(
    clk                 => clk,
    iRgb                => blur31x,
    oRgb                => blur3vx);
end generate F_BLUR_CHANNELS_ENABLE;
F_DITH_CHANNELS_ENABLE: if (F_DITH_CHANNELS = true) generate
begin
filter_dith_1_inst  : dither_filter
generic map (
    img_width         => img_width,
    img_height        => img_height,
    color_width       => 8,
    reduced_width     => 5)
port map (
    clk               => clk,
    iCord_x           => txCord.x,
    iRgb              => rgb,
    oRgb              => ditRgb1vx);
filter_dith_2_inst  : dither_filter
generic map (
    img_width         => img_width,
    img_height        => img_height,
    color_width       => 8,
    reduced_width     => 4)
port map (
    clk               => clk,
    iCord_x           => txCord.x,
    iRgb              => rgb,
    oRgb              => ditRgb2vx);
filter_dith_3_inst  : dither_filter
generic map (
    img_width         => img_width,
    img_height        => img_height,
    color_width       => 8,
    reduced_width     => 3)
port map (
    clk               => clk,
    iCord_x           => txCord.x,
    iRgb              => rgb,
    oRgb              => ditRgb3vx);
end generate F_DITH_CHANNELS_ENABLE;
F_DITH_ENABLE: if (L_D1T = true) generate
signal dither_syn : channel;
begin
filter_dith_inst  : dither_filter
generic map (
    img_width         => img_width,
    img_height        => img_height,
    color_width       => 8,
    reduced_width     => 4)
port map (
    clk               => clk,
    iCord_x           => txCord.x,
    iRgb              => rgb,
    oRgb              => dither_syn);
hsv_syncr_inst  : sync_frames
generic map(
    pixelDelay => 68)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => dither_syn,
    oRgb       => fRgb.d1t);
end generate F_DITH_ENABLE;
F_DITH_BLUR_ENABLE: if (L_B1T = true) generate
signal di_bl_syn     :  channel;
begin
filter_dit_inst      : dither_filter
generic map (
    img_width         => img_width,
    img_height        => img_height,
    color_width       => 8,
    reduced_width     => 3)
port map (
    clk               => clk,
    iCord_x           => txCord.x,
    iRgb              => rgb,
    oRgb              => di_bl_syn);
b1t_syncr_inst      : sync_frames
generic map(
    pixelDelay => 68)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => di_bl_syn,
    oRgb       => fRgb.b1t);
end generate F_DITH_BLUR_ENABLE;
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
filter_kernel_inst  : kernel
generic map(
    HSV_1_FRAME         => HSV_1,
    HSV_2_FRAME         => HSV_2,
    HSV_3_FRAME         => HSV_3,
    HSV_4_FRAME         => HSV_4,
    HSVL1_FRAME         => HSVL1,
    HSVL2_FRAME         => HSVL2,
    HSVL3_FRAME         => HSVL3,
    HSVL4_FRAME         => HSVL4,
    F_RE1_FRAME         => F_RE1,
    F_RE2_FRAME         => F_RE2,
    F_RE3_FRAME         => F_RE3,
    F_RE4_FRAME         => F_RE4,
    F_RE5_FRAME         => F_RE5,
    F_RE6_FRAME         => F_RE6,
    F_RE7_FRAME         => F_RE7,
    F_RE8_FRAME         => F_RE8,
    FCMYK_FRAME         => FCMYK,
    F_XYZ_FRAME         => F_XYZ,
    F_LMS_FRAME         => F_LMS,
    YPBPR_FRAME         => YPBPR,
    F_YUV_FRAME         => F_YUV,
    YDRDB_FRAME         => YDRDB,
    YC1C2_FRAME         => YC1C2,
    F_IPT_FRAME         => F_IPT,
    F_YIQ_FRAME         => F_YIQ,
    F_HED_FRAME         => F_HED,
    FOHTA_FRAME         => FOHTA,
    FMICC_FRAME         => FMICC,
    F_CC1_FRAME         => F_CC1,
    F_CC2_FRAME         => F_CC2,
    F_CC3_FRAME         => F_CC3,
    F_CC4_FRAME         => F_CC4,
    F_CC5_FRAME         => F_CC5,
    F_CC6_FRAME         => F_CC6,
    F_CC7_FRAME         => F_CC7,
    F_CC8_FRAME         => F_CC8,
    INRGB_FRAME         => F_RGB,
    RGBLP_FRAME         => F_LUM,
    RGBTR_FRAME         => F_TRM,
    COHSL_FRAME         => F_OHS,
    SHARP_FRAME         => F_SHP,
    BLURE_FRAME         => F_BLU,
    EMBOS_FRAME         => F_EMB,
    YCBCR_FRAME         => F_YCC,
    SOBEL_FRAME         => F_SOB,
    CGAIN_FRAME         => F_CGA,
    CCGAIN_FRAME        => false,
    HSV_FRAME           => F_HSV,
    HSL_FRAME           => F_HSL,
    img_width           => img_width,
    img_height          => img_height,
    s_data_width        => s_data_width,
    i_data_width        => i_data_width)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    txCord              => txCord,
    iLumTh              => iLumTh,
    iSobelTh            => iSobelTh,
    iRgb                => iRgb,
    iKcoeff             => iKcoeff,
    iFilterId           => iFilterId,
    oKcoeff             => oKcoeff,
    oEdgeValid          => sEdgeValid,
    oRgb                => rgbImageKernel);
L_OBJ_ENABLE: if (L_OBJ = true) generate
begin
l_obj_inst: edge_objects
generic map (
    i_data_width          => i_data_width)
port map (                  
    clk                   => clk,
    rst_l                 => rst_l,
    iRgb                  => rgb_contrast_bright,
    oRgbRemix             => rgbLocFilt.lcobj);
objSyncr_inst  : sync_frames
generic map(
    pixelDelay          => 31)
port map(
    clk                 => clk,
    reset               => rst_l,
    iRgb                => rgbLocFilt.lcobj,
    oRgb                => rgbLocSynSFilt.lcobj);
end generate L_OBJ_ENABLE;
    fRgb.synLcobj        <= rgbLocSynSFilt.lcobj;
L_AVG_ENABLE: if (L_AVG = true) generate
begin
l_avg_inst: color_avg
generic map (
    i_data_width          => i_data_width)
port map (                  
    clk                   => clk,
    reset                 => rst_l,
    iRgb                  => rgb,
    oRgb                  => rgbLocFilt.rgbag);
avgSyncr_inst  : sync_frames
generic map(
    pixelDelay          => 29)
port map(
    clk                 => clk,
    reset               => rst_l,
    iRgb                => rgbLocFilt.rgbag,
    oRgb                => rgbLocSynSFilt.rgbag);
end generate L_AVG_ENABLE;
    fRgb.synRgbag        <= rgbLocSynSFilt.rgbag;
    
    
    
L_BLU_ENABLE: if (L_BLU = true) generate
begin
l_blu_inst  : blur_filter
generic map(
    iMSB                => blurMsb,
    iLSB                => blurLsb,
    i_data_width        => i_data_width,
    img_width           => img_width,
    adwrWidth           => adwrWidth,
    addrWidth           => addrWidth)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => rgb,
    oRgb                => rgbLocFilt.blur);
blurSyncr_inst  : sync_frames
generic map(
    pixelDelay          => 27)
port map(
    clk                 => clk,
    reset               => rst_l,
    iRgb                => rgbLocFilt.blur,
    oRgb                => rgbLocSynSFilt.blur);
end generate L_BLU_ENABLE;



L1CGA_ENABLE: if (L1CGA = true) generate
begin
l1cga_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => L1CGA,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccc1);
end generate L1CGA_ENABLE;
    fRgb.ccc1        <= ccc1;
L2CGA_ENABLE: if (L2CGA = true) generate
begin
l2cga_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => L2CGA,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccc2);
end generate L2CGA_ENABLE;
    fRgb.ccc2        <= ccc2;
L3CGA_ENABLE: if (L3CGA = true) generate
begin
l3cga_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => L3CGA,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccc3);
end generate L3CGA_ENABLE;
    fRgb.ccc3        <= ccc3;
L4CGA_ENABLE: if (L4CGA = true) generate
begin
l3cga_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => L4CGA,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccc4);
end generate L4CGA_ENABLE;
    fRgb.ccc4        <= ccc4;
    
L5CGA_ENABLE: if (L5CGA = true) generate
begin
l5cga_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => L5CGA,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccc5);
end generate L5CGA_ENABLE;
    fRgb.ccc5        <= ccc5;
L6CGA_ENABLE: if (L6CGA = true) generate
begin
l6cga_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => L6CGA,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccc6);
end generate L6CGA_ENABLE;
    fRgb.ccc6        <= ccc6;
L7CGA_ENABLE: if (L7CGA = true) generate
begin
l3cga_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => L7CGA,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccc7);
end generate L7CGA_ENABLE;
    fRgb.ccc7        <= ccc7;
L8CGA_ENABLE: if (L8CGA = true) generate
begin
l8cga_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => L8CGA,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccc8);
end generate L8CGA_ENABLE;
    fRgb.ccc8        <= ccc8;
    

    
    
    
    
    
LCCM1_ENABLE: if (LCCM1 = true) generate
begin
lccm1_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => LCCM1,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccm1);
end generate LCCM1_ENABLE;
    fRgb.ccm1        <= ccm1;
    

LCCM2_ENABLE: if (LCCM2 = true) generate
begin
lccm2_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => LCCM2,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccm2);
end generate LCCM2_ENABLE;
    fRgb.ccm2        <= ccm2;
    
    
    
    
LCCM3_ENABLE: if (LCCM3 = true) generate
begin
lccm3_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => LCCM3,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccm3);
end generate LCCM3_ENABLE;
    fRgb.ccm3        <= ccm3;
    
    
LCCM4_ENABLE: if (LCCM4 = true) generate
begin
lccm4_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => LCCM4,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccm4);
end generate LCCM4_ENABLE;
    fRgb.ccm4        <= ccm4;
    
    
LCCM5_ENABLE: if (LCCM5 = true) generate
begin
lccm5_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => LCCM5,
    CCM6               => false,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccm5);
end generate LCCM5_ENABLE;
    fRgb.ccm5        <= ccm5;
    
LCCM6_ENABLE: if (LCCM6 = true) generate
begin
lccm6_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => LCCM6,
    CCM7               => false,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccm6);
end generate LCCM6_ENABLE;
    fRgb.ccm6        <= ccm6;
    
    
    
    
LCCM7_ENABLE: if (LCCM7 = true) generate
begin
lccm7_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => LCCM7,
    CCM8               => false,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccm7);
end generate LCCM7_ENABLE;
    fRgb.ccm7        <= ccm7;
    
    
    
LCCM8_ENABLE: if (LCCM8 = true) generate
begin
lccm8_recolor_rgb_inst: recolor_rgb
generic map (
    CCC1               => false,
    CCC2               => false,
    CCC3               => false,
    CCC4               => false,
    CCC5               => false,
    CCC6               => false,
    CCC7               => false,
    CCC8               => false,
    CCM1               => false,
    CCM2               => false,
    CCM3               => false,
    CCM4               => false,
    CCM5               => false,
    CCM6               => false,
    CCM7               => false,
    CCM8               => LCCM8,
    img_width          => img_width,
    i_k_config_number  => i_data_width)
port map (                  
    clk                => clk,
    rst_l              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => ccm8);
end generate LCCM8_ENABLE;
    fRgb.ccm8        <= ccm8;
    
    
    
    
    
    
L_SHP_ENABLE: if (L_SHP = true) generate
begin
l_shp_inst  : sharp_filter
generic map(
    i_data_width        => i_data_width,
    img_width           => img_width,
    adwrWidth           => adwrWidth,
    addrWidth           => addrWidth)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => rgb,
    kls                 => iAls,
    oRgb                => rgbLocFilt.sharp);
sharpSyncr_inst  : sync_frames
generic map(
    pixelDelay          => 27)
port map(
    clk                 => clk,
    reset               => rst_l,
    iRgb                => rgbLocFilt.sharp,
    oRgb                => rgbLocSynSFilt.sharp);
end generate L_SHP_ENABLE;
    fRgb.synSharp        <= rgbLocSynSFilt.sharp;
L_YCC_ENABLE: if (L_YCC = true) generate
begin
l_ycc_inst  : rgb_ycbcr
generic map(
    i_data_width         => i_data_width,
    i_precision          => 12,
    i_full_range         => TRUE)
port map(
    clk                  => clk,
    rst_l                => rst_l,
    iRgb                 => rgb_contrast_bright,
    y                    => rgbLocFilt.ycbcr.red,
    cb                   => rgbLocFilt.ycbcr.green,
    cr                   => rgbLocFilt.ycbcr.blue,
    oValid               => rgbLocFilt.ycbcr.valid);
yccSyncr_inst  : sync_frames
generic map(
    pixelDelay           => 27)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => rgbLocFilt.ycbcr,
    oRgb                 => rgbLocSynSFilt.ycbcr);
end generate L_YCC_ENABLE;
    fRgb.synYcbcr                    <= rgbLocSynSFilt.ycbcr;
filter_colcor_inst  : color_correction
generic map(
    i_k_config_number   => 0)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => cgainIoIn,
    als                 => iAls,
    oRgb                => cgainIoOut);
filter_sharpe_inst  : sharp_filter
generic map(
    i_data_width        => i_data_width,
    img_width           => img_width,
    adwrWidth           => adwrWidth,
    addrWidth           => addrWidth)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => sharpIoIn,
    kls                 => iAls,
    oRgb                => sharpIodValid);
sharp_f_valid_inst  : d_valid
generic map (
    pixelDelay   => 25)
port map(
    clk      => clk,
    iRgb     => sharpIodValid,
    oRgb     => sharpIoOut);
filter_blur_5_inst  : blur_filter
generic map(
    iMSB                => blurMsb,
    iLSB                => blurLsb,
    i_data_width        => i_data_width,
    img_width           => img_width,
    adwrWidth           => adwrWidth,
    addrWidth           => addrWidth)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => blurIoIn,
    oRgb                => blurIodValid);
blurr_f_valid_inst  : d_valid
generic map (
    pixelDelay   => 16)
port map(
    clk      => clk,
    iRgb     => blurIodValid,
    oRgb     => blurIoOut);
filter_y_cbcr_inst  : rgb_ycbcr
generic map(
    i_data_width         => i_data_width,
    i_precision          => 12,
    i_full_range         => TRUE)
port map(
    clk                  => clk,
    rst_l                => rst_l,
    iRgb                 => YcbcrIoIn,
    y                    => YcbcrIoOutSelect.red,
    cb                   => YcbcrIoOutSelect.green,
    cr                   => YcbcrIoOutSelect.blue,
    oValid               => YcbcrIoOutSelect.valid);
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
TEST_FRAME_ENABLE: if (F_TES = true) generate
begin
test_patterns_inst  : testpattern
port map(
    clk           => clk,
    iValid        => rgb.valid,
    iCord         => txCord,
    tpSelect      => iLumTh,
    oRgb          => fRgb.tPattern);
end generate TEST_FRAME_ENABLE;
MASK_SOB_CGA_FRAME_ENABLE : if (M_SOB_CGA = true) generate
    signal tp2cgain   : channel;
    signal tp2        : std_logic_vector(23 downto 0) := (others => '0');
    alias tp2Red      : std_logic_vector(7 downto 0) is tp2(23 downto 16);
    alias tp2Green    : std_logic_vector(7 downto 0) is tp2(15 downto 8);
    alias tp2Blue     : std_logic_vector(7 downto 0) is tp2(7 downto 0);
    signal tpValid    : std_logic  := lo;
begin
TapsControllerSobCgaInst: taps_controller
generic map(
    img_width    => img_width,
    tpDataWidth  => 24)
port map(
    clk          => clk,
    rst_l        => rst_l,
    iRgb         => rgbImageKernel.cgain,
    tpValid      => tpValid,
    tp0          => open,
    tp1          => open,
    tp2          => tp2);
process (clk,rst_l) begin
    if (rst_l = lo) then
        tp2cgain.red   <= black;
        tp2cgain.green <= black;
        tp2cgain.blue  <= black;
        tp2cgain.valid <= lo;
    elsif rising_edge(clk) then
        tp2cgain.red   <= tp2Red;
        tp2cgain.green <= tp2Green;
        tp2cgain.blue  <= tp2Blue;
        tp2cgain.valid <= tpValid;
    end if;
end process;
frame_masking_inst  : frame_mask
generic map (
    eBlack       => true)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => rgbImageKernel.sobel,
    i2Rgb       => tp2cgain,
    oRgb        => fRgb.maskSobelCga);
end generate MASK_SOB_CGA_FRAME_ENABLE;
MASK_SOB_TRM_FRAME_ENABLE: if (M_SOB_TRM = true) generate
begin
frame_masking_inst  : frame_mask
generic map (
    eBlack       => true)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => rgbImageKernel.sobel,
    i2Rgb       => rgbImageKernel.colorTrm,
    oRgb        => fRgb.maskSobelTrm);
end generate MASK_SOB_TRM_FRAME_ENABLE;



MASK_SOB_HSL_FRAME_ENABLE: if (M_SOB_HSL = true) generate
begin
frame_masking_inst  : frame_mask
generic map (
    eBlack       => false)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => ccc2,
    i2Rgb       => ccc1,
    oRgb        => fRgb.maskSobelHsl);
end generate MASK_SOB_HSL_FRAME_ENABLE;



MASK_SOB_HSV_FRAME_ENABLE: if (M_SOB_HSV = true) generate
begin
frame_masking_inst  : frame_mask
generic map (
    eBlack       => true)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => rgbImageKernel.sobel,
    i2Rgb       => rgbImageKernel.hsv,
    oRgb        => fRgb.maskSobelHsv);
end generate MASK_SOB_HSV_FRAME_ENABLE;



MASK_SOB_YCC_FRAME_ENABLE: if (M_SOB_YCC = true) generate
begin
frame_masking_inst  : frame_mask
generic map (
    eBlack       => true)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => rgbImageKernel.sobel,
    i2Rgb       => YcbcrIoOutSelect,
    oRgb        => fRgb.maskSobelYcc);
end generate MASK_SOB_YCC_FRAME_ENABLE;
MASK_SOB_SHP_FRAME_ENABLE: if (M_SOB_SHP = true) generate
begin
frame_masking_inst  : frame_mask
generic map (
    eBlack       => true)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => rgbImageKernel.sobel,
    i2Rgb       => rgbImageKernel.sharp,
    oRgb        => fRgb.maskSobelShp);
end generate MASK_SOB_SHP_FRAME_ENABLE;
MASK_SOB_RGB_FRAME_ENABLE: if (M_SOB_RGB = true) generate
    constant sobRgbPiDelay : integer := 14;
    signal tp2inrgb        : channel;
    signal tp2             : std_logic_vector(23 downto 0) := (others => '0');
    alias tp2Red           : std_logic_vector(7 downto 0) is tp2(23 downto 16);
    alias tp2Green         : std_logic_vector(7 downto 0) is tp2(15 downto 8);
    alias tp2Blue          : std_logic_vector(7 downto 0) is tp2(7 downto 0);
    signal tpValid         : std_logic  := lo;
    signal d1Rgb           : channel;
begin
tap_mk_sobcga_inst  : taps_controller
generic map(
    img_width    => img_width,
    tpDataWidth  => 24)
port map(
    clk          => clk,
    rst_l        => rst_l,
    iRgb         => rgbImageKernel.inrgb,
    tpValid      => tpValid,
    tp0          => open,
    tp1          => open,
    tp2          => tp2);
process (clk,rst_l) begin
    if (rst_l = lo) then
        tp2inrgb.red   <= black;
        tp2inrgb.green <= black;
        tp2inrgb.blue  <= black;
        tp2inrgb.valid <= lo;
    elsif rising_edge(clk) then
        tp2inrgb.red   <= tp2Red;
        tp2inrgb.green <= tp2Green;
        tp2inrgb.blue  <= tp2Blue;
        tp2inrgb.valid <= tpValid;
    end if;
end process;
sob_rgb_syncr_inst  : sync_frames
generic map(
    pixelDelay => sobRgbPiDelay)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => tp2inrgb,
    oRgb       => d1Rgb);
frame_masking_inst  : frame_mask
generic map (
    eBlack       => true)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => rgbImageKernel.re2color,
    i2Rgb       => rgbImageKernel.re1color,
    oRgb        => fRgb.maskSobelRgb);
end generate MASK_SOB_RGB_FRAME_ENABLE;
MASK_SOB_LUM_FRAME_ENABLE: if (M_SOB_LUM = true) generate
begin
frame_masking_inst  : frame_mask
generic map (
    eBlack       => false)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => fRgb.space.ch4,
    i2Rgb       => rgbImageKernel.re1color,
    oRgb        => fRgb.maskSobelLum);
end generate MASK_SOB_LUM_FRAME_ENABLE;
MASK_SOB_BLU_FRAME_ENABLE: if (M_SOB_BLU = true) generate
begin
frame_masking_inst  : frame_mask
generic map (
    eBlack       => true)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => rgbImageKernel.re1color,
    i2Rgb       => fRgb.space.ch4,
    oRgb        => fRgb.maskSobelBlu);
end generate MASK_SOB_BLU_FRAME_ENABLE;
F_CC1_FRAME_ENABLE: if (F_CC1 = true) generate
    fRgb.cc1 <= rgbImageKernel.cc1;
end generate F_CC1_FRAME_ENABLE;
F_CC2_FRAME_ENABLE: if (F_CC2 = true) generate
    fRgb.cc2 <= rgbImageKernel.cc2;
end generate F_CC2_FRAME_ENABLE;
F_CC3_FRAME_ENABLE: if (F_CC3 = true) generate
    fRgb.cc3 <= rgbImageKernel.cc3;
end generate F_CC3_FRAME_ENABLE;
F_CC4_FRAME_ENABLE: if (F_CC4 = true) generate
    fRgb.cc4 <= rgbImageKernel.cc4;
end generate F_CC4_FRAME_ENABLE;
F_CC5_FRAME_ENABLE: if (F_CC5 = true) generate
    fRgb.cc5 <= rgbImageKernel.cc5;
end generate F_CC5_FRAME_ENABLE;
F_CC6_FRAME_ENABLE: if (F_CC6 = true) generate
    fRgb.cc6 <= rgbImageKernel.cc6;
end generate F_CC6_FRAME_ENABLE;
F_CC7_FRAME_ENABLE: if (F_CC7 = true) generate
    fRgb.cc7 <= rgbImageKernel.cc7;
end generate F_CC7_FRAME_ENABLE;
F_CC8_FRAME_ENABLE: if (F_CC8 = true) generate
    fRgb.cc8 <= rgbImageKernel.cc8;
end generate F_CC8_FRAME_ENABLE;
CMYK_FRAME_ENABLE: if (FCMYK = true) generate
    fRgb.cmyk <= rgbImageKernel.cmyk;
end generate CMYK_FRAME_ENABLE;
XYZ_FRAME_ENABLE: if (F_XYZ = true) generate
    fRgb.xyz <= rgbImageKernel.xyz;
end generate XYZ_FRAME_ENABLE;
LMS_FRAME_ENABLE: if (F_LMS = true) generate
    fRgb.lms <= rgbImageKernel.lms;
end generate LMS_FRAME_ENABLE;
YPBPR_FRAME_ENABLE: if (YPBPR = true) generate
    fRgb.ypbpr <= rgbImageKernel.ypbpr;
end generate YPBPR_FRAME_ENABLE;
YDRDB_FRAME_ENABLE: if (YDRDB = true) generate
    fRgb.ydrdb <= rgbImageKernel.ydrdb;
end generate YDRDB_FRAME_ENABLE;


YUV_FRAME_ENABLE: if (F_YUV = true) generate
    fRgb.yuv <= rgbImageKernel.yuv;
end generate yuv_FRAME_ENABLE;
YC1C2_FRAME_ENABLE: if (YC1C2 = true) generate
    fRgb.yc1c2 <= rgbImageKernel.yc1c2;
end generate YC1C2_FRAME_ENABLE;
F_IPT_FRAME_ENABLE: if (F_IPT = true) generate
    fRgb.ipt <= rgbImageKernel.ipt;
end generate F_IPT_FRAME_ENABLE;
F_YIQ_FRAME_ENABLE: if (F_YIQ = true) generate
    fRgb.yiq <= rgbImageKernel.yiq;
end generate F_YIQ_FRAME_ENABLE;
F_HED_FRAME_ENABLE: if (F_HED = true) generate
    fRgb.hed <= rgbImageKernel.hed;
end generate F_HED_FRAME_ENABLE;
FOHTA_FRAME_ENABLE: if (FOHTA = true) generate
    fRgb.ohta <= rgbImageKernel.ohta;
end generate FOHTA_FRAME_ENABLE;
FMICC_FRAME_ENABLE: if (FMICC = true) generate
    fRgb.micc <= rgbImageKernel.micc;
end generate FMICC_FRAME_ENABLE;
INRGB_FRAME_ENABLE: if (F_RGB = true) generate
    fRgb.inrgb <= rgbImageKernel.inrgb;
end generate INRGB_FRAME_ENABLE;
YCBCR_FRAME_ENABLE: if (F_YCC = true) generate
begin
    fRgb.ycbcr <= rgbImageKernel.ycbcr;
end generate YCBCR_FRAME_ENABLE;
SHARP_FRAME_ENABLE: if (F_SHP = true) generate
begin
    fRgb.sharp <= rgbImageKernel.sharp;
end generate SHARP_FRAME_ENABLE;
BLURE_FRAME_ENABLE: if (F_BLU = true) generate
begin
    fRgb.blur <= rgbImageKernel.blur;
end generate BLURE_FRAME_ENABLE;
EMBOS_FRAME_ENABLE: if (F_EMB = true) generate
begin
    fRgb.embos <= rgbImageKernel.embos;
end generate EMBOS_FRAME_ENABLE;
SOBEL_FRAME_ENABLE: if (F_SOB = true) generate
signal sobel_delay : channel;
begin
    fRgb.sobel <= rgbImageKernel.sobel;
end generate SOBEL_FRAME_ENABLE;
CGAIN_FRAME_ENABLE: if (F_CGA = true) generate begin
    fRgb.cgain <= rgbImageKernel.cgain;
end generate CGAIN_FRAME_ENABLE;
HSL_FRAME_ENABLE: if (F_HSL = true) generate
    fRgb.hsl        <= rgbImageKernel.hsl;
end generate HSL_FRAME_ENABLE;
HSV_FRAME_ENABLE: if (F_HSV = true) generate
    fRgb.hsv <= rgbImageKernel.hsv;
end generate HSV_FRAME_ENABLE;
HSV_1_FRAME_ENABLE: if (HSV_1 = true) generate
    fRgb.hsl1_range <= rgbImageKernel.hsl1_range;
end generate HSV_1_FRAME_ENABLE;
HSV_2_FRAME_ENABLE: if (HSV_2 = true) generate
    fRgb.hsl2_range <= rgbImageKernel.hsl2_range;
end generate HSV_2_FRAME_ENABLE;
HSV_3_FRAME_ENABLE: if (HSV_3 = true) generate
    fRgb.hsl3_range <= rgbImageKernel.hsl3_range;
end generate HSV_3_FRAME_ENABLE;
HSV_4_FRAME_ENABLE: if (HSV_4 = true) generate
    fRgb.hsl4_range <= rgbImageKernel.hsl4_range;
end generate HSV_4_FRAME_ENABLE;
HSVL1_FRAME_ENABLE: if (HSVL1 = true) generate
    fRgb.hsll1range <= rgbImageKernel.hsll1range;
end generate HSVL1_FRAME_ENABLE;
HSVL2_FRAME_ENABLE: if (HSVL2 = true) generate
    fRgb.hsll2range <= rgbImageKernel.hsll2range;
end generate HSVL2_FRAME_ENABLE;
HSVL3_FRAME_ENABLE: if (HSVL3 = true) generate
    fRgb.hsll3range <= rgbImageKernel.hsll3range;
end generate HSVL3_FRAME_ENABLE;
HSVL4_FRAME_ENABLE: if (HSVL4 = true) generate
    fRgb.hsll4range <= rgbImageKernel.hsll4range;
end generate HSVL4_FRAME_ENABLE;
LUM_FRAME_ENABLE: if (F_LUM = true) generate
    fRgb.colorLmp <= rgbImageKernel.colorLmp;
end generate LUM_FRAME_ENABLE;
TRM_FRAME_ENABLE: if (F_TRM = true) generate
    fRgb.colorTrm <= rgbImageKernel.colorTrm;
end generate TRM_FRAME_ENABLE;
OHS_FRAME_ENABLE: if (F_OHS = true) generate
    fRgb.colorhsl  <= rgbImageKernel.colorhsl;
end generate OHS_FRAME_ENABLE;
RE1_FRAME_ENABLE: if (F_RE1 = true) generate
    fRgb.re1color  <= rgbImageKernel.re1color;
end generate RE1_FRAME_ENABLE;
RE2_FRAME_ENABLE: if (F_RE2 = true) generate
    fRgb.re2color  <= rgbImageKernel.re2color;
end generate RE2_FRAME_ENABLE;
RE3_FRAME_ENABLE: if (F_RE3 = true) generate
    fRgb.re3color  <= rgbImageKernel.re3color;
end generate RE3_FRAME_ENABLE;
RE4_FRAME_ENABLE: if (F_RE4 = true) generate
    fRgb.re4color  <= rgbImageKernel.re4color;
end generate RE4_FRAME_ENABLE;
RE5_FRAME_ENABLE: if (F_RE5 = true) generate
    fRgb.re5color  <= rgbImageKernel.re5color;
end generate RE5_FRAME_ENABLE;
RE6_FRAME_ENABLE: if (F_RE6 = true) generate
    fRgb.re6color  <= rgbImageKernel.re6color;
end generate RE6_FRAME_ENABLE;
RE7_FRAME_ENABLE: if (F_RE7 = true) generate
    fRgb.re7color  <= rgbImageKernel.re7color;
end generate RE7_FRAME_ENABLE;
RE8_FRAME_ENABLE: if (F_RE8 = true) generate
    fRgb.re8color  <= rgbImageKernel.re8color;
end generate RE8_FRAME_ENABLE;
YDRDB_FRAME_DISABLED: if (YDRDB = false) generate
    fRgb.ydrdb <= init_channel;
end generate YDRDB_FRAME_DISABLED;
CMYK_FRAME_DISABLED: if (FCMYK = false) generate
    fRgb.cmyk <= init_channel;
end generate CMYK_FRAME_DISABLED;
XYZ_FRAME_DISABLED: if (F_XYZ = false) generate
    fRgb.xyz <= init_channel;
end generate XYZ_FRAME_DISABLED;
LMS_FRAME_DISABLED: if (F_LMS = false) generate
    fRgb.lms <= init_channel;
end generate LMS_FRAME_DISABLED;
YPBPR_FRAME_DISABLED: if (YPBPR = false) generate
    fRgb.ypbpr <= init_channel;
end generate YPBPR_FRAME_DISABLED;
YUV_FRAME_DISABLED: if (F_YUV = false) generate
    fRgb.yuv <= init_channel;
end generate YUV_FRAME_DISABLED;
YC1C2_FRAME_DISABLED: if (YC1C2 = false) generate
    fRgb.yc1c2 <= init_channel;
end generate YC1C2_FRAME_DISABLED;
F_IPT_FRAME_DISABLED: if (F_IPT = false) generate
    fRgb.ipt <= init_channel;
end generate F_IPT_FRAME_DISABLED;
F_YIQ_FRAME_DISABLED: if (F_YIQ = false) generate
    fRgb.yiq <= init_channel;
end generate F_YIQ_FRAME_DISABLED;
F_HED_FRAME_DISABLED: if (F_HED = false) generate
    fRgb.hed <= init_channel;
end generate F_HED_FRAME_DISABLED;
FOHTA_FRAME_DISABLED: if (FOHTA = false) generate
    fRgb.ohta <= init_channel;
end generate FOHTA_FRAME_DISABLED;
FMICC_FRAME_DISABLED: if (FMICC = false) generate
    fRgb.micc <= init_channel;
end generate FMICC_FRAME_DISABLED;
MASK_SOB_CGA_FRAME_DISABLED: if (M_SOB_CGA = false) generate
    fRgb.maskSobelCga  <= init_channel;
end generate MASK_SOB_CGA_FRAME_DISABLED;
MASK_SOB_TRM_FRAME_DISABLED: if (M_SOB_TRM = false) generate
    fRgb.maskSobelTrm  <= init_channel;
end generate MASK_SOB_TRM_FRAME_DISABLED;
MASK_SOB_HSL_FRAME_DISABLED: if (M_SOB_HSL = false) generate
    fRgb.maskSobelHsl  <= init_channel;
end generate MASK_SOB_HSL_FRAME_DISABLED;
MASK_SOB_HSV_FRAME_DISABLED: if (M_SOB_HSV = false) generate
    fRgb.maskSobelHsv  <= init_channel;
end generate MASK_SOB_HSV_FRAME_DISABLED;
MASK_SOB_YCC_FRAME_DISABLED: if (M_SOB_YCC = false) generate
    fRgb.maskSobelYcc  <= init_channel;
end generate MASK_SOB_YCC_FRAME_DISABLED;
MASK_SOB_SHP_FRAME_DISABLED: if (M_SOB_SHP = false) generate
    fRgb.maskSobelShp  <= init_channel;
end generate MASK_SOB_SHP_FRAME_DISABLED;
MASK_SOB_RGB_FRAME_DISABLED: if (M_SOB_RGB = false) generate
    fRgb.maskSobelRgb  <= init_channel;
end generate MASK_SOB_RGB_FRAME_DISABLED;
MASK_SOB_LUM_FRAME_DISABLED: if (M_SOB_LUM = false) generate
    fRgb.maskSobelLum  <= init_channel;
end generate MASK_SOB_LUM_FRAME_DISABLED;
MASK_SOB_BLU_FRAME_DISABLED: if (M_SOB_BLU = false) generate
    fRgb.maskSobelBlu  <= init_channel;
end generate MASK_SOB_BLU_FRAME_DISABLED;
LUM_FRAME_DISABLED: if (F_LUM = false) generate
    fRgb.colorLmp  <= init_channel;
end generate LUM_FRAME_DISABLED;
TRM_FRAME_DISABLED: if (F_TRM = false) generate
    fRgb.colorTrm  <= init_channel;
end generate TRM_FRAME_DISABLED;
OHS_FRAME_DISABLED: if (F_OHS = false) generate
    fRgb.colorhsl  <= init_channel;
end generate OHS_FRAME_DISABLED;
RE1_FRAME_DISABLED: if (F_RE1 = false) generate
    fRgb.re1color  <= init_channel;
end generate RE1_FRAME_DISABLED;
RE2_FRAME_DISABLED: if (F_RE2 = false) generate
    fRgb.re2color  <= init_channel;
end generate RE2_FRAME_DISABLED;
RE3_FRAME_DISABLED: if (F_RE3 = false) generate
    fRgb.re3color  <= init_channel;
end generate RE3_FRAME_DISABLED;
RE4_FRAME_DISABLED: if (F_RE4 = false) generate
    fRgb.re4color  <= init_channel;
end generate RE4_FRAME_DISABLED;
RE5_FRAME_DISABLED: if (F_RE5 = false) generate
    fRgb.re5color  <= init_channel;
end generate RE5_FRAME_DISABLED;
RE6_FRAME_DISABLED: if (F_RE6 = false) generate
    fRgb.re6color  <= init_channel;
end generate RE6_FRAME_DISABLED;
RE7_FRAME_DISABLED: if (F_RE7 = false) generate
    fRgb.re7color  <= init_channel;
end generate RE7_FRAME_DISABLED;
RE8_FRAME_DISABLED: if (F_RE8 = false) generate
    fRgb.re8color  <= init_channel;
end generate RE8_FRAME_DISABLED;
INRGB_FRAME_DISABLED: if (F_RGB = false) generate
    fRgb.inrgb     <= init_channel;
end generate INRGB_FRAME_DISABLED;
YCBCR_FRAME_DISABLED: if (F_YCC = false) generate
    fRgb.ycbcr     <= init_channel;
end generate YCBCR_FRAME_DISABLED;
SHARP_FRAME_DISABLED: if (F_SHP = false) generate
    fRgb.sharp     <= init_channel;
end generate SHARP_FRAME_DISABLED;
BLURE_FRAME_DISABLED: if (F_BLU = false) generate
    fRgb.blur     <= init_channel;
end generate BLURE_FRAME_DISABLED;
EMBOS_FRAME_DISABLED: if (F_EMB = false) generate
    fRgb.embos     <= init_channel;
end generate EMBOS_FRAME_DISABLED;
SOBEL_FRAME_DISABLED: if (F_SOB = false) generate
    fRgb.sobel     <= init_channel;
end generate SOBEL_FRAME_DISABLED;
CGAIN_FRAME_DISABLED: if (F_CGA = false) generate
    fRgb.cgain     <= init_channel;
end generate CGAIN_FRAME_DISABLED;
HSL_FRAME_DISABLED: if (F_HSL = false) generate
    fRgb.hsl        <= init_channel;
end generate HSL_FRAME_DISABLED;
HSV_FRAME_DISABLED: if (F_HSV = false) generate
    fRgb.hsv     <= init_channel;
end generate HSV_FRAME_DISABLED;
end Behavioral;