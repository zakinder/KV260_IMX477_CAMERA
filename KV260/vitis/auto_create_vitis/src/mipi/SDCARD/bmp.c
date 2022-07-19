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
    uint32_t red = 0, green = 0, blue = 0;
	for(y = 0; y < Yimage ; y++)
	{
		for(x = 0; x < Ximage; x++)
		{
			Write_line_buf[x*4 + 3] = data_buf[x*4 + iPixelAddr + 0];
			Write_line_buf[x*4 + 2] = data_buf[x*4 + iPixelAddr + 1];
			Write_line_buf[x*4 + 1] = data_buf[x*4 + iPixelAddr + 2];
			Write_line_buf[x*4 + 0] = data_buf[x*4 + iPixelAddr + 3];
            // blue              = (pS2MM_Mem[i*4+0] & 0x3ff00000)>>20;
            // red               = (pS2MM_Mem[i*4+1] & 0x000ffc00)>>10;
            // green             = (pS2MM_Mem[i*4+2] & 0x000003ff);
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
void bmp_tx(char * name, char *head_buf, Xuint32 *data_buf, u32 stride, FIL *fil)
{
    u64 adrSof;
    u8  nAddre;
    int  pix;
	short y,x;
	u32 iPixelAddr = 0;
    UINT bw;
	FRESULT res;
	unsigned int br;
    adrSof  = 0x317BF00;
    nAddre  = 0x1;
    int len;
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
    printf  ("1ST PIXEL VALUE %i\n",(unsigned)(data_buf[0] & 0x03ff));

        for(x = 0; x < 1920*1080; x++) {
            unsigned char buffer[PIXEL_LENGTH] = { 0 };
            pix = ((data_buf[x] & 0x03ff)>>1);
            len =snprintf((void*)buffer,sizeof(buffer),"%d ",pix);
            unsigned char *response = (void*)buffer;
            res = f_write(fil,response,len,&bw);
            if(res != FR_OK)
            {
                printf("error: f_write Failed!\r\n") ;
                return;
            }
        }
            
        res = f_write(fil,"\n", 1, &bw);
        if(res != FR_OK)
        {
            printf("error: f_write Failed!\r\n") ;
            return ;
        }
        res = f_close(fil);
}
