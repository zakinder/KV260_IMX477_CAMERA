library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;
entity exposer is
generic (
    i_data_width   : natural := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end exposer;
architecture behavioral of exposer is
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
    signal rgbSyncEol           : std_logic_vector(11 downto 0) := x"000";
    signal rgbSyncSof           : std_logic_vector(11 downto 0) := x"000";
    signal rgbSyncEof           : std_logic_vector(11 downto 0) := x"000";
    signal rgbColors            : type_inteChannel(0 to 11);
    signal rgb_min              : integer;
    signal rgb_max_n            : integer;
    signal rgb_max_1            : integer;
    signal rgb_equation_max     : integer;
    signal rgb_equation_mid     : integer;
    signal rgb_equation_min     : integer;
begin
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEol(0)  <= iRgb.eol;
        for i in 0 to 10 loop
          rgbSyncEol(i+1)  <= rgbSyncEol(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncSof(0)  <= iRgb.sof;
        for i in 0 to 10 loop
          rgbSyncSof(i+1)  <= rgbSyncSof(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEof(0)  <= iRgb.eof;
        for i in 0 to 10 loop
          rgbSyncEof(i+1)  <= rgbSyncEof(i);
        end loop;
    end if;
end process;



process (clk)begin
    if rising_edge(clk) then
        rgbColors(0).red    <= to_integer(unsigned(iRgb.red(9 downto 2)));
        rgbColors(0).green  <= to_integer(unsigned(iRgb.green(9 downto 2)));
        rgbColors(0).blue   <= to_integer(unsigned(iRgb.blue(9 downto 2)));
        rgbColors(0).valid  <= iRgb.valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbColors(1)        <= rgbColors(0);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_max_n            <= (rgbColors(1).red+rgbColors(1).green+rgbColors(1).blue)/3;
        rgb_max_1            <= rgb_max_n/8;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_min        <= min3(rgbColors(0).red,rgbColors(0).green,rgbColors(0).blue);
    end if;
end process;

process (clk)begin
    if rising_edge(clk) then
        rgbColors(2).red    <= rgbColors(1).red - rgb_min;
        rgbColors(2).green  <= rgbColors(1).green - rgb_min;
        rgbColors(2).blue   <= rgbColors(1).blue - rgb_min;
        rgbColors(2).valid  <= rgbColors(1).valid;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        rgbColors(3).red   <= (rgbColors(2).red)/2;
        rgbColors(3).green <= (rgbColors(2).green)/2;
        rgbColors(3).blue  <= (rgbColors(2).blue)/2;
        rgbColors(3).valid <= rgbColors(2).valid;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        rgbColors(4).red   <= (rgbColors(3).red) + rgb_max_1;
        rgbColors(4).green <= (rgbColors(3).green) + rgb_max_1;
        rgbColors(4).blue  <= (rgbColors(3).blue) + rgb_max_1;
        rgbColors(4).valid <= rgbColors(3).valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbColors(5).red   <= (rgbColors(4).red)*3;
        rgbColors(5).green <= (rgbColors(4).green)*3;
        rgbColors(5).blue  <= (rgbColors(4).blue)*3;
        rgbColors(5).valid <= rgbColors(4).valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_equation_max     <= max3((rgbColors(5).red),(rgbColors(5).green),(rgbColors(5).blue));
        rgb_equation_mid     <= mid3((rgbColors(5).red),(rgbColors(5).green),(rgbColors(5).blue));
        rgb_equation_min     <= min3((rgbColors(5).red),(rgbColors(5).green),(rgbColors(5).blue));
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        rgbColors(6)        <= rgbColors(5);
        rgbColors(7)        <= rgbColors(6);
    end if;
end process;
-- process (clk) begin
    -- if rising_edge(clk) then
        -- if (rgbColors(6).red = rgb_equation_min)then
            -- rgbColors(7).red        <= (rgb_equation_mid)/2 + (rgb_equation_mid)/4;
            -- rgbColors(7).green      <= rgbColors(6).green;
            -- rgbColors(7).blue       <= rgbColors(6).blue;
        -- elsif(rgbColors(6).red = rgb_equation_max) and (rgbColors(6).green = rgb_equation_min) and (rgbColors(6).blue = rgb_equation_mid) then
            -- rgbColors(7).red        <= rgbColors(6).red;
            -- rgbColors(7).green      <= (rgb_equation_mid);
            -- rgbColors(7).blue       <= rgbColors(6).blue;
        -- elsif(rgbColors(6).red = rgb_equation_mid) and (rgbColors(6).green = rgb_equation_min) and (rgbColors(6).blue = rgb_equation_max) then
            -- rgbColors(7).red        <= rgbColors(6).red;
            -- rgbColors(7).green      <= (rgb_equation_mid);
            -- rgbColors(7).blue       <= rgbColors(6).blue;
        -- elsif(rgbColors(6).green = rgb_equation_min)then
            -- rgbColors(7).red        <= rgbColors(6).red;
            -- rgbColors(7).green      <= (rgb_equation_mid)/2 + (rgb_equation_mid)/4;
            -- rgbColors(7).blue       <= rgbColors(6).blue;
        -- else
            -- rgbColors(7).red        <= rgbColors(6).red;
            -- rgbColors(7).green      <= rgbColors(6).green;
            -- rgbColors(7).blue       <= (rgb_equation_mid)/2 + (rgb_equation_mid)/4;
        -- end if;     
    -- end if;
-- end process;
-- process (clk) begin
    -- if rising_edge(clk) then
        -- rgbColors(7).valid      <= rgbColors(6).valid;
    -- end if;
-- end process;
process (clk) begin
    if rising_edge(clk) then
        rgbColors(8)        <= rgbColors(7);
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
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        oRgb.red     <= std_logic_vector(to_unsigned(rgbColors(11).red, 8)) & "00";
        oRgb.green   <= std_logic_vector(to_unsigned(rgbColors(11).green, 8)) & "00";
        oRgb.blue    <= std_logic_vector(to_unsigned(rgbColors(11).blue, 8)) & "00";
        oRgb.valid   <= rgbColors(11).valid;
        oRgb.eol     <= rgbSyncEol(11);
        oRgb.sof     <= rgbSyncSof(11);
        oRgb.eof     <= rgbSyncEof(11);
    end if;
end process;


end behavioral;