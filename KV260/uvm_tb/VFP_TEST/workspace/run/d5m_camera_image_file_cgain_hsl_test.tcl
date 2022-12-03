vlog -f ../../includes/dut_vlg.f

vopt top -o top_optimized +cover=sbfec+top(rtl).
vsim top_optimized -coverage +UVM_TESTNAME=img_cgain_hsl_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value img_cgain_hsl_test
coverage save img_cgain_hsl_test.ucdb
vcover report img_cgain_hsl_test.ucdb -cvg -details
coverage report -html -htmldir ../coverage_reports/questa_html_coverage_reports/img_cgain_hsl_test -source -details -assert -directive -cvg -code bcefst -verbose -threshL 50 -threshH 90
coverage report -file ../coverage_reports/img_cgain_hsl_test.txt -byfile -totals -assert -directive -cvg -codeAll
quit
