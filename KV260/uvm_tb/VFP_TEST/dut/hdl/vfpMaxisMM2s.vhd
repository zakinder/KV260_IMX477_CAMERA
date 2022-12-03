--05012019 [05-01-2019]
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity videoProcess_v1_0_m_axis_mm2s is
generic (
    s_data_width	                : integer := 16);
port (
    aclk                            : in std_logic;
    aresetn                         : in std_logic;
    rgb_s_axis_tready               : out std_logic;
    rgb_s_axis_tvalid               : in std_logic;
    rgb_s_axis_tuser                : in std_logic;
    rgb_s_axis_tlast                : in std_logic;
    rgb_s_axis_tdata                : in std_logic_vector(s_data_width-1  downto 0);
    m_axis_mm2s_tkeep               : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tstrb               : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tid                 : out std_logic_vector(0 downto 0);
    m_axis_mm2s_tdest               : out std_logic_vector(0 downto 0);  
    m_axis_mm2s_tready              : in std_logic;
    m_axis_mm2s_tvalid              : out std_logic;
    m_axis_mm2s_tuser               : out std_logic;
    m_axis_mm2s_tlast               : out std_logic;
    m_axis_mm2s_tdata               : out std_logic_vector(s_data_width-1 downto 0));
end videoProcess_v1_0_m_axis_mm2s;
architecture arch_imp of videoProcess_v1_0_m_axis_mm2s is
    type pixel_locations is (video_trans_in_progress,wait_to_go);
    signal pixel_locations_address  : pixel_locations; 
    signal axis_tvalid              : std_logic:= lo;
    signal axis_tuser               : std_logic:= lo;
    signal axis_tlast               : std_logic:= lo;
    signal axis_tdata               : std_logic_vector(s_data_width-1 downto 0):= (others => lo); 
    signal maxis_mm2s_tdata         : std_logic_vector(s_data_width-1 downto 0):= (others => lo);
    signal maxis_mm2s_tuser         : std_logic:= lo;
    signal maxis_mm2s_tvalid        : std_logic:= lo;
    signal maxis_mmss_tvalid        : std_logic:= lo;
    signal mm2s_tready              : std_logic:= lo;
    signal sync_tlast               : std_logic:= lo;
    signal s_axis_aclk                     : std_logic;
    signal s_axis_aresetn                  : std_logic;
    signal s_axis_tready                   : std_logic;
    signal s_axis_tdata                    : std_logic_vector(23 downto 0);
    signal s_axis_tstrb                    : std_logic_vector(2 downto 0);
    signal s_axis_tkeep                    : std_logic_vector(2 downto 0);        
    signal s_axis_tlast                    : std_logic;
    signal s_axis_tuser                    : std_logic;
    signal s_axis_tvalid                   : std_logic;
    signal video_out_aclk                  : std_logic;
    signal video_out_aresetn               : std_logic;
    signal video_out_tvalid                : std_logic;
    signal video_out_tdata                 : std_logic_vector(23 downto 0);
    signal video_out_tstrb                 : std_logic_vector(2 downto 0);
    signal video_out_tkeep                 : std_logic_vector(2 downto 0);
    signal video_out_tlast                 : std_logic;
    signal video_out_tuser                 : std_logic;        
    signal video_out_tready                : std_logic;
    signal sof_pulse                       : std_logic :='0';
    signal axis_sof                        : std_logic;
    type video_io_state is (VIDEO_SET_RESET,VIDEO_SOF_OFF,VIDEO_SOF_ON,VIDEO_END_OF_LINE);
    signal VIDEO_STATES      : video_io_state;
begin

s_axis_aclk     <= aclk;
s_axis_aresetn  <= aresetn;
--s_axis_tready   <= xx;
s_axis_tdata    <=  rgb_s_axis_tdata;
--s_axis_tstrb    <= xx;
--s_axis_tkeep    <= xx;
s_axis_tlast    <= rgb_s_axis_tlast;
s_axis_tuser    <= rgb_s_axis_tuser;
s_axis_tvalid   <= rgb_s_axis_tvalid;




process(aclk) begin
    if rising_edge(aclk) then
        axis_tvalid <= rgb_s_axis_tvalid;
        mm2s_tready <= m_axis_mm2s_tready;
        axis_tuser  <= rgb_s_axis_tuser;
        sync_tlast  <= rgb_s_axis_tlast;
        if (s_data_width  = 16)then-- initiate response
            axis_tdata  <= std_logic_vector(resize(unsigned(rgb_s_axis_tdata(15 downto 8) & rgb_s_axis_tdata(7 downto 0)), axis_tdata'length));
        else
            axis_tdata  <= std_logic_vector(resize(unsigned(rgb_s_axis_tdata(23 downto 16) &rgb_s_axis_tdata(15 downto 8) & rgb_s_axis_tdata(7 downto 0)), axis_tdata'length));
        end if; 
        --axis_tdata  <= rgb_s_axis_tdata(15 downto 8) & rgb_s_axis_tdata(7 downto 0);
    end if;
end process;
process (aclk) begin
    if (rising_edge (aclk)) then
        if (aresetn = lo) then
            pixel_locations_address <= wait_to_go;
            rgb_s_axis_tready       <=lo;
        else
        case (pixel_locations_address) is
        when wait_to_go =>
            axis_tlast         <=lo;
            rgb_s_axis_tready  <=hi;--initiate
            maxis_mm2s_tvalid  <=lo;
            if (rgb_s_axis_tvalid  = hi)then-- initiate response
                pixel_locations_address <= video_trans_in_progress;            
            else
                pixel_locations_address <= wait_to_go;    
            end if;        
        when video_trans_in_progress =>
            maxis_mm2s_tuser   <= axis_tuser;
            maxis_mm2s_tdata   <= axis_tdata;
            if (sync_tlast = hi)then
                axis_tlast <=hi;
                maxis_mm2s_tvalid  <=lo;
                pixel_locations_address <= wait_to_go;
            else
                axis_tlast <=lo;
                maxis_mm2s_tvalid  <=hi;
                pixel_locations_address <= video_trans_in_progress;
            end if;
        when others =>
            pixel_locations_address <= wait_to_go;
        end case;
        end if;
    end if;
end process;
process(aclk) begin
    if rising_edge(aclk) then
        m_axis_mm2s_tkeep      <= (others => hi);
        m_axis_mm2s_tid        <= "0";
        m_axis_mm2s_tdest      <= "0";
        m_axis_mm2s_tstrb      <= (others => hi);
        m_axis_mm2s_tdata      <= maxis_mm2s_tdata;
        m_axis_mm2s_tlast      <= axis_tlast;
        m_axis_mm2s_tuser      <= maxis_mm2s_tuser;
        m_axis_mm2s_tvalid     <= maxis_mm2s_tvalid or maxis_mmss_tvalid;
    end if;
end process;
process(aclk) begin
    if rising_edge(aclk) then
        maxis_mmss_tvalid  <= maxis_mm2s_tvalid;
    end if;
end process;

        s_axis_tready          <= '1';
        video_out_tstrb        <= (others => '1');
        video_out_tkeep        <= (others => '1');
process (s_axis_aclk) begin
    if (rising_edge (s_axis_aclk)) then
        if (s_axis_aresetn = '0') then
            VIDEO_STATES <= VIDEO_SET_RESET;
        else
            video_out_tuser <=axis_sof;
        --continue to check sof pulse. Enable sof pulse.
        if(s_axis_tuser = '1') then
            sof_pulse <= '1';
        end if;
        case (VIDEO_STATES) is
        when VIDEO_SET_RESET =>
            video_out_tlast  <= '0';
            video_out_tvalid <= '0';
            video_out_tdata  <= (others => '0');
            axis_sof         <= '0';
        --sof from slave
        if (sof_pulse = '1') then
            VIDEO_STATES <= VIDEO_SOF_OFF;
            sof_pulse    <= '0';
        else
            VIDEO_STATES <= VIDEO_SET_RESET;
        end if;
        when VIDEO_SOF_OFF =>
        if (s_axis_tvalid = '1') then
            VIDEO_STATES <= VIDEO_SOF_ON;
            --assert sof for master
            axis_sof     <= '1';
        else
            VIDEO_STATES <= VIDEO_SOF_OFF;
        end if;
        when VIDEO_SOF_ON =>
            axis_sof         <= '0';
			video_out_tvalid <= '1';
			video_out_tdata  <= s_axis_tdata;
        if (s_axis_tvalid = '1') then
            video_out_tlast  <= '0';
            VIDEO_STATES   <= VIDEO_SOF_ON;
        else
            video_out_tlast  <= '1';
            VIDEO_STATES   <= VIDEO_END_OF_LINE;
        end if;
        when VIDEO_END_OF_LINE =>
            video_out_tlast  <= '0';
            video_out_tvalid <= '0';
            if (sof_pulse = '1') then
                VIDEO_STATES <= VIDEO_SOF_OFF;
				sof_pulse    <= '0';
            elsif (s_axis_tvalid = '1') then
                VIDEO_STATES <= VIDEO_SOF_ON;
            else
                VIDEO_STATES <= VIDEO_END_OF_LINE;
            end if;
        when others =>
            VIDEO_STATES <= VIDEO_SET_RESET;
        end case;
        end if;
    end if;
end process;



end arch_imp;