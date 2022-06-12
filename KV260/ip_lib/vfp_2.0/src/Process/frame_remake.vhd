-------------------------------------------------------------------------------
--
-- Filename    : frame_remake.vhd
-- Create Date : 01162019 [01-16-2019]
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
use work.tbPackage.all;
use work.dutPortsPackage.all;
entity frame_remake is
generic (
    eBlack         : boolean := false);
port (
    clk            : in std_logic;
    reset          : in  std_logic;
    iEdgeValid     : in std_logic;
    iRgb           : in frameColors;
    oRgb           : out channel);
end frame_remake;
architecture behavioral of frame_remake is
    signal ycbcr            : channel;
    signal synYcbcr         : channel;
    signal iRgb_hsl1_range  : channel;
    signal iRgb_hsl2_range  : channel;
    signal iRgb_hsl3_range  : channel;
    signal iRgb_hsl4_range  : channel;

    signal iRgb_hsll1range  : channel;
    signal iRgb_hsll2range  : channel;
    signal iRgb_hsll3range  : channel;
    signal iRgb_hsll4range  : channel;
    
    signal iRgb_colorhsl    : channel;
    
    signal d1Rgb            : channel;
    signal d2Rgb            : channel;
    signal d3Rgb            : channel;
    signal d4Rgb            : channel;
    signal d5Rgb            : channel;
    signal d6Rgb            : channel;
    signal d7Rgb            : channel;
    signal d8Rgb            : channel;
    
    

    signal d22Rgb           : channel;
    signal d23Rgb           : channel;
    signal d25Rgb           : channel;
    signal d26Rgb           : channel;
    signal d27Rgb           : channel;
    signal d28Rgb           : channel;
    
    signal d32Rgb           : channel;
    signal d33Rgb           : channel;
    signal d35Rgb           : channel;
    signal d36Rgb           : channel;
    signal d37Rgb           : channel;
    signal d38Rgb           : channel;
    
    signal d42Rgb           : channel;
    signal d43Rgb           : channel;
    signal d45Rgb           : channel;
    signal d46Rgb           : channel;
    signal d47Rgb           : channel;
    signal d48Rgb           : channel;
    
    signal d52Rgb           : channel;
    signal d53Rgb           : channel;
    signal d55Rgb           : channel;
    signal d56Rgb           : channel;
    signal d57Rgb           : channel;
    signal d58Rgb           : channel;
    
    
begin
--sobel             : channel;
--embos             : channel;
--blur              : channel;
--sharp             : channel;
--cgain             : channel;
--ycbcr             : channel;
--hsv               : channel;
--hsv               : channel;
--inrgb             : channel;
--d1t               : channel;
--b1t               : channel;
--maskSobelLum      : channel;
--maskSobelTrm      : channel;
--maskSobelRgb      : channel;
--maskSobelShp      : channel;
--maskSobelBlu      : channel;
--maskSobelYcc      : channel;
--maskSobelHsv      : channel;
--maskSobelhsv      : channel;
--maskSobelCga      : channel;
--colorTrm          : channel;
--colorLmp          : channel;
--tPattern          : channel;
--cgainToCgain      : channel;
--cgainTohsv        : channel;
--cgainToHsv        : channel;
--cgainToYcbcr      : channel;
--cgainToShp        : channel;
--cgainToBlu        : channel;
--shpToCgain        : channel;
--shpTohsv          : channel;
--shpToHsv          : channel;
--shpToYcbcr        : channel;
--shpToShp          : channel;
--shpToBlu          : channel;
--bluToBlu          : channel;
--bluToCga          : channel;
--bluToShp          : channel;
--bluToYcc          : channel;
--bluToHsv          : channel;
--bluTohsv          : channel;
--bluToCgaShp       : channel;
--bluToCgaShpYcc    : channel;
--bluToCgaShpHsv    : channel;
--bluToShpCga       : channel;
--bluToShpCgaYcc    : channel;
--bluToShpCgaHsv    : channel;
--cgaBright         : channel;
--cgaDark           : channel;
--cgaBalance        : channel;
--cgaGainRed        : channel;
--cgaGainGre        : channel;
--cgaGainBlu        : channel;
--synBlur           : channel;
--synSharp          : channel;
--iRgb_hsl1_range          : channel;
--synYcbcr          : channel;
--synLcobj          : channel;
--synRgbag          : channel;
oRgb <= d1Rgb;
-- frame_remake_h_cb_cr    [hu_cb_cr ]
-- frame_remake_s_cb_cr    [sa_cb_cr ]
-- frame_remake_l_cb_cr    [lu_cb_cr ]
-- frame_remake_h_cb_l     [hu_cb_lu ]
-- frame_remake_h_s_cr     [hu_sa_cr ]
-- frame_remake_ccr_h_cb   [ccr_hu_cb]
-- frame_remake_ccr_h_cr   [ccr_hu_cr]
-- frame_remake_ccr_h_s    [ccr_hu_sa]

l_ycc_inst  : rgb_ycbcr
generic map(
    i_data_width         => i_data_width,
    i_precision          => 12,
    i_full_range         => TRUE)
port map(
    clk                  => clk,
    rst_l                => reset,
    iRgb                 => iRgb.inrgb,
    y                    => ycbcr.red,
    cb                   => ycbcr.green,
    cr                   => ycbcr.blue,
    oValid               => ycbcr.valid);
    
    
yccSyncr_inst  : sync_frames
generic map(
    pixelDelay           => 10)
port map(
    clk                  => clk,
    reset                => reset,
    iRgb                 => ycbcr,
    oRgb                 => synYcbcr);


iRgb_hsl1_range_inst  : sync_frames
generic map(
    pixelDelay           => 1)
port map(
    clk                  => clk,
    reset                => reset,
    iRgb                 => iRgb.hsl1_range,
    oRgb                 => iRgb_hsl1_range);
    
hsl2_range_range_inst  : sync_frames
generic map(
    pixelDelay           => 1)
port map(
    clk                  => clk,
    reset                => reset,
    iRgb                 => iRgb.hsl2_range,
    oRgb                 => iRgb_hsl2_range);
    
hsl3_range_range_inst  : sync_frames
generic map(
    pixelDelay           => 1)
port map(
    clk                  => clk,
    reset                => reset,
    iRgb                 => iRgb.hsl3_range,
    oRgb                 => iRgb_hsl3_range);
    
hsl4_range_range_inst  : sync_frames
generic map(
    pixelDelay           => 1)
port map(
    clk                  => clk,
    reset                => reset,
    iRgb                 => iRgb.hsl4_range,
    oRgb                 => iRgb_hsl4_range);
    
    
iRgb_hsll1range_inst  : sync_frames
generic map(
    pixelDelay           => 0)
port map(
    clk                  => clk,
    reset                => reset,
    iRgb                 => iRgb.hsll1range,
    oRgb                 => iRgb_hsll1range);

iRgb_hsll2range_inst  : sync_frames
generic map(
    pixelDelay           => 0)
port map(
    clk                  => clk,
    reset                => reset,
    iRgb                 => iRgb.hsll2range,
    oRgb                 => iRgb_hsll2range);
    
iRgb_hsll3range_inst  : sync_frames
generic map(
    pixelDelay           => 0)
port map(
    clk                  => clk,
    reset                => reset,
    iRgb                 => iRgb.hsll3range,
    oRgb                 => iRgb_hsll3range);
    
iRgb_hsll4range_inst  : sync_frames
generic map(
    pixelDelay           => 0)
port map(
    clk                  => clk,
    reset                => reset,
    iRgb                 => iRgb.hsll4range,
    oRgb                 => iRgb_hsll4range);
    
iRgb_colorhsl_inst  : sync_frames
generic map(
    pixelDelay           => 0)
port map(
    clk                  => clk,
    reset                => reset,
    iRgb                 => iRgb.colorhsl,
    oRgb                 => iRgb_colorhsl);
    
    
process (clk) begin  --frame_remake_h_cb_cr
    if rising_edge(clk) then
        d1Rgb.red    <= iRgb_hsl1_range.red;
        d1Rgb.green  <= synYcbcr.green;
        d1Rgb.blue   <= synYcbcr.blue;
        d1Rgb.valid  <= iRgb_hsl1_range.valid;
    end if;
end process;
process (clk) begin  --frame_remake_s_cb_cr
    if rising_edge(clk) then 
        d2Rgb.red    <= iRgb_hsl1_range.green;
        d2Rgb.green  <= synYcbcr.green;
        d2Rgb.blue   <= synYcbcr.blue;
        d2Rgb.valid  <= iRgb_hsl1_range.valid;
    end if;
end process;
process (clk) begin  --frame_remake_l_cb_cr
    if rising_edge(clk) then 
        d3Rgb.red    <= iRgb_hsl1_range.blue;
        d3Rgb.green  <= synYcbcr.green;
        d3Rgb.blue   <= synYcbcr.blue;
        d3Rgb.valid  <= iRgb_hsl1_range.valid;
    end if;
end process;
process (clk) begin  --frame_remake_h_cb_l
    if rising_edge(clk) then 
        d4Rgb.red    <= iRgb_hsl1_range.red;
        d4Rgb.green  <= synYcbcr.green;
        d4Rgb.blue   <= iRgb.hsv.blue;
        d4Rgb.valid  <= iRgb_hsl1_range.valid;
    end if;
end process;
process (clk) begin  --frame_remake_h_s_cr
    if rising_edge(clk) then 
        d5Rgb.red    <= iRgb_hsl1_range.red;
        d5Rgb.green  <= iRgb_hsl1_range.green;
        d5Rgb.blue   <= synYcbcr.blue;
        d5Rgb.valid  <= iRgb_hsl1_range.valid;
    end if;
end process;
process (clk) begin --frame_remake_ccr_h_cb
    if rising_edge(clk) then 
        d6Rgb.red    <= iRgb.cgain.red;
        d6Rgb.green  <= iRgb_hsl1_range.red;
        d6Rgb.blue   <= synYcbcr.blue;
        d6Rgb.valid  <= iRgb_hsl1_range.valid;
    end if;
end process;
process (clk) begin --frame_remake_ccr_h_cr
    if rising_edge(clk) then 
        d7Rgb.red    <= iRgb.cgain.red;
        d7Rgb.green  <= iRgb_hsl1_range.red;
        d7Rgb.blue   <= synYcbcr.blue;
        d7Rgb.valid  <= iRgb_hsl1_range.valid;
    end if;
end process;
process (clk) begin  --frame_remake_ccr_h_s
    if rising_edge(clk) then 
        d8Rgb.red    <= iRgb.cgain.red;
        d8Rgb.green  <= iRgb_hsl1_range.red;
        d8Rgb.blue   <= iRgb.hsv.blue;
        d8Rgb.valid  <= iRgb_hsl1_range.valid;
    end if;
end process;



process (clk) begin  --fframe_remake_s_cb_cr
    if rising_edge(clk) then 
        d22Rgb.red    <= iRgb_hsll1range.green;
        d22Rgb.green  <= synYcbcr.green;
        d22Rgb.blue   <= synYcbcr.blue;
        d22Rgb.valid  <= iRgb_hsll1range.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_l_cb_cr
    if rising_edge(clk) then 
        d23Rgb.red    <= iRgb_hsll1range.blue;
        d23Rgb.green  <= synYcbcr.green;
        d23Rgb.blue   <= synYcbcr.blue;
        d23Rgb.valid  <= iRgb_hsll1range.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_s_l_cr
    if rising_edge(clk) then 
        d25Rgb.red    <= iRgb_hsll1range.green;
        d25Rgb.green  <= iRgb_hsll1range.blue;
        d25Rgb.blue   <= synYcbcr.blue;
        d25Rgb.valid  <= iRgb_hsll1range.valid;
    end if;
end process;
process (clk) begin --fframe_remake_ccr_s_cb
    if rising_edge(clk) then 
        d26Rgb.red    <= iRgb.cgain.red;
        d26Rgb.green  <= iRgb_hsll1range.green;
        d26Rgb.blue   <= synYcbcr.blue;
        d26Rgb.valid  <= iRgb_hsll1range.valid;
    end if;
end process;
process (clk) begin --fframe_remake_ccr_s_cr
    if rising_edge(clk) then 
        d27Rgb.red    <= iRgb.cgain.red;
        d27Rgb.green  <= iRgb_hsll1range.green;
        d27Rgb.blue   <= synYcbcr.blue;
        d27Rgb.valid  <= iRgb_hsll1range.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_ccr_s_l
    if rising_edge(clk) then 
        d28Rgb.red    <= iRgb.cgain.red;
        d28Rgb.green  <= iRgb_hsll1range.green;
        d28Rgb.blue   <= iRgb_hsll1range.blue;
        d28Rgb.valid  <= iRgb_hsll1range.valid;
    end if;
end process;

process (clk) begin  --fframe_remake_s_cb_cr
    if rising_edge(clk) then 
        d32Rgb.red    <= iRgb_hsll2range.green;
        d32Rgb.green  <= synYcbcr.green;
        d32Rgb.blue   <= synYcbcr.blue;
        d32Rgb.valid  <= iRgb_hsll2range.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_l_cb_cr
    if rising_edge(clk) then 
        d33Rgb.red    <= iRgb_hsll2range.blue;
        d33Rgb.green  <= synYcbcr.green;
        d33Rgb.blue   <= synYcbcr.blue;
        d33Rgb.valid  <= iRgb_hsll2range.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_s_l_cr
    if rising_edge(clk) then 
        d35Rgb.red    <= iRgb_hsll2range.green;
        d35Rgb.green  <= iRgb_hsll2range.blue;
        d35Rgb.blue   <= synYcbcr.blue;
        d35Rgb.valid  <= iRgb_hsll2range.valid;
    end if;
end process;
process (clk) begin --fframe_remake_ccr_s_cb
    if rising_edge(clk) then 
        d36Rgb.red    <= iRgb.cgain.red;
        d36Rgb.green  <= iRgb_hsll2range.green;
        d36Rgb.blue   <= synYcbcr.blue;
        d36Rgb.valid  <= iRgb_hsll2range.valid;
    end if;
end process;
process (clk) begin --fframe_remake_ccr_s_cr
    if rising_edge(clk) then 
        d37Rgb.red    <= iRgb.cgain.red;
        d37Rgb.green  <= iRgb_hsll2range.green;
        d37Rgb.blue   <= synYcbcr.blue;
        d37Rgb.valid  <= iRgb_hsll2range.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_ccr_s_l
    if rising_edge(clk) then 
        d38Rgb.red    <= iRgb.cgain.red;
        d38Rgb.green  <= iRgb_hsll2range.green;
        d38Rgb.blue   <= iRgb_hsll2range.blue;
        d38Rgb.valid  <= iRgb_hsll2range.valid;
    end if;
end process;
---------------------------------------------------------------------

process (clk) begin  --fframe_remake_s_cb_cr
    if rising_edge(clk) then 
        d42Rgb.red    <= iRgb_colorhsl.green;
        d42Rgb.green  <= synYcbcr.green;
        d42Rgb.blue   <= synYcbcr.blue;
        d42Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_l_cb_cr
    if rising_edge(clk) then 
        d43Rgb.red    <= iRgb_colorhsl.blue;
        d43Rgb.green  <= synYcbcr.green;
        d43Rgb.blue   <= synYcbcr.blue;
        d43Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_s_l_cr
    if rising_edge(clk) then 
        d45Rgb.red    <= iRgb_colorhsl.green;
        d45Rgb.green  <= iRgb_colorhsl.blue;
        d45Rgb.blue   <= synYcbcr.blue;
        d45Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
process (clk) begin --fframe_remake_ccr_s_cb
    if rising_edge(clk) then 
        d46Rgb.red    <= iRgb.cgain.red;
        d46Rgb.green  <= iRgb_colorhsl.green;
        d46Rgb.blue   <= synYcbcr.blue;
        d46Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
process (clk) begin --fframe_remake_ccr_s_cr
    if rising_edge(clk) then 
        d47Rgb.red    <= iRgb.cgain.red;
        d47Rgb.green  <= iRgb_colorhsl.green;
        d47Rgb.blue   <= synYcbcr.blue;
        d47Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_ccr_s_l
    if rising_edge(clk) then 
        d48Rgb.red    <= iRgb.cgain.red;
        d48Rgb.green  <= iRgb_colorhsl.green;
        d48Rgb.blue   <= iRgb_colorhsl.blue;
        d48Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;

---------------------------------------------------------------------
process (clk) begin  --fframe_remake_s_cb_cr
    if rising_edge(clk) then 
        d52Rgb.red    <= iRgb_colorhsl.green;
        d52Rgb.green  <= iRgb_hsll1range.green;
        d52Rgb.blue   <= iRgb_hsll1range.blue;
        d52Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_l_cb_cr
    if rising_edge(clk) then 
        d53Rgb.red    <= iRgb_colorhsl.blue;
        d53Rgb.green  <= iRgb_hsll1range.green;
        d53Rgb.blue   <= iRgb_hsll1range.blue;
        d53Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_s_l_cr
    if rising_edge(clk) then 
        d55Rgb.red    <= iRgb_colorhsl.green;
        d55Rgb.green  <= iRgb_colorhsl.blue;
        d55Rgb.blue   <= iRgb_hsll1range.blue;
        d55Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
process (clk) begin --fframe_remake_ccr_s_cb
    if rising_edge(clk) then 
        d56Rgb.red    <= iRgb.cgain.red;
        d56Rgb.green  <= iRgb_colorhsl.green;
        d56Rgb.blue   <= iRgb_hsll1range.blue;
        d56Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
process (clk) begin --fframe_remake_ccr_s_cr
    if rising_edge(clk) then 
        d57Rgb.red    <= iRgb.cgain.red;
        d57Rgb.green  <= iRgb_colorhsl.green;
        d57Rgb.blue   <= iRgb_hsll1range.blue;
        d57Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_ccr_s_l
    if rising_edge(clk) then 
        d58Rgb.red    <= iRgb.cgain.red;
        d58Rgb.green  <= iRgb_colorhsl.green;
        d58Rgb.blue   <= iRgb_colorhsl.blue;
        d58Rgb.valid  <= iRgb_colorhsl.valid;
    end if;
end process;
---------------------------------------------------------------------

fframe_remake_s_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_remake_s_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d22Rgb);
fframe_remake_l_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_remake_l_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d23Rgb);
fframe_remake_s_l_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_remake_s_l_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d25Rgb);
fframe_remake_ccr_s_cb_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_remake_ccr_s_cb")
port map (                  
    pixclk                => clk,
    iRgb                  => d26Rgb);
fframe_remake_ccr_s_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_remake_ccr_s_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d27Rgb);
fframe_remake_ccr_s_l_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_remake_ccr_s_l")
port map (                  
    pixclk                => clk,
    iRgb                  => d28Rgb);
    

    
    
fframe_colorhsl_s_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_colorhsl_s_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d42Rgb);
fframe_colorhsl_l_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_colorhsl_l_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d43Rgb);
fframe_colorhsl_s_l_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_colorhsl_s_l_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d45Rgb);
fframe_colorhsl_ccr_s_cb_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_colorhsl_ccr_s_cb")
port map (                  
    pixclk                => clk,
    iRgb                  => d46Rgb);
fframe_colorhsl_ccr_s_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_colorhsl_ccr_s_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d47Rgb);
fframe_colorhsl_ccr_s_l_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_colorhsl_ccr_s_l")
port map (                  
    pixclk                => clk,
    iRgb                  => d48Rgb);
    
    
fframe_hsll2range_s_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_hsll2range_s_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d32Rgb);
fframe_hsll2range_l_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_hsll2range_l_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d33Rgb);
fframe_hsll2range_s_l_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_hsll2range_s_l_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d35Rgb);
fframe_hsll2range_ccr_s_cb_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_hsll2range_ccr_s_cb")
port map (                  
    pixclk                => clk,
    iRgb                  => d36Rgb);
fframe_hsll2range_ccr_s_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_hsll2range_ccr_s_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d37Rgb);
fframe_hsll2range_ccr_s_l_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "fframe_hsll2range_ccr_s_l")
port map (                  
    pixclk                => clk,
    iRgb                  => d38Rgb);
    
    
    
    
    
frame_remake_h_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "frame_remake_h_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d1Rgb);
frame_remake_s_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "frame_remake_s_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d2Rgb);
frame_remake_l_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "frame_remake_l_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d3Rgb);
frame_remake_h_cb_l_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "frame_remake_h_cb_l")
port map (                  
    pixclk                => clk,
    iRgb                  => d4Rgb);
frame_remake_h_s_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "frame_remake_h_s_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d5Rgb);
frame_remake_ccr_h_cb_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "frame_remake_ccr_h_cb")
port map (                  
    pixclk                => clk,
    iRgb                  => d6Rgb);
frame_remake_ccr_h_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "frame_remake_ccr_h_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d7Rgb);
frame_remake_ccr_h_s_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "frame_remake_ccr_h_s")
port map (                  
    pixclk                => clk,
    iRgb                  => d8Rgb);
    
hsll1range_colorhsl_s_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "hsll1range_colorhsl_s_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d52Rgb);
hsll1range_colorhsl_l_cb_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "hsll1range_colorhsl_l_cb_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d53Rgb);
hsll1range_colorhsl_s_l_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "hsll1range_colorhsl_s_l_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d55Rgb);
hsll1range_colorhsl_ccr_s_cb_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "hsll1range_colorhsl_ccr_s_cb")
port map (                  
    pixclk                => clk,
    iRgb                  => d56Rgb);
hsll1range_colorhsl_ccr_s_cr_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "hsll1range_colorhsl_ccr_s_cr")
port map (                  
    pixclk                => clk,
    iRgb                  => d57Rgb);
hsll1range_colorhsl_ccr_s_l_inst: write_image
generic map (
    enImageText           => true,
    enImageIndex          => true,
    i_data_width          => i_data_width,
    test                  => "testFolder",
    input_file            => readbmp,
    output_file           => "hsll1range_colorhsl_ccr_s_l")
port map (                  
    pixclk                => clk,
    iRgb                  => d58Rgb);
    
end behavioral;