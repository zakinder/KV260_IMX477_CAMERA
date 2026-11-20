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
int init_camera();
void read_imx477_reg(u16 addr);
void write_imx477_reg(u16 addr,u8 data);
void read_imx519_reg(u16 addr);
void write_imx519_reg(u16 addr,u8 data);
void read_imx219_reg(u16 addr);
void write_imx219_reg(u16 addr,u8 data);
int scan_sensor1(XIicPs *IicInstance);
int scan_sensor2(XIicPs *IicInstance);
int scan_sensor3(XIicPs *IicInstance);
