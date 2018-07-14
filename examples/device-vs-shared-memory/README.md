## Device memory vs Shared memory

This example compares the performance of matrix multiplication performed [on device memory vs on shared memory][mmul-sh].

[mmul-sh]: https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#shared-memory

### System

* GPUs
   1. NVIDIA 12GB GTX TITAN X
   2. NVIDIA 6GB Zotac GTX 980 Ti
* CUDA version: 9.0.176
* NVIDIA driver version: 384.111

### Method

Using the NVIDIA profiler to measure the execution times, e.g. `CUDA_VISIBLE_DEVICES=0 nvprof build/mmul_dev 1024 1024`

### Results

##### Device memory

| GPU | 16x16 | 64x64 | 256x256 | 1024x1024 | 4096x4096 |
| --- | --- |--- |--- |--- |--- |
| NVIDIA 12GB GTX TITAN X: | 3.6160us | 6.7840us | 124.86us | 8.1955ms | 524.82ms |
| NVIDIA 6GB Zotac GTX 980 Ti: | 3.6160us | 6.9440us | 123.11us | 8.1613ms | 517.84ms |

##### Shared memory

| GPU | 16x16 | 64x64 | 256x256 | 1024x1024 | 4096x4096 |
| --- | --- |--- |--- |--- |--- |
| NVIDIA 12GB GTX TITAN X: | 2.7520us | 4.6400us | 52.352us | 2.8304ms | 180.64ms |
| NVIDIA 6GB Zotac GTX 980 Ti: | 2.5280us | 4.6720us | 52.576us | 2.8305ms | 178.68ms |

