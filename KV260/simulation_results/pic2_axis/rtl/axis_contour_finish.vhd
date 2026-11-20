-- Smooth the small staircase left by integer tone levels and contour decisions.
-- The bounded 5x5 binomial average has unit gain and a constant divisor of 256.
library ieee;
use ieee.std_logic_1164.all;
use work.pic2_types.all;

entity axis_contour_finish is
  generic (G_WIDTH : positive; G_HEIGHT : positive);
  port (
    clk, rst_n : in std_logic;
    s_valid : in std_logic; s_ready : out std_logic;
    s_pixel : in pixel_t; s_sof, s_eol : in std_logic;
    m_valid : out std_logic; m_ready : in std_logic;
    m_pixel : out pixel_t; m_sof, m_eol : out std_logic
  );
end entity;

architecture rtl of axis_contour_finish is
  type weights_t is array(0 to 4) of positive;
  constant WEIGHT : weights_t := (1,4,6,4,1);
  type row_sum_t is array(0 to 2) of natural range 0 to 4080;
  type rows_t is array(0 to 4) of row_sum_t;
  signal rows : rows_t;
  signal win : window_t;
  signal wvalid, wsof, weol, advance : std_logic;
  signal valid, sof, eol : std_logic_vector(0 to 1) := (others=>'0');
begin
  window_source : entity work.axis_window5
    generic map(G_WIDTH,G_HEIGHT,1)
    port map(clk,rst_n,s_valid,s_ready,s_pixel,s_sof,s_eol,wvalid,advance,win,wsof,weol);
  advance <= (not valid(1)) or m_ready;
  m_valid <= valid(1); m_sof <= sof(1); m_eol <= eol(1);

  average : process(clk)
    variable center, sample, result : rgb_t;
    variable partial : row_sum_t;
    variable total : natural range 0 to 65280;
  begin
    if rising_edge(clk) then
      if rst_n='0' then
        valid <= (others=>'0'); sof <= (others=>'0'); eol <= (others=>'0');
      elsif advance='1' then
        valid <= wvalid & valid(0); sof <= wsof & sof(0); eol <= weol & eol(0);
        if wvalid='1' then
          center := unpack(win(12));
          for r in 0 to 4 loop
            partial := (others=>0);
            for c in 0 to 4 loop
              sample := unpack(win(5*r+c));
              -- Crossing a strong boundary contributes half as much color change.
              if distance(center,sample)>28 then
                for ch in 0 to 2 loop sample(ch) := (sample(ch)+center(ch)+1)/2; end loop;
              end if;
              for ch in 0 to 2 loop partial(ch) := partial(ch)+WEIGHT(c)*sample(ch); end loop;
            end loop;
            rows(r) <= partial;
          end loop;
        end if;
        if valid(0)='1' then
          for ch in 0 to 2 loop
            total := 0;
            for r in 0 to 4 loop total := total+WEIGHT(r)*rows(r)(ch); end loop;
            result(ch) := (total+128)/256;
          end loop;
          m_pixel <= pack(result);
        end if;
      end if;
    end if;
  end process;
end architecture;
