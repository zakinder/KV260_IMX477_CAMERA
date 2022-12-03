vlog ../../tb/env/d5m_camera_env/d5m_camera_hsl_frame_128_128_pkg.sv
vlog ../../tb/top/d5m_camera_top/top.sv

vopt +acc top -o top_optimized
vsim top_optimized +UVM_TESTNAME=img_cgain_test
set NoQuitOnFinish 0
set StdArithNoWarnings   1
set NumericStdNoWarnings 1
onbreak {resume}
source wave.do
run -all
quit