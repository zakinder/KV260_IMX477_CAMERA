#include "xvtc.h"
#include "../DP_VIDEO/video_modes.h"
int vtc_init(VideoMode video) {
	XVtc vtc;
	XVtc_Config *vtc_config;
    XVtc_SourceSelect SourceSelect;
    XVtc_Timing vtcTiming;
    if ( (vtc_config = XVtc_LookupConfig(XPAR_VTC_0_DEVICE_ID)) == NULL) {
		xil_printf("XVtc_LookupConfig() failed\r\n");
		return XST_FAILURE;
	}
    if (XVtc_CfgInitialize(&vtc, vtc_config, vtc_config->BaseAddress) != XST_SUCCESS) {
		xil_printf("XVtc_CfgInitialize() failed\r\n");
		return XST_FAILURE;
	}
    //**************************************************************************************
    // VIDEO TIMINF CONTROLLER
    //**************************************************************************************
    vtcTiming.HActiveVideo          = video.width;                       /**< Horizontal Active Video Size */
    vtcTiming.HFrontPorch           = video.hps - video.width;           /**< Horizontal Front Porch Size */
    vtcTiming.HSyncWidth            = video.hpe - video.hps;             /**< Horizontal Sync Width */
    vtcTiming.HBackPorch            = video.hmax - video.hpe + 1;        /**< Horizontal Back Porch Size */
    vtcTiming.HSyncPolarity         = video.hpol;                        /**< Horizontal Sync Polarity */
    vtcTiming.VActiveVideo          = video.height;                      /**< Vertical Active Video Size */
    vtcTiming.V0FrontPorch          = video.vps - video.height;          /**< Vertical Front Porch Size */
    vtcTiming.V0SyncWidth           = video.vpe - video.vps;             /**< Vertical Sync Width */
    vtcTiming.V0BackPorch           = video.vmax - video.vpe + 1;;       /**< Horizontal Back Porch Size */
    vtcTiming.V1FrontPorch          = video.vps - video.height;          /**< Vertical Front Porch Size */
    vtcTiming.V1SyncWidth           = video.vpe - video.vps;             /**< Vertical Sync Width */
    vtcTiming.V1BackPorch           = video.vmax - video.vpe + 1;;       /**< Horizontal Back Porch Size */
    vtcTiming.VSyncPolarity         = video.vpol;                        /**< Vertical Sync Polarity */
    vtcTiming.Interlaced            = 0;
    memset((void *)&SourceSelect, 0, sizeof(SourceSelect));
    SourceSelect.VBlankPolSrc       = 1;
    SourceSelect.VSyncPolSrc        = 1;
    SourceSelect.HBlankPolSrc       = 1;
    SourceSelect.HSyncPolSrc        = 1;
    SourceSelect.ActiveVideoPolSrc  = 1;
    SourceSelect.ActiveChromaPolSrc = 1;
    SourceSelect.VChromaSrc         = 1;
    SourceSelect.VActiveSrc         = 1;
    SourceSelect.VBackPorchSrc      = 1;
    SourceSelect.VSyncSrc           = 1;
    SourceSelect.VFrontPorchSrc     = 1;
    SourceSelect.VTotalSrc          = 1;
    SourceSelect.HActiveSrc         = 1;
    SourceSelect.HBackPorchSrc      = 1;
    SourceSelect.HSyncSrc           = 1;
    SourceSelect.HFrontPorchSrc     = 1;
    SourceSelect.HTotalSrc          = 1;
    XVtc_RegUpdateEnable(&vtc);
    XVtc_SetGeneratorTiming(&vtc, &vtcTiming);
    XVtc_SetSource(&vtc, &SourceSelect);
    XVtc_EnableGenerator(&vtc);
    XVtc_Enable(&vtc);
	xil_printf("Video timing generator initialized\r\n");
	return XST_SUCCESS;
}