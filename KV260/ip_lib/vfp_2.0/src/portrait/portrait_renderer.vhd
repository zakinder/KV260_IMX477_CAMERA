library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.portrait_palette.all;

entity portrait_renderer is
    generic (INPUT_WIDTH : positive := 3840; INPUT_HEIGHT : positive := 2160);
    port (width,height : in natural;
          clk, rst_n, s_valid : in std_logic;
          s_rgb : in std_logic_vector(23 downto 0);
          m_sof,m_eol,m_eof : out std_logic;
          m_valid : out std_logic;
          m_rgb : out std_logic_vector(23 downto 0));
end entity;

architecture rtl of portrait_renderer is
    constant W : positive := INPUT_WIDTH;
    constant H : positive := INPUT_HEIGHT;
    subtype pixel is std_logic_vector(23 downto 0);
    subtype window_t is std_logic_vector(599 downto 0);
    signal graded : pixel;
    signal window_width : unsigned(15 downto 0);
    signal first_window : window_t;
    signal first_valid, smooth_valid, graded_valid : std_logic;
    type five_weights is array (0 to 4) of integer;
    constant spatial : five_weights := (1,2,2,2,1);
    type rgb_sums is array(0 to 2) of integer;
    -- Twelve bits per channel carry four fractional bits through the surface filter.
    subtype rgb_q4 is std_logic_vector(35 downto 0);
    signal smooth : rgb_q4;
    signal surface_y, graded_y : unsigned(9 downto 0);
    function clip(v, hi : integer) return integer is
    begin
        if v < 0 then return 0; elsif v > hi then return hi; end if;
        return v;
    end function;
    function channel(p : pixel; k : natural) return natural is
    begin return to_integer(unsigned(p(8*k+7 downto 8*k))); end function;
    function tap(win : window_t; row, col : natural) return pixel is
        constant low : natural := 24*(row*5+col);
    begin return win(low+23 downto low); end function;
    function luma(p : pixel) return natural is
    begin return (channel(p,2)+2*channel(p,1)+channel(p,0)+2)/4; end function;
    procedure advance(variable x,y : inout natural) is
    begin
        if x=width-1 then
            x:=0;
            if y=height-1 then y:=0; else y:=y+1; end if;
        else x:=x+1; end if;
    end procedure;
    function surface(win : window_t) return rgb_q4 is
        variable sums : rgb_sums := (others=>0);
        variable weight : integer;
        variable result : rgb_q4;
        variable p : pixel;
    begin
        for r in 0 to 4 loop
            for c in 0 to 4 loop
                p:=tap(win,r,c);
                weight:=spatial(r)*spatial(c);
                for k in 0 to 2 loop sums(k):=sums(k)+channel(p,k)*weight; end loop;
            end loop;
        end loop;
        for k in 0 to 2 loop
            result(12*k+11 downto 12*k):=std_logic_vector(to_unsigned((sums(k)+2)/4,12));
        end loop;
        return result;
    end function;
    function luma4(p : pixel) return integer is
    begin
        return channel(p,2)+2*channel(p,1)+channel(p,0);
    end function;
    function magnitude(x : integer) return integer is
    begin
        if x<0 then return -x; end if;
        return x;
    end function;
    function clean_luma(win : window_t) return unsigned is
        type offsets_t is array(0 to 3) of integer;
        constant dy : offsets_t := (1,0,1,1);
        constant dx : offsets_t := (0,1,1,-1);
        variable center : integer := luma4(tap(win,2,2));
        variable score,best,left_y,right_y,along,total,votes,gauss : integer;
    begin
        best:=5000; total:=0; votes:=0; gauss:=4*center;
        for i in 0 to 3 loop
            left_y:=luma4(tap(win,2-dy(i),2-dx(i)));
            right_y:=luma4(tap(win,2+dy(i),2+dx(i)));
            if i<2 then gauss:=gauss+2*(left_y+right_y);
            else gauss:=gauss+left_y+right_y; end if;
            score:=magnitude(left_y-right_y)+magnitude(left_y-center)+magnitude(right_y-center);
            if score<best then best:=score; total:=0; votes:=0; end if;
            if score=best then total:=total+left_y+2*center+right_y; votes:=votes+1; end if;
        end loop;
        case votes is
            when 1 => along:=total;
            when 2 => along:=(total+1)/2;
            when 3 => along:=(total+1)/3;
            when others => along:=(total+2)/4;
        end case;
        return to_unsigned((2*gauss+8*along+32)/64,10);
    end function;
    function blend(a,b,f : integer) return integer is
    begin return (a*(128-f)+b*f+64)/128; end function;
    function grade(p : rgb_q4) return pixel is
        variable red : integer := to_integer(unsigned(p(35 downto 24)));
        variable green : integer := to_integer(unsigned(p(23 downto 12)));
        variable blue : integer := to_integer(unsigned(p(11 downto 0)));
        variable y : integer := (red+2*green+blue+2)/4;
        variable u : integer := clip(red-green+512,1663);
        variable v : integer := clip(green-blue+512,1663);
        variable addr : integer := (y/128*14+u/128)*14+v/128;
        variable corners : std_logic_vector(191 downto 0);
        type four is array(0 to 3) of integer;
        variable mid : four;
        variable value : integer;
        variable result : pixel;
    begin
        for i in 0 to 7 loop
            corners(24*i+23 downto 24*i):=palette(addr+(i/4)*196+((i/2) mod 2)*14+(i mod 2));
        end loop;
        for k in 0 to 2 loop
            for i in 0 to 3 loop
                mid(i):=blend(channel(corners(i*48+23 downto i*48),k),
                              channel(corners(i*48+47 downto i*48+24),k),v mod 128);
            end loop;
            value:=blend(blend(mid(0),mid(1),u mod 128),blend(mid(2),mid(3),u mod 128),y mod 128);
            result(8*k+7 downto 8*k):=std_logic_vector(to_unsigned(value,8));
        end loop;
        return result;
    end function;
begin
    window_width <= to_unsigned(width,16);
    w1 : entity work.portrait_window_5x5 generic map(W)
        port map(clk,rst_n,window_width,s_valid,s_rgb,first_valid,first_window);
    detail : entity work.detail_renderer generic map(W,H)
        port map(width,height,clk,rst_n,graded_valid,graded,graded_y,m_sof,m_eol,m_eof,m_valid,m_rgb);

    process(clk)
        variable x,y : natural := 0;
        variable center : pixel;
    begin
        if rising_edge(clk) then
            if rst_n='0' then
                smooth_valid<='0'; graded_valid<='0'; x:=0; y:=0;
            else
                smooth_valid<=first_valid;
                graded_valid<=smooth_valid;
                if first_valid='1' then
                    center:=tap(first_window,2,2);
                    surface_y<=to_unsigned(channel(center,2)+2*channel(center,1)+channel(center,0),10);
                    if x>=2 and x+2<width and y>=2 and y+2<height then
                        smooth<=surface(first_window);
                        surface_y<=clean_luma(first_window);
                    else
                        for k in 0 to 2 loop
                            smooth(12*k+11 downto 12*k)<=std_logic_vector(to_unsigned(channel(center,k)*16,12));
                        end loop;
                    end if;
                    advance(x,y);
                end if;
                if smooth_valid='1' then graded<=grade(smooth); graded_y<=surface_y; end if;
            end if;
        end if;
    end process;
end architecture;
