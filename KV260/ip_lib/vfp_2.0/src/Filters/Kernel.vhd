-------------------------------------------------------------------------------
--
-- Filename    : kernel.vhd
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
entity kernel is
generic (
    HSV_1_FRAME        : boolean := false;
    HSV_2_FRAME        : boolean := false;
    HSV_3_FRAME        : boolean := false;
    HSV_4_FRAME        : boolean := false;
    HSVL1_FRAME        : boolean := false;
    HSVL2_FRAME        : boolean := false;
    HSVL3_FRAME        : boolean := false;
    HSVL4_FRAME        : boolean := false;
    F_RE1_FRAME        : boolean := false;
    F_RE2_FRAME        : boolean := false;
    F_RE3_FRAME        : boolean := false;
    F_RE4_FRAME        : boolean := false;
    F_RE5_FRAME        : boolean := false;
    F_RE6_FRAME        : boolean := false;
    F_RE7_FRAME        : boolean := false;
    F_RE8_FRAME        : boolean := false;
    FCMYK_FRAME        : boolean := false;
    F_XYZ_FRAME        : boolean := false;
    F_LMS_FRAME        : boolean := false;
    YPBPR_FRAME        : boolean := false;
    F_YUV_FRAME        : boolean := false;
    YDRDB_FRAME        : boolean := false;
    YC1C2_FRAME        : boolean := false;
    F_IPT_FRAME        : boolean := false;
    F_YIQ_FRAME        : boolean := false;
    F_HED_FRAME        : boolean := false;
    FOHTA_FRAME        : boolean := false;
    FMICC_FRAME        : boolean := false;
    F_CC1_FRAME        : boolean := false;
    F_CC2_FRAME        : boolean := false;
    F_CC3_FRAME        : boolean := false;
    F_CC4_FRAME        : boolean := false;
    F_CC5_FRAME        : boolean := false;
    F_CC6_FRAME        : boolean := false;
    F_CC7_FRAME        : boolean := false;
    F_CC8_FRAME        : boolean := false;
    INRGB_FRAME        : boolean := false;
    RGBLP_FRAME        : boolean := false;
    RGBTR_FRAME        : boolean := false;
    COHSL_FRAME        : boolean := false;
    SHARP_FRAME        : boolean := false;
    BLURE_FRAME        : boolean := false;
    EMBOS_FRAME        : boolean := false;
    YCBCR_FRAME        : boolean := false;
    SOBEL_FRAME        : boolean := false;
    CGAIN_FRAME        : boolean := false;
    CCGAIN_FRAME       : boolean := false;
    HSV_FRAME          : boolean := false;
    HSL_FRAME          : boolean := false;
    img_width          : integer := 4096;
    img_height         : integer := 4096;
    s_data_width       : integer := 16;
    i_data_width       : integer := 8);
port (
    clk                : in std_logic;
    rst_l              : in std_logic;
    iLumTh             : in integer;
    iSobelTh           : in integer;
    txCord             : in coord;
    iRgb               : in channel;
    iKcoeff            : in kernelCoeff;
    iFilterId          : in integer;
    oKcoeff            : out kernelCoeff;
    oEdgeValid         : out std_logic;
    oRgb               : out colors);
end kernel;
architecture Behavioral of kernel is
    constant adwrWidth     : integer := 16;
    constant addrWidth     : integer := 12;
    constant init_channel  : channel := (valid => lo, red => black, green => black, blue => black);
    signal rgbMac1         : channel := (valid => lo, red => black, green => black, blue => black);
    signal rgbMac2         : channel := (valid => lo, red => black, green => black, blue => black);
    signal rgbMac3         : channel := (valid => lo, red => black, green => black, blue => black);
    signal rgbSyncValid    : std_logic_vector(15 downto 0)  := x"0000";
    signal kCoProd         : kCoefFiltFloat;
    signal cc1_sync          : channel;
    signal cc2_sync          : channel;
    signal cc3_sync          : channel;
    signal cc4_sync          : channel;
    signal cc5_sync          : channel;
    signal cc6_sync          : channel;
    signal cc7_sync          : channel;
    signal cc8_sync          : channel;
    signal cc1_cluster_range : channel;
    signal cc2_cluster_range : channel;
    signal cc3_cluster_range : channel;
    signal cc4_cluster_range : channel;
    signal cc5_cluster_range : channel;
    signal cc6_cluster_range : channel;
    signal cc7_cluster_range : channel;
    signal cc8_cluster_range : channel;
    
    
    
    signal cc1             : channel;
    signal cc2             : channel;
    signal cc3             : channel;
    signal cc4             : channel;
    signal cc5             : channel;
    signal cc6             : channel;
    signal cc7             : channel;
    signal cc8             : channel;
    signal colorhsl        : channel;
    signal colorhsl_sync   : channel;
    signal ccmcolor        : channel;
    signal cmyk_sync       : channel;
    signal cmyk            : channel;
    signal ohta_sync       : channel;
    signal ohta            : channel;
    signal micc_sync       : channel;
    signal micc            : channel;
    signal hed_sync        : channel;
    signal hed             : channel;
    signal yiq_sync        : channel;
    signal yiq             : channel;
    signal ydrdb_sync      : channel;
    signal ydrdb           : channel;
    signal ipt_sync        : channel;
    signal ipt             : channel;
    signal yc1c2_sync      : channel;
    signal yc1c2           : channel;
    signal xyz_sync        : channel;
    signal xyz             : channel;
    signal lms_sync        : channel;
    signal lms             : channel;
    signal ypbpr_sync      : channel;
    signal ypbpr           : channel;
    signal yuv_sync        : channel;
    signal yuv             : channel;
    signal re1color        : channel;
    signal re2color        : channel;
    signal re3color        : channel;
    signal re4color        : channel;
    signal re5color        : channel;
    signal re6color        : channel;
    signal re7color        : channel;
    signal re8color        : channel;
    signal blurRgb         : channel;
    signal blurRgbSync     : channel;
    signal hslSyncr        : channel;
    signal hsl_1_Syncr     : channel;
    signal hsl_2_Syncr     : channel;
    signal hsl_3_Syncr     : channel;
    signal hsl_4_Syncr     : channel;
    signal hsll1_Syncr     : channel;
    signal hsll2_Syncr     : channel;
    signal hsll3_Syncr     : channel;
    signal hsll4_Syncr     : channel;
    signal hsl_1_range     : channel;
    signal hsl_2_range     : channel;
    signal hsl_3_range     : channel;
    signal hsl_4_range     : channel;
    signal hsll1_range     : channel;
    signal hsll2_range     : channel;
    signal hsll3_range     : channel;
    signal hsll4_range     : channel;
    signal rgb_invert      : channel;
begin
-----------------------------------------------------------------------------------------------
--coef_mult
-----------------------------------------------------------------------------------------------
CoefMultInst: coef_mult
port map (
    clk            => clk,
    rst_l          => rst_l,
    iKcoeff        => iKcoeff,
    iFilterId      => iFilterId,
    oKcoeff        => oKcoeff,
    oCoeffProd     => kCoProd);
-----------------------------------------------------------------------------------------------
--taps_controller
-----------------------------------------------------------------------------------------------
TPDATAWIDTH3_ENABLED: if ((SHARP_FRAME = TRUE) or (BLURE_FRAME = TRUE) or (EMBOS_FRAME = TRUE)) generate
    signal tp0        : std_logic_vector(23 downto 0) := (others => '0');
    signal tp1        : std_logic_vector(23 downto 0) := (others => '0');
    signal tp2        : std_logic_vector(23 downto 0) := (others => '0');
    signal tpValid    : std_logic  := lo;
begin
TapsControllerInst: taps_controller
generic map(
    img_width    => img_width,
    tpDataWidth  => 24)
port map(
    clk          => clk,
    rst_l        => rst_l,
    iRgb         => iRgb,
    tpValid      => tpValid,
    tp0          => tp0,
    tp1          => tp1,
    tp2          => tp2);
process (clk,rst_l) begin
    if (rst_l = lo) then
        rgbMac1.red   <= (others => '0');
        rgbMac1.green <= (others => '0');
        rgbMac1.blue  <= (others => '0');
        rgbMac1.valid <= lo;
    elsif rising_edge(clk) then
        rgbMac1.red   <= tp0(23 downto 16);
        rgbMac1.green <= tp1(23 downto 16);
        rgbMac1.blue  <= tp2(23 downto 16);
        rgbMac1.valid <= tpValid;
    end if;
end process;
process (clk,rst_l) begin
    if (rst_l = lo) then
        rgbMac2.red   <= (others => '0');
        rgbMac2.green <= (others => '0');
        rgbMac2.blue  <= (others => '0');
        rgbMac2.valid <= lo;
    elsif rising_edge(clk) then
        rgbMac2.red   <= tp0(15 downto 8);
        rgbMac2.green <= tp1(15 downto 8);
        rgbMac2.blue  <= tp2(15 downto 8);
        rgbMac2.valid <= tpValid;
    end if;
end process;
process (clk,rst_l) begin
    if (rst_l = lo) then
        rgbMac3.red   <= (others => '0');
        rgbMac3.green <= (others => '0');
        rgbMac3.blue  <= (others => '0');
        rgbMac3.valid <= lo;
    elsif rising_edge(clk) then
        rgbMac3.red   <= tp0(7 downto 0);
        rgbMac3.green <= tp1(7 downto 0);
        rgbMac3.blue  <= tp2(7 downto 0);
        rgbMac3.valid <= tpValid;
    end if;
end process;
end generate TPDATAWIDTH3_ENABLED;
-----------------------------------------------------------------------------------------------
--FILTERS: YCBCR
-----------------------------------------------------------------------------------------------
YCBCR_FRAME_ENABLE: if (YCBCR_FRAME = true) generate
signal ycbcr       : channel;
signal ycbcrSyncr  : channel;
signal kCoeffYcbcr : kernelCoeDWord;
begin
process (clk) begin
    if (rising_edge (clk)) then
        if (kCoProd.kCoeffYcbcr.kSet = kCoefYcbcrIndex) then
            kCoeffYcbcr <= kCoProd.kCoeffYcbcr;
        end if;
    end if;
end process;
Kernel_Ycbcr_Inst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => YCBCR_FRAME,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => iRgb,
    kCoeff         => kCoeffYcbcr,
    oRgb           => ycbcrSyncr);
ycbcr_syncr_inst  : sync_frames
generic map(
    pixelDelay => 43)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => ycbcrSyncr,
    oRgb       => oRgb.ycbcr);
end generate YCBCR_FRAME_ENABLE;
-----------------------------------------------------------------------------------------------
--FILTERS: CGAIN
-----------------------------------------------------------------------------------------------
CGAIN_FRAME_ENABLE: if (CGAIN_FRAME = true or CCGAIN_FRAME = true) generate
    signal c1gain          : channel;
    signal cgain1Syn       : channel;
    signal cgain2Syn       : channel;
    signal c2gain          : channel;
    signal cgain1Syncr     : channel;
    signal cgain2Syncr     : channel;
    signal kCofC1gain      : kernelCoeDWord;
    signal kCofC2gain      : kernelCoeDWord;
begin
CGAIN_FRAME_KSET_ENABLE: if (CGAIN_FRAME = true and CCGAIN_FRAME = false) generate
kCoeffCgainP:process (clk) begin
    if (rising_edge (clk)) then
        if (kCoProd.kCoeffCgain.kSet = kCoefCgainIndex) then
            kCofC1gain <= kCoProd.kCoeffCgain;
        end if;
    end if;
end process kCoeffCgainP;
Kernel1CgainInst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => CGAIN_FRAME,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => iRgb,
    kCoeff         => kCofC1gain,
    oRgb           => cgain1Syncr);
cgain1syncr_inst  : sync_frames
generic map(
    pixelDelay => 53)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => cgain1Syncr,
    oRgb       => oRgb.cgain);
end generate CGAIN_FRAME_KSET_ENABLE;
CCGAIN_FRAME_KSET_ENABLE: if (CGAIN_FRAME = false and CCGAIN_FRAME = true) generate
kCoeffCcgainP:process (clk) begin
    if (rising_edge (clk)) then
        if (kCoProd.kCoef1Cgain.kSet = kCoefCgai1Index) then
            kCofC2gain <= kCoProd.kCoef1Cgain;
        end if;
    end if;
end process kCoeffCcgainP;
Kernel2CgainInst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => CGAIN_FRAME,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => iRgb,
    kCoeff         => kCofC2gain,
    oRgb           => cgain2Syncr);
cgain2syncr_inst  : sync_frames
generic map(
    pixelDelay => 39)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => cgain2Syncr,
    oRgb       => oRgb.cgain);
end generate CCGAIN_FRAME_KSET_ENABLE;
end generate CGAIN_FRAME_ENABLE;
-----------------------------------------------------------------------------------------------
--FILTERS: SHARP
-----------------------------------------------------------------------------------------------
SHARP_FRAME_ENABLE: if (SHARP_FRAME = true) generate
signal oRed           : channel;
signal oGreen         : channel;
signal oBlue          : channel;
signal rgbsharp       : channel;
signal kCoeffSharp    : kernelCoeDWord;
begin
process (clk) begin
    if (rising_edge (clk)) then
        if (kCoProd.kCoeffSharp.kSet = kCoefSharpIndex) then
            kCoeffSharp <= kCoProd.kCoeffSharp;
        end if;
    end if;
end process;
Kernel_Sharp_Red_Inst: kernel_core
generic map(
    SHARP_FRAME   => SHARP_FRAME,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => rgbMac1,
    kCoeff         => kCoeffSharp,
    oRgb           => oRed);
Kernel_Sharp_Green_Inst: kernel_core
generic map(
    SHARP_FRAME   => SHARP_FRAME,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => rgbMac2,
    kCoeff         => kCoeffSharp,
    oRgb           => oGreen);
Kernel_Sharp_Blue_Inst: kernel_core
generic map(
    SHARP_FRAME   => SHARP_FRAME,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => rgbMac3,
    kCoeff         => kCoeffSharp,
    oRgb           => oBlue);
    rgbsharp.red   <=  oRed.red;
    rgbsharp.green <=  oGreen.red;
    rgbsharp.blue  <=  oBlue.red;
    rgbsharp.valid <=  oRed.valid;
sharp_syncr_inst  : sync_frames
generic map(
    pixelDelay     => 33)
port map(
    clk            => clk,
    reset          => rst_l,
    iRgb           => rgbsharp,
    oRgb           => oRgb.sharp);
end generate SHARP_FRAME_ENABLE;
-----------------------------------------------------------------------------------------------
--FILTERS: BLURE
-----------------------------------------------------------------------------------------------
BLURE_FRAME_ENABLE: if (BLURE_FRAME = true) generate
signal oRed           : channel;
signal oGreen         : channel;
signal oBlue          : channel;
signal kCoeffBlure    : kernelCoeDWord;
begin
process (clk) begin
    if (rising_edge (clk)) then
        if (kCoProd.kCoeffBlure.kSet = kCoefBlureIndex) then
            kCoeffBlure <= kCoProd.kCoeffBlure;
        end if;
    end if;
end process;
Kernel_Blur_Red_Inst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => BLURE_FRAME,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => rgbMac1,
    kCoeff         => kCoeffBlure,
    oRgb           => oRed);
Kernel_Blur_Green_Inst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => BLURE_FRAME,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => rgbMac2,
    kCoeff         => kCoeffBlure,
    oRgb           => oGreen);
Kernel_Blur_Blue_Inst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => BLURE_FRAME,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => rgbMac3,
    kCoeff         => kCoeffBlure,
    oRgb           => oBlue);
    blurRgb.red    <=  oRed.red;
    blurRgb.green  <=  oGreen.red;
    blurRgb.blue   <=  oBlue.red;
    blurRgb.valid  <=  oRed.valid;
blur_syncr_inst  : sync_frames
generic map(
    pixelDelay     => 34)
port map(
    clk            => clk,
    reset          => rst_l,
    iRgb           => blurRgb,
    oRgb           => blurRgbSync);
    oRgb.blur <= blurRgbSync;
end generate BLURE_FRAME_ENABLE;
-----------------------------------------------------------------------------------------------
--FILTERS: EMBOS
-----------------------------------------------------------------------------------------------
EMBOS_FRAME_ENABLE: if (EMBOS_FRAME = true) generate
signal oRed           : channel;
signal oGreen         : channel;
signal oBlue          : channel;
signal embosRgb       : channel;
signal kCoeffEmbos    : kernelCoeDWord;
begin
process (clk) begin
    if (rising_edge (clk)) then
        if (kCoProd.kCoeffEmbos.kSet = kCoefEmbosIndex) then
            kCoeffEmbos <= kCoProd.kCoeffEmbos;
        end if;
    end if;
end process;
Kernel_Blur_Red_Inst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => EMBOS_FRAME,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => rgbMac1,
    kCoeff         => kCoeffEmbos,
    oRgb           => oRed);
Kernel_Blur_Green_Inst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => EMBOS_FRAME,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => rgbMac2,
    kCoeff         => kCoeffEmbos,
    oRgb           => oGreen);
Kernel_Blur_Blue_Inst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => EMBOS_FRAME,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => false,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => rgbMac3,
    kCoeff         => kCoeffEmbos,
    oRgb           => oBlue);
    embosRgb.red    <=  oRed.red;
    embosRgb.green  <=  oGreen.red;
    embosRgb.blue   <=  oBlue.red;
    embosRgb.valid  <=  oRed.valid;
embos_syncr_inst  : sync_frames
generic map(
    pixelDelay     => 34)
port map(
    clk            => clk,
    reset          => rst_l,
    iRgb           => embosRgb,
    oRgb           => oRgb.embos);
end generate EMBOS_FRAME_ENABLE;
-----------------------------------------------------------------------------------------------
--FILTERS: SOBEL
-----------------------------------------------------------------------------------------------
SOBEL_FRAME_ENABLE: if (SOBEL_FRAME = true) generate
-----------------------------------------------------------------------------------------------
signal osobelX        : channel;
signal osobelY        : channel;
signal sobel          : channel;
signal sobel_rgb      : channel;
signal sobel_hsl      : channel;
signal ccm2rgb_range  : channel;
signal kCoefXSobel    : kernelCoeDWord;
signal kCoefYSobel    : kernelCoeDWord;
signal mx             : unsigned(15 downto 0)         := (others => '0');
signal my             : unsigned(15 downto 0)         := (others => '0');
signal sxy            : unsigned(15 downto 0)         := (others => '0');
signal sqr            : std_logic_vector(31 downto 0) := (others => '0');
signal sbof           : std_logic_vector(31 downto 0) := (others => '0');
signal sobelThreshold : integer :=0;
signal tp0            : std_logic_vector(7 downto 0)  := (others => '0');
signal tp1            : std_logic_vector(7 downto 0)  := (others => '0');
signal tp2            : std_logic_vector(7 downto 0)  := (others => '0');
signal tpValid        : std_logic := lo;
signal ovalid         : std_logic := lo;
begin
-----------------------------------------------------------------------------------------------
-- taps_controller
-----------------------------------------------------------------------------------------------
----------------------------------------------------------
-- Used ccm color space for better edge detection.
----------------------------------------------------------
sobel_ccm_inst  : ccm
generic map(
    i_k_config_number   => 8)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => ccm2rgb_range);
    sobel_rgb.red       <= iRgb.red;
    sobel_rgb.green     <= iRgb.red;
    sobel_rgb.blue      <= iRgb.red;
    sobel_rgb.valid     <= iRgb.valid;
----------------------------------------------------------
TapsControllerInst: taps_controller
generic map(
    img_width    => img_width,
    tpDataWidth  => 8)
port map(
    clk          => clk,
    rst_l        => rst_l,
    iRgb         => sobel_rgb,
    tpValid      => tpValid,
    tp0          => tp0,
    tp1          => tp1,
    tp2          => tp2);
-----------------------------------------------------------------------------------------------
-- Taps To Rgb
-----------------------------------------------------------------------------------------------
    sobel.red   <= tp0;
    sobel.green <= tp1;
    sobel.blue  <= tp2;
    sobel.valid <= tpValid;
-----------------------------------------------------------------------------------------------
-- Coeff Init Updates
-----------------------------------------------------------------------------------------------
process (clk) begin
    if (rising_edge (clk)) then
        if (kCoProd.kCoefXSobel.kSet = kCoefSobeXIndex) then
            kCoefXSobel <= kCoProd.kCoefXSobel;
        end if;
    end if;
end process;
process (clk) begin
    if (rising_edge (clk)) then
        if (kCoProd.kCoefYSobel.kSet = kCoefSobeYIndex) then
            kCoefYSobel <= kCoProd.kCoefYSobel;
        end if;
    end if;
end process;
KernelSobelXInst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => SOBEL_FRAME,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => sobel,
    kCoeff         => kCoefXSobel,
    oRgb           => osobelX);
KernelSobelYInst: kernel_core
generic map(
    SHARP_FRAME   => false,
    BLURE_FRAME   => false,
    EMBOS_FRAME   => false,
    YCBCR_FRAME   => false,
    SOBEL_FRAME   => SOBEL_FRAME,
    CGAIN_FRAME   => false,
    img_width     => img_width,
    i_data_width  => i_data_width)
port map(
    clk            => clk,
    rst_l          => rst_l,
    iRgb           => sobel,
    kCoeff         => kCoefYSobel,
    oRgb           => osobelY);
sobelDomainsValueP:process (clk) begin
    if rising_edge(clk) then
        mx  <= (unsigned(osobelX.red) * unsigned(osobelX.red));
        my  <= (unsigned(osobelY.red) * unsigned(osobelY.red));
    end if;
end process sobelDomainsValueP;
sumValueP:process (clk) begin
    if rising_edge(clk) then
        sxy <= (mx + my);
    end if;
end process sumValueP;
squareRootValueP:process (clk) begin
    if rising_edge(clk) then
        sqr <= std_logic_vector(resize(unsigned(sxy), sqr'length));
    end if;
end process squareRootValueP;
-----------------------------------------------------------------------------------------------
--rgbSync
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= osobelX.valid;
        rgbSyncValid(1)  <= rgbSyncValid(0);
        rgbSyncValid(2)  <= rgbSyncValid(1);
        rgbSyncValid(3)  <= rgbSyncValid(2);
        rgbSyncValid(4)  <= rgbSyncValid(3);
        rgbSyncValid(5)  <= rgbSyncValid(4);
        rgbSyncValid(6)  <= rgbSyncValid(5);
        rgbSyncValid(7)  <= rgbSyncValid(6);
        rgbSyncValid(8)  <= rgbSyncValid(7);
        rgbSyncValid(9)  <= rgbSyncValid(8);
        rgbSyncValid(10) <= rgbSyncValid(9);
        rgbSyncValid(11) <= rgbSyncValid(10);
        rgbSyncValid(12) <= rgbSyncValid(11);
        rgbSyncValid(13) <= rgbSyncValid(12);
        rgbSyncValid(14) <= rgbSyncValid(13);
        rgbSyncValid(15) <= rgbSyncValid(14);
    end if;
end process;
--sqr(G) = (Gx2 + Gy2)
squareRootTopInst: squareRootTop
port map(
    clk        => clk,
    ivalid     => rgbSyncValid(6),
    idata      => sqr,
    ovalid     => ovalid,
    odata      => sbof);
--magnitude(G) = square_root(Gx2 + Gy2)
sobelThreshold          <= to_integer(unsigned(sbof(15 downto 0)));
sobelOutP:process (clk) begin
    if rising_edge(clk) then
        if (sobelThreshold > iSobelTh) then -- > Hex 006E dEC 110
            oEdgeValid       <= hi;
            oRgb.sobel.red   <= black;
            oRgb.sobel.green <= black;
            oRgb.sobel.blue  <= black;
        else
            oEdgeValid       <= lo;
            oRgb.sobel.red   <= white;
            oRgb.sobel.green <= white;
            oRgb.sobel.blue  <= white;
        end if;
            oRgb.sobel.valid <= ovalid;
    end if;
end process sobelOutP;
end generate SOBEL_FRAME_ENABLE;
-----------------------------------------------------------------------------------------------
--FILTERS: RGB
-----------------------------------------------------------------------------------------------
INRGB_FRAME_ENABLE: if (INRGB_FRAME = true) generate
    signal invert_rgb : uChannel;
    signal rgb1Syncr    : channel;
    signal rgb2Syncr    : channel;
constant gHold : unsigned(7 downto 0) := x"ff";
begin
    invert_rgb.red   <= (gHold - unsigned(iRgb.red));
    invert_rgb.green <= (gHold - unsigned(iRgb.green));
    invert_rgb.blue  <= (gHold - unsigned(iRgb.blue));
    invert_rgb.valid <= iRgb.valid;
    --oRgb.inrgb.red   <= std_logic_vector(invert_rgb.red);
    --oRgb.inrgb.green <= std_logic_vector(invert_rgb.green);
    --oRgb.inrgb.blue  <= std_logic_vector(invert_rgb.blue);
    --oRgb.inrgb.valid <= invert_rgb.valid;
rgb1_syncr_inst  : sync_frames
generic map(
    pixelDelay => 63)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => iRgb,
    oRgb       => rgb1Syncr);
rgb2_syncr_inst  : sync_frames
generic map(
    pixelDelay => 4)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => rgb1Syncr,
    oRgb       => oRgb.inrgb);
end generate INRGB_FRAME_ENABLE;
-----------------------------------------------------------------------------------------------
--FILTERS: HSV
-----------------------------------------------------------------------------------------------
HSV_FRAME_ENABLE: if (HSV_FRAME = true) generate
    signal hsvSyncr    : channel;
begin
-------------------------------------------------------------
-- HSV
-------------------------------------------------------------
hsvInst: hsv_c
generic map(
    i_data_width       => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    oHsv               => hsvSyncr);
hsv_syncr_inst  : sync_frames
generic map(
    pixelDelay => 70)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => hsvSyncr,
    oRgb       => oRgb.hsv);
end generate HSV_FRAME_ENABLE;
-----------------------------------------------------------------------------------------------
--FILTERS: HSL
-----------------------------------------------------------------------------------------------
HSL_FRAME_ENABLE: if (HSL_FRAME = true) generate begin
-------------------------------------------------------------
-- HSL
-------------------------------------------------------------
hslInst: hsl_c
generic map(
    i_data_width       => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    oHsl               => hslSyncr);
hsl_syncr_inst  : sync_frames
generic map(
    pixelDelay => 75)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => hslSyncr,
    oRgb       => oRgb.hsl);
end generate HSL_FRAME_ENABLE;
-------------------------------------------------------------
-- HSV  1 RANGE HSV_1_FRAME
-------------------------------------------------------------
HSV_1_FRAME_ENABLE: if (HSV_1_FRAME = true) generate begin
hsl_1_range_Inst: hsl_1range
generic map(
    i_data_width       => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    oHsl               => hsl_1_Syncr);
hsl_1_syncr_inst  : sync_frames
generic map(
    pixelDelay => 70)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => hsl_1_Syncr,
    oRgb       => hsl_1_range);
    oRgb.hsl1_range <= hsl_1_range;
end generate HSV_1_FRAME_ENABLE;
-------------------------------------------------------------
-- HSV  2 RANGE
-------------------------------------------------------------
HSV_2_FRAME_ENABLE: if (HSV_2_FRAME = true) generate begin
rgb_inverted_inst: rgb_inverted
generic map(
    i_data_width       => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    oRgb               => rgb_invert);
hsl_2_range_inst: hsl_2range
generic map(
    i_data_width       => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => rgb_invert,
    oHsl               => hsl_2_Syncr);
hsl_2_syncr_inst  : sync_frames
generic map(
    pixelDelay => 66)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => hsl_2_Syncr,
    oRgb       => oRgb.hsl2_range);
end generate HSV_2_FRAME_ENABLE;
-------------------------------------------------------------
-- HSV  3 RANGE
-------------------------------------------------------------
HSV_3_FRAME_ENABLE: if (HSV_3_FRAME = true) generate begin
hsl_3_range_Inst: hsl_3range
generic map(
    i_data_width       => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    oHsl               => hsl_3_Syncr);
hsl_3_syncr_inst  : sync_frames
generic map(
    pixelDelay => 74)
port map(
    clk             => clk,
    reset           => rst_l,
    iRgb            => hsl_3_Syncr,
    oRgb            => oRgb.hsl3_range);
end generate HSV_3_FRAME_ENABLE;
-------------------------------------------------------------
-- HSV  4 RANGE
-------------------------------------------------------------
HSV_4_FRAME_ENABLE: if (HSV_4_FRAME = true) generate begin
hsl_4_range_Inst: hsl_4range
generic map(
    i_data_width    => i_data_width)
port map(
    clk             => clk,
    reset           => rst_l,
    iRgb            => iRgb,
    oHsl            => hsl_4_Syncr);
hsl_4_syncr_inst  : sync_frames
generic map(
    pixelDelay      => 74)
port map(
    clk             => clk,
    reset           => rst_l,
    iRgb            => hsl_4_Syncr,
    oRgb            => oRgb.hsl4_range);
end generate HSV_4_FRAME_ENABLE;
-------------------------------------------------------------
-- HSVL 1 RANGE 
-------------------------------------------------------------
HSVL1_FRAME_ENABLE: if (HSVL1_FRAME = true) generate 
signal ccm_hsvl_1_color : channel;
begin
ccm_hsvl_1_color_inst  : ccm
generic map(
    i_k_config_number   => 6)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => ccm_hsvl_1_color);
hsvl_1_range_Inst: hsvl_1range
generic map(
    i_data_width    => i_data_width)
port map(
    clk             => clk,
    reset           => rst_l,
    iRgb            => ccm_hsvl_1_color,
    oHsl            => hsll1_Syncr);
hsvl_1_syncr_inst  : sync_frames
generic map(
    pixelDelay      => 60)
port map(
    clk             => clk,
    reset           => rst_l,
    iRgb            => hsll1_Syncr,
    oRgb            => oRgb.hsll1range);
end generate HSVL1_FRAME_ENABLE;
HSVL2_FRAME_ENABLE: if (HSVL2_FRAME = true) generate begin
hsvl_2_range_inst: hsvl_2range
generic map(
    i_data_width    => i_data_width)
port map(
    clk             => clk,
    reset           => rst_l,
    iRgb            => iRgb,
    oHsl            => hsll2_Syncr);
hsvl_2_syncr_inst  : sync_frames
generic map(
    pixelDelay      => 69)
port map(
    clk             => clk,
    reset           => rst_l,
    iRgb            => hsll2_Syncr,
    oRgb            => oRgb.hsll2range);
end generate HSVL2_FRAME_ENABLE;
HSVL3_FRAME_ENABLE: if (HSVL3_FRAME = true) generate 
signal ccm_hsvl_3_color : channel;
begin
ccm_hsvl_3_color_inst  : ccm
generic map(
    i_k_config_number   => 1)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => ccm_hsvl_3_color);
hsvl_3_range_Inst: hsvl_3range
generic map(
    i_data_width       => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => ccm_hsvl_3_color,
    oHsl               => hsll3_Syncr);
hsvl_3_syncr_inst  : sync_frames
generic map(
    pixelDelay => 60)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => hsll3_Syncr,
    oRgb       => oRgb.hsll3range);
end generate HSVL3_FRAME_ENABLE;
HSVL4_FRAME_ENABLE: if (HSVL4_FRAME = true) generate 
signal ccm_hsvl_4_color : channel;
begin
ccm_hsvl_4_color_inst  : ccm
generic map(
    i_k_config_number   => 2)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => ccm_hsvl_4_color);
hsvl_4_range_Inst: hsvl_4range
generic map(
    i_data_width       => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => ccm_hsvl_4_color,
    oHsl               => hsll4_Syncr);
hsvl_4_syncr_inst  : sync_frames
generic map(
    pixelDelay => 63)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => hsll4_Syncr,
    oRgb       => oRgb.hsll4range);
end generate HSVL4_FRAME_ENABLE;
-----------------------------------------------------------------------------------------------
--FILTERS: RGBTRIM
-----------------------------------------------------------------------------------------------
RGBTRIM_FRAME_ENABLE: if (RGBTR_FRAME = true) generate
begin
recolor_space_0_inst: color_trim
generic map(
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    oRgb               => oRgb.colorTrm);
end generate RGBTRIM_FRAME_ENABLE;
RGBCOHSL_FRAME_ENABLE: if (COHSL_FRAME = true) generate begin
recolor_space_0_inst: recolor_space_hsl
generic map(
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    oRgb               => colorhsl_sync);
sync_color_hsl_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => colorhsl_sync,
    oRgb                 => colorhsl);
end generate RGBCOHSL_FRAME_ENABLE;
oRgb.colorhsl <= colorhsl;
F_CC1_FRAME_ENABLE: if (F_CC1_FRAME = true) generate begin
f_cc1_frame_inst  : ccm
generic map(
    i_k_config_number   => 1)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => cc1_cluster_range);
recolor_space_1_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => cc1_cluster_range,
    txCord             => txCord,
    oRgb               => cc1_sync);
sync_cc1_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => cc1_sync,
    oRgb                 => cc1);
end generate F_CC1_FRAME_ENABLE;
oRgb.cc1 <= cc1;
F_CC2_FRAME_ENABLE: if (F_CC2_FRAME = true) generate begin
f_cc2_frame_inst  : ccm
generic map(
    i_k_config_number   => 2)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => cc2_cluster_range);
recolor_space_2_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => cc2_cluster_range,
    txCord             => txCord,
    oRgb               => cc2_sync);
sync_cc2_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => cc2_sync,
    oRgb                 => cc2);
end generate F_CC2_FRAME_ENABLE;
oRgb.cc2 <= cc2;
F_CC3_FRAME_ENABLE: if (F_CC3_FRAME = true) generate begin
f_cc3_frame_inst  : ccm
generic map(
    i_k_config_number   => 3)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => cc3_cluster_range);
recolor_space_3_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => cc3_cluster_range,
    txCord             => txCord,
    oRgb               => cc3_sync);
sync_cc3_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => cc3_sync,
    oRgb                 => cc3);
end generate F_CC3_FRAME_ENABLE;
oRgb.cc3 <= cc3;
F_CC4_FRAME_ENABLE: if (F_CC4_FRAME = true) generate begin
f_cc4_frame_inst  : ccm
generic map(
    i_k_config_number   => 4)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => cc4_cluster_range);
recolor_space_4_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => cc4_cluster_range,
    txCord             => txCord,
    oRgb               => cc4_sync);
sync_cc4_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => cc4_sync,
    oRgb                 => cc4);
end generate F_CC4_FRAME_ENABLE;
oRgb.cc4 <= cc4;
F_CC5_FRAME_ENABLE: if (F_CC5_FRAME = true) generate begin
f_cc5_frame_inst  : ccm
generic map(
    i_k_config_number   => 5)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => cc5_cluster_range);
recolor_space_5_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => cc5_cluster_range,
    txCord             => txCord,
    oRgb               => cc5_sync);
sync_cc5_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => cc5_sync,
    oRgb                 => cc5);
end generate F_CC5_FRAME_ENABLE;
oRgb.cc5 <= cc5;
F_CC6_FRAME_ENABLE: if (F_CC6_FRAME = true) generate begin
f_cc6_frame_inst  : ccm
generic map(
    i_k_config_number   => 6)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => cc6_cluster_range);
recolor_space_6_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => cc6_cluster_range,
    txCord             => txCord,
    oRgb               => cc6_sync);
sync_cc6_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => cc6_sync,
    oRgb                 => cc6);
end generate F_CC6_FRAME_ENABLE;
oRgb.cc6 <= cc6;
F_CC7_FRAME_ENABLE: if (F_CC7_FRAME = true) generate begin
cc7_inst  : ccm
generic map(
    i_k_config_number   => 7)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => cc7_cluster_range);
recolor_space_7_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => cc7_cluster_range,
    txCord             => txCord,
    oRgb               => cc7_sync);
sync_cc7_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => cc7_sync,
    oRgb                 => cc7);
end generate F_CC7_FRAME_ENABLE;
oRgb.cc7 <= cc7;
F_CC8_FRAME_ENABLE: if (F_CC8_FRAME = true) generate begin
cc8_inst  : ccm
generic map(
    i_k_config_number   => 8)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => cc8_cluster_range);
recolor_space_8_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => cc8_cluster_range,
    txCord             => txCord,
    oRgb               => cc8_sync);
sync_cc8_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => cc8_sync,
    oRgb                 => cc8);
end generate F_CC8_FRAME_ENABLE;
oRgb.cc8 <= cc8;
F_XYZ_FRAME_ENABLE: if (F_XYZ_FRAME = true) generate begin
xyz_inst  : ccm
generic map(
    i_k_config_number   => 10)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => xyz_sync);
sync_xyz_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => xyz_sync,
    oRgb                 => xyz);
end generate F_XYZ_FRAME_ENABLE;
oRgb.xyz <= xyz;
F_LMS_FRAME_ENABLE: if (F_LMS_FRAME = true) generate begin
lms_inst  : ccm
generic map(
    i_k_config_number   => 11)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => xyz_sync,
    oRgb                => lms_sync);
sync_lms_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => lms_sync,
    oRgb                 => lms);
end generate F_LMS_FRAME_ENABLE;
oRgb.lms <= lms;
YPBPR_FRAME_ENABLE: if (YPBPR_FRAME = true) generate begin
ypbpr_inst  : ccm
generic map(
    i_k_config_number   => 12)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => ypbpr_sync);
sync_ypbpr_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => ypbpr_sync,
    oRgb                 => ypbpr);
end generate YPBPR_FRAME_ENABLE;
oRgb.ypbpr <= ypbpr;
F_YUV_FRAME_ENABLE: if (F_YUV_FRAME = true) generate begin
yuv_inst  : ccm
generic map(
    i_k_config_number   => 13)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => yuv_sync);
sync_yuv_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => yuv_sync,
    oRgb                 => yuv);
end generate F_YUV_FRAME_ENABLE;
oRgb.yuv <= yuv;
F_HED_FRAME_ENABLE: if (F_HED_FRAME = true) generate begin
hed_inst  : ccm
generic map(
    i_k_config_number   => 16)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => hed_sync);
sync_hed_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => hed_sync,
    oRgb                 => hed);
end generate F_HED_FRAME_ENABLE;
oRgb.hed <= hed;
F_YIQ_FRAME_ENABLE: if (F_YIQ_FRAME = true) generate begin
yiq_inst  : ccm
generic map(
    i_k_config_number   => 14)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => yiq_sync);
sync_yiq_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => yiq_sync,
    oRgb                 => yiq);
end generate F_YIQ_FRAME_ENABLE;
oRgb.yiq <= yiq;
YDRDB_FRAME_ENABLE: if (YDRDB_FRAME = true) generate begin
ydrdb_inst  : ccm
generic map(
    i_k_config_number   => 15)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => ydrdb_sync);
sync_ydrdb_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => ydrdb_sync,
    oRgb                 => ydrdb);
end generate YDRDB_FRAME_ENABLE;
oRgb.ydrdb <= ydrdb;
F_IPT_FRAME_ENABLE: if (F_IPT_FRAME = true) generate begin
ipt_inst  : ccm
generic map(
    i_k_config_number   => 17)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => xyz_sync,
    oRgb                => ipt_sync);
sync_ipt_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => ipt_sync,
    oRgb                 => ipt);
end generate F_IPT_FRAME_ENABLE;
oRgb.ipt <= ipt;
YC1C2_FRAME_ENABLE: if (YC1C2_FRAME = true) generate begin
yc1c2_inst  : ccm
generic map(
    i_k_config_number   => 13)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRgb                => iRgb,
    oRgb                => yc1c2_sync);
sync_yc1c2_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => yc1c2_sync,
    oRgb                 => yc1c2);
end generate YC1C2_FRAME_ENABLE;
oRgb.yc1c2 <= yc1c2;
FCMYK_FRAME_ENABLE: if (FCMYK_FRAME = true) generate begin
rgb_to_cmyk_inst  : rgb_to_cmyk
generic map(
    i_data_width   => 4)
port map(
    clk                 => clk,
    reset               => rst_l,
    iRgb                => iRgb,
    oRgb                => cmyk_sync);
sync_cmyk_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => cmyk_sync,
    oRgb                 => cmyk);
end generate FCMYK_FRAME_ENABLE;
oRgb.cmyk <= cmyk;
FOHTA_FRAME_ENABLE: if (FOHTA_FRAME = true) generate 
begin
rgb_to_ohta_inst  : rgb_to_I1I2I3_ohta
generic map(
    i_data_width   => 4)
port map(
    clk                 => clk,
    reset               => rst_l,
    iRgb                => iRgb,
    oRgb                => ohta_sync);
sync_ohta_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => ohta_sync,
    oRgb                 => ohta);
end generate FOHTA_FRAME_ENABLE;
oRgb.ohta <= ohta;
FMICC_FRAME_ENABLE: if (FMICC_FRAME = true) generate 
begin
rgb_to_micc_inst  : rgb_to_I1I2I3_micc
generic map(
    i_data_width   => 4)
port map(
    clk                 => clk,
    reset               => rst_l,
    iRgb                => iRgb,
    oRgb                => micc_sync);
sync_micc_inst  : sync_frames
generic map(
    pixelDelay           => 58)
port map(
    clk                  => clk,
    reset                => rst_l,
    iRgb                 => micc_sync,
    oRgb                 => micc);
end generate FMICC_FRAME_ENABLE;
oRgb.micc <= micc;
F_RE1_FRAME_ENABLE: if (F_RE1_FRAME = true) generate begin
recolor_space_1_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 255,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => re1color);
end generate F_RE1_FRAME_ENABLE;
oRgb.re1color <= re1color;
F_RE2_FRAME_ENABLE: if (F_RE2_FRAME = true) generate begin
recolor_space_2_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 50,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => re2color);
end generate F_RE2_FRAME_ENABLE;
F_RE3_FRAME_ENABLE: if (F_RE3_FRAME = true) generate begin
recolor_space_3_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 25,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => re3color);
end generate F_RE3_FRAME_ENABLE;
F_RE4_FRAME_ENABLE: if (F_RE4_FRAME = true) generate begin
recolor_space_4_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 20,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => re4color);
end generate F_RE4_FRAME_ENABLE;
F_RE5_FRAME_ENABLE: if (F_RE5_FRAME = true) generate begin
recolor_space_5_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 15,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => re5color);
end generate F_RE5_FRAME_ENABLE;
F_RE6_FRAME_ENABLE: if (F_RE6_FRAME = true) generate begin
recolor_space_6_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 10,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => re6color);
end generate F_RE6_FRAME_ENABLE;
F_RE7_FRAME_ENABLE: if (F_RE7_FRAME = true) generate begin
recolor_space_7_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 5,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => re7color);
end generate F_RE7_FRAME_ENABLE;
F_RE8_FRAME_ENABLE: if (F_RE8_FRAME = true) generate begin
recolor_space_8_inst: recolor_space_cluster
generic map(
    neighboring_pixel_threshold => 3,
    img_width         => img_width,
    i_data_width      => i_data_width)
port map(
    clk                => clk,
    reset              => rst_l,
    iRgb               => iRgb,
    txCord             => txCord,
    oRgb               => re8color);
end generate F_RE8_FRAME_ENABLE;
oRgb.re2color   <= re2color;
oRgb.re3color   <= re3color;
oRgb.re4color   <= re4color;
oRgb.re5color   <= re5color;
oRgb.re6color   <= re6color;
oRgb.re7color   <= re7color;
oRgb.re8color   <= re8color;
-----------------------------------------------------------------------------------------------
--FILTERS: RGBLUMP
-----------------------------------------------------------------------------------------------
RGBLUMP_FRAME_ENABLE: if (RGBLP_FRAME = true) generate
    signal colorLmpSyncr    : channel;
begin
SegmentColorsInst: segment_colors
port map(
    clk                => clk,
    reset              => rst_l,
    iLumTh             => iLumTh,
    iRgb               => re1color,
    oRgb               => colorLmpSyncr);
colorLmp_syncr_inst  : sync_frames
generic map(
    pixelDelay => 59)
port map(
    clk        => clk,
    reset      => rst_l,
    iRgb       => colorLmpSyncr,
    oRgb       => oRgb.colorLmp);
end generate RGBLUMP_FRAME_ENABLE;
-----------------------------------------------------------------------------------------------
--FRAMES_DISABLED
-----------------------------------------------------------------------------------------------
RGBLUMP_FRAME_DISABLED: if (RGBLP_FRAME = false) generate
    oRgb.colorLmp   <= init_channel;
end generate RGBLUMP_FRAME_DISABLED;
RGBTRIM_FRAME_DISABLED: if (RGBTR_FRAME = false) generate
    oRgb.colorTrm   <= init_channel;
end generate RGBTRIM_FRAME_DISABLED;
OHS_FRAME_DISABLED: if (COHSL_FRAME = false) generate
    oRgb.colorhsl   <= init_channel;
end generate OHS_FRAME_DISABLED;
F_RE1_FRAME_DISABLED: if (F_RE1_FRAME = false) generate
    oRgb.re1color   <= init_channel;
end generate F_RE1_FRAME_DISABLED;
F_RE2_FRAME_DISABLED: if (F_RE2_FRAME = false) generate
    oRgb.re2color   <= init_channel;
end generate F_RE2_FRAME_DISABLED;
F_RE3_FRAME_DISABLED: if (F_RE3_FRAME = false) generate
    oRgb.re3color   <= init_channel;
end generate F_RE3_FRAME_DISABLED;
F_RE4_FRAME_DISABLED: if (F_RE4_FRAME = false) generate
    oRgb.re4color   <= init_channel;
end generate F_RE4_FRAME_DISABLED;
F_RE5_FRAME_DISABLED: if (F_RE5_FRAME = false) generate
    oRgb.re5color   <= init_channel;
end generate F_RE5_FRAME_DISABLED;
F_RE6_FRAME_DISABLED: if (F_RE6_FRAME = false) generate
    oRgb.re6color   <= init_channel;
end generate F_RE6_FRAME_DISABLED;
F_RE7_FRAME_DISABLED: if (F_RE7_FRAME = false) generate
    oRgb.re7color   <= init_channel;
end generate F_RE7_FRAME_DISABLED;
F_RE8_FRAME_DISABLED: if (F_RE8_FRAME = false) generate
    oRgb.re8color   <= init_channel;
end generate F_RE8_FRAME_DISABLED;
INRGB_FRAME_DISABLED: if (INRGB_FRAME = false) generate
    oRgb.inrgb   <= init_channel;
end generate INRGB_FRAME_DISABLED;
YCBCR_FRAME_DISABLED: if (YCBCR_FRAME = false) generate
    oRgb.ycbcr   <= init_channel;
end generate YCBCR_FRAME_DISABLED;
SHARP_FRAME_DISABLED: if (SHARP_FRAME = false) generate
    oRgb.sharp   <= init_channel;
end generate SHARP_FRAME_DISABLED;
BLURE_FRAME_DISABLED: if (BLURE_FRAME = false) generate
    oRgb.blur  <= init_channel;
end generate BLURE_FRAME_DISABLED;
EMBOS_FRAME_DISABLED: if (EMBOS_FRAME = false) generate
    oRgb.embos   <= init_channel;
end generate EMBOS_FRAME_DISABLED;
SOBEL_FRAME_DISABLED: if (SOBEL_FRAME = false) generate
    oRgb.sobel   <= init_channel;
end generate SOBEL_FRAME_DISABLED;
CGAIN_FRAME_DISABLED: if (CGAIN_FRAME = false) generate
    oRgb.cgain   <= init_channel;
end generate CGAIN_FRAME_DISABLED;
HSL_FRAME_DISABLED: if (HSL_FRAME = false) generate
    oRgb.hsl     <= init_channel;
end generate HSL_FRAME_DISABLED;
HSV_FRAME_DISABLED: if (HSV_FRAME = false) generate
    oRgb.hsv     <= init_channel;
end generate HSV_FRAME_DISABLED;
end Behavioral;