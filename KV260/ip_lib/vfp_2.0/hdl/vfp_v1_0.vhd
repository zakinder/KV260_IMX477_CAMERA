-------------------------------------------------------------------------------
-- Filename    : vfp.vhd
-- Create Date : 02092019 [02-09-2019]
-- Author      : Zakinder
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
entity vfp_v1_0 is
    generic (
        revision_number           : std_logic_vector(31 downto 0) := x"11272022";
        C_vfpConfig_DATA_WIDTH    : integer    := 32;
        C_vfpConfig_ADDR_WIDTH    : integer    := 8;
        C_oVideo_TDATA_WIDTH      : integer    := 32;
        C_oVideo_START_COUNT      : integer    := 32;
        C_iVideo_TDATA_WIDTH      : integer    := 32;
        FRAME_PIXEL_DEPTH         : integer    := 10;
        FRAME_WIDTH               : natural    := 1920;
        FRAME_HEIGHT              : natural    := 1080);
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
        o1video_aclk              : in std_logic;
        o1video_aresetn           : in std_logic;
        o1video_tvalid            : out std_logic;
        o1video_tkeep             : out std_logic_vector(2 downto 0);
        o1video_tdata             : out std_logic_vector(23 downto 0);
        o1video_tstrb             : out std_logic_vector(2 downto 0);
        o1video_tlast             : out std_logic;
        o1video_tready            : in std_logic;
        o1video_tuser             : out std_logic;
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
end vfp_v1_0;
architecture arch_imp of vfp_v1_0 is
    signal wr_regs            : mRegs;
    signal rd_regs            : mRegs;
    signal cord_x             : std_logic_vector(15 downto 0);
    signal cord_y             : std_logic_vector(15 downto 0);
    signal coefficients_in_1  : coefficient_values;
    signal coefficients_out_1 : coefficient_values;
    signal coefficients_in_2  : coefficient_values;
    signal coefficients_out_2 : coefficient_values;
    signal coefficients_in_3  : coefficient_values;
    signal coefficients_out_3 : coefficient_values;
    signal txCord             : coord;
    signal k_config_number_1  : integer := 0;
    signal k_config_number_2  : integer := 0;
    signal k_config_number_3  : integer := 0;
    signal config_number_14   : integer := 0;
    signal config_number_15   : natural := 0;
    signal config_number_16   : integer := 0;
    signal config_number_17   : integer := 0;
    signal config_number_19   : integer := 0;
    signal config_number_43   : integer := 0;
    signal config_number_44   : integer := 14;
    signal config_number_45   : integer := 0;
    signal config_number_20   : integer := 0;
    signal ccc1                : channel;
    signal ccc2                : channel;
    signal ccc3                : channel;
    signal ccc4                : channel;
    signal ccc5                : channel;
    signal ccc6                : channel;
    signal ccc7                : channel;
    signal ccc8                : channel;
    signal ccc9                : channel;
    signal ccc10               : channel;
    signal ccc11               : channel;
    signal ccc12               : channel;
    signal ccc13               : channel;
    signal ccc14               : channel;
    signal ccc15               : channel;
    signal ccc16               : channel;
    signal ccc17               : channel;
    signal ccc18               : channel;
    signal ccc19               : channel;
    signal ccc20               : channel;
    signal ccc21               : channel;
    signal ccc22               : channel;
    signal ccc23               : channel;
    signal ccc31               : channel;
    signal ccc32               : channel;
begin
-- this module encode and decode cpu config data to slave components
vfpConfigInst: vfp_config
generic map(
    revision_number      => revision_number,
    conf_data_width      => C_vfpConfig_DATA_WIDTH,
    conf_addr_width      => C_vfpConfig_ADDR_WIDTH)
port map(
    -- config and requested registers
    wrRegsOut            => wr_regs,
    rdRegsIn             => rd_regs,
    -- cpu config axi4 lite channel
    S_AXI_ACLK           => vfpconfig_aclk,
    S_AXI_ARESETN        => vfpconfig_aresetn,
    S_AXI_AWADDR         => vfpconfig_awaddr,
    S_AXI_AWPROT         => vfpconfig_awprot,
    S_AXI_AWVALID        => vfpconfig_awvalid,
    S_AXI_AWREADY        => vfpconfig_awready,
    S_AXI_WDATA          => vfpconfig_wdata,
    S_AXI_WSTRB          => vfpconfig_wstrb,
    S_AXI_WVALID         => vfpconfig_wvalid,
    S_AXI_WREADY         => vfpconfig_wready,
    S_AXI_BRESP          => vfpconfig_bresp,
    S_AXI_BVALID         => vfpconfig_bvalid,
    S_AXI_BREADY         => vfpconfig_bready,
    S_AXI_ARADDR         => vfpconfig_araddr,
    S_AXI_ARPROT         => vfpconfig_arprot,
    S_AXI_ARVALID        => vfpconfig_arvalid,
    S_AXI_ARREADY        => vfpconfig_arready,
    S_AXI_RDATA          => vfpconfig_rdata,
    S_AXI_RRESP          => vfpconfig_rresp,
    S_AXI_RVALID         => vfpconfig_rvalid,
    S_AXI_RREADY         => vfpconfig_rready);
VFP_AXI_STREAM_INST : vfp_axi_stream 
generic map(
    TDATA_WIDTH                     => C_iVideo_TDATA_WIDTH,
    FRAME_PIXEL_DEPTH               => FRAME_PIXEL_DEPTH,
    FRAME_WIDTH                     => FRAME_WIDTH,
    FRAME_HEIGHT                    => FRAME_HEIGHT)
port map (
    s_axis_aclk                     => ivideo_aclk,
    s_axis_aresetn                  => ivideo_aresetn,
    s_axis_tready                   => ivideo_tready,
    s_axis_tdata                    => ivideo_tdata,
    s_axis_tlast                    => ivideo_tlast,
    s_axis_tuser                    => ivideo_tuser,
    s_axis_tvalid                   => ivideo_tvalid,
    config_number_19                => config_number_19,
    oCord_x                         => cord_x,
    oCord_y                         => cord_y,
    oRgb                            => ccc1);
process (ivideo_aclk)begin
    if rising_edge(ivideo_aclk) then
        rgb_fr_plw_xcnt                 <= std_logic_vector(to_unsigned(ccc1.xcnt, 16));
        rgb_fr_plw_ycnt                 <= std_logic_vector(to_unsigned(ccc1.ycnt, 16));
        txCord.x                        <= cord_x;
        txCord.y                        <= cord_y;
        crd_x                           <= cord_x;
        crd_y                           <= cord_y;
        k_config_number_1               <= to_integer((unsigned(wr_regs.cfigReg11)));
        k_config_number_2               <= to_integer((unsigned(wr_regs.cfigReg12)));
        k_config_number_3               <= to_integer((unsigned(wr_regs.cfigReg13)));
        config_number_14                <= to_integer((unsigned(wr_regs.cfigReg14)));
        config_number_15                <= to_integer((unsigned(wr_regs.cfigReg15)));
        config_number_16                <= to_integer((unsigned(wr_regs.cfigReg16)));
        config_number_17                <= to_integer((unsigned(wr_regs.cfigReg17)));
        config_number_19                <= to_integer((unsigned(wr_regs.cfigReg19)));
        config_number_20                <= to_integer((unsigned(wr_regs.cfigReg20)));
        config_number_43                <= to_integer((unsigned(wr_regs.cfigReg43)));
        config_number_44                <= to_integer((unsigned(wr_regs.cfigReg44)));
        config_number_45                <= to_integer((unsigned(wr_regs.cfigReg45)));
    end if;
end process;
process (ivideo_aclk)begin
    if rising_edge(ivideo_aclk) then
        coefficients_in_1.k1   <= wr_regs.cfigReg1;
        coefficients_in_1.k2   <= wr_regs.cfigReg2;
        coefficients_in_1.k3   <= wr_regs.cfigReg3;
        coefficients_in_1.k4   <= wr_regs.cfigReg4;
        coefficients_in_1.k5   <= wr_regs.cfigReg5;
        coefficients_in_1.k6   <= wr_regs.cfigReg6;
        coefficients_in_1.k7   <= wr_regs.cfigReg7;
        coefficients_in_1.k8   <= wr_regs.cfigReg8;
        coefficients_in_1.k9   <= wr_regs.cfigReg9;
        rd_regs.cfigReg1       <= coefficients_out_1.k1;
        rd_regs.cfigReg2       <= coefficients_out_1.k2;
        rd_regs.cfigReg3       <= coefficients_out_1.k3;
        rd_regs.cfigReg4       <= coefficients_out_1.k4;
        rd_regs.cfigReg5       <= coefficients_out_1.k5;
        rd_regs.cfigReg6       <= coefficients_out_1.k6;
        rd_regs.cfigReg7       <= coefficients_out_1.k7;
        rd_regs.cfigReg8       <= coefficients_out_1.k8;
        rd_regs.cfigReg9       <= coefficients_out_1.k9;
        coefficients_in_2.k1   <= wr_regs.cfigReg46;
        coefficients_in_2.k2   <= wr_regs.cfigReg47;
        coefficients_in_2.k3   <= wr_regs.cfigReg48;
        coefficients_in_2.k4   <= wr_regs.cfigReg49;
        coefficients_in_2.k5   <= wr_regs.cfigReg50;
        coefficients_in_2.k6   <= wr_regs.cfigReg51;
        coefficients_in_2.k7   <= wr_regs.cfigReg52;
        coefficients_in_2.k8   <= wr_regs.cfigReg53;
        coefficients_in_2.k9   <= wr_regs.cfigReg54;
        rd_regs.cfigReg46      <= coefficients_out_2.k1;
        rd_regs.cfigReg47      <= coefficients_out_2.k2;
        rd_regs.cfigReg48      <= coefficients_out_2.k3;
        rd_regs.cfigReg49      <= coefficients_out_2.k4;
        rd_regs.cfigReg50      <= coefficients_out_2.k5;
        rd_regs.cfigReg51      <= coefficients_out_2.k6;
        rd_regs.cfigReg52      <= coefficients_out_2.k7;
        rd_regs.cfigReg53      <= coefficients_out_2.k8;
        rd_regs.cfigReg54      <= coefficients_out_2.k9;
        coefficients_in_3.k1   <= wr_regs.cfigReg55;
        coefficients_in_3.k2   <= wr_regs.cfigReg56;
        coefficients_in_3.k3   <= wr_regs.cfigReg57;
        coefficients_in_3.k4   <= wr_regs.cfigReg58;
        coefficients_in_3.k5   <= wr_regs.cfigReg59;
        coefficients_in_3.k6   <= wr_regs.cfigReg60;
        coefficients_in_3.k7   <= wr_regs.cfigReg61;
        coefficients_in_3.k8   <= wr_regs.cfigReg62;
        coefficients_in_3.k9   <= wr_regs.cfigReg63;
        rd_regs.cfigReg55      <= coefficients_out_3.k1;
        rd_regs.cfigReg56      <= coefficients_out_3.k2;
        rd_regs.cfigReg57      <= coefficients_out_3.k3;
        rd_regs.cfigReg58      <= coefficients_out_3.k4;
        rd_regs.cfigReg59      <= coefficients_out_3.k5;
        rd_regs.cfigReg60      <= coefficients_out_3.k6;
        rd_regs.cfigReg61      <= coefficients_out_3.k7;
        rd_regs.cfigReg62      <= coefficients_out_3.k8;
        rd_regs.cfigReg63      <= coefficients_out_3.k9;
    end if;
end process;
test_patterns_inst  : testpattern
port map(
    clk           => ivideo_aclk,
    iRgb          => ccc1,
    iCord         => txCord,
    tpSelect      => config_number_44,
    oRgb          => ccc2);
process (ivideo_aclk)begin
    if rising_edge(ivideo_aclk) then
        if(config_number_14 = 0) then
            ccc3           <= ccc1;
        else
            ccc3           <= ccc2;
        end if;
    end if;
end process;
dark_ccm_inst  : ccm
generic map (
    data_width              => 8,
    i_k_config_number       => 8)
port map(
    clk                   => ivideo_aclk,
    rst_l                 => ivideo_aresetn,
    k_config_number       => k_config_number_1,
    coefficients_in       => coefficients_in_1,
    coefficients_out      => coefficients_out_1,
    iRgb                  => ccc3,
    oRgb                  => ccc4);
light_ccm_inst  : ccm
generic map (
    data_width              => 8,
    i_k_config_number       => 8)
port map(
    clk                   => ivideo_aclk,
    rst_l                 => ivideo_aresetn,
    k_config_number       => k_config_number_2,
    coefficients_in       => coefficients_in_2,
    coefficients_out      => coefficients_out_2,
    iRgb                  => ccc4,
    oRgb                  => ccc5);
balance_ccm_inst  : ccm
generic map (
    data_width              => 8,
    i_k_config_number       => 8)
port map(
    clk                   => ivideo_aclk,
    rst_l                 => ivideo_aresetn,
    k_config_number       => k_config_number_3,
    coefficients_in       => coefficients_in_3,
    coefficients_out      => coefficients_out_3,
    iRgb                  => ccc5,
    oRgb                  => ccc6);
    ccc7 <= ccc6;
edge_1objects_inst: edge_1objects
generic map (
   i_data_width       => FRAME_PIXEL_DEPTH)
port map (                  
   clk                => ivideo_aclk,
   rst_l              => ivideo_aresetn,
   iRgb               => ccc7,
   oRgbRemix          => ccc13);
edge_3objects_inst: edge_3objects
generic map (
   i_data_width       => FRAME_PIXEL_DEPTH)
port map (                  
   clk                => ivideo_aclk,
   rst_l              => ivideo_aresetn,
   iRgb               => ccc7,
   oRgbRemix          => ccc14);
edge_6objects_inst: edge_6objects
generic map (
   i_data_width       => FRAME_PIXEL_DEPTH)
port map (                  
   clk                => ivideo_aclk,
   rst_l              => ivideo_aresetn,
   iRgb               => ccc7,
   oRgbRemix          => ccc16);
rgb_contrast_brightness_2_inst: rgb_contrast_brightness_level_1
generic map (
   contrast_val          => to_sfixed(1.40,15,-3),
   exposer_val           => 0)
port map (                  
   clk                   => ivideo_aclk,
   rst_l                 => ivideo_aresetn,
   iRgb                  => ccc7,
   oRgb                  => ccc15);
process (ivideo_aclk)begin
    if rising_edge(ivideo_aclk) then
        if(config_number_17 = 0) then
            ccc8           <= ccc13;
        elsif(config_number_17 = 1)then
            ccc8           <= ccc14;
        elsif(config_number_17 = 2)then
            ccc8           <= ccc15;
        else
            ccc8           <= ccc7;
        end if;
    end if;
end process;
sobel_inst: sobel
generic map(
   i_data_width        => 8,
   img_width           => FRAME_WIDTH)
port map(
   clk                => ivideo_aclk,
   rst_l              => ivideo_aresetn,
   iRgb               => ccc8,
   threshold          => config_number_44,
   oRgb               => ccc18);
process (ivideo_aclk) begin
    if rising_edge(ivideo_aclk) then
        ccc19 <=ccc18;
        ccc20 <=ccc19;
        ccc21 <=ccc20;
        ccc22 <=ccc21;
        ccc23 <=ccc22;
    end if;
end process;
color_k5_clustering_inst: color_k5_clustering
generic map(
    i_data_width      => i_data_width)
port map(
    clk                => ivideo_aclk,
    rst_l              => ivideo_aresetn,
    iRgb               => ccc8,
    k_lut_selected     => config_number_43,
    k_lut_in           => wr_regs.cfigReg45(23 downto 0),
    k_lut_out          => rd_regs.cfigReg45,
    k_ind_w            => config_number_15,
    k_ind_r            => config_number_20,
    oRgb               => ccc10);
process (ivideo_aclk) begin
    if rising_edge(ivideo_aclk) then
        if (ccc19.green(0) = '0') then
            ccc31.red   <= (others => '0');
            ccc31.green <= (others => '0');
            ccc31.blue  <= (others => '0');
        else
            ccc31.red   <= ccc10.red;
            ccc31.green <= ccc10.green;
            ccc31.blue  <= ccc10.blue;
        end if;
            ccc31.valid <= ccc10.valid;
            ccc31.eol   <= ccc10.eol;
            ccc31.sof   <= ccc10.sof;
            ccc31.eof   <= ccc10.eof;
    end if;
end process;
process (ivideo_aclk) begin
    if rising_edge(ivideo_aclk) then
        if (ccc23.green(0) = '0') then
            ccc32.red   <= (others => '0');
            ccc32.green <= (others => '0');
            ccc32.blue  <= (others => '0');
        else
            ccc32.red   <= ccc10.red;
            ccc32.green <= ccc10.green;
            ccc32.blue  <= ccc10.blue;
        end if;
            ccc32.valid <= ccc10.valid;
            ccc32.eol   <= ccc10.eol;
            ccc32.sof   <= ccc10.sof;
            ccc32.eof   <= ccc10.eof;
    end if;
end process;
rgb_contrast_brightness_1_inst: rgb_contrast_brightness_level_1
generic map (
   contrast_val          => to_sfixed(1.40,15,-3),
   exposer_val           => 0)
port map (                  
   clk                   => ivideo_aclk,
   rst_l                 => ivideo_aresetn,
   iRgb                  => ccc10,
   oRgb                  => ccc9);
-- color_k2_clustering_inst: color_k3_clustering
-- generic map(
    -- i_data_width      => i_data_width)
-- port map(
    -- clk                => ivideo_aclk,
    -- rst_l              => ivideo_aresetn,
    -- iRgb               => ccc9,
    -- iLutNum            => config_number_15,
    -- k_lut              => config_number_45,
    -- oRgb               => ccc17);
process (ivideo_aclk)begin
    if rising_edge(ivideo_aclk) then
        if(config_number_16 = 0) then
            ccc12           <= ccc1;
        elsif(config_number_16 = 1)then
            ccc12           <= ccc2;
        elsif(config_number_16 = 2)then
            ccc12           <= ccc3;
        elsif(config_number_16 = 3)then
            ccc12           <= ccc4;
        elsif(config_number_16 = 4)then
            ccc12           <= ccc5;
        elsif(config_number_16 = 5)then
            ccc12           <= ccc6;
        elsif(config_number_16 = 6)then
            ccc12           <= ccc7;
        elsif(config_number_16 = 7)then
            ccc12           <= ccc8;
        elsif(config_number_16 = 8)then
            ccc12           <= ccc9;
        elsif(config_number_16 = 9)then
            ccc12           <= ccc10;
        elsif(config_number_16 = 10)then
            ccc12           <= ccc13;
        elsif(config_number_16 = 11)then
            ccc12           <= ccc14;
        elsif(config_number_16 = 12)then
            ccc12           <= ccc16;
        elsif(config_number_16 = 13)then
            ccc12           <= ccc15;
        elsif(config_number_16 = 14)then
            ccc12           <= ccc17;
        elsif(config_number_16 = 15)then
            ccc12           <= ccc18;
        elsif(config_number_16 = 16)then
            ccc12           <= ccc31;
        elsif(config_number_16 = 17)then
            ccc12           <= ccc32;
        else
            ccc12           <= ccc11;
        end if;
    end if;
end process;
   ovideo_tstrb           <= ivideo_tstrb;
   ovideo_tkeep           <= ivideo_tkeep;
   ovideo_tdata           <= "00" & ccc12.red & ccc12.green & ccc12.blue;
   ovideo_tvalid          <= ccc12.valid;
   ovideo_tuser           <= ccc12.sof;
   ovideo_tlast           <= ccc12.eol;
   o1video_tstrb          <= ivideo_tstrb(2 downto 0);
   o1video_tkeep          <= ivideo_tkeep(2 downto 0);
   o1video_tdata          <= ccc12.green(9 downto 2) & ccc12.blue(9 downto 2) & ccc12.red(9 downto 2);
   o1video_tvalid         <= ccc12.valid;
   o1video_tuser          <= ccc12.sof;
   o1video_tlast          <= ccc12.eol;
   rgb_fr_plw_red         <= "00" & ccc12.red(7 downto 0);
   rgb_fr_plw_gre         <= "00" & ccc12.green(7 downto 0);
   rgb_fr_plw_blu         <= "00" & ccc12.blue(7 downto 0);
   rgb_fr_plw_sof         <= ccc12.sof;
   rgb_fr_plw_eol         <= ccc12.eol;
   rgb_fr_plw_eof         <= ccc12.eof;
   rgb_fr_plw_val         <= ccc12.valid;
end arch_imp;
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use work.constants_package.all;
--use work.vpf_records.all;
--use work.ports_package.all;
--use work.fixed_pkg.all;
--use work.float_pkg.all;
--entity vfp_v1_0 is
--    generic (
--        -- System Revision
--        revision_number           : std_logic_vector(31 downto 0) := x"10132022";
--        C_vfpConfig_DATA_WIDTH    : integer    := 32;
--        C_vfpConfig_ADDR_WIDTH    : integer    := 8;
--        C_oVideo_TDATA_WIDTH      : integer    := 32;
--        C_oVideo_START_COUNT      : integer    := 32;
--        C_iVideo_TDATA_WIDTH      : integer    := 32;
--        FRAME_PIXEL_DEPTH         : integer    := 10;
--        FRAME_WIDTH               : natural    := 1920;
--        FRAME_HEIGHT              : natural    := 1080);
--    port (
--        vfpconfig_aclk            : in std_logic;
--        vfpconfig_aresetn         : in std_logic;
--        vfpconfig_awaddr          : in std_logic_vector(C_vfpConfig_ADDR_WIDTH-1 downto 0);
--        vfpconfig_awprot          : in std_logic_vector(2 downto 0);
--        vfpconfig_awvalid         : in std_logic;
--        vfpconfig_awready         : out std_logic;
--        vfpconfig_wdata           : in std_logic_vector(C_vfpConfig_DATA_WIDTH-1 downto 0);
--        vfpconfig_wstrb           : in std_logic_vector((C_vfpConfig_DATA_WIDTH/8)-1 downto 0);
--        vfpconfig_wvalid          : in std_logic;
--        vfpconfig_wready          : out std_logic;
--        vfpconfig_bresp           : out std_logic_vector(1 downto 0);
--        vfpconfig_bvalid          : out std_logic;
--        vfpconfig_bready          : in std_logic;
--        vfpconfig_araddr          : in std_logic_vector(C_vfpConfig_ADDR_WIDTH-1 downto 0);
--        vfpconfig_arprot          : in std_logic_vector(2 downto 0);
--        vfpconfig_arvalid         : in std_logic;
--        vfpconfig_arready         : out std_logic;
--        vfpconfig_rdata           : out std_logic_vector(C_vfpConfig_DATA_WIDTH-1 downto 0);
--        vfpconfig_rresp           : out std_logic_vector(1 downto 0);
--        vfpconfig_rvalid          : out std_logic;
--        vfpconfig_rready          : in std_logic;
--        ovideo_aclk               : in std_logic;
--        ovideo_aresetn            : in std_logic;
--        ovideo_tvalid             : out std_logic;
--        ovideo_tkeep              : out std_logic_vector(3 downto 0);
--        ovideo_tdata              : out std_logic_vector(C_oVideo_TDATA_WIDTH-1 downto 0);
--        ovideo_tstrb              : out std_logic_vector((C_oVideo_TDATA_WIDTH/8)-1 downto 0);
--        ovideo_tlast              : out std_logic;
--        ovideo_tready             : in std_logic;
--        ovideo_tuser              : out std_logic;
--        o1video_aclk               : in std_logic;
--        o1video_aresetn            : in std_logic;
--        o1video_tvalid             : out std_logic;
--        o1video_tkeep              : out std_logic_vector(2 downto 0);
--        o1video_tdata              : out std_logic_vector(23 downto 0);
--        o1video_tstrb              : out std_logic_vector(2 downto 0);
--        o1video_tlast              : out std_logic;
--        o1video_tready             : in std_logic;
--        o1video_tuser              : out std_logic;
--        rgb_fr_plw_red            : out std_logic_vector(9 downto 0);
--        rgb_fr_plw_gre            : out std_logic_vector(9 downto 0);
--        rgb_fr_plw_blu            : out std_logic_vector(9 downto 0);
--        rgb_fr_plw_sof            : out std_logic;
--        rgb_fr_plw_eol            : out std_logic;
--        rgb_fr_plw_eof            : out std_logic;
--        rgb_fr_plw_val            : out std_logic;
--        rgb_fr_plw_xcnt           : out std_logic_vector(15 downto 0);
--        rgb_fr_plw_ycnt           : out std_logic_vector(15 downto 0);
--        crd_x                     : out std_logic_vector(15 downto 0);
--        crd_y                     : out std_logic_vector(15 downto 0);
--        ivideo_aclk               : in std_logic;
--        ivideo_aresetn            : in std_logic;
--        ivideo_tready             : out std_logic;
--        ivideo_tkeep              : in std_logic_vector(3 downto 0);  
--        ivideo_tdata              : in std_logic_vector(C_iVideo_TDATA_WIDTH-1 downto 0);
--        ivideo_tstrb              : in std_logic_vector((C_iVideo_TDATA_WIDTH/8)-1 downto 0);
--        ivideo_tlast              : in std_logic;
--        ivideo_tuser              : in std_logic; 
--        ivideo_tvalid             : in std_logic);
--end vfp_v1_0;
--architecture arch_imp of vfp_v1_0 is
--    signal rgb_to_ccm         : channel;
--    signal rgb_tt_ccm         : channel;
--    signal rgb_fr_ccm         : channel;
--    signal rgb_ff_ccm         : channel;
--    signal rgb_ss_ccm         : channel;
--    signal rgb_f1_ccm         : channel;
--    signal rgb_f2_ccm         : channel;
--    signal rgb_h1_ccm         : channel;
--    signal rgb_h2_ccm         : channel;
--    signal rgb_h3_ccm         : channel;
--    signal rgb_h4_ccm         : channel;
--    signal rgb_h5_ccm         : channel;
--    signal rgb_h6_ccm         : channel;
--    signal rgb_f8_ccm         : channel;
--    signal rgb_f8_cmm         : channel;
--    signal rgb_f9_ccc         : channel;
--    signal rgb_f9_ccm         : channel;
--    signal rgb_f9_cmm         : channel;
--    signal rgb_f9_mmm         : channel;
--    signal rgb_10_mmm         : channel;
--    signal rgb_11_mmm         : channel;
--    signal rgb_fr_plw         : channel;
--    signal rgb_fr_p2w         : channel;
--    signal rgb_contr1         : channel;
--    signal rgb_range1         : channel;
--    signal wr_regs            : mRegs;
--    signal rd_regs            : mRegs;
--    signal cord_x             : std_logic_vector(15 downto 0);
--    signal cord_y             : std_logic_vector(15 downto 0);
--    signal coefficients_in_1  : coefficient_values;
--    signal coefficients_out_1 : coefficient_values;
--    signal coefficients_in_2  : coefficient_values;
--    signal coefficients_out_2 : coefficient_values;
--    signal coefficients_in_3  : coefficient_values;
--    signal coefficients_out_3 : coefficient_values;
--    signal iAls               : coefficient;
--    signal txCord             : coord;
--    signal k_config_number_1  : integer := 0;
--    signal k_config_number_2  : integer := 0;
--    signal k_config_number_3  : integer := 0;
--    signal config_number_14   : integer := 0;
--    signal config_number_15   : integer := 0;
--    signal config_number_16   : integer := 0;
--    signal config_number_17   : integer := 15;
--    signal config_number_18   : integer := 0;
--    signal config_number_19   : integer := 0;
--    signal config_number_31   : integer := 0;
--    signal config_number_32   : integer := 0;
--    signal config_number_33   : integer := 0;
--    signal config_number_34   : integer := 0;
--    signal config_number_35   : integer := 0;
--    signal config_number_36   : integer := 0;
--    signal config_number_37   : integer := 0;
--    signal config_number_38   : integer := 0;
--    signal config_number_39   : integer := 0;
--    signal config_number_40   : integer := 0;
--    signal config_number_41   : integer := 0;
--    signal config_number_42   : integer := 0;
--    signal config_number_43   : integer := 0;
--    signal config_number_44   : integer := 14;
--    signal config_number_45   : integer := 0;
--    signal config_number_46   : integer := 0;
--    signal ccc_rgb1_range      : channel;
--    signal ccc_rgb2_range      : channel;
--    signal ccc_rgb3_range      : channel;
--    signal ccc_rgb4_range      : channel;
--    signal ccx_rgb1_range      : channel;
--    signal ccx_rgb2_range      : channel;
--    signal ccx_rgb3_range      : channel;
--    signal ccx_rgb4_range      : channel;
--    signal ccc1                : channel;
--    signal ccc2                : channel;
--    signal ccc3                : channel;
--    signal ccc4                : channel;
--    signal ccc5                : channel;
--    signal ccc6                : channel;
--    signal ccc7                : channel;
--    signal ccc8                : channel;
--    signal ccm1                : channel;
--    signal ccm2                : channel;
--    signal ccm3                : channel;
--    signal ccm4                : channel;
--    signal ccm5                : channel;
--    signal ccm6                : channel;
--    signal ccm7                : channel;
--    signal ccm8                : channel;
--    signal ccm9                : channel;
--    signal rgbYcbcr            : channel;
--    signal rgbCmyk             : channel;
--    signal hRed                : std_logic_vector(7 downto 0);  
--    signal hGre                : std_logic_vector(7 downto 0);  
--    signal hBlu                : std_logic_vector(7 downto 0);  
--    signal hValid              : std_logic;
--    signal hEol                : std_logic; 
--    signal hEof                : std_logic; 
--    signal hSof                : std_logic;
--begin
---- this module encode and decode cpu config data to slave components
--vfpConfigInst: vfp_config
--generic map(
--    revision_number      => revision_number,
--    conf_data_width      => C_vfpConfig_DATA_WIDTH,
--    conf_addr_width      => C_vfpConfig_ADDR_WIDTH)
--port map(
--    -- config and requested registers
--    wrRegsOut            => wr_regs,
--    rdRegsIn             => rd_regs,
--    -- cpu config axi4 lite channel
--    S_AXI_ACLK           => vfpconfig_aclk,
--    S_AXI_ARESETN        => vfpconfig_aresetn,
--    S_AXI_AWADDR         => vfpconfig_awaddr,
--    S_AXI_AWPROT         => vfpconfig_awprot,
--    S_AXI_AWVALID        => vfpconfig_awvalid,
--    S_AXI_AWREADY        => vfpconfig_awready,
--    S_AXI_WDATA          => vfpconfig_wdata,
--    S_AXI_WSTRB          => vfpconfig_wstrb,
--    S_AXI_WVALID         => vfpconfig_wvalid,
--    S_AXI_WREADY         => vfpconfig_wready,
--    S_AXI_BRESP          => vfpconfig_bresp,
--    S_AXI_BVALID         => vfpconfig_bvalid,
--    S_AXI_BREADY         => vfpconfig_bready,
--    S_AXI_ARADDR         => vfpconfig_araddr,
--    S_AXI_ARPROT         => vfpconfig_arprot,
--    S_AXI_ARVALID        => vfpconfig_arvalid,
--    S_AXI_ARREADY        => vfpconfig_arready,
--    S_AXI_RDATA          => vfpconfig_rdata,
--    S_AXI_RRESP          => vfpconfig_rresp,
--    S_AXI_RVALID         => vfpconfig_rvalid,
--    S_AXI_RREADY         => vfpconfig_rready);
--VFP_AXI_STREAM_INST : vfp_axi_stream 
--generic map(
--    TDATA_WIDTH                     => C_iVideo_TDATA_WIDTH,
--    FRAME_PIXEL_DEPTH               => FRAME_PIXEL_DEPTH,
--    FRAME_WIDTH                     => FRAME_WIDTH,
--    FRAME_HEIGHT                    => FRAME_HEIGHT)
--port map (
--    s_axis_aclk                     => ivideo_aclk,
--    s_axis_aresetn                  => ivideo_aresetn,
--    s_axis_tready                   => ivideo_tready,
--    s_axis_tdata                    => ivideo_tdata,
--    s_axis_tlast                    => ivideo_tlast,
--    s_axis_tuser                    => ivideo_tuser,
--    s_axis_tvalid                   => ivideo_tvalid,
--    config_number_19                => config_number_19,
--    oCord_x                         => cord_x,
--    oCord_y                         => cord_y,
--    oRgb                            => rgb_tt_ccm);
--    rgb_fr_plw_xcnt                 <= std_logic_vector(to_unsigned(rgb_tt_ccm.xcnt, 16));
--    rgb_fr_plw_ycnt                 <= std_logic_vector(to_unsigned(rgb_tt_ccm.ycnt, 16));
--    txCord.x                        <= cord_x;
--    txCord.y                        <= cord_y;
--    crd_x                           <= cord_x;
--    crd_y                           <= cord_y;
--    k_config_number_1               <= to_integer((unsigned(wr_regs.cfigReg11)));
--    k_config_number_2               <= to_integer((unsigned(wr_regs.cfigReg12)));
--    k_config_number_3               <= to_integer((unsigned(wr_regs.cfigReg13)));
--    config_number_14                <= to_integer((unsigned(wr_regs.cfigReg14)));
--    config_number_15                <= to_integer((unsigned(wr_regs.cfigReg15)));
--    config_number_16                <= to_integer((unsigned(wr_regs.cfigReg16)));
--    config_number_17                <= to_integer((unsigned(wr_regs.cfigReg17)));
--    config_number_18                <= to_integer((unsigned(wr_regs.cfigReg18)));
--    config_number_19                <= to_integer((unsigned(wr_regs.cfigReg19)));
--    iAls.k1                         <= wr_regs.cfigReg21;
--    iAls.k2                         <= wr_regs.cfigReg22;
--    iAls.k3                         <= wr_regs.cfigReg23;
--    iAls.k4                         <= wr_regs.cfigReg24;
--    iAls.k5                         <= wr_regs.cfigReg25;
--    iAls.k6                         <= wr_regs.cfigReg26;
--    iAls.k7                         <= wr_regs.cfigReg27;
--    iAls.k8                         <= wr_regs.cfigReg28;
--    iAls.k9                         <= wr_regs.cfigReg29;
--    iAls.config                     <= to_integer((unsigned(wr_regs.cfigReg30)));
--    config_number_31                <= to_integer((unsigned(wr_regs.cfigReg31)));
--    config_number_32                <= to_integer((unsigned(wr_regs.cfigReg32)));
--    config_number_33                <= to_integer((unsigned(wr_regs.cfigReg33)));
--    config_number_34                <= to_integer((unsigned(wr_regs.cfigReg34)));
--    config_number_35                <= to_integer((unsigned(wr_regs.cfigReg35)));
--    config_number_36                <= to_integer((unsigned(wr_regs.cfigReg36)));
--    config_number_37                <= to_integer((unsigned(wr_regs.cfigReg37)));
--    config_number_38                <= to_integer((unsigned(wr_regs.cfigReg38)));
--    config_number_39                <= to_integer((unsigned(wr_regs.cfigReg39)));
--    config_number_40                <= to_integer((unsigned(wr_regs.cfigReg40)));
--    config_number_41                <= to_integer((unsigned(wr_regs.cfigReg41)));
--    config_number_42                <= to_integer((unsigned(wr_regs.cfigReg42)));
--    config_number_43                <= to_integer((unsigned(wr_regs.cfigReg43)));
--    config_number_44                <= to_integer((unsigned(wr_regs.cfigReg44)));
--    config_number_45                <= to_integer((unsigned(wr_regs.cfigReg45)));
--    config_number_46                <= to_integer((unsigned(wr_regs.cfigReg46)));
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--        coefficients_in_1.k1   <= wr_regs.cfigReg1;
--        coefficients_in_1.k2   <= wr_regs.cfigReg2;
--        coefficients_in_1.k3   <= wr_regs.cfigReg3;
--        coefficients_in_1.k4   <= wr_regs.cfigReg4;
--        coefficients_in_1.k5   <= wr_regs.cfigReg5;
--        coefficients_in_1.k6   <= wr_regs.cfigReg6;
--        coefficients_in_1.k7   <= wr_regs.cfigReg7;
--        coefficients_in_1.k8   <= wr_regs.cfigReg8;
--        coefficients_in_1.k9   <= wr_regs.cfigReg9;
--        rd_regs.cfigReg1       <= coefficients_out_1.k1;
--        rd_regs.cfigReg2       <= coefficients_out_1.k2;
--        rd_regs.cfigReg3       <= coefficients_out_1.k3;
--        rd_regs.cfigReg4       <= coefficients_out_1.k4;
--        rd_regs.cfigReg5       <= coefficients_out_1.k5;
--        rd_regs.cfigReg6       <= coefficients_out_1.k6;
--        rd_regs.cfigReg7       <= coefficients_out_1.k7;
--        rd_regs.cfigReg8       <= coefficients_out_1.k8;
--        rd_regs.cfigReg9       <= coefficients_out_1.k9;
--        coefficients_in_2.k1   <= wr_regs.cfigReg46;
--        coefficients_in_2.k2   <= wr_regs.cfigReg47;
--        coefficients_in_2.k3   <= wr_regs.cfigReg48;
--        coefficients_in_2.k4   <= wr_regs.cfigReg49;
--        coefficients_in_2.k5   <= wr_regs.cfigReg50;
--        coefficients_in_2.k6   <= wr_regs.cfigReg51;
--        coefficients_in_2.k7   <= wr_regs.cfigReg52;
--        coefficients_in_2.k8   <= wr_regs.cfigReg53;
--        coefficients_in_2.k9   <= wr_regs.cfigReg54;
--        rd_regs.cfigReg46      <= coefficients_out_2.k1;
--        rd_regs.cfigReg47      <= coefficients_out_2.k2;
--        rd_regs.cfigReg48      <= coefficients_out_2.k3;
--        rd_regs.cfigReg49      <= coefficients_out_2.k4;
--        rd_regs.cfigReg50      <= coefficients_out_2.k5;
--        rd_regs.cfigReg51      <= coefficients_out_2.k6;
--        rd_regs.cfigReg52      <= coefficients_out_2.k7;
--        rd_regs.cfigReg53      <= coefficients_out_2.k8;
--        rd_regs.cfigReg54      <= coefficients_out_2.k9;
--        coefficients_in_3.k1   <= wr_regs.cfigReg55;
--        coefficients_in_3.k2   <= wr_regs.cfigReg56;
--        coefficients_in_3.k3   <= wr_regs.cfigReg57;
--        coefficients_in_3.k4   <= wr_regs.cfigReg58;
--        coefficients_in_3.k5   <= wr_regs.cfigReg59;
--        coefficients_in_3.k6   <= wr_regs.cfigReg60;
--        coefficients_in_3.k7   <= wr_regs.cfigReg61;
--        coefficients_in_3.k8   <= wr_regs.cfigReg62;
--        coefficients_in_3.k9   <= wr_regs.cfigReg63;
--        rd_regs.cfigReg55      <= coefficients_out_3.k1;
--        rd_regs.cfigReg56      <= coefficients_out_3.k2;
--        rd_regs.cfigReg57      <= coefficients_out_3.k3;
--        rd_regs.cfigReg58      <= coefficients_out_3.k4;
--        rd_regs.cfigReg59      <= coefficients_out_3.k5;
--        rd_regs.cfigReg60      <= coefficients_out_3.k6;
--        rd_regs.cfigReg61      <= coefficients_out_3.k7;
--        rd_regs.cfigReg62      <= coefficients_out_3.k8;
--        rd_regs.cfigReg63      <= coefficients_out_3.k9;
--    end if;
--end process;
--rgb_f8_cmm <= rgb_tt_ccm;
--test_patterns_inst  : testpattern
--port map(
--    clk           => ivideo_aclk,
--    iRgb          => rgb_f8_cmm,
--    iCord         => txCord,
--    tpSelect      => config_number_44,
--    oRgb          => ccm5);
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--        if(config_number_45 = 0) then
--            ccc5           <= rgb_f8_cmm;-- rgb
--        else
--            ccc5           <= ccm5;      -- rgb->testpattern
--        end if;
--    end if;
--end process;
--rgb_range_1_inst: rgb_range
--generic map (
--    i_data_width       => FRAME_PIXEL_DEPTH)
--port map (                  
--    clk                => ivideo_aclk,
--    reset              => ivideo_aresetn,
--    gain               => config_number_14,
--    iRgb               => ccc5,
--    oRgb               => ccc_rgb1_range);
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--        if(config_number_18 = 0) then
--            ccx_rgb1_range <= ccc5;
--        else
--            ccx_rgb1_range <= ccc_rgb1_range;
--        end if;
--    end if;
--end process;
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--        if(config_number_45 = 0) then
--            rgb_to_ccm           <= ccx_rgb1_range;-- rgb->range
--        elsif(config_number_45 = 1) then
--            rgb_to_ccm           <= ccc5;         -- rgb->testpattern->range
--        else
--            rgb_to_ccm           <= rgb_f8_cmm;   -- rgb->
--        end if;
--    end if;
--end process;
--rgb_contrast_brightness_1_inst: rgb_contrast_brightness_level_1
--generic map (
--    contrast_val          => to_sfixed(1.60,15,-3),
--    exposer_val           => 0)
--port map (                  
--    clk                   => ivideo_aclk,
--    rst_l                 => ivideo_aresetn,
--    iRgb                  => rgb_to_ccm,
--    oRgb                  => ccc1);
--dark_ccm_inst  : ccm
--generic map (
--    data_width              => 8,
--    i_k_config_number       => 8)
--port map(
--    clk                   => ivideo_aclk,
--    rst_l                 => ivideo_aresetn,
--    k_config_number       => k_config_number_1,
--    coefficients_in       => coefficients_in_1,
--    coefficients_out      => coefficients_out_1,
--    iRgb                  => rgb_to_ccm,
--    oRgb                  => ccc2);
--rgb_range_2_inst: rgb_range
--generic map (
--    i_data_width       => FRAME_PIXEL_DEPTH)
--port map (                  
--    clk                => ivideo_aclk,
--    reset              => ivideo_aresetn,
--    gain               => config_number_14,
--    iRgb               => ccc2,
--    oRgb               => ccc_rgb2_range);
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--        if(config_number_18 = 0) then
--            ccx_rgb2_range <= ccc2;
--        else
--            ccx_rgb2_range <= ccc_rgb2_range;
--        end if;
--    end if;
--end process;
--light_ccm_inst  : ccm
--generic map (
--    data_width              => 8,
--    i_k_config_number       => 8)
--port map(
--    clk                   => ivideo_aclk,
--    rst_l                 => ivideo_aresetn,
--    k_config_number       => k_config_number_2,
--    coefficients_in       => coefficients_in_2,
--    coefficients_out      => coefficients_out_2,
--    iRgb                  => ccx_rgb2_range,
--    oRgb                  => ccc3);
--rgb_range_3_inst: rgb_range
--generic map (
--    i_data_width       => FRAME_PIXEL_DEPTH)
--port map (                  
--    clk                => ivideo_aclk,
--    reset              => ivideo_aresetn,
--    gain               => config_number_14,
--    iRgb               => ccc3,
--    oRgb               => ccc_rgb3_range);
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--        if(config_number_18 = 0) then
--            ccx_rgb3_range <= ccc3;
--        else
--            ccx_rgb3_range <= ccc_rgb3_range;
--        end if;
--    end if;
--end process;
--balance_ccm_inst  : ccm
--generic map (
--    data_width              => 8,
--    i_k_config_number       => 8)
--port map(
--    clk                   => ivideo_aclk,
--    rst_l                 => ivideo_aresetn,
--    k_config_number       => k_config_number_3,
--    coefficients_in       => coefficients_in_3,
--    coefficients_out      => coefficients_out_3,
--    iRgb                  => ccx_rgb3_range,
--    oRgb                  => ccc4);
--    ccc_rgb4_range <= ccc4;
--recolor_space_2_inst: pixel_localization_9x9_window
--generic map(
--   img_width                   => FRAME_WIDTH,
--   i_data_width                => FRAME_PIXEL_DEPTH)
--port map(
--   clk                         => ivideo_aclk,
--   reset                       => ivideo_aresetn,
--   txCord                      => txCord,
--   neighboring_pixel_threshold => config_number_17,
--   iRgb                        => ccc_rgb4_range,
--   oRgb                        => ccc6);
--rgb_contrast_brightness_2_inst: rgb_contrast_brightness_level_1
--generic map (
--    contrast_val          => to_sfixed(1.15,15,-3),
--    exposer_val           => 0)
--port map (                  
--    clk                   => ivideo_aclk,
--    rst_l                 => ivideo_aresetn,
--    iRgb                  => ccc2,
--    oRgb                  => ccc7);
--rgb_contrast_brightness_3_inst: rgb_contrast_brightness_level_1
--generic map (
--    contrast_val          => to_sfixed(1.45,15,-3),
--    exposer_val           => 0)
--port map (                  
--    clk                   => ivideo_aclk,
--    rst_l                 => ivideo_aresetn,
--    iRgb                  => ccc2,
--    oRgb                  => ccc8);
----l_blu_inst  : blur_filter
----generic map(
----    iMSB                => blurMsb,
----    iLSB                => blurLsb,
----    i_data_width        => FRAME_PIXEL_DEPTH,
----    img_width           => FRAME_WIDTH,
----    adwrWidth           => 16,
----    addrWidth           => 12)
----port map(
----    clk                 => ivideo_aclk,
----    rst_l               => ivideo_aresetn,
----    iRgb                => ccc_rgb4_range,
----    oRgb                => ccm1);
--filter_sharpe_inst  : sharp_filter
--generic map(
--    i_data_width        => FRAME_PIXEL_DEPTH,
--    img_width           => FRAME_WIDTH,
--    adwrWidth           => 16,
--    addrWidth           => 12)
--port map(
--    clk                 => ivideo_aclk,
--    rst_l               => ivideo_aresetn,
--    iRgb                => ccc_rgb4_range,
--    kls                 => iAls,
--    oRgb                => ccm2);
---- filter_blur_1_inst  : blur_filter_4by4
---- generic map(
--    -- iMSB                => blurMsb,
--    -- iLSB                => blurLsb,
--    -- i_data_width        => FRAME_PIXEL_DEPTH,
--    -- img_width           => FRAME_WIDTH,
--    -- adwrWidth           => 16,
--    -- addrWidth           => 12)
---- port map(
--    -- clk                 => ivideo_aclk,
--    -- rst_l               => ivideo_aresetn,
--    -- iRgb                => ccc_rgb4_range,
--    -- oRgb                => ccm3);
--hsl_inst: hsl_c
--generic map(
--    i_data_width       => FRAME_PIXEL_DEPTH)
--port map(
--    clk                => ivideo_aclk,
--    reset              => ivideo_aresetn,
--    iRgb               => ccc_rgb4_range,
--    config_number_31   => config_number_31,
--    config_number_32   => config_number_32,
--    config_number_33   => config_number_33,
--    config_number_34   => config_number_34,
--    config_number_35   => config_number_35,
--    config_number_36   => config_number_36,
--    config_number_37   => config_number_37,
--    config_number_38   => config_number_38,
--    config_number_39   => config_number_39,
--    config_number_40   => config_number_40,
--    config_number_41   => config_number_41,
--    config_number_42   => config_number_42,
--    oHsl               => ccm4);
--ycc_inst  : rgb_ycbcr
--generic map(
--    i_data_width         => 10,
--    i_precision          => 12,
--    i_full_range         => TRUE)
--port map(
--    clk                  => ivideo_aclk,
--    rst_l                => ivideo_aresetn,
--    iRgb                 => ccc_rgb4_range,
--    oRgb                 => rgbYcbcr);
---- rgb_to_cmyk_inst  : rgb_to_cmyk
---- generic map(
--    -- i_data_width   => 8)
---- port map(
--    -- clk                 => ivideo_aclk,
--    -- reset               => ivideo_aresetn,
--    -- iRgb                => ccc2,
--    -- oRgb                => rgbCmyk);
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--    if(config_number_15 = 0) then
--        rgb_fr_ccm           <= rgb_f8_cmm;
--    elsif(config_number_15 = 1)then
--        rgb_fr_ccm           <= ccc1;
--    elsif(config_number_15 = 2)then
--        rgb_fr_ccm           <= ccc2;
--    elsif(config_number_15 = 3)then
--        rgb_fr_ccm           <= ccc3;
--    elsif(config_number_15 = 4)then
--        rgb_fr_ccm           <= ccc4;
--    elsif(config_number_15 = 5)then
--        rgb_fr_ccm           <= ccc5;
--    elsif(config_number_15 = 6)then
--        rgb_fr_ccm           <= ccc6;
--    elsif(config_number_15 = 7)then
--        rgb_fr_ccm           <= ccc7;
--    elsif(config_number_15 = 8)then
--        rgb_fr_ccm           <= ccc8;
--    elsif(config_number_15 = 9)then
--        rgb_fr_ccm           <= ccm1;
--    elsif(config_number_15 = 10)then
--        rgb_fr_ccm           <= ccm2;
--    elsif(config_number_15 = 11)then
--        rgb_fr_ccm           <= ccm3;
--    elsif(config_number_15 = 12)then
--        rgb_fr_ccm           <= ccm4;
--    elsif(config_number_15 = 13)then
--        rgb_fr_ccm           <= rgbYcbcr;
--    elsif(config_number_15 = 14)then
--        rgb_fr_ccm           <= rgbCmyk;
--    elsif(config_number_15 = 15)then
--        rgb_fr_ccm           <= ccm5;
--    else
--        rgb_fr_ccm           <= rgb_to_ccm;
--    end if;
--    end if;
--end process;
--redge_objects_inst: edge_objects
--generic map (
--    i_data_width       => FRAME_PIXEL_DEPTH)
--port map (                  
--    clk                => ivideo_aclk,
--    rst_l              => ivideo_aresetn,
--    iRgb               => rgb_fr_ccm,
--    oRgbRemix          => rgb_ff_ccm);
--    
--color_k_clustering_inst: color_k_clustering
--generic map(
--    i_data_width      => i_data_width)
--port map(
--    clk                => ivideo_aclk,
--    rst_l              => ivideo_aresetn,
--    iRgb               => rgb_fr_ccm,
--    oRgb               => rgb_ss_ccm);
--    
--    
--    
--rgb_2_hsv_inst  : rgb_2_hsv
--port map(
--    clk                  => ivideo_aclk,
--    rst                  => ivideo_aresetn,
--    iRgb                 => rgb_ss_ccm,
--    oHSV                 => rgb_h1_ccm,
--    oHSV_YCB             => rgb_h2_ccm);
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--        rgb_f1_ccm.red         <= rgb_fr_ccm.green;
--        rgb_f1_ccm.green       <= rgb_fr_ccm.green;
--        rgb_f1_ccm.blue        <= rgb_fr_ccm.red;
--        rgb_f1_ccm.valid       <= rgb_fr_ccm.valid;
--        rgb_f1_ccm.eof         <= rgb_fr_ccm.eof;
--        rgb_f1_ccm.sof         <= rgb_fr_ccm.sof;
--        rgb_f1_ccm.eol         <= rgb_fr_ccm.eol;
--    end if;
--end process;
--rgb_3_hsv_inst  : rgb_2_hsv
--port map(
--    clk                  => ivideo_aclk,
--    rst                  => ivideo_aresetn,
--    iRgb                 => rgb_f1_ccm,
--    oHSV                 => rgb_h3_ccm,
--    oHSV_YCB             => rgb_h4_ccm);
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--        rgb_f2_ccm.red         <= rgb_fr_ccm.green;
--        rgb_f2_ccm.green       <= rgb_fr_ccm.green;
--        rgb_f2_ccm.blue        <= rgb_fr_ccm.red;
--        rgb_f2_ccm.valid       <= rgb_fr_ccm.valid;
--        rgb_f2_ccm.eof         <= rgb_fr_ccm.eof;
--        rgb_f2_ccm.sof         <= rgb_fr_ccm.sof;
--        rgb_f2_ccm.eol         <= rgb_fr_ccm.eol;
--    end if;
--end process;
--rgb_4_hsv_inst  : rgb_2_hsv
--port map(
--    clk                  => ivideo_aclk,
--    rst                  => ivideo_aresetn,
--    iRgb                 => rgb_h4_ccm,
--    oHSV                 => rgb_h5_ccm,
--    oHSV_YCB             => rgb_h6_ccm);
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--    if(config_number_43 = 0) then
--        rgb_f8_ccm.red         <= "00" & rgb_ss_ccm.red(7 downto 0);
--        rgb_f8_ccm.green       <= "00" & rgb_ss_ccm.green(7 downto 0);
--        rgb_f8_ccm.blue        <= "00" & rgb_ss_ccm.blue(7 downto 0);
--        rgb_f8_ccm.valid       <= rgb_ss_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_ss_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_ss_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_ss_ccm.eol;
--    elsif(config_number_43 = 1)then
--        rgb_f8_ccm.red         <= rgb_h1_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h1_ccm.green;
--        rgb_f8_ccm.blue        <= rgb_h1_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h1_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h1_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h1_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h1_ccm.eol;
--    elsif(config_number_43 = 2)then
--        rgb_f8_ccm.red         <= "00" & rgb_ff_ccm.red(7 downto 0);
--        rgb_f8_ccm.green       <= "00" & rgb_ff_ccm.green(7 downto 0);
--        rgb_f8_ccm.blue        <= "00" & rgb_ff_ccm.blue(7 downto 0);
--        rgb_f8_ccm.valid       <= rgb_ff_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_ff_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_ff_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_ff_ccm.eol;
--    elsif(config_number_43 = 3)then
--        rgb_f8_ccm.red         <= (others => '0');
--        rgb_f8_ccm.green       <= rgb_h1_ccm.green;
--        rgb_f8_ccm.blue        <= (others => '0');
--        rgb_f8_ccm.valid       <= rgb_h1_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h1_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h1_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h1_ccm.eol;
--    elsif(config_number_43 = 4)then
--        rgb_f8_ccm.red         <= (others => '0');
--        rgb_f8_ccm.green       <= (others => '0');
--        rgb_f8_ccm.blue        <= rgb_h1_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h1_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h1_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h1_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h1_ccm.eol;
--    elsif(config_number_43 = 5)then
--        rgb_f8_ccm.red         <= rgb_h1_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h1_ccm.red;
--        rgb_f8_ccm.blue        <= rgb_h1_ccm.red;
--        rgb_f8_ccm.valid       <= rgb_h1_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h1_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h1_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h1_ccm.eol;
--    elsif(config_number_43 = 6)then
--        rgb_f8_ccm.red         <= rgb_h1_ccm.green;
--        rgb_f8_ccm.green       <= rgb_h1_ccm.green;
--        rgb_f8_ccm.blue        <= rgb_h1_ccm.green;
--        rgb_f8_ccm.valid       <= rgb_h1_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h1_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h1_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h1_ccm.eol;
--    elsif(config_number_43 = 7)then
--        rgb_f8_ccm.red         <= rgb_h1_ccm.blue;
--        rgb_f8_ccm.green       <= rgb_h1_ccm.blue;
--        rgb_f8_ccm.blue        <= rgb_h1_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h1_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h1_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h1_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h1_ccm.eol;
--    elsif(config_number_43 = 8)then
--        rgb_f8_ccm.red         <= rgb_h2_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h2_ccm.green;
--        rgb_f8_ccm.blue        <= rgb_h2_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h2_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h2_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h2_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h2_ccm.eol;
--    elsif(config_number_43 = 9)then
--        rgb_f8_ccm.red         <= rgb_h2_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h2_ccm.red;
--        rgb_f8_ccm.blue        <= rgb_h2_ccm.red;
--        rgb_f8_ccm.valid       <= rgb_h2_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h2_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h2_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h2_ccm.eol;
--    elsif(config_number_43 = 10)then
--        rgb_f8_ccm.red         <= rgb_h2_ccm.green;
--        rgb_f8_ccm.green       <= rgb_h2_ccm.green;
--        rgb_f8_ccm.blue        <= rgb_h2_ccm.green;
--        rgb_f8_ccm.valid       <= rgb_h2_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h2_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h2_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h2_ccm.eol;
--    elsif(config_number_43 = 11)then
--        rgb_f8_ccm.red         <= rgb_h2_ccm.blue;
--        rgb_f8_ccm.green       <= rgb_h2_ccm.blue;
--        rgb_f8_ccm.blue        <= rgb_h2_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h2_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h2_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h2_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h2_ccm.eol;
--    elsif(config_number_43 = 12)then
--        rgb_f8_ccm.red         <= rgb_h4_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h4_ccm.red;
--        rgb_f8_ccm.blue        <= rgb_h4_ccm.red;
--        rgb_f8_ccm.valid       <= rgb_h4_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h4_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h4_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h4_ccm.eol;
--    elsif(config_number_43 = 13)then
--        rgb_f8_ccm.red         <= rgb_h4_ccm.green;
--        rgb_f8_ccm.green       <= rgb_h4_ccm.green;
--        rgb_f8_ccm.blue        <= rgb_h4_ccm.green;
--        rgb_f8_ccm.valid       <= rgb_h4_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h4_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h4_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h4_ccm.eol;
--    elsif(config_number_43 = 14)then
--        rgb_f8_ccm.red         <= rgb_h4_ccm.blue;
--        rgb_f8_ccm.green       <= rgb_h4_ccm.blue;
--        rgb_f8_ccm.blue        <= rgb_h4_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h4_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h4_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h4_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h4_ccm.eol;
--    elsif(config_number_43 = 15)then
--        rgb_f8_ccm.red         <= rgb_h6_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h6_ccm.red;
--        rgb_f8_ccm.blue        <= rgb_h6_ccm.red;
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 16)then
--        rgb_f8_ccm.red         <= rgb_h6_ccm.green;
--        rgb_f8_ccm.green       <= rgb_h6_ccm.green;
--        rgb_f8_ccm.blue        <= rgb_h6_ccm.green;
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 17)then
--        rgb_f8_ccm.red         <= rgb_h6_ccm.blue;
--        rgb_f8_ccm.green       <= rgb_h6_ccm.blue;
--        rgb_f8_ccm.blue        <= rgb_h6_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 18)then
--        rgb_f8_ccm.red         <= rgb_h2_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h4_ccm.red;
--        rgb_f8_ccm.blue        <= rgb_h4_ccm.red;
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 19)then -- 9,11,12
--        rgb_f8_ccm.red         <= rgb_h2_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h2_ccm.blue;
--        rgb_f8_ccm.blue        <= rgb_h6_ccm.red;
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 20)then -- 9,11,14
--        rgb_f8_ccm.red         <= rgb_h2_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h2_ccm.blue;
--        rgb_f8_ccm.blue        <= rgb_h4_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 21)then -- 9,12,14
--        rgb_f8_ccm.red         <= rgb_h2_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h4_ccm.red;
--        rgb_f8_ccm.blue        <= rgb_h4_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 22)then -- 11,12,14
--        rgb_f8_ccm.red         <= rgb_h2_ccm.blue;
--        rgb_f8_ccm.green       <= rgb_h4_ccm.red;
--        rgb_f8_ccm.blue        <= rgb_h4_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 23)then -- 9,11,15
--        rgb_f8_ccm.red         <= rgb_h2_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h2_ccm.blue;
--        rgb_f8_ccm.blue        <= rgb_h6_ccm.red;
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 24)then -- 9,11,13
--        rgb_f8_ccm.red         <= rgb_h2_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h2_ccm.blue;
--        rgb_f8_ccm.blue        <= rgb_h4_ccm.green;
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 25)then -- 9,11,12
--        rgb_f8_ccm.red         <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h6_ccm.red));
--        rgb_f8_ccm.green       <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h6_ccm.red));
--        rgb_f8_ccm.blue        <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h6_ccm.red));
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 26)then -- 9,11,14
--        rgb_f8_ccm.red         <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h4_ccm.blue));
--        rgb_f8_ccm.green       <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h4_ccm.blue));
--        rgb_f8_ccm.blue        <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h4_ccm.blue));
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 27)then -- 9,12,14
--        rgb_f8_ccm.red         <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h4_ccm.red) + unsigned(rgb_h4_ccm.blue));
--        rgb_f8_ccm.green       <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h4_ccm.red) + unsigned(rgb_h4_ccm.blue));
--        rgb_f8_ccm.blue        <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h4_ccm.red) + unsigned(rgb_h4_ccm.blue));
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 28)then -- 11,12,14
--        rgb_f8_ccm.red         <= std_logic_vector(unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h4_ccm.red) + unsigned(rgb_h4_ccm.blue));
--        rgb_f8_ccm.green       <= std_logic_vector(unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h4_ccm.red) + unsigned(rgb_h4_ccm.blue));
--        rgb_f8_ccm.blue        <= std_logic_vector(unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h4_ccm.red) + unsigned(rgb_h4_ccm.blue));
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 29)then -- 9,11,15
--        rgb_f8_ccm.red         <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h6_ccm.red));
--        rgb_f8_ccm.green       <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h6_ccm.red));
--        rgb_f8_ccm.blue        <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h6_ccm.red));
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 30)then -- 9,11,13
--        rgb_f8_ccm.red         <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h4_ccm.green));
--        rgb_f8_ccm.green       <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h4_ccm.green));
--        rgb_f8_ccm.blue        <= std_logic_vector(unsigned(rgb_h2_ccm.red) + unsigned(rgb_h2_ccm.blue) + unsigned(rgb_h4_ccm.green));
--        rgb_f8_ccm.valid       <= rgb_h6_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h6_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h6_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h6_ccm.eol;
--    elsif(config_number_43 = 31)then
--        rgb_f8_ccm.red         <= "00" & ccm5.red(9 downto 2);
--        rgb_f8_ccm.green       <= "00" & ccm5.green(9 downto 2);
--        rgb_f8_ccm.blue        <= "00" & ccm5.blue(9 downto 2);
--        rgb_f8_ccm.valid       <= ccm5.valid;
--        rgb_f8_ccm.eof         <= ccm5.eof;
--        rgb_f8_ccm.sof         <= ccm5.sof;
--        rgb_f8_ccm.eol         <= ccm5.eol;
--    elsif(config_number_43 = 32)then
--        rgb_f8_ccm.red         <= "00" & ccc3.red(9 downto 2);
--        rgb_f8_ccm.green       <= "00" & ccc3.green(9 downto 2);
--        rgb_f8_ccm.blue        <= "00" & ccc3.blue(9 downto 2);
--        rgb_f8_ccm.valid       <= rgb_fr_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_fr_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_fr_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_fr_ccm.eol;
--    elsif(config_number_43 = 33)then
--        rgb_f8_ccm.red         <= "00" & rgb_fr_ccm.red(9 downto 2);
--        rgb_f8_ccm.green       <= "00" & rgb_fr_ccm.green(9 downto 2);
--        rgb_f8_ccm.blue        <= "00" & rgb_fr_ccm.blue(9 downto 2);
--        rgb_f8_ccm.valid       <= rgb_fr_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_fr_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_fr_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_fr_ccm.eol;
--    elsif(config_number_43 = 34)then
--        rgb_f8_ccm.red         <= "00" & rgb_fr_ccm.blue(9 downto 2);
--        rgb_f8_ccm.green       <= "00" & rgb_fr_ccm.blue(9 downto 2);
--        rgb_f8_ccm.blue        <= "00" & rgb_fr_ccm.blue(9 downto 2);
--        rgb_f8_ccm.valid       <= rgb_fr_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_fr_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_fr_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_fr_ccm.eol;
--    elsif(config_number_43 = 35)then
--        rgb_f8_ccm.red         <= rgb_h5_ccm.red;
--        rgb_f8_ccm.green       <= rgb_h5_ccm.red;
--        rgb_f8_ccm.blue        <= rgb_h5_ccm.red;
--        rgb_f8_ccm.valid       <= rgb_h5_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h5_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h5_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h5_ccm.eol;
--    elsif(config_number_43 = 36)then
--        rgb_f8_ccm.red         <= rgb_h5_ccm.green;
--        rgb_f8_ccm.green       <= rgb_h5_ccm.green;
--        rgb_f8_ccm.blue        <= rgb_h5_ccm.green;
--        rgb_f8_ccm.valid       <= rgb_h5_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h5_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h5_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h5_ccm.eol;
--    elsif(config_number_43 = 37)then
--        rgb_f8_ccm.red         <= rgb_h5_ccm.blue;
--        rgb_f8_ccm.green       <= rgb_h5_ccm.blue;
--        rgb_f8_ccm.blue        <= rgb_h5_ccm.blue;
--        rgb_f8_ccm.valid       <= rgb_h5_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_h5_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_h5_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_h5_ccm.eol;
--    else
--        rgb_f8_ccm.red         <= "00" & rgb_fr_ccm.red(9 downto 2);
--        rgb_f8_ccm.green       <= "00" & rgb_fr_ccm.green(9 downto 2);
--        rgb_f8_ccm.blue        <= "00" & rgb_fr_ccm.blue(9 downto 2);
--        rgb_f8_ccm.valid       <= rgb_fr_ccm.valid;
--        rgb_f8_ccm.eof         <= rgb_fr_ccm.eof;
--        rgb_f8_ccm.sof         <= rgb_fr_ccm.sof;
--        rgb_f8_ccm.eol         <= rgb_fr_ccm.eol;
--    end if;
--    end if;
--end process;
--rgb_range_5_inst: rgb_range
--generic map (
--    i_data_width       => FRAME_PIXEL_DEPTH)
--port map (                  
--    clk                => ivideo_aclk,
--    reset              => ivideo_aresetn,
--    gain               => config_number_16,
--    iRgb               => rgb_f8_ccm,
--    oRgb               => rgb_f9_ccm);
--process (ivideo_aclk)begin
--    if rising_edge(ivideo_aclk) then
--        if(config_number_18 = 0) then
--            ccx_rgb4_range <= rgb_f8_ccm;
--        else
--            ccx_rgb4_range <= rgb_f9_ccm;
--        end if;
--    end if;
--end process;
--l_blu_inst  : blur_filter
--generic map(
--    iMSB                => blurMsb,
--    iLSB                => blurLsb,
--    i_data_width        => FRAME_PIXEL_DEPTH,
--    img_width           => FRAME_WIDTH,
--    adwrWidth           => 16,
--    addrWidth           => 12)
--port map(
--    clk                 => ivideo_aclk,
--    rst_l               => ivideo_aresetn,
--    iRgb                => ccx_rgb4_range,
--    oRgb                => rgb_f9_ccc);
--filter_blur_3_inst  : blur_filter_4by4
--generic map(
--    iMSB                => blurMsb,
--    iLSB                => blurLsb,
--    i_data_width        => FRAME_PIXEL_DEPTH,
--    img_width           => FRAME_WIDTH,
--    adwrWidth           => 16,
--    addrWidth           => 12)
--port map(
--    clk                 => ivideo_aclk,
--    rst_l               => ivideo_aresetn,
--    iRgb                => rgb_f9_ccc,
--    i2Rgb               => rgb_f8_cmm,
--    oRgb                => rgb_f9_mmm);
--delta_check_inst  : delta_check
--port map(
--    clk                 => ivideo_aclk,
--    rst                 => ivideo_aresetn,
--    iRgb                => rgb_f8_cmm,
--    iHue                => rgb_f9_ccc,
--    oRGB                => rgb_f9_cmm);
----process (ivideo_aclk)begin
----    if rising_edge(ivideo_aclk) then
----        if(config_number_46 = 0) then
----            rgb_10_mmm <= rgb_f9_mmm;
----        else
----            rgb_10_mmm <= rgb_f9_cmm;
----        end if;
----    end if;
----end process;
----
----
----rgb_range_6_inst: rgb_range
----generic map (
----    i_data_width       => FRAME_PIXEL_DEPTH)
----port map (                  
----    clk                => ivideo_aclk,
----    reset              => ivideo_aresetn,
----    gain               => config_number_16,
----    iRgb               => rgb_10_mmm,
----    oRgb               => rgb_11_mmm);
--   ovideo_tstrb           <= ivideo_tstrb;
--   ovideo_tkeep           <= ivideo_tkeep;
--   ovideo_tdata           <= "00" & rgb_fr_ccm.red & rgb_fr_ccm.green & rgb_fr_ccm.blue;
--   ovideo_tvalid          <= rgb_fr_ccm.valid;
--   ovideo_tuser           <= rgb_fr_ccm.sof;
--   ovideo_tlast           <= rgb_fr_ccm.eol;
--   o1video_tstrb          <= ivideo_tstrb(2 downto 0);
--   o1video_tkeep          <= ivideo_tkeep(2 downto 0);
--   o1video_tdata          <= rgb_f8_ccm.green(7 downto 0) & rgb_f8_ccm.blue(7 downto 0) & rgb_f8_ccm.red(7 downto 0);
--   o1video_tvalid         <= rgb_f8_ccm.valid;
--   o1video_tuser          <= rgb_f8_ccm.sof;
--   o1video_tlast          <= rgb_f8_ccm.eol;
--   rgb_fr_plw_red         <= "00" & rgb_f8_ccm.red(7 downto 0);
--   rgb_fr_plw_gre         <= "00" & rgb_f8_ccm.green(7 downto 0);
--   rgb_fr_plw_blu         <= "00" & rgb_f8_ccm.blue(9 downto 2);
--   rgb_fr_plw_sof         <= rgb_f8_ccm.sof;
--   rgb_fr_plw_eol         <= rgb_f8_ccm.eol;
--   rgb_fr_plw_eof         <= rgb_f8_ccm.eof;
--   rgb_fr_plw_val         <= rgb_f8_ccm.valid;
--end arch_imp;