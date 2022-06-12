-------------------------------------------------------------------------------
--
-- Filename    : camera_raw_data.vhd
-- Create Date : 01062019 [01-06-2019]
-- Author      : Zakinder
--
-- Description:
-- This module read camera input control valids and data signals.
-- camera_raw_data is the first module inside the VFP system which
-- communicate with D5M camera.It receives the data of 12 bits
-- per pixel at each clock cycle from the cmos camera when the
-- frame valid and line valid are asserted high.Pixel clock is
-- used to synchronize 12-bits input idata on the rising edge
-- of the clock.Input valids(ilval and ifval) are used to start
-- loading idata into line data buffer.The d5mLnBuffer line buffer
-- operate on two separate clocks pixclk and m_axis_aclk.It is
-- used to store and synchronize pixel data across clock pixclk
-- and m_axis_aclk domain boundaries.When pLine and pFrame are
-- enabled, the line buffer stores the pWrData at each triggering
-- pixclk clock edge.As long as both valids are active high by
-- the camera, the line buffer stores the pWrData upto maximum
-- supported image width maxImgWidth of plineRam.
-- maxImgWidth maximum image width. calImgWidth Image width values
-- varies which is adjusted by the camera valid signals upto
-- maximum supported value.
-- Max Full Resolution : 2592x1944 -frame rate @15.15 24-bits
----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity camera_raw_data is
generic (
    dataWidth         : integer := 12;
    img_width         : integer := 8);
port (
    m_axis_aclk       : in std_logic;
    m_axis_aresetn    : in std_logic;
    pixclk            : in std_logic;
    ifval             : in std_logic;
    ilval             : in std_logic;
    idata             : in std_logic_vector(dataWidth-1 downto 0);
    oRawData          : out r2xData);
end camera_raw_data;

architecture arch_imp of camera_raw_data is
    --PIXCLK SIDE
    signal pLine          : std_logic :=lo;
    signal pFrame         : std_logic :=lo;
    signal pLnSy          : std_logic :=lo;
    signal pWrAdr         : integer   := zero;
    signal pSof           : std_logic :=lo;
    signal pSol           : std_logic :=lo;
    signal pEof           : std_logic :=lo;
    signal pEol           : std_logic :=lo;
    --M_AXIS_ACLK SIDE
    signal iLvalSy1       : std_logic :=lo;
    signal iLvalSy2       : std_logic :=lo;
    signal iLvalSy3       : std_logic :=lo;
    signal iLvalSy4       : std_logic :=lo;
    signal iFvalSy1       : std_logic :=lo;
    signal iFvalSy2       : std_logic :=lo;
    signal pEolBufferFull : std_logic :=lo;
    ----
    signal pRdData        : std_logic_vector(dataWidth-1 downto 0):= (others => lo);
    signal rLine          : std_logic :=lo;
    type d5mSt is (rLnSt,eolSt,eofSt,sofSt);
    signal d5mStates      : d5mSt;
    signal cordx          : integer :=zero;
    signal cordy          : integer :=zero;
    signal imgWidth       : integer := 3071;
    type pLnRm is array (0 to img_width) of std_logic_vector (dataWidth-1 downto 0);
    signal d5mLnBuffer    : pLnRm := (others => (others => lo));

begin

-----------------------------------------------------------------------------------------
--pixclk
-----------------------------------------------------------------------------------------
pEolBufferFull <= hi when (pLnSy = hi and ilval = lo) else lo;
d5mDataSyncP: process(pixclk) begin
    if rising_edge(pixclk) then
        pLine       <= ilval;
        pLnSy       <= pLine;
        pFrame      <= ifval;
        if (pFrame = hi and pLine = hi) then
            pWrAdr  <= pWrAdr + one;
        else
            pWrAdr <= zero;
        end if;
        if (pEolBufferFull = hi) then
            imgWidth  <= pWrAdr;
        else
            imgWidth  <= imgWidth;
        end if;
        d5mLnBuffer(pWrAdr) <= idata;
    end if;
end process d5mDataSyncP;

-----------------------------------------------------------------------------------------
cdcSignals: process (m_axis_aclk) begin
    if rising_edge(m_axis_aclk) then
        iLvalSy1  <= ilval;
        iLvalSy2  <= iLvalSy1;
        iFvalSy1  <= ifval;
        iFvalSy2  <= iFvalSy1;
    end if;
end process cdcSignals;

edgeDetect: process (m_axis_aclk) begin
    if rising_edge(m_axis_aclk) then
        iLvalSy3  <= iLvalSy2;
        iLvalSy4  <= iLvalSy3;
    end if;
end process edgeDetect;

pSol <= hi when (iLvalSy4 = lo and iLvalSy2 = hi) else lo;--risingEdge Detect
pEol <= hi when (iLvalSy4 = hi and iLvalSy2 = lo) else lo;--fallingEdge Detect

readLineP: process (m_axis_aclk) begin
    if (rising_edge (m_axis_aclk)) then
        if (m_axis_aresetn = lo) then
            d5mStates <= sofSt;
            pSof      <= lo;
            pEof      <= lo;
            rLine     <= lo;
            cordx     <= zero;
            cordy     <= zero;
        else
        case (d5mStates) is
        when sofSt =>
            pEof      <= lo;
            if (iFvalSy2 = hi) and (pEol = hi) then --pEolBufferFull and Sof
                pSof      <= hi;
                d5mStates <= rLnSt;
            end if;
        when rLnSt =>
            if (cordx = imgWidth) then
                rLine         <= lo;
                d5mStates     <= eolSt;
                cordx         <= zero;
            else
                cordx         <= cordx + one;--start reading
                rLine         <= hi;
                pSof          <= lo;
                d5mStates     <= rLnSt;
            end if;
        when eolSt =>
            if (iFvalSy2 = lo)  then --pEolBufferFull and Sof
                cordy     <= zero;
                d5mStates <= eofSt;
            elsif(pEol = hi) then
                d5mStates <= rLnSt;
                cordy     <= cordy + one;
            else
                d5mStates <= eolSt;
            end if;
        when eofSt =>
            d5mStates <= sofSt;
            pEof      <= hi;
        when others =>
            d5mStates <= sofSt;
        end case;
        end if;
    end if;
end process readLineP;

d5mLineRamP: process (m_axis_aclk) begin
    if rising_edge(m_axis_aclk) then
        pRdData <= d5mLnBuffer(cordx);
    end if;
end process d5mLineRamP;

d5mP: process (m_axis_aclk) begin
    if rising_edge(m_axis_aclk) then
        oRawData.valid  <= rLine;
        oRawData.pEof   <= pEof;
        oRawData.pSof   <= pSof;
        oRawData.cord.x <= std_logic_vector(to_unsigned(cordx, 16));
        oRawData.cord.y <= std_logic_vector(to_unsigned(cordy, 16));
        if (rLine = hi) then
            oRawData.data  <= pRdData(11 downto 0);
            oRawData.dita <= std_logic_vector(resize(unsigned(pRdData), oRawData.dita'length));
        else
            oRawData.data <= (others =>lo);
        end if;
    end if;
end process d5mP;

end arch_imp;