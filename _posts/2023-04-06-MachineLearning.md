---
layout: post
title: MachineLearning
---

# stable-baselines3

## 强化学习训练日志指标和参数解释

    -----------------------------------------
    | rollout/                |             |
    |    ep_len_mean          | 2.24e+03    |
    |    ep_rew_mean          | 1.38e+03    |
    | time/                   |             |
    |    fps                  | 185         |
    |    iterations           | 298         |
    |    time_elapsed         | 3295        |
    |    total_timesteps      | 610304      |
    | train/                  |             |
    |    approx_kl            | 0.024709977 |
    |    clip_fraction        | 0.11        |
    |    clip_range           | 0.2         |
    |    entropy_loss         | -0.26       |
    |    explained_variance   | 0.936       |
    |    learning_rate        | 0.0003      |
    |    loss                 | 0.425       |
    |    n_updates            | 2970        |
    |    policy_gradient_loss | -0.016      |
    |    value_loss           | 4.92        |
    -----------------------------------------


- rollout/ep_len_mean：这是每个回合（episode）的平均长度，即每个回合中执行的平均步数（step）。回合是强化学习中的一个基本概念，指的是智能体（agent）从初始状态开始，与环境（environment）交互，直到达到终止状态的过程。回合长度越长，说明智能体能够在环境中存活越久。
- rollout/ep_rew_mean：这是每个回合的平均奖励（reward），即每个回合中获得的平均累积奖励。奖励是强化学习中的另一个基本概念，指的是环境对智能体行为的反馈，用来评价行为的好坏。奖励越高，说明智能体表现越好。

- time/fps：这是训练过程中的帧率（frames per second），即每秒钟处理的步数。帧率越高，说明训练速度越快。
- time/iterations：这是训练过程中的迭代次数（iterations），即更新策略（policy）的次数。迭代次数越多，说明训练越充分。
- time/time_elapsed：这是训练过程中消耗的时间（time elapsed），以秒为单位。时间越短，说明训练效率越高。
- time/total_timesteps：这是训练过程中总共执行的步数（total timesteps），即智能体与环境交互的总次数。步数越多，说明训练数据越多。

- train/approx_kl：这是训练过程中近似的KL散度（approximate Kullback-Leibler divergence），即新旧策略之间的差异程度。KL散度是一种衡量两个概率分布相似性的指标，越小说明越相似。在某些强化学习算法中，KL散度可以用来控制策略更新的步长，避免更新过大导致不稳定。
- train/clip_fraction：这是训练过程中被裁剪（clipped）的梯度比例（gradient ratio）。在某些强化学习算法中，为了防止策略更新过大，会对梯度进行裁剪，即限制梯度在一个范围内。裁剪比例越高，说明更新幅度越大。
- train/clip_range：这是训练过程中梯度裁剪的范围（gradient clipping range）。它是一个超参数（hyperparameter），可以根据实验效果进行调整。
- train/entropy_loss：这是训练过程中的熵损失（entropy loss），即策略熵（policy entropy）的相反数。熵是一种衡量不确定性的指标，越高说明越不确定。在某些强化学习算法中，为了增加策略的探索性（exploration），会给目标函数加上一个熵项，使得策略更倾向于选择不确定性高的行为。熵损失越低，说明策略更多样化。
- train/explained_variance：这是训练过程中的可解释方差（explained variance），即价值函数（value function）对回报（return）的预测准确度。可解释方差是一种衡量回归模型拟合效果的指标，越接近1说明越准确。
- train/learning_rate：这是训练过程中的学习率（learning rate），即梯度下降法中更新参数的速率。它也是一个超参数，可以根据实验效果进行调整。
- train/loss：这是训练过程中的总损失（total loss），即目标函数（objective function）的值。损失越小，说明模型性能越好。
- train/n_updates：这是训练过程中的更新次数（update times），即更新参数的次数。更新次数越多，说明训练越充分。
- train/policy_gradient_loss：这是训练过程中的策略梯度损失（policy gradient loss），即基于策略梯度法优化策略时产生的损失。策略梯度法是一种强化学习算法，它通过直接优化策略来提高期望奖励。策略梯度损失越小，说明策略性能越好。
- train/value_loss：这是训练过程中的价值损失（value loss），即基于最小二乘法优化价值函数时产生的损失。价值函数是一种估计未来回报的函数，在某些强化学习算法中，它可以辅助策略优化或者直接作为输出。价值损失越小，说明价值函数越准确。






# stable-diffusion

## webui

命令仓库：

[https://github.com/camenduru/stable-diffusion-webui-colab](https://github.com/camenduru/stable-diffusion-webui-colab)

启动命令：

[https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Command-Line-Arguments-and-Settings](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Command-Line-Arguments-and-Settings)


    --share --listen --enable-insecure-extension-access


### 扩展

汉化扩展：https://github.com/hanamizuki-ai/stable-diffusion-webui-localization-zh_Hans

图库浏览器扩展：https://github.com/AlUlkesh/stable-diffusion-webui-images-browser

提示词自动补全扩展：https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git  -> 汉化提示词（复制到extensions\a1111-sd-webui-tagcomplete\tags目录）：http://www.123114514.xyz/d/WebUI/Tag/a1111-sd-webui-tagcomplete.zip

反推提示词（tagg）：https://github.com/toriato/stable-diffusion-webui-wd14-tagger  -> 要重启命令才生效

controlnet: https://github.com/Mikubill/sd-webui-controlnet -> 模型文件（复制到models\ControlNet目录）：https://huggingface.co/lllyasviel/ControlNet-v1-1/tree/main

3D Openpose Editor: https://github.com/nonnonstop/sd-webui-3d-open-pose-editor ([在线直接使用](https://zhuyu1997.github.io/open-pose-editor/))


# 神经网络模型可视化


## 在tensorboard里可视化 StableBaselines3 的模型网络结构

Stable-Baselines3 默认支持 TensorBoard，但它不直接支持在 TensorBoard 中可视化模型网络结构。要在 TensorBoard 中可视化模型网络结构，可以使用 PyTorch 的 `SummaryWriter` 类。以下是一个示例：

首先，确保安装了所需的库：

```bash
pip install stable-baselines3 tensorboard
```

然后，你可以使用以下代码在 TensorBoard 中可视化模型网络结构：

```python
import os
import torch
from torch.utils.tensorboard import SummaryWriter
from stable_baselines3 import PPO
from stable_baselines3.common.vec_env import DummyVecEnv
from stable_baselines3.common.env_util import make_atari_env

# 创建 Atari 游戏环境
env_id = "BreakoutNoFrameskip-v4"
env = make_atari_env(env_id, n_envs=1, seed=0)
env = DummyVecEnv([lambda: env])

# 使用 PPO 算法训练模型
model = PPO("CnnPolicy", env, verbose=1)

# 获取模型的神经网络
policy_net = model.policy.to("cpu")

# 为可视化创建一个虚拟输入
dummy_input = torch.randn(1, *env.observation_space.shape)

# 设置 TensorBoard 日志目录
log_dir = "tensorboard_logs"
os.makedirs(log_dir, exist_ok=True)

# 使用 PyTorch 的 SummaryWriter 将模型网络结构写入 TensorBoard
writer = SummaryWriter(log_dir)
writer.add_graph(policy_net, dummy_input)
writer.close()
```

这段代码首先创建一个 Atari 游戏环境，然后使用 PPO 算法训练模型。接下来，它获取模型的神经网络并将其转换为 CPU 设备。然后，它创建一个虚拟输入。接下来，它设置 TensorBoard 日志目录并使用 PyTorch 的 `SummaryWriter` 将模型网络结构写入 TensorBoard。

要查看 TensorBoard 中的模型网络结构，请在命令行中运行以下命令：

```bash
tensorboard --logdir tensorboard_logs
```

然后，在浏览器中打开显示的 URL（通常为 `http://localhost:6006`），并导航到 "Graphs" 标签以查看模型网络结构。

请注意，这个示例使用了 PPO 算法和 Atari 游戏环境。你可以根据需要替换为其他算法和环境。




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

# Windows 安装CUDA

从NVIDIA官网下载CUDA的安装包

CUDA Toolkit下载地址: [https://developer.nvidia.com/cuda-downloads](https://developer.nvidia.com/cuda-downloads)

# Windows 下 pytoch CUDA安装

从pytorch官网下载对应CUDA版本: [https://pytorch.org/get-started/locally/](https://pytorch.org/get-started/locally/)


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

