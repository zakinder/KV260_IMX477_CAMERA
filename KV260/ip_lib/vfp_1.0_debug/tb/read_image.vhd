-------------------------------------------------------------------------------
--
-- Filename    : read_image.vhd
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
use work.tb_pkg.all;

entity read_image is
generic (
    enImageText   : boolean := false;
    enImageIndex  : boolean := false;
    i_data_width  : integer := 10;
    test          : string  := "folder";
    input_file    : string  := "input_image";
    output_file   : string  := "output_image");
port (
    pixclk        : in  std_logic;
    oCord         : out coord;
    oRgb          : out channel);
end read_image; 
architecture Behavioral of read_image is
    constant readbmp       : string := rImgFolder&fSlash&readbmp&fSlash&readbmp&".bmp";
    type char_file is file of character;
    file bmp_file          : char_file open read_mode is readbmp;
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
    signal rgb   :  channel;
    signal crd   :  coord  := (x => (others => '0'), y => (others => '0'));
    shared variable  header         : header_type;
    shared variable  image_width    : integer;
    shared variable  image_height   : integer;
    shared variable  row            : row_pointer;
    shared variable  row_p          : row_pointer;
    shared variable  image          : image_pointer;
    shared variable  padding        : integer;
    shared variable  char           : character;
    shared variable  rowIndex       : integer := 0;
    shared variable  colIndex       : integer := 0;
    shared variable  vat            : integer := 0;
begin
process (pixclk) begin
    if rising_edge(pixclk) then
        oCord.x    <= crd.x;
    end if;
end process;
oCord.y    <= crd.y;
ImageFrameP: process
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
    assert character'pos(header(28)) = 32 and
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
    -- Read blue pixel
    read(bmp_file, char);
    row(col_i).blue :=
      std_logic_vector(to_unsigned(character'pos(char), 8));
    -- Read green pixel
    read(bmp_file, char);
    row(col_i).green :=
      std_logic_vector(to_unsigned(character'pos(char), 8));
    -- Read red pixel
    read(bmp_file, char);
    row(col_i).red :=
      std_logic_vector(to_unsigned(character'pos(char), 8));
  end loop;
  -- Read and discard padding
  for i in 1 to padding loop
    read(bmp_file, char);
  end loop;
  -- Assign the row pointer to the image vector of rows
  image(row_i) := row;
end loop;
wait for 100 ns;
for row_i in 0 to image_height - 1 loop
  row := image(row_i);
  rowIndex := rowIndex + 1;
  for col_i in 0 to image_width - 1 loop
        --colIndex := colIndex + 1;
        crd.x     <= std_logic_vector(to_unsigned(col_i, 16));
        crd.y     <= std_logic_vector(to_unsigned(row_i, 16));
        oRgb.red    <= row(col_i).red;
        oRgb.green  <= row(col_i).green;
        oRgb.blue   <= row(col_i).blue;
        oRgb.valid  <= hi;
    wait until pixclk'event and pixclk = '1';
  end loop;
        crd.x       <= std_logic_vector(to_unsigned(0, 16));
        oRgb.valid  <= lo;
    wait for 30 ns;
end loop;

wait for 10 us;

for row_i in 0 to image_height - 1 loop
  row := image(row_i);
  rowIndex := rowIndex + 1;
  for col_i in 0 to image_width - 1 loop
        --colIndex := colIndex + 1;
        crd.x     <= std_logic_vector(to_unsigned(col_i, 16));
        crd.y     <= std_logic_vector(to_unsigned(row_i, 16));
        oRgb.red    <= row(col_i).red;
        oRgb.green  <= row(col_i).green;
        oRgb.blue   <= row(col_i).blue;
        oRgb.valid  <= hi;
    wait until pixclk'event and pixclk = '1';
  end loop;
        crd.x       <= std_logic_vector(to_unsigned(0, 16));
        oRgb.valid  <= lo;
    wait for 30 ns;
end loop;


  deallocate(image);
  file_close(bmp_file);
  wait for 100 ns;
  report "Simulation done. Check ""out.bmp"" image.";
  wait until vat = 1;
end process ImageFrameP;
end Behavioral;