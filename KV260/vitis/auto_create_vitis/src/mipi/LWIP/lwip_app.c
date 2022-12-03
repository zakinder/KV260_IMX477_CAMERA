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
#define UDP_BUFF_SIZE 1400
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
			for(int i=0;i<=(VIDEO2_MAX_FRAME-(0*UDP_BUFF_SIZE));i+=UDP_BUFF_SIZE)
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
    int a0=0;
    if(p_rx != NULL)
    {
    pData = (u16 *)p_rx->payload;
    if(p_rx->len >= 1){
    	stream_it = -1;
    	WriteOneFrameEnd[0] = -1;
    	a0 = (int)pData[0];
//        if(a0==1){
//        	delay = (int)pData[10];
//            xil_printf("delay= %d\n\r",delay);
//        	WriteOneFrameEnd[0] = 1;
//        	stream_it = -1;
//        }else
        	if(a0==2){
            delay = (int)pData[10];
            xil_printf("delay= %d\n\r",delay);
        	per_write_reg(REG11,(int)pData[1]);
        	per_write_reg(REG12,(int)pData[2]);
        	per_write_reg(REG13,(int)pData[3]);
        	per_write_reg(REG14,(int)pData[4]);
        	per_write_reg(REG15,(int)pData[5]);
        	per_write_reg(REG16,(int)pData[6]);
        	per_write_reg(REG17,(int)pData[7]);
        	per_write_reg(REG44,(int)pData[8]);
        	//per_write_reg(REG45,((0x0000ff& pData[9])<<16) | (REG45,((0x0000ff& pData[11])<<8))| ((0x0000ff& pData[12])));
        	//per_read_rgb1_reg();
        	//per_read_rgb2_reg();
        	//per_write_reg(REG20,(int)pData[9]);
            //xil_printf("REG11= %d REG12= %d REG13= %d REG14= %d REG15= %d REG16= %d REG17= %d\n\r",(int)pData[11],(int)pData[12],(int)pData[13],(int)pData[14],(int)pData[15],(int)pData[16],(int)pData[17]);
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
        	stream_it = 0;
        }else if(a0==5){
        	per_write_reg(REG46,(int)pData[1]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = 0;
//        }else if(a0==5){
//        	read_imx682_reg((int)pData[18]);
//        	WriteOneFrameEnd[0] = 1;
//        	stream_it = 0;
//        }else if(a0==6){
//            xil_printf("IMX 682: Addr= %d Data= %d\n\r",(int)pData[19],(int)pData[20]);
//            write_imx682_reg((int)pData[19],(int)pData[20]);
//        	WriteOneFrameEnd[0] = 1;
//        	stream_it = 0;
//        }else if(a0==7){
//            xil_printf("IMX 219: Addr= %d Data= %d\n\r",(int)pData[19],(int)pData[20]);
//            write_imx219_reg((int)pData[19],(int)pData[20]);
//        	WriteOneFrameEnd[0] = 1;
//        	stream_it = 0;
        }else if(a0==8){
        	per_write_reg(REG43,(int)pData[21]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = 0;
//        }else if(a0==9){
//        	per_write_rdeg(REG19,(int)pData[21]);
//        	WriteOneFrameEnd[0] = 1;
//        	stream_it = 0;
        }else if(a0==10){
        	per_write_reg(REG15,(int)pData[1]);
        	per_write_reg(REG45,((0x0000ff& pData[2])<<16) | (REG45,((0x0000ff& pData[3])<<8))| ((0x0000ff& pData[4])));
        	//if(pData[1]<31){
        	per_read_rgb_reg((int)pData[1]);
        	//}
//        	}else if(pData[1]>30 & pData[1]<61){
//        	per_read_rgb2_reg();
//        	}else if(pData[1]>60){
//        	per_read_rgb3_reg();
//        	}
        	WriteOneFrameEnd[0] = 1;
        	stream_it = 0;
        }else if(a0==11){
            per_write_reg(REG1,(int)pData[1]);
            per_write_reg(REG2,(~(int)pData[2])+1);
            per_write_reg(REG3,(~(int)pData[3])+1);
            per_write_reg(REG4,(~(int)pData[4])+1);
            per_write_reg(REG5,(int)pData[5]);
            per_write_reg(REG6,(~(int)pData[6])+1);
            per_write_reg(REG7,(~(int)pData[7])+1);
            per_write_reg(REG8,(~(int)pData[8])+1);
            per_write_reg(REG9,(int)pData[9]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = 1;
        }else if(a0==12){
            per_write_reg(REG46,(int)pData[1]);
            per_write_reg(REG47,(~(int)pData[2])+1);
            per_write_reg(REG48,(~(int)pData[3])+1);
            per_write_reg(REG49,(~(int)pData[4])+1);
            per_write_reg(REG50,(int)pData[5]);
            per_write_reg(REG51,(~(int)pData[6])+1);
            per_write_reg(REG52,(~(int)pData[7])+1);
            per_write_reg(REG53,(~(int)pData[8])+1);
            per_write_reg(REG54,(int)pData[9]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = 1;
        }else if(a0==13){
            per_write_reg(REG55,(int)pData[1]);
            per_write_reg(REG56,(~(int)pData[2])+1);
            per_write_reg(REG57,(~(int)pData[3])+1);
            per_write_reg(REG58,(~(int)pData[4])+1);
            per_write_reg(REG59,(int)pData[5]);
            per_write_reg(REG60,(~(int)pData[6])+1);
            per_write_reg(REG61,(~(int)pData[7])+1);
            per_write_reg(REG62,(~(int)pData[8])+1);
            per_write_reg(REG63,(int)pData[9]);
        	WriteOneFrameEnd[0] = 1;
        	stream_it = 1;
        }else if(a0==14){
        	per_write_reg(REG20,(int)pData[1]);
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
