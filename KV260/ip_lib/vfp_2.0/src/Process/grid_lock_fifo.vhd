-------------------------------------------------------------------------------
--
-- Filename    : grid_lock_fifo.vhd
-- Create Date : 04112019 [04-11-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity grid_lock_fifo is
generic (
    FIFO_DEPTH       : integer := 24;
    FIFO_DATA_WIDTH  : integer := 24;
    FIFO_ADDR_WIDTH  : integer := 14);
port (
    clk              : in  std_logic;
    clrStatus        : in  std_logic;
    --READ PORT
    rdEn             : in  std_logic;
    rdAddress        : in  std_logic_vector (FIFO_ADDR_WIDTH-1 downto 0);
    dataO            : out std_logic_vector (FIFO_DATA_WIDTH-1 downto 0);
    --WRITE PORT
    wrEn             : in  std_logic;
    wrAddress        : in  std_logic_vector (FIFO_ADDR_WIDTH-1 downto 0);
    dataIn           : in  std_logic_vector (FIFO_DATA_WIDTH-1 downto 0);
    --STATUS
    wrDone           : out std_logic;
    rdDone           : out std_logic;
    emptyO           : out std_logic;
    fullO            : out std_logic);
end entity;
architecture rtl of grid_lock_fifo is
    type RAM is array (integer range <>)of std_logic_vector (FIFO_DATA_WIDTH-1 downto 0);
    signal Mem : RAM (0 to FIFO_DEPTH-1);
    signal eqlLocations  : std_logic;
    signal wrDoneStatus  : std_logic;
    signal rdDoneStatus  : std_logic;
    signal preStatus     : std_logic := lo;
    signal preFull       : std_logic;
    signal preEmpty      : std_logic;
    signal emptyHi       : std_logic;
    signal fullHi        : std_logic;
    signal fifoWrAddrs   : integer := 0;
    signal fifoRdAddrs   : integer := 0;
begin

fullO        <= fullHi;
emptyO       <= emptyHi;

fifoWrAddrs  <= to_integer(unsigned(wrAddress));
fifoRdAddrs  <= to_integer(unsigned(rdAddress));

eqlLocations <= hi when (wrAddress = rdAddress) else lo;
wrDone       <= hi when (fifoWrAddrs    = FIFO_DEPTH - 1) else lo;
rdDone       <= hi when (fifoRdAddrs    = FIFO_DEPTH - 1) else lo;
preEmpty     <= not preStatus and eqlLocations;
preFull      <= preStatus and eqlLocations;

readPort: process (clk) begin
    if (rising_edge(clk)) then
        if (rdEn = hi and emptyHi = lo) then
            dataO <= Mem(fifoRdAddrs);
        end if;
    end if;
end process readPort;

writePort: process (clk) begin
    if (rising_edge(clk)) then
        if (wrEn = hi and fullHi = lo) then
            Mem(fifoWrAddrs) <= dataIn;
        end if;
    end if;
end process writePort;

rdPointerStatus: process (wrAddress, rdAddress)
    variable rdConditionBit0 : std_logic;
    variable rdConditionBit1 : std_logic;
begin
    rdConditionBit0 := wrAddress(FIFO_ADDR_WIDTH-2) xor  rdAddress(FIFO_ADDR_WIDTH-1);
    rdConditionBit1 := wrAddress(FIFO_ADDR_WIDTH-1) xnor rdAddress(FIFO_ADDR_WIDTH-2);
    rdDoneStatus    <= rdConditionBit0 and rdConditionBit1;
end process rdPointerStatus;

wrPointerStatus: process (wrAddress, rdAddress)
    variable wrConditionBit0 : std_logic;
    variable wrConditionBit1 : std_logic;
begin
    wrConditionBit0 := wrAddress(FIFO_ADDR_WIDTH-2) xnor rdAddress(FIFO_ADDR_WIDTH-1);
    wrConditionBit1 := wrAddress(FIFO_ADDR_WIDTH-1) xor  rdAddress(FIFO_ADDR_WIDTH-2);
    wrDoneStatus    <= wrConditionBit0 and wrConditionBit1;
end process wrPointerStatus;

fifoPreStatus: process (wrDoneStatus, rdDoneStatus, clrStatus) begin
    if (rdDoneStatus = hi or clrStatus = hi) then
        preStatus <= lo;  -- GoingEmpty
    elsif (wrDoneStatus = hi) then
        preStatus <= hi;  -- GoingFull
    end if;
end process fifoPreStatus;

fifoFullStatus: process (clk, preFull) begin
    if (preFull = hi) then
        fullHi <= hi;
    elsif (rising_edge(clk)) then
        fullHi <= lo;
    end if;
end process fifoFullStatus;

fifoEmptyStatus: process (clk, preEmpty) begin
    if (preEmpty = hi) then
        emptyHi <= hi;
    elsif (rising_edge(clk)) then
        emptyHi <= lo;
    end if;
end process fifoEmptyStatus;

end architecture;