#include <xiicps.h>
#include <xil_printf.h>
#include <xil_types.h>
#include <xstatus.h>

#include "I2c_transections.h"
#include "IMX219/imx219.h"

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
    Status = ov5647_camera_sensor_init(&iic_cam);
  	if (Status != XST_SUCCESS) {
  		print("OV5647 Camera Sensor Not connected\n\r");
  	}
    Status = imx519_sensor_init(&iic_cam);
  	if (Status != XST_SUCCESS) {
  		print("OV5647 Camera Sensor Not connected\n\r");
  	}
    Status = imx682_sensor_init(&iic_cam);
  	if (Status != XST_SUCCESS) {
  		print("OV5647 Camera Sensor Not connected\n\r");
  	}
    return 0;
}


void read_imx477_reg(u16 addr)
{
	XIicPs_Config *iic_conf;
	int Status;
	print("IMX477 Camera\n\r");
    Status = imx477_read_register(&iic_cam,addr);
  	if (Status != XST_SUCCESS) {
  		print("IMX477 Camera Sensor Not connected\n\r");
  	}
}
void write_imx477_reg(u16 addr,u8 data)
{
	XIicPs_Config *iic_conf;
	int Status;
	print("IMX477 Camera\n\r");
    Status = imx477_write_read_register(&iic_cam,addr,data);
  	if (Status != XST_SUCCESS) {
  		print("IMX477 Camera Sensor Not connected\n\r");
  	}
}


void read_imx519_reg(u16 addr)
{
	XIicPs_Config *iic_conf;
	int Status;
	print("IMX519 Camera\n\r");
    Status = imx519_read_register(&iic_cam,addr);
  	if (Status != XST_SUCCESS) {
  		print("Unable to Read IMX519 Camera Sensor\n\r");
  	}
}
void write_imx519_reg(u16 addr,u8 data)
{
	XIicPs_Config *iic_conf;
	int Status;
	print("IMX519 Camera\n\r");
    Status = imx519_write_read_register(&iic_cam,addr,data);
  	if (Status != XST_SUCCESS) {
  		print("Unable to Write IMX519 Camera Sensor\n\r");
  	}
}

int scan_sensor1(XIicPs *IicInstance)
{
	u8 sensor_id[2];
	for(int address = 0; address < 256; address++ )
	 {
		if (sensor_id[0] != 0x5 || sensor_id[1] != 0x19)
		{
			scan_read(IicInstance, 0x300A, &sensor_id[0],address);
			scan_read(IicInstance, 0x300B, &sensor_id[1],address);
			printf("Got DEVICE. id, %x %x\r\n", sensor_id[0], sensor_id[1]);
		}
		else
		{
			printf("Got DEVICE.. id, %x %x\r\n", sensor_id[0], sensor_id[1]);
		}
		printf("Id @ address ==== %x is %x %x\r\n",address, sensor_id[0], sensor_id[1]);
	 }
	return 0;
}
int scan_sensor2(XIicPs *IicInstance)
{
	u8 sensor_id[2];
	for(int address = 0; address < 256; address++ )
	 {
		if (sensor_id[0] != 0x5 || sensor_id[1] != 0x19)
		{
			scan_read(IicInstance, 0x16, &sensor_id[0],address);
			scan_read(IicInstance, 0x17, &sensor_id[1],address);
			printf("Got DEVICE. id, %x %x\r\n", sensor_id[0], sensor_id[1]);
		}
		else
		{
			printf("Got DEVICE.. id, %x %x\r\n", sensor_id[0], sensor_id[1]);
		}
		printf("Id @ address ==== %x is %x %x\r\n",address, sensor_id[0], sensor_id[1]);
	 }
	return 0;
}

int scan_sensor3(XIicPs *IicInstance)
{
	u8 sensor_id[2];
	for(int address = 0; address < 256; address++ )
	 {
		if (sensor_id[0] != 0x5 || sensor_id[1] != 0x19)
		{
			scan_read(IicInstance, 0x1A, &sensor_id[0],address);
			scan_read(IicInstance, 0x0A, &sensor_id[1],address);
			printf("Got DEVICE. id, %x %x\r\n", sensor_id[0], sensor_id[1]);
		}
		else
		{
			printf("Got DEVICE.. id, %x %x\r\n", sensor_id[0], sensor_id[1]);
		}
		printf("Id @ address ==== %x is %x %x\r\n",address, sensor_id[0], sensor_id[1]);
	 }
	return 0;
}

