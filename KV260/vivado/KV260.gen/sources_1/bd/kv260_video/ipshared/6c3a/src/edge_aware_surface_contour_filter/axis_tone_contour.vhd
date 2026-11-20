-- The tone curve returns one brightness value. Pixel hue comes exclusively
-- from the camera RGB. There is no RGB palette, color classification or tint.
library ieee;
use ieee.std_logic_1164.all;
use work.pic2_types.all;

entity axis_tone_contour is
  generic (
    G_WIDTH : positive; G_HEIGHT : positive; G_SPACING : positive;
    G_CHROMA_Q8 : natural range 256 to 384 := 384
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

architecture rtl of axis_tone_contour is
  type anchors_t is array (0 to 16) of natural range 0 to 256;
  constant ANCHORS : anchors_t := (0,56,81,104,122,137,149,158,168,180,191,201,212,223,234,245,256);
  function tone(y : byte_t) return byte_t is
    variable i : natural range 0 to 15 := y/16;
  begin
    return smallest(255,ANCHORS(i)+((y mod 16)*(ANCHORS(i+1)-ANCHORS(i))+8)/16);
  end;
  signal win : window_t;
  signal wvalid, wsof, weol, advance : std_logic;
  signal valid, sof, eol : std_logic_vector(0 to 3) := (others=>'0');
  signal gradient1 : natural range 0 to 2040;
  signal dark_side1, dark_ridge1, light_ridge1 : integer range -255 to 255;
  signal center1, center2, relative3 : rgb_t;
  signal y1, target2, target3 : byte_t;
  signal gain2 : natural range 256 to 384;
  signal minimum2 : byte_t;
begin
  window_source : entity work.axis_window5
    generic map (G_WIDTH,G_HEIGHT,G_SPACING)
    port map (clk,rst_n,s_valid,s_ready,s_pixel,s_sof,s_eol,wvalid,advance,win,wsof,weol,active_width,active_height);
  advance <= (not valid(3)) or m_ready;
  m_valid <= valid(3); m_sof <= sof(3); m_eol <= eol(3);

  render : process(clk)
    type lights_t is array (0 to 24) of byte_t;
    variable y : lights_t;
    variable gx, gy : integer range -1020 to 1020;
    variable luminance, soft_level, ink, ridge_ink, highlight, mn, mx, offset : integer;
    variable result : rgb_t;
  begin
    if rising_edge(clk) then
      if rst_n='0' then
        valid <= (others=>'0'); sof <= (others=>'0'); eol <= (others=>'0');
      elsif advance='1' then
        valid <= wvalid & valid(0 to 2); sof <= wsof & sof(0 to 2); eol <= weol & eol(0 to 2);
        if wvalid='1' then
          for i in 0 to 24 loop y(i) := luma(unpack(win(i))); end loop;
          center1 <= unpack(win(12)); y1 <= y(12);
          gx := y(8)+2*y(13)+y(18) - y(6)-2*y(11)-y(16);
          gy := y(16)+2*y(17)+y(18) - y(6)-2*y(7)-y(8);
          gradient1 <= magnitude(gx)+magnitude(gy);
          -- A narrow dark stroke has brighter pixels on BOTH sides, even when
          -- its center has zero Sobel gradient. Check four line orientations.
          dark_ridge1 <= largest(largest(smallest(y(10),y(14)),smallest(y(2),y(22))),
                                 largest(smallest(y(0),y(24)),smallest(y(4),y(20)))) - y(12);
          light_ridge1 <= y(12) - smallest(smallest(largest(y(10),y(14)),largest(y(2),y(22))),
                                          smallest(largest(y(0),y(24)),largest(y(4),y(20))));
          dark_side1 <= (y(7)+y(11)+y(13)+y(17)+y(2)+y(10)+y(14)+y(22)+4)/8 - y(12);
        end if;
        if valid(0)='1' then
          luminance := tone(y1);
          -- Gentle luminance stepping keeps broad ramps from forming hard bands.
          soft_level := (3*luminance+smallest(255,8*((luminance+4)/8))+2)/4;
          ink := 0;
          if dark_side1>1 then
            ink := smallest(12,largest(gradient1/4-5,0)/4 + dark_side1/4);
          end if;
          ridge_ink := smallest(42,3*largest(dark_ridge1-2,0)/2);
          highlight := smallest(14,3*largest(light_ridge1-3,0)/4);
          target2 <= clamp(soft_level-largest(ink,ridge_ink)+highlight,0,255);
          center2 <= center1;
          mn := smallest(center1(0),smallest(center1(1),center1(2)));
          mx := largest(center1(0),largest(center1(1),center1(2)));
          minimum2 <= mn;
          -- One gain for all channels. Taper the gain near the gamut boundary.
          gain2 <= 256+smallest(G_CHROMA_Q8-256,255-(mx-mn));
        end if;
        if valid(1)='1' then
          for ch in 0 to 2 loop relative3(ch) <= ((center2(ch)-minimum2)*gain2+128)/256; end loop;
          target3 <= target2;
        end if;
        if valid(2)='1' then
          mx := largest(relative3(0),largest(relative3(1),relative3(2)));
          offset := clamp(target3-luma(relative3),0,255-mx);
          for ch in 0 to 2 loop result(ch) := relative3(ch)+offset; end loop;
          m_pixel <= pack(result);
        end if;
      end if;
    end if;
  end process;
end architecture;
