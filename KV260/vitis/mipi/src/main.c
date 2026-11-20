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
   2.2   Sakinder 12/30/22 Added UHD 3840x2160p@30Hz functions.
   2.3   Sakinder 12/30/22 Added function for dynamic reconfig clocks.
   -----------------------------------------------------------------------
*/
#include <stdio.h>
#include <string.h>
#include "xil_cache.h"
#include "xil_io.h"
#include "sleep.h"
#include <xil_printf.h>
#include <xil_types.h>
#include <xparameters.h>
#include "config.h"
#include "DEMOSAIC/demosaic.h"
#include "DP_VIDEO/video_modes.h"
#include "DP_VIDEO/xdpdma_video.h"
#include "MENU/menu_calls.h"
#include "SENSORS_CONFIG/init_camera.h"
#include "UART/uartio.h"
#include "VDMA/vdma.h"
#include "VTC/vtc.h"
#include "SDCARD/bmp.h"
#include "xgpio.h"
#include <xclk_wiz.h>
#include "DP_CLOCK/clk_wiz.h"
#include "imx477_startup_settings.h"
XClk_Wiz ClkWizInst;
VideoMode video;
static XGpio axi_gpio;
#define GPIO_SENSOR_IAS1_RSTN	(0)
#define GPIO_SENSOR_RPI_RSTN	(1)
#define GPIO_SENSOR_RPI_LED	    (2)
u32 frameBuf[DISPLAY_NUM_FRAMES][VIDEO1_MAX_FRAME] __attribute__((aligned(64)));
u32 *pFrames[DISPLAY_NUM_FRAMES];
u32 frameBuf1[NUM_FRAMES][VIDEO2_MAX_FRAME];
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
/* Display-only bring-up. Sample PARK_PTR without changing DMA state. */
static void report_vdma_rotation(UINTPTR base)
{
    const u32 mask = 0x1f1f0000U;
    const u32 required_control = 0x8bU; /* RS, Circular, GenlockEn, GenlockSrc */
    u32 read_cr = Xil_In32(base + 0x00U);
    u32 write_cr = Xil_In32(base + 0x30U);
    u32 previous = ~0U;
    u32 write_seen = 0;
    u32 read_seen = 0;

    printf("VDMA circular test: MM2S_CR=0x%08lx S2MM_CR=0x%08lx\r\n",
           (unsigned long)read_cr, (unsigned long)write_cr);
    if ((read_cr & required_control) != required_control ||
        (write_cr & required_control) != required_control)
        printf("VDMA test: expected control mask 0x8B on both channels.\r\n");

    for (unsigned int i = 0; i < 100; ++i) {
        const u32 park = Xil_In32(base + 0x28U);
        const unsigned int write_store = (park >> 24) & 31U;
        const unsigned int read_store = (park >> 16) & 31U;
        write_seen |= 1U << write_store;
        read_seen |= 1U << read_store;
        if ((park & mask) != previous) {
            printf("VDMA stores: write=%u read=%u\r\n", write_store, read_store);
            previous = park & mask;
        }
        usleep(20000);
    }

    printf("VDMA summary: write_seen=0x%lx read_seen=0x%lx MM2S_SR=0x%08lx S2MM_SR=0x%08lx\r\n",
           (unsigned long)write_seen, (unsigned long)read_seen,
           (unsigned long)Xil_In32(base + 0x04U),
           (unsigned long)Xil_In32(base + 0x34U));
}

int main()
{
	per_write_reg(VFP_FRAME_DIMENSIONS,((0x00FFFF & VIDEO1_ROWS)<<16) | ((VIDEO1_COLUMNS)));
	XVidC_VideoTiming const *TimingPtr;
	XVidC_VideoStream VidStream;
	VidStream.PixPerClk = 1;
	VidStream.ColorFormatId = XVIDC_CSF_RGB;
	VidStream.ColorDepth = 8;
#if p3840x2160 == 1
	VidStream.VmId = XVIDC_VM_3840x2160_30_P;
#else
	VidStream.VmId = XVIDC_VM_1920x1080_60_P;
#endif
	XClk_Wiz_dynamic_reconfig(&ClkWizInst, XPAR_PS_VIDEO_TO_PS_CLK_WIZ_0_DEVICE_ID,VidStream.VmId);
	TimingPtr = XVidC_GetTimingInfo(VidStream.VmId);
	VidStream.Timing = *TimingPtr;
	VidStream.FrameRate = XVidC_GetFrameRate(VidStream.VmId);
	xil_printf("\r\n********************************************\r\n");
	printf("Test Input Stream: %s (%s)\r\n",
			XVidC_GetVideoModeStr(VidStream.VmId),
			XVidC_GetColorFormatStr(VidStream.ColorFormatId));
	xil_printf("********************************************\r\n");
	pFrames1[0] = frameBuf1[0];
    memset(pFrames1[0], 0, VIDEO2_MAX_FRAME);
    if (vdma_write(XPAR_AXIVDMA_1_DEVICE_ID, VIDEO2_STRIDE, VIDEO2_ROWS,
                   VIDEO2_STRIDE, (unsigned int)pFrames1[0]) != XST_SUCCESS) {
        xil_printf("Preview VDMA could not start.\r\n");
        return 1;
    }
    gpio_init();
	int i,connected_camera;
    connected_camera=init_camera();
    if (connected_camera == 477) {
        extern XIicPs iic_cam;
        (void)imx477_apply_startup_settings(&iic_cam);
    }
    printf("Connected Camera = %i \n\r",connected_camera);
    demosaic2_init();
    demosaic1_init();
    vtc_init(&VidStream);
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
        memset(pFrames[i], 0, VIDEO1_MAX_FRAME);
        Xil_DCacheFlushRange((UINTPTR)pFrames[i], VIDEO1_MAX_FRAME);
	}
    if (vdma_write_init(XPAR_AXIVDMA_0_DEVICE_ID, VIDEO1_STRIDE, VIDEO1_ROWS,
                        VIDEO1_STRIDE, (unsigned int)pFrames[0],
                        (unsigned int)pFrames[1], (unsigned int)pFrames[2]) != 0) {
        printf("VDMA circular test could not start.\r\n");
        return 1;
    }
	/* Graphics DMA owns a separate DDR buffer outside the VDMA stores. */
    memset(DpGraphicsFrame, 0, VIDEO1_MAX_FRAME);
    Xil_DCacheFlushRange((UINTPTR)DpGraphicsFrame, VIDEO1_MAX_FRAME);
    run_dppsu(DpGraphicsFrame, VidStream.VmId);
    report_vdma_rotation(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR);
    printf("Rotating 4K MJPEG test ready.\r\n");
    for (;;) {
        menu_calls(TRUE, (char *)&BMODE_1920x1080, pFrames1[0],
                   VIDEO2_STRIDE, connected_camera);
    }
}
