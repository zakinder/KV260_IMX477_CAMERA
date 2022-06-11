// LAST TESTED : 09/08/2019
#ifndef __SYSTEM_CONFIG_DEFINES_H__
#define __SYSTEM_CONFIG_DEFINES_H__
#include "xparameters.h"


#define DEFAULT_HYPERTERMINAL_UART_ID 	XPAR_PS7_UART_1_DEVICE_ID
#define UART_BASEADDR        			XPAR_PSU_UART_1_BASEADDR
#define D5M_BASE        			    XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR

/*****************************************************************************************************************/
#define D5M_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define D5M_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
/*****************************************************************************************************************/



/*****************************************************************************************************************/
#ifndef uartPRINTF
#define uartPRINTF    printf
#endif
#define uart_Black_Text() uartPRINTF("\x1B[30m")
#define uart_Red_Text() uartPRINTF("\x1B[31m")
#define uart_Green_Text() uartPRINTF("\x1B[32m")
#define uart_Yellow_Text() uartPRINTF("\x1B[33m")
#define uart_Blue_Text() uartPRINTF("\x1B[34m")
#define uart_Magenta_Text() uartPRINTF("\x1B[35m")
#define uart_Cyan_Text() uartPRINTF("\x1B[36m")
#define uart_White_Text() uartPRINTF("\x1B[37m")
#define uart_Default_Text() uartPRINTF("\x1B[39m")
#define print_prompt() uartPRINTF("\x1B[31m")
#define print_prompt_Default_Text() uartPRINTF("\x1B[39m")
#define uart_Black_Background() uartPRINTF("\x1B[40m")
#define uart_Red_Background() uartPRINTF("\x1B[41m")
#define uart_Green_Background() uartPRINTF("\x1B[42m")
#define uart_Yellow_Background() uartPRINTF("\x1B[43m")
#define uart_Blue_Background() uartPRINTF("\x1B[44m")
#define uart_Magenta_Background() uartPRINTF("\x1B[45m")
#define uart_Cyan_Background() uartPRINTF("\x1B[46m")
#define uart_White_Background() uartPRINTF("\x1B[47m")
#define uart_Default_Background() uartPRINTF("\x1B[49m")
#define uart_Cursor_Home() uartPRINTF("\x1B[H")
#define uart_Cursor_Set_XY_Position(X,Y) uartPRINTF("\x1B[%d;%dH",X,Y)
#define uart_Cursor_Show() uartPRINTF("\x1B[?25h")
#define uart_Cursor_Hide() uartPRINTF("\x1B[?25l")
#define uart_Cursor_Up(Rows) uartPRINTF("\x1B[%dA",Rows)
#define uart_Cursor_Down(Rows) uartPRINTF("\x1B[%dB",Rows)
#define uart_Cursor_Left(Columns) uartPRINTF("\x1B[%dC",Columns)
#define uart_Cursor_Right(Columns) uartPRINTF("\x1B[%dD",Columns)
#define uart_Clear_Line_To_End() uartPRINTF("\x1B[0K")
#define uart_Clear_Line_Up_To_Cursor() uartPRINTF("\x1B[1K")
#define uart_Clear_Line() uartPRINTF("\x1B[2K")
#define uart_Clear_Screen() uartPRINTF("\x1B[2J")
#define uart_Clear_Screen_To_End() uartPRINTF("\x1B[J")
#define uart_Clear_Screen_Up_To_Cursor() uartPRINTF("\x1B[1J")
#define uart_Text_Attributes_None() uartPRINTF("\x1B[0m")
#define uart_Text_Attributes_Bold() uartPRINTF("\x1B[1m")
#define uart_Text_Attributes_italic() uartPRINTF("\x1B[3m")
#define uart_Text_Attributes_underline() uartPRINTF("\x1B[4m")
#define uart_Text_Attributes_strike() uartPRINTF("\x1B[9m")
#define uart_Text_Attributes_Dim() uartPRINTF("\x1B[2m")
#define uart_Text_Attributes_Blink() uartPRINTF("\x1B[5m")
#define uart_Text_Attributes_Reverse() uartPRINTF("\x1B[7m")
#define uart_Text_Attributes_Hidden() uartPRINTF("\x1B[8m")
#define uart_Mode_Insert() uartPRINTF("\x1B[4h")
#define uart_Mode_Overwrite() uartPRINTF("\x1B[4l")
#define uart_Mode_Scrolling_Smooth() uartPRINTF("\x1B[?4h")
#define uart_Mode_Scrolling_Jump() uartPRINTF("\x1B[?4l")
#define uart_Editing_Insert_Lines(Lines) uartPRINTF("\x1B[%dL",Lines)
#define uart_Editing_Delete_Lines(Lines) uartPRINTF("\x1B[%dM",Lines)
#define uart_Editing_Delete_Characters(Characters) uartPRINTF("\x1B[%dP",Characters)
/*****************************************************************************************************************/
#define KEYPRESS_ARROW_UP       240
#define KEYPRESS_ARROW_DOWN     241
#define KEYPRESS_ARROW_LEFT     242
#define KEYPRESS_ARROW_RIGHT    243
#define KEYPRESS_END            244
#define menu_select             1
#define menuCheck               19
#define clear                   0x10ECC0
#define mainmenu                0x4773053D
#define quit                    0x1EBAA
#define menucall                0x47B89810
#define kernal                  0xB49AAE
#define quit_current_state      0x71
#define cmds_quit               0x95BA400A
#define cmds_space              0x20
#define cmds_uart               0x95BA4834
#define imxwrite                0x45E01E71
#define imxread                 0x6FCB6D2
/*****************************************************************************************************************/
#endif // __SYSTEM_CONFIG_DEFINES_H__
