// MODULE : imageReadInterfaceInst


//module imageReadInterfaceDut(d5m_camera_if.ConfigMaster d5m_camera_vif);
//
//// This module wrapper is for image read and write transection which is instanited at top tb testbench.
//imageReadInterface            #(
//    .i_data_width              (i_data_width                      ),
//    .img_frames_cnt_bmp        (img_frames_cnt_bmp                ),
//    .img_width_bmp             (img_width_bmp                     ),
//    .img_height_bmp            (img_height_bmp                    ),
//    .read_bmp                  (read_bmp                          ))
//imageReadInterfaceInst         (
//    .clk                       (d5m_camera_vif.clkmm              ),
//    .m_axis_mm2s_aclk          (d5m_camera_vif.clkmm              ),
//    .aclk                      (d5m_camera_vif.clkmm              ),
//    .pix_clk                   (d5m_camera_vif.pixclk             ),
//    .reset                     (d5m_camera_vif.reset              ),
//    .iReadyToRead              (d5m_camera_vif.d5p.iReadyToRead   ),
//    .iImageTypeTest            (d5m_camera_vif.d5p.iImageTypeTest ),
//    .iRgb                      (d5m_camera_vif.d5p.rgb            ),
//    .ilvalid                   (d5m_camera_vif.d5p.lvalid         ),
//    .ifvalid                   (d5m_camera_vif.d5p.fvalid         ),
//    .m_axis_mm2s_tvalid        (d5m_camera_vif.m_axis_mm2s_tvalid ),
//    .m_axis_mm2s_tdata         (d5m_camera_vif.m_axis_mm2s_tdata  ),
//    .valid                     (d5m_camera_vif.d5m.valid          ),
//    .red                       (d5m_camera_vif.d5m.red            ),
//    .green                     (d5m_camera_vif.d5m.green          ),
//    .blue                      (d5m_camera_vif.d5m.blue           ),
//    .lvalid                    (d5m_camera_vif.d5m.lvalid         ),
//    .fvalid                    (d5m_camera_vif.d5m.fvalid         ),
//    .rgb                       (d5m_camera_vif.d5m.rgb            ),
//    .xCord                     (d5m_camera_vif.d5m.x              ),
//    .yCord                     (d5m_camera_vif.d5m.y              ),
//    .endOfFrame                (d5m_camera_vif.d5m.eof            ));
//    
//
//
//endmodule: imageReadInterfaceDut
//
// This module wrapper is dut submodule testbench which is instantiated at top tb testbench.

module video_process_dut(d5m_camera_if.ConfigMaster d5m_camera_vif);
    video_process_tb rtl_tb();
endmodule: video_process_dut


// MODULE : VFP_v1_0
// This module wrapper is top dut module which is instanited at top tb testbench.
// Dut has D5M camera interface, axi4-stream tx/rx channels and axi4-lite configuration.

//module vfpConfigd5mCameraDut(d5m_camera_if.ConfigMaster d5m_camera_vif);
//VFP_v1_0                      #(
//    .revision_number           ( revision_number                  ),
//    .C_rgb_m_axis_TDATA_WIDTH  ( C_rgb_m_axis_TDATA_WIDTH         ),
//    .C_rgb_m_axis_START_COUNT  ( C_rgb_m_axis_START_COUNT         ),
//    .C_rgb_s_axis_TDATA_WIDTH  ( C_rgb_s_axis_TDATA_WIDTH         ),
//    .C_m_axis_mm2s_TDATA_WIDTH ( C_m_axis_mm2s_TDATA_WIDTH        ),
//    .C_m_axis_mm2s_START_COUNT ( C_m_axis_mm2s_START_COUNT        ),
//    .C_vfpConfig_DATA_WIDTH    ( C_vfpConfig_DATA_WIDTH           ),
//    .C_vfpConfig_ADDR_WIDTH    ( C_vfpConfig_ADDR_WIDTH           ),
//    .conf_data_width           ( conf_data_width                  ),
//    .conf_addr_width           ( conf_addr_width                  ),
//    .i_data_width              ( i_data_width                     ),
//    .s_data_width              ( s_data_width                     ),
//    .b_data_width              ( b_data_width                     ),
//    .i_precision               ( i_precision                      ),
//    .i_full_range              ( i_full_range                     ),
//    .img_width                 ( img_width                        ),
//    .dataWidth                 ( dataWidth                        ),
//    .img_width_bmp             ( img_width_bmp                    ),
//    .img_height_bmp            ( img_height_bmp                   ),
//    .F_TES                     ( F_TES                            ),
//    .F_LUM                     ( F_LUM                            ),
//    .F_TRM                     ( F_TRM                            ),
//    .F_RGB                     ( F_RGB                            ),
//    .F_SHP                     ( F_SHP                            ),
//    .F_BLU                     ( F_BLU                            ),
//    .F_EMB                     ( F_EMB                            ),
//    .F_YCC                     ( F_YCC                            ),
//    .F_SOB                     ( F_SOB                            ),
//    .F_CGA                     ( F_CGA                            ),
//    .F_HSV                     ( F_HSV                            ),
//    .F_HSL                     ( F_HSL                            ))
//dutVFP_v1Inst                  (
//    //d5m input
//    .pixclk                    (d5m_camera_vif.pixclk             ),
//    .ifval                     (d5m_camera_vif.d5m.fvalid         ),
//    .ilval                     (d5m_camera_vif.d5m.lvalid         ),
//    .idata                     (d5m_camera_vif.d5m.rgb            ),
//    //tx channel
//    .rgb_m_axis_aclk           (d5m_camera_vif.clkmm              ),
//    .rgb_m_axis_aresetn        (d5m_camera_vif.ARESETN            ),
//    .rgb_m_axis_tready         (d5m_camera_vif.rgb_s_axis_tready  ),
//    .rgb_m_axis_tvalid         (d5m_camera_vif.rgb_m_axis_tvalid  ),
//    .rgb_m_axis_tlast          (d5m_camera_vif.rgb_m_axis_tlast   ),
//    .rgb_m_axis_tuser          (d5m_camera_vif.rgb_m_axis_tuser   ),
//    .rgb_m_axis_tdata          (d5m_camera_vif.rgb_m_axis_tdata   ),
//    //rx channel               
//    .rgb_s_axis_aclk           (d5m_camera_vif.clkmm              ),
//    .rgb_s_axis_aresetn        (d5m_camera_vif.ARESETN            ),
//    .rgb_s_axis_tready         (d5m_camera_vif.rgb_s_axis_tready  ),
//    .rgb_s_axis_tvalid         (d5m_camera_vif.rgb_m_axis_tvalid  ),
//    .rgb_s_axis_tlast          (d5m_camera_vif.rgb_m_axis_tlast   ),
//    .rgb_s_axis_tuser          (d5m_camera_vif.rgb_m_axis_tuser   ),
//    .rgb_s_axis_tdata          (d5m_camera_vif.rgb_m_axis_tdata   ),
//    //destination channel                                    
//    .m_axis_mm2s_aclk          (d5m_camera_vif.clkmm              ),
//    .m_axis_mm2s_aresetn       (d5m_camera_vif.ARESETN            ),
//    .m_axis_mm2s_tready        (d5m_camera_vif.m_axis_mm2s_tready ),
//    .m_axis_mm2s_tvalid        (d5m_camera_vif.m_axis_mm2s_tvalid ),
//    .m_axis_mm2s_tuser         (d5m_camera_vif.m_axis_mm2s_tuser  ),
//    .m_axis_mm2s_tlast         (d5m_camera_vif.m_axis_mm2s_tlast  ),
//    .m_axis_mm2s_tdata         (d5m_camera_vif.m_axis_mm2s_tdata  ),
//    .m_axis_mm2s_tkeep         (d5m_camera_vif.m_axis_mm2s_tkeep  ),
//    .m_axis_mm2s_tstrb         (d5m_camera_vif.m_axis_mm2s_tstrb  ),
//    .m_axis_mm2s_tid           (d5m_camera_vif.m_axis_mm2s_tid    ),
//    .m_axis_mm2s_tdest         (d5m_camera_vif.m_axis_mm2s_tdest  ),
//    //video configuration      
//    .vfpconfig_aclk            (d5m_camera_vif.clkmm              ),
//    .vfpconfig_aresetn         (d5m_camera_vif.ARESETN            ),
//    .vfpconfig_awaddr          (d5m_camera_vif.axi4.AWADDR        ),
//    .vfpconfig_awprot          (d5m_camera_vif.axi4.AWPROT        ),
//    .vfpconfig_awvalid         (d5m_camera_vif.axi4.AWVALID       ),
//    .vfpconfig_awready         (d5m_camera_vif.axi4.AWREADY       ),
//    .vfpconfig_wdata           (d5m_camera_vif.axi4.WDATA         ),
//    .vfpconfig_wstrb           (d5m_camera_vif.axi4.WSTRB         ),
//    .vfpconfig_wvalid          (d5m_camera_vif.axi4.WVALID        ),
//    .vfpconfig_wready          (d5m_camera_vif.axi4.WREADY        ),
//    .vfpconfig_bresp           (d5m_camera_vif.axi4.BRESP         ),
//    .vfpconfig_bvalid          (d5m_camera_vif.axi4.BVALID        ),
//    .vfpconfig_bready          (d5m_camera_vif.axi4.BREADY        ),
//    .vfpconfig_araddr          (d5m_camera_vif.axi4.ARADDR        ),
//    .vfpconfig_arprot          (d5m_camera_vif.axi4.ARPROT        ),
//    .vfpconfig_arvalid         (d5m_camera_vif.axi4.ARVALID       ),
//    .vfpconfig_arready         (d5m_camera_vif.axi4.ARREADY       ),
//    .vfpconfig_rdata           (d5m_camera_vif.axi4.RDATA         ),
//    .vfpconfig_rresp           (d5m_camera_vif.axi4.RRESP         ),
//    .vfpconfig_rvalid          (d5m_camera_vif.axi4.RVALID        ),
//    .vfpconfig_rready          (d5m_camera_vif.axi4.RREADY        ));
    
//endmodule: vfpConfigd5mCameraDut