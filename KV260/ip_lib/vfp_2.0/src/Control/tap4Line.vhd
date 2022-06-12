library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
entity tap4Line is
generic (
    img_width    : integer := 4095;
    tpDataWidth  : integer := 12);
port (
    clk          : in std_logic;
    rst_l        : in std_logic;
    write_en     : in std_logic;
    idata        : in std_logic_vector(tpDataWidth - 1 downto 0);
    read_en      : in std_logic;
    odata        : out std_logic_vector(tpDataWidth - 1 downto 0));
end entity;
architecture arch of tap4Line is
    type ram_type is array (0 to img_width-1) of std_logic_vector (tpDataWidth - 1 downto 0);
    signal rowbuffer     : ram_type := (others => (others => '0'));
    signal oregister     : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal i1register    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal i2register    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal i3register    : std_logic_vector(tpDataWidth - 1 downto 0) := (others => '0');
    signal write1s_enb   : std_logic;
    signal write2s_enb   : std_logic;
    signal write3s_enb   : std_logic;
    
    signal read_1s_enb   : std_logic;
    signal read_2s_enb   : std_logic;
    signal read_3s_enb   : std_logic;
    
    signal rAddres1Cnt   : natural range 0 to (img_width-1) := zero;
    signal rAddres2Cnt   : natural range 0 to (img_width-1) := zero;
    signal rAddres3Cnt   : natural range 0 to (img_width-1) := zero;
    signal rAddres4Cnt   : natural range 0 to (img_width-1) := zero;
    signal wAddres1Cnt   : natural range 0 to (img_width-1) := zero;
    signal wAddres2Cnt   : natural range 0 to (img_width-1) := zero;
    signal wAddres3Cnt   : natural range 0 to (img_width-1) := zero;
    signal wAddres4Cnt   : natural range 0 to (img_width-1) := zero;
    signal ramWaddr      : natural range 0 to (img_width-1) := zero;
    signal ram_Waddr     : natural range 0 to (img_width-1) := zero;
    signal ram2Waddr     : natural range 0 to (img_width-1) := zero;
    
begin


process (clk,rst_l) begin
    if (rst_l = lo) then
        rAddres1Cnt     <= zero;
        rAddres2Cnt     <= zero;
    elsif rising_edge(clk) then
        if ((read_en = hi) and (rAddres1Cnt < (img_width-1))) then
            rAddres1Cnt  <= rAddres1Cnt + 1;
        else
            rAddres1Cnt  <= zero;
        end if;
        rAddres2Cnt  <= rAddres1Cnt;
        rAddres3Cnt  <= rAddres2Cnt;
        rAddres4Cnt  <= rAddres3Cnt;
        read_1s_enb  <= read_en;
        read_2s_enb  <= read_1s_enb;
        read_3s_enb  <= read_2s_enb;
        
        
    end if;
end process;

process (clk,rst_l) begin
    if (rst_l = lo) then
        wAddres1Cnt  <= zero;
        wAddres2Cnt     <= zero;
    elsif rising_edge(clk) then
        if ((write_en = hi) and (wAddres1Cnt < (img_width-1))) then
            wAddres1Cnt  <= wAddres1Cnt + 1;
        else
            wAddres1Cnt  <= zero;
        end if;
        wAddres2Cnt  <= wAddres1Cnt;
        wAddres3Cnt  <= wAddres2Cnt;
    end if;
end process;


process (clk,rst_l) begin
    if (rst_l = lo) then
        write1s_enb  <= lo;
        write2s_enb  <= lo;
        write3s_enb  <= lo;
    elsif rising_edge(clk) then
        write1s_enb <= write_en;
        write2s_enb <= write1s_enb;
        write3s_enb <= write2s_enb;
        i1register   <= idata;
        i2register   <= i1register;
        i3register   <= i2register;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        if (write1s_enb = hi) then
            rowbuffer(wAddres2Cnt) <= i3register;
        end if;
    end if;
end process;
process (clk,rst_l) begin
    if (rst_l = lo) then
        oregister  <= (others => '0');
    elsif rising_edge(clk) then
        if (read_1s_enb = hi) then
            oregister <= rowbuffer(rAddres1Cnt);
        end if;    
    end if;
end process;
process (clk,rst_l) begin
    if (rst_l = lo) then
        odata  <= (others => '0');
    elsif rising_edge(clk) then
        --if (write3s_enb ='1') then
            odata <= oregister;
        --end if;
    end if;
end process;
end architecture;
