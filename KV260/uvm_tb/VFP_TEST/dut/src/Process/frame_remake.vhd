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
    signal d1Rgb     : channel;
    signal d2Rgb     : channel;
    signal d3Rgb     : channel;
    signal d4Rgb     : channel;
    signal d5Rgb     : channel;
    signal d6Rgb     : channel;
    signal d7Rgb     : channel;
    signal d8Rgb     : channel;
    signal d21Rgb    : channel;
    signal d22Rgb    : channel;
    signal d23Rgb    : channel;
    signal d24Rgb    : channel;
    signal d25Rgb    : channel;
    signal d26Rgb    : channel;
    signal d27Rgb    : channel;
    signal d28Rgb    : channel;
    constant readbmp : string  := "272_416";
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
--synCgain          : channel;
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

process (clk) begin  --frame_remake_h_cb_cr
    if rising_edge(clk) then
        d1Rgb.red    <= iRgb.hsv.red;
        d1Rgb.green  <= iRgb.ycbcr.green;
        d1Rgb.blue   <= iRgb.ycbcr.blue;
        d1Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;
process (clk) begin  --frame_remake_s_cb_cr
    if rising_edge(clk) then 
        d2Rgb.red    <= iRgb.hsv.green;
        d2Rgb.green  <= iRgb.ycbcr.green;
        d2Rgb.blue   <= iRgb.ycbcr.blue;
        d2Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;
process (clk) begin  --frame_remake_l_cb_cr
    if rising_edge(clk) then 
        d3Rgb.red    <= iRgb.hsv.blue;
        d3Rgb.green  <= iRgb.ycbcr.green;
        d3Rgb.blue   <= iRgb.ycbcr.blue;
        d3Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;
process (clk) begin  --frame_remake_h_cb_l
    if rising_edge(clk) then 
        d4Rgb.red    <= iRgb.hsv.red;
        d4Rgb.green  <= iRgb.ycbcr.green;
        d4Rgb.blue   <= iRgb.hsv.blue;
        d4Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;
process (clk) begin  --frame_remake_h_s_cr
    if rising_edge(clk) then 
        d5Rgb.red    <= iRgb.hsv.red;
        d5Rgb.green  <= iRgb.hsv.green;
        d5Rgb.blue   <= iRgb.ycbcr.blue;
        d5Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;

process (clk) begin --frame_remake_ccr_h_cb
    if rising_edge(clk) then 
        d6Rgb.red    <= iRgb.cgain.red;
        d6Rgb.green  <= iRgb.hsv.red;
        d6Rgb.blue   <= iRgb.ycbcr.blue;
        d6Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;

process (clk) begin --frame_remake_ccr_h_cr
    if rising_edge(clk) then 
        d7Rgb.red    <= iRgb.cgain.red;
        d7Rgb.green  <= iRgb.hsv.red;
        d7Rgb.blue   <= iRgb.ycbcr.blue;
        d7Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;

process (clk) begin  --frame_remake_ccr_h_s
    if rising_edge(clk) then 
        d8Rgb.red    <= iRgb.cgain.red;
        d8Rgb.green  <= iRgb.hsv.red;
        d8Rgb.blue   <= iRgb.hsv.blue;
        d8Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;




process (clk) begin  --fframe_remake_s_cb_cr
    if rising_edge(clk) then 
        d22Rgb.red    <= iRgb.vhsv.green;
        d22Rgb.green  <= iRgb.ycbcr.green;
        d22Rgb.blue   <= iRgb.ycbcr.blue;
        d22Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;
process (clk) begin  --fframe_remake_l_cb_cr
    if rising_edge(clk) then 
        d23Rgb.red    <= iRgb.vhsv.blue;
        d23Rgb.green  <= iRgb.ycbcr.green;
        d23Rgb.blue   <= iRgb.ycbcr.blue;
        d23Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;

process (clk) begin  --fframe_remake_s_l_cr
    if rising_edge(clk) then 
        d25Rgb.red    <= iRgb.vhsv.green;
        d25Rgb.green  <= iRgb.vhsv.blue;
        d25Rgb.blue   <= iRgb.ycbcr.blue;
        d25Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;

process (clk) begin --fframe_remake_ccr_s_cb
    if rising_edge(clk) then 
        d26Rgb.red    <= iRgb.cgain.red;
        d26Rgb.green  <= iRgb.vhsv.green;
        d26Rgb.blue   <= iRgb.ycbcr.blue;
        d26Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;

process (clk) begin --fframe_remake_ccr_s_cr
    if rising_edge(clk) then 
        d27Rgb.red    <= iRgb.cgain.red;
        d27Rgb.green  <= iRgb.vhsv.green;
        d27Rgb.blue   <= iRgb.ycbcr.blue;
        d27Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;

process (clk) begin  --fframe_remake_ccr_s_l
    if rising_edge(clk) then 
        d28Rgb.red    <= iRgb.cgain.red;
        d28Rgb.green  <= iRgb.vhsv.green;
        d28Rgb.blue   <= iRgb.vhsv.blue;
        d28Rgb.valid  <= iRgb.ycbcr.valid;
    end if;
end process;


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