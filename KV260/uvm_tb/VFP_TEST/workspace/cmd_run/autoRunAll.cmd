cd ../../tb
%~d1
setlocal enableextensions disabledelayedexpansion
set "textFile=frame_en_lib0.svh"
@echo FRAME SIZE TESTS
@echo 0- Set Image Size to 64 by 64
@echo 1- Set Image Size to 128 by 128
@echo 2- Set Image Size to 400 by 300
@echo 3- Set Image Size to 1920 by 1080
@set /p frame_size=" FRAME_SIZE: "
@GOTO start_run_from_here
@REM --------------------------------------------
@REM ----------------------- START_RUN_FROM_HERE
@REM --------------------------------------------
@REM :start_run_from_here
@REM @set "replace_to=shtocg"
@REM @set "this_check_rgb_type="
@REM @set "next_check_rgb_type=shtocg"
@REM @GOTO shtocg


:start_run_from_here
@set "replace_to=cgain"
@GOTO cgain

:cgain
@set "this_check_rgb_type=cgain"
@set "next_check_rgb_type=sharp"
@GOTO SEARCH_REPLACE
:sharp
@set "this_check_rgb_type=sharp"
@set "next_check_rgb_type=blur"
@GOTO SEARCH_REPLACE
:blur
@set "this_check_rgb_type=blur"
@set "next_check_rgb_type=hsl"
@GOTO SEARCH_REPLACE
:hsl
@set "this_check_rgb_type=hsl"
@set "next_check_rgb_type=hsv"
@GOTO SEARCH_REPLACE
:hsv
@set "this_check_rgb_type=hsv"
@set "next_check_rgb_type=rgb"
@GOTO SEARCH_REPLACE
:rgb
@set "this_check_rgb_type=rgb"
@set "next_check_rgb_type=sobel"
@GOTO SEARCH_REPLACE
:sobel
@set "this_check_rgb_type=sobel"
@set "next_check_rgb_type=emboss"
@GOTO SEARCH_REPLACE
:emboss
@set "this_check_rgb_type=emboss"
@set "next_check_rgb_type=shtocg"
@GOTO SEARCH_REPLACE

:shtocg
@set "this_check_rgb_type=shtocg"
@set "next_check_rgb_type=cgtosh"
@GOTO SEARCH_REPLACE

:cgtosh
@set "this_check_rgb_type=cgtosh"
@set "next_check_rgb_type=cgtohl"
@GOTO SEARCH_REPLACE

:cgtohl
@set "this_check_rgb_type=cgtohl"
@set "next_check_rgb_type=vsim_run"
@GOTO SEARCH_REPLACE

:SEARCH_REPLACE
@echo off
@set "replace=%replace_to%_v%frame_size%"

@REM @set "replace = %replace_with%"
@set "search0=%this_check_rgb_type%_v0"
@set "search1=%this_check_rgb_type%_v1"
@set "search2=%this_check_rgb_type%_v2"
@set "search3=%this_check_rgb_type%_v3"

for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    >>"%textFile%" echo(!line:%search0%=%replace%!
    endlocal
)

for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    >>"%textFile%" echo(!line:%search1%=%replace%!
    endlocal
)

for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    >>"%textFile%" echo(!line:%search2%=%replace%!
    endlocal
)

for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    >>"%textFile%" echo(!line:%search3%=%replace%!
    endlocal
)

@if "%next_check_rgb_type%"=="cgain" (@GOTO cgain)
@if "%next_check_rgb_type%"=="sharp" (@GOTO sharp)
@if "%next_check_rgb_type%"=="blur" (@GOTO blur)
@if "%next_check_rgb_type%"=="hsl" (@GOTO hsl)
@if "%next_check_rgb_type%"=="hsv" (@GOTO hsv)
@if "%next_check_rgb_type%"=="rgb" (@GOTO rgb)
@if "%next_check_rgb_type%"=="sobel" (@GOTO sobel)
@if "%next_check_rgb_type%"=="emboss" (@GOTO emboss)
@if "%next_check_rgb_type%"=="shtocg" (@GOTO shtocg)
@if "%next_check_rgb_type%"=="cgtosh" (@GOTO cgtosh)
@if "%next_check_rgb_type%"=="cgtohl" (@GOTO cgtohl)
@if "%next_check_rgb_type%"=="vsim_run" (@GOTO vsim_run)
@REM --------------------------------------------
@REM ----------------------- RUN TEST CASE
@REM --------------------------------------------
:vsim_run
@if "%replace_to%"=="cgain" (@GOTO vsim_run_cgain)
@if "%replace_to%"=="sharp" (@GOTO vsim_run_sharp)
@if "%replace_to%"=="blur" (@GOTO vsim_run_blur)
@if "%replace_to%"=="hsl" (@GOTO vsim_run_hsl)
@if "%replace_to%"=="hsv" (@GOTO vsim_run_hsv)
@if "%replace_to%"=="rgb" (@GOTO vsim_run_rgb)
@if "%replace_to%"=="sobel" (@GOTO vsim_run_sobel)
@if "%replace_to%"=="emboss" (@GOTO vsim_run_emboss)
@if "%replace_to%"=="shtocg" (@GOTO vsim_run_sharptocgain)
@if "%replace_to%"=="cgtosh" (@GOTO vsim_run_cgaintosharp)
@if "%replace_to%"=="cgtohl" (@GOTO vsim_run_cgaintohsl)

:vsim_run_cgain
cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_cgain_test.tcl
cd ../../tb
@set "replace_to=sharp"
@GOTO cgain



:vsim_run_sharp

cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_sharp_test.tcl
cd ../../tb
@set "replace_to=blur"
@GOTO cgain

:vsim_run_blur

cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_blur_test.tcl
cd ../../tb
@set "replace_to=hsl"
@GOTO cgain



:vsim_run_hsl

cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_hsl_test.tcl
cd ../../tb
@set "replace_to=hsv"
@GOTO cgain

:vsim_run_hsv

cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_hsv_test.tcl
cd ../../tb
@set "replace_to=rgb"
@GOTO cgain

:vsim_run_rgb

cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_rgb_test.tcl
cd ../../tb
@set "replace_to=sobel"
@GOTO cgain



:vsim_run_sobel

cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_sobel_test.tcl
cd ../../tb
@set "replace_to=emboss"
@GOTO cgain



:vsim_run_emboss

cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_emboss_test.tcl
cd ../../tb
@set "replace_to=shtocg"
@GOTO cgain




:vsim_run_sharptocgain

cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_sharp_cgain_test.tcl
cd ../../tb
@set "replace_to=cgtosh"
@GOTO cgain



:vsim_run_cgaintosharp

cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_cgain_sharp_test.tcl
cd ../../tb
@set "replace_to=cgtohl"
@GOTO cgain


:vsim_run_cgaintohsl

cd ../workspace/run0
@echo current type:  %replace_to%
vsim -c -do d5m_camera_image_file_cgain_hsl_test.tcl
@GOTO wait

:wait

@echo Done

pause
:abort
:eof
@REM @PAUSE
:GO_UP
cd ..\
@GOTO WHAT