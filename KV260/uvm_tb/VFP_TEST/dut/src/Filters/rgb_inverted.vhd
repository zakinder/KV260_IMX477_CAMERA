library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;
use work.float_pkg.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity rgb_inverted is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in  channel;
    oRgb           : out channel;
    oRgbInverted   : out channel;
    oRgbFiltered   : out channel);
end rgb_inverted;
architecture behavioral of rgb_inverted is
    signal s1Rgb          : channel;
    signal s2Rgb          : channel;
    signal s3Rgb          : channel;
    signal s4Rgb          : channel;
    signal uFs1Rgb        : rgbToUfRecord;
    signal uFs2Rgb        : rgbToU1MSBfRecord;
    signal uFs3Rgb        : rgbToUfRecord;
    signal uFs4Rgb        : rgbToUfRecord;
    signal rgbMaxVal      : ufixed(7 downto 0) :=(others => '0');
    signal valid1xB       : std_logic := '0';
    signal aBlueGreenVal  : ufixed(8 downto 0) :=(others => '0');
    signal aBlueRedVal    : ufixed(8 downto 0) :=(others => '0');
    signal aRgbDeltaVal   : ufixed(9 downto 0) :=(others => '0');
begin
rgbMaxVal <= to_ufixed (255.0,rgbMaxVal);
process (clk) begin
    if rising_edge(clk) then 
        s1Rgb        <= iRgb;
        s2Rgb        <= s1Rgb;
        s3Rgb        <= s2Rgb;
        s4Rgb        <= s3Rgb;
    end if;
end process;
process (clk,reset)begin
    if (reset = lo) then
        uFs1Rgb.red    <= (others => '0');
        uFs1Rgb.green  <= (others => '0');
        uFs1Rgb.blue   <= (others => '0');
        uFs1Rgb.valid  <= lo;
    elsif rising_edge(clk) then 
        uFs1Rgb.red    <= to_ufixed(iRgb.red,uFs1Rgb.red);
        uFs1Rgb.green  <= to_ufixed(iRgb.green,uFs1Rgb.green);
        uFs1Rgb.blue   <= to_ufixed(iRgb.blue,uFs1Rgb.blue);
        uFs1Rgb.valid  <= iRgb.valid;
    end if; 
end process;
process (clk) begin
    if rising_edge(clk) then 
        uFs2Rgb.red        <= rgbMaxVal - uFs1Rgb.red;
        uFs2Rgb.green      <= rgbMaxVal - uFs1Rgb.green;
        uFs2Rgb.blue       <= rgbMaxVal - uFs1Rgb.blue;
        uFs2Rgb.valid      <= uFs1Rgb.valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then 
        uFs3Rgb.red        <= resize(uFs2Rgb.red,uFs3Rgb.red);
        uFs3Rgb.green      <= resize(uFs2Rgb.green,uFs3Rgb.green);
        uFs3Rgb.blue       <= resize(uFs2Rgb.blue,uFs3Rgb.blue);
        uFs3Rgb.valid      <= uFs2Rgb.valid;
    end if;
end process;
valid1xB <= hi when (uFs3Rgb.blue > uFs3Rgb.red) and (uFs3Rgb.blue > uFs3Rgb.green) and (uFs3Rgb.green > uFs3Rgb.red)  and (uFs3Rgb.red /= uFs3Rgb.green) else lo;
process (clk) begin
    if rising_edge(clk) then 
        if(valid1xB = hi) then
            uFs4Rgb.red      <= uFs3Rgb.red;
            uFs4Rgb.green    <= uFs3Rgb.green;
            uFs4Rgb.blue     <= uFs3Rgb.blue;
         else
            uFs4Rgb.red      <= to_ufixed (255.0,uFs4Rgb.red);
            uFs4Rgb.green    <= to_ufixed (255.0,uFs4Rgb.green);
            uFs4Rgb.blue     <= to_ufixed (255.0,uFs4Rgb.blue);
         end if;
            uFs4Rgb.valid    <= uFs3Rgb.valid;
    end if;
end process;
process (uFs4Rgb) begin
    if (uFs4Rgb.red  /= rgbMaxVal) or (uFs4Rgb.red  = 0.0) then
        aBlueGreenVal <= (uFs4Rgb.blue - uFs4Rgb.green);
        aBlueRedVal   <= (uFs4Rgb.blue - uFs4Rgb.red);
    else
        aBlueGreenVal <= to_ufixed (255.0,aBlueGreenVal);
        aBlueRedVal   <= to_ufixed (255.0,aBlueRedVal);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then 
        if (aBlueGreenVal  >= aBlueRedVal)then
            aRgbDeltaVal <= (aBlueGreenVal - aBlueRedVal);
        else
            aRgbDeltaVal <= (aBlueRedVal - aBlueGreenVal);
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
            oRgbFiltered.valid  <= s4Rgb.valid;
       if(aBlueGreenVal < 150.0) and (aRgbDeltaVal > 10.0) then
            oRgbFiltered.red    <= s4Rgb.red;
            oRgbFiltered.green  <= s4Rgb.green;
            oRgbFiltered.blue   <= s4Rgb.blue;
        else
            oRgbFiltered.red    <= x"ff";
            oRgbFiltered.green  <= x"ff";
            oRgbFiltered.blue   <= x"ff";
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then 
        oRgbInverted.red    <= std_logic_vector(uFs3Rgb.red(i_data_width-1 downto 0));
        oRgbInverted.green  <= std_logic_vector(uFs3Rgb.green(i_data_width-1 downto 0));
        oRgbInverted.blue   <= std_logic_vector(uFs3Rgb.blue(i_data_width-1 downto 0));
        oRgbInverted.valid  <= uFs3Rgb.valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then 
        oRgb    <= iRgb;
    end if;
end process;
end behavioral;