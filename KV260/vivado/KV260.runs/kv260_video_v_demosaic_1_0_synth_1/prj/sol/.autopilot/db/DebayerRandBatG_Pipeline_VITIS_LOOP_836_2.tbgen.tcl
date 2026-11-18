set moduleName DebayerRandBatG_Pipeline_VITIS_LOOP_836_2
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {DebayerRandBatG_Pipeline_VITIS_LOOP_836_2}
set C_modelType { void 0 }
set C_modelArgList {
	{ pixWindow_val_val_V_70_i int 10 regular  }
	{ pixWindow_val_val_V_69_i int 10 regular  }
	{ pixWindow_val_val_V_68_i int 10 regular  }
	{ pixWindow_val_val_V_67_i int 10 regular  }
	{ pixWindow_val_val_V_66_i int 10 regular  }
	{ pixWindow_val_val_V_65_i int 10 regular  }
	{ pixWindow_val_val_V_64_i int 10 regular  }
	{ pixWindow_val_val_V_63_i int 10 regular  }
	{ pixWindow_val_val_V_62_i int 10 regular  }
	{ pixWindow_val_val_V_61_i int 10 regular  }
	{ pixWindow_val_val_V_60_i int 10 regular  }
	{ pixWindow_val_val_V_i int 10 regular  }
	{ add_ln833_i int 12 regular {ap_stable 0} }
	{ x_phase_i int 1 regular  }
	{ xor_i int 15 regular  }
	{ out_y_i int 12 regular  }
	{ lineBuffer_val_V_2_i int 30 regular {array 2049 { 0 1 } 1 1 }  }
	{ lineBuffer_val_V_i int 30 regular {array 2049 { 0 1 } 1 1 }  }
	{ trunc_ln int 12 regular {ap_stable 0} }
	{ cmp204_i int 1 regular  }
	{ cmp60_i int 1 regular  }
	{ imgRB int 30 regular {fifo 0 volatile }  }
	{ imgRgb int 30 regular {fifo 1 volatile }  }
	{ pixWindow_val_val_V_82_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_81_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_80_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_79_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_78_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_77_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_76_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_75_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_74_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_73_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_72_i_out int 10 regular {pointer 1}  }
	{ pixWindow_val_val_V_71_i_out int 10 regular {pointer 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "pixWindow_val_val_V_70_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_69_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_68_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_67_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_66_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_65_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_64_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_63_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_62_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_61_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_60_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "add_ln833_i", "interface" : "wire", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "x_phase_i", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "xor_i", "interface" : "wire", "bitwidth" : 15, "direction" : "READONLY"} , 
 	{ "Name" : "out_y_i", "interface" : "wire", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "lineBuffer_val_V_2_i", "interface" : "memory", "bitwidth" : 30, "direction" : "READWRITE"} , 
 	{ "Name" : "lineBuffer_val_V_i", "interface" : "memory", "bitwidth" : 30, "direction" : "READWRITE"} , 
 	{ "Name" : "trunc_ln", "interface" : "wire", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "cmp204_i", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "cmp60_i", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "imgRB", "interface" : "fifo", "bitwidth" : 30, "direction" : "READONLY"} , 
 	{ "Name" : "imgRgb", "interface" : "fifo", "bitwidth" : 30, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_82_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_81_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_80_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_79_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_78_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_77_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_76_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_75_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_74_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_73_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_72_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "pixWindow_val_val_V_71_i_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 73
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ imgRB_dout sc_in sc_lv 30 signal 21 } 
	{ imgRB_num_data_valid sc_in sc_lv 2 signal 21 } 
	{ imgRB_fifo_cap sc_in sc_lv 2 signal 21 } 
	{ imgRB_empty_n sc_in sc_logic 1 signal 21 } 
	{ imgRB_read sc_out sc_logic 1 signal 21 } 
	{ imgRgb_din sc_out sc_lv 30 signal 22 } 
	{ imgRgb_num_data_valid sc_in sc_lv 2 signal 22 } 
	{ imgRgb_fifo_cap sc_in sc_lv 2 signal 22 } 
	{ imgRgb_full_n sc_in sc_logic 1 signal 22 } 
	{ imgRgb_write sc_out sc_logic 1 signal 22 } 
	{ pixWindow_val_val_V_70_i sc_in sc_lv 10 signal 0 } 
	{ pixWindow_val_val_V_69_i sc_in sc_lv 10 signal 1 } 
	{ pixWindow_val_val_V_68_i sc_in sc_lv 10 signal 2 } 
	{ pixWindow_val_val_V_67_i sc_in sc_lv 10 signal 3 } 
	{ pixWindow_val_val_V_66_i sc_in sc_lv 10 signal 4 } 
	{ pixWindow_val_val_V_65_i sc_in sc_lv 10 signal 5 } 
	{ pixWindow_val_val_V_64_i sc_in sc_lv 10 signal 6 } 
	{ pixWindow_val_val_V_63_i sc_in sc_lv 10 signal 7 } 
	{ pixWindow_val_val_V_62_i sc_in sc_lv 10 signal 8 } 
	{ pixWindow_val_val_V_61_i sc_in sc_lv 10 signal 9 } 
	{ pixWindow_val_val_V_60_i sc_in sc_lv 10 signal 10 } 
	{ pixWindow_val_val_V_i sc_in sc_lv 10 signal 11 } 
	{ add_ln833_i sc_in sc_lv 12 signal 12 } 
	{ x_phase_i sc_in sc_lv 1 signal 13 } 
	{ xor_i sc_in sc_lv 15 signal 14 } 
	{ out_y_i sc_in sc_lv 12 signal 15 } 
	{ lineBuffer_val_V_2_i_address0 sc_out sc_lv 12 signal 16 } 
	{ lineBuffer_val_V_2_i_ce0 sc_out sc_logic 1 signal 16 } 
	{ lineBuffer_val_V_2_i_we0 sc_out sc_logic 1 signal 16 } 
	{ lineBuffer_val_V_2_i_d0 sc_out sc_lv 30 signal 16 } 
	{ lineBuffer_val_V_2_i_address1 sc_out sc_lv 12 signal 16 } 
	{ lineBuffer_val_V_2_i_ce1 sc_out sc_logic 1 signal 16 } 
	{ lineBuffer_val_V_2_i_q1 sc_in sc_lv 30 signal 16 } 
	{ lineBuffer_val_V_i_address0 sc_out sc_lv 12 signal 17 } 
	{ lineBuffer_val_V_i_ce0 sc_out sc_logic 1 signal 17 } 
	{ lineBuffer_val_V_i_we0 sc_out sc_logic 1 signal 17 } 
	{ lineBuffer_val_V_i_d0 sc_out sc_lv 30 signal 17 } 
	{ lineBuffer_val_V_i_address1 sc_out sc_lv 12 signal 17 } 
	{ lineBuffer_val_V_i_ce1 sc_out sc_logic 1 signal 17 } 
	{ lineBuffer_val_V_i_q1 sc_in sc_lv 30 signal 17 } 
	{ trunc_ln sc_in sc_lv 12 signal 18 } 
	{ cmp204_i sc_in sc_lv 1 signal 19 } 
	{ cmp60_i sc_in sc_lv 1 signal 20 } 
	{ pixWindow_val_val_V_82_i_out sc_out sc_lv 10 signal 23 } 
	{ pixWindow_val_val_V_82_i_out_ap_vld sc_out sc_logic 1 outvld 23 } 
	{ pixWindow_val_val_V_81_i_out sc_out sc_lv 10 signal 24 } 
	{ pixWindow_val_val_V_81_i_out_ap_vld sc_out sc_logic 1 outvld 24 } 
	{ pixWindow_val_val_V_80_i_out sc_out sc_lv 10 signal 25 } 
	{ pixWindow_val_val_V_80_i_out_ap_vld sc_out sc_logic 1 outvld 25 } 
	{ pixWindow_val_val_V_79_i_out sc_out sc_lv 10 signal 26 } 
	{ pixWindow_val_val_V_79_i_out_ap_vld sc_out sc_logic 1 outvld 26 } 
	{ pixWindow_val_val_V_78_i_out sc_out sc_lv 10 signal 27 } 
	{ pixWindow_val_val_V_78_i_out_ap_vld sc_out sc_logic 1 outvld 27 } 
	{ pixWindow_val_val_V_77_i_out sc_out sc_lv 10 signal 28 } 
	{ pixWindow_val_val_V_77_i_out_ap_vld sc_out sc_logic 1 outvld 28 } 
	{ pixWindow_val_val_V_76_i_out sc_out sc_lv 10 signal 29 } 
	{ pixWindow_val_val_V_76_i_out_ap_vld sc_out sc_logic 1 outvld 29 } 
	{ pixWindow_val_val_V_75_i_out sc_out sc_lv 10 signal 30 } 
	{ pixWindow_val_val_V_75_i_out_ap_vld sc_out sc_logic 1 outvld 30 } 
	{ pixWindow_val_val_V_74_i_out sc_out sc_lv 10 signal 31 } 
	{ pixWindow_val_val_V_74_i_out_ap_vld sc_out sc_logic 1 outvld 31 } 
	{ pixWindow_val_val_V_73_i_out sc_out sc_lv 10 signal 32 } 
	{ pixWindow_val_val_V_73_i_out_ap_vld sc_out sc_logic 1 outvld 32 } 
	{ pixWindow_val_val_V_72_i_out sc_out sc_lv 10 signal 33 } 
	{ pixWindow_val_val_V_72_i_out_ap_vld sc_out sc_logic 1 outvld 33 } 
	{ pixWindow_val_val_V_71_i_out sc_out sc_lv 10 signal 34 } 
	{ pixWindow_val_val_V_71_i_out_ap_vld sc_out sc_logic 1 outvld 34 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
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
 	{ "name": "pixWindow_val_val_V_70_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_70_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_69_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_69_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_68_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_68_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_67_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_67_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_66_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_66_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_65_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_65_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_64_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_64_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_63_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_63_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_62_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_62_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_61_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_61_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_60_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_60_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_i", "role": "default" }} , 
 	{ "name": "add_ln833_i", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "add_ln833_i", "role": "default" }} , 
 	{ "name": "x_phase_i", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "x_phase_i", "role": "default" }} , 
 	{ "name": "xor_i", "direction": "in", "datatype": "sc_lv", "bitwidth":15, "type": "signal", "bundle":{"name": "xor_i", "role": "default" }} , 
 	{ "name": "out_y_i", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "out_y_i", "role": "default" }} , 
 	{ "name": "lineBuffer_val_V_2_i_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "lineBuffer_val_V_2_i", "role": "address0" }} , 
 	{ "name": "lineBuffer_val_V_2_i_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "lineBuffer_val_V_2_i", "role": "ce0" }} , 
 	{ "name": "lineBuffer_val_V_2_i_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "lineBuffer_val_V_2_i", "role": "we0" }} , 
 	{ "name": "lineBuffer_val_V_2_i_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "lineBuffer_val_V_2_i", "role": "d0" }} , 
 	{ "name": "lineBuffer_val_V_2_i_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "lineBuffer_val_V_2_i", "role": "address1" }} , 
 	{ "name": "lineBuffer_val_V_2_i_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "lineBuffer_val_V_2_i", "role": "ce1" }} , 
 	{ "name": "lineBuffer_val_V_2_i_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "lineBuffer_val_V_2_i", "role": "q1" }} , 
 	{ "name": "lineBuffer_val_V_i_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "lineBuffer_val_V_i", "role": "address0" }} , 
 	{ "name": "lineBuffer_val_V_i_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "lineBuffer_val_V_i", "role": "ce0" }} , 
 	{ "name": "lineBuffer_val_V_i_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "lineBuffer_val_V_i", "role": "we0" }} , 
 	{ "name": "lineBuffer_val_V_i_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "lineBuffer_val_V_i", "role": "d0" }} , 
 	{ "name": "lineBuffer_val_V_i_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "lineBuffer_val_V_i", "role": "address1" }} , 
 	{ "name": "lineBuffer_val_V_i_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "lineBuffer_val_V_i", "role": "ce1" }} , 
 	{ "name": "lineBuffer_val_V_i_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "lineBuffer_val_V_i", "role": "q1" }} , 
 	{ "name": "trunc_ln", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "trunc_ln", "role": "default" }} , 
 	{ "name": "cmp204_i", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "cmp204_i", "role": "default" }} , 
 	{ "name": "cmp60_i", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "cmp60_i", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_82_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_82_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_82_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_82_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_81_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_81_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_81_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_81_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_80_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_80_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_80_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_80_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_79_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_79_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_79_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_79_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_78_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_78_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_78_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_78_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_77_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_77_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_77_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_77_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_76_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_76_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_76_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_76_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_75_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_75_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_75_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_75_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_74_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_74_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_74_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_74_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_73_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_73_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_73_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_73_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_72_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_72_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_72_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_72_i_out", "role": "ap_vld" }} , 
 	{ "name": "pixWindow_val_val_V_71_i_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "pixWindow_val_val_V_71_i_out", "role": "default" }} , 
 	{ "name": "pixWindow_val_val_V_71_i_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pixWindow_val_val_V_71_i_out", "role": "ap_vld" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "DebayerRandBatG_Pipeline_VITIS_LOOP_836_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "7", "EstimateLatencyMax" : "2055",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"DependenceCheck" : [
			{"FromInitialState" : "ap_enable_state1_pp0_iter0_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter0", "FromInitialOperation" : "ap_enable_operation_68", "FromInitialSV" : "0", "FromFinalState" : "ap_enable_state2_pp0_iter1_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter1", "FromFinalOperation" : "ap_enable_operation_82", "FromFinalSV" : "1", "FromAddress" : "lineBuffer_val_V_i_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state3_pp0_iter2_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter2", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter3", "ToInitialOperation" : "ap_enable_operation_112", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state3_pp0_iter2_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter2", "ToFinalOperation" : "ap_enable_operation_112", "ToFinalSV" : "2", "ToAddress" : "lineBuffer_val_V_i_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "12", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_1_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:835:13)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state1_pp0_iter0_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter0", "FromInitialOperation" : "ap_enable_operation_70", "FromInitialSV" : "0", "FromFinalState" : "ap_enable_state2_pp0_iter1_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter1", "FromFinalOperation" : "ap_enable_operation_86", "FromFinalSV" : "1", "FromAddress" : "lineBuffer_val_V_2_i_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state3_pp0_iter2_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter2", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter3", "ToInitialOperation" : "ap_enable_operation_132", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state3_pp0_iter2_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter2", "ToFinalOperation" : "ap_enable_operation_132", "ToFinalSV" : "2", "ToAddress" : "lineBuffer_val_V_2_i_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "12", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_1_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:835:13)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state3_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_112", "FromInitialSV" : "2", "FromFinalState" : "ap_enable_state3_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_112", "FromFinalSV" : "2", "FromAddress" : "lineBuffer_val_V_i_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state1_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter1", "ToInitialOperation" : "ap_enable_operation_68", "ToInitialSV" : "0", "ToFinalState" : "ap_enable_state2_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_82", "ToFinalSV" : "1", "ToAddress" : "lineBuffer_val_V_i_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "12", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_1_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:835:13)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state1_pp0_iter0_stage0", "ap_enable_state2_pp0_iter1_stage0", "ap_enable_state3_pp0_iter2_stage0"]},
			{"FromInitialState" : "ap_enable_state3_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_132", "FromInitialSV" : "2", "FromFinalState" : "ap_enable_state3_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_132", "FromFinalSV" : "2", "FromAddress" : "lineBuffer_val_V_2_i_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state1_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter1", "ToInitialOperation" : "ap_enable_operation_70", "ToInitialSV" : "0", "ToFinalState" : "ap_enable_state2_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_86", "ToFinalSV" : "1", "ToAddress" : "lineBuffer_val_V_2_i_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "12", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_1_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:835:13)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state1_pp0_iter0_stage0", "ap_enable_state2_pp0_iter1_stage0", "ap_enable_state3_pp0_iter2_stage0"]}],
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
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
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
	{"Name" : "Latency", "Min" : "7", "Max" : "2055"}
	, {"Name" : "Interval", "Min" : "7", "Max" : "2055"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	pixWindow_val_val_V_70_i { ap_none {  { pixWindow_val_val_V_70_i in_data 0 10 } } }
	pixWindow_val_val_V_69_i { ap_none {  { pixWindow_val_val_V_69_i in_data 0 10 } } }
	pixWindow_val_val_V_68_i { ap_none {  { pixWindow_val_val_V_68_i in_data 0 10 } } }
	pixWindow_val_val_V_67_i { ap_none {  { pixWindow_val_val_V_67_i in_data 0 10 } } }
	pixWindow_val_val_V_66_i { ap_none {  { pixWindow_val_val_V_66_i in_data 0 10 } } }
	pixWindow_val_val_V_65_i { ap_none {  { pixWindow_val_val_V_65_i in_data 0 10 } } }
	pixWindow_val_val_V_64_i { ap_none {  { pixWindow_val_val_V_64_i in_data 0 10 } } }
	pixWindow_val_val_V_63_i { ap_none {  { pixWindow_val_val_V_63_i in_data 0 10 } } }
	pixWindow_val_val_V_62_i { ap_none {  { pixWindow_val_val_V_62_i in_data 0 10 } } }
	pixWindow_val_val_V_61_i { ap_none {  { pixWindow_val_val_V_61_i in_data 0 10 } } }
	pixWindow_val_val_V_60_i { ap_none {  { pixWindow_val_val_V_60_i in_data 0 10 } } }
	pixWindow_val_val_V_i { ap_none {  { pixWindow_val_val_V_i in_data 0 10 } } }
	add_ln833_i { ap_stable {  { add_ln833_i in_data 0 12 } } }
	x_phase_i { ap_none {  { x_phase_i in_data 0 1 } } }
	xor_i { ap_none {  { xor_i in_data 0 15 } } }
	out_y_i { ap_none {  { out_y_i in_data 0 12 } } }
	lineBuffer_val_V_2_i { ap_memory {  { lineBuffer_val_V_2_i_address0 mem_address 1 12 }  { lineBuffer_val_V_2_i_ce0 mem_ce 1 1 }  { lineBuffer_val_V_2_i_we0 mem_we 1 1 }  { lineBuffer_val_V_2_i_d0 mem_din 1 30 }  { lineBuffer_val_V_2_i_address1 MemPortADDR2 1 12 }  { lineBuffer_val_V_2_i_ce1 MemPortCE2 1 1 }  { lineBuffer_val_V_2_i_q1 in_data 0 30 } } }
	lineBuffer_val_V_i { ap_memory {  { lineBuffer_val_V_i_address0 mem_address 1 12 }  { lineBuffer_val_V_i_ce0 mem_ce 1 1 }  { lineBuffer_val_V_i_we0 mem_we 1 1 }  { lineBuffer_val_V_i_d0 mem_din 1 30 }  { lineBuffer_val_V_i_address1 MemPortADDR2 1 12 }  { lineBuffer_val_V_i_ce1 MemPortCE2 1 1 }  { lineBuffer_val_V_i_q1 in_data 0 30 } } }
	trunc_ln { ap_stable {  { trunc_ln in_data 0 12 } } }
	cmp204_i { ap_none {  { cmp204_i in_data 0 1 } } }
	cmp60_i { ap_none {  { cmp60_i in_data 0 1 } } }
	imgRB { ap_fifo {  { imgRB_dout fifo_port_we 0 30 }  { imgRB_num_data_valid fifo_status_num_data_valid 0 2 }  { imgRB_fifo_cap fifo_update 0 2 }  { imgRB_empty_n fifo_status 0 1 }  { imgRB_read fifo_data 1 1 } } }
	imgRgb { ap_fifo {  { imgRgb_din fifo_port_we 1 30 }  { imgRgb_num_data_valid fifo_status_num_data_valid 0 2 }  { imgRgb_fifo_cap fifo_update 0 2 }  { imgRgb_full_n fifo_status 0 1 }  { imgRgb_write fifo_data 1 1 } } }
	pixWindow_val_val_V_82_i_out { ap_vld {  { pixWindow_val_val_V_82_i_out out_data 1 10 }  { pixWindow_val_val_V_82_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_81_i_out { ap_vld {  { pixWindow_val_val_V_81_i_out out_data 1 10 }  { pixWindow_val_val_V_81_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_80_i_out { ap_vld {  { pixWindow_val_val_V_80_i_out out_data 1 10 }  { pixWindow_val_val_V_80_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_79_i_out { ap_vld {  { pixWindow_val_val_V_79_i_out out_data 1 10 }  { pixWindow_val_val_V_79_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_78_i_out { ap_vld {  { pixWindow_val_val_V_78_i_out out_data 1 10 }  { pixWindow_val_val_V_78_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_77_i_out { ap_vld {  { pixWindow_val_val_V_77_i_out out_data 1 10 }  { pixWindow_val_val_V_77_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_76_i_out { ap_vld {  { pixWindow_val_val_V_76_i_out out_data 1 10 }  { pixWindow_val_val_V_76_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_75_i_out { ap_vld {  { pixWindow_val_val_V_75_i_out out_data 1 10 }  { pixWindow_val_val_V_75_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_74_i_out { ap_vld {  { pixWindow_val_val_V_74_i_out out_data 1 10 }  { pixWindow_val_val_V_74_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_73_i_out { ap_vld {  { pixWindow_val_val_V_73_i_out out_data 1 10 }  { pixWindow_val_val_V_73_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_72_i_out { ap_vld {  { pixWindow_val_val_V_72_i_out out_data 1 10 }  { pixWindow_val_val_V_72_i_out_ap_vld out_vld 1 1 } } }
	pixWindow_val_val_V_71_i_out { ap_vld {  { pixWindow_val_val_V_71_i_out out_data 1 10 }  { pixWindow_val_val_V_71_i_out_ap_vld out_vld 1 1 } } }
}
