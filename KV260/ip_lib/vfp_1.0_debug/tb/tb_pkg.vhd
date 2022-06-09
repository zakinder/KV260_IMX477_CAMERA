--12302021 [12-30-2021]
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vfp_pkg.all;
package tb_pkg is
    --       [64_64     = 5   us]
    --       [100_100   = 18  us]
    --       [128_128   = 18  us]
    --       [222_149   = 18  us]
    --       [255_127   = 18  us]
    --       [255_255   = 18  us]
    --       [272_416   = 239 us]
    --       [272_832   = 239 us]
    --       [300_300   = 110 us]
    --       [320_480   = 110 us]
    --       [300_200   = 110 us]
    --       [368_393   = 110 us]
    --       [400_300   = 123 us]
    --       [500_26    = 104 us]
    --       [500_200   = 104 us]
    --       [500_500   = 250 us]
    --       [619_479   = 304 us]
    --       [640_480   = 304 us]
    --       [770_580   = 452 us]
    --       [1000_500  = 622 us]
    --       [1012_606  = 622 us]
    --       [1024_1024 = 622 us]
    --       [1754_1006 = 622 us]
    constant readbmp             : string  := "128_128";
    constant Histrograms         : string  := "Histrograms";
    constant img_width           : integer := image_size_width(readbmp);
    constant img_height          : integer := image_size_height(readbmp);
    ----------------------------------------------------------------------------------------------------
    constant clk_freq            : real    := 1000.00e6;
    constant revision_number     : std_logic_vector(31 downto 0) := x"02212019";
    constant dataWidth           : integer := 12; 
    constant line_hight          : integer := 5;  
    constant adwrWidth           : integer := 16;
    constant addrWidth           : integer := 12;
    constant SLOT_NUM            : integer := 770;
    constant wImgFolder          : string := "K:/ZEDBOARD/simulations/images/write";
    constant rImgFolder          : string := "K:/ZEDBOARD/simulations/images/read";
    constant bSlash              : string := "\";
    constant fSlash              : string := "/";
    constant LogsFolder          : string := "Logs";
end package;

