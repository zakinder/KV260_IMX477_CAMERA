library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants_package.all;
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;

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
    tdata              : out std_logic_vector(23 downto 0);
    tstrb              : out std_logic_vector(2 downto 0);
    tkeep              : out std_logic_vector(2 downto 0);
    tlast              : out std_logic;
    tuser              : out std_logic;
    tvalid             : out std_logic);
end image_read_axi4_stream_interface;

architecture Behavioral of image_read_axi4_stream_interface is 


    signal crd_xy                        : cord;
    signal tx_crd                       : coord;
    signal rgbRead                       : channel;
    
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
            tstrb            <= "000";
            tkeep            <= "111";
            tvalid           <= '0';
            if (crd_xy.x  = 1 and crd_xy.y = 0) then
                tuser        <= '1';
                VIDEO_STATES <= VIDEO_SOF_ON;
            else
                VIDEO_STATES <= VIDEO_SOF_OFF;
            end if;
        when VIDEO_SOF_ON =>
            if (crd_xy.x  = 2 and crd_xy.y = 0) then
                tuser        <= '1';
            else
                tuser        <= '0';
            end if;
            tdata            <=  (rgbRead.red & rgbRead.green &  rgbRead.blue)
            tvalid           <= '1';
            if (crd_xy.x  = 1279 and crd_xy.y = 719) then
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
    i_data_width          => 8,
    test                  => testFolder,
    input_file            => readbmp,
    output_file           => "output_image")
port map (                  
    pixclk                => clk,
    oCord                 => tx_crd,
    oRgb                  => rgbRead);

crd_xy.x      <= to_integer((unsigned(tx_crd.x)));
crd_xy.y      <= to_integer((unsigned(tx_crd.y)));




end Behavioral;