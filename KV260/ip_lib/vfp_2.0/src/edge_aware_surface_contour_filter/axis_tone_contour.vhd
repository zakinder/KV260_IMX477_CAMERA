-- =============================================================================
-- Module      : axis_tone_contour
-- Description : Stage 4 tone-mapping, contour detection, and RGB color
--               reconstruction stage for pic2_filter_axis. Evaluates a 5x5
--               window at spacing s=6 (25x25 footprint) across a 9-cycle
--               stalled-ready pipeline to lift shadows, ink edges/ridges, and
--               expand chroma saturation.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axis_tone_contour is
  generic (
    G_WIDTH     : positive := 2048; -- Maximum hardware frame width
    G_HEIGHT    : positive := 1152; -- Maximum hardware frame height
    G_SPACING   : positive := 6;    -- Tap spacing s (6 = 25x25 footprint)
    G_CHROMA_Q8 : integer  := 384   -- Q8 chroma boost gain (384/256 = 1.5x)
  );
  port (
    -- Clock, Reset, and Active Frame Geometry
    aclk          : in  std_logic;                     -- AXI4-Stream system clock
    aresetn       : in  std_logic;                     -- Synchronous active-low reset
    active_width  : in  std_logic_vector(15 downto 0); -- Active frame width
    active_height : in  std_logic_vector(15 downto 0); -- Active frame height

    -- AXI4-Stream Input Interface
    s_axis_tdata  : in  std_logic_vector(23 downto 0); -- Input RGB888 [23:16]=R, [15:8]=G, [7:0]=B
    s_axis_tvalid : in  std_logic;                     -- Input data valid
    s_axis_tready : out std_logic;                     -- Input backpressure ready
    s_axis_tuser  : in  std_logic;                     -- Start-of-Frame (SOF) marker
    s_axis_tlast  : in  std_logic;                     -- End-of-Line (EOL) marker

    -- AXI4-Stream Output Interface
    m_axis_tdata  : out std_logic_vector(23 downto 0); -- Reconstructed RGB888 output
    m_axis_tvalid : out std_logic;                     -- Output data valid
    m_axis_tready : in  std_logic;                     -- Downstream ready
    m_axis_tuser  : out std_logic;                     -- Output SOF marker
    m_axis_tlast  : out std_logic                      -- Output EOL marker
  );
end entity axis_tone_contour;

architecture rtl of axis_tone_contour is

  -- ---------------------------------------------------------------------------
  -- Tone Curve Anchor Table & Arithmetic Helper Functions
  -- ---------------------------------------------------------------------------
  type anchor_array_t is array (0 to 16) of integer range 0 to 256;
  constant ANCHORS : anchor_array_t := (
      0,  56,  81, 104, 122, 137, 149, 158, 168,
    180, 191, 201, 212, 223, 234, 245, 256
  );

  type rgb8_t is record
    r : integer range 0 to 255;
    g : integer range 0 to 255;
    b : integer range 0 to 255;
  end record rgb8_t;

  type tap_rgb_array_t  is array (0 to 24) of rgb8_t;
  type tap_luma_array_t is array (0 to 24) of integer range 0 to 255;

  -- Unpack 24-bit vector into RGB integer record
  function to_rgb8(v : std_logic_vector(23 downto 0)) return rgb8_t is
  begin
    return (
      r => to_integer(unsigned(v(23 downto 16))),
      g => to_integer(unsigned(v(15 downto 8))),
      b => to_integer(unsigned(v(7 downto 0)))
    );
  end function to_rgb8;

  -- Rounded 8-bit luma approximation: Y = (5R + 9G + 2B + 8) div 16
  function luma_y(c : rgb8_t) return integer is
  begin
    return (5 * c.r + 9 * c.g + 2 * c.b + 8) / 16;
  end function luma_y;

  -- Clamp integer value into [lo, hi]
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

  -- Function: tone
  -- Interpolates the 17-anchor shadow-lifting curve and blends 3 parts linear
  -- curve (T) with 1 part 8-step quantized level (S)
  function tone(y_in : integer) return integer is
    variable idx : integer range 0 to 15;
    variable frc : integer range 0 to 15;
    variable t   : integer;
    variable s   : integer;
  begin
    idx := y_in / 16;
    frc := y_in mod 16;
    t   := clamp_int(ANCHORS(idx) + ((frc * (ANCHORS(idx + 1) - ANCHORS(idx)) + 8) / 16), 0, 255);
    s   := clamp_int(8 * ((t + 4) / 8), 0, 255);
    return (3 * t + s + 2) / 4;
  end function tone;
  type curve_t is array (0 to 255) of integer range 0 to 255;
  function build_curve return curve_t is
    variable curve : curve_t;
  begin
    for i in curve'range loop curve(i) := tone(i); end loop;
    return curve;
  end function;
  constant CURVE : curve_t := build_curve;
  signal y_tap : tap_luma_array_t;
  signal center0, center_delay : rgb8_t;
  signal soft_delay, ink_delay, light_delay, min_delay : integer range 0 to 255;
  signal ink_part, ridge_part, light_part : integer range 0 to 255;
  signal curve_part, min_part, max_part : integer range 0 to 255;
  signal center_part, offset_rgb, output_rgb : rgb8_t;
  signal offset_y, offset_target, offset_room, output_offset : integer range 0 to 255;
  signal gain_delay : integer range 256 to 384;


  -- ---------------------------------------------------------------------------
  -- Window Generator & Pipeline Register Signals
  -- ---------------------------------------------------------------------------
  signal win_taps_flat : std_logic_vector(25 * 24 - 1 downto 0);
  signal win_taps      : tap_rgb_array_t;
  signal win_valid     : std_logic;
  signal win_ready     : std_logic;
  signal win_sof       : std_logic;
  signal win_eol       : std_logic;

  -- Pipeline Flow Control
  signal advance       : std_logic;
  signal v_pipe        : std_logic_vector(1 to 9) := (others => '0');
  signal sof_pipe      : std_logic_vector(1 to 9) := (others => '0');
  signal eol_pipe      : std_logic_vector(1 to 9) := (others => '0');

  -- Stage 1 Registers: Center RGB/Y, Sobel gradient, and ridge/light metrics
  signal s1_center     : rgb8_t;
  signal s1_y_center   : integer range 0 to 255;
  signal s1_grad       : integer range 0 to 2040;
  signal s1_dark_d     : integer range -255 to 255;
  signal s1_rd         : integer range -255 to 255;
  signal s1_rl         : integer range -255 to 255;

  -- Stage 2 Registers: Center RGB, target luma, channel min, and Q8 gain
  signal s2_center     : rgb8_t;
  signal s2_target     : integer range 0 to 255;
  signal s2_c_min      : integer range 0 to 255;
  signal s2_gain_q8    : integer range 256 to 512;

  -- Stage 3 Registers: Scaled relative RGB channels and delayed target luma
  signal s3_rel_rgb    : rgb8_t;
  signal s3_target     : integer range 0 to 255;

  -- Stage 4 Register: Final packed RGB888 output
  signal s4_tdata      : std_logic_vector(23 downto 0) := (others => '0');

begin

  -- ---------------------------------------------------------------------------
  -- 5x5 Line-Buffer Window Generator Instantiation (Spacing s = 6)
  -- ---------------------------------------------------------------------------
  u_win : entity work.axis_window5
    generic map (
      G_WIDTH       => G_WIDTH,
      G_HEIGHT      => G_HEIGHT,
      G_SPACING     => G_SPACING
    )
    port map (
      aclk          => aclk,
      aresetn       => aresetn,
      active_width  => active_width,
      active_height => active_height,
      s_axis_tdata  => s_axis_tdata,
      s_axis_tvalid => s_axis_tvalid,
      s_axis_tready => s_axis_tready,
      s_axis_tuser  => s_axis_tuser,
      s_axis_tlast  => s_axis_tlast,
      m_window_data => win_taps_flat,
      m_valid       => win_valid,
      m_ready       => win_ready,
      m_sof         => win_sof,
      m_eol         => win_eol
    );

  -- Unpack 25 flattened RGB888 taps (row-major 0..24, center = 12)
  gen_unpack : for i in 0 to 24 generate
    win_taps(i) <= to_rgb8(win_taps_flat((i + 1) * 24 - 1 downto i * 24));
  end generate gen_unpack;

  -- Backpressure advance enable
  advance       <= (not v_pipe(9)) or m_axis_tready;
  win_ready     <= advance;

  m_axis_tdata  <= s4_tdata;
  m_axis_tvalid <= v_pipe(9);
  m_axis_tuser  <= sof_pipe(9);
  m_axis_tlast  <= eol_pipe(9);

  -- ---------------------------------------------------------------------------
  -- Process     : render
  -- Description : 4-stage synchronous arithmetic pipeline executing Sobel and
  --               opposing-pair contour detection, shadow tone-curve mapping,
  --               Q8 chroma difference scaling, and luma offset reconstruction.
  -- ---------------------------------------------------------------------------
  render : process (aclk)
    variable yc          : integer;
    variable gx, gy      : integer;
    variable axial_sum   : integer;
    variable p_min, p_max: integer;
    variable max_p_min   : integer;
    variable min_p_max   : integer;

    variable v_soft      : integer;
    variable v_ink       : integer;
    variable v_ridge     : integer;
    variable v_light     : integer;
    variable v_c_min     : integer;
    variable v_c_max     : integer;
    variable v_span      : integer;

    variable v_rel_max   : integer;
    variable v_out_rgb   : rgb8_t;
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        v_pipe   <= (others => '0');
        sof_pipe <= (others => '0');
        eol_pipe <= (others => '0');
        s4_tdata <= (others => '0');

      elsif advance = '1' then
        -- Shift valid and frame/line sidebands across all 6 pipeline stages
        v_pipe   <= win_valid & v_pipe(1 to 8);
        sof_pipe <= win_sof   & sof_pipe(1 to 8);
        eol_pipe <= win_eol   & eol_pipe(1 to 8);

        -- ---------------------------------------------------------------------
        -- STAGES 1-2: Compute tap lumas, inner 3x3 Sobel gradient, axial dark-side
        --          measure d, and 4 outer opposing-pair ridge/light measures
        -- ---------------------------------------------------------------------
        for i in 0 to 24 loop
          y_tap(i) <= luma_y(win_taps(i));
        end loop;

        center0 <= win_taps(12);
        yc := y_tap(12);

        -- Inner 3x3 Sobel operators (taps 6,7,8 / 11,12,13 / 16,17,18)
        gx := (y_tap(8)  + 2 * y_tap(13) + y_tap(18)) -
              (y_tap(6)  + 2 * y_tap(11) + y_tap(16));
        gy := (y_tap(16) + 2 * y_tap(17) + y_tap(18)) -
              (y_tap(6)  + 2 * y_tap(7)  + y_tap(8));

        -- Rounded mean of 8 axial neighbors at +/-1 and +/-2 tap spacings minus Yc
        axial_sum := y_tap(2)  + y_tap(7)  + y_tap(17) + y_tap(22) +
                     y_tap(10) + y_tap(11) + y_tap(13) + y_tap(14);
        s1_dark_d <= ((axial_sum + 4) / 8) - yc;

        -- Four outer opposing pairs spanning center tap 12:
        -- Pair 0: Vertical (2, 22)   | Pair 1: Horizontal (10, 14)
        -- Pair 2: Main Diag (0, 24)  | Pair 3: Anti-Diag (4, 20)
        max_p_min := -1;
        min_p_max := 256;

        -- Pair 0: (2, 22)
        if y_tap(2) < y_tap(22) then p_min := y_tap(2); p_max := y_tap(22);
        else                         p_min := y_tap(22); p_max := y_tap(2); end if;
        if p_min > max_p_min then max_p_min := p_min; end if;
        if p_max < min_p_max then min_p_max := p_max; end if;

        -- Pair 1: (10, 14)
        if y_tap(10) < y_tap(14) then p_min := y_tap(10); p_max := y_tap(14);
        else                          p_min := y_tap(14); p_max := y_tap(10); end if;
        if p_min > max_p_min then max_p_min := p_min; end if;
        if p_max < min_p_max then min_p_max := p_max; end if;

        -- Pair 2: (0, 24)
        if y_tap(0) < y_tap(24) then p_min := y_tap(0); p_max := y_tap(24);
        else                         p_min := y_tap(24); p_max := y_tap(0); end if;
        if p_min > max_p_min then max_p_min := p_min; end if;
        if p_max < min_p_max then min_p_max := p_max; end if;

        -- Pair 3: (4, 20)
        if y_tap(4) < y_tap(20) then p_min := y_tap(4); p_max := y_tap(20);
        else                         p_min := y_tap(20); p_max := y_tap(4); end if;
        if p_min > max_p_min then max_p_min := p_min; end if;
        if p_max < min_p_max then min_p_max := p_max; end if;

        s1_center   <= center0;
        s1_y_center <= yc;
        s1_grad     <= abs(gx) + abs(gy);
        s1_rd       <= max_p_min - yc;
        s1_rl       <= yc - min_p_max;

        -- ---------------------------------------------------------------------
        -- STAGES 3-4: Compute tone target luma and center channel span / Q8 gain
        -- ---------------------------------------------------------------------
        curve_part <= CURVE(s1_y_center);
        soft_delay <= curve_part;

        if s1_dark_d <= 1 then
          v_ink := 0;
        else
          v_ink := clamp_int((clamp_int((s1_grad / 4) - 5, 0, 2040) / 4) + (s1_dark_d / 4), 0, 12);
        end if;

        v_light := clamp_int((3 * clamp_int(s1_rl - 3, 0, 255)) / 4, 0, 14);

        ink_part <= v_ink;
        ridge_part <= clamp_int(s1_rd - 2, 0, 255);
        v_ridge := clamp_int((3 * ridge_part) / 2, 0, 42);
        if ink_part >= v_ridge then
          ink_delay <= ink_part;
        else
          ink_delay <= v_ridge;
        end if;

        light_part <= v_light;
        light_delay <= light_part;
        -- Find center RGB min, max, and chroma span
        v_c_min := s1_center.r;
        v_c_max := s1_center.r;
        if s1_center.g < v_c_min then v_c_min := s1_center.g; end if;
        if s1_center.b < v_c_min then v_c_min := s1_center.b; end if;
        if s1_center.g > v_c_max then v_c_max := s1_center.g; end if;
        if s1_center.b > v_c_max then v_c_max := s1_center.b; end if;

        min_part <= v_c_min;
        max_part <= v_c_max;
        center_part <= s1_center;
        v_span := max_part - min_part;
        center_delay <= center_part;
        min_delay <= min_part;
        gain_delay <= 256 + clamp_int(255 - v_span, 0, G_CHROMA_Q8 - 256);

        -- ---------------------------------------------------------------------
        -- STAGES 5-6: Register target and scale channel differences by Q8 chroma gain
        -- ---------------------------------------------------------------------
        s2_center <= center_delay; s2_c_min <= min_delay; s2_gain_q8 <= gain_delay;
        s2_target <= clamp_int(soft_delay - ink_delay + light_delay, 0, 255);

        s3_rel_rgb.r <= ((s2_center.r - s2_c_min) * s2_gain_q8 + 128) / 256;
        s3_rel_rgb.g <= ((s2_center.g - s2_c_min) * s2_gain_q8 + 128) / 256;
        s3_rel_rgb.b <= ((s2_center.b - s2_c_min) * s2_gain_q8 + 128) / 256;
        s3_target    <= s2_target;

        -- ---------------------------------------------------------------------
        -- STAGES 7-9: Compute common luma offset, add to relative RGB, and pack
        -- ---------------------------------------------------------------------
        v_rel_max := s3_rel_rgb.r;
        if s3_rel_rgb.g > v_rel_max then v_rel_max := s3_rel_rgb.g; end if;
        if s3_rel_rgb.b > v_rel_max then v_rel_max := s3_rel_rgb.b; end if;

        offset_y <= luma_y(s3_rel_rgb);
        offset_room <= 255 - v_rel_max;
        offset_target <= s3_target;
        offset_rgb <= s3_rel_rgb;

        output_offset <= clamp_int(offset_target - offset_y, 0, offset_room);
        output_rgb <= offset_rgb;
        -- The registered offset is bounded by the brightest channel's headroom.
        v_out_rgb.r := output_rgb.r + output_offset;
        v_out_rgb.g := output_rgb.g + output_offset;
        v_out_rgb.b := output_rgb.b + output_offset;

        s4_tdata <= std_logic_vector(to_unsigned(v_out_rgb.r, 8)) &
                    std_logic_vector(to_unsigned(v_out_rgb.g, 8)) &
                    std_logic_vector(to_unsigned(v_out_rgb.b, 8));
      end if;
    end if;
  end process render;

end architecture rtl;
