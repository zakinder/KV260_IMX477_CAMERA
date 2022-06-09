#include "demosaic.h"
#include "../config.h"
#include <xil_printf.h>
#include <xil_types.h>
#include <xparameters.h>
#include <xstatus.h>
#include <xv_demosaic.h>
int demosaic_init() {
	XV_demosaic demosaic;
	XV_demosaic_Config *demosaic_config;
	if ( (demosaic_config = XV_demosaic_LookupConfig(XPAR_PS_VIDEO_RX_VIDEO_V_DEMOSAIC_0_DEVICE_ID)) == NULL) {
		xil_printf("XV_demosaic_LookupConfig() failed\r\n");
		return XST_FAILURE;
	}
	if (XV_demosaic_CfgInitialize(&demosaic, demosaic_config, demosaic_config->BaseAddress)
			!= XST_SUCCESS) {
		xil_printf("XV_demosaic_CfgInitialize() failed\r\n");
		return XST_FAILURE;
	}
	XV_demosaic_Set_HwReg_width(&demosaic, VIDEO_COLUMNS);
	XV_demosaic_Set_HwReg_height(&demosaic, VIDEO_ROWS);
	XV_demosaic_Set_HwReg_bayer_phase(&demosaic, IMX219_BAYER_PHASE);
	if (!XV_demosaic_IsReady(&demosaic)) {
		xil_printf("demosaic core not ready\r\n");
		return XST_FAILURE;
	}
	XV_demosaic_EnableAutoRestart(&demosaic);
	XV_demosaic_Start(&demosaic);
	xil_printf("Demosiac module initialized\r\n");
	return XST_SUCCESS;
}
