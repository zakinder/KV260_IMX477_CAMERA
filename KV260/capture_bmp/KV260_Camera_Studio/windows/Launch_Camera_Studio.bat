@echo off
cd /d "%~dp0"
py -3 kv260_camera_studio.py
if errorlevel 1 pause
