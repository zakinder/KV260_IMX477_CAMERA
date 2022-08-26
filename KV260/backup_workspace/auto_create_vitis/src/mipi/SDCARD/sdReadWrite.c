#include "xil_types.h"
#include <ff.h>
#include <integer.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <xbasic_types.h>
#include <xil_io.h>
#include <xil_printf.h>
#include <xstatus.h>
#include "../UART/uartio.h"
#define MAX_STRING_LENGTH 80
#define PIXEL_LENGTH 7
static FIL fil;
static FIL iFil;
static FIL oFil;
static FATFS fatfs;
static char *SD_File;
static char *SD2File;
FRESULT Res;
u64 adrSof;
u8  nAddre;
u16 nPattn;
u16 nRgb;
u32 x;
int y;
int row;
int col;
int i;
int j;
int pix;
UINT bw; // bytes written
TCHAR *Path = "1:/";
int WrFrData()
{
    adrSof  = 0x317BF00;//skip 1st line
    nAddre  = 0x2;
    nPattn  = 0x1;
    nRgb    = 0x0;
    row     = 0;
    col     = 0;
    int len;
    //rawRgbSelect(nPattn);
    printf("Enter file name with extension\n");
    menu_print_prompt();
    //char FileName[MAX_STRING_LENGTH] = { 0 };
    char FileName[MAX_STRING_LENGTH] = "RGB.BMP";
    //char_to_uart(FileName);
    SD_File  = (char *)FileName;
    printf("Enter num of rows to be saved[1071]\n");
    menu_print_prompt();
    row = uart_prompt_io();
    printf("Enter num of rows to be saved[1920]\n");
    menu_print_prompt();
    col = uart_prompt_io();
    //Res = f_mount(&fatfs,"1:/",0);
	//	if(Res != FR_OK)
	//	{
	//		printf("error:f_mount f_write Failed!\r\n") ;
	//		return ;
	//	}
    Res = f_open(&fil,SD_File,FA_CREATE_ALWAYS | FA_WRITE);
		if(Res != FR_OK)
		{
			printf("error:f_open f_write Failed!\r\n") ;
			return ;
		}
    //Res = f_lseek(&fil,0);
    //if (Res != FR_OK) {return XST_FAILURE;}
    printf  ("1ST PIXEL VALUE %i\n",(unsigned)(Xil_In8(adrSof) & 0xffff));
    for(y = 0; y < row; y++) {
        for(x = 0; x < col; x++) {
            unsigned char buffer[PIXEL_LENGTH] = { 0 };
            //1st field: buffer-out
            //2nd field: max number of bytes that will be written to the buffer
            //3rd field: Input value format
            //4rd field: Input value to be formated
            len =snprintf((void*)buffer,sizeof(buffer),"%d ",(Xil_In8(adrSof)));
            unsigned char *response = (void*)buffer;
            //increment pixel address
            adrSof = adrSof + nAddre;
            //FRESULT f_write (
            //FIL* fp,            /* Pointer to the file object */
            //const void *buff,    /* Pointer to the data to be written */
            //UINT btw,            /* Number of bytes to write */
            //UINT* bw            /* Pointer to number of bytes written */
            //)
            Res = f_write(&fil,response,len,&bw);
		if(Res != FR_OK)
		{
			printf("error: f_write Failed!\r\n") ;
			return ;
		}
        }
        Res = f_write(&fil,"\n", 1, &bw);
		if(Res != FR_OK)
		{
			printf("error: f_write Failed!\r\n") ;
			return ;
		}
        //adrSof = adrSof + 0x7800;
   }
    printf  ("x      %i\n", row);
    printf  ("y      %i\n", y);
    //rawRgbSelect(0x0);
    Res = f_close(&fil);
    if (Res != FR_OK) {return XST_FAILURE;}
    return XST_SUCCESS;
}
int Wr_Data_Sd()
{
    adrSof  = 0x317BF00;//skip 1st line
    nAddre  = 0x2;
    row     = 1071;
    col     = 1920;
    int len;
    unsigned char tmp;
    printf("Enter file name with extension\n");
    menu_print_prompt();
    char FileName[MAX_STRING_LENGTH] = { 0 };
    char_to_uart(FileName);
    SD_File  = (char *)FileName;
    Res = f_mount(&fatfs,Path,0);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_open(&fil,SD_File,FA_CREATE_ALWAYS|FA_WRITE|FA_READ);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_lseek(&fil,0);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf  ("1ST PIXEL VALUE %i\n",(unsigned)(Xil_In16(adrSof) & 0xffff));
    for(y = 0; y < row; y++) {
        unsigned char buffer[PIXEL_LENGTH] = { 0 };
        for(x = 0; x < col; x++) {
            len =snprintf((void*)buffer,sizeof(buffer),"%d ",(Xil_In8(adrSof)));
            unsigned char *response = (void*)buffer;
            adrSof = adrSof + nAddre;
            Res = f_write(&fil,response,len,&bw);
            if (Res) {return XST_FAILURE;}
        }
        Res = f_write(&fil, "\n", 1, &bw);
        if (Res != FR_OK) {return XST_FAILURE;}
   }
    Res = f_close(&fil);
    if (Res != FR_OK) {return XST_FAILURE;}
    return XST_SUCCESS;
}
int Rd_WR_Data_Sd()
{
    adrSof  = 0x317BF00;//skip 1st line
    nAddre  = 0x2;
    row     = 1071;
    col     = 1920;
    int offset;
    int width;
    int height;
    int nWidth;
    int nHeight;
    unsigned char *imageData;
    unsigned char tmp;
    unsigned char *buffer;
    printf("Enter file name with extension\n");
    menu_print_prompt();
    char iFilName[MAX_STRING_LENGTH] = { 0 };
    char_to_uart(iFilName);
    SD_File  = (char *)iFilName;
    Res = f_mount(&fatfs,Path,0);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_open(&iFil,SD_File,FA_READ);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_lseek(&iFil,10);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_read(&iFil,&offset,4,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_lseek(&iFil,18);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_read(&iFil,&width,4,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_read(&iFil,&height,4,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf("width  = %d\n",width);
    printf("height = %d\n",height);
    printf("Enter n times\n");
    menu_print_prompt();
    nWidth = uart_prompt_io();
    width  = nWidth*width;
    height = nWidth*height;
    printf("width  = %d\n",width);
    printf("height = %d\n",height);
    //printf("Enter nWidth\n");
    //menu_print_prompt();
    //nHeight = uart_prompt_io();
    Res = f_lseek(&iFil, 0);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf("FR_OK : 1\n");
    buffer = (unsigned char *)malloc(offset);
    if(buffer == NULL) {
    perror("malloc");
    exit(-1);}
    Res = f_read(&iFil,buffer,offset,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf("FR_OK : 2\n");
    imageData = (unsigned char*)malloc(width*height);
    int mod = width % 4;
    if(mod != 0) {
    mod = 4 - mod;}
    printf("FR_OK : 2\n");
    for(i = 0; i < height; i++) {
        for(j = 0; j < width; j++) {
            Res = f_read(&iFil, &tmp, sizeof(char),&bw);
            if (Res != FR_OK) {return XST_FAILURE;}
            imageData[i*width + j] = tmp;
            //printf  ("[%i][%i][%c]\n",i,j,(unsigned char)tmp);
        }
        for(j = 0; j < mod; j++) {
            Res = f_read(&iFil, &tmp, sizeof(char),&bw);
            if (Res != FR_OK) {return XST_FAILURE;}
        }
    }
    printf("FR_OK : 3\n");
    printf("Enter file name with extension\n");
    menu_print_prompt();
    char FileName[MAX_STRING_LENGTH] = { 0 };
    char_to_uart(FileName);
    SD2File  = (char *)FileName;
    Res = f_open(&oFil,SD2File,FA_CREATE_ALWAYS|FA_WRITE);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_write(&oFil,buffer,offset,&bw);
    if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
    mod = width % 4;
    if(mod != 0) {
    mod = 4 - mod;}
    printf("mod = %d\n", mod);
    for(i = 0; i < height; i++) {
        for(j = 0; j < width; j++) {
            tmp = (unsigned char)imageData[i*width+j];
            //printf  ("[%i][%i][%c]\n",i,j,(unsigned char)tmp);
            Res = f_write(&oFil, &tmp, sizeof(char), &bw);
            if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
      }
        for(j = 0; j < mod; j++) {
            Res = f_write(&oFil,&tmp,sizeof(char),&bw);
            if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
            //printf  ("[%i][%c]\n",j,tmp);
      }
    }
    //for(i = height-1; i >= 0; i--) {
    //    for(j = 0; j < width; j++) {
    //        tmp = (unsigned char)imageData[i*width+j];
    //        printf  ("[%i][%i][%c]\n",i,j,(unsigned char)tmp);
    //        Res = f_write(&oFil, &tmp, sizeof(char), &bw);
    //        if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
    //  }
    //    for(j = 0; j < mod; j++) {
    //        Res = f_write(&oFil, &tmp, sizeof(char), &bw);
    //        if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
    //        printf  ("[%i][%c]\n",j,tmp);
    //  }
    //}
    Res = f_close(&oFil);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_close(&iFil);
    if (Res != FR_OK) {return XST_FAILURE;}
    free(buffer);
    return XST_SUCCESS;
}
int Rd_Data_Sd()
{
    adrSof  = 0x317BF00;//skip 1st line
    nAddre  = 0x02;
    row     = 1071;
    col     = 1920;
    int len;
    int offset;
    int width;
    int height;
    unsigned char *imageData;
    unsigned char *response;
    unsigned char buff[PIXEL_LENGTH] = { 0 };
    unsigned char *buffer;
    u16 pGrRe;
    u16 pBlRe;
    u16 pGrReNx;
    u8 pGrn;
    u8 pBle;
    u8 pRed;
    printf("Enter file name with extension\n");
    menu_print_prompt();
    char iFilName[MAX_STRING_LENGTH] = { 0 };
    char_to_uart(iFilName);
    SD_File  = (char *)iFilName;
    Res = f_mount(&fatfs,Path,0);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_open(&iFil,SD_File,FA_READ);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_lseek(&iFil,10);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_read(&iFil,&offset,4,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_lseek(&iFil,18);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_read(&iFil,&width,4,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_read(&iFil,&height,4,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf("width  = %d\n",width);
    printf("height = %d\n",height);
    Res = f_lseek(&iFil, 0);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf("FR_OK : 1\n");
    buffer = (unsigned char *)malloc(offset);
    if(buffer == NULL) {
    perror("malloc");
    exit(-1);
    }
    Res = f_read(&iFil,buffer,offset,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf("FR_OK : 2\n");
   //*widthOut = width;
   //*heightOut = height;
   // imageData = (unsigned char*)malloc(width*height);
   //if(imageData == NULL) {
   // perror("malloc");
   // exit(-1);}
    printf("Enter file name with extension\n");
    menu_print_prompt();
    char FileName[MAX_STRING_LENGTH] = { 0 };
    char_to_uart(FileName);
    SD2File  = (char *)FileName;
    Res = f_open(&oFil,SD2File,FA_CREATE_ALWAYS|FA_WRITE);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_write(&oFil,buffer,offset,&bw);
    if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
    int mod = width % 4;
    if(mod != 0) {
    mod = 4 - mod;}
    printf("mod = %d\n", mod);
    for(i = 0; i < height; i++) {
         //response = (unsigned char)imageOut[i*cols+j];
// Cr = Cr - 128 ;
// Cb = Cb - 128 ;
// r = Y + 45 * Cr / 32 ;
// g = Y - (11 * Cb + 23 * Cr) / 32 ;
// b = Y + 113 * Cb / 64 ;  
    // Y  -Red
    // Cb -Green
    // Cr -Blue
         // pRed  = (pGrRe & 0xff);
         // pGrn  = ((pGrRe & 0xff00) >>8);
         // pGrReNx = ((Xil_In16(adrSof + nAddre + nAddre) & 0xffff));
//pRed  = (pBlRe & 0xff);
         //len =snprintf((void*)buff,sizeof(buff),"%d ",((Xil_In16(adrSof) & 0x00ff)));
          for(j = 0; j < width; j++) {
              //pGrRe   = ((Xil_In16(adrSof) & 0xffff));
              //pBlRe   = ((Xil_In16(adrSof + nAddre) & 0xffff));
              //pRed    = (pGrRe & 0xff);
              //pGrn    = ((pGrRe & 0xff00) >>8);
              //pBle    = ((pBlRe & 0xff00) >>8);
              //printf("pRed = %d\n", pRed);
//              printf("pGrn = %d\n", pGrn);
//              printf("pBle = %d\n", pBle);
              len      = snprintf((void*)buff,sizeof(buff),"%d ",((Xil_In16(adrSof) & 0x00ff)));
              unsigned char *responsed1 = (void*)buff;
              Res      = f_write(&oFil,responsed1,sizeof(char),&bw);
              if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
              len      = snprintf((void*)buff,sizeof(buff),"%d ",((Xil_In16(adrSof) & 0xff00) >>8));
              unsigned char *responsed2 = (void*)buff;
              Res      = f_write(&oFil,responsed2,sizeof(char),&bw);
              if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
              len      = snprintf((void*)buff,sizeof(buff),"%d ",((Xil_In16(adrSof + nAddre) & 0xff00) >>8));
              unsigned char *responsed3 = (void*)buff;
              response = (void*)buff;
              Res      = f_write(&oFil,responsed3,sizeof(char),&bw);
              if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
              // len      = snprintf((void*)buff,sizeof(buff),"%d ",((Xil_In16(adrSof) & 0x00ff)));
              // response = (void*)buff;
              // Res      = f_write(&oFil,response,len,&bw);
              // if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
              // len      = snprintf((void*)buff,sizeof(buff),"%d ",((Xil_In16(adrSof) & 0x00ff)));
              // response = (void*)buff;
              // Res      = f_write(&oFil,response,len,&bw);
              // if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
//              len      = snprintf((void*)buff,sizeof(buff),"%d ",pGrn);
//              response = (void*)buff;
//              Res      = f_write(&oFil,response,len,&bw);
//              if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
//              len      = snprintf((void*)buff,sizeof(buff),"%d ",pBle);
//              response = (void*)buff;
//              Res      = f_write(&oFil,response,len,&bw);
             // if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
              adrSof = adrSof + nAddre;
      }
        for(j = 0; j < mod; j++) {
            Res = f_write(&oFil,response,sizeof(char),&bw);
            if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
      }
   } 
    Res = f_close(&oFil);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_close(&iFil);
    if (Res != FR_OK) {return XST_FAILURE;}
    free(buffer);
    return XST_SUCCESS;
//   printf  ("1ST PIXEL VALUE %i\n",(unsigned)(Xil_In16(adrSof) & 0xffff));
//   for(y = 0; y < row; y++) {
//       unsigned char buffer[PIXEL_LENGTH] = { 0 };
//       for(x = 0; x < col; x++) {
//           len =snprintf((void*)buffer,sizeof(buffer),"%d ",(Xil_In16(adrSof)));
//           unsigned char *response = (void*)buffer;
//           adrSof = adrSof + nAddre;
//           Res = f_write(&fil,response,len,&bw);
//           if (Res) {return XST_FAILURE;}
//       }
//       Res = f_write(&fil, "\n", 1, &bw);
//       if (Res != FR_OK) {return XST_FAILURE;}
//  }
////------------------------------
//    //Res = f_lseek(&fil, offset);
//    //if (Res != FR_OK) {return XST_FAILURE;}
//   
//    int mod = width % 4;
//    if(mod != 0) {
//    mod = 4 - mod;}
//    printf("FR_OK : 2\n");
//    
//   // NOTE bitmaps are stored in upside-down raster order.  
//   // Read in the actual image
//    for(i = 0; i < height; i++) {
//        // add actual data to the image
//        for(j = 0; j < width; j++) {
//            Res = f_read(&fil, &tmp, sizeof(char),&bw);
//            if (Res != FR_OK) {return XST_FAILURE;}
//            imageData[i*width + j] = tmp;
//        }
//        for(j = 0; j < mod; j++) {
//            Res = f_read(&fil, &tmp, sizeof(char),&bw);
//            if (Res != FR_OK) {return XST_FAILURE;}
//        }
//    }
//   
//    printf("FR_OK : 3\n");
//    for(i = 0; i < height; i++) {
//       for(j = 0; j < width; j++) {
//         printf("[%d] [%d] [%d]\n",i,j,imageData[i*width+j]);
//         ///floatImage[i*width+j] = (float)imageData[i*width+j];
//       }
//    }
//   
//   // Then we flip it over
//// int flipRow;
//// for(i = 0; i < height/2; i++) {
////    flipRow = height - (i+1);
////    for(j = 0; j < width; j++) {
////       tmp = imageData[i*width+j];
////       imageData[i*width+j] = imageData[flipRow*width+j];
////       imageData[flipRow*width+j] = tmp;
////    }
//// }
//
//
//    //Res = f_open(&fil,SD_File,FA_CREATE_ALWAYS|FA_WRITE|FA_READ);
//    //if (Res != FR_OK) {return XST_FAILURE;}
////  Res = f_lseek(&fil,0);
////  if (Res != FR_OK) {return XST_FAILURE;}
////  printf  ("1ST PIXEL VALUE %i\n",(unsigned)(Xil_In16(adrSof) & 0xffff));
////  for(y = 0; y < row; y++) {
////      unsigned char buffer[PIXEL_LENGTH] = { 0 };
////      for(x = 0; x < col; x++) {
////          len =snprintf((void*)buffer,sizeof(buffer),"%d ",(Xil_In16(adrSof)));
////          unsigned char *response = (void*)buffer;
////          adrSof = adrSof + nAddre;
////          Res = f_write(&fil,response,len,&bw);
////          if (Res) {return XST_FAILURE;}
////      }
////      Res = f_write(&fil, "\n", 1, &bw);
////      if (Res != FR_OK) {return XST_FAILURE;}
//// }
////  Res = f_close(&fil);
////  if (Res != FR_OK) {return XST_FAILURE;}
////  return XST_SUCCESS;
//    free(imageData);
////------------------------------
//    Res = f_close(&fil);
//    if (Res != FR_OK) {return XST_FAILURE;}
//    return XST_SUCCESS;
}
int writeRawFrameData(int height,int width)
{
    FRESULT Res;
    adrSof = 0x317BF00;
    printf("adrSof[%x]=0x317BF00\n",(unsigned) adrSof,0x317BF00);
    Res = f_mount(&fatfs,Path,0);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf("Enter FileName with extension\n");
    menu_print_prompt();
    char FileName[MAX_STRING_LENGTH] = { 0 };
    char_to_uart(FileName);
    SD_File  = (char *)FileName;
    Res = f_open(&fil, SD_File, FA_CREATE_ALWAYS | FA_WRITE | FA_READ);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_lseek(&fil, 0);
    if (Res != FR_OK) {return XST_FAILURE;}
       int mod = width % 4;
       if(mod != 0) {
          mod = 4 - mod;
       }
       //   printf("mod = %d\n", mod);
       for(i = height-1; i >= 0; i--) {
          for(j = 0; j < width; j++) {
          //printf("adrSof[%i]=%i\n",(unsigned) j,(unsigned) (Xil_In16(adrSof) & 0xffff));
          //dataPack((Xil_In16(adrSof) & 0xffff));
          char buffer[6] = { 0 };
          snprintf(buffer, sizeof(buffer), "%d", (Xil_In16(adrSof) & 0xffff));
          adrSof = adrSof + 0x2;
         // printf  ("%s\n", buffer);
             Res = f_write(&fil, (void*)buffer, sizeof(buffer), &bw);
             if (Res != FR_OK) {return XST_FAILURE;}
             Res = f_write(&fil,"",1, &bw);
             if (Res != FR_OK) {return XST_FAILURE;}
          }
          // In bmp format, rows must be a multiple of 4-bytes.
          // So if we're not at a multiple of 4, add junk padding.
          for(j = 0; j < mod; j++) {
              char buffer[6];
              Res = f_write(&fil, (void*)buffer, sizeof(buffer), &bw);
              if (Res != FR_OK) {return XST_FAILURE;}
             // printf  ("x %s ", buffer);
                 Res = f_write(&fil, "\n", 1, &bw);
                 if (Res != FR_OK) {return XST_FAILURE;}
          }
       }
    Res = f_close(&fil);
    if (Res != FR_OK) {return XST_FAILURE;}
    return XST_SUCCESS;
}
int Write_HD_Data_Sd()
{
    adrSof  = 0x317BF00;//skip 1st line
    nAddre  = 0x02;
    row     = 1071;
    col     = 1920;
    int len;
    int offset;
    int width;
    int height;
    unsigned char *response;
    unsigned char buff[PIXEL_LENGTH] = { 0 };
    char iFilName[MAX_STRING_LENGTH] = "RGB.BMP";
    unsigned char *buffer;
    SD_File  = (char *)iFilName;
    Res = f_mount(&fatfs,Path,0);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_open(&iFil,SD_File,FA_READ);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_lseek(&iFil,10);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_read(&iFil,&offset,4,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_lseek(&iFil,18);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_read(&iFil,&width,4,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_read(&iFil,&height,4,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf("width  = %d\n",width);
    printf("height = %d\n",height);
    Res = f_lseek(&iFil, 0);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf("FR_OK : 1\n");
    buffer = (unsigned char *)malloc(offset);
    if(buffer == NULL) {
    perror("malloc");
    exit(-1);
    }
    Res = f_read(&iFil,buffer,offset,&bw);
    if (Res != FR_OK) {return XST_FAILURE;}
    printf("FR_OK : 2\n");
    printf("Enter file name with extension\n");
    menu_print_prompt();
    char FileName[MAX_STRING_LENGTH] = { 0 };
    char_to_uart(FileName);
    SD2File  = (char *)FileName;
    Res = f_open(&oFil,SD2File,FA_CREATE_ALWAYS|FA_WRITE);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_write(&oFil,buffer,offset,&bw);
    if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
    int mod = width % 4;
    if(mod != 0) {
    mod = 4 - mod;}
    printf("mod = %d\n", mod);
    for(i = 0; i < height; i++) {
          for(j = 0; j < width; j++) {
              len      = snprintf((void*)buff,sizeof(buff),"%d ",((Xil_In16(adrSof) & 0x00ff)));
              unsigned char *responsed1 = (void*)buff;
              Res      = f_write(&oFil,responsed1,sizeof(char),&bw);
              if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
              len      = snprintf((void*)buff,sizeof(buff),"%d ",((Xil_In16(adrSof) & 0xff00) >>8));
              unsigned char *responsed2 = (void*)buff;
              Res      = f_write(&oFil,responsed2,sizeof(char),&bw);
              if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
              len      = snprintf((void*)buff,sizeof(buff),"%d ",((Xil_In16(adrSof + nAddre) & 0xff00) >>8));
              unsigned char *responsed3 = (void*)buff;
              response = (void*)buff;
              Res      = f_write(&oFil,responsed3,sizeof(char),&bw);
              if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
              adrSof = adrSof + nAddre;
      }
        for(j = 0; j < mod; j++) {
            Res = f_write(&oFil,response,sizeof(char),&bw);
            if (Res != FR_OK) { printf("error writing header!\n"); return XST_FAILURE;}
      }
   }
    Res = f_close(&oFil);
    if (Res != FR_OK) {return XST_FAILURE;}
    Res = f_close(&iFil);
    if (Res != FR_OK) {return XST_FAILURE;}
    free(buffer);
    return XST_SUCCESS;
}