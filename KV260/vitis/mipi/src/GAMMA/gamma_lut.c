#include "xv_gamma_lut.h"
#include "xilinx-gamma-coeff.h"
#include "../config.h"
int gamma_lut_init() {
	XV_gamma_lut gamma_lut;
	XV_gamma_lut_Config *gamma_lut_config;

	if ( (gamma_lut_config = XV_gamma_lut_LookupConfig(XPAR_PS_VIDEO_RX_VIDEO_V_GAMMA_LUT_0_DEVICE_ID)) == NULL) {
		xil_printf("XV_gamma_lut_LookupConfig() failed\r\n");
		return XST_FAILURE;
	}
	if (XV_gamma_lut_CfgInitialize(&gamma_lut, gamma_lut_config, gamma_lut_config->BaseAddress)) {
		xil_printf("XV_gamma_lut_CfgInitialize() failed\r\n");
		return XST_FAILURE;
	}
	XV_gamma_lut_Set_HwReg_width(&gamma_lut, VIDEO_COLUMNS);
	XV_gamma_lut_Set_HwReg_height(&gamma_lut, VIDEO_ROWS);
    XV_gamma_lut_Set_HwReg_video_format(&gamma_lut, 0); // RGB
	if (XV_gamma_lut_Write_HwReg_gamma_lut_0_Words(&gamma_lut, 0, (int *) xgamma10_07,
			sizeof(xgamma10_10)/sizeof(int)) != sizeof(xgamma10_10)/sizeof(int)) {
		xil_printf("Gamma correction LUT write failed\r\n");
		return XST_FAILURE;
	}
	if (XV_gamma_lut_Write_HwReg_gamma_lut_1_Words(&gamma_lut, 0, (int *) xgamma10_07,
			sizeof(xgamma10_10)/sizeof(int)) != sizeof(xgamma10_10)/sizeof(int)) {
		xil_printf("Gamma correction LUT write failed\r\n");
		return XST_FAILURE;
	}
	if (XV_gamma_lut_Write_HwReg_gamma_lut_2_Words(&gamma_lut, 0, (int *) xgamma10_07,
			sizeof(xgamma10_10)/sizeof(int)) != sizeof(xgamma10_10)/sizeof(int)) {
		xil_printf("Gamma correction LUT write failed\r\n");
		return XST_FAILURE;
	}
	XV_gamma_lut_EnableAutoRestart(&gamma_lut);
	XV_gamma_lut_Start(&gamma_lut);
	xil_printf("Gamma correction LUT initialized\r\n");
	return XST_SUCCESS;
}

