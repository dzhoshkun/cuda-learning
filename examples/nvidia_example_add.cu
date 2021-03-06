/**
 * Simple example provided by NVIDIA for profiling and understanding GPU acceleration.
 * Source: https://devblogs.nvidia.com/even-easier-introduction-cuda/
 * Retrieved: 30 June 2018
 */

#include <iostream>
#include <math.h>
#include <stdio.h>
// Kernel function to add the elements of two arrays

__global__
void add_1_thread(int n, float *x, float *y)
{
  for (int i = 0; i < n; i++)
    y[i] = x[i] + y[i];
}

__global__
void add_1_block(int n, float *x, float *y)
{
  int index = threadIdx.x;
  int stride = blockDim.x;
  for (int i = index; i < n; i += stride)
    y[i] = x[i] + y[i];
}

__global__
void add_grid(int n, float *x, float *y)
{
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = index; i < n; i += stride)
    y[i] = x[i] + y[i];
}

int main(int argc, char * argv[])
{
  int N = 1<<20;
  float *x, *y;

  // Allocate Unified Memory – accessible from CPU or GPU
  cudaMallocManaged(&x, N*sizeof(float));
  cudaMallocManaged(&y, N*sizeof(float));

  // initialize x and y arrays on the host
  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  // Run kernel on 1M elements on the GPU
  int blockSize = atoi(argv[2]);
  int numBlocks = atoi(argv[1]);
  int numThreads = numBlocks * blockSize;
  if (numThreads != N)
    printf("%d elements can't be processed by %d threads!\n",
           N, numThreads);
  add_grid<<<numBlocks, blockSize>>>(N, x, y);
  add_1_block<<<1, blockSize>>>(N, x, y);
  add_1_thread<<<1, 1>>>(N, x, y);

  // Wait for GPU to finish before accessing on host
  cudaDeviceSynchronize();

  // Free memory
  cudaFree(x);
  cudaFree(y);
  
  return 0;
}

