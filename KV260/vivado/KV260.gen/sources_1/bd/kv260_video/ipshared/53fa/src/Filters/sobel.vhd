library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
use work.vfp_pkg.all;
entity sobel is
generic (
    i_data_width   : integer := 8;
    img_width      : integer := 256);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    iRgb           : in channel;
    threshold      : in natural;
    oRgb           : out channel);
end entity;
architecture arch of sobel is
--GX
--[-1 +0 +1]
--[-2 +0 +2]
--[-1 +0 +1]
--ROW-1[-1 0 1]
signal Kernel_1_X : signed(i_data_width-1 downto 0) :=x"FF";
signal Kernel_2_X : signed(i_data_width-1 downto 0) :=x"00";
signal Kernel_3_X : signed(i_data_width-1 downto 0) :=x"01";
--ROW-2[-2 0 2]
signal Kernel_4_X : signed(i_data_width-1 downto 0) :=x"FE";
signal Kernel_5_X : signed(i_data_width-1 downto 0) :=x"00";
signal Kernel_6_X : signed(i_data_width-1 downto 0) :=x"02";
--ROW-3[-1 0 1]
signal Kernel_7_X : signed(i_data_width-1 downto 0) :=x"FF";
signal Kernel_8_X : signed(i_data_width-1 downto 0) :=x"00";
signal Kernel_9_X : signed(i_data_width-1 downto 0) :=x"01";
--GY
--[+1 +2 +1]
--[+0 +0 +0]
--[-1 -2 -1]
--ROW-1[+1 +2 +1]
signal Kernel_1_Y : signed(i_data_width-1 downto 0) :=x"01";
signal Kernel_2_Y : signed(i_data_width-1 downto 0) :=x"02";
signal Kernel_3_Y : signed(i_data_width-1 downto 0) :=x"01";
--ROW-2[+0 +0 +0]
signal Kernel_4_Y : signed(i_data_width-1 downto 0) :=x"00";
signal Kernel_5_Y : signed(i_data_width-1 downto 0) :=x"00";
signal Kernel_6_Y : signed(i_data_width-1 downto 0) :=x"00";
--ROW-3[-1 -2 -1]
signal Kernel_7_Y : signed(i_data_width-1 downto 0) :=x"FF";
signal Kernel_8_Y : signed(i_data_width-1 downto 0) :=x"FE";
signal Kernel_9_Y : signed(i_data_width-1 downto 0) :=x"FF";

    type detap is record
        vTap0x     : signed(29 downto 0);
        vTap1x     : signed(29 downto 0);
        vTap2x     : signed(29 downto 0);
    end record;
    type s_pixel is record
        m1         : signed (16 downto 0);
        m2         : signed (16 downto 0);
        m3         : signed (16 downto 0);
        mac        : signed (16 downto 0);
    end record;
    type presults is record
        pax        : signed (16 downto 0);
        pay        : signed (16 downto 0);
        mx         : signed (33 downto 0);
        my         : signed (33 downto 0);
        sxy        : signed (33 downto 0);
        sqr        : std_logic_vector (31 downto 0);
        sbo        : std_logic_vector (15 downto 0);
        sbof       : natural;
    end record;
    signal vTap0x        : std_logic_vector(29 downto 0);
    signal vTap1x        : std_logic_vector(29 downto 0);
    signal vTap2x        : std_logic_vector(29 downto 0);
    signal mac1X         : s_pixel;
    signal mac2X         : s_pixel;
    signal mac3X         : s_pixel;
    signal mac1Y         : s_pixel;
    signal mac2Y         : s_pixel;
    signal mac3Y         : s_pixel;
    signal sobel         : presults;
    signal tpd1          : detap;
    signal tpd2          : detap;
    signal tpd3          : detap;
    signal rgbSyncEol    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncSof    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncEof    : std_logic_vector(31 downto 0) := x"00000000";
    signal rgbSyncValid  : std_logic_vector(31 downto 0) := x"00000000";
---------------------------------------------------------------------------------
begin

process (clk) begin
    if rising_edge(clk) then
        rgbSyncValid(0)  <= iRgb.valid;
        for i in 0 to 30 loop
          rgbSyncValid(i+1)  <= rgbSyncValid(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEol(0)  <= iRgb.eol;
        for i in 0 to 30 loop
          rgbSyncEol(i+1)  <= rgbSyncEol(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncSof(0)  <= iRgb.sof;
        for i in 0 to 30 loop
          rgbSyncSof(i+1)  <= rgbSyncSof(i);
        end loop;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        rgbSyncEof(0)  <= iRgb.eof;
        for i in 0 to 30 loop
          rgbSyncEof(i+1)  <= rgbSyncEof(i);
        end loop;
    end if;
end process;
RGB_Inst: rgb_3taps
generic map(
    img_width       => img_width,
    tpDataWidth     => 30)
port map(
    clk             => clk,
    rst_l           => rst_l,
    iRgb            => iRgb,
    tpValid         => open,
    tp0             => vTap0x,
    tp1             => vTap1x,
    tp2             => vTap2x);
TAP_DELAY : process (clk, rst_l)
begin
  if rst_l = '0' then
    tpd1.vTap0x    <= (others => '0');
    tpd1.vTap1x    <= (others => '0');
    tpd1.vTap2x    <= (others => '0');
    tpd2.vTap0x    <= (others => '0');
    tpd2.vTap1x    <= (others => '0');
    tpd2.vTap2x    <= (others => '0'); 
    tpd3.vTap0x    <= (others => '0');
    tpd3.vTap1x    <= (others => '0');
    tpd3.vTap2x    <= (others => '0');
  elsif rising_edge(clk) then
    tpd1.vTap0x    <= signed(vTap0x);
    tpd1.vTap1x    <= signed(vTap1x);
    tpd1.vTap2x    <= signed(vTap2x);
    tpd2.vTap0x    <= tpd1.vTap0x;
    tpd2.vTap1x    <= tpd1.vTap1x;
    tpd2.vTap2x    <= tpd1.vTap2x;
    tpd3.vTap0x    <= tpd2.vTap0x;
    tpd3.vTap1x    <= tpd2.vTap1x;
    tpd3.vTap2x    <= tpd2.vTap2x;
  end if;
end process TAP_DELAY;
MAC_X_A : process (clk, rst_l) begin
  if rst_l = '0' then
      mac1X.m1    <= (others => '0');
      mac1X.m2    <= (others => '0');
      mac1X.m3    <= (others => '0');
      mac1X.mac   <= (others => '0');
  elsif rising_edge(clk) then
      mac1X.m1    <= (('0' & tpd1.vTap0x(9 downto 2)) * Kernel_9_X);
      mac1X.m2    <= (('0' & tpd2.vTap0x(9 downto 2)) * Kernel_8_X);
      mac1X.m3    <= (('0' & tpd3.vTap0x(9 downto 2)) * Kernel_7_X);
      mac1X.mac   <= mac1X.m1 + mac1X.m2 + mac1X.m3;
  end if;
end process MAC_X_A;
MAC_X_B : process (clk, rst_l) begin
  if rst_l = '0' then
      mac2X.m1    <= (others => '0');
      mac2X.m2    <= (others => '0');
      mac2X.m3    <= (others => '0');
      mac2X.mac   <= (others => '0');
  elsif rising_edge(clk) then
      mac2X.m1    <= (('0' & tpd1.vTap1x(9 downto 2)) * Kernel_6_X);
      mac2X.m2    <= (('0' & tpd2.vTap1x(9 downto 2)) * Kernel_5_X);
      mac2X.m3    <= (('0' & tpd3.vTap1x(9 downto 2)) * Kernel_4_X);
      mac2X.mac   <= mac2X.m1 + mac2X.m2 + mac2X.m3;
  end if;
end process MAC_X_B;
MAC_X_C : process (clk, rst_l) begin
  if rst_l = '0' then
      mac3X.m1    <= (others => '0');
      mac3X.m2    <= (others => '0');
      mac3X.m3    <= (others => '0');
      mac3X.mac   <= (others => '0');
  elsif rising_edge(clk) then
      mac3X.m1    <= (('0' & tpd1.vTap2x(9 downto 2)) * Kernel_3_X);
      mac3X.m2    <= (('0' & tpd2.vTap2x(9 downto 2)) * Kernel_2_X);
      mac3X.m3    <= (('0' & tpd3.vTap2x(9 downto 2)) * Kernel_1_X);
      mac3X.mac   <= mac3X.m1 + mac3X.m2 + mac3X.m3;
  end if;
end process MAC_X_C;
MAC_Y_A : process (clk, rst_l) begin
  if rst_l = '0' then
      mac1Y.m1    <= (others => '0');
      mac1Y.m2    <= (others => '0');
      mac1Y.m3    <= (others => '0');
      mac1Y.mac   <= (others => '0');
  elsif rising_edge(clk) then
      mac1Y.m1    <= (('0' & tpd1.vTap0x(9 downto 2)) * Kernel_9_Y);
      mac1Y.m2    <= (('0' & tpd2.vTap0x(9 downto 2)) * Kernel_8_Y);
      mac1Y.m3    <= (('0' & tpd3.vTap0x(9 downto 2)) * Kernel_7_Y);
      mac1Y.mac   <= mac1Y.m1 + mac1Y.m2 + mac1Y.m3;
  end if;
end process MAC_Y_A;
MAC_Y_B : process (clk, rst_l) begin
  if rst_l = '0' then
      mac2Y.m1    <= (others => '0');
      mac2Y.m2    <= (others => '0');
      mac2Y.m3    <= (others => '0');
      mac2Y.mac   <= (others => '0');
  elsif rising_edge(clk) then
      mac2Y.m1    <= (('0' & tpd1.vTap1x(9 downto 2)) * Kernel_6_Y);
      mac2Y.m2    <= (('0' & tpd2.vTap1x(9 downto 2)) * Kernel_5_Y);
      mac2Y.m3    <= (('0' & tpd3.vTap1x(9 downto 2)) * Kernel_4_Y);
      mac2Y.mac   <= mac2Y.m1 + mac2Y.m2 + mac2Y.m3;
  end if;
end process MAC_Y_B;
MAC_Y_C : process (clk, rst_l) begin
  if rst_l = '0' then
      mac3Y.m1    <= (others => '0');
      mac3Y.m2    <= (others => '0');
      mac3Y.m3    <= (others => '0');
      mac3Y.mac   <= (others => '0');
  elsif rising_edge(clk) then
      mac3Y.m1    <= (('0' & tpd1.vTap2x(9 downto 2)) * Kernel_3_Y);
      mac3Y.m2    <= (('0' & tpd2.vTap2x(9 downto 2)) * Kernel_2_Y);
      mac3Y.m3    <= (('0' & tpd3.vTap2x(9 downto 2)) * Kernel_1_Y);
      mac3Y.mac   <= mac3Y.m1 + mac3Y.m2 + mac3Y.m3;
  end if;
end process MAC_Y_C;
PA_X : process (clk, rst_l) begin
  if rst_l = '0' then
      sobel.pax <= (others => '0');
  elsif rising_edge(clk) then
      sobel.pax <= mac1X.mac + mac2X.mac + mac3X.mac;
  end if;
end process PA_X;
PA_Y : process (clk, rst_l) begin
  if rst_l = '0' then
      sobel.pay <= (others => '0');
  elsif rising_edge(clk) then
      sobel.pay <= mac1Y.mac + mac2Y.mac + mac3Y.mac;
  end if;
end process PA_Y;
GX : process (clk, rst_l) begin
  if rst_l = '0' then
      sobel.mx <= (others => '0');
  elsif rising_edge(clk) then
      sobel.mx <= (sobel.pax * sobel.pax);
  end if;
end process GX;
GY : process (clk, rst_l) begin
  if rst_l = '0' then
      sobel.my <= (others => '0');
  elsif rising_edge(clk) then
      sobel.my <= (sobel.pay * sobel.pay);
  end if;
end process GY;
GS : process (clk, rst_l) begin
  if rst_l = '0' then
      sobel.sxy <= (others => '0');
  elsif rising_edge(clk) then
      sobel.sxy <= (sobel.mx + sobel.my);
  end if;
end process GS;
SQROOT : process (clk, rst_l) begin
  if rst_l = '0' then
      sobel.sqr <=(others => '0');
  elsif rising_edge(clk) then
      sobel.sqr    <= std_logic_vector(sobel.sxy(31 downto 0));
  end if;
end process SQROOT;
mod6_1_2_inst: square_root
generic map(
    data_width        => 32)
port map(
   clock              => clk,
   rst_l              => rst_l,
   data_in            => sobel.sqr,
   data_out           => sobel.sbo);
sobel.sbof            <= to_integer((unsigned(sobel.sbo(15 downto 0))));
process (clk, rst_l) begin
  if rst_l = '0' then
      oRgb.red   <= (others => '0');
      oRgb.green <= (others => '0');
      oRgb.blue  <= (others => '0');
  elsif rising_edge(clk) then
      if (sobel.sbof > threshold) then
        oRgb.red   <= (others => '0');
        oRgb.green <= (others => '0');
        oRgb.blue  <= (others => '0');
      else
        oRgb.red   <= (others => '1');
        oRgb.green <= (others => '1');
        oRgb.blue  <= (others => '1');
      end if;
  end if;
end process;
    oRgb.valid <= rgbSyncValid(24);
    oRgb.eol   <= rgbSyncEol(24);
    oRgb.sof   <= rgbSyncSof(24);
    oRgb.eof   <= rgbSyncEof(24);
end architecture;