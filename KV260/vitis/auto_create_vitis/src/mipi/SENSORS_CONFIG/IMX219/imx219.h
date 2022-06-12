#ifndef __IMX219_H__
#define __IMX219_H__
#include "xil_types.h"
#include <xiicps.h>
struct reginfo
{
    u16 reg;
    u8 val;
};
#define SEQUENCE_INIT        0x00
#define SEQUENCE_NORMAL      0x01
#define SEQUENCE_PROPERTY    0xFFFD
#define SEQUENCE_WAIT_MS     0xFFFE
#define SEQUENCE_END	     0xFFFF
#define IIC_DEVICE_ID	     XPAR_XIICPS_0_DEVICE_ID
int imx219_camera_sensor_init();
int read_imx219_camera_reg(XIicPs *IicInstance,u16 addr);
int write_imx219_camera_reg(XIicPs *IicInstance,u16 addr,u8 data);
#endif
