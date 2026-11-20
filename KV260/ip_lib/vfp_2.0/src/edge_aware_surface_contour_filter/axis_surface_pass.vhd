-- Range-based Kuwahara variant. Four overlapping 3x3 regions compete to
-- represent the center. Similar-scoring regions share the result. No color table.
library ieee;
use ieee.std_logic_1164.all;
use work.pic2_types.all;

entity axis_surface_pass is
  generic (
    G_WIDTH : positive; G_HEIGHT : positive;
    G_SPACING : positive; G_TOLERANCE : natural
  );
  port (
    clk, rst_n : in std_logic;
    s_valid : in std_logic; s_ready : out std_logic;
    s_pixel : in pixel_t; s_sof, s_eol : in std_logic;
    m_valid : out std_logic; m_ready : in std_logic;
    m_pixel : out pixel_t; m_sof, m_eol : out std_logic;
    active_width : in positive range 1 to G_WIDTH := G_WIDTH;
    active_height : in positive range 1 to G_HEIGHT := G_HEIGHT
  );
end entity;

architecture rtl of axis_surface_pass is
  type sum3_t is array (0 to 2) of natural range 0 to 765;
  type strip_t is record
    total : sum3_t;
    lo, hi : byte_t;
  end record;
  type strips_t is array (0 to 9) of strip_t;
  type candidate_t is record
    color : rgb_t;
    score : natural range 0 to 1275;
  end record;
  type candidates_t is array (0 to 3) of candidate_t;

  function strip(a, b, c : rgb_t; ya, yb, yc : byte_t) return strip_t is
    variable result : strip_t;
  begin
    for ch in 0 to 2 loop result.total(ch) := a(ch)+b(ch)+c(ch); end loop;
    result.lo := smallest(ya,smallest(yb,yc));
    result.hi := largest(ya,largest(yb,yc));
    return result;
  end;
  type totals_t is array (0 to 3,0 to 2) of natural range 0 to 2299;
  type spans_t is array (0 to 3) of byte_t;
  type colors_t is array (0 to 3) of rgb_t;
  signal totals : totals_t;
  signal spans, mean_spans, score_spans, distances : spans_t;
  signal means, score_colors : colors_t;
  signal sum_center, mean_center, score_center, blend_center, blend_mean : rgb_t;
  signal win : window_t;
  signal wvalid, wsof, weol, advance : std_logic;
  signal valid, sof, eol : std_logic_vector(0 to 7) := (others=>'0');
  signal strips : strips_t;
  signal regions2, regions3 : candidates_t;
  signal winner3 : candidate_t;
  signal center1, center2, center3 : rgb_t;
begin
  window_source : entity work.axis_window5
    generic map (G_WIDTH, G_HEIGHT, G_SPACING)
    port map (clk,rst_n,s_valid,s_ready,s_pixel,s_sof,s_eol,wvalid,advance,win,wsof,weol,active_width,active_height);
  advance <= (not valid(7)) or m_ready;
  m_valid <= valid(7); m_sof <= sof(7); m_eol <= eol(7);

  compute : process(clk)
    type color_row_t is array (0 to 4) of rgb_t;
    type light_row_t is array (0 to 4) of byte_t;
    variable colors : color_row_t;
    variable light : light_row_t;
    variable start : natural range 0 to 5;
    variable winner : candidate_t;
    type sum4_t is array (0 to 2) of natural range 0 to 1020;
    variable region_sum : sum4_t;
    variable selected, mean_color, result : rgb_t;
  begin
    if rising_edge(clk) then
      if rst_n='0' then
        valid <= (others=>'0'); sof <= (others=>'0'); eol <= (others=>'0');
      elsif advance='1' then
        valid <= wvalid & valid(0 to 6); sof <= wsof & sof(0 to 6); eol <= weol & eol(0 to 6);
        if wvalid='1' then
          center1 <= unpack(win(12));
          for r in 0 to 4 loop
            for c in 0 to 4 loop
              colors(c) := unpack(win(5*r+c)); light(c) := luma(colors(c));
            end loop;
            strips(2*r)   <= strip(colors(0),colors(1),colors(2),light(0),light(1),light(2));
            strips(2*r+1) <= strip(colors(2),colors(3),colors(4),light(2),light(3),light(4));
          end loop;
        end if;
        if valid(0)='1' then
          sum_center <= center1;
          for q in 0 to 3 loop
            start := 4*(q/2) + (q mod 2);
            for ch in 0 to 2 loop
              totals(q,ch) <= strips(start).total(ch)+strips(start+2).total(ch)+strips(start+4).total(ch)+4;
            end loop;
            spans(q) <= largest(strips(start).hi,largest(strips(start+2).hi,strips(start+4).hi))
                       -smallest(strips(start).lo,smallest(strips(start+2).lo,strips(start+4).lo));
          end loop;
        end if;
        if valid(1)='1' then
          mean_center <= sum_center; mean_spans <= spans;
          for q in 0 to 3 loop
            for ch in 0 to 2 loop
              -- Exact floor(n/9) over the bounded numerator range 0..2299.
              means(q)(ch) <= (totals(q,ch)*3641)/32768;
            end loop;
          end loop;
        end if;
        if valid(2)='1' then
          score_center <= mean_center; score_colors <= means; score_spans <= mean_spans;
          for q in 0 to 3 loop distances(q) <= distance(means(q),mean_center); end loop;
        end if;
        if valid(3)='1' then
          center2 <= score_center;
          for q in 0 to 3 loop
            regions2(q).color <= score_colors(q);
            regions2(q).score <= 2*score_spans(q)+3*distances(q);
          end loop;
        end if;
        if valid(4)='1' then
          center3 <= center2; regions3 <= regions2;
          winner := regions2(0);
          for q in 1 to 3 loop
            if regions2(q).score < winner.score then winner := regions2(q); end if;
          end loop;
          winner3 <= winner;
        end if;
        if valid(5)='1' then
          region_sum := (others=>0);
          for q in 0 to 3 loop
            selected := winner3.color;
            if regions3(q).score <= winner3.score+G_TOLERANCE then selected := regions3(q).color; end if;
            for ch in 0 to 2 loop region_sum(ch) := region_sum(ch)+selected(ch); end loop;
          end loop;
          for ch in 0 to 2 loop mean_color(ch) := (region_sum(ch)+2)/4; end loop;
          blend_mean <= mean_color; blend_center <= center3;
        end if;
        if valid(6)='1' then
          -- Retain more of an isolated, high-contrast center (e.g. an eyelid).
          if distance(blend_mean,blend_center)>24 then
            for ch in 0 to 2 loop result(ch) := (blend_mean(ch)+blend_center(ch)+1)/2; end loop;
          else
            for ch in 0 to 2 loop result(ch) := (7*blend_mean(ch)+blend_center(ch)+4)/8; end loop;
          end if;
          m_pixel <= pack(result);
        end if;
      end if;
    end if;
  end process;
end architecture;
