#ifndef __IMX519_H__
#define __IMX519_H__
#include <xbasic_types.h>
#include <xiicps.h>
int imx519_write(XIicPs *IicInstance,u16 addr,u8 data);
int imx519_sensor_init(XIicPs *IicInstance,u16 config_number);
int imx519_read_register(XIicPs *IicInstance,u16 addr);
int imx519_write_register(XIicPs *IicInstance,u16 addr,u8 data);
int imx519_write_read_register(XIicPs *IicInstance,u16 addr,u8 data);
#endif
