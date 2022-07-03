#include "imx219.h"
#include <xil_types.h>
#include <xstatus.h>
#include "xiicps.h"
#include "xparameters.h"
#include "sleep.h"
#include <xil_printf.h>
#include "../../config.h"
#include "../I2c_transections.h"
#define IIC_IMX219_ADDR  	        0x10
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
struct reginfo cfg_imx219_1280_702p_60fps[] =
{
    {0x30EB, 0x05},
    {0x30EB, 0x0C},
    {0x300A, 0xFF},
    {0x300B, 0xFF},
    {0x30EB, 0x05},
    {0x30EB, 0x09},
    {0x0114, 0x01},                 // CSI_LANE_MODE = 2-lane
    {0x0128, 0x00},                 // DPHY_CTRL = auto mode
    {0x012A, 0x13},                 // EXCLK_FREQ[15:8]
    {0x012B, 0x34},                 // EXCLK_FREQ[7:0] = 4916 MHz
    {REG_FRAME_LEN_MSB, 0x04},      // FRM_LENGTH_A[15:8]
    {REG_FRAME_LEN_LSB, 0x60},      // FRM_LENGTH_A[7:0] = 1120
    {REG_LINE_LEN_MSB, 0x0D},       // LINE_LENGTH_A[15:8]
    {REG_LINE_LEN_LSB, 0x78},       // LINE_LENGTH_A[7:0] = 3448
    {0x0164, 0x01},                 // XADD_STA_A[11:8]
    {0x0165, 0x58},                 // XADD_STA_A[7:0] = X top left = 344
    {0x0166, 0x0B},                 // XADD_END_A[11:8]
    {0x0167, 0x77},                 // XADD_END_A[7:0] = X bottom right = 2935
    {0x0168, 0x01},                 // YADD_STA_A[11:8]
    {0x0169, 0xF0},                 // YADD_STA_A[7:0] = Y top left = 496
    {0x016A, 0x07},                 // YADD_END_A[11:8]
    {0x016B, 0xAF},                 // YADD_END_A[7:0] = Y bottom right = 1967
    {0x016C, 0x05},                 // x_output_size[11:8]
    {0x016D, 0x10},                 // x_output_size[7:0] = 1296
    {0x016E, 0x02},                 // y_output_size[11:8]
    {0x016F, 0xE0},                 // y_output_size[7:0] = 736
    {0x0170, 0x01},                 // X_ODD_INC_A
    {0x0171, 0x01},                 // Y_ODD_INC_A
    {REG_BINNING_H, 0x01},          // BINNING_MODE_H_A = x2-binning
    {REG_BINNING_V, 0x01},          // BINNING_MODE_V_A = x2-binning
//  {REG_BINNING_H, 0x00},          // BINNING_MODE_H_A = no-binning
//  {REG_BINNING_V, 0x00},          // BINNING_MODE_V_A = no-binning
    {REG_BIN_CALC_MOD_H, 0x01},     // BINNING_CAL_MODE_H_A
    {REG_BIN_CALC_MOD_V, 0x01},     // BINNING_CAL_MODE_V_A
    {REG_CSI_FORMAT_C, 0x0A},       // CSI_DATA_FORMAT_A[15:8]
    {REG_CSI_FORMAT_D, 0x0A},       // CSI_DATA_FORMAT_A[7:0]
    {0x0301, 0x05},
    {0x0303, 0x01},
    {0x0304, 0x02},
    {0x0305, 0x02},
    {0x0309, 0x0A},                 // OPPXCK_DIV
    {0x030B, 0x01},                 // OPSYCK_DIV
    {0x0306, 0x00},                 // PLL_VT_MPY[10:8]
//  {0x0307, 0x2E},                 // PLL_VT_MPY[7:0] = 46
    {0x0307, 0x17},                 // PLL_VT_MPY[7:0] = 23
//  {0x0307, 0x0F},                 // PLL_VT_MPY[7:0] = 15
    {0x030C, 0x00},                 // PLL_OP_MPY[10:8]
//  {0x030D, 0x5C},                 // PLL_OP_MPY[7:0] = 92
    {0x030D, 0x2E},                 // PLL_OP_MPY[7:0] = 46
//  {0x030D, 0x1E},                 // PLL_OP_MPY[7:0] = 30
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
//  {0x0601, 0x02},                 // Test pattern = Color bar
//  {0x0601, 0x00},                 // Test pattern = Normal work
//  {0x0620, 0x00},                 // TP_WINDOW_X_OFFSET[11:8]
//  {0x0621, 0x00},                 // TP_WINDOW_X_OFFSET[7:0]
//  {0x0621, 0x00},                 // TP_WINDOW_Y_OFFSET[11:8]
//  {0x0623, 0x00},                 // TP_WINDOW_Y_OFFSET[7:0]
//  {0x0624, 0x05},                 // TP_WINDOW_WIDTH[11:8]
//  {0x0625, 0x00},                 // TP_WINDOW_WIDTH[7:0] = 1280
//  {0x0626, 0x02},                 // TP_WINDOW_HEIGHT[11:8]
//  {0x0627, 0xD0},                 // TP_WINDOW_HEIGHT[7:0] = 720
    {REG_MODE_SEL, 0x01},
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
		{REG_CSI_FORMAT_C, 0x0A},   // CSI_DATA_FORMAT_A[15:8]
		{REG_CSI_FORMAT_D, 0x0A},   // CSI_DATA_FORMAT_A[7:0]
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
        {0x455E,				   0x00},
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
        {REG_TEST_PATTERN_MSB,     0x00},
        {REG_TEST_PATTERN_LSB,     0x00},
        {REG_TP_X_OFFSET_MSB,      0x00},
        {REG_TP_X_OFFSET_LSB,      0x00},
        {REG_TP_Y_OFFSET_MSB,      0x00},
        {REG_TP_Y_OFFSET_LSB,      0x00},
        {REG_TP_WIDTH_MSB,   	   0x05},   //TP width 1920 ->780 1280->500
        {REG_TP_WIDTH_LSB,   	   0x00},
        {REG_TP_HEIGHT_MSB,   	   0x02},   //TP height 1080 -> 438 720->2D0
        {REG_TP_HEIGHT_LSB,   	   0xD0},
        {REG_DIG_GAIN_GLOBAL_MSB,  0x01},
        {REG_DIG_GAIN_GLOBAL_LSB,  0x10},
        {REG_ANA_GAIN_GLOBAL,      0x80},   //analog gain , raspberry pi constinouly changes this depending on scense
        {REG_INTEGRATION_TIME_MSB, 0x03},	//integration time , really important for frame rate
        {REG_INTEGRATION_TIME_LSB, 0x51},
		{REG_MODE_SEL, 0x01},
        {SEQUENCE_END, 0x00}
};
int imx219_read(XIicPs *IicInstance,u16 addr,u8 *read_buf)
{
	*read_buf=i2c_reg16_read(IicInstance,IIC_IMX219_ADDR,addr);
	return XST_SUCCESS;
}
int scan_read(XIicPs *IicInstance,u16 addr,u8 *read_buf,u16 scan_addr)
{
	*read_buf=i2c_reg16_read(IicInstance,scan_addr,addr);
	return XST_SUCCESS;
}
int imx219_write(XIicPs *IicInstance,u16 addr,u8 data)
{
	return i2c_reg16_write(IicInstance,IIC_IMX219_ADDR,addr,data);
}
void imx219_sensor_write_array(XIicPs *IicInstance, struct reginfo *regarray)
{
	int i = 0;
	while (regarray[i].reg != SEQUENCE_END) {
		imx219_write(IicInstance,regarray[i].reg,regarray[i].val);
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
int imx219_camera_sensor_init(XIicPs *IicInstance)
{
	u8 sensor_id[2] ;
	imx219_read(IicInstance, 0x0000, &sensor_id[0]);
	imx219_read(IicInstance, 0x0001, &sensor_id[1]);
	if (sensor_id[0] == 0x2 || sensor_id[1] == 0x19)
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
