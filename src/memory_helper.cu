#include "memory_helper.h"
using namespace std;

void* MemoryMonitor::cpuMalloc(int size){
	cpuMemory += size;
	void* p = malloc(size);
	cpuPoint[p] = 1.0f * size;
// 	if(size >= 1024 * 1024){
// 		printf("cpu malloc memory %fMb\n", 1.0 * size / 1024 / 1024);
// 	}
	return p;
}

cudaError_t MemoryMonitor::gpuMalloc(void** devPtr, int size){
	gpuMemory += size;
	cudaError_t error = cudaMalloc(devPtr, size);
	gpuPoint[*devPtr] = (float)size;
// 	if(size >= 1024 * 1024){
// 		printf("gpu malloc memory %fMb\n", 1.0 * size / 1024 / 1024);
// 	}
	return error;
}

void MemoryMonitor::freeGpuMemory(void* ptr){
	if(gpuPoint.find(ptr) != gpuPoint.end()){
// 		if(gpuPoint[ptr] >= 1024 * 1024){
// 			//printf("free gpu memory %fMb\n", gpuPoint[ptr] / 1024 / 1024);
// 		}
		gpuMemory -= gpuPoint[ptr];
		cudaFree(ptr);
		gpuPoint.erase(ptr);
	}
}


void MemoryMonitor::freeCpuMemory(void* ptr)
{
	if(cpuPoint.find(ptr) != cpuPoint.end()){
// 		if(cpuPoint[ptr] >= 1024 * 1024){
// 			printf("free cpu memory %fMb\n", cpuPoint[ptr] / 1024 / 1024);
// 		}
		cpuMemory -= cpuPoint[ptr];
		free(ptr);
		cpuPoint.erase(ptr);
	}
}
