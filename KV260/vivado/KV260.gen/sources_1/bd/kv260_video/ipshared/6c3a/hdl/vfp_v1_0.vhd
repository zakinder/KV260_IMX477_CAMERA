--------------------------------------------------------------------------------------------
-- Filename      : vfp.vhd
-- Create Date   : 02092019 [02-09-2019]
-- Modified Date : 02052023 [02-05-2023]
-- Author        : Sakinder Ali
--------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vpf_records.all;
entity vfp_v1_0 is
    generic (
        revision_number           : std_logic_vector(31 downto 0) := x"02052023";
        C_vfpConfig_DATA_WIDTH    : integer    := 32;
        C_vfpConfig_ADDR_WIDTH    : integer    := 8;
        C_oVideo_TDATA_WIDTH      : integer    := 32;
        C_oVideo_START_COUNT      : integer    := 32;
        C_iVideo_TDATA_WIDTH      : integer    := 32;
        FRAME_PIXEL_DEPTH         : integer    := 10;
        FRAME_WIDTH               : natural    := 4096;
        FRAME_HEIGHT              : natural    := 3040);
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
        ovideo_tkeep              : out std_logic_vector(2 downto 0);
        ovideo_tdata              : out std_logic_vector(23 downto 0);
        ovideo_tstrb              : out std_logic_vector(2 downto 0);
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
        ivideo_tvalid             : in std_logic;
        video2_aclk               : in std_logic;
        video2_aresetn            : in std_logic;
        video2_tready             : out std_logic;
        video2_tkeep              : in std_logic_vector(3 downto 0);  
        video2_tdata              : in std_logic_vector(C_iVideo_TDATA_WIDTH-1 downto 0);
        video2_tstrb              : in std_logic_vector((C_iVideo_TDATA_WIDTH/8)-1 downto 0);
        video2_tlast              : in std_logic;
        video2_tuser              : in std_logic; 
        video2_tvalid             : in std_logic);
end vfp_v1_0;
architecture arch_imp of vfp_v1_0 is
    signal wr_regs, rd_regs : mRegs;
    signal pixels : std_logic_vector(C_iVideo_TDATA_WIDTH-1 downto 0);
    signal valid, ready, sof, eol, filtered, resetn : std_logic;
    signal rgb : std_logic_vector(23 downto 0);
    signal keep, strb : std_logic_vector(2 downto 0);
    signal start_of_frame, end_of_line, end_of_frame : std_logic;
    signal pending_rgb, pending_gbr : std_logic := '0';
    signal preview_eol, half_size_preview : std_logic;
    signal input_ready : std_logic;
    signal frame_dimensions : std_logic_vector(31 downto 0);
    signal next_x, next_y, pixel_x, pixel_y, frame_height_latched : unsigned(15 downto 0);
begin
    -- All VFP interfaces share pl_clk0 and its reset in the KV260 block design.
    resetn <= ivideo_aresetn and ovideo_aresetn and o1video_aresetn;
    video2_tready <= video2_aresetn;
    rd_regs <= (cfigReg0 => revision_number, cfigReg18 => wr_regs.cfigReg18,
                cfigReg19 => wr_regs.cfigReg19, others => (others => '0'));

vfpConfigInst: entity work.vfp_config
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

    surface_contour : entity work.surface_contour_select
        generic map (MAX_WIDTH => FRAME_WIDTH, MAX_HEIGHT => FRAME_HEIGHT,
                     DATA_WIDTH => C_iVideo_TDATA_WIDTH)
        port map (clk => ivideo_aclk, rst_n => resetn,
                  enable => wr_regs.cfigReg18(0), dimensions => wr_regs.cfigReg19,
                  s_data => ivideo_tdata, s_valid => ivideo_tvalid, s_ready => input_ready,
                  s_sof => ivideo_tuser, s_eol => ivideo_tlast,
                  m_data => pixels, m_valid => valid, m_ready => ready,
                  m_sof => sof, m_eol => eol, filtered => filtered);

    ivideo_tready <= input_ready;
    -- The filter may take several lines to produce its first output.
    process (ivideo_aclk)
    begin
        if rising_edge(ivideo_aclk) then
            if ivideo_tvalid = '1' and input_ready = '1' and ivideo_tuser = '1' then
                frame_dimensions <= wr_regs.cfigReg19;
            end if;
        end if;
    end process;

    -- Each VDMA consumes the registered beat once, even when TREADY differs.
    ready <= resetn and (not pending_rgb or ovideo_tready)
                    and (not pending_gbr or o1video_tready);

    distribute : process (ivideo_aclk)
        variable geometry : std_logic_vector(31 downto 0);
        variable half_size : std_logic;
        variable x, y, height : unsigned(15 downto 0);
    begin
        if rising_edge(ivideo_aclk) then
            if resetn = '0' then
                pending_rgb <= '0';
                pending_gbr <= '0';
                half_size_preview <= '0';
                next_x <= (others => '0');
                next_y <= (others => '0');
                frame_height_latched <= (others => '0');
            else
                if ovideo_tready = '1' then pending_rgb <= '0'; end if;
                if o1video_tready = '1' then pending_gbr <= '0'; end if;
                if valid = '1' and ready = '1' then
                    pending_rgb <= '1';
                    pending_gbr <= '1';
                    rgb <= pixels(29 downto 22) & pixels(19 downto 12) & pixels(9 downto 2);
                    start_of_frame <= sof;
                    end_of_line <= eol;
                    if filtered = '1' then
                        keep <= "111";
                        strb <= "111";
                    else
                        keep <= ivideo_tkeep(2 downto 0);
                        strb <= ivideo_tstrb(2 downto 0);
                    end if;
                    preview_eol <= eol;
                    half_size := half_size_preview;
                    x := next_x;
                    y := next_y;
                    height := frame_height_latched;
                    if sof = '1' then
                        x := (others => '0');
                        y := (others => '0');
                        if filtered = '1' then geometry := frame_dimensions;
                        else geometry := wr_regs.cfigReg19; end if;
                        height := unsigned(geometry(31 downto 16));
                        half_size := '0';
                        if geometry = x"08700F00" then -- 3840 x 2160
                            half_size := '1';
                        end if;
                        half_size_preview <= half_size;
                        frame_height_latched <= height;
                    end if;
                    -- VDMA1 has a 1920 x 1080 frame store in the 4K build.
                    if half_size = '1' then
                        pending_gbr <= not (x(0) or y(0));
                        if x = 3838 then preview_eol <= '1'; end if;
                    end if;
                    pixel_x <= x;
                    pixel_y <= y;
                    end_of_frame <= '0';
                    if eol = '1' then
                        next_x <= (others => '0');
                        next_y <= y + 1;
                        if y + 1 = height then end_of_frame <= '1'; end if;
                    else
                        next_x <= x + 1;
                        next_y <= y;
                    end if;
                end if;
            end if;
        end if;
    end process;

    ovideo_tdata <= rgb;
    o1video_tdata <= rgb(15 downto 0) & rgb(23 downto 16);
    ovideo_tvalid <= pending_rgb;
    o1video_tvalid <= pending_gbr;
    ovideo_tuser <= start_of_frame;
    o1video_tuser <= start_of_frame;
    ovideo_tlast <= end_of_line;
    o1video_tlast <= preview_eol;
    ovideo_tkeep <= keep;
    o1video_tkeep <= keep;
    ovideo_tstrb <= strb;
    o1video_tstrb <= strb;

    rgb_fr_plw_red <= "00" & rgb(23 downto 16);
    rgb_fr_plw_gre <= "00" & rgb(15 downto 8);
    rgb_fr_plw_blu <= "00" & rgb(7 downto 0);
    rgb_fr_plw_val <= pending_rgb and ovideo_tready;
    rgb_fr_plw_sof <= start_of_frame and pending_rgb and ovideo_tready;
    rgb_fr_plw_eol <= end_of_line and pending_rgb and ovideo_tready;
    rgb_fr_plw_eof <= end_of_frame and pending_rgb and ovideo_tready;
    rgb_fr_plw_xcnt <= std_logic_vector(pixel_x);
    rgb_fr_plw_ycnt <= std_logic_vector(pixel_y);
    crd_x <= std_logic_vector(pixel_x);
    crd_y <= std_logic_vector(pixel_y);
end arch_imp;
