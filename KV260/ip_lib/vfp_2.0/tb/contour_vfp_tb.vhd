library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contour_vfp_tb is
    generic (FULL_4K_FRAME : boolean := false);
end;
architecture test of contour_vfp_tb is
    signal clk, rst_n, aw, wv, ar, sv, ss, sl : std_logic := '0';
    signal awr, wr, bv, arr, rv, sr : std_logic;
    signal addr : std_logic_vector(7 downto 0);
    signal wd, rd, sd : std_logic_vector(31 downto 0);
    type rgb_pair is array (0 to 1) of std_logic_vector(23 downto 0);
    type mask_pair is array (0 to 1) of std_logic_vector(2 downto 0);
    signal data : rgb_pair;
    signal keep, strb : mask_pair;
    signal valid, ready, sof, eol, complete : std_logic_vector(0 to 1) := "00";
    type sizes is array (0 to 4) of positive;
    constant widths : sizes := (13,17,17,23,3840);
    constant heights : sizes := (7,9,9,11,2160);
    type signatures is array (0 to 3) of unsigned(31 downto 0);
    -- Frame signatures from the independent fixed-point software model.
    constant expected : signatures := (x"46D33179",x"85495A9F",x"E462E930",x"794E6653");

    function camera_rgb(x, y : natural) return std_logic_vector is
    begin
        return std_logic_vector(unsigned'(to_unsigned((17*x+21*y) mod 256,8) &
                                to_unsigned((61*x+7*y) mod 256,8) &
                                to_unsigned((x+47*y) mod 256,8)));
    end function;
begin
    clk <= not clk after 5 ns when complete /= "11" else '0';
    dut : entity work.vfp_v1_0 port map (
        vfpconfig_aclk=>clk, vfpconfig_aresetn=>rst_n,
        vfpconfig_awaddr=>addr, vfpconfig_awprot=>"000", vfpconfig_awvalid=>aw, vfpconfig_awready=>awr,
        vfpconfig_wdata=>wd, vfpconfig_wstrb=>"1111", vfpconfig_wvalid=>wv, vfpconfig_wready=>wr,
        vfpconfig_bresp=>open, vfpconfig_bvalid=>bv, vfpconfig_bready=>'1',
        vfpconfig_araddr=>addr, vfpconfig_arprot=>"000", vfpconfig_arvalid=>ar, vfpconfig_arready=>arr,
        vfpconfig_rdata=>rd, vfpconfig_rresp=>open, vfpconfig_rvalid=>rv, vfpconfig_rready=>'1',
        ivideo_aclk=>clk, ivideo_aresetn=>rst_n, ivideo_tready=>sr, ivideo_tkeep=>"1101",
        ivideo_tstrb=>"1001", ivideo_tdata=>sd, ivideo_tuser=>ss, ivideo_tlast=>sl, ivideo_tvalid=>sv,
        video2_aclk=>clk, video2_aresetn=>rst_n, video2_tready=>open, video2_tkeep=>"1111",
        video2_tstrb=>"1111", video2_tdata=>(others=>'0'), video2_tuser=>'0', video2_tlast=>'0', video2_tvalid=>'0',
        ovideo_aclk=>clk, ovideo_aresetn=>rst_n, ovideo_tready=>ready(0), ovideo_tkeep=>keep(0),
        ovideo_tstrb=>strb(0), ovideo_tdata=>data(0), ovideo_tuser=>sof(0), ovideo_tlast=>eol(0), ovideo_tvalid=>valid(0),
        o1video_aclk=>clk, o1video_aresetn=>rst_n, o1video_tready=>ready(1), o1video_tkeep=>keep(1),
        o1video_tstrb=>strb(1), o1video_tdata=>data(1), o1video_tuser=>sof(1), o1video_tlast=>eol(1), o1video_tvalid=>valid(1),
        rgb_fr_plw_red=>open, rgb_fr_plw_gre=>open, rgb_fr_plw_blu=>open, rgb_fr_plw_val=>open,
        rgb_fr_plw_sof=>open, rgb_fr_plw_eol=>open, rgb_fr_plw_eof=>open, rgb_fr_plw_xcnt=>open,
        rgb_fr_plw_ycnt=>open, crd_x=>open, crd_y=>open);

    drive : process
        procedure write_reg(offset, value : natural) is
        begin
            addr<=std_logic_vector(to_unsigned(offset,8)); wd<=std_logic_vector(to_unsigned(value,32));
            aw<='1'; wv<='1';
            loop wait until rising_edge(clk); exit when awr='1' and wr='1'; end loop;
            aw<='0'; wv<='0';
            loop wait until rising_edge(clk); exit when bv='1'; end loop;
        end procedure;
        procedure read_reg(offset, value : natural) is
        begin
            addr<=std_logic_vector(to_unsigned(offset,8)); ar<='1';
            loop wait until rising_edge(clk); exit when arr='1'; end loop;
            ar<='0';
            loop wait until rising_edge(clk); exit when rv='1'; end loop;
            assert unsigned(rd)=value report "AXI-Lite readback" severity failure;
        end procedure;
        variable rgb : std_logic_vector(23 downto 0);
        variable rows : positive;
    begin
        wait until falling_edge(clk); wait until falling_edge(clk); rst_n<='1';
        for f in widths'range loop
            write_reg(76,heights(f)*65536+widths(f));
            read_reg(76,heights(f)*65536+widths(f));
            write_reg(72,f mod 2); read_reg(72,f mod 2);
            rows := heights(f);
            if f=4 and not FULL_4K_FRAME then rows:=3; end if; -- Exercise 4K and its preview across three scan lines.
            for y in 0 to rows-1 loop
                if y=2 and f mod 2=1 then sv<='0'; write_reg(72,0); end if;
                for x in 0 to widths(f)-1 loop
                    rgb:=camera_rgb(x,y);
                    sd<="01" & rgb(23 downto 16) & "11" & rgb(15 downto 8) & "10" & rgb(7 downto 0) & "11";
                    sv<='1'; ss<='0'; sl<='0';
                    if x=0 and y=0 then ss<='1'; end if;
                    if x=widths(f)-1 then sl<='1'; end if;
                    loop wait until rising_edge(clk); exit when sr='1'; end loop;
                end loop;
            end loop;
            sv<='0'; ss<='0'; sl<='0';
        end loop;
        wait;
    end process;

    sinks : for i in 0 to 1 generate
        check : process(clk)
            variable cycles, f, x, y : natural := 0;
            variable width, rows, step : positive;
            variable rgb : std_logic_vector(23 downto 0);
            variable signature : unsigned(31 downto 0) := (others=>'0');
            variable held : boolean := false;
            variable beat, previous : std_logic_vector(31 downto 0);
        begin
            if rising_edge(clk) then
                cycles:=cycles+1;
                assert (FULL_4K_FRAME and cycles<30000000) or cycles<100000 report "Timeout" severity failure;
                if (cycles+3*i) mod (7+i)<2 then ready(i)<='0'; else ready(i)<='1'; end if;
                beat:=data(i)&keep(i)&strb(i)&sof(i)&eol(i);
                if held then assert valid(i)='1' and beat=previous report "Unstable stalled output" severity failure; end if;
                held:=valid(i)='1' and ready(i)='0'; previous:=beat;
                if valid(i)='1' and ready(i)='1' then
                    assert f<=4 report "Unexpected output beat" severity failure;
                    width:=widths(f); rows:=heights(f); step:=1;
                    if f=4 then
                        if not FULL_4K_FRAME then rows:=3; end if;
                        if i=1 then width:=1920; rows:=(rows+1)/2; step:=2; end if;
                    end if;
                    assert (sof(i)='1')=(x=0 and y=0) and (eol(i)='1')=(x=width-1)
                        report "Frame markers" severity failure;
                    rgb:=data(i);
                    if i=1 then rgb:=data(i)(7 downto 0)&data(i)(23 downto 8); end if;
                    if f mod 2=0 then
                        assert rgb=camera_rgb(x*step,y*step) and keep(i)="101" and strb(i)="001"
                            report "Bypass pixel or byte enables" severity failure;
                    else
                        assert keep(i)="111" and strb(i)="111" report "Filtered byte enables" severity failure;
                    end if;
                    signature:=rotate_left(signature,5) xor resize(unsigned(rgb),32);
                    x:=x+1;
                    if x=width then x:=0; y:=y+1; end if;
                    if y=rows then
                        if f<4 then assert signature=expected(f) report "Frame signature" severity failure; end if;
                        signature:=(others=>'0'); y:=0; f:=f+1;
                        if f=5 then complete(i)<='1'; report "PASS VDMA output "&integer'image(i); end if;
                    end if;
                end if;
            end if;
        end process;
    end generate;
end architecture;
