// Class: config_axi4_seq
class config_axi4_seq extends img_base_seq;
   `uvm_object_utils(config_axi4_seq)

   function new(string name="config_axi4_seq");
       super.new(name);
   endfunction: new

   virtual  task body();
       axi_write_read_channel(oRgbOsharp,rgb_sharp);
       axi_write_read_channel(oEdgeType,edge_type);
       axi_write_read_channel(threshold,config_threshold);
       axi_write_read_channel(videoChannel,video_channel);
       axi_write_read_channel(cChannel,c_channel);
       axi_write_read_channel(dChannel,reg_06_en_ycbcr_or_rgb);
       axi_write_read_channel(pReg_pointInterest,point_interest);
       axi_write_read_channel(pReg_deltaConfig,delta_config);
       axi_write_read_channel(pReg_cpuAckGoAgain,cpu_ack_go_again);
       axi_write_read_channel(pReg_cpuWgridLock,cpu_wgrid_lock);
       axi_write_read_channel(pReg_cpuAckoffFrame,cpu_ack_off_frame);
       axi_write_read_channel(pReg_fifoReadAddress,fifo_read_address);
       axi_write_read_channel(pReg_clearFifoData,clear_fifo_data);
       axi_write_read_channel(rgbCoord_rl,rgb_cord_rl);
       axi_write_read_channel(rgbCoord_rh,rgb_cord_rh);
       axi_write_read_channel(rgbCoord_gl,rgb_cord_gl);
       axi_write_read_channel(rgbCoord_gh,rgb_cord_gh);
       axi_write_read_channel(rgbCoord_bl,rgb_cord_bl);
       axi_write_read_channel(rgbCoord_bh,rgb_cord_bh);
       axi_write_read_channel(oLumTh,lum_th);
       axi_write_read_channel(oHsvPerCh,hsv_per_ch);
       axi_write_read_channel(oYccPerCh,ycc_per_ch);
   endtask: body

endclass: config_axi4_seq