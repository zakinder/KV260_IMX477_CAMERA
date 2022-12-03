library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants_package.all;
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;
entity imageWrite is
generic (
    enImageText    : boolean := false;
    enImageIndex   : boolean := false;
    i_data_width   : integer := 8;
    img_width_bmp  : integer := 400;
    img_height_bmp : integer := 300;
    input_file     : string  := "input_image";
    output_file    : string  := "output_image");
port (
    clk            : in  std_logic;
    iFile          : in  channel;
    iFileCont      : in  cord;
    pixclk         : in  std_logic;
    enableWrite    : in  std_logic;
    doneWrite      : out std_logic;
    oCord          : out coord;
    oFrameEnable   : out std_logic;
    iRgb           : in  channel);
end imageWrite;
architecture Behavioral of imageWrite is 
    -------------------------------------------------------------------------
    constant read_fol             : string := "K:/ZEDBOARD/uvm_tb/VFP_TEST/dut/tb/uvm_images/read";
    constant write_fol            : string := "K:/ZEDBOARD/uvm_tb/VFP_TEST/dut/tb/uvm_images/write";
    constant write_fol_rgb_log    : string := "K:/ZEDBOARD/uvm_tb/VFP_TEST/dut/tb/uvm_images/write/log/rgb_values";
    constant write_fol_index_log  : string := "K:/ZEDBOARD/uvm_tb/VFP_TEST/dut/tb/uvm_images/write/log/index_rgb_values";
    constant write_fol_condi_log  : string := "K:/ZEDBOARD/uvm_tb/VFP_TEST/dut/tb/uvm_images/write/log/conditioned_index_rgb_values";
    constant write_fol_anl_log    : string := "K:/ZEDBOARD/uvm_tb/VFP_TEST/dut/tb/uvm_images/write/log/anl_index_rgb_values";
    constant bacslash             : string := "\";
    constant readbmp              : string := read_fol&bacslash&input_file&".bmp";
    constant wrBmp                : string := write_fol&bacslash&output_file&".bmp";
    constant wrBmpRgbLog          : string := write_fol_rgb_log&bacslash&output_file&".txt";
    constant wrBmpIndLog          : string := write_fol_index_log&bacslash&output_file&".txt";
    constant wrBmpConLog          : string := write_fol_condi_log&bacslash&output_file&".txt";
    constant wrBmpAnlLog          : string := write_fol_anl_log&bacslash&output_file&".txt";
    -------------------------------------------------------------------------
    type bitFile is file of bit_vector;
    file readFile             : bitFile open read_mode  is readbmp;
    type stdFile is file of character;
    file wrBmpfile            : stdFile open write_mode is wrBmp;
    file wrBmpLogRgbfile      : text open write_mode is wrBmpRgbLog;
    file wrBmpLogIndfile      : text open write_mode is wrBmpIndLog;
    file wrBmpLogConfile      : text open write_mode is wrBmpConLog;
    file wrBmpLogAnlfile      : text open write_mode is wrBmpAnlLog;
    type imageHeaderTable is array(0 to 60) of integer range 0 to 255;
    constant imageHeader      : imageHeaderTable := (0,66,77,54,192,0,0,0,0,0,0,54,0,0,0,40,0,0,0,128,0,0,0,128,0,0,0,1,0,24,0,0,0,0,0,0,192,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    type rgbPixel is array(1 to 3) of std_logic_vector(i_data_width-1 downto 0);
    type rgbFrame is array(0 to img_width_bmp -1, 0 to img_height_bmp -1) of rgbPixel;
    -------------------------------------------------------------------------
    signal rgbFile         : rgbFrame  := (others => (others => (others => (others => '0'))));
    signal rgbData         : rgbFrame  := (others => (others => (others => (others => '0'))));
    -------------------------------------------------------------------------
    signal Xcont           : integer   := 0;
    signal Ycont           : integer   := 0;
    signal wrImageFile     : std_logic := lo;
    signal frameEnable     : std_logic := lo;
    signal imageCompleted  : std_logic := lo;
    signal rgb             : channel   := (valid => lo, red => black, green => black, blue => black);
    signal pFile           : channel;
    signal pFileCont       : cord      := (x => 0, y => 0);
    -------------------------------------------------------------------------
begin
    oCord.x     <= std_logic_vector(to_unsigned(Xcont, 16));
    oCord.y     <= std_logic_vector(to_unsigned(Ycont, 16));
    doneWrite <= imageCompleted;
process (pixclk) begin
    if rising_edge(pixclk) then
        rgb   <= iRgb;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        pFileCont <= iFileCont;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
            rgbFile(pFileCont.x, pFileCont.y)(3) <= iFile.red;
            rgbFile(pFileCont.x, pFileCont.y)(2) <= iFile.green;
            rgbFile(pFileCont.x, pFileCont.y)(1) <= iFile.blue;
    end if;
end process;
frameEnable <= hi when (enableWrite = hi and imageCompleted = lo);
oFrameEnable <= hi when (enableWrite = hi and wrImageFile = lo) else lo;
process(pixclk)begin
    if rising_edge(pixclk) then
        if(frameEnable = hi) then
            if (rgb.valid = hi and wrImageFile = lo) then
                Xcont  <= Xcont + 1;
            end if;
            if(Xcont = img_width_bmp - 1)then
                Ycont  <= Ycont + 1;
                Xcont  <= 0;
            end if;
            if(Xcont = img_width_bmp - 1 and Ycont = img_height_bmp - 1)then
                Ycont  <= 0;
            end if;
            rgbData(Xcont, Ycont)(3) <= rgb.red;
            rgbData(Xcont, Ycont)(2) <= rgb.green;
            rgbData(Xcont, Ycont)(1) <= rgb.blue;
        end if;        
    end if;
end process;
process(Ycont,Xcont)begin
    if (Xcont = img_width_bmp - 1 and Ycont = img_height_bmp - 1) then
        wrImageFile <= hi;
    end if;
end process;
process
    variable stdBuffer         : character;
    variable outLine           : line;
    variable outLine2          : line;
    variable analysisLine      : line;
    variable pixelValLine      : line;
    constant headerBar         : string  := "|-----------|-------------";
    constant header            : string  := "|iR  iG  iB | oR  oG  oB  ";
    constant header2           : string  := "INDEX  ROW  COLUMN |iR  iG  iB | oR  oG  oB";
    constant CuRedVal          : string  := "CuRedVal= ";
    constant CuMaxRed          : string  := "CuMaxRed= ";
    constant CuRowMaxRed       : string  := "CuRowMaxAvgRed= ";
    constant LtRowMaxRed       : string  := "LtRowMaxRed= ";
    constant avgRedheader      : string  := "AvgRed= ";
    constant maxGreheader      : string  := "Max Gre = ";
    constant avgGreheader      : string  := "Avg Gre = ";
    constant maxBluheader      : string  := "Max Blu = ";
    constant avgBluheader      : string  := "Avg Blu = ";
    variable pixelIndex        : integer := 0;
    variable rowIndex          : integer := 0;
    variable pixelLocation     : integer := 0;
    variable pRedStatus        : integer := 0;
    variable pGreStatus        : integer := 0;
    variable pBluStatus        : integer := 0;
    variable p1RedStatus       : integer := 0;
    variable p1GreStatus       : integer := 0;
    variable p1BluStatus       : integer := 0;
    variable fRedStatus        : integer := 0;
    variable fGreStatus        : integer := 0;
    variable fBluStatus        : integer := 0;
    variable maxRedStatus      : integer := 0;
    variable maxGreStatus      : integer := 0;
    variable maxBluStatus      : integer := 0;
    variable avgRedStatus      : integer := 0;
    variable avgGreStatus      : integer := 0;
    variable avgBluStatus      : integer := 0;
    variable rowAvgMaxRed      : integer := 0;
    variable rowAvgMaxSetRed   : integer := 0;
    variable charSpace         : character := ' ';
    variable charBar           : character := '|';
    variable nBitVale          : bit_vector (0 downto 0);
    variable actual_len        : natural;
    begin
    wait until wrImageFile = hi;
    write(pixelValLine,headerBar);
    writeline(wrBmpLogRgbfile,pixelValLine);
    write(pixelValLine,header);
    writeline(wrBmpLogRgbfile,pixelValLine);
    write(pixelValLine,headerBar);
    writeline(wrBmpLogRgbfile,pixelValLine);
    write(outLine,header2);
    writeline(wrBmpLogIndfile,outLine);
    write(outLine,header2);
    writeline(wrBmpLogConfile,outLine);
    for i in 0 to 53 loop
        read(readFile, nBitVale, actual_len);
        stdBuffer := character'val(to_integer(unsigned(conv_std_logic_vector(bit'pos(nBitVale(0)), 8))));
        write(wrBmpfile, stdBuffer);
    end loop;
    for y in 0 to img_height_bmp loop
        rowIndex      := rowIndex + 1;
        pixelLocation := 0;
        maxRedStatus  := 0;
        for x in 0 to img_width_bmp - 1 loop
            for c in 1 to 3 loop
                if (pixelIndex > 18) and (y < img_height_bmp) then
                    stdBuffer := character'val(to_integer(unsigned(rgbData(x, y)(c))));
                    write(wrBmpfile, stdBuffer);
                end if;
                if (y = img_height_bmp) and (x < 20)  then
                    stdBuffer := character'val(to_integer(unsigned(rgbData(x, y-1)(c))));
                    write(wrBmpfile, stdBuffer);
                end if;
            end loop;
            if(y < img_height_bmp) then
            ------------------------------------------------------------------
            pixelLocation := pixelLocation + 1;
            pixelIndex    := pixelIndex + 1;
            -------------------------------
            fRedStatus    := (to_integer(unsigned(rgbFile(x, y)(3))));
            fGreStatus    := (to_integer(unsigned(rgbFile(x, y)(2))));
            fBluStatus    := (to_integer(unsigned(rgbFile(x, y)(1))));
            -------------------------------
            pRedStatus    := (to_integer(unsigned(rgbData(x, y)(3))));
            pGreStatus    := (to_integer(unsigned(rgbData(x, y)(2))));
            pBluStatus    := (to_integer(unsigned(rgbData(x, y)(1))));
            -------------------------------
            if(x < img_width_bmp - 1)then
                p1RedStatus   := (to_integer(unsigned(rgbData(x+1, y)(3))));
                p1GreStatus   := (to_integer(unsigned(rgbData(x+1, y)(2))));
                p1BluStatus   := (to_integer(unsigned(rgbData(x+1, y)(1))));
            else
                p1RedStatus   := (to_integer(unsigned(rgbData(x, y)(3))));
                p1GreStatus   := (to_integer(unsigned(rgbData(x, y)(2))));
                p1BluStatus   := (to_integer(unsigned(rgbData(x, y)(1))));
            end if;
            if(maxRedStatus < pRedStatus) and (pRedStatus < 255)then
                if(p1RedStatus = 255)  and (pRedStatus /= 0) then
                    maxRedStatus  := pRedStatus;
                else
                    if(p1RedStatus /= 0) then
                        maxRedStatus  := max(pRedStatus,p1RedStatus);
                    end if;
                end if;
            end if;
            if(x = img_width_bmp - 1) then
                if (maxRedStatus /= 0) then
                    rowAvgMaxRed := maxRedStatus;
                else
                    rowAvgMaxRed := rowAvgMaxSetRed;
                end if;
            end if;
            if(maxRedStatus /= 0) then
                rowAvgMaxSetRed := (rowAvgMaxRed + maxRedStatus)/2;
            end if;
            avgRedStatus  := (pRedStatus+p1RedStatus)/2;
            write(analysisLine,rowIndex);
                if (rowIndex < 10) then
                    write(analysisLine,charSpace);
                    write(analysisLine,charSpace);
                    write(analysisLine,charSpace);
                    write(analysisLine,charSpace);
                elsif(rowIndex < 100) then
                    write(analysisLine,charSpace);
                    write(analysisLine,charSpace);
                    write(analysisLine,charSpace);
                elsif(rowIndex < 1000) then
                    write(analysisLine,charSpace);
                    write(analysisLine,charSpace);
                else
                    write(analysisLine,charSpace);
                end if;
            write(analysisLine,pRedStatus);
                    if (pRedStatus < 10) then
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                    elsif(pRedStatus < 100) then
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                    else
                        write(analysisLine,charSpace);
                    end if;
            write(analysisLine,CuMaxRed);
            write(analysisLine,maxRedStatus);
                    if (maxRedStatus < 10) then
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                    elsif(maxRedStatus < 100) then
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                    else
                        write(analysisLine,charSpace);
                    end if;
            write(analysisLine,CuRowMaxRed);
            write(analysisLine,rowAvgMaxSetRed);
                    if (rowAvgMaxSetRed < 10) then
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                    elsif(rowAvgMaxSetRed < 100) then
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                    else
                        write(analysisLine,charSpace);
                    end if;
            write(analysisLine,LtRowMaxRed);
            write(analysisLine,rowAvgMaxRed);
                     if (rowAvgMaxRed < 10) then
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                    elsif(rowAvgMaxRed < 100) then
                        write(analysisLine,charSpace);
                        write(analysisLine,charSpace);
                    else
                        write(analysisLine,charSpace);
                    end if;
            write(analysisLine,avgRedheader);
            write(analysisLine,avgRedStatus);
            writeline(wrBmpLogAnlfile, analysisLine);
            -- IndexValLine --------------------------------------------------
            if(enImageText = True) then
                    if(enImageIndex = True) then
                        write(outLine,pixelIndex);
                            if (pixelIndex < 10) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            elsif(pixelIndex < 100) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            elsif(pixelIndex < 1000) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            elsif(pixelIndex < 10000) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            elsif(pixelIndex < 100000) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            else
                                write(outLine,charSpace);
                            end if;
                        write(outLine,rowIndex);
                            if (rowIndex < 10) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            elsif(rowIndex < 100) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            elsif(rowIndex < 1000) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            else
                                write(outLine,charSpace);
                            end if;
                        write(outLine,pixelLocation);
                            if (pixelLocation < 10) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            elsif(pixelLocation < 100) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            elsif(pixelLocation < 1000) then
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            else
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                                write(outLine,charSpace);
                            end if;
                    end if;
                ------------------------------------------ Orginal Data
                write(outLine,charBar);
                write(outLine,fRedStatus);
                    if (fRedStatus < 10) then
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                    elsif(fRedStatus < 100) then
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                    else
                        write(outLine,charSpace);
                    end if;
                write(outLine,fGreStatus);
                    if (fGreStatus < 10) then
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                    elsif(fGreStatus < 100) then
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                    else
                        write(outLine,charSpace);
                    end if;
                write(outLine,fBluStatus);
                    if (fBluStatus < 10) then
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                        write(outLine,charBar);
                        write(outLine,charSpace);
                    elsif(fBluStatus < 100) then
                        write(outLine,charSpace);
                        write(outLine,charBar);
                        write(outLine,charSpace);
                    else
                        write(outLine,charBar);
                        write(outLine,charSpace);
                    end if;
                ------------------------------------------ 
                write(outLine,pRedStatus);
                    if (pRedStatus < 10) then
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                    elsif(pRedStatus < 100) then
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                    else
                        write(outLine,charSpace);
                    end if;
                write(outLine,pGreStatus);
                    if (pGreStatus < 10) then
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                    elsif(pGreStatus < 100) then
                        write(outLine,charSpace);
                        write(outLine,charSpace);
                    else
                        write(outLine,charSpace);
                    end if;
                write(outLine,pBluStatus);
                outLine2 :=outLine;
                writeline(wrBmpLogIndfile, outLine);
                -- pixelValLine --------------------------------------------------
                if (pRedStatus > 0) and (pGreStatus > 0) and (pBluStatus > 0) then
                    writeline(wrBmpLogConfile, outLine2);
                end if;
                -- pixelValLine --------------------------------------------------
                ------------------------------------------ Orginal Data
                write(pixelValLine,charBar);
                write(pixelValLine,fRedStatus);
                    if (fRedStatus < 10) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                    elsif(fRedStatus < 100) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                    else
                        write(pixelValLine,charSpace);
                    end if;
                write(pixelValLine,fGreStatus);
                    if (fGreStatus < 10) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                    elsif(fGreStatus < 100) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                    else
                        write(pixelValLine,charSpace);
                    end if;
                write(pixelValLine,fBluStatus);
                    if (fBluStatus < 10) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charBar);
                        write(pixelValLine,charSpace);
                    elsif(fBluStatus < 100) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charBar);
                        write(pixelValLine,charSpace);
                    else
                        write(pixelValLine,charBar);
                        write(pixelValLine,charSpace);
                    end if;
                ------------------------------------------
                ------------------------------------------ Modified Data
                write(pixelValLine,pRedStatus);
                    if (pRedStatus < 10) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                    elsif(pRedStatus < 100) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                    else
                        write(pixelValLine,charSpace);
                    end if;
                write(pixelValLine,pGreStatus);
                    if (pGreStatus < 10) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                    elsif(pGreStatus < 100) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                    else
                        write(pixelValLine,charSpace);
                    end if;
                write(pixelValLine,pBluStatus);
                    if (pBluStatus < 10) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                    elsif(pBluStatus < 100) then
                        write(pixelValLine,charSpace);
                        write(pixelValLine,charSpace);
                    else
                        write(pixelValLine,charSpace);
                    end if;
                writeline(wrBmpLogRgbfile,pixelValLine);
                ------------------------------------------------------------------
            end if;    
            end if;
        end loop;
    end loop;
    wait for 10 ns;
    imageCompleted <= hi;
    wait;   
    --assert false
    --report "simulation ended"
    --severity failure;
end process;
end Behavioral;