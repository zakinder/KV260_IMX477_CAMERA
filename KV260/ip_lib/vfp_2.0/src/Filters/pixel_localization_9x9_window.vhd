-------------------------------------------------------------------------------
--
-- Filename    : pixel_localization_9x9_window.vhd
-- Create Date : 05062019 [05-06-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity pixel_localization_9x9_window is
generic (
    img_width                   : integer := 1920;
    i_data_width                : integer := 8);
port (
    clk                         : in  std_logic;
    reset                       : in  std_logic;
    iRgb                        : in channel;
    neighboring_pixel_threshold : integer;
    txCord                      : in coord;
    oRgb                        : out channel);
end pixel_localization_9x9_window;
architecture behavioral of pixel_localization_9x9_window is
------------------------------------------------------------------------------
  signal pixel_threshold_2                         : integer  := neighboring_pixel_threshold;   -- [60% with 20] [70% with 40] 
  signal row1                                      : k_9by9;
  signal row2                                      : k_9by9;
  signal row3                                      : k_9by9;
  signal row4                                      : k_9by9;
  signal row5                                      : k_9by9;
  signal row6                                      : k_9by9;
  signal row7                                      : k_9by9;
  signal row8                                      : k_9by9;
  signal row9                                      : k_9by9;
  signal rgb_pixels_9x9                            : k_9by9_rgb;
  signal rgb_9x9                                   : k_9by9_rgb_integers;
  signal rgb_9x9_delta                             : filters_size_rgb_integers;
  signal rgb_9x9_detect                            : filters_size_rgb_detect;
  signal pix_9x9                                   : k_9by9_rgb_integers;
  signal sum                                       : rgb_pixel_sum_values;
  signal v_tap_0x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_1x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_2x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_3x                                  : std_logic_vector(29 downto 0) := (others => '0'); 
  signal v_tap_4x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_5x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_6x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_7x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_71                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_72                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_73                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_74                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_8x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal tpValid                                   : std_logic;
  signal pixels_1_81_enabled                       : std_logic:= '0';
  signal Rgb1                                      : channel;
  signal Rgb2                                      : channel;
  signal Rgb3                                      : channel;
  signal rgbSyncValid                              : std_logic_vector(31 downto 0)  := x"00000000";
  signal rgbSyncEol                                : std_logic_vector(31 downto 0)  := x"00000000";
  signal rgbSyncSof                                : std_logic_vector(31 downto 0)  := x"00000000";
  signal rgbSyncEof                                : std_logic_vector(31 downto 0)  := x"00000000";
  signal crd_s1,crd_s2,crd_s3,crd_s4,crd_s5        : cord;
  signal crd_s6,crd_s7,crd_s8,crd_s9,crd_s10       : cord;
  signal crd_s11,crd_s12,crd_s13,crd_s14,crd_s15   : cord;
  signal crd_s16,crd_s17,crd_s18,crd_s19,crd_s20   : cord;
  signal crd_s21,crd_s22,crd_s23,crd_s24,crd_s25   : cord;
  signal crd_s26,crd_s27,crd_s28,crd_s29,crd_s30   : cord;
  signal crd_s31,crd_s32,crd_s33,crd_s34,crd_s35   : cord;
  signal crd_s36,crd_s37,crd_s38,crd_s39,crd_s40   : cord;
begin 
process (clk) begin
    if rising_edge(clk) then
        crd_s1.x      <= to_integer((unsigned(txCord.x)));
        crd_s1.y      <= to_integer((unsigned(txCord.y)));
        crd_s2        <= crd_s1;
        crd_s3        <= crd_s2;
        crd_s4        <= crd_s3;
        crd_s5        <= crd_s4;
        crd_s6        <= crd_s5;
        crd_s7        <= crd_s6;
        crd_s8        <= crd_s7;
        crd_s9        <= crd_s8;
        crd_s10       <= crd_s9;
        crd_s11       <= crd_s10;
        crd_s12       <= crd_s11;
        crd_s13       <= crd_s12;
        crd_s14       <= crd_s13;
        crd_s15       <= crd_s14;
        crd_s16       <= crd_s15;
        crd_s17       <= crd_s16;
        crd_s18       <= crd_s17;
        crd_s19       <= crd_s18;
        crd_s20       <= crd_s19;
        crd_s21       <= crd_s20;
        crd_s22       <= crd_s21;
        crd_s23       <= crd_s22;
        crd_s24       <= crd_s23;
        crd_s25       <= crd_s24;
        crd_s26       <= crd_s25;
        crd_s27       <= crd_s26;
        crd_s28       <= crd_s27;
        crd_s29       <= crd_s28;
        crd_s30       <= crd_s29;
        crd_s31       <= crd_s30;
        crd_s32       <= crd_s31;
        crd_s33       <= crd_s32;
        crd_s34       <= crd_s33;
        crd_s35       <= crd_s34;
        crd_s36       <= crd_s35;
        crd_s37       <= crd_s36;
        crd_s38       <= crd_s37;
        crd_s39       <= crd_s38;
        crd_s40       <= crd_s39;
    end if;
end process;
rgb_syncr_inst  : sync_frames
generic map(
    pixelDelay => 14)
port map(
    clk        => clk,
    reset      => reset,
    iRgb       => iRgb,
    oRgb       => Rgb3);
RGB_2_Inst: rgb_8taps
generic map(
    img_width       => img_width,
    tpDataWidth     => 30)
port map(
    clk             => clk,
    rst_l           => reset,
    iRgb            => iRgb,
    tpValid         => tpValid,
    tp0             => v_tap_0x,
    tp1             => v_tap_1x,
    tp2             => v_tap_2x,
    tp3             => v_tap_3x,
    tp4             => v_tap_4x,
    tp5             => v_tap_5x,
    tp6             => v_tap_6x,
    tp7             => v_tap_7x,
    tp8             => v_tap_8x);
process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= iRgb.valid;
        rgbSyncValid(1)  <= rgbSyncValid(0);
        rgbSyncValid(2)  <= rgbSyncValid(1);
        rgbSyncValid(3)  <= rgbSyncValid(2);
        rgbSyncValid(4)  <= rgbSyncValid(3);
        rgbSyncValid(5)  <= rgbSyncValid(4);
        rgbSyncValid(6)  <= rgbSyncValid(5);
        rgbSyncValid(7)  <= rgbSyncValid(6);
        rgbSyncValid(8)  <= rgbSyncValid(7);
        rgbSyncValid(9)  <= rgbSyncValid(8);
        rgbSyncValid(10) <= rgbSyncValid(9);
        rgbSyncValid(11) <= rgbSyncValid(10);
        rgbSyncValid(12) <= rgbSyncValid(11);
        rgbSyncValid(13) <= rgbSyncValid(12);
        rgbSyncValid(14) <= rgbSyncValid(13);
        rgbSyncValid(15) <= rgbSyncValid(14);
        rgbSyncValid(16) <= rgbSyncValid(15);
        rgbSyncValid(17) <= rgbSyncValid(16);
        rgbSyncValid(18) <= rgbSyncValid(17);
        rgbSyncValid(19) <= rgbSyncValid(18);
        rgbSyncValid(20) <= rgbSyncValid(19);
        rgbSyncValid(21) <= rgbSyncValid(20);
        rgbSyncValid(22) <= rgbSyncValid(21);
        rgbSyncValid(23) <= rgbSyncValid(22);
        rgbSyncValid(24) <= rgbSyncValid(23);
        rgbSyncValid(25) <= rgbSyncValid(24);
        rgbSyncValid(26) <= rgbSyncValid(25);
        rgbSyncValid(27) <= rgbSyncValid(26);
        rgbSyncValid(28) <= rgbSyncValid(27);
        rgbSyncValid(29) <= rgbSyncValid(28);
        rgbSyncValid(30) <= rgbSyncValid(29);
        rgbSyncValid(31) <= rgbSyncValid(30);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEol(0)  <= iRgb.eol;
        rgbSyncEol(1)  <= rgbSyncEol(0);
        rgbSyncEol(2)  <= rgbSyncEol(1);
        rgbSyncEol(3)  <= rgbSyncEol(2);
        rgbSyncEol(4)  <= rgbSyncEol(3);
        rgbSyncEol(5)  <= rgbSyncEol(4);
        rgbSyncEol(6)  <= rgbSyncEol(5);
        rgbSyncEol(7)  <= rgbSyncEol(6);
        rgbSyncEol(8)  <= rgbSyncEol(7);
        rgbSyncEol(9)  <= rgbSyncEol(8);
        rgbSyncEol(10) <= rgbSyncEol(9);
        rgbSyncEol(11) <= rgbSyncEol(10);
        rgbSyncEol(12) <= rgbSyncEol(11);
        rgbSyncEol(13) <= rgbSyncEol(12);
        rgbSyncEol(14) <= rgbSyncEol(13);
        rgbSyncEol(15) <= rgbSyncEol(14);
        rgbSyncEol(16) <= rgbSyncEol(15);
        rgbSyncEol(17) <= rgbSyncEol(16);
        rgbSyncEol(18) <= rgbSyncEol(17);
        rgbSyncEol(19) <= rgbSyncEol(18);
        rgbSyncEol(20) <= rgbSyncEol(19);
        rgbSyncEol(21) <= rgbSyncEol(20);
        rgbSyncEol(22) <= rgbSyncEol(21);
        rgbSyncEol(23) <= rgbSyncEol(22);
        rgbSyncEol(24) <= rgbSyncEol(23);
        rgbSyncEol(25) <= rgbSyncEol(24);
        rgbSyncEol(26) <= rgbSyncEol(25);
        rgbSyncEol(27) <= rgbSyncEol(26);
        rgbSyncEol(28) <= rgbSyncEol(27);
        rgbSyncEol(29) <= rgbSyncEol(28);
        rgbSyncEol(30) <= rgbSyncEol(29);
        rgbSyncEol(31) <= rgbSyncEol(30);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncSof(0)  <= iRgb.sof;
        rgbSyncSof(1)  <= rgbSyncSof(0);
        rgbSyncSof(2)  <= rgbSyncSof(1);
        rgbSyncSof(3)  <= rgbSyncSof(2);
        rgbSyncSof(4)  <= rgbSyncSof(3);
        rgbSyncSof(5)  <= rgbSyncSof(4);
        rgbSyncSof(6)  <= rgbSyncSof(5);
        rgbSyncSof(7)  <= rgbSyncSof(6);
        rgbSyncSof(8)  <= rgbSyncSof(7);
        rgbSyncSof(9)  <= rgbSyncSof(8);
        rgbSyncSof(10) <= rgbSyncSof(9);
        rgbSyncSof(11) <= rgbSyncSof(10);
        rgbSyncSof(12) <= rgbSyncSof(11);
        rgbSyncSof(13) <= rgbSyncSof(12);
        rgbSyncSof(14) <= rgbSyncSof(13);
        rgbSyncSof(15) <= rgbSyncSof(14);
        rgbSyncSof(16) <= rgbSyncSof(15);
        rgbSyncSof(17) <= rgbSyncSof(16);
        rgbSyncSof(18) <= rgbSyncSof(17);
        rgbSyncSof(19) <= rgbSyncSof(18);
        rgbSyncSof(20) <= rgbSyncSof(19);
        rgbSyncSof(21) <= rgbSyncSof(20);
        rgbSyncSof(22) <= rgbSyncSof(21);
        rgbSyncSof(23) <= rgbSyncSof(22);
        rgbSyncSof(24) <= rgbSyncSof(23);
        rgbSyncSof(25) <= rgbSyncSof(24);
        rgbSyncSof(26) <= rgbSyncSof(25);
        rgbSyncSof(27) <= rgbSyncSof(26);
        rgbSyncSof(28) <= rgbSyncSof(27);
        rgbSyncSof(29) <= rgbSyncSof(28);
        rgbSyncSof(30) <= rgbSyncSof(29);
        rgbSyncSof(31) <= rgbSyncSof(30);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEof(0)  <= iRgb.eof;
        rgbSyncEof(1)  <= rgbSyncEof(0);
        rgbSyncEof(2)  <= rgbSyncEof(1);
        rgbSyncEof(3)  <= rgbSyncEof(2);
        rgbSyncEof(4)  <= rgbSyncEof(3);
        rgbSyncEof(5)  <= rgbSyncEof(4);
        rgbSyncEof(6)  <= rgbSyncEof(5);
        rgbSyncEof(7)  <= rgbSyncEof(6);
        rgbSyncEof(8)  <= rgbSyncEof(7);
        rgbSyncEof(9)  <= rgbSyncEof(8);
        rgbSyncEof(10) <= rgbSyncEof(9);
        rgbSyncEof(11) <= rgbSyncEof(10);
        rgbSyncEof(12) <= rgbSyncEof(11);
        rgbSyncEof(13) <= rgbSyncEof(12);
        rgbSyncEof(14) <= rgbSyncEof(13);
        rgbSyncEof(15) <= rgbSyncEof(14);
        rgbSyncEof(16) <= rgbSyncEof(15);
        rgbSyncEof(17) <= rgbSyncEof(16);
        rgbSyncEof(18) <= rgbSyncEof(17);
        rgbSyncEof(19) <= rgbSyncEof(18);
        rgbSyncEof(20) <= rgbSyncEof(19);
        rgbSyncEof(21) <= rgbSyncEof(20);
        rgbSyncEof(22) <= rgbSyncEof(21);
        rgbSyncEof(23) <= rgbSyncEof(22);
        rgbSyncEof(24) <= rgbSyncEof(23);
        rgbSyncEof(25) <= rgbSyncEof(24);
        rgbSyncEof(26) <= rgbSyncEof(25);
        rgbSyncEof(27) <= rgbSyncEof(26);
        rgbSyncEof(28) <= rgbSyncEof(27);
        rgbSyncEof(29) <= rgbSyncEof(28);
        rgbSyncEof(30) <= rgbSyncEof(29);
        rgbSyncEof(31) <= rgbSyncEof(30);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
            row1.pixel_1    <= v_tap_0x;
            row1.pixel_2    <= row1.pixel_1;
            row1.pixel_3    <= row1.pixel_2;
            row1.pixel_4    <= row1.pixel_3;
            row1.pixel_5    <= row1.pixel_4;
            row1.pixel_6    <= row1.pixel_5;
            row1.pixel_7    <= row1.pixel_6;
            row1.pixel_8    <= row1.pixel_7;
            row1.pixel_9    <= row1.pixel_8;
            row2.pixel_1    <= v_tap_1x;
            row2.pixel_2    <= row2.pixel_1;
            row2.pixel_3    <= row2.pixel_2;
            row2.pixel_4    <= row2.pixel_3;
            row2.pixel_5    <= row2.pixel_4;
            row2.pixel_6    <= row2.pixel_5;
            row2.pixel_7    <= row2.pixel_6;
            row2.pixel_8    <= row2.pixel_7;
            row2.pixel_9    <= row2.pixel_8;
            row3.pixel_1    <= v_tap_2x;
            row3.pixel_2    <= row3.pixel_1;
            row3.pixel_3    <= row3.pixel_2;
            row3.pixel_4    <= row3.pixel_3;
            row3.pixel_5    <= row3.pixel_4;
            row3.pixel_6    <= row3.pixel_5;
            row3.pixel_7    <= row3.pixel_6;
            row3.pixel_8    <= row3.pixel_7;
            row3.pixel_9    <= row3.pixel_8;
            row4.pixel_1    <= v_tap_3x;
            row4.pixel_2    <= row4.pixel_1;
            row4.pixel_3    <= row4.pixel_2;
            row4.pixel_4    <= row4.pixel_3;
            row4.pixel_5    <= row4.pixel_4;
            row4.pixel_6    <= row4.pixel_5;
            row4.pixel_7    <= row4.pixel_6;
            row4.pixel_8    <= row4.pixel_7;
            row4.pixel_9    <= row4.pixel_8;
            row5.pixel_1    <= v_tap_4x;
            row5.pixel_2    <= row5.pixel_1;
            row5.pixel_3    <= row5.pixel_2;
            row5.pixel_4    <= row5.pixel_3;
            row5.pixel_5    <= row5.pixel_4;
            row5.pixel_6    <= row5.pixel_5;
            row5.pixel_7    <= row5.pixel_6;
            row5.pixel_8    <= row5.pixel_7;
            row5.pixel_9    <= row5.pixel_8;
            row6.pixel_1    <= v_tap_5x;
            row6.pixel_2    <= row6.pixel_1;
            row6.pixel_3    <= row6.pixel_2;
            row6.pixel_4    <= row6.pixel_3;
            row6.pixel_5    <= row6.pixel_4;
            row6.pixel_6    <= row6.pixel_5;
            row6.pixel_7    <= row6.pixel_6;
            row6.pixel_8    <= row6.pixel_7;
            row6.pixel_9    <= row6.pixel_8;
            row7.pixel_1    <= v_tap_6x;
            row7.pixel_2    <= row7.pixel_1;
            row7.pixel_3    <= row7.pixel_2;
            row7.pixel_4    <= row7.pixel_3;
            row7.pixel_5    <= row7.pixel_4;
            row7.pixel_6    <= row7.pixel_5;
            row7.pixel_7    <= row7.pixel_6;
            row7.pixel_8    <= row7.pixel_7;
            row7.pixel_9    <= row7.pixel_8;
            row8.pixel_1    <= v_tap_7x;
            row8.pixel_2    <= row8.pixel_1;
            row8.pixel_3    <= row8.pixel_2;
            row8.pixel_4    <= row8.pixel_3;
            row8.pixel_5    <= row8.pixel_4;
            row8.pixel_6    <= row8.pixel_5;
            row8.pixel_7    <= row8.pixel_6;
            row8.pixel_8    <= row8.pixel_7;
            row8.pixel_9    <= row8.pixel_8;
            row9.pixel_1    <= v_tap_8x;
            row9.pixel_2    <= row9.pixel_1;
            row9.pixel_3    <= row9.pixel_2;
            row9.pixel_4    <= row9.pixel_3;
            row9.pixel_5    <= row9.pixel_4;
            row9.pixel_6    <= row9.pixel_5;
            row9.pixel_7    <= row9.pixel_6;
            row9.pixel_8    <= row9.pixel_7;
            row9.pixel_9    <= row9.pixel_8;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
            rgb_pixels_9x9.red.k1  <= row1.pixel_1(29 downto 20);
            rgb_pixels_9x9.red.k2  <= row1.pixel_2(29 downto 20);
            rgb_pixels_9x9.red.k3  <= row1.pixel_3(29 downto 20);
            rgb_pixels_9x9.red.k4  <= row1.pixel_4(29 downto 20);
            rgb_pixels_9x9.red.k5  <= row1.pixel_5(29 downto 20);
            rgb_pixels_9x9.red.k6  <= row1.pixel_6(29 downto 20);
            rgb_pixels_9x9.red.k7  <= row1.pixel_7(29 downto 20);
            rgb_pixels_9x9.red.k8  <= row1.pixel_8(29 downto 20);
            rgb_pixels_9x9.red.k9  <= row1.pixel_9(29 downto 20);
            rgb_pixels_9x9.red.k10 <= row2.pixel_1(29 downto 20);
            rgb_pixels_9x9.red.k11 <= row2.pixel_2(29 downto 20);
            rgb_pixels_9x9.red.k12 <= row2.pixel_3(29 downto 20);
            rgb_pixels_9x9.red.k13 <= row2.pixel_4(29 downto 20);
            rgb_pixels_9x9.red.k14 <= row2.pixel_5(29 downto 20);
            rgb_pixels_9x9.red.k15 <= row2.pixel_6(29 downto 20);
            rgb_pixels_9x9.red.k16 <= row2.pixel_7(29 downto 20);
            rgb_pixels_9x9.red.k17 <= row2.pixel_8(29 downto 20);
            rgb_pixels_9x9.red.k18 <= row2.pixel_9(29 downto 20);
            rgb_pixels_9x9.red.k19 <= row3.pixel_1(29 downto 20);
            rgb_pixels_9x9.red.k20 <= row3.pixel_2(29 downto 20);
            rgb_pixels_9x9.red.k21 <= row3.pixel_3(29 downto 20);
            rgb_pixels_9x9.red.k22 <= row3.pixel_4(29 downto 20);
            rgb_pixels_9x9.red.k23 <= row3.pixel_5(29 downto 20);
            rgb_pixels_9x9.red.k24 <= row3.pixel_6(29 downto 20);
            rgb_pixels_9x9.red.k25 <= row3.pixel_7(29 downto 20);
            rgb_pixels_9x9.red.k26 <= row3.pixel_8(29 downto 20);
            rgb_pixels_9x9.red.k27 <= row3.pixel_9(29 downto 20);
            rgb_pixels_9x9.red.k28 <= row4.pixel_1(29 downto 20);
            rgb_pixels_9x9.red.k29 <= row4.pixel_2(29 downto 20);
            rgb_pixels_9x9.red.k30 <= row4.pixel_3(29 downto 20);
            rgb_pixels_9x9.red.k31 <= row4.pixel_4(29 downto 20);
            rgb_pixels_9x9.red.k32 <= row4.pixel_5(29 downto 20);
            rgb_pixels_9x9.red.k33 <= row4.pixel_6(29 downto 20);
            rgb_pixels_9x9.red.k34 <= row4.pixel_7(29 downto 20);
            rgb_pixels_9x9.red.k35 <= row4.pixel_8(29 downto 20);
            rgb_pixels_9x9.red.k36 <= row4.pixel_9(29 downto 20);
            rgb_pixels_9x9.red.k37 <= row5.pixel_1(29 downto 20);
            rgb_pixels_9x9.red.k38 <= row5.pixel_2(29 downto 20);
            rgb_pixels_9x9.red.k39 <= row5.pixel_3(29 downto 20);
            rgb_pixels_9x9.red.k40 <= row5.pixel_4(29 downto 20);
            rgb_pixels_9x9.red.k41 <= row5.pixel_5(29 downto 20);
            rgb_pixels_9x9.red.k42 <= row5.pixel_6(29 downto 20);
            rgb_pixels_9x9.red.k43 <= row5.pixel_7(29 downto 20);
            rgb_pixels_9x9.red.k44 <= row5.pixel_8(29 downto 20);
            rgb_pixels_9x9.red.k45 <= row5.pixel_9(29 downto 20);
            rgb_pixels_9x9.red.k46 <= row6.pixel_1(29 downto 20);
            rgb_pixels_9x9.red.k47 <= row6.pixel_2(29 downto 20);
            rgb_pixels_9x9.red.k48 <= row6.pixel_3(29 downto 20);
            rgb_pixels_9x9.red.k49 <= row6.pixel_4(29 downto 20);
            rgb_pixels_9x9.red.k50 <= row6.pixel_5(29 downto 20);
            rgb_pixels_9x9.red.k51 <= row6.pixel_6(29 downto 20);
            rgb_pixels_9x9.red.k52 <= row6.pixel_7(29 downto 20);
            rgb_pixels_9x9.red.k53 <= row6.pixel_8(29 downto 20);
            rgb_pixels_9x9.red.k54 <= row6.pixel_9(29 downto 20);
            rgb_pixels_9x9.red.k55 <= row7.pixel_1(29 downto 20);
            rgb_pixels_9x9.red.k56 <= row7.pixel_2(29 downto 20);
            rgb_pixels_9x9.red.k57 <= row7.pixel_3(29 downto 20);
            rgb_pixels_9x9.red.k58 <= row7.pixel_4(29 downto 20);
            rgb_pixels_9x9.red.k59 <= row7.pixel_5(29 downto 20);
            rgb_pixels_9x9.red.k60 <= row7.pixel_6(29 downto 20);
            rgb_pixels_9x9.red.k61 <= row7.pixel_7(29 downto 20);
            rgb_pixels_9x9.red.k62 <= row7.pixel_8(29 downto 20);
            rgb_pixels_9x9.red.k63 <= row7.pixel_9(29 downto 20);
            rgb_pixels_9x9.red.k64 <= row8.pixel_1(29 downto 20);
            rgb_pixels_9x9.red.k65 <= row8.pixel_2(29 downto 20);
            rgb_pixels_9x9.red.k66 <= row8.pixel_3(29 downto 20);
            rgb_pixels_9x9.red.k67 <= row8.pixel_4(29 downto 20);
            rgb_pixels_9x9.red.k68 <= row8.pixel_5(29 downto 20);
            rgb_pixels_9x9.red.k69 <= row8.pixel_6(29 downto 20);
            rgb_pixels_9x9.red.k70 <= row8.pixel_7(29 downto 20);
            rgb_pixels_9x9.red.k71 <= row8.pixel_8(29 downto 20);
            rgb_pixels_9x9.red.k72 <= row8.pixel_9(29 downto 20);
            rgb_pixels_9x9.red.k73 <= row9.pixel_1(29 downto 20);
            rgb_pixels_9x9.red.k74 <= row9.pixel_2(29 downto 20);
            rgb_pixels_9x9.red.k75 <= row9.pixel_3(29 downto 20);
            rgb_pixels_9x9.red.k76 <= row9.pixel_4(29 downto 20);
            rgb_pixels_9x9.red.k77 <= row9.pixel_5(29 downto 20);
            rgb_pixels_9x9.red.k78 <= row9.pixel_6(29 downto 20);
            rgb_pixels_9x9.red.k79 <= row9.pixel_7(29 downto 20);
            rgb_pixels_9x9.red.k80 <= row9.pixel_8(29 downto 20);
            rgb_pixels_9x9.red.k81 <= row9.pixel_9(29 downto 20);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
            rgb_pixels_9x9.green.k1  <= row1.pixel_1(19 downto 10);
            rgb_pixels_9x9.green.k2  <= row1.pixel_2(19 downto 10);
            rgb_pixels_9x9.green.k3  <= row1.pixel_3(19 downto 10);
            rgb_pixels_9x9.green.k4  <= row1.pixel_4(19 downto 10);
            rgb_pixels_9x9.green.k5  <= row1.pixel_5(19 downto 10);
            rgb_pixels_9x9.green.k6  <= row1.pixel_6(19 downto 10);
            rgb_pixels_9x9.green.k7  <= row1.pixel_7(19 downto 10);
            rgb_pixels_9x9.green.k8  <= row1.pixel_8(19 downto 10);
            rgb_pixels_9x9.green.k9  <= row1.pixel_9(19 downto 10);
            rgb_pixels_9x9.green.k10 <= row2.pixel_1(19 downto 10);
            rgb_pixels_9x9.green.k11 <= row2.pixel_2(19 downto 10);
            rgb_pixels_9x9.green.k12 <= row2.pixel_3(19 downto 10);
            rgb_pixels_9x9.green.k13 <= row2.pixel_4(19 downto 10);
            rgb_pixels_9x9.green.k14 <= row2.pixel_5(19 downto 10);
            rgb_pixels_9x9.green.k15 <= row2.pixel_6(19 downto 10);
            rgb_pixels_9x9.green.k16 <= row2.pixel_7(19 downto 10);
            rgb_pixels_9x9.green.k17 <= row2.pixel_8(19 downto 10);
            rgb_pixels_9x9.green.k18 <= row2.pixel_9(19 downto 10);
            rgb_pixels_9x9.green.k19 <= row3.pixel_1(19 downto 10);
            rgb_pixels_9x9.green.k20 <= row3.pixel_2(19 downto 10);
            rgb_pixels_9x9.green.k21 <= row3.pixel_3(19 downto 10);
            rgb_pixels_9x9.green.k22 <= row3.pixel_4(19 downto 10);
            rgb_pixels_9x9.green.k23 <= row3.pixel_5(19 downto 10);
            rgb_pixels_9x9.green.k24 <= row3.pixel_6(19 downto 10);
            rgb_pixels_9x9.green.k25 <= row3.pixel_7(19 downto 10);
            rgb_pixels_9x9.green.k26 <= row3.pixel_8(19 downto 10);
            rgb_pixels_9x9.green.k27 <= row3.pixel_9(19 downto 10);
            rgb_pixels_9x9.green.k28 <= row4.pixel_1(19 downto 10);
            rgb_pixels_9x9.green.k29 <= row4.pixel_2(19 downto 10);
            rgb_pixels_9x9.green.k30 <= row4.pixel_3(19 downto 10);
            rgb_pixels_9x9.green.k31 <= row4.pixel_4(19 downto 10);
            rgb_pixels_9x9.green.k32 <= row4.pixel_5(19 downto 10);
            rgb_pixels_9x9.green.k33 <= row4.pixel_6(19 downto 10);
            rgb_pixels_9x9.green.k34 <= row4.pixel_7(19 downto 10);
            rgb_pixels_9x9.green.k35 <= row4.pixel_8(19 downto 10);
            rgb_pixels_9x9.green.k36 <= row4.pixel_9(19 downto 10);
            rgb_pixels_9x9.green.k37 <= row5.pixel_1(19 downto 10);
            rgb_pixels_9x9.green.k38 <= row5.pixel_2(19 downto 10);
            rgb_pixels_9x9.green.k39 <= row5.pixel_3(19 downto 10);
            rgb_pixels_9x9.green.k40 <= row5.pixel_4(19 downto 10);
            rgb_pixels_9x9.green.k41 <= row5.pixel_5(19 downto 10);
            rgb_pixels_9x9.green.k42 <= row5.pixel_6(19 downto 10);
            rgb_pixels_9x9.green.k43 <= row5.pixel_7(19 downto 10);
            rgb_pixels_9x9.green.k44 <= row5.pixel_8(19 downto 10);
            rgb_pixels_9x9.green.k45 <= row5.pixel_9(19 downto 10);
            rgb_pixels_9x9.green.k46 <= row6.pixel_1(19 downto 10);
            rgb_pixels_9x9.green.k47 <= row6.pixel_2(19 downto 10);
            rgb_pixels_9x9.green.k48 <= row6.pixel_3(19 downto 10);
            rgb_pixels_9x9.green.k49 <= row6.pixel_4(19 downto 10);
            rgb_pixels_9x9.green.k50 <= row6.pixel_5(19 downto 10);
            rgb_pixels_9x9.green.k51 <= row6.pixel_6(19 downto 10);
            rgb_pixels_9x9.green.k52 <= row6.pixel_7(19 downto 10);
            rgb_pixels_9x9.green.k53 <= row6.pixel_8(19 downto 10);
            rgb_pixels_9x9.green.k54 <= row6.pixel_9(19 downto 10);
            rgb_pixels_9x9.green.k55 <= row7.pixel_1(19 downto 10);
            rgb_pixels_9x9.green.k56 <= row7.pixel_2(19 downto 10);
            rgb_pixels_9x9.green.k57 <= row7.pixel_3(19 downto 10);
            rgb_pixels_9x9.green.k58 <= row7.pixel_4(19 downto 10);
            rgb_pixels_9x9.green.k59 <= row7.pixel_5(19 downto 10);
            rgb_pixels_9x9.green.k60 <= row7.pixel_6(19 downto 10);
            rgb_pixels_9x9.green.k61 <= row7.pixel_7(19 downto 10);
            rgb_pixels_9x9.green.k62 <= row7.pixel_8(19 downto 10);
            rgb_pixels_9x9.green.k63 <= row7.pixel_9(19 downto 10);
            rgb_pixels_9x9.green.k64 <= row8.pixel_1(19 downto 10);
            rgb_pixels_9x9.green.k65 <= row8.pixel_2(19 downto 10);
            rgb_pixels_9x9.green.k66 <= row8.pixel_3(19 downto 10);
            rgb_pixels_9x9.green.k67 <= row8.pixel_4(19 downto 10);
            rgb_pixels_9x9.green.k68 <= row8.pixel_5(19 downto 10);
            rgb_pixels_9x9.green.k69 <= row8.pixel_6(19 downto 10);
            rgb_pixels_9x9.green.k70 <= row8.pixel_7(19 downto 10);
            rgb_pixels_9x9.green.k71 <= row8.pixel_8(19 downto 10);
            rgb_pixels_9x9.green.k72 <= row8.pixel_9(19 downto 10);
            rgb_pixels_9x9.green.k73 <= row9.pixel_1(19 downto 10);
            rgb_pixels_9x9.green.k74 <= row9.pixel_2(19 downto 10);
            rgb_pixels_9x9.green.k75 <= row9.pixel_3(19 downto 10);
            rgb_pixels_9x9.green.k76 <= row9.pixel_4(19 downto 10);
            rgb_pixels_9x9.green.k77 <= row9.pixel_5(19 downto 10);
            rgb_pixels_9x9.green.k78 <= row9.pixel_6(19 downto 10);
            rgb_pixels_9x9.green.k79 <= row9.pixel_7(19 downto 10);
            rgb_pixels_9x9.green.k80 <= row9.pixel_8(19 downto 10);
            rgb_pixels_9x9.green.k81 <= row9.pixel_9(19 downto 10);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
            rgb_pixels_9x9.blue.k1  <= row1.pixel_1(9 downto 0);
            rgb_pixels_9x9.blue.k2  <= row1.pixel_2(9 downto 0);
            rgb_pixels_9x9.blue.k3  <= row1.pixel_3(9 downto 0);
            rgb_pixels_9x9.blue.k4  <= row1.pixel_4(9 downto 0);
            rgb_pixels_9x9.blue.k5  <= row1.pixel_5(9 downto 0);
            rgb_pixels_9x9.blue.k6  <= row1.pixel_6(9 downto 0);
            rgb_pixels_9x9.blue.k7  <= row1.pixel_7(9 downto 0);
            rgb_pixels_9x9.blue.k8  <= row1.pixel_8(9 downto 0);
            rgb_pixels_9x9.blue.k9  <= row1.pixel_9(9 downto 0);
            rgb_pixels_9x9.blue.k10 <= row2.pixel_1(9 downto 0);
            rgb_pixels_9x9.blue.k11 <= row2.pixel_2(9 downto 0);
            rgb_pixels_9x9.blue.k12 <= row2.pixel_3(9 downto 0);
            rgb_pixels_9x9.blue.k13 <= row2.pixel_4(9 downto 0);
            rgb_pixels_9x9.blue.k14 <= row2.pixel_5(9 downto 0);
            rgb_pixels_9x9.blue.k15 <= row2.pixel_6(9 downto 0);
            rgb_pixels_9x9.blue.k16 <= row2.pixel_7(9 downto 0);
            rgb_pixels_9x9.blue.k17 <= row2.pixel_8(9 downto 0);
            rgb_pixels_9x9.blue.k18 <= row2.pixel_9(9 downto 0);
            rgb_pixels_9x9.blue.k19 <= row3.pixel_1(9 downto 0);
            rgb_pixels_9x9.blue.k20 <= row3.pixel_2(9 downto 0);
            rgb_pixels_9x9.blue.k21 <= row3.pixel_3(9 downto 0);
            rgb_pixels_9x9.blue.k22 <= row3.pixel_4(9 downto 0);
            rgb_pixels_9x9.blue.k23 <= row3.pixel_5(9 downto 0);
            rgb_pixels_9x9.blue.k24 <= row3.pixel_6(9 downto 0);
            rgb_pixels_9x9.blue.k25 <= row3.pixel_7(9 downto 0);
            rgb_pixels_9x9.blue.k26 <= row3.pixel_8(9 downto 0);
            rgb_pixels_9x9.blue.k27 <= row3.pixel_9(9 downto 0);
            rgb_pixels_9x9.blue.k28 <= row4.pixel_1(9 downto 0);
            rgb_pixels_9x9.blue.k29 <= row4.pixel_2(9 downto 0);
            rgb_pixels_9x9.blue.k30 <= row4.pixel_3(9 downto 0);
            rgb_pixels_9x9.blue.k31 <= row4.pixel_4(9 downto 0);
            rgb_pixels_9x9.blue.k32 <= row4.pixel_5(9 downto 0);
            rgb_pixels_9x9.blue.k33 <= row4.pixel_6(9 downto 0);
            rgb_pixels_9x9.blue.k34 <= row4.pixel_7(9 downto 0);
            rgb_pixels_9x9.blue.k35 <= row4.pixel_8(9 downto 0);
            rgb_pixels_9x9.blue.k36 <= row4.pixel_9(9 downto 0);
            rgb_pixels_9x9.blue.k37 <= row5.pixel_1(9 downto 0);
            rgb_pixels_9x9.blue.k38 <= row5.pixel_2(9 downto 0);
            rgb_pixels_9x9.blue.k39 <= row5.pixel_3(9 downto 0);
            rgb_pixels_9x9.blue.k40 <= row5.pixel_4(9 downto 0);
            rgb_pixels_9x9.blue.k41 <= row5.pixel_5(9 downto 0);
            rgb_pixels_9x9.blue.k42 <= row5.pixel_6(9 downto 0);
            rgb_pixels_9x9.blue.k43 <= row5.pixel_7(9 downto 0);
            rgb_pixels_9x9.blue.k44 <= row5.pixel_8(9 downto 0);
            rgb_pixels_9x9.blue.k45 <= row5.pixel_9(9 downto 0);
            rgb_pixels_9x9.blue.k46 <= row6.pixel_1(9 downto 0);
            rgb_pixels_9x9.blue.k47 <= row6.pixel_2(9 downto 0);
            rgb_pixels_9x9.blue.k48 <= row6.pixel_3(9 downto 0);
            rgb_pixels_9x9.blue.k49 <= row6.pixel_4(9 downto 0);
            rgb_pixels_9x9.blue.k50 <= row6.pixel_5(9 downto 0);
            rgb_pixels_9x9.blue.k51 <= row6.pixel_6(9 downto 0);
            rgb_pixels_9x9.blue.k52 <= row6.pixel_7(9 downto 0);
            rgb_pixels_9x9.blue.k53 <= row6.pixel_8(9 downto 0);
            rgb_pixels_9x9.blue.k54 <= row6.pixel_9(9 downto 0);
            rgb_pixels_9x9.blue.k55 <= row7.pixel_1(9 downto 0);
            rgb_pixels_9x9.blue.k56 <= row7.pixel_2(9 downto 0);
            rgb_pixels_9x9.blue.k57 <= row7.pixel_3(9 downto 0);
            rgb_pixels_9x9.blue.k58 <= row7.pixel_4(9 downto 0);
            rgb_pixels_9x9.blue.k59 <= row7.pixel_5(9 downto 0);
            rgb_pixels_9x9.blue.k60 <= row7.pixel_6(9 downto 0);
            rgb_pixels_9x9.blue.k61 <= row7.pixel_7(9 downto 0);
            rgb_pixels_9x9.blue.k62 <= row7.pixel_8(9 downto 0);
            rgb_pixels_9x9.blue.k63 <= row7.pixel_9(9 downto 0);
            rgb_pixels_9x9.blue.k64 <= row8.pixel_1(9 downto 0);
            rgb_pixels_9x9.blue.k65 <= row8.pixel_2(9 downto 0);
            rgb_pixels_9x9.blue.k66 <= row8.pixel_3(9 downto 0);
            rgb_pixels_9x9.blue.k67 <= row8.pixel_4(9 downto 0);
            rgb_pixels_9x9.blue.k68 <= row8.pixel_5(9 downto 0);
            rgb_pixels_9x9.blue.k69 <= row8.pixel_6(9 downto 0);
            rgb_pixels_9x9.blue.k70 <= row8.pixel_7(9 downto 0);
            rgb_pixels_9x9.blue.k71 <= row8.pixel_8(9 downto 0);
            rgb_pixels_9x9.blue.k72 <= row8.pixel_9(9 downto 0);
            rgb_pixels_9x9.blue.k73 <= row9.pixel_1(9 downto 0);
            rgb_pixels_9x9.blue.k74 <= row9.pixel_2(9 downto 0);
            rgb_pixels_9x9.blue.k75 <= row9.pixel_3(9 downto 0);
            rgb_pixels_9x9.blue.k76 <= row9.pixel_4(9 downto 0);
            rgb_pixels_9x9.blue.k77 <= row9.pixel_5(9 downto 0);
            rgb_pixels_9x9.blue.k78 <= row9.pixel_6(9 downto 0);
            rgb_pixels_9x9.blue.k79 <= row9.pixel_7(9 downto 0);
            rgb_pixels_9x9.blue.k80 <= row9.pixel_8(9 downto 0);
            rgb_pixels_9x9.blue.k81 <= row9.pixel_9(9 downto 0);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_9x9.red.k1    <= to_integer(unsigned(rgb_pixels_9x9.red.k1)); 
        rgb_9x9.red.k2    <= to_integer(unsigned(rgb_pixels_9x9.red.k2)); 
        rgb_9x9.red.k3    <= to_integer(unsigned(rgb_pixels_9x9.red.k3)); 
        rgb_9x9.red.k4    <= to_integer(unsigned(rgb_pixels_9x9.red.k4)); 
        rgb_9x9.red.k5    <= to_integer(unsigned(rgb_pixels_9x9.red.k5)); 
        rgb_9x9.red.k6    <= to_integer(unsigned(rgb_pixels_9x9.red.k6)); 
        rgb_9x9.red.k7    <= to_integer(unsigned(rgb_pixels_9x9.red.k7)); 
        rgb_9x9.red.k8    <= to_integer(unsigned(rgb_pixels_9x9.red.k8)); 
        rgb_9x9.red.k9    <= to_integer(unsigned(rgb_pixels_9x9.red.k9)); 
        rgb_9x9.red.k10   <= to_integer(unsigned(rgb_pixels_9x9.red.k10));
        rgb_9x9.red.k11   <= to_integer(unsigned(rgb_pixels_9x9.red.k11));
        rgb_9x9.red.k12   <= to_integer(unsigned(rgb_pixels_9x9.red.k12));
        rgb_9x9.red.k13   <= to_integer(unsigned(rgb_pixels_9x9.red.k13));
        rgb_9x9.red.k14   <= to_integer(unsigned(rgb_pixels_9x9.red.k14));
        rgb_9x9.red.k15   <= to_integer(unsigned(rgb_pixels_9x9.red.k15));
        rgb_9x9.red.k16   <= to_integer(unsigned(rgb_pixels_9x9.red.k16));
        rgb_9x9.red.k17   <= to_integer(unsigned(rgb_pixels_9x9.red.k17));
        rgb_9x9.red.k18   <= to_integer(unsigned(rgb_pixels_9x9.red.k18));
        rgb_9x9.red.k19   <= to_integer(unsigned(rgb_pixels_9x9.red.k19));
        rgb_9x9.red.k20   <= to_integer(unsigned(rgb_pixels_9x9.red.k20));
        rgb_9x9.red.k21   <= to_integer(unsigned(rgb_pixels_9x9.red.k21));
        rgb_9x9.red.k22   <= to_integer(unsigned(rgb_pixels_9x9.red.k22));
        rgb_9x9.red.k23   <= to_integer(unsigned(rgb_pixels_9x9.red.k23));
        rgb_9x9.red.k24   <= to_integer(unsigned(rgb_pixels_9x9.red.k24));
        rgb_9x9.red.k25   <= to_integer(unsigned(rgb_pixels_9x9.red.k25));
        rgb_9x9.red.k26   <= to_integer(unsigned(rgb_pixels_9x9.red.k26));
        rgb_9x9.red.k27   <= to_integer(unsigned(rgb_pixels_9x9.red.k27));
        rgb_9x9.red.k28   <= to_integer(unsigned(rgb_pixels_9x9.red.k28));
        rgb_9x9.red.k29   <= to_integer(unsigned(rgb_pixels_9x9.red.k29));
        rgb_9x9.red.k30   <= to_integer(unsigned(rgb_pixels_9x9.red.k30));
        rgb_9x9.red.k31   <= to_integer(unsigned(rgb_pixels_9x9.red.k31));
        rgb_9x9.red.k32   <= to_integer(unsigned(rgb_pixels_9x9.red.k32));
        rgb_9x9.red.k33   <= to_integer(unsigned(rgb_pixels_9x9.red.k33));
        rgb_9x9.red.k34   <= to_integer(unsigned(rgb_pixels_9x9.red.k34));
        rgb_9x9.red.k35   <= to_integer(unsigned(rgb_pixels_9x9.red.k35));
        rgb_9x9.red.k36   <= to_integer(unsigned(rgb_pixels_9x9.red.k36));
        rgb_9x9.red.k37   <= to_integer(unsigned(rgb_pixels_9x9.red.k37));
        rgb_9x9.red.k38   <= to_integer(unsigned(rgb_pixels_9x9.red.k38));
        rgb_9x9.red.k39   <= to_integer(unsigned(rgb_pixels_9x9.red.k39));
        rgb_9x9.red.k40   <= to_integer(unsigned(rgb_pixels_9x9.red.k40));
        rgb_9x9.red.k41   <= to_integer(unsigned(rgb_pixels_9x9.red.k41));
        rgb_9x9.red.k42   <= to_integer(unsigned(rgb_pixels_9x9.red.k42));
        rgb_9x9.red.k43   <= to_integer(unsigned(rgb_pixels_9x9.red.k43));
        rgb_9x9.red.k44   <= to_integer(unsigned(rgb_pixels_9x9.red.k44));
        rgb_9x9.red.k45   <= to_integer(unsigned(rgb_pixels_9x9.red.k45));
        rgb_9x9.red.k46   <= to_integer(unsigned(rgb_pixels_9x9.red.k46));
        rgb_9x9.red.k47   <= to_integer(unsigned(rgb_pixels_9x9.red.k47));
        rgb_9x9.red.k48   <= to_integer(unsigned(rgb_pixels_9x9.red.k48));
        rgb_9x9.red.k49   <= to_integer(unsigned(rgb_pixels_9x9.red.k49));
        rgb_9x9.red.k50   <= to_integer(unsigned(rgb_pixels_9x9.red.k50));
        rgb_9x9.red.k51   <= to_integer(unsigned(rgb_pixels_9x9.red.k51));
        rgb_9x9.red.k52   <= to_integer(unsigned(rgb_pixels_9x9.red.k52));
        rgb_9x9.red.k53   <= to_integer(unsigned(rgb_pixels_9x9.red.k53));
        rgb_9x9.red.k54   <= to_integer(unsigned(rgb_pixels_9x9.red.k54));
        rgb_9x9.red.k55   <= to_integer(unsigned(rgb_pixels_9x9.red.k55));
        rgb_9x9.red.k56   <= to_integer(unsigned(rgb_pixels_9x9.red.k56));
        rgb_9x9.red.k57   <= to_integer(unsigned(rgb_pixels_9x9.red.k57));
        rgb_9x9.red.k58   <= to_integer(unsigned(rgb_pixels_9x9.red.k58));
        rgb_9x9.red.k59   <= to_integer(unsigned(rgb_pixels_9x9.red.k59));
        rgb_9x9.red.k60   <= to_integer(unsigned(rgb_pixels_9x9.red.k60));
        rgb_9x9.red.k61   <= to_integer(unsigned(rgb_pixels_9x9.red.k61));
        rgb_9x9.red.k62   <= to_integer(unsigned(rgb_pixels_9x9.red.k62));
        rgb_9x9.red.k63   <= to_integer(unsigned(rgb_pixels_9x9.red.k63));
        rgb_9x9.red.k64   <= to_integer(unsigned(rgb_pixels_9x9.red.k64));
        rgb_9x9.red.k65   <= to_integer(unsigned(rgb_pixels_9x9.red.k65));
        rgb_9x9.red.k66   <= to_integer(unsigned(rgb_pixels_9x9.red.k66));
        rgb_9x9.red.k67   <= to_integer(unsigned(rgb_pixels_9x9.red.k67));
        rgb_9x9.red.k68   <= to_integer(unsigned(rgb_pixels_9x9.red.k68));
        rgb_9x9.red.k69   <= to_integer(unsigned(rgb_pixels_9x9.red.k69));
        rgb_9x9.red.k70   <= to_integer(unsigned(rgb_pixels_9x9.red.k70));
        rgb_9x9.red.k71   <= to_integer(unsigned(rgb_pixels_9x9.red.k71));
        rgb_9x9.red.k72   <= to_integer(unsigned(rgb_pixels_9x9.red.k72));
        rgb_9x9.red.k73   <= to_integer(unsigned(rgb_pixels_9x9.red.k73));
        rgb_9x9.red.k74   <= to_integer(unsigned(rgb_pixels_9x9.red.k74));
        rgb_9x9.red.k75   <= to_integer(unsigned(rgb_pixels_9x9.red.k75));
        rgb_9x9.red.k76   <= to_integer(unsigned(rgb_pixels_9x9.red.k76));
        rgb_9x9.red.k77   <= to_integer(unsigned(rgb_pixels_9x9.red.k77));
        rgb_9x9.red.k78   <= to_integer(unsigned(rgb_pixels_9x9.red.k78));
        rgb_9x9.red.k79   <= to_integer(unsigned(rgb_pixels_9x9.red.k79));
        rgb_9x9.red.k80   <= to_integer(unsigned(rgb_pixels_9x9.red.k80));
        rgb_9x9.red.k81   <= to_integer(unsigned(rgb_pixels_9x9.red.k81));
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_9x9.green.k1    <= to_integer(unsigned(rgb_pixels_9x9.green.k1)); 
        rgb_9x9.green.k2    <= to_integer(unsigned(rgb_pixels_9x9.green.k2)); 
        rgb_9x9.green.k3    <= to_integer(unsigned(rgb_pixels_9x9.green.k3)); 
        rgb_9x9.green.k4    <= to_integer(unsigned(rgb_pixels_9x9.green.k4)); 
        rgb_9x9.green.k5    <= to_integer(unsigned(rgb_pixels_9x9.green.k5)); 
        rgb_9x9.green.k6    <= to_integer(unsigned(rgb_pixels_9x9.green.k6)); 
        rgb_9x9.green.k7    <= to_integer(unsigned(rgb_pixels_9x9.green.k7)); 
        rgb_9x9.green.k8    <= to_integer(unsigned(rgb_pixels_9x9.green.k8)); 
        rgb_9x9.green.k9    <= to_integer(unsigned(rgb_pixels_9x9.green.k9)); 
        rgb_9x9.green.k10   <= to_integer(unsigned(rgb_pixels_9x9.green.k10));
        rgb_9x9.green.k11   <= to_integer(unsigned(rgb_pixels_9x9.green.k11));
        rgb_9x9.green.k12   <= to_integer(unsigned(rgb_pixels_9x9.green.k12));
        rgb_9x9.green.k13   <= to_integer(unsigned(rgb_pixels_9x9.green.k13));
        rgb_9x9.green.k14   <= to_integer(unsigned(rgb_pixels_9x9.green.k14));
        rgb_9x9.green.k15   <= to_integer(unsigned(rgb_pixels_9x9.green.k15));
        rgb_9x9.green.k16   <= to_integer(unsigned(rgb_pixels_9x9.green.k16));
        rgb_9x9.green.k17   <= to_integer(unsigned(rgb_pixels_9x9.green.k17));
        rgb_9x9.green.k18   <= to_integer(unsigned(rgb_pixels_9x9.green.k18));
        rgb_9x9.green.k19   <= to_integer(unsigned(rgb_pixels_9x9.green.k19));
        rgb_9x9.green.k20   <= to_integer(unsigned(rgb_pixels_9x9.green.k20));
        rgb_9x9.green.k21   <= to_integer(unsigned(rgb_pixels_9x9.green.k21));
        rgb_9x9.green.k22   <= to_integer(unsigned(rgb_pixels_9x9.green.k22));
        rgb_9x9.green.k23   <= to_integer(unsigned(rgb_pixels_9x9.green.k23));
        rgb_9x9.green.k24   <= to_integer(unsigned(rgb_pixels_9x9.green.k24));
        rgb_9x9.green.k25   <= to_integer(unsigned(rgb_pixels_9x9.green.k25));
        rgb_9x9.green.k26   <= to_integer(unsigned(rgb_pixels_9x9.green.k26));
        rgb_9x9.green.k27   <= to_integer(unsigned(rgb_pixels_9x9.green.k27));
        rgb_9x9.green.k28   <= to_integer(unsigned(rgb_pixels_9x9.green.k28));
        rgb_9x9.green.k29   <= to_integer(unsigned(rgb_pixels_9x9.green.k29));
        rgb_9x9.green.k30   <= to_integer(unsigned(rgb_pixels_9x9.green.k30));
        rgb_9x9.green.k31   <= to_integer(unsigned(rgb_pixels_9x9.green.k31));
        rgb_9x9.green.k32   <= to_integer(unsigned(rgb_pixels_9x9.green.k32));
        rgb_9x9.green.k33   <= to_integer(unsigned(rgb_pixels_9x9.green.k33));
        rgb_9x9.green.k34   <= to_integer(unsigned(rgb_pixels_9x9.green.k34));
        rgb_9x9.green.k35   <= to_integer(unsigned(rgb_pixels_9x9.green.k35));
        rgb_9x9.green.k36   <= to_integer(unsigned(rgb_pixels_9x9.green.k36));
        rgb_9x9.green.k37   <= to_integer(unsigned(rgb_pixels_9x9.green.k37));
        rgb_9x9.green.k38   <= to_integer(unsigned(rgb_pixels_9x9.green.k38));
        rgb_9x9.green.k39   <= to_integer(unsigned(rgb_pixels_9x9.green.k39));
        rgb_9x9.green.k40   <= to_integer(unsigned(rgb_pixels_9x9.green.k40));
        rgb_9x9.green.k41   <= to_integer(unsigned(rgb_pixels_9x9.green.k41));
        rgb_9x9.green.k42   <= to_integer(unsigned(rgb_pixels_9x9.green.k42));
        rgb_9x9.green.k43   <= to_integer(unsigned(rgb_pixels_9x9.green.k43));
        rgb_9x9.green.k44   <= to_integer(unsigned(rgb_pixels_9x9.green.k44));
        rgb_9x9.green.k45   <= to_integer(unsigned(rgb_pixels_9x9.green.k45));
        rgb_9x9.green.k46   <= to_integer(unsigned(rgb_pixels_9x9.green.k46));
        rgb_9x9.green.k47   <= to_integer(unsigned(rgb_pixels_9x9.green.k47));
        rgb_9x9.green.k48   <= to_integer(unsigned(rgb_pixels_9x9.green.k48));
        rgb_9x9.green.k49   <= to_integer(unsigned(rgb_pixels_9x9.green.k49));
        rgb_9x9.green.k50   <= to_integer(unsigned(rgb_pixels_9x9.green.k50));
        rgb_9x9.green.k51   <= to_integer(unsigned(rgb_pixels_9x9.green.k51));
        rgb_9x9.green.k52   <= to_integer(unsigned(rgb_pixels_9x9.green.k52));
        rgb_9x9.green.k53   <= to_integer(unsigned(rgb_pixels_9x9.green.k53));
        rgb_9x9.green.k54   <= to_integer(unsigned(rgb_pixels_9x9.green.k54));
        rgb_9x9.green.k55   <= to_integer(unsigned(rgb_pixels_9x9.green.k55));
        rgb_9x9.green.k56   <= to_integer(unsigned(rgb_pixels_9x9.green.k56));
        rgb_9x9.green.k57   <= to_integer(unsigned(rgb_pixels_9x9.green.k57));
        rgb_9x9.green.k58   <= to_integer(unsigned(rgb_pixels_9x9.green.k58));
        rgb_9x9.green.k59   <= to_integer(unsigned(rgb_pixels_9x9.green.k59));
        rgb_9x9.green.k60   <= to_integer(unsigned(rgb_pixels_9x9.green.k60));
        rgb_9x9.green.k61   <= to_integer(unsigned(rgb_pixels_9x9.green.k61));
        rgb_9x9.green.k62   <= to_integer(unsigned(rgb_pixels_9x9.green.k62));
        rgb_9x9.green.k63   <= to_integer(unsigned(rgb_pixels_9x9.green.k63));
        rgb_9x9.green.k64   <= to_integer(unsigned(rgb_pixels_9x9.green.k64));
        rgb_9x9.green.k65   <= to_integer(unsigned(rgb_pixels_9x9.green.k65));
        rgb_9x9.green.k66   <= to_integer(unsigned(rgb_pixels_9x9.green.k66));
        rgb_9x9.green.k67   <= to_integer(unsigned(rgb_pixels_9x9.green.k67));
        rgb_9x9.green.k68   <= to_integer(unsigned(rgb_pixels_9x9.green.k68));
        rgb_9x9.green.k69   <= to_integer(unsigned(rgb_pixels_9x9.green.k69));
        rgb_9x9.green.k70   <= to_integer(unsigned(rgb_pixels_9x9.green.k70));
        rgb_9x9.green.k71   <= to_integer(unsigned(rgb_pixels_9x9.green.k71));
        rgb_9x9.green.k72   <= to_integer(unsigned(rgb_pixels_9x9.green.k72));
        rgb_9x9.green.k73   <= to_integer(unsigned(rgb_pixels_9x9.green.k73));
        rgb_9x9.green.k74   <= to_integer(unsigned(rgb_pixels_9x9.green.k74));
        rgb_9x9.green.k75   <= to_integer(unsigned(rgb_pixels_9x9.green.k75));
        rgb_9x9.green.k76   <= to_integer(unsigned(rgb_pixels_9x9.green.k76));
        rgb_9x9.green.k77   <= to_integer(unsigned(rgb_pixels_9x9.green.k77));
        rgb_9x9.green.k78   <= to_integer(unsigned(rgb_pixels_9x9.green.k78));
        rgb_9x9.green.k79   <= to_integer(unsigned(rgb_pixels_9x9.green.k79));
        rgb_9x9.green.k80   <= to_integer(unsigned(rgb_pixels_9x9.green.k80));
        rgb_9x9.green.k81   <= to_integer(unsigned(rgb_pixels_9x9.green.k81));
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_9x9.blue.k1    <= to_integer(unsigned(rgb_pixels_9x9.blue.k1)); 
        rgb_9x9.blue.k2    <= to_integer(unsigned(rgb_pixels_9x9.blue.k2)); 
        rgb_9x9.blue.k3    <= to_integer(unsigned(rgb_pixels_9x9.blue.k3)); 
        rgb_9x9.blue.k4    <= to_integer(unsigned(rgb_pixels_9x9.blue.k4)); 
        rgb_9x9.blue.k5    <= to_integer(unsigned(rgb_pixels_9x9.blue.k5)); 
        rgb_9x9.blue.k6    <= to_integer(unsigned(rgb_pixels_9x9.blue.k6)); 
        rgb_9x9.blue.k7    <= to_integer(unsigned(rgb_pixels_9x9.blue.k7)); 
        rgb_9x9.blue.k8    <= to_integer(unsigned(rgb_pixels_9x9.blue.k8)); 
        rgb_9x9.blue.k9    <= to_integer(unsigned(rgb_pixels_9x9.blue.k9)); 
        rgb_9x9.blue.k10   <= to_integer(unsigned(rgb_pixels_9x9.blue.k10));
        rgb_9x9.blue.k11   <= to_integer(unsigned(rgb_pixels_9x9.blue.k11));
        rgb_9x9.blue.k12   <= to_integer(unsigned(rgb_pixels_9x9.blue.k12));
        rgb_9x9.blue.k13   <= to_integer(unsigned(rgb_pixels_9x9.blue.k13));
        rgb_9x9.blue.k14   <= to_integer(unsigned(rgb_pixels_9x9.blue.k14));
        rgb_9x9.blue.k15   <= to_integer(unsigned(rgb_pixels_9x9.blue.k15));
        rgb_9x9.blue.k16   <= to_integer(unsigned(rgb_pixels_9x9.blue.k16));
        rgb_9x9.blue.k17   <= to_integer(unsigned(rgb_pixels_9x9.blue.k17));
        rgb_9x9.blue.k18   <= to_integer(unsigned(rgb_pixels_9x9.blue.k18));
        rgb_9x9.blue.k19   <= to_integer(unsigned(rgb_pixels_9x9.blue.k19));
        rgb_9x9.blue.k20   <= to_integer(unsigned(rgb_pixels_9x9.blue.k20));
        rgb_9x9.blue.k21   <= to_integer(unsigned(rgb_pixels_9x9.blue.k21));
        rgb_9x9.blue.k22   <= to_integer(unsigned(rgb_pixels_9x9.blue.k22));
        rgb_9x9.blue.k23   <= to_integer(unsigned(rgb_pixels_9x9.blue.k23));
        rgb_9x9.blue.k24   <= to_integer(unsigned(rgb_pixels_9x9.blue.k24));
        rgb_9x9.blue.k25   <= to_integer(unsigned(rgb_pixels_9x9.blue.k25));
        rgb_9x9.blue.k26   <= to_integer(unsigned(rgb_pixels_9x9.blue.k26));
        rgb_9x9.blue.k27   <= to_integer(unsigned(rgb_pixels_9x9.blue.k27));
        rgb_9x9.blue.k28   <= to_integer(unsigned(rgb_pixels_9x9.blue.k28));
        rgb_9x9.blue.k29   <= to_integer(unsigned(rgb_pixels_9x9.blue.k29));
        rgb_9x9.blue.k30   <= to_integer(unsigned(rgb_pixels_9x9.blue.k30));
        rgb_9x9.blue.k31   <= to_integer(unsigned(rgb_pixels_9x9.blue.k31));
        rgb_9x9.blue.k32   <= to_integer(unsigned(rgb_pixels_9x9.blue.k32));
        rgb_9x9.blue.k33   <= to_integer(unsigned(rgb_pixels_9x9.blue.k33));
        rgb_9x9.blue.k34   <= to_integer(unsigned(rgb_pixels_9x9.blue.k34));
        rgb_9x9.blue.k35   <= to_integer(unsigned(rgb_pixels_9x9.blue.k35));
        rgb_9x9.blue.k36   <= to_integer(unsigned(rgb_pixels_9x9.blue.k36));
        rgb_9x9.blue.k37   <= to_integer(unsigned(rgb_pixels_9x9.blue.k37));
        rgb_9x9.blue.k38   <= to_integer(unsigned(rgb_pixels_9x9.blue.k38));
        rgb_9x9.blue.k39   <= to_integer(unsigned(rgb_pixels_9x9.blue.k39));
        rgb_9x9.blue.k40   <= to_integer(unsigned(rgb_pixels_9x9.blue.k40));
        rgb_9x9.blue.k41   <= to_integer(unsigned(rgb_pixels_9x9.blue.k41));
        rgb_9x9.blue.k42   <= to_integer(unsigned(rgb_pixels_9x9.blue.k42));
        rgb_9x9.blue.k43   <= to_integer(unsigned(rgb_pixels_9x9.blue.k43));
        rgb_9x9.blue.k44   <= to_integer(unsigned(rgb_pixels_9x9.blue.k44));
        rgb_9x9.blue.k45   <= to_integer(unsigned(rgb_pixels_9x9.blue.k45));
        rgb_9x9.blue.k46   <= to_integer(unsigned(rgb_pixels_9x9.blue.k46));
        rgb_9x9.blue.k47   <= to_integer(unsigned(rgb_pixels_9x9.blue.k47));
        rgb_9x9.blue.k48   <= to_integer(unsigned(rgb_pixels_9x9.blue.k48));
        rgb_9x9.blue.k49   <= to_integer(unsigned(rgb_pixels_9x9.blue.k49));
        rgb_9x9.blue.k50   <= to_integer(unsigned(rgb_pixels_9x9.blue.k50));
        rgb_9x9.blue.k51   <= to_integer(unsigned(rgb_pixels_9x9.blue.k51));
        rgb_9x9.blue.k52   <= to_integer(unsigned(rgb_pixels_9x9.blue.k52));
        rgb_9x9.blue.k53   <= to_integer(unsigned(rgb_pixels_9x9.blue.k53));
        rgb_9x9.blue.k54   <= to_integer(unsigned(rgb_pixels_9x9.blue.k54));
        rgb_9x9.blue.k55   <= to_integer(unsigned(rgb_pixels_9x9.blue.k55));
        rgb_9x9.blue.k56   <= to_integer(unsigned(rgb_pixels_9x9.blue.k56));
        rgb_9x9.blue.k57   <= to_integer(unsigned(rgb_pixels_9x9.blue.k57));
        rgb_9x9.blue.k58   <= to_integer(unsigned(rgb_pixels_9x9.blue.k58));
        rgb_9x9.blue.k59   <= to_integer(unsigned(rgb_pixels_9x9.blue.k59));
        rgb_9x9.blue.k60   <= to_integer(unsigned(rgb_pixels_9x9.blue.k60));
        rgb_9x9.blue.k61   <= to_integer(unsigned(rgb_pixels_9x9.blue.k61));
        rgb_9x9.blue.k62   <= to_integer(unsigned(rgb_pixels_9x9.blue.k62));
        rgb_9x9.blue.k63   <= to_integer(unsigned(rgb_pixels_9x9.blue.k63));
        rgb_9x9.blue.k64   <= to_integer(unsigned(rgb_pixels_9x9.blue.k64));
        rgb_9x9.blue.k65   <= to_integer(unsigned(rgb_pixels_9x9.blue.k65));
        rgb_9x9.blue.k66   <= to_integer(unsigned(rgb_pixels_9x9.blue.k66));
        rgb_9x9.blue.k67   <= to_integer(unsigned(rgb_pixels_9x9.blue.k67));
        rgb_9x9.blue.k68   <= to_integer(unsigned(rgb_pixels_9x9.blue.k68));
        rgb_9x9.blue.k69   <= to_integer(unsigned(rgb_pixels_9x9.blue.k69));
        rgb_9x9.blue.k70   <= to_integer(unsigned(rgb_pixels_9x9.blue.k70));
        rgb_9x9.blue.k71   <= to_integer(unsigned(rgb_pixels_9x9.blue.k71));
        rgb_9x9.blue.k72   <= to_integer(unsigned(rgb_pixels_9x9.blue.k72));
        rgb_9x9.blue.k73   <= to_integer(unsigned(rgb_pixels_9x9.blue.k73));
        rgb_9x9.blue.k74   <= to_integer(unsigned(rgb_pixels_9x9.blue.k74));
        rgb_9x9.blue.k75   <= to_integer(unsigned(rgb_pixels_9x9.blue.k75));
        rgb_9x9.blue.k76   <= to_integer(unsigned(rgb_pixels_9x9.blue.k76));
        rgb_9x9.blue.k77   <= to_integer(unsigned(rgb_pixels_9x9.blue.k77));
        rgb_9x9.blue.k78   <= to_integer(unsigned(rgb_pixels_9x9.blue.k78));
        rgb_9x9.blue.k79   <= to_integer(unsigned(rgb_pixels_9x9.blue.k79));
        rgb_9x9.blue.k80   <= to_integer(unsigned(rgb_pixels_9x9.blue.k80));
        rgb_9x9.blue.k81   <= to_integer(unsigned(rgb_pixels_9x9.blue.k81)); 
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_9x9_delta.filter_size_9x9.red.k1      <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k1); 
        rgb_9x9_delta.filter_size_9x9.red.k2      <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k2); 
        rgb_9x9_delta.filter_size_9x9.red.k3      <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k3); 
        rgb_9x9_delta.filter_size_9x9.red.k4      <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k4); 
        rgb_9x9_delta.filter_size_9x9.red.k5      <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k5); 
        rgb_9x9_delta.filter_size_9x9.red.k6      <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k6); 
        rgb_9x9_delta.filter_size_9x9.red.k7      <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k7); 
        rgb_9x9_delta.filter_size_9x9.red.k8      <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k8); 
        rgb_9x9_delta.filter_size_9x9.red.k9      <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k9); 
        rgb_9x9_delta.filter_size_9x9.red.k10     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k10);
        rgb_9x9_delta.filter_size_9x9.red.k11     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k11);
        rgb_9x9_delta.filter_size_9x9.red.k12     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k12);
        rgb_9x9_delta.filter_size_9x9.red.k13     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k13);
        rgb_9x9_delta.filter_size_9x9.red.k14     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k14);
        rgb_9x9_delta.filter_size_9x9.red.k15     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k15);
        rgb_9x9_delta.filter_size_9x9.red.k16     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k16);
        rgb_9x9_delta.filter_size_9x9.red.k17     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k17);
        rgb_9x9_delta.filter_size_9x9.red.k18     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k18);
        rgb_9x9_delta.filter_size_9x9.red.k19     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k19);
        rgb_9x9_delta.filter_size_9x9.red.k20     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k20);
        rgb_9x9_delta.filter_size_9x9.red.k21     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k21);
        rgb_9x9_delta.filter_size_9x9.red.k22     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k22);
        rgb_9x9_delta.filter_size_9x9.red.k23     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k23);
        rgb_9x9_delta.filter_size_9x9.red.k24     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k24);
        rgb_9x9_delta.filter_size_9x9.red.k25     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k25);
        rgb_9x9_delta.filter_size_9x9.red.k26     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k26);
        rgb_9x9_delta.filter_size_9x9.red.k27     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k27);
        rgb_9x9_delta.filter_size_9x9.red.k28     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k28);
        rgb_9x9_delta.filter_size_9x9.red.k29     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k29);
        rgb_9x9_delta.filter_size_9x9.red.k30     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k30);
        rgb_9x9_delta.filter_size_9x9.red.k31     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k31);
        rgb_9x9_delta.filter_size_9x9.red.k32     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k32);
        rgb_9x9_delta.filter_size_9x9.red.k33     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k33);
        rgb_9x9_delta.filter_size_9x9.red.k34     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k34);
        rgb_9x9_delta.filter_size_9x9.red.k35     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k35);
        rgb_9x9_delta.filter_size_9x9.red.k36     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k36);
        rgb_9x9_delta.filter_size_9x9.red.k37     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k37);
        rgb_9x9_delta.filter_size_9x9.red.k38     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k38);
        rgb_9x9_delta.filter_size_9x9.red.k39     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k39);
        rgb_9x9_delta.filter_size_9x9.red.k40     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k40);
        rgb_9x9_delta.filter_size_9x9.red.k41     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k41);
        rgb_9x9_delta.filter_size_9x9.red.k42     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k42);
        rgb_9x9_delta.filter_size_9x9.red.k43     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k43);
        rgb_9x9_delta.filter_size_9x9.red.k44     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k44);
        rgb_9x9_delta.filter_size_9x9.red.k45     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k45);
        rgb_9x9_delta.filter_size_9x9.red.k46     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k46);
        rgb_9x9_delta.filter_size_9x9.red.k47     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k47);
        rgb_9x9_delta.filter_size_9x9.red.k48     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k48);
        rgb_9x9_delta.filter_size_9x9.red.k49     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k49);
        rgb_9x9_delta.filter_size_9x9.red.k50     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k50);
        rgb_9x9_delta.filter_size_9x9.red.k51     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k51);
        rgb_9x9_delta.filter_size_9x9.red.k52     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k52);
        rgb_9x9_delta.filter_size_9x9.red.k53     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k53);
        rgb_9x9_delta.filter_size_9x9.red.k54     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k54);
        rgb_9x9_delta.filter_size_9x9.red.k55     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k55);
        rgb_9x9_delta.filter_size_9x9.red.k56     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k56);
        rgb_9x9_delta.filter_size_9x9.red.k57     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k57);
        rgb_9x9_delta.filter_size_9x9.red.k58     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k58);
        rgb_9x9_delta.filter_size_9x9.red.k59     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k59);
        rgb_9x9_delta.filter_size_9x9.red.k60     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k60);
        rgb_9x9_delta.filter_size_9x9.red.k61     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k61);
        rgb_9x9_delta.filter_size_9x9.red.k62     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k62);
        rgb_9x9_delta.filter_size_9x9.red.k63     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k63);
        rgb_9x9_delta.filter_size_9x9.red.k64     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k64);
        rgb_9x9_delta.filter_size_9x9.red.k65     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k65);
        rgb_9x9_delta.filter_size_9x9.red.k66     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k66);
        rgb_9x9_delta.filter_size_9x9.red.k67     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k67);
        rgb_9x9_delta.filter_size_9x9.red.k68     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k68);
        rgb_9x9_delta.filter_size_9x9.red.k69     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k69);
        rgb_9x9_delta.filter_size_9x9.red.k70     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k70);
        rgb_9x9_delta.filter_size_9x9.red.k71     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k71);
        rgb_9x9_delta.filter_size_9x9.red.k72     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k72);
        rgb_9x9_delta.filter_size_9x9.red.k73     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k73);
        rgb_9x9_delta.filter_size_9x9.red.k74     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k74);
        rgb_9x9_delta.filter_size_9x9.red.k75     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k75);
        rgb_9x9_delta.filter_size_9x9.red.k76     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k76);
        rgb_9x9_delta.filter_size_9x9.red.k77     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k77);
        rgb_9x9_delta.filter_size_9x9.red.k78     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k78);
        rgb_9x9_delta.filter_size_9x9.red.k79     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k79);
        rgb_9x9_delta.filter_size_9x9.red.k80     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k80);
        rgb_9x9_delta.filter_size_9x9.red.k81     <= abs(rgb_9x9.red.k1 - rgb_9x9.red.k81);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_9x9_delta.filter_size_9x9.green.k1      <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k1); 
        rgb_9x9_delta.filter_size_9x9.green.k2      <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k2); 
        rgb_9x9_delta.filter_size_9x9.green.k3      <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k3); 
        rgb_9x9_delta.filter_size_9x9.green.k4      <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k4); 
        rgb_9x9_delta.filter_size_9x9.green.k5      <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k5); 
        rgb_9x9_delta.filter_size_9x9.green.k6      <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k6); 
        rgb_9x9_delta.filter_size_9x9.green.k7      <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k7); 
        rgb_9x9_delta.filter_size_9x9.green.k8      <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k8); 
        rgb_9x9_delta.filter_size_9x9.green.k9      <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k9); 
        rgb_9x9_delta.filter_size_9x9.green.k10     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k10);
        rgb_9x9_delta.filter_size_9x9.green.k11     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k11);
        rgb_9x9_delta.filter_size_9x9.green.k12     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k12);
        rgb_9x9_delta.filter_size_9x9.green.k13     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k13);
        rgb_9x9_delta.filter_size_9x9.green.k14     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k14);
        rgb_9x9_delta.filter_size_9x9.green.k15     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k15);
        rgb_9x9_delta.filter_size_9x9.green.k16     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k16);
        rgb_9x9_delta.filter_size_9x9.green.k17     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k17);
        rgb_9x9_delta.filter_size_9x9.green.k18     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k18);
        rgb_9x9_delta.filter_size_9x9.green.k19     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k19);
        rgb_9x9_delta.filter_size_9x9.green.k20     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k20);
        rgb_9x9_delta.filter_size_9x9.green.k21     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k21);
        rgb_9x9_delta.filter_size_9x9.green.k22     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k22);
        rgb_9x9_delta.filter_size_9x9.green.k23     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k23);
        rgb_9x9_delta.filter_size_9x9.green.k24     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k24);
        rgb_9x9_delta.filter_size_9x9.green.k25     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k25);
        rgb_9x9_delta.filter_size_9x9.green.k26     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k26);
        rgb_9x9_delta.filter_size_9x9.green.k27     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k27);
        rgb_9x9_delta.filter_size_9x9.green.k28     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k28);
        rgb_9x9_delta.filter_size_9x9.green.k29     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k29);
        rgb_9x9_delta.filter_size_9x9.green.k30     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k30);
        rgb_9x9_delta.filter_size_9x9.green.k31     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k31);
        rgb_9x9_delta.filter_size_9x9.green.k32     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k32);
        rgb_9x9_delta.filter_size_9x9.green.k33     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k33);
        rgb_9x9_delta.filter_size_9x9.green.k34     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k34);
        rgb_9x9_delta.filter_size_9x9.green.k35     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k35);
        rgb_9x9_delta.filter_size_9x9.green.k36     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k36);
        rgb_9x9_delta.filter_size_9x9.green.k37     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k37);
        rgb_9x9_delta.filter_size_9x9.green.k38     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k38);
        rgb_9x9_delta.filter_size_9x9.green.k39     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k39);
        rgb_9x9_delta.filter_size_9x9.green.k40     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k40);
        rgb_9x9_delta.filter_size_9x9.green.k41     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k41);
        rgb_9x9_delta.filter_size_9x9.green.k42     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k42);
        rgb_9x9_delta.filter_size_9x9.green.k43     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k43);
        rgb_9x9_delta.filter_size_9x9.green.k44     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k44);
        rgb_9x9_delta.filter_size_9x9.green.k45     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k45);
        rgb_9x9_delta.filter_size_9x9.green.k46     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k46);
        rgb_9x9_delta.filter_size_9x9.green.k47     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k47);
        rgb_9x9_delta.filter_size_9x9.green.k48     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k48);
        rgb_9x9_delta.filter_size_9x9.green.k49     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k49);
        rgb_9x9_delta.filter_size_9x9.green.k50     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k50);
        rgb_9x9_delta.filter_size_9x9.green.k51     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k51);
        rgb_9x9_delta.filter_size_9x9.green.k52     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k52);
        rgb_9x9_delta.filter_size_9x9.green.k53     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k53);
        rgb_9x9_delta.filter_size_9x9.green.k54     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k54);
        rgb_9x9_delta.filter_size_9x9.green.k55     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k55);
        rgb_9x9_delta.filter_size_9x9.green.k56     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k56);
        rgb_9x9_delta.filter_size_9x9.green.k57     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k57);
        rgb_9x9_delta.filter_size_9x9.green.k58     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k58);
        rgb_9x9_delta.filter_size_9x9.green.k59     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k59);
        rgb_9x9_delta.filter_size_9x9.green.k60     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k60);
        rgb_9x9_delta.filter_size_9x9.green.k61     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k61);
        rgb_9x9_delta.filter_size_9x9.green.k62     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k62);
        rgb_9x9_delta.filter_size_9x9.green.k63     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k63);
        rgb_9x9_delta.filter_size_9x9.green.k64     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k64);
        rgb_9x9_delta.filter_size_9x9.green.k65     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k65);
        rgb_9x9_delta.filter_size_9x9.green.k66     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k66);
        rgb_9x9_delta.filter_size_9x9.green.k67     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k67);
        rgb_9x9_delta.filter_size_9x9.green.k68     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k68);
        rgb_9x9_delta.filter_size_9x9.green.k69     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k69);
        rgb_9x9_delta.filter_size_9x9.green.k70     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k70);
        rgb_9x9_delta.filter_size_9x9.green.k71     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k71);
        rgb_9x9_delta.filter_size_9x9.green.k72     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k72);
        rgb_9x9_delta.filter_size_9x9.green.k73     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k73);
        rgb_9x9_delta.filter_size_9x9.green.k74     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k74);
        rgb_9x9_delta.filter_size_9x9.green.k75     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k75);
        rgb_9x9_delta.filter_size_9x9.green.k76     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k76);
        rgb_9x9_delta.filter_size_9x9.green.k77     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k77);
        rgb_9x9_delta.filter_size_9x9.green.k78     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k78);
        rgb_9x9_delta.filter_size_9x9.green.k79     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k79);
        rgb_9x9_delta.filter_size_9x9.green.k80     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k80);
        rgb_9x9_delta.filter_size_9x9.green.k81     <= abs(rgb_9x9.green.k1 - rgb_9x9.green.k81);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_9x9_delta.filter_size_9x9.blue.k1      <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k1); 
        rgb_9x9_delta.filter_size_9x9.blue.k2      <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k2); 
        rgb_9x9_delta.filter_size_9x9.blue.k3      <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k3); 
        rgb_9x9_delta.filter_size_9x9.blue.k4      <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k4); 
        rgb_9x9_delta.filter_size_9x9.blue.k5      <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k5); 
        rgb_9x9_delta.filter_size_9x9.blue.k6      <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k6); 
        rgb_9x9_delta.filter_size_9x9.blue.k7      <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k7); 
        rgb_9x9_delta.filter_size_9x9.blue.k8      <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k8); 
        rgb_9x9_delta.filter_size_9x9.blue.k9      <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k9); 
        rgb_9x9_delta.filter_size_9x9.blue.k10     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k10);
        rgb_9x9_delta.filter_size_9x9.blue.k11     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k11);
        rgb_9x9_delta.filter_size_9x9.blue.k12     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k12);
        rgb_9x9_delta.filter_size_9x9.blue.k13     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k13);
        rgb_9x9_delta.filter_size_9x9.blue.k14     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k14);
        rgb_9x9_delta.filter_size_9x9.blue.k15     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k15);
        rgb_9x9_delta.filter_size_9x9.blue.k16     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k16);
        rgb_9x9_delta.filter_size_9x9.blue.k17     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k17);
        rgb_9x9_delta.filter_size_9x9.blue.k18     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k18);
        rgb_9x9_delta.filter_size_9x9.blue.k19     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k19);
        rgb_9x9_delta.filter_size_9x9.blue.k20     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k20);
        rgb_9x9_delta.filter_size_9x9.blue.k21     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k21);
        rgb_9x9_delta.filter_size_9x9.blue.k22     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k22);
        rgb_9x9_delta.filter_size_9x9.blue.k23     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k23);
        rgb_9x9_delta.filter_size_9x9.blue.k24     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k24);
        rgb_9x9_delta.filter_size_9x9.blue.k25     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k25);
        rgb_9x9_delta.filter_size_9x9.blue.k26     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k26);
        rgb_9x9_delta.filter_size_9x9.blue.k27     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k27);
        rgb_9x9_delta.filter_size_9x9.blue.k28     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k28);
        rgb_9x9_delta.filter_size_9x9.blue.k29     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k29);
        rgb_9x9_delta.filter_size_9x9.blue.k30     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k30);
        rgb_9x9_delta.filter_size_9x9.blue.k31     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k31);
        rgb_9x9_delta.filter_size_9x9.blue.k32     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k32);
        rgb_9x9_delta.filter_size_9x9.blue.k33     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k33);
        rgb_9x9_delta.filter_size_9x9.blue.k34     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k34);
        rgb_9x9_delta.filter_size_9x9.blue.k35     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k35);
        rgb_9x9_delta.filter_size_9x9.blue.k36     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k36);
        rgb_9x9_delta.filter_size_9x9.blue.k37     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k37);
        rgb_9x9_delta.filter_size_9x9.blue.k38     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k38);
        rgb_9x9_delta.filter_size_9x9.blue.k39     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k39);
        rgb_9x9_delta.filter_size_9x9.blue.k40     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k40);
        rgb_9x9_delta.filter_size_9x9.blue.k41     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k41);
        rgb_9x9_delta.filter_size_9x9.blue.k42     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k42);
        rgb_9x9_delta.filter_size_9x9.blue.k43     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k43);
        rgb_9x9_delta.filter_size_9x9.blue.k44     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k44);
        rgb_9x9_delta.filter_size_9x9.blue.k45     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k45);
        rgb_9x9_delta.filter_size_9x9.blue.k46     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k46);
        rgb_9x9_delta.filter_size_9x9.blue.k47     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k47);
        rgb_9x9_delta.filter_size_9x9.blue.k48     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k48);
        rgb_9x9_delta.filter_size_9x9.blue.k49     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k49);
        rgb_9x9_delta.filter_size_9x9.blue.k50     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k50);
        rgb_9x9_delta.filter_size_9x9.blue.k51     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k51);
        rgb_9x9_delta.filter_size_9x9.blue.k52     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k52);
        rgb_9x9_delta.filter_size_9x9.blue.k53     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k53);
        rgb_9x9_delta.filter_size_9x9.blue.k54     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k54);
        rgb_9x9_delta.filter_size_9x9.blue.k55     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k55);
        rgb_9x9_delta.filter_size_9x9.blue.k56     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k56);
        rgb_9x9_delta.filter_size_9x9.blue.k57     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k57);
        rgb_9x9_delta.filter_size_9x9.blue.k58     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k58);
        rgb_9x9_delta.filter_size_9x9.blue.k59     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k59);
        rgb_9x9_delta.filter_size_9x9.blue.k60     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k60);
        rgb_9x9_delta.filter_size_9x9.blue.k61     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k61);
        rgb_9x9_delta.filter_size_9x9.blue.k62     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k62);
        rgb_9x9_delta.filter_size_9x9.blue.k63     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k63);
        rgb_9x9_delta.filter_size_9x9.blue.k64     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k64);
        rgb_9x9_delta.filter_size_9x9.blue.k65     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k65);
        rgb_9x9_delta.filter_size_9x9.blue.k66     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k66);
        rgb_9x9_delta.filter_size_9x9.blue.k67     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k67);
        rgb_9x9_delta.filter_size_9x9.blue.k68     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k68);
        rgb_9x9_delta.filter_size_9x9.blue.k69     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k69);
        rgb_9x9_delta.filter_size_9x9.blue.k70     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k70);
        rgb_9x9_delta.filter_size_9x9.blue.k71     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k71);
        rgb_9x9_delta.filter_size_9x9.blue.k72     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k72);
        rgb_9x9_delta.filter_size_9x9.blue.k73     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k73);
        rgb_9x9_delta.filter_size_9x9.blue.k74     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k74);
        rgb_9x9_delta.filter_size_9x9.blue.k75     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k75);
        rgb_9x9_delta.filter_size_9x9.blue.k76     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k76);
        rgb_9x9_delta.filter_size_9x9.blue.k77     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k77);
        rgb_9x9_delta.filter_size_9x9.blue.k78     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k78);
        rgb_9x9_delta.filter_size_9x9.blue.k79     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k79);
        rgb_9x9_delta.filter_size_9x9.blue.k80     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k80);
        rgb_9x9_delta.filter_size_9x9.blue.k81     <= abs(rgb_9x9.blue.k1 - rgb_9x9.blue.k81);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        pix_9x9.red   <= rgb_9x9.red;
        pix_9x9.green <= rgb_9x9.green;
        pix_9x9.blue  <= rgb_9x9.blue;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        --sum.red.pixels_01_02_03_3x3                <= (pix_9x9.red.k1  + pix_9x9.red.k2*2  + pix_9x9.red.k3) / 4;
        --sum.red.pixels_10_11_12_3x3                <= (pix_9x9.red.k10*2 + pix_9x9.red.k11*4 + pix_9x9.red.k12*2) / 8;
        --sum.red.pixels_19_20_21_3x3                <= (pix_9x9.red.k19 + pix_9x9.red.k20*2 + pix_9x9.red.k21) / 4;
        --sum.red.pixels_01                          <= (pix_9x9.red.k5);
        --sum.red.pixels_01_02                       <= (pix_9x9.red.k1*2  + pix_9x9.red.k2) / 3;
        ----if(crd_s40.y=0)then
        ----    sum.red.pixels_01_to_21_3x3                <= (sum.red.pixels_01_02_03_3x3);
        ----elsif(crd_s40.y=1)then
        ----    sum.red.pixels_01_to_21_3x3                <= (sum.red.pixels_01_02_03_3x3 + sum.red.pixels_10_11_12_3x3) / 2;
       ----else
        --    sum.red.pixels_01_to_21_3x3                  <= (sum.red.pixels_01_02_03_3x3 + sum.red.pixels_10_11_12_3x3 + sum.red.pixels_19_20_21_3x3) / 3;
        ----end if;
        sum.red.pixels_01_02_03                    <= (rgb_9x9.red.k1  + rgb_9x9.red.k2   + rgb_9x9.red.k3)  / 3;
        sum.red.pixels_04_05_06                    <= (rgb_9x9.red.k4  + rgb_9x9.red.k5   + rgb_9x9.red.k6)  / 3;
        sum.red.pixels_07_08_09                    <= (rgb_9x9.red.k7  + rgb_9x9.red.k8   + rgb_9x9.red.k9)  / 3;
        sum.red.pixels_10_11_12                    <= (rgb_9x9.red.k10 + rgb_9x9.red.k11  + rgb_9x9.red.k12) / 3;
        sum.red.pixels_13_14_15                    <= (rgb_9x9.red.k13 + rgb_9x9.red.k14  + rgb_9x9.red.k15) / 3;
        sum.red.pixels_16_17_18                    <= (rgb_9x9.red.k16 + rgb_9x9.red.k17  + rgb_9x9.red.k18) / 3;
        sum.red.pixels_19_20_21                    <= (rgb_9x9.red.k19 + rgb_9x9.red.k20  + rgb_9x9.red.k21) / 3;
        sum.red.pixels_22_23_24                    <= (rgb_9x9.red.k22 + rgb_9x9.red.k23  + rgb_9x9.red.k24) / 3;
        sum.red.pixels_25_26_27                    <= (rgb_9x9.red.k25 + rgb_9x9.red.k26  + rgb_9x9.red.k27) / 3;
        sum.red.pixels_28_29_30                    <= (rgb_9x9.red.k28 + rgb_9x9.red.k29  + rgb_9x9.red.k30) / 3;
        sum.red.pixels_31_32_33                    <= (rgb_9x9.red.k31 + rgb_9x9.red.k32  + rgb_9x9.red.k33) / 3;
        sum.red.pixels_34_35_36                    <= (rgb_9x9.red.k34 + rgb_9x9.red.k35  + rgb_9x9.red.k36) / 3;
        sum.red.pixels_37_38_39                    <= (rgb_9x9.red.k37 + rgb_9x9.red.k38  + rgb_9x9.red.k39) / 3;
        sum.red.pixels_40_41_42                    <= (rgb_9x9.red.k40 + rgb_9x9.red.k41  + rgb_9x9.red.k42) / 3;
        sum.red.pixels_43_44_45                    <= (rgb_9x9.red.k43 + rgb_9x9.red.k44  + rgb_9x9.red.k45) / 3;
        sum.red.pixels_46_47_48                    <= (rgb_9x9.red.k46 + rgb_9x9.red.k47  + rgb_9x9.red.k48) / 3;
        sum.red.pixels_49_50_51                    <= (rgb_9x9.red.k49 + rgb_9x9.red.k50  + rgb_9x9.red.k51) / 3;
        sum.red.pixels_52_53_54                    <= (rgb_9x9.red.k52 + rgb_9x9.red.k53  + rgb_9x9.red.k54) / 3;
        sum.red.pixels_55_56_57                    <= (rgb_9x9.red.k55 + rgb_9x9.red.k56  + rgb_9x9.red.k57) / 3;
        sum.red.pixels_58_59_60                    <= (rgb_9x9.red.k58 + rgb_9x9.red.k59  + rgb_9x9.red.k60) / 3;
        sum.red.pixels_61_62_63                    <= (rgb_9x9.red.k61 + rgb_9x9.red.k62  + rgb_9x9.red.k63) / 3;
        sum.red.pixels_64_65_66                    <= (rgb_9x9.red.k64 + rgb_9x9.red.k65  + rgb_9x9.red.k66) / 3;
        sum.red.pixels_67_68_69                    <= (rgb_9x9.red.k67 + rgb_9x9.red.k68  + rgb_9x9.red.k69) / 3;
        sum.red.pixels_70_71_72                    <= (rgb_9x9.red.k70 + rgb_9x9.red.k71  + rgb_9x9.red.k72) / 3;
        sum.red.pixels_73_74_75                    <= (rgb_9x9.red.k73 + rgb_9x9.red.k74  + rgb_9x9.red.k75) / 3;
        sum.red.pixels_76_77_78                    <= (rgb_9x9.red.k76 + rgb_9x9.red.k77  + rgb_9x9.red.k78) / 3;
        sum.red.pixels_79_80_81                    <= (rgb_9x9.red.k79 + rgb_9x9.red.k80  + rgb_9x9.red.k81) / 3;
        sum.red.pixels_01_02_03_04_05_06_07_08_09  <= (sum.red.pixels_01_02_03 + sum.red.pixels_04_05_06 + sum.red.pixels_07_08_09) / 3;
        sum.red.pixels_10_11_12_13_14_15_16_17_18  <= (sum.red.pixels_10_11_12 + sum.red.pixels_13_14_15 + sum.red.pixels_16_17_18) / 3;
        sum.red.pixels_19_20_21_22_23_24_25_26_27  <= (sum.red.pixels_19_20_21 + sum.red.pixels_22_23_24 + sum.red.pixels_25_26_27) / 3;
        sum.red.pixels_28_29_30_31_32_33_34_35_36  <= (sum.red.pixels_28_29_30 + sum.red.pixels_31_32_33 + sum.red.pixels_34_35_36) / 3;
        sum.red.pixels_37_38_39_40_41_42_43_44_45  <= (sum.red.pixels_37_38_39 + sum.red.pixels_40_41_42 + sum.red.pixels_43_44_45) / 3;
        sum.red.pixels_46_47_48_49_50_51_52_53_54  <= (sum.red.pixels_46_47_48 + sum.red.pixels_49_50_51 + sum.red.pixels_52_53_54) / 3;
        sum.red.pixels_55_56_57_58_59_60_61_62_63  <= (sum.red.pixels_55_56_57 + sum.red.pixels_58_59_60 + sum.red.pixels_61_62_63) / 3;
        sum.red.pixels_64_65_66_67_68_69_70_71_72  <= (sum.red.pixels_64_65_66 + sum.red.pixels_67_68_69 + sum.red.pixels_70_71_72) / 3;
        sum.red.pixels_73_74_75_76_77_78_79_80_81  <= (sum.red.pixels_73_74_75 + sum.red.pixels_76_77_78 + sum.red.pixels_79_80_81) / 3;
        sum.red.pixels_01_TO_27                    <= (sum.red.pixels_01_02_03_04_05_06_07_08_09 + sum.red.pixels_10_11_12_13_14_15_16_17_18 + sum.red.pixels_19_20_21_22_23_24_25_26_27)  / 3;
        sum.red.pixels_28_TO_54                    <= (sum.red.pixels_28_29_30_31_32_33_34_35_36 + sum.red.pixels_37_38_39_40_41_42_43_44_45 + sum.red.pixels_46_47_48_49_50_51_52_53_54)  / 3;
        sum.red.pixels_55_TO_81                    <= (sum.red.pixels_55_56_57_58_59_60_61_62_63 + sum.red.pixels_64_65_66_67_68_69_70_71_72 + sum.red.pixels_73_74_75_76_77_78_79_80_81)  / 3;
        sum.red.pixels_01_to_81                    <= (sum.red.pixels_01_TO_27 + sum.red.pixels_28_TO_54 + sum.red.pixels_55_TO_81) /3;
        --sum.red.pixels_10_11_12_13_14_15_16_17_18  <= (pix_9x9.red.k10*1 + pix_9x9.red.k11*1 + pix_9x9.red.k12*1 + pix_9x9.red.k13*1 + pix_9x9.red.k14*1 + pix_9x9.red.k15*1 + pix_9x9.red.k16*1 + pix_9x9.red.k17*1 + pix_9x9.red.k18*1) / 9;
        --sum.red.pixels_19_20_21_22_23_24_25_26_27  <= (pix_9x9.red.k19*1 + pix_9x9.red.k20*1 + pix_9x9.red.k21*1 + pix_9x9.red.k22*1 + pix_9x9.red.k23*1 + pix_9x9.red.k24*1 + pix_9x9.red.k25*1 + pix_9x9.red.k26*1 + pix_9x9.red.k27*1) / 9;
        --sum.red.pixels_28_29_30_31_32_33_34_35_36  <= (pix_9x9.red.k28*1 + pix_9x9.red.k29*1 + pix_9x9.red.k30*1 + pix_9x9.red.k31*1 + pix_9x9.red.k32*1 + pix_9x9.red.k33*1 + pix_9x9.red.k34*1 + pix_9x9.red.k35*1 + pix_9x9.red.k36*1) / 9;
        --sum.red.pixels_37_38_39_40_41_42_43_44_45  <= (pix_9x9.red.k37*1 + pix_9x9.red.k38*1 + pix_9x9.red.k39*1 + pix_9x9.red.k40*1 + pix_9x9.red.k41*1 + pix_9x9.red.k42*1 + pix_9x9.red.k43*1 + pix_9x9.red.k44*1 + pix_9x9.red.k45*1) / 9;
        --sum.red.pixels_46_47_48_49_50_51_52_53_54  <= (pix_9x9.red.k46*1 + pix_9x9.red.k47*1 + pix_9x9.red.k48*1 + pix_9x9.red.k49*1 + pix_9x9.red.k50*1 + pix_9x9.red.k51*1 + pix_9x9.red.k52*1 + pix_9x9.red.k53*1 + pix_9x9.red.k54*1) / 9;
        --sum.red.pixels_55_56_57_58_59_60_61_62_63  <= (pix_9x9.red.k55*1 + pix_9x9.red.k56*1 + pix_9x9.red.k57*1 + pix_9x9.red.k58*1 + pix_9x9.red.k59*1 + pix_9x9.red.k60*1 + pix_9x9.red.k61*1 + pix_9x9.red.k62*1 + pix_9x9.red.k63*1) / 9;
        --sum.red.pixels_64_65_66_67_68_69_70_71_72  <= (pix_9x9.red.k64*1 + pix_9x9.red.k65*1 + pix_9x9.red.k66*1 + pix_9x9.red.k67*1 + pix_9x9.red.k68*1 + pix_9x9.red.k69*1 + pix_9x9.red.k70*1 + pix_9x9.red.k71*1 + pix_9x9.red.k72*1) / 9;
        --sum.red.pixels_73_74_75_76_77_78_79_80_81  <= (pix_9x9.red.k73*1 + pix_9x9.red.k74*1 + pix_9x9.red.k75*1 + pix_9x9.red.k76*1 + pix_9x9.red.k77*1 + pix_9x9.red.k78*1 + pix_9x9.red.k79*1 + pix_9x9.red.k80*1 + pix_9x9.red.k81*1) / 9;
        --if(crd_s40.y=0)then
        --    sum.red.pixels_01_to_81                    <= (sum.red.pixels_01_02_03_04_05_06_07_08_09);
        --elsif(crd_s40.y=1)then
        --    sum.red.pixels_01_to_81                    <= (sum.red.pixels_01_02_03_04_05_06_07_08_09 + sum.red.pixels_10_11_12_13_14_15_16_17_18) /2;
        --elsif(crd_s40.y=2)then
        --    sum.red.pixels_01_to_81                    <= (sum.red.pixels_01_02_03_04_05_06_07_08_09 + sum.red.pixels_10_11_12_13_14_15_16_17_18 + sum.red.pixels_19_20_21_22_23_24_25_26_27) /3;
        --elsif(crd_s40.y=3)then
        --    sum.red.pixels_01_to_81                    <= (sum.red.pixels_01_02_03_04_05_06_07_08_09 + sum.red.pixels_10_11_12_13_14_15_16_17_18 + sum.red.pixels_19_20_21_22_23_24_25_26_27 + sum.red.pixels_28_29_30_31_32_33_34_35_36) /4;
        --elsif(crd_s40.y=4)then
        --    sum.red.pixels_01_to_81                    <= (sum.red.pixels_01_02_03_04_05_06_07_08_09 + sum.red.pixels_10_11_12_13_14_15_16_17_18 + sum.red.pixels_19_20_21_22_23_24_25_26_27 + sum.red.pixels_28_29_30_31_32_33_34_35_36 + sum.red.pixels_37_38_39_40_41_42_43_44_45) /5;
        --elsif(crd_s40.y=5)then
        --    sum.red.pixels_01_to_81                    <= (sum.red.pixels_01_02_03_04_05_06_07_08_09 + sum.red.pixels_10_11_12_13_14_15_16_17_18 + sum.red.pixels_19_20_21_22_23_24_25_26_27 + sum.red.pixels_28_29_30_31_32_33_34_35_36 + sum.red.pixels_37_38_39_40_41_42_43_44_45 + sum.red.pixels_46_47_48_49_50_51_52_53_54) /6;
        --elsif(crd_s40.y=6)then
        --    sum.red.pixels_01_to_81                    <= (sum.red.pixels_01_02_03_04_05_06_07_08_09 + sum.red.pixels_10_11_12_13_14_15_16_17_18 + sum.red.pixels_19_20_21_22_23_24_25_26_27 + sum.red.pixels_28_29_30_31_32_33_34_35_36 + sum.red.pixels_37_38_39_40_41_42_43_44_45 + sum.red.pixels_46_47_48_49_50_51_52_53_54 + sum.red.pixels_55_56_57_58_59_60_61_62_63) /7;
        --elsif(crd_s40.y=7)then
        --    sum.red.pixels_01_to_81                    <= (sum.red.pixels_01_02_03_04_05_06_07_08_09 + sum.red.pixels_10_11_12_13_14_15_16_17_18 + sum.red.pixels_19_20_21_22_23_24_25_26_27 + sum.red.pixels_28_29_30_31_32_33_34_35_36 + sum.red.pixels_37_38_39_40_41_42_43_44_45 + sum.red.pixels_46_47_48_49_50_51_52_53_54 + sum.red.pixels_55_56_57_58_59_60_61_62_63 + sum.red.pixels_64_65_66_67_68_69_70_71_72) /8;
        --else
        --    sum.red.pixels_01_to_81                    <= (sum.red.pixels_01_02_03_04_05_06_07_08_09 + sum.red.pixels_10_11_12_13_14_15_16_17_18 + sum.red.pixels_19_20_21_22_23_24_25_26_27 + sum.red.pixels_28_29_30_31_32_33_34_35_36 + sum.red.pixels_37_38_39_40_41_42_43_44_45 + sum.red.pixels_46_47_48_49_50_51_52_53_54 + sum.red.pixels_55_56_57_58_59_60_61_62_63 + sum.red.pixels_64_65_66_67_68_69_70_71_72 + sum.red.pixels_73_74_75_76_77_78_79_80_81) /9;
        --end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        --sum.green.pixels_01_02_03_3x3                <= (pix_9x9.green.k1  + pix_9x9.green.k2*2  + pix_9x9.green.k3) / 4;
        --sum.green.pixels_10_11_12_3x3                <= (pix_9x9.green.k10*2 + pix_9x9.green.k11*4 + pix_9x9.green.k12*2) / 8;
        --sum.green.pixels_19_20_21_3x3                <= (pix_9x9.green.k19 + pix_9x9.green.k20*2 + pix_9x9.green.k21) / 4;
        --sum.green.pixels_01                          <= (pix_9x9.green.k5);
        --sum.green.pixels_01_02                       <= (pix_9x9.green.k1*2  + pix_9x9.green.k2) / 3;
        ----if(crd_s40.y=0)then
        -- --   sum.green.pixels_01_to_21_3x3                <= (sum.green.pixels_01_02_03_3x3);
        ----elsif(crd_s40.y=1)then
        ----    sum.green.pixels_01_to_21_3x3                <= (sum.green.pixels_01_02_03_3x3 + sum.green.pixels_10_11_12_3x3) / 2;
        ----else
        --    sum.green.pixels_01_to_21_3x3                <= (sum.green.pixels_01_02_03_3x3 + sum.green.pixels_10_11_12_3x3 + sum.green.pixels_19_20_21_3x3) / 3;
        ----end if;
        sum.green.pixels_01_02_03                    <= (rgb_9x9.green.k1  + rgb_9x9.green.k2   + rgb_9x9.green.k3)  / 3;
        sum.green.pixels_04_05_06                    <= (rgb_9x9.green.k4  + rgb_9x9.green.k5   + rgb_9x9.green.k6)  / 3;
        sum.green.pixels_07_08_09                    <= (rgb_9x9.green.k7  + rgb_9x9.green.k8   + rgb_9x9.green.k9)  / 3;
        sum.green.pixels_10_11_12                    <= (rgb_9x9.green.k10 + rgb_9x9.green.k11  + rgb_9x9.green.k12) / 3;
        sum.green.pixels_13_14_15                    <= (rgb_9x9.green.k13 + rgb_9x9.green.k14  + rgb_9x9.green.k15) / 3;
        sum.green.pixels_16_17_18                    <= (rgb_9x9.green.k16 + rgb_9x9.green.k17  + rgb_9x9.green.k18) / 3;
        sum.green.pixels_19_20_21                    <= (rgb_9x9.green.k19 + rgb_9x9.green.k20  + rgb_9x9.green.k21) / 3;
        sum.green.pixels_22_23_24                    <= (rgb_9x9.green.k22 + rgb_9x9.green.k23  + rgb_9x9.green.k24) / 3;
        sum.green.pixels_25_26_27                    <= (rgb_9x9.green.k25 + rgb_9x9.green.k26  + rgb_9x9.green.k27) / 3;
        sum.green.pixels_28_29_30                    <= (rgb_9x9.green.k28 + rgb_9x9.green.k29  + rgb_9x9.green.k30) / 3;
        sum.green.pixels_31_32_33                    <= (rgb_9x9.green.k31 + rgb_9x9.green.k32  + rgb_9x9.green.k33) / 3;
        sum.green.pixels_34_35_36                    <= (rgb_9x9.green.k34 + rgb_9x9.green.k35  + rgb_9x9.green.k36) / 3;
        sum.green.pixels_37_38_39                    <= (rgb_9x9.green.k37 + rgb_9x9.green.k38  + rgb_9x9.green.k39) / 3;
        sum.green.pixels_40_41_42                    <= (rgb_9x9.green.k40 + rgb_9x9.green.k41  + rgb_9x9.green.k42) / 3;
        sum.green.pixels_43_44_45                    <= (rgb_9x9.green.k43 + rgb_9x9.green.k44  + rgb_9x9.green.k45) / 3;
        sum.green.pixels_46_47_48                    <= (rgb_9x9.green.k46 + rgb_9x9.green.k47  + rgb_9x9.green.k48) / 3;
        sum.green.pixels_49_50_51                    <= (rgb_9x9.green.k49 + rgb_9x9.green.k50  + rgb_9x9.green.k51) / 3;
        sum.green.pixels_52_53_54                    <= (rgb_9x9.green.k52 + rgb_9x9.green.k53  + rgb_9x9.green.k54) / 3;
        sum.green.pixels_55_56_57                    <= (rgb_9x9.green.k55 + rgb_9x9.green.k56  + rgb_9x9.green.k57) / 3;
        sum.green.pixels_58_59_60                    <= (rgb_9x9.green.k58 + rgb_9x9.green.k59  + rgb_9x9.green.k60) / 3;
        sum.green.pixels_61_62_63                    <= (rgb_9x9.green.k61 + rgb_9x9.green.k62  + rgb_9x9.green.k63) / 3;
        sum.green.pixels_64_65_66                    <= (rgb_9x9.green.k64 + rgb_9x9.green.k65  + rgb_9x9.green.k66) / 3;
        sum.green.pixels_67_68_69                    <= (rgb_9x9.green.k67 + rgb_9x9.green.k68  + rgb_9x9.green.k69) / 3;
        sum.green.pixels_70_71_72                    <= (rgb_9x9.green.k70 + rgb_9x9.green.k71  + rgb_9x9.green.k72) / 3;
        sum.green.pixels_73_74_75                    <= (rgb_9x9.green.k73 + rgb_9x9.green.k74  + rgb_9x9.green.k75) / 3;
        sum.green.pixels_76_77_78                    <= (rgb_9x9.green.k76 + rgb_9x9.green.k77  + rgb_9x9.green.k78) / 3;
        sum.green.pixels_79_80_81                    <= (rgb_9x9.green.k79 + rgb_9x9.green.k80  + rgb_9x9.green.k81) / 3;
        sum.green.pixels_01_02_03_04_05_06_07_08_09  <= (sum.green.pixels_01_02_03 + sum.green.pixels_04_05_06 + sum.green.pixels_07_08_09) / 3;
        sum.green.pixels_10_11_12_13_14_15_16_17_18  <= (sum.green.pixels_10_11_12 + sum.green.pixels_13_14_15 + sum.green.pixels_16_17_18) / 3;
        sum.green.pixels_19_20_21_22_23_24_25_26_27  <= (sum.green.pixels_19_20_21 + sum.green.pixels_22_23_24 + sum.green.pixels_25_26_27) / 3;
        sum.green.pixels_28_29_30_31_32_33_34_35_36  <= (sum.green.pixels_28_29_30 + sum.green.pixels_31_32_33 + sum.green.pixels_34_35_36) / 3;
        sum.green.pixels_37_38_39_40_41_42_43_44_45  <= (sum.green.pixels_37_38_39 + sum.green.pixels_40_41_42 + sum.green.pixels_43_44_45) / 3;
        sum.green.pixels_46_47_48_49_50_51_52_53_54  <= (sum.green.pixels_46_47_48 + sum.green.pixels_49_50_51 + sum.green.pixels_52_53_54) / 3;
        sum.green.pixels_55_56_57_58_59_60_61_62_63  <= (sum.green.pixels_55_56_57 + sum.green.pixels_58_59_60 + sum.green.pixels_61_62_63) / 3;
        sum.green.pixels_64_65_66_67_68_69_70_71_72  <= (sum.green.pixels_64_65_66 + sum.green.pixels_67_68_69 + sum.green.pixels_70_71_72) / 3;
        sum.green.pixels_73_74_75_76_77_78_79_80_81  <= (sum.green.pixels_73_74_75 + sum.green.pixels_76_77_78 + sum.green.pixels_79_80_81) / 3;
        sum.green.pixels_01_TO_27                    <= (sum.green.pixels_01_02_03_04_05_06_07_08_09 + sum.green.pixels_10_11_12_13_14_15_16_17_18 + sum.green.pixels_19_20_21_22_23_24_25_26_27)  / 3;
        sum.green.pixels_28_TO_54                    <= (sum.green.pixels_28_29_30_31_32_33_34_35_36 + sum.green.pixels_37_38_39_40_41_42_43_44_45 + sum.green.pixels_46_47_48_49_50_51_52_53_54)  / 3;
        sum.green.pixels_55_TO_81                    <= (sum.green.pixels_55_56_57_58_59_60_61_62_63 + sum.green.pixels_64_65_66_67_68_69_70_71_72 + sum.green.pixels_73_74_75_76_77_78_79_80_81)  / 3;
        sum.green.pixels_01_to_81                    <= (sum.green.pixels_01_TO_27 + sum.green.pixels_28_TO_54 + sum.green.pixels_55_TO_81) /3;
        --sum.green.pixels_01_02_03_04_05_06_07_08_09  <= (pix_9x9.green.k1 *1 + pix_9x9.green.k2 *1 + pix_9x9.green.k3 *1 + pix_9x9.green.k4 *1 + pix_9x9.green.k5 *1 + pix_9x9.green.k6 *1 + pix_9x9.green.k7 *1 + pix_9x9.green.k8 *1 + pix_9x9.green.k9 *1) / 9;
        --sum.green.pixels_10_11_12_13_14_15_16_17_18  <= (pix_9x9.green.k10*1 + pix_9x9.green.k11*1 + pix_9x9.green.k12*1 + pix_9x9.green.k13*1 + pix_9x9.green.k14*1 + pix_9x9.green.k15*1 + pix_9x9.green.k16*1 + pix_9x9.green.k17*1 + pix_9x9.green.k18*1) / 9;
        --sum.green.pixels_19_20_21_22_23_24_25_26_27  <= (pix_9x9.green.k19*1 + pix_9x9.green.k20*1 + pix_9x9.green.k21*1 + pix_9x9.green.k22*1 + pix_9x9.green.k23*1 + pix_9x9.green.k24*1 + pix_9x9.green.k25*1 + pix_9x9.green.k26*1 + pix_9x9.green.k27*1) / 9;
        --sum.green.pixels_28_29_30_31_32_33_34_35_36  <= (pix_9x9.green.k28*1 + pix_9x9.green.k29*1 + pix_9x9.green.k30*1 + pix_9x9.green.k31*1 + pix_9x9.green.k32*1 + pix_9x9.green.k33*1 + pix_9x9.green.k34*1 + pix_9x9.green.k35*1 + pix_9x9.green.k36*1) / 9;
        --sum.green.pixels_37_38_39_40_41_42_43_44_45  <= (pix_9x9.green.k37*1 + pix_9x9.green.k38*1 + pix_9x9.green.k39*1 + pix_9x9.green.k40*1 + pix_9x9.green.k41*1 + pix_9x9.green.k42*1 + pix_9x9.green.k43*1 + pix_9x9.green.k44*1 + pix_9x9.green.k45*1) / 9;
        --sum.green.pixels_46_47_48_49_50_51_52_53_54  <= (pix_9x9.green.k46*1 + pix_9x9.green.k47*1 + pix_9x9.green.k48*1 + pix_9x9.green.k49*1 + pix_9x9.green.k50*1 + pix_9x9.green.k51*1 + pix_9x9.green.k52*1 + pix_9x9.green.k53*1 + pix_9x9.green.k54*1) / 9;
        --sum.green.pixels_55_56_57_58_59_60_61_62_63  <= (pix_9x9.green.k55*1 + pix_9x9.green.k56*1 + pix_9x9.green.k57*1 + pix_9x9.green.k58*1 + pix_9x9.green.k59*1 + pix_9x9.green.k60*1 + pix_9x9.green.k61*1 + pix_9x9.green.k62*1 + pix_9x9.green.k63*1) / 9;
        --sum.green.pixels_64_65_66_67_68_69_70_71_72  <= (pix_9x9.green.k64*1 + pix_9x9.green.k65*1 + pix_9x9.green.k66*1 + pix_9x9.green.k67*1 + pix_9x9.green.k68*1 + pix_9x9.green.k69*1 + pix_9x9.green.k70*1 + pix_9x9.green.k71*1 + pix_9x9.green.k72*1) / 9;
        --sum.green.pixels_73_74_75_76_77_78_79_80_81  <= (pix_9x9.green.k73*1 + pix_9x9.green.k74*1 + pix_9x9.green.k75*1 + pix_9x9.green.k76*1 + pix_9x9.green.k77*1 + pix_9x9.green.k78*1 + pix_9x9.green.k79*1 + pix_9x9.green.k80*1 + pix_9x9.green.k81*1) / 9;
        --if(crd_s40.y=0)then
        --    sum.green.pixels_01_to_81                    <= (sum.green.pixels_01_02_03_04_05_06_07_08_09);
        --elsif(crd_s40.y=1)then
        --    sum.green.pixels_01_to_81                    <= (sum.green.pixels_01_02_03_04_05_06_07_08_09 + sum.green.pixels_10_11_12_13_14_15_16_17_18) /2;
        --elsif(crd_s40.y=2)then
        --    sum.green.pixels_01_to_81                    <= (sum.green.pixels_01_02_03_04_05_06_07_08_09 + sum.green.pixels_10_11_12_13_14_15_16_17_18 + sum.green.pixels_19_20_21_22_23_24_25_26_27) /3;
        --elsif(crd_s40.y=3)then
        --    sum.green.pixels_01_to_81                    <= (sum.green.pixels_01_02_03_04_05_06_07_08_09 + sum.green.pixels_10_11_12_13_14_15_16_17_18 + sum.green.pixels_19_20_21_22_23_24_25_26_27 + sum.green.pixels_28_29_30_31_32_33_34_35_36) /4;
        --elsif(crd_s40.y=4)then
        --    sum.green.pixels_01_to_81                    <= (sum.green.pixels_01_02_03_04_05_06_07_08_09 + sum.green.pixels_10_11_12_13_14_15_16_17_18 + sum.green.pixels_19_20_21_22_23_24_25_26_27 + sum.green.pixels_28_29_30_31_32_33_34_35_36 + sum.green.pixels_37_38_39_40_41_42_43_44_45) /5;
        --elsif(crd_s40.y=5)then
        --    sum.green.pixels_01_to_81                    <= (sum.green.pixels_01_02_03_04_05_06_07_08_09 + sum.green.pixels_10_11_12_13_14_15_16_17_18 + sum.green.pixels_19_20_21_22_23_24_25_26_27 + sum.green.pixels_28_29_30_31_32_33_34_35_36 + sum.green.pixels_37_38_39_40_41_42_43_44_45 + sum.green.pixels_46_47_48_49_50_51_52_53_54) /6;
        --elsif(crd_s40.y=6)then
        --    sum.green.pixels_01_to_81                    <= (sum.green.pixels_01_02_03_04_05_06_07_08_09 + sum.green.pixels_10_11_12_13_14_15_16_17_18 + sum.green.pixels_19_20_21_22_23_24_25_26_27 + sum.green.pixels_28_29_30_31_32_33_34_35_36 + sum.green.pixels_37_38_39_40_41_42_43_44_45 + sum.green.pixels_46_47_48_49_50_51_52_53_54 + sum.green.pixels_55_56_57_58_59_60_61_62_63) /7;
        --elsif(crd_s40.y=7)then
        --    sum.green.pixels_01_to_81                    <= (sum.green.pixels_01_02_03_04_05_06_07_08_09 + sum.green.pixels_10_11_12_13_14_15_16_17_18 + sum.green.pixels_19_20_21_22_23_24_25_26_27 + sum.green.pixels_28_29_30_31_32_33_34_35_36 + sum.green.pixels_37_38_39_40_41_42_43_44_45 + sum.green.pixels_46_47_48_49_50_51_52_53_54 + sum.green.pixels_55_56_57_58_59_60_61_62_63 + sum.green.pixels_64_65_66_67_68_69_70_71_72) /8;
        --else
        -- sum.green.pixels_01_to_81                    <= (sum.green.pixels_01_02_03_04_05_06_07_08_09 + sum.green.pixels_10_11_12_13_14_15_16_17_18 + sum.green.pixels_19_20_21_22_23_24_25_26_27 + sum.green.pixels_28_29_30_31_32_33_34_35_36 + sum.green.pixels_37_38_39_40_41_42_43_44_45 + sum.green.pixels_46_47_48_49_50_51_52_53_54 + sum.green.pixels_55_56_57_58_59_60_61_62_63 + sum.green.pixels_64_65_66_67_68_69_70_71_72 + sum.green.pixels_73_74_75_76_77_78_79_80_81) /9;
       --end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        --sum.blue.pixels_01_02_03_3x3                <= (pix_9x9.blue.k1  + pix_9x9.blue.k2*2  + pix_9x9.blue.k3) / 4;
        --sum.blue.pixels_10_11_12_3x3                <= (pix_9x9.blue.k10*2 + pix_9x9.blue.k11*4 + pix_9x9.blue.k12*2) / 8;
        --sum.blue.pixels_19_20_21_3x3                <= (pix_9x9.blue.k19 + pix_9x9.blue.k20*2 + pix_9x9.blue.k21) / 4;
        --sum.blue.pixels_01                          <= (pix_9x9.blue.k5);
        --sum.blue.pixels_01_02                       <= (pix_9x9.blue.k1*2  + pix_9x9.blue.k2) / 3;
        --if(crd_s40.y=0)then
        --    sum.blue.pixels_01_to_21_3x3                <= (sum.blue.pixels_01_02_03_3x3);
        --elsif(crd_s40.y=1)then
        --    sum.blue.pixels_01_to_21_3x3                <= (sum.blue.pixels_01_02_03_3x3 + sum.blue.pixels_10_11_12_3x3) / 2;
        --else
        --    sum.blue.pixels_01_to_21_3x3                <= (sum.blue.pixels_01_02_03_3x3 + sum.blue.pixels_10_11_12_3x3 + sum.blue.pixels_19_20_21_3x3) / 3;
        --end if;
        sum.blue.pixels_01_02_03                    <= (rgb_9x9.blue.k1  + rgb_9x9.blue.k2   + rgb_9x9.blue.k3)  / 3;
        sum.blue.pixels_04_05_06                    <= (rgb_9x9.blue.k4  + rgb_9x9.blue.k5   + rgb_9x9.blue.k6)  / 3;
        sum.blue.pixels_07_08_09                    <= (rgb_9x9.blue.k7  + rgb_9x9.blue.k8   + rgb_9x9.blue.k9)  / 3;
        sum.blue.pixels_10_11_12                    <= (rgb_9x9.blue.k10 + rgb_9x9.blue.k11  + rgb_9x9.blue.k12) / 3;
        sum.blue.pixels_13_14_15                    <= (rgb_9x9.blue.k13 + rgb_9x9.blue.k14  + rgb_9x9.blue.k15) / 3;
        sum.blue.pixels_16_17_18                    <= (rgb_9x9.blue.k16 + rgb_9x9.blue.k17  + rgb_9x9.blue.k18) / 3;
        sum.blue.pixels_19_20_21                    <= (rgb_9x9.blue.k19 + rgb_9x9.blue.k20  + rgb_9x9.blue.k21) / 3;
        sum.blue.pixels_22_23_24                    <= (rgb_9x9.blue.k22 + rgb_9x9.blue.k23  + rgb_9x9.blue.k24) / 3;
        sum.blue.pixels_25_26_27                    <= (rgb_9x9.blue.k25 + rgb_9x9.blue.k26  + rgb_9x9.blue.k27) / 3;
        sum.blue.pixels_28_29_30                    <= (rgb_9x9.blue.k28 + rgb_9x9.blue.k29  + rgb_9x9.blue.k30) / 3;
        sum.blue.pixels_31_32_33                    <= (rgb_9x9.blue.k31 + rgb_9x9.blue.k32  + rgb_9x9.blue.k33) / 3;
        sum.blue.pixels_34_35_36                    <= (rgb_9x9.blue.k34 + rgb_9x9.blue.k35  + rgb_9x9.blue.k36) / 3;
        sum.blue.pixels_37_38_39                    <= (rgb_9x9.blue.k37 + rgb_9x9.blue.k38  + rgb_9x9.blue.k39) / 3;
        sum.blue.pixels_40_41_42                    <= (rgb_9x9.blue.k40 + rgb_9x9.blue.k41  + rgb_9x9.blue.k42) / 3;
        sum.blue.pixels_43_44_45                    <= (rgb_9x9.blue.k43 + rgb_9x9.blue.k44  + rgb_9x9.blue.k45) / 3;
        sum.blue.pixels_46_47_48                    <= (rgb_9x9.blue.k46 + rgb_9x9.blue.k47  + rgb_9x9.blue.k48) / 3;
        sum.blue.pixels_49_50_51                    <= (rgb_9x9.blue.k49 + rgb_9x9.blue.k50  + rgb_9x9.blue.k51) / 3;
        sum.blue.pixels_52_53_54                    <= (rgb_9x9.blue.k52 + rgb_9x9.blue.k53  + rgb_9x9.blue.k54) / 3;
        sum.blue.pixels_55_56_57                    <= (rgb_9x9.blue.k55 + rgb_9x9.blue.k56  + rgb_9x9.blue.k57) / 3;
        sum.blue.pixels_58_59_60                    <= (rgb_9x9.blue.k58 + rgb_9x9.blue.k59  + rgb_9x9.blue.k60) / 3;
        sum.blue.pixels_61_62_63                    <= (rgb_9x9.blue.k61 + rgb_9x9.blue.k62  + rgb_9x9.blue.k63) / 3;
        sum.blue.pixels_64_65_66                    <= (rgb_9x9.blue.k64 + rgb_9x9.blue.k65  + rgb_9x9.blue.k66) / 3;
        sum.blue.pixels_67_68_69                    <= (rgb_9x9.blue.k67 + rgb_9x9.blue.k68  + rgb_9x9.blue.k69) / 3;
        sum.blue.pixels_70_71_72                    <= (rgb_9x9.blue.k70 + rgb_9x9.blue.k71  + rgb_9x9.blue.k72) / 3;
        sum.blue.pixels_73_74_75                    <= (rgb_9x9.blue.k73 + rgb_9x9.blue.k74  + rgb_9x9.blue.k75) / 3;
        sum.blue.pixels_76_77_78                    <= (rgb_9x9.blue.k76 + rgb_9x9.blue.k77  + rgb_9x9.blue.k78) / 3;
        sum.blue.pixels_79_80_81                    <= (rgb_9x9.blue.k79 + rgb_9x9.blue.k80  + rgb_9x9.blue.k81) / 3;
        sum.blue.pixels_01_02_03_04_05_06_07_08_09  <= (sum.blue.pixels_01_02_03 + sum.blue.pixels_04_05_06 + sum.blue.pixels_07_08_09) / 3;
        sum.blue.pixels_10_11_12_13_14_15_16_17_18  <= (sum.blue.pixels_10_11_12 + sum.blue.pixels_13_14_15 + sum.blue.pixels_16_17_18) / 3;
        sum.blue.pixels_19_20_21_22_23_24_25_26_27  <= (sum.blue.pixels_19_20_21 + sum.blue.pixels_22_23_24 + sum.blue.pixels_25_26_27) / 3;
        sum.blue.pixels_28_29_30_31_32_33_34_35_36  <= (sum.blue.pixels_28_29_30 + sum.blue.pixels_31_32_33 + sum.blue.pixels_34_35_36) / 3;
        sum.blue.pixels_37_38_39_40_41_42_43_44_45  <= (sum.blue.pixels_37_38_39 + sum.blue.pixels_40_41_42 + sum.blue.pixels_43_44_45) / 3;
        sum.blue.pixels_46_47_48_49_50_51_52_53_54  <= (sum.blue.pixels_46_47_48 + sum.blue.pixels_49_50_51 + sum.blue.pixels_52_53_54) / 3;
        sum.blue.pixels_55_56_57_58_59_60_61_62_63  <= (sum.blue.pixels_55_56_57 + sum.blue.pixels_58_59_60 + sum.blue.pixels_61_62_63) / 3;
        sum.blue.pixels_64_65_66_67_68_69_70_71_72  <= (sum.blue.pixels_64_65_66 + sum.blue.pixels_67_68_69 + sum.blue.pixels_70_71_72) / 3;
        sum.blue.pixels_73_74_75_76_77_78_79_80_81  <= (sum.blue.pixels_73_74_75 + sum.blue.pixels_76_77_78 + sum.blue.pixels_79_80_81) / 3;
        sum.blue.pixels_01_TO_27                    <= (sum.blue.pixels_01_02_03_04_05_06_07_08_09 + sum.blue.pixels_10_11_12_13_14_15_16_17_18 + sum.blue.pixels_19_20_21_22_23_24_25_26_27)  / 3;
        sum.blue.pixels_28_TO_54                    <= (sum.blue.pixels_28_29_30_31_32_33_34_35_36 + sum.blue.pixels_37_38_39_40_41_42_43_44_45 + sum.blue.pixels_46_47_48_49_50_51_52_53_54)  / 3;
        sum.blue.pixels_55_TO_81                    <= (sum.blue.pixels_55_56_57_58_59_60_61_62_63 + sum.blue.pixels_64_65_66_67_68_69_70_71_72 + sum.blue.pixels_73_74_75_76_77_78_79_80_81)  / 3;
        sum.blue.pixels_01_to_81                    <= (sum.blue.pixels_01_TO_27 + sum.blue.pixels_28_TO_54 + sum.blue.pixels_55_TO_81) /3;
        --sum.blue.pixels_01_02_03_04_05_06_07_08_09  <= (pix_9x9.blue.k1 *1 + pix_9x9.blue.k2 *1 + pix_9x9.blue.k3 *1 + pix_9x9.blue.k4 *1 + pix_9x9.blue.k5 *1 + pix_9x9.blue.k6 *1 + pix_9x9.blue.k7 *1 + pix_9x9.blue.k8 *1 + pix_9x9.blue.k9 *1) / 9;
        --sum.blue.pixels_10_11_12_13_14_15_16_17_18  <= (pix_9x9.blue.k10*1 + pix_9x9.blue.k11*1 + pix_9x9.blue.k12*1 + pix_9x9.blue.k13*1 + pix_9x9.blue.k14*1 + pix_9x9.blue.k15*1 + pix_9x9.blue.k16*1 + pix_9x9.blue.k17*1 + pix_9x9.blue.k18*1) / 9;
        --sum.blue.pixels_19_20_21_22_23_24_25_26_27  <= (pix_9x9.blue.k19*1 + pix_9x9.blue.k20*1 + pix_9x9.blue.k21*1 + pix_9x9.blue.k22*1 + pix_9x9.blue.k23*1 + pix_9x9.blue.k24*1 + pix_9x9.blue.k25*1 + pix_9x9.blue.k26*1 + pix_9x9.blue.k27*1) / 9;
        --sum.blue.pixels_28_29_30_31_32_33_34_35_36  <= (pix_9x9.blue.k28*1 + pix_9x9.blue.k29*1 + pix_9x9.blue.k30*1 + pix_9x9.blue.k31*1 + pix_9x9.blue.k32*1 + pix_9x9.blue.k33*1 + pix_9x9.blue.k34*1 + pix_9x9.blue.k35*1 + pix_9x9.blue.k36*1) / 9;
        --sum.blue.pixels_37_38_39_40_41_42_43_44_45  <= (pix_9x9.blue.k37*1 + pix_9x9.blue.k38*1 + pix_9x9.blue.k39*1 + pix_9x9.blue.k40*1 + pix_9x9.blue.k41*1 + pix_9x9.blue.k42*1 + pix_9x9.blue.k43*1 + pix_9x9.blue.k44*1 + pix_9x9.blue.k45*1) / 9;
        --sum.blue.pixels_46_47_48_49_50_51_52_53_54  <= (pix_9x9.blue.k46*1 + pix_9x9.blue.k47*1 + pix_9x9.blue.k48*1 + pix_9x9.blue.k49*1 + pix_9x9.blue.k50*1 + pix_9x9.blue.k51*1 + pix_9x9.blue.k52*1 + pix_9x9.blue.k53*1 + pix_9x9.blue.k54*1) / 9;
        --sum.blue.pixels_55_56_57_58_59_60_61_62_63  <= (pix_9x9.blue.k55*1 + pix_9x9.blue.k56*1 + pix_9x9.blue.k57*1 + pix_9x9.blue.k58*1 + pix_9x9.blue.k59*1 + pix_9x9.blue.k60*1 + pix_9x9.blue.k61*1 + pix_9x9.blue.k62*1 + pix_9x9.blue.k63*1) / 9;
        --sum.blue.pixels_64_65_66_67_68_69_70_71_72  <= (pix_9x9.blue.k64*1 + pix_9x9.blue.k65*1 + pix_9x9.blue.k66*1 + pix_9x9.blue.k67*1 + pix_9x9.blue.k68*1 + pix_9x9.blue.k69*1 + pix_9x9.blue.k70*1 + pix_9x9.blue.k71*1 + pix_9x9.blue.k72*1) / 9;
        --sum.blue.pixels_73_74_75_76_77_78_79_80_81  <= (pix_9x9.blue.k73*1 + pix_9x9.blue.k74*1 + pix_9x9.blue.k75*1 + pix_9x9.blue.k76*1 + pix_9x9.blue.k77*1 + pix_9x9.blue.k78*1 + pix_9x9.blue.k79*1 + pix_9x9.blue.k80*1 + pix_9x9.blue.k81*1) / 9;
        --if(crd_s40.y=0)then
        --    sum.blue.pixels_01_to_81                    <= (sum.blue.pixels_01_02_03_04_05_06_07_08_09);
        --elsif(crd_s40.y=1)then
        --    sum.blue.pixels_01_to_81                    <= (sum.blue.pixels_01_02_03_04_05_06_07_08_09 + sum.blue.pixels_10_11_12_13_14_15_16_17_18) /2;
        --elsif(crd_s40.y=2)then
        --    sum.blue.pixels_01_to_81                    <= (sum.blue.pixels_01_02_03_04_05_06_07_08_09 + sum.blue.pixels_10_11_12_13_14_15_16_17_18 + sum.blue.pixels_19_20_21_22_23_24_25_26_27) /3;
        --elsif(crd_s40.y=3)then
        --    sum.blue.pixels_01_to_81                    <= (sum.blue.pixels_01_02_03_04_05_06_07_08_09 + sum.blue.pixels_10_11_12_13_14_15_16_17_18 + sum.blue.pixels_19_20_21_22_23_24_25_26_27 + sum.blue.pixels_28_29_30_31_32_33_34_35_36) /4;
        --elsif(crd_s40.y=4)then
        --    sum.blue.pixels_01_to_81                    <= (sum.blue.pixels_01_02_03_04_05_06_07_08_09 + sum.blue.pixels_10_11_12_13_14_15_16_17_18 + sum.blue.pixels_19_20_21_22_23_24_25_26_27 + sum.blue.pixels_28_29_30_31_32_33_34_35_36 + sum.blue.pixels_37_38_39_40_41_42_43_44_45) /5;
        --elsif(crd_s40.y=5)then
        --    sum.blue.pixels_01_to_81                    <= (sum.blue.pixels_01_02_03_04_05_06_07_08_09 + sum.blue.pixels_10_11_12_13_14_15_16_17_18 + sum.blue.pixels_19_20_21_22_23_24_25_26_27 + sum.blue.pixels_28_29_30_31_32_33_34_35_36 + sum.blue.pixels_37_38_39_40_41_42_43_44_45 + sum.blue.pixels_46_47_48_49_50_51_52_53_54) /6;
        --elsif(crd_s40.y=6)then
        --    sum.blue.pixels_01_to_81                    <= (sum.blue.pixels_01_02_03_04_05_06_07_08_09 + sum.blue.pixels_10_11_12_13_14_15_16_17_18 + sum.blue.pixels_19_20_21_22_23_24_25_26_27 + sum.blue.pixels_28_29_30_31_32_33_34_35_36 + sum.blue.pixels_37_38_39_40_41_42_43_44_45 + sum.blue.pixels_46_47_48_49_50_51_52_53_54 + sum.blue.pixels_55_56_57_58_59_60_61_62_63) /7;
        --elsif(crd_s40.y=7)then
        --    sum.blue.pixels_01_to_81                    <= (sum.blue.pixels_01_02_03_04_05_06_07_08_09 + sum.blue.pixels_10_11_12_13_14_15_16_17_18 + sum.blue.pixels_19_20_21_22_23_24_25_26_27 + sum.blue.pixels_28_29_30_31_32_33_34_35_36 + sum.blue.pixels_37_38_39_40_41_42_43_44_45 + sum.blue.pixels_46_47_48_49_50_51_52_53_54 + sum.blue.pixels_55_56_57_58_59_60_61_62_63 + sum.blue.pixels_64_65_66_67_68_69_70_71_72) /8;
        --else
        --  sum.blue.pixels_01_to_81                    <= (sum.blue.pixels_01_02_03_04_05_06_07_08_09 + sum.blue.pixels_10_11_12_13_14_15_16_17_18 + sum.blue.pixels_19_20_21_22_23_24_25_26_27 + sum.blue.pixels_28_29_30_31_32_33_34_35_36 + sum.blue.pixels_37_38_39_40_41_42_43_44_45 + sum.blue.pixels_46_47_48_49_50_51_52_53_54 + sum.blue.pixels_55_56_57_58_59_60_61_62_63 + sum.blue.pixels_64_65_66_67_68_69_70_71_72 + sum.blue.pixels_73_74_75_76_77_78_79_80_81) /9;
        --end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
      if( rgb_9x9_detect.filter_size_9x9.red.k(1).n   =1  and
     rgb_9x9_detect.filter_size_9x9.red.k(2).n   =2  and
     rgb_9x9_detect.filter_size_9x9.red.k(3).n   =3  and
     rgb_9x9_detect.filter_size_9x9.red.k(4).n   =4  and
     rgb_9x9_detect.filter_size_9x9.red.k(5).n   =5  and
     rgb_9x9_detect.filter_size_9x9.red.k(6).n   =6  and
     rgb_9x9_detect.filter_size_9x9.red.k(7).n   =7  and
     rgb_9x9_detect.filter_size_9x9.red.k(8).n   =8  and
     rgb_9x9_detect.filter_size_9x9.red.k(9).n   =9  and
     rgb_9x9_detect.filter_size_9x9.red.k(10).n  =10  and
     rgb_9x9_detect.filter_size_9x9.red.k(11).n  =11  and
     rgb_9x9_detect.filter_size_9x9.red.k(12).n  =12  and
     rgb_9x9_detect.filter_size_9x9.red.k(13).n  =13  and
     rgb_9x9_detect.filter_size_9x9.red.k(14).n  =14  and
     rgb_9x9_detect.filter_size_9x9.red.k(15).n  =15  and
     rgb_9x9_detect.filter_size_9x9.red.k(16).n  =16  and
     rgb_9x9_detect.filter_size_9x9.red.k(17).n  =17  and
     rgb_9x9_detect.filter_size_9x9.red.k(18).n  =18  and
     rgb_9x9_detect.filter_size_9x9.red.k(19).n  =19  and
     rgb_9x9_detect.filter_size_9x9.red.k(20).n  =20  and
     rgb_9x9_detect.filter_size_9x9.red.k(21).n  =21  and
     rgb_9x9_detect.filter_size_9x9.red.k(22).n  =22  and
     rgb_9x9_detect.filter_size_9x9.red.k(23).n  =23  and
     rgb_9x9_detect.filter_size_9x9.red.k(24).n  =24  and
     rgb_9x9_detect.filter_size_9x9.red.k(25).n  =25  and
     rgb_9x9_detect.filter_size_9x9.red.k(26).n  =26  and
     rgb_9x9_detect.filter_size_9x9.red.k(27).n  =27  and
     rgb_9x9_detect.filter_size_9x9.red.k(28).n  =28  and
     rgb_9x9_detect.filter_size_9x9.red.k(29).n  =29  and
     rgb_9x9_detect.filter_size_9x9.red.k(30).n  =30  and
     rgb_9x9_detect.filter_size_9x9.red.k(31).n  =31  and
     rgb_9x9_detect.filter_size_9x9.red.k(32).n  =32  and
     rgb_9x9_detect.filter_size_9x9.red.k(33).n  =33  and
     rgb_9x9_detect.filter_size_9x9.red.k(34).n  =34  and
     rgb_9x9_detect.filter_size_9x9.red.k(35).n  =35  and
     rgb_9x9_detect.filter_size_9x9.red.k(36).n  =36  and
     rgb_9x9_detect.filter_size_9x9.red.k(37).n  =37  and
     rgb_9x9_detect.filter_size_9x9.red.k(38).n  =38  and
     rgb_9x9_detect.filter_size_9x9.red.k(39).n  =39  and
     rgb_9x9_detect.filter_size_9x9.red.k(40).n  =40  and
     rgb_9x9_detect.filter_size_9x9.red.k(41).n  =41  and
     rgb_9x9_detect.filter_size_9x9.red.k(42).n  =42  and
     rgb_9x9_detect.filter_size_9x9.red.k(43).n  =43  and
     rgb_9x9_detect.filter_size_9x9.red.k(44).n  =44  and
     rgb_9x9_detect.filter_size_9x9.red.k(45).n  =45  and
     rgb_9x9_detect.filter_size_9x9.red.k(46).n  =46  and
     rgb_9x9_detect.filter_size_9x9.red.k(47).n  =47  and
     rgb_9x9_detect.filter_size_9x9.red.k(48).n  =48  and
     rgb_9x9_detect.filter_size_9x9.red.k(49).n  =49  and
     rgb_9x9_detect.filter_size_9x9.red.k(50).n  =50  and
     rgb_9x9_detect.filter_size_9x9.red.k(51).n  =51  and
     rgb_9x9_detect.filter_size_9x9.red.k(52).n  =52  and
     rgb_9x9_detect.filter_size_9x9.red.k(53).n  =53  and
     rgb_9x9_detect.filter_size_9x9.red.k(54).n  =54  and
     rgb_9x9_detect.filter_size_9x9.red.k(55).n  =55  and
     rgb_9x9_detect.filter_size_9x9.red.k(56).n  =56  and
     rgb_9x9_detect.filter_size_9x9.red.k(57).n  =57  and
     rgb_9x9_detect.filter_size_9x9.red.k(58).n  =58  and
     rgb_9x9_detect.filter_size_9x9.red.k(59).n  =59  and
     rgb_9x9_detect.filter_size_9x9.red.k(60).n  =60  and
     rgb_9x9_detect.filter_size_9x9.red.k(61).n  =61  and
     rgb_9x9_detect.filter_size_9x9.red.k(62).n  =62  and
     rgb_9x9_detect.filter_size_9x9.red.k(63).n  =63  and
     rgb_9x9_detect.filter_size_9x9.red.k(64).n  =64  and
     rgb_9x9_detect.filter_size_9x9.red.k(65).n  =65  and
     rgb_9x9_detect.filter_size_9x9.red.k(66).n  =66  and
     rgb_9x9_detect.filter_size_9x9.red.k(67).n  =67  and
     rgb_9x9_detect.filter_size_9x9.red.k(68).n  =68  and
     rgb_9x9_detect.filter_size_9x9.red.k(69).n  =69  and
     rgb_9x9_detect.filter_size_9x9.red.k(70).n  =70  and
     rgb_9x9_detect.filter_size_9x9.red.k(71).n  =71  and
     rgb_9x9_detect.filter_size_9x9.red.k(72).n  =72  and
     rgb_9x9_detect.filter_size_9x9.red.k(73).n  =73  and
     rgb_9x9_detect.filter_size_9x9.red.k(74).n  =74  and
     rgb_9x9_detect.filter_size_9x9.red.k(75).n  =75  and
     rgb_9x9_detect.filter_size_9x9.red.k(76).n  =76  and
     rgb_9x9_detect.filter_size_9x9.red.k(77).n  =77  and
     rgb_9x9_detect.filter_size_9x9.red.k(78).n  =78  and
     rgb_9x9_detect.filter_size_9x9.red.k(79).n  =79  and
     rgb_9x9_detect.filter_size_9x9.red.k(80).n  =80  and
     rgb_9x9_detect.filter_size_9x9.red.k(81).n  =81) then  
               pixels_1_81_enabled <= hi;
                sum.red.result      <= std_logic_vector(to_unsigned(sum.red.pixels_01_to_81, 10));
        --elsif (rgb_9x9_detect.filter_size_9x9.red.k(1).n=1 and  rgb_9x9_detect.filter_size_9x9.red.k(2).n=2 and rgb_9x9_detect.filter_size_9x9.red.k(3).n=3
        --   and rgb_9x9_detect.filter_size_9x9.red.k(10).n=10 and rgb_9x9_detect.filter_size_9x9.red.k(11).n=11 and rgb_9x9_detect.filter_size_9x9.red.k(12).n=12  
        --   and rgb_9x9_detect.filter_size_9x9.red.k(19).n=19 and rgb_9x9_detect.filter_size_9x9.red.k(20).n=20  and rgb_9x9_detect.filter_size_9x9.red.k(21).n=21) then
        --        sum.red.result      <= std_logic_vector(to_unsigned(sum.red.pixels_01_to_21_3x3, 10));
        else
                pixels_1_81_enabled <= lo;
                sum.red.result   <= Rgb3.red;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
      if( rgb_9x9_detect.filter_size_9x9.green.k(1).n   =1  and
          rgb_9x9_detect.filter_size_9x9.green.k(2).n   =2  and
          rgb_9x9_detect.filter_size_9x9.green.k(3).n   =3  and
          rgb_9x9_detect.filter_size_9x9.green.k(4).n   =4  and
          rgb_9x9_detect.filter_size_9x9.green.k(5).n   =5  and
          rgb_9x9_detect.filter_size_9x9.green.k(6).n   =6  and
          rgb_9x9_detect.filter_size_9x9.green.k(7).n   =7  and
          rgb_9x9_detect.filter_size_9x9.green.k(8).n   =8  and
          rgb_9x9_detect.filter_size_9x9.green.k(9).n   =9  and
          rgb_9x9_detect.filter_size_9x9.green.k(10).n  =10  and
          rgb_9x9_detect.filter_size_9x9.green.k(11).n  =11  and
          rgb_9x9_detect.filter_size_9x9.green.k(12).n  =12  and
          rgb_9x9_detect.filter_size_9x9.green.k(13).n  =13  and
          rgb_9x9_detect.filter_size_9x9.green.k(14).n  =14  and
          rgb_9x9_detect.filter_size_9x9.green.k(15).n  =15  and
          rgb_9x9_detect.filter_size_9x9.green.k(16).n  =16  and
          rgb_9x9_detect.filter_size_9x9.green.k(17).n  =17  and
          rgb_9x9_detect.filter_size_9x9.green.k(18).n  =18  and
          rgb_9x9_detect.filter_size_9x9.green.k(19).n  =19  and
          rgb_9x9_detect.filter_size_9x9.green.k(20).n  =20  and
          rgb_9x9_detect.filter_size_9x9.green.k(21).n  =21  and
          rgb_9x9_detect.filter_size_9x9.green.k(22).n  =22  and
          rgb_9x9_detect.filter_size_9x9.green.k(23).n  =23  and
          rgb_9x9_detect.filter_size_9x9.green.k(24).n  =24  and
          rgb_9x9_detect.filter_size_9x9.green.k(25).n  =25  and
          rgb_9x9_detect.filter_size_9x9.green.k(26).n  =26  and
          rgb_9x9_detect.filter_size_9x9.green.k(27).n  =27  and
          rgb_9x9_detect.filter_size_9x9.green.k(28).n  =28  and
          rgb_9x9_detect.filter_size_9x9.green.k(29).n  =29  and
          rgb_9x9_detect.filter_size_9x9.green.k(30).n  =30  and
          rgb_9x9_detect.filter_size_9x9.green.k(31).n  =31  and
          rgb_9x9_detect.filter_size_9x9.green.k(32).n  =32  and
          rgb_9x9_detect.filter_size_9x9.green.k(33).n  =33  and
          rgb_9x9_detect.filter_size_9x9.green.k(34).n  =34  and
          rgb_9x9_detect.filter_size_9x9.green.k(35).n  =35  and
          rgb_9x9_detect.filter_size_9x9.green.k(36).n  =36  and
          rgb_9x9_detect.filter_size_9x9.green.k(37).n  =37  and
          rgb_9x9_detect.filter_size_9x9.green.k(38).n  =38  and
          rgb_9x9_detect.filter_size_9x9.green.k(39).n  =39  and
          rgb_9x9_detect.filter_size_9x9.green.k(40).n  =40  and
          rgb_9x9_detect.filter_size_9x9.green.k(41).n  =41  and
          rgb_9x9_detect.filter_size_9x9.green.k(42).n  =42  and
          rgb_9x9_detect.filter_size_9x9.green.k(43).n  =43  and
          rgb_9x9_detect.filter_size_9x9.green.k(44).n  =44  and
          rgb_9x9_detect.filter_size_9x9.green.k(45).n  =45  and
          rgb_9x9_detect.filter_size_9x9.green.k(46).n  =46  and
          rgb_9x9_detect.filter_size_9x9.green.k(47).n  =47  and
          rgb_9x9_detect.filter_size_9x9.green.k(48).n  =48  and
          rgb_9x9_detect.filter_size_9x9.green.k(49).n  =49  and
          rgb_9x9_detect.filter_size_9x9.green.k(50).n  =50  and
          rgb_9x9_detect.filter_size_9x9.green.k(51).n  =51  and
          rgb_9x9_detect.filter_size_9x9.green.k(52).n  =52  and
          rgb_9x9_detect.filter_size_9x9.green.k(53).n  =53  and
          rgb_9x9_detect.filter_size_9x9.green.k(54).n  =54  and
          rgb_9x9_detect.filter_size_9x9.green.k(55).n  =55  and
          rgb_9x9_detect.filter_size_9x9.green.k(56).n  =56  and
          rgb_9x9_detect.filter_size_9x9.green.k(57).n  =57  and
          rgb_9x9_detect.filter_size_9x9.green.k(58).n  =58  and
          rgb_9x9_detect.filter_size_9x9.green.k(59).n  =59  and
          rgb_9x9_detect.filter_size_9x9.green.k(60).n  =60  and
          rgb_9x9_detect.filter_size_9x9.green.k(61).n  =61  and
          rgb_9x9_detect.filter_size_9x9.green.k(62).n  =62  and
          rgb_9x9_detect.filter_size_9x9.green.k(63).n  =63  and
          rgb_9x9_detect.filter_size_9x9.green.k(64).n  =64  and
          rgb_9x9_detect.filter_size_9x9.green.k(65).n  =65  and
          rgb_9x9_detect.filter_size_9x9.green.k(66).n  =66  and
          rgb_9x9_detect.filter_size_9x9.green.k(67).n  =67  and
          rgb_9x9_detect.filter_size_9x9.green.k(68).n  =68  and
          rgb_9x9_detect.filter_size_9x9.green.k(69).n  =69  and
          rgb_9x9_detect.filter_size_9x9.green.k(70).n  =70  and
          rgb_9x9_detect.filter_size_9x9.green.k(71).n  =71  and
          rgb_9x9_detect.filter_size_9x9.green.k(72).n  =72  and
          rgb_9x9_detect.filter_size_9x9.green.k(73).n  =73  and
          rgb_9x9_detect.filter_size_9x9.green.k(74).n  =74  and
          rgb_9x9_detect.filter_size_9x9.green.k(75).n  =75  and
          rgb_9x9_detect.filter_size_9x9.green.k(76).n  =76  and
          rgb_9x9_detect.filter_size_9x9.green.k(77).n  =77  and
          rgb_9x9_detect.filter_size_9x9.green.k(78).n  =78  and
          rgb_9x9_detect.filter_size_9x9.green.k(79).n  =79  and
          rgb_9x9_detect.filter_size_9x9.green.k(80).n  =80  and
          rgb_9x9_detect.filter_size_9x9.green.k(81).n  =81) then  
                sum.green.result   <= std_logic_vector(to_unsigned(sum.green.pixels_01_to_81, 10));
        --elsif (rgb_9x9_detect.filter_size_9x9.green.k(1).n=1 and  rgb_9x9_detect.filter_size_9x9.green.k(2).n=2 and rgb_9x9_detect.filter_size_9x9.green.k(3).n=3
        --   and rgb_9x9_detect.filter_size_9x9.green.k(10).n=10 and rgb_9x9_detect.filter_size_9x9.green.k(11).n=11 and rgb_9x9_detect.filter_size_9x9.green.k(12).n=12  
        --   and rgb_9x9_detect.filter_size_9x9.green.k(19).n=19 and rgb_9x9_detect.filter_size_9x9.green.k(20).n=20  and rgb_9x9_detect.filter_size_9x9.green.k(21).n=21) then
        --        sum.green.result      <= std_logic_vector(to_unsigned(sum.green.pixels_01_to_21_3x3, 10));
         else
             sum.green.result   <= Rgb3.green;
         end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if( rgb_9x9_detect.filter_size_9x9.blue.k(1).n   =1  and
            rgb_9x9_detect.filter_size_9x9.blue.k(2).n   =2  and
            rgb_9x9_detect.filter_size_9x9.blue.k(3).n   =3  and
            rgb_9x9_detect.filter_size_9x9.blue.k(4).n   =4  and
            rgb_9x9_detect.filter_size_9x9.blue.k(5).n   =5  and
            rgb_9x9_detect.filter_size_9x9.blue.k(6).n   =6  and
            rgb_9x9_detect.filter_size_9x9.blue.k(7).n   =7  and
            rgb_9x9_detect.filter_size_9x9.blue.k(8).n   =8  and
            rgb_9x9_detect.filter_size_9x9.blue.k(9).n   =9  and
            rgb_9x9_detect.filter_size_9x9.blue.k(10).n  =10  and
            rgb_9x9_detect.filter_size_9x9.blue.k(11).n  =11  and
            rgb_9x9_detect.filter_size_9x9.blue.k(12).n  =12  and
            rgb_9x9_detect.filter_size_9x9.blue.k(13).n  =13  and
            rgb_9x9_detect.filter_size_9x9.blue.k(14).n  =14  and
            rgb_9x9_detect.filter_size_9x9.blue.k(15).n  =15  and
            rgb_9x9_detect.filter_size_9x9.blue.k(16).n  =16  and
            rgb_9x9_detect.filter_size_9x9.blue.k(17).n  =17  and
            rgb_9x9_detect.filter_size_9x9.blue.k(18).n  =18  and
            rgb_9x9_detect.filter_size_9x9.blue.k(19).n  =19  and
            rgb_9x9_detect.filter_size_9x9.blue.k(20).n  =20  and
            rgb_9x9_detect.filter_size_9x9.blue.k(21).n  =21  and
            rgb_9x9_detect.filter_size_9x9.blue.k(22).n  =22  and
            rgb_9x9_detect.filter_size_9x9.blue.k(23).n  =23  and
            rgb_9x9_detect.filter_size_9x9.blue.k(24).n  =24  and
            rgb_9x9_detect.filter_size_9x9.blue.k(25).n  =25  and
            rgb_9x9_detect.filter_size_9x9.blue.k(26).n  =26  and
            rgb_9x9_detect.filter_size_9x9.blue.k(27).n  =27  and
            rgb_9x9_detect.filter_size_9x9.blue.k(28).n  =28  and
            rgb_9x9_detect.filter_size_9x9.blue.k(29).n  =29  and
            rgb_9x9_detect.filter_size_9x9.blue.k(30).n  =30  and
            rgb_9x9_detect.filter_size_9x9.blue.k(31).n  =31  and
            rgb_9x9_detect.filter_size_9x9.blue.k(32).n  =32  and
            rgb_9x9_detect.filter_size_9x9.blue.k(33).n  =33  and
            rgb_9x9_detect.filter_size_9x9.blue.k(34).n  =34  and
            rgb_9x9_detect.filter_size_9x9.blue.k(35).n  =35  and
            rgb_9x9_detect.filter_size_9x9.blue.k(36).n  =36  and
            rgb_9x9_detect.filter_size_9x9.blue.k(37).n  =37  and
            rgb_9x9_detect.filter_size_9x9.blue.k(38).n  =38  and
            rgb_9x9_detect.filter_size_9x9.blue.k(39).n  =39  and
            rgb_9x9_detect.filter_size_9x9.blue.k(40).n  =40  and
            rgb_9x9_detect.filter_size_9x9.blue.k(41).n  =41  and
            rgb_9x9_detect.filter_size_9x9.blue.k(42).n  =42  and
            rgb_9x9_detect.filter_size_9x9.blue.k(43).n  =43  and
            rgb_9x9_detect.filter_size_9x9.blue.k(44).n  =44  and
            rgb_9x9_detect.filter_size_9x9.blue.k(45).n  =45  and
            rgb_9x9_detect.filter_size_9x9.blue.k(46).n  =46  and
            rgb_9x9_detect.filter_size_9x9.blue.k(47).n  =47  and
            rgb_9x9_detect.filter_size_9x9.blue.k(48).n  =48  and
            rgb_9x9_detect.filter_size_9x9.blue.k(49).n  =49  and
            rgb_9x9_detect.filter_size_9x9.blue.k(50).n  =50  and
            rgb_9x9_detect.filter_size_9x9.blue.k(51).n  =51  and
            rgb_9x9_detect.filter_size_9x9.blue.k(52).n  =52  and
            rgb_9x9_detect.filter_size_9x9.blue.k(53).n  =53  and
            rgb_9x9_detect.filter_size_9x9.blue.k(54).n  =54  and
            rgb_9x9_detect.filter_size_9x9.blue.k(55).n  =55  and
            rgb_9x9_detect.filter_size_9x9.blue.k(56).n  =56  and
            rgb_9x9_detect.filter_size_9x9.blue.k(57).n  =57  and
            rgb_9x9_detect.filter_size_9x9.blue.k(58).n  =58  and
            rgb_9x9_detect.filter_size_9x9.blue.k(59).n  =59  and
            rgb_9x9_detect.filter_size_9x9.blue.k(60).n  =60  and
            rgb_9x9_detect.filter_size_9x9.blue.k(61).n  =61  and
            rgb_9x9_detect.filter_size_9x9.blue.k(62).n  =62  and
            rgb_9x9_detect.filter_size_9x9.blue.k(63).n  =63  and
            rgb_9x9_detect.filter_size_9x9.blue.k(64).n  =64  and
            rgb_9x9_detect.filter_size_9x9.blue.k(65).n  =65  and
            rgb_9x9_detect.filter_size_9x9.blue.k(66).n  =66  and
            rgb_9x9_detect.filter_size_9x9.blue.k(67).n  =67  and
            rgb_9x9_detect.filter_size_9x9.blue.k(68).n  =68  and
            rgb_9x9_detect.filter_size_9x9.blue.k(69).n  =69  and
            rgb_9x9_detect.filter_size_9x9.blue.k(70).n  =70  and
            rgb_9x9_detect.filter_size_9x9.blue.k(71).n  =71  and
            rgb_9x9_detect.filter_size_9x9.blue.k(72).n  =72  and
            rgb_9x9_detect.filter_size_9x9.blue.k(73).n  =73  and
            rgb_9x9_detect.filter_size_9x9.blue.k(74).n  =74  and
            rgb_9x9_detect.filter_size_9x9.blue.k(75).n  =75  and
            rgb_9x9_detect.filter_size_9x9.blue.k(76).n  =76  and
            rgb_9x9_detect.filter_size_9x9.blue.k(77).n  =77  and
            rgb_9x9_detect.filter_size_9x9.blue.k(78).n  =78  and
            rgb_9x9_detect.filter_size_9x9.blue.k(79).n  =79  and
            rgb_9x9_detect.filter_size_9x9.blue.k(80).n  =80  and
            rgb_9x9_detect.filter_size_9x9.blue.k(81).n  =81) then  
                sum.blue.result   <= std_logic_vector(to_unsigned(sum.blue.pixels_01_to_81, 10));
        --elsif (rgb_9x9_detect.filter_size_9x9.blue.k(1).n=1 and  rgb_9x9_detect.filter_size_9x9.blue.k(2).n=2 and rgb_9x9_detect.filter_size_9x9.blue.k(3).n=3
        --   and rgb_9x9_detect.filter_size_9x9.blue.k(10).n=10 and rgb_9x9_detect.filter_size_9x9.blue.k(11).n=11 and rgb_9x9_detect.filter_size_9x9.blue.k(12).n=12  
        --   and rgb_9x9_detect.filter_size_9x9.blue.k(19).n=19 and rgb_9x9_detect.filter_size_9x9.blue.k(20).n=20  and rgb_9x9_detect.filter_size_9x9.blue.k(21).n=21) then
        --        sum.blue.result      <= std_logic_vector(to_unsigned(sum.blue.pixels_01_to_21_3x3, 10));
            else
                sum.blue.result   <= Rgb3.blue;
            end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        oRgb.red     <= sum.red.result;
        oRgb.green   <= sum.green.result;
        oRgb.blue    <= sum.blue.result;
        oRgb.valid   <= rgbSyncValid(15);
        oRgb.eol     <= rgbSyncEol(15);
        oRgb.sof     <= rgbSyncSof(15);
        oRgb.eof     <= rgbSyncEof(15);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgb_9x9_delta.filter_size_9x9.red.k1 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(1).n  <= 1;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(1).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k2 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(2).n  <= 2;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(2).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k3 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(3).n  <= 3;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(3).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k4 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(4).n  <= 4;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(4).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k5 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(5).n  <= 5;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(5).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k6 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(6).n  <= 6;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(6).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k7 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(7).n  <= 7;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(7).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k8 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(8).n  <= 8;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(8).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k9 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(9).n  <= 9;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(9).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k10 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(10).n  <= 10;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(10).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k11 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(11).n  <= 11;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(11).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k12 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(12).n  <= 12;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(12).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k13 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(13).n  <= 13;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(13).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k14 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(14).n  <= 14;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(14).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k15 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(15).n  <= 15;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(15).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k16 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(16).n  <= 16;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(16).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k17 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(17).n  <= 17;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(17).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k18 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(18).n  <= 18;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(18).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k19 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(19).n  <= 19;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(19).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k20 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(20).n  <= 20;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(20).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k21 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(21).n  <= 21;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(21).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k22 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(22).n  <= 22;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(22).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k23 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(23).n  <= 23;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(23).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k24 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(24).n  <= 24;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(24).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k25 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(25).n  <= 25;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(25).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k26 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(26).n  <= 26;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(26).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k27 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(27).n  <= 27;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(27).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k28 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(28).n  <= 28;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(28).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k29 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(29).n  <= 29;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(29).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k30 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(30).n  <= 30;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(30).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k31 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(31).n  <= 31;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(31).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k32 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(32).n  <= 32;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(32).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k33 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(33).n  <= 33;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(33).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k34 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(34).n  <= 34;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(34).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k35 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(35).n  <= 35;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(35).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k36 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(36).n  <= 36;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(36).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k37 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(37).n  <= 37;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(37).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k38 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(38).n  <= 38;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(38).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k39 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(39).n  <= 39;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(39).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k40 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(40).n  <= 40;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(40).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k41 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(41).n  <= 41;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(41).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k42 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(42).n  <= 42;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(42).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k43 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(43).n  <= 43;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(43).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k44 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(44).n  <= 44;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(44).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k45 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(45).n  <= 45;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(45).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k46 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(46).n  <= 46;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(46).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k47 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(47).n  <= 47;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(47).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k48 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(48).n  <= 48;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(48).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k49 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(49).n  <= 49;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(49).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k50 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(50).n  <= 50;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(50).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k51 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(51).n  <= 51;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(51).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k52 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(52).n  <= 52;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(52).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k53 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(53).n  <= 53;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(53).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k54 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(54).n  <= 54;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(54).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k55 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(55).n  <= 55;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(55).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k56 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(56).n  <= 56;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(56).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k57 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(57).n  <= 57;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(57).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k58 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(58).n  <= 58;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(58).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k59 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(59).n  <= 59;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(59).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k60 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(60).n  <= 60;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(60).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k61 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(61).n  <= 61;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(61).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k62 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(62).n  <= 62;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(62).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k63 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(63).n  <= 63;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(63).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k64 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(64).n  <= 64;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(64).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k65 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(65).n  <= 65;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(65).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k66 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(66).n  <= 66;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(66).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k67 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(67).n  <= 67;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(67).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k68 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(68).n  <= 68;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(68).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k69 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(69).n  <= 69;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(69).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k70 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(70).n  <= 70;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(70).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k71 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(71).n  <= 71;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(71).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k72 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(72).n  <= 72;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(72).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k73 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(73).n  <= 73;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(73).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k74 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(74).n  <= 74;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(74).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k75 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(75).n  <= 75;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(75).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k76 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(76).n  <= 76;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(76).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k77 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(77).n  <= 77;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(77).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k78 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(78).n  <= 78;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(78).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k79 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(79).n  <= 79;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(79).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k80 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(80).n  <= 80;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(80).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.red.k81 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.red.k(81).n  <= 81;
        else
            rgb_9x9_detect.filter_size_9x9.red.k(81).n  <= 0;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgb_9x9_delta.filter_size_9x9.green.k1 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(1).n  <= 1;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(1).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k2 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(2).n  <= 2;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(2).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k3 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(3).n  <= 3;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(3).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k4 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(4).n  <= 4;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(4).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k5 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(5).n  <= 5;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(5).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k6 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(6).n  <= 6;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(6).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k7 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(7).n  <= 7;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(7).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k8 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(8).n  <= 8;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(8).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k9 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(9).n  <= 9;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(9).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k10 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(10).n  <= 10;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(10).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k11 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(11).n  <= 11;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(11).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k12 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(12).n  <= 12;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(12).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k13 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(13).n  <= 13;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(13).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k14 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(14).n  <= 14;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(14).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k15 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(15).n  <= 15;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(15).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k16 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(16).n  <= 16;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(16).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k17 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(17).n  <= 17;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(17).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k18 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(18).n  <= 18;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(18).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k19 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(19).n  <= 19;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(19).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k20 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(20).n  <= 20;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(20).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k21 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(21).n  <= 21;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(21).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k22 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(22).n  <= 22;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(22).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k23 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(23).n  <= 23;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(23).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k24 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(24).n  <= 24;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(24).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k25 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(25).n  <= 25;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(25).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k26 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(26).n  <= 26;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(26).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k27 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(27).n  <= 27;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(27).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k28 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(28).n  <= 28;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(28).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k29 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(29).n  <= 29;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(29).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k30 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(30).n  <= 30;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(30).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k31 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(31).n  <= 31;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(31).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k32 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(32).n  <= 32;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(32).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k33 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(33).n  <= 33;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(33).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k34 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(34).n  <= 34;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(34).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k35 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(35).n  <= 35;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(35).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k36 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(36).n  <= 36;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(36).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k37 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(37).n  <= 37;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(37).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k38 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(38).n  <= 38;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(38).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k39 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(39).n  <= 39;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(39).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k40 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(40).n  <= 40;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(40).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k41 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(41).n  <= 41;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(41).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k42 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(42).n  <= 42;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(42).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k43 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(43).n  <= 43;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(43).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k44 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(44).n  <= 44;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(44).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k45 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(45).n  <= 45;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(45).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k46 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(46).n  <= 46;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(46).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k47 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(47).n  <= 47;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(47).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k48 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(48).n  <= 48;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(48).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k49 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(49).n  <= 49;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(49).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k50 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(50).n  <= 50;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(50).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k51 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(51).n  <= 51;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(51).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k52 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(52).n  <= 52;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(52).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k53 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(53).n  <= 53;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(53).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k54 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(54).n  <= 54;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(54).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k55 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(55).n  <= 55;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(55).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k56 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(56).n  <= 56;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(56).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k57 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(57).n  <= 57;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(57).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k58 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(58).n  <= 58;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(58).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k59 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(59).n  <= 59;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(59).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k60 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(60).n  <= 60;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(60).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k61 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(61).n  <= 61;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(61).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k62 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(62).n  <= 62;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(62).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k63 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(63).n  <= 63;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(63).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k64 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(64).n  <= 64;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(64).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k65 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(65).n  <= 65;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(65).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k66 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(66).n  <= 66;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(66).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k67 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(67).n  <= 67;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(67).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k68 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(68).n  <= 68;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(68).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k69 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(69).n  <= 69;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(69).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k70 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(70).n  <= 70;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(70).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k71 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(71).n  <= 71;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(71).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k72 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(72).n  <= 72;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(72).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k73 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(73).n  <= 73;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(73).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k74 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(74).n  <= 74;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(74).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k75 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(75).n  <= 75;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(75).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k76 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(76).n  <= 76;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(76).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k77 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(77).n  <= 77;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(77).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k78 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(78).n  <= 78;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(78).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k79 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(79).n  <= 79;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(79).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k80 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(80).n  <= 80;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(80).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.green.k81 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.green.k(81).n  <= 81;
        else
            rgb_9x9_detect.filter_size_9x9.green.k(81).n  <= 0;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgb_9x9_delta.filter_size_9x9.blue.k1 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(1).n  <= 1;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(1).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k2 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(2).n  <= 2;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(2).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k3 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(3).n  <= 3;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(3).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k4 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(4).n  <= 4;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(4).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k5 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(5).n  <= 5;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(5).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k6 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(6).n  <= 6;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(6).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k7 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(7).n  <= 7;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(7).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k8 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(8).n  <= 8;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(8).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k9 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(9).n  <= 9;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(9).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k10 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(10).n  <= 10;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(10).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k11 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(11).n  <= 11;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(11).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k12 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(12).n  <= 12;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(12).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k13 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(13).n  <= 13;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(13).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k14 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(14).n  <= 14;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(14).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k15 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(15).n  <= 15;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(15).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k16 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(16).n  <= 16;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(16).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k17 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(17).n  <= 17;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(17).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k18 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(18).n  <= 18;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(18).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k19 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(19).n  <= 19;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(19).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k20 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(20).n  <= 20;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(20).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k21 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(21).n  <= 21;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(21).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k22 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(22).n  <= 22;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(22).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k23 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(23).n  <= 23;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(23).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k24 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(24).n  <= 24;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(24).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k25 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(25).n  <= 25;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(25).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k26 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(26).n  <= 26;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(26).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k27 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(27).n  <= 27;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(27).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k28 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(28).n  <= 28;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(28).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k29 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(29).n  <= 29;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(29).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k30 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(30).n  <= 30;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(30).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k31 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(31).n  <= 31;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(31).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k32 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(32).n  <= 32;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(32).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k33 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(33).n  <= 33;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(33).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k34 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(34).n  <= 34;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(34).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k35 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(35).n  <= 35;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(35).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k36 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(36).n  <= 36;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(36).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k37 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(37).n  <= 37;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(37).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k38 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(38).n  <= 38;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(38).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k39 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(39).n  <= 39;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(39).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k40 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(40).n  <= 40;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(40).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k41 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(41).n  <= 41;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(41).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k42 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(42).n  <= 42;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(42).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k43 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(43).n  <= 43;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(43).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k44 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(44).n  <= 44;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(44).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k45 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(45).n  <= 45;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(45).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k46 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(46).n  <= 46;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(46).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k47 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(47).n  <= 47;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(47).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k48 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(48).n  <= 48;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(48).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k49 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(49).n  <= 49;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(49).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k50 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(50).n  <= 50;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(50).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k51 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(51).n  <= 51;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(51).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k52 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(52).n  <= 52;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(52).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k53 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(53).n  <= 53;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(53).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k54 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(54).n  <= 54;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(54).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k55 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(55).n  <= 55;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(55).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k56 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(56).n  <= 56;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(56).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k57 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(57).n  <= 57;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(57).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k58 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(58).n  <= 58;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(58).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k59 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(59).n  <= 59;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(59).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k60 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(60).n  <= 60;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(60).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k61 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(61).n  <= 61;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(61).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k62 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(62).n  <= 62;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(62).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k63 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(63).n  <= 63;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(63).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k64 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(64).n  <= 64;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(64).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k65 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(65).n  <= 65;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(65).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k66 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(66).n  <= 66;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(66).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k67 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(67).n  <= 67;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(67).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k68 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(68).n  <= 68;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(68).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k69 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(69).n  <= 69;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(69).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k70 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(70).n  <= 70;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(70).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k71 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(71).n  <= 71;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(71).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k72 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(72).n  <= 72;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(72).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k73 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(73).n  <= 73;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(73).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k74 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(74).n  <= 74;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(74).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k75 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(75).n  <= 75;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(75).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k76 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(76).n  <= 76;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(76).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k77 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(77).n  <= 77;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(77).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k78 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(78).n  <= 78;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(78).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k79 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(79).n  <= 79;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(79).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k80 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(80).n  <= 80;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(80).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_9x9.blue.k81 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_9x9.blue.k(81).n  <= 81;
        else
            rgb_9x9_detect.filter_size_9x9.blue.k(81).n  <= 0;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgb_9x9_delta.filter_size_3x3.red.k1 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(1).n  <= 1;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(1).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k2 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(2).n  <= 2;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(2).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k3 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(3).n  <= 3;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(3).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k4 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(4).n  <= 4;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(4).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k5 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(5).n  <= 5;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(5).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k6 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(6).n  <= 6;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(6).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k7 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(7).n  <= 7;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(7).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k8 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(8).n  <= 8;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(8).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k9 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(9).n  <= 9;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(9).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k10 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(10).n  <= 10;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(10).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k11 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(11).n  <= 11;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(11).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k12 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(12).n  <= 12;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(12).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k13 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(13).n  <= 13;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(13).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k14 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(14).n  <= 14;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(14).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k15 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(15).n  <= 15;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(15).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k16 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(16).n  <= 16;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(16).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k17 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(17).n  <= 17;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(17).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k18 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(18).n  <= 18;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(18).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k19 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(19).n  <= 19;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(19).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k20 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(20).n  <= 20;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(20).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k21 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(21).n  <= 21;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(21).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k22 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(22).n  <= 22;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(22).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k23 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(23).n  <= 23;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(23).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k24 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(24).n  <= 24;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(24).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k25 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(25).n  <= 25;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(25).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k26 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(26).n  <= 26;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(26).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k27 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(27).n  <= 27;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(27).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k28 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(28).n  <= 28;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(28).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k29 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(29).n  <= 29;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(29).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k30 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(30).n  <= 30;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(30).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k31 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(31).n  <= 31;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(31).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k32 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(32).n  <= 32;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(32).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k33 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(33).n  <= 33;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(33).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k34 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(34).n  <= 34;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(34).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k35 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(35).n  <= 35;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(35).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k36 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(36).n  <= 36;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(36).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k37 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(37).n  <= 37;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(37).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k38 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(38).n  <= 38;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(38).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k39 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(39).n  <= 39;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(39).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k40 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(40).n  <= 40;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(40).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k41 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(41).n  <= 41;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(41).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k42 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(42).n  <= 42;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(42).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k43 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(43).n  <= 43;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(43).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k44 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(44).n  <= 44;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(44).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k45 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(45).n  <= 45;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(45).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k46 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(46).n  <= 46;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(46).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k47 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(47).n  <= 47;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(47).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k48 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(48).n  <= 48;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(48).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k49 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(49).n  <= 49;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(49).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k50 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(50).n  <= 50;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(50).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k51 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(51).n  <= 51;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(51).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k52 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(52).n  <= 52;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(52).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k53 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(53).n  <= 53;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(53).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k54 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(54).n  <= 54;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(54).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k55 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(55).n  <= 55;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(55).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k56 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(56).n  <= 56;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(56).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k57 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(57).n  <= 57;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(57).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k58 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(58).n  <= 58;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(58).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k59 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(59).n  <= 59;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(59).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k60 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(60).n  <= 60;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(60).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k61 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(61).n  <= 61;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(61).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k62 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(62).n  <= 62;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(62).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k63 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(63).n  <= 63;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(63).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k64 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(64).n  <= 64;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(64).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k65 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(65).n  <= 65;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(65).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k66 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(66).n  <= 66;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(66).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k67 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(67).n  <= 67;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(67).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k68 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(68).n  <= 68;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(68).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k69 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(69).n  <= 69;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(69).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k70 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(70).n  <= 70;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(70).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k71 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(71).n  <= 71;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(71).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k72 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(72).n  <= 72;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(72).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k73 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(73).n  <= 73;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(73).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k74 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(74).n  <= 74;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(74).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k75 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(75).n  <= 75;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(75).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k76 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(76).n  <= 76;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(76).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k77 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(77).n  <= 77;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(77).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k78 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(78).n  <= 78;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(78).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k79 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(79).n  <= 79;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(79).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k80 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(80).n  <= 80;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(80).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.red.k81 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.red.k(81).n  <= 81;
        else
            rgb_9x9_detect.filter_size_3x3.red.k(81).n  <= 0;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgb_9x9_delta.filter_size_3x3.green.k1 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(1).n  <= 1;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(1).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k2 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(2).n  <= 2;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(2).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k3 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(3).n  <= 3;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(3).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k4 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(4).n  <= 4;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(4).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k5 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(5).n  <= 5;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(5).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k6 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(6).n  <= 6;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(6).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k7 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(7).n  <= 7;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(7).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k8 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(8).n  <= 8;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(8).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k9 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(9).n  <= 9;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(9).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k10 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(10).n  <= 10;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(10).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k11 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(11).n  <= 11;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(11).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k12 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(12).n  <= 12;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(12).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k13 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(13).n  <= 13;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(13).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k14 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(14).n  <= 14;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(14).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k15 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(15).n  <= 15;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(15).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k16 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(16).n  <= 16;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(16).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k17 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(17).n  <= 17;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(17).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k18 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(18).n  <= 18;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(18).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k19 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(19).n  <= 19;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(19).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k20 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(20).n  <= 20;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(20).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k21 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(21).n  <= 21;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(21).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k22 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(22).n  <= 22;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(22).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k23 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(23).n  <= 23;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(23).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k24 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(24).n  <= 24;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(24).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k25 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(25).n  <= 25;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(25).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k26 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(26).n  <= 26;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(26).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k27 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(27).n  <= 27;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(27).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k28 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(28).n  <= 28;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(28).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k29 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(29).n  <= 29;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(29).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k30 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(30).n  <= 30;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(30).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k31 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(31).n  <= 31;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(31).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k32 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(32).n  <= 32;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(32).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k33 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(33).n  <= 33;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(33).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k34 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(34).n  <= 34;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(34).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k35 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(35).n  <= 35;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(35).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k36 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(36).n  <= 36;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(36).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k37 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(37).n  <= 37;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(37).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k38 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(38).n  <= 38;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(38).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k39 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(39).n  <= 39;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(39).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k40 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(40).n  <= 40;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(40).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k41 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(41).n  <= 41;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(41).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k42 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(42).n  <= 42;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(42).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k43 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(43).n  <= 43;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(43).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k44 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(44).n  <= 44;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(44).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k45 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(45).n  <= 45;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(45).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k46 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(46).n  <= 46;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(46).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k47 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(47).n  <= 47;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(47).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k48 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(48).n  <= 48;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(48).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k49 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(49).n  <= 49;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(49).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k50 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(50).n  <= 50;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(50).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k51 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(51).n  <= 51;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(51).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k52 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(52).n  <= 52;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(52).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k53 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(53).n  <= 53;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(53).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k54 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(54).n  <= 54;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(54).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k55 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(55).n  <= 55;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(55).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k56 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(56).n  <= 56;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(56).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k57 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(57).n  <= 57;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(57).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k58 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(58).n  <= 58;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(58).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k59 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(59).n  <= 59;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(59).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k60 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(60).n  <= 60;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(60).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k61 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(61).n  <= 61;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(61).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k62 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(62).n  <= 62;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(62).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k63 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(63).n  <= 63;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(63).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k64 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(64).n  <= 64;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(64).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k65 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(65).n  <= 65;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(65).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k66 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(66).n  <= 66;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(66).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k67 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(67).n  <= 67;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(67).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k68 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(68).n  <= 68;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(68).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k69 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(69).n  <= 69;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(69).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k70 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(70).n  <= 70;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(70).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k71 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(71).n  <= 71;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(71).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k72 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(72).n  <= 72;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(72).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k73 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(73).n  <= 73;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(73).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k74 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(74).n  <= 74;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(74).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k75 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(75).n  <= 75;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(75).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k76 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(76).n  <= 76;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(76).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k77 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(77).n  <= 77;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(77).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k78 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(78).n  <= 78;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(78).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k79 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(79).n  <= 79;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(79).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k80 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(80).n  <= 80;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(80).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.green.k81 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.green.k(81).n  <= 81;
        else
            rgb_9x9_detect.filter_size_3x3.green.k(81).n  <= 0;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgb_9x9_delta.filter_size_3x3.blue.k1 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(1).n  <= 1;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(1).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k2 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(2).n  <= 2;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(2).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k3 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(3).n  <= 3;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(3).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k4 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(4).n  <= 4;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(4).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k5 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(5).n  <= 5;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(5).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k6 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(6).n  <= 6;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(6).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k7 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(7).n  <= 7;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(7).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k8 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(8).n  <= 8;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(8).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k9 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(9).n  <= 9;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(9).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k10 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(10).n  <= 10;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(10).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k11 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(11).n  <= 11;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(11).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k12 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(12).n  <= 12;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(12).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k13 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(13).n  <= 13;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(13).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k14 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(14).n  <= 14;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(14).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k15 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(15).n  <= 15;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(15).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k16 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(16).n  <= 16;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(16).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k17 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(17).n  <= 17;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(17).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k18 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(18).n  <= 18;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(18).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k19 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(19).n  <= 19;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(19).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k20 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(20).n  <= 20;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(20).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k21 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(21).n  <= 21;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(21).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k22 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(22).n  <= 22;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(22).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k23 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(23).n  <= 23;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(23).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k24 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(24).n  <= 24;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(24).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k25 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(25).n  <= 25;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(25).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k26 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(26).n  <= 26;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(26).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k27 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(27).n  <= 27;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(27).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k28 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(28).n  <= 28;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(28).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k29 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(29).n  <= 29;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(29).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k30 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(30).n  <= 30;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(30).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k31 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(31).n  <= 31;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(31).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k32 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(32).n  <= 32;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(32).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k33 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(33).n  <= 33;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(33).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k34 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(34).n  <= 34;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(34).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k35 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(35).n  <= 35;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(35).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k36 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(36).n  <= 36;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(36).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k37 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(37).n  <= 37;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(37).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k38 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(38).n  <= 38;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(38).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k39 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(39).n  <= 39;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(39).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k40 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(40).n  <= 40;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(40).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k41 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(41).n  <= 41;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(41).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k42 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(42).n  <= 42;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(42).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k43 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(43).n  <= 43;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(43).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k44 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(44).n  <= 44;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(44).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k45 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(45).n  <= 45;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(45).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k46 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(46).n  <= 46;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(46).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k47 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(47).n  <= 47;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(47).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k48 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(48).n  <= 48;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(48).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k49 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(49).n  <= 49;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(49).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k50 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(50).n  <= 50;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(50).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k51 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(51).n  <= 51;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(51).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k52 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(52).n  <= 52;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(52).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k53 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(53).n  <= 53;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(53).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k54 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(54).n  <= 54;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(54).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k55 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(55).n  <= 55;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(55).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k56 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(56).n  <= 56;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(56).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k57 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(57).n  <= 57;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(57).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k58 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(58).n  <= 58;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(58).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k59 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(59).n  <= 59;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(59).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k60 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(60).n  <= 60;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(60).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k61 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(61).n  <= 61;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(61).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k62 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(62).n  <= 62;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(62).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k63 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(63).n  <= 63;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(63).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k64 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(64).n  <= 64;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(64).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k65 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(65).n  <= 65;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(65).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k66 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(66).n  <= 66;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(66).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k67 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(67).n  <= 67;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(67).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k68 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(68).n  <= 68;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(68).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k69 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(69).n  <= 69;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(69).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k70 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(70).n  <= 70;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(70).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k71 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(71).n  <= 71;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(71).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k72 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(72).n  <= 72;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(72).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k73 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(73).n  <= 73;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(73).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k74 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(74).n  <= 74;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(74).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k75 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(75).n  <= 75;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(75).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k76 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(76).n  <= 76;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(76).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k77 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(77).n  <= 77;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(77).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k78 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(78).n  <= 78;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(78).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k79 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(79).n  <= 79;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(79).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k80 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(80).n  <= 80;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(80).n  <= 0;
        end if;
        if(rgb_9x9_delta.filter_size_3x3.blue.k81 <= pixel_threshold_2) then
            rgb_9x9_detect.filter_size_3x3.blue.k(81).n  <= 81;
        else
            rgb_9x9_detect.filter_size_3x3.blue.k(81).n  <= 0;
        end if;
    end if;
end process;
end behavioral;