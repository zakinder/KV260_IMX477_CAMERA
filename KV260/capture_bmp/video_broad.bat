
@echo off
SET count=1
 FOR /f "tokens=*" %%G IN ('dir /b') DO (
ffmpeg -i "udp://127.0.0.0:8080?overrun_nonfatal=1&fifo_size=50000000" -rtbufsize 702000k -framerate 60 -threads 8 -vcodec libx264 -crf 0 -preset ultrafast -vf vflip -f mpegts "udp://127.0.0.1:41110?pkt_size=188?buffer_size=65535"

 echo %count%:%%G
 set /a count+=1 )