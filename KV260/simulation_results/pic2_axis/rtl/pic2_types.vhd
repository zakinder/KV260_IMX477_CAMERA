-- Packed pixel keeps the line memories at 24 bits per sample.
library ieee;
use ieee.std_logic_1164.all;

package pic2_types is
  subtype byte_t is natural range 0 to 255;
  subtype pixel_t is natural range 0 to 16#FFFFFF#;
  type rgb_t is array (0 to 2) of byte_t;
  type window_t is array (0 to 24) of pixel_t; -- top left first, center at 12

  function unpack(p : pixel_t) return rgb_t;
  function pack(c : rgb_t) return pixel_t;
  function luma(c : rgb_t) return byte_t;
  function largest(a, b : integer) return integer;
  function smallest(a, b : integer) return integer;
  function clamp(v, lo, hi : integer) return integer;
  function magnitude(v : integer) return natural;
  function distance(a, b : rgb_t) return natural;
end package;

package body pic2_types is
  function unpack(p : pixel_t) return rgb_t is
  begin
    return (p / 65536, (p / 256) mod 256, p mod 256);
  end;
  function pack(c : rgb_t) return pixel_t is
  begin
    return c(0)*65536 + c(1)*256 + c(2);
  end;
  function luma(c : rgb_t) return byte_t is
  begin
    return (5*c(0) + 9*c(1) + 2*c(2) + 8)/16;
  end;
  function largest(a, b : integer) return integer is
  begin
    if a > b then return a; end if;
    return b;
  end;
  function smallest(a, b : integer) return integer is
  begin
    if a < b then return a; end if;
    return b;
  end;
  function clamp(v, lo, hi : integer) return integer is
  begin
    return largest(lo, smallest(v, hi));
  end;
  function magnitude(v : integer) return natural is
  begin
    if v<0 then return -v; end if;
    return v;
  end;
  function distance(a, b : rgb_t) return natural is
  begin
    return largest(magnitude(a(0)-b(0)), largest(magnitude(a(1)-b(1)), magnitude(a(2)-b(2))));
  end;
end package body;
