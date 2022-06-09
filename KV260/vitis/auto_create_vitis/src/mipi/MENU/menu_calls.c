#include "menu_calls.h"

#include <stdio.h>
#include <xiicps.h>
#include <xil_printf.h>
#include <xstatus.h>

#include "../SENSORS_CONFIG/camera_sensors.h"
#include "../UART/uartio.h"
#include "config_defines.h"

XIicPs imx219_i2c_cam;
#define IIC_DEVICEID        XPAR_XIICPS_0_DEVICE_ID
void menu_calls(ON_OFF) {

    u8 sensor_id[2];
    int menu_calls_enable = ON_OFF;
    int Status;
    unsigned int uart_io;
    u32 current_state = mainmenu;
    u32 k_number;
    u32 k_number_value;
    u8 Send_Buffer [10];
    u8 Recv_Buffer [10];
//	 per_write_reg(REG1,2000);
//	 per_write_reg(REG2,0xff06);
//	 per_write_reg(REG3,0xff83);
//	 per_write_reg(REG4,0xff83);
//	 per_write_reg(REG5,2000);
//	 per_write_reg(REG6,0xff06);
//	 per_write_reg(REG7,0xff06);
//	 per_write_reg(REG8,0xff83);
//	 per_write_reg(REG9,2000);
//	 per_write_reg(REG0,1);
//	 per_write_reg(REG11,6);

	 usleep(100000);

    while (menu_calls_enable == TRUE)
    {
        switch (current_state)
        {
        case mainmenu:
            cmds_menu();
            current_state = menu_select;
            break;
        case menu_select:
            uart_io = uart_prompt_io();
            if (uart_io == 0) {
                uart_Red_Text();
                printf("Unknown command entered %x\r\n",(unsigned) uart_io);
                printf("\r>>");
                uart_Default_Text();
                break;
            } else {
                uart_Default_Text();
                current_state = uart_io;
                break;
            }
            break;
        case clear:
            menu_cls();
            current_state = mainmenu;break;
        case kernal:
            printf("Enter k_number\n");
            menu_print_prompt();
            k_number = uart_prompt_io()*4;
            if (k_number == 0)
            {
                printf("Enter K Number Value\n");
                menu_print_prompt();
                k_number_value = uart_prompt_io();
                per_write_reg(k_number,k_number_value);
                printf("K1 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG1))) & 0x0000ffff);
                printf("K2 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG2))+1) & 0x0000ffff);
                printf("K3 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG3))+1) & 0x0000ffff);
                printf("K4 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG4))+1) & 0x0000ffff);
                printf("K5 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG5))) & 0x0000ffff);
                printf("K6 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG6))+1) & 0x0000ffff);
                printf("K7 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG7))+1) & 0x0000ffff);
                printf("K8 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG8))+1) & 0x0000ffff);
                printf("K9 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG9))) & 0x0000ffff);
                current_state = kernal;break;
            }
            else if (k_number == 4 ||  k_number == 20 || k_number == 36 || k_number == 40 || k_number == 44 || k_number == 48 || k_number == 52 || k_number == 56 || k_number == 60 || k_number == 64 || k_number == 68 || k_number == 72)
            {
                printf("Enter K Number Value\n");
                menu_print_prompt();
                k_number_value = uart_prompt_io();
                per_write_reg(k_number,k_number_value);
                printf("K1 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG1))) & 0x0000ffff);
                printf("K2 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG2))+1) & 0x0000ffff);
                printf("K3 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG3))+1) & 0x0000ffff);
                printf("K4 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG4))+1) & 0x0000ffff);
                printf("K5 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG5))) & 0x0000ffff);
                printf("K6 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG6))+1) & 0x0000ffff);
                printf("K7 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG7))+1) & 0x0000ffff);
                printf("K8 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG8))+1) & 0x0000ffff);
                printf("K9 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG9))) & 0x0000ffff);
                current_state = kernal;break;
            }
            else if (k_number == 8 || k_number == 12 || k_number == 16 || k_number == 24 || k_number == 28 || k_number == 32)
            {
                printf("Enter K Number Value\n");
                menu_print_prompt();
                k_number_value = uart_prompt_io();
                per_write_reg(k_number,(~k_number_value)+1);
                printf("K1 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG1))) & 0x0000ffff);
                printf("K2 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG2))+1) & 0x0000ffff);
                printf("K3 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG3))+1) & 0x0000ffff);
                printf("K4 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG4))+1) & 0x0000ffff);
                printf("K5 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG5))) & 0x0000ffff);
                printf("K6 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG6))+1) & 0x0000ffff);
                printf("K7 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG7))+1) & 0x0000ffff);
                printf("K8 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG8))+1) & 0x0000ffff);
                printf("K9 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG9))) & 0x0000ffff);
                current_state = kernal;break;
            }
            else if (k_number == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
                printf("Enter Wrong Register Value\n");
            	current_state = kernal;break;
            }
        case imxwrite:
        	tpg_init(0);
        	current_state = mainmenu;break;
        case imxread:
        	tpg_init(1);
        	current_state = mainmenu;break;
        case quit:
            menu_calls_enable = FALSE;
            break;
        case cmds_uart:
            uartvalue();
            current_state =uartcmd(mainmenu,cmds_uart);
            break;
        default:
            printf("\r\n");
            current_state = mainmenu;
            break;
        }
    }
    printf("Break\r\n");
    menu_calls_enable = TRUE;
}
