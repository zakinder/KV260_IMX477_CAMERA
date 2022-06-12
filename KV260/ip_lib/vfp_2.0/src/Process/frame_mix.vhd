-------------------------------------------------------------------------------
--
-- Filename    : frame_mix.vhd
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
entity frame_remake is
generic (
    eBlack         : boolean := false);
port (
    clk            : in std_logic;
    reset          : in  std_logic;
    iEdgeValid     : in std_logic;
    iRgb           : in frameColors);
end frame_remake;


architecture behavioral of frame_remake is
    signal d1Rgb     : channel;
    signal d2Rgb     : channel;
    signal d3Rgb     : channel;
    signal d4Rgb     : channel;
    signal d5Rgb     : channel;
    signal d6Rgb     : channel;
    signal d7Rgb     : channel;
    signal d8Rgb     : channel;
    signal d11Rgb    : channel;
    signal d12Rgb    : channel;
    signal d13Rgb    : channel;
    signal d14Rgb    : channel;
    signal d15Rgb    : channel;
    signal d16Rgb    : channel;
    signal d17Rgb    : channel;
    signal d18Rgb    : channel;
begin
--sobel             : channel;
--embos             : channel;
--blur              : channel;
--sharp             : channel;
--cgain             : channel;
--ycbcr             : channel;
--hsl               : channel;
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
--maskSobelHsl      : channel;
--maskSobelCga      : channel;
--colorTrm          : channel;
--colorLmp          : channel;
--tPattern          : channel;
--cgainToCgain      : channel;
--cgainToHsl        : channel;
--cgainToHsv        : channel;
--cgainToYcbcr      : channel;
--cgainToShp        : channel;
--cgainToBlu        : channel;
--shpToCgain        : channel;
--shpToHsl          : channel;
--shpToHsv          : channel;
--shpToYcbcr        : channel;
--shpToShp          : channel;
--shpToBlu          : channel;
--bluToBlu          : channel;
--bluToCga          : channel;
--bluToShp          : channel;
--bluToYcc          : channel;
--bluToHsv          : channel;
--bluToHsl          : channel;
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
--synCgain          : channel;
--synYcbcr          : channel;
--synLcobj          : channel;
--synRgbag          : channel;
--oRgb <= d1Rgb;

-- frame_mix_h_cb_cr    [hu_cb_cr ]
-- frame_mix_s_cb_cr    [sa_cb_cr ]
-- frame_mix_l_cb_cr    [lu_cb_cr ]
-- frame_mix_h_cb_l     [hu_cb_lu ]
-- frame_mix_h_s_cr     [hu_sa_cr ]
-- frame_mix_ccr_h_cb   [ccr_hu_cb]
-- frame_mix_ccr_h_cr   [ccr_hu_cr]
-- frame_mix_ccr_h_s    [ccr_hu_sa]

--
--process (clk) begin  --frame_mix_h_cb_cr
--    if rising_edge(clk) then
--        d1Rgb.red    <= iRgb.colorhsl.red;
--        d1Rgb.green  <= iRgb.ycbcr.red;
--        d1Rgb.blue   <= iRgb.colorhsl.blue;
--        d1Rgb.valid  <= iRgb.ycbcr.valid;
--    end if;
--end process;
--process (clk) begin  --frame_mix_s_cb_cr
--    if rising_edge(clk) then 
--        d2Rgb.red    <= iRgb.colorhsl.green;
--        d2Rgb.green  <= iRgb.ycbcr.green;
--        d2Rgb.blue   <= iRgb.colorhsl.blue;
--        d2Rgb.valid  <= iRgb.ycbcr.valid;
--    end if;
--end process;
--process (clk) begin  --frame_mix_l_cb_cr
--    if rising_edge(clk) then 
--        d3Rgb.red    <= iRgb.colorhsl.blue;
--        d3Rgb.green  <= iRgb.ycbcr.blue;
--        d3Rgb.blue   <= iRgb.colorhsl.blue;
--        d3Rgb.valid  <= iRgb.ycbcr.valid;
--    end if;
--end process;
--process (clk) begin  --frame_mix_h_cb_l
--    if rising_edge(clk) then 
--        d4Rgb.red    <= iRgb.colorhsl.red;
--        d4Rgb.green  <= iRgb.hsl.red;
--        d4Rgb.blue   <= iRgb.colorhsl.blue;
--        d4Rgb.valid  <= iRgb.ycbcr.valid;
--    end if;
--end process;
--process (clk) begin  --frame_mix_h_s_cr
--    if rising_edge(clk) then 
--        d5Rgb.red    <= iRgb.colorhsl.red;
--        d5Rgb.green  <= iRgb.hsl.green;
--        d5Rgb.blue   <= iRgb.colorhsl.blue;
--        d5Rgb.valid  <= iRgb.ycbcr.valid;
--    end if;
--end process;
--process (clk) begin  --frame_mix_ccr_h_cb
--    if rising_edge(clk) then 
--        d6Rgb.red    <= iRgb.colorhsl.red;
--        d6Rgb.green  <= iRgb.hsl.blue;
--        d6Rgb.blue   <= iRgb.colorhsl.blue;
--        d6Rgb.valid  <= iRgb.ycbcr.valid;
--    end if;
--end process;
--process (clk) begin  --frame_mix_ccr_h_cr
--    if rising_edge(clk) then
--        d7Rgb.red    <= iRgb.colorhsl.red;
--        d7Rgb.green  <= iRgb.inrgb.red;
--        d7Rgb.blue   <= iRgb.colorhsl.green;
--        d7Rgb.valid  <= iRgb.ycbcr.valid
--    end if;
--end process;
--process (clk) begin  --frame_mix_ccr_h_s
--    if rising_edge(clk) then
--        d8Rgb.red    <= iRgb.colorhsl.red;
--        d8Rgb.green  <= iRgb.inrgb.green;
--        d8Rgb.blue   <= iRgb.colorhsl.blue;
--        d8Rgb.valid  <= iRgb.ycbcr.valid
--    end if;
--end process;
--process (clk) begin  --frame_mix_ccr_h_s
--    if rising_edge(clk) then
--        d11Rgb.red    <= iRgb.colorhsl.red;
--        d11Rgb.green  <= iRgb.inrgb.blue;
--        d11Rgb.blue   <= iRgb.colorhsl.blue;
--        d11Rgb.valid  <= iRgb.cgain.valid
--    end if;
--end process;
--process (clk) begin  --frame_mix_ccr_h_s
--    if rising_edge(clk) then
--        d12Rgb.red    <= iRgb.inrgb.red;
--        d12Rgb.green  <= iRgb.inrgb.green;
--        d12Rgb.blue   <= iRgb.colorhsl.blue;
--        d12Rgb.valid  <= iRgb.cgain.valid
--    end if;
--end process;
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--frame_mix_ccr_chslr_chslb_inst: write_image
--generic map (
--    enImageText           => true,
--    enImageIndex          => true,
--    i_data_width          => i_data_width,
--    test                  => testFolder,
--    input_file            => readbmp,
--    output_file           => "chslr_chslb1")
--port map (                  
--    pixclk                => clk,
--    iRgb                  => d11Rgb);
--frame_mix_ccr_chslr_chslb2_inst: write_image
--generic map (
--    enImageText           => true,
--    enImageIndex          => true,
--    i_data_width          => i_data_width,
--    test                  => testFolder,
--    input_file            => readbmp,
--    output_file           => "chslr_chslb2")
--port map (                  
--    pixclk                => clk,
--    iRgb                  => d12Rgb);
--frame_mix_h_cb_cr_inst: write_image
--generic map (
--    enImageText           => true,
--    enImageIndex          => true,
--    i_data_width          => i_data_width,
--    test                  => testFolder,
--    input_file            => readbmp,
--    output_file           => "frame_mix_h_cb_cr")
--port map (                  
--    pixclk                => clk,
--    iRgb                  => d1Rgb);
--frame_mix_s_cb_cr_inst: write_image
--generic map (
--    enImageText           => true,
--    enImageIndex          => true,
--    i_data_width          => i_data_width,
--    test                  => testFolder,
--    input_file            => readbmp,
--    output_file           => "frame_mix_s_cb_cr")
--port map (                  
--    pixclk                => clk,
--    iRgb                  => d2Rgb);
--frame_mix_l_cb_cr_inst: write_image
--generic map (
--    enImageText           => true,
--    enImageIndex          => true,
--    i_data_width          => i_data_width,
--    test                  => testFolder,
--    input_file            => readbmp,
--    output_file           => "frame_mix_l_cb_cr")
--port map (                  
--    pixclk                => clk,
--    iRgb                  => d3Rgb);
--frame_mix_h_cb_l_inst: write_image
--generic map (
--    enImageText           => true,
--    enImageIndex          => true,
--    i_data_width          => i_data_width,
--    test                  => testFolder,
--    input_file            => readbmp,
--    output_file           => "frame_mix_h_cb_l")
--port map (                  
--    pixclk                => clk,
--    iRgb                  => d4Rgb);
--frame_mix_h_s_cr_inst: write_image
--generic map (
--    enImageText           => true,
--    enImageIndex          => true,
--    i_data_width          => i_data_width,
--    test                  => testFolder,
--    input_file            => readbmp,
--    output_file           => "frame_mix_h_s_cr")
--port map (                  
--    pixclk                => clk,
--    iRgb                  => d5Rgb);
--frame_mix_ccr_h_cb_inst: write_image
--generic map (
--    enImageText           => true,
--    enImageIndex          => true,
--    i_data_width          => i_data_width,
--    test                  => testFolder,
--    input_file            => readbmp,
--    output_file           => "frame_mix_ccr_h_cb")
--port map (                  
--    pixclk                => clk,
--    iRgb                  => d6Rgb);
--frame_mix_ccr_h_cr_inst: write_image
--generic map (
--    enImageText           => true,
--    enImageIndex          => true,
--    i_data_width          => i_data_width,
--    test                  => testFolder,
--    input_file            => readbmp,
--    output_file           => "frame_mix_ccr_h_cr")
--port map (                  
--    pixclk                => clk,
--    iRgb                  => d7Rgb);
--frame_mix_ccr_h_s_inst: write_image
--generic map (
--    enImageText           => true,
--    enImageIndex          => true,
--    i_data_width          => i_data_width,
--    test                  => testFolder,
--    input_file            => readbmp,
--    output_file           => "frame_mix_ccr_h_s")
--port map (                  
--    pixclk                => clk,
--    iRgb                  => d8Rgb);
--    
    
--EBLACK_ENABLED: if (eBlack = true) generate
--    process (clk) begin
--        if rising_edge(clk) then
--            if (iEdgeValid = hi) then
--                oRgb.red   <= black;
--                oRgb.green <= black;
--                oRgb.blue  <= black;
--            else
--                oRgb.red   <= d1Rgb.red;
--                oRgb.green <= d1Rgb.green;
--                oRgb.blue  <= d1Rgb.blue;
--            end if;
--                oRgb.valid <= iRgb.valid;
--        end if;
--    end process;
--end generate EBLACK_ENABLED;
--EBLACK_DISABLED: if (eBlack = false) generate
--    process (clk) begin
--        if rising_edge(clk) then
--            if (iEdgeValid = hi) then
--                oRgb.red   <= iRgb.red;
--                oRgb.green <= iRgb.green;
--                oRgb.blue  <= iRgb.blue;
--            else
--                oRgb.red   <= d1Rgb.red;
--                oRgb.green <= d1Rgb.green;
--                oRgb.blue  <= d1Rgb.blue;
--            end if;
--                oRgb.valid <= iRgb.valid;
--        end if;
--    end process;
--end generate EBLACK_DISABLED;
end behavioral;