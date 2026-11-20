-- =============================================================================
-- Module      : axis_contour_finish
-- Description : Stage 5 color-limited 5x5 binomial smoothing stage for
--               pic2_filter_axis. Replaces neighbor taps whose max channel
--               distance from center tap 12 exceeds 28 with their midpoint,
--               then applies separable [1, 4, 6, 4, 1] binomial weights across
--               a 7-cycle stalled-ready arithmetic pipeline.
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

  type tap_array_t is array (0 to 24) of rgb8_t;
  type delta_array_t is array (0 to 24, 0 to 2) of integer range -255 to 255;
  signal delta : delta_array_t;
  signal original, midpoint, limited : tap_array_t;
  constant PIPE_DEPTH : positive := 7;

  -- Unpack 24-bit vector into RGB integer record
  function to_rgb8(v : std_logic_vector(23 downto 0)) return rgb8_t is
  begin
    return (
      r => to_integer(unsigned(v(23 downto 16))),
      g => to_integer(unsigned(v(15 downto 8))),
      b => to_integer(unsigned(v(7 downto 0)))
    );
  end function to_rgb8;

  signal win_taps_flat : std_logic_vector(25 * 24 - 1 downto 0);
  signal win_taps      : tap_array_t;
  signal win_valid     : std_logic;
  signal win_ready     : std_logic;
  signal win_sof       : std_logic;
  signal win_eol       : std_logic;

  -- Pipeline Flow Control
  signal advance       : std_logic;
  signal v_pipe        : std_logic_vector(1 to PIPE_DEPTH) := (others => '0');
  signal sof_pipe      : std_logic_vector(1 to PIPE_DEPTH) := (others => '0');
  signal eol_pipe      : std_logic_vector(1 to PIPE_DEPTH) := (others => '0');


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
  advance       <= (not v_pipe(PIPE_DEPTH)) or m_axis_tready;
  win_ready     <= advance;

  m_axis_tvalid <= v_pipe(PIPE_DEPTH);
  m_axis_tuser  <= sof_pipe(PIPE_DEPTH);
  m_axis_tlast  <= eol_pipe(PIPE_DEPTH);

  -- ---------------------------------------------------------------------------
  -- Register the differences and both clamp choices before threshold selection.
  process (aclk)
    variable center, sample : rgb8_t;
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        v_pipe   <= (others => '0');
        sof_pipe <= (others => '0');
        eol_pipe <= (others => '0');
      elsif advance = '1' then
        v_pipe   <= win_valid & v_pipe(1 to PIPE_DEPTH-1);
        sof_pipe <= win_sof & sof_pipe(1 to PIPE_DEPTH-1);
        eol_pipe <= win_eol & eol_pipe(1 to PIPE_DEPTH-1);
        center := win_taps(12);
        for i in 0 to 24 loop
          sample := win_taps(i);
          delta(i,0) <= sample.r - center.r;
          delta(i,1) <= sample.g - center.g;
          delta(i,2) <= sample.b - center.b;
          original(i) <= sample;
          midpoint(i) <= ((sample.r + center.r + 1)/2,
                          (sample.g + center.g + 1)/2,
                          (sample.b + center.b + 1)/2);
          if delta(i,0) > G_DIFF_THRESH or delta(i,0) < -G_DIFF_THRESH or
             delta(i,1) > G_DIFF_THRESH or delta(i,1) < -G_DIFF_THRESH or
             delta(i,2) > G_DIFF_THRESH or delta(i,2) < -G_DIFF_THRESH then
            limited(i) <= midpoint(i);
          else
            limited(i) <= original(i);
          end if;
        end loop;
      end if;
    end if;
  end process;

  -- Each channel uses the same exact [1,4,6,4,1] kernel in both dimensions.
  -- Factor it as (a+e) + 4*(b+d+c) + 2*c. Round only after the vertical sum.
  channels : for ch in 0 to 2 generate
    type pixels_t is array (0 to 24) of integer range 0 to 255;
    type pair_t is array (0 to 4) of integer range 0 to 510;
    type triple_t is array (0 to 4) of integer range 0 to 765;
    type centers_t is array (0 to 4) of integer range 0 to 255;
    type rows_t is array (0 to 4) of integer range 0 to 4080;
    signal pixels : pixels_t;
    signal outer_pair : pair_t;
    signal inner_three : triple_t;
    signal centers : centers_t;
    signal rows : rows_t;
    signal vertical_outer : integer range 0 to 8160;
    signal vertical_inner : integer range 0 to 12240;
    signal vertical_center : integer range 0 to 4080;
    signal total : integer range 0 to 65280;
  begin
    unpack : for i in 0 to 24 generate
      pixels(i) <= limited(i).b when ch = 0 else
                   limited(i).g when ch = 1 else limited(i).r;
    end generate;

    process (aclk)
    begin
      if rising_edge(aclk) then
        if aresetn = '0' then
          m_axis_tdata(8*ch+7 downto 8*ch) <= (others => '0');
        elsif advance = '1' then
          for r in 0 to 4 loop
            outer_pair(r) <= pixels(5*r) + pixels(5*r+4);
            inner_three(r) <= pixels(5*r+1) + pixels(5*r+3) + pixels(5*r+2);
            centers(r) <= pixels(5*r+2);
            rows(r) <= outer_pair(r) + 4*inner_three(r) + 2*centers(r);
          end loop;
          vertical_outer <= rows(0) + rows(4);
          vertical_inner <= rows(1) + rows(3) + rows(2);
          vertical_center <= rows(2);
          total <= vertical_outer + 4*vertical_inner + 2*vertical_center;
          m_axis_tdata(8*ch+7 downto 8*ch) <=
            std_logic_vector(to_unsigned((total+128)/256, 8));
        end if;
      end if;
    end process;
  end generate;

end architecture rtl;
