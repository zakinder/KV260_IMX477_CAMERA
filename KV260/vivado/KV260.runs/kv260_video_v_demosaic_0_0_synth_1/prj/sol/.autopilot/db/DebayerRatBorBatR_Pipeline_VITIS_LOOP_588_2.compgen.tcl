# This script segment is generated automatically by AutoPilot

set id 130
set name kv260_video_v_demosaic_0_0_mux_32_10_1_1
set corename simcore_mux
set op mux
set stage_num 1
set din0_width 10
set din0_signed 0
set din1_width 10
set din1_signed 0
set din2_width 10
set din2_signed 0
set din3_width 2
set din3_signed 0
set dout_width 10
if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $name BINDTYPE {op} TYPE {mux} IMPL {auto} LATENCY 0 ALLOW_PRAGMA 1
}


set op mux
set corename Multiplexer
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_pipemux] == "::AESL_LIB_VIRTEX::xil_gen_pipemux"} {
eval "::AESL_LIB_VIRTEX::xil_gen_pipemux { \
    id ${id} \
    name ${name} \
    corename ${corename} \
    op ${op} \
    reset_level 1 \
    sync_rst true \
    stage_num ${stage_num} \
    din0_width ${din0_width} \
    din0_signed ${din0_signed} \
    din1_width ${din1_width} \
    din1_signed ${din1_signed} \
    din2_width ${din2_width} \
    din2_signed ${din2_signed} \
    din3_width ${din3_width} \
    din3_signed ${din3_signed} \
    dout_width ${dout_width} \
}"
} else {
puts "@W \[IMPL-101\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_pipemux, check your platform lib"
}
}


# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 155 \
    name lineBuffer_val_V_1_i \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename lineBuffer_val_V_1_i \
    op interface \
    ports { lineBuffer_val_V_1_i_address0 { O 13 vector } lineBuffer_val_V_1_i_ce0 { O 1 bit } lineBuffer_val_V_1_i_we0 { O 1 bit } lineBuffer_val_V_1_i_d0 { O 30 vector } lineBuffer_val_V_1_i_address1 { O 13 vector } lineBuffer_val_V_1_i_ce1 { O 1 bit } lineBuffer_val_V_1_i_q1 { I 30 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'lineBuffer_val_V_1_i'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 156 \
    name lineBuffer_val_V_i \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename lineBuffer_val_V_i \
    op interface \
    ports { lineBuffer_val_V_i_address0 { O 13 vector } lineBuffer_val_V_i_ce0 { O 1 bit } lineBuffer_val_V_i_we0 { O 1 bit } lineBuffer_val_V_i_d0 { O 30 vector } lineBuffer_val_V_i_address1 { O 13 vector } lineBuffer_val_V_i_ce1 { O 1 bit } lineBuffer_val_V_i_q1 { I 30 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'lineBuffer_val_V_i'"
}
}


# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 136 \
    name pixWindow_val_val_V_14_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_14_i \
    op interface \
    ports { pixWindow_val_val_V_14_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 137 \
    name pixWindow_val_val_V_13_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_13_i \
    op interface \
    ports { pixWindow_val_val_V_13_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 138 \
    name pixWindow_val_val_V_12_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_12_i \
    op interface \
    ports { pixWindow_val_val_V_12_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 139 \
    name pixWindow_val_val_V_11_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_11_i \
    op interface \
    ports { pixWindow_val_val_V_11_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 140 \
    name pixWindow_val_val_V_10_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_10_i \
    op interface \
    ports { pixWindow_val_val_V_10_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 141 \
    name pixWindow_val_val_V_9_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_9_i \
    op interface \
    ports { pixWindow_val_val_V_9_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 142 \
    name pixWindow_val_val_V_8_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_8_i \
    op interface \
    ports { pixWindow_val_val_V_8_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 143 \
    name pixWindow_val_val_V_7_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_7_i \
    op interface \
    ports { pixWindow_val_val_V_7_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 144 \
    name pixWindow_val_val_V_6_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_6_i \
    op interface \
    ports { pixWindow_val_val_V_6_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 145 \
    name pixWindow_val_val_V_5_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_5_i \
    op interface \
    ports { pixWindow_val_val_V_5_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 146 \
    name pixWindow_val_val_V_4_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_4_i \
    op interface \
    ports { pixWindow_val_val_V_4_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 147 \
    name pixWindow_val_val_V_3_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_3_i \
    op interface \
    ports { pixWindow_val_val_V_3_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 148 \
    name pixWindow_val_val_V_2_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_2_i \
    op interface \
    ports { pixWindow_val_val_V_2_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 149 \
    name pixWindow_val_val_V_1_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_1_i \
    op interface \
    ports { pixWindow_val_val_V_1_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 150 \
    name pixWindow_val_val_V_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_i \
    op interface \
    ports { pixWindow_val_val_V_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 151 \
    name add_ln585_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_add_ln585_i \
    op interface \
    ports { add_ln585_i { I 13 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 152 \
    name out_y_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_out_y_i \
    op interface \
    ports { out_y_i { I 13 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 153 \
    name x_phase_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_x_phase_i \
    op interface \
    ports { x_phase_i { I 1 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 154 \
    name xor_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xor_i \
    op interface \
    ports { xor_i { I 15 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 157 \
    name trunc_ln \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_trunc_ln \
    op interface \
    ports { trunc_ln { I 13 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 158 \
    name cmp204_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_cmp204_i \
    op interface \
    ports { cmp204_i { I 1 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 159 \
    name cmp60_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_cmp60_i \
    op interface \
    ports { cmp60_i { I 1 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 160 \
    name imgG \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_imgG \
    op interface \
    ports { imgG_dout { I 30 vector } imgG_num_data_valid { I 2 vector } imgG_fifo_cap { I 2 vector } imgG_empty_n { I 1 bit } imgG_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 161 \
    name cond479_cast_cast_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_cond479_cast_cast_i \
    op interface \
    ports { cond479_cast_cast_i { I 2 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 162 \
    name red_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_red_i \
    op interface \
    ports { red_i { I 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 163 \
    name cond_cast_cast_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_cond_cast_cast_i \
    op interface \
    ports { cond_cast_cast_i { I 2 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 164 \
    name imgRB \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_imgRB \
    op interface \
    ports { imgRB_din { O 30 vector } imgRB_num_data_valid { I 2 vector } imgRB_fifo_cap { I 2 vector } imgRB_full_n { I 1 bit } imgRB_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 165 \
    name pixWindow_val_val_V_29_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_29_i_out \
    op interface \
    ports { pixWindow_val_val_V_29_i_out { O 10 vector } pixWindow_val_val_V_29_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 166 \
    name pixWindow_val_val_V_28_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_28_i_out \
    op interface \
    ports { pixWindow_val_val_V_28_i_out { O 10 vector } pixWindow_val_val_V_28_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 167 \
    name pixWindow_val_val_V_27_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_27_i_out \
    op interface \
    ports { pixWindow_val_val_V_27_i_out { O 10 vector } pixWindow_val_val_V_27_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 168 \
    name pixWindow_val_val_V_26_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_26_i_out \
    op interface \
    ports { pixWindow_val_val_V_26_i_out { O 10 vector } pixWindow_val_val_V_26_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 169 \
    name pixWindow_val_val_V_25_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_25_i_out \
    op interface \
    ports { pixWindow_val_val_V_25_i_out { O 10 vector } pixWindow_val_val_V_25_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 170 \
    name pixWindow_val_val_V_24_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_24_i_out \
    op interface \
    ports { pixWindow_val_val_V_24_i_out { O 10 vector } pixWindow_val_val_V_24_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 171 \
    name pixWindow_val_val_V_23_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_23_i_out \
    op interface \
    ports { pixWindow_val_val_V_23_i_out { O 10 vector } pixWindow_val_val_V_23_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 172 \
    name pixWindow_val_val_V_22_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_22_i_out \
    op interface \
    ports { pixWindow_val_val_V_22_i_out { O 10 vector } pixWindow_val_val_V_22_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 173 \
    name pixWindow_val_val_V_21_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_21_i_out \
    op interface \
    ports { pixWindow_val_val_V_21_i_out { O 10 vector } pixWindow_val_val_V_21_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 174 \
    name pixWindow_val_val_V_20_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_20_i_out \
    op interface \
    ports { pixWindow_val_val_V_20_i_out { O 10 vector } pixWindow_val_val_V_20_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 175 \
    name pixWindow_val_val_V_19_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_19_i_out \
    op interface \
    ports { pixWindow_val_val_V_19_i_out { O 10 vector } pixWindow_val_val_V_19_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 176 \
    name pixWindow_val_val_V_18_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_18_i_out \
    op interface \
    ports { pixWindow_val_val_V_18_i_out { O 10 vector } pixWindow_val_val_V_18_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 177 \
    name pixWindow_val_val_V_17_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_17_i_out \
    op interface \
    ports { pixWindow_val_val_V_17_i_out { O 10 vector } pixWindow_val_val_V_17_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 178 \
    name pixWindow_val_val_V_16_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_16_i_out \
    op interface \
    ports { pixWindow_val_val_V_16_i_out { O 10 vector } pixWindow_val_val_V_16_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 179 \
    name pixWindow_val_val_V_15_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_15_i_out \
    op interface \
    ports { pixWindow_val_val_V_15_i_out { O 10 vector } pixWindow_val_val_V_15_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id -1 \
    name ap_ctrl \
    type ap_ctrl \
    reset_level 1 \
    sync_rst true \
    corename ap_ctrl \
    op interface \
    ports { ap_start { I 1 bit } ap_ready { O 1 bit } ap_done { O 1 bit } ap_idle { O 1 bit } } \
} "
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -2 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_clk \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-113\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}


# Adapter definition:
set PortName ap_rst
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_reset] == "cg_default_interface_gen_reset"} {
eval "cg_default_interface_gen_reset { \
    id -3 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_rst \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-114\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}



# merge
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_end
    cg_default_interface_gen_bundle_end
    AESL_LIB_XILADAPTER::native_axis_end
}


# flow_control definition:
set InstName kv260_video_v_demosaic_0_0_flow_control_loop_pipe_sequential_init_U
set CompName kv260_video_v_demosaic_0_0_flow_control_loop_pipe_sequential_init
set name flow_control_loop_pipe_sequential_init
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control] == "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control"} {
eval "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control { \
    name ${name} \
    prefix kv260_video_v_demosaic_0_0_ \
}"
} else {
puts "@W \[IMPL-107\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control, check your platform lib"
}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $CompName BINDTYPE interface TYPE internal_upc_flow_control INSTNAME $InstName
}


