// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_H
#define XKV260_VIDEO_V_DEMOSAIC_1_0_V_DEMOSAIC_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xkv260_video_v_demosaic_1_0_v_demosaic_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u64 Kv260_video_v_demosaic_1_0_ctrl_BaseAddress;
} XKv260_video_v_demosaic_1_0_v_demosaic_Config;
#endif

typedef struct {
    u64 Kv260_video_v_demosaic_1_0_ctrl_BaseAddress;
    u32 IsReady;
} XKv260_video_v_demosaic_1_0_v_demosaic;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XKv260_video_v_demosaic_1_0_v_demosaic_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XKv260_video_v_demosaic_1_0_v_demosaic_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XKv260_video_v_demosaic_1_0_v_demosaic_Initialize(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u16 DeviceId);
XKv260_video_v_demosaic_1_0_v_demosaic_Config* XKv260_video_v_demosaic_1_0_v_demosaic_LookupConfig(u16 DeviceId);
int XKv260_video_v_demosaic_1_0_v_demosaic_CfgInitialize(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, XKv260_video_v_demosaic_1_0_v_demosaic_Config *ConfigPtr);
#else
int XKv260_video_v_demosaic_1_0_v_demosaic_Initialize(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, const char* InstanceName);
int XKv260_video_v_demosaic_1_0_v_demosaic_Release(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
#endif

void XKv260_video_v_demosaic_1_0_v_demosaic_Start(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
u32 XKv260_video_v_demosaic_1_0_v_demosaic_IsDone(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
u32 XKv260_video_v_demosaic_1_0_v_demosaic_IsIdle(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
u32 XKv260_video_v_demosaic_1_0_v_demosaic_IsReady(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
void XKv260_video_v_demosaic_1_0_v_demosaic_EnableAutoRestart(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
void XKv260_video_v_demosaic_1_0_v_demosaic_DisableAutoRestart(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);

void XKv260_video_v_demosaic_1_0_v_demosaic_Set_width(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Data);
u32 XKv260_video_v_demosaic_1_0_v_demosaic_Get_width(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
void XKv260_video_v_demosaic_1_0_v_demosaic_Set_height(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Data);
u32 XKv260_video_v_demosaic_1_0_v_demosaic_Get_height(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
void XKv260_video_v_demosaic_1_0_v_demosaic_Set_bayer_phase(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Data);
u32 XKv260_video_v_demosaic_1_0_v_demosaic_Get_bayer_phase(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);

void XKv260_video_v_demosaic_1_0_v_demosaic_InterruptGlobalEnable(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
void XKv260_video_v_demosaic_1_0_v_demosaic_InterruptGlobalDisable(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
void XKv260_video_v_demosaic_1_0_v_demosaic_InterruptEnable(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Mask);
void XKv260_video_v_demosaic_1_0_v_demosaic_InterruptDisable(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Mask);
void XKv260_video_v_demosaic_1_0_v_demosaic_InterruptClear(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr, u32 Mask);
u32 XKv260_video_v_demosaic_1_0_v_demosaic_InterruptGetEnabled(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);
u32 XKv260_video_v_demosaic_1_0_v_demosaic_InterruptGetStatus(XKv260_video_v_demosaic_1_0_v_demosaic *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
