library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants_package.all;
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;
entity imageRead is
generic (
    i_data_width       : integer := 8;
    img_width_bmp      : integer := 400;
    img_height_bmp     : integer := 300;
    img_frames_cnt_bmp : integer := 2;
    input_file         : string  := "input_image");
port (
    clk                : in  std_logic;
    reset              : in  std_logic;
    readyToRead        : in  std_logic;
    fvalid             : out std_logic;
    lvalid             : out std_logic;
    oRgb               : out channel;
    oFileCont          : out cord;
    oCord              : out coord;
    endOfFrame         : out std_logic);
end imageRead;
architecture Behavioral of imageRead is 
    -------------------------------------------------------------------------
    constant proj_fol  : string := "R:/KV260/uvm_tb/VFP_TEST/dut/tb/uvm_images/read";
    constant bacslash  : string := "/";
    constant readbmp   : string := proj_fol&bacslash&input_file&".bmp";
    -------------------------------------------------------------------------
    type bit_file is file of bit_vector;
    file read_file      : bit_file open read_mode  is readbmp;
    type t_color is array(1 to 3) of std_logic_vector(i_data_width-1 downto 0);
    type t_bmp is array(0 to img_width_bmp -1, 0 to img_height_bmp -1) of t_color;
    signal bmp_read     : t_bmp;
    signal SetToRead    : std_logic := lo;
    signal lineValid    : std_logic := lo;
    signal Xcont        : integer := 0;
    signal Ycont        : integer := 0;
    signal xImagecont   : integer := 0;
    signal yImagecont   : integer := 0;
    signal i_count      : integer := 0;
    signal olm          : rgbConstraint;
    signal initFrame    : std_logic := lo;
    signal startFrame   : std_logic := lo;
begin 
--  endOfFrame   <= hi when (Xcont = img_width_bmp and Ycont = img_height_bmp - 1 and SetToRead = hi and i_count = (img_frames_cnt_bmp-1));-- else lo;
--  endOfFrame   <= hi when (Xcont = img_width_bmp + 2 and Ycont = img_height_bmp + 2 and SetToRead = hi and i_count = (img_frames_cnt_bmp-1));-- else lo;
    endOfFrame   <= hi when (Xcont = img_width_bmp and Ycont = img_height_bmp + 2 and SetToRead = hi) else lo;
    oRgb.valid  <= lineValid when (Xcont < img_width_bmp and Ycont < img_height_bmp and SetToRead = hi) else lo;
    oCord.x     <= std_logic_vector(to_unsigned(xImagecont, 16));
    oCord.y     <= std_logic_vector(to_unsigned(yImagecont, 16));
    
    oFileCont.x     <= xImagecont;
    oFileCont.y     <= yImagecont;
    initFrame       <= hi when (SetToRead = hi and readyToRead = hi and i_count <= img_frames_cnt_bmp) else lo;
    -------------------------------------------------------------------------
    pcreate_pixelpositions: process(clk,reset)begin
        if (reset = lo) then
            oRgb.red     <= (others => '0');
            oRgb.green   <= (others => '0');
            oRgb.blue    <= (others => '0');
            olm.rl       <= 0;
            olm.rh       <= 0;
            olm.gl       <= 0;
            olm.gh       <= 0;
            olm.bl       <= 0;
            olm.bh       <= 0;
            lvalid       <= lo;
            fvalid       <= lo;
        elsif rising_edge(clk) then
            startFrame <= initFrame;
            if(Ycont < img_height_bmp)then
                fvalid  <= initFrame;
            else
                fvalid  <= lo;
            end if;
            if (startFrame = hi) then
                if(Xcont < img_width_bmp + 3 and Ycont < img_height_bmp + 3)then
                    Xcont  <= Xcont + 1;
                else
                    Xcont  <= 0;
                end if;
                if(Xcont < img_width_bmp and Ycont < img_height_bmp)then
                    xImagecont  <= Xcont;
                    lineValid   <= hi;
                    lvalid      <= hi;
                else
                    xImagecont  <= 0;
                    lineValid   <= lo;
                    lvalid      <= lo;
                    
                end if;
                if(Xcont = img_width_bmp + 1 and Ycont < img_height_bmp + 3)then
                    Ycont  <= Ycont + 1;
                elsif(Xcont = img_width_bmp + 2 and Ycont = img_height_bmp + 3)then
                    Ycont  <= 0;
                else
                    Ycont  <= Ycont;
                end if;
                if(Ycont < img_height_bmp)then
                    yImagecont  <= Ycont;
                else
                    yImagecont  <= 0;
                end if;
                if(xImagecont = img_width_bmp - 1 and yImagecont = img_height_bmp - 1)then
                    i_count   <= i_count + 1;
                    report "i_count incremented"; -- severity note
                end if;
                if (i_count = 0) then
                    olm.rl <= 60;
                    olm.rh <= 255;
                    olm.gl <= 60;
                    olm.gh <= 255;
                    olm.bl <= 60;
                    olm.bh <= 255;
                elsif (i_count = 1) then
                    olm.rl <= 60;
                    olm.rh <= 255;
                    olm.gl <= 60;
                    olm.gh <= 255;
                    olm.bl <= 60;
                    olm.bh <= 255;
                elsif (i_count = 2) then
                    olm.rl <= 60;
                    olm.rh <= 255;
                    olm.gl <= 60;
                    olm.gh <= 255;
                    olm.bl <= 60;
                    olm.bh <= 255;
                elsif (i_count = 3) then
                    olm.rl <= 60;
                    olm.rh <= 255;
                    olm.gl <= 60;
                    olm.gh <= 255;
                    olm.bl <= 60;
                    olm.bh <= 255;
                elsif (i_count = 4) then
                    olm.rl <= 60;
                    olm.rh <= 255;
                    olm.gl <= 60;
                    olm.gh <= 255;
                    olm.bl <= 60;
                    olm.bh <= 255;
                else
                    olm.rl <= 60;
                    olm.rh <= 255;
                    olm.gl <= 60;
                    olm.gh <= 255;
                    olm.bl <= 60;
                    olm.bh <= 255;
                end if;
                oRgb.red     <= bmp_read(xImagecont, yImagecont)(3);
                oRgb.green   <= bmp_read(xImagecont, yImagecont)(2);
                oRgb.blue    <= bmp_read(xImagecont, yImagecont)(1);
            else
                oRgb.red     <= (others => '0');
                oRgb.green   <= (others => '0');
                oRgb.blue    <= (others => '0');
                olm.rl <= 0;
                olm.rh <= 0;
                olm.gl <= 0;
                olm.gh <= 0;
                olm.bl <= 0;
                olm.bh <= 0;
            end if;
        end if;
    end process pcreate_pixelpositions;
    -------------------------------------------------------------------------
    pfile_actions : process
            variable next_vector    : bit_vector (0 downto 0);
            variable actual_len     : natural;
            variable read_byte      : std_logic_vector(7 downto 0);
            begin
            -- READ IN BMP COLOR DATA                   --HEIGHT * WIDTH * 3
            for y in 0 to img_height_bmp - 1 loop       --HEIGHT
                for x in 0 to img_width_bmp - 1 loop    --WIDTH
                    for c in 1 to 3 loop                --RGB   
                        read(read_file, next_vector, actual_len);
                        read_byte := conv_std_logic_vector(bit'pos(next_vector(0)), 8);
                        bmp_read(x, y)(c) <= read_byte;
                    end loop;
                end loop;
            end loop;
            wait for 10 ns;
            SetToRead <= hi;
            wait;        
    end process pfile_actions;
end Behavioral;