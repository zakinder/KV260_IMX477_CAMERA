/*
 * Copyright (C) 2009 - 2018 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */

#include <stdio.h>
#include "xparameters.h"
#include "netif/xadapter.h"
#include "lwip/udp.h"
#include "../PLATFORM/platform.h"
#include "../PLATFORM/platform_config.h"
#if defined (__arm__) || defined(__aarch64__)
#include "xil_printf.h"
#endif

#include "lwipopts.h"
#include "sleep.h"
#include "../config.h"
#include "lwip/priv/tcp_priv.h"
#include "lwip/init.h"
#include "lwip/inet.h"
#include "xil_cache.h"
#include "lwip/dhcp.h"



#define IMG_W 1920
#define IMG_H 1080
#define UDP_BUFF_SIZE IMG_W*4
#define frame_length_curr 4*IMG_W*IMG_H

#define DEFAULT_IP_ADDRESS	"192.168.1.10"
#define DEFAULT_IP_MASK		"255.255.255.0"
#define DEFAULT_GW_ADDRESS	"192.168.1.1"
void platform_enable_interrupts(void);
void print_app_header(void);


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
extern char sendchannel[2];
char targetPicHeader[8]={0, 0x00, 0x02, 0x00, 0x02};
char sendchannel[2] = {0,0};
int FrameLengthCurr = 0 ;
/* defined by each RAW mode application */
int start_udp(unsigned int port);
int transfer_data(const char *pData, int len, const ip_addr_t *addr) ;
int send_adc_data(const char *frame, int data_len);
int sendpic(const char *pic, int piclen, int sn);
/* missing declaration in lwIP */
void lwip_init();
extern volatile int dhcp_timoutcntr;
err_t dhcp_start(struct netif *netif);
static struct netif server_netif;
struct netif *netif;



void print_ip(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip),
			ip4_addr3(ip), ip4_addr4(ip));
}
void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{
	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}


void print_app_header() {
	xil_printf("\n\r\n\r-----AN5642 lwIP UDP DEMO ------\n\r");
	xil_printf("UDP packets sent to port 8080\n\r");
}

#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
int ProgramSi5324(void);
int ProgramSfpPhy(void);
#endif
#endif

#ifdef XPS_BOARD_ZCU102
#ifdef XPAR_XIICPS_0_DEVICE_ID
int IicPhyReset(void);
#endif
#endif

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

#if LWIP_IPV6==0
	ip_addr_t ipaddr, netmask, gw;

#endif
	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] =
	{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

	netif = &server_netif;
#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
	ProgramSi5324();
	ProgramSfpPhy();
#endif
#endif

	/* Define this board specific macro in order perform PHY reset
	 * on ZCU102
	 */
#ifdef XPS_BOARD_ZCU102
	IicPhyReset();
#endif

	init_platform();
#if LWIP_IPV6==0
#if LWIP_DHCP==1
	ipaddr.addr = 0;
	gw.addr = 0;
	netmask.addr = 0;
#else
	/* initliaze IP addresses to be used */
	IP4_ADDR(&ipaddr,  192, 168,   1, 10);
	IP4_ADDR(&netmask, 255, 255, 255,  0);
	IP4_ADDR(&gw,      192, 168,   1,  1);
#endif
#endif
	xil_printf("\r\n\r\n");
	xil_printf("-----lwIP RAW Mode UDP Server Application-----\r\n");

	/* initialize lwIP */
	lwip_init();

	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(netif, NULL, NULL, NULL, mac_ethernet_address,
				PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\r\n");
		return -1;
	}
	netif_set_default(netif);

	/* now enable interrupts */
	platform_enable_interrupts();

	/* specify that the network if is up */
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

	ipaddr.addr = netif->ip_addr.addr;
	gw.addr = netif->gw.addr;
	netmask.addr = netif->netmask.addr;
#endif
	print_ip_settings(&ipaddr, &netmask, &gw);
	memcpy(ip_export, &ipaddr, 4);
	memcpy(mac_export, &mac_ethernet_address, 6);
#endif
	start_udp(8080);

	int index;
	/* receive and process packets */
	while (1) {
		xemacif_input(netif);
		if((WriteOneFrameEnd[0] >= 0) && (sendchannel[0]) )
		{
			targetPicHeader[4] = 2;
			index = WriteOneFrameEnd[0];
			int sn = 1;
			int cot;
			Xil_DCacheInvalidateRange((u32)pFrames[index], frame_length_curr);
			/* Separate camera 1 frame in package */
			for(int i=0;i<frame_length_curr;i+=1440)
			{
				if((i+1440)>frame_length_curr)
				{
					cot = frame_length_curr-i;
				}
				else
				{
					cot = 1440;
				}
				sendpic((const char *)pFrames[index]+i, cot, sn++);
			}
			WriteOneFrameEnd[0] = -1;
		}
//		/* Separate camera 2 frame in package */
//		if((WriteOneFrameEnd[1] >= 0) && (sendchannel[1]) )
//		{
//			targetPicHeader[4] = 3;
//			index = WriteOneFrameEnd[1];
//			int sn = 1;
//			int cot;
//			Xil_DCacheInvalidateRange((u32)pFrames1[index], frame_length_curr);
//			for(int i=0;i<frame_length_curr;i+=1440)
//			{
//				if((i+1440)>frame_length_curr)
//				{
//					cot = frame_length_curr-i;
//				}
//				else
//				{
//					cot = 1440;
//				}
//				sendpic((const char *)pFrames1[index]+i, cot, sn++);
//			}
//			WriteOneFrameEnd[1] = -1;
//		}
	}
	/* never reached */
	cleanup_platform();

	return 0;
}



/*
 * Transfer data with udp
 *
 * @param pData is data pointer will be send
 * @param len is the data length
 * @param addr is IP address
 *
 */
int transfer_data(const char *pData, int len, const ip_addr_t *addr)
{
	/* If parameter length bigger than udp8080_qlen, reallocate memory space */
	if(len > udp8080_qlen)
	{
		if(udp8080_q)
		{
			pbuf_free(udp8080_q);
		}
		udp8080_qlen = len;
		/* allocate memory space to pbuf */
		udp8080_q = pbuf_alloc(PBUF_TRANSPORT, udp8080_qlen, PBUF_POOL);
		if(!udp8080_q)
		{
			xil_printf("pbuf_alloc %d fail\n\r", udp8080_qlen);
			udp8080_qlen = 0;
			return -3;
		}
	}
	/* copy data to pbuf payload */
	memcpy(udp8080_q->payload, pData, len);
	udp8080_q->len = len;
	udp8080_q->tot_len = len;
	/* Start to send udp data */
	udp_sendto(udp8080_pcb, udp8080_q, addr, 8080);
	return 0;
}


/*
 * Send frame data with udp
 *
 * @param pic is frame pointer will be send
 * @param piclen is frame length in one package
 * @param sn is Serial number for each ethernet package
 *
 * @format  Header(8bytes)+data(piclen)
 * @HeaderFormat {ReceivedFirstData|0x01, 0x00, 0x02, 0x00, 0x02, SerialNumber(3bytes)}
 */

int sendpic(const char *pic, int piclen, int sn)
{
	if(!targetPicHeader[0])
	{
		return -1;
	}
	targetPicHeader[5] = sn>>16;
	targetPicHeader[6] = sn>>8;
	targetPicHeader[7] = sn>>0;

	struct pbuf *q;
	q = pbuf_alloc(PBUF_TRANSPORT, 8+piclen, PBUF_POOL);
	if(!q)
	{
		//xil_printf("pbuf_alloc %d fail\n\r", piclen+8);
		return -3;
	}

	memcpy(q->payload, targetPicHeader, 8);
	memcpy(q->payload+8, pic, piclen);
	q->len = q->tot_len = 8+piclen;
	udp_sendto(udp8080_pcb, q, &target_addr, 8080);
	pbuf_free(q);
	return 0;
}


/*
 * Call back funtion for udp receiver
 *
 * @param arg is argument
 * @param pcb is udp pcb pointer
 * @param p_rx is pbuf pointer
 * @param addr is IP address
 * @param port is udp port
 *
 */
void udp_recive(void *arg, struct udp_pcb *pcb, struct pbuf *p_rx,
		const ip_addr_t *addr, u16_t port) {
	char *pData;
		char buff[10];
		if(p_rx != NULL)
		{
			pData = (char *)p_rx->payload;

			if(p_rx->len >= 5)
			{
                print("o\n\r");
				/* Check received data if they are query command from PC, format as random&0xFE, 0x00, 0x02, 0x00, 0x01 */
				if(((pData[0]&0x01) == 0) &&
						(pData[1] == 0x00) &&
						((pData[2] == 0x02) || (pData[2] < 0x00)) &&
						(pData[3]) == 0x00)
				{
					/* Reply data, 16 bytes, random|0x01, 0x00, 0x02, 0x00, 0x01, mac_address, ip_address, 0x02 */
					if(pData[4] == 1)
					{
						buff[0] = pData[0]|1;
						buff[1] = 0x00;
						buff[2] = 0x02;
						buff[3] = 0x00;
						buff[4] = 0x01;
						memcpy(buff+5, mac_export, 6);
						memcpy(buff+5+6, ip_export, 4);
						buff[15] = 2;
						transfer_data(buff, 16, addr);
					}
					/* If received data is (random&0xFE, 0x00, 0x02, 0x00, 0x02, mac_address, ch_sel, flag) means PC request video data*/
					else if(pData[4] == 2)
					{
						if(pData[12] == 0)
						{
							sendchannel[0] = 0;
							sendchannel[1] = 0;
							targetPicHeader[0] = 0;
						}
						/* If received data byte 13(StartFlag) is 0x01, compare received MAC address and local MAC address */
						else if(memcmp(pData+5, mac_export, 6) == 0)
						{
							/* If data byte 13(channel selection) is 0x01 means select camera 1, set to 1280x720 */
							if(pData[11] == 1)
							{
								sendchannel[0] = 1;
								sendchannel[1] = 0;
								xil_printf("option= %d %d  set fmt= 1280x720 left\n\r", (int)pData[11], (int)pData[12]);
								//resetVideoFmt(1280, 720, 0);
							}
							/* If data byte 13(channel selection) is 0x02 means select camera 2, set to 1280x720 */
							else if(pData[11] == 2)
							{
								sendchannel[0] = 0;
								sendchannel[1] = 1;
								xil_printf("option= %d %d  set fmt= 1280x720 right\n\r", (int)pData[11], (int)pData[12]);
								//resetVideoFmt(1280, 720, 1);
							}
							/* If data byte 13(channel selection) is 0x03 means select two cameras, set all to 800x600 */
							else if(pData[11] == 3)
							{
								sendchannel[0] = 1;
								sendchannel[1] = 1;
								xil_printf("option= %d %d  set fmt= 800x600 dual\n\r", (int)pData[11], (int)pData[12]);
								//resetVideoFmt(800, 600, 0);
								//resetVideoFmt(800, 600, 1);
							}
							memcpy(&target_addr, addr, sizeof(target_addr));
							targetPicHeader[0] = pData[0]|1;
						}
					}
				}
			}
			pbuf_free(p_rx);
		}
}
/*
 * Create new pcb, bind pcb and port, set call back function
 */
int start_udp(unsigned int port) {
	err_t err;
	udp8080_pcb = udp_new();
	if (!udp8080_pcb) {
		xil_printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}
	/* bind to specified @port */
	err = udp_bind(udp8080_pcb, IP_ADDR_ANY, port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r", port, err);
		return -2;
	}
	udp_recv(udp8080_pcb, udp_recive, 0);
	IP4_ADDR(&target_addr, 192,168,1,42);

	return 0;
}
