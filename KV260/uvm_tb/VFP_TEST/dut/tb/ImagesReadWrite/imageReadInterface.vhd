library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants_package.all;
use work.vfp_pkg.all;
use work.vpf_records.all;
use work.ports_package.all;
entity imageReadInterface is
generic (
    i_data_width         : integer := 8;
    img_frames_cnt_bmp   : integer := 2;
    img_width_bmp        : integer := 400;
    img_height_bmp       : integer := 300;
    read_bmp             : string  := "input_image");
port (
    --
    clk                  : in  std_logic;
    reset                : in  std_logic;
    aclk                 : out std_logic;
    --From Dut: d5m camera processed data
    m_axis_mm2s_aclk     : in  std_logic;
    m_axis_mm2s_tvalid   : in  std_logic;
    m_axis_mm2s_tdata    : in std_logic_vector(23 downto 0);
    --From Driver: kind of test: image file/ pattern test
    iReadyToRead         : in  std_logic;
    iImageTypeTest       : in  std_logic;
    --From Driver: pattern test
    iRgb                 : in std_logic_vector(23 downto 0);
    ilvalid              : in std_logic;
    ifvalid              : in std_logic;
    --To Dut: d5m camera raw data
    pix_clk              : out std_logic;
    rgb                  : out std_logic_vector(23 downto 0);
    lvalid               : out std_logic;
    fvalid               : out std_logic;
    --To Monitor: to collect coverage
    valid                : out std_logic;
    red                  : out std_logic_vector(7 downto 0);
    green                : out std_logic_vector(7 downto 0);
    blue                 : out std_logic_vector(7 downto 0);
    xCord                : out std_logic_vector(11 downto 0);
    yCord                : out std_logic_vector(11 downto 0);
    endOfFrame           : out std_logic);
end imageReadInterface;
architecture Behavioral of imageReadInterface is
    signal   pFileCont           : cord;
    signal   rgbRead             : channel;
    signal   txCord              : coord;
    signal   wTxCord             : coord;
    signal   mm2rgb              : channel;
    signal   mm2rgb1Sync         : channel;
    signal   mm2rgb2Sync         : channel;
    signal   enableWrite         : std_logic := lo;
    signal   doneWrite           : std_logic := lo;
    signal   doneTask            : std_logic := lo;
    signal   end_of_frame        : std_logic := lo;
    signal   l_valid             : std_logic := lo;
    signal   f_valid             : std_logic := lo;
    signal   dFrameEnable        : std_logic := lo;
    signal   valid1Sync          : std_logic := lo;
    signal   valid2Sync          : std_logic := lo;
    signal   validFrameRiPulse   : std_logic := lo;
    signal   vFrameSync1Pulse    : std_logic := lo;
    signal   vFrameSync2Pulse    : std_logic := lo;
    signal   vFrameSync3Pulse    : std_logic := lo;
    signal   vFrameSync4Pulse    : std_logic := lo;
    signal   vFrameSync5Pulse    : std_logic := lo;
    signal   vFrameSync6Pulse    : std_logic := lo;
    signal   valid2ndFrame       : std_logic := lo;
    signal   i_count             : integer := 0;
    signal   pixclk              : std_logic := lo;
begin


    clk_gen(aclk,mm2s_aclk);
    clk_gen(pixclk,pixclk_freq);
    pix_clk <= pixclk;
    
    rgb                          <= (rgbRead.red & rgbRead.green &  rgbRead.blue) when (iImageTypeTest = lo) else iRgb;
    lvalid                       <= l_valid when (iImageTypeTest = lo) else ilvalid;
    fvalid                       <= f_valid when (iImageTypeTest = lo) else ifvalid;
    
    mm2rgb.valid                 <= m_axis_mm2s_tvalid;
    mm2rgb.red                   <= m_axis_mm2s_tdata(23 downto 16);
    mm2rgb.green                 <= m_axis_mm2s_tdata(15 downto 8);
    mm2rgb.blue                  <= m_axis_mm2s_tdata(7 downto 0);
    
    valid                        <= mm2rgb1Sync.valid and dFrameEnable;
    red                          <= mm2rgb1Sync.red;
    green                        <= mm2rgb1Sync.green;
    blue                         <= mm2rgb1Sync.blue;
    xCord                        <= wTxCord.x(11 downto 0);
    yCord                        <= wTxCord.y(11 downto 0);
    enableWrite                  <= hi when (mm2rgb.valid = hi);
    doneTask                     <= hi when (iReadyToRead = hi and doneWrite = lo) else lo;
    endOfFrame                   <= hi when (doneWrite = hi) else lo;
    
process (clk) begin
    if rising_edge(clk) then
        valid1Sync    <= ifvalid;
        valid2Sync    <= valid1Sync;
    end if;
end process;

validFrameRiPulse <= hi when (valid1Sync = hi and valid2Sync = lo) else lo;

process (clk) begin
    if rising_edge(clk) then
        if (vFrameSync6Pulse = hi) then
            i_count <= i_count + 1;
        end if;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        vFrameSync1Pulse  <= validFrameRiPulse;
        vFrameSync2Pulse  <= vFrameSync1Pulse;
        vFrameSync3Pulse  <= vFrameSync2Pulse;
        vFrameSync4Pulse  <= vFrameSync3Pulse;
        vFrameSync5Pulse  <= vFrameSync4Pulse;
        vFrameSync6Pulse  <= vFrameSync5Pulse;
    end if;
end process;

valid2ndFrame <= hi when (i_count = 0);

process (clk) begin
    if rising_edge(clk) then
        mm2rgb1Sync   <= mm2rgb;
        mm2rgb2Sync   <= mm2rgb1Sync;
    end if;
end process;


ImageReadInst: imageRead
generic map (
    i_data_width          => i_data_width,
    img_frames_cnt_bmp    => img_frames_cnt_bmp,
    img_width_bmp         => img_width_bmp,
    img_height_bmp        => img_height_bmp,
    input_file            => read_bmp)
port map (                  
    clk                   => pixclk,
    reset                 => reset,
    readyToRead           => doneTask,
    fvalid                => f_valid,
    lvalid                => l_valid,
    oRgb                  => rgbRead,
    oFileCont             => pFileCont,
    oCord                 => txCord,
    endOfFrame            => end_of_frame);
    
    
imageWriteInst: imageWrite
generic map (
    enImageText           => false,
    enImageIndex          => false,
    i_data_width          => i_data_width,
    img_width_bmp         => img_width_bmp,
    img_height_bmp        => img_height_bmp,
    input_file            => read_bmp,
    output_file           => read_bmp)
port map (
    clk                   => clk,
    iFile                 => rgbRead,
    iFileCont             => pFileCont,
    pixclk                => m_axis_mm2s_aclk,
    enableWrite           => enableWrite,
    doneWrite             => doneWrite,
    oFrameEnable          => dFrameEnable,
    oCord                 => wTxCord,
    iRgb                  => mm2rgb);
end Behavioral;