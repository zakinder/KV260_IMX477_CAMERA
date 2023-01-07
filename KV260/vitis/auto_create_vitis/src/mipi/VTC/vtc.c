#include "xvtc.h"
#include "xvidc.h"

#include "../DP_VIDEO/video_modes.h"
int vtc_init(XVidC_VideoStream *StreamPtr) {
	XVtc vtc;

	XVtc_Config *vtc_config;


    if ( (vtc_config = XVtc_LookupConfig(XPAR_VTC_0_DEVICE_ID)) == NULL) {
		xil_printf("XVtc_LookupConfig() failed\r\n");
		return XST_FAILURE;
	}
    if (XVtc_CfgInitialize(&vtc, vtc_config, vtc_config->BaseAddress) != XST_SUCCESS) {
		xil_printf("XVtc_CfgInitialize() failed\r\n");
		return XST_FAILURE;
	}




	XVtc_Timing vtc_timing = { 0 };
	u16 PixelsPerClock = 1;

	vtc_timing.HActiveVideo = StreamPtr->Timing.HActive / PixelsPerClock;
	vtc_timing.HFrontPorch = StreamPtr->Timing.HFrontPorch / PixelsPerClock;
	vtc_timing.HSyncWidth = StreamPtr->Timing.HSyncWidth / PixelsPerClock;
	vtc_timing.HBackPorch = StreamPtr->Timing.HBackPorch / PixelsPerClock;
	vtc_timing.HSyncPolarity = StreamPtr->Timing.HSyncPolarity;
	vtc_timing.VActiveVideo = StreamPtr->Timing.VActive;
	vtc_timing.V0FrontPorch = StreamPtr->Timing.F0PVFrontPorch;
	vtc_timing.V0SyncWidth = StreamPtr->Timing.F0PVSyncWidth;
	vtc_timing.V0BackPorch = StreamPtr->Timing.F0PVBackPorch;
	vtc_timing.VSyncPolarity = StreamPtr->Timing.VSyncPolarity;
	XVtc_Reset(&vtc);
	XVtc_DisableGenerator(&vtc);
	XVtc_Disable(&vtc);
	XVtc_SetGeneratorTiming(&vtc, &vtc_timing);
	XVtc_Enable(&vtc);
	XVtc_EnableGenerator(&vtc);
	XVtc_RegUpdateEnable(&vtc);
	//xil_printf("Video timing generator initialized\r\n");
	return XST_SUCCESS;
}
