-------------------------------------------------------------------------------
-- RGB to HSV Converter
--
-- DESCRIPTION
--
-- Convert RGB input color to HSV color space
--
-- HSV outputs are all 8 bit unsigned values
-- (hue circle has 180 divisions)
--
-- Saturated outputs or invalid hues have S=0
--
-- VERSION SPECIFIC INFORMATION
--
-- Author: Matt Diehl
-- This was written directly from OpenCV code, translated to hardware, so it
-- should output the exact same values for the same inputs :)
-- Other groups in 2009 and earlier are using a strange converter which gives
-- wrong HSV888 values for the RGB
-- H: 0 - 179
-- S: 0 - 255
-- V: 0 - 255
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

-- Uncomment the following lines to use the declarations that are
-- provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hsv_conv is
port (
	clk : IN std_logic;
	reset : IN std_logic;
	valid_in : IN std_logic;
	R : IN std_logic_vector(7 downto 0);
	G : IN std_logic_vector(7 downto 0);
	B : IN std_logic_vector(7 downto 0);
	H : OUT std_logic_vector(7 downto 0);
	S : OUT std_logic_vector(7 downto 0);
	V : OUT std_logic_vector(7 downto 0);
	valid_out : OUT std_logic);
end hsv_conv;

architecture fixedArch of hsv_conv is

	-- Table of 256 inverses in 8.16 fixed point
	component inv_table is
		port (
			value_A : in std_logic_vector(7 downto 0);
			value_B : in std_logic_vector(7 downto 0);
			inverse_A : out std_logic_vector(23 downto 0);
			inverse_B : out std_logic_vector(23 downto 0)
		);
	end component;

	constant HSV_SHIFT		: integer := 12;

	--registers for 1st stage results
	signal r1_reg			: std_logic_vector(8 downto 0);
	signal g1_reg			: std_logic_vector(8 downto 0);
	signal b1_reg			: std_logic_vector(8 downto 0);
	signal v1_reg			: std_logic_vector(7 downto 0);		
	signal v1_next			: std_logic_vector(7 downto 0);		--(max(r,g,b))
	signal maxIsR_reg		: std_logic;
	signal maxIsR_next		: std_logic;
	signal maxIsG_reg		: std_logic;
	signal maxIsG_next		: std_logic;
	signal diff1_reg		: std_logic_vector(7 downto 0);	
	signal diff1_next		: std_logic_vector(7 downto 0);	--(max-min)
	signal valid1_reg		: std_logic;
	
	signal minVal			:std_logic_vector(7 downto 0);

	--registers for 2nd stage results
	signal h2_reg			: std_logic_vector(9 downto 0);	
	signal h2_next			: std_logic_vector(9 downto 0);	--maxIsR?(g1-b1): maxIsG?(b1-r1+diff1<<1): (r1-g1+diff<<2)
	signal s2_reg			: std_logic_vector(23 downto 0);		
	signal s2_next			: std_logic_vector(23 downto 0);		--(diff1*div_table(v1)>>hsv_shift)
	signal v2_reg			: std_logic_vector(7 downto 0);		
	signal diff_inv2_reg		: std_logic_vector(28 downto 0);	
	signal diff_inv2_next		: std_logic_vector(28 downto 0);	--(div_table(diff1)*15)
	signal diff2_reg		: std_logic_vector(7 downto 0);	
	signal diff2_next		: std_logic_vector(7 downto 0);	--same as last
	signal valid2_reg		: std_logic;

	--registers for 3rd stage results
	signal h3_1_reg			: std_logic_vector(38 downto 0);	--h2*diff2
	signal h3_1_next		: std_logic_vector(38 downto 0);	--h2*diff2
	signal h3_2_reg			: std_logic_vector(8 downto 0);	--h2<0?180:0
	signal h3_2_next		: std_logic_vector(8 downto 0);	--h2<0?180:0
	signal s3_reg			: std_logic_vector(7 downto 0);		--same as last stage
	signal s3_next			: std_logic_vector(7 downto 0);		--(diff1*div_table(v1)>>hsv_shift)
	signal v3_reg			: std_logic_vector(7 downto 0);		--same as last stage
	signal valid3_reg		: std_logic;

	--registers for 4th stage results
	signal h4_reg			: std_logic_vector(7 downto 0);		--(h3_1+(1<<(hsv_shift+6)))>>(7+hsv_shift)  +  h3_2
	signal h4_next			: std_logic_vector(7 downto 0);		--(h3_1+(1<<(hsv_shift+6)))>>(7+hsv_shift)  +  h3_2
	signal s4_reg			: std_logic_vector(7 downto 0);		--same as last stage
	signal v4_reg			: std_logic_vector(7 downto 0);		--same as last stage
	signal valid4_reg		: std_logic;
	
	-- Unsigned inverses [0, 1/255] in 8.16 fixed point
	signal diff_inv			: std_logic_vector(23 downto 0);
	signal max_inv			: std_logic_vector(23 downto 0);
	
	-- signals for multiplications:
	signal H_int1			: std_logic_vector(32 downto 0); -- 9.16 result
	signal H_int2			: std_logic_vector(38 downto 0); -- 9.16 result
	signal H_int3			: std_logic_vector(19 downto 0); -- 9.16 result

	-- Internal Signals for Input
	signal R_int			: std_logic_vector(8 downto 0);
	signal G_int			: std_logic_vector(8 downto 0);
	signal B_int			: std_logic_vector(8 downto 0);
	signal valid0			: std_logic;


begin

	-- Input Register
	process(clk, reset)
	begin
		if clk'event and clk='1' then
			if reset = '0' then
				R_int <= (others => '0');
				G_int <= (others => '0');
				B_int <= (others => '0');
				valid0 <= '0';
			else				 
				valid0 <= valid_in;
				if valid_in = '1' then
					R_int <= '0' & R;
					G_int <= '0' & G;
					B_int <= '0' & B;
				end if;
			end if;
		end if;
	end process;

	-------------------------------------------------------------------
	-- First Stage Registers
	process(clk, reset)
	begin
		if clk'event and clk='1' then
			if reset = '0' then
				r1_reg		<= (others => '0');
				g1_reg		<= (others => '0');
				b1_reg		<= (others => '0');
				v1_reg		<= (others => '0');
				maxIsR_reg	<= '0';
				maxIsG_reg	<= '0';
				diff1_reg	<= (others => '0');
				valid1_reg	<= '0';
			else				 
				r1_reg		<= R_int;
				g1_reg		<= G_int;
				b1_reg		<= B_int;
				v1_reg		<= v1_next;			--(max(r,g,b))
				maxIsR_reg	<= maxIsR_next;
				maxIsG_reg	<= maxIsG_next;
				diff1_reg	<= diff1_next;		--(max-min)
				valid1_reg	<= valid0;
			end if;
		end if;
	end process;

	-- First Stage of Pipeline
	process(R_int, G_int, B_int, v1_next, minVal, valid0, maxIsR_reg, maxIsG_reg, v1_reg)
	begin
		maxIsR_next	<= maxIsR_reg;
		maxIsG_next	<= maxIsG_reg;
		minVal		<= minVal;
		v1_next		<= v1_reg;
		if valid0 = '1' then
			maxIsR_next	<= '0';
			maxIsG_next	<= '0';
			minVal		<= B_int(minVal'length-1 downto 0);
			v1_next		<= B_int(v1_next'length-1 downto 0);				--(max(r,g,b))
			--calculate V by figuring the max value
			if R_int >= G_int then
				if R_int >= B_int then
					maxIsR_next	<= '1';
					v1_next		<= R_int(v1_next'length-1 downto 0);
				end if;
			else
				if G_int >= B_int then
					maxIsG_next	<= '1';
					v1_next		<= G_int(v1_next'length-1 downto 0);
				end if;
			end if;
			
			--calculate the min
			if R_int < G_int then
				if R_int < B_int then
					minVal	<= R_int(minVal'length-1 downto 0);
				end if;
			else
				if G_int < B_int then
					minVal	<= G_int(minVal'length-1 downto 0);
				end if;
			end if;
			
			diff1_next	<= (v1_next) - (minVal);		--(max-min)
		end if;
	end process;

	
	-- Look up inverse values in ROM
	invTable : inv_table
	port map (
		value_A => v1_reg,
		value_B => diff1_reg,
		inverse_A => max_inv,
		inverse_B => diff_inv
	);
	
	-------------------------------------------------------------------
	-- Second Stage Registers
	process(clk, reset)
	begin
		if clk'event and clk='1' then
			if reset = '0' then
				h2_reg		<= (others => '0');
				s2_reg		<= (others => '0');
				v2_reg		<= (others => '0');
				diff_inv2_reg	<= (others => '0');
				diff2_reg	<= (others => '0');
				valid2_reg	<= '0';
			else				 
				h2_reg		<= h2_next;			--maxIsR?(g1-b1): maxIsG?(b1-r1+diff1<<1): (r1-g1+diff<<2)
				s2_reg		<= s2_next;			--div_table(v1)
				v2_reg		<= v1_reg;
				diff_inv2_reg	<= diff_inv2_next;		--(div_table(diff1)*15)
				diff2_reg	<= diff2_next;
				valid2_reg	<= valid1_reg;
			end if;
		end if;
	end process;

	-- Second Stage of Pipeline
	process(max_inv, diff_inv, r1_reg, g1_reg, b1_reg, maxIsR_reg, maxIsG_reg, diff1_reg, valid1_reg, h2_reg, s2_reg, diff_inv2_reg, diff2_reg)
	begin		
		h2_next <= h2_reg;
		s2_next <= s2_reg;
		diff_inv2_next <= diff_inv2_reg;
		diff2_next <= diff2_reg;
		if valid1_reg = '1' then
			--calcu h2_next  --maxIsR?(g1-b1): maxIsG?(b1-r1+diff1<<1): (r1-g1+diff<<2)
			if maxIsR_reg = '1' then --red is max:
				h2_next		<= ('0' & g1_reg) - ('0' & b1_reg);
			elsif maxIsG_reg = '1' then --green is max value:
				h2_next		<= (('0' & b1_reg) - ('0' & r1_reg) + ('0' & diff1_reg(diff1_reg'length-1 downto 0) & '0') );
			else --blue is the max value:
				h2_next		<= ('0' & r1_reg) - ('0' & g1_reg) + (diff1_reg(diff1_reg'length-1 downto 0) & "00");
			end if;
			
			--calculate s2_next	--(diff1*div_table(v1)>>hsv_shift)
			s2_next			<= max_inv;
			diff2_next		<= diff1_reg;
			--calculate diff_inv2_next	--(div_table(diff1)*15)
			diff_inv2_next		<= diff_inv*std_logic_vector(to_signed(15,5));
		end if;
		
	end process;

	
	-------------------------------------------------------------------
	-- Third Stage Registers
	process(clk, reset)
	begin
		if clk'event and clk='1' then
			if reset = '0' then
				h3_1_reg	<= (others => '0');
				h3_2_reg	<= (others => '0');
				s3_reg		<= (others => '0');
				v3_reg		<= (others => '0');
				valid3_reg	<= '0';
			else				 
				h3_1_reg	<= h3_1_next;		--h2*diff2
				h3_2_reg	<= h3_2_next;		--h2<0?180:0
				s3_reg		<= s3_next;			--(diff1*s2_reg>>hsv_shift)
				v3_reg		<= v2_reg;			--same as last stage
				valid3_reg	<= valid2_reg;
			end if;
		end if;
	end process;

	-- Third Stage of Pipeline
	process(h2_reg, diff_inv2_reg, H_int1, diff2_reg, s2_reg, valid2_reg, s3_reg, h3_1_reg, h3_2_reg)
	begin
		s3_next <= s3_reg;
		h3_1_next <= h3_1_reg;
		h3_2_next <= h3_2_reg;
		H_int1			<= (('0'&diff2_reg) * s2_reg);
		if valid2_reg = '1' then
			s3_next			<= H_int1(s3_next'length+HSV_SHIFT-1 downto HSV_SHIFT);
			--calculate h3_1_next
			h3_1_next		<= h2_reg * diff_inv2_reg;	--h2*diff2
			
			--calculate h3_2_next
			if h2_reg(h2_reg'length-1) = '1' then --it's less than 0
				h3_2_next	<= std_logic_vector(to_signed(180,9));	--h2<0?180:0
			else
				h3_2_next	<= (others => '0');
			end if;
		end if;
	end process;



	-------------------------------------------------------------------
	-- Fourth Stage Registers
	process(clk, reset)
	begin
		if clk'event and clk='1' then
			if reset = '0' then
				h4_reg		<= (others => '0');
				s4_reg		<= (others => '0');
				v4_reg		<= (others => '0');
				valid4_reg	<= '0';
			else				 
				h4_reg		<= h4_next;			--(h3_1+(1<<(hsv_shift+6)))>>(7+hsv_shift)  +  h3_2
				s4_reg		<= s3_reg;			--same as last stage
				v4_reg		<= v3_reg;			--same as last stage
				valid4_reg	<= valid3_reg;
			end if;
		end if;
	end process;

	-- Fourth Stage of Pipeline
	process(h3_1_reg, h3_2_reg, H_int2, H_int3, valid3_reg, h4_reg)
	begin
		h4_next <= h4_reg;
		H_int2		<= h3_1_reg + ( '0' & '1' & std_logic_vector(to_signed(0,HSV_SHIFT+6))); -- need to make sure the '0' is first so it's positive
		H_int3		<= h3_2_reg + H_int2(H_int2'length - 1 downto HSV_SHIFT+7);
		if valid3_reg = '1' then
			--(h3_1+(1<<(hsv_shift+6)))>>(7+hsv_shift)  +  h3_2
			h4_next		<= H_int3(h4_next'length-1 downto 0);
		end if;
	end process;

	H			<= h4_reg;
	S			<= s4_reg;
	V			<= v4_reg;
	valid_out	<= valid4_reg;

end fixedArch;