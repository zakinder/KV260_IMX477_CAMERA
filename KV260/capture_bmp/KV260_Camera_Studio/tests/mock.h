#ifndef KV260_MOCK_H
#define KV260_MOCK_H
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint16_t u16_t;
typedef uint32_t u32;
typedef uint64_t XTime;
typedef int err_t;
typedef struct { u32 addr; } ip_addr_t;
struct pbuf { void *payload; u16_t len; u16_t tot_len; };
struct udp_pcb { int unused; };
struct netif { ip_addr_t ip_addr, netmask, gw; };
typedef struct { char bm_len[4]; char bm_bytes[4]; } BmpMode;

#define COUNTS_PER_SECOND 1000000ULL
#define UDP_TEST_BUF 1400
#define VIDEO2_MAX_FRAME 16000
#define NUM_FRAMES 3
#ifndef P540
#define P540 0
#endif
#ifndef LWIP_DHCP
#define LWIP_DHCP 0
#endif
#define PLATFORM_EMAC_BASEADDR 0
#define PBUF_TRANSPORT 0
#define PBUF_RAM 0
#define ERR_OK 0
#define ERR_MEM (-1)
#define ERR_VAL (-6)
#define IP_ADDR_ANY ((const ip_addr_t *)0)
#define BMODE_1920x1080 ((BmpMode){{0},{0}})
#define BMODE_1920x540 ((BmpMode){{0},{0}})
#define IP4_ADDR(ip,a,b,c,d) ((ip)->addr = ((u32)(a)<<24)|((u32)(b)<<16)|((u32)(c)<<8)|(u32)(d))
#define ip_addr_cmp(a,b) ((a)->addr == (b)->addr)
#define ip4_addr1(a) ((unsigned)(((a)->addr>>24)&255))
#define ip4_addr2(a) ((unsigned)(((a)->addr>>16)&255))
#define ip4_addr3(a) ((unsigned)(((a)->addr>>8)&255))
#define ip4_addr4(a) ((unsigned)((a)->addr&255))

int lwip_stream_start(void);
void XTime_GetTime(XTime *time);
void print(char *text);
void xil_printf(const char *format, ...);
int inet_aton(const char *text, ip_addr_t *address);
struct pbuf *pbuf_alloc(int layer, u16_t len, int type);
err_t pbuf_take(struct pbuf *p, const void *data, u16_t len);
u16_t pbuf_copy_partial(const struct pbuf *p, void *data, u16_t len, u16_t offset);
u8 pbuf_free(struct pbuf *p);
err_t udp_sendto(struct udp_pcb *pcb, struct pbuf *p, const ip_addr_t *address, u16_t port);
struct udp_pcb *udp_new(void);
err_t udp_bind(struct udp_pcb *pcb, const ip_addr_t *addr, u16_t port);
void udp_remove(struct udp_pcb *pcb);
void udp_recv(struct udp_pcb *pcb, void (*recv)(void*,struct udp_pcb*,struct pbuf*,const ip_addr_t*,u16_t), void *arg);
void init_platform(void);
void lwip_init(void);
struct netif *xemac_add(struct netif *netif, ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw, unsigned char *mac, int base);
void netif_set_default(struct netif *netif);
void netif_set_up(struct netif *netif);
void netif_set_addr(struct netif *netif, const ip_addr_t *ip, const ip_addr_t *mask, const ip_addr_t *gw);
void xemacif_input(struct netif *netif);
err_t dhcp_start(struct netif *netif);
void dhcp_stop(struct netif *netif);
int jpeg_pipeline_start(void);
void jpeg_pipeline_stop(void);
int jpeg_pipeline_busy(void);
void jpeg_pipeline_poll(void);
int jpeg_pipeline_failed(void);
int jpeg_pipeline_claim(const unsigned char **data, size_t *size, unsigned int *token);
void jpeg_pipeline_release(unsigned int token);
size_t jpeg_snapshot_capture(const unsigned char **data);
void per_write_reg(int address, int value);
void read_imx477_reg(int address);
void write_imx477_reg(int address, int value);
void per_read_rgb_reg(int value);

#include "vfp_mock.h"
#endif
