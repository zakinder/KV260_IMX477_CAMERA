@echo off
cd /d "%~dp0"
py -3 play_4k_mjpeg_diagnostic.py --save-first %*
pause
