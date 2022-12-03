vlog ../../tb/env/d5m_camera_env/d5m_camera_hsl_frame_1920_1080_pkg.sv
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
coverage attribute -name TESTNAME -value img_cgain_test
coverage save img_cgain_test.ucdb
vcover report img_cgain_test.ucdb -cvg -details
coverage report -html -htmldir ../coverage_reports/questa_html_coverage_reports/img_cgain_test -source -details -assert -directive -cvg -code bcefst -verbose -threshL 50 -threshH 90
coverage report -file ../coverage_reports/img_cgain_test.txt -byfile -totals -assert -directive -cvg -codeAll
quit