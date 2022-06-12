-------------------------------------------------------------------------------
--
-- Filename    : point_of_interest.vhd
-- Create Date : 05022019 [05-02-2019]
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

entity point_of_interest is
generic (
    i_data_width   : integer := 8;
    s_data_width   : integer := 16;
    b_data_width   : integer := 32);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iCord          : in coord;
    endOfFrame     : in std_logic;
    iRoi           : in poi;
    iRgb           : in channel;
    oRgb           : out channel;
    gridLockDatao  : out std_logic_vector(b_data_width-1 downto 0);
    fifoStatus     : out std_logic_vector(b_data_width-1 downto 0);
    oGridLocation  : out std_logic);
end entity;
architecture arch of point_of_interest is
    constant FIFO_ADDR_WIDTH :integer := 14;
    constant FIFO_DATA_WIDTH :integer := 24;
    constant FIFO_DEPTH :integer := 2**(FIFO_ADDR_WIDTH);--8192
    type fState is (idle,lockReady,fifoFullStatus,fifoEmptyStatus,waitForNewFrame,gridEnCheck);
    signal fifoControlState : fState;
    signal wrAddrsGlCtr     : integer := 0;
    signal GlEnable         : std_logic;
    signal rdData           : std_logic_vector(23 downto 0);
    signal wrDataIn         : std_logic_vector(23 downto 0);
    signal clearData        : std_logic;
    signal wrEn             : std_logic;
    signal wrLstEn          : std_logic;
    signal emptyO           : std_logic;
    signal wrDone           : std_logic;
    signal rdDone           : std_logic;
    signal fullO            : std_logic;
    signal clrStatus        : std_logic;
    signal wrAddress        : std_logic_vector (FIFO_ADDR_WIDTH-1 downto 0);
    signal wrAddr           : std_logic_vector (FIFO_ADDR_WIDTH-1 downto 0);
    signal gridEn           : std_logic;
    signal fifoIsFull       : std_logic;
    signal fifoIsEmpty      : std_logic;
    signal gridContMax      : std_logic_vector (15 downto 0);
    signal pCont            : cord;
begin
    oGridLocation  <= GlEnable;
    fifoStatus     <= "00000000" & gridContMax & "00000" & fifoIsFull & fifoIsEmpty & fifoIsFull;
    gridLockDatao  <= x"00" & rdData;
    wrAddress      <= std_logic_vector(to_unsigned(wrAddrsGlCtr,FIFO_ADDR_WIDTH));
fifoControlP: process (clk) begin
if (rising_edge (clk)) then
    if (rst_l = lo) then
        fifoControlState <= idle;
        gridEn           <= lo;
        fifoIsFull       <= lo;
        fifoIsEmpty      <= lo;
        clrStatus        <= hi;
    else
    case (fifoControlState) is
    when idle =>
    --READY
        fifoIsFull   <= lo;
        fifoIsEmpty  <= hi;
        clrStatus    <= lo;
        --Enable
        if (iRoi.cpuWgridLock = hi) then
            fifoControlState <= waitForNewFrame;
        end if;
    when waitForNewFrame =>
    --WAIT
        if (endOfFrame = hi) then
            fifoControlState <= gridEnCheck;
        end if;
    when gridEnCheck =>
        if (GlEnable = lo) then
            fifoControlState <= lockReady;
            gridEn           <= hi;
        end if;
    when lockReady =>
    --CHECK
        fifoIsFull  <= lo;
        fifoIsEmpty <= lo;
        --WriteDone Pulse
        if (wrDone = hi) then
            fifoControlState <= fifoFullStatus;
            gridEn           <= lo;
        end if;
    when fifoFullStatus =>
    --CHECK
        fifoIsFull   <= hi;--Full
        fifoIsEmpty  <= lo;
        gridContMax <= std_logic_vector(resize(unsigned(wrAddr), gridContMax'length));
        --ReadDone Pulse
        if (rdDone = hi) then
            fifoControlState <= fifoEmptyStatus;
        end if;
    when fifoEmptyStatus =>
    --RESET
        fifoIsFull   <= lo;
        fifoIsEmpty  <= hi;
        if (iRoi.cpuAckGoAgain = hi) then
            fifoControlState <= idle;
            clrStatus        <= hi;
        end if;
    when others =>
        fifoControlState <= idle;
    end case;
    end if;
end if;
end process fifoControlP;
enablePointerP: process (clk)begin
    if rising_edge(clk) then
        wrDataIn  <= (iRgb.red & iRgb.green & iRgb.blue);
        wrAddr    <= wrAddress;
        if (((pCont.x >= iRoi.pointInterest) and (pCont.x <= iRoi.pointInterest + pInterestWidth)) and ((pCont.y >= iRoi.pointInterest) and (pCont.y <= iRoi.pointInterest + pInterestHight)))
        and (iRgb.valid = hi) then
            GlEnable     <= hi;
        else
            GlEnable     <= lo;
        end if;
        wrLstEn       <= not(gridEn);
        if (gridEn = hi and GlEnable = hi) then
            wrEn         <= hi;
            wrAddrsGlCtr <= wrAddrsGlCtr + 1;
        elsif (gridEn = hi and GlEnable = lo)then
            wrEn          <= wrLstEn;
            wrAddrsGlCtr  <= wrAddrsGlCtr;
        else
            wrEn          <= lo;
            wrAddrsGlCtr  <=  0;
        end if;
    end if;
end process enablePointerP;
gridLockFifoInt : grid_lock_fifo
generic map(
    FIFO_DEPTH      => FIFO_DEPTH,
    FIFO_DATA_WIDTH => FIFO_DATA_WIDTH,
    FIFO_ADDR_WIDTH => FIFO_ADDR_WIDTH)
port map(
    clk             => clk,
    clrStatus       => clrStatus,
    rdEn            => iRoi.fifoReadEnable,
    rdAddress       => iRoi.fifoReadAddress(FIFO_ADDR_WIDTH-1 downto 0),
    dataO           => rdData,
    wrEn            => wrEn,
    wrAddress       => wrAddr,
    dataIn          => wrDataIn,
    wrDone          => wrDone,
    rdDone          => rdDone,
    emptyO          => emptyO,
    fullO           => fullO);
pipCordP: process (clk)begin
    if rising_edge(clk) then
        pCont.x      <= to_integer((unsigned(iCord.x)));
        pCont.y      <= to_integer((unsigned(iCord.y)));
    end if;
end process pipCordP;
pixelCordInt : pixel_cord
port map(
    clk      => clk,
    iRgb     => iRgb,
    iPixelEn => GlEnable,
    iEof     => endOfFrame,
    iCord    => pCont,
    oRgb     => oRgb);
end architecture;