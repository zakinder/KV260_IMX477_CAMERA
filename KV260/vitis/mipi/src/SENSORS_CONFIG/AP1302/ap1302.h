
#include <xbasic_types.h>
#include <xiicps.h>
int ap1302_write(XIicPs *IicInstance,u16 addr,u8 data);
int ap1302_sensor_init(XIicPs *IicInstance);
int ap1302_read_register(XIicPs *IicInstance,u16 addr);
int ap1302_write_register(XIicPs *IicInstance,u16 addr,u8 data);
int ap1302_write_read_register(XIicPs *IicInstance,u16 addr,u8 data);
int ap1302_camera_sensor_init(XIicPs *IicInstance);

