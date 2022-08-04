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
u32 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(256)));
u32 *pFrames[DISPLAY_NUM_FRAMES];
int main()

{
    video = VMODE_1920x1080;
	int i,connected_camera;
    connected_camera=init_camera();
    printf("connected_camera = %i \n\r",connected_camera);

    demosaic_init();
    vtc_init(video);
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
        memset(pFrames[i], 0, DEMO_MAX_FRAME);
	}

    vdma_write_init(XPAR_AXIVDMA_0_DEVICE_ID,DEMO_STRIDE,VIDEO_ROWS,DEMO_STRIDE,(unsigned int)pFrames[0],(unsigned int)pFrames[1],(unsigned int)pFrames[2]);
    run_dppsu((unsigned int)pFrames[1]);
    //lwip_loop();
     while(1){
         menu_calls(TRUE,(char *)&BMODE_1920x1080,pFrames[0], DEMO_STRIDE,connected_camera);
     }
    return 0;
}
