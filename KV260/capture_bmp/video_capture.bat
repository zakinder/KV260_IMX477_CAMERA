

@echo off
SET count=1
 FOR /f "tokens=*" %%G IN ('dir /b') DO (
ffplay.exe -i -vf vflip -framerate 60 "udp://127.0.0.0:8080?overrun_nonfatal=1&fifo_size=50000000"

 echo %count%:%%G
 set /a count+=1 )
