-------------------------------------------------------------------------------
--
-- Filename    : image_write.vhd
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
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
use work.tbpackage.all;
entity write_image_filter_logs is
generic (
    F_TES         : boolean := false;
    F_LUM         : boolean := false;
    F_TRM         : boolean := false;
    F_RGB         : boolean := false;
    F_SHP         : boolean := false;
    F_BLU         : boolean := false;
    F_EMB         : boolean := false;
    F_YCC         : boolean := false;
    F_SOB         : boolean := false;
    F_CGA         : boolean := false;
    F_HSV         : boolean := false;
    F_HSL         : boolean := false;
    L_BLU         : boolean := false;
    L_AVG         : boolean := false;
    L_OBJ         : boolean := false;
    L_CGA         : boolean := false;
    L_YCC         : boolean := false;
    L_SHP         : boolean := false;
    L_D1T         : boolean := false;
    L_B1T         : boolean := false;
    enImageText   : boolean := false;
    enImageIndex  : boolean := false;
    i_data_width  : integer := 8;
    test          : string  := "folder";
    input_file    : string  := "input_image";
    output_file   : string  := "output_image");
port (
    pixclk        : in  std_logic;
    iRgb          : in frameColors);
end write_image_filter_logs; 
architecture Behavioral of write_image_filter_logs is

    constant wrBmpLog       : string   := wImgFolder&bSlash&input_file&bSlash&LogsFolder&bSlash&output_file&"__"&integer'image(SLOT_NUM)&"_logs.txt";
    file wrBmpLogfile       : text open write_mode is wrBmpLog;
    type rgbPixel is array(1 to 3) of std_logic_vector(i_data_width-1 downto 0);
    type rgbFrame is array(0 to img_width -1, 0 to img_height -1) of rgbPixel;
    signal sobel            : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal colorlmp         : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal embos            : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal blur             : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal sharp            : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal cgain            : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal ycbcr            : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal hsl              : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal hsv              : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal inrgb            : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal d1t              : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal b1t              : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal trm              : rgbFrame  := (others => (others => (others => (others => '0'))));
    constant FILE_HEADER    : string    := "|R   G   B   |R   G   B   |R   G   B   |R   G   B   |R   G   B   |R   G   B   |R   G   B   |";
    constant FILE0_HEADER   : string    := "#   ROW COL ";
    constant F_RGB_HEADER   : string    := "F_RGB|";
    constant F_CGA_HEADER   : string    := "F_CGA|";
    constant F_HSV_HEADER   : string    := "F_HSV|";
    constant F_BLU_HEADER   : string    := "F_BLU|";
    constant F_YCC_HEADER   : string    := "F_YCC|";
    constant F_SHP_HEADER   : string    := "F_SHP|";
    constant F_EMB_HEADER   : string    := "F_EMB|";
    constant F_SOB_HEADER   : string    := "F_SOB|";
    constant F_LUM_HEADER   : string    := "F_LUM|";
    constant L_D1T_HEADER   : string    := "L_D1T|";
    constant L_B1T_HEADER   : string    := "L_B1T|";
    constant F_TRM_HEADER   : string    := "F_TRM|";
    signal Xcont            : integer   := 0;
    signal Ycont            : integer   := 0;
    signal wrImageFile      : std_logic := lo;
    signal frameEnable      : std_logic := lo;
    signal rgb1,rgb2,rgb3   : frameColors;
    signal imageCompleted   : std_logic := lo;
    signal enableWrite      : std_logic;
begin
enableWrite <= hi when (iRgb.cgain.valid = hi);
process (pixclk) begin
    if rising_edge(pixclk) then
        rgb1    <= iRgb;
        rgb2    <= rgb1;
        rgb3    <= rgb2;
    end if;
end process;
frameEnable <= hi when (enableWrite = hi and imageCompleted = lo) else lo;
readRgbDataP: process(pixclk)begin
    if rising_edge(pixclk) then
        if(frameEnable = hi) then
            if (rgb3.cgain.valid = hi and wrImageFile = lo) then
                Xcont  <= Xcont + 1;
            end if;
            if (F_SOB = True) then
                sobel(Xcont, Ycont)(3)   <= rgb3.sobel.red;
                sobel(Xcont, Ycont)(2)   <= rgb3.sobel.green;
                sobel(Xcont, Ycont)(1)   <= rgb3.sobel.blue;
            end if;
            if (F_LUM = True) then
                colorlmp(Xcont, Ycont)(3) <= rgb3.colorLmp.red;
                colorlmp(Xcont, Ycont)(2) <= rgb3.colorLmp.green;
                colorlmp(Xcont, Ycont)(1) <= rgb3.colorLmp.blue;
            end if;
            if (F_EMB = True) then
                embos(Xcont, Ycont)(3)   <= rgb3.embos.red;
                embos(Xcont, Ycont)(2)   <= rgb3.embos.green;
                embos(Xcont, Ycont)(1)   <= rgb3.embos.blue;
            end if;
            if (F_BLU = True) then
                blur(Xcont, Ycont)(3)    <= rgb3.blur.red;
                blur(Xcont, Ycont)(2)    <= rgb3.blur.green;
                blur(Xcont, Ycont)(1)    <= rgb3.blur.blue;
            end if;
            if (F_SHP = True) then
                sharp(Xcont, Ycont)(3)   <= rgb3.sharp.red;
                sharp(Xcont, Ycont)(2)   <= rgb3.sharp.green;
                sharp(Xcont, Ycont)(1)   <= rgb3.sharp.blue;
            end if;
            if (F_HSL = True) then
                hsl(Xcont, Ycont)(3)     <= rgb3.hsl.red;
                hsl(Xcont, Ycont)(2)     <= rgb3.hsl.green;
                hsl(Xcont, Ycont)(1)     <= rgb3.hsl.blue;
            end if;
            if (F_CGA = True) then
                cgain(Xcont, Ycont)(3)   <= rgb3.cgain.red;
                cgain(Xcont, Ycont)(2)   <= rgb3.cgain.green;
                cgain(Xcont, Ycont)(1)   <= rgb3.cgain.blue;
            end if;
            if (F_YCC = True) then
                ycbcr(Xcont, Ycont)(3)   <= rgb3.ycbcr.red;
                ycbcr(Xcont, Ycont)(2)   <= rgb3.ycbcr.green;
                ycbcr(Xcont, Ycont)(1)   <= rgb3.ycbcr.blue;
            end if;
            if (F_HSV = True) then
                hsv(Xcont, Ycont)(3)     <= rgb3.hsv.red;
                hsv(Xcont, Ycont)(2)     <= rgb3.hsv.green;
                hsv(Xcont, Ycont)(1)     <= rgb3.hsv.blue;
            end if;
            if (F_RGB = True) then
                inrgb(Xcont, Ycont)(3)   <= rgb3.inrgb.red;
                inrgb(Xcont, Ycont)(2)   <= rgb3.inrgb.green;
                inrgb(Xcont, Ycont)(1)   <= rgb3.inrgb.blue;
            end if;
            if (L_D1T = True) then
                d1t(Xcont, Ycont)(3)     <= rgb3.d1t.red;
                d1t(Xcont, Ycont)(2)     <= rgb3.d1t.green;
                d1t(Xcont, Ycont)(1)     <= rgb3.d1t.blue;
            end if;
            if (L_B1T = True) then
                b1t(Xcont, Ycont)(3)     <= rgb3.b1t.red;
                b1t(Xcont, Ycont)(2)     <= rgb3.b1t.green;
                b1t(Xcont, Ycont)(1)     <= rgb3.b1t.blue;
            end if;
            if (F_TRM = True) then
                trm(Xcont, Ycont)(3)     <= rgb3.colorTrm.red;
                trm(Xcont, Ycont)(2)     <= rgb3.colorTrm.green;
                trm(Xcont, Ycont)(1)     <= rgb3.colorTrm.blue;
            end if;
            if(Xcont = img_width - 1)then
                Ycont  <= Ycont + 1;
                Xcont  <= 0;
            end if;
            if(Xcont = img_width - 1 and Ycont = img_height - 1)then
                Ycont  <= 0;
            end if;
        end if;        
    end if;
end process readRgbDataP;
ImageFrameLoadDoneP: process(Ycont,Xcont)begin
    if (Xcont = img_width - 1 and Ycont = img_height - 1) then
        wrImageFile <= hi;
    end if;
end process ImageFrameLoadDoneP;
ImageFrameP: process
    variable outLine        : line;
    variable pixelIndex     : integer := 0;
    variable rowIndex       : integer := 0;
    variable pixelLocation  : integer := 0;
    variable charVline      : character := '|';
    variable charSpace      : character := ' ';
    begin
    write(outLine,FILE0_HEADER);
    write(outLine,FILE_HEADER);
    writeline(wrBmpLogfile, outLine);
    wait until wrImageFile = hi;
    for y in 0 to img_height loop
        rowIndex := rowIndex + 1;
        pixelLocation := 0;
        for x in 0 to img_width - 1 loop
            pixelLocation := pixelLocation + 1;
            pixelIndex    := pixelIndex + 1;
            if(y < img_height) then
            if(enImageText = True) then
                if(enImageIndex = True) then
                    write(outLine,pixelIndex);
                    write(outLine,maxchar(pixelIndex));
                    write(outLine,charSpace);
                    write(outLine,rowIndex);
                    write(outLine,maxchar(rowIndex));
                    write(outLine,pixelLocation);
                    write(outLine,maxchar(pixelLocation));
                end if;
            if (F_RGB = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(inrgb(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(inrgb(x, y)(3)))));
                write(outLine,(to_integer(unsigned(inrgb(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(inrgb(x, y)(2))))));
                write(outLine,(to_integer(unsigned(inrgb(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(inrgb(x, y)(1))))));
            end if;
            if (F_CGA = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(cgain(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(cgain(x, y)(3)))));
                write(outLine,(to_integer(unsigned(cgain(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(cgain(x, y)(2))))));
                write(outLine,(to_integer(unsigned(cgain(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(cgain(x, y)(1))))));
            end if;
            if (F_HSV = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(hsv(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(hsv(x, y)(3)))));
                write(outLine,(to_integer(unsigned(hsv(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(hsv(x, y)(2))))));
                write(outLine,(to_integer(unsigned(hsv(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(hsv(x, y)(1))))));
            end if;
            if (F_BLU = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(blur(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(blur(x, y)(3)))));
                write(outLine,(to_integer(unsigned(blur(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(blur(x, y)(2))))));
                write(outLine,(to_integer(unsigned(blur(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(blur(x, y)(1))))));
            end if;
            if (F_YCC = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(ycbcr(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(ycbcr(x, y)(3)))));
                write(outLine,(to_integer(unsigned(ycbcr(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(ycbcr(x, y)(2))))));
                write(outLine,(to_integer(unsigned(ycbcr(x, y)(1)))));
                write(outLine,maxchar(to_integer(unsigned(ycbcr(x, y)(1)))));
            end if;
            if (F_SHP = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(sharp(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(sharp(x, y)(3)))));
                write(outLine,(to_integer(unsigned(sharp(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(sharp(x, y)(2))))));
                write(outLine,(to_integer(unsigned(sharp(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(sharp(x, y)(1))))));
            end if;
            if (F_EMB = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(embos(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(embos(x, y)(3)))));
                write(outLine,(to_integer(unsigned(embos(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(embos(x, y)(2))))));
                write(outLine,(to_integer(unsigned(embos(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(embos(x, y)(1))))));
            end if;
            if (F_SOB = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(sobel(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(sobel(x, y)(3)))));
                write(outLine,(to_integer(unsigned(sobel(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(sobel(x, y)(2))))));
                write(outLine,(to_integer(unsigned(sobel(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(sobel(x, y)(1))))));
            end if;
            if (F_LUM = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(colorlmp(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(colorlmp(x, y)(3)))));
                write(outLine,(to_integer(unsigned(colorlmp(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(colorlmp(x, y)(2))))));
                write(outLine,(to_integer(unsigned(colorlmp(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(colorlmp(x, y)(1))))));
            end if;
            if (L_D1T = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(d1t(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(d1t(x, y)(3)))));
                write(outLine,(to_integer(unsigned(d1t(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(d1t(x, y)(2))))));
                write(outLine,(to_integer(unsigned(d1t(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(d1t(x, y)(1))))));
            end if;
            if (L_B1T = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(b1t(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(b1t(x, y)(3)))));
                write(outLine,(to_integer(unsigned(b1t(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(b1t(x, y)(2))))));
                write(outLine,(to_integer(unsigned(b1t(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(b1t(x, y)(1))))));
            end if;
            if (F_TRM = True) then
                write(outLine,charVline);
                write(outLine,(to_integer(unsigned(trm(x, y)(3)))));
                write(outLine,maxchar(to_integer(unsigned(trm(x, y)(3)))));
                write(outLine,(to_integer(unsigned(trm(x, y)(2)))));
                write(outLine,maxchar((to_integer(unsigned(trm(x, y)(2))))));
                write(outLine,(to_integer(unsigned(trm(x, y)(1)))));
                write(outLine,maxchar((to_integer(unsigned(trm(x, y)(1))))));
            end if;
            write(outLine,charVline);
            if (F_RGB = True) then
                write(outLine,F_RGB_HEADER);
            end if;
            if (F_CGA = True) then
                write(outLine,F_CGA_HEADER);
            end if;
            if (F_HSV = True) then
                write(outLine,F_HSV_HEADER);
            end if;
            if (F_BLU = True) then
                write(outLine,F_BLU_HEADER);
            end if;
            if (F_YCC = True) then
                write(outLine,F_YCC_HEADER);
            end if;
            if (F_SHP = True) then
                write(outLine,F_SHP_HEADER);
            end if;
            if (F_EMB = True) then
                write(outLine,F_EMB_HEADER);
            end if;
            if (F_SOB = True) then
                write(outLine,F_SOB_HEADER);
            end if;
            if (F_LUM = True) then
                write(outLine,F_LUM_HEADER);
            end if;
            if (L_D1T = True) then
                write(outLine,L_D1T_HEADER);
            end if;
            if (L_B1T = True) then
                write(outLine,L_B1T_HEADER);
            end if;
            if (F_TRM = True) then
                write(outLine,F_TRM_HEADER);
            end if;
            writeline(wrBmpLogfile, outLine);
            end if;
            end if;
        end loop;
    end loop;
    wait for 10 ns;
    imageCompleted <= hi;
    wait;
	assert false
	report "simulation ended"
	severity failure;
end process ImageFrameP;
end Behavioral;
---------------------------------------------------------------------------------
----
---- Filename    : write_image_filter_logs.vhd
---- Create Date : 
---- Author      : 
----
---- Description:
---- 
----
---------------------------------------------------------------------------------
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use std.textio.all;
--use ieee.std_logic_textio.all;
--use work.constants_package.all;
--use work.vpf_records.all;
--use work.ports_package.all;
--use work.tbpackage.all;
--
--entity write_image_filter_logs is
--generic (
--    enImageText   : boolean := false;
--    enImageIndex  : boolean := false;
--    i_data_width  : integer := 8;
--    test          : string  := "folder";
--    input_file    : string  := "input_image";
--    output_file   : string  := "output_image");
--port (
--    pixclk        : in  std_logic;
--    iRgb          : in frameColors);
--end write_image_filter_logs; 
--
--architecture Behavioral of write_image_filter_logs is
--
--    constant SLOT_NUM       : integer  := 2;
--    constant wrBmp_rgb      : string := wImgFolder&bSlash&input_file&bSlash&output_file&"__"& integer'image(SLOT_NUM)&".bmp";
--    constant rdBmp_rgb      : string := rImgFolder&fSlash&readbmp&fSlash&readbmp&".bmp";
--    constant wrBmpRgbLog    : string := wImgFolder&bSlash&input_file&bSlash&LogsFolder&bSlash&output_file&"__"&integer'image(SLOT_NUM)&"_logs.txt";
--    constant FILE1_HEADER   : string := "           |    RGB    |   CGAIN   |    HSV    |   YCBCR   ";
--    constant FILE0_HEADER   : string := "#   ROW COL|RED GRE BLU|RED GRE BLU|RED GRE BLU|RED GRE BLU";
--    
--    type char_file is file of character;
--    
--    file bmp_file           : char_file open read_mode is rdBmp_rgb;
--    file write_rgb_bmp_file : char_file open write_mode is wrBmp_rgb;
--    file write_log_bmp_file : text open write_mode is wrBmpRgbLog;
--
--    type header_type  is array (0 to 53) of character;
--    type pixel_type is record
--      red   : std_logic_vector(7 downto 0);
--      green : std_logic_vector(7 downto 0);
--      blue  : std_logic_vector(7 downto 0);
--    end record;
--    type row_type is array (integer range <>) of pixel_type;
--    type row_pointer is access row_type;
--    type image_type is array (integer range <>) of row_pointer;
--    type image_pointer is access image_type;
--    
--    shared variable  header         : header_type;
--    shared variable  image_width    : integer;
--    shared variable  image_height   : integer;
--
--    shared variable  padding        : integer;
--    shared variable  char           : character;
--    shared variable  pixel_row      : integer := 0;
--    shared variable  vat            : integer := 0;
--
--
--    shared variable  row_inrgb      : row_pointer;
--    shared variable  row_cgain      : row_pointer;
--    shared variable  row_hsv        : row_pointer;
--    shared variable  row_ycbcr      : row_pointer;
--    
--    shared variable  row_blur       : row_pointer;
--    shared variable  row_sharp      : row_pointer;
--    shared variable  row_embos      : row_pointer;
--    shared variable  row_sobel      : row_pointer;
--    
--    shared variable  image          : image_pointer;
--    shared variable write_rgb_line  : line;
--    shared variable pixelIndex      : integer := 0;
--
--    shared variable pixel_col       : integer := 0;
--    shared variable charVline       : character := '|';
--    
--    shared variable wrImageFile              : std_logic := lo;
--    shared variable wr1ImageFile             : std_logic := lo;
--    shared variable wr2ImageFile             : std_logic := lo;
--    
--    --sobel             : channel;
--    --embos             : channel;
--    --blur              : channel;
--    --sharp             : channel;
--    --cgain             : channel;
--    --ycbcr             : channel;
--    --hsl               : channel;
--    --hsv               : channel;
--    --inrgb             : channel;
--    signal rgb2,rgb3,rgb3,rgb4    : frameColors;
--    
--begin
--
--
--process (pixclk) begin
--    if rising_edge(pixclk) then
--        rgb2   <= iRgb;
--        rgb3   <= rgb2;
--        rgb3   <= rgb3;
--        rgb4   <= rgb3;
--    end if;
--end process;
--
--
--
--
--ImageFrameP: process
--
--
--    
--    begin
--    
--    for i in header_type'range loop
--        read(bmp_file, header(i));
--    end loop;
--    
--    -- Check ID field
--    assert header(0) = 'B' and header(1) = 'M'
--        report "First two bytes are not ""BM"". This is not a BMP file"
--        severity failure;
--        
--    -- Check that the pixel array offset is as expected
--    assert character'pos(header(10)) = 54 and
--        character'pos(header(11)) = 0 and
--        character'pos(header(12)) = 0 and
--        character'pos(header(13)) = 0
--        report "Pixel array offset in header is not 54 bytes"
--        severity failure;
--        
--    -- Check that DIB header size is 40 bytes,
--    -- meaning that the BMP is of type BITMAPINFOHEADER
--    assert character'pos(header(14)) = 40 and
--        character'pos(header(15)) = 0 and
--        character'pos(header(16)) = 0 and
--        character'pos(header(17)) = 0
--        report "DIB headers size is not 40 bytes, is this a Windows BMP?"
--        severity failure;
--        
--    -- Check that the number of color planes is 1
--    assert character'pos(header(26)) = 1 and
--        character'pos(header(27)) = 0
--        report "Color planes is not 1" severity failure;
--        
--    -- Check that the number of bits per pixel is 24
--    assert character'pos(header(28)) = 24 and
--        character'pos(header(29)) = 0
--        report "Bits per pixel is not 24" severity failure;
--        
--    -- Read image width
--    image_width := character'pos(header(18)) +
--        character'pos(header(19)) * 2**8 +
--        character'pos(header(20)) * 2**16 +
--        character'pos(header(21)) * 2**24;
--        
--    -- Read image height
--    image_height := character'pos(header(22)) +
--        character'pos(header(23)) * 2**8 +
--        character'pos(header(24)) * 2**16 +
--        character'pos(header(25)) * 2**24;
--        
--    report "image_width: " & integer'image(image_width);
--    report "image_height: " & integer'image(image_height);
--    
--    -- Number of bytes needed to pad each row to 32 bits
--    padding := (4 - image_width*3 mod 4) mod 4;
--    
--    -- Create a new image type in dynamic memory
--    image := new image_type(0 to image_height - 1);
--    
---------------------------------------------
---- in_file
---------------------------------------------
--for row_i in 0 to image_height - 1 loop
--
--  -- Create a new row type in dynamic memory
--  row_cgain := new row_type(0 to image_width - 1);
--  row_inrgb := new row_type(0 to image_width - 1);
--  row_hsv   := new row_type(0 to image_width - 1);
--  
--  for col_i in 0 to image_width - 1 loop
--    read(bmp_file, char);
--    row_cgain(col_i).blue := std_logic_vector(to_unsigned(character'pos(char), 8));
--    row_inrgb(col_i).blue := std_logic_vector(to_unsigned(character'pos(char), 8));
--    read(bmp_file, char);
--    row_cgain(col_i).green := std_logic_vector(to_unsigned(character'pos(char), 8));
--    row_inrgb(col_i).green := std_logic_vector(to_unsigned(character'pos(char), 8));
--    read(bmp_file, char);
--    row_cgain(col_i).red := std_logic_vector(to_unsigned(character'pos(char), 8));
--    row_inrgb(col_i).red := std_logic_vector(to_unsigned(character'pos(char), 8));
--  end loop;
--  
--  -- Read and discard padding
--  for i in 1 to padding loop
--    read(bmp_file, char);
--  end loop;
--
--  -- Assign the row pointer to the image vector of rows
--  image(row_i) := row_cgain;
--  report "image row_i: " & integer'image(row_i);
--  --report "_____________Actual bus data is "
--  --& integer'image(to_integer(unsigned(readData_s)))
--end loop;
--
--for row_i in 0 to image_height - 1 loop
--
--  --wait until (iRgb.cgain.valid = hi or rgb2.cgain.valid = hi or rgb3.cgain.valid = hi or rgb3.cgain.valid = hi);
--    wait until (iRgb.cgain.valid = hi);
--  row_inrgb := image(row_i);
--  --row_cgain := image(row_i);
--  --row_hsv   := image(row_i);
--  --row_ycbcr := image(row_i);
--  wrImageFile := hi;
--      for col_i in 0 to image_width - 1 loop
--      
--
--            row_inrgb(col_i).red   := rgb2.inrgb.red;
--            row_inrgb(col_i).green := rgb2.inrgb.green;
--            row_inrgb(col_i).blue  := rgb2.inrgb.blue;
--            --wait for 1 ns;
--            --
--            --row_ycbcr(col_i).red   := rgb3.ycbcr.red;
--            --row_ycbcr(col_i).green := rgb3.ycbcr.green;
--            --row_ycbcr(col_i).blue  := rgb3.ycbcr.blue;
--            --wait for 1 ns;
--            --
--            --row_hsv(col_i).red     := rgb3.hsv.red;
--            --row_hsv(col_i).green   := rgb3.hsv.green;
--            --row_hsv(col_i).blue    := rgb3.hsv.blue;
--            --wait for 1 ns;
--            --
--            --row_cgain(col_i).red   := rgb4.cgain.red;
--            --row_cgain(col_i).green := rgb4.cgain.green;
--            --row_cgain(col_i).blue  := rgb4.cgain.blue;
--            --wait for 1 ns;
--            
--       end loop;
--
--      wait until rgb2.inrgb.valid = lo;
--      
--end loop;
--report "Simulation done. ImageInrgbFrame.";
--wait for 1 us;
---------------------------------------------
---- write_rgb_bmp_file
---------------------------------------------
--
--report "write_rgb_bmp_file. write_rgb_bmp_file write_rgb_bmp_file write_rgb_bmp_file.";
--for i in header_type'range loop
--  write(write_rgb_bmp_file, header(i));
--end loop;
--
--write(write_rgb_line,FILE1_HEADER);
--writeline(write_log_bmp_file, write_rgb_line);
--write(write_rgb_line,FILE0_HEADER);
--writeline(write_log_bmp_file, write_rgb_line);
--
--for row_i in 0 to image_height - 1 loop
--
--  row_cgain := image(row_i);
--  row_inrgb := image(row_i);
--  row_hsv   := image(row_i);
--  row_ycbcr := image(row_i);
--  
--  pixel_row := pixel_row + 1;
--  pixel_col := 0;
--  
--  for col_i in 0 to image_width - 1 loop
--  
--    pixel_col     := pixel_col + 1;
--    pixelIndex    := pixelIndex + 1;
--    
--    write(write_rgb_bmp_file,character'val(to_integer(unsigned(row_cgain(col_i).blue))));
--    write(write_rgb_bmp_file,character'val(to_integer(unsigned(row_cgain(col_i).green))));
--    write(write_rgb_bmp_file,character'val(to_integer(unsigned(row_cgain(col_i).red))));
--    
--
--
--    if(enImageText = True) then
--    
--        if(enImageIndex = True) then
--            write(write_rgb_line,pixelIndex);
--            write(write_rgb_line,HT);
--            write(write_rgb_line,pixel_row);
--            write(write_rgb_line,HT);
--            write(write_rgb_line,pixel_col);
--            write(write_rgb_line,HT);
--        end if;
--        
--        write(write_rgb_line,charVline);
--        
--        write(write_rgb_line,(to_integer(unsigned(row_inrgb(col_i).red))));
--        write(write_rgb_line,HT);
--        write(write_rgb_line,(to_integer(unsigned(row_inrgb(col_i).green))));
--        write(write_rgb_line,HT);
--        write(write_rgb_line,(to_integer(unsigned(row_inrgb(col_i).blue))));
--
--        write(write_rgb_line,HT);
--        
--        write(write_rgb_line,(to_integer(unsigned(row_cgain(col_i).red))));
--        write(write_rgb_line,HT);
--        write(write_rgb_line,(to_integer(unsigned(row_cgain(col_i).green))));
--        write(write_rgb_line,HT);
--        write(write_rgb_line,(to_integer(unsigned(row_cgain(col_i).blue))));
--        
--        
--        write(write_rgb_line,HT);
--        
--        write(write_rgb_line,(to_integer(unsigned(row_hsv(col_i).red))));
--        write(write_rgb_line,HT);
--        write(write_rgb_line,(to_integer(unsigned(row_hsv(col_i).green))));
--        write(write_rgb_line,HT);
--        write(write_rgb_line,(to_integer(unsigned(row_hsv(col_i).blue))));
--        
--        write(write_rgb_line,HT);
--        
--        write(write_rgb_line,(to_integer(unsigned(row_ycbcr(col_i).red))));
--        write(write_rgb_line,HT);
--        write(write_rgb_line,(to_integer(unsigned(row_ycbcr(col_i).green))));
--        write(write_rgb_line,HT);
--        write(write_rgb_line,(to_integer(unsigned(row_ycbcr(col_i).blue))));
--        
--        write(write_rgb_line,HT);
--        write(write_rgb_line,charVline);
--        
--        writeline(write_log_bmp_file, write_rgb_line);
--        
--    end if;
--  end loop;
--
--  deallocate(row_cgain);
--  
--  -- Write padding
--  for i in 1 to padding loop
--    write(write_rgb_bmp_file, character'val(0));
--  end loop;
--  
--end loop;
--
--  deallocate(image);
--  file_close(bmp_file);
--  file_close(write_rgb_bmp_file);
--
--  wait for 1 us;
--  report "Simulation done. Check ""out.bmp"" image.";
--  wait until vat = 1;
--  
--end process;
--
--ImageCgainFrame: process
--begin
--wait until wrImageFile = hi;
--for row_i in 0 to image_height - 1 loop
--  wait until iRgb.cgain.valid = hi;
--  row_cgain := image(row_i);
--      for col_i in 0 to image_width - 1 loop
--            row_cgain(col_i).red   := iRgb.cgain.red;
--            row_cgain(col_i).green := iRgb.cgain.green;
--            row_cgain(col_i).blue  := iRgb.cgain.blue;
--       end loop;
--      wait until iRgb.cgain.valid = lo;
--end loop;
--  --report integer'image(row_cgain(image_width - 1).blue);
--  report "Simulation done. ImageCgainFrame.";
--end process;
--
--ImageHsvFrame: process
--begin
--wait until wrImageFile = hi;
--for row_i in 0 to image_height - 1 loop
--  wait until iRgb.hsv.valid = hi;
--  row_hsv   := image(row_i);
--      for col_i in 0 to image_width - 1 loop
--            row_hsv(col_i).red     := iRgb.hsv.red;
--            row_hsv(col_i).green   := iRgb.hsv.green;
--            row_hsv(col_i).blue    := iRgb.hsv.blue;
--
--       end loop;
--      wait until iRgb.hsv.valid = lo;
--end loop;
--  --report row_hsv(image_width - 1).blue;
--  report "Simulation done. ImageHsvFrame.";
--end process;
--
--ImageYcbcrFrame: process
--begin
--wait until wrImageFile = hi;
--for row_i in 0 to image_height - 1 loop
--  wait until iRgb.ycbcr.valid = hi;
--  row_ycbcr := image(row_i);
--      for col_i in 0 to image_width - 1 loop
--            row_ycbcr(col_i).red   := iRgb.ycbcr.red;
--            row_ycbcr(col_i).green := iRgb.ycbcr.green;
--            row_ycbcr(col_i).blue  := iRgb.ycbcr.blue;
--       end loop;
--      wait until iRgb.ycbcr.valid = lo;
--end loop;
--  --report row_ycbcr(image_width - 1).blue;
--  report "Simulation done. ImageYcbcrFrame.";
--end process;
--
--end Behavioral;