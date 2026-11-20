-- =============================================================================
-- Module      : axis_window5
-- Description : Parameterized 5x5 sliding-window generator for AXI4-Stream
--               RGB888 video. Uses banked 72-bit UltraRAM column history (4*s
--               rows deep) and 5-tap horizontal shift registers to emit 25 taps
--               spaced s pixels horizontally and s rows vertically, with full
--               border replication so output frame size matches input 1:1.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axis_window5 is
  generic (
    G_WIDTH   : positive := 2048; -- Maximum supported horizontal frame width
    G_HEIGHT  : positive := 1152; -- Maximum supported vertical frame height
    G_SPACING : positive := 1     -- Tap spacing s (1, 3, or 6)
  );
  port (
    -- Clock, Synchronous Active-Low Reset, and Active Frame Dimensions
    aclk          : in  std_logic;                      -- AXI4-Stream system clock
    aresetn       : in  std_logic;                      -- Synchronous active-low reset
    active_width  : in  std_logic_vector(15 downto 0);  -- Active frame width in pixels
    active_height : in  std_logic_vector(15 downto 0);  -- Active frame height in lines

    -- AXI4-Stream Pixel Input Interface
    s_axis_tdata  : in  std_logic_vector(23 downto 0);  -- Input RGB888 pixel
    s_axis_tvalid : in  std_logic;                      -- Input pixel valid
    s_axis_tready : out std_logic;                      -- Input ready backpressure
    s_axis_tuser  : in  std_logic;                      -- Start-of-Frame (SOF) marker
    s_axis_tlast  : in  std_logic;                      -- End-of-Line (EOL) marker

    -- 25-Tap Window Output Interface (Row-Major 0..24, Center = Tap 12)
    m_window_data : out std_logic_vector(600 - 1 downto 0); -- 25 x 24-bit RGB888 taps
    m_valid       : out std_logic;                          -- Window valid
    m_ready       : in  std_logic;                          -- Downstream pipeline ready
    m_sof         : out std_logic;                          -- Output SOF at center (0,0)
    m_eol         : out std_logic                           -- Output EOL at last column
  );
end entity axis_window5;

architecture rtl of axis_window5 is

  -- ---------------------------------------------------------------------------
  -- UltraRAM Column History Constants & Bank Geometry (72-Bit Wide Banks)
  -- ---------------------------------------------------------------------------
  constant C_HIST_ROWS  : positive := 4 * G_SPACING;           -- 4s stored RGB888 rows
  constant C_HIST_BITS  : positive := C_HIST_ROWS * 24;        -- Total history bits/col
  constant C_BANK_WIDTH : positive := 72;                      -- UltraRAM native bank width
  constant C_NUM_BANKS  : positive := (C_HIST_BITS + 71) / 72; -- Number of 72-bit banks
  constant C_PAD_BITS   : positive := C_NUM_BANKS * C_BANK_WIDTH;

  type bank_ram_t is array (0 to G_WIDTH - 1) of std_logic_vector(C_BANK_WIDTH - 1 downto 0);
  type bank_bus_t is array (0 to C_NUM_BANKS - 1) of std_logic_vector(C_BANK_WIDTH - 1 downto 0);

  -- 5x5 RGB888 Tap Grid: 5 vertical rows (0..4) x 5 horizontal columns (0..4)
  type col5_rgb_t is array (0 to 4) of std_logic_vector(23 downto 0);
  type win5_rgb_t is array (0 to 4) of col5_rgb_t;

  -- Column History RAM Read/Write Buses
  signal x_req          : integer range 0 to G_WIDTH - 1              := 0;
  signal x_pipe         : integer range 0 to G_WIDTH + 2 * G_SPACING  := 0;
  signal y_pipe         : integer range 0 to G_HEIGHT + 2 * G_SPACING := 0;
  signal ram_rd_banks   : bank_bus_t := (others => (others => '0'));
  signal ram_wr_banks   : bank_bus_t := (others => (others => '0'));
  signal ram_rd_word    : std_logic_vector(C_PAD_BITS - 1 downto 0);
  signal ram_wr_word    : std_logic_vector(C_PAD_BITS - 1 downto 0)   := (others => '0');
  signal ram_wr_en      : std_logic := '0';

  -- Raster State & Virtual Border Padding Signals
  signal x_in           : integer range 0 to G_WIDTH + 2 * G_SPACING  := 0;
  signal y_in           : integer range 0 to G_HEIGHT + 2 * G_SPACING := 0;
  signal v_pad_active   : std_logic := '0'; -- Asserted during bottom 2s virtual rows
  signal h_pad_active   : std_logic := '0'; -- Asserted during right 2s virtual cols
  signal pending_valid  : std_logic := '0';
  signal pending_pixel  : std_logic_vector(23 downto 0) := (others => '0');
  signal last_col_pixel : std_logic_vector(23 downto 0) := (others => '0');

  -- 5x5 Window Shift Register & Output Hold Registers
  signal h_taps         : win5_rgb_t := (others => (others => (others => '0')));
  signal out_valid_reg  : std_logic  := '0';
  signal out_sof_reg    : std_logic  := '0';
  signal out_eol_reg    : std_logic  := '0';

  -- Active Frame Bounds & Handshake Controls
  signal w_act          : integer range 0 to G_WIDTH;
  signal h_act          : integer range 0 to G_HEIGHT;
  signal pipe_advance   : std_logic;
  signal step_en        : std_logic;

begin

  w_act        <= to_integer(unsigned(active_width));
  h_act        <= to_integer(unsigned(active_height));

  -- Downstream advance condition: output register is empty or accepted
  pipe_advance <= (not out_valid_reg) or m_ready;

  -- Accept new input pixels only when not in virtual padding and pipeline can advance
  s_axis_tready <= '1' when (v_pad_active = '0' and h_pad_active = '0' and
                             (pending_valid = '0' or pipe_advance = '1')) else '0';

  -- Step occurs on an active input transfer or a virtual border padding cycle
  step_en      <= '1' when ((s_axis_tvalid = '1' and v_pad_active = '0' and h_pad_active = '0' and
                             (pending_valid = '0' or pipe_advance = '1')) or
                            ((v_pad_active = '1' or h_pad_active = '1') and pipe_advance = '1')) else '0';

  -- Physical column address clamps virtual right-padding columns to (w_act - 1)
  x_req        <= x_in when (x_in < w_act) else (w_act - 1);

  -- ---------------------------------------------------------------------------
  -- Generate    : banks
  -- Description : Splits wide column history words into parallel banks up to
  --               72 bits wide with ram_style = "ultra" for UltraRAM inference.
  -- ---------------------------------------------------------------------------
  banks : for b in 0 to C_NUM_BANKS - 1 generate
    signal mem_bank         : bank_ram_t := (others => (others => '0'));
    attribute ram_style     : string;
    attribute ram_style of mem_bank : signal is "ultra";
  begin
    ram_wr_banks(b) <= ram_wr_word((b + 1) * C_BANK_WIDTH - 1 downto b * C_BANK_WIDTH);
    ram_rd_word((b + 1) * C_BANK_WIDTH - 1 downto b * C_BANK_WIDTH) <= ram_rd_banks(b);

    p_bank_ram : process (aclk)
    begin
      if rising_edge(aclk) then
        if ram_wr_en = '1' then
          mem_bank(x_pipe) <= ram_wr_banks(b);
        end if;
        if step_en = '1' then
          ram_rd_banks(b) <= mem_bank(x_req);
        end if;
      end if;
    end process p_bank_ram;
  end generate banks;

  -- ---------------------------------------------------------------------------
  -- Process     : raster
  -- Description : Coordinates pixel intake, virtual right/bottom border
  --               replication, 5-tap horizontal shift register updates, and
  --               center-aligned valid/SOF/EOL generation.
  -- ---------------------------------------------------------------------------
  raster : process (aclk)
    variable cur_px    : std_logic_vector(23 downto 0);
    variable col_5rows : col5_rgb_t;
    variable next_hist : std_logic_vector(C_HIST_BITS - 1 downto 0);
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        x_in           <= 0;
        y_in           <= 0;
        x_pipe         <= 0;
        y_pipe         <= 0;
        v_pad_active   <= '0';
        h_pad_active   <= '0';
        pending_valid  <= '0';
        pending_pixel  <= (others => '0');
        last_col_pixel <= (others => '0');
        out_valid_reg  <= '0';
        out_sof_reg    <= '0';
        out_eol_reg    <= '0';
        ram_wr_en      <= '0';
        ram_wr_word    <= (others => '0');

      else
        ram_wr_en <= '0';

        -- Clear output valid once accepted by downstream stage if no new step
        if pipe_advance = '1' then
          out_valid_reg <= '0';
          out_sof_reg   <= '0';
          out_eol_reg   <= '0';
        end if;

        -- 1. Advance pending RAM read into 5x5 horizontal shift taps
        if pending_valid = '1' and pipe_advance = '1' then
          cur_px := pending_pixel;

          -- Extract 5 vertical row samples spaced by G_SPACING rows:
          -- Row 4 (newest) = cur_px; Rows 3..0 = history offsets s, 2s, 3s, 4s
          col_5rows(4) := cur_px;
          if y_pipe = 0 then
            -- First active row seeds all 4*s vertical history rows with cur_px
            for r in 0 to 3 loop
              col_5rows(r) := cur_px;
            end loop;
            for h in 0 to C_HIST_ROWS - 1 loop
              next_hist((h + 1) * 24 - 1 downto h * 24) := cur_px;
            end loop;
          else
            for r in 0 to 3 loop
              col_5rows(r) := ram_rd_word(((4 - r) * G_SPACING) * 24 - 1 downto
                                          ((4 - r) *