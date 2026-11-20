setlocal
@set batchfile_name=%~n0
@set batchfile_drive=%~d0
@set batchfile_path=%~dp0
@%batchfile_drive%
@cd %batchfile_path%
@echo -- Run : %batchfile_name%
@echo -- Current Design Path: %batchfile_path%
@set  driverletter= R
@subst %driverletter%: %batchfile_path%..
@echo --Start scripts from virtual driver: %driverletter%
@start %driverletter%:\
