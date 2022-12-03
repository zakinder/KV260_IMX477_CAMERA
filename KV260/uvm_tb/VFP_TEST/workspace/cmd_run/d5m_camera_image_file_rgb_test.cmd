cd ../run0
del *.ucdb *.wlf *.log *.htm *.opt *.contrib *.noncontrib *.rank *.vstf
rd work /s /q
rd ..\coverage_reports\questa_html_coverage_reports\d5m_camera_image_file_rgb_test /s /q

vsim  -c -do compile_rtl.tcl
vsim  -c -do d5m_camera_image_file_rgb_test.tcl