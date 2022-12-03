library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ports_package.all;
entity squareRootTop is
port (
    clk            : in std_logic;
    ivalid         : in std_logic;
    idata          : in std_logic_vector(31 downto 0);
    ovalid         : out std_logic;
    odata          : out std_logic_vector(31 downto 0));
end entity;
architecture arch of squareRootTop is



---------------------------------------------------------------------------------
--fixedToFloat FXtFO
  --signal ivalid     : std_logic := '0';  -- payload is valid
  --signal idata      : std_logic_vector(31 downto 0) := (others => '0');  -- data payload
  signal mFXtFoRtvalid    : std_logic := '0';
  signal mFXtFoRtdata     : std_logic_vector(31 downto 0) := (others => '0');  -- data payload
---------------------------------------------------------------------------------
--fixedToFloat FOtFX
  signal sFOSqTvalid     : std_logic := '0';  -- payload is valid
  signal sFOSqTdata      : std_logic_vector(31 downto 0) := (others => '0');  -- data payload
  signal mFOSqRtvalid    : std_logic := '0';
  signal mFOSqRtdata     : std_logic_vector(31 downto 0) := (others => '0');  -- data payload
---------------------------------------------------------------------------------

--fixedToFloat FOtFX
  signal sFOtFxTvalid     : std_logic := '0';  -- payload is valid
  signal sFOtFxTdata      : std_logic_vector(31 downto 0) := (others => '0');  -- data payload
--signal ovalid    : std_logic := '0';
--signal odata     : std_logic_vector(31 downto 0) := (others => '0');  -- data payload
---------------------------------------------------------------------------------
begin

fixedToFloat_inst: fixedToFloat
    port map(
      aclk                    => clk,
      s_axis_a_tvalid         => ivalid,
      s_axis_a_tdata          => idata,
      m_axis_result_tvalid    => mFXtFoRtvalid,
      m_axis_result_tdata     => mFXtFoRtdata);
      
      
squareRoot_inst: squareRoot
    port map(
      aclk                    => clk,
      s_axis_a_tvalid         => mFXtFoRtvalid,
      s_axis_a_tdata          => mFXtFoRtdata,
      m_axis_result_tvalid    => mFOSqRtvalid,
      m_axis_result_tdata     => mFOSqRtdata);     

      
floatToFixed_inst: floatToFixed
    port map(
      aclk                    => clk,
      s_axis_a_tvalid         => mFOSqRtvalid,
      s_axis_a_tdata          => mFOSqRtdata,
      m_axis_result_tvalid    => ovalid,
      m_axis_result_tdata     => odata);
      
end architecture;