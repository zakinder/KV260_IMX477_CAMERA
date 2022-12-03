
vlog -f ../../includes/dut_vlg.f

vopt top -o top_optimized  +acc +cover=sbfec+top(rtl).
vsim top_optimized -coverage +UVM_TESTNAME=img_hsl_test
set NoQuitOnFinish 1
set StdArithNoWarnings   1
set NumericStdNoWarnings 1
onbreak {resume}
source wave.do
run -all






