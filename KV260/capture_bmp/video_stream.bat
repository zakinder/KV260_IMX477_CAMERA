
@echo off
SET count=1
 FOR /f "tokens=*" %%G IN ('dir /b') DO (
ffplay.exe -i "udp://127.0.0.1:41110?overrun_nonfatal=1&fifo_size=50000000
 echo %count%:%%G
 set /a count+=1 )
