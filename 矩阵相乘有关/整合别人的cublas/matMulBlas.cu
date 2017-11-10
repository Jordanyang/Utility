/*********************************************
该程序的功能是借用cublas来做矩阵并行运算,C=AB
考虑到cublas中矩阵是按列存储的
调用cublasSgemm时是按C=BA调用,实际执行的是B^T x A^T ,由于按列存储，这样乘积得到的矩阵刚好是按行存储的C，打印结果是就很方便了
因此实际调用该程序时，矩阵A和矩阵B按行存储，结果矩阵C也是按行存储的，同C语言矩阵乘法一样。
*********************************************/
#include<cublas.h>
#include<cublas_v2.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include <curand.h>
#include <iostream>
#include<fstream>
#include<vector>
#include<string>
#include "MyTime.h"
#define A_ROW 15000      //随意定义A和B的size
#define A_COL 15000
#define B_COL 15000
#define CUDA_SAFE_CALL(cuda_errno) { \
if(cudaSuccess!=cuda_errno) {\
			printf("\nCUDA Runtime Error:%s(err_num=%d)\n", cudaGetErrorString(cuda_errno),cuda_errno);\
			printf("\nCUDA Error in%s,line %d\n",__FILE__,__LINE__);\
			cudaDeviceReset();\
			cudaSetDevice(0);\
}}
using namespace std;
extern void gpu_blas_mmul(cublasHandle_t &handle, float *C, const float *A, const float *B, const int m, const int k, const int n);
extern void save_to_text(std::string filename, std::vector<double> &p);
int main()
{
	
	//分配cpu上的内存
	float *host_A=(float*) malloc(sizeof(float)*A_ROW*A_COL);
	float *host_B=(float*) malloc(sizeof(float)*A_COL*B_COL);
	float *host_C=(float*) malloc(sizeof(float)*A_ROW*B_COL);
	
	//GPU上内存分配
	float *dev_A=0,*dev_B=0,*dev_C=0;
	MyTimer t;
	cudaMalloc((void**)&dev_A,sizeof(float)* A_ROW* A_COL );
	cudaMalloc((void**)&dev_B,sizeof(float)* A_COL* B_COL );
	cudaMalloc((void**)&dev_C,sizeof(float)* A_ROW* B_COL );
	
	
	cublasHandle_t handle;//handle，表示是cublas的上下文句柄,初始化cublas
	cublasCreate(&handle);//计算前create handle
	vector<double> mytime;
	int my_ROW;
	for(int i=0;i<100;i++)
	{
	my_ROW=150*(i+1);
	t.start();//计算时用time.h库中的clock()函数
 // 将矩阵数据传递进 显存 中已经开辟好了的空间
    cublasSetVector (
        my_ROW*A_COL,    // 要存入显存的元素个数
        sizeof(float),    // 每个元素大小
        host_A,    // 主机端起始地址
        1,    // 连续元素之间的存储间隔
        dev_A,    // GPU 端起始地址
        1    // 连续元素之间的存储间隔
    );
	cublasSetVector (
        A_COL*B_COL,    // 要存入显存的元素个数
        sizeof(float),    // 每个元素大小
        host_B,    // 主机端起始地址
        1,    // 连续元素之间的存储间隔
        dev_B,    // GPU 端起始地址
        1    // 连续元素之间的存储间隔
    );
	
	gpu_blas_mmul(handle,dev_C,dev_A, dev_B, my_ROW,B_COL, A_COL);
	cudaDeviceSynchronize();
	// 从 显存 中取出运算结果至 内存中去
    cublasGetVector (
        my_ROW*B_COL,    //  要取出元素的个数
        sizeof(float),    // 每个元素大小
        dev_C,    // GPU 端起始地址
        1,    // 连续元素之间的存储间隔
        host_C,    // 主机端起始地址
        1    // 连续元素之间的存储间隔
    );
	t.stop();
  	mytime.push_back(t.elapse());
	}
	
	save_to_text("CUDATime.txt", mytime);
	
	cudaFree(dev_A);
	cudaFree(dev_B);
	cudaFree(dev_C);
	cublasDestroy(handle); 

	free(host_A);
	free(host_B);
	free(host_C);
	return 0;
}
//计算C=A*B，m,n分别是C的行和列，k是A的行和B的列,但是考虑到cublas是按列存储，
//cublasSgemm的参数，把自己绕的有点晕。这里用的的是B*A，即（A_COL*B_COL）*（A_ROW*A_COL）
//但是真正在函数中执行的是BT*AT=CT(即转置相乘，即B_COL*A_COL）*（A_COL*A_ROW））从而不用自己在麻烦机器来转置了.lda,ldb分别对应B_COL，A_COLB_COL，A_COL即对应的是实际执行的矩阵的row，ldc对应的
void gpu_blas_mmul(cublasHandle_t &handle, float *C,const float *A, const float *B,  const int m,const int n, const int k ) 
{
	const float alpha = 1.0;
	const float beta = 0.0;
	cublasSgemm(handle,CUBLAS_OP_N,CUBLAS_OP_N,n,m,k, &alpha,B,n,A,k,&beta,C,n);
}
void save_to_text(std::string filename, std::vector<double> &p)
{
	using namespace std;
	fstream outfile;
	string tempfilenanme = filename;
	outfile.open(tempfilenanme, ios::out | ios::trunc);
	for (auto i = 0; i < p.size(); i++)
		outfile << p[i] << "\r"<<endl;
	outfile.close();
}	


