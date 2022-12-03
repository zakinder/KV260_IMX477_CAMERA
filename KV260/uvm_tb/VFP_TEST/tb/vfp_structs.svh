package vfp_structs_pack;

// Enum: vfp_channels
typedef struct packed {
    bit         clkmm;
    bit         valid;
    bit [7:0]   red;
    bit [7:0]   green;
    bit [7:0]   blue;
    bit         sim_done;
    bit         completed_resolution_line;
    bit         completed_resolution;
    bit         completed_resolution_line_64;
    bit         completed_resolution_line_128;
    bit         completed_resolution_line_400;
    bit         completed_resolution_line_1920;
    bit         completed_resolution64_64;
    bit         completed_resolution128_128;
    bit         completed_resolution_400_300;
    bit         completed_resolution_1920_1080;
    reg [15:0]  x_coord;
    reg [15:0]  y_coord;
    reg [15:0]  detect;
    reg         increment_row;
} vfp_channels;



// Enum: rgb_channel
typedef struct packed {
    bit        clkmm;
    bit        valid;
    bit        lvalid;
    bit        fvalid;
    bit        eof;
    bit        sof;
    bit [7:0]  red;
    bit [7:0]  green;
    bit [7:0]  blue;
    bit [23:0] rgb;
    bit [11:0] x;
    bit [11:0] y;
} rgb_channel;



// Enum: cof_channel
typedef struct packed {
    int        image_width;
    int        lval_offset;
    int        lval_lines;
    int        number_frames;
    bit [7:0]  red;
    bit [7:0]  green;
    bit [7:0]  blue;
    bit [11:0] x;
    bit [11:0] y;
} cof_channel;



// Enum: axi4_lite_channel
typedef struct packed {
    bit [15:0] addr;
    bit [31:0] data;
} axi4_lite_channel;



// Enum: pattern_channel
typedef struct packed {
    bit        clkmm;
    bit        iReadyToRead;
    bit        iImageTypeTest;
    bit        valid;
    bit        lvalid;
    bit        fvalid;
    bit        eof;
    bit        sof;
    bit [23:0] rgb;
    bit [11:0] x;
    bit [11:0] y;
} pattern_channel;



// Enum: vfp_axi4
typedef struct packed {
    bit [7:0]  AWADDR;
    bit [2:0]  AWPROT;
    bit        AWVALID;
    bit        AWREADY;
    bit [31:0] WDATA;
    bit [3:0]  WSTRB;
    bit        WVALID;
    bit        WREADY;
    bit [1:0]  BRESP;
    bit        BVALID;
    bit        BREADY;
    bit [7:0]  ARADDR;
    bit [2:0]  ARPROT;
    bit        ARVALID;
    bit        ARREADY;
    bit [31:0] RDATA;
    bit [1:0]  RRESP;
    bit        RVALID;
    bit        RREADY;
} vfp_axi4;



// Enum: vfp_regs
typedef struct packed {
    bit [31:0] REG_00;
    bit [31:0] REG_01;
    bit [31:0] REG_02;
    bit [31:0] REG_03;
    bit [31:0] REG_04;
    bit [31:0] REG_05;
    bit [31:0] REG_06;
    bit [31:0] REG_07;
    bit [31:0] REG_08;
    bit [31:0] REG_09;
    bit [31:0] REG_10;
    bit [31:0] REG_11;
    bit [31:0] REG_12;
    bit [31:0] REG_13;
    bit [31:0] REG_14;
    bit [31:0] REG_15;
    bit [31:0] REG_16;
    bit [31:0] REG_17;
    bit [31:0] REG_18;
    bit [31:0] REG_19;
    bit [31:0] REG_20;
    bit [31:0] REG_21;
    bit [31:0] REG_22;
    bit [31:0] REG_23;
    bit [31:0] REG_24;
    bit [31:0] REG_25;
    bit [31:0] REG_26;
    bit [31:0] REG_27;
    bit [31:0] REG_28;
    bit [31:0] REG_29;
    bit [31:0] REG_30;
    bit [31:0] REG_31;
    bit [31:0] REG_32;
    bit [31:0] REG_33;
    bit [31:0] REG_34;
    bit [31:0] REG_35;
    bit [31:0] REG_36;
    bit [31:0] REG_37;
    bit [31:0] REG_38;
    bit [31:0] REG_39;
    bit [31:0] REG_40;
    bit [31:0] REG_41;
    bit [31:0] REG_42;
    bit [31:0] REG_43;
    bit [31:0] REG_44;
    bit [31:0] REG_45;
    bit [31:0] REG_46;
    bit [31:0] REG_47;
    bit [31:0] REG_48;
    bit [31:0] REG_49;
    bit [31:0] REG_50;
    bit [31:0] REG_51;
    bit [31:0] REG_52;
    bit [31:0] REG_53;
    bit [31:0] REG_54;
    bit [31:0] REG_55;
    bit [31:0] REG_56;
    bit [31:0] REG_57;
    bit [31:0] REG_58;
    bit [31:0] REG_59;
    bit [31:0] REG_60;
    bit [31:0] REG_61;
    bit [31:0] REG_62;
    bit [31:0] REG_63;
} vfp_regs;


// Enum: e_bool
typedef enum {
    FALSE,
    TRUE
} e_bool;
    
    
// Enum: cell_set
typedef enum {
    rgb_incrementer, 
    gre_rand_select, 
    gre_per_select, 
    blu_per_select, 
    all_select, 
    red_per_select, 
    blu_rand_select, 
    red_rand_select, 
    rgb_000_000_black,
    rgb_001_050_dark,
    rgb_051_100_med_dark,
    rgb_101_150_medium,
    rgb_151_200_med_light,
    rgb_201_255_light,
    rgb_255_255_white
} cell_set;


// Enum: d5m_txn_e
typedef enum { 
    AXI4_READ, 
    AXI4_WRITE, 
    D5M_WRITE, 
    IMAGE_READ 
} d5m_txn_e;

endpackage