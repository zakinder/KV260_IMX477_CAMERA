#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "vfp_registers.h"

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint16_t u16_t;
typedef uint32_t u32;
typedef int XIicPs;
typedef struct { uint32_t addr; } ip_addr_t;
struct udp_pcb { int unused; };
struct pbuf { u16_t tot_len; void *payload; int allocated; };
enum { ERR_OK = 0, PBUF_TRANSPORT = 0, PBUF_RAM = 0 };
#define IP_ADDR_ANY NULL
enum { IMX477_TUNING_OK, IMX477_TUNING_IO_ERROR, IMX477_TUNING_RANGE_ERROR, IMX477_TUNING_HDR_ACTIVE };
typedef struct { u16 exposure_lines, frame_lines, analog_gain_code; u8 long_exposure_shift, dol_enable, dol_mode, i2c_address; } Imx477TuningStatus;
XIicPs iic_cam;
static struct udp_pcb fake_pcb;
static char sent[256];
static int writes, gains_set, exposure_set, stream_set, mode, sensor_result, port_bound;
static u32 offsets[20], values[20];

struct udp_pcb *udp_new(void) { return &fake_pcb; }
int udp_bind(struct udp_pcb *p, const ip_addr_t *addr, u16_t port) { (void)p; (void)addr; port_bound=port; return 0; }
void udp_remove(struct udp_pcb *p) { (void)p; }
void udp_recv(struct udp_pcb *p, void (*f)(void *,struct udp_pcb *,struct pbuf *,const ip_addr_t *,u16_t), void *arg) { (void)p; (void)f; (void)arg; }
struct pbuf *pbuf_alloc(int layer, u16_t length, int kind) { (void)layer; (void)kind; struct pbuf *p=calloc(1,sizeof(*p)); assert(p); p->payload=malloc(length+1); assert(p->payload); p->tot_len=length; p->allocated=1; return p; }
int pbuf_take(struct pbuf *p, const void *data, u16_t length) { memcpy(p->payload,data,length); ((char *)p->payload)[length]=0; return 0; }
u16_t pbuf_copy_partial(struct pbuf *p, void *dst, u16_t length, u16_t offset) { memcpy(dst,(char *)p->payload+offset,length); return length; }
int pbuf_free(struct pbuf *p) { if(p->allocated){free(p->payload);free(p);} return 0; }
int udp_sendto(struct udp_pcb *p, struct pbuf *b, const ip_addr_t *addr, u16_t port) { (void)p; (void)addr; (void)port; snprintf(sent,sizeof(sent),"%s",(char *)b->payload); return 0; }
void per_write_reg(u32 offset,u32 value) { assert(writes<20); offsets[writes]=offset; values[writes]=value; ++writes; }
int lwip_mjpeg_set(int n) { stream_set=n+1; return 0; }
int imx477_tuning_read(XIicPs *i, Imx477TuningStatus *s) { (void)i; memset(s,0,sizeof(*s)); s->exposure_lines=300; s->frame_lines=2200; return sensor_result; }
int imx477_digital_gain_read(XIicPs *i,u16 gains[4],u8 *global) { (void)i; for(int j=0;j<4;j++) gains[j]=(u16)(256+j*100); *global=(u8)mode; return sensor_result; }
int imx477_digital_gain_set(XIicPs *i,unsigned ch,u16 v) { (void)i; (void)ch; (void)v; ++gains_set; return sensor_result; }
int imx477_tuning_exposure(XIicPs *i,unsigned n) { (void)i; exposure_set=(int)n+1; return sensor_result; }

#include "generated_control.c"

static void command(const char *input, const char *expected)
{
    char line[192], reply[192];
    snprintf(line,sizeof(line),"%s",input);
    execute(line,reply,sizeof(reply));
    if(strcmp(reply,expected)!=0){fprintf(stderr,"Expected %s, got %s\n",expected,reply);abort();}
}

int main(void)
{
    command("KVC1 11 PING", "KVR1 11 OK PONG 1");
    command("KVC1 12 PING extra", "KVR1 12 ERR FORMAT");
    command("KVC1 13 STREAM 1", "KVR1 13 OK STREAM");
    assert(stream_set==2);
    command("KVC1 14 SENSOR", "KVR1 14 OK SENSOR 300 2200 0 0 0 0 256 356 456 556");
    mode=1;
    command("KVC1 15 GAIN 1 512", "KVR1 15 ERR GLOBAL_MODE");
    assert(gains_set==0);
    mode=0;
    command("KVC1 16 GAIN 1 512", "KVR1 16 OK GAIN");
    assert(gains_set==1);
    command("KVC1 17 GAIN 1 999999", "KVR1 17 ERR FORMAT");
    assert(gains_set==1);
    sensor_result=IMX477_TUNING_HDR_ACTIVE;
    command("KVC1 18 EXPO 2", "KVR1 18 ERR HDR_ACTIVE");
    assert(exposure_set==3);
    sensor_result=0;
    command("KVC1 19 ADJ 1 41", "KVR1 19 ERR FORMAT");
    assert(writes==0);
    command("KVC1 20 ADJ 1 10", "KVR1 20 OK VFP_WRITTEN");
    assert(writes==1 && offsets[0]==VFP_IMAGE_ADJUST_SELECTOR_VALUE && values[0]==0x1000a);
    writes=0;
    command("KVC1 21 CCM 0 1024 -512 0 0 1024 0 0 0 1024", "KVR1 21 OK VFP_WRITTEN");
    assert(writes==10 && offsets[1]==VFP_DARK_CCM_K2 && values[1]==(u32)-512);
    assert(offsets[9]==VFP_DARK_CCM_PRESET_SELECT && values[9]==15);
    writes=0;
    command("KVC1 22 CCM 0 1024 0 0 0 -1 0 0 0 1024", "KVR1 22 ERR FORMAT");
    assert(writes==0);
    command("KVC1 23 OUT 6", "KVR1 23 OK VFP_WRITTEN");
    assert(writes==1 && offsets[0]==VFP_OUTPUT_CHANNEL_SELECT && values[0]==6);
    writes=0;
    command("KVC1 24 OUT 18", "KVR1 24 OK VFP_WRITTEN");
    assert(writes==1 && offsets[0]==VFP_OUTPUT_CHANNEL_SELECT && values[0]==18);
    assert(gui_control_start()==0 && port_bound==8082);
    ip_addr_t peer={0x1234};
    char raw[]="KVC1 101 PING";
    struct pbuf rx={(u16_t)strlen(raw),raw,0};
    recv_control(NULL,&fake_pcb,&rx,&peer,1234);
    assert(request.occupied);
    char raw2[]="KVC1 102 PING";
    struct pbuf rx2={(u16_t)strlen(raw2),raw2,0};
    recv_control(NULL,&fake_pcb,&rx2,&peer,1234);
    assert(request.occupied && strcmp(sent,"KVR1 102 ERR BUSY")==0);
    gui_control_poll();
    assert(!request.occupied && strcmp(sent,"KVR1 101 OK PONG 1")==0);
    puts("PASS: request validation, CCM ranges, SDR/mode handling, ACK and bounded UDP callback");
    return 0;
}
