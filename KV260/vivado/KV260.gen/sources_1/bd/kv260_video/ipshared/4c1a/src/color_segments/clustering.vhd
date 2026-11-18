-------------------------------------------------------------------------------
--
-- Filename    : clustering.vhd
-- Create Date : 04282019 [04-28-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity clustering is
generic (
    data_width     : integer := 8);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    k_rgb          : in int_rgb;
    threshold      : out integer);
end entity;
architecture arch of clustering is
type s_pixel is record
    i_red      : integer;
    i_gre      : integer;
    i_blu      : integer;
    red        : integer;
    gre        : integer;
    blu        : integer;
    m1         : integer;
    m2         : integer;
    m3         : integer;
    mac        : integer;
    mac_syn    : integer;
    sum        : std_logic_vector (31 downto 0);
    sum2       : std_logic_vector (31 downto 0);
    rslt       : std_logic_vector (15 downto 0);
    rslt2      : integer;
end record;
    signal rgb_set1       : s_pixel;
begin
process (clk) begin
    if rising_edge(clk) then
          rgb_set1.i_red      <= to_integer(unsigned(iRgb.red(9 downto 2)));
          rgb_set1.i_gre      <= to_integer(unsigned(iRgb.green(9 downto 2)));
          rgb_set1.i_blu      <= to_integer(unsigned(iRgb.blue(9 downto 2)));
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
          rgb_set1.red          <= abs(k_rgb.red - rgb_set1.i_red);
          rgb_set1.gre          <= abs(k_rgb.gre - rgb_set1.i_gre);
          rgb_set1.blu          <= abs(k_rgb.blu - rgb_set1.i_blu);
    end if;
end process;

process (clk) begin
  if rising_edge(clk) then
      rgb_set1.m1    <= (rgb_set1.red * rgb_set1.red);
      rgb_set1.m2    <= (rgb_set1.gre * rgb_set1.gre);
      rgb_set1.m3    <= (rgb_set1.blu * rgb_set1.blu);
  end if;
end process;

process (clk) begin
  if rising_edge(clk) then
      rgb_set1.mac   <= rgb_set1.m1 + rgb_set1.m2 + rgb_set1.m3;
  end if;
end process;


process (clk) begin
  if rising_edge(clk) then
    rgb_set1.sum <= std_logic_vector(to_unsigned(rgb_set1.mac,32));
  end if;
end process;

process (clk) begin
  if rising_edge(clk) then
    rgb_set1.sum2 <= rgb_set1.sum;
  end if;
end process;

set1_inst: square_root
generic map(
    data_width       => 32)
port map(
   clock    => clk,
   rst_l    => rst_l,
   data_in  => rgb_set1.sum2,
   data_out => rgb_set1.rslt);
   
   
process (clk, rst_l) begin
  if rising_edge(clk) then
    rgb_set1.rslt2      <= to_integer(unsigned(rgb_set1.rslt));

  end if;
end process;

process (clk, rst_l) begin
  if rising_edge(clk) then
    threshold           <= rgb_set1.rslt2;
  end if;
end process;

end architecture;

