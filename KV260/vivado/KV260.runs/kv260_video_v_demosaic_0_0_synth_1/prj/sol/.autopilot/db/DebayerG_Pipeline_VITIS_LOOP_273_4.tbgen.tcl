set moduleName DebayerG_Pipeline_VITIS_LOOP_273_4
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
set C_modelName {DebayerG_Pipeline_VITIS_LOOP_273_4}
set C_modelType { void 0 }
set C_modelArgList {
	{ bayerWindow_val_V_19 int 10 regular  }
	{ bayerWindow_val_V_18 int 10 regular  }
	{ bayerWindow_val_V_17 int 10 regular  }
	{ bayerWindow_val_V_16 int 10 regular  }
	{ bayerWindow_val_V_15 int 10 regular  }
	{ bayerWindow_val_V_14 int 10 regular  }
	{ bayerWindow_val_V_13 int 10 regular  }
	{ bayerWindow_val_V_12 int 10 regular  }
	{ bayerWindow_val_V_11 int 10 regular  }
	{ bayerWindow_val_V_10 int 10 regular  }
	{ bayerWindow_val_V_9 int 10 regular  }
	{ bayerWindow_val_V_8 int 10 regular  }
	{ bayerWindow_val_V_7 int 10 regular  }
	{ bayerWindow_val_V_6 int 10 regular  }
	{ bayerWindow_val_V_5 int 10 regular  }
	{ bayerWindow_val_V_4 int 10 regular  }
	{ bayerWindow_val_V_3 int 10 regular  }
	{ bayerWindow_val_V_2 int 10 regular  }
	{ bayerWindow_val_V_1 int 10 regular  }
	{ bayerWindow_val_V int 10 regular  }
	{ add_ln270 int 17 regular {ap_stable 0} }
	{ x_phase int 1 regular  }
	{ xor_r int 15 regular  }
	{ cmp724 int 1 regular  }
	{ out_y int 17 regular  }
	{ linebuf_yuv_val_V_3 int 10 regular {array 4097 { 0 1 } 1 1 }  }
	{ linebuf_yuv_val_V_2 int 10 regular {array 4097 { 0 1 } 1 1 }  }
	{ linebuf_yuv_val_V_1 int 10 regular {array 4097 { 0 1 } 1 1 }  }
	{ linebuf_yuv_val_V int 10 regular {array 4097 { 0 1 } 1 1 }  }
	{ zext_ln238 int 16 regular {ap_stable 0} }
	{ cmp170 int 1 regular  }
	{ imgBayer int 10 regular {fifo 0 volatile }  }
	{ cmp84 int 1 regular  }
	{ imgG int 30 regular {fifo 1 volatile }  }
	{ bayerWindow_val_V_39_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_38_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_37_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_36_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_35_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_34_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_33_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_32_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_31_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_30_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_29_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_28_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_27_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_26_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_25_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_24_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_23_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_22_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_21_out int 10 regular {pointer 1}  }
	{ bayerWindow_val_V_20_out int 10 regular {pointer 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "bayerWindow_val_V_19", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_18", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_17", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_16", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_15", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_14", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_13", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_12", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_11", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_10", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_9", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_8", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_7", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_6", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_5", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_4", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_3", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_2", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V_1", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "bayerWindow_val_V", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "add_ln270", "interface" : "wire", "bitwidth" : 17, "direction" : "READONLY"} , 
 	{ "Name" : "x_phase", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "xor_r", "interface" : "wire", "bitwidth" : 15, "direction" : "READONLY"} , 
 	{ "Name" : "cmp724", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "out_y", "interface" : "wire", "bitwidth" : 17, "direction" : "READONLY"} , 
 	{ "Name" : "linebuf_yuv_val_V_3", "interface" : "memory", "bitwidth" : 10, "direction" : "READWRITE"} , 
 	{ "Name" : "linebuf_yuv_val_V_2", "interface" : "memory", "bitwidth" : 10, "direction" : "READWRITE"} , 
 	{ "Name" : "linebuf_yuv_val_V_1", "interface" : "memory", "bitwidth" : 10, "direction" : "READWRITE"} , 
 	{ "Name" : "linebuf_yuv_val_V", "interface" : "memory", "bitwidth" : 10, "direction" : "READWRITE"} , 
 	{ "Name" : "zext_ln238", "interface" : "wire", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "cmp170", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "imgBayer", "interface" : "fifo", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "cmp84", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "imgG", "interface" : "fifo", "bitwidth" : 30, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_39_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_38_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_37_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_36_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_35_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_34_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_33_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_32_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_31_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_30_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_29_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_28_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_27_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_26_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_25_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_24_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_23_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_22_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_21_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bayerWindow_val_V_20_out", "interface" : "wire", "bitwidth" : 10, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 112
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ imgBayer_dout sc_in sc_lv 10 signal 31 } 
	{ imgBayer_num_data_valid sc_in sc_lv 2 signal 31 } 
	{ imgBayer_fifo_cap sc_in sc_lv 2 signal 31 } 
	{ imgBayer_empty_n sc_in sc_logic 1 signal 31 } 
	{ imgBayer_read sc_out sc_logic 1 signal 31 } 
	{ imgG_din sc_out sc_lv 30 signal 33 } 
	{ imgG_num_data_valid sc_in sc_lv 2 signal 33 } 
	{ imgG_fifo_cap sc_in sc_lv 2 signal 33 } 
	{ imgG_full_n sc_in sc_logic 1 signal 33 } 
	{ imgG_write sc_out sc_logic 1 signal 33 } 
	{ bayerWindow_val_V_19 sc_in sc_lv 10 signal 0 } 
	{ bayerWindow_val_V_18 sc_in sc_lv 10 signal 1 } 
	{ bayerWindow_val_V_17 sc_in sc_lv 10 signal 2 } 
	{ bayerWindow_val_V_16 sc_in sc_lv 10 signal 3 } 
	{ bayerWindow_val_V_15 sc_in sc_lv 10 signal 4 } 
	{ bayerWindow_val_V_14 sc_in sc_lv 10 signal 5 } 
	{ bayerWindow_val_V_13 sc_in sc_lv 10 signal 6 } 
	{ bayerWindow_val_V_12 sc_in sc_lv 10 signal 7 } 
	{ bayerWindow_val_V_11 sc_in sc_lv 10 signal 8 } 
	{ bayerWindow_val_V_10 sc_in sc_lv 10 signal 9 } 
	{ bayerWindow_val_V_9 sc_in sc_lv 10 signal 10 } 
	{ bayerWindow_val_V_8 sc_in sc_lv 10 signal 11 } 
	{ bayerWindow_val_V_7 sc_in sc_lv 10 signal 12 } 
	{ bayerWindow_val_V_6 sc_in sc_lv 10 signal 13 } 
	{ bayerWindow_val_V_5 sc_in sc_lv 10 signal 14 } 
	{ bayerWindow_val_V_4 sc_in sc_lv 10 signal 15 } 
	{ bayerWindow_val_V_3 sc_in sc_lv 10 signal 16 } 
	{ bayerWindow_val_V_2 sc_in sc_lv 10 signal 17 } 
	{ bayerWindow_val_V_1 sc_in sc_lv 10 signal 18 } 
	{ bayerWindow_val_V sc_in sc_lv 10 signal 19 } 
	{ add_ln270 sc_in sc_lv 17 signal 20 } 
	{ x_phase sc_in sc_lv 1 signal 21 } 
	{ xor_r sc_in sc_lv 15 signal 22 } 
	{ cmp724 sc_in sc_lv 1 signal 23 } 
	{ out_y sc_in sc_lv 17 signal 24 } 
	{ linebuf_yuv_val_V_3_address0 sc_out sc_lv 13 signal 25 } 
	{ linebuf_yuv_val_V_3_ce0 sc_out sc_logic 1 signal 25 } 
	{ linebuf_yuv_val_V_3_we0 sc_out sc_logic 1 signal 25 } 
	{ linebuf_yuv_val_V_3_d0 sc_out sc_lv 10 signal 25 } 
	{ linebuf_yuv_val_V_3_address1 sc_out sc_lv 13 signal 25 } 
	{ linebuf_yuv_val_V_3_ce1 sc_out sc_logic 1 signal 25 } 
	{ linebuf_yuv_val_V_3_q1 sc_in sc_lv 10 signal 25 } 
	{ linebuf_yuv_val_V_2_address0 sc_out sc_lv 13 signal 26 } 
	{ linebuf_yuv_val_V_2_ce0 sc_out sc_logic 1 signal 26 } 
	{ linebuf_yuv_val_V_2_we0 sc_out sc_logic 1 signal 26 } 
	{ linebuf_yuv_val_V_2_d0 sc_out sc_lv 10 signal 26 } 
	{ linebuf_yuv_val_V_2_address1 sc_out sc_lv 13 signal 26 } 
	{ linebuf_yuv_val_V_2_ce1 sc_out sc_logic 1 signal 26 } 
	{ linebuf_yuv_val_V_2_q1 sc_in sc_lv 10 signal 26 } 
	{ linebuf_yuv_val_V_1_address0 sc_out sc_lv 13 signal 27 } 
	{ linebuf_yuv_val_V_1_ce0 sc_out sc_logic 1 signal 27 } 
	{ linebuf_yuv_val_V_1_we0 sc_out sc_logic 1 signal 27 } 
	{ linebuf_yuv_val_V_1_d0 sc_out sc_lv 10 signal 27 } 
	{ linebuf_yuv_val_V_1_address1 sc_out sc_lv 13 signal 27 } 
	{ linebuf_yuv_val_V_1_ce1 sc_out sc_logic 1 signal 27 } 
	{ linebuf_yuv_val_V_1_q1 sc_in sc_lv 10 signal 27 } 
	{ linebuf_yuv_val_V_address0 sc_out sc_lv 13 signal 28 } 
	{ linebuf_yuv_val_V_ce0 sc_out sc_logic 1 signal 28 } 
	{ linebuf_yuv_val_V_we0 sc_out sc_logic 1 signal 28 } 
	{ linebuf_yuv_val_V_d0 sc_out sc_lv 10 signal 28 } 
	{ linebuf_yuv_val_V_address1 sc_out sc_lv 13 signal 28 } 
	{ linebuf_yuv_val_V_ce1 sc_out sc_logic 1 signal 28 } 
	{ linebuf_yuv_val_V_q1 sc_in sc_lv 10 signal 28 } 
	{ zext_ln238 sc_in sc_lv 16 signal 29 } 
	{ cmp170 sc_in sc_lv 1 signal 30 } 
	{ cmp84 sc_in sc_lv 1 signal 32 } 
	{ bayerWindow_val_V_39_out sc_out sc_lv 10 signal 34 } 
	{ bayerWindow_val_V_39_out_ap_vld sc_out sc_logic 1 outvld 34 } 
	{ bayerWindow_val_V_38_out sc_out sc_lv 10 signal 35 } 
	{ bayerWindow_val_V_38_out_ap_vld sc_out sc_logic 1 outvld 35 } 
	{ bayerWindow_val_V_37_out sc_out sc_lv 10 signal 36 } 
	{ bayerWindow_val_V_37_out_ap_vld sc_out sc_logic 1 outvld 36 } 
	{ bayerWindow_val_V_36_out sc_out sc_lv 10 signal 37 } 
	{ bayerWindow_val_V_36_out_ap_vld sc_out sc_logic 1 outvld 37 } 
	{ bayerWindow_val_V_35_out sc_out sc_lv 10 signal 38 } 
	{ bayerWindow_val_V_35_out_ap_vld sc_out sc_logic 1 outvld 38 } 
	{ bayerWindow_val_V_34_out sc_out sc_lv 10 signal 39 } 
	{ bayerWindow_val_V_34_out_ap_vld sc_out sc_logic 1 outvld 39 } 
	{ bayerWindow_val_V_33_out sc_out sc_lv 10 signal 40 } 
	{ bayerWindow_val_V_33_out_ap_vld sc_out sc_logic 1 outvld 40 } 
	{ bayerWindow_val_V_32_out sc_out sc_lv 10 signal 41 } 
	{ bayerWindow_val_V_32_out_ap_vld sc_out sc_logic 1 outvld 41 } 
	{ bayerWindow_val_V_31_out sc_out sc_lv 10 signal 42 } 
	{ bayerWindow_val_V_31_out_ap_vld sc_out sc_logic 1 outvld 42 } 
	{ bayerWindow_val_V_30_out sc_out sc_lv 10 signal 43 } 
	{ bayerWindow_val_V_30_out_ap_vld sc_out sc_logic 1 outvld 43 } 
	{ bayerWindow_val_V_29_out sc_out sc_lv 10 signal 44 } 
	{ bayerWindow_val_V_29_out_ap_vld sc_out sc_logic 1 outvld 44 } 
	{ bayerWindow_val_V_28_out sc_out sc_lv 10 signal 45 } 
	{ bayerWindow_val_V_28_out_ap_vld sc_out sc_logic 1 outvld 45 } 
	{ bayerWindow_val_V_27_out sc_out sc_lv 10 signal 46 } 
	{ bayerWindow_val_V_27_out_ap_vld sc_out sc_logic 1 outvld 46 } 
	{ bayerWindow_val_V_26_out sc_out sc_lv 10 signal 47 } 
	{ bayerWindow_val_V_26_out_ap_vld sc_out sc_logic 1 outvld 47 } 
	{ bayerWindow_val_V_25_out sc_out sc_lv 10 signal 48 } 
	{ bayerWindow_val_V_25_out_ap_vld sc_out sc_logic 1 outvld 48 } 
	{ bayerWindow_val_V_24_out sc_out sc_lv 10 signal 49 } 
	{ bayerWindow_val_V_24_out_ap_vld sc_out sc_logic 1 outvld 49 } 
	{ bayerWindow_val_V_23_out sc_out sc_lv 10 signal 50 } 
	{ bayerWindow_val_V_23_out_ap_vld sc_out sc_logic 1 outvld 50 } 
	{ bayerWindow_val_V_22_out sc_out sc_lv 10 signal 51 } 
	{ bayerWindow_val_V_22_out_ap_vld sc_out sc_logic 1 outvld 51 } 
	{ bayerWindow_val_V_21_out sc_out sc_lv 10 signal 52 } 
	{ bayerWindow_val_V_21_out_ap_vld sc_out sc_logic 1 outvld 52 } 
	{ bayerWindow_val_V_20_out sc_out sc_lv 10 signal 53 } 
	{ bayerWindow_val_V_20_out_ap_vld sc_out sc_logic 1 outvld 53 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "imgBayer_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "imgBayer", "role": "dout" }} , 
 	{ "name": "imgBayer_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgBayer", "role": "num_data_valid" }} , 
 	{ "name": "imgBayer_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgBayer", "role": "fifo_cap" }} , 
 	{ "name": "imgBayer_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgBayer", "role": "empty_n" }} , 
 	{ "name": "imgBayer_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgBayer", "role": "read" }} , 
 	{ "name": "imgG_din", "direction": "out", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "imgG", "role": "din" }} , 
 	{ "name": "imgG_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgG", "role": "num_data_valid" }} , 
 	{ "name": "imgG_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "imgG", "role": "fifo_cap" }} , 
 	{ "name": "imgG_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgG", "role": "full_n" }} , 
 	{ "name": "imgG_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "imgG", "role": "write" }} , 
 	{ "name": "bayerWindow_val_V_19", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_19", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_18", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_18", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_17", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_17", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_16", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_16", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_15", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_15", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_14", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_14", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_13", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_13", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_12", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_12", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_11", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_11", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_10", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_10", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_9", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_9", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_8", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_8", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_7", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_7", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_6", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_6", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_5", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_5", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_4", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_4", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_3", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_3", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_2", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_2", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_1", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_1", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V", "role": "default" }} , 
 	{ "name": "add_ln270", "direction": "in", "datatype": "sc_lv", "bitwidth":17, "type": "signal", "bundle":{"name": "add_ln270", "role": "default" }} , 
 	{ "name": "x_phase", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "x_phase", "role": "default" }} , 
 	{ "name": "xor_r", "direction": "in", "datatype": "sc_lv", "bitwidth":15, "type": "signal", "bundle":{"name": "xor_r", "role": "default" }} , 
 	{ "name": "cmp724", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "cmp724", "role": "default" }} , 
 	{ "name": "out_y", "direction": "in", "datatype": "sc_lv", "bitwidth":17, "type": "signal", "bundle":{"name": "out_y", "role": "default" }} , 
 	{ "name": "linebuf_yuv_val_V_3_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_3", "role": "address0" }} , 
 	{ "name": "linebuf_yuv_val_V_3_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_3", "role": "ce0" }} , 
 	{ "name": "linebuf_yuv_val_V_3_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_3", "role": "we0" }} , 
 	{ "name": "linebuf_yuv_val_V_3_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_3", "role": "d0" }} , 
 	{ "name": "linebuf_yuv_val_V_3_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_3", "role": "address1" }} , 
 	{ "name": "linebuf_yuv_val_V_3_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_3", "role": "ce1" }} , 
 	{ "name": "linebuf_yuv_val_V_3_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_3", "role": "q1" }} , 
 	{ "name": "linebuf_yuv_val_V_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_2", "role": "address0" }} , 
 	{ "name": "linebuf_yuv_val_V_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_2", "role": "ce0" }} , 
 	{ "name": "linebuf_yuv_val_V_2_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_2", "role": "we0" }} , 
 	{ "name": "linebuf_yuv_val_V_2_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_2", "role": "d0" }} , 
 	{ "name": "linebuf_yuv_val_V_2_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_2", "role": "address1" }} , 
 	{ "name": "linebuf_yuv_val_V_2_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_2", "role": "ce1" }} , 
 	{ "name": "linebuf_yuv_val_V_2_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_2", "role": "q1" }} , 
 	{ "name": "linebuf_yuv_val_V_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_1", "role": "address0" }} , 
 	{ "name": "linebuf_yuv_val_V_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_1", "role": "ce0" }} , 
 	{ "name": "linebuf_yuv_val_V_1_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_1", "role": "we0" }} , 
 	{ "name": "linebuf_yuv_val_V_1_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_1", "role": "d0" }} , 
 	{ "name": "linebuf_yuv_val_V_1_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_1", "role": "address1" }} , 
 	{ "name": "linebuf_yuv_val_V_1_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_1", "role": "ce1" }} , 
 	{ "name": "linebuf_yuv_val_V_1_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V_1", "role": "q1" }} , 
 	{ "name": "linebuf_yuv_val_V_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V", "role": "address0" }} , 
 	{ "name": "linebuf_yuv_val_V_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V", "role": "ce0" }} , 
 	{ "name": "linebuf_yuv_val_V_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V", "role": "we0" }} , 
 	{ "name": "linebuf_yuv_val_V_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V", "role": "d0" }} , 
 	{ "name": "linebuf_yuv_val_V_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V", "role": "address1" }} , 
 	{ "name": "linebuf_yuv_val_V_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V", "role": "ce1" }} , 
 	{ "name": "linebuf_yuv_val_V_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "linebuf_yuv_val_V", "role": "q1" }} , 
 	{ "name": "zext_ln238", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "zext_ln238", "role": "default" }} , 
 	{ "name": "cmp170", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "cmp170", "role": "default" }} , 
 	{ "name": "cmp84", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "cmp84", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_39_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_39_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_39_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_39_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_38_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_38_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_38_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_38_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_37_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_37_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_37_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_37_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_36_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_36_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_36_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_36_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_35_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_35_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_35_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_35_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_34_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_34_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_34_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_34_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_33_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_33_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_33_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_33_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_32_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_32_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_32_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_32_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_31_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_31_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_31_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_31_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_30_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_30_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_30_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_30_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_29_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_29_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_29_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_29_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_28_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_28_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_28_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_28_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_27_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_27_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_27_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_27_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_26_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_26_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_26_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_26_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_25_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_25_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_25_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_25_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_24_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_24_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_24_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_24_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_23_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_23_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_23_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_23_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_22_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_22_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_22_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_22_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_21_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_21_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_21_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_21_out", "role": "ap_vld" }} , 
 	{ "name": "bayerWindow_val_V_20_out", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "bayerWindow_val_V_20_out", "role": "default" }} , 
 	{ "name": "bayerWindow_val_V_20_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bayerWindow_val_V_20_out", "role": "ap_vld" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
		"CDFG" : "DebayerG_Pipeline_VITIS_LOOP_273_4",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "25", "EstimateLatencyMax" : "65560",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"DependenceCheck" : [
			{"FromInitialState" : "ap_enable_state1_pp0_iter0_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter0", "FromInitialOperation" : "ap_enable_operation_113", "FromInitialSV" : "0", "FromFinalState" : "ap_enable_state2_pp0_iter1_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter1", "FromFinalOperation" : "ap_enable_operation_133", "FromFinalSV" : "1", "FromAddress" : "linebuf_yuv_val_V_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state3_pp0_iter2_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter2", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter3", "ToInitialOperation" : "ap_enable_operation_165", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state3_pp0_iter2_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter2", "ToFinalOperation" : "ap_enable_operation_165", "ToFinalSV" : "2", "ToAddress" : "linebuf_yuv_val_V_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:237:20)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state1_pp0_iter0_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter0", "FromInitialOperation" : "ap_enable_operation_115", "FromInitialSV" : "0", "FromFinalState" : "ap_enable_state2_pp0_iter1_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter1", "FromFinalOperation" : "ap_enable_operation_134", "FromFinalSV" : "1", "FromAddress" : "linebuf_yuv_val_V_1_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state3_pp0_iter2_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter2", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter3", "ToInitialOperation" : "ap_enable_operation_191", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state3_pp0_iter2_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter2", "ToFinalOperation" : "ap_enable_operation_191", "ToFinalSV" : "2", "ToAddress" : "linebuf_yuv_val_V_1_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:237:20)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state1_pp0_iter0_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter0", "FromInitialOperation" : "ap_enable_operation_117", "FromInitialSV" : "0", "FromFinalState" : "ap_enable_state2_pp0_iter1_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter1", "FromFinalOperation" : "ap_enable_operation_135", "FromFinalSV" : "1", "FromAddress" : "linebuf_yuv_val_V_2_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state3_pp0_iter2_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter2", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter3", "ToInitialOperation" : "ap_enable_operation_190", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state3_pp0_iter2_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter2", "ToFinalOperation" : "ap_enable_operation_190", "ToFinalSV" : "2", "ToAddress" : "linebuf_yuv_val_V_2_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:237:20)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state1_pp0_iter0_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter0", "FromInitialOperation" : "ap_enable_operation_119", "FromInitialSV" : "0", "FromFinalState" : "ap_enable_state2_pp0_iter1_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter1", "FromFinalOperation" : "ap_enable_operation_136", "FromFinalSV" : "1", "FromAddress" : "linebuf_yuv_val_V_3_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state3_pp0_iter2_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter2", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter3", "ToInitialOperation" : "ap_enable_operation_189", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state3_pp0_iter2_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter2", "ToFinalOperation" : "ap_enable_operation_189", "ToFinalSV" : "2", "ToAddress" : "linebuf_yuv_val_V_3_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:237:20)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state3_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_165", "FromInitialSV" : "2", "FromFinalState" : "ap_enable_state3_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_165", "FromFinalSV" : "2", "FromAddress" : "linebuf_yuv_val_V_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state1_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter1", "ToInitialOperation" : "ap_enable_operation_113", "ToInitialSV" : "0", "ToFinalState" : "ap_enable_state2_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_133", "ToFinalSV" : "1", "ToAddress" : "linebuf_yuv_val_V_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:237:20)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state1_pp0_iter0_stage0", "ap_enable_state2_pp0_iter1_stage0", "ap_enable_state3_pp0_iter2_stage0"]},
			{"FromInitialState" : "ap_enable_state3_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_189", "FromInitialSV" : "2", "FromFinalState" : "ap_enable_state3_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_189", "FromFinalSV" : "2", "FromAddress" : "linebuf_yuv_val_V_3_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state1_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter1", "ToInitialOperation" : "ap_enable_operation_119", "ToInitialSV" : "0", "ToFinalState" : "ap_enable_state2_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_136", "ToFinalSV" : "1", "ToAddress" : "linebuf_yuv_val_V_3_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:237:20)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state1_pp0_iter0_stage0", "ap_enable_state2_pp0_iter1_stage0", "ap_enable_state3_pp0_iter2_stage0"]},
			{"FromInitialState" : "ap_enable_state3_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_190", "FromInitialSV" : "2", "FromFinalState" : "ap_enable_state3_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_190", "FromFinalSV" : "2", "FromAddress" : "linebuf_yuv_val_V_2_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state1_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter1", "ToInitialOperation" : "ap_enable_operation_117", "ToInitialSV" : "0", "ToFinalState" : "ap_enable_state2_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_135", "ToFinalSV" : "1", "ToAddress" : "linebuf_yuv_val_V_2_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:237:20)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state1_pp0_iter0_stage0", "ap_enable_state2_pp0_iter1_stage0", "ap_enable_state3_pp0_iter2_stage0"]},
			{"FromInitialState" : "ap_enable_state3_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_191", "FromInitialSV" : "2", "FromFinalState" : "ap_enable_state3_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_191", "FromFinalSV" : "2", "FromAddress" : "linebuf_yuv_val_V_1_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state1_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialNextIteration" : "ap_enable_reg_pp0_iter1", "ToInitialOperation" : "ap_enable_operation_115", "ToInitialSV" : "0", "ToFinalState" : "ap_enable_state2_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_134", "ToFinalSV" : "1", "ToAddress" : "linebuf_yuv_val_V_1_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "13", "II" : "1", "Pragma" : "(R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/v_demosaic.cpp:237:20)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state1_pp0_iter0_stage0", "ap_enable_state2_pp0_iter1_stage0", "ap_enable_state3_pp0_iter2_stage0"]}],
		"Port" : [
			{"Name" : "bayerWindow_val_V_19", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_18", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_17", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_16", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_15", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_14", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_13", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_12", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_11", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_10", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_9", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_8", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_7", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_6", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_5", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_4", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_3", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_2", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V_1", "Type" : "None", "Direction" : "I"},
			{"Name" : "bayerWindow_val_V", "Type" : "None", "Direction" : "I"},
			{"Name" : "add_ln270", "Type" : "Stable", "Direction" : "I"},
			{"Name" : "x_phase", "Type" : "None", "Direction" : "I"},
			{"Name" : "xor_r", "Type" : "None", "Direction" : "I"},
			{"Name" : "cmp724", "Type" : "None", "Direction" : "I"},
			{"Name" : "out_y", "Type" : "None", "Direction" : "I"},
			{"Name" : "linebuf_yuv_val_V_3", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "linebuf_yuv_val_V_2", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "linebuf_yuv_val_V_1", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "linebuf_yuv_val_V", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "zext_ln238", "Type" : "Stable", "Direction" : "I"},
			{"Name" : "cmp170", "Type" : "None", "Direction" : "I"},
			{"Name" : "imgBayer", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "imgBayer_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "cmp84", "Type" : "None", "Direction" : "I"},
			{"Name" : "imgG", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "imgG_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "bayerWindow_val_V_39_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_38_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_37_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_36_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_35_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_34_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_33_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_32_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_31_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_30_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_29_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_28_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_27_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_26_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_25_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_24_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_23_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_22_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_21_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "bayerWindow_val_V_20_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "DIV1_TABLE", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "DIV2_TABLE", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_273_4", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter22", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter22", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.DIV1_TABLE_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.DIV2_TABLE_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_18s_9ns_18_4_1_U55", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_18s_8ns_18_4_1_U56", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_18s_8ns_18_4_1_U57", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_18s_9ns_18_4_1_U58", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_14s_10ns_24_4_1_U59", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_14s_10ns_24_4_1_U60", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14s_10ns_24s_25_4_1_U61", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14s_10ns_24s_25_4_1_U62", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	DebayerG_Pipeline_VITIS_LOOP_273_4 {
		bayerWindow_val_V_19 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_18 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_17 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_16 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_15 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_14 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_13 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_12 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_11 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_10 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_9 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_8 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_7 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_6 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_5 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_4 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_3 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_2 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V_1 {Type I LastRead 0 FirstWrite -1}
		bayerWindow_val_V {Type I LastRead 0 FirstWrite -1}
		add_ln270 {Type I LastRead 0 FirstWrite -1}
		x_phase {Type I LastRead 0 FirstWrite -1}
		xor_r {Type I LastRead 0 FirstWrite -1}
		cmp724 {Type I LastRead 0 FirstWrite -1}
		out_y {Type I LastRead 0 FirstWrite -1}
		linebuf_yuv_val_V_3 {Type IO LastRead 0 FirstWrite 2}
		linebuf_yuv_val_V_2 {Type IO LastRead 0 FirstWrite 2}
		linebuf_yuv_val_V_1 {Type IO LastRead 0 FirstWrite 2}
		linebuf_yuv_val_V {Type IO LastRead 0 FirstWrite 2}
		zext_ln238 {Type I LastRead 0 FirstWrite -1}
		cmp170 {Type I LastRead 0 FirstWrite -1}
		imgBayer {Type I LastRead 1 FirstWrite -1}
		cmp84 {Type I LastRead 0 FirstWrite -1}
		imgG {Type O LastRead -1 FirstWrite 22}
		bayerWindow_val_V_39_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_38_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_37_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_36_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_35_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_34_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_33_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_32_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_31_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_30_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_29_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_28_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_27_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_26_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_25_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_24_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_23_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_22_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_21_out {Type O LastRead -1 FirstWrite 21}
		bayerWindow_val_V_20_out {Type O LastRead -1 FirstWrite 21}
		DIV1_TABLE {Type I LastRead -1 FirstWrite -1}
		DIV2_TABLE {Type I LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "25", "Max" : "65560"}
	, {"Name" : "Interval", "Min" : "25", "Max" : "65560"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	bayerWindow_val_V_19 { ap_none {  { bayerWindow_val_V_19 in_data 0 10 } } }
	bayerWindow_val_V_18 { ap_none {  { bayerWindow_val_V_18 in_data 0 10 } } }
	bayerWindow_val_V_17 { ap_none {  { bayerWindow_val_V_17 in_data 0 10 } } }
	bayerWindow_val_V_16 { ap_none {  { bayerWindow_val_V_16 in_data 0 10 } } }
	bayerWindow_val_V_15 { ap_none {  { bayerWindow_val_V_15 in_data 0 10 } } }
	bayerWindow_val_V_14 { ap_none {  { bayerWindow_val_V_14 in_data 0 10 } } }
	bayerWindow_val_V_13 { ap_none {  { bayerWindow_val_V_13 in_data 0 10 } } }
	bayerWindow_val_V_12 { ap_none {  { bayerWindow_val_V_12 in_data 0 10 } } }
	bayerWindow_val_V_11 { ap_none {  { bayerWindow_val_V_11 in_data 0 10 } } }
	bayerWindow_val_V_10 { ap_none {  { bayerWindow_val_V_10 in_data 0 10 } } }
	bayerWindow_val_V_9 { ap_none {  { bayerWindow_val_V_9 in_data 0 10 } } }
	bayerWindow_val_V_8 { ap_none {  { bayerWindow_val_V_8 in_data 0 10 } } }
	bayerWindow_val_V_7 { ap_none {  { bayerWindow_val_V_7 in_data 0 10 } } }
	bayerWindow_val_V_6 { ap_none {  { bayerWindow_val_V_6 in_data 0 10 } } }
	bayerWindow_val_V_5 { ap_none {  { bayerWindow_val_V_5 in_data 0 10 } } }
	bayerWindow_val_V_4 { ap_none {  { bayerWindow_val_V_4 in_data 0 10 } } }
	bayerWindow_val_V_3 { ap_none {  { bayerWindow_val_V_3 in_data 0 10 } } }
	bayerWindow_val_V_2 { ap_none {  { bayerWindow_val_V_2 in_data 0 10 } } }
	bayerWindow_val_V_1 { ap_none {  { bayerWindow_val_V_1 in_data 0 10 } } }
	bayerWindow_val_V { ap_none {  { bayerWindow_val_V in_data 0 10 } } }
	add_ln270 { ap_stable {  { add_ln270 in_data 0 17 } } }
	x_phase { ap_none {  { x_phase in_data 0 1 } } }
	xor_r { ap_none {  { xor_r in_data 0 15 } } }
	cmp724 { ap_none {  { cmp724 in_data 0 1 } } }
	out_y { ap_none {  { out_y in_data 0 17 } } }
	linebuf_yuv_val_V_3 { ap_memory {  { linebuf_yuv_val_V_3_address0 mem_address 1 13 }  { linebuf_yuv_val_V_3_ce0 mem_ce 1 1 }  { linebuf_yuv_val_V_3_we0 mem_we 1 1 }  { linebuf_yuv_val_V_3_d0 mem_din 1 10 }  { linebuf_yuv_val_V_3_address1 MemPortADDR2 1 13 }  { linebuf_yuv_val_V_3_ce1 MemPortCE2 1 1 }  { linebuf_yuv_val_V_3_q1 in_data 0 10 } } }
	linebuf_yuv_val_V_2 { ap_memory {  { linebuf_yuv_val_V_2_address0 mem_address 1 13 }  { linebuf_yuv_val_V_2_ce0 mem_ce 1 1 }  { linebuf_yuv_val_V_2_we0 mem_we 1 1 }  { linebuf_yuv_val_V_2_d0 mem_din 1 10 }  { linebuf_yuv_val_V_2_address1 MemPortADDR2 1 13 }  { linebuf_yuv_val_V_2_ce1 MemPortCE2 1 1 }  { linebuf_yuv_val_V_2_q1 in_data 0 10 } } }
	linebuf_yuv_val_V_1 { ap_memory {  { linebuf_yuv_val_V_1_address0 mem_address 1 13 }  { linebuf_yuv_val_V_1_ce0 mem_ce 1 1 }  { linebuf_yuv_val_V_1_we0 mem_we 1 1 }  { linebuf_yuv_val_V_1_d0 mem_din 1 10 }  { linebuf_yuv_val_V_1_address1 MemPortADDR2 1 13 }  { linebuf_yuv_val_V_1_ce1 MemPortCE2 1 1 }  { linebuf_yuv_val_V_1_q1 in_data 0 10 } } }
	linebuf_yuv_val_V { ap_memory {  { linebuf_yuv_val_V_address0 mem_address 1 13 }  { linebuf_yuv_val_V_ce0 mem_ce 1 1 }  { linebuf_yuv_val_V_we0 mem_we 1 1 }  { linebuf_yuv_val_V_d0 mem_din 1 10 }  { linebuf_yuv_val_V_address1 MemPortADDR2 1 13 }  { linebuf_yuv_val_V_ce1 MemPortCE2 1 1 }  { linebuf_yuv_val_V_q1 in_data 0 10 } } }
	zext_ln238 { ap_stable {  { zext_ln238 in_data 0 16 } } }
	cmp170 { ap_none {  { cmp170 in_data 0 1 } } }
	imgBayer { ap_fifo {  { imgBayer_dout fifo_port_we 0 10 }  { imgBayer_num_data_valid fifo_status_num_data_valid 0 2 }  { imgBayer_fifo_cap fifo_update 0 2 }  { imgBayer_empty_n fifo_status 0 1 }  { imgBayer_read fifo_data 1 1 } } }
	cmp84 { ap_none {  { cmp84 in_data 0 1 } } }
	imgG { ap_fifo {  { imgG_din fifo_port_we 1 30 }  { imgG_num_data_valid fifo_status_num_data_valid 0 2 }  { imgG_fifo_cap fifo_update 0 2 }  { imgG_full_n fifo_status 0 1 }  { imgG_write fifo_data 1 1 } } }
	bayerWindow_val_V_39_out { ap_vld {  { bayerWindow_val_V_39_out out_data 1 10 }  { bayerWindow_val_V_39_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_38_out { ap_vld {  { bayerWindow_val_V_38_out out_data 1 10 }  { bayerWindow_val_V_38_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_37_out { ap_vld {  { bayerWindow_val_V_37_out out_data 1 10 }  { bayerWindow_val_V_37_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_36_out { ap_vld {  { bayerWindow_val_V_36_out out_data 1 10 }  { bayerWindow_val_V_36_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_35_out { ap_vld {  { bayerWindow_val_V_35_out out_data 1 10 }  { bayerWindow_val_V_35_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_34_out { ap_vld {  { bayerWindow_val_V_34_out out_data 1 10 }  { bayerWindow_val_V_34_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_33_out { ap_vld {  { bayerWindow_val_V_33_out out_data 1 10 }  { bayerWindow_val_V_33_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_32_out { ap_vld {  { bayerWindow_val_V_32_out out_data 1 10 }  { bayerWindow_val_V_32_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_31_out { ap_vld {  { bayerWindow_val_V_31_out out_data 1 10 }  { bayerWindow_val_V_31_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_30_out { ap_vld {  { bayerWindow_val_V_30_out out_data 1 10 }  { bayerWindow_val_V_30_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_29_out { ap_vld {  { bayerWindow_val_V_29_out out_data 1 10 }  { bayerWindow_val_V_29_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_28_out { ap_vld {  { bayerWindow_val_V_28_out out_data 1 10 }  { bayerWindow_val_V_28_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_27_out { ap_vld {  { bayerWindow_val_V_27_out out_data 1 10 }  { bayerWindow_val_V_27_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_26_out { ap_vld {  { bayerWindow_val_V_26_out out_data 1 10 }  { bayerWindow_val_V_26_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_25_out { ap_vld {  { bayerWindow_val_V_25_out out_data 1 10 }  { bayerWindow_val_V_25_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_24_out { ap_vld {  { bayerWindow_val_V_24_out out_data 1 10 }  { bayerWindow_val_V_24_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_23_out { ap_vld {  { bayerWindow_val_V_23_out out_data 1 10 }  { bayerWindow_val_V_23_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_22_out { ap_vld {  { bayerWindow_val_V_22_out out_data 1 10 }  { bayerWindow_val_V_22_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_21_out { ap_vld {  { bayerWindow_val_V_21_out out_data 1 10 }  { bayerWindow_val_V_21_out_ap_vld out_vld 1 1 } } }
	bayerWindow_val_V_20_out { ap_vld {  { bayerWindow_val_V_20_out out_data 1 10 }  { bayerWindow_val_V_20_out_ap_vld out_vld 1 1 } } }
}
