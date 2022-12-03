library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ports_package.all;
entity FloatMultiplyTop is
port (
    clk            : in std_logic;
    iAdata         : in std_logic_vector(31 downto 0);
    iBdata         : in std_logic_vector(31 downto 0);
    oRdata         : out std_logic_vector(31 downto 0));
end entity;
architecture arch of FloatMultiplyTop is
  signal iValid     : std_logic := '1';
  signal oValid     : std_logic;
begin
FloatMultiplyInst: FloatMultiply
    port map(
    aclk                    => clk,
    s_axis_a_tvalid         => iValid,
    s_axis_a_tdata          => iAdata,
    s_axis_b_tvalid         => iValid,
    s_axis_b_tdata          => iBdata,
    m_axis_result_tvalid    => oValid,
    m_axis_result_tdata     => oRdata);
end architecture;