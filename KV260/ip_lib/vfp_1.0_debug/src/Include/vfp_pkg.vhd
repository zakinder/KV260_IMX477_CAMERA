--12302021 [12-30-2021]
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package vfp_pkg is
    ----------------------------------------------------------------------------------------------------
    --procdures
    procedure clk_gen(signal clk : out std_logic; constant FREQ : real);
    ----------------------------------------------------------------------------------------------------
    --functions
    function maxchar(L: integer)                                    return string;
    function image_size_width(bmp: string)                          return integer;
    function image_size_height(bmp: string)                         return integer;
    function int_delta(l, r: integer)                               return integer;
    function int_sum(l, r: integer)                                 return integer;
    function int_prod(l, r: integer)                                return integer;
    function int_div(l, r: integer)                                 return integer;
    function max(l, r: integer)                                     return integer;
    function min(l, r: integer)                                     return integer;
    function max_select(l, r: integer)                              return integer;
    function min_select(l, r: integer)                              return integer;
    function int_max_val(l, m : integer)                            return integer;
    function int_max_val(l, m, r: integer)                          return integer;
    function int_max_val(l, m, r, e: integer)                       return integer;
    function int_min_val(l, m : integer)                            return integer;
    function int_min_val(l, m, r: integer)                          return integer;
    function int_min_val(l, m, r, e: integer)                       return integer;
    function selframe(l, r: boolean)                                return boolean;
    function selframe(l, r, m: boolean)                             return boolean;
    function per_frame(l, r: integer)                               return boolean;
    function perframe(l,r, m: boolean)                              return boolean;
    function conv_std_logic_vector(arg : integer; size : integer)   return std_logic_vector;
    ----------------------------------------------------------------------------------------------------
end package;
--------------------------------------------------------------------------------------------------------
--TB PACKAGE
--------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package body vfp_pkg is
    ----------------------------------------------------------------------------------------------------
    function image_size_width(bmp: string) return integer is
    begin
       if bmp = "64_64"  then
           return 64;
       elsif bmp = "100_100" then
           return 100;
       elsif bmp = "128_128" then
           return 128;
       elsif bmp = "222_149" then
           return 222;
       elsif bmp = "255_255" then
           return 255;
       elsif bmp = "255_127" then
           return 255;
       elsif bmp = "255_170" then
           return 170;
       elsif bmp = "255_181" then
           return 255;
       elsif bmp = "258_200" then
           return 258;
       elsif bmp = "272_416" then
           return 272;
       elsif bmp = "272_832" then
           return 272;
       elsif bmp = "300_200" then
           return 300;
       elsif bmp = "300_300" then
           return 300;
       elsif bmp = "320_480" then
           return 320;
       elsif bmp = "368_393" then
           return 368;
       elsif bmp = "385_289" then
           return 385;
       elsif bmp = "496_565" then
           return 496;
       elsif bmp = "500_26" then
           return 500;
       elsif bmp = "500_200" then
           return 500;
       elsif bmp = "500_191" then
           return 500;
       elsif bmp = "500_334" then
           return 500;
       elsif bmp = "500_500" then
           return 500;
       elsif bmp = "600_600" then
           return 600;
       elsif bmp = "619_479" then
           return 619;
       elsif bmp = "640_480" then
           return 640;
       elsif bmp = "770_580" then
           return 770;
       elsif bmp = "950_225" then
           return 950;
       elsif bmp = "950_950" then
           return 950;
       elsif bmp = "1000_500" then
           return 1000;
       elsif bmp = "1012_606" then
           return 1012;
       elsif bmp = "1024_1024" then
           return 1024;
       elsif bmp = "1024_685" then
           return 1024;
       elsif bmp = "1024_576" then
           return 1024;
       elsif bmp = "1056_760" then
           return 1056;
       elsif bmp = "1200_1600" then
           return 1200;
       elsif bmp = "1280_720" then
           return 1280;
       elsif bmp = "1754_1006" then
           return 1754;
       elsif bmp = "2638_1012" then
           return 2638;
       elsif bmp = "3000_3000" then
           return 3000;
       end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function image_size_height(bmp: string) return integer is
    begin
       if bmp = "64_64"  then
           return 64;
       elsif bmp = "100_100" then
           return 100;
       elsif bmp = "128_128" then
           return 128;
       elsif bmp = "222_149" then
           return 149;
       elsif bmp = "255_255" then
           return 255;
       elsif bmp = "255_127" then
           return 127;
       elsif bmp = "255_170" then
           return 255;
       elsif bmp = "255_181" then
           return 181;
       elsif bmp = "258_200" then
           return 200;
       elsif bmp = "272_416" then
           return 416;
       elsif bmp = "272_832" then
           return 832;
       elsif bmp = "300_200" then
           return 200;
       elsif bmp = "300_300" then
           return 300;
       elsif bmp = "320_480" then
           return 480;
       elsif bmp = "385_289" then
           return 289;
       elsif bmp = "368_393" then
           return 393;
       elsif bmp = "496_565" then
           return 565;
       elsif bmp = "500_26" then
           return 26;
       elsif bmp = "500_200" then
           return 200;
       elsif bmp = "500_191" then
           return 191;
       elsif bmp = "500_334" then
           return 334;
       elsif bmp = "500_500" then
           return 500;
       elsif bmp = "600_600" then
           return 600;
       elsif bmp = "619_479" then
           return 479;
       elsif bmp = "640_480" then
           return 480;
       elsif bmp = "770_580" then
           return 580;
       elsif bmp = "950_225" then
           return 225;
       elsif bmp = "950_950" then
           return 950;
       elsif bmp = "1000_500" then
           return 500;
       elsif bmp = "1012_606" then
           return 606;
       elsif bmp = "1024_1024" then
           return 1024;
       elsif bmp = "1024_685" then
           return 685;
       elsif bmp = "1024_576" then
           return 576;
       elsif bmp = "1056_760" then
           return 760;
       elsif bmp = "1200_1600" then
           return 1600;
       elsif bmp = "1280_720" then
           return 720;
       elsif bmp = "1754_1006" then
           return 1006;
       elsif bmp = "2638_1012" then
           return 1012;
       elsif bmp = "3000_3000" then
           return 3000;
       end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function maxchar(l: integer) return string is
    begin
       if l >= 100  then
           return " ";
       elsif l >= 10 then
           return "  ";
       elsif l <= 10 then
           return "   ";
       end if;
    end;
    ----------------------------------------------------------------------------------------------------
    procedure clk_gen(signal clk : out std_logic; constant freq : real) is
        constant period    : time := 1 sec / freq;
        constant high_time : time := period / 2;
        constant low_time  : time := period - high_time;
        begin
            loop
            clk <= '1';
            wait for high_time;
            clk <= '0';
            wait for low_time;
        end loop;
    end procedure;
    ----------------------------------------------------------------------------------------------------
    function conv_std_logic_vector(arg : integer; size : integer) return std_logic_vector is
        variable result         : std_logic_vector (size - 1 downto 0);
        variable temp           : integer;
        begin
        temp := arg;
        for i in 0 to size - 1 loop
            if (temp mod 2) = 1 then
                result(i) := '1';
            else
                result(i) := '0';
            end if;
            if temp > 0 then
                temp := temp / 2;
            elsif (temp > integer'low) then
                temp := (temp - 1) / 2;
            else
                temp := temp / 2;
            end if;
        end loop; 
        return result;
    end function;
    ----------------------------------------------------------------------------------------------------
    function int_max_val(l, m: integer) return integer is
    begin
       if l >= m then
           return l;
       else
           return m;
       end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function int_max_val(l, m, r: integer) return integer is
    begin
       if l >= r and l >= m then
           return l;
       elsif m >= l and m >= r then
           return m;
       else
           return r;
       end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function int_max_val(l, m, r, e : integer) return integer is
    begin
       if l >= r and l >= m and l >= e then
           return l;
       elsif m >= l and m >= r and m >= e then
           return m;
       elsif r >= l and r >= m and r >= e then
           return r;
       else
           return e;
       end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function int_min_val(l, m: integer) return integer is
    begin
       if l <= m then
           return l;
       else
           return m;
       end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function int_min_val(l, m, r: integer) return integer is
    begin
       if l <= r and l <= m then
           return l;
       elsif m <= l and m <= r then
           return m;
       else
           return r;
       end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function int_min_val(l, m, r, e : integer) return integer is
    begin
       if l <= r and l <= m and l <= e then
           return l;
       elsif m <= l and m <= r and m <= e then
           return m;
       elsif r <= l and r <= m and r <= e then
           return r;
       else
           return e;
       end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function per_frame(l, r: integer) return boolean is
    begin
        if (l = r) then
            return true;
        else
            return false;
        end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function perframe(l, r, m: boolean) return boolean is
        begin
        if (l = true) and (r = true) and (m = true) then
            return true;
        else
            return false;
        end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function selframe(l, r: boolean) return boolean is
    begin
        if (l = true) and (r = true) then
            return true;
        else
            return false;
        end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function selframe(l, r, m: boolean) return boolean is
        begin
        if (l = true) and (r = true) and (m = true) then
            return true;
        else
            return false;
        end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function max(l, r: integer) return integer is
        begin
        if l > r then
            return l;
        else
            return r;
        end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function max_select(l, r: integer) return integer is
        begin
        if l > r then
            return l;
        else
            return r;
        end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function min_select(l, r: integer) return integer is
        begin
        if l < r then
            return l;
        else
            return r;
        end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function min(l, r: integer) return integer is
        begin
        if l < r then
            return l;
        else
            return r;
        end if;
    end;
    ----------------------------------------------------------------------------------------------------
    function int_delta(l, r: integer) return integer is
        begin
            return (l-r);
    end;
    function int_sum(l, r: integer) return integer is
        begin
            return (l+r);
    end;
    function int_prod(l, r: integer) return integer is
        begin
            return (l*r);
    end;
    function int_div(l, r: integer) return integer is
        begin
            return (l/r);
    end;
    ----------------------------------------------------------------------------------------------------
end package body;