#include <stdio.h>


__device__
void warp_reduce_add()
{
    int val = threadIdx.x;
    printf("Thread %d has value %d before op\n", threadIdx.x, val);
    #define FULL_MASK 0xffffffff
    for (int offset = 16; offset > 0; offset /= 2)
        val += __shfl_down_sync(FULL_MASK, val, offset);
    printf("Thread %d has value %d after op\n", threadIdx.x, val);
}


__global__
void add()
{
    warp_reduce_add();
}


int main(int argc, char * argv[])
{
    int nthreads = atoi(argv[1]);
    add<<<1, nthreads>>>();
    cudaDeviceSynchronize();
    return 0;
}

