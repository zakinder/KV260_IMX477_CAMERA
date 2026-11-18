@echo off
cd /d "%~dp0"
py -3 -u .\play_4k_mjpeg_compare.py --no-preview 2>&1 | Tee-Object -FilePath .\kv260_receiver_log.txt %*
pause
