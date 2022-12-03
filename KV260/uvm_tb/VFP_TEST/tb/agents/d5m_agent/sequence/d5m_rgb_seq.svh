// Class: d5m_rgb_seq
class d5m_rgb_seq extends img_base_seq;
    `uvm_object_utils(d5m_rgb_seq)

    // Function: new
    function new(string name="d5m_rgb_seq");
        super.new(name);
        frame_pkts_h    = rgb_set_frame::type_id::create("frame_pkts_h");
        vfp_pkts_h      = vfp_config::type_id::create("vfp_pkts_h");
    endfunction: new
    
    // Method: body 
    virtual task body();
        super.body();
        
        max_num_video_select    = 50;
        fifo_read_enable        = 32'h10000;
        pReg_fifoReadAddress    = 8'h90;
        max_fifo_read_address   = 32'h400f;
        aBusSelect              = 8'h0C;
        enable_pattern          = 1'b0;
        incre                   = 0;

        vfp_pkts_h.randomize();
        vfp_pkts_h.unpack_packets();
        vfp_pkts_h.check_packets();
        vfp_pkts_h.pack_packets();
        
        vpkts = {<<{vfp_pkts_h.reg_vpkts}};
        `uvm_info("SEQ", $sformatf("vfp_modev vpkts REG_00=%0d", vpkts.REG_00), UVM_LOW);
        `uvm_info("SEQ", $sformatf("vfp_modev vpkts REG_01=%0d", vpkts.REG_01), UVM_LOW);
        
        
        axi_write_channel((addr=oRgbOsharp),    (data=vpkts.REG_00));
        axi_write_channel((addr=oEdgeType),     (data=vpkts.REG_01));
        axi_write_channel((addr=threshold),     (data=vpkts.REG_04));
        axi_write_channel((addr=videoChannel),  (data=vpkts.REG_05));
        axi_write_channel((addr=dChannel),      (data=vpkts.REG_06));
        axi_write_channel((addr=cChannel),      (data=vpkts.REG_07));
        
        init_axi_write_channel(item);
        //----------------------------------------------------
        //axi_write_channel_test();
        //axi_read_channel_test();
        //axi_multi_writes_to_address(videoChannel,max_num_video_select);
        //----------------------------------------------------
        // d5m_write_pre_set_ifval();
        number_frames  = 1;
        lval_offset    = img_width_bmp+10;
        lval_lines     = img_height_bmp;
        image_width    = img_width_bmp;
        choices        = rgb_incrementer;
        frame_pkts_h.re_gen_cell_box(
            (outter_size=lval_lines),
            (inner_size=image_width),
            (set_cell_red=set_cell_red_value),
            (set_cell_gre=set_cell_gre_value),
            (set_cell_blu=set_cell_blu_value),
            (set_incr=16),
            (choices=rgb_incrementer));
        create_rgb_frames(item,number_frames,lval_lines,lval_offset,image_width);
        //----------------------------------------------------
    endtask: body
    
endclass: d5m_rgb_seq