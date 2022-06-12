-------------------------------------------------------------------------------
--
-- Filename    : mWrRd.vhd
-- Create Date : 05012019 [05-01-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation axi4 components.
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity mWrRd is
generic (
    revision_number   : std_logic_vector(31 downto 0) := x"00000000";
    s_data_width      : integer    := 16;
    b_data_width      : integer    := 32);
port (
    -- Master Write Read Registers
    iWrRegs           : in mRegs;
    oReRegs           : out mRegs;
    -- System Time
    iSeconds          : in std_logic_vector(5 downto 0);
    iMinutes          : in std_logic_vector(5 downto 0);
    iHours            : in std_logic_vector(4 downto 0);
    -- Fifo Data
    iFifoStatus       : in std_logic_vector(b_data_width-1 downto 0);
    iGridLockData     : in std_logic_vector(b_data_width-1 downto 0);
    -- Configured filters coeffs
    iKcoeff           : in kernelCoeff;
    -- Fixed filters kernal coeffs
    oAls              : out coefficient;
    -- Customizable filters kernal coeffs
    oKls              : out coefficient;
    -- Filter lum theshold value
    oLumTh            : out integer;
    -- Hsv filter per color select
    oHsvPerCh         : out integer;
    -- Ycbcr filter per color select
    oYccPerCh         : out integer;
    -- Rgb max min limits
    oRgbRoiLimits     : out region;
    -- Filters id
    oFilterId         : out integer;
    -- oMmAxi end node bus select
    oMmAxi            : out integer;
    -- Sobel filter Threshold
    oSobelThresh      : out integer;
    -- Video channel
    oVideoChannel     : out integer;
    -- Rgb select id
    oRgbSelect        : out integer;
    -- Region of interest
    oRoi              : out poi);
end mWrRd;
architecture Behavioral of mWrRd is
begin
--CPU Registers
    -- Write Registers
    oFilterId             <= to_integer(unsigned(iWrRegs.cfigReg2));
    oMmAxi                <= to_integer(unsigned(iWrRegs.cfigReg3));
    oSobelThresh          <= to_integer(unsigned(iWrRegs.cfigReg4));
    oVideoChannel         <= to_integer(unsigned(iWrRegs.cfigReg5));
    oRgbSelect            <= to_integer(unsigned(iWrRegs.cfigReg6));
    oKls.k1               <= iWrRegs.cfigReg8;
    oKls.k2               <= iWrRegs.cfigReg9;
    oKls.k3               <= iWrRegs.cfigReg10;
    oKls.k4               <= iWrRegs.cfigReg11;
    oKls.k5               <= iWrRegs.cfigReg12;
    oKls.k6               <= iWrRegs.cfigReg13;
    oKls.k7               <= iWrRegs.cfigReg14;
    oKls.k8               <= iWrRegs.cfigReg15;
    oKls.k9               <= iWrRegs.cfigReg16;
    oKls.config           <= to_integer(unsigned(iWrRegs.cfigReg17));
    oAls.k1               <= iWrRegs.cfigReg21;
    oAls.k2               <= iWrRegs.cfigReg22;
    oAls.k3               <= iWrRegs.cfigReg23;
    oAls.k4               <= iWrRegs.cfigReg24;
    oAls.k5               <= iWrRegs.cfigReg25;
    oAls.k6               <= iWrRegs.cfigReg26;
    oAls.k7               <= iWrRegs.cfigReg27;
    oAls.k8               <= iWrRegs.cfigReg28;
    oAls.k9               <= iWrRegs.cfigReg29;
    oAls.config           <= to_integer(unsigned(iWrRegs.cfigReg30));
    oRoi.pointInterest    <= to_integer(unsigned(iWrRegs.cfigReg31(s_data_width -1 downto 0)));--set the point
    oRoi.deltaConfig      <= to_integer(unsigned(iWrRegs.cfigReg32(s_data_width -1 downto 0)));--set the point delta
    oRoi.cpuAckGoAgain    <= iWrRegs.cfigReg33(0);
    oRoi.cpuWgridLock     <= iWrRegs.cfigReg34(0);
    oRoi.cpuAckoffFrame   <= iWrRegs.cfigReg35(0);
    oRoi.fifoReadAddress  <= iWrRegs.cfigReg36(13 downto 0);--fifo read address location upto cpuGridCont[Max-Locations]
    oRoi.fifoReadEnable   <= iWrRegs.cfigReg36(16);--fifo read enable
    oRoi.clearFifoData    <= iWrRegs.cfigReg37(0);--clear the fifo
    oRgbRoiLimits.rl      <= iWrRegs.cfigReg50(7 downto 0);
    oRgbRoiLimits.rh      <= iWrRegs.cfigReg51(7 downto 0);
    oRgbRoiLimits.gl      <= iWrRegs.cfigReg52(7 downto 0);
    oRgbRoiLimits.gh      <= iWrRegs.cfigReg53(7 downto 0);
    oRgbRoiLimits.bl      <= iWrRegs.cfigReg54(7 downto 0);
    oRgbRoiLimits.bh      <= iWrRegs.cfigReg55(7 downto 0);
    oLumTh                <= to_integer(unsigned(iWrRegs.cfigReg56));
    oHsvPerCh             <= to_integer(unsigned(iWrRegs.cfigReg57));
    oYccPerCh             <= to_integer(unsigned(iWrRegs.cfigReg58));
    -- Read Registers
    oReRegs.cfigReg0      <= iWrRegs.cfigReg0;
    oReRegs.cfigReg1      <= iWrRegs.cfigReg1;
    oReRegs.cfigReg2      <= iWrRegs.cfigReg2;
    oReRegs.cfigReg3      <= iWrRegs.cfigReg3;
    oReRegs.cfigReg4      <= iWrRegs.cfigReg4;
    oReRegs.cfigReg5      <= iWrRegs.cfigReg5;
    oReRegs.cfigReg6      <= iWrRegs.cfigReg6;
    oReRegs.cfigReg7      <= iWrRegs.cfigReg7;
    oReRegs.cfigReg8      <= std_logic_vector(resize(unsigned(iKcoeff.k1), oReRegs.cfigReg8'length));
    oReRegs.cfigReg9      <= std_logic_vector(resize(unsigned(iKcoeff.k2), oReRegs.cfigReg9'length));
    oReRegs.cfigReg10     <= std_logic_vector(resize(unsigned(iKcoeff.k3), oReRegs.cfigReg10'length));
    oReRegs.cfigReg11     <= std_logic_vector(resize(unsigned(iKcoeff.k4), oReRegs.cfigReg11'length));
    oReRegs.cfigReg12     <= std_logic_vector(resize(unsigned(iKcoeff.k5), oReRegs.cfigReg12'length));
    oReRegs.cfigReg13     <= std_logic_vector(resize(unsigned(iKcoeff.k6), oReRegs.cfigReg13'length));
    oReRegs.cfigReg14     <= std_logic_vector(resize(unsigned(iKcoeff.k7), oReRegs.cfigReg14'length));
    oReRegs.cfigReg15     <= std_logic_vector(resize(unsigned(iKcoeff.k8), oReRegs.cfigReg15'length));
    oReRegs.cfigReg16     <= std_logic_vector(resize(unsigned(iKcoeff.k9), oReRegs.cfigReg16'length));
    oReRegs.cfigReg17     <= std_logic_vector(to_unsigned(iKcoeff.kSet,32));
    oReRegs.cfigReg28     <= iWrRegs.cfigReg28;
    oReRegs.cfigReg29     <= iWrRegs.cfigReg29;
    oReRegs.cfigReg30     <= iWrRegs.cfigReg30;
    oReRegs.cfigReg31     <= iWrRegs.cfigReg31;
    oReRegs.cfigReg32     <= iWrRegs.cfigReg32;
    oReRegs.cfigReg33     <= iWrRegs.cfigReg33;
    oReRegs.cfigReg34     <= iWrRegs.cfigReg34;
    oReRegs.cfigReg35     <= iWrRegs.cfigReg35;
    oReRegs.cfigReg36     <= x"0000" & "00" & iWrRegs.cfigReg36(13 downto 0);
    oReRegs.cfigReg37     <= iWrRegs.cfigReg37;
    oReRegs.cfigReg38     <= iGridLockData;
    oReRegs.cfigReg39     <= x"000000" & "0000000" & iFifoStatus(0);--fifoFullh
    oReRegs.cfigReg40     <= x"000000" & "0000000" & iFifoStatus(1);--fifoEmptyh
    oReRegs.cfigReg41     <= x"000000" & "0000000" & iFifoStatus(2);--fifoFullh
    oReRegs.cfigReg42     <= x"000000" & iFifoStatus(23 downto 16);--cpuGridCont
    oReRegs.cfigReg43     <= iWrRegs.cfigReg43;
    oReRegs.cfigReg44     <= iWrRegs.cfigReg44;
    oReRegs.cfigReg45     <= iWrRegs.cfigReg45;
    oReRegs.cfigReg46     <= iWrRegs.cfigReg46;
    oReRegs.cfigReg47     <= iWrRegs.cfigReg47;
    oReRegs.cfigReg48     <= iWrRegs.cfigReg48;
    oReRegs.cfigReg49     <= iWrRegs.cfigReg49;
    oReRegs.cfigReg50     <= iWrRegs.cfigReg50;
    oReRegs.cfigReg51     <= iWrRegs.cfigReg51;
    oReRegs.cfigReg52     <= iWrRegs.cfigReg52;
    oReRegs.cfigReg53     <= iWrRegs.cfigReg53;
    oReRegs.cfigReg54     <= iWrRegs.cfigReg54;
    oReRegs.cfigReg55     <= iWrRegs.cfigReg55;
    oReRegs.cfigReg56     <= iWrRegs.cfigReg56;
    oReRegs.cfigReg57     <= iWrRegs.cfigReg57;
    oReRegs.cfigReg58     <= iWrRegs.cfigReg58;
    oReRegs.cfigReg59     <= iWrRegs.cfigReg59;
    oReRegs.cfigReg60     <= x"000000" & "00" & iSeconds;
    oReRegs.cfigReg61     <= x"000000" & "00" & iMinutes;
    oReRegs.cfigReg62     <= x"000000" & "000" & iHours;
    oReRegs.cfigReg63     <= revision_number;
end Behavioral;