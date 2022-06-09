-------------------------------------------------------------------------------
--
-- Filename    : digital_clock.vhd
-- Create Date : 02072019 [02-07-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.constants_package.all;
use work.vpf_records.all;

--source clock 142.857132 instead 150 = half p 71428566 else if 75= 37500000*2
--source clock 100Mhz = half p 50000000 but to sec in per ms 50000

entity digital_clock is
port (
    clk     : in std_logic;
    oSec    : out std_logic_vector(5 downto 0);
    oMin    : out std_logic_vector(5 downto 0);
    oHou    : out std_logic_vector(4 downto 0));
end digital_clock;

architecture Behavioral of digital_clock is

constant HALFPERIOD     : integer   := 71428566;--@142.8MHz= 1/2sec for HARDWARE
constant TESTHALFPERIOD : integer   := 50000;   --@100MHz= 1/2ms

signal sec,min,hour     : integer range 0 to 60 :=0;

signal count            : integer   := 1;

signal sclk             : std_logic :='0';

begin

oSec    <= conv_std_logic_vector(sec,6);
oMin    <= conv_std_logic_vector(min,6);
oHou    <= conv_std_logic_vector(hour,5);

process(clk)begin
    if rising_edge(clk) then
        count <=count + 1;
        if(count = HALFPERIOD) then
            sclk     <= not(sclk);
            count    <= 1;
        end if;
    end if;
end process;

process(sclk)begin
    if rising_edge(sclk) then
        sec <= sec + 1;
        if(sec = 59) then
            sec<=0;
            min <= min + 1;
            if(min = 59) then
                hour <= hour + 1;
                min <= 0;
                if(hour = 23) then
                    hour <= 0;
                end if;
            end if;
        end if;
    end if;
end process;

end Behavioral;