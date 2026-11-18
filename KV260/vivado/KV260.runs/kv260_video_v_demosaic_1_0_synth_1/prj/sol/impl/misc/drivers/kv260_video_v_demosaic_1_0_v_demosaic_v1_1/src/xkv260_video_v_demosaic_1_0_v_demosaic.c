// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xkv260_video_v_demosaic_1_0_v_demosaic.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XKv260_video_v_demosaic_1_0_v_demosaic_CfgInitialize(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, XKv260_video_v_demosaic_1_0_v_demosaic_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress = ConfigPtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XKv260_video_v_demosaic_1_0_v_demosaic_Start(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_AP_CTRL) & 0x80;
    XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XKv260_video_v_demosaic_1_0_v_demosaic_IsDone(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XKv260_video_v_demosaic_1_0_v_demosaic_IsIdle(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XKv260_video_v_demosaic_1_0_v_demosaic_IsReady(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XKv260_video_v_demosaic_1_0_v_demosaic_EnableAutoRestart(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_AP_CTRL, 0x80);
}

void XKv260_video_v_demosaic_1_0_v_demosaic_DisableAutoRestart(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_AP_CTRL, 0);
}

void XKv260_video_v_demosaic_1_0_v_demosaic_Set_width(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_WIDTH_DATA, Data);
}

u32 XKv260_video_v_demosaic_1_0_v_demosaic_Get_width(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_WIDTH_DATA);
    return Data;
}

void XKv260_video_v_demosaic_1_0_v_demosaic_Set_height(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_HEIGHT_DATA, Data);
}

u32 XKv260_video_v_demosaic_1_0_v_demosaic_Get_height(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_HEIGHT_DATA);
    return Data;
}

void XKv260_video_v_demosaic_1_0_v_demosaic_Set_bayer_phase(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_BAYER_PHASE_DATA, Data);
}

u32 XKv260_video_v_demosaic_1_0_v_demosaic_Get_bayer_phase(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_BAYER_PHASE_DATA);
    return Data;
}

void XKv260_video_v_demosaic_1_0_v_demosaic_InterruptGlobalEnable(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_GIE, 1);
}

void XKv260_video_v_demosaic_1_0_v_demosaic_InterruptGlobalDisable(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_GIE, 0);
}

void XKv260_video_v_demosaic_1_0_v_demosaic_InterruptEnable(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_IER);
    XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_IER, Register | Mask);
}

void XKv260_video_v_demosaic_1_0_v_demosaic_InterruptDisable(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_IER);
    XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_IER, Register & (~Mask));
}

void XKv260_video_v_demosaic_1_0_v_demosaic_InterruptClear(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    //XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_ISR, Mask);
}

u32 XKv260_video_v_demosaic_1_0_v_demosaic_InterruptGetEnabled(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_IER);
}

u32 XKv260_video_v_demosaic_1_0_v_demosaic_InterruptGetStatus(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    // Current Interrupt Clear Behavior is Clear on Read(COR).
    return XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(InstancePtr->Kv260_video_v_demosaic_1_0_ctrl_BaseAddress, XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_KV260_VIDEO_V_DEMOSAIC_1_0_CTRL_ADDR_ISR);
}

