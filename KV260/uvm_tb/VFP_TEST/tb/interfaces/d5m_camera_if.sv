// INTERFACE : axi_lite_IF [AXI4_LITE]

interface d5m_camera_if(input bit reset,ARESETN);
    rgb_channel         vfp;
    rgb_channel         d5m;
    cof_channel         cof;
    axi4_lite_channel   axi4_lite;

    pattern_channel     d5p;
    vfp_axi4            axi4;
    bit pixclk;
    bit ACLK;
    logic               ifval;
    bit                 clkmm;
    logic [7:0]         AWADDR;
    logic [ 2:0]        AWPROT;
    logic               AWVALID;
    logic               AWREADY;
    logic [31:0]        WDATA;
    logic [ 3:0]        WSTRB;
    logic               WVALID;
    logic               WREADY;
    logic [1:0]         BRESP;
    logic               BVALID;
    logic               BREADY;
    logic [7:0]         ARADDR;
    logic [ 2:0]        ARPROT;
    logic               ARVALID;
    logic               ARREADY;
    logic [31:0]        RDATA;
    logic [ 1:0]        RRESP;
    logic               RVALID;
    logic               RREADY;
    logic               rgb_m_axis_tready; //input
    logic               rgb_m_axis_tvalid; //output
    logic               rgb_m_axis_tlast;  //output
    logic               rgb_m_axis_tuser;  //output
    logic [23:0]        rgb_m_axis_tdata;  //output
    //rx channel                   
    logic               rgb_s_axis_tready;//output
    logic               rgb_s_axis_tvalid;//input
    logic               rgb_s_axis_tlast; //input
    logic               rgb_s_axis_tuser; //input
    logic [23:0]    rgb_s_axis_tdata;     //input
    //destination channel                                    
    logic               m_axis_mm2s_tready;//input
    logic               m_axis_mm2s_tvalid;//output
    logic               m_axis_mm2s_tuser; //output
    logic               m_axis_mm2s_tlast; //output
    logic [23:0]        m_axis_mm2s_tdata; //output
    logic [2:0]         m_axis_mm2s_tkeep; //output
    logic [2:0]         m_axis_mm2s_tstrb; //output
    logic [0:0]         m_axis_mm2s_tid;   //output
    logic [0:0]         m_axis_mm2s_tdest; //output
    string              read_bmp;
    modport ConfigMaster(
    input pixclk,clkmm,reset,d5p,ACLK,ARESETN,rgb_m_axis_tready,rgb_s_axis_tvalid,rgb_s_axis_tlast,rgb_s_axis_tuser,rgb_s_axis_tdata,m_axis_mm2s_tready,
    output  read_bmp,d5m,axi4,rgb_m_axis_tvalid,rgb_m_axis_tlast,rgb_m_axis_tuser,rgb_m_axis_tdata,rgb_s_axis_tready,m_axis_mm2s_tvalid,m_axis_mm2s_tuser,m_axis_mm2s_tlast,m_axis_mm2s_tdata,m_axis_mm2s_tkeep,m_axis_mm2s_tstrb,m_axis_mm2s_tid,m_axis_mm2s_tdest);
endinterface: d5m_camera_if