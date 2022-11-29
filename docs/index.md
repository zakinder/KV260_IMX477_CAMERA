## COLOR K-MEANS CLUSTERING

This module takes a stream of camera data in pixel pipeline format. This stream must be presented to the inputs iRgb.red, iRgb.red, iRgb.red, iRgb.valid, iRgb.eol, iRgb.eof and iRgb.sof. The result of this module steam K-Mean rgb cluster color space in output oRgb channel.

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/rgb_module.bmp)

In this section, K mean-based color quantization algorithm is applied to rgb frame.
- Select rgb n color references for k points to decide number of clusters.
- Assign each new pixel value to closest selected rgb n values using Euclidean distance.
- Pixels which are nearest to the selected rgb values allocated to a cluster.

Euclidean distance is calculated between original image pixel Red1, Green1 and Blue1 and reference pixel color schemes.

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/k1.png)


Rgb Image of video frame consist of 0 to 255 values per rgb channel which gives 256*256*256 colors, and the goal is to use color k mean cluster to set number of clusters. Minimum distance is the final candidate for being closest to the source rgb color. If an RGB image color depth of 24 bits which is 16 million of colors, after K-mean clustering with value n, then image is converted to a version of n colors.

K-mean cluster module convert 16 million of rgb colors into n color version. The module has clock and reset ports. Port iRGB and oRGB consist of red, green, and blue rgb channels with valid signal.

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/k3.png)

The Functional block diagram of the implemented rgb to n clustered conversion is shown in Figure below. 

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/k4.png)

The codebook created for K-Means is called the color palette or reference color scheme.

### K EQUALTO 6 REFERENCE COLOR SCHEMES

Generated image below is the result of k-mean clustering using 6 colors references of palette schemes.

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/k2.png)

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture1.jpg)
![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture2.jpg)

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture3.jpg)
![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture4.jpg)

# K EQUALTO 9 REFERENCE COLOR SCHEMES

In this reference, k parameter set to k = 9, where k is the number of clusters. K-mean color quantization quantizes input image to number of colors into 9 clusters from 9 refences of color schemes. 

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture1.jpg)
![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture5.jpg)

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture3.jpg)
![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture6.jpg)


# K EQUALTO 24 REFERENCE COLOR SCHEMES

In this reference, k parameter set to k = 24, where k is the number of clusters. K-mean color quantization quantizes input image to number of colors into 24 clusters from 24 refences of color schemes. 

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture1.jpg)
![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture7.jpg)

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture3.jpg)
![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture8.jpg)


![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture9.jpg)
![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture10.jpg)

# K EQUALTO 51 REFERENCE COLOR SCHEMES

In this reference, k parameter set to k = 51, where k is the number of clusters. K-mean color quantization quantizes input image to number of colors into 51 clusters from 51 refences of color schemes. 

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture1.jpg)
![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture11.jpg)

![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture3.jpg)
![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture13.jpg)


![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture9.jpg)
![This is an image](https://github.com/zakinder/KRIA_KV260_IMX477_CAMERA/blob/main/KV260/doc/references/Picture12.jpg)



