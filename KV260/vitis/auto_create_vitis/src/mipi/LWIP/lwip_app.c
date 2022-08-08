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
#include "../config.h"
#include "string.h"
# include "xscugic.h"
#include "../VDMA/vdma.h"
#define IMG_W 1920
#define IMG_H 1080
#define UDP_BUFF_SIZE 720
#define frame_length_curr 4*1920*1080
#define DEFAULT_IP_ADDRESS	"192.168.0.10"
#define DEFAULT_IP_MASK		"255.255.255.0"
#define DEFAULT_GW_ADDRESS	"192.168.0.1"


XScuGic XScuGicInstance;
XAxiVdma vdma_vin[1];
static int WriteError;
int wr_index[2]={0,0};
int rd_index[2]={0,0};
int frame_id1 = 1;
int frame_id2 = 1;

u8 frameBuf0[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(256)));
u8 *pFrames0[DISPLAY_NUM_FRAMES];

extern char targetPicHeader[8];
char targetPicHeader[8]={0, 0x00, 0x02, 0x00, 0x02};
//u8 bmpbufs[DEMO_MAX_FRAME] __attribute__ ((aligned(256)));
//u32 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(256)));
//u32 *pFrames[DISPLAY_NUM_FRAMES];

int sendpic(const char *pic, int piclen, int sn);
static void WriteCallBack0(void *CallbackRef, u32 Mask);
static void WriteErrorCallBack(void *CallbackRef, u32 Mask);
int InterruptConnect(XScuGic *XScuGicInstancePtr,u32 Int_Id,void * Handler,void *CallBackRef);
int vdma_write_start(XAxiVdma *Vdma);
int vdma_write_init(short DeviceID,XAxiVdma *Vdma,short HoriSizeInput,short VertSizeInput,short Stride,unsigned int FrameStoreStartAddr0,unsigned int FrameStoreStartAddr1,unsigned int FrameStoreStartAddr2);
int InterruptInit(u16 DeviceId,XScuGic *XScuGicInstancePtr);
void platform_enable_interrupts(void);
int WriteOneFrameEnd[2]={-1,-1};
static struct udp_pcb *udp8080_pcb = NULL;
static struct pbuf *udp8080_q = NULL;
static int udp8080_qlen = 0;
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
void init_vdma(){
	vdma_write_stop(&vdma_vin[0]);
	XAxiVdma_IntrDisable(&vdma_vin[0], XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE);

	vdma_write_init(XPAR_AXIVDMA_0_DEVICE_ID, &vdma_vin[0], IMG_W * 4, IMG_H, IMG_W * 4,(unsigned int)pFrames0[0], (unsigned int)pFrames0[1], (unsigned int)pFrames0[2]);
	XAxiVdma_SetCallBack(&vdma_vin[0], XAXIVDMA_HANDLER_GENERAL,WriteCallBack0, (void *)&vdma_vin[0], XAXIVDMA_WRITE);
	XAxiVdma_SetCallBack(&vdma_vin[0], XAXIVDMA_HANDLER_ERROR,WriteErrorCallBack, (void *)&vdma_vin[0], XAXIVDMA_WRITE);
	InterruptConnect(&XScuGicInstance,XPAR_FABRIC_PS_VIDEO_V_DMA_AXI_VDMA_0_S2MM_INTROUT_INTR,XAxiVdma_WriteIntrHandler,(void *)&vdma_vin[0]);
	XAxiVdma_IntrEnable(&vdma_vin[0], XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE); 	vdma_write_start(&vdma_vin[0]);
}
void resetVideoFmt(int w, int h, int ch)
{

	vdma_write_stop(&vdma_vin[ch]);
	XAxiVdma_IntrDisable(&vdma_vin[ch], XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE);
    
	vdma_write_init(XPAR_AXIVDMA_0_DEVICE_ID, &vdma_vin[ch], w * 4, h, w * 4,(unsigned int)pFrames0[0], (unsigned int)pFrames0[1], (unsigned int)pFrames0[2]);
	XAxiVdma_SetCallBack(&vdma_vin[ch], XAXIVDMA_HANDLER_GENERAL,WriteCallBack0, (void *)&vdma_vin[ch], XAXIVDMA_WRITE);
	XAxiVdma_SetCallBack(&vdma_vin[ch], XAXIVDMA_HANDLER_ERROR,WriteErrorCallBack, (void *)&vdma_vin[ch], XAXIVDMA_WRITE);
	InterruptConnect(&XScuGicInstance,XPAR_FABRIC_PS_VIDEO_V_DMA_AXI_VDMA_0_S2MM_INTROUT_INTR,XAxiVdma_WriteIntrHandler,(void *)&vdma_vin[ch]);
	//XAxiVdma_IntrEnable(&vdma_vin[ch], XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE);
    
	vdma_write_start(&vdma_vin[ch]);
	//frame_length_curr = w*h*3;
}
int lwip_loop()
{
    int i;
	for (int i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames0[i] = frameBuf0[i];
		memset(pFrames0[i], 0, DEMO_MAX_FRAME);
		Xil_DCacheFlushRange((INTPTR) pFrames0[i], DEMO_MAX_FRAME) ;
	}
    //run_dppsu((unsigned int)pFrames0[0]);
    //WriteOneFrameEnd[0] = 0;
    InterruptInit(XPAR_SCUGIC_0_DEVICE_ID,&XScuGicInstance);
    //
    
    //vdma_write_init(XPAR_AXIVDMA_0_DEVICE_ID,DEMO_STRIDE,VIDEO_ROWS,DEMO_STRIDE,(unsigned int)pFrames[0],(unsigned int)pFrames[1],(unsigned int)pFrames[2]);
    //run_dppsu((unsigned int)pFrames0[1]);
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
                xil_printf("DHCP Timeout\r\n");
                xil_printf("Configuring default IP of 192.168.0.10\r\n");
                IP4_ADDR(&(netif->ip_addr),  192, 168,   0, 10);
                IP4_ADDR(&(netif->netmask), 255, 255, 255,  0);
                IP4_ADDR(&(netif->gw),      192, 168,  0,  1);
            }
        }
	ipaddr.addr  = netif->ip_addr.addr;
	gw.addr      = netif->gw.addr;
	netmask.addr = netif->netmask.addr;
	print_ip_settings(&ipaddr, &netmask, &gw);
	memcpy(ip_export,&ipaddr, 4);
	memcpy(mac_export,&mac_ethernet_address, 6);
    //init_vdma();
    resetVideoFmt(1920, 1080, 0);
	start_udp(8080);
	XAxiVdma_IntrEnable(&vdma_vin[0], XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE);
    //XAxiVdma_IntrDisable(&vdma_vin[0], XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE);
	//WriteOneFrameEnd[0] = 0;
	while (1) {
		xemacif_input(netif);
		//if((WriteOneFrameEnd[0] >= 0))
		//{
		//	int sn = 1;
		//	Xil_DCacheInvalidateRange((u32)pFrames0[0], frame_length_curr+1441);
        //    //fetch_rgb_data();
		//	int cot;
        //    memcpy(&bmpbufs,(u32)pFrames0[0],DEMO_MAX_FRAME);
        //    tx_bmp((const char *)&BMODE_1920x1080, 54,0);
		//	for(int i=0;i<=(frame_length_curr);i+=UDP_BUFF_SIZE)
		//	{
		//	 if(i==0){
		//		 tx_bmp((const char *)&BMODE_1920x1080, 54,0);
		//	 }
        //      tx_bmp((const char *)&bmpbufs+i,UDP_BUFF_SIZE,sn++);
		//	}
		//	usleep(100000);
		//}
        
        
        
        
        
        
		if((WriteOneFrameEnd[0] >= 0))
		{
            targetPicHeader[4] = 2;
            int index = WriteOneFrameEnd[0];
			int sn = 1;
            
			int cot,count;
            //xil_printf("Tail %d\n\r",index);
			Xil_DCacheInvalidateRange((u32)pFrames0[index], frame_length_curr);
            //memcpy(&bmpbufs,(u32)pFrames0[0],DEMO_MAX_FRAME);
            tx_bmp((const char *)&BMODE_1920x1080, 1440,0);

				//for(int i=0;i<frame_length_curr;i+=UDP_BUFF_SIZE)
				//{
				//	if((i+UDP_BUFF_SIZE)>=frame_length_curr)
				//	{
				//		cot = frame_length_curr-i;
				//		transfer_data_x((const char *)pFrames0[index]+i, 0,frame_id1, ++sn,cot);
				//	}
				//	else
				//	{
                //
				//		transfer_data_x((const char *)pFrames0[index]+i, 0,frame_id1,++sn,UDP_BUFF_SIZE);
                //
				//	}
                //
				//}
			//	//xil_printf("%d sec\n", time(NULL) - timeflag);
			//	WriteOneFrameEnd[0] = -1;
			//	if (frame_id1++ == 4) frame_id1 = 1;
            
            //tx_bmp((const char *)&BMODE_1920x1080, 54,0);
			for(int i=0;i<frame_length_curr;i+=UDP_BUFF_SIZE)
			{
				if((i+UDP_BUFF_SIZE)>frame_length_curr)
				{
					cot = frame_length_curr-i;

				}
				else
				{
					cot = UDP_BUFF_SIZE;
				}
                //tx_bmp((const char *)pFrames0[index]+i,cot,sn++);
				sendpic((const char *)pFrames0[1]+i, cot, sn++);
			}
			//WriteOneFrameEnd[0] = -1;

            //count=0;
            ////tx_bmp((const char *)&BMODE_1920x1080, 54,0);
			//for(int i=0;i<(frame_length_curr);i+=UDP_BUFF_SIZE)
			//{
			// if(count==0){
			// 	 tx_bmp((const char *)&BMODE_1920x1080, 54,0);
			// }
            //tx_bmp((const char *)pFrames0[index]+i,UDP_BUFF_SIZE,sn++);
            //count++;
            //usleep(20);
            //}
            //if(count!=8294400){
            //   xil_printf("count %d\n\r",count); 
            //}
            
          //xil_printf("count %d\n\r",i);
          //stats_display();
          //WriteOneFrameEnd[0] = -1;
			
		}
	}
	cleanup_platform();
	return 0;
}
int tx_bmp(const char *bmp, int bmp_length, int sn)
{
	 //if(sn==0){
	//	 xil_printf("Header\n\r");
	 //}
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
int transfer_data_x(const char *pData, int cam,int frame, int seq, int len)
{
	//xil_printf("%d\r\n",seq);
	//if (add==NULL){
	//	return 0;
	//}

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
	memcpy(q->payload, buff, 0);
	memcpy(q->payload+0, pData, len);
	q->len = len+0;
	q->tot_len = len+0;
	/* Start to send udp data */
	udp_sendto(udp8080_pcb, q, &target_addr, 8080);
	pbuf_free(q);
	return 0;
}
int sendpic(const char *pic, int piclen, int sn)
{
	//if(!targetPicHeader[0])
	//{
	//	return -1;
	//}
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

	memcpy(q->payload, targetPicHeader, 0);
	memcpy(q->payload+0, pic, piclen);
	q->len = q->tot_len = 0+piclen;
	udp_sendto(udp8080_pcb, q, &target_addr, 8080);
	pbuf_free(q);
	return 0;
}

void udp_recive(void *arg, struct udp_pcb *pcb, struct pbuf *p_rx, const ip_addr_t *addr, u16_t port) {
    char *pData;
    int a1,a2,a3;
    int a4=0;
    if(p_rx != NULL)
    {
    pData = (char *)p_rx->payload;
    if(p_rx->len >= 1){
        a1 = concat((int)pData[0], (int)pData[1]);
        a2 = concat((int)pData[2], (int)pData[3]);
        a3 = concat((int)pData[4], (int)pData[5]);
        a4 = (int)pData[6];
        //if(a4==1){
        //	WriteOneFrameEnd[0] = 1;
        //}else{
        //	WriteOneFrameEnd[0] = -1;
        //}
            xil_printf("Data= %i %i %i\n\r", a1,a2,a3);
            per_write_reg(0,a1);
            per_write_reg(20,a2);
            per_write_reg(36,a3);
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
int concat(int x, int y){
    char str1[10];
    char str2[10];
    sprintf(str1,"%d",x);
    sprintf(str2,"%d",y);
    strcat(str1,str2);
    return atoi(str1);
}
static void WriteCallBack0(void *CallbackRef, u32 Mask)
{
	if (Mask & XAXIVDMA_IXR_FRMCNT_MASK)
	{
		if(WriteOneFrameEnd[0] >= 0)
		{
			return;
		}
		int hold_rd = rd_index[0];
		if(wr_index[0]==2)
		{
			wr_index[0]=0;
			rd_index[0]=2;
		}
		else
		{
			rd_index[0] = wr_index[0];
			wr_index[0]++;
		}
		/* Set park pointer */
		XAxiVdma_StartParking((XAxiVdma*)CallbackRef, wr_index[0], XAXIVDMA_WRITE);
		WriteOneFrameEnd[0] = hold_rd;
        
	}
}

static void WriteErrorCallBack(void *CallbackRef, u32 Mask)
{
	if (Mask & XAXIVDMA_IXR_ERROR_MASK) {
		WriteError += 1;
	}
}
