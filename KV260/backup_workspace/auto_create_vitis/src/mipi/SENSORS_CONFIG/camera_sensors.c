#include "../SENSORS_CONFIG/camera_sensors.h"

#include <xil_types.h>
#include <xstatus.h>
#include "xiicps.h"
#include "xparameters.h"
#include "sleep.h"
#include <xil_printf.h>
#include "../config.h"
#include "../SENSORS_CONFIG/I2c_transections.h"

#define IIC_OV5640_ADDR  	        0X3C
#define IIC_IMX219_ADDR  	        0x10
#define IIC_IMX477_ADDR  	        0x9A
////////////////////////////////////////////////////
// IMX219
////////////////////////////////////////////////////
#define IMX219_ANA_GAIN_GLOBAL      0x0157
#define IMX219_SENSOR_ID			0x0219
#define REG_SW_RESET 				0x0103
#define REG_MODEL_ID_MSB			0x0000
#define REG_MODEL_ID_LSB			0x0001
#define REG_MODE_SEL 				0x0100
#define REG_CSI_LANE				0x0114
#define REG_DPHY_CTRL				0x0128
#define REG_EXCK_FREQ_MSB			0x012A
#define REG_EXCK_FREQ_LSB			0x012B
#define REG_FRAME_LEN_MSB			0x0160
#define REG_FRAME_LEN_LSB			0x0161
#define REG_LINE_LEN_MSB			0x0162
#define REG_LINE_LEN_LSB			0x0163
#define REG_X_ADD_STA_MSB			0x0164
#define REG_X_ADD_STA_LSB			0x0165
#define REG_X_ADD_END_MSB			0x0166
#define REG_X_ADD_END_LSB			0x0167
#define REG_Y_ADD_STA_MSB			0x0168
#define REG_Y_ADD_STA_LSB			0x0169
#define REG_Y_ADD_END_MSB			0x016A
#define REG_Y_ADD_END_LSB			0x016B
#define REG_X_OUT_SIZE_MSB			0x016C
#define REG_X_OUT_SIZE_LSB			0x016D
#define REG_Y_OUT_SIZE_MSB			0x016E
#define REG_Y_OUT_SIZE_LSB			0x016F
#define REG_X_ODD_INC				0x0170
#define REG_Y_ODD_INC				0x0171
#define REG_IMG_ORIENT				0x0172
#define REG_BINNING_H				0x0174
#define REG_BINNING_V				0x0175
#define REG_BIN_CALC_MOD_H			0x0176
#define REG_BIN_CALC_MOD_V			0x0177
#define REG_CSI_FORMAT_C			0x018C
#define REG_CSI_FORMAT_D			0x018D
#define REG_DIG_GAIN_GLOBAL_MSB		0x0158
#define REG_DIG_GAIN_GLOBAL_LSB		0x0159
#define REG_ANA_GAIN_GLOBAL			0x0157
#define REG_INTEGRATION_TIME_MSB	0x015A
#define REG_INTEGRATION_TIME_LSB 	0x015B
#define REG_ANALOG_GAIN 			0x0157
#define REG_VTPXCK_DIV				0x0301
#define REG_VTSYCK_DIV				0x0303
#define	REG_PREPLLCK_VT_DIV			0x0304
#define	REG_PREPLLCK_OP_DIV			0x0305
#define	REG_PLL_VT_MPY_MSB			0x0306
#define	REG_PLL_VT_MPY_LSB			0x0307
#define REG_OPPXCK_DIV				0x0309
#define REG_OPSYCK_DIV				0x030B
#define REG_PLL_OP_MPY_MSB			0x030C
#define REG_PLL_OP_MPY_LSB			0x030D
#define REG_TEST_PATTERN_MSB		0x0600
#define REG_TEST_PATTERN_LSB		0x0601
#define	REG_TP_X_OFFSET_MSB			0x0620
#define	REG_TP_X_OFFSET_LSB			0x0621
#define	REG_TP_Y_OFFSET_MSB			0x0622
#define	REG_TP_Y_OFFSET_LSB			0x0623
#define	REG_TP_WIDTH_MSB			0x0624
#define	REG_TP_WIDTH_LSB			0x0625
#define	REG_TP_HEIGHT_MSB			0x0626
#define	REG_TP_HEIGHT_LSB			0x0627
////////////////////////////////////////////////////
/* Chip ID */
#define IMX477_REG_CHIP_ID		    0x0016
#define IMX477_CHIP_ID			    0x0477

#define IMX477_REG_MODE_SELECT		0x0100
#define IMX477_MODE_STANDBY		    0x00
#define IMX477_MODE_STREAMING		0x01

#define IMX477_REG_ORIENTATION		0x101

#define IMX477_XCLK_FREQ		    24000000

#define IMX477_DEFAULT_LINK_FREQ	450000000

/* Pixel rate is fixed at 840MHz for all the modes */
#define IMX477_PIXEL_RATE		    840000000

/* V_TIMING internal */
#define IMX477_REG_FRAME_LENGTH		0x0340
#define IMX477_FRAME_LENGTH_MAX		0xffdc

/* Exposure control */
#define IMX477_REG_EXPOSURE		    0x0202
#define IMX477_EXPOSURE_OFFSET		22
#define IMX477_EXPOSURE_MIN		    20
#define IMX477_EXPOSURE_STEP		1
#define IMX477_EXPOSURE_DEFAULT		0x640
#define IMX477_EXPOSURE_MAX		(IMX477_FRAME_LENGTH_MAX - \
					 IMX477_EXPOSURE_OFFSET)

/* Analog gain control */
#define IMX477_REG_ANALOG_GAIN		0x0204
#define IMX477_ANA_GAIN_MIN		    0
#define IMX477_ANA_GAIN_MAX		    978
#define IMX477_ANA_GAIN_STEP		1
#define IMX477_ANA_GAIN_DEFAULT		0x0

/* Digital gain control */
#define IMX477_REG_DIGITAL_GAIN		0x020e
#define IMX477_DGTL_GAIN_MIN		0x0100
#define IMX477_DGTL_GAIN_MAX		0xffff
#define IMX477_DGTL_GAIN_DEFAULT	0x0100
#define IMX477_DGTL_GAIN_STEP		1

/* Test Pattern Control */
#define IMX477_REG_TEST_PATTERN		    0x0600
#define IMX477_TEST_PATTERN_DISABLE	    0
#define IMX477_TEST_PATTERN_SOLID_COLOR	1
#define IMX477_TEST_PATTERN_COLOR_BARS	2
#define IMX477_TEST_PATTERN_GREY_COLOR	3
#define IMX477_TEST_PATTERN_PN9		    4

/* Test pattern colour components */
#define IMX477_REG_TEST_PATTERN_R	    0x0602
#define IMX477_REG_TEST_PATTERN_GR	    0x0604
#define IMX477_REG_TEST_PATTERN_B	    0x0606
#define IMX477_REG_TEST_PATTERN_GB	    0x0608
#define IMX477_TEST_PATTERN_COLOUR_MIN	0
#define IMX477_TEST_PATTERN_COLOUR_MAX	0x0fff
#define IMX477_TEST_PATTERN_COLOUR_STEP	1
#define IMX477_TEST_PATTERN_R_DEFAULT	IMX477_TEST_PATTERN_COLOUR_MAX
#define IMX477_TEST_PATTERN_GR_DEFAULT	0
#define IMX477_TEST_PATTERN_B_DEFAULT	0
#define IMX477_TEST_PATTERN_GB_DEFAULT	0

/* Embedded metadata stream structure */
#define IMX477_EMBEDDED_LINE_WIDTH 16384
#define IMX477_NUM_EMBEDDED_LINES 1


#define IMX477_ANA_GLOBAL_GAIN_U	    0x0204
#define IMX477_ANA_GLOBAL_GAIN_L	    0x0205

#define IMX477_DIG_GLOBAL_GAIN	        0x3FF9
#define IMX477_DIG_GAIN_GR_U	        0x020E
#define IMX477_DIG_GAIN_GR_L	        0x020F
#define IMX477_DIG_GAIN_R_U	            0x0210
#define IMX477_DIG_GAIN_R_L	            0x0211
#define IMX477_DIG_GAIN_B_U	            0x0212
#define IMX477_DIG_GAIN_B_L	            0x0213
#define IMX477_DIG_GAIN_GB_U	        0x0214
#define IMX477_DIG_GAIN_GB_L	        0x0215




//////////////////////////////////////////////////////////
struct reginfo cfg_ov5640_init_data[] =
{	
		//[7]=0 Software reset; [6]=1 Software power down; Default=0x02
		{0x3008, 0x42},
		//[1]=1 System input clock from PLL; Default read = 0x11
		{0x3103, 0x03},
		//[3:0]=0000 MD2P,MD2N,MCP,MCN input; Default=0x00
		{0x3017, 0x00},
		//[7:2]=000000 MD1P,MD1N, D3:0 input; Default=0x00
		{0x3018, 0x00},
		//[6:4]=001 PLL charge pump, [3:0]=1000 MIPI 8-bit mode
		{0x3034, 0x18},
		//PLL1 configuration
		//[7:4]=0001 System clock divider /1, [3:0]=0001 Scale divider for MIPI /1
		{0x3035, 0x11},
		//[7:0]=56 PLL multiplier
		{0x3036, 0x38},
		//[4]=1 PLL root divider /2, [3:0]=1 PLL pre-divider /1
		{0x3037, 0x11},
		//[5:4]=00 PCLK root divider /1, [3:2]=00 SCLK2x root divider /1, [1:0]=01 SCLK root divider /2
		{0x3108, 0x01},
		//PLL2 configuration
		//[5:4]=01 PRE_DIV_SP /1.5, [2]=1 R_DIV_SP /1, [1:0]=00 DIV12_SP /1
		{0x303D, 0x10},
		//[4:0]=11001 PLL2 multiplier DIV_CNT5B = 25
		{0x303B, 0x19},
		{0x3630, 0x2e},
		{0x3631, 0x0e},
		{0x3632, 0xe2},
		{0x3633, 0x23},
		{0x3621, 0xe0},
		{0x3704, 0xa0},
		{0x3703, 0x5a},
		{0x3715, 0x78},
		{0x3717, 0x01},
		{0x370b, 0x60},
		{0x3705, 0x1a},
		{0x3905, 0x02},
		{0x3906, 0x10},
		{0x3901, 0x0a},
		{0x3731, 0x02},
		//VCM debug mode
		{0x3600, 0x37},
		{0x3601, 0x33},
		//System control register changing not recommended
		{0x302d, 0x60},
		//??
		{0x3620, 0x52},
		{0x371b, 0x20},
		//?? DVP
		{0x471c, 0x50},
		{0x3a13, 0x43},
		{0x3a18, 0x00},
		{0x3a19, 0xf8},
		{0x3635, 0x13},
		{0x3636, 0x06},
		{0x3634, 0x44},
		{0x3622, 0x01},
		{0x3c01, 0x34},
		{0x3c04, 0x28},
		{0x3c05, 0x98},
		{0x3c06, 0x00},
		{0x3c07, 0x08},
		{0x3c08, 0x00},
		{0x3c09, 0x1c},
		{0x3c0a, 0x9c},
		{0x3c0b, 0x40},
		//[7]=1 color bar enable, [3:2]=00 eight color bar
		{0x503d, 0x00},
		//[2]=1 ISP vflip, [1]=1 sensor vflip
		{0x3820, 0x46},
		//[7:5]=001 Two lane mode, [4]=0 MIPI HS TX no power down, [3]=0 MIPI LP RX no power down, [2]=1 MIPI enable, [1:0]=10 Debug mode; Default=0x58
		{0x300e, 0x45},
		//[5]=0 Clock free running, [4]=1 Send line short packet, [3]=0 Use lane1 as default, [2]=1 MIPI bus LP11 when no packet; Default=0x04
		{0x4800, 0x14},
		{0x302e, 0x08},
		//[7:4]=0x3 YUV422, [3:0]=0x0 YUYV
		//{0x4300, 0x30},
		//[7:4]=0x6 RGB565, [3:0]=0x0 {b[4:0],g[5:3],g[2:0],r[4:0]}
		{0x4300, 0x6f},
		{0x501f, 0x01},
		{0x4713, 0x03},
		{0x4407, 0x04},
		{0x440e, 0x00},
		{0x460b, 0x35},
		//[1]=0 DVP PCLK divider manual control by 0x3824[4:0]
		{0x460c, 0x20},
		//[4:0]=1 SCALE_DIV=INT(3824[4:0]/2)
		{0x3824, 0x01},
		//[7]=1 LENC correction enabled, [5]=1 RAW gamma enabled, [2]=1 Black pixel cancellation enabled, [1]=1 White pixel cancellation enabled, [0]=1 Color interpolation enabled
		{0x5000, 0x07},
		//[7]=0 Special digital effects, [5]=0 scaling, [2]=0 UV average disabled, [1]=1 Color matrix enabled, [0]=1 Auto white balance enabled
		{0x5001, 0x03},
		{SEQUENCE_END, 0x00}
};
struct reginfo cfg_ov5640_1280_702p_60fps[] =
{
		//1280 x 720 binned, RAW10, MIPISCLK=280M, SCLK=56Mz, PCLK=56M
		//PLL1 configuration
		//[7:4]=0010 System clock divider /2, [3:0]=0001 Scale divider for MIPI /1
		{0x3035, 0x21},
		//[7:0]=70 PLL multiplier
		{0x3036, 0x46},
		//[4]=0 PLL root divider /1, [3:0]=5 PLL pre-divider /1.5
		{0x3037, 0x05},
		//[5:4]=01 PCLK root divider /2, [3:2]=00 SCLK2x root divider /1, [1:0]=01 SCLK root divider /2
		{0x3108, 0x11},
		//[6:4]=001 PLL charge pump, [3:0]=1010 MIPI 10-bit mode
		{0x3034, 0x1A},
		//[3:0]=0 X address start high byte
		{0x3800, (0 >> 8) & 0x0F},
		//[7:0]=0 X address start low byte
		{0x3801, 0 & 0xFF},
		//[2:0]=0 Y address start high byte
		{0x3802, (8 >> 8) & 0x07},
		//[7:0]=0 Y address start low byte
		{0x3803, 8 & 0xFF},
		//[3:0] X address end high byte
		{0x3804, (2619 >> 8) & 0x0F},
		//[7:0] X address end low byte
		{0x3805, 2619 & 0xFF},
		//[2:0] Y address end high byte
		{0x3806, (1947 >> 8) & 0x07},
		//[7:0] Y address end low byte
		{0x3807, 1947 & 0xFF},
		//[3:0]=0 timing hoffset high byte
		{0x3810, (0 >> 8) & 0x0F},
		//[7:0]=0 timing hoffset low byte
		{0x3811, 0 & 0xFF},
		//[2:0]=0 timing voffset high byte
		{0x3812, (0 >> 8) & 0x07},
		//[7:0]=0 timing voffset low byte
		{0x3813, 0 & 0xFF},
		//[3:0] Output horizontal width high byte
		{0x3808, (1280 >> 8) & 0x0F},
		//[7:0] Output horizontal width low byte
		{0x3809, 1280 & 0xFF},
		//[2:0] Output vertical height high byte
		{0x380a, (720 >> 8) & 0x7F},
		//[7:0] Output vertical height low byte
		{0x380b, 720 & 0xFF},
		//HTS line exposure time in # of pixels
		{0x380c, (1896 >> 8) & 0x1F},
		{0x380d, 1896 & 0xFF},
		//VTS frame exposure time in # lines
		{0x380e, (984 >> 8) & 0xFF},
		{0x380f, 984 & 0xFF},
		//[7:4]=0x3 horizontal odd subsample increment, [3:0]=0x1 horizontal even subsample increment
		{0x3814, 0x31},
		//[7:4]=0x3 vertical odd subsample increment, [3:0]=0x1 vertical even subsample increment
		{0x3815, 0x31},
		//[2]=0 ISP mirror, [1]=0 sensor mirror, [0]=1 horizontal binning
		{0x3821, 0x01},
		//little MIPI shit: global timing unit, period of PCLK in ns * 2(depends on # of lanes)
		{0x4837, 36}, // 1/56M*2
		//Undocumented anti-green settings
		{0x3618, 0x00}, // Removes vertical lines appearing under bright light
		{0x3612, 0x59},
		{0x3708, 0x64},
		{0x3709, 0x52},
		{0x370c, 0x03},
		//[7:4]=0x0 Formatter RAW, [3:0]=0x0 BGBG/GRGR
		{0x4300, 0x00},
		//[2:0]=0x3 Format select ISP RAW (DPC)
		{0x501f, 0x03},
		{SEQUENCE_END, 0x00}
};
struct reginfo cfg_ov5640_1920_1080p_30fps[] =
{//1920 x 1080 @ 30fps, RAW10, MIPISCLK=420, SCLK=84MHz, PCLK=84M
		//PLL1 configuration
		//[7:4]=0010 System clock divider /2, [3:0]=0001 Scale divider for MIPI /1
		{0x3035, 0x21}, // 30fps setting
		//[7:0]=105 PLL multiplier
		{0x3036, 0x69},
		//[4]=0 PLL root divider /1, [3:0]=5 PLL pre-divider /1.5
		{0x3037, 0x05},
		//[5:4]=01 PCLK root divider /2, [3:2]=00 SCLK2x root divider /1, [1:0]=01 SCLK root divider /2
		{0x3108, 0x11},
		//[6:4]=001 PLL charge pump, [3:0]=1010 MIPI 10-bit mode
		{0x3034, 0x1A},
		//[3:0]=0 X address start high byte
		{0x3800, (336 >> 8) & 0x0F},
		//[7:0]=0 X address start low byte
		{0x3801, 336 & 0xFF},
		//[2:0]=0 Y address start high byte
		{0x3802, (426 >> 8) & 0x07},
		//[7:0]=0 Y address start low byte
		{0x3803, 426 & 0xFF},
		//[3:0] X address end high byte
		{0x3804, (2287 >> 8) & 0x0F},
		//[7:0] X address end low byte
		{0x3805, 2287 & 0xFF},
		//[2:0] Y address end high byte
		{0x3806, (1529 >> 8) & 0x07},
		//[7:0] Y address end low byte
		{0x3807, 1529 & 0xFF},
		//[3:0]=0 timing hoffset high byte
		{0x3810, (16 >> 8) & 0x0F},
		//[7:0]=0 timing hoffset low byte
		{0x3811, 16 & 0xFF},
		//[2:0]=0 timing voffset high byte
		{0x3812, (12 >> 8) & 0x07},
		//[7:0]=0 timing voffset low byte
		{0x3813, 12 & 0xFF},
		//[3:0] Output horizontal width high byte
		{0x3808, (1920 >> 8) & 0x0F},
		//[7:0] Output horizontal width low byte
		{0x3809, 1920 & 0xFF},
		//[2:0] Output vertical height high byte
		{0x380a, (1080 >> 8) & 0x7F},
		//[7:0] Output vertical height low byte
		{0x380b, 1080 & 0xFF},
		//HTS line exposure time in # of pixels Tline=HTS/sclk
		{0x380c, (2500 >> 8) & 0x1F},
		{0x380d, 2500 & 0xFF},
		//VTS frame exposure time in # lines
		{0x380e, (1120 >> 8) & 0xFF},
		{0x380f, 1120 & 0xFF},
		//[7:4]=0x1 horizontal odd subsample increment, [3:0]=0x1 horizontal even subsample increment
		{0x3814, 0x11},
		//[7:4]=0x1 vertical odd subsample increment, [3:0]=0x1 vertical even subsample increment
		{0x3815, 0x11},
		//[2]=0 ISP mirror, [1]=0 sensor mirror, [0]=0 no horizontal binning
		{0x3821, 0x00},
		//little MIPI shit: global timing unit, period of PCLK in ns * 2(depends on # of lanes)
		{0x4837, 24}, // 1/84M*2
		//Undocumented anti-green settings
		{0x3618, 0x00}, // Removes vertical lines appearing under bright light
		{0x3612, 0x59},
		{0x3708, 0x64},
		{0x3709, 0x52},
		{0x370c, 0x03},
		//[7:4]=0x0 Formatter RAW, [3:0]=0x0 BGBG/GRGR
		{0x4300, 0x00},
		//[2:0]=0x3 Format select ISP RAW (DPC)
		{0x501f, 0x03},
		{SEQUENCE_END, 0x00}
};
struct reginfo cfg_ov5640_advanced_awb[] =
{
		// Enable Advanced AWB
		{0x3406 ,0x00},
		{0x5192 ,0x04},
		{0x5191 ,0xf8},
		{0x518d ,0x26},
		{0x518f ,0x42},
		{0x518e ,0x2b},
		{0x5190 ,0x42},
		{0x518b ,0xd0},
		{0x518c ,0xbd},
		{0x5187 ,0x18},
		{0x5188 ,0x18},
		{0x5189 ,0x56},
		{0x518a ,0x5c},
		{0x5186 ,0x1c},
		{0x5181 ,0x50},
		{0x5184 ,0x20},
		{0x5182 ,0x11},
		{0x5183 ,0x00},
		{0x5001 ,0x03},
		{SEQUENCE_END, 0x00}
};

struct reginfo cfg_imx219_1280_702p_60fps[] =
{
    {0x30EB, 0x05},
    {0x30EB, 0x0C},
    {0x300A, 0xFF},
    {0x300B, 0xFF},
    {0x30EB, 0x05},
    {0x30EB, 0x09},
    {0x0114, 0x01}, // CSI_LANE_MODE = 2-lane
    {0x0128, 0x00}, // DPHY_CTRL = auto mode
    {0x012A, 0x13}, // EXCLK_FREQ[15:8]
    {0x012B, 0x34}, // EXCLK_FREQ[7:0] = 4916 MHz
    {REG_FRAME_LEN_MSB, 0x04}, // FRM_LENGTH_A[15:8]
    {REG_FRAME_LEN_LSB, 0x60}, // FRM_LENGTH_A[7:0] = 1120
    {REG_LINE_LEN_MSB, 0x0D}, // LINE_LENGTH_A[15:8]
    {REG_LINE_LEN_LSB, 0x78}, // LINE_LENGTH_A[7:0] = 3448
    {0x0164, 0x01}, // XADD_STA_A[11:8]
    {0x0165, 0x58}, // XADD_STA_A[7:0] = X top left = 344
    {0x0166, 0x0B}, // XADD_END_A[11:8]
    {0x0167, 0x77}, // XADD_END_A[7:0] = X bottom right = 2935
    {0x0168, 0x01}, // YADD_STA_A[11:8]
    {0x0169, 0xF0}, // YADD_STA_A[7:0] = Y top left = 496
    {0x016A, 0x07}, // YADD_END_A[11:8]
    {0x016B, 0xAF}, // YADD_END_A[7:0] = Y bottom right = 1967
    {0x016C, 0x05}, // x_output_size[11:8]
    {0x016D, 0x10}, // x_output_size[7:0] = 1296
    {0x016E, 0x02}, // y_output_size[11:8]
    {0x016F, 0xE0}, // y_output_size[7:0] = 736
    {0x0170, 0x01}, // X_ODD_INC_A
    {0x0171, 0x01}, // Y_ODD_INC_A
    {REG_BINNING_H, 0x01}, // BINNING_MODE_H_A = x2-binning
    {REG_BINNING_V, 0x01}, // BINNING_MODE_V_A = x2-binning
    // {REG_BINNING_H, 0x00}, // BINNING_MODE_H_A = no-binning
    // {REG_BINNING_V, 0x00}, // BINNING_MODE_V_A = no-binning
    {REG_BIN_CALC_MOD_H, 0x01}, // BINNING_CAL_MODE_H_A
    {REG_BIN_CALC_MOD_V, 0x01}, // BINNING_CAL_MODE_V_A
    {REG_CSI_FORMAT_C, 0x0A}, // CSI_DATA_FORMAT_A[15:8]
    {REG_CSI_FORMAT_D, 0x0A}, // CSI_DATA_FORMAT_A[7:0]
    {0x0301, 0x05},
    {0x0303, 0x01},
    {0x0304, 0x02},
    {0x0305, 0x02},
    {0x0309, 0x0A}, // OPPXCK_DIV
    {0x030B, 0x01}, // OPSYCK_DIV
    {0x0306, 0x00}, // PLL_VT_MPY[10:8]
    //{0x0307, 0x2E}, // PLL_VT_MPY[7:0] = 46
    {0x0307, 0x17}, // PLL_VT_MPY[7:0] = 23
    //{0x0307, 0x0F}, // PLL_VT_MPY[7:0] = 15
    {0x030C, 0x00}, // PLL_OP_MPY[10:8]
    //{0x030D, 0x5C}, // PLL_OP_MPY[7:0] = 92
    {0x030D, 0x2E}, // PLL_OP_MPY[7:0] = 46
    //{0x030D, 0x1E}, // PLL_OP_MPY[7:0] = 30
    {0x455E, 0x00},
    {0x471E, 0x4B},
    {0x4767, 0x0F},
    {0x4750, 0x14},
    {0x4540, 0x00},
    {0x47B4, 0x14},
    {0x4713, 0x30},
    {0x478B, 0x10},
    {0x478F, 0x10},
    {0x4793, 0x10},
    {0x4797, 0x0E},
    {0x479B, 0x0E},
    //{0x0601, 0x02}, // Test pattern = Color bar
//    {0x0601, 0x00}, // Test pattern = Normal work
//    {0x0620, 0x00}, // TP_WINDOW_X_OFFSET[11:8]
//    {0x0621, 0x00}, // TP_WINDOW_X_OFFSET[7:0]
//    {0x0621, 0x00}, // TP_WINDOW_Y_OFFSET[11:8]
//    {0x0623, 0x00}, // TP_WINDOW_Y_OFFSET[7:0]
//    {0x0624, 0x05}, // TP_WINDOW_WIDTH[11:8]
//    {0x0625, 0x00}, // TP_WINDOW_WIDTH[7:0] = 1280
//    {0x0626, 0x02}, // TP_WINDOW_HEIGHT[11:8]
//    {0x0627, 0xD0}, // TP_WINDOW_HEIGHT[7:0] = 720
    {REG_MODE_SEL, 0x01}, /* mode select streaming on */
	{SEQUENCE_END, 0x00}
};



struct reginfo cfg_imx219_1920_1080p_60fps[] =
{
		{0x30eb, 0x05},
		{0x30eb, 0x0c},
		{0x300a, 0xff},
		{0x300b, 0xff},
		{0x30eb, 0x05},
		{0x30eb, 0x09},
		{0x0114, 0x01},
		{0x0128, 0x00},
		{0x012a, 0x18},
		{0x012b, 0x00},
		{REG_LINE_LEN_MSB, 0x0d},
		{REG_LINE_LEN_LSB, 0x78},
		{0x0164, 0x02},
		{0x0165, 0xa8},
		{0x0166, 0x0a},
		{0x0167, 0x27},
		{0x0168, 0x02},
		{0x0169, 0xb4},
		{0x016a, 0x06},
		{0x016b, 0xeb},
		{0x016c, 0x07},
		{0x016d, 0x80},
		{0x016e, 0x04},
		{0x016f, 0x38},
		{0x0170, 0x01},
		{0x0171, 0x01},
		{REG_BINNING_H, 0x00},
		{REG_BINNING_V, 0x00},
		{REG_BIN_CALC_MOD_H, 0x01}, // BINNING_CAL_MODE_H_A
		{REG_BIN_CALC_MOD_V, 0x01}, // BINNING_CAL_MODE_V_A
		{REG_CSI_FORMAT_C, 0x0A}, // CSI_DATA_FORMAT_A[15:8]
		{REG_CSI_FORMAT_D, 0x0A}, // CSI_DATA_FORMAT_A[7:0]
		{0x0301, 0x05},
		{0x0303, 0x01},
		{0x0304, 0x03},
		{0x0305, 0x03},
		{0x0306, 0x00},
		{0x0307, 0x39},
		{0x030b, 0x01},
		{0x030c, 0x00},
		{0x030d, 0x72},
		{0x0624, 0x07},
		{0x0625, 0x80},
		{0x0626, 0x04},
		{0x0627, 0x38},
		{0x455e, 0x00},
		{0x471e, 0x4b},
		{0x4767, 0x0f},
		{0x4750, 0x14},
		{0x4540, 0x00},
		{0x47b4, 0x14},
		{0x4713, 0x30},
		{0x478b, 0x10},
		{0x478f, 0x10},
		{0x4793, 0x10},
		{0x4797, 0x0e},
		{0x479b, 0x0e},
        {REG_INTEGRATION_TIME_MSB, 0x03},	//integration time , really important for frame rate
        {REG_INTEGRATION_TIME_LSB, 0x51},
		{REG_MODE_SEL, 0x01},
		{SEQUENCE_END, 0x00}
};

struct reginfo cfg2_imx219_1920_1080p_60fps[] =
{

	    {0x0100, 0x00},
	    {0x30eb, 0x05},
	    {0x30eb, 0x0c},
	    {0x300a, 0xff},
	    {0x300b, 0xff},
	    {0x30eb, 0x05},
	    {0x30eb, 0x09},
	    {0x0114, 0x01},
	    {0x0128, 0x00},
	    {0x012a, 0x18},
	    {0x012b, 0x00},
	    {0x0162, 0x0d},
	    {0x0163, 0x78},
	    {0x0164, 0x02},
	    {0x0165, 0xa8},
	    {0x0166, 0x0a},
	    {0x0167, 0x27},
	    {0x0168, 0x02},
	    {0x0169, 0xb4},
	    {0x016a, 0x06},
	    {0x016b, 0xeb},
	    {0x016c, 0x07},
	    {0x016d, 0x80},
	    {0x016e, 0x04},
	    {0x016f, 0x38},
	    {0x0170, 0x01},
	    {0x0171, 0x01},
	    {0x0174, 0x00},
	    {0x0175, 0x00},
	    {0x0301, 0x05},
	    {0x0303, 0x01},
	    {0x0304, 0x03},
	    {0x0305, 0x03},
	    {0x0306, 0x00},
	    {0x0307, 0x39},
	    {0x030b, 0x01},
	    {0x030c, 0x00},
	    {0x030d, 0x72},
	    {0x0624, 0x07},
	    {0x0625, 0x80},
	    {0x0626, 0x04},
	    {0x0627, 0x38},
	    {0x455e, 0x00},
	    {0x471e, 0x4b},
	    {0x4767, 0x0f},
	    {0x4750, 0x14},
	    {0x4540, 0x00},
	    {0x47b4, 0x14},
	    {0x4713, 0x30},
	    {0x478b, 0x10},
	    {0x478f, 0x10},
	    {0x4793, 0x10},
	    {0x4797, 0x0e},
	    {0x479b, 0x0e},
		{0x018c, 0x0a},
		{0x018d, 0x0a},
		{0x0309, 0x0a},
        {REG_INTEGRATION_TIME_MSB, 0x03},	//integration time , really important for frame rate
        {REG_INTEGRATION_TIME_LSB, 0x51},
		{REG_MODE_SEL, 0x01},
		{SEQUENCE_END, 0x00}
};
struct reginfo cfg1_imx219_1920_1080p_60fps[] =
{

        {REG_MODE_SEL,		       0x00},
        {0x30EB,			       0x05},	//access sequence
        {0x30EB,			       0x0C},
        {0x300A,			       0xFF},
        {0x300B,			       0xFF},
        {0x30EB,			       0x05},
        {0x30EB,			       0x09},
        {REG_CSI_LANE,		       0x01},	//3-> 4Lane 1-> 2Lane
        {REG_DPHY_CTRL,		       0x00},	//DPHY timing 0-> auot 1-> manual
        {REG_EXCK_FREQ_MSB,	       0x18},	//external oscillator frequncy 0x18 -> 24Mhz
        {REG_EXCK_FREQ_LSB,	       0x00},
        {REG_FRAME_LEN_MSB,	       0x06},	//frame length , Raspberry pi sends this commands continously when recording video @60fps ,writes come at interval of 32ms , Data 355 for resolution 1280x720 command 162 also comes along with data 0DE7 also 15A with data 0200
        {REG_FRAME_LEN_LSB,	       0xE3},
        {REG_LINE_LEN_MSB,	       0x0d},	//does not directly affect how many bits on wire in one line does affect how many clock between lines
        {REG_LINE_LEN_LSB,	       0x78},	//appears to be having step in value, not every LSb change will reflect on fps
        {REG_X_ADD_STA_MSB,	       0x02},	//x start
        {REG_X_ADD_STA_LSB,	       0xA8},
        {REG_X_ADD_END_MSB,	       0x0A},	//x end
        {REG_X_ADD_END_LSB,	       0x27},
        {REG_Y_ADD_STA_MSB,	       0x02},	//y start
        {REG_Y_ADD_STA_LSB,	       0xB4},
        {REG_Y_ADD_END_MSB,	       0x06},	//y end
        {REG_Y_ADD_END_LSB,	       0xEB},
        {REG_X_OUT_SIZE_MSB,       0x07},	//resolution 1280 -> 5 00 , 1920 -> 780 , 2048 -> 0x8 0x00
        {REG_X_OUT_SIZE_LSB,       0x80},
        {REG_Y_OUT_SIZE_MSB,       0x04},	// 720 -> 0x02D0 | 1080 -> 0x438  | this setting changes how many line over wire does not affect frame rate
        {REG_Y_OUT_SIZE_LSB,       0x38},
        {REG_X_ODD_INC,		       0x01},	//increment
        {REG_Y_ODD_INC,		       0x01},	//increment
        {REG_BINNING_H,		       0x00},	//binning H 0 off 1 x2 2 x4 3 x2 analog
        {REG_BINNING_V,		       0x00},	//binning H 0 off 1 x2 2 x4 3 x2 analog
        {REG_CSI_FORMAT_C,		   0x0A},	//CSI Data format A-> 10bit
        {REG_CSI_FORMAT_D,		   0x0A},	//CSI Data format
        {REG_VTPXCK_DIV,		   0x05},	//vtpxclkd_div	5 301
        {REG_VTSYCK_DIV,		   0x01},	//vtsclk _div  1	303
        {REG_PREPLLCK_VT_DIV,	   0x03},	//external oscillator /3
        {REG_PREPLLCK_OP_DIV,	   0x03},	//external oscillator /3
        {REG_PLL_VT_MPY_MSB,	   0x00},	//PLL_VT multiplizer
        {REG_PLL_VT_MPY_LSB,	   0x52},	//Changes Frame rate with , integration register 0x15a
        //{REG_OPPXCK_DIV,		   0x0A},	//oppxck_div
        //{REG_OPSYCK_DIV,		   0x01},	//opsysck_div
        //{REG_PLL_OP_MPY_MSB,	   0x00},	//PLL_OP
        //{REG_PLL_OP_MPY_LSB,	   0x32}, 	// 8Mhz x 0x57 ->696Mhz -> 348Mhz |  0x32 -> 200Mhz | 0x40 -> 256Mhz
        {0x455E,				   0x00},	//magic?
        {0x471E,				   0x4B},
        {0x4767,				   0x0F},
        {0x4750,				   0x14},
        {0x4540,				   0x00},
        {0x47B4,				   0x14},
        {0x4713,				   0x30},
        {0x478B,				   0x10},
        {0x478F,				   0x10},
        {0x4793,				   0x10},
        {0x4797,				   0x0E},
        {0x479B,				   0x0E},
        {REG_TEST_PATTERN_MSB,     0x00}, //test pattern
        {REG_TEST_PATTERN_LSB,     0x00},
        {REG_TP_X_OFFSET_MSB,      0x00}, //tp offset x 0
        {REG_TP_X_OFFSET_LSB,      0x00},
        {REG_TP_Y_OFFSET_MSB,      0x00}, //tp offset y 0
        {REG_TP_Y_OFFSET_LSB,      0x00},
        {REG_TP_WIDTH_MSB,   	   0x05}, //TP width 1920 ->780 1280->500
        {REG_TP_WIDTH_LSB,   	   0x00},
        {REG_TP_HEIGHT_MSB,   	   0x02}, //TP height 1080 -> 438 720->2D0
        {REG_TP_HEIGHT_LSB,   	   0xD0},
        {REG_DIG_GAIN_GLOBAL_MSB,  0x01},
        {REG_DIG_GAIN_GLOBAL_LSB,  0x10},
        {REG_ANA_GAIN_GLOBAL,      0x80},   //analog gain , raspberry pi constinouly changes this depending on scense
        {REG_INTEGRATION_TIME_MSB, 0x03},	//integration time , really important for frame rate
        {REG_INTEGRATION_TIME_LSB, 0x51},
		{REG_MODE_SEL, 0x01},
        {SEQUENCE_END, 0x00}
};
struct reginfo cfg1_imx477_mode_common[] =
{
        {0x0136, 0x18},
        {0x0137, 0x00},
        {0xe000, 0x00},
        {0xe07a, 0x01},
        {0x0808, 0x02},
        {0x4ae9, 0x18},
        {0x4aea, 0x08},
        {0xf61c, 0x04},
        {0xf61e, 0x04},
        {0x4ae9, 0x21},
        {0x4aea, 0x80},
        {0x38a8, 0x1f},
        {0x38a9, 0xff},
        {0x38aa, 0x1f},
        {0x38ab, 0xff},
        {0x55d4, 0x00},
        {0x55d5, 0x00},
        {0x55d6, 0x07},
        {0x55d7, 0xff},
        {0x55e8, 0x07},
        {0x55e9, 0xff},
        {0x55ea, 0x00},
        {0x55eb, 0x00},
        {0x574c, 0x07},
        {0x574d, 0xff},
        {0x574e, 0x00},
        {0x574f, 0x00},
        {0x5754, 0x00},
        {0x5755, 0x00},
        {0x5756, 0x07},
        {0x5757, 0xff},
        {0x5973, 0x04},
        {0x5974, 0x01},
        {0x5d13, 0xc3},
        {0x5d14, 0x58},
        {0x5d15, 0xa3},
        {0x5d16, 0x1d},
        {0x5d17, 0x65},
        {0x5d18, 0x8c},
        {0x5d1a, 0x06},
        {0x5d1b, 0xa9},
        {0x5d1c, 0x45},
        {0x5d1d, 0x3a},
        {0x5d1e, 0xab},
        {0x5d1f, 0x15},
        {0x5d21, 0x0e},
        {0x5d22, 0x52},
        {0x5d23, 0xaa},
        {0x5d24, 0x7d},
        {0x5d25, 0x57},
        {0x5d26, 0xa8},
        {0x5d37, 0x5a},
        {0x5d38, 0x5a},
        {0x5d77, 0x7f},
        {0x7b75, 0x0e},
        {0x7b76, 0x0b},
        {0x7b77, 0x08},
        {0x7b78, 0x0a},
        {0x7b79, 0x47},
        {0x7b7c, 0x00},
        {0x7b7d, 0x00},
        {0x8d1f, 0x00},
        {0x8d27, 0x00},
        {0x9004, 0x03},
        {0x9200, 0x50},
        {0x9201, 0x6c},
        {0x9202, 0x71},
        {0x9203, 0x00},
        {0x9204, 0x71},
        {0x9205, 0x01},
        {0x9371, 0x6a},
        {0x9373, 0x6a},
        {0x9375, 0x64},
        {0x991a, 0x00},
        {0x996b, 0x8c},
        {0x996c, 0x64},
        {0x996d, 0x50},
        {0x9a4c, 0x0d},
        {0x9a4d, 0x0d},
        {0xa001, 0x0a},
        {0xa003, 0x0a},
        {0xa005, 0x0a},
        {0xa006, 0x01},
        {0xa007, 0xc0},
        {0xa009, 0xc0},
        {0x3d8a, 0x01},
        {0x4421, 0x04},
        {0x7b3b, 0x01},
        {0x7b4c, 0x00},
        {0x9905, 0x00},
        {0x9907, 0x00},
        {0x9909, 0x00},
        {0x990b, 0x00},
        {0x9944, 0x3c},
        {0x9947, 0x3c},
        {0x994a, 0x8c},
        {0x994b, 0x50},
        {0x994c, 0x1b},
        {0x994d, 0x8c},
        {0x994e, 0x50},
        {0x994f, 0x1b},
        {0x9950, 0x8c},
        {0x9951, 0x1b},
        {0x9952, 0x0a},
        {0x9953, 0x8c},
        {0x9954, 0x1b},
        {0x9955, 0x0a},
        {0x9a13, 0x04},
        {0x9a14, 0x04},
        {0x9a19, 0x00},
        {0x9a1c, 0x04},
        {0x9a1d, 0x04},
        {0x9a26, 0x05},
        {0x9a27, 0x05},
        {0x9a2c, 0x01},
        {0x9a2d, 0x03},
        {0x9a2f, 0x05},
        {0x9a30, 0x05},
        {0x9a41, 0x00},
        {0x9a46, 0x00},
        {0x9a47, 0x00},
        {0x9c17, 0x35},
        {0x9c1d, 0x31},
        {0x9c29, 0x50},
        {0x9c3b, 0x2f},
        {0x9c41, 0x6b},
        {0x9c47, 0x2d},
        {0x9c4d, 0x40},
        {0x9c6b, 0x00},
        {0x9c71, 0xc8},
        {0x9c73, 0x32},
        {0x9c75, 0x04},
        {0x9c7d, 0x2d},
        {0x9c83, 0x40},
        {0x9c94, 0x3f},
        {0x9c95, 0x3f},
        {0x9c96, 0x3f},
        {0x9c97, 0x00},
        {0x9c98, 0x00},
        {0x9c99, 0x00},
        {0x9c9a, 0x3f},
        {0x9c9b, 0x3f},
        {0x9c9c, 0x3f},
        {0x9ca0, 0x0f},
        {0x9ca1, 0x0f},
        {0x9ca2, 0x0f},
        {0x9ca3, 0x00},
        {0x9ca4, 0x00},
        {0x9ca5, 0x00},
        {0x9ca6, 0x1e},
        {0x9ca7, 0x1e},
        {0x9ca8, 0x1e},
        {0x9ca9, 0x00},
        {0x9caa, 0x00},
        {0x9cab, 0x00},
        {0x9cac, 0x09},
        {0x9cad, 0x09},
        {0x9cae, 0x09},
        {0x9cbd, 0x50},
        {0x9cbf, 0x50},
        {0x9cc1, 0x50},
        {0x9cc3, 0x40},
        {0x9cc5, 0x40},
        {0x9cc7, 0x40},
        {0x9cc9, 0x0a},
        {0x9ccb, 0x0a},
        {0x9ccd, 0x0a},
        {0x9d17, 0x35},
        {0x9d1d, 0x31},
        {0x9d29, 0x50},
        {0x9d3b, 0x2f},
        {0x9d41, 0x6b},
        {0x9d47, 0x42},
        {0x9d4d, 0x5a},
        {0x9d6b, 0x00},
        {0x9d71, 0xc8},
        {0x9d73, 0x32},
        {0x9d75, 0x04},
        {0x9d7d, 0x42},
        {0x9d83, 0x5a},
        {0x9d94, 0x3f},
        {0x9d95, 0x3f},
        {0x9d96, 0x3f},
        {0x9d97, 0x00},
        {0x9d98, 0x00},
        {0x9d99, 0x00},
        {0x9d9a, 0x3f},
        {0x9d9b, 0x3f},
        {0x9d9c, 0x3f},
        {0x9d9d, 0x1f},
        {0x9d9e, 0x1f},
        {0x9d9f, 0x1f},
        {0x9da0, 0x0f},
        {0x9da1, 0x0f},
        {0x9da2, 0x0f},
        {0x9da3, 0x00},
        {0x9da4, 0x00},
        {0x9da5, 0x00},
        {0x9da6, 0x1e},
        {0x9da7, 0x1e},
        {0x9da8, 0x1e},
        {0x9da9, 0x00},
        {0x9daa, 0x00},
        {0x9dab, 0x00},
        {0x9dac, 0x09},
        {0x9dad, 0x09},
        {0x9dae, 0x09},
        {0x9dc9, 0x0a},
        {0x9dcb, 0x0a},
        {0x9dcd, 0x0a},
        {0x9e17, 0x35},
        {0x9e1d, 0x31},
        {0x9e29, 0x50},
        {0x9e3b, 0x2f},
        {0x9e41, 0x6b},
        {0x9e47, 0x2d},
        {0x9e4d, 0x40},
        {0x9e6b, 0x00},
        {0x9e71, 0xc8},
        {0x9e73, 0x32},
        {0x9e75, 0x04},
        {0x9e94, 0x0f},
        {0x9e95, 0x0f},
        {0x9e96, 0x0f},
        {0x9e97, 0x00},
        {0x9e98, 0x00},
        {0x9e99, 0x00},
        {0x9ea0, 0x0f},
        {0x9ea1, 0x0f},
        {0x9ea2, 0x0f},
        {0x9ea3, 0x00},
        {0x9ea4, 0x00},
        {0x9ea5, 0x00},
        {0x9ea6, 0x3f},
        {0x9ea7, 0x3f},
        {0x9ea8, 0x3f},
        {0x9ea9, 0x00},
        {0x9eaa, 0x00},
        {0x9eab, 0x00},
        {0x9eac, 0x09},
        {0x9ead, 0x09},
        {0x9eae, 0x09},
        {0x9ec9, 0x0a},
        {0x9ecb, 0x0a},
        {0x9ecd, 0x0a},
        {0x9f17, 0x35},
        {0x9f1d, 0x31},
        {0x9f29, 0x50},
        {0x9f3b, 0x2f},
        {0x9f41, 0x6b},
        {0x9f47, 0x42},
        {0x9f4d, 0x5a},
        {0x9f6b, 0x00},
        {0x9f71, 0xc8},
        {0x9f73, 0x32},
        {0x9f75, 0x04},
        {0x9f94, 0x0f},
        {0x9f95, 0x0f},
        {0x9f96, 0x0f},
        {0x9f97, 0x00},
        {0x9f98, 0x00},
        {0x9f99, 0x00},
        {0x9f9a, 0x2f},
        {0x9f9b, 0x2f},
        {0x9f9c, 0x2f},
        {0x9f9d, 0x00},
        {0x9f9e, 0x00},
        {0x9f9f, 0x00},
        {0x9fa0, 0x0f},
        {0x9fa1, 0x0f},
        {0x9fa2, 0x0f},
        {0x9fa3, 0x00},
        {0x9fa4, 0x00},
        {0x9fa5, 0x00},
        {0x9fa6, 0x1e},
        {0x9fa7, 0x1e},
        {0x9fa8, 0x1e},
        {0x9fa9, 0x00},
        {0x9faa, 0x00},
        {0x9fab, 0x00},
        {0x9fac, 0x09},
        {0x9fad, 0x09},
        {0x9fae, 0x09},
        {0x9fc9, 0x0a},
        {0x9fcb, 0x0a},
        {0x9fcd, 0x0a},
        {0xa14b, 0xff},
        {0xa151, 0x0c},
        {0xa153, 0x50},
        {0xa155, 0x02},
        {0xa157, 0x00},
        {0xa1ad, 0xff},
        {0xa1b3, 0x0c},
        {0xa1b5, 0x50},
        {0xa1b9, 0x00},
        {0xa24b, 0xff},
        {0xa257, 0x00},
        {0xa2ad, 0xff},
        {0xa2b9, 0x00},
        {0xb21f, 0x04},
        {0xb35c, 0x00},
        {0xb35e, 0x08},
        {0x0112, 0x0c},
        {0x0113, 0x0c},
        {0x0114, 0x01},
        {0x0350, 0x00},
        {0xbcf1, 0x02},
        {0x3ff9, 0x01},
        {SEQUENCE_END, 0x00}
};
struct reginfo cfg1_imx477_1920x1080p[] =
{
        {0x0342, 0x31},
        {0x0343, 0xc4},
        {0x0344, 0x00},
        {0x0345, 0x00},
        {0x0346, 0x01},
        {0x0347, 0xb8},
        {0x0348, 0x0f},
        {0x0349, 0xd7},
        {0x034a, 0x0a},
        {0x034b, 0x27},
        {0x0220, 0x00},
        {0x0221, 0x11},
        {0x0381, 0x01},
        {0x0383, 0x01},
        {0x0385, 0x01},
        {0x0387, 0x01},
        {0x0900, 0x01},
        {0x0901, 0x12},
        {0x0902, 0x02},
        {0x3140, 0x02},
        {0x3c00, 0x00},
        {0x3c01, 0x03},
        {0x3c02, 0xa2},
        {0x3f0d, 0x01},
        {0x5748, 0x07},
        {0x5749, 0xff},
        {0x574a, 0x00},
        {0x574b, 0x00},
        {0x7b53, 0x01},
        {0x9369, 0x73},
        {0x936b, 0x64},
        {0x936d, 0x5f},
        {0x9304, 0x00},
        {0x9305, 0x00},
        {0x9e9a, 0x2f},
        {0x9e9b, 0x2f},
        {0x9e9c, 0x2f},
        {0x9e9d, 0x00},
        {0x9e9e, 0x00},
        {0x9e9f, 0x00},
        {0xa2a9, 0x60},
        {0xa2b7, 0x00},
        {0x0401, 0x01},
        {0x0404, 0x00},
        {0x0405, 0x20},
        {0x0408, 0x00},
        {0x0409, 0x00},
        {0x040a, 0x00},
        {0x040b, 0x00},
        {0x040c, 0x0f},
        {0x040d, 0xd8},
        {0x040e, 0x04},
        {0x040f, 0x38},
        {0x034c, 0x07},
        {0x034d, 0xec},
        {0x034e, 0x04},
        {0x034f, 0x38},
        {0x0301, 0x05},
        {0x0303, 0x02},
        {0x0305, 0x04},
        {0x0306, 0x01},
        {0x0307, 0x5e},
        {0x0309, 0x0c},
        {0x030b, 0x02},
        {0x030d, 0x02},
        {0x030e, 0x00},
        {0x030f, 0x96},
        {0x0310, 0x01},
        {0x0820, 0x07},
        {0x0821, 0x08},
        {0x0822, 0x00},
        {0x0823, 0x00},
        {0x080a, 0x00},
        {0x080b, 0x7f},
        {0x080c, 0x00},
        {0x080d, 0x4f},
        {0x080e, 0x00},
        {0x080f, 0x77},
        {0x0810, 0x00},
        {0x0811, 0x5f},
        {0x0812, 0x00},
        {0x0813, 0x57},
        {0x0814, 0x00},
        {0x0815, 0x4f},
        {0x0816, 0x01},
        {0x0817, 0x27},
        {0x0818, 0x00},
        {0x0819, 0x3f},
        {0xe04c, 0x00},
        {0xe04d, 0x7f},
        {0xe04e, 0x00},
        {0xe04f, 0x1f},
        {0x3e20, 0x01},
        {0x3e37, 0x00},
        {0x3f50, 0x00},
        {0x3f56, 0x01},
        {0x3f57, 0x6c},
		{REG_MODE_SEL, 0x01},
        {SEQUENCE_END, 0x00}
};
struct reginfo cfg2_imx477_1920x1080p[] =
{
	{0x0112, 0x0A},
	{0x0113, 0x0A},
	{0x0114, 0x01},
	{0x0342, 0x23},
	{0x0343, 0x40},
	{0x0340, 0x06},
	{0x0341, 0x0F},
	{0x0344, 0x00},
	{0x0345, 0x00},
	{0x0346, 0x01},
	{0x0347, 0x78},
	{0x0348, 0x0F},
	{0x0349, 0xD7},
	{0x034A, 0x0A},
	{0x034B, 0x67},
	{0x00E3, 0x00},
	{0x00E4, 0x00},
	{0x00FC, 0x0A},
	{0x00FD, 0x0A},
	{0x00FE, 0x0A},
	{0x00FF, 0x0A},
	{0x0220, 0x00},
	{0x0221, 0x11},
	{0x0381, 0x01},
	{0x0383, 0x01},
	{0x0385, 0x01},
	{0x0387, 0x01},
	{0x0900, 0x01},
	{0x0901, 0x22},
	{0x0902, 0x02},
	{0x3140, 0x02},
	{0x3C00, 0x00},
	{0x3C01, 0x01},
	{0x3C02, 0x9C},
	{0x3F0D, 0x00},
	{0x5748, 0x00},
	{0x5749, 0x00},
	{0x574A, 0x00},
	{0x574B, 0xA4},
	{0x7B75, 0x0E},
	{0x7B76, 0x09},
	{0x7B77, 0x08},
	{0x7B78, 0x06},
	{0x7B79, 0x34},
	{0x7B53, 0x00},
	{0x9369, 0x73},
	{0x936B, 0x64},
	{0x936D, 0x5F},
	{0x9304, 0x03},
	{0x9305, 0x80},
	{0x9E9A, 0x2F},
	{0x9E9B, 0x2F},
	{0x9E9C, 0x2F},
	{0x9E9D, 0x00},
	{0x9E9E, 0x00},
	{0x9E9F, 0x00},
	{0xA2A9, 0x27},
	{0xA2B7, 0x03},
	{0x0401, 0x00},
	{0x0404, 0x00},
	{0x0405, 0x10},
	{0x0408, 0x00},
	{0x0409, 0x36},
	{0x040A, 0x00},
	{0x040B, 0x20},
	{0x040C, 0x07},
	{0x040D, 0x80},
	{0x040E, 0x04},
	{0x040F, 0x38},
	{0x034C, 0x07},
	{0x034D, 0x80},
	{0x034E, 0x04},
	{0x034F, 0x38},
	{0x0301, 0x05},
	{0x0303, 0x02},
	{0x0305, 0x02},
	{0x0306, 0x00},
	{0x0307, 0xAF},
	{0x0309, 0x0A},
	{0x030B, 0x01},
	{0x030D, 0x03},
	{0x030E, 0x00},
	{0x030F, 0x96},
	{0x0310, 0x01},
	{0x0820, 0x09},
	{0x0821, 0x60},
	{0x0822, 0x00},
	{0x0823, 0x00},
	{0x080A, 0x00},
	{0x080B, 0x87},
	{0x080C, 0x00},
	{0x080D, 0x4F},
	{0x080E, 0x00},
	{0x080F, 0x87},
	{0x0810, 0x00},
	{0x0811, 0x5F},
	{0x0812, 0x00},
	{0x0813, 0x5F},
	{0x0814, 0x00},
	{0x0815, 0x4F},
	{0x0816, 0x01},
	{0x0817, 0x3F},
	{0x0818, 0x00},
	{0x0819, 0x3F},
	{0xE04C, 0x00},
	{0xE04D, 0x87},
	{0xE04E, 0x00},
	{0xE04F, 0x1F},
	{0x3E20, 0x01},
	{0x3E37, 0x00},
	{0x3F50, 0x00},
	{0x3F56, 0x01},
	{0x3F57, 0x02},
	{0X3FF9, 0x01},
	{REG_MODE_SEL, 0x01},
	{SEQUENCE_END, 0x00}
};
int ov5640_read(XIicPs *IicInstance,u16 addr,u8 *read_buf)
{
	*read_buf=i2c_reg16_read(IicInstance,IIC_OV5640_ADDR,addr);
	return XST_SUCCESS;
}
int imx219_read(XIicPs *IicInstance,u16 addr,u8 *read_buf)
{
	*read_buf=i2c_reg16_read(IicInstance,IIC_IMX219_ADDR,addr);
	return XST_SUCCESS;
}
int imx477_read(XIicPs *IicInstance,u16 addr,u8 *read_buf)
{
	*read_buf=i2c_reg16_read(IicInstance,IIC_IMX477_ADDR,addr);
	return XST_SUCCESS;
}
int scan_read(XIicPs *IicInstance,u16 addr,u8 *read_buf,u16 scan_addr)
{
	*read_buf=i2c_reg16_read(IicInstance,scan_addr,addr);
	return XST_SUCCESS;
}
int ov5640_write(XIicPs *IicInstance,u16 addr,u8 data)
{
	return i2c_reg16_write(IicInstance,IIC_OV5640_ADDR,addr,data);
}
int imx219_write(XIicPs *IicInstance,u16 addr,u8 data)
{
	return i2c_reg16_write(IicInstance,IIC_IMX219_ADDR,addr,data);
}
int imx477_write(XIicPs *IicInstance,u16 addr,u8 data)
{
	return i2c_reg16_write(IicInstance,IIC_IMX477_ADDR,addr,data);
}
int ov5640_soft_write(XIicPs *IicInstance,u16 addr,u8 data)
{
	return i2c_reg16_write(IicInstance,0x74,addr,data);
}

void ov5640_sensor_write_array(XIicPs *IicInstance, struct reginfo *regarray)
{
	int i = 0;
	while (regarray[i].reg != SEQUENCE_END) {
		ov5640_write(IicInstance,regarray[i].reg,regarray[i].val);
		i++;
	}
}
void imx219_sensor_write_array(XIicPs *IicInstance, struct reginfo *regarray)
{
	int i = 0;
	while (regarray[i].reg != SEQUENCE_END) {
		imx219_write(IicInstance,regarray[i].reg,regarray[i].val);
		i++;
	}
}
void imx_477_sensor_write_array(XIicPs *IicInstance, struct reginfo *regarray)
{
	int i = 0;
	while (regarray[i].reg != SEQUENCE_END) {
		imx477_write(IicInstance,regarray[i].reg,regarray[i].val);
		i++;
	}
}

int write_imx219_camera_reg(XIicPs *IicInstance,u16 addr,u8 data)
{
    imx219_write(IicInstance,addr,data);
    printf("IMX219 Reg Address = %x, Wrote Value = %x \n",addr,data);

}

int read_imx219_camera_reg(XIicPs *IicInstance,u16 addr)
{
    int Status;
	u8 sensor_id[2];
	Status = imx219_read(IicInstance,addr,&sensor_id[0]);

    printf("IMX219 Reg Address = %x, Read Value = %x \n",addr,sensor_id[0]);

}

int write_read_imx219_camera_reg(XIicPs *IicInstance,u16 addr,u8 data)
{
    write_imx219_camera_reg(IicInstance,addr,data);
    read_imx219_camera_reg(IicInstance,addr);

}
int ov5640_camera_sensor_init(XIicPs *IicInstance)
{
	u8 sensor_id[2] ;
	ov5640_read(IicInstance, 0x300A, &sensor_id[0]);
	ov5640_read(IicInstance, 0x300B, &sensor_id[1]);
	if (sensor_id[0] != 0x56 || sensor_id[1] != 0x40)
	{
		xil_printf("Not OV5640 id: %x %x\r\n", sensor_id[0], sensor_id[1]);
		return XST_FAILURE;
	}
	else
	{
		xil_printf("Got OV5640 id: %x %x\r\n", sensor_id[0], sensor_id[1]);

	//[1]=0 System input clock from pad; Default read = 0x11
	ov5640_write(IicInstance,0x3103,0x11);
	//[7]=1 Software reset; [6]=0 Software power down; Default=0x02
	ov5640_write(IicInstance,0x3008, 0x82);
	usleep(1000000);
	ov5640_sensor_write_array(IicInstance,cfg_ov5640_init_data);
	usleep(1000000);
	//[7]=0 Software reset; [6]=1 Software power down; Default=0x02
	ov5640_write(IicInstance,0x3008, 0x42);
    #if P1080 == 1
	//1080p 30fps
	ov5640_sensor_write_array(IicInstance,cfg_ov5640_1920_1080p_30fps);
    #else
	//720p 60fps
	ov5640_sensor_write_array(IicInstance,cfg_ov5640_1280_702p_60fps);
    #endif
	ov5640_sensor_write_array(IicInstance,cfg_ov5640_advanced_awb);
	//[7]=0 Software reset; [6]=0 Software power down; Default=0x02
	ov5640_write(IicInstance,0x3008, 0x02);
	}
	return 0;
}
int imx219_camera_sensor_init(XIicPs *IicInstance)
{
	u8 sensor_id[2] ;
	imx219_read(IicInstance, 0x0000, &sensor_id[0]);
	imx219_read(IicInstance, 0x0001, &sensor_id[1]);
	if (sensor_id[0] != 0x2 || sensor_id[1] != 0x19)
	{
		printf("Not IMX219 camera sensor id: %x %x\n", sensor_id[0], sensor_id[1]);
	return XST_FAILURE;
	}
	else
	{
		printf("Got IMX219 camera sensor id: %x %x\r\n", sensor_id[0], sensor_id[1]);
        usleep(10000);
        #if P1080 == 1
        imx219_sensor_write_array(IicInstance,cfg1_imx219_1920_1080p_60fps);
        #else
        imx219_sensor_write_array(IicInstance,cfg_imx219_1280_702p_60fps);
        #endif
        imx219_write(IicInstance, IMX219_ANA_GAIN_GLOBAL, 230);
    	imx219_read(IicInstance, 0x0158, &sensor_id[0]);
    	imx219_read(IicInstance, 0x0159, &sensor_id[1]);
    	printf("Read imx219 id 0x0158: %x  id 0x0159: %x\n", sensor_id[0], sensor_id[1]);


        //imx219_write(IicInstance, 0x0190, 1);
//    	imx219_read(IicInstance, 0x0190, &sensor_id[0]);
//    	printf("Read imx219 id 0x0190 LSC_ENABLE_A                  = %x\n",sensor_id[0]);
//
//    	imx219_read(IicInstance, 0x0191, &sensor_id[0]);
//    	printf("Read imx219 id 0x0191 LSC_COLOR_MODE_A              = %x\n",sensor_id[0]);
//
//    	imx219_read(IicInstance, 0x0192, &sensor_id[0]);
//    	printf("Read imx219 id 0x0192 LSC_SELECT_TABLE_A            = %x\n",sensor_id[0]);
//
//        //imx219_write(IicInstance, 0x0193, 1);
//    	imx219_read(IicInstance, 0x0193, &sensor_id[0]);
//    	printf("Read imx219 id 0x0193 LSC_TUNING_ENABLE_A           = %x\n",sensor_id[0]);
//
//        imx219_write(IicInstance, 0x0194, 0);
//    	imx219_read(IicInstance, 0x0194, &sensor_id[0]);
//    	printf("Read imx219 id 0x0194 LSC_WHITE_BALANCE_RG_A[15:8]  = %x\n",sensor_id[0]);
//
//        imx219_write(IicInstance, 0x0195, 50);
//    	imx219_read(IicInstance, 0x0195, &sensor_id[0]);
//    	printf("Read imx219 id 0x0195 LSC_WHITE_BALANCE_RG_A[7:0]   = %x\n",sensor_id[0]);
//
//    	imx219_read(IicInstance, 0x0198, &sensor_id[0]);
//    	printf("Read imx219 id 0x0198 LSC_TUNING_COEF_R_A   = %x\n",sensor_id[0]);
//
//        imx219_write(IicInstance, 0x0199, 50);
//    	imx219_read(IicInstance, 0x0199, &sensor_id[0]);
//    	printf("Read imx219 id 0x0199 LSC_TUNING_COEF_GR_A  = %x\n",sensor_id[0]);
//
//        imx219_write(IicInstance, 0x019A, 50);
//    	imx219_read(IicInstance, 0x019A, &sensor_id[0]);
//    	printf("Read imx219 id 0x019A LSC_TUNING_COEF_GB_A  = %x\n",sensor_id[0]);
//
//
//    	imx219_read(IicInstance, 0x019B, &sensor_id[0]);
//    	printf("Read imx219 id 0x019B LSC_TUNING_COEF_B_A   = %x\n",sensor_id[0]);
//
//
//    	imx219_read(IicInstance, 0x019C, &sensor_id[0]);
//    	printf("Read imx219 id 0x019C LSC_TUNING_R_A[12:8]  = %x\n",sensor_id[0]);
//
//
//    	imx219_read(IicInstance, 0x019D, &sensor_id[0]);
//    	printf("Read imx219 id 0x019D LSC_TUNING_R_A[7:0]   = %x\n",sensor_id[0]);
//
//
//        imx219_write(IicInstance, 0x019E, 0);
//    	imx219_read(IicInstance, 0x019E, &sensor_id[0]);
//    	printf("Read imx219 id 0x019E LSC_TUNING_GR_A[12:8] = %x\n",sensor_id[0]);
//
//
//        imx219_write(IicInstance, 0x019F, 50);
//    	imx219_read(IicInstance, 0x019F, &sensor_id[0]);
//    	printf("Read imx219 id 0x019F LSC_TUNING_GR_A[7:0]  = %x\n",sensor_id[0]);
//
//        imx219_write(IicInstance, 0x01A0, 0);
//    	imx219_read(IicInstance, 0x01A0, &sensor_id[0]);
//    	printf("Read imx219 id 0x01A0 LSC_TUNING_GB_A[12:8] = %x\n",sensor_id[0]);
//
//
//        imx219_write(IicInstance, 0x01A1, 50);
//    	imx219_read(IicInstance, 0x01A1, &sensor_id[0]);
//    	printf("Read imx219 id 0x01A1 LSC_TUNING_GB_A[7:0]  = %x\n",sensor_id[0]);
//
//        imx219_write(IicInstance, 0x01A2, 0);
//    	imx219_read(IicInstance, 0x01A2, &sensor_id[0]);
//    	printf("Read imx219 id 0x01A2 LSC_TUNING_B_A[12:8]  = %x\n",sensor_id[0]);
//
//        imx219_write(IicInstance, 0x01A3, 50);
//    	imx219_read(IicInstance, 0x01A3, &sensor_id[0]);
//    	printf("Read imx219 id 0x01A3 LSC_TUNING_B_A[7:0]   = %x\n",sensor_id[0]);
	return XST_SUCCESS;
	}
}
//int imx477_sensor_init(XIicPs *IicInstance)
//{
//	u8 sensor_id[2];
//	imx477_read(IicInstance, 0x16, &sensor_id[0]);
//	imx477_read(IicInstance, 0x17, &sensor_id[1]);
//	imx477_read(IicInstance, 0x16, &sensor_id[0]);
//	imx477_read(IicInstance, 0x17, &sensor_id[1]);
//	imx477_read(IicInstance, 0x16, &sensor_id[0]);
//	imx477_read(IicInstance, 0x17, &sensor_id[1]);
//	imx477_read(IicInstance, 0x16, &sensor_id[0]);
//	imx477_read(IicInstance, 0x17, &sensor_id[1]);
//	imx477_read(IicInstance, 0x16, &sensor_id[0]);
//	imx477_read(IicInstance, 0x17, &sensor_id[1]);
//	imx477_read(IicInstance, 0x16, &sensor_id[0]);
//	imx477_read(IicInstance, 0x17, &sensor_id[1]);
//	printf("Id @ address... ====  %x %x\r\n", sensor_id[0], sensor_id[1]);
//
//	imx_477_sensor_write_array(IicInstance,cfg1_imx477_mode_common);
//	usleep(1000000);
//	imx_477_sensor_write_array(IicInstance,cfg2_imx477_1920x1080p);
//	usleep(1000000);
//	imx477_read(IicInstance, 0x16, &sensor_id[0]);
//	imx477_read(IicInstance, 0x17, &sensor_id[1]);
//	printf("Id @ address ====  %x %x\r\n", sensor_id[0], sensor_id[1]);
//	return 0;
//}


int imx477_sensor_init(XIicPs *IicInstance)
{
	u8 sensor_id[2];
	for(int address = 100; address < 155; address++ )
	 {
			scan_read(IicInstance, 0x0016, &sensor_id[0],address);
			scan_read(IicInstance, 0x0017, &sensor_id[1],address);
	 }
	if (sensor_id[0] != 0x7 || sensor_id[1] != 0x7)
	{
		printf("Not IMX477 Camera Sensor ID: %x %x\n", sensor_id[0], sensor_id[1]);
	}
	else
	{
		printf("Got IMX477 Camera Sensor ID: 4%x%x\r\n", sensor_id[0], sensor_id[1]);
		imx_477_sensor_write_array(IicInstance,cfg1_imx477_mode_common);
		usleep(1000000);
		imx_477_sensor_write_array(IicInstance,cfg2_imx477_1920x1080p);
		usleep(1000000);
	}
    
    	//imx477_read(IicInstance, IMX477_DIG_GLOBAL_GAIN, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GLOBAL_GAIN                  = %x\n",sensor_id[0]);
        //
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_GR_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_GR_U                  = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_GR_L, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_GR_L                  = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_R_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_R_U                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_R_L, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_R_L                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_B_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_B_U                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_B_L, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_B_L                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_R_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_R_U                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_GB_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_GB_L                  = %x\n",sensor_id[0]);
        
        
        //imx219_write(IicInstance, IMX477_DIG_GLOBAL_GAIN, 0);
        //imx219_write(IicInstance, IMX477_DIG_GAIN_R_U, 0xf);
        //imx219_write(IicInstance, IMX477_DIG_GAIN_R_L, 0xff);
        
        
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_GR_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_GR_U                  = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_GR_L, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_GR_L                  = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_R_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_R_U                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_R_L, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_R_L                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_B_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_B_U                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_B_L, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_B_L                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_R_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_R_U                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_DIG_GAIN_GB_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_DIG_GAIN_GB_L                  = %x\n",sensor_id[0]);
        
        
    	//imx477_read(IicInstance, IMX477_ANA_GLOBAL_GAIN_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_ANA_GLOBAL_GAIN_U                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_ANA_GLOBAL_GAIN_L, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_ANA_GLOBAL_GAIN_L                  = %x\n",sensor_id[0]);
        //imx219_write(IicInstance, IMX477_ANA_GLOBAL_GAIN_U, 0x3);
        //imx219_write(IicInstance, IMX477_ANA_GLOBAL_GAIN_L, 0xc8);
        //
    	//imx477_read(IicInstance, IMX477_ANA_GLOBAL_GAIN_U, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_ANA_GLOBAL_GAIN_U                   = %x\n",sensor_id[0]);
    	//imx477_read(IicInstance, IMX477_ANA_GLOBAL_GAIN_L, &sensor_id[0]);
    	//printf("Read IMX477 Reg: IMX477_ANA_GLOBAL_GAIN_L                  = %x\n",sensor_id[0]);
        
        imx477_read(IicInstance, IMX477_REG_ORIENTATION, &sensor_id[0]);
        printf("Read IMX477 Reg: IMX477_REG_ORIENTATION                   = %x\n",sensor_id[0]);
        imx219_write(IicInstance, IMX477_REG_ORIENTATION, 0x1);
	return 0;
}


int scan_sensor(XIicPs *IicInstance)
{
	u8 sensorid[2];
	u8 sensor_ids[2];
	u8 sensor_id[2];
	for(int address = 100; address < 156; address++ )
	 {
		if (sensor_id[0] != 0x4 || sensor_id[1] != 0x77)
		{
			scan_read(IicInstance, 0x0016, &sensor_id[0],address);
			scan_read(IicInstance, 0x0017, &sensor_id[1],address);
		}
		else
		{
			printf("Got imx477.. id, %x %x\r\n", sensorid[0], sensor_id[1]);
		}
		printf("Id @ address ==== %x is %x %x\r\n",address, sensor_id[0], sensor_id[1]);
	 }
		scan_read(IicInstance, 0x0016, &sensorid[0],0x9a);
		scan_read(IicInstance, 0x0017, &sensorid[1],0x9a);
		printf("Read Again imx477 id, %x %x\r\n", sensorid[0], sensorid[1]);
	for(int address = 840; address < 849; address++ )
	 {
		imx477_read(IicInstance, address, &sensor_ids[0]);
		printf("Id @ address ==== %x is %x\r\n",address, sensor_ids[0]);
	 }

	return 0;
}
