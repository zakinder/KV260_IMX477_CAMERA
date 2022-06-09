setlocal
@echo ------------------------Set design paths----------------------------
@set batchfile_name=%~n0
@set batchfile_drive=%~d0
@set batchfile_path=%~dp0
@%batchfile_drive%
@cd %batchfile_path%
@echo -- Run Design with: %batchfile_name%
@echo -- Use Design Path: %batchfile_path%
@echo ---------------------Load basic design settings---------------------
@call design_basic_settings.cmd
@echo --------------------------------------------------------------------
@if not defined VIVADO_AVAILABLE (
  @set VIVADO_AVAILABLE=0
)
@if not defined SDK_AVAILABLE (
  @set SDK_AVAILABLE=0
)
@if not defined LABTOOL_AVAILABLE (
  @set LABTOOL_AVAILABLE=0
)
@if not defined SDSOC_AVAILABLE (
  @set SDSOC_AVAILABLE=0
)
@echo --------------------------------------------------------------------
@if %VIVADO_AVAILABLE%==1 (
  @if not exist %VITIS_XSETTINGS% ( @echo -- Warning: %VITIS_XSETTINGS% not found. Vitis not available, start project with limited functionality --
  ) 
  @goto  RUN
)
@echo -- Error: Need Vivado to run. --
@if not exist %XILDIR% ( @echo -- Error: %XILDIR% not found. Check path of XILDIR variable on design_basic_settings.sh (upper and lower case is important)
) 
@if exist %XILDIR% (
  @if not exist %VIVADO_XSETTINGS% ( @echo -- Error: %VIVADO_XSETTINGS% not found. Check if this file is available on your installation
  ) 
  @if not exist %VITIS_XSETTINGS% ( @echo -- Warning: %VITIS_XSETTINGS% not found. Vitis not available, start project with limited functionality --
  ) 
) 
@if not exist design_basic_settings.cmd ( @echo -- Error: design_basic_settings.cmd not found. Please start _create_win.setup.cmd and follow instructions
) 
@goto  ERROR
:RUN
@if %SDK_AVAILABLE%==0 (
  @echo -- Warning: Vitis not available, start project with limited functionality
)
@echo ----------------------Change to log folder--------------------------
@set vlog_folder=%batchfile_path%v_log
@echo %vlog_folder%
@if not exist %vlog_folder% ( @mkdir %vlog_folder% )   
@cd %vlog_folder%
@echo --------------------------------------------------------------------
@echo -------------------------Start VIVADO scripts -----------------------
call vivado -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --gui 1 
@echo -------------------------scripts finished----------------------------
@echo --------------------------------------------------------------------
@echo --------------------Change to design folder-------------------------
@cd..
@echo ------------------------Design finished-----------------------------
@if not defined DO_NOT_CLOSE_SHELL (
  @set DO_NOT_CLOSE_SHELL=0
)
@if %DO_NOT_CLOSE_SHELL%==1 (
  PAUSE
)
GOTO EOF
:ERROR
@echo ---------------------------Error occurs-----------------------------
@echo --------------------------------------------------------------------
PAUSE
:EOF