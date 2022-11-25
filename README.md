# SONY IMX477/IMX682/IMX519/IMX219 Video Streaming


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
      
      

PL Design include following IPs

      Zynq MPSoC Processing System            - Processing System
      MIPI CSI2 RX Sub System                 - Receives The MIPI CSI2 Stream From Camera Sensor.
      Sensor Demosaic                         - Convert RAW Pixel into RGB Pixel.
      VDMA                                    - Writes the Image to DDR memory.
      Video Timing Generator                  - Generates the Output Video Timing
      Clock Wizards                           - Generate Video Pixel Clock and MIPI CSI2 Reference Clock
      Video Frame Processing                  - Video Processing Such As Filters and CCM.

PS Design include following Modules

      Configuration and Intialization of VTC, VDMA, Camera Sensors And Lwip.


* Select rgb n color references for k points to decide number of clusters.
* Assign each new pixel value to closest selected rgb n values using Euclidean distance.
* Pixels which are nearest to the selected rgb values allocated to a cluster.

Euclidean distance is calculated between original image pixel Red1, Green1 and Blue1 and reference pixel color schemes.

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/k1.png">

# K EQUALTO 6 REFERENCE COLOR SCHEMES

Generated image below is the result of k-mean clustering using 6 colors references of palette schemes.

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/k2.png" width="250">



***

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture1.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture2.jpg" width="300">

***
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture3.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture4.jpg" width="300">


# K EQUALTO 9 REFERENCE COLOR SCHEMES

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture1.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture5.jpg" width="300">

***
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture3.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture6.jpg" width="300">

# K EQUALTO 24 REFERENCE COLOR SCHEMES

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture1.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture7.jpg" width="300">

***

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture3.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture8.jpg" width="300">

***
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture9.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture10.jpg" width="300">

# K EQUALTO 51 REFERENCE COLOR SCHEMES

Image below is generated using 51 reference color schemes.

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture1.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture11.jpg" width="300">

***

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture3.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture13.jpg" width="300">

***
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture9.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture12.jpg" width="300">

