---
layout: post
title: MachineVision
---


# 标注工具


| 名称 | 网址 | 说明 |
|------|------|------|
| Roboflow | [https://roboflow.com](https://roboflow.com) | 在线托管、预处理、标注、CV项目部署 |
| T-Rex Label | [https://trexlabel.com](https://trexlabel.com) | 在线COCO、YOLO |
| X-Anylabeling | [https://github.com/CVHub520/X-AnyLabeling](https://github.com/CVHub520/X-AnyLabeling) |  |


# 标注格式

## Instance Segmentation

| 格式       | 表达方式       | 坐标  | 是否区分实例 |
| ---------- | ------------- | ----- | ----------- |
| YOLO-seg   | polygon       | 归一化 | 是         |
| COCO       | polygon / RLE | 像素   | 是         |
| VOC-mask   | mask 图       | 像素   | 否         |
| Cityscapes | mask          | 像素   | 是         |



# sam3


安装流程：

```bash
# 1. 创建并进入项目文件夹
mkdir sam3-deploy && cd sam3-deploy

# 2. 初始化环境（uv 会自动检测并下载合适的 Python 3.12+）
uv init

# 3. 安装 SAM 3 核心依赖
# 手动编辑 pyproject.toml，在文件末尾添加以下内容：
[[tool.uv.index]]
name = "pytorch-cu124"
url = "https://download.pytorch.org/whl/cu124"
explicit = true

[tool.uv.sources]
torch = { index = "pytorch-cu124" }
torchvision = { index = "pytorch-cu124" }
torchaudio = { index = "pytorch-cu124" }

# 然后安装依赖
uv add torch torchvision torchaudio

# 4.安装 SAM 3 相关的其他库
# 注意：直接从 GitHub 安装 transformers 的最新开发版，以确保支持 SAM 3
uv add "git+https://github.com/huggingface/transformers.git"
uv add accelerate pillow numpy huggingface_hub

# 5.直接用 Python 代码登录
uv run python -c "from huggingface_hub import login; login()"
# 然后用申请通过后的token登录

# 6.下载模型
# 可使用镜像：export HF_ENDPOINT=https://hf-mirror.com
hf download facebook/sam3 --local-dir /mnt/hf_cache/hub --local-dir-use-symlinks False


```

