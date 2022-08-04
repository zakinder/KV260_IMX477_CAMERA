#include <stdio.h>
#include "xparameters.h"
#include "netif/xadapter.h"
#include "lwip/udp.h"
#include "../PLATFORM/platform.h"
#include "../PLATFORM/platform_config.h"
#include "xil_printf.h"
#include "lwipopts.h"
#include "sleep.h"
#include "../config.h"
#include "lwip/priv/tcp_priv.h"
#include "lwip/init.h"
#include "lwip/inet.h"
#include "xil_cache.h"
#include "lwip/dhcp.h"
#include "../SDCARD/bmp.h"
#define IMG_W 1920
#define IMG_H 1080
#define UDP_BUFF_SIZE IMG_W*4
#define frame_length_curr 4*1920*1080
#define DEFAULT_IP_ADDRESS	"192.168.1.10"
#define DEFAULT_IP_MASK		"255.255.255.0"
#define DEFAULT_GW_ADDRESS	"192.168.1.1"
u8 bmpbufs[DEMO_MAX_FRAME] __attribute__ ((aligned(256)));
void platform_enable_interrupts(void);
int WriteOneFrameEnd[2]={-1,-1};
static struct udp_pcb *udp8080_pcb = NULL;
static struct pbuf *udp8080_q = NULL;
static int udp8080_qlen = 0;
ip_addr_t target_addr;
char TargetHeader[8] = { 0, 0x00, 0x01, 0x00, 0x02 };
unsigned char ip_export[4];
unsigned char mac_export[6];
extern u8 *pFrames[DISPLAY_NUM_FRAMES];
extern int WriteOneFrameEnd[2];
extern char targetPicHeader[8];
char targetPicHeader[8]={0, 0x00, 0x02, 0x00, 0x02};
int start_udp(unsigned int port);
int sendpic(const char *pic, int piclen, int sn);
void lwip_init();
extern volatile int dhcp_timoutcntr;
err_t dhcp_start(struct netif *netif);
static struct netif server_netif;
struct netif *netif;
u32 k_number;
void print_ip(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip),ip4_addr3(ip), ip4_addr4(ip));
}
void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{
	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}
static void assign_default_ip(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{
	int err;
	xil_printf("Configuring default IP %s \r\n", DEFAULT_IP_ADDRESS);
	err = inet_aton(DEFAULT_IP_ADDRESS, ip);
	if (!err)
		xil_printf("Invalid default IP address: %d\r\n", err);
	err = inet_aton(DEFAULT_IP_MASK, mask);
	if (!err)
		xil_printf("Invalid default IP MASK: %d\r\n", err);
	err = inet_aton(DEFAULT_GW_ADDRESS, gw);
	if (!err)
		xil_printf("Invalid default gateway address: %d\r\n", err);
}
int lwip_loop()
{
	struct netif *netif;
	ip_addr_t ipaddr, netmask, gw;
	unsigned char mac_ethernet_address[] =
	{0x00,0x0a,0x35,0x00,0x01,0x02};
	netif = &server_netif;
	init_platform();
	ipaddr.addr = 0;
	gw.addr = 0;
	netmask.addr = 0;
	xil_printf("\r\n\r\n");
	lwip_init();
	if (!xemac_add(netif, NULL, NULL, NULL, mac_ethernet_address,PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\r\n");
		return -1;
	}
	netif_set_default(netif);
	platform_enable_interrupts();
	netif_set_up(netif);
#if (LWIP_IPV6 == 0)
#if (LWIP_DHCP==1)
	/* Create a new DHCP client for this interface.
	 * Note: you must call dhcp_fine_tmr() and dhcp_coarse_tmr() at
	 * the predefined regular intervals after starting the client.
	 */
	dhcp_start(netif);
	dhcp_timoutcntr = 24;
	while(((netif->ip_addr.addr) == 0) && (dhcp_timoutcntr > 0))
		xemacif_input(netif);
        if (dhcp_timoutcntr <= 0) {
            if ((netif->ip_addr.addr) == 0) {
                xil_printf("DHCP Timeout\r\n");
                xil_printf("Configuring default IP of 192.168.1.10\r\n");
                IP4_ADDR(&(netif->ip_addr),  192, 168,   1, 10);
                IP4_ADDR(&(netif->netmask), 255, 255, 255,  0);
                IP4_ADDR(&(netif->gw),      192, 168,   1,  1);
            }
        }
	ipaddr.addr  = netif->ip_addr.addr;
	gw.addr      = netif->gw.addr;
	netmask.addr = netif->netmask.addr;
#endif
	print_ip_settings(&ipaddr, &netmask, &gw);
	memcpy(ip_export,&ipaddr, 4);
	memcpy(mac_export,&mac_ethernet_address, 6);
#endif
	start_udp(8080);
	int index;
	while (1) {
		xemacif_input(netif);
		if((WriteOneFrameEnd[0] >= 0))
		{
			index = 1;
			int sn = 1;
			int i;
			int cot;
			Xil_DCacheInvalidateRange((u32)pFrames[index], frame_length_curr+1920*4);
            fetch_rgb_data();
            memcpy(&bmpbufs,(u32)pFrames[index],DEMO_MAX_FRAME);
			for(i=0;i<=(frame_length_curr+1920*4);i+=1920*4)
			{
              sendpic((const char *)&bmpbufs+i,1920*4,sn++);
			}
            WriteOneFrameEnd[0] = -1;
		}
	}
	cleanup_platform();
	return 0;
}
int sendpic(const char *pic, int piclen, int sn)
{
    xil_printf("sn %d\n\r",sn);
	targetPicHeader[5] = sn>>16;
	targetPicHeader[6] = sn>>8;
	targetPicHeader[7] = sn>>0;
	struct pbuf *q;
    q = pbuf_alloc(PBUF_TRANSPORT, piclen, PBUF_POOL);
	if(!q)
	{
		xil_printf("pbuf_alloc %d fail\n\r", piclen+8);
		return -3;
	}
    memcpy(q->payload, pic, piclen);
	udp_sendto(udp8080_pcb, q, &target_addr, 8080);
	pbuf_free(q);
	return 0;
}
void udp_recive(void *arg, struct udp_pcb *pcb, struct pbuf *p_rx, const ip_addr_t *addr, u16_t port) {
    char *pData;
    char buff[100];
    int i;
    if(p_rx != NULL)
    {
    pData = (char *)p_rx->payload;
    if(p_rx->len >= 1){
            xil_printf("Data= %d %d %d %d %d %d\n\r", (int)pData[0],(int)pData[1],(int)pData[2],(int)pData[3],(int)pData[4],(int)pData[5]);
            sendpic((const char *)&BMODE_1920x1080, 54,0);
            memcpy(&target_addr, addr, sizeof(target_addr));
            WriteOneFrameEnd[0] = 0;
    }
    pbuf_free(p_rx);
    }
}
int start_udp(unsigned int port) {
	err_t err;
	udp8080_pcb = udp_new();
	if (!udp8080_pcb) {
		xil_printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}
	err = udp_bind(udp8080_pcb, IP_ADDR_ANY, port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r", port, err);
		return -2;
	}
	udp_recv(udp8080_pcb, udp_recive, 0);
	IP4_ADDR(&target_addr, 192,168,1,42);
	return 0;
}
