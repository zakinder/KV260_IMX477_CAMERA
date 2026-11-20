@set XILDIR=C:/Xilinx
@set VIVADO_VERSION=2022.1
@set PARTNUMBER=1
@set SWAPP=NA
@set PROGRAM_ROOT_FOLDER_FILE=0
@set USE_XILINX_BOARD_STORE=0
@set DO_NOT_CLOSE_SHELL=0
@set ZIP_PATH=C:/Program Files/7-Zip/7z.exe
@set ENABLE_SDSOC=0
@set XILINXGIT_DEVICETREE=B:/xilinx_git/device-tree-xlnx
@echo -----------------------------------------
@set XIL_VIV_EXIST=0
@if exist %XILDIR%\Vivado\%VIVADO_VERSION%\ (
  @set XIL_VIV_EXIST=1
)
@set XIL_VIT_EXIST=0
@if exist %XILDIR%\Vitis\%VIVADO_VERSION%\ (
  @set XIL_VIT_EXIST=1
)
@set XIL_VLAB_EXIST=0
@if exist %XILDIR%\Vivado_Lab\%VIVADO_VERSION%\ (
  @set XIL_VLAB_EXIST=1
)
@echo --------------------------------------------------------------------
@echo ------------------Set Xilinx environment variables------------------
@set VIVADO_XSETTINGS=%XILDIR%\Vivado\%VIVADO_VERSION%\settings64.bat
@set VITIS_XSETTINGS=%XILDIR%\Vitis\%VIVADO_VERSION%\settings64.bat
@set LABTOOL_XSETTINGS=%XILDIR%\Vivado_Lab\%VIVADO_VERSION%\settings64.bat
@if not defined VIVADO_AVAILABLE (
  @set VIVADO_AVAILABLE=0
)
@if not defined SDK_AVAILABLE (
  @set SDK_AVAILABLE=0
)
@if not defined LABTOOL_AVAILABLE (
  @set LABTOOL_AVAILABLE=0
)
@if not defined VIVADO_XSETTINGS_ISDONE ( 
  @if exist %VIVADO_XSETTINGS% (
    @echo --Info: Configure Xilinx Vivado Settings --
    @echo --Excecute: %VIVADO_XSETTINGS% --
    @call %VIVADO_XSETTINGS%
    @set VIVADO_AVAILABLE=1
  )
  @set VIVADO_XSETTINGS_ISDONE=1
)
@if not defined VITIS_XSETTINGS_ISDONE (
  @if exist %VITIS_XSETTINGS% (
    @echo --Info: Configure Xilinx VITIS Settings --
    @echo --Excecute: %VITIS_XSETTINGS% --
    @call %VITIS_XSETTINGS%
    @set SDK_AVAILABLE=1
  )
  @set VITIS_XSETTINGS_ISDONE=1
)
@if not defined LABTOOL_XSETTINGS_ISDONE (
  @if exist %LABTOOL_XSETTINGS% ( 
    @echo --Info: Configure Xilinx Vivado LabTools Settings --
    @echo --Excecute: %LABTOOL_XSETTINGS% --
    @call %LABTOOL_XSETTINGS%
    @set LABTOOL_AVAILABLE=1
  )
  @set LABTOOL_XSETTINGS_ISDONE=1
)