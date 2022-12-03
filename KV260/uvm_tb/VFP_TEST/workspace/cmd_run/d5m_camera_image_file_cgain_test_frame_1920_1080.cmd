cd ../run0
del *.ucdb *.wlf *.log *.htm *.opt *.contrib *.noncontrib *.rank *.vstf

vsim  -c -do compile_rtl.tcl
vsim  -c -do d5m_camera_image_file_cgain_test_frame_1920_1080.tcl