library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.vfp_pkg.all;
use work.tbPackage.all;
entity image_wr_interface is
  generic (
    i_data_width  : integer := 8;
    test          : string  := "test1"; 
    input_file    : string  := "input_image";  
    output_file   : string  := "output_image");
  port (
    pixclk        : in  std_logic;
    iRed          : in  std_logic_vector(i_data_width-1 downto 0);
    iGreen        : in  std_logic_vector(i_data_width-1 downto 0);
    iBlue         : in  std_logic_vector(i_data_width-1 downto 0);
    runFrame      : out std_logic;
    startFrame    : in std_logic;
    fvalid        : out std_logic;
    lvalid        : out std_logic;
    oRed          : out std_logic_vector(i_data_width-1 downto 0);
    oGreen        : out std_logic_vector(i_data_width-1 downto 0);
    oBlue         : out std_logic_vector(i_data_width-1 downto 0);
    xCount        : out std_logic_vector(15 downto 0);
    yCount        : out std_logic_vector(15 downto 0);
    rl            : out std_logic_vector(i_data_width-1 downto 0);
    rh            : out std_logic_vector(i_data_width-1 downto 0);
    gl            : out std_logic_vector(i_data_width-1 downto 0);
    gh            : out std_logic_vector(i_data_width-1 downto 0);
    bl            : out std_logic_vector(i_data_width-1 downto 0);
    bh            : out std_logic_vector(i_data_width-1 downto 0);
    address       : out std_logic_vector(15 downto 0);
    endOfFrame    : out std_logic;
    oValid        : out std_logic);
end image_wr_interface;
architecture Behavioral of image_wr_interface is

    -------------------------------------------------------------------------
	
    constant proj_fol  : string := "K:/ZEDBOARD/doc/ipManager/ip_user_files/VFP_1.0/tb";
    constant bacslash  : string := "\";
    constant readbmp   : string := input_file&".bmp";
    constant writbmp   : string := proj_fol&bacslash&test&bacslash&output_file&".bmp";
    constant writbmp1  : string := proj_fol&bacslash&test&bacslash&output_file&".txt";
    -------------------------------------------------------------------------
    type bit_file is file of bit_vector;
    file read_file     : bit_file open read_mode  is readbmp;
    type std_file is file of character;
    file write_file    : std_file open write_mode is writbmp;
    file write1file    : text open write_mode is writbmp1;
    type imageHeaderTable is array(0 to 51) of integer range 0 to 255;
    constant imageHeader  : imageHeaderTable := (0,66,77,54,192,0,0,0,0,0,0,54,0,0,0,40,0,0,0,128,0,0,0,128,0,0,0,1,0,24,0,0,0,0,0,0,192,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    type t_color is array(1 to 3) of std_logic_vector(i_data_width-1 downto 0);
    type t_bmp is array(0 to img_width -1, 0 to img_height -1) of t_color;
    signal bmp_read : t_bmp;
    signal bmp_out  : t_bmp := (others => (others => (others => (others => '0'))));
    type camlink_buffer_bus is record
        row1Cnt           : integer range 0 to 1024;
        row2Cnt           : integer range 0 to 1024;
        i_count           : integer range 0 to 1024;
        flag              : std_logic;
        pdone             : std_logic;
        x_count           : integer range 0 to 1024;
        y_count           : integer range 0 to 1024;
        xCount            : std_logic_vector(15 downto 0);
        yCount            : std_logic_vector(15 downto 0);
    end record;
    signal video    : camlink_buffer_bus;
    signal done     : std_logic := '0';
    signal enable   : std_logic := '0';
    signal running   : std_logic := '0';
    signal vvvvv   : std_logic := '0';
    signal x_in     : integer := 0;
    signal y_in     : integer := 0;
    signal x1in     : integer := 0;
    signal y1in     : integer := 0;
    signal x2in     : integer := 0;
    signal y2in     : integer := 0;
    signal x3in     : integer := 0;
    signal y3in     : integer := 0;
    signal x_out    : integer := 0;
    signal y_out    : integer := 0;
begin
    -------------------------------------------------------------------------
    pcreate_pixelpositions: process(pixclk)begin
        if rising_edge(pixclk) then
            if (running = '1' and done = '0' and startFrame = '1') then
                    video.flag      <= '0';
                    video.pdone     <= '0';
                if (video.row1Cnt < 100) then
                    video.row1Cnt     <= video.row1Cnt + 1;
                    fvalid    <= '0';
                elsif (video.row1Cnt < 200) then
                    video.row1Cnt   <= video.row1Cnt + 1;
                    fvalid    <= '1';
                elsif (video.x_count < img_width - 1 and video.flag = '0') then
                    video.row2Cnt   <= 0;
                    lvalid    <= '1';
                    video.x_count   <= video.x_count + 1;
                    oValid          <= '1';
                    vvvvv           <= '1';
                else
                   if (video.row2Cnt < 9) then
                       video.row2Cnt   <= video.row2Cnt + 1;
                       video.x_count   <= 0;
                       lvalid    <= '0';
                       video.flag      <= '1';
                       oValid          <= vvvvv;
                       vvvvv           <= '0';
                   else
                       video.flag <= '0';
                       --------------------------------------------
                       if (video.y_count < img_height - 1) then
                           video.y_count <= video.y_count + 1;
                       else
                           video.pdone     <= '1';
                           video.x_count   <= 0;
                           video.row2Cnt   <= 0;
                           fvalid    <= '0';
                           lvalid    <= '0';
                           oValid          <= vvvvv;
                           vvvvv           <= '0';
                           video.i_count   <= video.i_count + 1;
                           video.y_count   <= 0;
                       end if;
                       --------------------------------------------
                   end if;
               end if;
               --------------------------------------------
               if (video.y_count < img_height / 2) then
                   enable <= '1';
               else
                   enable <= '0';
               end if;
               --------------------------------------------
               if (video.i_count = 1) then
                   done <= '1';
               else
                   done <= '0';
               end if;
            -------------------------------------------------------------------------
                if (video.i_count = 0) then
                    rl<=x"64";
                    rh<=x"FD";
                    gl<=x"86";
                    gh<=x"A1";
                    bl<=x"5E";
                    bh<=x"7A";
               elsif (video.i_count = 1) then
                    rl<=x"C6";
                    rh<=x"FD";
                    gl<=x"86";
                    gh<=x"A1";
                    bl<=x"5E";
                    bh<=x"7A";
               elsif (video.i_count = 2) then
                    rl<=x"09";
                    rh<=x"FA";
                    gl<=x"09";
                    gh<=x"FA";
                    bl<=x"09";
                    bh<=x"F9";
               elsif (video.i_count = 3) then
                    rl<=x"09";
                    rh<=x"F0";
                    gl<=x"09";
                    gh<=x"F0";
                    bl<=x"09";
                    bh<=x"F0";
               elsif (video.i_count = 4) then
                    rl<=x"09";
                    rh<=x"F0";
                    gl<=x"09";
                    gh<=x"F0";
                    bl<=x"09";
                    bh<=x"F0";
               else
                    rl<=x"02";
                    rh<=x"30";
                    gl<=x"02";
                    gh<=x"30";
                    bl<=x"02";
                    bh<=x"30";
                    oValid <= '0';
                    video.pdone     <= '0';
               end if;
            -------------------------------------------------------------------------
            oRed         <= bmp_read(video.x_count, video.y_count)(1);
            oGreen       <= bmp_read(video.x_count, video.y_count)(2);
            oBlue        <= bmp_read(video.x_count, video.y_count)(3);
			address      <= std_logic_vector(to_unsigned(video.x_count, 16));
            -------------------------------------------------------------------------
            x_in         <= video.x_count;
            y_in         <= video.y_count;
            x1in         <= x_in;
            y1in         <= y_in;
            x2in         <= x1in;
            y2in         <= y1in;
            x3in         <= x2in;
            y3in         <= y2in;
            xCount       <= std_logic_vector(to_unsigned(x3in, 16));
            yCount       <= std_logic_vector(to_unsigned(y3in, 16));
            x_out        <= x3in;
            y_out        <= y3in;
            -------------------------------------------------------------------------
            bmp_out(x_out, y_out)(1) <= iRed;
            bmp_out(x_out, y_out)(2) <= iGreen;
            bmp_out(x_out, y_out)(3) <= iBlue;
            -------------------------------------------------------------------------
            end if;
            if(y3in = 127 and x3in = 127)then
                endOfFrame   <= '1';
            else
                endOfFrame   <= '0';
            end if;
        end if;
    end process pcreate_pixelpositions;
    -------------------------------------------------------------------------
    pfile_actions : process
            variable next_vector    : bit_vector (0 downto 0);
            variable actual_len     : natural;
            variable addr           : unsigned(17 downto 0) := (others => '0');
            variable to_write       : signed(15 downto 0);
            variable read_byte      : std_logic_vector(7 downto 0);
            function conv_std_logic_vector(ARG : integer; SIZE : integer) return std_logic_vector is
            variable result         : std_logic_vector (SIZE - 1 downto 0);
            variable temp           : integer;
            --file outfile          : text is out "RGB.txt";
            begin
            temp := ARG;
                for i in 0 to SIZE - 1 loop
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
            end;
            variable std_buffer     : character;
            variable outline        : line;
            variable cnt            : integer := 0;
            variable v_SPACE        : character := ' ';
            begin
            runFrame <= '1';
            --wait until startFrame = '1';
            -- COPY BMP HEADER LOCATION FOR BMP
--            for i in 1 to 51 loop
--                --read(read_file, next_vector, actual_len);
--                write(outline,(to_integer(unsigned(conv_std_logic_vector(bit'pos(next_vector(0)), 8)))));
--                writeline(write1file, outline);
--                std_buffer := character'val(to_integer(unsigned(conv_std_logic_vector(bit'pos(next_vector(0)), 8))));
--                write(write_file, std_buffer);
--            end loop;
--          for i in 1 to 51 loop
--              read(read_file, next_vector, actual_len);
--              write(outline, (to_integer(unsigned(conv_std_logic_vector(bit'pos(next_vector(0)), 8))));
--              writeline(outfile, outline);
--              std_buffer := character'val(to_integer(unsigned(conv_std_logic_vector(bit'pos(next_vector(0)), 8))));
--              write(write_file, std_buffer);
--          end loop;
            for i in 1 to 51 loop
                cnt := cnt + 1;
                --read(read_file, next_vector, actual_len);
                --write(outline,imageHeader(cnt));
                --writeline(write1file, outline);
                std_buffer := character'val(imageHeader(cnt));
                write(write_file, std_buffer);
            end loop;
            -- READ IN BMP COLOR DATA                   --HEIGHT * WIDTH * 3
            for y in 0 to img_height - 1 loop           --HEIGHT
                for x in 0 to img_width - 1 loop        --WIDTH
                    for c in 1 to 3 loop                --RGB   
                        read(read_file, next_vector, actual_len);
                        read_byte := conv_std_logic_vector(bit'pos(next_vector(0)), 8);
                        bmp_read(x, y)(c) <= read_byte;
                        --wait for 1 ns;--COPY CLK
                    end loop;
                end loop;
            end loop;
            running <= '1';
            wait until done = '1';
            -- WRITE RESULT TO BMP                  --HEIGHT * WIDTH * 3
            for y in 0 to img_height - 1 loop       --HEIGHT
                for x in 0 to img_width - 1 loop    --WIDTH
                    for c in 1 to 3 loop            --RGB
                    std_buffer := character'val(to_integer(unsigned(bmp_out(x, y)(c))));
                    write(write_file, std_buffer);
                    end loop;
                    write(outline,(to_integer(unsigned(bmp_out(x, y)(1)))));
                    write(outline,v_SPACE);
                    write(outline,(to_integer(unsigned(bmp_out(x, y)(2)))));
                    write(outline,v_SPACE);
                    write(outline,(to_integer(unsigned(bmp_out(x, y)(3)))));
                    writeline(write1file, outline);
                end loop;
            end loop;
            running <= '0';
            runFrame <= '0';
            wait;        
    end process pfile_actions;
    -------------------------------------------------------------------------
end Behavioral;