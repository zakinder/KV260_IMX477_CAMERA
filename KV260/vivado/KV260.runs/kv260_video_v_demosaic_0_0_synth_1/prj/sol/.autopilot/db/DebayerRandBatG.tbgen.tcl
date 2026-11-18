set moduleName DebayerRandBatG
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {DebayerRandBatG}
set C_modelType { void 0 }
set C_modelArgList {
	{ imgRB int 30 regular {fifo 0 volatile }  }
	{ imgRgb int 30 regular {fifo 1 volatile }  }
	{ height int 12 regular {ap_stable 0} }
	{ width int 13 regular {ap_stable 0} }
	{ bayerPhase_c int 16 regular {fifo 0}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "imgRB", "interface" : "fifo", "bitwidth" : 30, "direction" : "READONLY"} , 
 	{ "Name" : "imgRgb", "interface" : "fifo", "bitwidth" : 30, "direction" : "WRITEONLY"} , 
 	{ "Name" : "height", "interface" : "wire", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "width", "interface" : "wire", "bitwidth" : 13, "direction" : "READONLY"} , 
 	{ "Name" : "bayerPhase_c", "interface" : "fifo", "bitwidth" : 16, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 24
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ imgRB_dout sc_in sc_lv 30 signal 0 } 
	{ imgRB_num_data_valid sc_in sc_lv 2 signal 0 } 
	{ imgRB_fifo_cap sc_in sc_lv 2 signal 0 } 
	{ imgRB_empty_n sc_in sc_logic 1 signal 0 } 
	{ imgRB_read sc_out sc_logic 1 signal 0 } 
	{ imgRgb_din sc_out sc_lv 30 signal 1 } 
	{ imgRgb_num_data_valid sc_in sc_lv 2 signal 1 } 
	{ imgRgb_fifo_cap sc_in sc_lv 2 signal 1 } 
	{ imgRgb_full_n sc_in sc_logic 1 signal 1 } 
	{ imgRgb_write sc_out sc_logic 1 signal 1 } 
	{ height sc_in sc_lv 12 signal 2 } 
	{ width sc_in sc_lv 13 signal 3 } 
	{ bayerPhase_c_dout sc_in sc_lv 16 signal 4 } 
	{ bayerPhase_c_num_data_valid sc_in sc_lv 2 signal 4 } 
	{ bayerPhase_c_fifo_cap sc_in sc_lv 2 signal 4 } 
	{ bayerPhase_c_empty_n sc_in sc_logic 1 signal 4 } 
	{ bayerPhase_c_read sc_out sc_logic 1 signal 4 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "imgRB_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "imgRB", "role": "dout" }} , 
 	{ "name": "imgRB_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgRB", "role": "num_data_valid" }} , 
 	{ "name": "imgRB_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgRB", "role": "fifo_cap" }} , 
 	{ "name": "imgRB_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgRB", "role": "empty_n" }} , 
 	{ "name": "imgRB_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgRB", "role": "read" }} , 
 	{ "name": "imgRgb_din", "direction": "out", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "imgRgb", "role": "din" }} , 
 	{ "name": "imgRgb_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgRgb", "role": "num_data_valid" }} , 
 	{ "name": "imgRgb_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgRgb", "role": "fifo_cap" }} , 
 	{ "name": "imgRgb_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgRgb", "role": "full_n" }} , 
 	{ "name": "imgRgb_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgRgb", "role": "write" }} , 
 	{ "name": "height", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "height", "role": "default" }} , 
 	{ "name": "width", "direction": "in", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "width", "role": "default" }} , 
 	{ "name": "bayerPhase_c_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "bayerPhase_c", "role": "dout" }} , 
 	{ "name": "bayerPhase_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "bayerPhase_c", "role": "num_data_valid" }} , 
 	{ "name": "bayerPhase_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "bayerPhase_c", "role": "fifo_cap" }} , 
 	{ "name": "bayerPhase_c_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "bayerPhase_c", "role": "empty_n" }} , 
 	{ "name": "bayerPhase_c_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "bayerPhase_c", "role": "read" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3"],
		"CDFG" : "DebayerRandBatG",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "11", "EstimateLatencyMax" : "8873067",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "imgRB", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_DebayerRandBatG_Pipeline_VITIS_LOOP_836_2_fu_156", "Port" : "imgRB", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "imgRgb", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_DebayerRandBatG_Pipeline_VITIS_LOOP_836_2_fu_156", "Port" : "imgRgb", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "height", "Type" : "Stable", "Direction" : "I"},
			{"Name" : "width", "Type" : "Stable", "Direction" : "I"},
			{"Name" : "bayerPhase_c", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "bayerPhase_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_833_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lineBuffer_val_V_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lineBuffer_val_V_2_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_DebayerRandBatG_Pipeline_VITIS_LOOP_836_2_fu_156", "Parent" : "0", "Child" : ["4"],
		"CDFG" : "DebayerRandBatG_Pipeline_VITIS_LOOP_836_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "7", "EstimateLatencyMax" : "4103",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"DependenceCheck" : [
			{"FromInitialState" : "ap_enable_state1_pp0_iter0_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter0", "FromInitialOperation" : "ap_enable_operation_68", "FromInitialSV" : "0", "FromFinalState" : "ap_enable_state2_pp0_iter1_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter1", "FromFinalOperation" : "ap_enable_operation_82", "FromFinalSV" : "1", "FromAddress" : "lineBuffer_val_V_i_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state3_pp0_iter2_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter2", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter3", "ToInitialOperation" : "ap_enable_operation_112", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state3_pp0_iter2_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter2", "ToFinalOperation" : "ap_enable_operation_112", "ToFinalSV" : "2", "ToAddress" : "lineBuffer_val_V_i_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:835:13)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state1_pp0_iter0_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter0", "FromInitialOperation" : "ap_enable_operation_70", "FromInitialSV" : "0", "FromFinalState" : "ap_enable_state2_pp0_iter1_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter1", "FromFinalOperation" : "ap_enable_operation_86", "FromFinalSV" : "1", "FromAddress" : "lineBuffer_val_V_2_i_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state3_pp0_iter2_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter2", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter3", "ToInitialOperation" : "ap_enable_operation_132", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state3_pp0_iter2_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter2", "ToFinalOperation" : "ap_enable_operation_132", "ToFinalSV" : "2", "ToAddress" : "lineBuffer_val_V_2_i_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:835:13)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state3_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_112", "FromInitialSV" : "2", "FromFinalState" : "ap_enable_state3_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_112", "FromFinalSV" : "2", "FromAddress" : "lineBuffer_val_V_i_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state1_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter1", "ToInitialOperation" : "ap_enable_operation_68", "ToInitialSV" : "0", "ToFinalState" : "ap_enable_state2_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_82", "ToFinalSV" : "1", "ToAddress" : "lineBuffer_val_V_i_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:835:13)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state1_pp0_iter0_stage0", "ap_enable_state2_pp0_iter1_stage0", "ap_enable_state3_pp0_iter2_stage0"]},
			{"FromInitialState" : "ap_enable_state3_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_132", "FromInitialSV" : "2", "FromFinalState" : "ap_enable_state3_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_132", "FromFinalSV" : "2", "FromAddress" : "lineBuffer_val_V_2_i_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state1_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter1", "ToInitialOperation" : "ap_enable_operation_70", "ToInitialSV" : "0", "ToFinalState" : "ap_enable_state2_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_86", "ToFinalSV" : "1", "ToAddress" : "lineBuffer_val_V_2_i_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:835:13)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state1_pp0_iter0_stage0", "ap_enable_state2_pp0_iter1_stage0", "ap_enable_state3_pp0_iter2_stage0"]}],
		"Port" : [
			{"Name" : "pixWindow_val_val_V_70_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_69_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_68_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_67_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_66_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_65_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_64_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_63_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_62_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_61_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_60_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "add_ln833_i", "Type" : "Stable", "Direction" : "I"},
			{"Name" : "x_phase_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "xor_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "out_y_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "lineBuffer_val_V_2_i", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "lineBuffer_val_V_i", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "trunc_ln", "Type" : "Stable", "Direction" : "I"},
			{"Name" : "cmp204_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "cmp60_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "imgRB", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "imgRB_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "imgRgb", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "imgRgb_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "pixWindow_val_val_V_82_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_81_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_80_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_79_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_78_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_77_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_76_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_75_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_74_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_73_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_72_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_71_i_out", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_836_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter5", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter5", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_DebayerRandBatG_Pipeline_VITIS_LOOP_836_2_fu_156.flow_control_loop_pipe_sequential_init_U", "Parent" : "3"}]}


set ArgLastReadFirstWriteLatency {
	DebayerRandBatG {
		imgRB {Type I LastRead 1 FirstWrite -1}
		imgRgb {Type O LastRead -1 FirstWrite 5}
		height {Type I LastRead 0 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}
		bayerPhase_c {Type I LastRead 0 FirstWrite -1}}
	DebayerRandBatG_Pipeline_VITIS_LOOP_836_2 {
		pixWindow_val_val_V_70_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_69_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_68_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_67_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_66_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_65_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_64_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_63_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_62_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_61_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_60_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_i {Type I LastRead 0 FirstWrite -1}
		add_ln833_i {Type I LastRead 0 FirstWrite -1}
		x_phase_i {Type I LastRead 0 FirstWrite -1}
		xor_i {Type I LastRead 0 FirstWrite -1}
		out_y_i {Type I LastRead 0 FirstWrite -1}
		lineBuffer_val_V_2_i {Type IO LastRead 0 FirstWrite 2}
		lineBuffer_val_V_i {Type IO LastRead 0 FirstWrite 2}
		trunc_ln {Type I LastRead 0 FirstWrite -1}
		cmp204_i {Type I LastRead 0 FirstWrite -1}
		cmp60_i {Type I LastRead 0 FirstWrite -1}
		imgRB {Type I LastRead 1 FirstWrite -1}
		imgRgb {Type O LastRead -1 FirstWrite 5}
		pixWindow_val_val_V_82_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_81_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_80_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_79_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_78_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_77_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_76_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_75_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_74_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_73_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_72_i_out {Type O LastRead -1 FirstWrite 4}
		pixWindow_val_val_V_71_i_out {Type O LastRead -1 FirstWrite 4}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "11", "Max" : "8873067"}
	, {"Name" : "Interval", "Min" : "11", "Max" : "8873067"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	imgRB { ap_fifo {  { imgRB_dout fifo_port_we 0 30 }  { imgRB_num_data_valid fifo_status_num_data_valid 0 2 }  { imgRB_fifo_cap fifo_update 0 2 }  { imgRB_empty_n fifo_status 0 1 }  { imgRB_read fifo_data 1 1 } } }
	imgRgb { ap_fifo {  { imgRgb_din fifo_port_we 1 30 }  { imgRgb_num_data_valid fifo_status_num_data_valid 0 2 }  { imgRgb_fifo_cap fifo_update 0 2 }  { imgRgb_full_n fifo_status 0 1 }  { imgRgb_write fifo_data 1 1 } } }
	height { ap_stable {  { height in_data 0 12 } } }
	width { ap_stable {  { width in_data 0 13 } } }
	bayerPhase_c { ap_fifo {  { bayerPhase_c_dout fifo_port_we 0 16 }  { bayerPhase_c_num_data_valid fifo_status_num_data_valid 0 2 }  { bayerPhase_c_fifo_cap fifo_update 0 2 }  { bayerPhase_c_empty_n fifo_status 0 1 }  { bayerPhase_c_read fifo_data 1 1 } } }
}
