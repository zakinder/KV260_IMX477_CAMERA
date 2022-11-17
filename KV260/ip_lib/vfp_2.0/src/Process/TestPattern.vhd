-------------------------------------------------------------------------------
--
-- Filename    : testpattern.vhd
-- Create Date : 01062019 [01-06-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity testpattern is
port (
    clk                   : in std_logic;
    iRgb                  : in channel;
    iCord                 : in coord;
    tpSelect              : in integer;
    oRgb                  : out channel);
end testpattern;
architecture arch_imp of testpattern is
    signal fTestPattern        : blurchannel;
    signal rTestPattern        : channel;
    signal rgbCo               : channel;
    signal rgbRed              : channel;
    signal rgbGre              : channel;
    signal rgbBlu              : channel;
    signal Rcont               : integer := 255;
    signal Bcont               : integer := 0;
    signal Gcont               : integer := 0;
    signal Ycont               : integer := 0;
    signal Xcont               : integer := 0;
    signal xCounter            : natural := 0;
    signal yCounter            : natural := 0;
    signal flag                : std_logic := '0';
begin
    xCounter    <= to_integer(unsigned(iCord.x));
    yCounter    <= to_integer(unsigned(iCord.y));
FrameTestPatternInst: frame_testpattern
generic map(
    s_data_width => 16)
port map(
    clk          => clk,
    iValid       => iRgb.valid,
    iCord        => iCord,
    oRgb         => fTestPattern);
ResoTestPatternInst: ResoTestPattern
generic map(
    s_data_width => 16)
port map(
    clk          => clk,
    iValid       => iRgb.valid,
    iCord        => iCord,
    oRgbCo       => rgbCo,
    oRgbRed      => rgbRed,
    oRgbGre      => rgbGre,
    oRgbBlu      => rgbBlu);
process (clk) begin
    if rising_edge(clk) then
            oRgb.sof       <= iRgb.sof;
            oRgb.eol       <= iRgb.eol;
            oRgb.eof       <= iRgb.eof;
            oRgb.xcnt      <= iRgb.xcnt;
            oRgb.ycnt      <= iRgb.ycnt;
        if(tpSelect = 0)then
            oRgb.valid     <= fTestPattern.valid;
            oRgb.red       <= fTestPattern.red(9 downto 0);
            oRgb.green     <= fTestPattern.green(9 downto 0);
            oRgb.blue      <= fTestPattern.blue(9 downto 0);
        elsif(tpSelect = 1)then
            oRgb.valid     <= fTestPattern.valid;
            oRgb.red       <= "00" & x"0" & fTestPattern.red(3 downto 0);
            oRgb.green     <= "00" & x"0" & fTestPattern.green(7 downto 4);
            oRgb.blue      <= "00" & x"0" & fTestPattern.blue(11 downto 8);
        elsif(tpSelect = 2)then
            oRgb.valid     <= fTestPattern.valid;
            oRgb.red       <= fTestPattern.red(9 downto 0);
            oRgb.green     <= "00" & x"0" & fTestPattern.green(7 downto 4);
            oRgb.blue      <= "00" & x"0" & fTestPattern.blue(11 downto 8);
        elsif(tpSelect = 3)then
            oRgb.valid     <= fTestPattern.valid;
            oRgb.red       <= "00" & x"0" & fTestPattern.red(3 downto 0);
            oRgb.green     <= fTestPattern.green(9 downto 0);
            oRgb.blue      <= "00" & x"0" & fTestPattern.blue(11 downto 8);
        elsif(tpSelect = 4)then
            oRgb.valid     <= fTestPattern.valid;
            oRgb.red       <= "00" & x"0" & fTestPattern.red(3 downto 0);
            oRgb.green     <= "00" & x"0" & fTestPattern.green(7 downto 4);
            oRgb.blue      <= fTestPattern.blue(9 downto 0);
        elsif(tpSelect = 5)then
            oRgb.valid     <= rgbCo.valid;
            oRgb.red       <= rgbCo.red;
            oRgb.green     <= rgbCo.green;
            oRgb.blue      <= rgbCo.blue;
        elsif(tpSelect = 6)then
            oRgb.valid     <= rgbRed.valid;
            oRgb.red       <= rgbRed.red;
            oRgb.green     <= rgbRed.green;
            oRgb.blue      <= rgbRed.blue;
        elsif(tpSelect = 7)then
            oRgb.valid     <= rgbGre.valid;
            oRgb.red       <= rgbGre.red;
            oRgb.green     <= rgbGre.green;
            oRgb.blue      <= rgbGre.blue;
        elsif(tpSelect = 8)then
            oRgb.valid     <= rgbBlu.valid;
            oRgb.red       <= rgbBlu.red;
            oRgb.green     <= rgbBlu.green;
            oRgb.blue      <= rgbBlu.blue;
        elsif(tpSelect = 9)then
            oRgb.valid     <= iRgb.valid;
            oRgb.red       <= std_logic_vector(to_unsigned(1023,10));
            oRgb.green     <= std_logic_vector(to_unsigned(0,10));
            oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        elsif(tpSelect = 10)then
            oRgb.valid     <= iRgb.valid;
            oRgb.red       <= std_logic_vector(to_unsigned(0,10));
            oRgb.green     <= std_logic_vector(to_unsigned(1023,10));
            oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        elsif(tpSelect = 11)then
            oRgb.valid     <= iRgb.valid;
            oRgb.red       <= std_logic_vector(to_unsigned(0,10));
            oRgb.green     <= std_logic_vector(to_unsigned(0,10));
            oRgb.blue      <= std_logic_vector(to_unsigned(1023,10));
        elsif(tpSelect = 12)then
            oRgb.valid     <= iRgb.valid;
            oRgb.red       <= std_logic_vector(to_unsigned(1023,10));
            oRgb.green     <= std_logic_vector(to_unsigned(1023,10));
            oRgb.blue      <= std_logic_vector(to_unsigned(1023,10));
        elsif(tpSelect = 13)then
            oRgb.valid     <= iRgb.valid;
            if(iRgb.valid = '1') then
                if(Gcont<255 and flag = '0') then
                    Gcont <= Gcont+1;
                else
                        if(Gcont=255 and flag = '0') then
                            if(Rcont>0) then
                                Rcont <= Rcont-1;
                            end if;
                            if(Rcont=0) then
                                if(Bcont<255) then
                                    Bcont <= Bcont+1;
                                end if;
                                if(Bcont=255) then
                                    flag <='1';
                                end if;
                            end if;
                        else
                            if(Gcont>0) then
                                Gcont <= Gcont-1;
                            end if;
                            if(Gcont=0) then
                                if(Rcont<255) then
                                    Rcont <= Rcont+1;
                                end if;
                                if(Rcont=255) then
                                    if(Bcont>0) then
                                        Bcont <= Bcont-1;
                                    end if;
                                end if;
                            end if;
                        end if;
                end if;
            else

                
                Rcont <= 255;
                Gcont <= 0;
                Bcont <= 0;
                flag  <='0';
            end if;

            
                oRgb.red       <= std_logic_vector(to_unsigned(Rcont,10));
                oRgb.green     <= std_logic_vector(to_unsigned(Gcont,10));
                oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,10));
        elsif(tpSelect = 14)then
            oRgb.valid     <= iRgb.valid;
            if(xCounter > 0 and xCounter < 1531) then
            ---------------------------
                                      ---------------------------
                                       if(Gcont<255 and flag = '0') then
                                               Gcont <= Gcont+1;
                                       else
                                               if(Gcont=255 and flag = '0') then
                                                   if(Rcont>0) then
                                                       Rcont <= Rcont-1;
                                                   end if;
                                                   if(Rcont=0) then
                                                       if(Bcont<255) then
                                                           Bcont <= Bcont+1;
                                                       end if;
                                                       if(Bcont=255) then
                                                           flag <='1';
                                                       end if;
                                                   end if;
                                               else
                                                   if(Gcont>0) then
                                                       Gcont <= Gcont-1;
                                                   end if;
                                                   if(Gcont=0) then
                                                       if(Rcont<255) then
                                                           Rcont <= Rcont+1;
                                                       end if;
                                                       if(Rcont=255) then
                                                           if(Bcont>0) then
                                                               Bcont <= Bcont-1;
                                                           end if;
                                                       end if;
                                                   end if;
                                               end if;
                                       end if;
                                      ---------------------------
                                       if(Bcont = 1 and flag = '1')then
                                           if(Ycont<255)then
                                               Ycont <= Ycont+1;
                                           else
                                               Ycont <= 0;
                                           end if;
                                       end if;
                                      ---------------------------
            ---------------------------
            else
            ---------------------------
            if(xCounter = 1531)then
                Rcont <= 255;
                Gcont <= Ycont;
                Bcont <= Ycont;
                flag  <='0';
            end if;
            
            

                
            end if;
            ---------------------------
                oRgb.red       <= std_logic_vector(to_unsigned(Rcont,10));
                oRgb.green     <= std_logic_vector(to_unsigned(Gcont,10));
                oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,10));
        --elsif(tpSelect = 14)then
        --    oRgb.valid     <= iRgb.valid;
        --    --RGB BARS
        --    if(iRgb.xcnt<640)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(iRgb.xcnt,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt<1280)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(iRgb.xcnt,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    else
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(iRgb.xcnt,10));
        --    end if;
        
        
        elsif(tpSelect = 15)then
            oRgb.valid     <= iRgb.valid;
            if(xCounter > 0 and xCounter < 1531)then
                if(Gcont<255 and flag = '0') then
                        Gcont <= Gcont+1;
                else
                        if(Gcont=255 and flag = '0') then
                            if(Rcont>0) then
                                Rcont <= Rcont-1;
                            end if;
                            if(Rcont=0) then
                                if(Bcont<255) then
                                    Bcont <= Bcont+1;
                                end if;
                                if(Bcont=255) then
                                    flag <='1';
                                end if;
                            end if;
                        else
                            if(Gcont>0) then
                                Gcont <= Gcont-1;
                            end if;
                            if(Gcont=0) then
                                if(Rcont<255) then
                                    Rcont <= Rcont+1;
                                end if;
                                if(Rcont=255) then
                                    if(Bcont>0) then
                                        Bcont <= Bcont-1;
                                    end if;
                                end if;
                            end if;
                        end if;
                end if;
                if(Bcont = 1 and flag = '1')then
                    if(Ycont<255)then
                        Ycont <= Ycont+1;
                    else
                        Ycont <= 0;
                    end if;
                end if;
                if(Ycont = 1)then
                    if(Xcont<255)then
                        Xcont <= Xcont+1;
                    else
                        Xcont <= 0;
                    end if;
                end if;
            else
                if(xCounter = 1532)then
                    Rcont <= 255;
                    Gcont <= Xcont;
                    Bcont <= Ycont;
                    flag  <='0';
                end if;
            end if;
                oRgb.red       <= std_logic_vector(to_unsigned(Rcont,10));
                oRgb.green     <= std_logic_vector(to_unsigned(Gcont,10));
                oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,10));

        elsif(tpSelect = 16)then
            oRgb.valid     <= iRgb.valid;
            if(iRgb.valid = '1') then
                if(Gcont<255 and flag = '0') then
                        Gcont <= Gcont+1;
                else
                        if(Gcont=255 and flag = '0') then
                            if(Rcont>0) then
                                Rcont <= Rcont-1;
                            end if;
                            if(Rcont=0) then
                                if(Bcont<255) then
                                    Bcont <= Bcont+1;
                                end if;
                                if(Bcont=255) then
                                    flag <='1';
                                end if;
                            end if;
                        else
                            if(Gcont>0) then
                                Gcont <= Gcont-1;
                            end if;
                            if(Gcont=0) then
                                if(Rcont<255) then
                                    Rcont <= Rcont+1;
                                end if;
                                if(Rcont=255) then
                                    if(Bcont>0) then
                                        Bcont <= Bcont-1;
                                    end if;
                                end if;
                            end if;
                        end if;
                end if;
                if(Rcont = 1)then
                    if(Ycont<255)then
                        Ycont <= Ycont+1;
                    else
                        Ycont <= 0;
                    end if;
                end if;
                if(Ycont = 1)then
                    if(Xcont<255)then
                        Xcont <= Xcont+1;
                    else
                        Xcont <= 0;
                    end if;
                end if;
            else
                Rcont <= 255;
                Gcont <= yCounter;
                Bcont <= yCounter;
                flag  <='0';
            end if;
                oRgb.red       <= std_logic_vector(to_unsigned(Rcont,10));
                oRgb.green     <= std_logic_vector(to_unsigned(Gcont,10));
                oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,10));
        elsif(tpSelect = 17)then
            oRgb.valid     <= iRgb.valid;
            if(iRgb.valid = '1') then
                if(Gcont<255 and flag = '0') then
                        Gcont <= Gcont+1;
                else
                        if(Gcont=255 and flag = '0') then
                            if(Rcont>0) then
                                Rcont <= Rcont-1;
                            end if;
                            if(Rcont=0) then
                                if(Bcont<255) then
                                    Bcont <= Bcont+1;
                                end if;
                                if(Bcont=255) then
                                    flag <='1';
                                end if;
                            end if;
                        else
                            if(Gcont>0) then
                                Gcont <= Gcont-1;
                            end if;
                            if(Gcont=0) then
                                if(Rcont<255) then
                                    Rcont <= Rcont+1;
                                end if;
                                if(Rcont=255) then
                                    if(Bcont>0) then
                                        Bcont <= Bcont-1;
                                    end if;
                                end if;
                            end if;
                        end if;
                end if;
                if(Rcont = 1)then
                    if(Ycont<255)then
                        Ycont <= Ycont+1;
                    else
                        Ycont <= 0;
                    end if;
                end if;
                if(Ycont = 1)then
                    if(Xcont<255)then
                        Xcont <= Xcont+1;
                    else
                        Xcont <= 0;
                    end if;
                end if;
            else
                Rcont <= 255;
                Gcont <= 0;
                Bcont <= yCounter;
                flag  <='0';
            end if;
                oRgb.red       <= std_logic_vector(to_unsigned(Rcont,10));
                oRgb.green     <= std_logic_vector(to_unsigned(Gcont,10));
                oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,10));
        
        --elsif(tpSelect = 15)then
        --    oRgb.valid     <= iRgb.valid;
        --    --RGB BARS
        --    if(iRgb.xcnt<640)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(iRgb.xcnt,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(iRgb.ycnt,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(1080-iRgb.ycnt,10));
        --    elsif(iRgb.xcnt<1280)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(1080-iRgb.ycnt,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(iRgb.xcnt,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(iRgb.ycnt,10));
        --    else
        --        oRgb.red       <= std_logic_vector(to_unsigned(iRgb.ycnt,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(1080-iRgb.ycnt,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(iRgb.xcnt,10));
        --    end if;
        --elsif(tpSelect = 16)then
        --    oRgb.valid     <= iRgb.valid;
        --    --RGB BARS
        --    if(iRgb.xcnt<640)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt<1280)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    else
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(1023,10));
        --    end if;
        --elsif(tpSelect = 17)then
        --    oRgb.valid     <= iRgb.valid;
        --    --RGB BARS
        --    if(iRgb.xcnt<640)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(512,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(128,10));
        --    elsif(iRgb.xcnt<1280)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(128,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(512,10));
        --    else
        --        oRgb.red       <= std_logic_vector(to_unsigned(512,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(128,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(1023,10));
        --    end if;
        --elsif(tpSelect = 18)then
        --    oRgb.valid     <= iRgb.valid;
        --    --3 Pixels Test
        --    if(iRgb.xcnt=0 and iRgb.ycnt=0)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt=1 and iRgb.ycnt=0)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt=2 and iRgb.ycnt=0)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(1023,10));
        --    else
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    end if;
        --elsif(tpSelect = 19)then
        --    oRgb.valid     <= iRgb.valid;
        --    --3 Pixels Test
        --    if(iRgb.xcnt=0)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt=1)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt=2)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(1023,10));
        --    else
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    end if;
        --elsif(tpSelect = 20)then
        --    oRgb.valid     <= iRgb.valid;
        --    --3 Pixels Test
        --    if(iRgb.xcnt<3)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt<6)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt<9)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(1023,10));
        --    else
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    end if;
        --elsif(tpSelect = 21)then
        --    oRgb.valid     <= iRgb.valid;
        --    --3 Pixels Test
        --    if(iRgb.xcnt=0 and iRgb.ycnt<5)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(429,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt=1 and iRgb.ycnt<5)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(429,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt=2 and iRgb.ycnt<5)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(429,10));
        --    else
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    end if;
        --elsif(tpSelect = 22)then
        --    oRgb.valid     <= iRgb.valid;
        --    --3 Pixels Test
        --    if(iRgb.xcnt=10 and iRgb.ycnt=1)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt=11 and iRgb.ycnt=1)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(1023,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    elsif(iRgb.xcnt=12 and iRgb.ycnt=1)then
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(1023,10));
        --    else
        --        oRgb.red       <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.green     <= std_logic_vector(to_unsigned(0,10));
        --        oRgb.blue      <= std_logic_vector(to_unsigned(0,10));
        --    end if;
        else
            oRgb.valid     <= iRgb.valid;
            oRgb.red       <= iRgb.red;
            oRgb.green     <= iRgb.green;
            oRgb.blue      <= iRgb.blue;
        end if;
    end if;
end process;
end arch_imp;