#include "vdma.h"
#include <stdio.h>
#include <sys/_stdint.h>
#include <sys/unistd.h>
#include <xaxivdma_hw.h>
#include <xbasic_types.h>
#include <xdebug.h>
#include <xil_printf.h>
#include <xstatus.h>
#include <xtime_l.h>
#include "../config.h"
const int res = 1920 * 1080;
uint32_t bayer[1920 * 1080 * 4];
uint32_t to8(Xuint32 data){
	data &= 0x3FFFFFFF;
	return (uint32_t)(data);
}

u32 vdma_version(XAxiVdma *Vdma) {
	return XAxiVdma_GetVersion(Vdma);
}
int vdma_read_start(XAxiVdma *Vdma) {
	int Status;
	Status = XAxiVdma_DmaStart(Vdma, XAXIVDMA_READ);
	if (Status != XST_SUCCESS)
	{
	   xil_printf("Start read transfer failed %d\n\r", Status);
	   return XST_FAILURE;
	}
	return XST_SUCCESS;
}
int vdma_read_stop(XAxiVdma *Vdma) {
	XAxiVdma_DmaStop(Vdma, XAXIVDMA_READ);
	return XST_SUCCESS;
}
int vdma_read_init(short DeviceID,short HoriSizeInput,short VertSizeInput,short Stride,unsigned int FrameStoreStartAddr)
{
	XAxiVdma Vdma;
	XAxiVdma_Config *Config;
	XAxiVdma_DmaSetup ReadCfg;
	int Status;
	Config = XAxiVdma_LookupConfig(DeviceID);
	if (NULL == Config) {
		xil_printf("XAxiVdma_LookupConfig failure\r\n");
		return XST_FAILURE;
	}
	Status = XAxiVdma_CfgInitialize(&Vdma, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("XAxiVdma_CfgInitialize failure\r\n");
		return XST_FAILURE;
	}
	ReadCfg.EnableCircularBuf   = 1;
	ReadCfg.EnableFrameCounter  = 0;
	ReadCfg.FixedFrameStoreAddr = 0;
	ReadCfg.EnableSync          = 1;
	ReadCfg.PointNum            = 1;
	ReadCfg.FrameDelay          = 0;
	ReadCfg.VertSizeInput       = VertSizeInput;
	ReadCfg.HoriSizeInput       = HoriSizeInput;
	ReadCfg.Stride              = Stride;
	Status = XAxiVdma_DmaConfig(&Vdma, XAXIVDMA_READ, &ReadCfg);
	if (Status != XST_SUCCESS) {
			xdbg_printf(XDBG_DEBUG_ERROR,
				"Read channel config failed %d\r\n", Status);
			return XST_FAILURE;
	}
	ReadCfg.FrameStoreStartAddr[0] = FrameStoreStartAddr;
	Status = XAxiVdma_DmaSetBufferAddr(&Vdma, XAXIVDMA_READ, ReadCfg.FrameStoreStartAddr);
	if (Status != XST_SUCCESS) {
			xdbg_printf(XDBG_DEBUG_ERROR,"Read channel set buffer address failed %d\r\n", Status);
			return XST_FAILURE;
	}
	Status = vdma_read_start(&Vdma);
	if (Status != XST_SUCCESS) {
		   xil_printf("error starting VDMA..!");
		   return Status;
	}
	return XST_SUCCESS;
}
int vdma_write_start(XAxiVdma *Vdma) {
	int Status;
	// MM2S Startup
	Status = XAxiVdma_DmaStart(Vdma, XAXIVDMA_WRITE);
	if (Status != XST_SUCCESS)
	{
	   xil_printf("Start write transfer failed %d\n\r", Status);
	   return XST_FAILURE;
	}
	return XST_SUCCESS;
}
int vdma_write_stop(XAxiVdma *Vdma) {
	XAxiVdma_DmaStop(Vdma, XAXIVDMA_WRITE);
	return XST_SUCCESS;
}
int vdma_write_init(short DeviceID,short HoriSizeInput,short VertSizeInput,short Stride,unsigned int FrameStoreStartAddr1,unsigned int FrameStoreStartAddr2,unsigned int FrameStoreStartAddr3)
{
    
	XAxiVdma Vdma;
	XAxiVdma_Config *Config;
	XAxiVdma_DmaSetup vdmaDMA;
	int Status;
	Config = XAxiVdma_LookupConfig(DeviceID);
	if (NULL == Config) {
		xil_printf("XAxiVdma_LookupConfig failure\r\n");
		return XST_FAILURE;
	}
	Status = XAxiVdma_CfgInitialize(&Vdma, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("XAxiVdma_CfgInitialize failure\r\n");
		return XST_FAILURE;
	}
	vdmaDMA.EnableCircularBuf       = 1;
	vdmaDMA.EnableFrameCounter      = 0;
	vdmaDMA.FixedFrameStoreAddr     = 1;
	vdmaDMA.EnableSync              = 1;
	vdmaDMA.PointNum                = 1;
	vdmaDMA.FrameDelay              = 0;
	vdmaDMA.VertSizeInput           = VertSizeInput;
	vdmaDMA.HoriSizeInput           = HoriSizeInput;
	vdmaDMA.Stride                  = Stride;
	vdmaDMA.EnableVFlip             = 1;
	vdmaDMA.FrameStoreStartAddr[0]  = FrameStoreStartAddr1;
	vdmaDMA.FrameStoreStartAddr[1]  = FrameStoreStartAddr2;
	vdmaDMA.FrameStoreStartAddr[2]  = FrameStoreStartAddr3;
	xil_printf("FrameStoreStartAddr1 = %X\n\r", FrameStoreStartAddr1);
	xil_printf("FrameStoreStartAddr2 = %X\n\r", FrameStoreStartAddr2);
	xil_printf("FrameStoreStartAddr3 = %X\n\r", FrameStoreStartAddr3);
    
	Status = XAxiVdma_DmaConfig(&Vdma, XAXIVDMA_WRITE, &vdmaDMA);
	if (Status != XST_SUCCESS) {
			xdbg_printf(XDBG_DEBUG_ERROR,"Write channel config failed %d\r\n", Status);
			return XST_FAILURE;
	}
	Status = XAxiVdma_DmaSetBufferAddr(&Vdma, XAXIVDMA_WRITE, vdmaDMA.FrameStoreStartAddr);
	if (Status != XST_SUCCESS) {
			xdbg_printf(XDBG_DEBUG_ERROR,"Write channel set buffer address failed %d\r\n", Status);
			return XST_FAILURE;
	}
	Status = XAxiVdma_DmaConfig(&Vdma, XAXIVDMA_READ, &(vdmaDMA));
	if (Status != XST_SUCCESS) {
		xdbg_printf(XDBG_DEBUG_ERROR,"Read channel config failed %d\r\n", Status);
			return XST_FAILURE;
	}
	Status = XAxiVdma_DmaSetBufferAddr(&Vdma, XAXIVDMA_READ,vdmaDMA.FrameStoreStartAddr);
	if (Status != XST_SUCCESS) {
			xdbg_printf(XDBG_DEBUG_ERROR,"Write channel set buffer address failed %d\r\n", Status);
			return XST_FAILURE;
	}
	Status = XAxiVdma_DmaStart(&Vdma, XAXIVDMA_WRITE);
	if (Status != XST_SUCCESS) {
		   xil_printf("Error Starting XAXIVDMA_WRITE..!");
		   return Status;
	}
	Status = XAxiVdma_StartParking(&Vdma, 0, XAXIVDMA_WRITE);
	if (Status != XST_SUCCESS) {
		   xil_printf("Error Starting XAXIVDMA_WRITE..!");
		   return Status;
	}
	Status = XAxiVdma_DmaStart(&Vdma, XAXIVDMA_READ);
	if (Status != XST_SUCCESS) {
		   xil_printf("Error Starting XAxiVdma_DmaStart..!");
		   return Status;
	}
	Status = XAxiVdma_StartParking(&Vdma, 1, XAXIVDMA_READ);
	if (Status != XST_SUCCESS) {
		   xil_printf("Error Starting XAxiVdma_StartParking..!");
		   return Status;
	}
    //sleep(4);
    fetch_rgb_data();
	return XST_SUCCESS;
}

void fetch_rgb_data() {
	Xuint32 parkptr, vdma_S2MM_DMACR, vdma_MM2S_DMACR;
	int i, j;
	XAxiVdma Vdma;
	XAxiVdma_Config *Config;
	XAxiVdma_DmaSetup vdmaDMA;
	int Status;
	xil_printf("Entering main SW processing loop\r\n");
	// Grab the DMA parkptr, and update it to ensure that when parked, the S2MM side is on frame 0, and the MM2S side on frame 1
	parkptr = XAxiVdma_ReadReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_PARKPTR_OFFSET);
	parkptr &= ~XAXIVDMA_PARKPTR_READREF_MASK;
	parkptr &= ~XAXIVDMA_PARKPTR_WRTREF_MASK;
	parkptr |= 0x1;
	XAxiVdma_WriteReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_PARKPTR_OFFSET, parkptr);
	// Grab the DMA Control Registers, and clear circular park mode.
	vdma_MM2S_DMACR = XAxiVdma_ReadReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_TX_OFFSET+XAXIVDMA_CR_OFFSET);
	XAxiVdma_WriteReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_TX_OFFSET+XAXIVDMA_CR_OFFSET, vdma_MM2S_DMACR & ~XAXIVDMA_CR_TAIL_EN_MASK);
	vdma_S2MM_DMACR = XAxiVdma_ReadReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_RX_OFFSET+XAXIVDMA_CR_OFFSET);
	XAxiVdma_WriteReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_RX_OFFSET+XAXIVDMA_CR_OFFSET, vdma_S2MM_DMACR & ~XAXIVDMA_CR_TAIL_EN_MASK);
	// Pointers to the S2MM memory frame and M2SS memory frame
	Xuint32 *pS2MM_Mem = (Xuint32 *)XAxiVdma_ReadReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_S2MM_ADDR_OFFSET+XAXIVDMA_START_ADDR_OFFSET);
	Xuint32 *pMM2S_Mem = (Xuint32 *)XAxiVdma_ReadReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_MM2S_ADDR_OFFSET+XAXIVDMA_START_ADDR_OFFSET+4);
	Xuint32 *pMM2S2Mem = (Xuint32 *)XAxiVdma_ReadReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_MM2S_ADDR_OFFSET+XAXIVDMA_START_ADDR_OFFSET+8);
	xil_printf("pS2MM_Mem = %X\n\r", pS2MM_Mem);
	xil_printf("pMM2S_Mem = %X\n\r", pMM2S_Mem);
	uint32_t Blue = 0, Red = 0, Green = 0;
    
    Xil_DCacheFlush();
	for (j = 0; j < 5; j++) {
            for (i = 0; i < res; i++) {
                Red           = (pS2MM_Mem[i] & 0x3ff00000)>>20;
                Green         = (pS2MM_Mem[i] & 0x000ffc00)>>10;
                Blue          = (pS2MM_Mem[i] & 0x000003ff);
            if(j<1 && i<5){
            printf  ("Y:%i X:%i Red:%x  Green:%x  Blue:%x \r\n",j,i,Red,Green,Blue);
            //printf  ("Y:%i X:%i Blue:%x  Green:%x  Red:%x \r\n",y,x,(unsigned)Blue,(unsigned)Green,(unsigned)Red);
            }
                //Red                = 0x0222;
                //Green              = 0x0333;
                //Blue               = 0x0111;
                //uint32_t Cb       = (uint32_t)((((((int)Blue) * 1) + (((int)Red) * 0) + (((int)Green) * 0)) / 1));
                //uint32_t Cr       = (uint32_t)((((((int)Blue) * 0) + (((int)Red) * 1) + (((int)Green) * 0)) / 1));
                //uint32_t Y1       = (uint32_t)((((((int)Blue) * 0) + (((int)Red) * 0) + (((int)Green) * 1)) / 1));
                uint32_t final1   = (((Red) << 20) | ((Blue) << 10) | ((Green)));
                pMM2S_Mem[i]      = final1;
                //pMM2S_Mem[i]      = pS2MM_Mem[i];
            }
	}
    Xil_DCacheFlush();     //Refresh the Cache, and update the data to 
	//Grab the DMA Control Registers, and re-enable circular park mode.
	vdma_MM2S_DMACR = XAxiVdma_ReadReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_TX_OFFSET+XAXIVDMA_CR_OFFSET);
	XAxiVdma_WriteReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_TX_OFFSET+XAXIVDMA_CR_OFFSET, vdma_MM2S_DMACR | XAXIVDMA_CR_TAIL_EN_MASK);
	vdma_S2MM_DMACR = XAxiVdma_ReadReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_RX_OFFSET+XAXIVDMA_CR_OFFSET);
	XAxiVdma_WriteReg(XPAR_PS_VIDEO_V_DMA_AXI_VDMA_0_BASEADDR, XAXIVDMA_RX_OFFSET+XAXIVDMA_CR_OFFSET, vdma_S2MM_DMACR | XAXIVDMA_CR_TAIL_EN_MASK);
	return;
}
