#ifndef __IMX519_H__
#define __IMX519_H__
#include <xbasic_types.h>
#include <xiicps.h>
int imx682_write(XIicPs *IicInstance,u16 addr,u8 data);
int imx682_sensor_init(XIicPs *IicInstance);
int imx682_read_register(XIicPs *IicInstance,u16 addr);
int imx682_write_register(XIicPs *IicInstance,u16 addr,u8 data);
int imx682_write_read_register(XIicPs *IicInstance,u16 addr,u8 data);
#endif
