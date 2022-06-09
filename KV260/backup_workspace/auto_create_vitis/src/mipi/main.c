#include <xaxivdma.h>
#include <xil_printf.h>
#include <xil_types.h>
#include <xparameters.h>
#include "config.h"
#include "DEMOSAIC/demosaic.h"
#include "DP_VIDEO/video_modes.h"
#include "DP_VIDEO/xdpdma_video.h"
#include "GAMMA/gamma_lut.h"
#include "MENU/menu_calls.h"
#include "PLATFORM/platform.h"
#include "SENSORS_CONFIG/camera_sensors.h"
#include "TPG/tpg.h"
#include "UART/uartio.h"
#include "VTC/vtc.h"
XAxiVdma vdma;
XAxiVdma_DmaSetup vdmaDMA;
XAxiVdma_Config *vdmaConfig;
VideoMode video;
u32 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(256)));
u32 *pFrames[DISPLAY_NUM_FRAMES];
int main()
{
    video = VMODE_1920x1080;
    init_platform();
    per_write_reg(REG11,3);
    per_write_reg(REG12,3);
    per_write_reg(REG13,3);
    per_write_reg(REG16,0);
    per_write_reg(REG15,1);
    init_camera();
    gamma_lut_init();
    demosaic_init();
    print("Camera Configuration Complete\n\r");
    tpg_init(1);
    vtc_init(video);
    pFrames[0] = frameBuf[0];
    vdmaConfig = XAxiVdma_LookupConfig(XPAR_AXIVDMA_0_DEVICE_ID);
    XAxiVdma_CfgInitialize(&vdma, vdmaConfig, vdmaConfig->BaseAddress);
    vdmaDMA.FrameDelay              = 0;
    vdmaDMA.EnableCircularBuf       = 1;
    vdmaDMA.EnableSync              = 0;
    vdmaDMA.PointNum                = 0;
    vdmaDMA.EnableFrameCounter      = 0;
    vdmaDMA.VertSizeInput           = video.height;
    vdmaDMA.HoriSizeInput           = (video.width)*4;
    vdmaDMA.FixedFrameStoreAddr     = 0;
    vdmaDMA.FrameStoreStartAddr[0]  = (INTPTR) pFrames[0];
    vdmaDMA.Stride                  = (video.width)*4;
    XAxiVdma_DmaConfig(&vdma, XAXIVDMA_WRITE, &(vdmaDMA));
    XAxiVdma_DmaSetBufferAddr(&vdma, XAXIVDMA_WRITE,vdmaDMA.FrameStoreStartAddr);
    XAxiVdma_DmaConfig(&vdma, XAXIVDMA_READ, &(vdmaDMA));
    XAxiVdma_DmaSetBufferAddr(&vdma, XAXIVDMA_READ,vdmaDMA.FrameStoreStartAddr);
    XAxiVdma_DmaStart(&vdma, XAXIVDMA_WRITE);
    XAxiVdma_StartParking(&vdma, 0, XAXIVDMA_WRITE);
    XAxiVdma_DmaStart(&vdma, XAXIVDMA_READ);
    XAxiVdma_StartParking(&vdma, 0, XAXIVDMA_READ);
    print("Vdma Configuration Complete\n\r");
    run_dppsu(vdmaDMA.FrameStoreStartAddr[0]);
    print("Entire Video Pipeline Activated\r\n");
     while(1){
         menu_calls(TRUE);
     }
    return 0;
}