#ifndef __IMX477_H__
#define __IMX477_H__
#include <xbasic_types.h>
#include <xiicps.h>
int imx477_write(XIicPs *IicInstance,u16 addr,u8 data);
int imx477_sensor_init(XIicPs *IicInstance,u16 config_number);
int imx477_read_register(XIicPs *IicInstance,u16 addr);
int imx477_write_register(XIicPs *IicInstance,u16 addr,u8 data);
int imx477_write_read_register(XIicPs *IicInstance,u16 addr,u8 data);
#endif
