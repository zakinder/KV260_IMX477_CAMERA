/*
 *  UDP server for video transmition
 *  --------------------------------
 *  Yipeng Wang 2019.8.10
 */


/** Connection handle for a UDP Server session */

#include "udp_server.h"

#include <arch/cc.h>
#include <lwip/ip4_addr.h>
#include <lwip/netif.h>
#include <lwip/pbuf.h>
#include <string.h>





struct ip4_addr remote_add= {0};
ip_addr_t *add = NULL;
u16_t portnow;
extern struct netif server_netif;
static struct udp_pcb *pcb;
//static struct perf_stats server;
/* Report interval in ms */
#define REPORT_INTERVAL_TIME (INTERIM_REPORT_INTERVAL * 1000)


int transfer_data_x(const char *pData, int cam,int frame, int seq, int len)
{
	//xil_printf("%d\r\n",seq);
	if (add==NULL){
		return 0;
	}

	char buff[5] = {0,frame,seq >> 16,seq >> 8,seq};

	if (cam ==1) buff[0] = 1;
	//print the udp send header
	//xil_printf("%d %d %d\n",buff[0],buff[1], seq);
	struct pbuf *q;
	q = pbuf_alloc(PBUF_TRANSPORT, len+5, PBUF_POOL);
	if (q == NULL){
		xil_printf("pbuf allo fail");
		return -2;
	}
	/* copy data to pbuf payload */
	memcpy(q->payload, buff, 5);
	memcpy(q->payload+5, pData, len);
	q->len = len+5;
	q->tot_len = len+5;
	/* Start to send udp data */
	udp_sendto(pcb, q, add, portnow);
	pbuf_free(q);
	return 0;
}

//void print_app_header(void)
//{
//	xil_printf("UDP server listening on port %d\r\n",UDP_CONN_PORT);
//	xil_printf("On Host: Run client\r\n",inet_ntoa(server_netif.ip_addr),INTERIM_REPORT_INTERVAL);
//}








/** callback function :Receive data on a udp session */
static void change_dest(void *arg, struct udp_pcb *tpcb,
		struct pbuf *p, const ip_addr_t *addr, u16_t port)
{

	xil_printf("callback\r\n");
	char *pData;
			//char buff[5];
			if(p != NULL)
			{
				pData = (char *)p->payload;
				xil_printf("%s\r\n",pData);
				if(p->len >= 3)
						{
							if (pData[0]==0x01 && pData[1]==0x01&&pData[2]==0x01){
								remote_add = *addr;
								add = &remote_add;
								portnow = port;
								xil_printf("port changed\r\n");
							}else if(pData[0]==0x01 && pData[1]==0x01&&pData[2]==0x00){
								add = NULL;
								xil_printf("port closed\r\n");

							}
						}
				pbuf_free(p);
			}
}
//creat a new pcb and set call back function 
void start_application(void)
{
	err_t err;

	/* Create Server PCB */
	pcb = udp_new();
	if (!pcb) {
		xil_printf("UDP server: Error creating PCB. Out of Memory\r\n");
		return;
	}

	err = udp_bind(pcb, IP_ADDR_ANY, UDP_CONN_PORT);
	if (err != ERR_OK) {
		xil_printf("UDP server: Unable to bind to port");
		xil_printf(" %d: err = %d\r\n", UDP_CONN_PORT, err);
		udp_remove(pcb);
		return;
	}

	/* specify callback to use for incoming connections */
	udp_recv(pcb, change_dest, NULL);

	return;
}
/*
int sendpic(const char *pic, int piclen, int sn)
{

	targetPicHeader[5] = sn>>16;
	targetPicHeader[6] = sn>>8;
	targetPicHeader[7] = sn>>0;
	static ip_addr_t *addrt=add;
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
	udp_sendto(pcb, q, addrt, 8080);
	pbuf_free(q);
	return 0;
}*/
