/* Matrix multiplication using device memory, adapted from:
 * https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#shared-memory
 */

#include <stdio.h>

// Matrices are stored in row-major order:
// M(row, col) = *(M.elements + row * M.width + col)
typedef struct {
    int width;
    int height;
    float* elements;
} Matrix;

// Thread block size
#define BLOCK_SIZE 16

// Forward declaration of the matrix multiplication kernel
__global__ void MatMulKernel(const Matrix, const Matrix, Matrix);

// Matrix multiplication - Host code
// Matrix dimensions are assumed to be multiples of BLOCK_SIZE
void MatMul(const Matrix A, const Matrix B, Matrix C)
{
    // Load A and B to device memory
    Matrix d_A;
    d_A.width = A.width; d_A.height = A.height;
    size_t size = A.width * A.height * sizeof(float);
    cudaMalloc(&d_A.elements, size);
    cudaMemcpy(d_A.elements, A.elements, size,
               cudaMemcpyHostToDevice);
    Matrix d_B;
    d_B.width = B.width; d_B.height = B.height;
    size = B.width * B.height * sizeof(float);
    cudaMalloc(&d_B.elements, size);
    cudaMemcpy(d_B.elements, B.elements, size,
               cudaMemcpyHostToDevice);

    // Allocate C in device memory
    Matrix d_C;
    d_C.width = C.width; d_C.height = C.height;
    size = C.width * C.height * sizeof(float);
    cudaMalloc(&d_C.elements, size);

    // Invoke kernel
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid(B.width / dimBlock.x, A.height / dimBlock.y);
    MatMulKernel<<<dimGrid, dimBlock>>>(d_A, d_B, d_C);

    // Read C from device memory
    cudaMemcpy(C.elements, d_C.elements, size,
               cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(d_A.elements);
    cudaFree(d_B.elements);
    cudaFree(d_C.elements);
}

// Matrix multiplication kernel called by MatMul()
__global__ void MatMulKernel(Matrix A, Matrix B, Matrix C)
{
    // Each thread computes one element of C
    // by accumulating results into Cvalue
    float Cvalue = 0;
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    for (int e = 0; e < A.width; ++e)
        Cvalue += A.elements[row * A.width + e]
                * B.elements[e * B.width + col];
    C.elements[row * C.width + col] = Cvalue;
}

int main(int argc, char * argv[])
{
    if (argc < 3)
    {
        printf("Usage: %s <width> <height>\n", argv[0]);
        return EXIT_FAILURE;
    }

    Matrix A, B, C;

    A.width = atoi(argv[1]);
    A.height = atoi(argv[2]);
    A.elements = (float *) malloc(A.width * A.height * sizeof(float));
    for (int i = 0; i < A.width; i++)
        for (int j = 0; j < A.height; j++)
            A.elements[j * A.width + i] = j + i;

    B.width = A.height;
    B.height = A.width;
    B.elements = (float *) malloc(B.width * B.height * sizeof(float));
    for (int i = 0; i < B.width; i++)
        for (int j = 0; j < B.height; j++)
            B.elements[j * B.width + i] = j + i;

    printf("Multiplying %dx%d matrix with %dx%d matrix\n",
           A.width, A.height, B.width, B.height);

    C.width = B.width;
    C.height = A.height;
    C.elements = (float *) malloc(C.width * C.height * sizeof(float));

    MatMul(A, B, C);

    delete [] A.elements;
    delete [] B.elements;
    delete [] C.elements;

    return EXIT_SUCCESS;
}

