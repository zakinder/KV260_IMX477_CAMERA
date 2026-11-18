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
    signal ORcont              : integer := 0;
    signal YGcont              : integer := 0;
    signal XBcont              : integer := 0;
    signal YAcont              : integer := 0;
    signal AAcont              : integer := 0;
    signal Rcont               : integer := 255;
    signal Bcont               : integer := 0;
    signal Gcont               : integer := 0;
    signal Ycont               : integer := 0;
    signal Xcont               : integer := 0;
    signal Ocont               : integer := 255;
    signal xCounter            : natural := 0;
    signal yCounter            : natural := 0;
    signal flag                : std_logic := '0';
    signal flag2               : std_logic := '0';
    signal flag3               : std_logic := '0';
    signal flag5               : std_logic := '0';
    signal flag6               : std_logic := '0';
    signal flag1               : std_logic := '0';
    signal flag4               : std_logic_vector(3 downto 0) := x"0";
    signal valids              : std_logic := '0';
    signal valid_1             : std_logic := '0';
    signal valid_1p            : std_logic := '0';
    signal valid_2p            : std_logic := '0';
    signal valid_3p            : std_logic := '0';
    signal xXc                 : natural := 0;
    signal yYc                 : natural := 1;
    
    signal irgb_eof_1s         : std_logic := '0';
    signal irgb_eof_2s         : std_logic := '0';
    signal irgb_eof_3s         : std_logic := '0';
    signal irgb_eof_4s         : std_logic := '0';
    constant k_rgb             : rgb_k_lut(0 to 101) := (
    (  0,  0,  0),
    (255,251,242),--RED  255
    (255,241,232),--RED  255
    (255,231,202),--RED  255
    (255,221,182),--RED  255
    (255,211,122),--RED  255
    (255,201,142),--RED  255
    (255,191,132),--RED  255
    (255,181,122),--RED  255
    (255,171,112),--RED  255
    (230,191,172),--RED  200
    (230,181,162),--RED  220
    (230, 81, 62),--RED  ---
    (220,181,142),--RED  220
    (220,171,132),--RED  220
    (200, 51, 12),--RED  ---
    (200,181, 92),--RED  ---
    (180,161,132),--RED  180
    (180,151,122),--RED  180
    (170,151,112),--RED  180
    (170,141,102),--RED  180
    (150, 31, 22),--RED  ---
    (150, 71, 42),--RED  ---
    (130, 91, 62),--RED  120
    (130, 81, 52),--RED  120
    (120, 81, 42),--RED  120
    (120, 71, 32),--RED  120
    (100, 51, 22),--RED  ---
    ( 70, 51, 42),--RED  60
    ( 70, 41, 32),--RED  60
    ( 60, 41, 22),--RED  60
    ( 60, 31, 12),--RED  60
    ( 50, 31, 32),--RED  50
    ( 50, 31, 22),--RED  50
    ( 40, 31, 22),--RED  50
    ( 40, 21, 12),--RED  50
    (253,255,244),--GREEN  255
    (243,255,234),--GREEN  255
    (233,255,204),--GREEN  255
    (223,255,184),--GREEN  255
    (213,255,124),--GREEN  255
    (203,255,144),--GREEN  255
    (193,255,134),--GREEN  255
    (183,255,124),--GREEN  255
    (173,255,114),--GREEN  255
    (193,230,174),--GREEN  200
    (183,230,164),--GREEN  220
    ( 83,230, 64),--GREEN  ---
    (183,220,144),--GREEN  220
    (173,220,134),--GREEN  220
    ( 53,200, 14),--GREEN  ---
    (183,200, 94),--GREEN  ---
    (163,180,134),--GREEN  180
    (153,180,124),--GREEN  180
    (153,170,114),--GREEN  180
    (143,170,104),--GREEN  180
    (143,150, 44),--GREEN  ---
    ( 73,130, 64),--GREEN  120
    ( 93,130, 54),--GREEN  120
    ( 83,120, 44),--GREEN  120
    ( 83,120, 34),--GREEN  120
    ( 73,100, 24),--GREEN  ---
    ( 33,100, 24),--GREEN  ---
    ( 53, 70, 44),--GREEN  60
    ( 43, 70, 34),--GREEN  60
    ( 43, 60, 24),--GREEN  60
    ( 33, 60, 14),--GREEN  60
    ( 33, 50, 34),--GREEN  50
    ( 23, 50, 24),--GREEN  50
    ( 33, 40, 24),--GREEN  50
    ( 23, 40, 14),--GREEN  50
    (146,205,255),--BLUE
    (136,195,255),--BLUE
    (126,185,255),--BLUE
    (116,175,255),--BLUE
    (176,195,230),--BLUE
    (166,185,230),--BLUE
    ( 66, 85,230),--BLUE
    (146,185,220),--BLUE
    (136,175,220),--BLUE
    ( 16, 55,200),--BLUE
    ( 96,185,200),--BLUE
    (136,165,180),--BLUE
    (126,155,180),--BLUE
    (116,155,170),--BLUE
    (106,145,170),--BLUE
    ( 46, 75,150),--BLUE
    ( 66, 95,130),--BLUE
    ( 56, 85,130),--BLUE
    ( 46, 85,120),--BLUE
    ( 36, 75,120),--BLUE
    ( 26, 55,100),--BLUE
    ( 16, 25, 75),--BLUE
    ( 46, 55, 70),--BLUE
    ( 36, 45, 70),--BLUE
    ( 26, 45, 60),--BLUE
    ( 16, 35, 60),--BLUE
    ( 26, 35, 50),--BLUE
    ( 26, 25, 50),--BLUE
    ( 26, 35, 40),--BLUE
    ( 16, 25, 40),--BLUE
    (255,255,255));
begin

    xCounter    <= to_integer(unsigned(iCord.x));
    yCounter    <= to_integer(unsigned(iCord.y));
    valid_1p    <= '1' when (valid_1 ='1' and iRgb.valid ='0') else '0';
    
process (clk) begin
    if (rising_edge(clk)) then
        irgb_eof_1s   <= iRgb.eof;
        irgb_eof_2s   <= irgb_eof_1s;
        irgb_eof_3s   <= irgb_eof_2s;
        irgb_eof_4s   <= irgb_eof_3s;
    end if;
end process; 
    
process (clk) begin
    if (rising_edge(clk)) then
        valids   <= iRgb.valid;
        valid_1  <= valids;
        valid_2p <= valid_1p;
    end if;
end process; 
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

            
            oRgb.red       <= std_logic_vector(to_unsigned(Rcont,8)) & "00";
            oRgb.green     <= std_logic_vector(to_unsigned(Gcont,8)) & "00";
            oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,8)) & "00";
        elsif(tpSelect = 14)then
            oRgb.valid     <= iRgb.valid;
            if(iRgb.valid = '1') then
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

                Rcont <= 255;
                Gcont <= Ycont;
                Bcont <= Ycont;
                flag  <='0';

            
            

                
            end if;
            ---------------------------
            oRgb.red       <= std_logic_vector(to_unsigned(Rcont,8)) & "00";
            oRgb.green     <= std_logic_vector(to_unsigned(Gcont,8)) & "00";
            oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,8)) & "00";

        
        elsif(tpSelect = 15)then
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

                Rcont <= 255;
                Gcont <= Ycont;
                Bcont <= Ycont;
                flag  <='0';

            end if;
            oRgb.red       <= std_logic_vector(to_unsigned(Rcont,8)) & "00";
            oRgb.green     <= std_logic_vector(to_unsigned(Gcont,8)) & "00";
            oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,8)) & "00";

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
            oRgb.red       <= std_logic_vector(to_unsigned(Rcont,8)) & "00";
            oRgb.green     <= std_logic_vector(to_unsigned(Gcont,8)) & "00";
            oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,8)) & "00";
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
            oRgb.red       <= std_logic_vector(to_unsigned(Rcont,8)) & "00";
            oRgb.green     <= std_logic_vector(to_unsigned(Gcont,8)) & "00";
            oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,8)) & "00";
       elsif(tpSelect = 18)then
            oRgb.valid     <= iRgb.valid;
            if(iRgb.valid = '1') then
                  -- RED=255 AND GREEN INCREMENT TO 255
                if(Gcont<255 and flag = '0') then
                        Gcont <= Gcont+1;
                else
                -- GREEN=255 and RED[--] TO 0
                        if(Gcont=255 and flag = '0') then
                            if(Rcont>0) then
                                Rcont <= Rcont-1;
                            end if;
                -- GREEN=255 AND RED=0 AND BLUE[++] TO 255
                            if(Rcont=0) then
                                if(Bcont<255) then
                                    Bcont <= Bcont+1;
                                end if;
                                if(Bcont=255) then
                                    flag <='1';
                                end if;
                            end if;
                        else
                -- GREEN[--] TO 0 AND RED=0 AND BLUE=255
                            if(Gcont>0) then
                                Gcont <= Gcont-1;
                            end if;
                -- GREEN=0 AND RED[++] TO 255 AND BLUE=255
                            if(Gcont=0) then
                                if(Rcont<255) then
                                    Rcont <= Rcont+1;
                                end if;
                -- GREEN=0 AND RED=255 AND BLUE[--] TO 0
                                if(Rcont=255) then
                                    if(Bcont>0) then
                                        Bcont <= Bcont-1;
                                    end if;
                                end if;
                            end if;
                        end if;
                end if;
            else
                if(valid_2p = '1')then
                    if(Ycont<256)then
                        Ycont <= Ycont+1;
                    else
                        Ycont <= 0;
                    end if;
                    if(Ycont = 255)then
                        if(Xcont<256)then
                            Xcont <= Xcont+1;
                        else
                            Xcont <= 0;
                        end if;
                    end if;
                    if(Xcont = 255)then
                        if(Ocont>0)then
                            Ocont <= Ocont-1;
                        else
                            Ocont <= 255;
                        end if;
                    end if;
                end if;
                Rcont <= Ocont;
                Gcont <= Ycont;
                Bcont <= Xcont;
                flag  <='0';
            end if;
            oRgb.red       <= std_logic_vector(to_unsigned(Rcont,8)) & "00";
            oRgb.green     <= std_logic_vector(to_unsigned(Gcont,8)) & "00";
            oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,8)) & "00";
       elsif(tpSelect = 19)then
            ---------------------------------------------------------------------
            ---------------------------------------------------------------------
            if(iRgb.valid = '1') then
                -- RED=255 AND GREEN INCREMENT TO 255
                if(Gcont<255 and flag = '0') then
                    Gcont <= Gcont+1;
                    if(Bcont<255) then
                        Bcont <= Bcont+1;
                    end if;
                else
                
                    --------------------------------------------
                    --------------------------------------------
                    if(Gcont=255 and flag = '0') then
                        -- GREEN=255 and RED[--] TO 0
                         if(Rcont>0) then
                             Rcont <= Rcont-1;
                         end if;
                         -- GREEN=255 AND RED=0 AND BLUE[++] TO 255
                         if(Rcont=0) then
                             if(Bcont<255) then
                                 Bcont <= Bcont+1;
                             end if;
                             if(Bcont=255) then
                                 flag <='1';
                                 Rcont <= XBcont;
                             end if;
                         end if;
                    else
                    --------------------------------------------
                    --------------------------------------------
                    if(flag3='0') then
                        --------------------------------------------
                        --------------------------------------------
                        -- GREEN[--] TO 0 AND RED=0 AND BLUE=255
                        if(flag6='0') then
                                    if(Gcont>0) then
                                        Gcont <= Gcont-1;
                                    end if;
                                    
                                    if(XBcont=0) then
                                        if(Gcont=1) and (Bcont>0) and (Bcont<255) then
                                            Bcont <= YGcont;
                                            Rcont <= AAcont;
                                        end if;

                                    else
                                        if(Gcont=1) and (Bcont>0) and (Bcont<255) then
                                            Bcont <= YGcont;
                                            Rcont <= YGcont;
                                        end if;
                                    end if;
                                    
                                    if(Gcont=0) then
                                        flag6 <= '1';
                                    end if;
                        --------------------------------------------
                        --------------------------------------------
                        else
                                    -- GREEN=0 AND RED[++] TO 255 AND BLUE=255
                                        if(Rcont<255)then
                                            Rcont <= Rcont+1;
                                        end if;
                                        -- GREEN=0 AND RED=255 AND BLUE[--] TO 0
                                        if(Rcont=255) then
                                            if(Bcont>0) then
                                                Bcont <= Bcont-1;
                                            end if;
                                            if(Bcont=0) then
                                                flag5 <='1';
                                            end if;
                                        end if;
                                        -- GREEN=0 AND RED=[--] TO 0 AND BLUE=0
                                        if(flag5='1') and (Rcont>0) then
                                            Rcont <= Rcont-1;
                                            Gcont <= XBcont;
                                            if(Rcont=255) and (YAcont=0) then
                                                Ocont <= Ocont+1;
                                                Bcont <= Ocont;
                                            elsif(Rcont=255) and (YAcont>0)then
                                                Bcont <= Ocont;
                                            end if;
                                        end if;
                                        if(Rcont=0) and (Gcont=0) then
                                            flag1 <='1';
                                        end if;
                                        if(flag1='1')then
                                            if(Bcont>0) then
                                                Bcont <= Bcont-1;
                                            end if;
                                            if(Rcont<255)then
                                                Rcont <= Bcont+YGcont;
                                            end if;
                                            if(Gcont>0) then
                                                Gcont <= Bcont-YGcont;
                                            end if;
                                        end if;
                                        
                        end if;
                        --------------------------------------------
                        --------------------------------------------
                      else
                         if(Rcont=255) and (Gcont=255) and (Bcont=255)then
                             flag4 <= x"1";
                         elsif(Rcont=255) and (Gcont=255) and (Bcont=0) then
                             flag4 <= x"2";
                         elsif(Rcont=255) and (Gcont=0) and (Bcont=0)then
                             flag4 <= x"3";
                         end if;
                         if(flag4 =  x"0")then
                             if(Rcont<255) or (Gcont<255) or (Bcont<255) then
                                 Rcont <= Rcont+1;
                                 Gcont <= Gcont+1;
                                 Bcont <= Bcont+1;
                             end if;
                         elsif(flag4 = x"1")then
                             if(Bcont>0) then
                                Bcont <= Bcont-1;
                             end if;
                         elsif(flag4 = x"2")then
                             if(Gcont>0) then
                                Gcont <= Gcont-1;
                             end if;
                         elsif(flag4 = x"3")then
                             if(Rcont>0) then
                                Rcont <= Rcont-1;
                             end if;
                         end if;
                      end if;
                --------------------------------------------
                    end if;
                end if;
            else
                Rcont <= 255;
                Gcont <= YGcont;
                Bcont <= XBcont;
            end if;
            ---------------------------------------------------------------------
            ---------------------------------------------------------------------
            oRgb.red       <= std_logic_vector(to_unsigned(Rcont,8)) & "00";
            oRgb.green     <= std_logic_vector(to_unsigned(Gcont,8)) & "00";
            oRgb.blue      <= std_logic_vector(to_unsigned(Bcont,8)) & "00";
            oRgb.valid     <= iRgb.valid;
        elsif(tpSelect = 20)then
           oRgb.red       <=  std_logic_vector(to_unsigned(k_rgb(yYc).red,8)) & "00";
           oRgb.green     <=  std_logic_vector(to_unsigned(k_rgb(yYc).gre,8)) & "00";
           oRgb.blue      <=  std_logic_vector(to_unsigned(k_rgb(yYc).blu,8)) & "00";
           oRgb.valid     <= iRgb.valid;
        elsif(tpSelect = 21)then
           if(yCounter < 100) then
               oRgb.red       <= std_logic_vector(to_unsigned(k_rgb(yCounter).red,8)) & "00";
               oRgb.green     <= std_logic_vector(to_unsigned(k_rgb(yCounter).gre,8)) & "00";
               oRgb.blue      <= std_logic_vector(to_unsigned(k_rgb(yCounter).blu,8)) & "00";
           end if;
           oRgb.valid     <= iRgb.valid;
        else
            oRgb.valid     <= iRgb.valid;
            oRgb.red       <= iRgb.red;
            oRgb.green     <= iRgb.green;
            oRgb.blue      <= iRgb.blue;
        end if;
       
       if(xCounter = 1) and (yCounter = 0) then
           flag   <='0';
           flag1  <='0';
           flag2  <='0';
           flag3  <='0';
           Ycont  <= 0;
           Xcont  <= 0;
           Ocont  <= 255;
           YAcont <= 0;
           YGcont <= 0;
           XBcont <= 0;
           Rcont  <= 255;
           Gcont  <= 0;
           Bcont  <= 0;
           xXc    <= 0;
           yYc    <= 0;
       end if;
       if(valid_2p = '1')then
               flag  <='0';
               flag3 <='0';
               flag4 <= x"0";
               flag5 <='0';
               flag6 <='0';
               flag1 <='0';
               if(flag2 = '1')then
                   flag2 <= '0';
               else
                   flag2 <= '1';
               end if;
               if(YAcont<4)then
                   YAcont <= YAcont+1;
               else
                   YAcont <= 0;
               end if;
               if(AAcont<32)then
                   AAcont <= AAcont+1;
               else
                   AAcont <= 0;
               end if;
               if(xXc<9)then
                   xXc <= xXc+1;
               else
                   xXc <= 0;
               end if;
               if(xXc=9)then
                   if(yYc<100)then
                       yYc <= yYc+1;
                   end if;
               end if;
               
               if(YAcont=2)then
                   if(YGcont<255)then
                       YGcont <= YGcont+1;
                   else
                       YGcont <= 0;
                   end if;
               end if;
               if(flag2 = '1')then
                   if(YGcont>128)then
                       if(XBcont<255)then
                           XBcont <= XBcont+1;
                       else
                           XBcont <= 0;
                       end if;
                   end if;
               end if;
       end if;
        
        
    end if;
end process;
end arch_imp;