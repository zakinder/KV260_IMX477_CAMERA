library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Add texture derived exclusively from the camera luminance to the graded base.
entity detail_renderer is
    generic (W : positive; H : positive);
    port (width, height : in natural;
          clk, rst_n, s_valid : in std_logic;
          s_rgb : in std_logic_vector(23 downto 0);
          s_luma_q2 : in unsigned(9 downto 0);
          m_sof, m_eol, m_eof : out std_logic;
          m_valid : out std_logic;
          m_rgb : out std_logic_vector(23 downto 0));
end entity;

architecture rtl of detail_renderer is
    subtype pixel is std_logic_vector(23 downto 0);
    subtype sample is unsigned(9 downto 0);
    type column_t is array (0 to 13) of sample;
    type line_memory is array (0 to W-1) of column_t;
    type window_t is array (0 to 14,0 to 14) of sample;
    constant CENTER_DELAY : positive := 7*W+7;
    type color_delay_t is array (0 to CENTER_DELAY-1) of pixel;
    signal lines : line_memory;
    signal colors : color_delay_t;
    function clip(v, lo, hi : integer) return integer is
    begin
        if v<lo then return lo; elsif v>hi then return hi; end if;
        return v;
    end function;
    function low(a,b : integer) return integer is
    begin if a<b then return a; end if; return b; end function;
    function high(a,b : integer) return integer is
    begin if a>b then return a; end if; return b; end function;
    function value(wnd : window_t; dy,dx : integer) return integer is
    begin return to_integer(wnd(7+dy,7+dx)); end function;
    function surround(wnd : window_t; d : positive) return integer is
        variable axis, diagonal : integer;
    begin
        axis := value(wnd,0,-d)+value(wnd,0,d)+value(wnd,-d,0)+value(wnd,d,0);
        diagonal := value(wnd,-d,-d)+value(wnd,-d,d)+value(wnd,d,-d)+value(wnd,d,d);
        return (4*value(wnd,0,0)+2*axis+diagonal+8)/16;
    end function;
    function line_mean(wnd : window_t; dy,dx : integer) return integer is
    begin return (value(wnd,dy,dx)+2*value(wnd,0,0)+value(wnd,-dy,-dx)+2)/4; end function;

    function render(wnd : window_t; rgb : pixel) return pixel is
        variable red : integer := to_integer(unsigned(rgb(23 downto 16)));
        variable green : integer := to_integer(unsigned(rgb(15 downto 8)));
        variable blue : integer := to_integer(unsigned(rgb(7 downto 0)));
        variable y,near_y,wide_y,direction,fine,band : integer;
        variable warm,flat_gain,neutral,gain,fabric,shadow,bright_skin,broad_gain : integer;
        variable tone,light,lift,tint : integer;
        type directions_t is array(0 to 3) of integer;
        variable lines_y : directions_t;
    begin
        y := value(wnd,0,0);
        near_y := surround(wnd,1);
        wide_y := (surround(wnd,3)+surround(wnd,5)+surround(wnd,7)+1)/3;
        lines_y := (line_mean(wnd,1,0),line_mean(wnd,0,1),line_mean(wnd,1,1),line_mean(wnd,1,-1));
        direction := lines_y(0);
        for i in 1 to 3 loop
            if y>=near_y then direction:=high(direction,lines_y(i));
            else direction:=low(direction,lines_y(i)); end if;
        end loop;
        fine := (y+direction-2*near_y)/2;
        band := near_y-wide_y;

        -- Continuous gains from graded RGB: less detail on bright neutral wall and skin highlights.
        warm := clip(red-green-13,0,32);
        flat_gain := clip(2*low(clip(green-133,0,32),clip(24-red+green,0,24)),0,32);
        neutral := 32-warm;
        gain := 8+neutral/2+clip((89-green)/5,0,12);
        gain := (gain*(32-flat_gain)+16)/32;
        bright_skin := low(warm,clip(red-172,0,32));
        gain := gain-gain*bright_skin/96;
        fabric := low(neutral,clip(green-34,0,32));
        broad_gain := gain+gain*fabric/48;
        tone := clip((fine*gain+band*broad_gain)/12,-60,85);
        shadow := low(clip((45-green)*2,0,32),neutral);
        lift := clip(direction-near_y-1,0,32)*shadow/8;
        tone := tone+lift;

        light := clip((red+2*green+blue-340)/28,0,5);
        tint := low(clip(red-green-9,0,20),clip(110-green,0,20));
        blue := blue+tone+bright_skin/8+tint/3+clip((red-145)/12,0,5)*warm/32;
        green := green+tone+bright_skin/6;
        red := red+tone+(warm*light+16)/32+tint/2;
        return std_logic_vector(to_unsigned(clip(red,0,255),8)) &
               std_logic_vector(to_unsigned(clip(green,0,255),8)) &
               std_logic_vector(to_unsigned(clip(blue,0,255),8));
    end function;
begin
    process(clk)
        variable x,ox : natural range 0 to W-1 := 0;
        variable oy : natural range 0 to H := 0;
        variable delay_index : natural range 0 to CENTER_DELAY-1 := 0;
        variable fill : natural range 0 to CENTER_DELAY := 0;
        variable wnd : window_t;
        variable history, next_history : column_t;
        variable center_color : pixel;
    begin
        if rising_edge(clk) then
            m_valid<='0'; m_sof<='0'; m_eol<='0'; m_eof<='0';
            if rst_n='0' then
                x:=0; ox:=0; oy:=0; delay_index:=0; fill:=0;
            elsif s_valid='1' then
                history:=lines(x);
                next_history(0 to 12):=history(1 to 13);
                next_history(13):=s_luma_q2;
                lines(x)<=next_history;
                for row in 0 to 14 loop
                    for col in 0 to 13 loop wnd(row,col):=wnd(row,col+1); end loop;
                    if row<14 then wnd(row,14):=history(row);
                    else wnd(row,14):=s_luma_q2; end if;
                end loop;
                center_color:=colors(delay_index);
                colors(delay_index)<=s_rgb;
                if delay_index=7*width+6 then delay_index:=0; else delay_index:=delay_index+1; end if;
                if x=width-1 then x:=0; else x:=x+1; end if;
                if fill<7*width+7 then fill:=fill+1;
                else
                    m_valid<='1';
                    if ox>=7 and ox+7<width and oy>=7 and oy+7<height then
                        m_rgb<=render(wnd,center_color);
                    else m_rgb<=center_color; end if;
                    if ox=0 and oy=0 then m_sof<='1'; end if;
                    if ox=width-1 then
                        m_eol<='1'; ox:=0;
                        if oy=height-1 then m_eof<='1'; oy:=0; else oy:=oy+1; end if;
                    else ox:=ox+1; end if;
                end if;
            end if;
        end if;
    end process;
end architecture;
