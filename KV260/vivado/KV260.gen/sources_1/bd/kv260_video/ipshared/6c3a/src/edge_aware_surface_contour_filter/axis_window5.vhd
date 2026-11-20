-- Centered 5x5 window, closed on all four borders by edge replication.
-- One address per physical column. A word holds the previous 4*G_SPACING rows.
-- Synchronous RAM read, then one cycle later write the updated column history.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pic2_types.all;

entity axis_window5 is
  generic (G_WIDTH : positive; G_HEIGHT : positive; G_SPACING : positive := 1);
  port (
    clk, rst_n : in std_logic;
    s_valid : in std_logic; s_ready : out std_logic;
    s_pixel : in pixel_t; s_sof, s_eol : in std_logic;
    m_valid : out std_logic; m_ready : in std_logic;
    m_window : out window_t; m_sof, m_eol : out std_logic;
    active_width : in positive range 1 to G_WIDTH := G_WIDTH;
    active_height : in positive range 1 to G_HEIGHT := G_HEIGHT
  );
end entity;

architecture rtl of axis_window5 is
  constant RADIUS : positive := 2*G_SPACING;
  constant DEPTH  : positive := 4*G_SPACING;
  constant PIXEL_BITS : positive := 24;
  constant BANK_BITS : positive := 72; -- one UltraRAM port
  constant HISTORY_BITS : positive := DEPTH * PIXEL_BITS;
  type taps_t is array (0 to 4, 0 to DEPTH) of pixel_t;
  signal read_history, write_history : std_logic_vector(HISTORY_BITS-1 downto 0);
  signal read_enable, write_enable : std_logic;
  signal taps : taps_t;
  signal x_req, x_pipe : natural range 0 to G_WIDTH+RADIUS-1 := 0;
  signal y_req, y_pipe : natural range 0 to G_HEIGHT+RADIUS-1 := 0;
  signal active_pixel, issue, advance, pending, valid_q : std_logic := '0';
  signal pixel_pipe : pixel_t;
  signal current_bits : std_logic_vector(PIXEL_BITS-1 downto 0);
begin
  advance <= (not valid_q) or m_ready;
  active_pixel <= '1' when x_req < active_width and y_req < active_height else '0';
  s_ready <= rst_n and advance and active_pixel;
  issue <= (not active_pixel) or s_valid;
  current_bits <= std_logic_vector(to_unsigned(pixel_pipe, PIXEL_BITS)) when y_pipe < active_height
                  else read_history(PIXEL_BITS-1 downto 0);
  write_history(PIXEL_BITS-1 downto 0) <= current_bits;
  gen_prior : for k in 1 to DEPTH-1 generate
    write_history((k+1)*PIXEL_BITS-1 downto k*PIXEL_BITS) <= current_bits when y_pipe=0
      else read_history(k*PIXEL_BITS-1 downto (k-1)*PIXEL_BITS);
  end generate;

  read_enable <= rst_n and advance and issue when x_req < active_width else '0';
  write_enable <= rst_n and advance and pending when x_pipe < active_width else '0';

  -- A bank is an array of packed vector words. A synchronous read issues
  -- one cycle before writeback. The first row seeds the history without a RAM reset.
  banks : for b in 0 to (HISTORY_BITS-1)/BANK_BITS generate
    constant LO : natural := b*BANK_BITS;
    constant HI : natural := smallest(LO+BANK_BITS,HISTORY_BITS)-1;
    subtype word_t is std_logic_vector(HI-LO downto 0);
    type ram_t is array (0 to G_WIDTH-1) of word_t;
    signal ram : ram_t;
    signal dout : word_t;
    attribute ram_style : string;
    attribute ram_style of ram : signal is "ultra";
  begin
    process(clk)
    begin
      if rising_edge(clk) then
        if write_enable='1' then
          ram(x_pipe) <= write_history(HI downto LO);
        end if;
        if read_enable='1' then
          dout <= ram(x_req);
        end if;
      end if;
    end process;
    read_history(HI downto LO) <= dout;
  end generate;

  raster : process(clk)
    variable col_sample : pixel_t;
  begin
    if rising_edge(clk) then
      if rst_n='0' then
        x_req <= 0; y_req <= 0; pending <= '0'; valid_q <= '0';
        m_sof <= '0'; m_eol <= '0';
      elsif advance='1' then
        valid_q <= '0'; m_sof <= '0'; m_eol <= '0';
        if pending='1' then
          for r in 0 to 4 loop
            if x_pipe >= active_width then
              col_sample := taps(r,0); -- virtual right column, repeat last sample
            elsif r=4 or y_pipe=0 then
              col_sample := to_integer(unsigned(current_bits));
            else
              col_sample := to_integer(unsigned(read_history((4-r)*G_SPACING*PIXEL_BITS-1 downto
                                                            ((4-r)*G_SPACING-1)*PIXEL_BITS)));
            end if;
            taps(r,0) <= col_sample;
            for k in 1 to DEPTH loop
              if x_pipe=0 then taps(r,k) <= col_sample;
              else taps(r,k) <= taps(r,k-1);
              end if;
            end loop;
          end loop;
          if x_pipe>=RADIUS and y_pipe>=RADIUS then
            valid_q <= '1';
            if x_pipe=RADIUS and y_pipe=RADIUS then m_sof <= '1'; end if;
            if x_pipe=active_width+RADIUS-1 then m_eol <= '1'; end if;
          end if;
        end if;
        pending <= issue;
        if issue='1' then
          x_pipe <= x_req; y_pipe <= y_req; pixel_pipe <= s_pixel;
          -- synthesis translate_off
          if active_pixel='1' then
            assert (s_sof='1') = (x_req=0 and y_req=0) report "Unexpected input SOF" severity failure;
            assert (s_eol='1') = (x_req=active_width-1) report "Unexpected input EOL" severity failure;
          end if;
          -- synthesis translate_on
          if x_req=active_width+RADIUS-1 then
            x_req <= 0;
            if y_req=active_height+RADIUS-1 then y_req <= 0;
            else y_req <= y_req+1;
            end if;
          else
            x_req <= x_req+1;
          end if;
        end if;
      end if;
    end if;
  end process;

  m_valid <= valid_q;
  gen_row : for r in 0 to 4 generate
    gen_column : for c in 0 to 4 generate
      m_window(5*r+c) <= taps(r,(4-c)*G_SPACING);
    end generate;
  end generate;
end architecture;
