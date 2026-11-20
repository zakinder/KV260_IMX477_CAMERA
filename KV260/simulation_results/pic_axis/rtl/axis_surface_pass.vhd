-- =============================================================================
-- Module      : axis_surface_pass
-- Description : Edge-aware 5x5 surface smoothing stage for pic2_filter_axis.
--               Evaluates four overlapping 3x3 sub-regions anchored at center
--               tap 12, selects regions within a homogeneity tolerance of the
--               best-matching surface, and blends the resulting surface mean
--               with the center pixel across a 12-cycle stalled-ready pipeline.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axis_surface_pass is
  generic (
    G_WIDTH     : positive := 2048; -- Maximum frame width for UltraRAM line buffers
    G_HEIGHT    : positive := 1152; -- Maximum frame height
    G_SPACING   : positive := 1;    -- Tap spacing s (1 = 5x5, 3 = 13x13, 6 = 25x25)
    G_TOLERANCE : natural  := 20    -- Score cutoff offset (20, 14, or 10)
  );
  port (
    -- Clock, Reset, and Frame Geometry
    aclk          : in  std_logic;                     -- AXI4-Stream system clock
    aresetn       : in  std_logic;                     -- Synchronous active-low reset
    active_width  : in  std_logic_vector(15 downto 0); -- Active frame width
    active_height : in  std_logic_vector(15 downto 0); -- Active frame height

    -- AXI4-Stream Input Interface
    s_axis_tdata  : in  std_logic_vector(23 downto 0); -- Input RGB888 [23:16]=R, [15:8]=G, [7:0]=B
    s_axis_tvalid : in  std_logic;                     -- Input data valid
    s_axis_tready : out std_logic;                     -- Input ready backpressure
    s_axis_tuser  : in  std_logic;                     -- Start-of-Frame (SOF) marker
    s_axis_tlast  : in  std_logic;                     -- End-of-Line (EOL) marker

    -- AXI4-Stream Output Interface
    m_axis_tdata  : out std_logic_vector(23 downto 0); -- Filtered RGB888 output
    m_axis_tvalid : out std_logic;                     -- Output data valid
    m_axis_tready : in  std_logic;                     -- Downstream ready
    m_axis_tuser  : out std_logic;                     -- Output SOF marker
    m_axis_tlast  : out std_logic                      -- Output EOL marker
  );
end entity axis_surface_pass;

architecture rtl of axis_surface_pass is

  -- ---------------------------------------------------------------------------
  -- Data Types & Pure Arithmetic Functions
  -- ---------------------------------------------------------------------------
  type rgb8_t is record
    r : integer range 0 to 255;
    g : integer range 0 to 255;
    b : integer range 0 to 255;
  end record rgb8_t;

  type tap_array_t  is array (0 to 24) of rgb8_t;
  type rgb4_array_t is array (0 to 3)  of rgb8_t;
  type int4_array_t is array (0 to 3)  of integer range 0 to 2047;

  -- 3-tap horizontal row strip summary
  type strip_t is record
    r_sum : integer range 0 to 765;
    g_sum : integer range 0 to 765;
    b_sum : integer range 0 to 765;
    y_min : integer range 0 to 255;
    y_max : integer range 0 to 255;
  end record strip_t;

  type strip10_array_t is array (0 to 9) of strip_t;

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

  -- Function: strip
  -- Reduces 3 horizontal taps into RGB sums and luma min/max extrema
  function strip(t0, t1, t2 : rgb8_t; y0, y1, y2 : integer) return strip_t is
    variable ymin, ymax : integer;
  begin
    ymin := y0;
    ymax := y0;
    if y1 < ymin then ymin := y1; end if;
    if y2 < ymin then ymin := y2; end if;
    if y1 > ymax then ymax := y1; end if;
    if y2 > ymax then ymax := y2; end if;

    return (
      r_sum => t0.r + t1.r + t2.r,
      g_sum => t0.g + t1.g + t2.g,
      b_sum => t0.b + t1.b + t2.b,
      y_min => ymin,
      y_max => ymax
    );
  end function strip;

  -- Function: candidate
  -- Combines 3 vertical row strips into a 3x3 region mean RGB and score
  type totals_t is array (0 to 3, 0 to 2) of integer range 0 to 2299;
  signal totals : totals_t;
  signal spans, mean_spans, score_spans, distances : int4_array_t;
  signal abs_delta, distance_colors : rgb4_array_t;
  signal distance_center : rgb8_t;
  signal distance_spans : int4_array_t;
  signal means, score_colors : rgb4_array_t;
  signal sum_center, mean_center, score_center, blend_center, blend_mean : rgb8_t;


  -- ---------------------------------------------------------------------------
  -- Window Generator & Pipeline Register Signals
  -- ---------------------------------------------------------------------------
  signal win_taps_flat : std_logic_vector(25 * 24 - 1 downto 0);
  signal win_taps      : tap_array_t;
  type tap_lumas_t is array (0 to 24) of integer range 0 to 255;
  signal strip_rgb : tap_array_t;
  signal strip_luma : tap_lumas_t;
  signal win_valid     : std_logic;
  signal win_ready     : std_logic;
  signal win_sof       : std_logic;
  signal win_eol       : std_logic;

  -- Pipeline Flow Control
  signal advance       : std_logic;
  signal v_pipe        : std_logic_vector(1 to 12) := (others => '0');
  signal sof_pipe      : std_logic_vector(1 to 12) := (others => '0');
  signal eol_pipe      : std_logic_vector(1 to 12) := (others => '0');

  -- Stage 1 Registers: Center pixel and 10 row strips
  signal s1_center     : rgb8_t;
  signal s1_strips     : strip10_array_t;

  -- Stage 2 Registers: Center pixel, 4 region means, and 4 scores
  signal s2_center     : rgb8_t;
  signal s2_means      : rgb4_array_t;
  signal s2_scores     : int4_array_t;

  -- Stage 3 Registers: Center pixel, winning mean, and 4 slot selections
  signal s3_center     : rgb8_t;
  signal s3_win_mean   : rgb8_t;
  signal s3_means      : rgb4_array_t;
  signal s3_scores     : int4_array_t;
  type pair_scores_t is array (0 to 1) of integer range 0 to 1275;
  type pair_colors_t is array (0 to 1) of rgb8_t;
  signal pair_scores : pair_scores_t;
  signal pair_colors : pair_colors_t;
  signal aligned_scores : int4_array_t;
  signal aligned_means : rgb4_array_t;
  signal aligned_center : rgb8_t;
  signal s3_best_score : integer range 0 to 1275;

  -- Stage 4 Register: Packed output RGB888 pixel
  signal half_blend, surface_blend : rgb8_t;
  signal edge_r, edge_g, edge_b : boolean;
  signal s4_tdata      : std_logic_vector(23 downto 0) := (others => '0');

begin

  -- ---------------------------------------------------------------------------
  -- 5x5 Line-Buffer Window Generator Instantiation
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

  -- Backpressure advance enable: advances whenever output is empty or accepted
  advance       <= (not v_pipe(12)) or m_axis_tready;
  win_ready     <= advance;

  m_axis_tdata  <= s4_tdata;
  m_axis_tvalid <= v_pipe(12);
  m_axis_tuser  <= sof_pipe(12);
  m_axis_tlast  <= eol_pipe(12);

  -- ---------------------------------------------------------------------------
  -- Process     : compute
  -- Description : 12-stage synchronous arithmetic pipeline executing strip
  --               reduction, 3x3 candidate scoring, tolerance gating, and
  --               center-preserving surface blending.
  -- ---------------------------------------------------------------------------
  compute : process (aclk)
    variable idx : natural range 0 to 5;
    variable a,b,c : strip_t;
    variable slots       : rgb4_array_t;
    variable v_cutoff    : integer;
    variable v_m_avg     : rgb8_t;
    variable v_out_rgb   : rgb8_t;
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        v_pipe   <= (others => '0');
        sof_pipe <= (others => '0');
        eol_pipe <= (others => '0');
        s4_tdata <= (others => '0');

      elsif advance = '1' then
        -- Shift valid and frame/line sidebands across all 12 pipeline stages
        v_pipe   <= win_valid & v_pipe(1 to 11);
        sof_pipe <= win_sof   & sof_pipe(1 to 11);
        eol_pipe <= win_eol   & eol_pipe(1 to 11);

        -- ---------------------------------------------------------------------
        -- STAGE 1: Latch center tap (12) and compute 10 overlapping row strips
        --          covering TL (0..2,5..7,10..12), TR (2..4,7..9,12..14),
        --          BL (10..12,15..17,20..22), and BR (12..14,17..19,22..24)
        -- ---------------------------------------------------------------------
        -- Register RGB and rounded luma before the strip extrema comparisons.
        strip_rgb <= win_taps;
        for i in 0 to 24 loop
          strip_luma(i) <= luma_y(win_taps(i));
        end loop;
        s1_center    <= strip_rgb(12);
        s1_strips(0) <= strip(strip_rgb(0), strip_rgb(1), strip_rgb(2), strip_luma(0), strip_luma(1), strip_luma(2));  -- Row 0 Left
        s1_strips(1) <= strip(strip_rgb(2), strip_rgb(3), strip_rgb(4), strip_luma(2), strip_luma(3), strip_luma(4));  -- Row 0 Right
        s1_strips(2) <= strip(strip_rgb(5), strip_rgb(6), strip_rgb(7), strip_luma(5), strip_luma(6), strip_luma(7));  -- Row 1 Left
        s1_strips(3) <= strip(strip_rgb(7), strip_rgb(8), strip_rgb(9), strip_luma(7), strip_luma(8), strip_luma(9));  -- Row 1 Right
        s1_strips(4) <= strip(strip_rgb(10), strip_rgb(11), strip_rgb(12), strip_luma(10), strip_luma(11), strip_luma(12)); -- Row 2 Left
        s1_strips(5) <= strip(strip_rgb(12), strip_rgb(13), strip_rgb(14), strip_luma(12), strip_luma(13), strip_luma(14)); -- Row 2 Right
        s1_strips(6) <= strip(strip_rgb(15), strip_rgb(16), strip_rgb(17), strip_luma(15), strip_luma(16), strip_luma(17)); -- Row 3 Left
        s1_strips(7) <= strip(strip_rgb(17), strip_rgb(18), strip_rgb(19), strip_luma(17), strip_luma(18), strip_luma(19)); -- Row 3 Right
        s1_strips(8) <= strip(strip_rgb(20), strip_rgb(21), strip_rgb(22), strip_luma(20), strip_luma(21), strip_luma(22)); -- Row 4 Left
        s1_strips(9) <= strip(strip_rgb(22), strip_rgb(23), strip_rgb(24), strip_luma(22), strip_luma(23), strip_luma(24)); -- Row 4 Right

        -- ---------------------------------------------------------------------
        -- STAGE 2: Form 4 overlapping 3x3 region means and homogeneity scores
        -- ---------------------------------------------------------------------
        sum_center <= s1_center;
        for q in 0 to 3 loop
          idx := 4*(q/2) + q mod 2;
          a := s1_strips(idx); b := s1_strips(idx+2); c := s1_strips(idx+4);
          totals(q,0) <= a.r_sum + b.r_sum + c.r_sum + 4;
          totals(q,1) <= a.g_sum + b.g_sum + c.g_sum + 4;
          totals(q,2) <= a.b_sum + b.b_sum + c.b_sum + 4;
          spans(q) <= work.pic2_types.largest(a.y_max,work.pic2_types.largest(b.y_max,c.y_max))
                    - work.pic2_types.smallest(a.y_min,work.pic2_types.smallest(b.y_min,c.y_min));
        end loop;

        -- Stages 3-5: rounded mean, channel distance, then final score.
        mean_center <= sum_center; mean_spans <= spans;
        score_center <= mean_center; score_colors <= means; score_spans <= mean_spans;
        distance_center <= score_center;
        distance_colors <= score_colors;
        distance_spans <= score_spans;
        s2_center <= distance_center;
        for q in 0 to 3 loop
          means(q).r <= (totals(q,0) * 3641) / 32768;
          means(q).g <= (totals(q,1) * 3641) / 32768;
          means(q).b <= (totals(q,2) * 3641) / 32768;
          -- Register absolute channel differences before the max comparison.
          abs_delta(q).r <= abs(means(q).r - mean_center.r);
          abs_delta(q).g <= abs(means(q).g - mean_center.g);
          abs_delta(q).b <= abs(means(q).b - mean_center.b);
          distances(q) <= work.pic2_types.largest(abs_delta(q).r,
            work.pic2_types.largest(abs_delta(q).g, abs_delta(q).b));
          s2_means(q) <= distance_colors(q);
          s2_scores(q) <= 2*distance_spans(q)+3*distances(q);
        end loop;

        -- ---------------------------------------------------------------------
        -- STAGE 6: Select winning region (strict '<' favors earlier index)
        --          and gate all 4 slots against min_score + G_TOLERANCE
        -- ---------------------------------------------------------------------
        -- Compare adjacent candidates first. The lower index wins ties
        -- at both levels, exactly as in the sequential four-way search.
        for pair_idx in 0 to 1 loop
          if s2_scores(2*pair_idx+1) < s2_scores(2*pair_idx) then
            pair_scores(pair_idx) <= s2_scores(2*pair_idx+1);
            pair_colors(pair_idx) <= s2_means(2*pair_idx+1);
          else
            pair_scores(pair_idx) <= s2_scores(2*pair_idx);
            pair_colors(pair_idx) <= s2_means(2*pair_idx);
          end if;
        end loop;
        aligned_scores <= s2_scores;
        aligned_means <= s2_means;
        aligned_center <= s2_center;

        if pair_scores(1) < pair_scores(0) then
          s3_best_score <= pair_scores(1);
          s3_win_mean <= pair_colors(1);
        else
          s3_best_score <= pair_scores(0);
          s3_win_mean <= pair_colors(0);
        end if;
        s3_scores <= aligned_scores;
        s3_means <= aligned_means;
        s3_center <= aligned_center;

        v_cutoff := s3_best_score + G_TOLERANCE;
        for i in 0 to 3 loop
          if s3_scores(i) <= v_cutoff then
            slots(i) := s3_means(i);
          else
            slots(i) := s3_win_mean;
          end if;
        end loop;

        -- ---------------------------------------------------------------------
        -- STAGE 7: Average 4 selected slots, apply isolated-center protection,
        --          and pack final 24-bit RGB888 output
        -- ---------------------------------------------------------------------
        v_m_avg.r := (slots(0).r + slots(1).r + slots(2).r + slots(3).r + 2) / 4;
        v_m_avg.g := (slots(0).g + slots(1).g + slots(2).g + slots(3).g + 2) / 4;
        v_m_avg.b := (slots(0).b + slots(1).b + slots(2).b + slots(3).b + 2) / 4;

        blend_mean <= v_m_avg; blend_center <= s3_center;

        -- Compute both rounded blends and the three edge tests in parallel.
        -- A difference of exactly 24 takes the surface blend.
        edge_r <= abs(blend_mean.r - blend_center.r) > 24;
        edge_g <= abs(blend_mean.g - blend_center.g) > 24;
        edge_b <= abs(blend_mean.b - blend_center.b) > 24;
        half_blend.r <= (blend_mean.r + blend_center.r + 1) / 2;
        half_blend.g <= (blend_mean.g + blend_center.g + 1) / 2;
        half_blend.b <= (blend_mean.b + blend_center.b + 1) / 2;
        surface_blend.r <= (7 * blend_mean.r + blend_center.r + 4) / 8;
        surface_blend.g <= (7 * blend_mean.g + blend_center.g + 4) / 8;
        surface_blend.b <= (7 * blend_mean.b + blend_center.b + 4) / 8;

        if edge_r or edge_g or edge_b then
          v_out_rgb := half_blend;
        else
          v_out_rgb := surface_blend;
        end if;
        s4_tdata <= std_logic_vector(to_unsigned(v_out_rgb.r, 8)) &
                    std_logic_vector(to_unsigned(v_out_rgb.g, 8)) &
                    std_logic_vector(to_unsigned(v_out_rgb.b, 8));
      end if;
    end if;
  end process compute;

end architecture rtl;
