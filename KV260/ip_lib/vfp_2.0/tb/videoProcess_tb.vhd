
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
use work.tb_pkg.all;
use work.vfp_pkg.all;

entity video_process_tb is
end video_process_tb;
architecture behavioral of video_process_tb is

component vfp_v1_0
generic (
        revision_number           : std_logic_vector(31 downto 0) := x"05202022";
        C_vfpConfig_DATA_WIDTH    : integer    := 32;
        C_vfpConfig_ADDR_WIDTH    : integer    := 8;
        C_oVideo_TDATA_WIDTH      : integer    := 32;
        C_oVideo_START_COUNT      : integer    := 32;
        C_iVideo_TDATA_WIDTH      : integer    := 32;
        FRAME_PIXEL_DEPTH         : integer    := 10;
        FRAME_WIDTH               : natural    := 1280;
        FRAME_HEIGHT              : natural    := 720);
port (
        vfpconfig_aclk            : in std_logic;
        vfpconfig_aresetn         : in std_logic;
        vfpconfig_awaddr          : in std_logic_vector(C_vfpConfig_ADDR_WIDTH-1 downto 0);
        vfpconfig_awprot          : in std_logic_vector(2 downto 0);
        vfpconfig_awvalid         : in std_logic;
        vfpconfig_awready         : out std_logic;
        vfpconfig_wdata           : in std_logic_vector(C_vfpConfig_DATA_WIDTH-1 downto 0);
        vfpconfig_wstrb           : in std_logic_vector((C_vfpConfig_DATA_WIDTH/8)-1 downto 0);
        vfpconfig_wvalid          : in std_logic;
        vfpconfig_wready          : out std_logic;
        vfpconfig_bresp           : out std_logic_vector(1 downto 0);
        vfpconfig_bvalid          : out std_logic;
        vfpconfig_bready          : in std_logic;
        vfpconfig_araddr          : in std_logic_vector(C_vfpConfig_ADDR_WIDTH-1 downto 0);
        vfpconfig_arprot          : in std_logic_vector(2 downto 0);
        vfpconfig_arvalid         : in std_logic;
        vfpconfig_arready         : out std_logic;
        vfpconfig_rdata           : out std_logic_vector(C_vfpConfig_DATA_WIDTH-1 downto 0);
        vfpconfig_rresp           : out std_logic_vector(1 downto 0);
        vfpconfig_rvalid          : out std_logic;
        vfpconfig_rready          : in std_logic;
        ovideo_aclk               : in std_logic;
        ovideo_aresetn            : in std_logic;
        ovideo_tvalid             : out std_logic;
        ovideo_tkeep              : out std_logic_vector(3 downto 0);
        ovideo_tdata              : out std_logic_vector(C_oVideo_TDATA_WIDTH-1 downto 0);
        ovideo_tstrb              : out std_logic_vector((C_oVideo_TDATA_WIDTH/8)-1 downto 0);
        ovideo_tlast              : out std_logic;
        ovideo_tready             : in std_logic;
        ovideo_tuser              : out std_logic;
        rgb_fr_plw_red            : out std_logic_vector(9 downto 0);
        rgb_fr_plw_gre            : out std_logic_vector(9 downto 0);
        rgb_fr_plw_blu            : out std_logic_vector(9 downto 0);
        rgb_fr_plw_sof            : out std_logic;
        rgb_fr_plw_eol            : out std_logic;
        rgb_fr_plw_eof            : out std_logic;
        rgb_fr_plw_val            : out std_logic;
        rgb_fr_plw_xcnt           : out std_logic_vector(15 downto 0);
        rgb_fr_plw_ycnt           : out std_logic_vector(15 downto 0);
        crd_x                     : out std_logic_vector(15 downto 0);
        crd_y                     : out std_logic_vector(15 downto 0);
        ivideo_aclk               : in std_logic;
        ivideo_aresetn            : in std_logic;
        ivideo_tready             : out std_logic;
        ivideo_tkeep              : in std_logic_vector(3 downto 0);  
        ivideo_tdata              : in std_logic_vector(C_iVideo_TDATA_WIDTH-1 downto 0);
        ivideo_tstrb              : in std_logic_vector((C_iVideo_TDATA_WIDTH/8)-1 downto 0);
        ivideo_tlast              : in std_logic;
        ivideo_tuser              : in std_logic; 
        ivideo_tvalid             : in std_logic);
end component;
    signal clk                : std_logic;
    signal reset              : std_logic;
    signal tdata              : std_logic_vector(31 downto 0);
    signal tstrb              : std_logic_vector(3 downto 0);
    signal tkeep              : std_logic_vector(3 downto 0);
    signal tlast              : std_logic;
    signal tuser              : std_logic;
    signal tvalid             : std_logic;
    constant testFolder       : string  := "F_BLU_TO_HSL";
    
    
    signal vfpconfig_aclk            : std_logic;
    signal vfpconfig_aresetn         : std_logic;
    signal vfpconfig_awaddr          : std_logic_vector(7 downto 0);
    signal vfpconfig_awprot          : std_logic_vector(2 downto 0);
    signal vfpconfig_awvalid         : std_logic;
    signal vfpconfig_awready         : std_logic;
    signal vfpconfig_wdata           : std_logic_vector(31 downto 0);
    signal vfpconfig_wstrb           : std_logic_vector(3 downto 0);
    signal vfpconfig_wvalid          : std_logic;
    signal vfpconfig_wready          : std_logic;
    signal vfpconfig_bresp           : std_logic_vector(1 downto 0);
    signal vfpconfig_bvalid          : std_logic;
    signal vfpconfig_bready          : std_logic;
    signal vfpconfig_araddr          : std_logic_vector(7 downto 0);
    signal vfpconfig_arprot          : std_logic_vector(2 downto 0);
    signal vfpconfig_arvalid         : std_logic;
    signal vfpconfig_arready         : std_logic;
    signal vfpconfig_rdata           : std_logic_vector(31 downto 0);
    signal vfpconfig_rresp           : std_logic_vector(1 downto 0);
    signal vfpconfig_rvalid          : std_logic;
    signal vfpconfig_rready          : std_logic;
    signal ovideo_aclk               : std_logic;
    signal ovideo_aresetn            : std_logic;
    signal ovideo_tvalid             : std_logic;
    signal ovideo_tkeep              : std_logic_vector(3 downto 0);
    signal ovideo_tdata              : std_logic_vector(31 downto 0);
    signal ovideo_tstrb              : std_logic_vector(3 downto 0);
    signal ovideo_tlast              : std_logic;
    signal ovideo_tready             : std_logic;
    signal ovideo_tuser              : std_logic;
    signal rgb_fr_plw_red            : std_logic_vector(9 downto 0);
    signal rgb_fr_plw_gre            : std_logic_vector(9 downto 0);
    signal rgb_fr_plw_blu            : std_logic_vector(9 downto 0);
    signal rgb_fr_plw_sof            : std_logic;
    signal rgb_fr_plw_eol            : std_logic;
    signal rgb_fr_plw_eof            : std_logic;
    signal rgb_fr_plw_val            : std_logic;
    signal rgb_fr_plw_xcnt           : std_logic_vector(15 downto 0);
    signal rgb_fr_plw_ycnt           : std_logic_vector(15 downto 0);
    signal crd_x                     : std_logic_vector(15 downto 0);
    signal crd_y                     : std_logic_vector(15 downto 0);
    signal ivideo_aclk               : std_logic;
    signal ivideo_aresetn            : std_logic;
    signal ivideo_tready             : std_logic;
    signal ivideo_tkeep              : std_logic_vector(3 downto 0);  
    signal ivideo_tdata              : std_logic_vector(31 downto 0);
    signal ivideo_tstrb              : std_logic_vector(3 downto 0);
    signal ivideo_tlast              : std_logic;
    signal ivideo_tuser              : std_logic; 
    signal ivideo_tvalid             : std_logic;
    
    
    
    
begin


clk_gen(clk, 100.00e6);
clk_gen(vfpconfig_aclk, 100.00e6);
clk_gen(ovideo_aclk, 100.00e6);
clk_gen(ivideo_aclk, 100.00e6);



    process begin
        reset             <= '0';
        ivideo_aresetn    <= '0';
        vfpconfig_aresetn <= '0';
        ovideo_aresetn    <= '0';
    wait for 10 ns;
        reset             <= '1';
        ivideo_aresetn    <= '1';
        vfpconfig_aresetn <= '1';
        ovideo_aresetn    <= '1';
    wait;
    end process;
    
    
IMAGE_READ_INST : image_read_axi4_stream_interface 
generic map(
    enImageText           => false,
    enImageIndex          => false,
    i_data_width          => 10,
    test                  => testFolder,
    input_file            => readbmp,
    output_file           => "output_image")
port map (
    clk                   => clk,
    reset                 => reset,
    tdata                 => tdata,
    tstrb                 => tstrb,
    tkeep                 => tkeep,
    tlast                 => tlast,
    tuser                 => tuser,
    tvalid                => tvalid);


VFP_V1_0_INST : vfp_v1_0 
generic map(
    revision_number           => x"05202022",
    C_vfpConfig_DATA_WIDTH    => 32,
    C_vfpConfig_ADDR_WIDTH    => 8,
    C_oVideo_TDATA_WIDTH      => 32,
    C_oVideo_START_COUNT      => 32,
    C_iVideo_TDATA_WIDTH      => 32,
    FRAME_PIXEL_DEPTH         => 10,
    FRAME_WIDTH               => 128,
    FRAME_HEIGHT              => 128)
port map (
        vfpconfig_aclk            =>  vfpconfig_aclk   ,-- in 
        vfpconfig_aresetn         =>  vfpconfig_aresetn,-- in 
        vfpconfig_awaddr          =>  vfpconfig_awaddr ,-- in 
        vfpconfig_awprot          =>  vfpconfig_awprot ,-- in 
        vfpconfig_awvalid         =>  vfpconfig_awvalid,-- in 
        vfpconfig_awready         =>  vfpconfig_awready,-- out
        vfpconfig_wdata           =>  vfpconfig_wdata  ,-- in 
        vfpconfig_wstrb           =>  vfpconfig_wstrb  ,-- in 
        vfpconfig_wvalid          =>  vfpconfig_wvalid ,-- in 
        vfpconfig_wready          =>  vfpconfig_wready ,-- out
        vfpconfig_bresp           =>  vfpconfig_bresp  ,-- out
        vfpconfig_bvalid          =>  vfpconfig_bvalid ,-- out
        vfpconfig_bready          =>  vfpconfig_bready ,-- in 
        vfpconfig_araddr          =>  vfpconfig_araddr ,-- in 
        vfpconfig_arprot          =>  vfpconfig_arprot ,-- in 
        vfpconfig_arvalid         =>  vfpconfig_arvalid,-- in 
        vfpconfig_arready         =>  vfpconfig_arready,-- out
        vfpconfig_rdata           =>  vfpconfig_rdata  ,-- out
        vfpconfig_rresp           =>  vfpconfig_rresp  ,-- out
        vfpconfig_rvalid          =>  vfpconfig_rvalid ,-- out
        vfpconfig_rready          =>  vfpconfig_rready ,-- in 
        ovideo_aclk               =>  ovideo_aclk      ,-- in 
        ovideo_aresetn            =>  ovideo_aresetn   ,-- in 
        ovideo_tvalid             =>  ovideo_tvalid    ,-- out
        ovideo_tkeep              =>  ovideo_tkeep     ,-- out
        ovideo_tdata              =>  ovideo_tdata     ,-- out
        ovideo_tstrb              =>  ovideo_tstrb     ,-- out
        ovideo_tlast              =>  ovideo_tlast     ,-- out
        ovideo_tready             =>  ovideo_tready    ,-- in 
        ovideo_tuser              =>  ovideo_tuser     ,-- out
        rgb_fr_plw_red            =>  rgb_fr_plw_red   ,-- out
        rgb_fr_plw_gre            =>  rgb_fr_plw_gre   ,-- out
        rgb_fr_plw_blu            =>  rgb_fr_plw_blu   ,-- out
        rgb_fr_plw_sof            =>  rgb_fr_plw_sof   ,-- out
        rgb_fr_plw_eol            =>  rgb_fr_plw_eol   ,-- out
        rgb_fr_plw_eof            =>  rgb_fr_plw_eof   ,-- out
        rgb_fr_plw_val            =>  rgb_fr_plw_val   ,-- out
        rgb_fr_plw_xcnt           =>  rgb_fr_plw_xcnt  ,-- out
        rgb_fr_plw_ycnt           =>  rgb_fr_plw_ycnt  ,-- out
        crd_x                     =>  crd_x            ,-- out
        crd_y                     =>  crd_y            ,-- out
        ivideo_aclk               =>  ivideo_aclk      ,-- in 
        ivideo_aresetn            =>  ivideo_aresetn   ,-- in 
        ivideo_tready             =>  ivideo_tready    ,-- out
        ivideo_tkeep              =>  tkeep     ,-- in 
        ivideo_tdata              =>  tdata     ,-- in 
        ivideo_tstrb              =>  tstrb     ,-- in 
        ivideo_tlast              =>  tlast     ,-- in 
        ivideo_tuser              =>  tuser     ,-- in 
        ivideo_tvalid             =>  tvalid);-- in 
end behavioral;