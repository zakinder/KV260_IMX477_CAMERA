// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xkv260_video_v_demosaic_1_0_v_demosaic.h"

extern XKv260_video_v_demosaic_1_0_v_demosaic_Config XKv260_video_v_demosaic_1_0_v_demosaic_ConfigTable[];

XKv260_video_v_demosaic_1_0_v_demosaic_Config *XKv260_video_v_demosaic_1_0_v_demosaic_LookupConfig(u16 DeviceId) {
	XKv260_video_v_demosaic_1_0_v_demosaic_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_NUM_INSTANCES; Index++) {
		if (XKv260_video_v_demosaic_1_0_v_demosaic_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XKv260_video_v_demosaic_1_0_v_demosaic_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XKv260_video_v_demosaic_1_0_v_demosaic_Initialize(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u16 DeviceId) {
	XKv260_video_v_demosaic_1_0_v_demosaic_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XKv260_video_v_demosaic_1_0_v_demosaic_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XKv260_video_v_demosaic_1_0_v_demosaic_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

