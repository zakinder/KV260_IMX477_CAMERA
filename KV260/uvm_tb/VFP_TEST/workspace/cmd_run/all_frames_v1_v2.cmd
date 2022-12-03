echo %cd%
call all_per_frame_v1.cmd
cd ../workspace/cmd_run0
echo %cd%
@echo ------------------------------------
@echo Done frame_v1
@echo ------------------------------------
call all_per_frame_v2.cmd
echo %cd%
@echo ------------------------------------
@echo Done frame_v1 and frame_v2
@echo ------------------------------------
pause