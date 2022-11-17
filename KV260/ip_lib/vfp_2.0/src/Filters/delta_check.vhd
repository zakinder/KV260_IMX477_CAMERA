library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity delta_check is
    port (
        clk            : in std_logic;
        rst            : in std_logic;
        iRGB           : in channel;
        iHue           : in channel;
        oRGB           : out channel);
end delta_check;
architecture arch_imp of delta_check is
    signal rgbSyncValid             : std_logic_vector(23 downto 0) := x"000000";
    signal rgbSyncEol               : std_logic_vector(23 downto 0) := x"000000";
    signal rgbSyncSof               : std_logic_vector(23 downto 0) := x"000000";
    signal rgbSyncEof               : std_logic_vector(23 downto 0) := x"000000";
    signal iHue_n1                  : intChannel;
    signal iHue_n2                  : intChannel;
    signal sRGB                     : channel;
    signal s2RGB                     : channel;
    signal store_red                : std_logic_vector(9 downto 0);
    signal store_gre                : std_logic_vector(9 downto 0);
    signal store_blu                : std_logic_vector(9 downto 0);
    
begin
process (clk)begin
    if rising_edge(clk) then
      rgbSyncValid(0)   <= sRGB.valid;
      rgbSyncValid(1)   <= rgbSyncValid(0);
      rgbSyncValid(2)   <= rgbSyncValid(1);
      rgbSyncValid(3)   <= rgbSyncValid(2);
      rgbSyncValid(4)   <= rgbSyncValid(3);
      rgbSyncValid(5)   <= rgbSyncValid(4);
      rgbSyncValid(6)   <= rgbSyncValid(5);
      rgbSyncValid(7)   <= rgbSyncValid(6);
      rgbSyncValid(8)   <= rgbSyncValid(7);
      rgbSyncValid(9)   <= rgbSyncValid(8);
      rgbSyncValid(10)  <= rgbSyncValid(9);
      rgbSyncValid(11)  <= rgbSyncValid(10);
      rgbSyncValid(12)  <= rgbSyncValid(11);
      rgbSyncValid(13)  <= rgbSyncValid(12);
      rgbSyncValid(14)  <= rgbSyncValid(13);
      rgbSyncValid(15)  <= rgbSyncValid(14);
      rgbSyncValid(16)  <= rgbSyncValid(15);
      rgbSyncValid(17)  <= rgbSyncValid(16);
      rgbSyncValid(18)  <= rgbSyncValid(17);
      rgbSyncValid(19)  <= rgbSyncValid(18);
      rgbSyncValid(20)  <= rgbSyncValid(19);
      rgbSyncValid(21)  <= rgbSyncValid(20);
      rgbSyncValid(22)  <= rgbSyncValid(21);
      rgbSyncValid(23)  <= rgbSyncValid(22);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEol(0)   <= sRGB.eol;
      rgbSyncEol(1)   <= rgbSyncEol(0);
      rgbSyncEol(2)   <= rgbSyncEol(1);
      rgbSyncEol(3)   <= rgbSyncEol(2);
      rgbSyncEol(4)   <= rgbSyncEol(3);
      rgbSyncEol(5)   <= rgbSyncEol(4);
      rgbSyncEol(6)   <= rgbSyncEol(5);
      rgbSyncEol(7)   <= rgbSyncEol(6);
      rgbSyncEol(8)   <= rgbSyncEol(7);
      rgbSyncEol(9)   <= rgbSyncEol(8);
      rgbSyncEol(10)  <= rgbSyncEol(9);
      rgbSyncEol(11)  <= rgbSyncEol(10);
      rgbSyncEol(12)  <= rgbSyncEol(11);
      rgbSyncEol(13)  <= rgbSyncEol(12);
      rgbSyncEol(14)  <= rgbSyncEol(13);
      rgbSyncEol(15)  <= rgbSyncEol(14);
      rgbSyncEol(16)  <= rgbSyncEol(15);
      rgbSyncEol(17)  <= rgbSyncEol(16);
      rgbSyncEol(18)  <= rgbSyncEol(17);
      rgbSyncEol(19)  <= rgbSyncEol(18);
      rgbSyncEol(20)  <= rgbSyncEol(19);
      rgbSyncEol(21)  <= rgbSyncEol(20);
      rgbSyncEol(22)  <= rgbSyncEol(21);
      rgbSyncEol(23)  <= rgbSyncEol(22);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncSof(0)   <= sRGB.sof;
      rgbSyncSof(1)   <= rgbSyncSof(0);
      rgbSyncSof(2)   <= rgbSyncSof(1);
      rgbSyncSof(3)   <= rgbSyncSof(2);
      rgbSyncSof(4)   <= rgbSyncSof(3);
      rgbSyncSof(5)   <= rgbSyncSof(4);
      rgbSyncSof(6)   <= rgbSyncSof(5);
      rgbSyncSof(7)   <= rgbSyncSof(6);
      rgbSyncSof(8)   <= rgbSyncSof(7);
      rgbSyncSof(9)   <= rgbSyncSof(8);
      rgbSyncSof(10)  <= rgbSyncSof(9);
      rgbSyncSof(11)  <= rgbSyncSof(10);
      rgbSyncSof(12)  <= rgbSyncSof(11);
      rgbSyncSof(13)  <= rgbSyncSof(12);
      rgbSyncSof(14)  <= rgbSyncSof(13);
      rgbSyncSof(15)  <= rgbSyncSof(14);
      rgbSyncSof(16)  <= rgbSyncSof(15);
      rgbSyncSof(17)  <= rgbSyncSof(16);
      rgbSyncSof(18)  <= rgbSyncSof(17);
      rgbSyncSof(19)  <= rgbSyncSof(18);
      rgbSyncSof(20)  <= rgbSyncSof(19);
      rgbSyncSof(21)  <= rgbSyncSof(20);
      rgbSyncSof(22)  <= rgbSyncSof(21);
      rgbSyncSof(23)  <= rgbSyncSof(22);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEof(0)   <= sRGB.eof;
      rgbSyncEof(1)   <= rgbSyncEof(0);
      rgbSyncEof(2)   <= rgbSyncEof(1);
      rgbSyncEof(3)   <= rgbSyncEof(2);
      rgbSyncEof(4)   <= rgbSyncEof(3);
      rgbSyncEof(5)   <= rgbSyncEof(4);
      rgbSyncEof(6)   <= rgbSyncEof(5);
      rgbSyncEof(7)   <= rgbSyncEof(6);
      rgbSyncEof(8)   <= rgbSyncEof(7);
      rgbSyncEof(9)   <= rgbSyncEof(8);
      rgbSyncEof(10)  <= rgbSyncEof(9);
      rgbSyncEof(11)  <= rgbSyncEof(10);
      rgbSyncEof(12)  <= rgbSyncEof(11);
      rgbSyncEof(13)  <= rgbSyncEof(12);
      rgbSyncEof(14)  <= rgbSyncEof(13);
      rgbSyncEof(15)  <= rgbSyncEof(14);
      rgbSyncEof(16)  <= rgbSyncEof(15);
      rgbSyncEof(17)  <= rgbSyncEof(16);
      rgbSyncEof(18)  <= rgbSyncEof(17);
      rgbSyncEof(19)  <= rgbSyncEof(18);
      rgbSyncEof(20)  <= rgbSyncEof(19);
      rgbSyncEof(21)  <= rgbSyncEof(20);
      rgbSyncEof(22)  <= rgbSyncEof(21);
      rgbSyncEof(23)  <= rgbSyncEof(22);
    end if;
end process;


delta1_syncr_inst  : sync_frames
generic map(
    pixelDelay      => 60)
port map(
    clk             => clk,
    reset           => rst,
    iRgb            => iRGB,
    oRgb            => sRGB);
delta2_syncr_inst  : sync_frames
generic map(
    pixelDelay      => 56)
port map(
    clk             => clk,
    reset           => rst,
    iRgb            => iRGB,
    oRgb            => s2RGB);
    
    
process (clk) begin
    if rising_edge(clk) then
        if (iRgb.eol = '1') then
          iHue_n1.red      <= 255;
          iHue_n1.green    <= 255;
          iHue_n1.blue     <= 255;
        else
          iHue_n1.red      <= to_integer(unsigned(iHue.red));
          iHue_n1.green    <= to_integer(unsigned(iHue.green));
          iHue_n1.blue     <= to_integer(unsigned(iHue.blue));
        end if;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
          iHue_n2          <= iHue_n1;
    end if;
end process;


process (clk) begin
    if rising_edge(clk) then
        if(abs(iHue_n2.red - iHue_n1.red) > 0) then
            store_red <= "00" & s2RGB.red(9 downto 2);
            store_gre <= "00" & s2RGB.green(9 downto 2);
            store_blu <= "00" & s2RGB.blue(9 downto 2);
        end if;
    end if;
end process;



process (clk) begin
    if rising_edge(clk) then
        if (abs(iHue_n2.red - iHue_n1.red) = 0) then
            oRGB.red   <= store_red;
            oRGB.green <= store_gre;
            oRGB.blue  <= store_blu;
        else
            oRGB.red   <= "00" & sRGB.red(9 downto 2);
            oRGB.green <= "00" & sRGB.green(9 downto 2);
            oRGB.blue  <= "00" & sRGB.blue(9 downto 2);
        end if;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        oRGB.valid   <= sRGB.valid;
        oRGB.eol     <= sRGB.eol;
        oRGB.eof     <= sRGB.eof;
        oRGB.sof     <= sRGB.sof;
    end if;
end process;

end arch_imp;

