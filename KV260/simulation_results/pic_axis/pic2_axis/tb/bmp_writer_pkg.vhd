library ieee;
use ieee.numeric_std.all;
use work.pic2_types.all;
use work.jpeg_reader_pkg.all;

package bmp_writer_pkg is
  type bmp_file_t is file of character;
  procedure bmp_header(file dst : bmp_file_t; w,h : positive);
  procedure bmp_pixel(file dst : bmp_file_t; p : pixel_t);
  procedure bmp_end_line(file dst : bmp_file_t; w : positive);
  procedure write_frame(path : string; variable pixels : in frame_ptr; w,h : positive);
end package;

package body bmp_writer_pkg is
  procedure b(file dst : bmp_file_t; v : natural) is
  begin write(dst,character'val(v mod 256)); end;
  procedure le32(file dst : bmp_file_t; v : integer) is
    variable raw : signed(31 downto 0) := to_signed(v,32);
  begin
    for i in 0 to 3 loop b(dst,to_integer(unsigned(raw(8*i+7 downto 8*i)))); end loop;
  end;
  procedure bmp_header(file dst : bmp_file_t; w,h : positive) is
    constant bytes : positive := ((3*w+3)/4)*4*h;
  begin
    write(dst,'B'); write(dst,'M'); le32(dst,54+bytes); le32(dst,0); le32(dst,54);
    le32(dst,40); le32(dst,w); le32(dst,-h); -- top-down, first beat is top left
    b(dst,1); b(dst,0); b(dst,24); b(dst,0);
    le32(dst,0); le32(dst,bytes); le32(dst,0); le32(dst,0); le32(dst,0); le32(dst,0);
  end;
  procedure bmp_pixel(file dst : bmp_file_t; p : pixel_t) is
    variable c : rgb_t := unpack(p);
  begin b(dst,c(2)); b(dst,c(1)); b(dst,c(0)); end;
  procedure bmp_end_line(file dst : bmp_file_t; w : positive) is
  begin
    for i in 1 to ((4-((3*w) mod 4)) mod 4) loop b(dst,0); end loop;
  end;
  procedure write_frame(path : string; variable pixels : in frame_ptr; w,h : positive) is
    file dst : bmp_file_t open write_mode is path;
  begin
    bmp_header(dst,w,h);
    for y in 0 to h-1 loop
      for x in 0 to w-1 loop bmp_pixel(dst,pixels(y*w+x)); end loop;
      bmp_end_line(dst,w);
    end loop;
  end;
end package body;
