#include <xaxivdma.h>
#include <xil_printf.h>
#include <xil_types.h>
#include <xparameters.h>
#include "config.h"
#include "DEMOSAIC/demosaic.h"
#include "DP_VIDEO/video_modes.h"
#include "DP_VIDEO/xdpdma_video.h"
#include "MENU/menu_calls.h"
#include "PLATFORM/platform.h"
#include "TPG/tpg.h"
#include "UART/uartio.h"
#include "VTC/vtc.h"
#include "MIPI/mipi.h"
VideoMode video;
u32 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(256)));
u32 *pFrames[DISPLAY_NUM_FRAMES];
int main()
{
    video = VMODE_1920x1080;
    per_write_reg(REG16,0);
    per_write_reg(REG11,0);
    per_write_reg(REG15,2);
    per_write_reg(REG19,4);
    mipi_init();
    init_camera();
    demosaic_init();
    print("Camera Configuration Complete\n\r");
    tpg_init(1);
    vtc_init(video);
	int i ;
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
	}
    run_dppsu((unsigned int)pFrames[1]);
    vdma_write_init(XPAR_AXIVDMA_0_DEVICE_ID,DEMO_STRIDE,VIDEO_ROWS,DEMO_STRIDE,(unsigned int)pFrames[0],(unsigned int)pFrames[1],(unsigned int)pFrames[2]);
    print("Entire Video Pipeline Activated\r\n");
     while(1){
         menu_calls(TRUE);
     }
    return 0;
}
