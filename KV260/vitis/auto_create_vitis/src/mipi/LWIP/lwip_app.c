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
#include "string.h"
#include "../VDMA/vdma.h"
#include "../MENU/menu_calls.h"
#include "../SENSORS_CONFIG/init_camera.h"
#define UDP_BUFF_SIZE 1440
u8 bmpbufs[VIDEO2_MAX_FRAME] __attribute__ ((aligned(256)));
extern u8 *pFrames1[NUM_FRAMES];
#define DEFAULT_IP_ADDRESS	"192.168.0.10"
#define DEFAULT_IP_MASK		"255.255.255.0"
#define DEFAULT_GW_ADDRESS	"192.168.0.1"
void platform_enable_interrupts(void);
int WriteOneFrameEnd[2]={-1,-1};
static struct udp_pcb *udp8080_pcb = NULL;
ip_addr_t target_addr;
unsigned char ip_export[4];
unsigned char mac_export[6];
int start_udp(unsigned int port);
int tx_bmp(const char *bmp, int bmp_length, int sn);
void lwip_init();
extern volatile int dhcp_timoutcntr;
err_t dhcp_start(struct netif *netif);
static struct netif server_netif;
struct netif *netif;
int stream_it;
int delay;
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
	stream_it = -1;
	delay     = 12;
	WriteOneFrameEnd[0] = -1;
	struct netif *netif;
	ip_addr_t ipaddr, netmask, gw;
	unsigned char mac_ethernet_address[] = {0x00,0x0a,0x35,0x00,0x01,0x02};
	netif = &server_netif;
	init_platform();
	ipaddr.addr  = 0;
	gw.addr      = 0;
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
	dhcp_start(netif);
	dhcp_timoutcntr = 24;
	while(((netif->ip_addr.addr) == 0) && (dhcp_timoutcntr > 0))
		xemacif_input(netif);
        if (dhcp_timoutcntr <= 0) {
            if ((netif->ip_addr.addr) == 0) {
                //xil_printf("DHCP Timeout\r\n");
                //xil_printf("Configuring default IP of 192.168.1.10\r\n");
                IP4_ADDR(&(netif->ip_addr),  192, 168,   0, 10);
                IP4_ADDR(&(netif->netmask), 255, 255, 255,  0);
                IP4_ADDR(&(netif->gw),      192, 168,   0,  1);
            }
        }
	ipaddr.addr  = netif->ip_addr.addr;
	gw.addr      = netif->gw.addr;
	netmask.addr = netif->netmask.addr;
	print_ip_settings(&ipaddr, &netmask, &gw);
	memcpy(ip_export,&ipaddr, 4);
	memcpy(mac_export,&mac_ethernet_address, 6);
	start_udp(8080);
	while (1) {
		xemacif_input(netif);
		if((WriteOneFrameEnd[0] >= 0))
		{
			int sn = 0;
			//Xil_DCacheInvalidateRange((u32)pFrames1[0], VIDEO2_MAX_FRAME);
            memcpy(&bmpbufs,(u32)pFrames1[0],VIDEO2_MAX_FRAME);
#if P540 == 1
            tx_bmp((const char *)&BMODE_1920x540, 54,0);
			for(int i=0;i<=(VIDEO2_MAX_FRAME+(0*UDP_BUFF_SIZE))/2;i+=UDP_BUFF_SIZE)
			{
			      tx_bmp((const char *)&bmpbufs+i,UDP_BUFF_SIZE,sn++);
			      usleep(40);
			}
#else
            tx_bmp((const char *)&BMODE_1920x1080, 54,0);
			for(int i=0;i<=(VIDEO2_MAX_FRAME+(0*UDP_BUFF_SIZE));i+=UDP_BUFF_SIZE)
			{
			      tx_bmp((const char *)&bmpbufs+i,UDP_BUFF_SIZE,sn++);
			      usleep(delay);
			}
#endif
		}
		WriteOneFrameEnd[0] = stream_it;
	}
	cleanup_platform();
	return 0;
}
int tx_bmp(const char *bmp, int bmp_length, int sn)
{
	struct pbuf *q;
    q = pbuf_alloc(PBUF_TRANSPORT, bmp_length, PBUF_POOL);
	if(!q)
	{
		xil_printf("pbuf_alloc %d fail\n\r", bmp_length+8);
		return -3;
	}
    memcpy(q->payload, bmp, bmp_length);
	udp_sendto(udp8080_pcb, q, &target_addr, 8080);
	pbuf_free(q);
	return 0;
}
void udp_recive(void *arg, struct udp_pcb *pcb, struct pbuf *p_rx, const ip_addr_t *addr, u16_t port) {
    u16 *pData;
    int a1,a2,a3;
    int a4,a5,a6;
    int a7,a8,a9;
    int a0=0;
    if(p_rx != NULL)
    {
    pData = (u16 *)p_rx->payload;
    if(p_rx->len >= 1){
    	stream_it = -1;
    	WriteOneFrameEnd[0] = -1;
    	a0 = (int)pData[0];
        if(a0==1){
        	delay = (int)pData[10];
            xil_printf("delay= %d\n\r",delay);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = -1;
        }else if(a0==2){
            a1 = (int)pData[1];
            a2 = (int)pData[2];
            a3 = (int)pData[3];
            a4 = (int)pData[4];
            a5 = (int)pData[5];
            a6 = (int)pData[6];
            a7 = (int)pData[7];
            a8 = (int)pData[8];
            a9 = (int)pData[9];
            per_write_reg(REG1,a1);
            per_write_reg(REG2,(~a2)+1);
            per_write_reg(REG3,(~a3)+1);
            per_write_reg(REG4,(~a4)+1);
            per_write_reg(REG5,a5);
            per_write_reg(REG6,(~a6)+1);
            per_write_reg(REG7,(~a7)+1);
            per_write_reg(REG8,(~a8)+1);
            per_write_reg(REG9,a9);
            printf("K1 =  %i \n", ((PL_ReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG1))) & 0x0000ffff);
            printf("K2 = -%i \n", (~(PL_ReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG2))+1) & 0x0000ffff);
            printf("K3 = -%i \n", (~(PL_ReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG3))+1) & 0x0000ffff);
            printf("K4 = -%i \n", (~(PL_ReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG4))+1) & 0x0000ffff);
            printf("K5 =  %i \n", ((PL_ReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG5))) & 0x0000ffff);
            printf("K6 = -%i \n", (~(PL_ReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG6))+1) & 0x0000ffff);
            printf("K7 = -%i \n", (~(PL_ReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG7))+1) & 0x0000ffff);
            printf("K8 = -%i \n", (~(PL_ReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG8))+1) & 0x0000ffff);
            printf("K9 =  %i \n", ((PL_ReadReg(XPAR_PS_VIDEO_RX_VIDEO_VFP_0_VFPCONFIG_BASEADDR,REG9))) & 0x0000ffff);
            delay = (int)pData[10];
            xil_printf("delay= %d\n\r",delay);
        	per_write_reg(REG11,(int)pData[11]);
        	per_write_reg(REG12,(int)pData[12]);
        	per_write_reg(REG13,(int)pData[13]);
        	per_write_reg(REG14,(int)pData[14]);
        	per_write_reg(REG15,(int)pData[15]);
        	per_write_reg(REG16,(int)pData[16]);
        	per_write_reg(REG17,(int)pData[17]);
            xil_printf("REG18= %d\n\r",(int)pData[18]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = 1;
        }else if(a0==3){
        	read_imx477_reg((int)pData[18]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = -1;
        }else if(a0==4){
            xil_printf("IMX 477: Addr= %d Data= %d\n\r",(int)pData[19],(int)pData[20]);
        	write_imx477_reg((int)pData[19],(int)pData[20]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = -1;
        }else if(a0==5){
        	read_imx682_reg((int)pData[18]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = -1;
        }else if(a0==6){
            xil_printf("IMX 682: Addr= %d Data= %d\n\r",(int)pData[19],(int)pData[20]);
            write_imx682_reg((int)pData[19],(int)pData[20]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = -1;
        }else if(a0==7){
            xil_printf("IMX 219: Addr= %d Data= %d\n\r",(int)pData[19],(int)pData[20]);
            write_imx219_reg((int)pData[19],(int)pData[20]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = -1;
        }else if(a0==8){
        	WriteOneFrameEnd[0] = 1;
        	stream_it = 0;
        }
            memcpy(&target_addr, addr, sizeof(target_addr));
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
	IP4_ADDR(&target_addr, 192,168,0,42);
	return 0;
}
