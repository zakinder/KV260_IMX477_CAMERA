--05062019 [05-06-2019]
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
use work.tbPackage.all;
entity ColorAvg is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end ColorAvg;
architecture behavioral of ColorAvg is
    signal int1Rgb          : intChannel;
    signal int2Rgb          : intChannel;
    signal int3Rgb          : intChannel;
    signal int4Rgb          : intChannel;
    signal int5Rgb          : intChannel;
    signal int6Rgb          : intChannel;
    
    
    signal intRg6b          : intChannel;    
    
    signal rgbSyncValid     : std_logic_vector(11 downto 0)  := x"000";
    signal rgbRedMax        : integer;
    signal rgbGreMax        : integer;
    signal rgbBluMax        : integer;
    signal rgbRed2xMax      : integer;
    signal rgbGre2xMax      : integer;
    signal rgbBlu2xMax      : integer;
    
    signal rgbRedO2Max      : integer;
    signal rgbGreO2Max      : integer;
    signal rgbBluO2Max      : integer;
    
    signal rgbRedMaxLimit   : integer;
    signal rgbGreMaxLimit   : integer;
    signal rgbBluMaxLimit   : integer;
    
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
        rgbRedMax <= max(int1Rgb.red,int3Rgb.red);
        rgbGreMax <= max(int1Rgb.green,int3Rgb.green);
        rgbBluMax <= max(int1Rgb.blue,int3Rgb.blue);
    end if;
end process;


process (clk) begin
    if rising_edge(clk) then 
        rgbRedMaxLimit <= rgbRedMax - int1Rgb.red;
        rgbGreMaxLimit <= rgbGreMax - int1Rgb.green;
        rgbBluMaxLimit <= rgbBluMax - int1Rgb.blue;
    end if;
end process;
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

process (clk) begin
    if rising_edge(clk) then
        oRgb.red   <= std_logic_vector(to_unsigned(intRg6b.red,8));
        oRgb.green <= std_logic_vector(to_unsigned(intRg6b.green,8));
        oRgb.blue  <= std_logic_vector(to_unsigned(intRg6b.blue,8));
        oRgb.valid <= int5Rgb.valid;
    end if;
end process;
-----------------------------------------------------------------------------------------------
-- STAGE 6
-----------------------------------------------------------------------------------------------
-- process (clk) begin
    -- if rising_edge(clk) then 
    -- if (rgbRedMaxLimit <= 40) then
        -- oRgb.red   <= std_logic_vector(to_unsigned(rgbRedMax,8));
    -- else
        -- oRgb.red   <= std_logic_vector(to_unsigned(intRg6b.red,8));
    -- end if;
    -- if (rgbGreMaxLimit <= 40) then
        -- oRgb.green   <= std_logic_vector(to_unsigned(rgbGreO2Max,8));
    -- else
        -- oRgb.green   <= std_logic_vector(to_unsigned(intRg6b.green,8));
    -- end if;
    -- if(rgbBluMaxLimit <= 40) then
        -- oRgb.blue   <= std_logic_vector(to_unsigned(rgbBluO2Max,8));
    -- else
        -- oRgb.blue   <= std_logic_vector(to_unsigned(intRg6b.blue,8));
    -- end if;
        -- oRgb.valid <= int5Rgb.valid;
    -- end if;
-- end process;
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

process (clk) begin
    if rising_edge(clk) then 
        rgbRed2xMax <= rgbRedMax;
        rgbGre2xMax <= rgbGreMax;
        rgbBlu2xMax <= rgbBluMax;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then 
        rgbRedO2Max <= max(int1Rgb.red,rgbRedMax);
        rgbGreO2Max <= max(int1Rgb.green,rgbGreMax);
        rgbBluO2Max <= max(int1Rgb.blue,rgbBluMax);
    end if;
end process;
end behavioral;