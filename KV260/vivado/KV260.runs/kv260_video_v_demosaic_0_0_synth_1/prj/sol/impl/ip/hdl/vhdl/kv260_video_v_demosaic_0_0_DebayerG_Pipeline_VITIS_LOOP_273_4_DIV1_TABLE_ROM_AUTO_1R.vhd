-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
-- Tool Version Limit: 2022.04
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity kv260_video_v_demosaic_0_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R is 
    generic(
             DataWidth     : integer := 10; 
             AddressWidth     : integer := 10; 
             AddressRange    : integer := 1024
    ); 
    port (
          address0      : in std_logic_vector(AddressWidth-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DataWidth-1 downto 0);
          address1      : in std_logic_vector(AddressWidth-1 downto 0); 
          ce1       : in std_logic; 
          q1         : out std_logic_vector(DataWidth-1 downto 0);
          address2      : in std_logic_vector(AddressWidth-1 downto 0); 
          ce2       : in std_logic; 
          q2         : out std_logic_vector(DataWidth-1 downto 0);
          address3      : in std_logic_vector(AddressWidth-1 downto 0); 
          ce3       : in std_logic; 
          q3         : out std_logic_vector(DataWidth-1 downto 0);
          reset     : in std_logic;
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of kv260_video_v_demosaic_0_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R is 

signal address0_tmp : std_logic_vector(AddressWidth-1 downto 0); 
signal address1_tmp : std_logic_vector(AddressWidth-1 downto 0); 
signal address2_tmp : std_logic_vector(AddressWidth-1 downto 0); 
signal address3_tmp : std_logic_vector(AddressWidth-1 downto 0); 
type mem_array is array (0 to AddressRange-1) of std_logic_vector (DataWidth-1 downto 0); 
signal mem0 : mem_array := (
    0 to 1=> "1111111111", 2 => "0111111111", 3 => "0101010101", 4 => "0011111111", 
    5 => "0011001100", 6 => "0010101010", 7 => "0010010010", 8 => "0001111111", 
    9 => "0001110001", 10 => "0001100110", 11 => "0001011101", 12 => "0001010101", 
    13 => "0001001110", 14 => "0001001001", 15 => "0001000100", 16 => "0000111111", 
    17 => "0000111100", 18 => "0000111000", 19 => "0000110101", 20 => "0000110011", 
    21 => "0000110000", 22 => "0000101110", 23 => "0000101100", 24 => "0000101010", 
    25 => "0000101000", 26 => "0000100111", 27 => "0000100101", 28 => "0000100100", 
    29 => "0000100011", 30 => "0000100010", 31 => "0000100001", 32 to 33=> "0000011111", 
    34 => "0000011110", 35 => "0000011101", 36 => "0000011100", 37 => "0000011011", 
    38 to 39=> "0000011010", 40 => "0000011001", 41 to 42=> "0000011000", 43 to 44=> "0000010111", 
    45 to 46=> "0000010110", 47 to 48=> "0000010101", 49 to 51=> "0000010100", 52 to 53=> "0000010011", 
    54 to 56=> "0000010010", 57 to 60=> "0000010001", 61 to 63=> "0000010000", 64 to 68=> "0000001111", 
    69 to 73=> "0000001110", 74 to 78=> "0000001101", 79 to 85=> "0000001100", 86 to 93=> "0000001011", 
    94 to 102=> "0000001010", 103 to 113=> "0000001001", 114 to 127=> "0000001000", 128 to 146=> "0000000111", 
    147 to 170=> "0000000110", 171 to 204=> "0000000101", 205 to 255=> "0000000100", 256 to 341=> "0000000011", 
    342 to 511=> "0000000010", 512 to 1023=> "0000000001" );
signal mem1 : mem_array := (
    0 to 1=> "1111111111", 2 => "0111111111", 3 => "0101010101", 4 => "0011111111", 
    5 => "0011001100", 6 => "0010101010", 7 => "0010010010", 8 => "0001111111", 
    9 => "0001110001", 10 => "0001100110", 11 => "0001011101", 12 => "0001010101", 
    13 => "0001001110", 14 => "0001001001", 15 => "0001000100", 16 => "0000111111", 
    17 => "0000111100", 18 => "0000111000", 19 => "0000110101", 20 => "0000110011", 
    21 => "0000110000", 22 => "0000101110", 23 => "0000101100", 24 => "0000101010", 
    25 => "0000101000", 26 => "0000100111", 27 => "0000100101", 28 => "0000100100", 
    29 => "0000100011", 30 => "0000100010", 31 => "0000100001", 32 to 33=> "0000011111", 
    34 => "0000011110", 35 => "0000011101", 36 => "0000011100", 37 => "0000011011", 
    38 to 39=> "0000011010", 40 => "0000011001", 41 to 42=> "0000011000", 43 to 44=> "0000010111", 
    45 to 46=> "0000010110", 47 to 48=> "0000010101", 49 to 51=> "0000010100", 52 to 53=> "0000010011", 
    54 to 56=> "0000010010", 57 to 60=> "0000010001", 61 to 63=> "0000010000", 64 to 68=> "0000001111", 
    69 to 73=> "0000001110", 74 to 78=> "0000001101", 79 to 85=> "0000001100", 86 to 93=> "0000001011", 
    94 to 102=> "0000001010", 103 to 113=> "0000001001", 114 to 127=> "0000001000", 128 to 146=> "0000000111", 
    147 to 170=> "0000000110", 171 to 204=> "0000000101", 205 to 255=> "0000000100", 256 to 341=> "0000000011", 
    342 to 511=> "0000000010", 512 to 1023=> "0000000001" );


begin 


memory_access_guard_0: process (address0) 
begin
      address0_tmp <= address0;
--synthesis translate_off
      if (CONV_INTEGER(address0) > AddressRange-1) then
           address0_tmp <= (others => '0');
      else 
           address0_tmp <= address0;
      end if;
--synthesis translate_on
end process;

memory_access_guard_1: process (address1) 
begin
      address1_tmp <= address1;
--synthesis translate_off
      if (CONV_INTEGER(address1) > AddressRange-1) then
           address1_tmp <= (others => '0');
      else 
           address1_tmp <= address1;
      end if;
--synthesis translate_on
end process;

memory_access_guard_2: process (address2) 
begin
      address2_tmp <= address2;
--synthesis translate_off
      if (CONV_INTEGER(address2) > AddressRange-1) then
           address2_tmp <= (others => '0');
      else 
           address2_tmp <= address2;
      end if;
--synthesis translate_on
end process;

memory_access_guard_3: process (address3) 
begin
      address3_tmp <= address3;
--synthesis translate_off
      if (CONV_INTEGER(address3) > AddressRange-1) then
           address3_tmp <= (others => '0');
      else 
           address3_tmp <= address3;
      end if;
--synthesis translate_on
end process;

p_rom_access: process (clk)  
begin 
    if (clk'event and clk = '1') then
        if (ce0 = '1') then 
            q0 <= mem0(CONV_INTEGER(address0_tmp)); 
        end if;
        if (ce1 = '1') then 
            q1 <= mem0(CONV_INTEGER(address1_tmp)); 
        end if;
        if (ce2 = '1') then 
            q2 <= mem1(CONV_INTEGER(address2_tmp)); 
        end if;
        if (ce3 = '1') then 
            q3 <= mem1(CONV_INTEGER(address3_tmp)); 
        end if;
    end if;
end process;

end rtl;

