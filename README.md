SONY IMX477/IMX682/IMX519/IMX219 Video Streaming


IMX219 and IMX477 Cameras using Raspberry Pi interface on the Kria KV260 Development Board.


FPGA Firmware

      MIPI Camera interfacing 
      Modular and scalable 
      IP-Cores for Vivado Design Suite 
      AXI4 / AXI-Stream compliancy 
      Support for Xilinx 7Series, Ultrascale, Ultrascale+, SoC and MPSoC 

Software

      Controlling and application 
      Modular and scalable 
      Written in C


On PC run ffplay to watch realtime UDP streaming

      ffplay.exe -i -vf vflip -framerate 60 "udp://127.0.0.0:8080?overrun_nonfatal=1&fifo_size=50000000" -loglevel quiet
