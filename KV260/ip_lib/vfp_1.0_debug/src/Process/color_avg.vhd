-------------------------------------------------------------------------------
--
-- Filename    : color_avg.vhd
-- Create Date : 05062019 [05-06-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;
use work.float_pkg.all;

use work.constants_package.all;
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;


entity color_avg is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end color_avg;

architecture behavioral of color_avg is

    signal int1Rgb          : intChannel;
    signal int2Rgb          : intChannel;
    signal int3Rgb          : intChannel;
    signal int4Rgb          : intChannel;
    signal int5Rgb          : intChannel;
    signal int6Rgb          : intChannel;


    signal intRg6b          : intChannel;
    signal color_limit      : std_logic := '0';
    signal rgbSyncValid     : std_logic_vector(11 downto 0)  := x"000";
	
    signal rgbRed12Max      : integer;
    signal rgbGre12Max      : integer;
    signal rgbBlu12Max      : integer;
	
    signal rgbRed12Min      : integer;
    signal rgbGre12Min      : integer;
    signal rgbBlu12Min      : integer;
	
    signal rgbRed13Max      : integer;
    signal rgbGre13Max      : integer;
    signal rgbBlu13Max      : integer;

    signal rgbRed13Min      : integer;
    signal rgbGre13Min      : integer;
    signal rgbBlu13Min      : integer;
	
	
    signal rgbRedM12Sum      : integer;
    signal rgbGreM12Sum      : integer;
    signal rgbBluM12Sum      : integer;

    signal rgbRedM12Limit   : integer;
    signal rgbGreM12Limit   : integer;
    signal rgbBluM12Limit   : integer;

    signal rgbRedM13Limit   : integer;
    signal rgbGreM13Limit   : integer;
    signal rgbBluM13Limit   : integer;

    signal rgbLimit         : channel;
    signal rgbAvg           : channel_9bi;
	
    signal uFs1Rgb          : rgbToUfRecord;
    signal uFs2Rgb          : rgbToUfRecord;
    signal uFs3Rgb          : rgbToUfRecord;
    signal uFs4Rgb          : rgbToUfRecord;
    signal uFs5Rgb          : rgbToUfRecord;

    signal rgbRedAvg        : ufixed(7 downto 0)    :=(others => '0');
    signal rgbSumRedAvg     : ufixed(9 downto -10)  :=(others => '0');
    signal rgbSumRed        : ufixed(9 downto 0)    :=(others => '0');

    signal rgbGreAvg        : ufixed(7 downto 0)    :=(others => '0');
    signal rgbSumGreAvg     : ufixed(9 downto -10)  :=(others => '0');
    signal rgbSumGre        : ufixed(9 downto 0)    :=(others => '0');

    signal rgbBluAvg        : ufixed(7 downto 0)    :=(others => '0');
    signal rgbSumBluAvg     : ufixed(9 downto -10)  :=(others => '0');
    signal rgbSumBlu        : ufixed(9 downto 0)    :=(others => '0');
    signal rgb1sRedM13Limit   : integer;
    signal rgb2sRedM13Limit   : integer;
	
begin

-----------------------------------------------------------------------------------------------
-- STAGE 1
-----------------------------------------------------------------------------------------------
process (clk,reset)begin
    if (reset = lo) then
        int1Rgb.red    <= 0;
        int1Rgb.green  <= 0;
        int1Rgb.blue   <= 0;
    elsif rising_edge(clk) then
        int1Rgb.red    <= to_integer(unsigned(iRgb.red));
        int1Rgb.green  <= to_integer(unsigned(iRgb.green));
        int1Rgb.blue   <= to_integer(unsigned(iRgb.blue));
        int1Rgb.valid  <= iRgb.valid;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        int2Rgb <= int1Rgb;
        int3Rgb <= int2Rgb;
        int4Rgb <= int3Rgb;
        int5Rgb <= int4Rgb;
        int6Rgb <= int5Rgb;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
	
        rgbRed12Max <= max_select(int1Rgb.red,int2Rgb.red);
        rgbGre12Max <= max_select(int1Rgb.green,int2Rgb.green);
        rgbBlu12Max <= max_select(int1Rgb.blue,int2Rgb.blue);
		
        rgbRed12Min <= min_select(int1Rgb.red,int2Rgb.red);
        rgbGre12Min <= min_select(int1Rgb.green,int2Rgb.green);
        rgbBlu12Min <= min_select(int1Rgb.blue,int2Rgb.blue);
		
		
        rgbRed13Max <= max_select(int1Rgb.red,int3Rgb.red);
        rgbGre13Max <= max_select(int1Rgb.green,int3Rgb.green);
        rgbBlu13Max <= max_select(int1Rgb.blue,int3Rgb.blue);
		
        rgbRed13Min <= min_select(int1Rgb.red,int3Rgb.red);
        rgbGre13Min <= min_select(int1Rgb.green,int3Rgb.green);
        rgbBlu13Min <= min_select(int1Rgb.blue,int3Rgb.blue);
		
    end if;
end process;

--either a value or zero later needed
process (clk) begin
    if rising_edge(clk) then
        rgbRedM12Limit <= rgbRed12Max - rgbRed12Min;
        rgbGreM12Limit <= rgbGre12Max - rgbGre12Min;
        rgbBluM12Limit <= rgbBlu12Max - rgbBlu12Min;
	
        rgbRedM13Limit <= rgbRed13Max - rgbRed13Min;
        rgbGreM13Limit <= rgbGre13Max - rgbGre13Min;
        rgbBluM13Limit <= rgbBlu13Max - rgbBlu13Min;
		
		rgb1sRedM13Limit <= rgbRedM13Limit;
		rgb2sRedM13Limit <= rgb1sRedM13Limit;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        rgbRedM12Sum <= int1Rgb.red + int2Rgb.red;
        rgbGreM12Sum <= int1Rgb.green + int2Rgb.green;
        rgbBluM12Sum <= int1Rgb.blue + int2Rgb.blue;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        rgbAvg.red   <= std_logic_vector(to_unsigned(rgbRedM12Sum,9));
        rgbAvg.green <= std_logic_vector(to_unsigned(rgbGreM12Sum,9));
        rgbAvg.blue  <= std_logic_vector(to_unsigned(rgbBluM12Sum,9));
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
    if (rgb2sRedM13Limit <= 40) then
	    color_limit    <= '1';
		rgbLimit.red     <= std_logic_vector(to_unsigned(intRg6b.red,8));
        rgbLimit.green   <= std_logic_vector(to_unsigned(intRg6b.green,8));
        rgbLimit.blue   <= std_logic_vector(to_unsigned(intRg6b.blue,8));
    else
	    color_limit    <= '0';
        rgbLimit.red   <= std_logic_vector(to_unsigned(int6Rgb.red,8));
        rgbLimit.green   <= std_logic_vector(to_unsigned(int6Rgb.green,8));
        rgbLimit.blue   <= std_logic_vector(to_unsigned(int6Rgb.blue,8));
    end if;
    --if (rgbGreM13Limit <= 40) then
    --    rgbLimit.green   <= std_logic_vector(to_unsigned(intRg6b.green,8));
    --else
    --    rgbLimit.green   <= std_logic_vector(to_unsigned(int5Rgb.green,8));
    --end if;
    --if(rgbBluM13Limit <= 40) then
    --    rgbLimit.blue   <= std_logic_vector(to_unsigned(intRg6b.blue,8));
    --else
    --    rgbLimit.blue   <= std_logic_vector(to_unsigned(int5Rgb.blue,8));
    --end if;
        rgbLimit.valid <= int5Rgb.valid;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        oRgb   <= rgbLimit;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

process (clk) begin
    if rising_edge(clk) then
        uFs2Rgb <= uFs1Rgb;
        uFs3Rgb <= uFs2Rgb;
        uFs4Rgb <= uFs3Rgb;
        uFs5Rgb <= uFs4Rgb;
    end if;
end process;

-----------------------------------------------------------------------------------------------
-- STAGE 1
-----------------------------------------------------------------------------------------------
process (clk,reset)begin
    if (reset = lo) then
        uFs1Rgb.red    <= (others => '0');
        uFs1Rgb.green  <= (others => '0');
        uFs1Rgb.blue   <= (others => '0');
    elsif rising_edge(clk) then
        uFs1Rgb.red    <= to_ufixed(iRgb.red,uFs1Rgb.red);
        uFs1Rgb.green  <= to_ufixed(iRgb.green,uFs1Rgb.green);
        uFs1Rgb.blue   <= to_ufixed(iRgb.blue,uFs1Rgb.blue);
        uFs1Rgb.valid  <= iRgb.valid;
    end if;
end process;

-----------------------------------------------------------------------------------------------
-- STAGE 2
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgbSumRed         <= uFs1Rgb.red + uFs2Rgb.red + uFs3Rgb.red;
        rgbSumGre         <= uFs1Rgb.green + uFs2Rgb.green + uFs3Rgb.green;
        rgbSumBlu         <= uFs1Rgb.blue + uFs2Rgb.blue + uFs3Rgb.blue;
    end if;
end process;

-----------------------------------------------------------------------------------------------
-- STAGE 3
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        if(rgbSumRed > 0)then
            rgbSumRedAvg      <= rgbSumRed / 3.0;
        end if;
        if(rgbSumGre > 0)then
            rgbSumGreAvg      <= rgbSumGre / 3.0;
        end if;
        if(rgbSumBlu > 0)then
            rgbSumBluAvg      <= rgbSumBlu / 3.0;
        end if;
    end if;
end process;

-----------------------------------------------------------------------------------------------
-- STAGE 4
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        rgbRedAvg         <= resize(rgbSumRedAvg,rgbRedAvg);
        rgbGreAvg         <= resize(rgbSumGreAvg,rgbGreAvg);
        rgbBluAvg         <= resize(rgbSumBluAvg,rgbBluAvg);
    end if;
end process;

-----------------------------------------------------------------------------------------------
-- STAGE 5
-----------------------------------------------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then
        intRg6b.red       <= to_integer(to_unsigned(rgbRedAvg,8));
        intRg6b.green     <= to_integer(to_unsigned(rgbGreAvg,8));
        intRg6b.blue      <= to_integer(to_unsigned(rgbBluAvg,8));
    end if;
end process;

--process (clk) begin
--    if rising_edge(clk) then
--        oRgb.red   <= std_logic_vector(to_unsigned(intRg6b.red,8));
--        oRgb.green <= std_logic_vector(to_unsigned(intRg6b.green,8));
--        oRgb.blue  <= std_logic_vector(to_unsigned(intRg6b.blue,8));
--        oRgb.valid <= int5Rgb.valid;
--    end if;
--end process;
-----------------------------------------------------------------------------------------------
-- STAGE 6
-----------------------------------------------------------------------------------------------


process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= iRgb.valid;
        rgbSyncValid(1)  <= rgbSyncValid(0);
        rgbSyncValid(2)  <= rgbSyncValid(1);
        rgbSyncValid(3)  <= rgbSyncValid(2);
        rgbSyncValid(4)  <= rgbSyncValid(3);
        rgbSyncValid(5)  <= rgbSyncValid(4);
        rgbSyncValid(6)  <= rgbSyncValid(5);
        rgbSyncValid(7)  <= rgbSyncValid(6);
        rgbSyncValid(8)  <= rgbSyncValid(7);
        rgbSyncValid(9)  <= rgbSyncValid(8);
        rgbSyncValid(10) <= rgbSyncValid(9);
        rgbSyncValid(11) <= rgbSyncValid(10);
    end if;
end process;



end behavioral;