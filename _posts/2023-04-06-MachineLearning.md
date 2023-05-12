---
layout: post
title: MachineLearning
---


# stable-diffusion

## webui

命令仓库：

[https://github.com/camenduru/stable-diffusion-webui-colab](https://github.com/camenduru/stable-diffusion-webui-colab)

启动命令：

[https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Command-Line-Arguments-and-Settings](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Command-Line-Arguments-and-Settings)



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

## nvcc命令not found

查看cuda的bin目录下是否有nvcc

    ls -alh /usr/local/cuda/bin

如果存在，直接将cuda路径加入系统路径即可：

vim ~/.bashrc进入配置文件,添加以下两行：

    export PATH=/usr/local/cuda/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH





# WSL2下Ubuntu的Docker中使用CUDA

基本的Docker镜像托管在 [https://hub.docker.com/r/nvidia/cuda](https://hub.docker.com/r/nvidia/cuda)

原始项目位于 [https://gitlab.com/nvidia/container-images/cuda](https://gitlab.com/nvidia/container-images/cuda)


1.Nvidia Container Toolkit安装

    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt-get update

确保拿到源信息：cat /etc/apt/sources.list.d/nvidia-docker.list

    deb https://nvidia.github.io/libnvidia-container/stable/ubuntu18.04/$(ARCH) /
    #deb https://nvidia.github.io/libnvidia-container/experimental/ubuntu18.04/$(ARCH) /
    deb https://nvidia.github.io/nvidia-container-runtime/stable/ubuntu18.04/$(ARCH) /
    #deb https://nvidia.github.io/nvidia-container-runtime/experimental/ubuntu18.04/$(ARCH) /
    deb https://nvidia.github.io/nvidia-docker/ubuntu18.04/$(ARCH) /

安装 nvidia-container-toolkit 软件包 （或者安装 nvidia-docker2 试试 https://github.com/NVIDIA/nvidia-docker）：

    apt-get install nvidia-container-toolkit

验证是否正确安装了 nvidia-container-toolkit。您可以使用以下命令检查版本号：

    dpkg -l | grep nvidia-container-toolkit


确保 nvidia-container-runtime 文件被创建

    # ls -alh /usr/bin/nvidia-container-runtime
    -rwxr-xr-x 1 root root 3.0M Apr 24 20:26 /usr/bin/nvidia-container-runtime*

2.配置NVIDIA容器运行时

使用命令：

    nvidia-ctk runtime configure

加载（或创建）一个/etc/docker/daemon.json文件，并确保NVIDIA容器运行时被配置为名为nvidia的运行时。

cat /etc/docker/daemon.json 

    {
        "default-runtime": "nvidia",
        "runtimes": {
            "nvidia": {
                "args": [],
                "path": "nvidia-container-runtime"
            }
        }
    }

3.重启docker

    ps -ef | grep dockerd

    kill <dockerd pid>

    nohup sh -c "dockerd &"

验证docker使用了nvidia容器运行时：

    docker info|grep nvidia

或使用容器跑nvidia-smi命令

    docker run -it --gpus=all --rm nvidia/cuda:11.4.2-base-ubuntu20.04 nvidia-smi

