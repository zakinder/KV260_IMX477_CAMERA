
@echo off > nul
SET count=1
FOR /f "tokens=*" %%G IN ('dir /b') DO (
@echo off > nul
ffmpeg -err_detect ignore_err -async 1 -strict experimental -i "udp://127.0.0.0:8080?overrun_nonfatal=1&fifo_size=50000000" -filter:v tblend -r 60 -threads 0 -vcodec libx264 -crf 0  -preset ultrafast -vf vflip -f mpegts "udp://localhost:81?pkt_size=1316" -loglevel quiet
set /a count+=1 )
Th

:: ffmpeg -err_detect ignore_err -async 1 -strict experimental -i "udp://127.0.0.0:8080?overrun_nonfatal=1&fifo_size=50000000" -filter:v tblend -r 60 -threads 0 -vcodec libx264 -crf 0  -preset ultrafast -vf vflip -f mpegts "udp://localhost:80?pkt_size=1316" -loglevel quiet
:: ffmpeg -i "udp://127.0.0.0:8080?overrun_nonfatal=1&fifo_size=50000000" -vcodec libx264 -crf 0 -preset ultrafast -vf vflip -f mpegts "udp://localhost:80?pkt_size=1316" -loglevel quiet
:: -i "udp://127.0.0.0:8080"
:: FFMPEG listens locally at port 8080 for UDP input
:: -vcodec libx264
:: Selects the H.264 software encoder
:: -crf 33
:: Selects the "Constant Rate Factor" for quality (the lower the better)
:: -preset superfast/ultrafast
:: Selects the compression (the faster, the less delay, but the higher bitrate)
:: -b:v 40k
:: Set video bitrate to 40 kbit/s
:: -acodec ac3_fixed
:: Selects the AC3 audio encoder (more downscaling possibilities than AAC)
:: -strict experimental
:: Seems to be needed for the AC3 encoder (don't know exactly why)
:: -b:a 12k
:: Set audio bitrate to 12 kBit/s
:: -ar 12000
:: Set the audio sample rate (corresponds to the bitrate)
:: -vf scale=384:-2:flags=lanczos
:: Scale down the image to width 384 pixel, height is chosen automatically according to a parameter "n", use the "Lanczos" scaling filter (sharp)
:: -r 12
:: Set output feamerate to 12 FPS
:: -f mpegts
:: Use "MPEGTS" as output streaming container
:: "udp://localhost:10000?pkt_size=1316"

