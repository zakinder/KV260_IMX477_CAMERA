-------------------------------------------------------------------------------
--
-- Filename    : recolor_space_hsl.vhd
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
entity recolor_space_hsl is
generic (
    img_width      : integer := 1920;
    i_data_width   : integer := 8);
port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    iRgb           : in channel;
    oRgb           : out channel);
end recolor_space_hsl;
architecture behavioral of recolor_space_hsl is
  signal Rgb1       : channel;
  signal Rgb2       : channel;
  signal Rgb3       : rgbToSfRecord;
  signal Rgb4       : rgbToSfRecord;
  signal Rgb5       : rgbToSf12Record;
  signal Rgb6       : rgbToSfRecord;
  signal Rgb7       : channel;
  signal Rgb8       : channel;
  signal Rgb9       : channel;
  signal iAls       : coefficient;
begin 
  iAls.config       <= 1;
  iAls.k1           <= x"0000000F"; -- +1.875
  iAls.k2           <= x"000000FE"; -- -0.25
  iAls.k3           <= x"000000F3"; -- -0.375
  iAls.k4           <= x"000000F3"; -- -0.375
  iAls.k5           <= x"0000000F"; -- +1.875
  iAls.k6           <= x"000000FE"; -- -0.25
  iAls.k7           <= x"000000F3"; -- -0.375
  iAls.k8           <= x"000000FE"; -- -0.25
  iAls.k9           <= x"0000000F"; -- +1.875
hsvl_1range_nst: hsl_1range
generic map(
    i_data_width       => i_data_width)
port map(
    clk                => clk,
    reset              => reset,
    iRgb               => iRgb,
    oHsl               => Rgb1);
irgb_sync_frames_inst: sync_frames
generic map(
    pixelDelay => 9)
port map(
    clk        => clk,
    reset      => reset,
    iRgb       => iRgb,
    oRgb       => Rgb2);
process (clk) begin
    if rising_edge(clk) then
        Rgb3.red    <= to_sfixed("00" & Rgb1.red,Rgb3.red);
        Rgb3.green  <= to_sfixed("00" & Rgb1.green,Rgb3.green);
        Rgb3.blue   <= to_sfixed("00" & Rgb1.blue,Rgb3.blue);
        Rgb4.red    <= to_sfixed("00" & Rgb2.red,Rgb4.red);
        Rgb4.green  <= to_sfixed("00" & Rgb2.green,Rgb4.green);
        Rgb4.blue   <= to_sfixed("00" & Rgb2.blue,Rgb4.blue);
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        Rgb5.red   <= abs(Rgb4.red - Rgb3.red);
        Rgb5.green <= abs(Rgb4.green - Rgb3.green);
        Rgb5.blue  <= abs(Rgb4.blue - Rgb3.blue);
        Rgb6.red   <= resize(Rgb5.red,Rgb6.red);
        Rgb6.green <= resize(Rgb5.green,Rgb6.green);
        Rgb6.blue  <= resize(Rgb5.blue,Rgb6.blue);
    end if;
end process;
    -- rgb - hsl values
    Rgb7.red    <= std_logic_vector(Rgb6.red(i_data_width-1 downto 0));
    Rgb7.green  <= std_logic_vector(Rgb6.green(i_data_width-1 downto 0));
    Rgb7.blue   <= std_logic_vector(Rgb6.blue(i_data_width-1 downto 0));
    Rgb7.valid  <= Rgb1.valid;
color_correction_inst  : color_correction
generic map(
    i_k_config_number   => 0)
port map(
    clk            => clk,
    rst_l          => reset,
    iRgb           => Rgb7,
    als            => iAls,
    oRgb           => Rgb8);
d_valid_inst : d_valid
generic map (
    pixelDelay     => 1)
port map(
    clk            => clk,
    iRgb           => Rgb8,
    oRgb           => Rgb9);
sync_frames_inst  : sync_frames
generic map(
    pixelDelay     => 3)
port map(
    clk            => clk,
    reset          => reset,
    iRgb           => Rgb9,
    oRgb           => oRgb);
end behavioral;