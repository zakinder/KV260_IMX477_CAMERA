library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;

entity rgb_4taps is
generic (
    img_width     : integer := 4096;
    tpDataWidth   : integer := 8);
port (
    clk         : in std_logic;
    rst_l       : in std_logic;
    iRgb        : in channel;
    tpValid     : out std_logic;
    tp0         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp1         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp2         : out std_logic_vector(tpDataWidth - 1 downto 0);
    tp3         : out std_logic_vector(tpDataWidth - 1 downto 0));
end entity;
architecture arch of rgb_4taps is
    signal tap0_data   : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap1_data   : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap2_data   : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d2RGB       : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d3RGB       : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d4RGB       : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d2RGB1Valid : std_logic := lo;
    signal d2RGB2Valid : std_logic := lo;
    signal d2RGB3Valid : std_logic := lo;
begin
process (clk,rst_l) begin
    if (rst_l = lo) then
        tp0      <= (others => '0');
        tp1      <= (others => '0');
        tp2      <= (others => '0');
        tp3      <= (others => '0');
        tpValid  <= lo;
    elsif rising_edge(clk) then
        tp0      <= d2RGB;
        tp1      <= tap0_data;
        tp2      <= tap1_data;
        tp3      <= tap2_data;
        tpValid  <= iRgb.valid;
    end if;
end process;
TPDATAWIDTH1_ENABLED: if (tpDataWidth = 8) generate
begin
process (clk,rst_l) begin
    if (rst_l = lo) then
        rgbPixel <= (others => '0');
        d2RGB    <= (others => '0');
    elsif rising_edge(clk) then
        d2RGB       <= rgbPixel;
        d2RGB1Valid <= iRgb.valid;
        d2RGB2Valid <= d2RGB1Valid;
        d2RGB3Valid <= d2RGB2Valid;
    end if;
end process;
    rgbPixel      <= iRgb.green;
end generate TPDATAWIDTH1_ENABLED;
TPDATAWIDTH3_ENABLED: if (tpDataWidth = 24) generate
begin
process (clk,rst_l) begin
    if (rst_l = lo) then
        d2RGB    <= (others => '0');
        rgbPixel    <= (others => '0');
    elsif rising_edge(clk) then
        if (iRgb.valid = hi) then
            rgbPixel     <= iRgb.red & iRgb.green & iRgb.blue;
        else
            rgbPixel    <= (others => '0');
        end if;
        d2RGB       <= rgbPixel;
        d3RGB       <= d2RGB;
        d4RGB       <= d3RGB;
        d2RGB1Valid <= iRgb.valid;
        d2RGB2Valid <= d2RGB1Valid;
        d2RGB3Valid <= d2RGB2Valid;
    end if;
end process;

end generate TPDATAWIDTH3_ENABLED;


tapLineD0: tapLine
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    valid       => iRgb.valid,
    idata       => d4RGB,
    odata       => tap0_data);
tapLineD1: tapLine
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    valid       => iRgb.valid,
    idata       => tap0_data,
    odata       => tap1_data);
tapLineD2: tapLine
generic map(
    img_width   => img_width,
    tpDataWidth => tpDataWidth)
port map(
    clk         => clk,
    rst_l       => rst_l,
    valid       => iRgb.valid,
    idata       => tap1_data,
    odata       => tap2_data);
end architecture;