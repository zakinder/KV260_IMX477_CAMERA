library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
use work.tbPackage.all;
entity kernel1Read is
generic (
    s_data_width  : integer := 16;
    input_file    : string  := "input_image");
port (
    clk             : in std_logic;
    reset           : in std_logic;
    kSet1Out        : out  coeffData);
end kernel1Read;
architecture Behavioral of kernel1Read is
constant projFold   : string := "Z:/ZEDBOARD/doc";
constant backSlash  : string := "/";
file test_vector    : text open read_mode is projFold&backSlash&input_file&".txt";
constant NUM_COL                : integer := 9;
type t_integer_array		    is array(integer range <> )  of real;
begin
p_read : process(reset,clk)
variable row                    : line;
variable v_data_read            : t_integer_array(1 to NUM_COL);
variable v_data_row_counter     : integer := 0;
begin
    if(reset='0') then
        v_data_row_counter     := 0;
        v_data_read            := (others=> 0.0);
    elsif(rising_edge(clk)) then
        if(not endfile(test_vector)) then
            v_data_row_counter := v_data_row_counter + 1;
            readline(test_vector,row);
        end if;
        for kk in 1 to NUM_COL loop
            read(row,v_data_read(kk));
        end loop;
        kSet1Out.k1    <= (v_data_read(1));
        kSet1Out.k2    <= (v_data_read(2));
        kSet1Out.k3    <= (v_data_read(3));
        kSet1Out.k4    <= (v_data_read(4));
        kSet1Out.k5    <= (v_data_read(5));
        kSet1Out.k6    <= (v_data_read(6));
        kSet1Out.k7    <= (v_data_read(7));
        kSet1Out.k8    <= (v_data_read(8));
        kSet1Out.k9    <= (v_data_read(9));
    end if;
end process p_read;
end Behavioral;