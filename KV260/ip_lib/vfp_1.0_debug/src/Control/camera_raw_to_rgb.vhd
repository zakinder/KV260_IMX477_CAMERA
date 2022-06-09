-------------------------------------------------------------------------------
--
-- Filename    : camera_raw_to_rgb.vhd
-- Create Date : 05022019 [05-02-2019]
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

entity camera_raw_to_rgb is
generic (
    img_width           : integer := 8;
    dataWidth           : integer := 12;
    addrWidth           : integer := 12);
port (
    m_axis_mm2s_aclk    : in std_logic;
    m_axis_mm2s_aresetn : in std_logic;
    pixclk              : in std_logic;
    ifval               : in std_logic;
    ilval               : in std_logic;
    idata               : in std_logic_vector(dataWidth-1 downto 0);
    oRgbSet             : out rRgb);
end camera_raw_to_rgb;

architecture arch_imp of camera_raw_to_rgb is

    signal rawTp            : rTp;
    signal rawData          : rData;
    signal rgbSet           : rRgb;
    signal raw2xData        : r2xData;
    signal raw1xData        : rData;
begin

CameraRawDataInst: camera_raw_data
generic map(
    dataWidth            => dataWidth,
    img_width            => img_width)
port map(
    m_axis_aclk          => m_axis_mm2s_aclk,
    m_axis_aresetn       => m_axis_mm2s_aresetn,
    pixclk               => pixclk,
    ifval                => ifval,
    ilval                => ilval,
    idata                => idata,
    oRawData             => raw2xData);
    raw1xData.valid      <= raw2xData.valid;
    raw1xData.pEof       <= raw2xData.pEof;
    raw1xData.pSof       <= raw2xData.pSof;
    raw1xData.cord       <= raw2xData.cord;
    raw1xData.data       <= raw2xData.data;
dataTapsInst: data_taps
generic map(
    img_width            => img_width,
    dataWidth            => 12,
    addrWidth            => addrWidth)
port map(
    aclk                 => m_axis_mm2s_aclk,
    iRawData             => raw1xData,
    oTpData              => rawTp);

RawToRgbInst: raw_to_rgb
port map(
    clk                  => m_axis_mm2s_aclk,
    rst_l                => m_axis_mm2s_aresetn,
    iTpData              => rawTp,
    oRgbSet              => rgbSet);
channelOutP: process (m_axis_mm2s_aclk) begin
    if rising_edge(m_axis_mm2s_aclk) then
        if (dataWidth = 12) then
            oRgbSet  <= rgbSet;
        else
            oRgbSet.valid  <= raw2xData.valid;
            oRgbSet.pEof   <= raw2xData.pEof;
            oRgbSet.pSof   <= raw2xData.pSof;
            oRgbSet.cord   <= raw2xData.cord;
            oRgbSet.red    <= std_logic_vector(raw2xData.dita(23 downto 16));
            oRgbSet.green  <= std_logic_vector(raw2xData.dita(15 downto 8));
            oRgbSet.blue   <= std_logic_vector(raw2xData.dita(7 downto 0));
        end if;
    end if;
end process channelOutP;
end arch_imp;