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

      ffplay.exe -i -vf vflip -framerate 60 "udp://127.0.0.0:8080" -loglevel quiet
      
      

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
      
# COLOR K-MEANS CLUSTERING

This module takes a stream of camera data in pixel pipeline format. This stream must be presented to the inputs iRgb.red, iRgb.red, iRgb.red, iRgb.valid, iRgb.eol, iRgb.eof and iRgb.sof. The result of this module steam K-Mean rgb cluster color space in output oRgb channel.

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/rgb_module.bmp">

* Select rgb n color references for k points to decide number of clusters.
* Assign each new pixel value to closest selected rgb n values using Euclidean distance.
* Pixels which are nearest to the selected rgb values allocated to a cluster.

Euclidean distance is calculated between original image pixel Red1, Green1 and Blue1 and reference pixel color schemes.

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/k1.png">

Rgb Image of video frame consist of 0 to 255 values per rgb channel which gives 256*256*256 colors, and the goal is to use color k mean cluster to set number of clusters. Minimum distance is the final candidate for being closest to the source rgb color. If an RGB image color depth of 24 bits which is 16 million of colors, after K-mean clustering with value n, then image is converted to a version of n colors.

K-mean cluster module convert 16 million of rgb colors into n color version. The module has clock and reset ports. Port iRGB and oRGB consist of red, green, and blue rgb channels with valid signal.

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/k3.png">

The Functional block diagram of the implemented rgb to n clustered conversion is shown in Figure below.

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/k4.png">

The codebook created for K-Means is called the color palette or reference color scheme.


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

In this reference, k parameter set to k = 9, where k is the number of clusters. K-mean color quantization quantizes input image to number of colors into 9 clusters from 9 refences of color schemes.

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture1.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture5.jpg" width="300">

***
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture3.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture6.jpg" width="300">

# K EQUALTO 24 REFERENCE COLOR SCHEMES

In this reference, k parameter set to k = 24, where k is the number of clusters. K-mean color quantization quantizes input image to number of colors into 24 clusters from 24 refences of color schemes. 

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

In this reference, k parameter set to k = 51, where k is the number of clusters. K-mean color quantization quantizes input image to number of colors into 51 clusters from 51 refences of color schemes. 

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture1.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture11.jpg" width="300">

***

<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture3.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture13.jpg" width="300">

***
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture9.jpg" width="300">
<img src="https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture12.jpg" width="300">

