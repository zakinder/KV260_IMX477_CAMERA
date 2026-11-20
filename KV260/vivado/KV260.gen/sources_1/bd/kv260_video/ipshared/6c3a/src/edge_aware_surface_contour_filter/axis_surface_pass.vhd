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
  function candidate(a, b, c : strip_t; center : rgb_t) return candidate_t is
    variable result : candidate_t;
    variable span : byte_t;
  begin
    for ch in 0 to 2 loop
      result.color(ch) := (a.total(ch)+b.total(ch)+c.total(ch)+4)/9;
    end loop;
    span := largest(a.hi,largest(b.hi,c.hi)) - smallest(a.lo,smallest(b.lo,c.lo));
    result.score := 2*span + 3*distance(result.color,center);
    return result;
  end;

  signal win : window_t;
  signal wvalid, wsof, weol, advance : std_logic;
  signal valid, sof, eol : std_logic_vector(0 to 3) := (others=>'0');
  signal strips : strips_t;
  signal regions2, regions3 : candidates_t;
  signal winner3 : candidate_t;
  signal center1, center2, center3 : rgb_t;
begin
  window_source : entity work.axis_window5
    generic map (G_WIDTH, G_HEIGHT, G_SPACING)
    port map (clk,rst_n,s_valid,s_ready,s_pixel,s_sof,s_eol,wvalid,advance,win,wsof,weol,active_width,active_height);
  advance <= (not valid(3)) or m_ready;
  m_valid <= valid(3); m_sof <= sof(3); m_eol <= eol(3);

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
        valid <= wvalid & valid(0 to 2); sof <= wsof & sof(0 to 2); eol <= weol & eol(0 to 2);
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
          center2 <= center1;
          for q in 0 to 3 loop
            start := 4*(q/2) + (q mod 2);
            regions2(q) <= candidate(strips(start),strips(start+2),strips(start+4),center1);
          end loop;
        end if;
        if valid(1)='1' then
          center3 <= center2; regions3 <= regions2;
          winner := regions2(0);
          for q in 1 to 3 loop
            if regions2(q).score < winner.score then winner := regions2(q); end if;
          end loop;
          winner3 <= winner;
        end if;
        if valid(2)='1' then
          region_sum := (others=>0);
          for q in 0 to 3 loop
            selected := winner3.color;
            if regions3(q).score <= winner3.score+G_TOLERANCE then selected := regions3(q).color; end if;
            for ch in 0 to 2 loop region_sum(ch) := region_sum(ch)+selected(ch); end loop;
          end loop;
          for ch in 0 to 2 loop mean_color(ch) := (region_sum(ch)+2)/4; end loop;
          -- Retain more of an isolated, high-contrast center (e.g. an eyelid).
          if distance(mean_color,center3)>24 then
            for ch in 0 to 2 loop result(ch) := (mean_color(ch)+center3(ch)+1)/2; end loop;
          else
            for ch in 0 to 2 loop result(ch) := (7*mean_color(ch)+center3(ch)+4)/8; end loop;
          end if;
          m_pixel <= pack(result);
        end if;
      end if;
    end if;
  end process;
end architecture;
