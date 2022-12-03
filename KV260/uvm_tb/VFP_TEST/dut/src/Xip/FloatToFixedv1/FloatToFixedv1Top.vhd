library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ports_package.all;
entity FloatToFixedv1Top is
port (
    aclk           : in std_logic;
    iData          : in std_logic_vector(31 downto 0);
    oData          : out std_logic_vector(27 downto 0));
end entity;
architecture arch of FloatToFixedv1Top is
  signal iValid     : std_logic := '1';
  signal oValid     : std_logic;
  signal mTdata     : std_logic_vector(31 downto 0);
begin
oData <= mTdata(27 downto 0);
FloatToFixedv1inst: FloatToFixedv1
    port map (
      aclk                    => aclk,
      s_axis_a_tvalid         => iValid,
      s_axis_a_tdata          => iData,
      m_axis_result_tvalid    => oValid,
      m_axis_result_tdata     => mTdata);
end architecture;