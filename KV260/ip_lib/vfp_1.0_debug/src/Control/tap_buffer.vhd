-------------------------------------------------------------------------------
--
-- Filename    : tap_buffer.vhd
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

entity tap_buffer is
generic (
    img_width    : integer := 4095;
    dataWidth    : integer := 12;
    addrWidth    : integer := 12);
port (
    write_clk    : in std_logic;
    write_enb    : in std_logic;
    w_address    : in std_logic_vector(addrWidth - 1 downto 0);
    idata        : in std_logic_vector(dataWidth - 1 downto 0);
    read_clk     : in std_logic;
    r_address    : in std_logic_vector(addrWidth - 1 downto 0);
    odata        : out std_logic_vector(dataWidth - 1 downto 0));
end entity;
architecture arch of tap_buffer is
    type ram_type is array (0 to img_width) of std_logic_vector (dataWidth - 1 downto 0);
    signal rowbuffer    : ram_type := (others => (others => '0'));
    signal oregister    : std_logic_vector(dataWidth - 1 downto 0);
    signal write1s_enb  : std_logic;
    signal write2s_enb  : std_logic;
    signal write3s_enb  : std_logic;
    signal write_or_enb : std_logic;
begin
process (write_clk) begin
    if rising_edge(write_clk) then
        write1s_enb <= write_enb;
        write2s_enb <= write1s_enb;
        write3s_enb <= write2s_enb;
    end if;
end process;
write_or_enb <= write_enb or write3s_enb;
process (write_clk) begin
if rising_edge(write_clk) then
    if (write_or_enb ='1') then
        rowbuffer(to_integer(unsigned(w_address))) <= idata;
    end if;
end if;
end process;
process (read_clk) begin
if rising_edge(read_clk) then
    oregister <= rowbuffer(to_integer(unsigned(r_address)));
end if;
end process;
process (read_clk) begin
if rising_edge(read_clk) then
    odata <= oregister;
end if;
end process;
end architecture;