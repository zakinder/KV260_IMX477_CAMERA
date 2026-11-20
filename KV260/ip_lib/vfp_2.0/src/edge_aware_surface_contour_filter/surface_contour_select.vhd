-- AXI video switch before the existing VFP row buffer. Input can be stalled
-- through demosaic while the centered windows pad or drain. Bypass is RGB10.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity surface_contour_select is
  generic (MAX_WIDTH, MAX_HEIGHT : positive; DATA_WIDTH : positive := 32);
  port (clk, rst_n, enable : in std_logic;
        dimensions : in std_logic_vector(31 downto 0);
        s_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
        s_valid : in std_logic; s_ready : out std_logic;
        s_sof, s_eol : in std_logic;
        m_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
        m_valid : out std_logic; m_ready : in std_logic;
        m_sof, m_eol, filtered : out std_logic);
end entity;

architecture rtl of surface_contour_select is
  type state_t is (bypass, feed, drain);
  signal bypass_held : std_logic := '0';
  signal state : state_t := bypass;
  signal width : positive range 1 to MAX_WIDTH := 1;
  signal height : positive range 1 to MAX_HEIGHT := 1;
  signal in_row, out_row : natural range 0 to MAX_HEIGHT-1 := 0;
  signal requested_width, requested_height : unsigned(15 downto 0);
  signal arm, run_filter, fv, fr, ov, os, ol : std_logic;
  signal rgb_in, rgb_out : std_logic_vector(23 downto 0);
  signal packed : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
  requested_width <= unsigned(dimensions(15 downto 0));
  requested_height <= unsigned(dimensions(31 downto 16));
  -- Hold the first beat for one cycle to latch the active geometry.
  arm <= '1' when state=bypass and bypass_held='0' and enable='1' and s_valid='1' and s_sof='1'
              and requested_width>0 and requested_width<=MAX_WIDTH
              and requested_height>0 and requested_height<=MAX_HEIGHT else '0';
  run_filter <= rst_n when state/=bypass else '0';
  filtered <= run_filter;
  fv <= s_valid when state=feed else '0';
  rgb_in <= s_data(29 downto 22) & s_data(19 downto 12) & s_data(9 downto 2);
  core : entity work.pic2_filter_axis
    generic map(G_WIDTH=>MAX_WIDTH,G_HEIGHT=>MAX_HEIGHT)
    port map(clk,run_filter,rgb_in,fv,fr,s_sof,s_eol,rgb_out,ov,m_ready,os,ol,width,height);
  packed <= std_logic_vector(resize(unsigned(rgb_out(23 downto 16) & "00" &
                 rgb_out(15 downto 8) & "00" & rgb_out(7 downto 0) & "00"),DATA_WIDTH));
  s_ready <= fr when state=feed else m_ready when state=bypass and arm='0' else '0';
  m_valid <= ov when state/=bypass else s_valid and not arm;
  m_data <= packed when state/=bypass else s_data;
  m_sof <= os and ov when state/=bypass else s_sof and not arm;
  m_eol <= ol and ov when state/=bypass else s_eol and not arm;

  process(clk)
  begin
    if rising_edge(clk) then
      if rst_n='0' then
        state<=bypass; in_row<=0; out_row<=0; bypass_held<='0';
      else
        if state=bypass and arm='0' and s_valid='1' and m_ready='0' then
          bypass_held<='1';
        else
          bypass_held<='0';
        end if;
        if arm='1' then
          width<=to_integer(requested_width); height<=to_integer(requested_height);
          state<=feed; in_row<=0; out_row<=0;
        elsif state=feed and s_valid='1' and fr='1' and s_eol='1' then
          if in_row=height-1 then state<=drain;
          else in_row<=in_row+1; end if;
        end if;
        if state/=bypass and ov='1' and m_ready='1' and ol='1' then
          if out_row=height-1 then state<=bypass;
          else out_row<=out_row+1; end if;
        end if;
      end if;
    end if;
  end process;
end architecture;
