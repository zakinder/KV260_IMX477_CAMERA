-------------------------------------------------------------------------------
--
-- Filename    : pixel_localization_3x3_window.vhd
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
entity pixel_localization_3x3_window is
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
end pixel_localization_3x3_window;
architecture behavioral of pixel_localization_3x3_window is
------------------------------------------------------------------------------
  signal pixel_threshold_2                         : integer  := neighboring_pixel_threshold;   -- [60% with 20] [70% with 40] 
  signal row1                                      : k_9by9;
  signal row2                                      : k_9by9;
  signal row3                                      : k_9by9;
  signal rgb_pixels_3x3                            : k_9by9_rgb;
  signal rgb_3x3                                   : k_3by3_rgb_integers;
  signal rgb_3x3_delta                             : filters_size_rgb_integers;
  signal rgb_3x3_detect                            : filters_3by3_rgb_detect;
  signal pix_3x3                                   : k_3by3_rgb_integers;
  signal sum                                       : rgb_pixel_sum_values;
  signal v_tap_0x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_1x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_2x                                  : std_logic_vector(29 downto 0) := (others => '0');
  signal v_tap_3x                                  : std_logic_vector(29 downto 0) := (others => '0'); 
  signal tpValid                                   : std_logic;
  signal pixels_1_81_enabled                       : std_logic:= '0';
  signal Rgb1                                      : channel;
  signal Rgb2                                      : channel;
  signal Rgb3                                      : channel;
  signal rgbSyncValid                              : std_logic_vector(31 downto 0)  := x"00000000";
  signal rgbSyncEol                                : std_logic_vector(31 downto 0)  := x"00000000";
  signal rgbSyncSof                                : std_logic_vector(31 downto 0)  := x"00000000";
  signal rgbSyncEof                                : std_logic_vector(31 downto 0)  := x"00000000";
begin 

rgb_syncr_inst  : sync_frames
generic map(
    pixelDelay => 14)
port map(
    clk        => clk,
    reset      => reset,
    iRgb       => iRgb,
    oRgb       => Rgb3);
rgb_3taps_Inst: rgb_3taps
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
    tp2             => v_tap_2x);
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

    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
            rgb_pixels_3x3.red.k1  <= row1.pixel_1(29 downto 20);
            rgb_pixels_3x3.red.k2  <= row1.pixel_2(29 downto 20);
            rgb_pixels_3x3.red.k3  <= row1.pixel_3(29 downto 20);
            rgb_pixels_3x3.red.k4  <= row2.pixel_1(29 downto 20);
            rgb_pixels_3x3.red.k5  <= row2.pixel_2(29 downto 20);
            rgb_pixels_3x3.red.k6  <= row2.pixel_3(29 downto 20);
            rgb_pixels_3x3.red.k7  <= row3.pixel_1(29 downto 20);
            rgb_pixels_3x3.red.k8  <= row3.pixel_2(29 downto 20);
            rgb_pixels_3x3.red.k9  <= row3.pixel_3(29 downto 20);
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
            rgb_pixels_3x3.green.k1  <= row1.pixel_1(19 downto 10);
            rgb_pixels_3x3.green.k2  <= row1.pixel_2(19 downto 10);
            rgb_pixels_3x3.green.k3  <= row1.pixel_3(19 downto 10);
            rgb_pixels_3x3.green.k4  <= row2.pixel_1(19 downto 10);
            rgb_pixels_3x3.green.k5  <= row2.pixel_2(19 downto 10);
            rgb_pixels_3x3.green.k6  <= row2.pixel_3(19 downto 10);
            rgb_pixels_3x3.green.k7  <= row3.pixel_1(19 downto 10);
            rgb_pixels_3x3.green.k8  <= row3.pixel_2(19 downto 10);
            rgb_pixels_3x3.green.k9  <= row3.pixel_3(19 downto 10);
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
            rgb_pixels_3x3.blue.k1  <= row1.pixel_1(9 downto 0);
            rgb_pixels_3x3.blue.k2  <= row1.pixel_2(9 downto 0);
            rgb_pixels_3x3.blue.k3  <= row1.pixel_3(9 downto 0);
            rgb_pixels_3x3.blue.k4  <= row2.pixel_1(9 downto 0);
            rgb_pixels_3x3.blue.k5  <= row2.pixel_2(9 downto 0);
            rgb_pixels_3x3.blue.k6  <= row2.pixel_3(9 downto 0);
            rgb_pixels_3x3.blue.k7  <= row3.pixel_1(9 downto 0);
            rgb_pixels_3x3.blue.k8  <= row3.pixel_2(9 downto 0);
            rgb_pixels_3x3.blue.k9  <= row3.pixel_3(9 downto 0);
    end if;
end process;


process (clk) begin
    if rising_edge(clk) then
        rgb_3x3.red.k1    <= to_integer(unsigned(rgb_pixels_3x3.red.k1)); 
        rgb_3x3.red.k2    <= to_integer(unsigned(rgb_pixels_3x3.red.k2)); 
        rgb_3x3.red.k3    <= to_integer(unsigned(rgb_pixels_3x3.red.k3)); 
        rgb_3x3.red.k4    <= to_integer(unsigned(rgb_pixels_3x3.red.k4)); 
        rgb_3x3.red.k5    <= to_integer(unsigned(rgb_pixels_3x3.red.k5)); 
        rgb_3x3.red.k6    <= to_integer(unsigned(rgb_pixels_3x3.red.k6)); 
        rgb_3x3.red.k7    <= to_integer(unsigned(rgb_pixels_3x3.red.k7)); 
        rgb_3x3.red.k8    <= to_integer(unsigned(rgb_pixels_3x3.red.k8)); 
        rgb_3x3.red.k9    <= to_integer(unsigned(rgb_pixels_3x3.red.k9)); 

    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_3x3.green.k1    <= to_integer(unsigned(rgb_pixels_3x3.green.k1)); 
        rgb_3x3.green.k2    <= to_integer(unsigned(rgb_pixels_3x3.green.k2)); 
        rgb_3x3.green.k3    <= to_integer(unsigned(rgb_pixels_3x3.green.k3)); 
        rgb_3x3.green.k4    <= to_integer(unsigned(rgb_pixels_3x3.green.k4)); 
        rgb_3x3.green.k5    <= to_integer(unsigned(rgb_pixels_3x3.green.k5)); 
        rgb_3x3.green.k6    <= to_integer(unsigned(rgb_pixels_3x3.green.k6)); 
        rgb_3x3.green.k7    <= to_integer(unsigned(rgb_pixels_3x3.green.k7)); 
        rgb_3x3.green.k8    <= to_integer(unsigned(rgb_pixels_3x3.green.k8)); 
        rgb_3x3.green.k9    <= to_integer(unsigned(rgb_pixels_3x3.green.k9)); 

    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_3x3.blue.k1    <= to_integer(unsigned(rgb_pixels_3x3.blue.k1)); 
        rgb_3x3.blue.k2    <= to_integer(unsigned(rgb_pixels_3x3.blue.k2)); 
        rgb_3x3.blue.k3    <= to_integer(unsigned(rgb_pixels_3x3.blue.k3)); 
        rgb_3x3.blue.k4    <= to_integer(unsigned(rgb_pixels_3x3.blue.k4)); 
        rgb_3x3.blue.k5    <= to_integer(unsigned(rgb_pixels_3x3.blue.k5)); 
        rgb_3x3.blue.k6    <= to_integer(unsigned(rgb_pixels_3x3.blue.k6)); 
        rgb_3x3.blue.k7    <= to_integer(unsigned(rgb_pixels_3x3.blue.k7)); 
        rgb_3x3.blue.k8    <= to_integer(unsigned(rgb_pixels_3x3.blue.k8)); 
        rgb_3x3.blue.k9    <= to_integer(unsigned(rgb_pixels_3x3.blue.k9)); 
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_3x3_delta.filter_size_3x3.red.k1      <= abs(rgb_3x3.red.k1 - rgb_3x3.red.k1); 
        rgb_3x3_delta.filter_size_3x3.red.k2      <= abs(rgb_3x3.red.k1 - rgb_3x3.red.k2); 
        rgb_3x3_delta.filter_size_3x3.red.k3      <= abs(rgb_3x3.red.k1 - rgb_3x3.red.k3); 
        rgb_3x3_delta.filter_size_3x3.red.k4      <= abs(rgb_3x3.red.k1 - rgb_3x3.red.k4); 
        rgb_3x3_delta.filter_size_3x3.red.k5      <= abs(rgb_3x3.red.k1 - rgb_3x3.red.k5); 
        rgb_3x3_delta.filter_size_3x3.red.k6      <= abs(rgb_3x3.red.k1 - rgb_3x3.red.k6); 
        rgb_3x3_delta.filter_size_3x3.red.k7      <= abs(rgb_3x3.red.k1 - rgb_3x3.red.k7); 
        rgb_3x3_delta.filter_size_3x3.red.k8      <= abs(rgb_3x3.red.k1 - rgb_3x3.red.k8); 
        rgb_3x3_delta.filter_size_3x3.red.k9      <= abs(rgb_3x3.red.k1 - rgb_3x3.red.k9); 

    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_3x3_delta.filter_size_3x3.green.k1      <= abs(rgb_3x3.green.k1 - rgb_3x3.green.k1); 
        rgb_3x3_delta.filter_size_3x3.green.k2      <= abs(rgb_3x3.green.k1 - rgb_3x3.green.k2); 
        rgb_3x3_delta.filter_size_3x3.green.k3      <= abs(rgb_3x3.green.k1 - rgb_3x3.green.k3); 
        rgb_3x3_delta.filter_size_3x3.green.k4      <= abs(rgb_3x3.green.k1 - rgb_3x3.green.k4); 
        rgb_3x3_delta.filter_size_3x3.green.k5      <= abs(rgb_3x3.green.k1 - rgb_3x3.green.k5); 
        rgb_3x3_delta.filter_size_3x3.green.k6      <= abs(rgb_3x3.green.k1 - rgb_3x3.green.k6); 
        rgb_3x3_delta.filter_size_3x3.green.k7      <= abs(rgb_3x3.green.k1 - rgb_3x3.green.k7); 
        rgb_3x3_delta.filter_size_3x3.green.k8      <= abs(rgb_3x3.green.k1 - rgb_3x3.green.k8); 
        rgb_3x3_delta.filter_size_3x3.green.k9      <= abs(rgb_3x3.green.k1 - rgb_3x3.green.k9); 
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgb_3x3_delta.filter_size_3x3.blue.k1      <= abs(rgb_3x3.blue.k1 - rgb_3x3.blue.k1); 
        rgb_3x3_delta.filter_size_3x3.blue.k2      <= abs(rgb_3x3.blue.k1 - rgb_3x3.blue.k2); 
        rgb_3x3_delta.filter_size_3x3.blue.k3      <= abs(rgb_3x3.blue.k1 - rgb_3x3.blue.k3); 
        rgb_3x3_delta.filter_size_3x3.blue.k4      <= abs(rgb_3x3.blue.k1 - rgb_3x3.blue.k4); 
        rgb_3x3_delta.filter_size_3x3.blue.k5      <= abs(rgb_3x3.blue.k1 - rgb_3x3.blue.k5); 
        rgb_3x3_delta.filter_size_3x3.blue.k6      <= abs(rgb_3x3.blue.k1 - rgb_3x3.blue.k6); 
        rgb_3x3_delta.filter_size_3x3.blue.k7      <= abs(rgb_3x3.blue.k1 - rgb_3x3.blue.k7); 
        rgb_3x3_delta.filter_size_3x3.blue.k8      <= abs(rgb_3x3.blue.k1 - rgb_3x3.blue.k8); 
        rgb_3x3_delta.filter_size_3x3.blue.k9      <= abs(rgb_3x3.blue.k1 - rgb_3x3.blue.k9); 
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        pix_3x3.red   <= rgb_3x3.red;
        pix_3x3.green <= rgb_3x3.green;
        pix_3x3.blue  <= rgb_3x3.blue;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
          sum.red.pixels_01_02_03                <= (pix_3x3.red.k1  + pix_3x3.red.k2*2  + pix_3x3.red.k3) / 4;
          sum.red.pixels_04_05_06                <= (pix_3x3.red.k4*2 + pix_3x3.red.k5*4 + pix_3x3.red.k6*2) / 8;
          sum.red.pixels_07_08_09                <= (pix_3x3.red.k7 + pix_3x3.red.k8*2 + pix_3x3.red.k9) / 4;
          sum.red.pixels_01_to_09_3x3            <= (sum.red.pixels_01_02_03 + sum.red.pixels_04_05_06 + sum.red.pixels_07_08_09) / 3;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
          sum.green.pixels_01_02_03                <= (pix_3x3.green.k1  + pix_3x3.green.k2*2  + pix_3x3.green.k3) / 4;
          sum.green.pixels_04_05_06                <= (pix_3x3.green.k4*2 + pix_3x3.green.k5*4 + pix_3x3.green.k6*2) / 8;
          sum.green.pixels_07_08_09                <= (pix_3x3.green.k7 + pix_3x3.green.k8*2 + pix_3x3.green.k9) / 4;
          sum.green.pixels_01_to_09_3x3            <= (sum.green.pixels_01_02_03 + sum.green.pixels_04_05_06 + sum.green.pixels_07_08_09) / 3;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
          sum.blue.pixels_01_02_03                <= (pix_3x3.blue.k1  + pix_3x3.blue.k2*2  + pix_3x3.blue.k3) / 4;
          sum.blue.pixels_04_05_06                <= (pix_3x3.blue.k4*2 + pix_3x3.blue.k5*4 + pix_3x3.blue.k6*2) / 8;
          sum.blue.pixels_07_08_09                <= (pix_3x3.blue.k7 + pix_3x3.blue.k8*2 + pix_3x3.blue.k9) / 4;
          sum.blue.pixels_01_to_09_3x3            <= (sum.blue.pixels_01_02_03 + sum.blue.pixels_04_05_06 + sum.blue.pixels_07_08_09) / 3;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
      if( rgb_3x3_detect.filter_size_3x3.red.k(1).n   =1  and
     rgb_3x3_detect.filter_size_3x3.red.k(2).n   =2  and
     rgb_3x3_detect.filter_size_3x3.red.k(3).n   =3  and
     rgb_3x3_detect.filter_size_3x3.red.k(4).n   =4  and
     rgb_3x3_detect.filter_size_3x3.red.k(5).n   =5  and
     rgb_3x3_detect.filter_size_3x3.red.k(6).n   =6  and
     rgb_3x3_detect.filter_size_3x3.red.k(7).n   =7  and
     rgb_3x3_detect.filter_size_3x3.red.k(8).n   =8  and
     rgb_3x3_detect.filter_size_3x3.red.k(9).n   =9) then  
               pixels_1_81_enabled <= hi;
                sum.red.result      <= std_logic_vector(to_unsigned(sum.red.pixels_01_to_09_3x3, 8));
        else
                pixels_1_81_enabled <= lo;
                sum.red.result   <= Rgb3.red;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
      if( rgb_3x3_detect.filter_size_3x3.green.k(1).n   =1  and
          rgb_3x3_detect.filter_size_3x3.green.k(2).n   =2  and
          rgb_3x3_detect.filter_size_3x3.green.k(3).n   =3  and
          rgb_3x3_detect.filter_size_3x3.green.k(4).n   =4  and
          rgb_3x3_detect.filter_size_3x3.green.k(5).n   =5  and
          rgb_3x3_detect.filter_size_3x3.green.k(6).n   =6  and
          rgb_3x3_detect.filter_size_3x3.green.k(7).n   =7  and
          rgb_3x3_detect.filter_size_3x3.green.k(8).n   =8  and
          rgb_3x3_detect.filter_size_3x3.green.k(9).n   =9) then  
                sum.green.result   <= std_logic_vector(to_unsigned(sum.green.pixels_01_to_81, 8));

         else
             sum.green.result   <= Rgb3.green;
         end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if( rgb_3x3_detect.filter_size_3x3.blue.k(1).n   =1  and
            rgb_3x3_detect.filter_size_3x3.blue.k(2).n   =2  and
            rgb_3x3_detect.filter_size_3x3.blue.k(3).n   =3  and
            rgb_3x3_detect.filter_size_3x3.blue.k(4).n   =4  and
            rgb_3x3_detect.filter_size_3x3.blue.k(5).n   =5  and
            rgb_3x3_detect.filter_size_3x3.blue.k(6).n   =6  and
            rgb_3x3_detect.filter_size_3x3.blue.k(7).n   =7  and
            rgb_3x3_detect.filter_size_3x3.blue.k(8).n   =8  and
            rgb_3x3_detect.filter_size_3x3.blue.k(9).n   =9) then  
                sum.blue.result   <= std_logic_vector(to_unsigned(sum.blue.pixels_01_to_81, 8));

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
        -- oRgb.eol     <= rgbSyncEol(15);
        -- oRgb.sof     <= rgbSyncSof(15);
        -- oRgb.eof     <= rgbSyncEof(15);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgb_3x3_delta.filter_size_3x3.red.k1 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.red.k(1).n  <= 1;
        else
            rgb_3x3_detect.filter_size_3x3.red.k(1).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.red.k2 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.red.k(2).n  <= 2;
        else
            rgb_3x3_detect.filter_size_3x3.red.k(2).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.red.k3 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.red.k(3).n  <= 3;
        else
            rgb_3x3_detect.filter_size_3x3.red.k(3).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.red.k4 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.red.k(4).n  <= 4;
        else
            rgb_3x3_detect.filter_size_3x3.red.k(4).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.red.k5 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.red.k(5).n  <= 5;
        else
            rgb_3x3_detect.filter_size_3x3.red.k(5).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.red.k6 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.red.k(6).n  <= 6;
        else
            rgb_3x3_detect.filter_size_3x3.red.k(6).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.red.k7 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.red.k(7).n  <= 7;
        else
            rgb_3x3_detect.filter_size_3x3.red.k(7).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.red.k8 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.red.k(8).n  <= 8;
        else
            rgb_3x3_detect.filter_size_3x3.red.k(8).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.red.k9 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.red.k(9).n  <= 9;
        else
            rgb_3x3_detect.filter_size_3x3.red.k(9).n  <= 0;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgb_3x3_delta.filter_size_3x3.green.k1 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.green.k(1).n  <= 1;
        else
            rgb_3x3_detect.filter_size_3x3.green.k(1).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.green.k2 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.green.k(2).n  <= 2;
        else
            rgb_3x3_detect.filter_size_3x3.green.k(2).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.green.k3 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.green.k(3).n  <= 3;
        else
            rgb_3x3_detect.filter_size_3x3.green.k(3).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.green.k4 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.green.k(4).n  <= 4;
        else
            rgb_3x3_detect.filter_size_3x3.green.k(4).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.green.k5 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.green.k(5).n  <= 5;
        else
            rgb_3x3_detect.filter_size_3x3.green.k(5).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.green.k6 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.green.k(6).n  <= 6;
        else
            rgb_3x3_detect.filter_size_3x3.green.k(6).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.green.k7 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.green.k(7).n  <= 7;
        else
            rgb_3x3_detect.filter_size_3x3.green.k(7).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.green.k8 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.green.k(8).n  <= 8;
        else
            rgb_3x3_detect.filter_size_3x3.green.k(8).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.green.k9 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.green.k(9).n  <= 9;
        else
            rgb_3x3_detect.filter_size_3x3.green.k(9).n  <= 0;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if(rgb_3x3_delta.filter_size_3x3.blue.k1 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.blue.k(1).n  <= 1;
        else
            rgb_3x3_detect.filter_size_3x3.blue.k(1).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.blue.k2 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.blue.k(2).n  <= 2;
        else
            rgb_3x3_detect.filter_size_3x3.blue.k(2).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.blue.k3 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.blue.k(3).n  <= 3;
        else
            rgb_3x3_detect.filter_size_3x3.blue.k(3).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.blue.k4 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.blue.k(4).n  <= 4;
        else
            rgb_3x3_detect.filter_size_3x3.blue.k(4).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.blue.k5 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.blue.k(5).n  <= 5;
        else
            rgb_3x3_detect.filter_size_3x3.blue.k(5).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.blue.k6 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.blue.k(6).n  <= 6;
        else
            rgb_3x3_detect.filter_size_3x3.blue.k(6).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.blue.k7 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.blue.k(7).n  <= 7;
        else
            rgb_3x3_detect.filter_size_3x3.blue.k(7).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.blue.k8 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.blue.k(8).n  <= 8;
        else
            rgb_3x3_detect.filter_size_3x3.blue.k(8).n  <= 0;
        end if;
        if(rgb_3x3_delta.filter_size_3x3.blue.k9 <= pixel_threshold_2) then
            rgb_3x3_detect.filter_size_3x3.blue.k(9).n  <= 9;
        else
            rgb_3x3_detect.filter_size_3x3.blue.k(9).n  <= 0;
        end if;
    end if;
end process;

end behavioral;