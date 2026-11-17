@echo off
cd /d "%~dp0"
py -3 receive_4k_jpeg.py
if errorlevel 1 goto done
start "" kv260_4k.jpg
:done
pause
