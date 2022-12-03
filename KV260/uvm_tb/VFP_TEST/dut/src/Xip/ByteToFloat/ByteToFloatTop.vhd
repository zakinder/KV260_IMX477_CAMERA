library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.ports_package.all;
entity ByteToFloatTop is
port (
    aclk           : in std_logic;
    rst_l          : in std_logic;
    iValid         : in std_logic;
    iData          : in std_logic_vector(7 downto 0);
    oValid         : out std_logic;
    oDataFloat     : out std_logic_vector(31 downto 0));
end entity;
architecture arch of ByteToFloatTop is



  signal sTdata            : std_logic_vector(15 downto 0);
  signal mTdata            : std_logic_vector(31 downto 0);
  signal mValid            : std_logic;
  
begin

sTdata <= x"00" & iData;

ByteToFloatinst: ByteToFloat
    port map (
      aclk                    => aclk,
      s_axis_a_tvalid         => iValid,
      s_axis_a_tdata          => sTdata,
      m_axis_result_tvalid    => mValid,
      m_axis_result_tdata     => mTdata);
      
process (aclk,rst_l) begin
    if (rst_l = lo) then
        oDataFloat  <= (others => '0');
        oValid      <= lo;
    elsif rising_edge(aclk) then 
        oDataFloat  <= mTdata;
        oValid      <= mValid;
    end if;
end process;
      
end architecture;