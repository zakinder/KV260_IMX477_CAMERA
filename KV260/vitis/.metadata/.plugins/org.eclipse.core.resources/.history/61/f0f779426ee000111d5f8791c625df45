// LAST TESTED : 09/01/2019
#ifndef __MENU_CALLS_H__
#define __MENU_CALLS_H__

#include <ff.h>
#include <xil_types.h>

#include "vfp_registers.h"

#define VFP_PREVIEW_BYPASS 0U

u32 uartcmd(u32 argA,u32 argB);
void menu_calls(int ON_OFF,char *head_buf, char *data_buf, u32 stride, int connected_camera);
#define PL_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#endif // __MENU_CALLS_H__
