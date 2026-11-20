-- =============================================================================
-- Module      : axis_contour_finish
-- Description : Stage 5 color-limited 5x5 binomial smoothing stage for
--               pic2_filter_axis. Replaces neighbor taps whose max channel
--               distance from center tap 12 exceeds 28 with their midpoint,
--               then applies separable [1, 4, 6, 4, 1] binomial weights across
--               a 2-cycle stalled-ready arithmetic pipeline.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axis_contour_finish is
  generic (
    G_WIDTH       : positive := 2048; -- Maximum hardware frame width
    G_HEIGHT      : positive := 1152; -- Maximum hardware frame height
    G_SPACING     : positive := 1;    -- Tap spacing s (1 = 5x5 footprint)
    G_DIFF_THRESH : natural  := 28    -- Max channel difference threshold before midpoint clamp
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
    m_axis_tdata  : out std_logic_vector(23 downto 0); -- Final smoothed RGB888 output
    m_axis_tvalid : out std_logic;                     -- Output data valid
    m_axis_tready : in  std_logic;                     -- Downstream ready
    m_axis_tuser  : out std_logic;                     -- Output SOF marker
    m_axis_tlast  : out std_logic                      -- Output EOL marker
  );
end entity axis_contour_finish;

architecture rtl of axis_contour_finish is

  -- ---------------------------------------------------------------------------
  -- Data Types & Pure Arithmetic Helper Functions
  -- ---------------------------------------------------------------------------
  type rgb8_t is record
    r : integer range 0 to 255;
    g : integer range 0 to 255;
    b : integer range 0 to 255;
  end record rgb8_t;

  type rgb_sum_t is record
    r : integer range 0 to 65535;
    g : integer range 0 to 65535;
    b : integer range 0 to 65535;
  end record rgb_sum_t;

  type tap_array_t  is array (0 to 24) of rgb8_t;
  type row5_sum_t   is array (0 to 4)  of rgb_sum_t;
  type weight5_t    is array (0 to 4)  of integer range 1 to 6;

  -- Separable 1-D binomial kernel weights (sum = 16; 2-D sum = 16 * 16 = 256)
  constant C_BINOM_W : weight5_t := (1, 4, 6, 4, 1);

  -- Unpack 24-bit vector into RGB integer record
  function to_rgb8(v : std_logic_vector(23 downto 0)) return rgb8_t is
  begin
    return (
      r => to_integer(unsigned(v(23 downto 16))),
      g => to_integer(unsigned(v(15 downto 8))),
      b => to_integer(unsigned(v(7 downto 0)))
    );
  end function to_rgb8;

  -- Maximum channel difference: D(A,B) = max(|Ar-Br|, |Ag-Bg|, |Ab-Bb|)
  function chan_dist(a, b : rgb8_t) return integer is
    variable dr, dg, db, m : integer;
  begin
    dr := abs(a.r - b.r);
    dg := abs(a.g - b.g);
    db := abs(a.b - b.b);
    m  := dr;
    if dg > m then m := dg; end if;
    if db > m then m := db; end if;
    return m;
  end function chan_dist;

  -- Function: limit_tap
  -- Replaces sample with (sample + center + 1) div 2 when D(sample, center) > 28
  function limit_tap(sample, center : rgb8_t; thresh : natural) return rgb8_t is
  begin
    if chan_dist(sample, center) > thresh then
      return (
        r => (sample.r + center.r + 1) / 2,
        g => (sample.g + center.g + 1) / 2,
        b => (sample.b + center.b + 1) / 2
      );
    else
      return sample;
    end if;
  end function limit_tap;

  -- ---------------------------------------------------------------------------
  -- Window Generator & 2-Stage Pipeline Register Signals
  -- ---------------------------------------------------------------------------
  signal win_taps_flat : std_logic_vector(25 * 24 - 1 downto 0);
  signal win_taps      : tap_array_t;
  signal win_valid     : std_logic;
  signal win_ready     : std_logic;
  signal win_sof       : std_logic;
  signal win_eol       : std_logic;

  -- Pipeline Flow Control
  signal advance       : std_logic;
  signal v_pipe        : std_logic_vector(1 to 2) := (others => '0');
  signal sof_pipe      : std_logic_vector(1 to 2) := (others => '0');
  signal eol_pipe      : std_logic_vector(1 to 2) := (others => '0');

  -- Stage 1 Registers: Five [1, 4, 6, 4, 1] horizontal weighted row sums
  signal s1_row_sums   : row5_sum_t;

  -- Stage 2 Register: Final packed RGB888 output pixel
  signal s2_tdata      : std_logic_vector(23 downto 0) := (others => '0');

begin

  -- ---------------------------------------------------------------------------
  -- 5x5 Line-Buffer Window Generator Instantiation (Spacing s = 1)
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
  advance       <= (not v_pipe(2)) or m_axis_tready;
  win_ready     <= advance;

  m_axis_tdata  <= s2_tdata;
  m_axis_tvalid <= v_pipe(2);
  m_axis_tuser  <= sof_pipe(2);
  m_axis_tlast  <= eol_pipe(2);

  -- ---------------------------------------------------------------------------
  -- Process     : average
  -- Description : 2-stage synchronous arithmetic pipeline that clamps distant
  --               samples (D > 28), accumulates 5 horizontal [1,4,6,4,1] row
  --               sums in Stage 1, and combines rows vertically with rounded
  --               division by 256 in Stage 2.
  -- ---------------------------------------------------------------------------
  average : process (aclk)
    variable v_center   : rgb8_t;
    variable v_limited  : rgb8_t;
    variable v_rsum     : rgb_sum_t;
    variable v_total    : rgb_sum_t;
    variable v_out_rgb  : rgb8_t;
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        v_pipe   <= (others => '0');
        sof_pipe <= (others => '0');
        eol_pipe <= (others => '0');
        s2_tdata <= (others => '0');

      elsif advance = '1' then
        -- Shift valid and frame/line sidebands across both pipeline stages
        v_pipe   <= win_valid & v_pipe(1);
        sof_pipe <= win_sof   & sof_pipe(1);
        eol_pipe <= win_eol   & eol_pipe(1);

        -- ---------------------------------------------------------------------
        -- STAGE 1: Limit distant taps against center (tap 12) and register
        --          five horizontal [1, 4, 6, 4, 1] binomial-weighted row sums
        -- ---------------------------------------------------------------------
        v_center := win_taps(12);

        for r in 0 to 4 loop
          v_rsum := (r => 0, g => 0, b => 0);
          for c in 0 to 4 loop
            v_limited := limit_tap(win_taps(r * 5 + c), v_center, G_DIFF_THRESH);
            v_rsum.r  := v_rsum.r + (C_BINOM_W(c) * v_limited.r);
            v_rsum.g  := v_rsum.g + (C_BINOM_W(c) * v_limited.g);
            v_rsum.b  := v_rsum.b + (C_BINOM_W(c) * v_limited.b);
          end loop;
          s1_row_sums(r) <= v_rsum;
        end loop;

        -- ---------------------------------------------------------------------
        -- STAGE 2: Combine five weighted row sums vertically with [1,4,6,4,1],
        --          round (+ 128), divide by 256, and pack RGB888 output
        -- ---------------------------------------------------------------------
        v_total := (r => 0, g => 0, b => 0);
        for r in 0 to 4 loop
          v_total.r := v_total.r + (C_BINOM_W(r) * s1_row_sums(r).r);
          v_total.g := v_total.g + (C_BINOM_W(r) * s1_row_sums(r).g);
          v_total.b := v_total.b + (C_BINOM_W(r) * s1_row_sums(r).b);
        end loop;

        v_out_rgb.r := (v_total.r + 128) / 256;
        v_out_rgb.g := (v_total.g + 128) / 256;
        v_out_rgb.b := (v_total.b + 128) / 256;

        s2_tdata <= std_logic_vector(to_unsigned(v_out_rgb.r, 8)) &
                    std_logic_vector(to_unsigned(v_out_rgb.g, 8)) &
                    std_logic_vector(to_unsigned(v_out_rgb.b, 8));
      end if;
    end if;
  end process average;

end architecture rtl;