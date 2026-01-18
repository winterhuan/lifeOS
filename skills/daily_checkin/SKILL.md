---
name: Daily Check-in
description: 个人每日反思与计划系统。引导用户进行每日签到，记录心情、成就，并生成深度反思分析。
allowed-tools: [write_to_file, view_file, list_dir]
---

# 每日签到 (Daily Check-in)

这是一个交互式的 Skill，分两阶段进行。

## 流程:

### 第一阶段：提问 (交互启动)

1. **理解上下文**
   - 快速浏览用户的 `life/journal/daily/` 最近几天的记录（如果有），了解近期状态。

2. **发起提问**
   - 加载模板：`.claude/skills/daily_checkin/prompts/checkin_questions.md`
   - 根据当前时间（早/午/晚）调整问候语。
   - 向用户发送问题，并**等待用户回复**。

### 第二阶段：记录与分析 (用户回复后执行)

3. **保存日记**
   - 将用户的回答保存至：`life/journal/daily/YYYY-MM-DD.md`

4. **生成反思**
   - 加载分析指令：`.claude/skills/daily_checkin/prompts/analyze_reflection.md`
   - 对用户的回答进行深度分析（结合最近几天的记录）。
   - 创建可视化总结。

5. **保存分析**
   - 将分析结果保存至：`life/journal/daily/YYYY-MM-DD-reflection.md`
   - 向用户展示分析的摘要和明天的建议。

## 关键原则:
- **同理心**：始终保持鼓励和支持的语气。
- **关注进步**：重点关注用户做到了什么，而不是没做什么。
- **中文输出**：所有交互、保存的文件和分析报告必须使用中文。
