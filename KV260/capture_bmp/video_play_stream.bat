
@echo off 
SET count=1
 FOR /f "tokens=*" %%G IN ('dir /b') DO (
ffplay.exe -i "udp://localhost:10000?overrun_nonfatal=1&fifo_size=50000000
 echo %count%:%%G
 set /a count+=1 )
