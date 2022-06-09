setlocal
REM PROJECT DIRECTORY
@set batchfile_name=%~n0
@set batchfile_drive=%~d0
@set batchfile_path=%~dp0
@%batchfile_drive%
@cd %batchfile_path%
@echo -- RUN DESIGN WITH: %batchfile_name%
@echo -- USE DESIGN PATH: %batchfile_path%
@call %mylocalpath%S_SET.cmd
@echo -- SET XILINX ENVIRONMENT VARIABLES
@set VIVADO_XSETTINGS=%XILDIR%\Vivado\%VIVADO_VERSION%\settings64.bat
@set SDK_XSETTINGS=%XILDIR%\SDK\%VIVADO_VERSION%\settings64.bat
@set LABTOOL_XSETTINGS=%XILDIR%\Vivado_Lab\%VIVADO_VERSION%\settings64.bat
REM ENABLE SDSOC
@if not defined ENABLE_SDSOC (
  @set ENABLE_SDSOC=0
)
@if %ENABLE_SDSOC%==1 (
@echo -- INFO: SDSOC SETTINGS ARE DISABLED FOR THIS CMD FILE
)
REM VIVADO AVAILABLE
@if not defined VIVADO_AVAILABLE (
  @set VIVADO_AVAILABLE=0
)
REM SDK AVAILABLE
@if not defined SDK_AVAILABLE (
  @set SDK_AVAILABLE=0
)
REM LABTOOL AVAILABLE
@if not defined LABTOOL_AVAILABLE (
  @set LABTOOL_AVAILABLE=0
)
REM SDSOC AVAILABLE
@if not defined SDSOC_AVAILABLE (
  @set SDSOC_AVAILABLE=0
)
REM XILINX VERSION PRINT
@echo -- USE XILINX VERSION: %VIVADO_VERSION% --
@if not defined VIVADO_XSETTINGS_ISDONE ( @echo --Info: Configure Xilinx Vivado Settings --
  @if not exist %VIVADO_XSETTINGS% ( @echo -- Info: %VIVADO_XSETTINGS% not found --
  ) else (
    @call %VIVADO_XSETTINGS%
    @set VIVADO_AVAILABLE=1
  )
  @set VIVADO_XSETTINGS_ISDONE=1
)
REM SDK SETTINGS IS DONE
@if not defined SDK_XSETTINGS_ISDONE ( @echo --Info: Configure Xilinx SDK Settings --
  @if not exist %SDK_XSETTINGS% ( @echo -- Info: %SDK_XSETTINGS% not found --
  ) else (
    @call %SDK_XSETTINGS%
    @set SDK_AVAILABLE=1
  )
  @set SDK_XSETTINGS_ISDONE=1
)
REM LABTOOL SETTINGS_IS DONE
@if not defined LABTOOL_XSETTINGS_ISDONE ( @echo --Info: Configure Xilinx LabTools Settings --
  @if not exist %LABTOOL_XSETTINGS% ( @echo -- Info: %LABTOOL_XSETTINGS% not found --
  ) else (
    @call %LABTOOL_XSETTINGS%
    @set LABTOOL_AVAILABLE=1
  )
  @set LABTOOL_XSETTINGS_ISDONE=1
)
REM SDSOC SETTINGS IS DONE
@if not defined SDSOC_XSETTINGS_ISDONE ( @echo --Info: Configure Xilinx SDSoC Settings --
  @if not exist %SDSOC_XSETTINGS% ( @echo -- Info: %SDSOC_XSETTINGS% not found --
  ) else (
    @call %SDSOC_XSETTINGS%
    @set SDSOC_AVAILABLE=1
  )
  @set SDSOC_XSETTINGS_ISDONE=1
)
REM VIVADO_AVAILABLE
@if %VIVADO_AVAILABLE%==1 (
  @goto  RUN
)
REM LABTOOL_AVAILABLE
@if %LABTOOL_AVAILABLE%==1 (
  @goto  RUN
)
@goto  ERROR
REM RUN
:RUN
@echo ----check old project exists----
@echo Delete project will delete all generated files like vivado, labtools, vitis,... folders!
set  creatProject=Y
@echo User Input: "%creatProject%"
if "%creatProject%"=="n" (GOTO EOF)
@echo Start clear project..."

@set vlog_folder=%batchfile_path%v_log
@set vlog_folderv=%batchfile_path%vivado

@set bkworkspace_folder=%batchfile_path%backup_workspace
@set auto_create_vitis_folder=%batchfile_path%backup_workspace\auto_create_vitis

@set workspace_folder=%batchfile_path%vitis
REM REMOVE LOG FOLDER
@echo REMOVE BKWORKSPACE_FOLDER FOLDER


@echo %bkworkspace_folder%
@if not exist %bkworkspace_folder% ( @mkdir %bkworkspace_folder% )   
@cd %bkworkspace_folder%

@echo %auto_create_vitis_folder%
@if not exist %auto_create_vitis_folder% ( @mkdir %auto_create_vitis_folder% )   
@cd %auto_create_vitis_folder%

@if exist %workspace_folder% ( @echo -- REMOVE OLD VLOG FILES AND FOLDER --
xcopy "%batchfile_path%\vitis\auto_create_vitis\*.*" "%batchfile_path%\backup_workspace\auto_create_vitis\" >nul /E /K /D /H /Y
xcopy "%batchfile_path%\vitis\kv260_video_wrapper.xsa" "%batchfile_path%\backup_workspace\" >nul /S /Y
)






@echo %vlog_folder%
@if not exist %vlog_folder% ( @mkdir %vlog_folder% )   
@cd %vlog_folder%

@echo %vlog_folderv%
@if not exist %vlog_folderv% ( @mkdir %vlog_folderv% )   
@cd %vlog_folderv%





@if %VIVADO_AVAILABLE%==1 (
  call vivado -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --clear_all
) else (
  call vivado_lab -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --clear_all --labtools
)

@cd..

@del "%batchfile_path%\vitis\*.log" /s /q
@rd "%batchfile_path%\vitis\kv260_video_wrapper"\ /s /q
@rd "%batchfile_path%\vitis\.metadata" /s /q
@rd "%batchfile_path%\vitis\.Xil" /s /q
@rd "%batchfile_path%\vitis\mipi_system" /s /q
@del "%batchfile_path%\vitis\.analytics" /s /q




REM REMOVE LOG FOLDER
@echo REMOVE LOG FOLDER
@if exist %vlog_folder% ( @echo -- REMOVE OLD VLOG FILES AND FOLDER --
@rd %vlog_folder% /s /q )

REM REMOVE VIVADO FOLDER
@echo REMOVE VIVADO FOLDER
@if exist %vlog_folderv% ( @echo -- REMOVE OLD VLOG FILES AND FOLDER --
@rd %vlog_folderv% /s /q )  

REM REMOVE VIVADO FOLDER
REM @echo REMOVE VIVADO FOLDER
REM @if exist %workspace_folder% ( @echo -- REMOVE OLD VLOG FILES AND FOLDER --
REM @rd %workspace_folder% /s /q )  

REM DESIGN FINISHED
@if not defined DO_NOT_CLOSE_SHELL (
  @set DO_NOT_CLOSE_SHELL=0
)
@if %DO_NOT_CLOSE_SHELL%==1 (
  PAUSE
)


GOTO EOF
REM ERROR
:ERROR
