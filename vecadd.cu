#include <stdio.h>

__global__ void VecAdd(float * A, float * B, float * C)
{
    int i = threadIdx.x;
    C[i] = A[i] + B[i];
}

void VecPrint(float * V, int len)
{
    int to_print = 10;
    if (to_print > len)
        to_print = len;
    for (int i=0; i<to_print; i++)
    {
        printf("%4.2f", V[i]);
        if (i<to_print-1)
            printf(", ");
    }
    if (to_print < len)
        printf("...");
    printf("\n");
}

int main()
{
    int N = 1024;
    size_t size = N * sizeof(float);

    // Allocate input vectors h_A, h_B and h_C in host memory
    float* h_A = (float*)malloc(size);
    float* h_B = (float*)malloc(size);
    float* h_C = (float*)malloc(size);

    // Initialize input vectors
    for (int i=0; i<N; i++)
    {
        h_A[i] = 2*i;
        h_B[i] = 4*i;
        h_C[i] = 0;
    }

    // Print initialised vectors
    VecPrint(h_A, N);
    VecPrint(h_B, N);
    VecPrint(h_C, N);

    // Allocate vectors in device memory
    float* d_A;
    cudaMalloc(&d_A, size);
    float* d_B;
    cudaMalloc(&d_B, size);
    float* d_C;
    cudaMalloc(&d_C, size);

    // Copy vectors from host memory to device memory
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    // Run the add kernel
    VecAdd<<<1, N>>>(d_A, d_B, d_C);

    // Print result
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);
    VecPrint(h_C, N);    

    // Free device memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    // Free host memory
    delete[] h_A;
    delete[] h_B;

    return 0;
}
