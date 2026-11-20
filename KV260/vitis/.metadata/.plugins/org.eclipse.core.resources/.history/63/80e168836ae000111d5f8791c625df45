#include "xil_types.h"
#include "ff.h"
#include "stdio.h"
#include "string.h"
#include "ff.h"
#include "bmp.h"
#include <xbasic_types.h>
#include <xil_io.h>
#include <xil_printf.h>
#include <xstatus.h>
#define MAX_STRING_LENGTH 80
#define PIXEL_LENGTH 7
unsigned char read_line_buf[1920 * 4];
unsigned char Write_line_buf[1920 * 4];
void bmp_read(char * bmp,u8 *frame,u32 stride, FIL *fil)
{
	short y,x;
	short Ximage;
	short Yimage;
	u32 iPixelAddr = 0;
	FRESULT res;
	unsigned char TMPBUF[64];
	unsigned int br;
	res = f_open(fil, bmp, FA_OPEN_EXISTING | FA_READ);
	if(res != FR_OK)
	{
		printf("error: f_open Failed!\r\n") ;
		return ;
	}
	res = f_read(fil, TMPBUF, 54, &br);
	if(res != FR_OK)
	{
		f_close(fil);
		printf("Failed to Read!\r\n") ;
		return ;
	}
	Ximage=(unsigned short int)TMPBUF[19]*256+TMPBUF[18];
	Yimage=(unsigned short int)TMPBUF[23]*256+TMPBUF[22];
	iPixelAddr = (Yimage-1)*stride ;
	for(y = 0; y < Yimage ; y++)
	{
		f_read(fil, read_line_buf, Ximage * 3, &br);
		for(x = 0; x < Ximage; x++)
		{
			frame[x * 4 + iPixelAddr + 0] = read_line_buf[x * 3 + 0];
			frame[x * 4 + iPixelAddr + 1] = read_line_buf[x * 3 + 1];
			frame[x * 4 + iPixelAddr + 2] = read_line_buf[x * 3 + 2];
			frame[x * 4 + iPixelAddr + 3] = 0xff ;
		}
		iPixelAddr -= stride;
	}
	f_close(fil);
}
void bmp_write(char * name, char *head_buf, char *data_buf, u32 stride, FIL *fil)
{
	short y,x;
	short Ximage;
	short Yimage;
	u32 iPixelAddr = 0;
	FRESULT res;
	unsigned int br;         // File R/W count
	memset(&Write_line_buf, 0, 1920*4) ;
	res = f_open(fil, name, FA_CREATE_ALWAYS | FA_WRITE);
	if(res != FR_OK)
	{
		printf("error: f_open Failed!\r\n") ;
		return ;
	}
	res = f_write(fil, head_buf, 54, &br) ;
	if(res != FR_OK)
	{
		f_close(fil);
		printf("error: f_write Failed!\r\n") ;
		return ;
	}
	Ximage=(unsigned short)head_buf[19]*256+head_buf[18];
	Yimage=(unsigned short)head_buf[23]*256+head_buf[22];
	iPixelAddr = (Yimage-1)*stride ;
    uint32_t Blu = 0, Red = 0, Green = 0, Rgb = 0;
    uint32_t Blu_x10 = 0, Red_x10 = 0, Green_x10 = 0, Rgb_x10 = 0;
	for(y = 0; y < Yimage ; y++)
	{
		for(x = 0; x < Ximage; x++)
		{
			Blu_x10   = data_buf[x*4 + iPixelAddr + 3];
			Red_x10   = data_buf[x*4 + iPixelAddr + 2];
			Green_x10 = data_buf[x*4 + iPixelAddr + 1];
			Rgb_x10   = data_buf[x*4 + iPixelAddr + 0];
            
            Green                    = ((((data_buf[x*4 + iPixelAddr + 1])<<8) | (data_buf[x*4 + iPixelAddr + 0])) & 0x3ff)>>2;
            Rgb                      = (data_buf[x*4 + iPixelAddr + 2] | (data_buf[x*4 + iPixelAddr + 3] & 0x00f));
            Blu                      = ((((data_buf[x*4 + iPixelAddr + 3]) << 4) | ((Rgb & 0x0F0)>>4)) & 0x3ff)>>2;
            Red                      = ((((((data_buf[x*4 + iPixelAddr + 2]) & 0x00F)<<8)| (data_buf[x*4 + iPixelAddr + 1]))>>2) & 0x3ff)>>2;
			Write_line_buf[x*4 + 3]  = Blu;
			Write_line_buf[x*4 + 2]  = Red;
			Write_line_buf[x*4 + 1]  = Green;
			Write_line_buf[x*4 + 0]  = Blu;
            //111: 0100010001
            //222: 1000100010
            //333: 1100110011
            //00.6Green.4Green.4Red.6Red.2Blue.8Blue
            // 1100110011.1000100010.0100010001
            // 110011001110001000100100010001
            // 3338 8911
            //        00010001  11
            //        10001001  89
            //        00111000  38
            //        00110011  33
			//Write_line_buf[x*4 + 0] = (Green&0x3FF)>>4;                    //6BIT-GREEN
			//Write_line_buf[x*4 + 1] = (((Green&0x0F)<<4)|(Red&0x3C0)>>6);  //4BIT-GREEN AND 4BIT-RED
			//Write_line_buf[x*4 + 2] = (((Red&0x3F)<<2)|(Blue&0x0300)>>8);  //6BIT-RED AND 2BIT-BLUE
			//Write_line_buf[x*4 + 3] = Blue;                                //8BIT-BLUE
			//Write_line_buf[x*4 + 3] = Blue;
			//Write_line_buf[x*4 + 2] = ((Blue&0x03)<<6 |(Red&0x3F));
			//Write_line_buf[x*4 + 1] = ((Green&0x0F)|(Red)<<4)&0xFF;
			//Write_line_buf[x*4 + 0] = (Green&0x3F);
            
			Blu_x10   = data_buf[x*4 + iPixelAddr + 3];
			Red_x10   = data_buf[x*4 + iPixelAddr + 2];
			Green_x10 = data_buf[x*4 + iPixelAddr + 1];
			Rgb_x10   = data_buf[x*4 + iPixelAddr + 0];
            
            
            //if(Blu_x10!=0 | Red_x10!=0 | Green_x10!=0 | Rgb_x10!=0){
            //printf  ("Y:%i X:%i    Blu:%x  Red:%x  Green:%x  Rgb_x10:%x\r\n",y,x,Blu_x10,Red_x10,Green_x10,Rgb_x10);
            //printf  ("Y:%i X:%i Blue:%x  Green:%x  Red:%x \r\n",y,x,(unsigned)Blue,(unsigned)Green,(unsigned)Red);
            //}
		}
		res = f_write(fil, Write_line_buf, Ximage*4, &br) ;
		if(res != FR_OK)
		{
			f_close(fil);
			printf("error: f_write Failed!\r\n") ;
			return ;
		}
		iPixelAddr -= stride;
	}
	f_close(fil);
}
