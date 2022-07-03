#include "menu_calls.h"

#include <stdio.h>
#include <xiicps.h>
#include <xil_printf.h>
#include <xstatus.h>


#include "../UART/uartio.h"
#include "config_defines.h"

void menu_calls(ON_OFF) {
    int menu_calls_enable = ON_OFF;
    unsigned int uart_io;
    u32 current_state = mainmenu;
    u32 k_number;
    u32 k_number_value;

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
            else if (k_number == 4 ||  k_number == 20 || k_number == 36 || k_number == 40 || k_number == 44 || k_number == 48 || k_number == 52 || k_number == 56 || k_number == 60 || k_number == 64 || k_number == 68 || k_number == 72 || k_number == 76)
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
            else if (k_number/4 == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
                printf("Enter Wrong Register Value\n");
            	current_state = kernal;break;
            }
        case kernal12:
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
                printf("K2 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG2))) & 0x0000ffff);
                printf("K3 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG3))) & 0x0000ffff);
                printf("K4 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG4))) & 0x0000ffff);
                printf("K5 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG5))) & 0x0000ffff);
                printf("K6 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG6))) & 0x0000ffff);
                printf("K7 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG7))) & 0x0000ffff);
                printf("K8 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG8))) & 0x0000ffff);
                printf("K9 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG9))) & 0x0000ffff);
                current_state = kernal12;break;
            }
            else if (k_number == 4 ||  k_number == 20 || k_number == 36 || k_number == 40 || k_number == 44 || k_number == 48 || k_number == 52 || k_number == 56 || k_number == 60 || k_number == 64 || k_number == 68 || k_number == 72 || k_number == 76 || k_number == 80 || k_number == 84 || k_number == 88 || k_number == 92 || k_number == 96 || k_number == 100 || k_number == 104 || k_number == 108 || k_number == 112 || k_number == 116 || k_number == 120 || k_number == 124 || k_number == 128 || k_number == 132 || k_number == 136 || k_number == 140 || k_number == 144 || k_number == 148 || k_number == 152 || k_number == 156 || k_number == 160 || k_number == 164 || k_number == 168 || k_number == 172 || k_number == 176)
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
                current_state = kernal12;break;
            }
            else if (k_number == 8 || k_number == 12 || k_number == 16 || k_number == 24 || k_number == 28 || k_number == 32)
            {
                printf("Enter K Number Value\n");
                menu_print_prompt();
                k_number_value = uart_prompt_io();
                per_write_reg(k_number,(k_number_value));
                printf("K1 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG1))) & 0x0000ffff);
                printf("K2 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG2))) & 0x0000ffff);
                printf("K3 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG3))) & 0x0000ffff);
                printf("K4 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG4))) & 0x0000ffff);
                printf("K5 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG5))) & 0x0000ffff);
                printf("K6 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG6))) & 0x0000ffff);
                printf("K7 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG7))) & 0x0000ffff);
                printf("K8 = -%i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG8))) & 0x0000ffff);
                printf("K9 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG9))) & 0x0000ffff);
                current_state = kernal12;break;
            }
            else if (k_number/4 == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
                printf("Enter Wrong Register Value\n");
            	current_state = kernal12;break;
            }
        case imx477c1:
            per_write_reg(REG1,5000);       // 5000
            per_write_reg(REG2,~500+1);     // -500
            per_write_reg(REG3,~500+1);     // -500
            per_write_reg(REG4,~500+1);     // -500
            per_write_reg(REG5,8000);       // 8000
            per_write_reg(REG6,~500+1);     // -500
            per_write_reg(REG7,0);          // 0
            per_write_reg(REG8,0);          // 0
            per_write_reg(REG9,2000);       // 2000
            printf("K1 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG1))) & 0x0000ffff);
            printf("K2 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG2))+1) & 0x0000ffff);
            printf("K3 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG3))+1) & 0x0000ffff);
            printf("K4 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG4))+1) & 0x0000ffff);
            printf("K5 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG5))) & 0x0000ffff);
            printf("K6 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG6))+1) & 0x0000ffff);
            printf("K7 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG7))+1) & 0x0000ffff);
            printf("K8 = -%i \n", (~(D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG8))+1) & 0x0000ffff);
            printf("K9 =  %i \n", ((D5M_mReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG9))) & 0x0000ffff);
            current_state = mainmenu;break;
        case readpixels:
        	fetch_rgb_data();
            current_state = mainmenu;break;
        case lwip:
        	//lwip_loop();
            current_state = mainmenu;break;
        case imxwrite:
            printf("Enter imx477 Register Address.\n");
            menu_print_prompt();
            k_number = uart_prompt_io();
            if (k_number == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
            	printf("Enter imx477 Register Data for the Register.\n");
                menu_print_prompt();
                k_number_value = uart_prompt_io();
                write_imx477_reg(k_number,k_number_value);
            	current_state = imxwrite;break;
            }
        case imxread:
            printf("Enter imx477 Register Address \n");
            menu_print_prompt();
            k_number = uart_prompt_io();
            if (k_number == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
            	read_imx477_reg(k_number);
            	current_state = imxread;break;
            }
        case write519:
            printf("Enter imx519 Register Address.\n");
            menu_print_prompt();
            k_number = uart_prompt_io();
            if (k_number == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
            	printf("Enter imx519 Register Data for the Register.\n");
                menu_print_prompt();
                k_number_value = uart_prompt_io();
                write_imx519_reg(k_number,k_number_value);
            	current_state = write519;break;
            }
        case read519:
            printf("Enter imx519 Register Address \n");
            menu_print_prompt();
            k_number = uart_prompt_io();
            if (k_number == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
            	read_imx519_reg(k_number);
            	current_state = read519;break;
            }
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
