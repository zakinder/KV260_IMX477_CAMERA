-- Centered 5x5 window, closed on all four borders by edge replication.
-- One address per physical column. A word holds the previous 4*G_SPACING rows.
-- Synchronous RAM read, then one cycle later write the updated column history.
library ieee;
use ieee.std_logic_1164.all;
use work.pic2_types.all;

entity axis_window5 is
  generic (G_WIDTH : positive; G_HEIGHT : positive; G_SPACING : positive := 1);
  port (
    clk, rst_n : in std_logic;
    s_valid : in std_logic; s_ready : out std_logic;
    s_pixel : in pixel_t; s_sof, s_eol : in std_logic;
    m_valid : out std_logic; m_ready : in std_logic;
    m_window : out window_t; m_sof, m_eol : out std_logic
  );
end entity;

architecture rtl of axis_window5 is
  constant RADIUS : positive := 2*G_SPACING;
  constant DEPTH  : positive := 4*G_SPACING;
  type column_history_t is array (0 to DEPTH-1) of pixel_t;
  type line_ram_t is array (0 to G_WIDTH-1) of column_history_t;
  type taps_t is array (0 to 4, 0 to DEPTH) of pixel_t;
  signal line_ram : line_ram_t;
  -- Let the target synthesis tool choose the memory primitive for this geometry.
  signal old_rows, updated_rows : column_history_t;
  signal taps : taps_t;
  signal x_req, x_pipe : natural range 0 to G_WIDTH+RADIUS-1 := 0;
  signal y_req, y_pipe : natural range 0 to G_HEIGHT+RADIUS-1 := 0;
  signal active_pixel, issue, advance, pending, valid_q : std_logic := '0';
  signal pixel_pipe, current_pixel : pixel_t;
begin
  advance <= (not valid_q) or m_ready;
  active_pixel <= '1' when x_req < G_WIDTH and y_req < G_HEIGHT else '0';
  s_ready <= rst_n and advance and active_pixel;
  issue <= (not active_pixel) or s_valid;
  current_pixel <= pixel_pipe when y_pipe < G_HEIGHT else old_rows(0);
  updated_rows(0) <= current_pixel;
  gen_prior : for k in 1 to DEPTH-1 generate
    updated_rows(k) <= current_pixel when y_pipe=0 else old_rows(k-1);
  end generate;

  -- No RAM reset. The first physical row seeds every vertical history tap.
  memory : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n='1' and advance='1' then
        if issue='1' and x_req < G_WIDTH then
          old_rows <= line_ram(x_req);
        end if;
        if pending='1' and x_pipe < G_WIDTH then
          line_ram(x_pipe) <= updated_rows;
        end if;
      end if;
    end if;
  end process;

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
            if x_pipe >= G_WIDTH then
              col_sample := taps(r,0); -- virtual right column, repeat last sample
            elsif r=4 or y_pipe=0 then
              col_sample := current_pixel;
            else
              col_sample := old_rows((4-r)*G_SPACING-1);
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
            if x_pipe=G_WIDTH+RADIUS-1 then m_eol <= '1'; end if;
          end if;
        end if;
        pending <= issue;
        if issue='1' then
          x_pipe <= x_req; y_pipe <= y_req; pixel_pipe <= s_pixel;
          -- synthesis translate_off
          if active_pixel='1' then
            assert (s_sof='1') = (x_req=0 and y_req=0) report "Unexpected input SOF" severity failure;
            assert (s_eol='1') = (x_req=G_WIDTH-1) report "Unexpected input EOL" severity failure;
          end if;
          -- synthesis translate_on
          if x_req=G_WIDTH+RADIUS-1 then
            x_req <= 0;
            if y_req=G_HEIGHT+RADIUS-1 then y_req <= 0;
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
