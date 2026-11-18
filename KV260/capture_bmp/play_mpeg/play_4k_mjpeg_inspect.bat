@echo off
cd /d "%~dp0"
py -3 play_4k_mjpeg_inspect.py --save-every 30 --save-max 8 %*
pause
