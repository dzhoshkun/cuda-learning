## Compiling

`nvcc main.cu -o build/lab -lopencv_highgui,opencv_core,opencv_imgcodecs,opencv_imgproc,nppicc`

## Results

Using version 339753c595658761385cddc3fc5246bd9ab8f6aa we get:

```
[0] % nvprof build/lab ~/data/sample-images/1920x1080.jpg                    
==7258== NVPROF is profiling process 7258, command: build/lab /home/dzhoshkun/data/sample-images/1920x1080.jpg
==7258== Profiling application: build/lab /home/dzhoshkun/data/sample-images/1920x1080.jpg
==7258== Profiling result:
            Type  Time(%)      Time     Calls       Avg       Min       Max  Name
 GPU activities:   30.79%  353.13us         1  353.13us  353.13us  353.13us  [CUDA memcpy HtoD]
                   29.44%  337.60us         1  337.60us  337.60us  337.60us  [CUDA memcpy DtoH]
                   15.15%  173.73us         1  173.73us  173.73us  173.73us  void ImageColorConversionKernel_8u<NppColorModel=15, NppPixelFormat=3, NppColorModel, NppPixelFormat>(unsigned char const *, int, unsigned char*, int, unsigned int, unsigned int)
                   11.22%  128.74us         1  128.74us  128.74us  128.74us  void ImageColorConversionKernel_4XX_8u<NppColorModel=1, NppPixelFormat=3, NppColorModel, NppPixelFormat>(unsigned char const *, unsigned char const *, unsigned char const *, unsigned char const *, int, int, int, unsigned char*, unsigned char*, unsigned char*, unsigned char*, int, int, int, unsigned int, unsigned int)
                    7.69%  88.225us         1  88.225us  88.225us  88.225us  void ImageColorConversionKernel_8u<NppColorModel=1, NppPixelFormat=3, NppColorModel, NppPixelFormat>(unsigned char const *, int, unsigned char*, int, unsigned int, unsigned int)
                    5.71%  65.505us         1  65.505us  65.505us  65.505us  void ImageColorConversionKernel_8u<NppColorModel=4, NppPixelFormat=12, NppColorModel, NppPixelFormat>(unsigned char const *, unsigned char const *, unsigned char const *, unsigned char const *, int, int, int, unsigned char*, unsigned char*, unsigned char*, unsigned char*, int, int, int, unsigned int, unsigned int)
      API calls:   86.84%  171.96ms         5  34.393ms  151.50us  170.72ms  cudaMalloc
                   11.29%  22.356ms         4  5.5891ms  16.450us  22.306ms  cudaLaunchKernel
                    0.55%  1.0932ms       189  5.7840us     138ns  358.13us  cuDeviceGetAttribute
                    0.49%  970.82us         2  485.41us  420.21us  550.61us  cudaMemcpy
                    0.27%  533.17us         2  266.58us  187.19us  345.98us  cuDeviceTotalMem
                    0.26%  517.78us         5  103.56us  94.756us  114.33us  cudaFree
                    0.24%  476.53us         5  95.305us  4.9600us  178.57us  cudaDeviceSynchronize
                    0.06%  112.02us         2  56.012us  39.184us  72.840us  cuDeviceGetName
                    0.00%  4.7110us         1  4.7110us  4.7110us  4.7110us  cuDeviceGetPCIBusId
                    0.00%  2.5320us         4     633ns     340ns  1.4890us  cuDeviceGetCount
                    0.00%  1.5330us         3     511ns     241ns  1.0240us  cuDeviceGet
                    0.00%     744ns         1     744ns     744ns     744ns  cuInit
                    0.00%     476ns         1     476ns     476ns     476ns  cuDriverGetVersion
```
