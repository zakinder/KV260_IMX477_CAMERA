# Run in Vivado 2022.1 with KV260.xpr open, before running synthesis.
set bd [get_files -quiet */kv260_video.bd]
if {[llength $bd] != 1} {error "Open the KV260 project containing kv260_video.bd first"}
open_bd_design $bd
source [file join [file dirname [info script]] contour_control_clock.tcl]
update_ip_catalog -rebuild
set vfp [get_bd_cells -quiet /PS_VIDEO/RX_VIDEO/vfp_0]
if {![llength $vfp]} {error "No VFP IP found. Check the project's IP repository path."}
upgrade_bd_cells $vfp
validate_bd_design
save_bd_design
generate_target all $bd
