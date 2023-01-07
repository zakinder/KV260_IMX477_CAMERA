#include "clk_wiz.h"
#include <xil_printf.h>
#include <xstatus.h>
#include <xvidc.h>
XClk_Wiz ClkWiz_Dynamic; /* The instance of the ClkWiz_Dynamic */
/*****************************************************************************/
/**
 *
 * This is the Wait_For_Lock function, it will wait for lock to settle change
 * frequency value
 *
 * @param	CfgPtr_Dynamic provides pointer to clock wizard dynamic config
 *
 * @return
 *		- Error 0 for pass scenario
 *		- Error > 0 for failure scenario
 *
 * @note		None
 *
 ******************************************************************************/
int Wait_For_Lock(XClk_Wiz_Config *CfgPtr_Dynamic)
{
    u32 Count = 0;
    u32 Error = 0;

    while(!(*(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x04) & CLK_LOCK))
    {
        if(Count == 10000)
        {
            Error++;
            break;
        }
        Count++;
    }
    return Error;
}
/*****************************************************************************/
/**
 *
 * XClk_Wiz wizard dynamic reconfig.
 *
 * @param	None.
 *
 * @return
 *		- XST_SUCCESS if XClk_Wiz dynamic reconfig ran successfully.
 *		- XST_FAILURE if XClk_Wiz dynamic reconfig failed.
 *
 * @note		None.
 *
 ****************************************************************************/
int XClk_Wiz_dynamic_reconfig(XClk_Wiz * ClkWizInstance, u32 DeviceId,XVidC_VideoMode TestMode)
{
    XClk_Wiz_Config *CfgPtr_Dynamic;
    u32 Count = 0;
    u32 Divide = 0;
    u32 Multiply_Int = 0;
    u32 Multiply_Frac = 0;
    u32 Divide0_Int = 0;
    u32 Divide0_Frac = 0;
    u32 Divide1_Int = 0;
    u32 Divide1_Frac = 0;
    u32 Divide2_Int = 0;
    u32 Divide2_Frac = 0;
    int Status;
    CfgPtr_Dynamic = XClk_Wiz_LookupConfig(DeviceId);
    if(!CfgPtr_Dynamic)
    {
    	 xil_printf("XST_FAILURE\r\n");
        return XST_FAILURE;

    }
    Status = XClk_Wiz_CfgInitialize(ClkWizInstance, CfgPtr_Dynamic, CfgPtr_Dynamic->BaseAddr);
    if(Status != XST_SUCCESS)
    {
   	 xil_printf("XST_FAILURE\r\n");
        return XST_FAILURE;
    }
    Status = Wait_For_Lock(CfgPtr_Dynamic);
    if(Status)
    {
        xil_printf("\n ERROR: Clock is not locked for default frequency : 0x%x\n\r",*(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x04) & CLK_LOCK);
    }
    /* SW reset applied */
    *(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x00) = 0xA;

    if(*(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x04) & CLK_LOCK)
    {
        xil_printf("\n ERROR: Clock is locked : 0x%x \t expected 0x00\n\r",*(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x04) & CLK_LOCK);
    }
    /* Wait cycles after SW reset */
    for(Count = 0; Count < 2000; Count++);
    Status = Wait_For_Lock(CfgPtr_Dynamic);
    if(Status)
    {
        xil_printf("\n ERROR: Clock is not locked after SW reset :""0x%x \t Expected  : 0x1\n\r",*(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x04) & CLK_LOCK);
    }
    if(TestMode == XVIDC_VM_1920x1080_60_P)
    {   // Settings for 148.5MHz Clock
		Multiply_Int = 86;
		Multiply_Frac = 875;
		Divide = 9;
		Divide0_Int = 6;
		Divide0_Frac = 500;
    }
    else if(TestMode == XVIDC_VM_3840x2160_30_P)
    {   // Settings for 297MHz Clock
		Multiply_Int = 37;
		Multiply_Frac = 125;
		Divide = 4;
		Divide0_Int = 3;
		Divide0_Frac = 125;
    }
    /* Configuring Multiply and Divide values */
    *(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x200) = (Multiply_Frac << 16) | (Multiply_Int << 8) | Divide;
    *(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x204) = 0x00;
    /* Configuring Multiply and Divide values */
    *(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x208) = (Divide0_Frac << 8) | Divide0_Int;
    *(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x20C) = 0x00;
    /* Load Clock Configuration Register values */
    *(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x25C) = 0x07;

    if(*(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x04) & CLK_LOCK)
    {
        xil_printf("\n ERROR: Clock is locked : 0x%x \t expected " "0x00\n\r",*(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x04) & CLK_LOCK);
    }
    /* Clock Configuration Registers are used for dynamic reconfiguration */
    *(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x25C) = 0x02;
    Status = Wait_For_Lock(CfgPtr_Dynamic);
    if(Status)
    {
        xil_printf("\n ERROR: Clock is not locked : 0x%x \t Expected "": 0x1\n\r",*(u32 *) (CfgPtr_Dynamic->BaseAddr + 0x04) & CLK_LOCK);
    }
    return XST_SUCCESS;
}
