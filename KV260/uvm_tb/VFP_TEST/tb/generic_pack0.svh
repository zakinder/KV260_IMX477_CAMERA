
// package: generic_pack
package generic_pack;

    `define true                               1
    `define false                              0
    `define d5m_data1x_witdh                   12
    `define axi_data1x_witdh                   15
    `define d5m_data2x_witdh                   24
    `define axi_data2x_witdh                   24

    parameter low                              =0;
    parameter high                             =1;
    parameter select_cgain                     =0;
    parameter select_sharp                     =1;
    parameter select_blur                      =2;
    parameter select_hsl                       =3;
    parameter select_hsv                       =4;
    parameter select_rgb                       =5;
    parameter select_sobel                     =6;
    parameter select_emboss                    =7;
    parameter select_cgainToCgain              =51;
    parameter select_SharpToCgain              =27;
    parameter select_cgainToSharp              =25;
    parameter select_sobel_mask_cga            =17;
    parameter select_sobel_mask_shp            =12;
    parameter select_sobel_mask_blu            =13;
    parameter select_sobel_mask_hsl            =16;
    parameter select_sobel_mask_hsv            =15;
    parameter select_sobel_mask_rgb            =10;
    parameter select_cgainToHsl                =23;
    parameter select_cgainToYcbcr              =24;
    parameter select_rgbCorrect                =45;
    parameter select_rgbRemix                  =46;
    parameter select_rgbDetect                 =47;
    parameter select_rgbPoi                    =48;
    parameter select_y_cb_cr                   =49;

  `ifdef cgain_v0
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgain_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_cgain;
  `elsif sharp_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sharp_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_sharp;
  `elsif blur_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =high;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="blur_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_blur;
  `elsif hsl_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="hsl_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_hsl;
  `elsif hsv_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="hsv_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_hsv;
  `elsif rgb_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =high;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="rgb_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_rgb;
  `elsif sobel_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobel_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_sobel;
  `elsif emboss_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =high;
    parameter read_bmp                         ="emboss_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_emboss;
  `elsif cgtocg_v0
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintocgain_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_cgainToCgain;
  `elsif shtocg_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sharptocgain_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_SharpToCgain;
  `elsif cgtosh_v0
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintosharp_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_cgainToSharp;
  `elsif sbmscg_v0
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskcgain_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_sobel_mask_cga;
  `elsif sbmssh_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmasksharp_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_sobel_mask_shp;
  `elsif sbmsbl_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =high;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskblur_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_sobel_mask_blu;
  `elsif sbmshl_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskhsl_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_sobel_mask_hsl;
  `elsif sbmshv_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskhsv_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_sobel_mask_hsv;
  `elsif sbmsrb_v0
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =high;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskrgb_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_sobel_mask_rgb;
  `elsif cgtohl_v0
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintohsl_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_cgainToHsl;
  `elsif cgain_v1
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgain_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_cgain;
  `elsif sharp_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sharp_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_sharp;
  `elsif blur_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =high;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="blur_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_blur;
  `elsif hsl_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="hsl_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_hsl;
  `elsif hsv_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="hsv_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_hsv;
  `elsif rgb_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =high;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="rgb_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_rgb;
  `elsif sobel_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobel_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_sobel;
  `elsif emboss_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =high;
    parameter read_bmp                         ="emboss_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_emboss;
  `elsif cgtocg_v1
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintocgain_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_cgainToCgain;
  `elsif shtocg_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sharptocgain_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_SharpToCgain;
  `elsif cgtosh_v1
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintosharp_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_cgainToSharp;
  `elsif sbmscg_v1
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskcgain_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_sobel_mask_cga;
  `elsif sbmssh_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmasksharp_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_sobel_mask_shp;
  `elsif sbmsbl_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =high;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskblur_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_sobel_mask_blu;
  `elsif sbmshl_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskhsl_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_sobel_mask_hsl;
  `elsif sbmshv_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskhsv_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_sobel_mask_hsv;
  `elsif sbmsrb_v1
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =high;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskrgb_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_sobel_mask_rgb;
  `elsif cgtohl_v1
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintohsl_v1";
    parameter img_width_bmp                    =128;
    parameter img_height_bmp                   =128;
    parameter selected_video_channel           =select_cgainToHsl;
  `elsif cgain_v2
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgain_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_cgain;
  `elsif sharp_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sharp_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_sharp;
  `elsif blur_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =high;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="blur_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_blur;
  `elsif hsl_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="hsl_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_hsl;
  `elsif hsv_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="hsv_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_hsv;
  `elsif rgb_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =high;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="rgb_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_rgb;
  `elsif sobel_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobel_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_sobel;
  `elsif emboss_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =high;
    parameter read_bmp                         ="emboss_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_emboss;
  `elsif cgtocg_v2
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintocgain_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_cgainToCgain;
  `elsif shtocg_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sharptocgain_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_SharpToCgain;
  `elsif cgtosh_v2
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintosharp_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_cgainToSharp;
    //------------------------------------------------------------------
  `elsif sbmscg_v2
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskcgain_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_sobel_mask_cga;
  `elsif sbmssh_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmasksharp_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_sobel_mask_shp;
  `elsif sbmsbl_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =high;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskblur_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_sobel_mask_blu;
  `elsif sbmshl_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskhsl_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_sobel_mask_hsl;
  `elsif sbmshv_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskhsv_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_sobel_mask_hsv;
  `elsif sbmsrb_v2
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =high;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskrgb_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_sobel_mask_rgb;
  `elsif cgtohl_v2
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintohsl_v2";
    parameter img_width_bmp                    =400;
    parameter img_height_bmp                   =300;
    parameter selected_video_channel           =select_cgainToHsl;
  `elsif cgain_v3
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgain_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_cgain;
  `elsif sharp_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sharp_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_sharp;
  `elsif blur_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =high;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="blur_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_blur;
  `elsif hsl_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="hsl_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_hsl;
  `elsif hsv_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="hsv_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_hsv;
  `elsif rgb_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =high;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="rgb_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_rgb;
  `elsif sobel_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobel_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_sobel;
  `elsif emboss_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =high;
    parameter read_bmp                         ="emboss_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_emboss;
  `elsif cgtocg_v3
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintocgain_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_cgainToCgain;
  `elsif shtocg_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sharptocgain_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_SharpToCgain;
  `elsif cgtosh_v3
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintosharp_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_cgainToSharp;
  `elsif sbmscg_v3
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskcgain_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_sobel_mask_cga;
  `elsif sbmssh_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =high;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmasksharp_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_sobel_mask_shp;
  `elsif sbmsbl_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =high;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskblur_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_sobel_mask_blu;
  `elsif sbmshl_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =low;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskhsl_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_sobel_mask_hsl;
  `elsif sbmshv_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskhsv_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_sobel_mask_hsv;
  `elsif sbmsrb_v3
    parameter F_CGA                            =low;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =low;
    parameter F_HSV                            =low;
    parameter F_RGB                            =high;
    parameter F_SOB                            =high;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="sobelmaskrgb_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_sobel_mask_rgb;
  `elsif cgtohl_v3
    parameter F_CGA                            =high;
    parameter F_SHP                            =low;
    parameter F_BLU                            =low;
    parameter F_HSL                            =high;
    parameter F_HSV                            =high;
    parameter F_RGB                            =low;
    parameter F_SOB                            =low;
    parameter F_EMB                            =low;
    parameter read_bmp                         ="cgaintohsl_v3";
    parameter img_width_bmp                    =1920;
    parameter img_height_bmp                   =1080;
    parameter selected_video_channel           =select_cgainToHsl;
  `else
    parameter F_CGA                            =high;
    parameter F_SHP                            =high;
    parameter F_BLU                            =high;
    parameter F_HSL                            =high;
    parameter F_HSV                            =high;
    parameter F_RGB                            =high;
    parameter F_SOB                            =high;
    parameter F_EMB                            =high;
    parameter read_bmp                         ="cgain_v0";
    parameter img_width_bmp                    =64;
    parameter img_height_bmp                   =64;
    parameter selected_video_channel           =select_cgain;
  `endif

    parameter en_ycbcr                         =low;
    parameter en_rgb                           =high;
    //--------------------------------------------------------------------
    // Vfp Config Registers data values
    //--------------------------------------------------------------------
    parameter reg_00_rgb_sharp                 =10;
    parameter reg_01_edge_type                 =11;
    parameter reg_02_wr_unused                 =low;
    parameter reg_03_bus_select                =low;
    parameter reg_04_config_threshold          =20;
    parameter reg_05_video_channel             =selected_video_channel;
    parameter reg_06_en_ycbcr_or_rgb           =en_rgb;
    parameter reg_07_c_channel                 =15;
    parameter reg_08_kls_k1                    =low;
    parameter reg_09_kls_k2                    =low;
    parameter reg_10_kls_k3                    =low;
    parameter reg_11_kls_k4                    =low;
    parameter reg_12_kls_k5                    =low;
    parameter reg_13_kls_k6                    =low;
    parameter reg_14_kls_k7                    =low;
    parameter reg_15_kls_k8                    =low;
    parameter reg_16_kls_k9                    =low;
    parameter reg_17_k_coef                    =low;
    parameter reg_18_wr_unused                 =low;
    parameter reg_19_wr_unused                 =low;
    parameter reg_20_wr_unused                 =low;
    parameter reg_21_als_k1                    =low;
    parameter reg_22_als_k2                    =low;
    parameter reg_23_als_k3                    =low;
    parameter reg_24_als_k4                    =low;
    parameter reg_25_als_k5                    =low;
    parameter reg_26_als_k6                    =low;
    parameter reg_27_als_k7                    =low;
    parameter reg_28_als_k8                    =low;
    parameter reg_29_als_k9                    =low;
    parameter reg_30_als_coef                  =low;
    parameter reg_31_point_interest            =10;
    parameter reg_32_delta_config              =5;
    parameter reg_33_cpu_ack_go_again          =1;
    parameter reg_34_cpu_wgrid_lock            =1;
    parameter reg_35_cpu_ack_off_frame         =6;
    parameter reg_36_fifo_read_address         =6;
    parameter reg_37_clear_fifo_data           =5;
    parameter reg_38_wr_unused                 =low;
    parameter reg_39_wr_unused                 =low;
    parameter reg_40_wr_unused                 =low;
    parameter reg_41_wr_unused                 =low;
    parameter reg_42_wr_unused                 =low;
    parameter reg_43_wr_unused                 =low;
    parameter reg_44_wr_unused                 =low;
    parameter reg_45_wr_unused                 =low;
    parameter reg_46_wr_unused                 =low;
    parameter reg_47_wr_unused                 =low;
    parameter reg_48_wr_unused                 =low;
    parameter reg_49_wr_unused                 =low;
    parameter reg_50_rgb_cord_rl               =low;
    parameter reg_51_rgb_cord_rh               =255;
    parameter reg_52_rgb_cord_gl               =low;
    parameter reg_53_rgb_cord_gh               =255;
    parameter reg_54_rgb_cord_bl               =low;
    parameter reg_55_rgb_cord_bh               =255;
    parameter reg_56_lum_th                    =36;
    parameter reg_57_hsv_per_ch                =low;
    parameter reg_58_ycc_per_ch                =low;
    parameter reg_59_wr_unused                 =low;
    parameter reg_60_wr_unused                 =low;
    parameter reg_61_wr_unused                 =low;
    parameter reg_62_wr_unused                 =low;
    parameter reg_63_wr_unused                 =low;
    //--------------------------------------------------------------------
    
    
    //--------------------------------------------------------------------
    // Vfp Config Registers offset addresses
    //--------------------------------------------------------------------
    parameter initAddr                         =8'h00;//0   [15]
    parameter oRgbOsharp                       =8'h00;//0   [15]
    parameter oEdgeType                        =8'h04;//4   [15]
    parameter filter_id                        =8'h08;//4   [15]
    parameter aBusSelect                       =8'h0C;//12  [15]
    parameter threshold                        =8'h10;//16  [15]
    parameter videoChannel                     =8'h14;//20  [15]
    parameter dChannel                         =8'h18;//24  [15]
    parameter cChannel                         =8'h1C;//28  [15]
    parameter kls_k1                           =8'h20;//32  [15]
    parameter kls_k2                           =8'h24;//36  [15]
    parameter kls_k3                           =8'h28;//40  [15]
    parameter kls_k4                           =8'h2C;//44  [15]
    parameter kls_k5                           =8'h30;//48  [15]
    parameter kls_k6                           =8'h34;//52  [15]
    parameter kls_k7                           =8'h38;//56  [15]
    parameter kls_k8                           =8'h3C;//60  [15]
    parameter kls_k9                           =8'h40;//64  [15]
    parameter kls_config                       =8'h44;//68  [15]
    parameter als_k1                           =8'h54;//84  [21]
    parameter als_k2                           =8'h58;//88  [22]
    parameter als_k3                           =8'h5C;//92  [23]
    parameter als_k4                           =8'h60;//96  [24]
    parameter als_k5                           =8'h64;//100 [25]
    parameter als_k6                           =8'h68;//104 [26]
    parameter als_k7                           =8'h6C;//108 [27]
    parameter als_k8                           =8'h70;//112 [28]
    parameter als_k9                           =8'h74;//116 [29]
    parameter als_config                       =8'h78;//120 [30]
    parameter pReg_pointInterest               =8'h7C;//124 [31]
    parameter pReg_deltaConfig                 =8'h80;//128 [32]
    parameter pReg_cpuAckGoAgain               =8'h84;//132 [33]
    parameter pReg_cpuWgridLock                =8'h88;//136 [34]
    parameter pReg_cpuAckoffFrame              =8'h8C;//140 [35]
    parameter pReg_fifoReadAddress             =8'h90;//144 [36]
    parameter pReg_clearFifoData               =8'h94;//148 [37]
    parameter rgbCoord_rl                      =8'hC8;//200 [50]
    parameter rgbCoord_rh                      =8'hCC;//204 [51]
    parameter rgbCoord_gl                      =8'hD0;//208 [52]
    parameter rgbCoord_gh                      =8'hD4;//212 [53]
    parameter rgbCoord_bl                      =8'hD8;//216 [54]
    parameter rgbCoord_bh                      =8'hDC;//220 [55]
    parameter oLumTh                           =8'hE0;//224 [56]
    parameter oHsvPerCh                        =8'hE4;//228 [57]
    parameter oYccPerCh                        =8'hE8;//232 [58]
    //--------------------------------------------------------------------
    
    
    //--------------------------------------------------------------------
    // Vfp Config Generics
    //--------------------------------------------------------------------
    parameter revision_number                  =32'h09072019;
    parameter C_rgb_m_axis_TDATA_WIDTH         =24;//16;
    parameter C_rgb_m_axis_START_COUNT         =32;
    parameter C_rgb_s_axis_TDATA_WIDTH         =24;//16;
    parameter C_m_axis_mm2s_TDATA_WIDTH        =24;//16;
    parameter C_m_axis_mm2s_START_COUNT        =32;
    parameter C_vfpConfig_DATA_WIDTH           =32;
    parameter C_vfpConfig_ADDR_WIDTH           =8;
    parameter conf_data_width                  =32;
    parameter conf_addr_width                  =8;
    parameter i_data_width                     =8;
    parameter s_data_width                     =24;//16;
    parameter b_data_width                     =32;
    parameter i_precision                      =12;
    parameter i_full_range                     =`false;
    parameter img_width                        =2751; //D5M max supported img_width =2751
    parameter dataWidth                        =24;   //12;
    parameter F_TES                            =`false;
    parameter F_LUM                            =`false;
    parameter F_TRM                            =`false;
    parameter F_YCC                            =`false;
    //--------------------------------------------------------------------
    
    
    //--------------------------------------------------------------------
    // 
    //--------------------------------------------------------------------
    parameter img_frames_cnt_bmp               =1;
    parameter frame_width                      =100;
    parameter lvalid_offset                    =10;
    parameter frame_height                     =5;
    parameter num_frames                       =1;
    parameter max_num_video_select             =32'h32;//180
    parameter fval_h                           =1'b1;
    parameter fval_l                           =1'b0;
    parameter lval_h                           =1'b1;
    parameter lval_l                           =1'b0;
    parameter ImTyTest_en_patten               =1'b1;//1 internal pattern , 0 from image file
    parameter rImage_disable                   =1'b0;//if ImTyTest set 1 then set this variable 0 otherwise used for when to read image file when write image module is ready upon clear.
    parameter time_out                         =62;
    //--------------------------------------------------------------------
    
    
    //--------------------------------------------------------------------
    // 
    //--------------------------------------------------------------------
    parameter set_increment_value              =87;
    parameter set_cell_red_value               =45;
    parameter set_cell_gre_value               =30;
    parameter set_cell_blu_value               =20;
    parameter offset_r                         =0;
    parameter offset_g                         =150;
    parameter offset_b                         =100;
    //--------------------------------------------------------------------

endpackage