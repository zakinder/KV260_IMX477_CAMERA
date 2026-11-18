# This script segment is generated automatically by AutoPilot

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
    id 203 \
    name lineBuffer_val_V_2_i \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename lineBuffer_val_V_2_i \
    op interface \
    ports { lineBuffer_val_V_2_i_address0 { O 12 vector } lineBuffer_val_V_2_i_ce0 { O 1 bit } lineBuffer_val_V_2_i_we0 { O 1 bit } lineBuffer_val_V_2_i_d0 { O 30 vector } lineBuffer_val_V_2_i_address1 { O 12 vector } lineBuffer_val_V_2_i_ce1 { O 1 bit } lineBuffer_val_V_2_i_q1 { I 30 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'lineBuffer_val_V_2_i'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 204 \
    name lineBuffer_val_V_i \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename lineBuffer_val_V_i \
    op interface \
    ports { lineBuffer_val_V_i_address0 { O 12 vector } lineBuffer_val_V_i_ce0 { O 1 bit } lineBuffer_val_V_i_we0 { O 1 bit } lineBuffer_val_V_i_d0 { O 30 vector } lineBuffer_val_V_i_address1 { O 12 vector } lineBuffer_val_V_i_ce1 { O 1 bit } lineBuffer_val_V_i_q1 { I 30 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'lineBuffer_val_V_i'"
}
}


# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 187 \
    name pixWindow_val_val_V_70_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_70_i \
    op interface \
    ports { pixWindow_val_val_V_70_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 188 \
    name pixWindow_val_val_V_69_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_69_i \
    op interface \
    ports { pixWindow_val_val_V_69_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 189 \
    name pixWindow_val_val_V_68_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_68_i \
    op interface \
    ports { pixWindow_val_val_V_68_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 190 \
    name pixWindow_val_val_V_67_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_67_i \
    op interface \
    ports { pixWindow_val_val_V_67_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 191 \
    name pixWindow_val_val_V_66_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_66_i \
    op interface \
    ports { pixWindow_val_val_V_66_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 192 \
    name pixWindow_val_val_V_65_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_65_i \
    op interface \
    ports { pixWindow_val_val_V_65_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 193 \
    name pixWindow_val_val_V_64_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_64_i \
    op interface \
    ports { pixWindow_val_val_V_64_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 194 \
    name pixWindow_val_val_V_63_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_63_i \
    op interface \
    ports { pixWindow_val_val_V_63_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 195 \
    name pixWindow_val_val_V_62_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_62_i \
    op interface \
    ports { pixWindow_val_val_V_62_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 196 \
    name pixWindow_val_val_V_61_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_61_i \
    op interface \
    ports { pixWindow_val_val_V_61_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 197 \
    name pixWindow_val_val_V_60_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_60_i \
    op interface \
    ports { pixWindow_val_val_V_60_i { I 10 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 198 \
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
    id 199 \
    name add_ln833_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_add_ln833_i \
    op interface \
    ports { add_ln833_i { I 12 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 200 \
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
    id 201 \
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
    id 202 \
    name out_y_i \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_out_y_i \
    op interface \
    ports { out_y_i { I 12 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 205 \
    name trunc_ln \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_trunc_ln \
    op interface \
    ports { trunc_ln { I 12 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 206 \
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
    id 207 \
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
    id 208 \
    name imgRB \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_imgRB \
    op interface \
    ports { imgRB_dout { I 30 vector } imgRB_num_data_valid { I 2 vector } imgRB_fifo_cap { I 2 vector } imgRB_empty_n { I 1 bit } imgRB_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 209 \
    name imgRgb \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_imgRgb \
    op interface \
    ports { imgRgb_din { O 30 vector } imgRgb_num_data_valid { I 2 vector } imgRgb_fifo_cap { I 2 vector } imgRgb_full_n { I 1 bit } imgRgb_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 210 \
    name pixWindow_val_val_V_82_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_82_i_out \
    op interface \
    ports { pixWindow_val_val_V_82_i_out { O 10 vector } pixWindow_val_val_V_82_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 211 \
    name pixWindow_val_val_V_81_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_81_i_out \
    op interface \
    ports { pixWindow_val_val_V_81_i_out { O 10 vector } pixWindow_val_val_V_81_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 212 \
    name pixWindow_val_val_V_80_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_80_i_out \
    op interface \
    ports { pixWindow_val_val_V_80_i_out { O 10 vector } pixWindow_val_val_V_80_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 213 \
    name pixWindow_val_val_V_79_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_79_i_out \
    op interface \
    ports { pixWindow_val_val_V_79_i_out { O 10 vector } pixWindow_val_val_V_79_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 214 \
    name pixWindow_val_val_V_78_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_78_i_out \
    op interface \
    ports { pixWindow_val_val_V_78_i_out { O 10 vector } pixWindow_val_val_V_78_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 215 \
    name pixWindow_val_val_V_77_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_77_i_out \
    op interface \
    ports { pixWindow_val_val_V_77_i_out { O 10 vector } pixWindow_val_val_V_77_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 216 \
    name pixWindow_val_val_V_76_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_76_i_out \
    op interface \
    ports { pixWindow_val_val_V_76_i_out { O 10 vector } pixWindow_val_val_V_76_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 217 \
    name pixWindow_val_val_V_75_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_75_i_out \
    op interface \
    ports { pixWindow_val_val_V_75_i_out { O 10 vector } pixWindow_val_val_V_75_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 218 \
    name pixWindow_val_val_V_74_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_74_i_out \
    op interface \
    ports { pixWindow_val_val_V_74_i_out { O 10 vector } pixWindow_val_val_V_74_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 219 \
    name pixWindow_val_val_V_73_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_73_i_out \
    op interface \
    ports { pixWindow_val_val_V_73_i_out { O 10 vector } pixWindow_val_val_V_73_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 220 \
    name pixWindow_val_val_V_72_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_72_i_out \
    op interface \
    ports { pixWindow_val_val_V_72_i_out { O 10 vector } pixWindow_val_val_V_72_i_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 221 \
    name pixWindow_val_val_V_71_i_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_pixWindow_val_val_V_71_i_out \
    op interface \
    ports { pixWindow_val_val_V_71_i_out { O 10 vector } pixWindow_val_val_V_71_i_out_ap_vld { O 1 bit } } \
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
set InstName kv260_video_v_demosaic_1_0_flow_control_loop_pipe_sequential_init_U
set CompName kv260_video_v_demosaic_1_0_flow_control_loop_pipe_sequential_init
set name flow_control_loop_pipe_sequential_init
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control] == "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control"} {
eval "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control { \
    name ${name} \
    prefix kv260_video_v_demosaic_1_0_ \
}"
} else {
puts "@W \[IMPL-107\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control, check your platform lib"
}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $CompName BINDTYPE interface TYPE internal_upc_flow_control INSTNAME $InstName
}


