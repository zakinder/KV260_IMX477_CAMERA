#include "xv_tpg.h"
#include "xvidc.h"
#include "../config.h"
int tpg_init(int en_input) {
	XV_tpg tpg;
	XV_tpg_Config *tpg_config;
    if ( (tpg_config = XV_tpg_LookupConfig(XPAR_XV_TPG_0_DEVICE_ID)) == NULL) {
		xil_printf("XV_tpg_LookupConfig() failed\r\n");
		return XST_FAILURE;
	}
    if (XV_tpg_CfgInitialize(&tpg, tpg_config, tpg_config->BaseAddress) != XST_SUCCESS) {
		xil_printf("XV_tpg_CfgInitialize() failed\r\n");
		return XST_FAILURE;
	}
	XV_tpg_Set_height(&tpg, VIDEO_ROWS);
	XV_tpg_Set_width(&tpg, VIDEO_COLUMNS);
	XV_tpg_Set_colorFormat(&tpg, XVIDC_CSF_RGB);
	XV_tpg_Set_maskId(&tpg, 0x0);
	XV_tpg_Set_motionSpeed(&tpg, 0x4);
	XV_tpg_Set_bckgndId(&tpg, XTPG_BKGND_TARTAN_COLOR_BARS);
	XV_tpg_Set_passthruStartX(&tpg, 0);
	XV_tpg_Set_passthruStartY(&tpg, 0);
	XV_tpg_Set_passthruEndX(&tpg, VIDEO_COLUMNS);
	XV_tpg_Set_passthruEndY(&tpg, VIDEO_ROWS);
	xil_printf("Test pattern generator configured for passthrough video\r\n");
	XV_tpg_Set_enableInput(&tpg, en_input);
	XV_tpg_EnableAutoRestart(&tpg);
	XV_tpg_Start(&tpg);
	xil_printf("Test pattern generator initialized\r\n");
	return XST_SUCCESS;
}