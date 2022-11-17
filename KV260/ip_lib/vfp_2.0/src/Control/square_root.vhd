--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--entity square_root is port( 
--   clock      : in std_logic;
--   rst_l      : in std_logic;
--   data_in    : in unsigned(31 downto 0); 
--   data_out   : out unsigned(15 downto 0)); 
--end square_root;
--
--
--architecture behaviour of square_root  is
--   function  sqrt  ( d : UNSIGNED ) return UNSIGNED is
--   variable a : unsigned(31 downto 0):=d;  --original input.
--   variable q : unsigned(15 downto 0):=(others => '0');  --result.
--   variable left,right,r : unsigned(17 downto 0):=(others => '0');  --input to adder/sub.r-remainder.
--   variable i : integer:=0;
--   begin
--   for i in 0 to 15 loop
--   right(0):='1';
--   right(1):=r(17);
--   right(17 downto 2):=q;
--   left(1 downto 0):=a(31 downto 30);
--   left(17 downto 2):=r(15 downto 0);
--   a(31 downto 2):=a(29 downto 0);  --shifting by 2 bit.
--   if ( r(17) = '1') then
--   r := left + right;
--   else
--   r := left - right;
--   end if;
--   q(15 downto 1) := q(14 downto 0);
--   q(0) := not r(17);
--   end loop; 
--   return q;
--   end sqrt;
--   
--   signal rgb_data : std_logic_vector(31 downto 0);
--   
--begin
--
--sqRoot : process (clock, rst_l) begin
-- if (rst_l = '0') then
--	data_out <=(others => '0');
-- elsif rising_edge(clock) then
--   data_out <= sqrt (data_in);
-- end if;
--end process sqRoot;
--
--
--end behaviour;

----------------------------------------------------------------------------------------------------
-- Component   : square_root
-- Author      : pwkolas
----------------------------------------------------------------------------------------------------
-- File        : square_root.vhd
-- Mod. Date   : XX.XX.XXXX
-- Version     : 1.00
----------------------------------------------------------------------------------------------------
-- Description : Square root calculator.
--               Based on
--               "A New Non-Restoring Square Root Algorithm and Its VLSI Implementations"
--
----------------------------------------------------------------------------------------------------
-- Modification History :
--
----------------------------------------------------------------------------------------------------
-- Comments :
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity square_root is
   generic (
      data_width : integer := 32);
   port (
      clock     : in  std_logic;
      rst_l     : in  std_logic;
      data_in   : in  std_logic_vector(data_width-1 downto 0);
      data_out  : out std_logic_vector((data_width/2)-1 downto 0));
end entity square_root;

architecture squareRoot_pipe_rtl of square_root is

   constant C_ALU_W  : integer := ((data_width/2) + 2);
   constant C_PIPE_L : integer := data_width/2;
   constant C_OFFSET : integer := 3;    -- width of start vectors going  to ALU

   type t_arr_pipe_x_data is array (C_PIPE_L-1 downto 0) of unsigned(data_width-1 downto 0);
   signal a_data : t_arr_pipe_x_data;   -- (D)
   signal a_R    : t_arr_pipe_x_data;   -- (R)

   type t_arr_pipe_x_alu is array (C_PIPE_L-1 downto 0) of unsigned(C_ALU_W-1 downto 0);

   type t_arr_pipe_x_res is array (C_PIPE_L-1 downto 0) of unsigned(data_width/2-1 downto 0);
   signal a_Q : t_arr_pipe_x_res;       -- (ALU Q out)

   signal nextOp : std_logic_vector(C_PIPE_L-1 downto 0);

begin
   sqrt_p : process (clock, rst_l)
      variable va_AluInR : t_arr_pipe_x_alu;  -- (ALU R in)
      variable va_AluInQ : t_arr_pipe_x_alu;  -- (ALU Q in)
      variable va_AluOut : t_arr_pipe_x_alu;  -- (ALU Q out)
   begin
      if (rst_l = '0') then
         a_data    <= (others => (others => '0'));
         a_R       <= (others => (others => '0'));
         a_Q       <= (others => (others => '0'));
         va_AluInR := (others => (others => '0'));
         va_AluInQ := (others => (others => '0'));
         va_AluOut := (others => (others => '0'));
         nextOp    <= (others => '0');
      elsif rising_edge(clock) then
         -- stage 0 start conditions, ALU inputs
         va_AluInR(0)             := (others => '0');
         va_AluInR(0)(1 downto 0) := unsigned(data_in(data_width-1 downto data_width-1-1));
         va_AluInQ(0)             := (others => '0');
         va_AluInQ(0)(0)          := '1';

         -- stage 0 calculations
         va_AluOut(0) := va_AluInR(0) - va_AluInQ(0);

         -- stage 0 result registers, ALU output
         a_data(0)                              <= shift_left(unsigned(data_in), 2);
         a_R(0)                                 <= (others => '0');
         a_R(0)(data_width-1 downto data_width-1-1) <= va_AluOut(0)(1 downto 0);
         a_Q(0)                                 <= (others => '0');
         a_Q(0)(0)                              <= not va_AluOut(0)(2);
         nextOp(0)                              <= not va_AluOut(0)(2);

         -- next stages
         for i in 1 to C_PIPE_L-1 loop
            -- prepare inputs for next stage
            va_AluInR(i)                            := (others => '0');
            va_AluInR(i)(C_OFFSET+i-1 downto 2)     := a_R(i-1)(data_width-(i-1)-1 downto data_width-(2*i));
            va_AluInR(i)(2-1 downto 0)              := a_data(i-1)(data_width-1 downto data_width-1-1);
            va_AluInQ(i)                            := (others => '0');
            va_AluInQ(i)(C_OFFSET+(i-1)-1 downto 2) := a_Q(i-1)(i-1 downto 0);
            va_AluInQ(i)(1)                         := not a_Q(i-1)(0);
            va_AluInQ(i)(0)                         := '1';

            -- ALU ADD/SUB
            if (nextOp(i-1) = '1') then
               va_AluOut(i) := va_AluInR(i) - va_AluInQ(i);
            else
               va_AluOut(i) := va_AluInR(i) + va_AluInQ(i);
            end if;

            -- result registers
            a_data(i)                                    <= shift_left(unsigned(a_data(i-1)), 2);
            a_R(i)                                       <= (others => '0');
            a_R(i)(data_width-i-1 downto data_width-2*(i+1)) <= va_AluOut(i)(i+1 downto 0);
            a_Q(i)                                       <= shift_left(unsigned(a_Q(i-1)), 1);
            a_Q(i)(0)                                    <= not va_AluOut(i)(i+2);
            nextOp(i)                                    <= not va_AluOut(i)(i+2);

         end loop;
      end if;
   end process;

   data_out <= std_logic_vector(a_Q(C_PIPE_L-1));

end architecture squareRoot_pipe_rtl;

