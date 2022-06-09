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
call C:\Xilinx\Vitis\2022.1\bin\xsct.bat build_vitis.tcl
pause
