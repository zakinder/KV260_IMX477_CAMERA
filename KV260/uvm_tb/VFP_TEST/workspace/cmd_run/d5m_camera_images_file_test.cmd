cd ../run0
@REM ====================================================================================
@REM ------------------------------------------------------------------------------------
@REM --------------------------------- RUN CMD
@REM ------------------------------------------------------------------------------------
@REM ====================================================================================
%~d1
@echo off
del *.ucdb *.wlf *.log *.htm *.opt *.contrib *.noncontrib *.rank *.vstf
rd work /s /q
@REM rd ..\coverage_reports\questa_html_coverage_reports\template_test /s /q
@REM rd ..\coverage_reports\questa_html_coverage_reports\axi_lite_test /s /q
@REM rd ..\coverage_reports\questa_html_coverage_reports\rgb_test /s /q
@REM rd ..\coverage_reports\questa_html_coverage_reports\axi4_stream_test /s /q
@REM rd ..\coverage_reports\questa_html_coverage_reports\SystemCoverage /s /q

            
:WHAT
@echo ------------------
@echo 1-cgain
@echo 2-sharp
@echo 3-blur
@echo 4-hsl
@echo 5-hsv
@echo 6-rgb
@echo 7-sobel
@echo 8-embos
@echo 9-rgbCorrect
@echo 10-rgbRemix
@echo 11-rgbDetect
@echo 12-rgbPoi
@echo 13-ycbcr


@echo ------------------
@set /p Select=" CMD "
@if "%Select%"=="1" (@GOTO cgain)
@if "%Select%"=="2" (@GOTO sharp)
@if "%Select%"=="3" (@GOTO blur)
@if "%Select%"=="4" (@GOTO hsl)
@if "%Select%"=="5" (@GOTO hsv)
@if "%Select%"=="6" (@GOTO rgb)
@if "%Select%"=="7" (@GOTO sobel)
@if "%Select%"=="8" (@GOTO embos)
@if "%Select%"=="9" (@GOTO rgbCorrect)
@if "%Select%"=="10" (@GOTO rgbRemix)
@if "%Select%"=="11" (@GOTO rgbDetect)
@if "%Select%"=="12" (@GOTO rgbPoi)
@if "%Select%"=="13" (@GOTO ycbcr)
@GOTO WHAT




:cgain
vsim -c -do d5m_camera_image_file_cgain_test.tcl
@GOTO WHAT

:sharp
vsim -c -do d5m_camera_image_file_sharp_test.tcl
@GOTO WHAT

:blur
vsim -c -do d5m_camera_image_file_blur_test.tcl
@GOTO WHAT

:hsl
vsim -c -do d5m_camera_image_file_hsl_test.tcl
@GOTO WHAT

:hsv
vsim -c -do d5m_camera_image_file_hsv_test.tcl
@GOTO WHAT

:rgb
vsim -c -do d5m_camera_image_file_rgb_test.tcl
@GOTO WHAT

:sobel
vsim -c -do d5m_camera_image_file_sobel_test.tcl
@GOTO WHAT

:embos
vsim -c -do d5m_camera_image_file_emboss_test.tcl
@GOTO WHAT

:rgbCorrect
vsim -c -do d5m_camera_image_file_test.tcl
@GOTO WHAT

:rgbRemix
vsim -c -do d5m_camera_image_file_test.tcl
@GOTO WHAT

:rgbDetect
vsim -c -do d5m_camera_image_file_test.tcl
@GOTO WHAT

:rgbPoi
vsim -c -do d5m_camera_image_file_test.tcl
@GOTO WHAT

:ycbcr
vsim -c -do d5m_camera_image_file_test.tcl
@GOTO WHAT


:ABORT

:EOF
@REM @PAUSE

:GO_UP
cd ..\
@GOTO WHAT