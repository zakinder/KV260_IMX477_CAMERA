#include "uartio.h"
#include <stdio.h>
#include <string.h>
#include <sys/unistd.h>
#include "../menu/config_defines.h"
char uart_per_char_read(u32 uart_address)
{
	char uart_io;
    if (uart_address == UART_BASEADDR)
        read(1, (char*) &uart_io, 1);
    return (uart_io);
}
void per_write_reg(u32 offset, u32 data)
{
	D5M_mWriteReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,offset,data);
}
char* char_to_uart(char auserinput[])
{
    int nTemp;
    int i;
    int nNumberBits = 32;
    char userinput = 0;
    int received_uart_data = 0;
    char nReturnVal = 0;
    nTemp = bit_expo(2, nNumberBits) - 1;
    fflush(stdout);
    while (userinput != 13) {
        userinput = uart_per_char_read(UART_BASEADDR);
            auserinput[received_uart_data++] = userinput;
            //printf("%s", auserinput);
            printf("%c", userinput);
            fflush(stdout);
        if (userinput == 13) {
            for (i = 0; i < received_uart_data; i++) {
                nReturnVal += auserinput[i] * bit_expo(10, received_uart_data - i - 1);
            }
            if (nReturnVal > nTemp)
                nReturnVal = nTemp;
        }
    }
    printf("\r>>\r\n", nReturnVal);
    return (nReturnVal);
}
// char* char_to_uart(char uart_s[])
// {
	// char uart_s = uart_per_char_read(UART_BASEADDR);
    // return (uart_s);
// }
u8 uart_per_byte_read(u32 uart_address) 
{
    u8 uart_io;
    if (uart_address == UART_BASEADDR)
        read(1, (char*) &uart_io, 1);
    return (uart_io);
}
u16 uart_two_byte_read(u32 uart_address)
{
    u16 uart_io;
    if (uart_address == UART_BASEADDR)
        read(1, (char*) &uart_io, 1);
    return (uart_io);
}
u8 keypress_to_uart(u32 uart_address)
{
	u32 uart_io;
	uart_io = uart_per_byte_read(uart_address);
	if (uart_io == 27) {
		uart_io = uart_per_byte_read(uart_address);
		if (uart_io == 91) {
			uart_io = uart_per_byte_read(uart_address);
			if (uart_io == 65)
				uart_io = KEYPRESS_ARROW_UP - 10;
			if (uart_io == 66)
				uart_io = KEYPRESS_ARROW_DOWN - 10;
			if (uart_io == 67)
				uart_io = KEYPRESS_ARROW_RIGHT - 10;
			if (uart_io == 68)
				uart_io = KEYPRESS_ARROW_LEFT - 10;
			if (uart_io == 75)
				uart_io = KEYPRESS_END - 10;
		}
	} else if (uart_io >= 48 && uart_io <= 57)
		uart_io -= 48;
	else if (uart_io >= 97 && uart_io <= 122)
		uart_io -= 32;
    return (uart_io);
}
u32 uart_prompt_io()
{
    int nTemp;
    int i;
    int nNumberBits = 32;
    u8 userinput = 0;
    int received_uart_data = 0;
    u8 auserinput[8];
    u32 nReturnVal = 0;
    nTemp = bit_expo(2, nNumberBits) - 1;
    fflush(stdout);
    while (userinput != 13) {
        userinput = uart_two_byte_read(UART_BASEADDR);
        if (userinput == 32) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            printf(" ");
            fflush(stdout);
        } else if ((userinput >= 48 && userinput <= 57)) {
            userinput -= 48;
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            uart_Cyan_Text();
            printf("%d", userinput);
            uart_Default_Text();
            fflush(stdout);
        } else if (userinput >= 65 && userinput <= 90) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            uart_Magenta_Text();
            printf("%c", userinput);
            uart_Default_Text();
            fflush(stdout);
        } else if (userinput >= 97 && userinput <= 122) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            uart_Magenta_Text();
            printf("%c", userinput);
            uart_Default_Text();
            fflush(stdout);
        } else if (userinput == 13) {
            for (i = 0; i < received_uart_data; i++) {
                nReturnVal += auserinput[i]
                        * bit_expo(10, received_uart_data - i - 1);
            }
            if (nReturnVal > nTemp)
                nReturnVal = nTemp;
        }
    }
    uart_Cyan_Text();
    printf("\r>>\r\n", nReturnVal);
    uart_Default_Text();
    return (nReturnVal);
}
int bit_expo(int base_value, int exponent)
{
    int i = 0;
    int nValue = 0;
    if (exponent == 0)
        nValue = 1;
    else {
        nValue = base_value;
        for (i = 1; i < exponent; i++) {
            nValue = nValue * base_value;
        }
    }
    return (nValue);
}
unsigned int uart_prompt_excute()
{
    int nTemp;
    int i;
    int nNumberBits = 32;
    u8 userinput = 0;
    int received_uart_data = 0;
    u8 auserinput[8];
    unsigned int nReturnVal = 0;
    nTemp = bit_expo(2, nNumberBits) - 1;
    printf(":");
    fflush(stdout);
    while (userinput != 13) {
        userinput = uart_two_byte_read(UART_BASEADDR);
        if (userinput == 32) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            printf(" ");
            fflush(stdout);
        } else if ((userinput >= 48 && userinput <= 57)) {
            userinput -= 48;
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            printf("%d", userinput);
            fflush(stdout);
        } else if (userinput >= 65 && userinput <= 90) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            printf("%C", userinput);
            fflush(stdout);
        } else if (userinput >= 97 && userinput <= 122) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            printf("%c", userinput);
            fflush(stdout);
        } else if (userinput == 13) {
            for (i = 0; i < received_uart_data; i++) {
                nReturnVal += auserinput[i]
                        * bit_expo(10, received_uart_data - i - 1);
            }
            if (nReturnVal > nTemp)
                nReturnVal = nTemp;
        }
    }
    printf("\r>> %c\r\n", nReturnVal);
    return (nReturnVal);
}
void uartvalue()
{
    u32 ascii_char = 1;
    ascii_char = uart_prompt_excute();
    printf("uarttester = %X\r\n", ascii_char);
    printf("uarttester = %d\r\n", ascii_char);
    printf("uarttester = %i\r\n", ascii_char);
    printf("uarttester = %x\r\n", ascii_char);
    printf("uarttester = %c\r\n", ascii_char);
    printf("uarttester = %s\r\n", ascii_char);
}
/*******************************************************/
/*
u32 enter_value_or_quit(arg1,arg2);
arg1 value : null or valid_state or invalid_state
             null          : return routine cmds
             valid_state   : return user entered valid state.
             invalid_state : return if user entered invalid state then arg2 is returned.
arg2 value : depended on arg1 if invalid state then arg2 is returned.
*/
u32 enter_value_or_quit(char s[],u32 current_state)
{
    u32 value_enter_quit;
    int result;
    char command_print[200];
    strcpy(command_print, "null");
    result = strcmp(command_print, s);
    if (result == 0)
    {
        printf("Enter Value:\n");
        menu_print_prompt();
        value_enter_quit = uart_prompt_io();
        if (value_enter_quit == 0x71 || value_enter_quit == 0x51)
        {
            return quit_current_state;
        }
        else if (value_enter_quit == 0)
        {
            return value_enter_quit;
        }
        else
        {
            return value_enter_quit;
        }
    }
    else
    {
        cmds_menu();
        uart_Green_Text();
        printf("Press Enter to remain in Current State : %s or Above cmds\n",s);
        uart_Default_Text();
        menu_print_prompt();
        value_enter_quit = uart_prompt_io();
        if (value_enter_quit == 0)
        {
            printf("Last State :%s\n",s);
            return current_state;
        }
        else
        {
            printf("Last State :%s\n",s);
            return value_enter_quit;
        }
    }
}
u32 enter_or_quit(char s[],u32 current_state)
{
    u32 value_enter_quit;
    int result;
    char command_print[200];
    strcpy(command_print, "null");
    result = strcmp(command_print, s);
    if (result == 0)
    {
        printf("Enter Value:\n");
        menu_print_prompt();
        value_enter_quit = uart_prompt_io();
        if (value_enter_quit == 0x71 || value_enter_quit == 0x51)
        {
            return quit_current_state;
        }
        else if (value_enter_quit == 0)
        {
            return value_enter_quit;
        }
        else
        {
            return value_enter_quit;
        }
    }
    else
    {
        printf("Current State : %s\n",s);
        printf("Press Enter to remain in Current State : %s\n",s);
        uart_Green_Text();
        printf("Next State : ?\n");
        uart_Default_Text();
        menu_print_prompt();
        value_enter_quit = uart_prompt_io();
        if (value_enter_quit == 0)
        {
            printf("Last State :%s\n",s);
            return current_state;
        }
        else
        {
            printf("Last State :%s\n",s);
            return value_enter_quit;
        }
    }
}
void menu_print_prompt()
{
    uart_Yellow_Text();
    printf("\r\n>> ");
    uart_Default_Text();
}
u32 uartcmd(u32 argA,u32 argB)
{
    printf("Enter to quit\n");
    printf("\r>>");
    u32 uartquit;
    uartquit = uart_prompt_io();
    if (uartquit == cmds_quit || uartquit == 0x00) {return argA;
    } else {return argB;}
}
void keyArrow1Select()
{
	int nMenu_State  = 1;
	u8 userinput     = 0;
	u16 testValues   = 1;
    int filterNumber = 0;
	int menu_Active = TRUE;
    printf("Enter Filter Number\n");
    menu_print_prompt();
    filterNumber = uart_prompt_io();
	//videoFeatureSelect(filterNumber);
	while (menu_Active == TRUE) {
		switch (nMenu_State) {
		case menuCheck: //exit keyArrors 19
			menu_Active = FALSE;
			break;
		case menu_select:
            menu_print_prompt();
            //Select video Coef Vals Updates
			//User input Keyarrow Direction
			userinput = keypress_to_uart(UART_BASEADDR);
			//Go to Keyarrow Direction State
			nMenu_State = userinput + 10;
			break;
		case KEYPRESS_ARROW_DOWN: 
			if (testValues <= 1){
				testValues = 0;   //MINIMUM SET VALUE
		     }else{
				testValues -= 10; //DECREMENT BY 1
		     }
			//videokCoefValsUpdate(testValues,filterNumber);
			nMenu_State = menu_select;
			break;
		case KEYPRESS_ARROW_UP:  
			if (testValues > 8092){
				testValues = 8093;//MAXIMUM SET VALUE
		     }else{
				testValues += 10; //INCREMENT BY 1
		     }
			//videokCoefValsUpdate(testValues,filterNumber);
			nMenu_State = menu_select;
			break;
		case KEYPRESS_ARROW_LEFT: 
			if (testValues > 8092){
				testValues = 8093; //MAXIMUM SET VALUE
		     }else{
				testValues += 100; //INCREMENT BY 2
		     }
			//videokCoefValsUpdate(testValues,filterNumber);
			nMenu_State = menu_select;
			break;
		case KEYPRESS_ARROW_RIGHT: 
			if (testValues <= 1){
				testValues = 1;    //MINIMUM SET VALUE
		     }else{
				testValues -= 100; //DECREMENT BY 2
		     }
			//videokCoefValsUpdate(testValues,filterNumber);
			nMenu_State = menu_select;
			break;
		default:
			nMenu_State = menu_select;
			break;
		}
	}
}
void cmds_menu() 
{
printf(
"\n"
"|--------------------------------|\n"
"| cmds videochannel |rgbselect   |\n"
"| cmds gridpoint    |vchannel    |\n"
"| cmds griddelta    |ltselect    |\n"
"| cmds fifomode     |kernalconfig|\n"
"| cmds printpixel   |ycbcrenable |\n"
"| cmds readfifo     |ycbcrdisable|\n"
"| cmds displaytype  |keygain     |\n"
"| d5mw testpattern  |hsvpervalue |\n"
"| d5mw colorgain    |yccpervalue |\n"
"| d5mw config       |colorgain   |\n"
"| d5mw update       |d5mgain     |\n"
"| d5mw exposer      |colorgain   |\n"
"| d5mw regs         |sdcard      |\n"
"| d5mr regs         |            |\n"
"| d5mr exposer      |            |\n"
"|--------------------------------|\n");
menu_print_prompt();
}
// void cmds_menu() 
// {
// printf(
// "\n"
// "|--------------------------|\n"
// "|D5M RELEASE V12.16.2018   |\n"
// "|--------------------------|\n"
// "|Hardware test             |\n"
// "|--------------------------|\n"
// "| cmds fifomode            |\n"
// "| cmds readfifo            |\n"
// "| cmds gridpoint           |\n"
// "| cmds exposer             |\n"
// "| cmds readexposer         |\n"
// "| cmds readd5m             |\n"
// "| cmds displaytype         |\n"
// "| cmds printpixel          |\n"
// "| cmds updated5m           |\n"
// "| cmds configd5m           |\n"
// "| cmds videochannel        |\n"
// "| d5m testpattern          |\n"
// "| d5m colorgain            |\n"
// "| xbright                  |\n"
// "| genimage                 |\n"
// "| zoom                     |\n"
// "| colorbars                |\n"
// "| vga                      |\n"
// "| hdmi                     |\n"
// "| fullhdmi                 |\n"
// "| coord                    |\n"
// "| threshold                |\n"
// "| timex                    |\n"
// "|--------------------------|\n");
// menu_print_prompt();
// }
void master_menu() 
{
printf(
"o-completed , x- in progress\n"
"|------------------------|\n"
"|Hardware test           |\n"
"|------------------------|\n"
"|000|Chip Version        |\n"
"|001|Row Start           |\n"
"|002|Column Start        |\n"
"|003|Row Size            |\n"
"|004|Column Size         |\n"
"|005|Horizontal Blank    |\n"
"|006|Vertical Blank      |\n"
"|007|Output Control      |\n"
"|008|Shutter Width Upper |\n"
"|009|Shutter Width Lower |\n"
"|010|Pixel Clock Control |\n"
"|011|Restart             |\n"
"|012|Shutter Delay       |\n"
"|013|Reset               |\n"
"|016|PLL Control         |\n"
"|017|PLL Config 1        |\n"
"|018|PLL Config 2        |\n"
"|030|Read Mode 1         |\n"
"|032|Read Mode 2         |\n"
"|034|Row Address Mode    |\n"
"|035|Column address mode |\n"
"|043|Green1 Gain         |\n"
"|044|Blue Gain           |\n"
"|045|Red Gain            |\n"
"|046|Green2 Gain         |\n"
"|053|Global Gain         |\n"
"|075|Row black offset    |\n"
"|160|TestPatternControl  |\n"
"|161|Test Pattern Green  |\n"
"|162|Test Pattern Red    |\n"
"|163|Test Pattern Blue   |\n"
"|164|TestPatBarWidth     |\n"
"|255|Chip Version Alt    |\n"
"|------------------------|\n");
menu_print_prompt();
}
void menu_cls() 
{
printf("\033[2J\033[;H");
}