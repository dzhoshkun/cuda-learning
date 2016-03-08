project(CudaLearning)
cmake_minimum_required(VERSION 3.2.0)

# CUDA
find_package(CUDA)
if(NOT CUDA_FOUND)
    message(FATAL_ERROR "CUDA not found. This application requires CUDA.")
endif(NOT CUDA_FOUND)

# BUILD
SET(NAME runme)
CUDA_ADD_EXECUTABLE(${NAME} vecadd.cu)
TARGET_LINK_LIBRARIES(${NAME} ${CUDA_CUDA_LIBRARY})
