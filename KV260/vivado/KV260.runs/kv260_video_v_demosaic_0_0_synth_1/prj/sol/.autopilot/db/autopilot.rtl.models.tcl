set SynModuleInfo {
  {SRCNAME Block_entry1_proc MODELNAME Block_entry1_proc RTLNAME kv260_video_v_demosaic_0_0_Block_entry1_proc}
  {SRCNAME {reg<unsigned short>} MODELNAME reg_unsigned_short_s RTLNAME kv260_video_v_demosaic_0_0_reg_unsigned_short_s}
  {SRCNAME AXIvideo2MultiBayer_Pipeline_loop_wait_for_start MODELNAME AXIvideo2MultiBayer_Pipeline_loop_wait_for_start RTLNAME kv260_video_v_demosaic_0_0_AXIvideo2MultiBayer_Pipeline_loop_wait_for_start
    SUBMODULES {
      {MODELNAME kv260_video_v_demosaic_0_0_flow_control_loop_pipe_sequential_init RTLNAME kv260_video_v_demosaic_0_0_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME kv260_video_v_demosaic_0_0_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME AXIvideo2MultiBayer_Pipeline_loop_width MODELNAME AXIvideo2MultiBayer_Pipeline_loop_width RTLNAME kv260_video_v_demosaic_0_0_AXIvideo2MultiBayer_Pipeline_loop_width}
  {SRCNAME AXIvideo2MultiBayer_Pipeline_loop_wait_for_eol MODELNAME AXIvideo2MultiBayer_Pipeline_loop_wait_for_eol RTLNAME kv260_video_v_demosaic_0_0_AXIvideo2MultiBayer_Pipeline_loop_wait_for_eol}
  {SRCNAME AXIvideo2MultiBayer MODELNAME AXIvideo2MultiBayer RTLNAME kv260_video_v_demosaic_0_0_AXIvideo2MultiBayer
    SUBMODULES {
      {MODELNAME kv260_video_v_demosaic_0_0_regslice_both RTLNAME kv260_video_v_demosaic_0_0_regslice_both BINDTYPE interface TYPE interface_regslice INSTNAME kv260_video_v_demosaic_0_0_regslice_both_U}
    }
  }
  {SRCNAME DebayerG_Pipeline_VITIS_LOOP_273_4 MODELNAME DebayerG_Pipeline_VITIS_LOOP_273_4 RTLNAME kv260_video_v_demosaic_0_0_DebayerG_Pipeline_VITIS_LOOP_273_4
    SUBMODULES {
      {MODELNAME kv260_video_v_demosaic_0_0_mul_mul_18s_9ns_18_4_1 RTLNAME kv260_video_v_demosaic_0_0_mul_mul_18s_9ns_18_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME kv260_video_v_demosaic_0_0_mul_mul_18s_8ns_18_4_1 RTLNAME kv260_video_v_demosaic_0_0_mul_mul_18s_8ns_18_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME kv260_video_v_demosaic_0_0_mul_mul_14s_10ns_24_4_1 RTLNAME kv260_video_v_demosaic_0_0_mul_mul_14s_10ns_24_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1 RTLNAME kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME kv260_video_v_demosaic_0_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R RTLNAME kv260_video_v_demosaic_0_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME kv260_video_v_demosaic_0_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV2_TABLE_ROM_AUTO_1R RTLNAME kv260_video_v_demosaic_0_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV2_TABLE_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME DebayerG MODELNAME DebayerG RTLNAME kv260_video_v_demosaic_0_0_DebayerG
    SUBMODULES {
      {MODELNAME kv260_video_v_demosaic_0_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W RTLNAME kv260_video_v_demosaic_0_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W BINDTYPE storage TYPE xpm_memory IMPL uram LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2 MODELNAME DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2 RTLNAME kv260_video_v_demosaic_0_0_DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2
    SUBMODULES {
      {MODELNAME kv260_video_v_demosaic_0_0_mux_32_10_1_1 RTLNAME kv260_video_v_demosaic_0_0_mux_32_10_1_1 BINDTYPE op TYPE mux IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME DebayerRatBorBatR MODELNAME DebayerRatBorBatR RTLNAME kv260_video_v_demosaic_0_0_DebayerRatBorBatR
    SUBMODULES {
      {MODELNAME kv260_video_v_demosaic_0_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W RTLNAME kv260_video_v_demosaic_0_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W BINDTYPE storage TYPE xpm_memory IMPL uram LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME DebayerRandBatG_Pipeline_VITIS_LOOP_836_2 MODELNAME DebayerRandBatG_Pipeline_VITIS_LOOP_836_2 RTLNAME kv260_video_v_demosaic_0_0_DebayerRandBatG_Pipeline_VITIS_LOOP_836_2}
  {SRCNAME DebayerRandBatG MODELNAME DebayerRandBatG RTLNAME kv260_video_v_demosaic_0_0_DebayerRandBatG}
  {SRCNAME Debayer MODELNAME Debayer RTLNAME kv260_video_v_demosaic_0_0_Debayer
    SUBMODULES {
      {MODELNAME kv260_video_v_demosaic_0_0_fifo_w30_d2_S RTLNAME kv260_video_v_demosaic_0_0_fifo_w30_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME kv260_video_v_demosaic_0_0_fifo_w16_d2_S RTLNAME kv260_video_v_demosaic_0_0_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME kv260_video_v_demosaic_0_0_start_for_DebayerRatBorBatR_U0 RTLNAME kv260_video_v_demosaic_0_0_start_for_DebayerRatBorBatR_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME kv260_video_v_demosaic_0_0_start_for_DebayerRandBatG_U0 RTLNAME kv260_video_v_demosaic_0_0_start_for_DebayerRandBatG_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
    }
  }
  {SRCNAME ZipperRemoval_Pipeline_VITIS_LOOP_1056_2 MODELNAME ZipperRemoval_Pipeline_VITIS_LOOP_1056_2 RTLNAME kv260_video_v_demosaic_0_0_ZipperRemoval_Pipeline_VITIS_LOOP_1056_2}
  {SRCNAME ZipperRemoval MODELNAME ZipperRemoval RTLNAME kv260_video_v_demosaic_0_0_ZipperRemoval}
  {SRCNAME MultiPixStream2AXIvideo_Pipeline_VITIS_LOOP_185_2 MODELNAME MultiPixStream2AXIvideo_Pipeline_VITIS_LOOP_185_2 RTLNAME kv260_video_v_demosaic_0_0_MultiPixStream2AXIvideo_Pipeline_VITIS_LOOP_185_2}
  {SRCNAME MultiPixStream2AXIvideo MODELNAME MultiPixStream2AXIvideo RTLNAME kv260_video_v_demosaic_0_0_MultiPixStream2AXIvideo}
  {SRCNAME v_demosaic MODELNAME v_demosaic RTLNAME kv260_video_v_demosaic_0_0_v_demosaic IS_TOP 1
    SUBMODULES {
      {MODELNAME kv260_video_v_demosaic_0_0_fifo_w16_d2_S_x RTLNAME kv260_video_v_demosaic_0_0_fifo_w16_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME kv260_video_v_demosaic_0_0_fifo_w10_d2_S RTLNAME kv260_video_v_demosaic_0_0_fifo_w10_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME kv260_video_v_demosaic_0_0_fifo_w30_d2_S_x RTLNAME kv260_video_v_demosaic_0_0_fifo_w30_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME kv260_video_v_demosaic_0_0_start_for_ZipperRemoval_U0 RTLNAME kv260_video_v_demosaic_0_0_start_for_ZipperRemoval_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME kv260_video_v_demosaic_0_0_start_for_MultiPixStream2AXIvideo_U0 RTLNAME kv260_video_v_demosaic_0_0_start_for_MultiPixStream2AXIvideo_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME kv260_video_v_demosaic_0_0_CTRL_s_axi RTLNAME kv260_video_v_demosaic_0_0_CTRL_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
