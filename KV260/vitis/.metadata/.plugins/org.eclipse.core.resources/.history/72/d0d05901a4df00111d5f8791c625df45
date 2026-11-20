#ifndef VIDEO_MODES_H_
#define VIDEO_MODES_H_
typedef struct {
	char label[64];
	u32 width;
	u32 height;
	u32 hps;
	u32 hpe;
	u32 hmax;
	u32 hpol;
	u32 vps;
	u32 vpe;
	u32 vmax;
	u32 vpol;
	double freq;
} VideoMode;
static const VideoMode VMODE_640x480 = {
	.label  = "640x480@60Hz",
	.width  = 640,
	.height = 480,
	.hps    = 656,
	.hpe    = 752,
	.hmax   = 799,
	.hpol   = 0,
	.vps    = 490,
	.vpe    = 492,
	.vmax   = 524,
	.vpol   = 0,
	.freq   = 25.0
};
static const VideoMode VMODE_800x600 = {
	.label = "800x600@60Hz",
	.width = 800,
	.height = 600,
	.hps = 840,
	.hpe = 968,
	.hmax = 1055,
	.hpol = 1,
	.vps = 601,
	.vpe = 605,
	.vmax = 627,
	.vpol = 1,
	.freq = 40.0
};
static const VideoMode VMODE_1280x1024 = {
	.label = "1280x1024@60Hz",
	.width = 1280,
	.height = 1024,
	.hps = 1328,
	.hpe = 1440,
	.hmax = 1687,
	.hpol = 1,
	.vps = 1025,
	.vpe = 1028,
	.vmax = 1065,
	.vpol = 1,
	.freq = 108.0
};
static const VideoMode VMODE_1280x720 = {
	.label = "1280x720@60Hz",
	.width = 1280,
	.height = 720,
	.hps = 1390,
	.hpe = 1430,
	.hmax = 1649,
	.hpol = 1,
	.vps = 725,
	.vpe = 730,
	.vmax = 749,
	.vpol = 1,
	.freq = 74.25, //74.2424 is close enough
};
static const VideoMode VMODE_1600x900 = {
        .label = "1600x900@60Hz",
        .width = 1600,
        .height = 900,
        .hps = 1648,
        .hpe = 1680,
        .hmax = 1759,
        .hpol = 1,
        .vps = 903,
        .vpe = 908,
        .vmax = 925,
        .vpol = 0,
        .freq = 97.75
};
static const VideoMode VMODE_1920x1080 = {
	.label = "1920x1080@60Hz",
	.width = 1920,
	.height = 1080,
	.hps = 2008,
	.hpe = 2052,
	.hmax = 2199,
	.hpol = 1,
	.vps = 1084,
	.vpe = 1089,
	.vmax = 1124,
	.vpol = 1,
	.freq = 148.5 //148.57 is close enough
};
#endif