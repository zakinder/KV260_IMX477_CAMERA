-- =============================================================================
-- Module      : surface_contour_select
-- Description : Top-level 32-bit RGB10 AXI4-Stream wrapper for the 8-bit
--               edge-aware surface contour filter core (pic2_filter_axis).
--               Supports frame-synchronized bypass, 10-to-8-bit channel
--               truncation, 8-to-10-bit zero-padded expansion, and clean
--               end-of-frame pipeline draining.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity surface_contour_select is
  generic (
    G_MAX_WIDTH  : positive := 2048; -- Maximum supported horizontal frame width
    G_MAX_HEIGHT : positive := 1152; -- Maximum supported vertical frame height
    DATA_WIDTH : positive := 32
  );
  port (
    -- Clock, Reset, and Frame Control
    aclk          : in  std_logic;                     -- AXI4-Stream system clock
    aresetn       : in  std_logic;                     -- Synchronous active-low reset
    enable        : in  std_logic;                     -- '1' = arm filter at next SOF, '0' = bypass
    dimensions    : in  std_logic_vector(31 downto 0); -- [15:0] = frame width, [31:16] = frame height

    -- RGB10 AXI4-Stream Slave Input Interface
    s_axis_tdata  : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- [29:20]=R10, [19:10]=G10, [9:0]=B10
    s_axis_tvalid : in  std_logic;                     -- Input data valid
    s_axis_tready : out std_logic;                     -- Input backpressure ready
    s_axis_tuser  : in  std_logic;                     -- Start-of-Frame (SOF) marker
    s_axis_tlast  : in  std_logic;                     -- End-of-Line (EOL) marker

    -- RGB10 AXI4-Stream Master Output Interface
    m_axis_tdata  : out std_logic_vector(DATA_WIDTH-1 downto 0); -- [29:20]=R10, [19:10]=G10, [9:0]=B10
    m_axis_tvalid : out std_logic;                     -- Output data valid
    m_axis_tready : in  std_logic;                     -- Downstream ready
    m_axis_tuser  : out std_logic;                     -- Output Start-of-Frame (SOF) marker
    filtered      : out std_logic;
    m_axis_tlast  : out std_logic                      -- Output End-of-Line (EOL) marker
  );
end entity surface_contour_select;

architecture rtl of surface_contour_select is

  -- ---------------------------------------------------------------------------
  -- Type and Internal Signal Declarations
  -- ---------------------------------------------------------------------------
  type state_t is (ST_BYPASS, ST_FEED, ST_DRAIN);
  signal state         : state_t               := ST_BYPASS;

  -- Latched Frame Dimensions & Line Counters
  signal active_width  : unsigned(15 downto 0) := (others => '0');
  signal active_height : unsigned(15 downto 0) := (others => '0');
  signal in_eol_cnt    : unsigned(15 downto 0) := (others => '0');
  signal out_eol_cnt   : unsigned(15 downto 0) := (others => '0');

  -- Internal RGB888 Core AXI4-Stream Signals
  signal core_s_tdata  : std_logic_vector(23 downto 0);
  signal core_s_tvalid : std_logic;
  signal core_s_tready : std_logic;
  signal core_m_tdata  : std_logic_vector(23 downto 0);
  signal core_m_tvalid : std_logic;
  signal core_m_tready : std_logic;
  signal core_m_tuser  : std_logic;
  signal core_m_tlast  : std_logic;

  -- Combinational Dimension Decoding & Validation
  signal run_core, bypass_held : std_logic;
  signal dim_w         : unsigned(15 downto 0);
  signal dim_h         : unsigned(15 downto 0);
  signal dims_valid    : boolean;
  signal arm_filter    : boolean;

begin

  -- ---------------------------------------------------------------------------
  -- Combinational Dimension Check & Channel Width Conversion
  -- ---------------------------------------------------------------------------
  dim_w      <= unsigned(dimensions(15 downto 0));
  dim_h      <= unsigned(dimensions(31 downto 16));

  dims_valid <= (dim_w > 0 and dim_w <= G_MAX_WIDTH) and
                (dim_h > 0 and dim_h <= G_MAX_HEIGHT);

  -- Trigger condition to arm filtering on an incoming Start-of-Frame beat
  arm_filter <= bypass_held = '0' and (s_axis_tvalid = '1') and
                (s_axis_tuser  = '1') and
                (enable        = '1') and
                dims_valid;

  -- Truncate 10-bit RGB lanes to upper 8 bits for the RGB888 core
  core_s_tdata <= s_axis_tdata(29 downto 22) & -- R8 (upper 8 bits of R10)
                  s_axis_tdata(19 downto 12) & -- G8 (upper 8 bits of G10)
                  s_axis_tdata(9 downto 2);    -- B8 (upper 8 bits of B10)

  -- ---------------------------------------------------------------------------
  -- Core RGB888 Filter Instantiation (5-Stage Streaming Pipeline)
  -- ---------------------------------------------------------------------------
  run_core <= aresetn when state /= ST_BYPASS else '0';
  filtered <= run_core;
  core : entity work.pic2_filter_axis
    generic map (
      G_WIDTH       => G_MAX_WIDTH,
      G_HEIGHT      => G_MAX_HEIGHT
    )
    port map (
      aclk          => aclk,
      aresetn       => run_core,
      active_width  => std_logic_vector(active_width),
      active_height => std_logic_vector(active_height),
      s_axis_tdata  => core_s_tdata,
      s_axis_tvalid => core_s_tvalid,
      s_axis_tready => core_s_tready,
      s_axis_tuser  => s_axis_tuser,
      s_axis_tlast  => s_axis_tlast,
      m_axis_tdata  => core_m_tdata,
      m_axis_tvalid => core_m_tvalid,
      m_axis_tready => core_m_tready,
      m_axis_tuser  => core_m_tuser,
      m_axis_tlast  => core_m_tlast
    );

  -- ---------------------------------------------------------------------------
  -- AXI4-Stream Routing & RGB888 -> RGB10 Zero-Padded Expansion
  -- ---------------------------------------------------------------------------
  core_s_tvalid <= s_axis_tvalid when (state = ST_FEED) else '0';

  core_m_tready <= m_axis_tready when (state = ST_FEED or state = ST_DRAIN) else '0';

  -- Hold input beat for 1 cycle on arm_filter SOF; stall during ST_DRAIN
  s_axis_tready <= core_s_tready when (state = ST_FEED) else
                   '0'           when (state = ST_DRAIN or (state = ST_BYPASS and arm_filter)) else
                   m_axis_tready;

  -- Expand filtered 8-bit channels back to 10-bit lanes by appending "00" LSBs
  m_axis_tdata  <= std_logic_vector(resize(unsigned('0' &
                   core_m_tdata(23 downto 16) & "00" & -- R10
                   core_m_tdata(15 downto 8)  & "00" & -- G10
                   core_m_tdata(7 downto 0)   & "00"),DATA_WIDTH)) -- B10
                   when (state = ST_FEED or state = ST_DRAIN) else
                   s_axis_tdata;

  -- Suppress output valid during the 1-cycle SOF arming hold in ST_BYPASS
  m_axis_tvalid <= core_m_tvalid when (state = ST_FEED or state = ST_DRAIN) else
                   '0'           when (state = ST_BYPASS and arm_filter) else
                   s_axis_tvalid;

  m_axis_tuser  <= core_m_tuser  when (state = ST_FEED or state = ST_DRAIN) else s_axis_tuser;
  m_axis_tlast  <= core_m_tlast  when (state = ST_FEED or state = ST_DRAIN) else s_axis_tlast;

  -- ---------------------------------------------------------------------------
  -- Process     : p_frame_fsm
  -- Description : Synchronous 3-state FSM managing frame-level transitions
  --               between direct bypass, active core feeding, and end-of-frame
  --               pipeline draining.
  -- ---------------------------------------------------------------------------
  p_frame_fsm : process (aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        bypass_held <= '0';
        state         <= ST_BYPASS;
        active_width  <= (others => '0');
        active_height <= (others => '0');
        in_eol_cnt    <= (others => '0');
        out_eol_cnt   <= (others => '0');
      else
        if state = ST_BYPASS and not arm_filter and s_axis_tvalid='1' and m_axis_tready='0' then
          bypass_held <= '1';
        else
          bypass_held <= '0';
        end if;
        case state is

          -- 1. BYPASS: Pass stream directly until an eligible SOF arms the filter
          when ST_BYPASS =>
            if arm_filter then
              active_width  <= dim_w;
              active_height <= dim_h;
              in_eol_cnt    <= (others => '0');
              out_eol_cnt   <= (others => '0');
              state         <= ST_FEED;
            end if;

          -- 2. FEED: Stream active frame into core and count input/output EOLs
          when ST_FEED =>
            if (s_axis_tvalid = '1') and (core_s_tready = '1') and (s_axis_tlast = '1') then
              if (in_eol_cnt + 1) = active_height then
                state <= ST_DRAIN;
              end if;
              in_eol_cnt <= in_eol_cnt + 1;
            end if;

            if (core_m_tvalid = '1') and (m_axis_tready = '1') and (core_m_tlast = '1') then
              out_eol_cnt <= out_eol_cnt + 1;
            end if;

          -- 3. DRAIN: Stall upstream input until final filtered EOL exits core
          when ST_DRAIN =>
            if (core_m_tvalid = '1') and (m_axis_tready = '1') and (core_m_tlast = '1') then
              if (out_eol_cnt + 1) = active_height then
                state <= ST_BYPASS;
              end if;
              out_eol_cnt <= out_eol_cnt + 1;
            end if;

        end case;
      end if;
    end if;
  end process p_frame_fsm;

end architecture rtl;
