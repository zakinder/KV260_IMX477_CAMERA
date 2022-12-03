// Class: img_base_seq
class img_base_seq extends uvm_sequence #(d5m_trans);
    `uvm_object_utils(img_base_seq)
    
    
    rgb_set_frame           frame_pkts_h;
    vfp_config              vfp_pkts_h;
    cell_set                choices;
    d5m_trans               item;
    vfp_regs                vpkts;

    

    int set_increment;
    int number_frames;
    int lval_lines;
    int lval_offset;
    int image_width;
    int incre;
    int outter_ar_size;
    int inner_ar_size;
    bit enable_pattern;

    int outter_size;
    int inner_size;
    int set_cell_red;
    int set_cell_gre;
    int set_cell_blu;
    int set_incr;


    bit [31:0] max_num_video_select;
    bit [31:0] fifo_read_enable;
    bit [7:0]  pReg_fifoReadAddress;
    bit [31:0] max_fifo_read_address;
    bit [7:0]  aBusSelect;
    bit [7:0]  addr;
    bit [31:0] data;
    int rgb_sharp           = reg_00_rgb_sharp;
    int edge_type           = reg_01_edge_type;
    int config_threshold    = reg_04_config_threshold;
    int video_channel       = reg_05_video_channel;
    int c_channel           = reg_07_c_channel;
    int en_ycbcr_or_rgb     = reg_06_en_ycbcr_or_rgb;
    int point_interest      = reg_31_point_interest;
    int delta_config        = reg_32_delta_config;
    int cpu_ack_go_again    = reg_33_cpu_ack_go_again;
    int cpu_wgrid_lock      = reg_34_cpu_wgrid_lock;
    int cpu_ack_off_frame   = reg_35_cpu_ack_off_frame;
    int fifo_read_address   = reg_36_fifo_read_address;
    int clear_fifo_data     = reg_37_clear_fifo_data;
    int rgb_cord_rl         = reg_50_rgb_cord_rl;
    int rgb_cord_rh         = reg_51_rgb_cord_rh;
    int rgb_cord_gl         = reg_52_rgb_cord_gl;
    int rgb_cord_gh         = reg_53_rgb_cord_gh;
    int rgb_cord_bl         = reg_54_rgb_cord_bl;
    int rgb_cord_bh         = reg_55_rgb_cord_bh;
    int lum_th              = reg_56_lum_th;
    int hsv_per_ch          = reg_57_hsv_per_ch;
    int ycc_per_ch          = reg_58_ycc_per_ch;
    
    // Function: new
    function new(string name="img_base_seq");
        super.new(name);
    endfunction: new
    
    // Method: body 
    virtual task body();
        `display_parameter_data_s_d(F_CGA);
        `display_parameter_data_s_d(F_SHP);
        `display_parameter_data_s_d(F_BLU);
        `display_parameter_data_s_d(F_HSL);
        `display_parameter_data_s_d(F_HSV);
        `display_parameter_data_s_d(F_RGB);
        `display_parameter_data_s_d(F_SOB);
        `display_parameter_data_s_d(F_EMB);
        `display_parameter_data_s_s(read_bmp);
        `display_parameter_data_s_d(img_width_bmp);
        `display_parameter_data_s_d(img_height_bmp);
        `display_parameter_data_s_d(reg_05_video_channel);
    endtask: body


    // Method: axi_write_channel_test 
    virtual protected task init_axi_write_channel(d5m_trans item);
        `uvm_create(item)
        item.d5p.rgb           = 0;
        item.d5p.lvalid        = 1'b0;
        item.d5p.fvalid        = 1'b0;
        item.d5m_txn           = D5M_WRITE;
        `uvm_send(item);
    endtask: init_axi_write_channel

    // Method: axi_write_channel_test 
    virtual protected task axi_write_channel_test();
        d5m_trans item;
        bit[7:0] addr;
        bit[31:0] data;
        for(addr = 0; addr  <255; addr++) begin
            data++;
            `uvm_create(item)
            item.axi4_lite.addr = {14'h0,addr[7:0]};
            item.d5m_txn        = AXI4_WRITE;
            item.axi4_lite.data = data;
            `uvm_send(item);
        end
    endtask: axi_write_channel_test
    
    // Method: axi_read_channel_test 
    virtual protected task axi_read_channel_test();
        d5m_trans item;
        bit[7:0] addr;
        bit[31:0] data;
        for(addr = 0; addr <255; addr++) begin
            data++;
            `uvm_create(item)
            item.axi4_lite.addr           = {14'h0,addr[7:0]};
            item.d5m_txn                  = AXI4_READ;
            item.axi4_lite.data           = 0;
            `uvm_send(item);
        end
    endtask: axi_read_channel_test
    
    // Method: axi_multi_writes_to_address 
    virtual protected task axi_multi_writes_to_address (bit[7:0] waddr,bit[31:0] max_value);
        bit[31:0] data;
        for(data = 0; data  <= max_value; data++) begin
           axi_write_channel(waddr,data);
        end
    endtask: axi_multi_writes_to_address
    
    // Method: axi_write_channel 
    virtual protected task axi_write_channel (bit[7:0] addr,bit[31:0] data);
        d5m_trans item;
        `uvm_create(item)
        item.axi4_lite.addr           = {7'h0,addr};
        item.axi4_lite.data           = data;
        item.d5m_txn                  = AXI4_WRITE;
        `uvm_send(item);
    endtask: axi_write_channel
    
    // Method: axi_read_channel 
    virtual protected task axi_read_channel();
        d5m_trans item;
        bit[7:0] addr;
        for(addr = 0; addr < 256; addr+=4) begin
            `uvm_create(item)
            item.axi4_lite.addr           = {14'h0,addr[7:0]};
            item.d5m_txn        = AXI4_READ;
            `uvm_send(item);
        end
    endtask: axi_read_channel
    
    // Method:  axi_write_read_channel
    virtual task axi_write_read_channel (bit[7:0] addr,bit[31:0] data);
        d5m_trans item;
        `uvm_create(item)
        item.axi4_lite.addr           = {7'h0,addr};
        item.axi4_lite.data           = data;
        item.d5m_txn                  = AXI4_WRITE;
        `uvm_send(item);
        axi_read_back_channel(addr);
    endtask: axi_write_read_channel
    
    // Method:  axi_read_back_channel
    virtual task axi_read_back_channel(bit[7:0] addr);
        d5m_trans item;
        `uvm_create(item)
        item.axi4_lite.addr           = addr;
        item.d5m_txn                  = AXI4_READ;
        `uvm_send(item);
   endtask: axi_read_back_channel
    
    
    // Method: d5m_write_pre_set_ifval 
    virtual protected task d5m_write_pre_set_ifval();
        d5m_trans item;
        int preset_cycles;
        //init d5m clear
        for(preset_cycles = 0; preset_cycles <= 10; preset_cycles++) begin
            `uvm_create(item)
            item.d5p.iImageTypeTest = 1'b1;
            item.d5p.rgb            = 0;
            item.d5p.lvalid         = 1'b0;
            item.d5p.fvalid         = 1'b1;
            item.d5m_txn            = D5M_WRITE;
            if (preset_cycles > 9 )begin //>200
                item.d5p.fvalid      = 1'b1;//init default sof valid line high
            end
            `uvm_send(item);
        end
    endtask: d5m_write_pre_set_ifval


   
   
    virtual protected task axi_write_config_reg();
        axi_write_channel(initAddr,initAddr);
        axi_write_channel_test();
        axi_read_channel_test();
        axi_multi_writes_to_address(videoChannel,max_num_video_select);
        axi_write_channel(kls_k1,kCoeffCgain_k1);
        axi_write_channel(kls_k2,kCoeffCgain_k2);
        axi_write_channel(kls_k3,kCoeffCgain_k3);
        axi_write_channel(kls_k4,kCoeffCgain_k4);
        axi_write_channel(kls_k5,kCoeffCgain_k5);
        axi_write_channel(kls_k6,kCoeffCgain_k6);
        axi_write_channel(kls_k7,kCoeffCgain_k7);
        axi_write_channel(kls_k8,kCoeffCgain_k8);
        axi_write_channel(kls_k9,kCoeffCgain_k9);
        axi_write_channel(kls_config,kCoeffCgain_kSet);
        axi_write_channel(filter_id,kCoeffCgain_kSet);
        axi_read_back_channel(kls_k1);
        axi_read_back_channel(kls_k2);
        axi_read_back_channel(kls_k3);
        axi_read_back_channel(kls_k4);
        axi_read_back_channel(kls_k5);
        axi_read_back_channel(kls_k6);
        axi_read_back_channel(kls_k7);
        axi_read_back_channel(kls_k8);
        axi_read_back_channel(kls_k9);
        axi_read_back_channel(kls_config);
        axi_write_channel(oRgbOsharp,reg_00_rgb_sharp);
        axi_write_channel(oEdgeType,reg_01_edge_type);
        axi_write_channel(threshold,reg_04_config_threshold);
        axi_write_channel(videoChannel,reg_05_video_channel);
        axi_write_channel(cChannel,reg_07_c_channel);
        axi_write_channel(dChannel,reg_06_en_ycbcr_or_rgb);
        //axi_write_channel(kls_config,kCoefDisabIndex);
        //axi_write_channel(kls_config,kCoefYcbcrIndex);
        //axi_write_channel(kls_config,kCoefCgainIndex);
        //axi_write_channel(kls_config,kCoefSharpIndex);
        //axi_write_channel(kls_config,kCoefBlureIndex);
        //axi_write_channel(kls_config,kCoefSobeXIndex);
        //axi_write_channel(kls_config,kCoefSobeYIndex);
        //axi_write_channel(kls_config,kCoefEmbosIndex);
        //axi_write_channel(kls_config,kCoefCgai1Index);
        //axi_write_channel(als_k1,6);
        //axi_write_channel(als_k2,5);
        //axi_write_channel(als_k3,6);
        //axi_write_channel(als_k4,5);
        //axi_write_channel(als_k5,6);
        //axi_write_channel(als_k6,6);
        //axi_write_channel(als_k7,5);
        //axi_write_channel(als_k8,6);
        //axi_write_channel(als_k9,5);
        //axi_write_channel(als_config,kCoefDisabIndex);
        //axi_write_channel(als_config,kCoefYcbcrIndex);
        //axi_write_channel(als_config,kCoefCgainIndex);
        //axi_write_channel(als_config,kCoefSharpIndex);
        //axi_write_channel(als_config,kCoefBlureIndex);
        //axi_write_channel(als_config,kCoefSobeXIndex);
        //axi_write_channel(als_config,kCoefSobeYIndex);
        //axi_write_channel(als_config,kCoefEmbosIndex);
        //axi_write_channel(als_config,kCoefCgai1Index);
        axi_write_channel(pReg_deltaConfig,reg_32_delta_config);
        axi_write_channel(pReg_cpuAckGoAgain,reg_33_cpu_ack_go_again);
        axi_write_channel(pReg_cpuWgridLock,reg_34_cpu_wgrid_lock);
        axi_write_channel(pReg_cpuAckoffFrame,reg_35_cpu_ack_off_frame);
        axi_write_channel(pReg_fifoReadAddress,reg_36_fifo_read_address);
        axi_write_channel(pReg_clearFifoData,reg_37_clear_fifo_data);
        axi_write_channel(rgbCoord_rl,reg_50_rgb_cord_rl);
        axi_write_channel(rgbCoord_rh,reg_51_rgb_cord_rh);
        axi_write_channel(rgbCoord_gl,reg_52_rgb_cord_gl);
        axi_write_channel(rgbCoord_gh,reg_53_rgb_cord_gh);
        axi_write_channel(rgbCoord_bl,reg_54_rgb_cord_bl);
        axi_write_channel(rgbCoord_bh,reg_55_rgb_cord_bh);
        axi_write_channel(oLumTh,reg_56_lum_th);
        axi_write_channel(oHsvPerCh,reg_57_hsv_per_ch);
        axi_write_channel(oYccPerCh,reg_58_ycc_per_ch);
    endtask: axi_write_config_reg
    
    // Method: create_rgb_frames 
    virtual protected task create_rgb_frames(d5m_trans item,int nframes,int l_lines,int l_offset,int image_width);

        bit[7:0] rgb_red_data;
        bit[7:0] rgb_gre_data;
        bit[7:0] rgb_blu_data;
        bit ImTyTest  = 1'b1;
        bit rImage    = 1'b0;
        bit fval      = fval_l;
        bit lval      = lval_l;
        bit[23:0] rgb = 24'h111;

        //write_per_pixel(item,ImTyTest,rImage,fval,lval,rgb);
        `uvm_create(item)
            item.d5p.iImageTypeTest = 1'b1;
            item.d5p.iReadyToRead   = 1'b0;
            item.d5p.fvalid         = fval;
            item.d5p.lvalid         = lval;
            item.d5p.rgb            = rgb;
            item.d5m_txn            = D5M_WRITE;
        `uvm_send(item);

        for(int n_frames = 0; n_frames <= nframes; n_frames++) begin
        for(int y = 0; y  < l_lines; y++) begin
            if(y == (l_lines-1)) begin
                fval  = fval_h;
                lval  = lval_h;// sol[start of line]
                for(int x = 0; x <image_width; x++) begin
                    rgb_red_data = frame_pkts_h.c_blocker.c_rows[y].c_block[x].red;
                    rgb_gre_data = frame_pkts_h.c_blocker.c_rows[y].c_block[x].gre;
                    rgb_blu_data = frame_pkts_h.c_blocker.c_rows[y].c_block[x].blu;
                    rgb          = {rgb_red_data,rgb_gre_data,rgb_blu_data};
                    write_per_pixel(item,ImTyTest,rImage,fval,lval,rgb);
                end
                fval  = fval_l;
                lval  = lval_l;// eol[end of line] with after eof
                rgb   = 24'h111;
                for(int x = 0; x  <l_offset; x++) begin
                    write_per_pixel(item,ImTyTest,rImage,fval,lval,rgb);
                end
                write_per_pixel(item,ImTyTest,rImage,fval,lval,rgb);
            end else begin
                fval  = fval_h;
                lval  = lval_h;// sol[start of line]
                for(int x = 0; x <image_width; x++) begin
                    rgb_red_data = frame_pkts_h.c_blocker.c_rows[y].c_block[x].red;
                    rgb_gre_data = frame_pkts_h.c_blocker.c_rows[y].c_block[x].gre;
                    rgb_blu_data = frame_pkts_h.c_blocker.c_rows[y].c_block[x].blu;
                    rgb          = {rgb_red_data,rgb_gre_data,rgb_blu_data};
                    write_per_pixel(item,ImTyTest,rImage,fval,lval,rgb);
                end
                fval  = fval_h;
                lval  = lval_l;// eol[end of line]
                rgb   = 24'h111;
                for(int x = 0; x  <l_offset; x++) begin
                    write_per_pixel(item,ImTyTest,rImage,fval,lval,rgb);
                end
            end
        end
        end
    endtask: create_rgb_frames
    // Method: write_per_pixel 
    virtual protected task write_per_pixel(d5m_trans item,bit ImTyTest,bit rImage,bit fval,bit lval, bit[23:0] rgb);
        `uvm_create(item)
            item.d5p.iImageTypeTest = ImTyTest;
            item.d5p.iReadyToRead   = rImage;
            item.d5p.fvalid         = fval;
            item.d5p.lvalid         = lval;
            item.d5p.rgb            = rgb;
            item.d5m_txn            = D5M_WRITE;
        `uvm_send(item);
    endtask: write_per_pixel
    
    // Method: axi_write_aBusSelect_channel 
    virtual protected task axi_write_aBusSelect_channel (bit[7:0] addr,bit[31:0] data);
        d5m_trans item;
        `uvm_create(item)
        item.axi4_lite.addr   = {7'h0,addr};
        item.axi4_lite.data   = data;
        item.d5m_txn          = AXI4_WRITE;
        `uvm_send(item);
    endtask: axi_write_aBusSelect_channel
    virtual protected task d5m_read();
            d5m_trans item;
            `uvm_create(item)
            item.d5p.iImageTypeTest = 1'b0;
            item.d5m_txn            = IMAGE_READ;
            `uvm_send(item);
    endtask: d5m_read
    virtual protected task d5m_write_create_frames(int number_frames,int lval_lines,int lval_offset,int image_width,bit enable_pattern);
        d5m_trans item;
        int y_cord;
        int n_frames;
        int n_pixel;
        //axi_write_aBusSelect_channel(aBusSelect,$urandom_range(0,3));
        for(n_frames = 0; n_frames <= number_frames; n_frames++) begin
            for(y_cord = 0; y_cord <= lval_lines; y_cord++) begin
                for(n_pixel = 1; n_pixel <= ((image_width) + (lval_offset)); n_pixel++) begin
                    `uvm_create(item)
                        item.d5p.iImageTypeTest = 1'b1;
                        item.d5p.iReadyToRead   = 1'b0;
                        item.d5m_txn            = D5M_WRITE;
                    if (y_cord > 0 && y_cord < lval_lines) begin
                        item.d5p.fvalid          = 1'b1;
                        item.d5p.lvalid          = 1'b1;// sol[start of line]
                        item.d5p.rgb             = enable_pattern ? $urandom_range(0,4095) : n_pixel;
                        if (n_pixel >= (image_width)) begin   
                            item.d5p.lvalid      = 1'b0;// eol[end of line]
                            item.d5p.rgb         = 0;
                        end
                    end else begin
                        item.d5p.lvalid          = 1'b0;
                        item.d5p.rgb          = 0;
                        if (y_cord == 0) begin
                            if (n_pixel >= ((image_width) + (lval_offset)) - 10)begin   
                                item.d5p.fvalid      = 1'b1;// sof[start of frame]
                            end
                        end
                        if (y_cord == lval_lines) begin
                            if (n_pixel >= (image_width) + 2)begin   
                                item.d5p.fvalid      = 1'b0;// eof[end of frame]
                            end
                        end
                    end
                    `uvm_send(item);
                end
            end
        end
    endtask: d5m_write_create_frames
    
endclass: img_base_seq