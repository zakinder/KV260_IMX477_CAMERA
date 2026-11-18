set moduleName DebayerRatBorBatR
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
set C_modelName {DebayerRatBorBatR}
set C_modelType { void 0 }
set C_modelArgList {
	{ imgG int 30 regular {fifo 0 volatile }  }
	{ imgRB int 30 regular {fifo 1 volatile }  }
	{ height int 11 regular {ap_stable 0} }
	{ width int 12 regular {ap_stable 0} }
	{ bayerPhase_c9 int 16 regular {fifo 0}  }
	{ bayerPhase_c int 16 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "imgG", "interface" : "fifo", "bitwidth" : 30, "direction" : "READONLY"} , 
 	{ "Name" : "imgRB", "interface" : "fifo", "bitwidth" : 30, "direction" : "WRITEONLY"} , 
 	{ "Name" : "height", "interface" : "wire", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "width", "interface" : "wire", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "bayerPhase_c9", "interface" : "fifo", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "bayerPhase_c", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 32
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ start_full_n sc_in sc_logic 1 signal -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ start_out sc_out sc_logic 1 signal -1 } 
	{ start_write sc_out sc_logic 1 signal -1 } 
	{ imgG_dout sc_in sc_lv 30 signal 0 } 
	{ imgG_num_data_valid sc_in sc_lv 2 signal 0 } 
	{ imgG_fifo_cap sc_in sc_lv 2 signal 0 } 
	{ imgG_empty_n sc_in sc_logic 1 signal 0 } 
	{ imgG_read sc_out sc_logic 1 signal 0 } 
	{ imgRB_din sc_out sc_lv 30 signal 1 } 
	{ imgRB_num_data_valid sc_in sc_lv 2 signal 1 } 
	{ imgRB_fifo_cap sc_in sc_lv 2 signal 1 } 
	{ imgRB_full_n sc_in sc_logic 1 signal 1 } 
	{ imgRB_write sc_out sc_logic 1 signal 1 } 
	{ height sc_in sc_lv 11 signal 2 } 
	{ width sc_in sc_lv 12 signal 3 } 
	{ bayerPhase_c9_dout sc_in sc_lv 16 signal 4 } 
	{ bayerPhase_c9_num_data_valid sc_in sc_lv 2 signal 4 } 
	{ bayerPhase_c9_fifo_cap sc_in sc_lv 2 signal 4 } 
	{ bayerPhase_c9_empty_n sc_in sc_logic 1 signal 4 } 
	{ bayerPhase_c9_read sc_out sc_logic 1 signal 4 } 
	{ bayerPhase_c_din sc_out sc_lv 16 signal 5 } 
	{ bayerPhase_c_num_data_valid sc_in sc_lv 2 signal 5 } 
	{ bayerPhase_c_fifo_cap sc_in sc_lv 2 signal 5 } 
	{ bayerPhase_c_full_n sc_in sc_logic 1 signal 5 } 
	{ bayerPhase_c_write sc_out sc_logic 1 signal 5 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "start_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_full_n", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "start_out", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_out", "role": "default" }} , 
 	{ "name": "start_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_write", "role": "default" }} , 
 	{ "name": "imgG_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "imgG", "role": "dout" }} , 
 	{ "name": "imgG_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgG", "role": "num_data_valid" }} , 
 	{ "name": "imgG_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgG", "role": "fifo_cap" }} , 
 	{ "name": "imgG_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgG", "role": "empty_n" }} , 
 	{ "name": "imgG_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgG", "role": "read" }} , 
 	{ "name": "imgRB_din", "direction": "out", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "imgRB", "role": "din" }} , 
 	{ "name": "imgRB_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgRB", "role": "num_data_valid" }} , 
 	{ "name": "imgRB_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgRB", "role": "fifo_cap" }} , 
 	{ "name": "imgRB_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgRB", "role": "full_n" }} , 
 	{ "name": "imgRB_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgRB", "role": "write" }} , 
 	{ "name": "height", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "height", "role": "default" }} , 
 	{ "name": "width", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "width", "role": "default" }} , 
 	{ "name": "bayerPhase_c9_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "bayerPhase_c9", "role": "dout" }} , 
 	{ "name": "bayerPhase_c9_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "bayerPhase_c9", "role": "num_data_valid" }} , 
 	{ "name": "bayerPhase_c9_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "bayerPhase_c9", "role": "fifo_cap" }} , 
 	{ "name": "bayerPhase_c9_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "bayerPhase_c9", "role": "empty_n" }} , 
 	{ "name": "bayerPhase_c9_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "bayerPhase_c9", "role": "read" }} , 
 	{ "name": "bayerPhase_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "bayerPhase_c", "role": "din" }} , 
 	{ "name": "bayerPhase_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "bayerPhase_c", "role": "num_data_valid" }} , 
 	{ "name": "bayerPhase_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "bayerPhase_c", "role": "fifo_cap" }} , 
 	{ "name": "bayerPhase_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "bayerPhase_c", "role": "full_n" }} , 
 	{ "name": "bayerPhase_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "bayerPhase_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3"],
		"CDFG" : "DebayerRatBorBatR",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "13", "EstimateLatencyMax" : "2226861",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "imgG", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2_fu_184", "Port" : "imgG", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "imgRB", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2_fu_184", "Port" : "imgRB", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "height", "Type" : "Stable", "Direction" : "I"},
			{"Name" : "width", "Type" : "Stable", "Direction" : "I"},
			{"Name" : "bayerPhase_c9", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "bayerPhase_c9_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "bayerPhase_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "bayerPhase_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_585_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lineBuffer_val_V_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lineBuffer_val_V_1_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2_fu_184", "Parent" : "0", "Child" : ["4", "5", "6", "7", "8", "9"],
		"CDFG" : "DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "9", "EstimateLatencyMax" : "2057",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"DependenceCheck" : [
			{"FromInitialState" : "ap_enable_state1_pp0_iter0_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter0", "FromInitialOperation" : "ap_enable_operation_82", "FromInitialSV" : "0", "FromFinalState" : "ap_enable_state2_pp0_iter1_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter1", "FromFinalOperation" : "ap_enable_operation_96", "FromFinalSV" : "1", "FromAddress" : "lineBuffer_val_V_i_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state3_pp0_iter2_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter2", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter3", "ToInitialOperation" : "ap_enable_operation_130", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state3_pp0_iter2_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter2", "ToFinalOperation" : "ap_enable_operation_130", "ToFinalSV" : "2", "ToAddress" : "lineBuffer_val_V_i_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "12", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_1_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:587:13)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state1_pp0_iter0_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter0", "FromInitialOperation" : "ap_enable_operation_84", "FromInitialSV" : "0", "FromFinalState" : "ap_enable_state2_pp0_iter1_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter1", "FromFinalOperation" : "ap_enable_operation_100", "FromFinalSV" : "1", "FromAddress" : "lineBuffer_val_V_1_i_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state3_pp0_iter2_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter2", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter3", "ToInitialOperation" : "ap_enable_operation_152", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state3_pp0_iter2_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter2", "ToFinalOperation" : "ap_enable_operation_152", "ToFinalSV" : "2", "ToAddress" : "lineBuffer_val_V_1_i_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "12", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_1_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:587:13)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state3_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_130", "FromInitialSV" : "2", "FromFinalState" : "ap_enable_state3_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_130", "FromFinalSV" : "2", "FromAddress" : "lineBuffer_val_V_i_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state1_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter1", "ToInitialOperation" : "ap_enable_operation_82", "ToInitialSV" : "0", "ToFinalState" : "ap_enable_state2_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_96", "ToFinalSV" : "1", "ToAddress" : "lineBuffer_val_V_i_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "12", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_1_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:587:13)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state1_pp0_iter0_stage0", "ap_enable_state2_pp0_iter1_stage0", "ap_enable_state3_pp0_iter2_stage0"]},
			{"FromInitialState" : "ap_enable_state3_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_152", "FromInitialSV" : "2", "FromFinalState" : "ap_enable_state3_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_152", "FromFinalSV" : "2", "FromAddress" : "lineBuffer_val_V_1_i_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state1_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter1", "ToInitialOperation" : "ap_enable_operation_84", "ToInitialSV" : "0", "ToFinalState" : "ap_enable_state2_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_100", "ToFinalSV" : "1", "ToAddress" : "lineBuffer_val_V_1_i_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "12", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_1_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:587:13)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state1_pp0_iter0_stage0", "ap_enable_state2_pp0_iter1_stage0", "ap_enable_state3_pp0_iter2_stage0"]}],
		"Port" : [
			{"Name" : "pixWindow_val_val_V_14_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_13_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_12_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_11_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_10_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_9_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_8_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_7_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_6_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_5_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_4_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_3_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_2_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_1_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "pixWindow_val_val_V_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "add_ln585_i", "Type" : "Stable", "Direction" : "I"},
			{"Name" : "out_y_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "x_phase_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "xor_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "lineBuffer_val_V_1_i", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "lineBuffer_val_V_i", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "trunc_ln", "Type" : "Stable", "Direction" : "I"},
			{"Name" : "cmp204_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "cmp60_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "imgG", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "imgG_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "cond479_cast_cast_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "red_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "cond_cast_cast_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "imgRB", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "imgRB_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "pixWindow_val_val_V_29_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_28_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_27_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_26_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_25_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_24_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_23_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_22_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_21_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_20_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_19_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_18_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_17_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_16_i_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixWindow_val_val_V_15_i_out", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_588_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter7", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter7", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2_fu_184.mux_32_10_1_1_U130", "Parent" : "3"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2_fu_184.mux_32_10_1_1_U131", "Parent" : "3"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2_fu_184.mux_32_10_1_1_U132", "Parent" : "3"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2_fu_184.mux_32_10_1_1_U133", "Parent" : "3"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2_fu_184.mux_32_10_1_1_U134", "Parent" : "3"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2_fu_184.flow_control_loop_pipe_sequential_init_U", "Parent" : "3"}]}


set ArgLastReadFirstWriteLatency {
	DebayerRatBorBatR {
		imgG {Type I LastRead 1 FirstWrite -1}
		imgRB {Type O LastRead -1 FirstWrite 7}
		height {Type I LastRead 0 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}
		bayerPhase_c9 {Type I LastRead 0 FirstWrite -1}
		bayerPhase_c {Type O LastRead -1 FirstWrite 0}}
	DebayerRatBorBatR_Pipeline_VITIS_LOOP_588_2 {
		pixWindow_val_val_V_14_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_13_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_12_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_11_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_10_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_9_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_8_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_7_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_6_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_5_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_4_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_3_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_2_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_1_i {Type I LastRead 0 FirstWrite -1}
		pixWindow_val_val_V_i {Type I LastRead 0 FirstWrite -1}
		add_ln585_i {Type I LastRead 0 FirstWrite -1}
		out_y_i {Type I LastRead 0 FirstWrite -1}
		x_phase_i {Type I LastRead 0 FirstWrite -1}
		xor_i {Type I LastRead 0 FirstWrite -1}
		lineBuffer_val_V_1_i {Type IO LastRead 0 FirstWrite 2}
		lineBuffer_val_V_i {Type IO LastRead 0 FirstWrite 2}
		trunc_ln {Type I LastRead 0 FirstWrite -1}
		cmp204_i {Type I LastRead 0 FirstWrite -1}
		cmp60_i {Type I LastRead 0 FirstWrite -1}
		imgG {Type I LastRead 1 FirstWrite -1}
		cond479_cast_cast_i {Type I LastRead 0 FirstWrite -1}
		red_i {Type I LastRead 0 FirstWrite -1}
		cond_cast_cast_i {Type I LastRead 0 FirstWrite -1}
		imgRB {Type O LastRead -1 FirstWrite 7}
		pixWindow_val_val_V_29_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_28_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_27_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_26_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_25_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_24_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_23_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_22_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_21_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_20_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_19_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_18_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_17_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_16_i_out {Type O LastRead -1 FirstWrite 6}
		pixWindow_val_val_V_15_i_out {Type O LastRead -1 FirstWrite 6}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "13", "Max" : "2226861"}
	, {"Name" : "Interval", "Min" : "13", "Max" : "2226861"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	imgG { ap_fifo {  { imgG_dout fifo_port_we 0 30 }  { imgG_num_data_valid fifo_status_num_data_valid 0 2 }  { imgG_fifo_cap fifo_update 0 2 }  { imgG_empty_n fifo_status 0 1 }  { imgG_read fifo_data 1 1 } } }
	imgRB { ap_fifo {  { imgRB_din fifo_port_we 1 30 }  { imgRB_num_data_valid fifo_status_num_data_valid 0 2 }  { imgRB_fifo_cap fifo_update 0 2 }  { imgRB_full_n fifo_status 0 1 }  { imgRB_write fifo_data 1 1 } } }
	height { ap_stable {  { height in_data 0 11 } } }
	width { ap_stable {  { width in_data 0 12 } } }
	bayerPhase_c9 { ap_fifo {  { bayerPhase_c9_dout fifo_port_we 0 16 }  { bayerPhase_c9_num_data_valid fifo_status_num_data_valid 0 2 }  { bayerPhase_c9_fifo_cap fifo_update 0 2 }  { bayerPhase_c9_empty_n fifo_status 0 1 }  { bayerPhase_c9_read fifo_data 1 1 } } }
	bayerPhase_c { ap_fifo {  { bayerPhase_c_din fifo_port_we 1 16 }  { bayerPhase_c_num_data_valid fifo_status_num_data_valid 0 2 }  { bayerPhase_c_fifo_cap fifo_update 0 2 }  { bayerPhase_c_full_n fifo_status 0 1 }  { bayerPhase_c_write fifo_data 1 1 } } }
}
