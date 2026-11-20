#include "xcsiss.h"
int mipi_init() {
	XCsiSs mipi;
	XCsiSs_Config *mipi_config;
	if ( (mipi_config = XCsiSs_LookupConfig(XPAR_PS_VIDEO_RX_VIDEO_MIPI_CSI2_RX_SUBSYST_0_RX_DEVICE_ID)) == NULL) {
		xil_printf("Xcsiss LookupConfig() failed\r\n");
		return XST_FAILURE;
	}
	if (XCsiSs_CfgInitialize(&mipi, mipi_config, mipi_config->BaseAddr) != XST_SUCCESS) {
		xil_printf("Xcsiss CfgInitialize() failed\r\n");
		return XST_FAILURE;
	}
	if (XCsiSs_Configure(&mipi, 2, 0) != XST_SUCCESS) {
		xil_printf("MIPI Configuration Failed\r\n");
		return XST_FAILURE;
	}
	if (XCsiSs_SelfTest(&mipi) != XST_SUCCESS) {
		xil_printf("MIPI Failed Self Test\r\n");
		return XST_FAILURE;
	}
	if (XCsiSs_Activate(&mipi, 1) != XST_SUCCESS) {
		xil_printf("MIPI Failed To Activate\r\n");
		return XST_FAILURE;
	}
	xil_printf("MIPI CSI-2 Rx Initialized\r\n");
	return XST_SUCCESS;
}
