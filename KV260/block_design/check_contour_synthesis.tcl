# Run in the project Tcl Console after regenerating the updated block design.
set run [get_runs synth_1]
if {[get_property NEEDS_REFRESH $run] || ![string match "*Complete*" [get_property STATUS $run]]} {
    reset_run $run
    launch_runs $run
    wait_on_run $run
}
if {![string match "*Complete*" [get_property STATUS $run]]} {error "Top-level synthesis did not complete"}
open_run $run
set vclk [get_clocks -quiet clk_out2_kv260_video_clk_wiz_1_0]
if {[llength $vclk] != 1 || abs([get_property PERIOD $vclk]-3.333)>0.01} {error "Expected 300 MHz video clock"}
set regs [get_cells -hier -filter {IS_SEQUENTIAL && NAME =~ */surface_contour/core/*}]
if {![llength $regs]} {error "Synthesized VFP datapath missing. Check IP output products and OOC checkpoints."}
set out [get_property DIRECTORY $run]
set paths [get_timing_paths -from $vclk -to $regs -max_paths 1]
if {![llength $paths]} {error "No constrained video path into the contour filter"}
report_timing -from $vclk -to $regs -max_paths 50 -file [file join $out contour_setup_paths.rpt]
set summary [report_timing_summary -report_unconstrained -max_paths 20 -return_string]
set fd [open [file join $out contour_synth_summary.rpt] w]
puts $fd $summary
close $fd
# Parse the design summary (setup, hold, pulse width) for Vivado 2022.1.
if {![regexp -line {^\s*(-?[0-9]+\.[0-9]+)\s+\S+\s+\d+\s+\d+\s+(-?[0-9]+\.[0-9]+)\s+\S+\s+\d+\s+\d+\s+(-?[0-9]+\.[0-9]+)\s+} $summary -> wns whs wpws]} {error "Inspect contour_synth_summary.rpt: no timing summary row"}
puts "Post-synthesis WNS $wns ns, WHS $whs ns, WPWS $wpws ns. Reports in $out"
if {$wns < 0 || $whs < 0 || $wpws < 0} {error "Post-synthesis timing fails. Review reports before implementation."}
