---
name: Weekly Check-in
description: 个性化周度复盘系统。智能发现和追踪相关指标，生成可视化增长分析报告。
allowed-tools: [view_file, list_dir, write_to_file, read_terminal]
---

# 周度复盘 (Weekly Check-in)

这是一个交互式的 Skill，分阶段执行。

## 流程:

### 1. 上下文发现与指标识别
- 分析 `CLAUDE.md` 及 `life/business/`, `life/docs/` 等文件夹。
- 读取并使用 `skills/weekly_checkin/prompts/identify_metrics.md` 来确定适合该用户的指标。

### 2. 数据收集 (交互)
- 基于识别出的指标，向用户提问，要求输入本周数据。
- **等待用户回复**。

### 3. 分析与报告
- 读取历史数据：`life/metrics/metrics-history.md` (如果存在)。
- 调用 `metrics-analyst` Agent 进行深度分析。

### 4. 输出组织
- 更新历史数据：将新数据追加到 `life/metrics/metrics-history.md`。
- 保存详细报告：`life/metrics/weekly-report-YYYY-MM-DD.md`。
- 向用户展示关键见解摘要。

## 关键特性:
- **智能适配**：不使用通用模板，根据你的实际项目类型（创作者/开发者/SaaS等）定制指标。
- **数据驱动**：关注增长率和趋势。
- **可视化**：生成 ASCII/Mermaid 图表。
- **中文输出**：全流程使用中文。

## 重要提示:
- 专注于**可操作的见解**，而不仅仅是数据收集。
- 如果是第一次运行，自动创建必要的目录。
