@echo -- UPDATING BKWORKSPACE
@ECHO OFF
@set batchfile_path=%~dp0
@set bkworkspace_folder=%batchfile_path%backup_workspace
@set auto_create_vitis_folder=%batchfile_path%backup_workspace\auto_create_vitis

@echo %bkworkspace_folder%
@if not exist %bkworkspace_folder% ( @mkdir %bkworkspace_folder% )   
@cd %bkworkspace_folder%

@echo %auto_create_vitis_folder%
@if not exist %auto_create_vitis_folder% ( @mkdir %auto_create_vitis_folder% )   
@cd %auto_create_vitis_folder%
xcopy "%batchfile_path%\vitis\auto_create_vitis\*.*" "%batchfile_path%\backup_workspace\auto_create_vitis\" >nul /E /K /D /H /Y
xcopy "%batchfile_path%\vitis\kv260_video_wrapper.xsa" "%batchfile_path%\backup_workspace\" >nul /S /Y
