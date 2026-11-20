#ifndef __IMX477_H__
#define __IMX477_H__
#include <xbasic_types.h>
#include <xiicps.h>
int imx477_write(XIicPs *IicInstance,u16 addr,u8 data);
int imx477_sensor_init(XIicPs *IicInstance,u16 config_number);
int imx477_read_register(XIicPs *IicInstance,u16 addr);
int imx477_write_register(XIicPs *IicInstance,u16 addr,u8 data);
int imx477_write_read_register(XIicPs *IicInstance,u16 addr,u8 data);
enum Imx477TuningResult {
    IMX477_TUNING_OK = 0,
    IMX477_TUNING_IO_ERROR,
    IMX477_TUNING_RANGE_ERROR,
    IMX477_TUNING_HDR_ACTIVE
};

typedef struct {
    u16 exposure_lines;
    u16 frame_lines;
    u16 analog_gain_code;
    u8 long_exposure_shift;
    u8 dol_enable;
    u8 dol_mode;
    u8 i2c_address;
} Imx477TuningStatus;

int imx477_dol_probe(XIicPs *iic);
void imx477_tuning_diagnose(XIicPs *iic);
int imx477_tuning_read(XIicPs *iic, Imx477TuningStatus *status);
int imx477_tuning_exposure(XIicPs *iic, unsigned int preset);
int imx477_tuning_brightness(XIicPs *iic, unsigned int preset);
int imx477_digital_gain_read(XIicPs *iic, u16 gains[4], u8 *global);
/* Channels 0-3 select Gr, R, B, Gb. Channel 4 sets global-gain bit 0. */
int imx477_digital_gain_set(XIicPs *iic, unsigned int channel, u16 gain);
int imx477_video_timing(XIicPs *iic, u16 *width, u16 *height, u16 *frame_lines);
int imx477_video_set_frame_lines(XIicPs *iic, u16 frame_lines);
#endif
