set_property SRC_FILE_INFO {cfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:1 order:LATE scoped_inst:inst/Debayer_U0/DebayerG_U0/linebuf_yuv_val_V_1_U/kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:2 order:LATE scoped_inst:inst/Debayer_U0/DebayerG_U0/linebuf_yuv_val_V_2_U/kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:3 order:LATE scoped_inst:inst/Debayer_U0/DebayerG_U0/linebuf_yuv_val_V_3_U/kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:4 order:LATE scoped_inst:inst/Debayer_U0/DebayerG_U0/linebuf_yuv_val_V_U/kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:5 order:LATE scoped_inst:inst/Debayer_U0/DebayerRandBatG_U0/lineBuffer_val_V_2_U/kv260_video_v_demosaic_1_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:6 order:LATE scoped_inst:inst/Debayer_U0/DebayerRandBatG_U0/lineBuffer_val_V_U/kv260_video_v_demosaic_1_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:7 order:LATE scoped_inst:inst/Debayer_U0/DebayerRatBorBatR_U0/lineBuffer_val_V_1_U/kv260_video_v_demosaic_1_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:8 order:LATE scoped_inst:inst/Debayer_U0/DebayerRatBorBatR_U0/lineBuffer_val_V_U/kv260_video_v_demosaic_1_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
current_instance inst/Debayer_U0/DebayerG_U0/linebuf_yuv_val_V_1_U/kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:1 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance inst/Debayer_U0/DebayerG_U0/linebuf_yuv_val_V_2_U/kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:2 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance inst/Debayer_U0/DebayerG_U0/linebuf_yuv_val_V_3_U/kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:3 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance inst/Debayer_U0/DebayerG_U0/linebuf_yuv_val_V_U/kv260_video_v_demosaic_1_0_DebayerG_linebuf_yuv_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:4 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance inst/Debayer_U0/DebayerRandBatG_U0/lineBuffer_val_V_2_U/kv260_video_v_demosaic_1_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:5 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance inst/Debayer_U0/DebayerRandBatG_U0/lineBuffer_val_V_U/kv260_video_v_demosaic_1_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:6 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance inst/Debayer_U0/DebayerRatBorBatR_U0/lineBuffer_val_V_1_U/kv260_video_v_demosaic_1_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:7 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance inst/Debayer_U0/DebayerRatBorBatR_U0/lineBuffer_val_V_U/kv260_video_v_demosaic_1_0_DebayerRatBorBatR_lineBuffer_val_V_XPM_MEMORY_URAM_1R1W_ram_U/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:8 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
