-- =============================================================================
-- Module      : pic2_filter_axis
-- Description : Core 24-bit RGB888 AXI4-Stream edge-aware surface contour
--               filter engine. Connects five streaming processing stages in
--               series via internal AXI4-Stream buses p(0..5), v(0..5), and
--               r(0..5):
--                 p(0) -> [Stage 1: axis_surface_pass,   s=1, tol=20] -> p(1)
--                 p(1) -> [Stage 2: axis_surface_pass,   s=3, tol=14] -> p(2)
--                 p(2) -> [Stage 3: axis_surface_pass,   s=6, tol=10] -> p(3)
--                 p(3) -> [Stage 4: axis_tone_contour,   s=6        ] -> p(4)
--                 p(4) -> [Stage 5: axis_contour_finish, s=1        ] -> p(5)
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pic2_filter_axis is
  generic (
    G_WIDTH  : positive := 2048; -- Maximum hardware line-buffer width
    G_HEIGHT : positive := 1152; -- Maximum hardware frame height
    G_MEDIUM_STEP  : positive := 3;
    G_COARSE_STEP  : positive := 6;
    G_CONTOUR_STEP : positive := 6;
    G_CHROMA_Q8    : natural range 256 to 384 := 384
  );
  port (
    -- Clock, Synchronous Active-Low Reset, and Active Frame Geometry
    aclk          : in  std_logic;                     -- AXI4-Stream system clock
    aresetn       : in  std_logic;                     -- Synchronous active-low reset
    active_width  : in  std_logic_vector(15 downto 0); -- Active frame width in pixels
    active_height : in  std_logic_vector(15 downto 0); -- Active frame height in lines

    -- RGB888 AXI4-Stream Slave Input Interface (Boundary 0)
    s_axis_tdata  : in  std_logic_vector(23 downto 0); -- [23:16]=R, [15:8]=G, [7:0]=B
    s_axis_tvalid : in  std_logic;                     -- Input pixel valid
    s_axis_tready : out std_logic;                     -- Input ready backpressure
    s_axis_tuser  : in  std_logic;                     -- Start-of-Frame (SOF) marker
    s_axis_tlast  : in  std_logic;                     -- End-of-Line (EOL) marker

    -- RGB888 AXI4-Stream Master Output Interface (Boundary 5)
    m_axis_tdata  : out std_logic_vector(23 downto 0); -- Filtered RGB888 output
    m_axis_tvalid : out std_logic;                     -- Output pixel valid
    m_axis_tready : in  std_logic;                     -- Downstream ready backpressure
    m_axis_tuser  : out std_logic;                     -- Output Start-of-Frame (SOF) marker
    m_axis_tlast  : out std_logic                      -- Output End-of-Line (EOL) marker
  );
end entity pic2_filter_axis;

architecture rtl of pic2_filter_axis is

  -- ---------------------------------------------------------------------------
  -- Stage Configuration Constants & Inter-Stage Bus Types
  -- ---------------------------------------------------------------------------
  type int3_array_t is array (0 to 2) of integer;
  constant C_SPACING   : int3_array_t := (1, G_MEDIUM_STEP, G_COARSE_STEP);  -- Multiscale tap spacings s
  constant C_TOLERANCE : int3_array_t := (20, 14, 10); -- Surface score cutoffs

  type pixel_bus_t is array (0 to 5) of std_logic_vector(23 downto 0);

  -- Inter-stage AXI4-Stream signals across boundaries 0 (input) through 5 (output)
  signal p   : pixel_bus_t;                  -- RGB888 pixel buses p(0)..p(5)
  signal v   : std_logic_vector(0 to 5);     -- Valid handshakes v(0)..v(5)
  signal r   : std_logic_vector(0 to 5);     -- Ready handshakes r(0)..r(5)
  signal sof : std_logic_vector(0 to 5);     -- Start-of-Frame sidebands sof(0)..sof(5)
  signal eol : std_logic_vector(0 to 5);     -- End-of-Line sidebands eol(0)..eol(5)

begin

  -- ---------------------------------------------------------------------------
  -- External AXI4-Stream Boundary Wiring (Boundary 0 and Boundary 5)
  -- ---------------------------------------------------------------------------
  p(0)          <= s_axis_tdata;
  v(0)          <= s_axis_tvalid;
  s_axis_tready <= r(0);
  sof(0)        <= s_axis_tuser;
  eol(0)        <= s_axis_tlast;

  m_axis_tdata  <= p(5);
  m_axis_tvalid <= v(5);
  r(5)          <= m_axis_tready;
  m_axis_tuser  <= sof(5);
  m_axis_tlast  <= eol(5);

  -- ---------------------------------------------------------------------------
  -- Generate    : gen_surfaces
  -- Description : Instantiates the three cascaded edge-aware surface passes
  --               (Stages 1, 2, and 3) with progressively wider tap spacings
  --               (s = 1, 3, 6) and tighter homogeneity tolerances (20, 14, 10).
  -- ---------------------------------------------------------------------------
  gen_surfaces : for idx in 0 to 2 generate
    surfaces : entity work.axis_surface_pass
      generic map (
        G_WIDTH       => G_WIDTH,
        G_HEIGHT      => G_HEIGHT,
        G_SPACING     => C_SPACING(idx),
        G_TOLERANCE   => C_TOLERANCE(idx)
      )
      port map (
        aclk          => aclk,
        aresetn       => aresetn,
        active_width  => active_width,
        active_height => active_height,
        s_axis_tdata  => p(idx),
        s_axis_tvalid => v(idx),
        s_axis_tready => r(idx),
        s_axis_tuser  => sof(idx),
        s_axis_tlast  => eol(idx),
        m_axis_tdata  => p(idx + 1),
        m_axis_tvalid => v(idx + 1),
        m_axis_tready => r(idx + 1),
        m_axis_tuser  => sof(idx + 1),
        m_axis_tlast  => eol(idx + 1)
      );
  end generate gen_surfaces;

  -- ---------------------------------------------------------------------------
  -- Instance    : finish_pixel (Stage 4)
  -- Description : Tone-mapping, Sobel/opposing-pair contour ink & ridge
  --               detection, and Q8 chroma-boosted RGB color reconstruction
  --               operating at coarse tap spacing s = 6 (25x25 footprint).
  -- ---------------------------------------------------------------------------
  finish_pixel : entity work.axis_tone_contour
    generic map (
      G_WIDTH       => G_WIDTH,
      G_HEIGHT      => G_HEIGHT,
      G_SPACING     => G_CONTOUR_STEP,
      G_CHROMA_Q8   => G_CHROMA_Q8
    )
    port map (
      aclk          => aclk,
      aresetn       => aresetn,
      active_width  => active_width,
      active_height => active_height,
      s_axis_tdata  => p(3),
      s_axis_tvalid => v(3),
      s_axis_tready => r(3),
      s_axis_tuser  => sof(3),
      s_axis_tlast  => eol(3),
      m_axis_tdata  => p(4),
      m_axis_tvalid => v(4),
      m_axis_tready => r(4),
      m_axis_tuser  => sof(4),
      m_axis_tlast  => eol(4)
    );

  -- ---------------------------------------------------------------------------
  -- Instance    : antialias (Stage 5)
  -- Description : Color-limited 5x5 binomial smoothing ([1, 4, 6, 4, 1] weights,
  --               tap spacing s = 1) that softens stair-stepped contour edges
  --               while clamping samples whose channel distance exceeds 28.
  -- ---------------------------------------------------------------------------
  antialias : entity work.axis_contour_finish
    generic map (
      G_WIDTH       => G_WIDTH,
      G_HEIGHT      => G_HEIGHT,
      G_SPACING     => 1
    )
    port map (
      aclk          => aclk,
      aresetn       => aresetn,
      active_width  => active_width,
      active_height => active_height,
      s_axis_tdata  => p(4),
      s_axis_tvalid => v(4),
      s_axis_tready => r(4),
      s_axis_tuser  => sof(4),
      s_axis_tlast  => eol(4),
      m_axis_tdata  => p(5),
      m_axis_tvalid => v(5),
      m_axis_tready => r(5),
      m_axis_tuser  => sof(5),
      m_axis_tlast  => eol(5)
    );

end architecture rtl;
