/* KV260 Camera Studio v1: separate, bounded UDP control protocol.
 * Runs in the same NO_SYS lwIP context as the existing application.
 * The receive callback only queues a request. Sensor I2C is performed from
 * gui_control_poll() between JPEG transmissions, never in an ISR.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <xiicps.h>
#include "lwip/udp.h"
#include "lwip/pbuf.h"
#include "../UART/uartio.h"
#include "../MENU/vfp_registers.h"
#include "../SENSORS_CONFIG/IMX477/imx477.h"
#include "lwip_app.h"
#include "gui_control.h"

#define CONTROL_PORT 8082U
#define CONTROL_MAX 192U

extern XIicPs iic_cam;

static struct udp_pcb *control_pcb;
static struct {
    int occupied;
    char text[CONTROL_MAX];
    ip_addr_t peer;
    u16_t port;
} request;

static void send_reply(const ip_addr_t *peer, u16_t port, const char *s)
{
    size_t len = strlen(s);
    struct pbuf *p = pbuf_alloc(PBUF_TRANSPORT, (u16_t)len, PBUF_RAM);
    if (!p)
        return;
    if (pbuf_take(p, s, (u16_t)len) == ERR_OK)
        (void)udp_sendto(control_pcb, p, peer, port);
    pbuf_free(p);
}

static int number(const char *s, long min, long max, long *out)
{
    char *end;
    long value;
    if (!s || !*s)
        return 0;
    errno = 0;
    value = strtol(s, &end, 10);
    if (errno || *end || value < min || value > max)
        return 0;
    *out = value;
    return 1;
}

static void recv_control(void *arg, struct udp_pcb *pcb, struct pbuf *p,
                         const ip_addr_t *addr, u16_t port)
{
    char input[CONTROL_MAX];
    u16_t length;
    ip_addr_t peer;
    (void)arg;
    (void)pcb;
    if (!p)
        return;
    length = p->tot_len;
    if (!addr || length == 0 || length >= sizeof(input) ||
        pbuf_copy_partial(p, input, length, 0) != length) {
        pbuf_free(p);
        return;
    }
    peer = *addr;
    pbuf_free(p);
    input[length] = '\0';
    /* Restrict payloads to a single printable ASCII line. */
    for (u16_t i = 0; i < length; ++i)
        if ((unsigned char)input[i] < 32U || (unsigned char)input[i] > 126U)
            return;
    if (strncmp(input, "KVC1 ", 5) != 0)
        return;
    if (request.occupied) {
        char reply[64];
        char *end;
        unsigned long seq = strtoul(input + 5, &end, 10);
        if (end != input + 5 && *end == ' ' && seq <= 2147483647UL) {
            (void)snprintf(reply, sizeof(reply), "KVR1 %lu ERR BUSY", seq);
            send_reply(&peer, port, reply);
        }
        return;
    }
    memcpy(request.text, input, length + 1U);
    request.peer = peer;
    request.port = port;
    request.occupied = 1;
}

int gui_control_start(void)
{
    if (control_pcb)
        return 0;
    control_pcb = udp_new();
    if (!control_pcb)
        return -1;
    if (udp_bind(control_pcb, IP_ADDR_ANY, CONTROL_PORT) != ERR_OK) {
        udp_remove(control_pcb);
        control_pcb = NULL;
        return -1;
    }
    udp_recv(control_pcb, recv_control, NULL);
    printf("Camera Studio control: UDP %u\r\n", (unsigned)CONTROL_PORT);
    return 0;
}

static int no_more_tokens(void)
{
    return strtok(NULL, " ") == NULL;
}

static int next_number(long lo, long hi, long *out)
{
    return number(strtok(NULL, " "), lo, hi, out);
}

static const char *sensor_error(int result)
{
    if (result == IMX477_TUNING_RANGE_ERROR)
        return "SENSOR_RANGE";
    if (result == IMX477_TUNING_HDR_ACTIVE)
        return "HDR_ACTIVE";
    return "SENSOR_IO";
}

static int valid_preview(long n)
{
    switch (n) {
    case 0: case 1: case 2: case 6: case 9: case 13:
    case 15: case 16: case 18: case 22: case 25: case 26: case 27: case VFP_PREVIEW_REFINED_PORTRAIT:
        return 1;
    default:
        return 0;
    }
}

static int adjustment_valid(long selector, long value)
{
    if (selector >= 1 && selector <= 4) return value >= 0 && value <= 40;
    if (selector >= 5 && selector <= 7) return value >= 0 && value <= 16;
    if (selector == 8) return value >= 0 && value <= 1;
    if (selector == 9) return value >= 0 && value <= 255;
    if (selector == 10) return value >= 0 && value <= 2;
    if (selector >= 11 && selector <= 13) return value >= 0 && value <= 255;
    return 0;
}

static void execute(char *line, char *reply, size_t reply_size)
{
    static const u32 ccm_base[] = {
        VFP_DARK_CCM_K1, VFP_LIGHT_CCM_K1, VFP_BALANCE_CCM_K1
    };
    static const u32 ccm_select[] = {
        VFP_DARK_CCM_PRESET_SELECT, VFP_LIGHT_CCM_PRESET_SELECT,
        VFP_BALANCE_CCM_PRESET_SELECT
    };
    char payload[128] = "ERR FORMAT";
    char *magic = strtok(line, " ");
    char *seqstr = strtok(NULL, " ");
    char *op = strtok(NULL, " ");
    long seq = 0, a, b;
    int result;

    if (!magic || strcmp(magic, "KVC1") ||
        !number(seqstr, 1, 2147483647L, &seq) || !op)
        goto done;

    if (!strcmp(op, "PING") && no_more_tokens()) {
        strcpy(payload, "OK PONG 1");
    } else if (!strcmp(op, "STREAM") && next_number(0, 1, &a) && no_more_tokens()) {
        if (lwip_mjpeg_set((int)a) == 0)
            strcpy(payload, "OK STREAM");
        else
            strcpy(payload, "ERR PIPELINE_BUSY");
    } else if (!strcmp(op, "SENSOR") && no_more_tokens()) {
        Imx477TuningStatus status;
        u16 gains[4];
        u8 global;
        result = imx477_tuning_read(&iic_cam, &status);
        if (result == IMX477_TUNING_OK)
            result = imx477_digital_gain_read(&iic_cam, gains, &global);
        if (result == IMX477_TUNING_OK) {
            (void)snprintf(payload, sizeof(payload),
                "OK SENSOR %u %u %u %u %u %u %u %u %u %u",
                (unsigned)status.exposure_lines, (unsigned)status.frame_lines,
                (unsigned)status.analog_gain_code, (unsigned)status.dol_enable,
                (unsigned)status.long_exposure_shift, (unsigned)global,
                (unsigned)gains[0], (unsigned)gains[1],
                (unsigned)gains[2], (unsigned)gains[3]);
        } else {
            (void)snprintf(payload, sizeof(payload), "ERR %s", sensor_error(result));
        }
    } else if (!strcmp(op, "EXPO") && next_number(0, 4, &a) && no_more_tokens()) {
        result = imx477_tuning_exposure(&iic_cam, (unsigned)a);
        (void)snprintf(payload, sizeof(payload), result == IMX477_TUNING_OK ?
            "OK EXPOSURE" : "ERR %s", sensor_error(result));
    } else if (!strcmp(op, "GMODE") && next_number(0, 1, &a) && no_more_tokens()) {
        result = imx477_digital_gain_set(&iic_cam, 4U, (u16)a);
        (void)snprintf(payload, sizeof(payload), result == IMX477_TUNING_OK ?
            "OK GMODE" : "ERR %s", sensor_error(result));
    } else if (!strcmp(op, "GAIN") && next_number(0, 3, &a) &&
               next_number(256, 2048, &b) && no_more_tokens()) {
        u16 gains[4];
        u8 global;
        result = imx477_digital_gain_read(&iic_cam, gains, &global);
        if (result == IMX477_TUNING_OK && (global & 1U)) {
            strcpy(payload, "ERR GLOBAL_MODE");
        } else {
            if (result == IMX477_TUNING_OK)
                result = imx477_digital_gain_set(&iic_cam, (unsigned)a, (u16)b);
            (void)snprintf(payload, sizeof(payload), result == IMX477_TUNING_OK ?
                "OK GAIN" : "ERR %s", sensor_error(result));
        }
    } else if (!strcmp(op, "OUT") && next_number(0, VFP_PREVIEW_REFINED_PORTRAIT, &a) &&
               no_more_tokens() && valid_preview(a)) {
        per_write_reg(VFP_OUTPUT_CHANNEL_SELECT, (u32)a);
        strcpy(payload, "OK VFP_WRITTEN");
    } else if (!strcmp(op, "INPUT") && next_number(0, 5, &a) && no_more_tokens()) {
        per_write_reg(VFP_RGB_CHANNEL_SELECT, (u32)a);
        strcpy(payload, "OK VFP_WRITTEN");
    } else if (!strcmp(op, "ADJ") && next_number(1, 13, &a) &&
               next_number(0, 255, &b) && no_more_tokens() && adjustment_valid(a, b)) {
        per_write_reg(VFP_IMAGE_ADJUST_SELECTOR_VALUE, ((u32)a << 16) | (u32)b);
        strcpy(payload, "OK VFP_WRITTEN");
    } else if (!strcmp(op, "LUT") && next_number(0, 9, &a) && a != 8 && no_more_tokens()) {
        per_write_reg(VFP_CENTROID_LUT_SELECT, (u32)a);
        strcpy(payload, "OK VFP_WRITTEN");
    } else if (!strcmp(op, "THRESH") && next_number(0, 65535, &a) && no_more_tokens()) {
        per_write_reg(VFP_TEST_PATTERN_SELECT_SOBEL_THRESHOLD, (u32)a);
        strcpy(payload, "OK VFP_WRITTEN");
    } else if (!strcmp(op, "PRESET") && next_number(0, 2, &a) &&
               next_number(0, 7, &b) && no_more_tokens()) {
        per_write_reg(ccm_select[a], (u32)b);
        strcpy(payload, "OK VFP_WRITTEN");
    } else if (!strcmp(op, "CCM") && next_number(0, 2, &a)) {
        long k[9];
        int valid = 1;
        for (unsigned i = 0; i < 9; ++i) {
            int diag = (i == 0 || i == 4 || i == 8);
            if (!next_number(diag ? 0 : -2048, diag ? 4096 : 2048, &k[i])) {
                valid = 0;
                break;
            }
        }
        if (valid && no_more_tokens()) {
            /* All values validated before first write. Register updates are
             * sequential, so the displayed image may transiently change. */
            for (unsigned i = 0; i < 9; ++i)
                per_write_reg(ccm_base[a] + 4U * i, (u32)k[i]);
            per_write_reg(ccm_select[a], 15U);
            strcpy(payload, "OK VFP_WRITTEN");
        }
    }
done:
    (void)snprintf(reply, reply_size, "KVR1 %ld %s", seq, payload);
}

void gui_control_poll(void)
{
    char reply[CONTROL_MAX];
    if (!request.occupied || !control_pcb)
        return;
    execute(request.text, reply, sizeof(reply));
    send_reply(&request.peer, request.port, reply);
    request.occupied = 0;
}
