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



