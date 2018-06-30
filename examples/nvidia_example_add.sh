#!/bin/bash
nvcc nvidia_example_add.cu -o ./build/add_cuda
CUDA_VISIBLE_DEVICES=1 nvprof ./build/add_cuda $1

