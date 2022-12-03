--04112019 [04-11-2019]
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tbPackage.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
use work.dutports_package.all;
entity dut_frameProcess is
port (
    clk            : in std_logic;
    resetn         : in std_logic);
end dut_frameProcess;
architecture arch_imp of dut_frameProcess is
    constant FIFO_ADDR_WIDTH : integer := 13;
    signal wrAddress         : std_logic_vector (13 downto 0);
    signal wrAddrsGlCtr      : integer := 0;
    signal startFrame        : std_logic :='1';
    signal fifoStatus        : std_logic_vector(31 downto 0);    
    signal videoChannel      : std_logic_vector(31 downto 0):=x"00000006";--configRegister5
    signal dChannel          : std_logic_vector(31 downto 0):=x"00000001";--configRegister6
    signal cChannel          : std_logic_vector(31 downto 0):=x"00000000";--configRegister7
    signal cRgbOsharp        : std_logic_vector(31 downto 0):=x"00000000";
    signal gridLockDatao     : std_logic_vector(31 downto 0);
    signal endOfFrame        : std_logic;
    signal threshold         : std_logic_vector(15 downto 0) :=x"006E";
    signal rgb               : channel;
    signal rgbio             : channel;
    signal dCord             : coord;
    signal txCord            : coord;
    signal kls               : coefficient;
    signal als               : coefficient;
    signal rgbCoord          : region;
    signal pRegion           : poi;
    signal sobel             : channel;
    signal rgbRemix          : channel;
    signal rgbDetect         : channel;
    signal rgbPoi            : channel;
    signal hsv               : channel;
    signal sharp             : channel;
    signal blur1x            : channel;
    signal blur2x            : channel;
    signal blur3x            : channel;
    signal blur4x            : channel;
    signal rgbcorrect        : channel;
    signal ycbcr             : channel;
    signal rgbDetectLock     : std_logic;
    signal rgbPoiLock        : std_logic;
    signal rgbSum            : tpRgb;
    signal rgbSet            : rRgb;
    signal frameData         : fcolors;
    signal enableFrame       : std_logic := hi;
    signal olm               : rgbConstraint;
    signal oLumTh            : integer;
    signal oHsvPerCh         : integer;
    signal oYccPerCh         : integer;
    signal iRgbSet           : rRgb;
    signal iEdgeType         : std_logic_vector(b_data_width-1 downto 0);
begin


frameProcessInst: frame_process
generic map(
    i_data_width         => i_data_width,
    s_data_width         => s_data_width,
    b_data_width         => b_data_width,
    img_width            => img_width,
    adwrWidth            => 16,
    addrWidth            => 12)
port map(
    clk                  => clk,
    rst_l                => resetn,
    iRgbSet              => iRgbSet,
    iEdgeType            => iEdgeType,
    iPoiRegion           => pRegion,
    iThreshold           => threshold,
    iKls                 => kls,
    iAls                 => als,
    iLumTh               => oLumTh,
    iHsvPerCh            => oHsvPerCh,
    iYccPerCh            => oYccPerCh,
    iRgbCoord            => rgbCoord,
    oFifoStatus          => fifoStatus,
    oGridLockData        => gridLockDatao,
    oFrameData           => frameData);
end arch_imp;