// Class: camera_seq
class camera_seq extends img_base_seq;
    `uvm_object_utils(camera_seq)
    

    function new(string name="camera_seq");
        super.new(name);
    endfunction: new

    virtual task body();
        super.body();
        fifo_read_enable                = 32'h10000;    //180
        pReg_fifoReadAddress            = 8'h90;        //116 pReg_fifoReadEnable --fifo read enable
        max_fifo_read_address           = 32'h400f;     //180
        aBusSelect                      = 8'h0C;        //12 
        enable_pattern                  = 1'b0;
        init_axi_write_channel(item);
        axi_write_config_reg();
        d5m_read();
        //d5m_write_pre_set_ifval();
        //number_frames  = item.cof.number_frames;
        //lval_lines     = item.cof.lval_lines;
        //lval_offset    = item.cof.lval_offset;
        //image_width    = item.image_width;
        //axi_write_channel(aBusSelect,0);
        //d5m_write_create_frames(number_frames,lval_lines,lval_offset,image_width,enable_pattern);
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

    
endclass: camera_seq