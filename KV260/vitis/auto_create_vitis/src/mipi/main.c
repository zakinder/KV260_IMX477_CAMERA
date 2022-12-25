/*
   MODIFICATION HISTORY:
   
   Ver   Who Date     Changes
   ----- -------- -------- -----------------------------------------------
   1.0	 Sakinder 06/01/22 Initial Release
   1.2   Sakinder 06/08/22 Added IMX219 Camera functions.
   1.3   Sakinder 06/14/22 Added IMX477 Camera functions.
   1.4   Sakinder 07/01/22 Added IMX519 Camera functions.
   1.5   Sakinder 07/06/22 Added IMX682 Camera functions.
   1.6   Sakinder 07/21/22 Implemented rgb frame bmp format write to sdcard.
   1.7   Sakinder 08/02/22 Validated Lwip udp image transfer.
   1.8   Sakinder 08/10/22 Validated Lwip udp video stream.
   1.9   Sakinder 11/21/22 Added K-Cluster registers for PL access.
   2.0   Sakinder 12/16/22 Validated rgb2hsl and hsl2rgb video channel for further clustering usage.
   2.1   Sakinder 12/20/22 Added AR1335 Camera functions.
   -----------------------------------------------------------------------
*/
#include <stdio.h>
#include <xil_printf.h>
#include <xil_types.h>
#include <xparameters.h>
#include "config.h"
#include "DEMOSAIC/demosaic.h"
#include "DP_VIDEO/video_modes.h"
#include "DP_VIDEO/xdpdma_video.h"
#include "MENU/menu_calls.h"
#include "MIPI/mipi.h"
#include "SENSORS_CONFIG/init_camera.h"
#include "UART/uartio.h"
#include "VDMA/vdma.h"
#include "VTC/vtc.h"
#include "SDCARD/bmp.h"
#include "xgpio.h"
VideoMode video;
static XGpio axi_gpio;
#define GPIO_SENSOR_IAS1_RSTN	(0)
#define GPIO_SENSOR_RPI_RSTN	(1)
#define GPIO_SENSOR_RPI_LED	    (2)
u32 frameBuf[DISPLAY_NUM_FRAMES][VIDEO1_MAX_FRAME] __attribute__ ((aligned(256)));
u32 *pFrames[DISPLAY_NUM_FRAMES];
u32 frameBuf1[NUM_FRAMES][VIDEO2_MAX_FRAME] __attribute__ ((aligned(256)));
u32 *pFrames1[NUM_FRAMES];
void gpio_init()
{
	XGpio_Initialize(&axi_gpio, XPAR_PS_VIDEO_TO_PS_AXI_GPIO_DEVICE_ID);
	XGpio_SetDataDirection(&axi_gpio, 1, 0);
	XGpio_DiscreteWrite(&axi_gpio, 1,
			(1<<GPIO_SENSOR_IAS1_RSTN) |
			(1<<GPIO_SENSOR_RPI_RSTN) |
			(1<<GPIO_SENSOR_RPI_LED)
		);
	usleep(5000);
}
int main()
{
	pFrames1[0] = frameBuf1[0];
    memset(pFrames1[0], 0, VIDEO2_MAX_FRAME);
    vdma_write(XPAR_AXIVDMA_1_DEVICE_ID,VIDEO2_STRIDE,VIDEO2_ROWS,VIDEO2_STRIDE,(unsigned int)pFrames1[0]);
    video = VMODE_1920x1080;
    gpio_init();
	int i,connected_camera;
    connected_camera=init_camera();
    printf("connectedcamera = %i \n\r",connected_camera);
    demosaic2_init();
    demosaic1_init();
    vtc_init(video);
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
        memset(pFrames[i], 0, VIDEO1_MAX_FRAME);
	}
    vdma_write_init(XPAR_AXIVDMA_0_DEVICE_ID,VIDEO1_STRIDE,VIDEO1_ROWS,VIDEO1_STRIDE,(unsigned int)pFrames[0],(unsigned int)pFrames[1],(unsigned int)pFrames[2]);
	run_dppsu((unsigned int)pFrames[1]);
     while(1){
         menu_calls(TRUE,(char *)&BMODE_1920x1080,pFrames1[0], VIDEO2_STRIDE,connected_camera);
     }
    return 0;
}
