-------------------------------------------------------------------------------
--
-- Filename    : VFP_v1_0.vhd
-- Create Date : 02072019 [02-07-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation axi4 components.
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity vfp_config is
    generic (
        revision_number          : std_logic_vector(31 downto 0) := x"00000000";
        conf_data_width          : integer    := 32;
        conf_addr_width          : integer    := 8);
    port (
        wrRegsOut                : out mRegs;
        rdRegsIn                 : in mRegs;
        S_AXI_ACLK               : in std_logic;
        S_AXI_ARESETN            : in std_logic;
        S_AXI_AWADDR             : in std_logic_vector(conf_addr_width-1 downto 0);
        S_AXI_AWPROT             : in std_logic_vector(2 downto 0);
        S_AXI_AWVALID            : in std_logic;
        S_AXI_AWREADY            : out std_logic;
        S_AXI_WDATA              : in std_logic_vector(conf_data_width-1 downto 0);
        S_AXI_WSTRB              : in std_logic_vector((conf_data_width/8)-1 downto 0);
        S_AXI_WVALID             : in std_logic;
        S_AXI_WREADY             : out std_logic;
        S_AXI_BRESP              : out std_logic_vector(1 downto 0);
        S_AXI_BVALID             : out std_logic;
        S_AXI_BREADY             : in std_logic;
        S_AXI_ARADDR             : in std_logic_vector(conf_addr_width-1 downto 0);
        S_AXI_ARPROT             : in std_logic_vector(2 downto 0);
        S_AXI_ARVALID            : in std_logic;
        S_AXI_ARREADY            : out std_logic;
        S_AXI_RDATA              : out std_logic_vector(conf_data_width-1 downto 0);
        S_AXI_RRESP              : out std_logic_vector(1 downto 0);
        S_AXI_RVALID             : out std_logic;
        S_AXI_RREADY             : in std_logic);
end vfp_config;
architecture arch_imp of vfp_config is
    constant ADDR_LSB            : integer := (conf_data_width/32)+ 1;
    constant OPT_MEM_ADDR_BITS   : integer := 5;
    signal axi_awaddr            : std_logic_vector(conf_addr_width-1 downto 0);
    signal axi_awready           : std_logic;
    signal axi_wready            : std_logic;
    signal axi_bresp             : std_logic_vector(1 downto 0);
    signal axi_bvalid            : std_logic;
    signal axi_araddr            : std_logic_vector(conf_addr_width-1 downto 0);
    signal axi_arready           : std_logic;
    signal axi_rdata             : std_logic_vector(conf_data_width-1 downto 0);
    signal axi_rresp             : std_logic_vector(1 downto 0);
    signal axi_rvalid            : std_logic;
    signal slv_reg_rden          : std_logic;
    signal slv_reg_wren          : std_logic;
    signal reg_data_out          : std_logic_vector(conf_data_width-1 downto 0);
    signal byte_index            : integer;
    signal aw_en                 : std_logic;
    signal localRegs             : mRegs;
begin
-- transfer response ack and data of request.
S_AXI_AWREADY    <= axi_awready;
S_AXI_WREADY     <= axi_wready;
S_AXI_BRESP      <= axi_bresp;
S_AXI_BVALID     <= axi_bvalid;
S_AXI_ARREADY    <= axi_arready;
S_AXI_RDATA      <= axi_rdata;
S_AXI_RRESP      <= axi_rresp;
S_AXI_RVALID     <= axi_rvalid;
-- generate address write valid ready response pulse to master. need to find why used aw_en since it become always enabled.
process (S_AXI_ACLK) begin
    if rising_edge(S_AXI_ACLK) then
        if S_AXI_ARESETN = lo then
        axi_awready     <= lo;
        aw_en           <= hi;--may not needed.
    else
        if (axi_awready = lo and S_AXI_AWVALID = hi and S_AXI_WVALID = hi and aw_en = hi) then
            axi_awready <= hi;
        elsif (S_AXI_BREADY = hi and axi_bvalid = hi) then
            aw_en       <= hi;--may not needed.
            axi_awready <= lo;
        else
            axi_awready <= lo;
        end if;
      end if;
    end if;
end process;
-- Capture requested write address when address valid pulse is asserted to master.
-- Min two clock cycles are required for S_AXI_AWVALID and S_AXI_WVALID inorder to capture the waddress.
process (S_AXI_ACLK) begin
    if rising_edge(S_AXI_ACLK) then
        if S_AXI_ARESETN = lo then
            axi_awaddr <= (others => '0');
        else
            if (axi_awready = lo and S_AXI_AWVALID = hi and S_AXI_WVALID = hi and aw_en = hi) then
                axi_awaddr <= S_AXI_AWADDR;
            end if;
        end if;
    end if;
end process;
process (S_AXI_ACLK)
begin
  if rising_edge(S_AXI_ACLK) then
    if S_AXI_ARESETN = lo then
      axi_wready <= lo;
    else
      if (axi_wready = lo and S_AXI_WVALID = hi and S_AXI_AWVALID = hi and aw_en = hi) then
          axi_wready <= hi;
      else
        axi_wready <= lo;
      end if;
    end if;
  end if;
end process;
slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;
process (S_AXI_ACLK)
variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
begin
  if rising_edge(S_AXI_ACLK) then
    if S_AXI_ARESETN = lo then
      localRegs.cfigReg0 <= (others => '0');
      localRegs.cfigReg1 <= (others => '0');
      localRegs.cfigReg2 <= (others => '0');
      localRegs.cfigReg3 <= (others => '0');
      localRegs.cfigReg4 <= (others => '0');
      localRegs.cfigReg5 <= (others => '0');
      localRegs.cfigReg6 <= (others => '0');
      localRegs.cfigReg7 <= (others => '0');
      localRegs.cfigReg8 <= (others => '0');
      localRegs.cfigReg9 <= (others => '0');
      localRegs.cfigReg10 <= (others => '0');
      localRegs.cfigReg11 <= (others => '0');
      localRegs.cfigReg12 <= (others => '0');
      localRegs.cfigReg13 <= (others => '0');
      localRegs.cfigReg14 <= (others => '0');
      localRegs.cfigReg15 <= (others => '0');
      localRegs.cfigReg16 <= (others => '0');
      localRegs.cfigReg17 <= (others => '0');
      localRegs.cfigReg18 <= (others => '0');
      localRegs.cfigReg19 <= (others => '0');
      localRegs.cfigReg20 <= (others => '0');
      localRegs.cfigReg21 <= (others => '0');
      localRegs.cfigReg22 <= (others => '0');
      localRegs.cfigReg23 <= (others => '0');
      localRegs.cfigReg24 <= (others => '0');
      localRegs.cfigReg25 <= (others => '0');
      localRegs.cfigReg26 <= (others => '0');
      localRegs.cfigReg27 <= (others => '0');
      localRegs.cfigReg28 <= (others => '0');
      localRegs.cfigReg29 <= (others => '0');
      localRegs.cfigReg30 <= (others => '0');
      localRegs.cfigReg31 <= (others => '0');
      localRegs.cfigReg32 <= (others => '0');
      localRegs.cfigReg33 <= (others => '0');
      localRegs.cfigReg34 <= (others => '0');
      localRegs.cfigReg35 <= (others => '0');
      localRegs.cfigReg36 <= (others => '0');
      localRegs.cfigReg37 <= (others => '0');
      localRegs.cfigReg38 <= (others => '0');
      localRegs.cfigReg39 <= (others => '0');
      localRegs.cfigReg40 <= (others => '0');
      localRegs.cfigReg41 <= (others => '0');
      localRegs.cfigReg42 <= (others => '0');
      localRegs.cfigReg43 <= (others => '0');
      localRegs.cfigReg44 <= (others => '0');
      localRegs.cfigReg45 <= (others => '0');
      localRegs.cfigReg46 <= (others => '0');
      localRegs.cfigReg47 <= (others => '0');
      localRegs.cfigReg48 <= (others => '0');
      localRegs.cfigReg49 <= (others => '0');
      localRegs.cfigReg50 <= (others => '0');
      localRegs.cfigReg51 <= (others => '0');
      localRegs.cfigReg52 <= (others => '0');
      localRegs.cfigReg53 <= (others => '0');
      localRegs.cfigReg54 <= (others => '0');
      localRegs.cfigReg55 <= (others => '0');
      localRegs.cfigReg56 <= (others => '0');
      localRegs.cfigReg57 <= (others => '0');
      localRegs.cfigReg58 <= (others => '0');
      localRegs.cfigReg59 <= (others => '0');
      localRegs.cfigReg60 <= (others => '0');
      localRegs.cfigReg61 <= (others => '0');
      localRegs.cfigReg62 <= (others => '0');
      localRegs.cfigReg63 <= (others => '0');
    else
      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
      if (slv_reg_wren = hi) then
        case loc_addr is
          when b"000000" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"000001" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"000010" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"000011" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"000100" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"000101" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"000110" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"000111" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"001000" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg8(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"001001" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"001010" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg10(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"001011" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg11(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"001100" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg12(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"001101" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg13(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"001110" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg14(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"001111" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg15(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"010000" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg16(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"010001" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg17(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"010010" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg18(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"010011" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg19(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"010100" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg20(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"010101" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg21(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"010110" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg22(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"010111" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg23(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"011000" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg24(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"011001" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg25(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"011010" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg26(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"011011" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg27(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"011100" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg28(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"011101" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg29(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"011110" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg30(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"011111" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg31(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"100000" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg32(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"100001" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg33(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"100010" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg34(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"100011" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg35(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"100100" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg36(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"100101" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg37(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"100110" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg38(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"100111" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg39(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"101000" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg40(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"101001" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg41(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"101010" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg42(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"101011" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg43(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"101100" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg44(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"101101" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg45(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"101110" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg46(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"101111" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg47(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"110000" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg48(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"110001" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg49(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"110010" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg50(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"110011" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg51(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"110100" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg52(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"110101" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg53(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"110110" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg54(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"110111" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg55(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"111000" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg56(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"111001" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg57(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"111010" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg58(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"111011" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg59(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"111100" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg60(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"111101" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg61(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"111110" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg62(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when b"111111" =>
            for byte_index in 0 to (conf_data_width/8-1) loop
              if ( S_AXI_WSTRB(byte_index) = hi ) then
                localRegs.cfigReg63(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when others =>
            --stored cpu values
            localRegs.cfigReg0 <= localRegs.cfigReg0;
            localRegs.cfigReg1 <= localRegs.cfigReg1;
            localRegs.cfigReg2 <= localRegs.cfigReg2;
            localRegs.cfigReg3 <= localRegs.cfigReg3;
            localRegs.cfigReg4 <= localRegs.cfigReg4;
            localRegs.cfigReg5 <= localRegs.cfigReg5;
            localRegs.cfigReg6 <= localRegs.cfigReg6;
            localRegs.cfigReg7 <= localRegs.cfigReg7;
            localRegs.cfigReg8 <= localRegs.cfigReg8;
            localRegs.cfigReg9 <= localRegs.cfigReg9;
            localRegs.cfigReg10 <= localRegs.cfigReg10;
            localRegs.cfigReg11 <= localRegs.cfigReg11;
            localRegs.cfigReg12 <= localRegs.cfigReg12;
            localRegs.cfigReg13 <= localRegs.cfigReg13;
            localRegs.cfigReg14 <= localRegs.cfigReg14;
            localRegs.cfigReg15 <= localRegs.cfigReg15;
            localRegs.cfigReg16 <= localRegs.cfigReg16;
            localRegs.cfigReg17 <= localRegs.cfigReg17;
            localRegs.cfigReg18 <= localRegs.cfigReg18;
            localRegs.cfigReg19 <= localRegs.cfigReg19;
            localRegs.cfigReg20 <= localRegs.cfigReg20;
            localRegs.cfigReg21 <= localRegs.cfigReg21;
            localRegs.cfigReg22 <= localRegs.cfigReg22;
            localRegs.cfigReg23 <= localRegs.cfigReg23;
            localRegs.cfigReg24 <= localRegs.cfigReg24;
            localRegs.cfigReg25 <= localRegs.cfigReg25;
            localRegs.cfigReg26 <= localRegs.cfigReg26;
            localRegs.cfigReg27 <= localRegs.cfigReg27;
            localRegs.cfigReg28 <= localRegs.cfigReg28;
            localRegs.cfigReg29 <= localRegs.cfigReg29;
            localRegs.cfigReg30 <= localRegs.cfigReg30;
            localRegs.cfigReg31 <= localRegs.cfigReg31;
            localRegs.cfigReg32 <= localRegs.cfigReg32;
            localRegs.cfigReg33 <= localRegs.cfigReg33;
            localRegs.cfigReg34 <= localRegs.cfigReg34;
            localRegs.cfigReg35 <= localRegs.cfigReg35;
            localRegs.cfigReg36 <= localRegs.cfigReg36;
            localRegs.cfigReg37 <= localRegs.cfigReg37;
            localRegs.cfigReg38 <= localRegs.cfigReg38;
            localRegs.cfigReg39 <= localRegs.cfigReg39;
            localRegs.cfigReg40 <= localRegs.cfigReg40;
            localRegs.cfigReg41 <= localRegs.cfigReg41;
            localRegs.cfigReg42 <= localRegs.cfigReg42;
            localRegs.cfigReg43 <= localRegs.cfigReg43;
            localRegs.cfigReg44 <= localRegs.cfigReg44;
            localRegs.cfigReg45 <= localRegs.cfigReg45;
            localRegs.cfigReg46 <= localRegs.cfigReg46;
            localRegs.cfigReg47 <= localRegs.cfigReg47;
            localRegs.cfigReg48 <= localRegs.cfigReg48;
            localRegs.cfigReg49 <= localRegs.cfigReg49;
            localRegs.cfigReg50 <= localRegs.cfigReg50;
            localRegs.cfigReg51 <= localRegs.cfigReg51;
            localRegs.cfigReg52 <= localRegs.cfigReg52;
            localRegs.cfigReg53 <= localRegs.cfigReg53;
            localRegs.cfigReg54 <= localRegs.cfigReg54;
            localRegs.cfigReg55 <= localRegs.cfigReg55;
            localRegs.cfigReg56 <= localRegs.cfigReg56;
            localRegs.cfigReg57 <= localRegs.cfigReg57;
            localRegs.cfigReg58 <= localRegs.cfigReg58;
            localRegs.cfigReg59 <= localRegs.cfigReg59;
            localRegs.cfigReg60 <= localRegs.cfigReg60;
            localRegs.cfigReg61 <= localRegs.cfigReg61;
            localRegs.cfigReg62 <= localRegs.cfigReg62;
            localRegs.cfigReg63 <= localRegs.cfigReg63;
        end case;
      end if;
    end if;
  end if;
end process;
process (S_AXI_ACLK)
begin
  if rising_edge(S_AXI_ACLK) then
    if S_AXI_ARESETN = lo then
      axi_bvalid  <= lo;
      axi_bresp   <= "00";
    else
      if (axi_awready = hi and S_AXI_AWVALID = hi and axi_wready = hi and S_AXI_WVALID = hi and axi_bvalid = lo  ) then
        axi_bvalid <= hi;
        axi_bresp  <= "00";
      elsif (S_AXI_BREADY = hi and axi_bvalid = hi) then
        axi_bvalid <= lo;
      end if;
    end if;
  end if;
end process;
process (S_AXI_ACLK)
begin
  if rising_edge(S_AXI_ACLK) then
    if S_AXI_ARESETN = lo then
      axi_arready <= lo;
      axi_araddr  <= (others => '1');
    else
      if (axi_arready = lo and S_AXI_ARVALID = hi) then
        axi_arready <= hi;
        axi_araddr  <= S_AXI_ARADDR;
      else
        axi_arready <= lo;
      end if;
    end if;
  end if;
end process;
process (S_AXI_ACLK)
begin
  if rising_edge(S_AXI_ACLK) then
    if S_AXI_ARESETN = lo then
      axi_rvalid <= lo;
      axi_rresp  <= "00";
    else
      if (axi_arready = hi and S_AXI_ARVALID = hi and axi_rvalid = lo) then
        axi_rvalid <= hi;
        axi_rresp  <= "00";
      elsif (axi_rvalid = hi and S_AXI_RREADY = hi) then
        axi_rvalid <= lo;
      end if;
    end if;
  end if;
end process;
    slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid);
process (axi_araddr, S_AXI_ARESETN, slv_reg_rden, rdRegsIn.cfigReg0, rdRegsIn.cfigReg1, rdRegsIn.cfigReg2, rdRegsIn.cfigReg3, rdRegsIn.cfigReg4, rdRegsIn.cfigReg5, rdRegsIn.cfigReg6, rdRegsIn.cfigReg7, rdRegsIn.cfigReg8, rdRegsIn.cfigReg9, rdRegsIn.cfigReg10, rdRegsIn.cfigReg11, rdRegsIn.cfigReg12, rdRegsIn.cfigReg13, rdRegsIn.cfigReg14, rdRegsIn.cfigReg15, rdRegsIn.cfigReg16, rdRegsIn.cfigReg17, rdRegsIn.cfigReg18, rdRegsIn.cfigReg19, rdRegsIn.cfigReg20, rdRegsIn.cfigReg21, rdRegsIn.cfigReg22, rdRegsIn.cfigReg23, rdRegsIn.cfigReg24, rdRegsIn.cfigReg25, rdRegsIn.cfigReg26, rdRegsIn.cfigReg27, rdRegsIn.cfigReg28, rdRegsIn.cfigReg29, rdRegsIn.cfigReg30, rdRegsIn.cfigReg31, rdRegsIn.cfigReg32, rdRegsIn.cfigReg33, rdRegsIn.cfigReg34, rdRegsIn.cfigReg35, rdRegsIn.cfigReg36, rdRegsIn.cfigReg37, rdRegsIn.cfigReg38, rdRegsIn.cfigReg39, rdRegsIn.cfigReg40, rdRegsIn.cfigReg41, rdRegsIn.cfigReg42, rdRegsIn.cfigReg43, rdRegsIn.cfigReg44, rdRegsIn.cfigReg45, rdRegsIn.cfigReg46, rdRegsIn.cfigReg47, rdRegsIn.cfigReg48, rdRegsIn.cfigReg49, rdRegsIn.cfigReg50, rdRegsIn.cfigReg51, rdRegsIn.cfigReg52, rdRegsIn.cfigReg53, rdRegsIn.cfigReg54, rdRegsIn.cfigReg55, rdRegsIn.cfigReg56, rdRegsIn.cfigReg57, rdRegsIn.cfigReg58, rdRegsIn.cfigReg59, rdRegsIn.cfigReg60, rdRegsIn.cfigReg61, rdRegsIn.cfigReg62, rdRegsIn.cfigReg63)
    variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
    begin
        loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
        case loc_addr is
          when b"000000" =>
            reg_data_out <= rdRegsIn.cfigReg0;
          when b"000001" =>
            reg_data_out <= rdRegsIn.cfigReg1;
          when b"000010" =>
            reg_data_out <= rdRegsIn.cfigReg2;
          when b"000011" =>
            reg_data_out <= rdRegsIn.cfigReg3;
          when b"000100" =>
            reg_data_out <= rdRegsIn.cfigReg4;
          when b"000101" =>
            reg_data_out <= rdRegsIn.cfigReg5;
          when b"000110" =>
            reg_data_out <= rdRegsIn.cfigReg6;
          when b"000111" =>
            reg_data_out <= rdRegsIn.cfigReg7;
          when b"001000" =>
            reg_data_out <= rdRegsIn.cfigReg8;
          when b"001001" =>
            reg_data_out <= rdRegsIn.cfigReg9;
          when b"001010" =>
            reg_data_out <= rdRegsIn.cfigReg10;
          when b"001011" =>
            reg_data_out <= rdRegsIn.cfigReg11;
          when b"001100" =>
            reg_data_out <= rdRegsIn.cfigReg12;
          when b"001101" =>
            reg_data_out <= rdRegsIn.cfigReg13;
          when b"001110" =>
            reg_data_out <= rdRegsIn.cfigReg14;
          when b"001111" =>
            reg_data_out <= rdRegsIn.cfigReg15;
          when b"010000" =>
            reg_data_out <= rdRegsIn.cfigReg16;
          when b"010001" =>
            reg_data_out <= rdRegsIn.cfigReg17;
          when b"010010" =>
            reg_data_out <= rdRegsIn.cfigReg18;
          when b"010011" =>
            reg_data_out <= rdRegsIn.cfigReg19;
          when b"010100" =>
            reg_data_out <= rdRegsIn.cfigReg20;
          when b"010101" =>
            reg_data_out <= rdRegsIn.cfigReg21;
          when b"010110" =>
            reg_data_out <= rdRegsIn.cfigReg22;
          when b"010111" =>
            reg_data_out <= rdRegsIn.cfigReg23;
          when b"011000" =>
            reg_data_out <= rdRegsIn.cfigReg24;
          when b"011001" =>
            reg_data_out <= rdRegsIn.cfigReg25;
          when b"011010" =>
            reg_data_out <= rdRegsIn.cfigReg26;
          when b"011011" =>
            reg_data_out <= rdRegsIn.cfigReg27;
          when b"011100" =>
            reg_data_out <= rdRegsIn.cfigReg28;
          when b"011101" =>
            reg_data_out <= rdRegsIn.cfigReg29;
          when b"011110" =>
            reg_data_out <= rdRegsIn.cfigReg30;
          when b"011111" =>
            reg_data_out <= rdRegsIn.cfigReg31;
          when b"100000" =>
            reg_data_out <= rdRegsIn.cfigReg32;
          when b"100001" =>
            reg_data_out <= rdRegsIn.cfigReg33;
          when b"100010" =>
            reg_data_out <= rdRegsIn.cfigReg34;
          when b"100011" =>
            reg_data_out <= rdRegsIn.cfigReg35;
          when b"100100" =>
            reg_data_out <= rdRegsIn.cfigReg36;
          when b"100101" =>
            reg_data_out <= rdRegsIn.cfigReg37;
          when b"100110" =>
            reg_data_out <= rdRegsIn.cfigReg38;
          when b"100111" =>
            reg_data_out <= rdRegsIn.cfigReg39;
          when b"101000" =>
            reg_data_out <= rdRegsIn.cfigReg40;
          when b"101001" =>
            reg_data_out <= rdRegsIn.cfigReg41;
          when b"101010" =>
            reg_data_out <= rdRegsIn.cfigReg42;
          when b"101011" =>
            reg_data_out <= rdRegsIn.cfigReg43;
          when b"101100" =>
            reg_data_out <= rdRegsIn.cfigReg44;
          when b"101101" =>
            reg_data_out <= rdRegsIn.cfigReg45;
          when b"101110" =>
            reg_data_out <= rdRegsIn.cfigReg46;
          when b"101111" =>
            reg_data_out <= rdRegsIn.cfigReg47;
          when b"110000" =>
            reg_data_out <= rdRegsIn.cfigReg48;
          when b"110001" =>
            reg_data_out <= rdRegsIn.cfigReg49;
          when b"110010" =>
            reg_data_out <= rdRegsIn.cfigReg50;
          when b"110011" =>
            reg_data_out <= rdRegsIn.cfigReg51;
          when b"110100" =>
            reg_data_out <= rdRegsIn.cfigReg52;
          when b"110101" =>
            reg_data_out <= rdRegsIn.cfigReg53;
          when b"110110" =>
            reg_data_out <= rdRegsIn.cfigReg54;
          when b"110111" =>
            reg_data_out <= rdRegsIn.cfigReg55;
          when b"111000" =>
            reg_data_out <= rdRegsIn.cfigReg56;
          when b"111001" =>
            reg_data_out <= rdRegsIn.cfigReg57;
          when b"111010" =>
            reg_data_out <= rdRegsIn.cfigReg58;
          when b"111011" =>
            reg_data_out <= rdRegsIn.cfigReg59;
          when b"111100" =>
            reg_data_out <= rdRegsIn.cfigReg60;
          when b"111101" =>
            reg_data_out <= rdRegsIn.cfigReg61;
          when b"111110" =>
            reg_data_out <= rdRegsIn.cfigReg62;
          when b"111111" =>
            reg_data_out <= rdRegsIn.cfigReg63;
          when others =>
            reg_data_out  <= (others => '0');
        end case;
end process;
process( S_AXI_ACLK ) begin
  if (rising_edge (S_AXI_ACLK)) then
    if ( S_AXI_ARESETN = lo ) then
      axi_rdata  <= (others => '0');
    else
      if (slv_reg_rden = hi) then
          axi_rdata <= reg_data_out;
      end if;
    end if;
  end if;
end process;
cpuOut: process (S_AXI_ACLK) begin
    if (rising_edge (S_AXI_ACLK)) then
        wrRegsOut <= localRegs;
    end if;
end process cpuOut;
end arch_imp;