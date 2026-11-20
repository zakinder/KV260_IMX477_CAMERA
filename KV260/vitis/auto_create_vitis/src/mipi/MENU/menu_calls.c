#include "menu_calls.h"
#include <stdio.h>
#include <xiicps.h>
#include <xil_printf.h>
#include <xstatus.h>
#include "string.h"
#include "ff.h"
#include "../UART/uartio.h"
#include "../LWIP/lwip_app.h"
#include "config_defines.h"
#include "../SENSORS_CONFIG/init_camera.h"
#include "../SENSORS_CONFIG/IMX477/imx477.h"
#include "../config.h"
#define MAX_STRING_LENGTH 80
static FIL fil;
static FATFS fatfs;
static char *SD_File;
u8 photobufs[VIDEO2_MAX_FRAME];
static void filter_menu(unsigned int *enabled)
{
    printf("\r\n1  Camera bypass\r\n"
           "8  Edge-aware surface contour filter\r\n"
           "A/D or Left/Right  Toggle   R  Restore bypass   Q  Return\r\n");
    for (;;) {
        printf("Selected: %s\r\n> ", *enabled ? "Surface contour" : "Camera bypass");
        fflush(stdout);
        unsigned int key = keypress_to_uart(UART_BASEADDR);
        if (key == 'Q')
            return;
        if (key == 1 || key == 'R')
            *enabled = 0;
        else if (key == 8)
            *enabled = 1;
        else if (key == 'A' || key == 'D' || key == KEYPRESS_ARROW_LEFT - 10 ||
                 key == KEYPRESS_ARROW_RIGHT - 10)
            *enabled = !*enabled;
        else
            continue;
        per_write_reg(VFP_SURFACE_CONTOUR_ENABLE, *enabled);
    }
}

static void imx477_digital_gain_menu(XIicPs *iic)
{
    static const char *const names[] = {"Gr", "R", "B", "Gb"};
    unsigned int channel = 0;
    u16 gains[4];
    u8 global;

    printf("\r\nIMX477 digital gain (single keys)\r\n"
           "1 Gr   2 Red   3 Blue   4 Gb\r\n"
           "+/- Adjust by 1/16x   U Set selected gain to 1x\r\n"
           "G Global mode   C Per-channel mode   R Readback   Q Back\r\n");

    for (;;) {
        int key;
        int result = imx477_digital_gain_read(iic, gains, &global);

        if (result == IMX477_TUNING_OK)
            printf("Gr %04X  R %04X  B %04X  Gb %04X  0x3FF9=%02X (%s)\r\n",
                   (unsigned)gains[0], (unsigned)gains[1], (unsigned)gains[2],
                   (unsigned)gains[3], (unsigned)global,
                   global & 1U ? "global, uses Gr" : "per-channel");
        else
            printf("Digital gain read failed. Press R to retry.\r\n");

        printf("Digital gain [%s]> ", names[channel]);
        fflush(stdout);
        key = keypress_to_uart(UART_BASEADDR);
        if (key == 'Q')
            return;
        if (key >= 1 && key <= 4) {
            channel = key - 1;
            continue;
        }
        if (key == 'R' || key == '\r' || key == '\n')
            continue;
        if (result != IMX477_TUNING_OK)
            continue;

        if (key == 'G' || key == 'C') {
            result = imx477_digital_gain_set(iic, 4, key == 'G');
        } else if (key == '+' || key == '-' || key == 'U') {
            unsigned int value = gains[channel];

            if (global & 1U && channel != 0) {
                printf("Global mode uses Gr. Select 1 or press C for per-channel gain.\r\n");
                continue;
            }
            if (key == 'U')
                value = 0x0100;
            else if (key == '+')
                value = value <= 0xffef ? value + 0x10 : 0xffff;
            else
                value = value >= 0x0110 ? value - 0x10 : 0x0100;
            if (value < 0x0100)
                value = 0x0100;
            result = imx477_digital_gain_set(iic, channel, (u16)value);
        } else {
            printf("Use 1-4, +, -, U, G, C, R, or Q.\r\n");
            continue;
        }

        if (result == IMX477_TUNING_HDR_ACTIVE)
            printf("Digital gain tuning is available in SDR mode.\r\n");
        else if (result != IMX477_TUNING_OK)
            printf("Digital gain update failed. Check register readback.\r\n");
    }
}

static void imx477_video_mode_menu(XIicPs *iic)
{
    static u16 baseline_lines;
    u16 width, height, lines;

    if (imx477_video_timing(iic, &width, &height, &lines) != IMX477_TUNING_OK) {
        printf("Cannot read IMX477 video timing.\r\n");
        return;
    }
    if (baseline_lines == 0)
        baseline_lines = lines;

    printf("\r\nIMX477 video mode: %ux%u (resolution set by build)\r\n"
           "Sensor frame rate: 1 Original   2 Half   3 One-third   4 Quarter\r\n"
           "R Read timing   Q Back\r\n"
           "DisplayPort refresh is configured separately.\r\n",
           (unsigned)width, (unsigned)height);
    for (;;) {
        unsigned int key;
        unsigned int requested;

        printf("Video mode> ");
        fflush(stdout);
        key = keypress_to_uart(UART_BASEADDR);
        if (key == 'Q')
            return;
        if (key >= 1 && key <= 4) {
            requested = (unsigned int)baseline_lines * key;
            if (requested > 0xffdcU ||
                imx477_video_set_frame_lines(iic, (u16)requested) != IMX477_TUNING_OK) {
                printf("Sensor frame-rate update failed. Check SDR timing and exposure.\r\n");
                continue;
            }
        } else if (key != 'R') {
            continue;
        }

        if (imx477_video_timing(iic, &width, &height, &lines) == IMX477_TUNING_OK)
            printf("%ux%u, %u lines/frame, sensor rate %u%% of original\r\n",
                   (unsigned)width, (unsigned)height, (unsigned)lines,
                   (unsigned)baseline_lines * 100U / lines);
        else
            printf("IMX477 timing readback failed.\r\n");
    }
}

static void imx477_tuning_menu(void)
{
    extern XIicPs iic_cam;

    printf("\r\nIMX477 sensor tuning (single keys)\r\n"
           "1-5  Exposure: 5, 15, 35, 60, or 90%% of usable frame lines\r\n"
           "6-9, 0  Brightness: analog gain codes 0, 341, 512, 683, 768\r\n"
           "H  DOL HDR status   R  Read settings   D  I2C diagnostics   Q  Main menu\r\n"
           "V  Video mode   G  Digital gain   P  Brief DOL CSI-2 probe (restores SDR)\r\n");

    for (;;) {
        int key;
        int result;
        Imx477TuningStatus status;

        printf("IMX477> ");
        fflush(stdout);
        key = keypress_to_uart(UART_BASEADDR);
        if (key == 'Q')
            return;
        if (key == '\r' || key == '\n')
            continue;

        if (key == 'V') {
            imx477_video_mode_menu(&iic_cam);
            continue;
        }
        if (key == 'G') {
            imx477_digital_gain_menu(&iic_cam);
            continue;
        }
        if (key == 'P') {
            if (imx477_dol_probe(&iic_cam) != IMX477_TUNING_OK)
                printf("DOL probe did not complete.\r\n");
            continue;
        }
        if (key == 'D') {
            imx477_tuning_diagnose(&iic_cam);
            continue;
        }
        if (key >= 1 && key <= 5) {
            result = imx477_tuning_exposure(&iic_cam, key - 1);
        } else if ((key >= 6 && key <= 9) || key == 0) {
            result = imx477_tuning_brightness(&iic_cam, key == 0 ? 4 : key - 6);
        } else if (key == 'H' || key == 'R') {
            result = IMX477_TUNING_OK;
        } else {
            printf("Use 1-9, 0, H, R, D, G, P, V, or Q.\r\n");
            continue;
        }

        if (result == IMX477_TUNING_OK)
            result = imx477_tuning_read(&iic_cam, &status);

        if (result == IMX477_TUNING_HDR_ACTIVE) {
            printf("DOL is active. These presets apply to single-exposure modes.\r\n");
        } else if (result == IMX477_TUNING_RANGE_ERROR) {
            printf("IMX477 timing validation failed. Press D for raw I2C readback.\r\n");
        } else if (result != IMX477_TUNING_OK) {
            printf("IMX477 I2C transaction or readback failed. Press R to retry status.\r\n");
        } else if (key == 'H') {
            printf("DOL enable 0x%02X, mode 0x%02X. Switching needs a matched "
                   "sensor and FPGA capture mode.\r\n",
                   (unsigned)status.dol_enable, (unsigned)status.dol_mode);
        } else {
            printf("I2C 0x%02X, exposure %u lines, frame %u lines, shift %u, analog gain %u, DOL %s\r\n",
                   (unsigned)status.i2c_address,
                   (unsigned)status.exposure_lines, (unsigned)status.frame_lines,
                   (unsigned)status.long_exposure_shift, (unsigned)status.analog_gain_code,
                   status.dol_enable & 1U ? "enabled" : "disabled");
        }
    }
}

void menu_calls(int ON_OFF,char *head_buf, char *data_buf, u32 stride,int connected_camera) {
    int menu_calls_enable = ON_OFF;
    unsigned int uart_io;
    u32 current_state = mainmenu;
    unsigned int contour_enabled = 0;
    u32 k_number;
    u32 k_number_value;

	FRESULT rc;
	char PhotoName[40];
    per_write_reg(VFP_SURFACE_CONTOUR_ENABLE, contour_enabled);
    if (connected_camera == 219 || connected_camera == 519 || connected_camera == 682)
        current_state = lwip;
    while (menu_calls_enable == TRUE)
    {
        lwip_stream_poll();
        switch (current_state)
        {
        case mainmenu:
            cmds_menu();
            printf("f + Enter   Live video filters\r\n"
                   "lwip + Enter   Start UDP video and return to this menu\r\n"
                   "j + Enter   Send one 4K JPEG to UDP port 8081\r\n"
                   "k + Enter   Start or stop continuous 4K JPEG over UDP 8081\r\n");
            if (connected_camera == 477)
                printf("t + Enter   IMX477 exposure, brightness, and DOL status\r\n");
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
        case 't':
        case 'T':
            if (connected_camera == 477)
                imx477_tuning_menu();
            else
                printf("IMX477 tuning requires the IMX477 camera.\r\n");
            current_state = mainmenu;
            break;
        case 'f':
        case 'F':
            filter_menu(&contour_enabled);
            current_state = mainmenu;
            break;
        case clear:
            menu_cls();
            current_state = mainmenu;break;
        case readpixels:
        	fetch_rgb_data();
            current_state = mainmenu;break;
        case 'j':
        case 'J': {
            int status = lwip_jpeg_request();
            printf("%s\r\n", status == 0 ? "4K JPEG queued." :
                   status > 0 ? "JPEG already pending or continuous mode active." : "Ethernet initialization failed.");
            current_state = mainmenu;
            break;
        }
        case 'k':
        case 'K': {
            int status = lwip_mjpeg_toggle();
            printf("%s\r\n", status == 1 ? "Continuous 4K JPEG started." :
                   status == 0 ? "Continuous 4K JPEG stopped after current frame." :
                   status == -2 ? "JPEG pending. Try again after it sends." :
                   "Ethernet initialization failed.");
            current_state = mainmenu;
            break;
        }
        case lwip: {
            int status = lwip_stream_start();

            if (status == 0)
                printf("UDP video enabled. Use f + Enter for live filters.\r\n");
            else if (status > 0)
                printf("UDP video is already enabled.\r\n");
            else
                printf("UDP video failed to start.\r\n");
            current_state = mainmenu;
            break;
        }
        case pics:
            rc = f_mount(&fatfs, "1:/", 0);
            if (rc != FR_OK)
            {
                return;
            }
            printf("Enter file name with extension\n");
            menu_print_prompt();
            char FileName[MAX_STRING_LENGTH] = { 0 };
            char_to_uart(FileName);
            SD_File  = (char *)FileName;
            sprintf(PhotoName, "1:/%s.BMP", SD_File);
            memcpy(&photobufs,data_buf,VIDEO2_MAX_FRAME);
        	bmp_write(PhotoName,head_buf,(char *)&photobufs,stride,&fil);
            current_state = mainmenu;break;
        case imx477wr:
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
            	current_state = imx477wr;break;
            }
        case imx477rd:
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
            	current_state = imx477rd;break;
            }
        case imx519wr:
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
            	current_state = imx519wr;break;
            }
        case imx519rd:
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
            	current_state = imx519rd;break;
            }
        case imx219wr:
            printf("Enter imx219 Register Address.\n");
            menu_print_prompt();
            k_number = uart_prompt_io();
            if (k_number == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
            	printf("Enter imx219 Register Data for the Register.\n");
                menu_print_prompt();
                k_number_value = uart_prompt_io();
                write_imx219_reg(k_number,k_number_value);
            	current_state = imx219wr;break;
            }
        case imx219rd:
            printf("Enter imx219 Register Address \n");
            menu_print_prompt();
            k_number = uart_prompt_io();
            if (k_number == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
            	read_imx219_reg(k_number);
            	current_state = imx219rd;break;
            }
        case imx682wr:
            printf("Enter imx682 Register Address.\n");
            menu_print_prompt();
            k_number = uart_prompt_io();
            if (k_number == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
            	printf("Enter imx682 Register Data for the Register.\n");
                menu_print_prompt();
                k_number_value = uart_prompt_io();
                write_imx682_reg(k_number,k_number_value);
            	current_state = imx682wr;break;
            }
        case imx682rd:
            printf("Enter imx682 Register Address \n");
            menu_print_prompt();
            k_number = uart_prompt_io();
            if (k_number == quit)
            {
                printf("Entered Quit\n");
                current_state = mainmenu;break;
            }
            else
            {
            	read_imx682_reg(k_number);
            	current_state = imx682rd;break;
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
    //menu_calls_enable = TRUE;
}
