# Run in Vivado 2022.1 with KV260.xpr open, before rebuilding the baseline.
set bd [get_files -quiet */kv260_video.bd]
if {[llength $bd] != 1} {error "Open the KV260 project containing kv260_video.bd first"}
open_bd_design $bd
proc timing_move_sink {source sink} {
    set src [get_bd_pins $source]
    set dst [get_bd_pins $sink]
    set new [get_bd_nets -of_objects $src]
    set old [get_bd_nets -quiet -of_objects $dst]
    if {[llength $old] && $old eq $new} {return}
    if {[llength $old]} {disconnect_bd_net $old $dst}
    connect_bd_net $src $dst
}
set previous [current_bd_instance .]
current_bd_instance [get_bd_cells /PS_VIDEO/TO_PS]
if {![llength [get_bd_cells -quiet rst_clk_wiz_ctrl]]} {
    create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_ctrl
}
set_property CONFIG.C_EXT_RESET_HIGH 0 [get_bd_cells rst_clk_wiz_ctrl]
foreach sink {rst_clk_wiz_ctrl/slowest_sync_clk ps8_0_axi_periph/M09_ACLK clk_wiz_0/s_axi_aclk clk_wiz_ila/clk} {
    timing_move_sink zynq_ultra_ps_e_0/pl_clk0 $sink
}
timing_move_sink zynq_ultra_ps_e_0/pl_resetn0 rst_clk_wiz_ctrl/ext_reset_in
foreach sink {ps8_0_axi_periph/M09_ARESETN clk_wiz_0/s_axi_aresetn} {
    timing_move_sink rst_clk_wiz_ctrl/peripheral_aresetn $sink
}
current_bd_instance $previous
update_ip_catalog -rebuild
set vfp [get_bd_cells -quiet /PS_VIDEO/RX_VIDEO/vfp_0]
if {![llength $vfp]} {error "No VFP IP found. Check the project's IP repository path."}
upgrade_bd_cells $vfp
validate_bd_design
save_bd_design
generate_target all $bd
