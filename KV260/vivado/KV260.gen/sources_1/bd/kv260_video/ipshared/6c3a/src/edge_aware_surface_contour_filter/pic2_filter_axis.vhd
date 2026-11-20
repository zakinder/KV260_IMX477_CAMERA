-- AXI4-Stream Video, one RGB888 pixel per transfer, SOF=TUSER, EOL=TLAST.
-- Synchronous active-low reset. First input beat after reset must be SOF.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pic2_types.all;

entity pic2_filter_axis is
  generic (
    G_WIDTH         : positive := 2048;
    G_HEIGHT        : positive := 1152;
    G_MEDIUM_STEP   : positive := 3;
    G_COARSE_STEP   : positive := 6;
    G_CONTOUR_STEP  : positive := 6;
    G_CHROMA_Q8     : natural range 256 to 384 := 384
  );
  port (
    aclk, aresetn : in std_logic;
    s_axis_tdata  : in std_logic_vector(23 downto 0);
    s_axis_tvalid : in std_logic; s_axis_tready : out std_logic;
    s_axis_tuser, s_axis_tlast : in std_logic;
    m_axis_tdata  : out std_logic_vector(23 downto 0);
    m_axis_tvalid : out std_logic; m_axis_tready : in std_logic;
    m_axis_tuser, m_axis_tlast : out std_logic;
    active_width : in positive range 1 to G_WIDTH := G_WIDTH;
    active_height : in positive range 1 to G_HEIGHT := G_HEIGHT
  );
end entity;

architecture rtl of pic2_filter_axis is
  type pixels_t is array (0 to 5) of pixel_t;
  type settings_t is array (0 to 2) of natural;
  constant SPACING : settings_t := (1,G_MEDIUM_STEP,G_COARSE_STEP);
  constant TOLERANCE : settings_t := (20,14,10);
  signal p : pixels_t;
  signal v, r, sof, eol : std_logic_vector(0 to 5);
begin
  p(0) <= to_integer(unsigned(s_axis_tdata)) when s_axis_tvalid='1' else 0;
  v(0) <= s_axis_tvalid; s_axis_tready <= r(0);
  sof(0) <= s_axis_tuser; eol(0) <= s_axis_tlast;
  surfaces : for i in 0 to 2 generate
    stage : entity work.axis_surface_pass
      generic map (G_WIDTH,G_HEIGHT,SPACING(i),TOLERANCE(i))
      port map (aclk,aresetn,v(i),r(i),p(i),sof(i),eol(i),
                v(i+1),r(i+1),p(i+1),sof(i+1),eol(i+1),active_width,active_height);
  end generate;
  finish_pixel : entity work.axis_tone_contour
    generic map (G_WIDTH,G_HEIGHT,G_CONTOUR_STEP,G_CHROMA_Q8)
    port map (aclk,aresetn,v(3),r(3),p(3),sof(3),eol(3),v(4),r(4),p(4),sof(4),eol(4),active_width,active_height);
  antialias : entity work.axis_contour_finish
    generic map (G_WIDTH,G_HEIGHT)
    port map (aclk,aresetn,v(4),r(4),p(4),sof(4),eol(4),v(5),r(5),p(5),sof(5),eol(5),active_width,active_height);
  r(5) <= m_axis_tready; m_axis_tvalid <= v(5);
  m_axis_tuser <= sof(5); m_axis_tlast <= eol(5);
  m_axis_tdata <= std_logic_vector(to_unsigned(p(5),24));
end architecture;
