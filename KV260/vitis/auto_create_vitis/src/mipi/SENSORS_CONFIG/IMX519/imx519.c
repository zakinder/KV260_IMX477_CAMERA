/*
   MODIFICATION HISTORY:
   
   Ver   Who Date     Changes
   ----- -------- -------- -----------------------------------------------
   1.0	 Sakinder 06/01/22 Initial Release
   1.4   Sakinder 07/01/22 Added IMX519 Camera functions.
   -----------------------------------------------------------------------
*/
#include "imx519.h"
#include <xil_types.h>
#include <stdio.h>
#include <xstatus.h>
#include "xiicps.h"
#include "xparameters.h"
#include "sleep.h"
#include <xil_printf.h>
#include "../../config.h"
#include "../I2c_transections.h"
#include "../init_camera.h"
#include "../imx_registers.h"
#define IIC_IMX519_ADDR  	        0x9A
#define IMX519_REG_CHIP_ID		    0x0016
#define IMX519_CHIP_ID			    0x0519

struct reginfo cfg_imx519_mode_common_regs[] =
{
	{REG_EXCK_FREQ_MSB, 0x18},
	{REG_EXCK_FREQ_LSB, 0x00},
	{0x3c7e, 0x01},
	{0x3c7f, 0x07},
	{0x3020, 0x00},
	{0x3e35, 0x01},
	{0x3f7f, 0x01},
	{0x5609, 0x57},
	{0x5613, 0x51},
	{0x561f, 0x5e},
	{0x5623, 0xd2},
	{0x5637, 0x11},
	{0x5657, 0x11},
	{0x5659, 0x12},
	{0x5733, 0x60},
	{0x5905, 0x57},
	{0x590f, 0x51},
	{0x591b, 0x5e},
	{0x591f, 0xd2},
	{0x5933, 0x11},
	{0x5953, 0x11},
	{0x5955, 0x12},
	{0x5a2f, 0x60},
	{0x5a85, 0x57},
	{0x5a8f, 0x51},
	{0x5a9b, 0x5e},
	{0x5a9f, 0xd2},
	{0x5ab3, 0x11},
	{0x5ad3, 0x11},
	{0x5ad5, 0x12},
	{0x5baf, 0x60},
	{0x5c15, 0x2a},
	{0x5c17, 0x80},
	{0x5c19, 0x31},
	{0x5c1b, 0x87},
	{0x5c25, 0x25},
	{0x5c27, 0x7b},
	{0x5c29, 0x2a},
	{0x5c2b, 0x80},
	{0x5c2d, 0x31},
	{0x5c2f, 0x87},
	{0x5c35, 0x2b},
	{0x5c37, 0x81},
	{0x5c39, 0x31},
	{0x5c3b, 0x87},
	{0x5c45, 0x25},
	{0x5c47, 0x7b},
	{0x5c49, 0x2a},
	{0x5c4b, 0x80},
	{0x5c4d, 0x31},
	{0x5c4f, 0x87},
	{0x5c55, 0x2d},
	{0x5c57, 0x83},
	{0x5c59, 0x32},
	{0x5c5b, 0x88},
	{0x5c65, 0x29},
	{0x5c67, 0x7f},
	{0x5c69, 0x2e},
	{0x5c6b, 0x84},
	{0x5c6d, 0x32},
	{0x5c6f, 0x88},
	{0x5e69, 0x04},
	{0x5e9d, 0x00},
	{0x5f18, 0x10},
	{0x5f1a, 0x0e},
	{0x5f20, 0x12},
	{0x5f22, 0x10},
	{0x5f24, 0x0e},
	{0x5f28, 0x10},
	{0x5f2a, 0x0e},
	{0x5f30, 0x12},
	{0x5f32, 0x10},
	{0x5f34, 0x0e},
	{0x5f38, 0x0f},
	{0x5f39, 0x0d},
	{0x5f3c, 0x11},
	{0x5f3d, 0x0f},
	{0x5f3e, 0x0d},
	{0x5f61, 0x07},
	{0x5f64, 0x05},
	{0x5f67, 0x03},
	{0x5f6a, 0x03},
	{0x5f6d, 0x07},
	{0x5f70, 0x07},
	{0x5f73, 0x05},
	{0x5f76, 0x02},
	{0x5f79, 0x07},
	{0x5f7c, 0x07},
	{0x5f7f, 0x07},
	{0x5f82, 0x07},
	{0x5f85, 0x03},
	{0x5f88, 0x02},
	{0x5f8b, 0x01},
	{0x5f8e, 0x01},
	{0x5f91, 0x04},
	{0x5f94, 0x05},
	{0x5f97, 0x02},
	{0x5f9d, 0x07},
	{0x5fa0, 0x07},
	{0x5fa3, 0x07},
	{0x5fa6, 0x07},
	{0x5fa9, 0x03},
	{0x5fac, 0x01},
	{0x5faf, 0x01},
	{0x5fb5, 0x03},
	{0x5fb8, 0x02},
	{0x5fbb, 0x01},
	{0x5fc1, 0x07},
	{0x5fc4, 0x07},
	{0x5fc7, 0x07},
	{0x5fd1, 0x00},
	{0x6302, 0x79},
	{0x6305, 0x78},
	{0x6306, 0xa5},
	{0x6308, 0x03},
	{0x6309, 0x20},
	{0x630b, 0x0a},
	{0x630d, 0x48},
	{0x630f, 0x06},
	{0x6311, 0xa4},
	{0x6313, 0x03},
	{0x6314, 0x20},
	{0x6316, 0x0a},
	{0x6317, 0x31},
	{0x6318, 0x4a},
	{0x631a, 0x06},
	{0x631b, 0x40},
	{0x631c, 0xa4},
	{0x631e, 0x03},
	{0x631f, 0x20},
	{0x6321, 0x0a},
	{0x6323, 0x4a},
	{0x6328, 0x80},
	{0x6329, 0x01},
	{0x632a, 0x30},
	{0x632b, 0x02},
	{0x632c, 0x20},
	{0x632d, 0x02},
	{0x632e, 0x30},
	{0x6330, 0x60},
	{0x6332, 0x90},
	{0x6333, 0x01},
	{0x6334, 0x30},
	{0x6335, 0x02},
	{0x6336, 0x20},
	{0x6338, 0x80},
	{0x633a, 0xa0},
	{0x633b, 0x01},
	{0x633c, 0x60},
	{0x633d, 0x02},
	{0x633e, 0x60},
	{0x633f, 0x01},
	{0x6340, 0x30},
	{0x6341, 0x02},
	{0x6342, 0x20},
	{0x6343, 0x03},
	{0x6344, 0x80},
	{0x6345, 0x03},
	{0x6346, 0x90},
	{0x6348, 0xf0},
	{0x6349, 0x01},
	{0x634a, 0x20},
	{0x634b, 0x02},
	{0x634c, 0x10},
	{0x634d, 0x03},
	{0x634e, 0x60},
	{0x6350, 0xa0},
	{0x6351, 0x01},
	{0x6352, 0x60},
	{0x6353, 0x02},
	{0x6354, 0x50},
	{0x6355, 0x02},
	{0x6356, 0x60},
	{0x6357, 0x01},
	{0x6358, 0x30},
	{0x6359, 0x02},
	{0x635a, 0x30},
	{0x635b, 0x03},
	{0x635c, 0x90},
	{0x635f, 0x01},
	{0x6360, 0x10},
	{0x6361, 0x01},
	{0x6362, 0x40},
	{0x6363, 0x02},
	{0x6364, 0x50},
	{0x6368, 0x70},
	{0x636a, 0xa0},
	{0x636b, 0x01},
	{0x636c, 0x50},
	{0x637d, 0xe4},
	{0x637e, 0xb4},
	{0x638c, 0x8e},
	{0x638d, 0x38},
	{0x638e, 0xe3},
	{0x638f, 0x4c},
	{0x6390, 0x30},
	{0x6391, 0xc3},
	{0x6392, 0xae},
	{0x6393, 0xba},
	{0x6394, 0xeb},
	{0x6395, 0x6e},
	{0x6396, 0x34},
	{0x6397, 0xe3},
	{0x6398, 0xcf},
	{0x6399, 0x3c},
	{0x639a, 0xf3},
	{0x639b, 0x0c},
	{0x639c, 0x30},
	{0x639d, 0xc1},
	{0x63b9, 0xa3},
	{0x63ba, 0xfe},
	{0x7600, 0x01},
	{0x79a0, 0x01},
	{0x79a1, 0x01},
	{0x79a2, 0x01},
	{0x79a3, 0x01},
	{0x79a4, 0x01},
	{0x79a5, 0x20},
	{0x79a9, 0x00},
	{0x79aa, 0x01},
	{0x79ad, 0x00},
	{0x79af, 0x00},
	{0x8173, 0x01},
	{0x835c, 0x01},
	{0x8a74, 0x01},
	{0x8c1f, 0x00},
	{0x8c27, 0x00},
	{0x8c3b, 0x03},
	{0x9004, 0x0b},
	{0x920c, 0x6a},
	{0x920d, 0x22},
	{0x920e, 0x6a},
	{0x920f, 0x23},
	{0x9214, 0x6a},
	{0x9215, 0x20},
	{0x9216, 0x6a},
	{0x9217, 0x21},
	{0x9385, 0x3e},
	{0x9387, 0x1b},
	{0x938d, 0x4d},
	{0x938f, 0x43},
	{0x9391, 0x1b},
	{0x9395, 0x4d},
	{0x9397, 0x43},
	{0x9399, 0x1b},
	{0x939d, 0x3e},
	{0x939f, 0x2f},
	{0x93a5, 0x43},
	{0x93a7, 0x2f},
	{0x93a9, 0x2f},
	{0x93ad, 0x34},
	{0x93af, 0x2f},
	{0x93b5, 0x3e},
	{0x93b7, 0x2f},
	{0x93bd, 0x4d},
	{0x93bf, 0x43},
	{0x93c1, 0x2f},
	{0x93c5, 0x4d},
	{0x93c7, 0x43},
	{0x93c9, 0x2f},
	{0x974b, 0x02},
	{0x995c, 0x8c},
	{0x995d, 0x00},
	{0x995e, 0x00},
	{0x9963, 0x64},
	{0x9964, 0x50},
	{0xaa0a, 0x26},
	{0xae03, 0x04},
	{0xae04, 0x03},
	{0xae05, 0x03},
	{0xbc1c, 0x08},
	{0xbcf1, 0x02},
	{SEQUENCE_END, 0x00}
};
/* 16 mpix 10fps */
struct reginfo cfg_imx519_mode_4656x3496_regs[] =
{
	{0x0111, 0x02},
	{REG_CSI_FORMAT_C, 0x0a},
	{REG_CSI_FORMAT_D, 0x0a},
	{REG_CSI_LANE, 0x01},
	{REG_LINE_LEN_MSB, 0x42},
	{REG_LINE_LEN_LSB, 0x00},
	{REG_FRAME_LEN_MSB, 0x0d},
	{REG_FRAME_LEN_LSB, 0xf4},
	{0x0344, 0x00},
	{0x0345, 0x00},
	{0x0346, 0x00},
	{0x0347, 0x00},
	{0x0348, 0x12},
	{0x0349, 0x2f},
	{0x034a, 0x0d},
	{0x034b, 0xa7},
	{0x0220, 0x00},
	{0x0221, 0x11},
	{0x0222, 0x01},
	{REG_BINNING_MODE, 0x00},
	{REG_BINNING_HV, 0x11},
	{REG_BINNING_WEIGHTING, 0x0a},
	{0x3f4c, 0x01},
	{0x3f4d, 0x01},
	{0x4254, 0x7f},
	{0x0401, 0x00},
	{0x0404, 0x00},
	{0x0405, 0x10},
	{0x0408, 0x00},
	{0x0409, 0x00},
	{0x040a, 0x00},
	{0x040b, 0x00},
	{0x040c, 0x12},
	{0x040d, 0x30},
	{0x040e, 0x0d},
	{0x040f, 0xa8},
	{0x034c, 0x12},
	{0x034d, 0x30},
	{0x034e, 0x0d},
	{0x034f, 0xa8},
	{REG_IVTPXCK_DIV, 0x06},
	{REG_IVTSYCK_DIV, 0x04},
	{REG_IVT_PREPLLCK_DIV, 0x04},
	{REG_PLL_IVT_MPY_MSB, 0x01},
	{REG_PLL_IVT_MPY_LSB, 0x57},
	{REG_IOPPXCK_DIV, 0x0a},
	{REG_IOPSYCK_DIV, 0x02},
	{REG_IOP_PREPLLCK_DIV, 0x04},
	{REG_IOP_MPY_MSB, 0x01},
	{REG_IOP_MPY_LSB, 0x49},
	{REG_PLL_MULTI_DRV, 0x01},
	{REG_REQ_LINK_BIT_RATE_MSB, 0x07},
	{REG_REQ_LINK_BIT_RATE_LMSB, 0xb6},
	{REG_REQ_LINK_BIT_RATE_MLSB, 0x00},
	{REG_REQ_LINK_BIT_RATE_LSB, 0x00},
	{0x3e20, 0x01},
	{0x3e37, 0x00},
	{0x3e3b, 0x00},
	{0x0106, 0x00},
	{0x0b00, 0x00},
	{0x3230, 0x00},
	{0x3f14, 0x01},
	{0x3f3c, 0x01},
	{REG_ADC_BIT_SETTING, 0x0a},
	{0x3fbc, 0x00},
	{0x3c06, 0x00},
	{0x3c07, 0x48},
	{0x3c0a, 0x00},
	{0x3c0b, 0x00},
	{0x3f78, 0x00},
	{0x3f79, 0x40},
	{0x3f7c, 0x00},
	{0x3f7d, 0x00},
	{REG_MODE_SEL, 0x01},
	{SEQUENCE_END, 0x00}
};
/* 4k 21fps mode */
struct reginfo cfg_imx519_mode_3840x2160_regs[] =
{
	{0x0111, 0x02},
	{REG_CSI_FORMAT_C, 0x0a},
	{REG_CSI_FORMAT_D, 0x0a},
	{REG_CSI_LANE, 0x01},
	{REG_LINE_LEN_MSB, 0x38},
	{REG_LINE_LEN_LSB, 0x70},
	{REG_FRAME_LEN_MSB, 0x08},
	{REG_FRAME_LEN_LSB, 0xd4},
	{0x0344, 0x01},
	{0x0345, 0x98},
	{0x0346, 0x02},
	{0x0347, 0xa0},
	{0x0348, 0x10},
	{0x0349, 0x97},
	{0x034a, 0x0b},
	{0x034b, 0x17},
	{0x0220, 0x00},
	{0x0221, 0x11},
	{0x0222, 0x01},
	{REG_BINNING_MODE, 0x00},
	{REG_BINNING_HV, 0x11},
	{REG_BINNING_WEIGHTING, 0x0a},
	{0x3f4c, 0x01},
	{0x3f4d, 0x01},
	{0x4254, 0x7f},
	{0x0401, 0x00},
	{0x0404, 0x00},
	{0x0405, 0x10},
	{0x0408, 0x00},
	{0x0409, 0x00},
	{0x040a, 0x00},
	{0x040b, 0x00},
	{0x040c, 0x0f},
	{0x040d, 0x00},
	{0x040e, 0x08},
	{0x040f, 0x70},
	{0x034c, 0x0f},
	{0x034d, 0x00},
	{0x034e, 0x08},
	{0x034f, 0x70},
	{REG_IVTPXCK_DIV, 0x06},
	{REG_IVTSYCK_DIV, 0x04},
	{REG_IVT_PREPLLCK_DIV, 0x04},
	{REG_PLL_IVT_MPY_MSB, 0x01},
	{REG_PLL_IVT_MPY_LSB, 0x57},
	{REG_IOPPXCK_DIV, 0x0a},
	{REG_IOPSYCK_DIV, 0x02},
	{REG_IOP_PREPLLCK_DIV, 0x04},
	{REG_IOP_MPY_MSB, 0x01},
	{REG_IOP_MPY_LSB, 0x49},
	{REG_PLL_MULTI_DRV, 0x01},
	{REG_REQ_LINK_BIT_RATE_MSB, 0x07},
	{REG_REQ_LINK_BIT_RATE_LMSB, 0xb6},
	{REG_REQ_LINK_BIT_RATE_MLSB, 0x00},
	{REG_REQ_LINK_BIT_RATE_LSB, 0x00},
	{0x3e20, 0x01},
	{0x3e37, 0x00},
	{0x3e3b, 0x00},
	{0x0106, 0x00},
	{0x0b00, 0x00},
	{0x3230, 0x00},
	{0x3f14, 0x01},
	{0x3f3c, 0x01},
	{REG_ADC_BIT_SETTING, 0x0a},
	{0x3fbc, 0x00},
	{0x3c06, 0x00},
	{0x3c07, 0x48},
	{0x3c0a, 0x00},
	{0x3c0b, 0x00},
	{0x3f78, 0x00},
	{0x3f79, 0x40},
	{0x3f7c, 0x00},
	{0x3f7d, 0x00},
	{REG_MODE_SEL, 0x01},
	{SEQUENCE_END, 0x00}
};
/* 2x2 binned 30fps mode */
struct reginfo cfg_imx519_mode_2328x1748_regs[] =
{
	/* MIPI output setting */
	{REG_CSI_FORMAT_C, 0x0a},
	{REG_CSI_FORMAT_D, 0x0a},
	{REG_CSI_LANE, 0x01},
	/* Frame Length Lines Setting */
	{REG_FRAME_LEN_MSB, 0x09},
	{REG_FRAME_LEN_LSB, 0xac},
	/* ROI Setting */
	{0x0344, 0x00},
	{0x0345, 0x00},
	{0x0346, 0x00},
	{0x0347, 0x00},
	{0x0348, 0x12},
	{0x0349, 0x2f},
	{0x034a, 0x0d},
	{0x034b, 0xa7},
	{0x0220, 0x00},
	{0x0221, 0x11},
	{0x0222, 0x01},
	/* Mode Setting */
	{REG_BINNING_MODE, 0x01},
	{REG_BINNING_HV, 0x22},
	{REG_BINNING_WEIGHTING, 0x0a},
	{0x3f4c, 0x01},
	{0x3f4d, 0x01},
	{0x4254, 0x7f},
	{0x0401, 0x00},
	{0x0404, 0x00},
	{0x0405, 0x10},
	/* Digital Crop & Scaling */
	{0x0408, 0x00},
	{0x0409, 0x00},
	{0x040a, 0x00},
	{0x040b, 0x00},
	{0x040c, 0x09},
	{0x040d, 0x18},
	{0x040e, 0x06},
	{0x040f, 0xd4},
	/* Output Size Setting */
	{0x034c, 0x09},
	{0x034d, 0x18},
	{0x034e, 0x06},
	{0x034f, 0xd4},
	/* Signaling mode setting */
	{0x0111, 0x02},
	/* External Clock Setting */
	{REG_EXCK_FREQ_MSB, 0x18},
	{REG_EXCK_FREQ_LSB, 0x00},
    /* Line Length PCK Setting */
	{REG_LINE_LEN_MSB, 0x24},
	{REG_LINE_LEN_LSB, 0x12},
    /* Clock Setting */
	{REG_IVTPXCK_DIV, 0x06},
	{REG_IVTSYCK_DIV, 0x04},
	{REG_IVT_PREPLLCK_DIV, 0x04},
	{REG_PLL_IVT_MPY_MSB, 0x01},
	{REG_PLL_IVT_MPY_LSB, 0x57},
	{REG_IOPPXCK_DIV, 0x0a},
	{REG_IOPSYCK_DIV, 0x02},
	{REG_IOP_PREPLLCK_DIV, 0x04},
	{REG_IOP_MPY_MSB, 0x01},
	{REG_IOP_MPY_LSB, 0x49},
	{REG_PLL_MULTI_DRV, 0x01},
    /* ------------ */
	/* Other Setting */
	{REG_REQ_LINK_BIT_RATE_MSB, 0x07},
	{REG_REQ_LINK_BIT_RATE_LMSB, 0xb6},
	{REG_REQ_LINK_BIT_RATE_MLSB, 0x00},
	{REG_REQ_LINK_BIT_RATE_LSB, 0x00},
	{0x3e20, 0x01},
	{0x3e37, 0x00},
	{0x3e3b, 0x00},
	{0x0106, 0x00},
	{0x0b00, 0x00},
	{0x3230, 0x00},
	{0x3f14, 0x01},
	{0x3f3c, 0x01},
	{REG_ADC_BIT_SETTING, 0x0a},
	{0x3fbc, 0x00},
	{0x3c06, 0x00},
	{0x3c07, 0x48},
	{0x3c0a, 0x00},
	{0x3c0b, 0x00},
	{0x3f78, 0x00},
	{0x3f79, 0x40},
	{0x3f7c, 0x00},
	{0x3f7d, 0x00},
	{REG_MODE_SEL, 0x01},
	{SEQUENCE_END, 0x00}
};
/* 1080p 60fps mode */
struct reginfo cfg_imx519_mode_1920x1080_regs[] =
{
	/* MIPI output setting */
	{0x0111, 0x02},
	{REG_CSI_FORMAT_C, 0x0a},
	{REG_CSI_FORMAT_D, 0x0a},
	{REG_CSI_LANE, 0x01},
    /* Line Length PCK Setting */
	{REG_LINE_LEN_MSB, 0x25},
	{REG_LINE_LEN_LSB, 0xd9},
    /* Frame Length Lines Setting */
	{REG_FRAME_LEN_MSB, 0x08},
	{REG_FRAME_LEN_LSB, 0xff},
    /* ROI Setting */
	{0x0344, 0x01},
	{0x0345, 0x98},
	{0x0346, 0x02},
	{0x0347, 0xa2},
	{0x0348, 0x10},
	{0x0349, 0x97},
	{0x034a, 0x0b},
	{0x034b, 0x15},
	{0x0220, 0x00},
	{0x0221, 0x11},
	{0x0222, 0x01},
    /* Mode Setting */
	{REG_BINNING_MODE, 0x01},
	{REG_BINNING_HV, 0x22},
	{REG_BINNING_WEIGHTING, 0x0a},
	{0x3f4c, 0x01},
	{0x3f4d, 0x01},
	{0x4254, 0x7f},
	{0x0401, 0x00},
	{0x0404, 0x00},
	{0x0405, 0x10},
    /* Digital Crop & Scaling */
	{0x0408, 0x00},
	{0x0409, 0x00},
	{0x040a, 0x00},
	{0x040b, 0x00},
	{0x040c, 0x07},
	{0x040d, 0x80},
	{0x040e, 0x04},
	{0x040f, 0x38},
    /* Output Size Setting */
	{0x034c, 0x07},
	{0x034d, 0x80},
	{0x034e, 0x04},
	{0x034f, 0x38},
    /* Clock Setting */
	{REG_IVTPXCK_DIV, 0x06},
	{REG_IVTSYCK_DIV, 0x04},
	{REG_IVT_PREPLLCK_DIV, 0x04},
	{REG_PLL_IVT_MPY_MSB, 0x01},
	{REG_PLL_IVT_MPY_LSB, 0x57},
	{REG_IOPPXCK_DIV, 0x0a},
	{REG_IOPSYCK_DIV, 0x02},
	{REG_IOP_PREPLLCK_DIV, 0x04},
	{REG_IOP_MPY_MSB, 0x01},
	{REG_IOP_MPY_LSB, 0x49},
	{REG_PLL_MULTI_DRV, 0x01},
    /* ------------ */
	{REG_REQ_LINK_BIT_RATE_MSB, 0x07},
	{REG_REQ_LINK_BIT_RATE_LMSB, 0xb6},
	{REG_REQ_LINK_BIT_RATE_MLSB, 0x00},
	{REG_REQ_LINK_BIT_RATE_LSB, 0x00},
	{0x3e20, 0x01},
	{0x3e37, 0x00},
	{0x3e3b, 0x00},
	{0x0106, 0x00},
	{0x0b00, 0x00},
	{0x3230, 0x00},
	{0x3f14, 0x01},
	{0x3f3c, 0x01},
	{REG_ADC_BIT_SETTING, 0x0a},
	{0x3fbc, 0x00},
	{0x3c06, 0x00},
	{0x3c07, 0x48},
	{0x3c0a, 0x00},
	{0x3c0b, 0x00},
	{0x3f78, 0x00},
	{0x3f79, 0x40},
	{0x3f7c, 0x00},
	{0x3f7d, 0x00},
	//{REG_MODE_SEL, 0x01},
	//{SEQUENCE_END, 0x00},
	//{REG_MODE_SEL, 0x00},
	//{0x0601, 0x02},
	{REG_MODE_SEL, 0x01},
	{SEQUENCE_END, 0x00}
};
/* 720p 120fps mode */
struct reginfo cfg_imx519_mode_1280x720_regs[] =
{
	{0x0111, 0x02},
	{REG_CSI_FORMAT_C, 0x0a},
	{REG_CSI_FORMAT_D, 0x0a},
	{REG_CSI_LANE, 0x01},
	{REG_LINE_LEN_MSB, 0x1b},
	{REG_LINE_LEN_LSB, 0x3b},
	{REG_FRAME_LEN_MSB, 0x03},
	{REG_FRAME_LEN_LSB, 0x34},
	{0x0344, 0x04},
	{0x0345, 0x18},
	{0x0346, 0x04},
	{0x0347, 0x12},
	{0x0348, 0x0e},
	{0x0349, 0x17},
	{0x034a, 0x09},
	{0x034b, 0xb6},
	{0x0220, 0x00},
	{0x0221, 0x11},
	{0x0222, 0x01},
	{REG_BINNING_MODE, 0x01},
	{REG_BINNING_HV, 0x22},
	{REG_BINNING_WEIGHTING, 0x0a},
	{0x3f4c, 0x01},
	{0x3f4d, 0x01},
	{0x4254, 0x7f},
	{0x0401, 0x00},
	{0x0404, 0x00},
	{0x0405, 0x10},
	{0x0408, 0x00},
	{0x0409, 0x00},
	{0x040a, 0x00},
	{0x040b, 0x00},
	{0x040c, 0x05},
	{0x040d, 0x00},
	{0x040e, 0x02},
	{0x040f, 0xd0},
	{0x034c, 0x05},
	{0x034d, 0x00},
	{0x034e, 0x02},
	{0x034f, 0xd0},
	{REG_IVTPXCK_DIV, 0x06},
	{REG_IVTSYCK_DIV, 0x04},
	{REG_IVT_PREPLLCK_DIV, 0x04},
	{REG_PLL_IVT_MPY_MSB, 0x01},
	{REG_PLL_IVT_MPY_LSB, 0x57},
	{REG_IOPPXCK_DIV, 0x0a},
	{REG_IOPSYCK_DIV, 0x02},
	{REG_IOP_PREPLLCK_DIV, 0x04},
	{REG_IOP_MPY_MSB, 0x01},
	{REG_IOP_MPY_LSB, 0x49},
	{REG_PLL_MULTI_DRV, 0x01},
	{REG_REQ_LINK_BIT_RATE_MSB, 0x07},
	{REG_REQ_LINK_BIT_RATE_LMSB, 0xb6},
	{REG_REQ_LINK_BIT_RATE_MLSB, 0x00},
	{REG_REQ_LINK_BIT_RATE_LSB, 0x00},
	{0x3e20, 0x01},
	{0x3e37, 0x00},
	{0x3e3b, 0x00},
	{0x0106, 0x00},
	{0x0b00, 0x00},
	{0x3230, 0x00},
	{0x3f14, 0x01},
	{0x3f3c, 0x01},
	{REG_ADC_BIT_SETTING, 0x0a},
	{0x3fbc, 0x00},
	{0x3c06, 0x00},
	{0x3c07, 0x48},
	{0x3c0a, 0x00},
	{0x3c0b, 0x00},
	{0x3f78, 0x00},
	{0x3f79, 0x40},
	{0x3f7c, 0x00},
	{0x3f7d, 0x00},
	{REG_MODE_SEL, 0x01},
	{SEQUENCE_END, 0x00}
};
struct reginfo cfg_imx519_testpattern_bar_regs[] =
{
	{REG_MODE_SEL, 0x00},
	{0x0601, 0x02},
	{REG_MODE_SEL, 0x01},
	{SEQUENCE_END, 0x00}
};
int imx519_read(XIicPs *IicInstance,u16 addr,u8 *read_buf)
{
	*read_buf=i2c_reg16_read(IicInstance,IIC_IMX519_ADDR,addr);
	return XST_SUCCESS;
}
int imx519_write(XIicPs *IicInstance,u16 addr,u8 data)
{
	return i2c_reg16_write(IicInstance,IIC_IMX519_ADDR,addr,data);
}
void imx_519_sensor_write_array(XIicPs *IicInstance, struct reginfo *regarray)
{
	int i = 0;
	while (regarray[i].reg != SEQUENCE_END) {
		imx519_write(IicInstance,regarray[i].reg,regarray[i].val);
		i++;
	}
}
int imx519_sensor_init(XIicPs *IicInstance,u16 config_number)
{
	u8 sensor_id[2];
	imx519_read(IicInstance, 0x0016, &sensor_id[0]);
	imx519_read(IicInstance, 0x0017, &sensor_id[1]);
	if (sensor_id[0] == 0x5 && sensor_id[1] == 0x19)
    {
		printf("Got imx519 Camera Sensor ID: %x%x\r\n", sensor_id[0], sensor_id[1]);
		imx_519_sensor_write_array(IicInstance,cfg_imx519_mode_common_regs);
		usleep(1000000);
        if(config_number == 0) {
            imx_477_sensor_write_array(IicInstance,cfg_imx519_mode_2328x1748_regs);
        } else if (config_number == 1) {
            imx_477_sensor_write_array(IicInstance,cfg_imx519_mode_4656x3496_regs);
        } else if (config_number == 2) {
            imx_477_sensor_write_array(IicInstance,cfg_imx519_mode_3840x2160_regs);
        } else if (config_number == 3) {
            imx_477_sensor_write_array(IicInstance,cfg_imx519_mode_1920x1080_regs);
        } else if (config_number == 4) {
            imx_477_sensor_write_array(IicInstance,cfg_imx519_mode_1280x720_regs);
        } else {
            imx_477_sensor_write_array(IicInstance,cfg_imx519_testpattern_bar_regs);
        }
	return 519;
	}

}
int imx519_read_register(XIicPs *IicInstance,u16 addr)
{
	u8 sensor_id[1];
    imx519_read(IicInstance, addr, &sensor_id[0]);
    printf("Read imx519 Read Reg Address  =  %x   Value = %x\n",addr,sensor_id[0]);
	return 0;
}
int imx519_write_register(XIicPs *IicInstance,u16 addr,u8 data)
{
	imx519_write(IicInstance,REG_MODE_SEL,0x00);
	imx519_write(IicInstance,addr,data);
	imx519_write(IicInstance,REG_MODE_SEL,0x01);
    printf("Read imx519 Write Reg Address  =  %x   Value = %x\n",addr,data);
	return 0;
}
int imx519_write_read_register(XIicPs *IicInstance,u16 addr,u8 data)
{
	imx519_write_register(IicInstance,addr,data);
	imx519_read_register(IicInstance,addr);
	return 0;
}
