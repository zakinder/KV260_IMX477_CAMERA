library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants_package.all;
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;
use work.tb_pkg.all;
entity image_read_axi4_stream_interface is
generic (
    enImageText   : boolean := false;
    enImageIndex  : boolean := false;
    i_data_width  : integer := 8;
    test          : string  := "folder";
    input_file    : string  := "input_image";
    output_file   : string  := "output_image");
port (
    clk                : in  std_logic;
    reset              : in  std_logic;
    tdata              : out std_logic_vector(31 downto 0);
    tstrb              : out std_logic_vector(3 downto 0);
    tkeep              : out std_logic_vector(3 downto 0);
    tlast              : out std_logic;
    tuser              : out std_logic;
    tvalid             : out std_logic);
end image_read_axi4_stream_interface;

architecture Behavioral of image_read_axi4_stream_interface is 

    constant FRAME_WIDTH                  : natural    := 128;
    constant FRAME_HEIGHT                 : natural    := 128;
    signal crd4xy                         : cord;
    signal crd1xy                         : cord;
    signal crd2xy                         : cord;
    signal crd3xy                         : cord;
    
    
    signal tx_crd                         : coord;
    signal tvalid_syn                     : std_logic;
    signal rgb1Read                       : channel;
    signal rgb2Read                       : channel;
    signal rgb3Read                       : channel;
    signal rgb4Read                       : channel;
    
    
    type video_io_state is (VIDEO_SET_RESET,VIDEO_SOF_OFF,VIDEO_SOF_ON);
    signal VIDEO_STATES      : video_io_state;


begin 



process (clk) begin
    if (rising_edge (clk)) then
        if (reset = '0') then
            VIDEO_STATES <= VIDEO_SET_RESET;
        else
        case (VIDEO_STATES) is
        when VIDEO_SET_RESET =>
            VIDEO_STATES     <= VIDEO_SOF_OFF;
        when VIDEO_SOF_OFF =>


            if (crd1xy.x  = 1 and crd1xy.y = 0) then
                tuser        <= '1';
                VIDEO_STATES <= VIDEO_SOF_ON;
            else
                VIDEO_STATES <= VIDEO_SOF_OFF;
            end if;
        when VIDEO_SOF_ON =>
            if (crd1xy.x  = 2 and crd1xy.y = 0) then
                tuser        <= '1';
            else
                tuser        <= '0';
            end if;
            tdata            <=  ("00" & rgb4Read.red & rgb4Read.green &  rgb4Read.blue);
            
            if (crd1xy.x  = FRAME_WIDTH-1 and crd1xy.y = FRAME_HEIGHT-1) then
                VIDEO_STATES     <= VIDEO_SOF_OFF;
            else
                VIDEO_STATES     <= VIDEO_SOF_ON;
            end if;
        when others =>
            VIDEO_STATES <= VIDEO_SET_RESET;
        end case;
        end if;
    end if;
end process;



image_read_inst: read_image
generic map (
    enImageText           => false,
    enImageIndex          => false,
    i_data_width          => 10,
    test                  => test,
    input_file            => readbmp,
    output_file           => "output_image")
port map (                  
    pixclk                => clk,
    oCord                 => tx_crd,
    oRgb                  => rgb1Read);

crd1xy.x      <= to_integer((unsigned(tx_crd.x)));
crd1xy.y      <= to_integer((unsigned(tx_crd.y)));

process (clk) begin
    if rising_edge(clk) then
        rgb2Read       <= rgb1Read;
        rgb3Read       <= rgb2Read;
        rgb4Read       <= rgb3Read;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        crd2xy       <= crd1xy;
        crd3xy       <= crd2xy;
        crd4xy       <= crd3xy;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        tvalid_syn       <= rgb4Read.valid;
    end if;
end process;
tlast            <= '1' when (crd4xy.x = FRAME_WIDTH-1) else '0';
tvalid           <= tvalid_syn;
tstrb            <= "0000";
tkeep            <= "1111";
end Behavioral;