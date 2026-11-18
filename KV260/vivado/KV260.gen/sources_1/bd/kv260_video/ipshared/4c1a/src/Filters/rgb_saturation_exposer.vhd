library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;
entity rgb_saturation_exposer is
port (
    clk            : in std_logic;
    reset          : in std_logic;
    P_SAT          : in integer;
    N_SAT          : in integer;
    RGB_VAL        : in integer;
    CONTRAST_EN    : in integer;
    N_SAT_VAL      : in integer;
    N_VAL          : in integer;
    iRgb           : in channel;
    oRgb           : out channel);
end rgb_saturation_exposer;
architecture behavioral of rgb_saturation_exposer is
    function min2(a : integer; b : integer) return integer is
        variable result : integer;
    begin
		if a < b then
            result := a;
        else
            result := b;
        end if;
        return result;
    end function min2;
    function min3(a : integer; b : integer; c : integer) return integer is
        variable result : integer;
    begin
		if a < b then
            result := a;
        else
            result := b;
        end if;
        if c < result then
            result := c;
        end if;
        return result;
    end function min3;
    function mid3(a : integer; b : integer; c : integer) return integer is
        variable result : integer;
    begin
		if a >= b and a <= c then
            result := a;
        elsif a <= b and a >= c then
            result := a;
        elsif b >= a and b <= c then
            result := b;
        elsif b <= a and b >= c then
            result := b;
        elsif c >= a and c <= b then
            result := c;
        else
            result := c;
        end if;
        return result;
    end function mid3;
    function max3(a : integer; b : integer; c : integer) return integer is
        variable result : integer;
    begin
        if a > b then
            result := a;
        else
            result := b;
        end if;
        if c > result then
            result := c;
        end if;
        return result;
    end function max3;
    signal rgbSyncEol           : std_logic_vector(15 downto 0) := x"0000";
    signal rgbSyncSof           : std_logic_vector(15 downto 0) := x"0000";
    signal rgbSyncEof           : std_logic_vector(15 downto 0) := x"0000";
    signal rgbColors            : type_inteChannel(0 to 12);
    signal rgbMath              : type_inteChannel(0 to 12);
    signal rgbValue             : type_inteChannel(0 to 12);

    
    signal rgb_equation_max     : integer;
    signal rgb_equation_mid     : integer;
    signal rgb_equation_min     : integer;
    
    signal rgb_equation2max     : integer;
    signal rgb_equation2mid     : integer;
    signal rgb_equation2min     : integer;
    
    signal rgb1equation_max     : integer;
    signal rgb1equation_mid     : integer;
    signal rgb1equation_min     : integer;
    
    signal rgb2equation_max     : integer;
    signal rgb2equation_mid     : integer;
    signal rgb2equation_min     : integer;



begin
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEol(0)  <= iRgb.eol;
        for i in 0 to 12 loop
          rgbSyncEol(i+1)  <= rgbSyncEol(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncSof(0)  <= iRgb.sof;
        for i in 0 to 12 loop
          rgbSyncSof(i+1)  <= rgbSyncSof(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEof(0)  <= iRgb.eof;
        for i in 0 to 12 loop
          rgbSyncEof(i+1)  <= rgbSyncEof(i);
        end loop;
    end if;
end process;



process (clk)begin
    if rising_edge(clk) then
        rgbColors(0).red    <= abs(255 - to_integer(unsigned(iRgb.red(9 downto 2))));
        rgbColors(0).green  <= abs(255 - to_integer(unsigned(iRgb.green(9 downto 2))));
        rgbColors(0).blue   <= abs(255 - to_integer(unsigned(iRgb.blue(9 downto 2))));
        rgbColors(0).valid  <= iRgb.valid;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        rgbMath(0).red    <= to_integer(unsigned(iRgb.red(9 downto 2)));
        rgbMath(0).green  <= to_integer(unsigned(iRgb.green(9 downto 2)));
        rgbMath(0).blue   <= to_integer(unsigned(iRgb.blue(9 downto 2)));
        rgbMath(0).valid  <= iRgb.valid;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        rgbValue(0).red    <= to_integer(unsigned(iRgb.red(9 downto 2)));
        rgbValue(0).green  <= to_integer(unsigned(iRgb.green(9 downto 2)));
        rgbValue(0).blue   <= to_integer(unsigned(iRgb.blue(9 downto 2)));
        rgbValue(0).valid  <= iRgb.valid;
        rgbValue(1)        <= rgbValue(0);
        rgbValue(2)        <= rgbValue(1);
        rgbValue(3)        <= rgbValue(2);
        rgbValue(4)        <= rgbValue(3);
        rgbValue(5)        <= rgbValue(4);
        rgbValue(6)        <= rgbValue(5);
    end if;
end process;


-- process (clk) begin
    -- if rising_edge(clk) then
        -- if(rgbMath(0).red>240)then
            -- rgbMath(1).red   <= ((rgbMath(0).red * 127500));
        -- elsif(rgbMath(0).red>191)then
            -- rgbMath(1).red   <= ((rgbMath(0).red * 127500));
        -- elsif(rgbMath(0).red>127)then
            -- rgbMath(1).red   <= (((((66300 - (255 * rgbMath(0).red)) + 66300)))*rgbMath(0).red);
        -- else
            -- rgbMath(1).red   <= (((((66300 - (255 * rgbMath(0).red)) + 66300)))*rgbMath(0).red);
        -- end if;
        -- if(rgbMath(0).green>240)then
            -- rgbMath(1).green   <= ((rgbMath(0).green * 127500));
        -- elsif(rgbMath(0).green>191)then
            -- rgbMath(1).green   <= ((rgbMath(0).green * 127500));
        -- elsif(rgbMath(0).green>127)then
            -- rgbMath(1).green   <= (((((66300 - (255 * rgbMath(0).green)) + 66300)))*rgbMath(0).green);
        -- else
            -- rgbMath(1).green   <= (((((66300 - (255 * rgbMath(0).green)) + 66300)))*rgbMath(0).green);
        -- end if;
        -- if(rgbMath(0).blue>240)then
            -- rgbMath(1).blue   <= ((rgbMath(0).blue * 127500));
        -- elsif(rgbMath(0).blue>191)then
            -- rgbMath(1).blue   <= ((rgbMath(0).blue * 127500));
        -- elsif(rgbMath(0).blue>127)then
            -- rgbMath(1).blue   <= (((((66300 - (255 * rgbMath(0).blue)) + 66300)))*rgbMath(0).blue);
        -- else
            -- rgbMath(1).blue   <= (((((66300 - (255 * rgbMath(0).blue)) + 66300)))*rgbMath(0).blue);
        -- end if;
        -- rgbMath(1).valid <= rgbMath(0).valid;
    -- end if;
-- end process;
-- process (clk) begin
    -- if rising_edge(clk) then
        -- rgbMath(1).red     <= ((rgbMath(0).red * 117500));
        -- rgbMath(1).green   <= ((rgbMath(0).green * 117500));
        -- rgbMath(1).blue    <= ((rgbMath(0).blue * 117500));
        -- rgbMath(1).valid   <= rgbMath(0).valid;
    -- end if;
-- end process;

-- process (clk) begin
    -- if rising_edge(clk) then
        -- rgbMath(2).red     <= rgbMath(1).red /76500;
        -- rgbMath(2).green   <= rgbMath(1).green /76500;
        -- rgbMath(2).blue    <= rgbMath(1).blue /76500;
        -- rgbMath(2).valid   <= rgbMath(1).valid;
    -- end if;
-- end process;


process (clk) begin
    if rising_edge(clk) then
        rgbColors(1).red    <= rgbColors(0).red;
        rgbColors(1).green  <= rgbColors(0).green;
        rgbColors(1).blue   <= rgbColors(0).blue;
        rgbColors(1).valid  <= rgbColors(0).valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbMath(1).red    <= rgbMath(0).red;
        rgbMath(1).green  <= rgbMath(0).green;
        rgbMath(1).blue   <= rgbMath(0).blue;
        rgbMath(1).valid  <= rgbMath(0).valid;
    end if;
end process;


process (clk) begin
    if rising_edge(clk) then
        rgb_equation_max        <= max3(rgbColors(0).red,rgbColors(0).green,rgbColors(0).blue);
        rgb_equation_mid        <= mid3(rgbColors(0).red,rgbColors(0).green,rgbColors(0).blue);
        rgb_equation_min        <= min3(rgbColors(0).red,rgbColors(0).green,rgbColors(0).blue);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_equation2max        <= max3(rgbMath(0).red,rgbMath(0).green,rgbMath(0).blue);
        rgb_equation2mid        <= mid3(rgbMath(0).red,rgbMath(0).green,rgbMath(0).blue);
        rgb_equation2min        <= min3(rgbMath(0).red,rgbMath(0).green,rgbMath(0).blue);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        rgbColors(2).red    <= abs(rgbColors(1).red - rgb_equation_min);
        rgbColors(2).green  <= abs(rgbColors(1).green - rgb_equation_min);
        rgbColors(2).blue   <= abs(rgbColors(1).blue - rgb_equation_min);
        rgbColors(2).valid  <= rgbColors(1).valid;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        rgbMath(2).red    <= abs(rgbMath(1).red - (rgb_equation2min));
        rgbMath(2).green  <= abs(rgbMath(1).green - (rgb_equation2min));
        rgbMath(2).blue   <= abs(rgbMath(1).blue - (rgb_equation2min));
        rgbMath(2).valid  <= rgbMath(1).valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbColors(3).red   <= (rgbColors(2).red);
        rgbColors(3).green <= (rgbColors(2).green);
        rgbColors(3).blue  <= (rgbColors(2).blue);
        rgbColors(3).valid <= rgbColors(2).valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbMath(3).red   <= (rgbMath(2).red)*3;
        rgbMath(3).green <= (rgbMath(2).green)*3;
        rgbMath(3).blue  <= (rgbMath(2).blue)*3;
        rgbMath(3).valid <= rgbMath(2).valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbColors(4)   <= rgbColors(3);
        rgbColors(5)   <= rgbColors(4);
        rgbMath(4)     <= rgbMath(3);
        rgbMath(5)     <= rgbMath(4);
    end if;
end process;


process (clk) begin
    if rising_edge(clk) then
        rgb1equation_max        <= max3(rgbColors(4).red,rgbColors(4).green,rgbColors(4).blue);
        rgb1equation_mid        <= mid3(rgbColors(4).red,rgbColors(4).green,rgbColors(4).blue);
        rgb1equation_min        <= min3(rgbColors(4).red,rgbColors(4).green,rgbColors(4).blue);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb2equation_max        <= max3(rgbMath(4).red,rgbMath(4).green,rgbMath(4).blue);
        rgb2equation_mid        <= mid3(rgbMath(4).red,rgbMath(4).green,rgbMath(4).blue);
        rgb2equation_min        <= min3(rgbMath(4).red,rgbMath(4).green,rgbMath(4).blue);

    end if;
end process;
process (clk) begin
   if rising_edge(clk) then
       rgbColors(6).red    <= abs(255-(rgbColors(5).red));
       rgbColors(6).green  <= abs(255-(rgbColors(5).green));
       rgbColors(6).blue   <= abs(255-(rgbColors(5).blue));
       rgbColors(6).valid  <= rgbColors(5).valid;
   end if;
end process;
process (clk) begin
   if rising_edge(clk) then
       rgbMath(6).red    <= rgbMath(5).red;
       rgbMath(6).green  <= rgbMath(5).green;
       rgbMath(6).blue   <= rgbMath(5).blue;
       rgbMath(6).valid  <= rgbMath(5).valid;
   end if;
end process;

process (clk) begin
   if rising_edge(clk) then
       rgbMath(7).red    <= (rgbMath(6).red)*P_SAT;
       rgbMath(7).green  <= (rgbMath(6).green)*P_SAT;
       rgbMath(7).blue   <= (rgbMath(6).blue)*P_SAT;
       rgbMath(7).valid  <= rgbColors(6).valid;
   end if;
end process;



process (clk) begin
   if rising_edge(clk) then
    if (CONTRAST_EN = 0) then
       rgbColors(7).red    <= abs(N_SAT_VAL-rgbColors(6).red)*N_SAT;
       rgbColors(7).green  <= abs(N_SAT_VAL-rgbColors(6).green)*N_SAT;
       rgbColors(7).blue   <= abs(N_SAT_VAL-rgbColors(6).blue)*N_SAT;
       rgbColors(7).valid  <= rgbColors(6).valid;
    else
       rgbColors(7).red    <= (N_SAT_VAL-rgbColors(6).red)*N_SAT;
       rgbColors(7).green  <= (N_SAT_VAL-rgbColors(6).green)*N_SAT;
       rgbColors(7).blue   <= (N_SAT_VAL-rgbColors(6).blue)*N_SAT;
       rgbColors(7).valid  <= rgbColors(6).valid;
    end if;
   end if;
end process;
process (clk) begin
   if rising_edge(clk) then
       rgbValue(7).red    <= (rgbValue(6).red)*RGB_VAL;
       rgbValue(7).green  <= (rgbValue(6).green)*RGB_VAL;
       rgbValue(7).blue   <= (rgbValue(6).blue)*RGB_VAL;
       rgbValue(7).valid  <= rgbColors(6).valid;
   end if;
end process;

process (clk) begin
   if rising_edge(clk) then

   end if;
end process;

process (clk) begin
   if rising_edge(clk) then
    if (N_VAL = 0) then
       rgbColors(8).red    <= abs(rgbMath(7).red + rgbColors(7).red + rgbValue(7).red);
       rgbColors(8).green  <= abs(rgbMath(7).green + rgbColors(7).green + rgbValue(7).green);
       rgbColors(8).blue   <= abs(rgbMath(7).blue + rgbColors(7).blue + rgbValue(7).blue);
       rgbColors(8).valid  <= rgbColors(7).valid;
    elsif(N_VAL = 1)then
       rgbColors(8).red    <= abs(rgbMath(7).red + rgbColors(7).red + rgbValue(7).red)/2;
       rgbColors(8).green  <= abs(rgbMath(7).green + rgbColors(7).green + rgbValue(7).green)/2;
       rgbColors(8).blue   <= abs(rgbMath(7).blue + rgbColors(7).blue + rgbValue(7).blue)/2;
       rgbColors(8).valid  <= rgbColors(7).valid;
    else
       rgbColors(8).red    <= abs(rgbMath(7).red + rgbColors(7).red + rgbValue(7).red)/4;
       rgbColors(8).green  <= abs(rgbMath(7).green + rgbColors(7).green + rgbValue(7).green)/4;
       rgbColors(8).blue   <= abs(rgbMath(7).blue + rgbColors(7).blue + rgbValue(7).blue)/4;
       rgbColors(8).valid  <= rgbColors(7).valid;
    end if;
   end if;
end process;









process (clk) begin
    if rising_edge(clk) then
        rgbColors(9)     <= rgbColors(8);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        if(rgbColors(9).red >= 255)then
            rgbColors(10).red      <= 255;
        else
            rgbColors(10).red      <= rgbColors(9).red;
        end if;
        if(rgbColors(9).green >= 255)then
            rgbColors(10).green      <= 255;
        else
            rgbColors(10).green      <= rgbColors(9).green;
        end if;
        if(rgbColors(9).blue >= 255)then
            rgbColors(10).blue      <= 255;
        else
            rgbColors(10).blue      <= rgbColors(9).blue;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbColors(10).valid      <= rgbColors(9).valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbColors(11)        <= rgbColors(10);
        rgbColors(12)        <= rgbColors(11);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        oRgb.red     <= std_logic_vector(to_unsigned(rgbColors(10).red, 8)) & "00";
        oRgb.green   <= std_logic_vector(to_unsigned(rgbColors(10).green, 8)) & "00";
        oRgb.blue    <= std_logic_vector(to_unsigned(rgbColors(10).blue, 8)) & "00";
        oRgb.valid   <= rgbColors(8).valid;
        oRgb.eol     <= rgbSyncEol(8);
        oRgb.sof     <= rgbSyncSof(8);
        oRgb.eof     <= rgbSyncEof(8);
    end if;
end process;


end behavioral;