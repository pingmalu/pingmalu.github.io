---
layout: post
title: MachineLearning
---

# WSL2安装CUDA

安装好WSL2前提下执行

1.在Windows下安装显卡驱动

CUDA on WSL 驱动下载地址：[https://developer.nvidia.com/cuda/wsl](https://developer.nvidia.com/cuda/wsl)


2.WSL2中安装CUDA

CUDA工具箱下载地址: [https://developer.nvidia.com/cuda-downloads](https://developer.nvidia.com/cuda-downloads)


可以使用以下命令来验证CUDA是否已经安装：

    nvcc --version

如果输出类似于以下内容，则表示CUDA已成功安装：

    nvcc: NVIDIA (R) Cuda compiler driver
