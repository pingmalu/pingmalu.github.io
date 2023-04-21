---
layout: post
title: MachineLearning
---

# 神经网络模型可视化

##  PyTorch 自带的可视化工具 torchviz 

### Windows下安装

首先pip安装：

    pip install graphviz
    pip install torchviz

然后安装 GraphViz 工具：

下载地址：[https://graphviz.org/download/](https://graphviz.org/download/)

建议用exe文件安装，安装时勾选添加graphviz路径到系统PATH环境变量中。

如果是在 git-bash 环境下，安装完成后环境变量不会自动导入，需要手动指定 或者 重启电脑即可。

安装完成后，可以在命令行终端输入dot -version验证是否已成功安装Graphviz。如果成功安装，会输出Graphviz的版本信息。

使用案例：

```python
...
outputs = self.model(X_train)
if self.args.show_model:
    # 可视化模型结构
    from torchviz import make_dot
    make_dot(outputs, params=dict(self.model.named_parameters())).view()
    exit()
...
```



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
