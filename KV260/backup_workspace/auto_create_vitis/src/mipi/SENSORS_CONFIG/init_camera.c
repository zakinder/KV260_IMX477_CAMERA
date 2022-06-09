#include <xiicps.h>
#include <xil_printf.h>
#include <xil_types.h>
#include <xstatus.h>
#include "../SENSORS_CONFIG/camera_sensors.h"
#include "../SENSORS_CONFIG/I2c_transections.h"
XIicPs iic_cam;
#define IIC_DEVICEID        XPAR_XIICPS_0_DEVICE_ID
#define IIC_SCLK_RATE		100000
#define SW_IIC_ADDR         0x74
u8 SendBuffer [10];
int init_camera()
{
	XIicPs_Config *iic_conf;
	int Status;
	iic_conf = XIicPs_LookupConfig(IIC_DEVICEID);
	XIicPs_CfgInitialize(&iic_cam,iic_conf,iic_conf->BaseAddress);
	XIicPs_SetSClk(&iic_cam, IIC_SCLK_RATE);
    i2c_init(&iic_cam, IIC_DEVICEID,IIC_SCLK_RATE);
    SendBuffer[0]= 0x04;
    Status = XIicPs_MasterSendPolled(&iic_cam, SendBuffer, 1, SW_IIC_ADDR);
  	if (Status != XST_SUCCESS) {
  		print("I2C Write Error\n\r");
  		return XST_FAILURE;
  	}
    Status = imx219_camera_sensor_init(&iic_cam);
  	if (Status != XST_SUCCESS) {
  		print("IMX219 Camera Sensor Not connected\n\r");
  	}
    Status = ov5640_camera_sensor_init(&iic_cam);
  	if (Status != XST_SUCCESS) {
  		print("OV5640 Camera Sensor Not connected\n\r");
  	}
    Status = imx477_sensor_init(&iic_cam);
  	if (Status != XST_SUCCESS) {
  		print("IMX477 Camera Sensor Not connected\n\r");
  	}
    return 0;
}




