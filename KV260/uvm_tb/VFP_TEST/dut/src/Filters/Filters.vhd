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
    L_CGA                    : boolean := false;
    L_YCC                    : boolean := false;
    L_SHP                    : boolean := false;
    L_D1T                    : boolean := false;
    L_B1T                    : boolean := false;
    L_HIS                    : boolean := true;
    L_SPC                    : boolean := true;
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
    signal rgb_histo           : channel;
    signal eObject             : channel;
    signal color_limits        : type_RgbArray(0 to 7);
    signal valid_vhs           : std_logic;
    signal dark_ccm            : coefficient;
    signal light_ccm           : coefficient;
    signal balance_ccm         : coefficient;
    signal rgb                 : channel;
    signal rgbYcbcr            : channel;
begin
    -- 60  =  7.50
    -- 24  =  3.00
    -- 8   =  1.00
    -- 248 = -1.00
    -- 232 = -3.00
    --     =  0.50
    --    |--------|--------|--------|
    --    | +0.375 | -0.250 | -0.250 |
    --    |--------|--------|--------|
    --    | -0.250 | +1.000 | -0.250 |
    --    |--------|--------|--------|
    --    | -0.500 | -0.250 | +1.250 |
    --    |--------|--------|--------|
    dark_ccm.config           <= 1;
    dark_ccm.k1               <= std_logic_vector(to_unsigned(3,32));   --  1.000
    dark_ccm.k2               <= std_logic_vector(to_unsigned(255,32)); -- -0.500
    dark_ccm.k3               <= std_logic_vector(to_unsigned(255,32)); -- -0.250
    dark_ccm.k4               <= std_logic_vector(to_unsigned(255,32));
    dark_ccm.k5               <= std_logic_vector(to_unsigned(3,32));
    dark_ccm.k6               <= std_logic_vector(to_unsigned(255,32));
    dark_ccm.k7               <= std_logic_vector(to_unsigned(255,32));
    dark_ccm.k8               <= std_logic_vector(to_unsigned(255,32));
    dark_ccm.k9               <= std_logic_vector(to_unsigned(3,32));
    -- 30  = 3.75
    -- 35  = 4.75
    -- 40  = 5.00
    -- 45  = 5.625
    -- 48  = 6.00
    -- 255 = -0.125
    -- 254 = -0.25
    -- 248 = -1.00
    -- 232 = -3.00
    -- 224 = -4.00
    --    |--------|--------|--------|
    --    | +5.000 | -3.000 | -1.000 |
    --    |--------|--------|--------|
    --    | -1.000 | +5.000 | -3.000 |
    --    |--------|--------|--------|
    --    | -3.000 | -1.000 | +5.000 | 
    --    |--------|--------|--------|
    light_ccm.config           <= 2;
    light_ccm.k1               <= std_logic_vector(to_unsigned(40,32));
    light_ccm.k2               <= std_logic_vector(to_unsigned(232,32));
    light_ccm.k3               <= std_logic_vector(to_unsigned(248,32));
    light_ccm.k4               <= std_logic_vector(to_unsigned(248,32));
    light_ccm.k5               <= std_logic_vector(to_unsigned(56,32));
    light_ccm.k6               <= std_logic_vector(to_unsigned(232,32));
    light_ccm.k7               <= std_logic_vector(to_unsigned(232,32));
    light_ccm.k8               <= std_logic_vector(to_unsigned(248,32));
    light_ccm.k9               <= std_logic_vector(to_unsigned(80,32));
    --    |--------|--------|--------|
    --    | +0.500 | +0.375 | +0.125 |
    --    |--------|--------|--------|
    --    | +0.250 | +0.625 | +0.125 |
    --    |--------|--------|--------|
    --    | +0.125 | +0.125 | +0.750 |
    --    |--------|--------|--------|
    balance_ccm.config         <= 3;
    balance_ccm.k1             <= std_logic_vector(to_unsigned(4,32));
    balance_ccm.k2             <= std_logic_vector(to_unsigned(3,32));
    balance_ccm.k3             <= std_logic_vector(to_unsigned(1,32));
    balance_ccm.k4             <= std_logic_vector(to_unsigned(2,32));
    balance_ccm.k5             <= std_logic_vector(to_unsigned(5,32));
    balance_ccm.k6             <= std_logic_vector(to_unsigned(1,32));
    balance_ccm.k7             <= std_logic_vector(to_unsigned(80,32));
    balance_ccm.k8             <= std_logic_vector(to_unsigned(3,32));
    balance_ccm.k9             <= std_logic_vector(to_unsigned(232,32));
    edgeValid               <= sEdgeValid;
    oRgb                    <= fRgb;
    blur_channels.ditRgb1vx <= ditRgb1vx;
    blur_channels.ditRgb2vx <= ditRgb2vx;
    blur_channels.ditRgb3vx <= ditRgb3vx;
    fRgb.blur1vx            <= blur1vx;
    fRgb.blur2vx            <= blur2vx;
    fRgb.blur3vx            <= blur3vx;
    fRgb.cgainToYcbcr       <= fRgb1.ycbcr;--CgainToYcbcr
    fRgb.cgainToShp         <= fRgb1.sharp;--CgainToSharp
    fRgb.cgainToBlu         <= fRgb1.blur; --CgainToBlur
    fRgb.cgainToCgain       <= fRgb1.cgain;--CgainToCgain
    fRgb.shpToYcbcr         <= fRgb2.ycbcr;--SharpToYcbcr
    fRgb.shpToShp           <= fRgb2.sharp;--SharpToSharp
    fRgb.shpToBlu           <= fRgb2.blur; --SharpToBlur
    fRgb.shpToCgain         <= fRgb2.cgain;--SharpToCgain
    fRgb.bluToYcc           <= fRgb3.ycbcr;--BlurToYcbcr
    fRgb.bluToShp           <= fRgb3.sharp;--BlurToSharp
    fRgb.bluToBlu           <= fRgb3.blur; --BlurToBlur
    fRgb.bluToCga           <= fRgb3.cgain;--BlurToCgain
    fRgb.cgainToHsl         <= fRgb1.hsl;  --CgainToHsl  ,HslToCgain
    fRgb.cgainToHsv         <= fRgb1.hsv;  --CgainToHsv  ,HsvToCgain
    fRgb.shpToHsl           <= fRgb2.hsl;  --SharpToHsl  ,HslToSharp
    fRgb.shpToHsv           <= fRgb2.hsv;  --SharpToHsv  ,HsvToSharp
    fRgb.bluToHsl           <= fRgb3.hsl;  --BlurToHsl   ,HslToBlur
    fRgb.bluToHsv           <= fRgb3.hsv;  --BlurToHsv   ,HsvToBlur
    fRgb.synBlur            <= rgbLocSynSFilt.blur;
    fRgb.vhsv               <= vhsv;
    fRgb.hsvl               <= rgb_hsvl;
    fRgb.histogram          <= rgb_histo;
    fRgb.eObject            <= eObject;
lThSelectP: process (clk) begin
    if rising_edge(clk) then
        if (iLumTh >= 0)  then
            rgbSel     <= iRgb;
        else
            rgbSel     <= blur3vx;
        end if;
    end if;
end process lThSelectP;
rgb_range_inst: rgb_range
generic map (
    i_data_width       => i_data_width)
port map (                  
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    oRgb               => rgb);
hsvl_ycc_inst  : rgb_ycbcr
generic map(
    i_data_width         => i_data_width,
    i_precision          => 12,
    i_full_range         => TRUE)
port map(
    clk                  => clk,
    rst_l                => rst_l,
    iRgb                 => iRgb,
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
    oHsl               => rgb_hsvl);
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
    iRgb               => rgb,
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
filter_blur_1_inst  : blur_filter
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
filter_blur_2_inst  : blur_filter
generic map(
    iMSB                => blurMsb - 1,
    iLSB                => blurLsb - 1,
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
filter_blur_3_inst  : blur_filter
generic map(
    iMSB                => blurMsb - 1,
    iLSB                => blurLsb - 1,
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
    iRgb                => rgbSel,
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
    iRgb                  => rgb,
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


L_CGA_ENABLE: if (L_CGA = true) generate
signal ccm1_rgb   : channel;
signal bbm1_rgb   : channel;
begin
dark_ccm_inst  : color_correction
generic map(
    i_k_config_number   => 1)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => rgb,
    als                 => dark_ccm,
    oRgb                => ccm1_rgb);
light_ccm_inst  : color_correction
generic map(
    i_k_config_number   => 2)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => ccm1_rgb,
    als                 => light_ccm,
    oRgb                => bbm1_rgb);
balance_ccm_inst  : color_correction
generic map(
    i_k_config_number   => 0)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => bbm1_rgb,
    als                 => balance_ccm,
    oRgb                => rgbLocFilt.cgain);
blurSyncr_inst  : sync_frames
generic map(
    pixelDelay          => 27)
port map(
    clk                 => clk,
    reset               => rst_l,
    iRgb                => rgbLocFilt.cgain,
    oRgb                => rgbLocSynSFilt.cgain);
end generate L_CGA_ENABLE;
    fRgb.synCgain        <= rgbLocSynSFilt.cgain;
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
    iRgb                 => rgb,
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
    signal dSobHsl           : channel;
    constant sobHslPiDelay   : integer := 18;
begin
sob_hsv_syncr_inst  : sync_frames
generic map(
    pixelDelay => sobHslPiDelay)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => rgbImageKernel.hsl,
    oRgb       => dSobHsl);
frame_masking_inst  : frame_mask
generic map (
    eBlack       => true)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => rgbImageKernel.sobel,
    i2Rgb       => dSobHsl,
    oRgb        => fRgb.maskSobelHsl);
end generate MASK_SOB_HSL_FRAME_ENABLE;
MASK_SOB_HSV_FRAME_ENABLE: if (M_SOB_HSV = true) generate
    signal dSobHsv           : channel;
    constant sobHsvPiDelay   : integer := 18;
begin
sob_hsv_syncr_inst  : sync_frames
generic map(
    pixelDelay => sobHsvPiDelay)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => rgbImageKernel.hsv,
    oRgb       => dSobHsv);
frame_masking_inst  : frame_mask
generic map (
    eBlack       => true)
port map(
    clk         => clk,
    reset       => rst_l,
    iEdgeValid  => sEdgeValid,
    i1Rgb       => rgbImageKernel.sobel,
    i2Rgb       => dSobHsv,
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
    fRgb.re3color  <= rgbImageKernel.re3color;
    fRgb.re4color  <= rgbImageKernel.re4color;
    fRgb.re5color  <= rgbImageKernel.re5color;
    fRgb.re6color  <= rgbImageKernel.re6color;
    fRgb.re7color  <= rgbImageKernel.re7color;
    fRgb.re8color  <= rgbImageKernel.re8color;
end generate RE2_FRAME_ENABLE;
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