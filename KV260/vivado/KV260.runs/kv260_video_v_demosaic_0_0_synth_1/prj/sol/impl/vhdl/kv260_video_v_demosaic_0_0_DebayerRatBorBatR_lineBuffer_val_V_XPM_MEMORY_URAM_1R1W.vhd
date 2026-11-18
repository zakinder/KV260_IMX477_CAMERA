-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
-- Tool Version Limit: 2022.04
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
--

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library xpm;
use xpm.vcomponents.all;

entity kv260_video_v_demosaic_0_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram is 
   generic(
  -- Common module parameters
       DATA_WIDTH         : integer := 30;
       ADDR_WIDTH         : integer := 13;
       DEPTH              : integer := 4097;
       MEMORY_SIZE        : integer := 122910;
       MEMORY_PRIMITIVE   : string  := "ultra";
       CLOCKING_MODE      : string  := "common_clock";
       ECC_MODE           : string  := "no_ecc";
       MEMORY_INIT_FILE   : string  := "none";
       WAKEUP_TIME        : string  := "disable_sleep";
       MESSAGE_CONTROL    : integer := 0;

  -- Port A module parameters
       WRITE_DATA_WIDTH_A : integer := 30;
       BYTE_WRITE_WIDTH_A : integer := 30;
       ADDR_WIDTH_A       : integer := 13;

  -- Port B module parameters
       READ_DATA_WIDTH_B  : integer := 30;
       ADDR_WIDTH_B       : integer := 13;
       READ_RESET_VALUE_B : string  := "0";
       READ_LATENCY_B     : integer := 1;
       WRITE_MODE_B       : string  := "read_first"

   ); 
    port (
  -- Port A module ports
       clka    : in std_logic;
       ena     : in std_logic;
       wea     : in std_logic;
       addra   : in std_logic_vector(ADDR_WIDTH_A-1 downto 0);
       dina    : in std_logic_vector(DATA_WIDTH-1 downto 0);
  -- Port B module ports
       clkb    : in std_logic;
       rstb    : in std_logic;
       enb     : in std_logic;
       addrb   : in std_logic_vector(ADDR_WIDTH_B-1 downto 0);
       doutb   : out std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end entity;


architecture rtl of kv260_video_v_demosaic_0_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram is 
   signal wea_vector : std_logic_vector((WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1 downto 0);
-- Set generic values and connect ports to instantiate an XPM_MEMORY simple dual port RAM configuration

-----Use the following component declaration in your design-----
component xpm_memory_sdpram
  generic (

    -- Common module generics
    MEMORY_SIZE        : integer;
    MEMORY_PRIMITIVE   : string;
    CLOCKING_MODE      : string;
    ECC_MODE           : string;
    MEMORY_INIT_FILE   : string;
    MEMORY_INIT_PARAM  : string;
    WAKEUP_TIME        : string;
    MESSAGE_CONTROL    : integer;

    -- Port A module generics
    WRITE_DATA_WIDTH_A : integer;
    BYTE_WRITE_WIDTH_A : integer;
    ADDR_WIDTH_A       : integer;

    -- Port B module generics
    READ_DATA_WIDTH_B  : integer;
    ADDR_WIDTH_B       : integer;
    READ_RESET_VALUE_B : string;
    READ_LATENCY_B     : integer;
    WRITE_MODE_B       : string
  );
  port (

    -- Common module ports
    sleep          : in  std_logic;

    -- Port A module ports
    clka           : in  std_logic;
    ena            : in  std_logic;
    wea            : in  std_logic_vector((WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1 downto 0);
    addra          : in  std_logic_vector(ADDR_WIDTH_A-1 downto 0);
    dina           : in  std_logic_vector(WRITE_DATA_WIDTH_A-1 downto 0);
    injectsbiterra : in  std_logic;
    injectdbiterra : in  std_logic;

    -- Port B module ports
    clkb           : in  std_logic;
    rstb           : in  std_logic;
    enb            : in  std_logic;
    regceb         : in  std_logic;
    addrb          : in  std_logic_vector(ADDR_WIDTH_B-1 downto 0);
    doutb          : out std_logic_vector(READ_DATA_WIDTH_B-1 downto 0);
    sbiterrb       : out std_logic;
    dbiterrb       : out std_logic
  );
end component;

begin
   wea_vector(0) <= wea;
-----Cut code below this line and paste into the architecture body-----
xpm_memory_sdpram_inst : xpm_memory_sdpram
  generic map (

    -- Common module generics
    MEMORY_SIZE        => MEMORY_SIZE,        --positive integer
    MEMORY_PRIMITIVE   => MEMORY_PRIMITIVE,   --string; "auto", "distributed", "block" or "ultra" 
    CLOCKING_MODE      => CLOCKING_MODE,      --string; "common_clock", "independent_clock"
    ECC_MODE           => ECC_MODE,           --do not change
    MEMORY_INIT_FILE   => MEMORY_INIT_FILE,   --string; "none" or "<filename>.mem" 
    MEMORY_INIT_PARAM  => "0",                --string
    WAKEUP_TIME        => WAKEUP_TIME,        --string; "disable_sleep" or "use_sleep_pin"
    MESSAGE_CONTROL    => MESSAGE_CONTROL,    --do not change

    -- Port A module generics
    WRITE_DATA_WIDTH_A => WRITE_DATA_WIDTH_A, --positive integer
    BYTE_WRITE_WIDTH_A => BYTE_WRITE_WIDTH_A, --integer; 8, 9, or WRITE_DATA_WIDTH_A value
    ADDR_WIDTH_A       => ADDR_WIDTH_A,       --positive integer

    -- Port B module generics
    READ_DATA_WIDTH_B  => READ_DATA_WIDTH_B,  --positive integer
    ADDR_WIDTH_B       => ADDR_WIDTH_B,       --positive integer
    READ_RESET_VALUE_B => READ_RESET_VALUE_B, --string
    READ_LATENCY_B     => READ_LATENCY_B,     --non-negative integer
    WRITE_MODE_B       => WRITE_MODE_B        --string; "write_first", "read_first", "no_change"
  )
  port map (

    -- Common module ports
    sleep          => '0',   --do not change

    -- Port A module ports
    clka           => clka,
    ena            => ena,
    wea            => wea_vector,
    addra          => addra,
    dina           => dina,
    injectsbiterra => '0',   --do not change
    injectdbiterra => '0',   --do not change

    -- Port B module ports
    clkb           => clkb,
    rstb           => rstb,
    enb            => enb,
    regceb         => enb,
    addrb          => addrb,
    doutb          => doutb,
    sbiterrb       => open,  --do not change
    dbiterrb       => open   --do not change
  );

end rtl;

Library IEEE;
use IEEE.std_logic_1164.all;

entity kv260_video_v_demosaic_0_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W is
    generic (
        DataWidth : INTEGER := 30;
        AddressRange : INTEGER := 4097;
        AddressWidth : INTEGER := 13);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        address1 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce1 : IN STD_LOGIC;
        we0 : IN STD_LOGIC;
        d0 : IN STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0);
        q1 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of kv260_video_v_demosaic_0_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W is
    component kv260_video_v_demosaic_0_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram is
        generic (
            DATA_WIDTH : INTEGER;
            ADDR_WIDTH : INTEGER;
            DEPTH : INTEGER);
        port (
            clka : IN STD_LOGIC;
            clkb : IN STD_LOGIC;
            rstb : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR;
            ena : IN STD_LOGIC;
            addrb : IN STD_LOGIC_VECTOR;
            enb : IN STD_LOGIC;
            dina : IN STD_LOGIC_VECTOR;
            wea : IN STD_LOGIC;
            doutb : OUT STD_LOGIC_VECTOR);
    end component;



begin
    kv260_video_v_demosaic_0_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram_U :  component kv260_video_v_demosaic_0_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram
    generic map (
        DATA_WIDTH => DataWidth,
        ADDR_WIDTH => AddressWidth,
        DEPTH => AddressRange)
    port map (
        clka => clk,
        clkb => clk,
        rstb => reset,
        addra => address0,
        ena => ce0,
        addrb => address1,
        enb => ce1,
        dina => d0,
        wea => we0,
        doutb => q1);

end architecture;


