// Class: img_pattern_seq
class img_pattern_seq extends img_base_seq;
    `uvm_object_utils(img_pattern_seq)
    rgb_set_frame        frame_pkts_h;

    function new(string name="img_pattern_seq");
        super.new(name);
        frame_pkts_h = rgb_set_frame::type_id::create("frame_pkts_h");
    endfunction: new

    virtual task body();
        super.body();
        max_num_video_select    = 50;
        fifo_read_enable        = 32'h10000;
        pReg_fifoReadAddress    = 8'h90;
        max_fifo_read_address   = 32'h400f;
        aBusSelect              = 8'h0C;
        enable_pattern          = 1'b0;
        incre                   = 0;
        set_cell_red            = 1;
        set_increment           = 2;
        choices                 = gre_rand_select;

        frame_pkts_h.re_gen_cell_box(
            (outter_size=12),
            (inner_size=6),
            (set_cell_red=set_cell_red_value),
            (set_cell_gre=set_cell_gre_value),
            (set_cell_blu=set_cell_blu_value),
            (set_incr=10),
            (choices=gre_rand_select));

        init_axi_write_channel(item);
        axi_write_config_reg();
        d5m_write_pre_set_ifval();

        number_frames     = item.cof.number_frames;
        lval_lines        = item.cof.lval_lines;
        lval_offset       = item.cof.lval_offset;
        image_width       = item.cof.image_width;
        enable_pattern    = 1;

        axi_write_channel((addr=aBusSelect),    (data=0));
        d5m_write_create_frames(number_frames,lval_lines,lval_offset,image_width,enable_pattern);

        //axi_write_channel(aBusSelect,1);
        //enable_pattern  = 1'b1;
        //d5m_write_create_frames(number_frames,lval_lines,lval_offset,image_width,enable_pattern);
        //axi_write_channel(aBusSelect,2);
        //d5m_write_create_frames(number_frames,lval_lines,lval_offset,image_width,enable_pattern);
        //axi_write_channel(aBusSelect,3);
        //d5m_write_create_frames(number_frames,lval_lines,lval_offset,image_width,enable_pattern);
        //axi_write_channel(pReg_fifoReadAddress,fifo_read_enable);
        //axi_multi_writes_to_address(pReg_fifoReadAddress,max_fifo_read_address);
        //----------------------------------------------------
    endtask: body
    // -------------------------------------------------------

endclass: img_pattern_seq