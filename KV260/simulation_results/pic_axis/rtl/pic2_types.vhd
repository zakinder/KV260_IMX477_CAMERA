-- =============================================================================
-- Package     : pic2_types
-- Description : Shared RGB888 record types, 25-tap window array definitions,
--               inter-stage AXI4-Stream bus arrays, and pure integer arithmetic
--               functions (luma approximation Y, max channel difference D,
--               packing/unpacking, and clamping) used across pic2_filter_axis.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pic2_types is

  -- ---------------------------------------------------------------------------
  -- Constant Definitions
  -- ---------------------------------------------------------------------------
  constant C_WINDOW_TAPS : positive := 25; -- 5x5 neighborhood tap count (0..24)
  constant C_CENTER_TAP  : natural  := 12; -- Center tap index in row-major order

  -- ---------------------------------------------------------------------------
  -- Shared Pixel, Window, and Inter-Stage Bus Types
  -- ---------------------------------------------------------------------------
  -- Unpacked 8-bit RGB pixel record
  type rgb8_t is record
    r : integer range 0 to 255;
    g : integer range 0 to 255;
    b : integer range 0 to 255;
  end record rgb8_t;

  -- Extended-precision RGB accumulator record for multi-tap sums
  type rgb_sum_t is record
    r : integer;
    g : integer;
    b : integer;
  end record rgb_sum_t;

  -- 25-tap row-major window arrays (indices 0..24, center = 12)
  type tap_rgb_array_t  is array (0 to C_WINDOW_TAPS - 1) of rgb8_t;
  type tap_luma_array_t is array (0 to C_WINDOW_TAPS - 1) of integer range 0 to 255;

  -- Inter-stage 24-bit RGB888 data bus array p(0..5) for pic2_filter_axis
  type pixel_bus_t      is array (0 to 5) of std_logic_vector(23 downto 0);

  -- ---------------------------------------------------------------------------
  -- Function Declarations
  -- ---------------------------------------------------------------------------
  -- Unpack 24-bit RGB888 vector [23:16]=R, [15:8]=G, [7:0]=B into rgb8_t
  function to_rgb8(v : std_logic_vector(23 downto 0)) return rgb8_t;

  -- Pack rgb8_t record into 24-bit RGB888 std_logic_vector
  function to_slv24(c : rgb8_t) return std_logic_vector;

  -- Rounded 8-bit luma approximation: Y(R,G,B) = (5R + 9G + 2B + 8) div 16
  function luma_y(c : rgb8_t) return integer;

  -- Maximum single-channel difference: D(A,B) = max(|Ar-Br|, |Ag-Bg|, |Ab-Bb|)
  function chan_dist(a, b : rgb8_t) return integer;

  -- Saturating integer clamp into [lo, hi]
  function clamp_int(val, lo, hi : integer) return integer;

end package pic2_types;

package body pic2_types is

  -- ---------------------------------------------------------------------------
  -- Function    : to_rgb8
  -- Description : Extracts 8-bit unsigned R, G, and B channels from a 24-bit
  --               AXI4-Stream RGB888 pixel word.
  -- ---------------------------------------------------------------------------
  function to_rgb8(v : std_logic_vector(23 downto 0)) return rgb8_t is
  begin
    return (
      r => to_integer(unsigned(v(23 downto 16))),
      g => to_integer(unsigned(v(15 downto 8))),
      b => to_integer(unsigned(v(7 downto 0)))
    );
  end function to_rgb8;

  -- ---------------------------------------------------------------------------
  -- Function    : to_slv24
  -- Description : Packs an rgb8_t record into a 24-bit RGB888 vector.
  -- ---------------------------------------------------------------------------
  function to_slv24(c : rgb8_t) return std_logic_vector is
  begin
    return std_logic_vector(to_unsigned(c.r, 8)) &
           std_logic_vector(to_unsigned(c.g, 8)) &
           std_logic_vector(to_unsigned(c.b, 8));
  end function to_slv24;

  -- ---------------------------------------------------------------------------
  -- Function    : luma_y
  -- Description : Computes the 8-bit luma approximation with rounded division
  --               by 16: Y(R,G,B) = (5R + 9G + 2B + 8) div 16.
  -- ---------------------------------------------------------------------------
  function luma_y(c : rgb8_t) return integer is
  begin
    return (5 * c.r + 9 * c.g + 2 * c.b + 8) / 16;
  end function luma_y;

  -- ---------------------------------------------------------------------------
  -- Function    : chan_dist
  -- Description : Returns the largest absolute channel difference across R, G,
  --               and B: D(A,B) = max(|Ar - Br|, |Ag - Bg|, |Ab - Bb|).
  -- ---------------------------------------------------------------------------
  function chan_dist(a, b : rgb8_t) return integer is
    variable dr : integer;
    variable dg : integer;
    variable db : integer;
    variable m  : integer;
  begin
    dr := abs(a.r - b.r);
    dg := abs(a.g - b.g);
    db := abs(a.b - b.b);

    m := dr;
    if dg > m then
      m := dg;
    end if;
    if db > m then
      m := db;
    end if;

    return m;
  end function chan_dist;

  -- ---------------------------------------------------------------------------
  -- Function    : clamp_int
  -- Description : Clamps an integer value to the closed interval [lo, hi].
  -- ---------------------------------------------------------------------------
  function clamp_int(val, lo, hi : integer) return integer is
  begin
    if val < lo then
      return lo;
    elsif val > hi then
      return hi;
    else
      return val;
    end if;
  end function clamp_int;

end package body pic2_types;