#ifndef __IMX219_H__
#define __IMX219_H__
#include <xbasic_types.h>
#include <xiicps.h>
int imx219_write(XIicPs *IicInstance,u16 addr,u8 data);
int imx219_sensor_init(XIicPs *IicInstance);
int imx219_read_register(XIicPs *IicInstance,u16 addr);
int imx219_write_register(XIicPs *IicInstance,u16 addr,u8 data);
int imx219_write_read_register(XIicPs *IicInstance,u16 addr,u8 data);
#endif
