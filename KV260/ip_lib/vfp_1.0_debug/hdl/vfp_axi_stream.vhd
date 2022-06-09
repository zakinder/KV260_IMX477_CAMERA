-------------------------------------------------------------------------------
--
-- Filename    : VFP_v1_0.vhd
-- Create Date : 05012019 [05-01-2019]
-- Author      : Zakinder
--
-- Description:
-- T'1's file instantiation axi4 components.
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity vfp_axi_stream is
    generic (
    TDATA_WIDTH                     : natural    := 32;
    FRAME_PIXEL_DEPTH               : natural    := 10;
    FRAME_WIDTH                     : natural    := 1920;
    FRAME_HEIGHT                    : natural    := 1080);
    port (
    s_axis_aclk                     : in std_logic;
    s_axis_aresetn                  : in std_logic;
    s_axis_tready                   : out std_logic;
    s_axis_tdata                    : in std_logic_vector(TDATA_WIDTH-1 downto 0);        
    s_axis_tlast                    : in std_logic;
    s_axis_tuser                    : in std_logic;
    s_axis_tvalid                   : in std_logic;
    oCord_x                         : out std_logic_vector(15 downto 0);
    oCord_y                         : out std_logic_vector(15 downto 0);
    oRgb                            : out channel);
end vfp_axi_stream;
architecture arch_imp of vfp_axi_stream is
    type video_io_state is (VIDEO_SET_RESET,VIDEO_SOF_OFF,VIDEO_SOF_ON);
    signal VIDEO_STATES      : video_io_state;
    type video_out_state is (V_SOF,V_LINE);
    signal VIDEO_OUT_STATES      : video_out_state;
    signal Xcont             : integer := 0;
    signal Ycont             : integer := 0;
    signal XrCont            : integer := 0;
    signal X1Cont            : integer := 0;
    signal YrCont            : integer := 0;
    signal Y1Cont            : integer := 0;
    signal Y2Cont            : integer := 0;
    
    signal vdata             : std_logic_vector(TDATA_WIDTH-1 downto 0);
    type ram_type is array (0 to FRAME_WIDTH-1) of std_logic_vector(TDATA_WIDTH-1 downto 0);
    signal rowbuffer     : ram_type := (others => (others => '0'));
begin
        oCord_x                <= std_logic_vector(to_unsigned(Xcont, 16));
        oCord_y                <= std_logic_vector(to_unsigned(Ycont, 16));
        s_axis_tready          <= '1';
process (s_axis_aclk) begin
    if (rising_edge (s_axis_aclk)) then
        if (s_axis_aresetn = '0') then
            VIDEO_STATES <= VIDEO_SET_RESET;
        else
        case (VIDEO_STATES) is
        when VIDEO_SET_RESET =>
            Xcont            <= 0;
            Ycont            <= 0;
            VIDEO_STATES     <= VIDEO_SOF_OFF;
        when VIDEO_SOF_OFF =>
            Xcont            <= 0;
            Ycont            <= 0;
            if (s_axis_tuser  = '1') then
                VIDEO_STATES <= VIDEO_SOF_ON;
            else
                VIDEO_STATES <= VIDEO_SOF_OFF;
            end if;
        when VIDEO_SOF_ON =>
            if (s_axis_tvalid = '0' and s_axis_tuser  = '1') then
                VIDEO_STATES     <= VIDEO_SOF_OFF;
            else
                VIDEO_STATES     <= VIDEO_SOF_ON;
            end if;
            if (s_axis_tvalid = '1' and s_axis_tlast = '1') then
                Xcont            <= 0;
                Ycont            <= Ycont + 1;
            else 
                if (s_axis_tvalid = '1') then
                    Xcont <= Xcont + 1;
                end if;
            end if;
        when others =>
            VIDEO_STATES <= VIDEO_SET_RESET;
        end case;
        end if;
    end if;
end process;
process (s_axis_aclk) begin
    if (rising_edge (s_axis_aclk)) then
        if (s_axis_aresetn = '0') then
            VIDEO_OUT_STATES <= V_SOF;
        else
        case (VIDEO_OUT_STATES) is
        when V_SOF  =>
            oRgb.eol        <= '0';
            oRgb.valid      <= '0';
            oRgb.eof        <= '0';
            if (s_axis_tuser = '1') then
                oRgb.sof        <= '1';
            end if;
            if (s_axis_tlast = '1') then
                VIDEO_OUT_STATES <= V_LINE;
            else
                VIDEO_OUT_STATES <= V_SOF;
                XrCont               <= 0;
            end if;
        when V_LINE =>
            if (XrCont = 1) then
                oRgb.sof             <= '0';
            end if;
            if (XrCont = FRAME_WIDTH-1) then
                oRgb.eol             <= '1';
            end if;
            if (XrCont < FRAME_WIDTH-1) then
                XrCont               <= XrCont + 1;
                oRgb.valid           <= '1';
                VIDEO_OUT_STATES     <= V_LINE;
                if ((YrCont = FRAME_HEIGHT-1) and (XrCont = FRAME_WIDTH-2)) then
                    oRgb.eof           <= '1';
                else
                    oRgb.eof           <= '0';
                end if;
            else
                VIDEO_OUT_STATES     <= V_SOF;
                if (YrCont < FRAME_WIDTH-1)then
                    YrCont               <= YrCont + 1;
                else
                    YrCont               <= 0;
                end if;

            end if;
        when others =>
            VIDEO_OUT_STATES <= V_SOF;
        end case;
        end if;
    end if;
end process;
process (s_axis_aclk) begin
    if rising_edge(s_axis_aclk) then
        if (s_axis_tvalid = '1') then
            rowbuffer(Xcont) <= s_axis_tdata;
        end if;
    end if;
end process;
process (s_axis_aclk) begin
    if rising_edge(s_axis_aclk) then
        vdata       <= rowbuffer(XrCont);
    end if;
end process;
process (s_axis_aclk) begin
    if rising_edge(s_axis_aclk) then
        X1Cont       <= XrCont;
        Y1Cont       <= YrCont;
        Y2Cont       <= Y1Cont;
    end if;
end process;

   oRgb.red         <= vdata(29 downto 20);
   oRgb.green       <= vdata(19 downto 10);
   oRgb.blue        <= vdata(9 downto 0);
   oRgb.ycnt        <= Y2Cont;
   oRgb.xcnt        <= X1Cont;
   
   
   
end arch_imp;