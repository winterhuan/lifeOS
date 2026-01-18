---
name: Brain Dump Analysis
description: 深度思考分析助手：从你的意识流写作（Brain Dumps）中提取深刻见解和模式。
allowed-tools: [view_file, list_dir, write_to_file, read_url_content]
---

# 深度思考分析助手 (Brain Dump Analysis)

## 流程:

### 1. 文件夹发现
- 检查 `life/braindumps/` 是否存在
- 如果不存在，创建它并引导用户放入 brain dump 文件
- 扫描文件夹下的所有文本文件 (.txt, .md)

### 2. 内容读取
- 读取 `life/braindumps/` 下的所有文件
- 保留原始格式和语音
- 注意文件名或内容中的时间戳

### 3. 洞察提取
- 调用 `insight-extractor` Agent。
- 分析所有读取的内容，寻找深层模式。

### 4. 分析阶段
- 调用 `brain-dump-analyst` Agent。
- 基于提取的见解，生成综合分析报告。

### 5. 输出组织
- 将提取的见解保存至 `life/braindumps/analysis/insights-YYYY-MM-DD.md`
- 将完整分析报告保存至 `life/braindumps/analysis/analysis-YYYY-MM-DD.md`
- 向用户提供关键发现的摘要

## 主要功能:
- 跨多个文件的模式识别
- 思维演变追踪
- 发现隐藏的连接
- 提取行动项
- 内容灵感生成（针对创作者）
- 可视化展示思维

## 重要提示:
- **保留**作者真实的语气
- **庆祝**思考和成长
- **发现**作者自己看不到的模式
- **让**洞察具有可操作性
- **展示**想法如何连接和演变
- **必须**使用中文输出所有分析结果
