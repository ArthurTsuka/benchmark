#include <iostream>
#include <cuda_runtime.h>
#include <chrono>

__global__ void sum_reduction(float* input, float* result, int n) {
    extern __shared__ float shared_data[];

    int tid = threadIdx.x;
    int index = blockIdx.x * blockDim.x + threadIdx.x;

    shared_data[tid] = (index < n) ? input[index] : 0.0f;
    __syncthreads();
    for (int stride = blockDim.x / 2; stride > 0; stride >>= 1) {
        if (tid < stride) {
            shared_data[tid] += shared_data[tid + stride];
        }
        __syncthreads();
    }

    if (tid == 0) {
        result[blockIdx.x] = shared_data[0];
    }
}

void checkCudaError(cudaError_t error, const char* message) {
    if (error != cudaSuccess) {
        std::cerr << message << " Error: " << cudaGetErrorString(error) << std::endl;
        exit(-1);
    }
}

int main() {
    int n = 1000000
    size_t size = n * sizeof(float);
    float* h_input = new float[n];
    float* h_result;

    for (int i = 0; i < n; i++) {
        h_input[i] = 1.0f;
    }

    float *d_input, *d_intermediate, *d_result;
    checkCudaError(cudaMalloc(&d_input, size), "Falha ao alocar memória para d_input");
    checkCudaError(cudaMemcpy(d_input, h_input, size, cudaMemcpyHostToDevice), "Falha ao copiar dados para d_input");

    int threads_per_block = 1024;
    int blocks_per_grid = (n + threads_per_block - 1) / threads_per_block;

    checkCudaError(cudaMalloc(&d_intermediate, blocks_per_grid * sizeof(float)), "Falha ao alocar memória para d_intermediate");
    checkCudaError(cudaMalloc(&d_result, sizeof(float)), "Falha ao alocar memória para d_result");

    auto start = std::chrono::high_resolution_clock::now();
    sum_reduction<<<blocks_per_grid, threads_per_block, threads_per_block * sizeof(float)>>>(d_input, d_intermediate, n);
    cudaDeviceSynchronize();
    h_result = new float[blocks_per_grid];
    checkCudaError(cudaMemcpy(h_result, d_intermediate, blocks_per_grid * sizeof(float), cudaMemcpyDeviceToHost), "Falha ao copiar resultados parciais para o host");

    float final_sum = 0.0f;
    for (int i = 0; i < blocks_per_grid; i++) {
        final_sum += h_result[i];
    }

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<float, std::milli> duration = end - start;

    std::cout << "A soma total é: " << final_sum << std::endl;
    std::cout << "Tempo de execução (ms): " << duration.count() << " ms" << std::endl;

    delete[] h_input;
    delete[] h_result;
    cudaFree(d_input);
    cudaFree(d_intermediate);
    cudaFree(d_result);

    return 0;
}
