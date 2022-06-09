-------------------------------------------------------------------------------
--
-- Filename    : data_taps.vhd
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

entity data_taps is
generic (
    img_width     : integer := 4096;
    dataWidth     : integer := 12;
    addrWidth     : integer := 12);
port (
    aclk          : in std_logic;
    iRawData      : in rData;
    oTpData       : out rTp);
end entity;

architecture arch of data_taps is

    signal d1RawData    :  rData;
    signal d2RawData    :  rData;
    signal wChx0Valid   : std_logic_vector(3 downto 0) := (others => lo);
    signal wChx1Valid   : std_logic_vector(3 downto 0) := (others => lo);
    signal wChx2Valid   : std_logic_vector(3 downto 0) := (others => lo);
    signal wChx3Valid   : std_logic_vector(3 downto 0) := (others => lo);
    signal write_chs    : integer range 0 to 3;
    signal write_s      : std_logic;
    signal write_p      : std_logic;
    signal tap0_data    : std_logic_vector(dataWidth - 1 downto 0) := (others => lo);
    signal tap1_data    : std_logic_vector(dataWidth - 1 downto 0) := (others => lo);
    signal tap2_data    : std_logic_vector(dataWidth - 1 downto 0) := (others => lo);
    signal tap3_data    : std_logic_vector(dataWidth - 1 downto 0) := (others => lo);

begin

write_p         <= hi when (write_s = hi and iRawData.valid = lo) else lo;
wChx0Valid(ch0) <= hi when (write_chs = ch0 and iRawData.valid = hi)  else lo;
wChx0Valid(ch1) <= hi when (write_chs = ch1 and iRawData.valid = hi)  else lo;
wChx0Valid(ch2) <= hi when (write_chs = ch2 and iRawData.valid = hi)  else lo;
wChx0Valid(ch3) <= hi when (write_chs = ch3 and iRawData.valid = hi)  else lo;
oTpData.valid <= hi when (wChx3Valid(ch0) = hi or wChx3Valid(ch1) = hi or wChx3Valid(ch2) = hi or wChx3Valid(ch3) = hi)  else lo;

pipValidP: process (aclk) begin
    if (rising_edge(aclk)) then
        write_s <= iRawData.valid;
    end if;
end process pipValidP;

selChP: process (aclk) begin
    if (rising_edge(aclk) ) then
        if (write_p = hi) then
            if (write_chs = ch3) then
                write_chs <= ch0;
            else
                write_chs <= write_chs + 1;
            end if;
        end if;
    end if;
end process selChP;

pipValidChP: process (aclk) begin
    if (rising_edge(aclk) ) then
        d1RawData     <= iRawData;
        d2RawData     <= d1RawData;
        oTpData.pEof  <= d2RawData.pEof;
        oTpData.pSof  <= d2RawData.pSof;
        oTpData.cord  <= d2RawData.cord;
        wChx1Valid    <= wChx0Valid;
        wChx2Valid    <= wChx1Valid;
        wChx3Valid    <= wChx2Valid;
    end if;
end process pipValidChP;

tap1ReadOutP: process(aclk) begin
    if (rising_edge(aclk) ) then
        if(wChx0Valid(ch0) = hi or wChx1Valid(ch0) = hi or wChx2Valid(ch0) = hi or wChx3Valid(ch0) = hi) then
            oTpData.taps.tp1 <= tap1_data;
            oTpData.taps.tp2 <= tap2_data;
            oTpData.taps.tp3 <= tap3_data;
        elsif(wChx0Valid(ch1) = hi or wChx1Valid(ch1) = hi or wChx2Valid(ch1) = hi or wChx3Valid(ch1) = hi) then
            oTpData.taps.tp1 <= tap2_data;
            oTpData.taps.tp2 <= tap3_data;
            oTpData.taps.tp3 <= tap0_data;
        elsif(wChx0Valid(ch2) = hi or wChx1Valid(ch2) = hi or wChx2Valid(ch2) = hi or wChx3Valid(ch2) = hi) then
            oTpData.taps.tp1 <= tap3_data;
            oTpData.taps.tp2 <= tap0_data;
            oTpData.taps.tp3 <= tap1_data;
        elsif(wChx0Valid(ch3) = hi or wChx1Valid(ch3) = hi or wChx2Valid(ch3) = hi or wChx3Valid(ch3) = hi) then
            oTpData.taps.tp1 <= tap0_data;
            oTpData.taps.tp2 <= tap1_data;
            oTpData.taps.tp3 <= tap2_data;
        else
            oTpData.taps.tp1 <= (others => lo);
            oTpData.taps.tp2 <= (others => lo);
            oTpData.taps.tp3 <= (others => lo);
        end if;
    end if;
end process tap1ReadOutP;

lineD0Inst: tap_buffer
generic map(
    img_width    => img_width,
    dataWidth    => dataWidth,
    addrWidth    => addrWidth)
port map(
    write_clk => aclk,
    write_enb => wChx0Valid(ch0),
    w_address => iRawData.cord.x(addrWidth -1 downto 0),
    idata     => iRawData.data,
    read_clk  => aclk,
    r_address => iRawData.cord.x(addrWidth -1 downto 0),
    odata     => tap0_data);
lineD1Inst: tap_buffer
generic map(
    img_width    => img_width,
    dataWidth    => dataWidth,
    addrWidth    => addrWidth)
port map(
    write_clk => aclk,
    write_enb => wChx0Valid(ch1),
    w_address => iRawData.cord.x(addrWidth -1 downto 0),
    idata     => iRawData.data,
    read_clk  => aclk,
    r_address => iRawData.cord.x(addrWidth -1 downto 0),
    odata     => tap1_data);
lineD2Inst: tap_buffer
generic map(
    img_width    => img_width,
    dataWidth    => dataWidth,
    addrWidth    => addrWidth)
port map(
    write_clk  => aclk,
    write_enb  => wChx0Valid(ch2),
    w_address  => iRawData.cord.x(addrWidth -1 downto 0),
    idata      => iRawData.data,
    read_clk   => aclk,
    r_address  => iRawData.cord.x(addrWidth -1 downto 0),
    odata      => tap2_data);
lineD3Inst: tap_buffer
generic map(
    img_width    => img_width,
    dataWidth    => dataWidth,
    addrWidth    => addrWidth)
port map(
    write_clk  => aclk,
    write_enb  => wChx0Valid(ch3),
    w_address  => iRawData.cord.x(addrWidth -1 downto 0),
    idata      => iRawData.data,
    read_clk   => aclk,
    r_address  => iRawData.cord.x(addrWidth -1 downto 0),
    odata      => tap3_data);
end architecture;