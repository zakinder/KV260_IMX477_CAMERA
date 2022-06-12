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
    signal rAddressCnt   : natural range 0 to (img_width-1) := zero;
    signal ramWaddr      : natural range 0 to (img_width-1) := zero;
    
begin
process (clk,rst_l) begin
    if (rst_l = lo) then
        rAddressCnt  <= zero;
        ramWaddr     <= zero;
    elsif rising_edge(clk) then
        if ((valid = hi) and (rAddressCnt < (img_width-1))) then
            rAddressCnt  <= rAddressCnt + 1;
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
