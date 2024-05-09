---
layout: post
title: Huggingface
---


# 源切换

镜像源：[https://hf-mirror.com/](https://hf-mirror.com/)

安装hfd.sh依赖以下包

    apt install git-lfs
    apt install aria2

### 在线模型依赖切换到本地模型

下载模型

    ./hfd.sh BELLE-2/Belle-whisper-large-v3-zh --tool aria2c -x 4

下载模块

    pip install transformers

```python
from transformers import pipeline

transcriber = pipeline(
  "automatic-speech-recognition", 
  model="BELLE-2/Belle-whisper-large-v3-zh"
)

transcriber.model.config.forced_decoder_ids = (
  transcriber.tokenizer.get_decoder_prompt_ids(
    language="zh", 
    task="transcribe"
  )
)

transcription = transcriber("my_audio.wav")

print(transcription)
```

切换到本地模型

```python
transcriber = pipeline(
  "automatic-speech-recognition", 
  model=r"c:/01_cloud/hf/Belle-whisper-large-v3-zh"
)
```



## Transformers

[https://huggingface.co/docs/transformers/main/en/main_classes/pipelines](https://huggingface.co/docs/transformers/main/en/main_classes/pipelines)



