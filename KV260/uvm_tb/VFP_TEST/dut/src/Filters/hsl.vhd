--05062019 [05-06-2019]
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity hsl_c is
generic (
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oHsl           : out channel);
end hsl_c;
architecture behavioral of hsl_c is
    --RGB Floating
    signal uFs0Rgb       : rgbToUfRecord;
    signal uFs1Rgb       : rgbToUfRecord;
    signal uFs2Rgb       : rgbToUfRecord;
    signal uFs3Rgb       : rgbToUfRecord;
    signal uF1Rgb        : rgbToUfRecord;
    signal uF2Rgb        : rgbToUfRecord;
    signal uF3Rgb        : rgbToUfRecord;
    signal uFs8Rgb       : rgbToUfRecord;
    signal uFs9Rgb       : rgbToUfRecord;
    signal uFs10Rgb       : rgbToUfRecord;
    signal uFs11Rgb       : rgbToUfRecord;
    signal uFs12Rgb       : rgbToUfRecord;
    signal uFs13Rgb       : rgbToUfRecord;

    signal uFsP1Rgb       : rgbToUfRecord;
    signal uFsP2Rgb       : rgbToUfRecord;
    signal uFsP3Rgb       : rgbToUfRecord;
    signal uFsP4Rgb       : rgbToUfRecord;
    signal uFsP4RgbSel   : std_logic := '0';
    signal rgbMaxVal     : ufixed(7 downto 0) :=(others => '0');
    signal aRedGreenVal  : ufixed(8 downto 0) :=(others => '0');
    --RGB Max Min
    signal rgbMax        : ufixed(7 downto 0) :=(others => '0');
    signal rgbMin        : ufixed(7 downto 0) :=(others => '0');
    signal maxValue      : ufixed(7 downto 0) :=(others => '0');
    signal minValue      : ufixed(7 downto 0) :=(others => '0');
    signal rgbDelta      : ufixed(8 downto 0) :=(others => '0');
    signal maxMinSum     : ufixed(8 downto 0) :=(others => '0');
    --Valid
    signal valid1xB      : std_logic := '0';
    signal valid2xB      : std_logic := '0';
    signal valid3xB      : std_logic := '0';
    signal valid4xB      : std_logic := '0';
    signal valid1xD      : std_logic := '0';
    signal valid2xD      : std_logic := '0';
    signal valid3xD      : std_logic := '0';
    signal valid4xD      : std_logic := '0';
    --HValue
    signal hValue1xD     : std_logic_vector(i_data_width-1 downto 0) :=(others => '0');
    signal hValue2xD     : std_logic_vector(i_data_width-1 downto 0) :=(others => '0');
    signal hValue3xD     : std_logic_vector(i_data_width-1 downto 0) :=(others => '0');
    signal hValue4xD     : std_logic_vector(i_data_width-1 downto 0) :=(others => '0');
    --Lum
    signal lumValueQuot  : ufixed(8 downto -9) :=(others => '0');
    signal lumValue      : ufixed(7 downto 0)  :=(others => '0');
    signal lumValue1xD   : std_logic_vector(i_data_width-1 downto 0) :=(others => '0');
    signal lumValue2xD   : std_logic_vector(i_data_width-1 downto 0) :=(others => '0');
    --Saturate
    signal satUfTop      : ufixed(17 downto 0) :=(others => '0');
    signal satUfBott     : ufixed(7 downto 0) :=(others => '0');
    signal satValueQuot  : ufixed(17 downto -8) :=(others => '0');
    signal satValue      : ufixed(7 downto 0) :=(others => '0');
    signal satValue1xD   : std_logic_vector(7 downto 0) :=(others => '0');
    --Hue Rsiz
    signal hueTop        : ufixed(17 downto 0) :=(others => '0');
    signal hueBot        : ufixed(8 downto 0) :=(others => '0');
    signal hueQuot       : ufixed(17 downto -9) :=(others => '0');
    signal hueQuot1x     : ufixed(7 downto 0) :=(others => '0');
    signal hueDeg        : ufixed(26 downto 0) :=(others => '0');
    signal hueDeg1x      : ufixed(7 downto 0) :=(others => '0');
    signal hueValue      : unsigned(7 downto 0):= (others => '0');
begin
rgbMaxVal <= to_ufixed (255.0,rgbMaxVal);
rgbToUfP: process (clk,reset)begin
    if (reset = lo) then
        uFs0Rgb.red    <= (others => '0');
        uFs0Rgb.green  <= (others => '0');
        uFs0Rgb.blue   <= (others => '0');
    elsif rising_edge(clk) then 
        uFs0Rgb.red    <= to_ufixed(iRgb.red,uFs0Rgb.red);
        uFs0Rgb.green  <= to_ufixed(iRgb.green,uFs0Rgb.green);
        uFs0Rgb.blue   <= to_ufixed(iRgb.blue,uFs0Rgb.blue);
        uFs0Rgb.valid  <= iRgb.valid;
    end if; 
end process rgbToUfP;
process (clk) begin
    if rising_edge(clk) then 
        uFsP1Rgb <= uFs0Rgb;
        uFsP2Rgb <= uFsP1Rgb;
        uFsP3Rgb <= uFsP2Rgb;
        uFsP4Rgb <= uFsP3Rgb;
    end if;
end process;
-------------------------------------------------------
process (clk) begin
    if rising_edge(clk) then 
        uF1Rgb.red        <= rgbMaxVal - uFs0Rgb.red;
        uF1Rgb.green      <= rgbMaxVal - uFs0Rgb.green;
        uF1Rgb.blue       <= rgbMaxVal - uFs0Rgb.blue;
        uF1Rgb.valid      <= uFs0Rgb.valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then 
        uF2Rgb.red        <= resize(uF1Rgb.red,uF2Rgb.red);
        uF2Rgb.green      <= resize(uF1Rgb.green,uF2Rgb.green);
        uF2Rgb.blue       <= resize(uF1Rgb.blue,uF2Rgb.blue);
        uF2Rgb.valid      <= uF1Rgb.valid;
    end if;
end process;
valid1xB <= hi when (uF2Rgb.blue > uF2Rgb.red) and (uF2Rgb.blue > uF2Rgb.green) and (uF2Rgb.green > uF2Rgb.red)  and (uF2Rgb.red /= uF2Rgb.green) else lo;
process (clk) begin
    if rising_edge(clk) then 
         if(valid1xB = hi) then
            uF3Rgb.red      <= uF2Rgb.red;
            uF3Rgb.green    <= uF2Rgb.green;
            uF3Rgb.blue     <= uF2Rgb.blue;
         else
            uF3Rgb.red      <= to_ufixed (255.0,uF3Rgb.red);
            uF3Rgb.green    <= to_ufixed (255.0,uF3Rgb.green);
            uF3Rgb.blue     <= to_ufixed (255.0,uF3Rgb.blue);
         end if;
            uF3Rgb.valid  <= uF2Rgb.valid;
    end if;
end process;
valid2xB <= hi when (uF2Rgb.blue > uF2Rgb.red) and (uF2Rgb.blue > uF2Rgb.green) and (uF2Rgb.red /= 0.0) and (uF2Rgb.red /= uF2Rgb.green)else lo;
process (uF3Rgb) begin
    if (uF3Rgb.red  = 0.0) and (uF3Rgb.red  /= rgbMaxVal) then
            aRedGreenVal <= (uF3Rgb.blue - uF3Rgb.green);
    else
            aRedGreenVal <= to_ufixed (0.0,aRedGreenVal);
    end if;
end process;


process (clk) begin
    if rising_edge(clk) then
            uFs1Rgb.valid    <= uFsP3Rgb.valid;
       if(aRedGreenVal < 150.0) then
            uFs1Rgb.red      <= uFsP3Rgb.red;
            uFs1Rgb.green    <= uFsP3Rgb.green;
            uFs1Rgb.blue     <= uFsP3Rgb.blue;
        else
            uFs1Rgb.red      <= to_ufixed (0.0,uFs1Rgb.red);
            uFs1Rgb.green    <= uF3Rgb.green;
            uFs1Rgb.blue     <= to_ufixed (0.0,uFs1Rgb.blue);
        end if;
    end if;
end process;


-------------------------------------------------------
pipRgbD2P: process (clk) begin
    if rising_edge(clk) then
        uFs2Rgb <= uFs1Rgb;
    end if;
end process pipRgbD2P;
pipRgbD3P: process (clk) begin
    if rising_edge(clk) then 
        uFs3Rgb <= uFs2Rgb;
    end if;
end process pipRgbD3P;
rgbMaxP: process (clk) begin
    if rising_edge(clk) then 
        if ((uFs1Rgb.red >= uFs1Rgb.green) and (uFs1Rgb.red >= uFs1Rgb.blue)) then
            rgbMax <= uFs1Rgb.red;
        elsif((uFs1Rgb.green >= uFs1Rgb.red) and (uFs1Rgb.green >= uFs1Rgb.blue))then
            rgbMax <= uFs1Rgb.green;
        else
            rgbMax <= uFs1Rgb.blue;
        end if;
    end if;
end process rgbMaxP;
rgbMinP: process (clk) begin
    if rising_edge(clk) then 
        if ((uFs1Rgb.red <= uFs1Rgb.green) and (uFs1Rgb.red <= uFs1Rgb.blue)) then
            rgbMin <= uFs1Rgb.red;
        elsif((uFs1Rgb.green <= uFs1Rgb.red) and (uFs1Rgb.green <= uFs1Rgb.blue)) then
            rgbMin <= uFs1Rgb.green;
        else
            rgbMin <= uFs1Rgb.blue;
        end if;
    end if;
end process rgbMinP;
rgbDeltaP: process (clk) begin
    if rising_edge(clk) then 
        rgbDelta      <= rgbMax - rgbMin;
    end if;
end process rgbDeltaP;
maxMinUfSumP: process (clk) begin
    if rising_edge(clk) then 
        maxMinSum    <= rgbMax + rgbMin;
    end if;
end process maxMinUfSumP;
pipRgbMaxUfD1P: process (clk) begin
    if rising_edge(clk) then 
        maxValue          <= rgbMax;
        minValue          <= rgbMin;
    end if;
end process pipRgbMaxUfD1P;
-------------------------------------------------
-- LUM
-------------------------------------------------
lumP: process (clk) begin
    if rising_edge(clk) then 
        lumValueQuot   <= maxMinSum / 2.0;
    end if;
end process lumP;
lumResizeP: process (clk) begin
    if rising_edge(clk) then 
        lumValue <= resize(lumValueQuot,lumValue);
        lumValue1xD <= std_logic_vector(to_unsigned(lumValue,8));
        lumValue2xD <= lumValue1xD;
    end if;
end process lumResizeP;
-------------------------------------------------
-- VALUE
-------------------------------------------------
hValueP: process (clk) begin
    if rising_edge(clk) then 
        hValue1xD <= std_logic_vector(to_unsigned(maxValue,8));
        hValue2xD <= hValue1xD;
        hValue3xD <= hValue2xD;
        hValue4xD <= hValue3xD;
    end if;
end process hValueP;
-------------------------------------------------
-- SATURATE
-------------------------------------------------
satNumniatorUfP: process (clk) begin
    if rising_edge(clk) then 
        satUfTop      <= 128.0 * rgbDelta;
    end if;
end process satNumniatorUfP;
satDominaUfCalP: process (clk) begin
    if rising_edge(clk) then 
        if (maxValue > 0) then
            satUfBott <= maxValue;
        end if;
    end if;
end process satDominaUfCalP;
satDividerP: process (clk) begin
    if rising_edge(clk) then 
        satValueQuot <= satUfTop / satUfBott;
    end if;
end process satDividerP;
satDividerResizeP: process (clk) begin
    if rising_edge(clk) then 
        satValue    <= resize(satValueQuot,satValue);
        satValue1xD <= std_logic_vector(to_unsigned(satValue,8));
    end if;
end process satDividerResizeP;
-------------------------------------------------
-- HUE
-------------------------------------------------
hueBottomP: process (clk) begin
    if rising_edge(clk) then 
        if (rgbDelta > 0) then
            hueBot <= rgbDelta;
        else
            hueBot <= to_ufixed (6.0,hueBot);
        end if;
    end if;
end process hueBottomP;
hueP: process (clk) begin
  if rising_edge(clk) then 
    if (uFs3Rgb.red  = maxValue) then
            hueDeg <= to_ufixed (90.0,hueDeg);
        if (uFs3Rgb.green >= uFs3Rgb.blue) then
            hueTop        <= (uFs3Rgb.green - uFs3Rgb.blue) * 43;
        else
            hueTop        <= (uFs3Rgb.blue - uFs3Rgb.green) * 43;
        end if;
    elsif(uFs3Rgb.green = maxValue)  then
            hueDeg <= to_ufixed (110.0,hueDeg);
        if (uFs3Rgb.blue >= uFs3Rgb.red ) then
            hueTop       <= (uFs3Rgb.blue - uFs3Rgb.red ) * 43;
        else
            hueTop       <= (uFs3Rgb.red  - uFs3Rgb.blue) * 43;
        end if;
    elsif(uFs3Rgb.blue = maxValue)  then
            hueDeg <= to_ufixed (90.0,hueDeg);
        if (uFs3Rgb.red  >= uFs3Rgb.green) then
            hueTop       <= (uFs3Rgb.red  - uFs3Rgb.green) * 43;
        else
            hueTop       <= (uFs3Rgb.green - uFs3Rgb.red ) * 43;
        end if;
    end if;
  end if;
end process hueP;
hueDividerP: process (clk) begin
    if rising_edge(clk) then 
        hueQuot  <= hueTop / hueBot;
    end if;
end process hueDividerP;
hueDegreeP: process (clk) begin
    if rising_edge(clk) then 
        hueDeg1x       <= resize(hueDeg,hueDeg1x);
    end if;
end process hueDegreeP;
hueDividerResizeP: process (clk) begin
    if rising_edge(clk) then 
        hueQuot1x <= resize(hueQuot,hueQuot1x);
    end if;
end process hueDividerResizeP;
hueValueP: process (clk) begin
    if rising_edge(clk) then 
        hueValue <= (to_unsigned(hueQuot1x,8) + to_unsigned(hueDeg1x,8));
    end if;
end process hueValueP;
-------------------------------------------------
-- VALID
-------------------------------------------------
pipValidP: process (clk) begin
    if rising_edge(clk) then 
        valid1xD    <= uFs3Rgb.valid;
        valid2xD    <= valid1xD;
        valid3xD    <= valid2xD;
        valid4xD    <= valid3xD;
    end if;
end process pipValidP;
-- process (uFs7Rgb) begin
    -- if (uFs7Rgb.red  = 0.0) then
        -- if (uFs7Rgb.green >= uFs7Rgb.blue) then
            -- aRedGreenVal        <= (uFs7Rgb.green - uFs7Rgb.blue);
        -- else
            -- aRedGreenVal        <= (uFs7Rgb.blue - uFs7Rgb.green);
        -- end if;
    -- elsif (uFs3Rgb.red /= rgbMaxVal) and (uFs3Rgb.green /= rgbMaxVal) and (uFs3Rgb.blue /= rgbMaxVal) then
        -- if (uFs7Rgb.green >= uFs7Rgb.blue) then
            -- aRedGreenVal        <= (uFs7Rgb.green - uFs7Rgb.blue);
        -- else
            -- aRedGreenVal        <= (uFs7Rgb.blue - uFs7Rgb.green);
        -- end if;
    -- else
    -- end if;
-- end process;
-- process (clk) begin
    -- if rising_edge(clk) then 
            -- oHsl.h      <= std_logic_vector(uFs8Rgb.red(i_data_width-1 downto 0));
            -- oHsl.s      <= std_logic_vector(uFs8Rgb.green(i_data_width-1 downto 0));
            -- oHsl.l      <= std_logic_vector(uFs8Rgb.blue(i_data_width-1 downto 0));
            -- oHsl.valid  <= uFs8Rgb.valid;
    -- end if;
-- end process;
-- process (clk) begin
    -- if rising_edge(clk) then 
        -- oHsl.h      <= std_logic_vector(uF2Rgb.red(i_data_width-1 downto 0));
        -- oHsl.s      <= std_logic_vector(uF2Rgb.green(i_data_width-1 downto 0));
        -- oHsl.l      <= std_logic_vector(uF2Rgb.blue(i_data_width-1 downto 0));
        -- oHsl.valid  <= uF2Rgb.valid;
    -- end if;
-- end process;
-- process (clk) begin
    -- if rising_edge(clk) then 
        -- oHsl.h      <= std_logic_vector(uF2Rgb.green(i_data_width-1 downto 0));
        -- oHsl.s      <= std_logic_vector(uF2Rgb.green(i_data_width-1 downto 0));
        -- oHsl.l      <= std_logic_vector(uF2Rgb.green(i_data_width-1 downto 0));
        -- oHsl.valid  <= uF2Rgb.valid;
    -- end if;
-- end process;
hsvOut: process (clk) begin
    if rising_edge(clk) then 
        oHsl.red      <= std_logic_vector(hueValue(i_data_width-1 downto 0));
        oHsl.green    <= satValue1xD;
        oHsl.blue     <= lumValue2xD;
        oHsl.valid    <= valid4xD;
    end if;
end process hsvOut;
-- hsvOut: process (clk) begin
    -- if rising_edge(clk) then 
        -- oHsl.h      <= std_logic_vector(hueValue(i_data_width-1 downto 0));
        -- oHsl.s      <= satValue1xD;
        -- oHsl.l      <= std_logic_vector(uFs12Rgb.green(i_data_width-1 downto 0));
        -- oHsl.valid  <= valid4xD;
    -- end if;
-- end process hsvOut;
end behavioral;