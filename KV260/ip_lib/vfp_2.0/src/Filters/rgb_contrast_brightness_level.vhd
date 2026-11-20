-------------------------------------------------------------------------------
--
-- Filename    : rgb_contrast_brightness_level_1.vhd
-- Create Date : 05022019 [05-02-2019]
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
entity rgb_contrast_brightness_level is
  port (
    clk       : in std_logic;
    rst_l     : in std_logic;
    contrast  : in integer;
    iRgb      : in channel;
    oRgb      : out channel);
end rgb_contrast_brightness_level;
architecture Behavioral of rgb_contrast_brightness_level is
  signal rgbSyncValid           : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncEol             : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncSof             : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncEof             : std_logic_vector(11 downto 0) := x"000";
  signal rgb1_crt               : contrast1_channel;
  signal rgb2_crt               : contrast1_channel;
  signal rgb3_crt               : contrast2_channel;
  signal rgb4_crt               : contrast1_channel;
  signal rgb5_crt               : contrast1_channel;
  -- Split the constant division into byte-indexed ROMs. Each entry is
  -- floor(byte * weight / 5) modulo 2^17 plus its Euclidean remainder.
  type coefficient_part is record
    q : unsigned(16 downto 0);
    r : natural range 0 to 4;
  end record;
  type coefficient_table is array (0 to 255) of coefficient_part;
  function make_table(weight : positive; signed_byte : boolean)
    return coefficient_table is
    variable t : coefficient_table;
    variable n, rem5 : integer;
  begin
    for i in t'range loop
      n := i;
      if signed_byte and i >= 128 then n := i - 256; end if;
      n := n * weight;
      rem5 := n mod 5;
      t(i).q := to_unsigned(((n-rem5)/5) mod 131072, 17);
      t(i).r := rem5;
    end loop;
    return t;
  end function;
  constant lo_table : coefficient_table := make_table(128,false);
  constant mid_table : coefficient_table := make_table(32768,false);
  constant hi_table : coefficient_table := make_table(8388608,true);
  signal lo, mid, hi : coefficient_part;
  signal q_lo_mid : unsigned(17 downto 0);
  signal rem_lo_mid : natural range 0 to 12;
  signal q_hi_stage : unsigned(16 downto 0);
  signal rem_hi_stage : natural range 0 to 4;
  signal rounding : natural range 0 to 4;
  signal rgb2_delay : contrast1_channel;
  signal contrast_val_sign      : signed(16 downto 0);
  signal contrast_constant_val1 : signed(15 downto 0):= x"8000";--32768=256*128
  signal contrast_constant_val2 : signed(15 downto 0):= x"0080";--128
begin
--((((((rgb*256-128*256)*(contrast/10*256))+128*256))/256)/256+128
process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= iRgb.valid;
        for i in 0 to 10 loop
          rgbSyncValid(i+1)  <= rgbSyncValid(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEol(0)  <= iRgb.eol;
        for i in 0 to 10 loop
          rgbSyncEol(i+1)  <= rgbSyncEol(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncSof(0)  <= iRgb.sof;
        for i in 0 to 10 loop
          rgbSyncSof(i+1)  <= rgbSyncSof(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEof(0)  <= iRgb.eof;
        for i in 0 to 10 loop
          rgbSyncEof(i+1)  <= rgbSyncEof(i);
        end loop;
    end if;
end process;
-- red = alpha(red-128)+128+b
process(clk)
    variable bits : signed(23 downto 0);
    variable carry : natural range 0 to 4;
begin
    if rising_edge(clk) then
        -- The original integer product contrast*256 fits for signed 24-bit inputs.
        bits := to_signed(contrast,24);
        lo <= lo_table(to_integer(unsigned(bits(7 downto 0))));
        mid <= mid_table(to_integer(unsigned(bits(15 downto 8))));
        hi <= hi_table(to_integer(unsigned(bits(23 downto 16))));
        if bits(23)='1' then rounding<=4; else rounding<=0; end if;

        -- Register the low and middle table sums before combining the high byte.
        q_lo_mid <= resize(lo.q,18) + resize(mid.q,18);
        rem_lo_mid <= lo.r + mid.r + rounding;
        q_hi_stage <= hi.q;
        rem_hi_stage <= hi.r;

        -- The quotient remains modulo 2^17, matching the original coefficient.
        carry := (rem_lo_mid + rem_hi_stage) / 5;
        contrast_val_sign <= signed(
            q_lo_mid(16 downto 0) + q_hi_stage + to_unsigned(carry,17));
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        rgb1_crt.red    <= signed('0' & iRgb.red(9 downto 2) & x"00");
        rgb1_crt.green  <= signed('0' & iRgb.green(9 downto 2) & x"00");
        rgb1_crt.blue   <= signed('0' & iRgb.blue(9 downto 2) & x"00");
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        rgb2_crt.red    <= (rgb1_crt.red + contrast_constant_val1);
        rgb2_crt.green  <= (rgb1_crt.green + contrast_constant_val1);
        rgb2_crt.blue   <= (rgb1_crt.blue + contrast_constant_val1);
        rgb2_delay      <= rgb2_crt;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        rgb3_crt.red    <= (rgb2_delay.red * contrast_val_sign) + contrast_constant_val1;
        rgb3_crt.green  <= (rgb2_delay.green * contrast_val_sign) + contrast_constant_val1;
        rgb3_crt.blue   <= (rgb2_delay.blue * contrast_val_sign) + contrast_constant_val1;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        rgb4_crt.red    <= rgb3_crt.red(32 downto 16);
        rgb4_crt.green  <= rgb3_crt.green(32 downto 16);
        rgb4_crt.blue   <= rgb3_crt.blue(32 downto 16);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        rgb5_crt.red    <= shift_right(rgb4_crt.red,1) + contrast_constant_val2;
        rgb5_crt.green  <= shift_right(rgb4_crt.green,1) + contrast_constant_val2;
        rgb5_crt.blue   <= shift_right(rgb4_crt.blue,1) + contrast_constant_val2;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        if(rgb5_crt.red(16) = '1')then
            oRgb.red    <= (others => '0');
        elsif(rgb5_crt.red(8) = '1')then
            oRgb.red    <= (others => '1');
        else
            oRgb.red    <= std_logic_vector(rgb5_crt.red(7 downto 0)) & "00";
        end if;
        if(rgb5_crt.green(16) = '1')then
            oRgb.green    <= (others => '0');
        elsif(rgb5_crt.green(8) = '1')then
            oRgb.green    <= (others => '1');
        else
            oRgb.green    <= std_logic_vector(rgb5_crt.green(7 downto 0)) & "00";
        end if;
        if(rgb5_crt.blue(16) = '1')then
            oRgb.blue    <= (others => '0');
        elsif(rgb5_crt.blue(8) = '1')then
            oRgb.blue    <= (others => '1');
        else
            oRgb.blue    <= std_logic_vector(rgb5_crt.blue(7 downto 0)) & "00";
        end if;
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
        oRgb.eol     <= rgbSyncEol(8);
        oRgb.sof     <= rgbSyncSof(8);
        oRgb.eof     <= rgbSyncEof(8);
        oRgb.valid   <= rgbSyncValid(8);
    end if;
end process;
end Behavioral;