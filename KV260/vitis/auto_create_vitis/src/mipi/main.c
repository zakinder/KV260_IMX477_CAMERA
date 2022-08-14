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
VideoMode video;
u32 frameBuf[DISPLAY_NUM_FRAMES][VIDEO1_MAX_FRAME] __attribute__ ((aligned(256)));
u32 *pFrames[DISPLAY_NUM_FRAMES];
u32 frameBuf1[NUM_FRAMES][VIDEO2_MAX_FRAME] __attribute__ ((aligned(256)));
u32 *pFrames1[NUM_FRAMES];
int main()
{
	pFrames1[0] = frameBuf1[0];
    memset(pFrames1[0], 0, VIDEO2_MAX_FRAME);
    vdma_write(XPAR_AXIVDMA_1_DEVICE_ID,VIDEO2_STRIDE,VIDEO2_ROWS,VIDEO2_STRIDE,(unsigned int)pFrames1[0]);
    video = VMODE_1920x1080;
	int i,connected_camera;
    connected_camera=init_camera();
    //printf("connectedcamera = %i \n\r",connected_camera);
    demosaic_init();
    vtc_init(video);
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
        memset(pFrames[i], 0, VIDEO1_MAX_FRAME);
	}
    vdma_write_init(XPAR_AXIVDMA_0_DEVICE_ID,VIDEO1_STRIDE,VIDEO1_ROWS,VIDEO1_STRIDE,(unsigned int)pFrames[0],(unsigned int)pFrames[1],(unsigned int)pFrames[2]);
    run_dppsu((unsigned int)pFrames[0]);
     while(1){
         menu_calls(TRUE,(char *)&BMODE_1920x1080,pFrames1[0], VIDEO2_STRIDE,connected_camera);
     }
    return 0;
}
