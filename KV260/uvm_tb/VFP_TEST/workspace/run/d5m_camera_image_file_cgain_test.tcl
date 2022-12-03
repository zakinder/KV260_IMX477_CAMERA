vlog ../../tb/frame_parameters/hsl_frame_64.sv
vlog ../../tb/env/d5m_camera_env/d5m_camera_cgain_pkg.sv
vlog ../../tb/top/d5m_camera_top/top.sv

vopt top -o top_optimized
vsim top_optimized +UVM_TESTNAME=img_cgain_test
set NoQuitOnFinish 1
set StdArithNoWarnings   1
set NumericStdNoWarnings 1
onbreak {resume}
source wave.do
source wave1.do
run -all
