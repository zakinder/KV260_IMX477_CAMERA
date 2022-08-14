@echo off > nul
SET count=1
FOR /f "tokens=*" %%G IN ('dir /b') DO (
@echo off > nul
ffplay.exe -i -vf vflip -framerate 60 "udp://127.0.0.0:8080?overrun_nonfatal=1&fifo_size=50000000" -loglevel quiet
set /a count+=1 )
