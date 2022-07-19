/*
   MODIFICATION HISTORY:
   
   Ver   Who Date     Changes
   ----- -------- -------- -----------------------------------------------
   1.0	 Sakinder 06/01/22 Initial Release
   1.2   Sakinder 06/08/22 Added IMX219 Camera functions.
   1.3   Sakinder 06/14/22 Added IMX477 Camera functions.
   1.4   Sakinder 07/01/22 Added IMX519 Camera functions.
   1.5   Sakinder 07/06/22 Added IMX682 Camera functions.
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
#include "TPG/tpg.h"
#include "UART/uartio.h"
#include "VDMA/vdma.h"
#include "VTC/vtc.h"
#include "ff.h"
#include "SDCARD/bmp.h"
#include "math.h"

static FIL fil;		/* File object */
static FATFS fatfs;
static int WriteError;
int wr_index = 0;
int rd_index = 0;
u8 photobuf[DEMO_MAX_FRAME] __attribute__ ((aligned(256)));;
VideoMode video;
u32 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(256)));
u32 *pFrames[DISPLAY_NUM_FRAMES];
int main()
{
	int i;
	FRESULT rc;
	float elapsed_time ;
	unsigned int PhotoCount = 0 ;
	char PhotoName[9] ;
	char PhotoPath[] = {'1',':','/','0','0','0','0', '.','b','m','p'};
    video = VMODE_1920x1080;
    init_camera();
    demosaic_init();
    tpg_init(1);
    vtc_init(video);
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
	}
    run_dppsu((unsigned int)pFrames[1]);
    vdma_write_init(XPAR_AXIVDMA_0_DEVICE_ID,DEMO_STRIDE,VIDEO_ROWS,DEMO_STRIDE,(unsigned int)pFrames[0],(unsigned int)pFrames[1],(unsigned int)pFrames[2]);
    //print("Entire Video Pipeline Activateds\r\n");

	rc = f_mount(&fatfs, "1:/", 0);
	if (rc != FR_OK)
	{
		return 0 ;
	}
    sprintf(PhotoName, "%04u.bmp", 1);
    for(i = 4;i < 8;i++)
    PhotoPath[i+3] = PhotoName[i];
    memcpy(&photobuf, pFrames[(wr_index+1)%2],  DEMO_MAX_FRAME);
    usleep(100000);
    bmp_write(PhotoPath, (char *)&BMODE_1920x1080, (char *)&photobuf, DEMO_STRIDE, &fil);
    //sprintf(PhotoName, "%04u1.bmp", 1);
    //for(i = 4;i < 8;i++)
    //PhotoPath[i+3] = PhotoName[i];
    //bmp_tx(PhotoPath, (char *)&BMODE_1920x1080,(unsigned int)pFrames[0], DEMO_STRIDE, &fil);
     while(1){
         menu_calls(TRUE);
     }
    return 0;
}
