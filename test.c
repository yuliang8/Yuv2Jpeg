#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <malloc.h>
#include <errno.h>

int get_Y_U_V(unsigned char*rData,unsigned char* in_Y,unsigned char* in_U,unsigned char* in_V,int nStride,int height)
{
	int i = 0;
	int y_n =0;
	int u_n =0;
	int v_n =0;
	int u = 0;
	int v = 2;
	int size = nStride*height*2;
	while(i<size){
		if(i%2 != 0){
			in_Y[y_n]= rData[i];
			y_n++;		
		}
		else if(i == u){
			in_U[u_n]= rData[i];
			u += 4;	
			u_n++;	
		}
		else if(i == v){
			in_V[v_n] = rData[i];
			v += 4;
			v_n++;
		}
		i++;
	}
	return 0;
}

int main(void)
{
	unsigned char* in_Y = (unsigned char*)malloc(720*576);//
	unsigned char* in_U = (unsigned char*)malloc(720 * 576/2);//
	unsigned char* in_V = (unsigned char*)malloc(720 * 576 / 2);//
	unsigned char* pData = (unsigned char*)malloc(720 * 576);//
	unsigned char* rData = (unsigned char*)malloc(720*576*2);
	
	unsigned long dwSize = 0;
	FILE *rfp = fopen("1","rb");
	if(NULL == rfp)
		fprintf(stderr,"fopen fp error:%s\n",strerror(errno));
	fread(rData,720*576*2,1,rfp);

	get_Y_U_V(rData,in_Y,in_U,in_V,720,576);

	YUV2Jpg(in_Y,in_U,in_V,720,576,100,720,pData,&dwSize);
	FILE *fp = fopen("2.jpg","wb");
	fwrite(pData,dwSize,1,fp);
	fclose(fp);
		
	free(in_Y);
	free(in_U);
	free(in_V);
	free(pData);
}
