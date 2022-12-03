library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity taps_controller is
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
    tp2         : out std_logic_vector(tpDataWidth - 1 downto 0));
end entity;
architecture arch of taps_controller is
    signal tap0_data   : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal tap1_data   : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal d2RGB       : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal rgbPixel    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
begin
process (clk,rst_l) begin
    if (rst_l = lo) then
        tp0      <= (others => '0');
        tp1      <= (others => '0');
        tp2      <= (others => '0');
        tpValid  <= lo;
    elsif rising_edge(clk) then 
        tp0      <= d2RGB; 
        tp1      <= tap0_data; 
        tp2      <= tap1_data;
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
        if (iRgb.valid = hi) then
            rgbPixel      <= iRgb.green;
        end if;
        d2RGB <= rgbPixel;
    end if; 
end process;
end generate TPDATAWIDTH1_ENABLED;
TPDATAWIDTH3_ENABLED: if (tpDataWidth = 24) generate
begin
process (clk,rst_l) begin
    if (rst_l = lo) then
        rgbPixel <= (others => '0');
        d2RGB    <= (others => '0');
    elsif rising_edge(clk) then 
        if (iRgb.valid = hi) then
            rgbPixel     <= iRgb.red & iRgb.green & iRgb.blue;
        end if;
        d2RGB <= rgbPixel;
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
    idata       => d2RGB,
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
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
entity tapLine is
generic (
    img_width    : integer := 4095;
    tpDataWidth  : integer := 12);
port (
    clk          : in std_logic;
    rst_l        : in std_logic;
    valid        : in std_logic;
    idata        : in std_logic_vector(tpDataWidth - 1 downto 0);
    odata        : out std_logic_vector(tpDataWidth - 1 downto 0));
end entity;
architecture arch of tapLine is
    type ram_type is array (0 to img_width-1) of std_logic_vector (tpDataWidth - 1 downto 0);
    signal rowbuffer     : ram_type := (others => (others => '0'));
    signal oregister     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal write1s_enb   : std_logic;
    signal write2s_enb   : std_logic;
    signal write3s_enb   : std_logic;  
    signal rAddressCnt   : integer := zero;
    signal ramWaddr      : integer := zero;
begin
process (clk,rst_l) begin
    if (rst_l = lo) then
        rAddressCnt  <= zero;
        ramWaddr     <= zero;
    elsif rising_edge(clk) then 
        if (valid = hi) then
            if(rAddressCnt < img_width-1)then
                rAddressCnt  <= rAddressCnt + 1;
            end if;
        else
            rAddressCnt  <= zero;
        end if;
        ramWaddr <= rAddressCnt;
    end if; 
end process;
process (clk,rst_l) begin
    if (rst_l = lo) then
        write1s_enb  <= lo;
        write2s_enb  <= lo;
        write3s_enb  <= lo;
    elsif rising_edge(clk) then 
        write1s_enb <= valid;
        write2s_enb <= write1s_enb;
        write3s_enb <= write2s_enb;
    end if; 
end process;
process (clk) begin
    if rising_edge(clk) then
        rowbuffer(ramWaddr) <= idata;
    end if;
end process;
process (clk,rst_l) begin
    if (rst_l = lo) then
        oregister  <= (others => '0');
    elsif rising_edge(clk) then 
        oregister <= rowbuffer(rAddressCnt);
    end if; 
end process;
process (clk,rst_l) begin
    if (rst_l = lo) then
        odata  <= (others => '0');
    elsif rising_edge(clk) then 
        if (write3s_enb ='1') then
            odata <= oregister;
        end if;
    end if; 
end process;
end architecture;