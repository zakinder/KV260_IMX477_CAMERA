library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_portrait_stream is end entity;
architecture test of tb_portrait_stream is
    constant width : positive := 32;
    constant height : positive := 24;
    signal clk, rst_n, valid_in, valid_out, sof, eol, eof : std_logic := '0';
    signal rgb_in, rgb_out : std_logic_vector(23 downto 0);
    signal finished : boolean := false;
    type crc_array is array (0 to 3) of unsigned(31 downto 0);
    -- zlib CRC32 over RGB bytes from the independent integer portrait model.
    constant expected : crc_array := (x"3A1E86AB", x"B275A594", x"38F04563", x"BFDA4CBE");
begin
    clk <= not clk after 5 ns when not finished else '0';
    dut : entity work.portrait_renderer generic map(40,30)
        port map(width,height,clk,rst_n,valid_in,rgb_in,sof,eol,eof,valid_out,rgb_out);
    process
        variable n : natural := 0;
        variable crc : unsigned(31 downto 0) := (others=>'1');
        variable bit_value : std_logic;
        procedure tick is
        begin
            wait until rising_edge(clk);
            if valid_out='1' then
                assert (sof='1') = (n mod (width*height)=0) severity failure;
                assert (eol='1') = (n mod width=width-1) severity failure;
                assert (eof='1') = (n mod (width*height)=width*height-1) severity failure;
                for k in 2 downto 0 loop
                    for b in 0 to 7 loop
                        bit_value:=crc(0) xor rgb_out(8*k+b);
                        crc:=shift_right(crc,1);
                        if bit_value='1' then crc:=crc xor x"EDB88320"; end if;
                    end loop;
                end loop;
                if eof='1' then
                    assert (not crc)=expected(n/(width*height)) report "RGB CRC mismatch" severity failure;
                    crc:=(others=>'1');
                end if;
                n:=n+1;
            end if;
        end procedure;
    begin
        tick; tick; rst_n<='1';
        for f in 0 to 4 loop
            for y in 0 to height-1 loop
                for x in 0 to width-1 loop
                    if (x+3*y+f) mod 13=0 then valid_in<='0'; tick; end if;
                    valid_in<='1';
                    rgb_in<=std_logic_vector(to_unsigned((f*17+x*3+y*2) mod 100,8)) &
                           std_logic_vector(to_unsigned((f*7+x+2*y) mod 90,8)) & std_logic_vector(to_unsigned((f*9+x+y) mod 75,8));
                    tick;
                    if n=4*width*height then
                        report "PASS: four continuous frames, valid gaps, RGB CRC and markers";
                        finished<=true; wait;
                    end if;
                end loop;
            end loop;
        end loop;
        assert false report "Output timeout" severity failure; wait;
    end process;
end architecture;
