---
layout: post
title: MachineLearning
---


{% raw %}
<script>
  window.MathJax = {
    tex: {
      inlineMath: [['$', '$'], ['\\(', '\\)']],
      displayMath: [['$$', '$$'], ['\\[', '\\]']]
    },
    svg: {
      fontCache: 'global'
    }
  };
</script>
<script src="https://cdn.staticfile.net/mathjax/3.2.2/es5/tex-mml-chtml.js"></script>
{% endraw %}

### 存在reward上升趋势：

c18推荐超参

```
-LR 0.0001
-pk 3
-c18_k 0.1        # 空惩罚系数
-c18_c 0.9 \ 0.2  # 持奖励折扣
-c18_f ?          # 重复动作惩罚值
```

n_envs: 平衡点2，适当增加可减少训练时间

    env = DummyVecEnv([lambda: TradingEnv(self.config)] * self.args.n_envs)



# stable-baselines3

    pip install stable-baselines3[extra]

[https://stable-baselines3.readthedocs.io/en/master/](https://stable-baselines3.readthedocs.io/en/master/)

[https://gymnasium.farama.org/v0.28.1/](https://gymnasium.farama.org/v0.28.1/)

# 激活函数

如何理解激活函数：[https://zhuanlan.zhihu.com/p/364620596](https://zhuanlan.zhihu.com/p/364620596)

详细解释：[https://blog.csdn.net/hy592070616/article/details/120617176](https://blog.csdn.net/hy592070616/article/details/120617176)

### Sigmoid

Sigmoid激活函数是一种常用的神经网络激活函数，它可以将任意实数映射到 [0,1] 之间的一个值。它的数学表达式是：

$$
sigmoid(x) = \frac{1}{1+e^{-x}}
$$

Sigmoid激活函数的优点是它的输出可以表示为概率，它的导数可以用自身表示，它的函数形状接近生物神经元。它的缺点是它的计算量较大，它的输出不是以0为中心的，它容易出现梯度消失的问题。

### Tanh

Tanh函数是一种双曲函数，它用于计算给定数字x的双曲正切值。它的数学表达式是：

$$
tanh(x) = \frac{e^x - e^{-x}}{e^x + e^{-x}}
$$

Tanh函数可以作为神经网络中的一种激活函数，它解决了Sigmoid函数的不以0为中心输出问题，但仍然存在梯度消失和幂运算的问题。

### ReLU

ReLU激活函数是一种常用的非线性激活函数，全称为修正线性单元。它的主要作用是将输入值限制在一个非负的范围内，即当输入值小于0时，输出值为0;当输入值大于等于0时，输出值等于输入值本身。ReLU函数的表达式为：

$$
relu(x) = \max(0, x)
$$

ReLU函数相比于Sigmoid和Tanh等其他激活函数，有以下几个优势：
- ReLU函数可以解决梯度消失问题，因为它在正半区的梯度恒为1，不会随着输入的增大而趋近于0。
- ReLU函数可以加速收敛，因为它在负半区的输出为0，相当于减少了一半的参数，降低了模型的复杂度。
- ReLU函数可以引入稀疏性，因为它会使一部分神经元的输出为0，这样就减少了参数的相互依存关系，缓解了过拟合问题。

ReLU函数也有一些不足之处，主要是：
- ReLU函数在负半区的梯度为0，这可能导致一些神经元永远不被激活，称为神经元死亡问题。
- ReLU函数不是关于原点对称的，这可能导致输出的分布有偏移，影响训练的效率。

为了解决这些问题，人们提出了一些ReLU函数的变种，例如Leaky ReLU, PReLU, ELU等，它们在负半区都给予了一个较小的正梯度，从而避免了神经元死亡的问题，同时也保持了ReLU函数的优点。

### Swish or silu

Swish激活函数是一种新型的非线性激活函数，它由谷歌大脑团队于2017年提出。它的数学表达式是：

$$
swish(x) = x \cdot \sigma(\beta x)
$$

其中，$\sigma(x)$ 表示Sigmoid函数， $x$ 为输入， $\beta$ 是一个可学习的参数。
Swish激活函数可以看作是一个带有可学习参数的Sigmoid函数，它的形状类似于ReLU函数，但是具有Sigmoid函数的非线性特性。当 $\beta=0$ 时，Swish激活函数退化为线性函数 $f(x)=x$ ；当 $\beta \rightarrow \infty$ 时，Swish激活函数接近于ReLU函数。

### Linear or None

Linear激活函数是一种线性函数，它直接将输入值作为输出值，不进行任何非线性变换。它的数学表达式是：

$$
linear(x) = x
$$

Linear激活函数的优点是计算简单，不会出现梯度消失或爆炸的问题。但是，它的缺点也很明显，就是它没有引入任何非线性因素，无法拟合复杂的数据分布和函数关系。如果只使用Linear激活函数，那么多层神经网络就等价于一个单层神经网络，没有深度学习的意义。
因此，Linear激活函数通常只用于回归问题的输出层，或者二分类问题的输出层（配合sigmoid函数）。在隐藏层，一般使用非线性激活函数，如sigmoid, tanh, relu等，来增强神经网络的表达能力和学习能力。

## sigmoid 函数两种实现性能测试

```python
import time
import math
import numpy as np

def sigmoid_math(x):
    return 1 / (1 + math.exp(-x))

def sigmoid_numpy(x):
    return 1 / (1 + np.exp(-x))


x = np.random.rand(1000000)

start_time = time.time()
for i in x:
    sigmoid_numpy(i)
end_time = time.time()
print("sigmoid_numpy 耗时：", end_time - start_time)

start_time = time.time()
sigmoid_numpy(x)
end_time = time.time()
print("sigmoid_numpy narray耗时：", end_time - start_time)

start_time = time.time()
for i in x:
    sigmoid_math(i)
end_time = time.time()
print("sigmoid_math 耗时：", end_time - start_time)

```

输出：

    $ ./main.py
    sigmoid_numpy 耗时： 0.6583921909332275
    sigmoid_numpy narray耗时： 0.008673667907714844
    sigmoid_math 耗时： 0.1450803279876709

可以看出虽然numpy是c实现，但是在循环体中调用性能不及math方式。




## EvalCallback类中各参数解释

    eval_env： 用于评估的环境。
    callback_on_new_best： 当找到新的最优模型时触发的回调。
    callback_after_eval： 在每次评估后触发的回调。
    n_eval_episodes： 在每次评估中测试agent的episode数。
    eval_freq： 每次回调之间的timestep数。
    log_path： 评估结果保存的路径。
    best_model_save_path： 保存最优模型的路径。
    deterministic： 在评估时是否使用确定性或随机动作。
    render： 在评估时是否渲染环境。
    verbose： 回调的详细程度。
    warn： 是否在eval_env未被Monitor包装器包装时警告用户。


## PPO

stable-baselines PPO算法的各个参数的具体含义如下：

    policy: 用于指定策略网络的类型，可以是MlpPolicy, CnnPolicy等，也可以是自定义的网络类，需要继承BasePolicy类。
    env: 用于指定环境的名称或对象，需要符合gym风格的接口，即包含reset, step, render等方法。
    learning_rate: 用于指定学习率，可以是一个固定的数值，也可以是一个随着训练进度变化的函数。
    n_steps: 用于指定每次更新前需要经过的时间步，也就是每次收集多少条轨迹数据后进行一次梯度更新，该参数会影响算法的采样效率和更新频率。
    batch_size: 用于指定每次梯度更新时使用的小批量数据的大小，该参数会影响算法的内存占用和并行计算效率。
    n_epochs: 用于指定每次梯度更新时对同一批数据重复优化的次数，该参数会影响算法的收敛速度和稳定性。
    gamma: 用于指定折扣因子，即对未来奖励的衰减程度，该参数会影响算法对长期回报和短期回报的偏好。
    gae_lambda: 用于指定广义优势估计（GAE）中平衡偏差和方差的参数，该参数会影响算法对策略改进的灵敏度和稳健性。
    clip_range: 用于指定策略网络参数的裁剪范围，即限制策略改变的幅度，该参数会影响算法对探索和利用的平衡和避免过拟合的能力。
    clip_range_vf: 用于指定值函数网络参数的裁剪范围，即限制值函数改变的幅度，该参数会影响算法对值函数估计的准确性和稳定性。
    normalize_advantage: 用于指定是否对优势函数进行归一化处理，该参数会影响算法对不同状态下策略改进的权重分配。
    ent_coef: 用于指定损失函数中熵项的系数，即对策略熵的惩罚或奖励程度，该参数会影响算法对探索行为的鼓励或抑制程度。
    vf_coef: 用于指定损失函数中值函数项的系数，即对值函数误差的惩罚或奖励程度，该参数会影响算法对值函数优化和策略优化的权衡。
    max_grad_norm: 用于指定梯度裁剪时的最大梯度范数，即限制梯度下降的步长，该参数会影响算法对学习率敏感度和收敛稳定性。

### policy选择

MlpPolicy 是一个多层感知机（MLP）网络，可以处理各种类型的非图像数据，包括离散数据、连续数据和混合数据。

MlpPolicy 是一个具有多个隐藏层的神经网络。每个隐藏层由一个线性层和一个 ReLU 激活函数组成。输出层是一个线性层，用于生成动作概率。

CnnPolicy 是一个卷积神经网络（CNN）网络，用于处理图像数据。

CnnPolicy 是一个具有多个卷积层和池化层的神经网络。卷积层用于提取图像特征，池化层用于降低特征的维度。输出层是一个线性层，用于生成动作概率。


在选择策略网络时，需要考虑以下因素：

    数据类型：如果数据是图像数据，则可以使用 CnnPolicy。如果数据是非图像数据，则可以使用 MlpPolicy。
    模型复杂度：MlpPolicy 的模型复杂度比 CnnPolicy 低。如果计算资源有限，则可以使用 MlpPolicy。
    模型性能：CnnPolicy 通常比 MlpPolicy 具有更好的性能。如果需要获得更好的性能，则可以使用 CnnPolicy。


## 梯度

### 策略网络

    self.policy_kwargs = dict(net_arch=[128, 128])

```
        obs
   /            \
 <128>          <128>
  |              |
 <128>          <128>
  |              |
policy_net    value_net
```

    self.policy_kwargs = dict(net_arch=dict(pi=[256, 256, 256],vf=[128, 256, 128]))

```
        obs
   /            \
 <256>          <128>
  |              |
 <256>          <256>
  |              |
 <256>          <128>
  |              |
policy_net    value_net
```


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

# tensorRT

## 安装

    pip install --extra-index-url https://pypi.nvidia.com tensorrt-libs
    pip install --extra-index-url https://pypi.nvidia.com tensorrt



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

神经网络图例：[https://www.asimovinstitute.org/neural-network-zoo/](https://www.asimovinstitute.org/neural-network-zoo/)


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

