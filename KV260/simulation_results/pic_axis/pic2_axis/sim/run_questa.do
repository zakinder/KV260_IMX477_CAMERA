# From the extracted project in Windows CMD: vsim -c -do sim/run_questa.do
onerror {quit -code 1}
if {![file exists sim/sources.txt]} {
    set root [file normalize [file join [file dirname [info script]] ..]]
    cd $root
}
if {![file exists sim/sources.txt]} {
    echo "Start Questa from the extracted pic2_axis folder."
    quit -code 1
}
file mkdir build results
set lib [file normalize build/questa]
if {![file isdirectory $lib]} {vlib $lib}
vmap work $lib
set fd [open sim/sources.txt r]
set sources [split [string trim [read $fd]] "\n"]
close $fd
foreach src $sources {
    vcom -2008 -work work [string trim $src]
}
# Standard PIC1 defaults: 2048 x 1152. The VHDL reader opens images/PIC1.JPG.
vsim -onfinish stop -voptargs=+acc -gG_STALLS=true work.tb_pic2
set BreakOnAssertion 2
run -all
if {[string trim [examine -radix binary sim:/tb_pic2/test_passed] "'"] ne "1"} {
    echo "FAIL: testbench did not complete"
    quit -code 1
}
echo "PASS: results/PIC1_filtered.bmp"
quit -code 0
