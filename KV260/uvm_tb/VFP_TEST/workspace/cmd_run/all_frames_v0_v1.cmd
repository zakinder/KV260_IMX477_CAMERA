echo %cd%
call all_per_frame_v0.cmd
cd ../workspace/cmd_run0
echo %cd%
@echo ------------------------------------
@echo Done frame_v0
@echo ------------------------------------
call all_per_frame_v1.cmd
echo %cd%
@echo ------------------------------------
@echo Done frame_v0 and frame_v1
@echo ------------------------------------
pause