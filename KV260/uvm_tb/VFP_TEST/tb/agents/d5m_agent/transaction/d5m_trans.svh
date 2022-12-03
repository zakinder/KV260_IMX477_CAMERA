// Class: d5m_trans
// This class is inherited from "uvm_sequence_item".
class d5m_trans extends uvm_sequence_item;


    // Data Members

    // handle: vfp
    // vfp is a handle to packed structure rgb_channel, which consist of rgb_image frame bit fields.
	// To generate the random stimulus, declare the fields as rand
    rand rgb_channel         vfp;

    string   read_bmp;

    // handle: d5m
    // d5m is a handle to packed structure rgb_channel, which consist of rgb_image frame bit fields.
    rand rgb_channel         d5m;
    
    
    // handle: cof
    // cof is a handle to packed structure cof_channel, which consist of rgb_image frame bit fields.
    rand cof_channel         cof;
    
    
    // handle: axi4_lite
    // axi4_lite is a handle to packed structure axi4_lite_channel, which consist of rgb_image frame bit fields.
    rand axi4_lite_channel   axi4_lite;
    


    // handle: d5p
    // d5p is a handle to packed structure pattern_channel, which consist of rgb_image frame bit fields.
    rand pattern_channel     d5p;
    
    
    // handle: axi4
    // axi4 is a handle to packed structure vfp_axi4, which consist of rgb_image frame bit fields.
    vfp_axi4                 axi4;
    
    // handle: d5m_txn
    // d5m_txn is a handle to packed structure d5m_txn_e, which consist of rgb_image frame bit fields.
	// Either write or read operation will be performed by d5m_txn.
    rand d5m_txn_e          d5m_txn;

    
    rand int A;
    rand int B;
    
    bit [31:0] axi4_lite_valid_address_list[]= '{0,4,8,12,16,20,24,28,124,128,132,136,140,144,148,200,204,208,212,216,220,224,228,232};
    

    // contain randome data items
    constraint cof_c_image_width   {`IMAGE_CONFIG(A,frame_width)  }
    constraint cof_c_number_frames {`IMAGE_CONFIG(B,lvalid_offset) }
    constraint cof_image_width     {`IMAGE_CONFIG(cof.image_width,frame_width)  }
    constraint cof_lval_offset     {`IMAGE_CONFIG(cof.lval_offset,lvalid_offset)}
    constraint cof_lval_lines      {`IMAGE_CONFIG(cof.lval_lines,frame_height)  }
    constraint cof_number_frames   {`IMAGE_CONFIG(cof.number_frames,num_frames) }
    constraint c_axi4_lite         {axi4_lite.addr inside {axi4_lite_valid_address_list};}


    

    
    // Function: new
    function new (string name = "");
        super.new(name);
    endfunction
    
    // Function: do_copy
    function void do_copy(uvm_object rhs);
        d5m_trans rhs_;
        
        if(!$cast(rhs_, rhs)) begin
            uvm_report_error("do_copy", "cast failed, check types");
        end
        
        axi4_lite.addr = rhs_.axi4_lite.addr;
        A = rhs_.B;
        B = rhs_.A;
        
    endfunction: do_copy
    
    // Function: do_compare
    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        d5m_trans rhs_;
        do_compare = $cast(rhs_, rhs) &&
        super.do_compare(rhs, comparer) &&
        // if we comment out the line below, the A field
        // is still compared (by the field macro compare
        // method)
        A == rhs_.A &&
        B == rhs_.B;
    endfunction: do_compare
    
    // Function: convert2string
    function string convert2string();
        return $sformatf(" A:\t%0d\n B:\t%0d", A, B);
    endfunction: convert2string
    
    // Function: convert_A
    function convert_A();
        return A;
    endfunction: convert_A
    
    // Function: convert_B
    function convert_B();
        return B;
    endfunction: convert_B
    
    // function void pre_randomize(); 
     // super.pre_randomize();
        // `uvm_info("BASE PRE_RANDOMIZATION", "BASE PRE_RANDOMIZATION",UVM_LOW)
        // `SV_RAND_CHECK(axi4_lite.addr,oRgbOsharp,axi4_lite.data,config_data_oRgbOsharp)
        // `SV_RAND_CHECK(axi4_lite.addr,oEdgeType,axi4_lite.data,config_data_oEdgeType)
        // `SV_RAND_CHECK(axi4_lite.addr,aBusSelect,axi4_lite.data,config_data_aBusSelect)
        // `SV_RAND_CHECK(axi4_lite.addr,threshold,axi4_lite.data,reg_04_config_threshold)
        // `SV_RAND_CHECK(axi4_lite.addr,videoChannel,axi4_lite.data,select_cgain)
        // `SV_RAND_CHECK(axi4_lite.addr,dChannel,axi4_lite.data,select_rgb_not_ycbcr)
        // `SV_RAND_CHECK(axi4_lite.addr,cChannel,axi4_lite.data,config_data_cChannel)
        // `SV_RAND_CHECK(axi4_lite.addr,pReg_pointInterest,axi4_lite.data,config_data_pReg_pointInterest)
        // `SV_RAND_CHECK(axi4_lite.addr,pReg_deltaConfig,axi4_lite.data,config_data_pReg_deltaConfig)
        // `SV_RAND_CHECK(axi4_lite.addr,pReg_cpuAckGoAgain,axi4_lite.data,config_data_pReg_cpuAckGoAgain)
        // `SV_RAND_CHECK(axi4_lite.addr,pReg_cpuWgridLock,axi4_lite.data,config_data_pReg_cpuWgridLock)
        // `SV_RAND_CHECK(axi4_lite.addr,pReg_cpuAckoffFrame,axi4_lite.data,config_data_pReg_cpuAckoffFrame)
        // `SV_RAND_CHECK(axi4_lite.addr,pReg_fifoReadAddress,axi4_lite.data,config_data_pReg_fifoReadAddress)
        // `SV_RAND_CHECK(axi4_lite.addr,pReg_clearFifoData,axi4_lite.data,config_data_pReg_clearFifoData)
        // `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_rl,axi4_lite.data,config_data_rgbCoord_rl)
        // `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_rh,axi4_lite.data,config_data_rgbCoord_rh)
        // `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_gl,axi4_lite.data,config_data_rgbCoord_gl)
        // `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_gh,axi4_lite.data,config_data_rgbCoord_gh)
        // `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_bl,axi4_lite.data,config_data_rgbCoord_bl)
        // `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_bh,axi4_lite.data,config_data_rgbCoord_bh)
        // `SV_RAND_CHECK(axi4_lite.addr,oLumTh,axi4_lite.data,config_data_oLumTh)
        // `SV_RAND_CHECK(axi4_lite.addr,oHsvPerCh,axi4_lite.data,config_data_oHsvPerCh)
        // `SV_RAND_CHECK(axi4_lite.addr,oYccPerCh,axi4_lite.data,config_data_oYccPerCh)
        // `uvm_info("addr", $sformatf("addr=%0d data=%0d", axi4_lite.addr,axi4_lite.data), UVM_LOW)
    // endfunction 
    
    
    
    // Function: post_randomize
    function void post_randomize(); 
    super.post_randomize();
       `uvm_info("BASE POST_RANDOMIZATION", "BASE POST_RANDOMIZATION",UVM_LOW)
        `SV_RAND_CHECK(axi4_lite.addr,oRgbOsharp,axi4_lite.data,reg_00_rgb_sharp)
        `SV_RAND_CHECK(axi4_lite.addr,oEdgeType,axi4_lite.data,reg_01_edge_type)
        `SV_RAND_CHECK(axi4_lite.addr,aBusSelect,axi4_lite.data,reg_03_bus_select)
        `SV_RAND_CHECK(axi4_lite.addr,threshold,axi4_lite.data,reg_04_config_threshold)
        `SV_RAND_CHECK(axi4_lite.addr,videoChannel,axi4_lite.data,reg_05_video_channel)
        `SV_RAND_CHECK(axi4_lite.addr,dChannel,axi4_lite.data,reg_06_en_ycbcr_or_rgb)
        `SV_RAND_CHECK(axi4_lite.addr,cChannel,axi4_lite.data,reg_07_c_channel)
        `SV_RAND_CHECK(axi4_lite.addr,pReg_pointInterest,axi4_lite.data,reg_31_point_interest)
        `SV_RAND_CHECK(axi4_lite.addr,pReg_deltaConfig,axi4_lite.data,reg_32_delta_config)
        `SV_RAND_CHECK(axi4_lite.addr,pReg_cpuAckGoAgain,axi4_lite.data,reg_33_cpu_ack_go_again)
        `SV_RAND_CHECK(axi4_lite.addr,pReg_cpuWgridLock,axi4_lite.data,reg_34_cpu_wgrid_lock)
        `SV_RAND_CHECK(axi4_lite.addr,pReg_cpuAckoffFrame,axi4_lite.data,reg_35_cpu_ack_off_frame)
        `SV_RAND_CHECK(axi4_lite.addr,pReg_fifoReadAddress,axi4_lite.data,reg_36_fifo_read_address)
        `SV_RAND_CHECK(axi4_lite.addr,pReg_clearFifoData,axi4_lite.data,reg_37_clear_fifo_data)
        `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_rl,axi4_lite.data,reg_50_rgb_cord_rl)
        `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_rh,axi4_lite.data,reg_51_rgb_cord_rh)
        `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_gl,axi4_lite.data,reg_52_rgb_cord_gl)
        `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_gh,axi4_lite.data,reg_53_rgb_cord_gh)
        `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_bl,axi4_lite.data,reg_54_rgb_cord_bl)
        `SV_RAND_CHECK(axi4_lite.addr,rgbCoord_bh,axi4_lite.data,reg_55_rgb_cord_bh)
        `SV_RAND_CHECK(axi4_lite.addr,oLumTh,axi4_lite.data,reg_56_lum_th)
        `SV_RAND_CHECK(axi4_lite.addr,oHsvPerCh,axi4_lite.data,reg_57_hsv_per_ch)
        `SV_RAND_CHECK(axi4_lite.addr,oYccPerCh,axi4_lite.data,reg_58_ycc_per_ch)
        `uvm_info("addr", $sformatf("addr=%0d data=%0d", axi4_lite.addr,axi4_lite.data), UVM_LOW)
    endfunction: post_randomize 
    
    
    //Utility and Field macros
    `uvm_object_utils_begin(d5m_trans)
        `uvm_field_int  (A,                             UVM_DEFAULT);
        `uvm_field_int  (B,                             UVM_DEFAULT);
        `uvm_field_int  (vfp.clkmm,                     UVM_DEFAULT);
        `uvm_field_int  (vfp.valid,                     UVM_DEFAULT);
        `uvm_field_int  (vfp.lvalid,                    UVM_DEFAULT);
        `uvm_field_int  (vfp.fvalid,                    UVM_DEFAULT);
        `uvm_field_int  (vfp.eof,                       UVM_DEFAULT);
        `uvm_field_int  (vfp.sof,                       UVM_DEFAULT);
        `uvm_field_int  (vfp.red,                       UVM_DEFAULT);
        `uvm_field_int  (vfp.green,                     UVM_DEFAULT);
        `uvm_field_int  (vfp.blue,                      UVM_DEFAULT);
        `uvm_field_int  (vfp.x,                         UVM_DEFAULT);
        `uvm_field_int  (vfp.y,                         UVM_DEFAULT);
        `uvm_field_int  (d5m.clkmm,                     UVM_DEFAULT);
        `uvm_field_int  (d5m.valid,                     UVM_DEFAULT);
        `uvm_field_int  (d5m.lvalid,                    UVM_DEFAULT);
        `uvm_field_int  (d5m.fvalid,                    UVM_DEFAULT);
        `uvm_field_int  (d5m.eof,                       UVM_DEFAULT);
        `uvm_field_int  (d5m.sof,                       UVM_DEFAULT);
        `uvm_field_int  (d5m.red,                       UVM_DEFAULT);
        `uvm_field_int  (d5m.green,                     UVM_DEFAULT);
        `uvm_field_int  (d5m.blue,                      UVM_DEFAULT);
        `uvm_field_int  (d5m.x,                         UVM_DEFAULT);
        `uvm_field_int  (d5m.y,                         UVM_DEFAULT);
        `uvm_field_int  (cof.lval_offset,               UVM_DEFAULT);
        `uvm_field_int  (cof.lval_lines,                UVM_DEFAULT);
        `uvm_field_int  (cof.number_frames,             UVM_DEFAULT);
        `uvm_field_int  (cof.image_width,               UVM_DEFAULT);
        `uvm_field_int  (d5p.clkmm,                     UVM_DEFAULT);
        `uvm_field_int  (d5p.iReadyToRead,              UVM_DEFAULT);
        `uvm_field_int  (d5p.iImageTypeTest,            UVM_DEFAULT);
        `uvm_field_int  (d5p.valid,                     UVM_DEFAULT);
        `uvm_field_int  (d5p.lvalid,                    UVM_DEFAULT);
        `uvm_field_int  (d5p.fvalid,                    UVM_DEFAULT);
        `uvm_field_int  (d5p.eof,                       UVM_DEFAULT);
        `uvm_field_int  (d5p.sof,                       UVM_DEFAULT);
        `uvm_field_int  (d5p.rgb,                       UVM_DEFAULT);
        `uvm_field_int  (d5p.x,                         UVM_DEFAULT);
        `uvm_field_int  (d5p.y,                         UVM_DEFAULT);
        `uvm_field_int  (axi4.AWADDR,                   UVM_DEFAULT);
        `uvm_field_int  (axi4.AWPROT,                   UVM_DEFAULT);
        `uvm_field_int  (axi4.AWVALID,                  UVM_DEFAULT);
        `uvm_field_int  (axi4.AWREADY,                  UVM_DEFAULT);
        `uvm_field_int  (axi4.WDATA,                    UVM_DEFAULT);
        `uvm_field_int  (axi4.WSTRB,                    UVM_DEFAULT);
        `uvm_field_int  (axi4.WVALID,                   UVM_DEFAULT);
        `uvm_field_int  (axi4.WREADY,                   UVM_DEFAULT);
        `uvm_field_int  (axi4.BRESP,                    UVM_DEFAULT);
        `uvm_field_int  (axi4.BVALID,                   UVM_DEFAULT);
        `uvm_field_int  (axi4.BREADY,                   UVM_DEFAULT);
        `uvm_field_int  (axi4.ARADDR,                   UVM_DEFAULT);
        `uvm_field_int  (axi4.ARPROT,                   UVM_DEFAULT);
        `uvm_field_int  (axi4.ARVALID,                  UVM_DEFAULT);
        `uvm_field_int  (axi4.ARREADY,                  UVM_DEFAULT);
        `uvm_field_int  (axi4.RDATA,                    UVM_DEFAULT);
        `uvm_field_int  (axi4.RRESP,                    UVM_DEFAULT);
        `uvm_field_int  (axi4.RVALID,                   UVM_DEFAULT);
        `uvm_field_int  (axi4.RREADY,                   UVM_DEFAULT);
        `uvm_field_int  (axi4_lite.addr,                UVM_DEFAULT);
        `uvm_field_int  (axi4_lite.data,                UVM_DEFAULT);
        `uvm_field_enum (d5m_txn_e, d5m_txn,            UVM_DEFAULT); 
    `uvm_object_utils_end
endclass: d5m_trans