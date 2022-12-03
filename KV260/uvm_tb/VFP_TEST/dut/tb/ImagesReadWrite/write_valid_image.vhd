-------------------------------------------------------------------------------
--
-- Filename    : write_valid_image.vhd
-- Create Date : 
-- Author      : 
--
-- Description:
-- 
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

entity write_valid_image is
generic (
    enImageText   : boolean := false;
    enImageIndex  : boolean := false;
    i_data_width  : integer := 8;
    test          : string  := "folder";
    input_file    : string  := "input_image";
    output_file   : string  := "output_image");
port (
    pixclk        : in  std_logic;
    iRgb          : in channel);
end write_valid_image;

architecture Behavioral of write_valid_image is

    constant wrBmp_rgb      : string := wImgFolder&bSlash&input_file&bSlash&output_file&"__"& integer'image(SLOT_NUM)&".bmp";
    constant rdBmp_rgb      : string := rImgFolder&fSlash&Histrograms&fSlash&Histrograms&".bmp";
    constant wrBmp_red      : string := wImgFolder&bSlash&input_file&bSlash&output_file&"_red__"& integer'image(SLOT_NUM)&".bmp";
    constant wrBmp_gre      : string := wImgFolder&bSlash&input_file&bSlash&output_file&"_gre__"& integer'image(SLOT_NUM)&".bmp";
    constant wrBmp_blu      : string := wImgFolder&bSlash&input_file&bSlash&output_file&"_blu__"& integer'image(SLOT_NUM)&".bmp";
    constant wrBmpRgbLog    : string := wImgFolder&bSlash&input_file&bSlash&LogsFolder&bSlash&output_file&"__"&integer'image(SLOT_NUM)&"_logs.txt";
    constant wrBmpRedLog    : string := wImgFolder&bSlash&input_file&bSlash&LogsFolder&bSlash&output_file&"__"&integer'image(SLOT_NUM)&"_red.txt";
    constant wrBmpGreLog    : string := wImgFolder&bSlash&input_file&bSlash&LogsFolder&bSlash&output_file&"__"&integer'image(SLOT_NUM)&"_gre.txt";
    constant wrBmpBluLog    : string := wImgFolder&bSlash&input_file&bSlash&LogsFolder&bSlash&output_file&"__"&integer'image(SLOT_NUM)&"_blu.txt";
    constant FILE_HEADER    : string := "#   ROW COL RED GRE BLU";
    
    type char_file is file of character;
    
    file bmp_file           : char_file open read_mode is rdBmp_rgb;
    file write_rgb_bmp_file : char_file open write_mode is wrBmp_rgb;
    file write_red_bmp_file : char_file open write_mode is wrBmp_red;
    file write_gre_bmp_file : char_file open write_mode is wrBmp_gre;
    file write_blu_bmp_file : char_file open write_mode is wrBmp_blu;
    file write_log_bmp_file : text open write_mode is wrBmpRgbLog;
    file write_red_log_file : text open write_mode is wrBmpRedLog;
    file write_gre_log_file : text open write_mode is wrBmpGreLog;
    file write_blu_log_file : text open write_mode is wrBmpBluLog;
    type header_type  is array (0 to 53) of character;
    type pixel_type is record
      red   : std_logic_vector(7 downto 0);
      green : std_logic_vector(7 downto 0);
      blue  : std_logic_vector(7 downto 0);
    end record;
    
    type row_type is array (integer range <>) of pixel_type;
    type row_pointer is access row_type;
    type image_type is array (integer range <>) of row_pointer;
    type image_pointer is access image_type;
    
    shared variable  header         : header_type;
    shared variable  image_width    : integer;
    shared variable  image_height   : integer;
    shared variable  padding        : integer;
    shared variable  char           : character;
    shared variable  vat            : integer := 0;
    
    shared variable  row            : row_pointer;
    shared variable  image          : image_pointer;
    

begin

ImageFrameP: process

    variable write_rgb_line : line;
    variable write_red_line : line;
    variable write_gre_line : line;
    variable write_blu_line : line;
    variable pixelIndex     : integer := 0;
    variable pixel_row      : integer := 0;
    variable pixel_col      : integer := 0;
    
    begin
    
    for i in header_type'range loop
        read(bmp_file, header(i));
    end loop;
    
    -- Check ID field
    assert header(0) = 'B' and header(1) = 'M'
        report "First two bytes are not ""BM"". This is not a BMP file"
        severity failure;
        
    -- Check that the pixel array offset is as expected
    assert character'pos(header(10)) = 54 and
        character'pos(header(11)) = 0 and
        character'pos(header(12)) = 0 and
        character'pos(header(13)) = 0
        report "Pixel array offset in header is not 54 bytes"
        severity failure;
        
    -- Check that DIB header size is 40 bytes,
    -- meaning that the BMP is of type BITMAPINFOHEADER
    assert character'pos(header(14)) = 40 and
        character'pos(header(15)) = 0 and
        character'pos(header(16)) = 0 and
        character'pos(header(17)) = 0
        report "DIB headers size is not 40 bytes, is this a Windows BMP?"
        severity failure;
        
    -- Check that the number of color planes is 1
    assert character'pos(header(26)) = 1 and
        character'pos(header(27)) = 0
        report "Color planes is not 1" severity failure;
        
    -- Check that the number of bits per pixel is 24
    assert character'pos(header(28)) = 24 and
        character'pos(header(29)) = 0
        report "Bits per pixel is not 24" severity failure;
        
    -- Read image width
    image_width := character'pos(header(18)) +
        character'pos(header(19)) * 2**8 +
        character'pos(header(20)) * 2**16 +
        character'pos(header(21)) * 2**24;
        
    -- Read image height
    image_height := character'pos(header(22)) +
        character'pos(header(23)) * 2**8 +
        character'pos(header(24)) * 2**16 +
        character'pos(header(25)) * 2**24;
        
    report "image_width: " & integer'image(image_width);
    report "image_height: " & integer'image(image_height);
    
    -- Number of bytes needed to pad each row to 32 bits
    padding := (4 - image_width*3 mod 4) mod 4;
    
    -- Create a new image type in dynamic memory
    image := new image_type(0 to image_height - 1);

-------------------------------------------
-- in_file
-------------------------------------------

for row_i in 0 to image_height - 1 loop

  -- Create a new row type in dynamic memory
  row := new row_type(0 to image_width - 1);
  for col_i in 0 to image_width - 1 loop
    read(bmp_file, char);
    row(col_i).blue := std_logic_vector(to_unsigned(character'pos(char), 8));
    read(bmp_file, char);
    row(col_i).green := std_logic_vector(to_unsigned(character'pos(char), 8));
    read(bmp_file, char);
    row(col_i).red := std_logic_vector(to_unsigned(character'pos(char), 8));
  end loop;
  
  -- Read and discard padding
  for i in 1 to padding loop
    read(bmp_file, char);
  end loop;
  
  -- Assign the row pointer to the image vector of rows
  image(row_i) := row;
  report "image row_i: " & integer'image(row_i);
  
end loop;


for row_i in 0 to image_height - 1 loop
  wait until iRgb.valid = hi;
  row := image(row_i);
      for col_i in 0 to image_width - 1 loop
            row(col_i).red   := iRgb.red;
            row(col_i).green := iRgb.green;
            row(col_i).blue  := iRgb.blue;
            wait for 1 ns;
       end loop;
      wait until iRgb.valid = lo;
end loop;

-------------------------------------------
-- write_rgb_bmp_file
-------------------------------------------
for i in header_type'range loop
  write(write_rgb_bmp_file, header(i));
  write(write_red_bmp_file, header(i));
  write(write_gre_bmp_file, header(i));
  write(write_blu_bmp_file, header(i));
end loop;

write(write_rgb_line,FILE_HEADER);
writeline(write_log_bmp_file, write_rgb_line);

for row_i in 0 to image_height - 1 loop

  row := image(row_i);
  pixel_row := pixel_row + 1;
  pixel_col := 0;
  
  for col_i in 0 to image_width - 1 loop
  
    pixel_col     := pixel_col + 1;
    pixelIndex    := pixelIndex + 1;
    
    write(write_rgb_bmp_file,character'val(to_integer(unsigned(row(col_i).blue))));
    write(write_rgb_bmp_file,character'val(to_integer(unsigned(row(col_i).green))));
    write(write_rgb_bmp_file,character'val(to_integer(unsigned(row(col_i).red))));
    
    write(write_red_bmp_file,character'val(to_integer(unsigned(row(col_i).red))));
    write(write_red_bmp_file,character'val(to_integer(unsigned(row(col_i).red))));
    write(write_red_bmp_file,character'val(to_integer(unsigned(row(col_i).red))));

    write(write_gre_bmp_file,character'val(to_integer(unsigned(row(col_i).blue))));
    write(write_gre_bmp_file,character'val(to_integer(unsigned(row(col_i).blue))));
    write(write_gre_bmp_file,character'val(to_integer(unsigned(row(col_i).blue))));

    write(write_blu_bmp_file,character'val(to_integer(unsigned(row(col_i).green))));
    write(write_blu_bmp_file,character'val(to_integer(unsigned(row(col_i).green))));
    write(write_blu_bmp_file,character'val(to_integer(unsigned(row(col_i).green))));
    
    write(write_red_line,(to_integer(unsigned(row(col_i).red))));
    write(write_red_line,HT);
    write(write_gre_line,(to_integer(unsigned(row(col_i).green))));
    write(write_gre_line,HT);
    write(write_blu_line,(to_integer(unsigned(row(col_i).blue))));
    write(write_blu_line,HT);

    
    if(enImageText = True) then
    
        if(enImageIndex = True) then
            write(write_rgb_line,pixelIndex);
            write(write_rgb_line,HT);
            write(write_rgb_line,pixel_row);
            write(write_rgb_line,HT);
            write(write_rgb_line,pixel_col);
            write(write_rgb_line,HT);
        end if;
        
        write(write_rgb_line,(to_integer(unsigned(row(col_i).red))));
        write(write_rgb_line,HT);
        write(write_rgb_line,(to_integer(unsigned(row(col_i).green))));
        write(write_rgb_line,HT);
        write(write_rgb_line,(to_integer(unsigned(row(col_i).blue))));
        writeline(write_log_bmp_file, write_rgb_line);
        
    end if;
  end loop;
  
  writeline(write_red_log_file, write_red_line);
  writeline(write_gre_log_file, write_gre_line);
  writeline(write_blu_log_file, write_blu_line);
  deallocate(row);
  
  -- Write padding
  for i in 1 to padding loop
    write(write_rgb_bmp_file, character'val(0));
    write(write_red_bmp_file, character'val(0));
    write(write_gre_bmp_file, character'val(0));
    write(write_blu_bmp_file, character'val(0));
  end loop;
  
end loop;

  deallocate(image);
  file_close(bmp_file);
  file_close(write_rgb_bmp_file);
  file_close(write_red_bmp_file);
  file_close(write_gre_bmp_file);
  file_close(write_blu_bmp_file);
  
  wait for 1 us;
  report "Simulation write_valid_image done............................";
  wait until vat = 1;
   
end process;
end Behavioral;