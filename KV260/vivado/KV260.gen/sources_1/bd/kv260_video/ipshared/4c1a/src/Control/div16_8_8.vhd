library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.unsigned;

entity div16_8_8 is
	generic(
		a_width			: positive := 17;
		b_width			: positive := 8;
		result_width	: positive := 9
	);
	port (
		clk        : in  std_logic;
		en         : in  std_logic;
		rstn       : in  std_logic;
		a          : in  std_logic_vector( a_width-1 downto 0);
		b          : in  std_logic_vector( b_width-1 downto 0);
		result     : out std_logic_vector( result_width-1 downto 0)	
	);
end entity div16_8_8;

architecture rtl of div16_8_8 is

    type unsigned_8_array  is array(natural range <>) of unsigned( 7 downto 0);
	type unsigned_16_array is array(natural range <>) of unsigned(15 downto 0);

	signal r_remainder 		: unsigned_16_array(1 to 9);
	signal r_shifted_b 		: unsigned_16_array(1 to 9);
	signal r_result    		: unsigned_8_array (1 to 9);
	signal r_result_signed 	: signed(8 downto 0);
	signal r_sign      		: std_logic_vector(1 to 9);
	signal r_en		     	: std_logic_vector(1 to 9);
	
------------------------------------------------------------------------------------------
  
function is_positive (in_zahl : in signed) return std_logic is		-- check the input a 

	begin
		if in_zahl > 0 then -- check the input a positive or negative
			return '1';
		else
			return '0';
		end if;
	end;
		
------------------------------------------------------------------------------------------
	
function right_shift_0 (in_vector : in std_logic_vector) return std_logic_vector is	
        variable result : std_logic_vector(1 to 9);
	begin
        for i in 1 to 8 loop
            result(i+1) := in_vector(i);
        end loop;
        result(1) := '0'; -- shift '1' in s_sign vector (positive result)
        return result;
	end;
		
------------------------------------------------------------------------------------------
	
function right_shift_1 (in_vector : in std_logic_vector) return std_logic_vector is	
        variable result : std_logic_vector(1 to 9);
	begin
        for i in 1 to 8 loop
            result(i+1) := in_vector(i);
        end loop;
        result(1) := '1'; -- shift '1' in s_sign vector (negative result)
        return result;
	end;
		
-------------------------------------------------------------------------------------------

function right_shift_0_for_b (in_unsigned : in unsigned) return unsigned is	
        variable result : unsigned(15 downto 0);
	begin
        for i in 14 downto 0 loop
            result(i) := in_unsigned(i+1);
        end loop;
        result(15) := '0'; -- shift '0' in r_shifted_b 
        return result;
	end;
		
------------------------------------------------------------------------------------------

begin

	process(clk, rstn, en)
		variable v_result 	: unsigned( 8 downto 1);
        variable a_signed 	: signed(16 downto 0);
        variable a_unsigned : unsigned(15 downto 0);
 
	begin
		if rstn = '0' then
	
	        -- student code here
	        -- initialize the result register
            r_result <= (others=>(others=>'0'));
            r_result_signed <= (others=>'0');
            -- use lower 8 digits to append zero to divisor
            r_en <= (others=>'0');
            -- student code until here
		elsif rising_edge(clk) then
		
    		-- student code here
            if en = '1' then
                -- push the dividend in r_remainder, 
                -- if dividend is positive, no change,
                -- store the sign '0' in r_sign
                if is_positive(signed(a)) = '1' then
                    a_unsigned := unsigned(a(15 downto 0));
                    r_remainder(1) <= a_unsigned;
                    r_sign <= right_shift_0(r_sign);
                -- if divided is negative, changes to absolute for calculation,   
                -- finally perform the result to negative,
                -- store the sign '1' in r_sign
                elsif is_positive(signed(a)) = '0' then
                    a_signed := abs(signed(a));
                    r_remainder(1) <= unsigned(a_signed(15 downto 0));
                    r_sign <= right_shift_1(r_sign);
                end if; 
                -- push the divisor in r_shifted_b, 
                -- append zeros to divisor to apply shift and subtract algorithm
                r_shifted_b(1) <= unsigned(b & r_en(1 to 8));
                
                -- after one clock the highest digit becomes '1'
                r_en(9) <= '1';
              
                -- pipeline structure
                -- the highest digit of r_en controls pipeline, not to execute before the transmission of signal
                if r_en(9) = '1' then
                    for i in 2 to result_width loop
                        -- the first comparison result is not needed (must be 0),
                        -- direct to the second comparsion
                        v_result := r_result(i-1);
                        -- if divided small than divisor,
                        -- then implement with shift registers,
                        -- this digit of the register of result set '0'  
                        if r_remainder(i-1) < r_shifted_b(i-1) then
                            r_remainder(i) <= r_remainder(i-1);
                            r_shifted_b(i) <= right_shift_0_for_b(r_shifted_b(i-1));
                            v_result := shift_left(v_result,1);
                            r_result(i) <= v_result;
                        -- until divided large than divisor,
                        -- then implement the subtraction,
                        -- this digit of the register of result set '1' 
                        elsif r_remainder(i-1) >= r_shifted_b(i-1) then
                            r_remainder(i) <= r_remainder(i-1) - r_shifted_b(i-1);
                            r_shifted_b(i) <= right_shift_0_for_b(r_shifted_b(i-1));
                            v_result := shift_left(v_result,1) + 1;
                            r_result(i) <= v_result;
                        end if;
                    end loop;

                
                    -- the last implementation only set the bit of r_result,
                    -- but not shift register anymore  
                    -- divided small than divisor,
                    -- this digit of the register of result set '0'  
                    if r_remainder(result_width) < r_shifted_b(result_width) then
                        v_result := r_result(result_width);
                        v_result := shift_left(v_result,1);
                    -- divided large than divisor,
                    -- this digit of the register of result set '1' 
                    elsif r_remainder(result_width) >= r_shifted_b(result_width) then
                        v_result := r_result(result_width);
                        v_result := shift_left(v_result,1) + 1;
                    end if;
                end if;
                            
                -- after each clock give a result with sign,
                -- the result is correct after each 9 implementations
                -- if the result should be positive
                if r_sign(9) = '0' then
                    -- the binary representation is its true value
                    r_result_signed <= signed(r_sign(9) & v_result); 
                -- if the result should be negative,
                -- and the temporary result is also 0,
                -- it will appear that conversion beyond the bit limit,
                -- it should be artificial corrected 
                elsif r_sign(9) = '1' and v_result = 0 then
                    r_result_signed <= signed('0' & v_result);
                -- else the other situation with a normal negative result
                elsif r_sign(9) = '1' and v_result /= 0 then
                    -- calculate the complement representation 
                    r_result_signed <= signed(r_sign(9) & (not v_result + 1));
                end if;
            end if;
			-- student code until here
		end if;
	end process;
	
	result <= std_logic_vector(r_result_signed);

end architecture rtl;