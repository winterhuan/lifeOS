# LifeOS Claude Code 插件

此仓库包含适用于 Claude Code 的 LifeOS Skills、Agents 和 Commands。

## 功能特性

- **每日简报 (Daily Brief)**：生成个性化的每日新闻简报。
- **每日签到 (Daily Check-in)**：跟踪每日进度和反思。
- **每周复盘 (Weekly Check-in)**：分析每周指标和趋势。
- **深度思考分析 (Brain Dump Analysis)**：从你的想法中提取见解。
- **Newsletter 研究 (Newsletter Research)**：研究并撰写 Newsletter。

## 安装

要在 Claude Code 中使用此插件：

1. **添加市场**：
   ```bash
   claude /plugin marketplace add winterhuan/lifeOS
   ```

2. **安装插件**：
   ```bash
   claude /plugin install lifeos@lifeos-marketplace
   ```

## 目录结构

- `commands/`: Claude 可调用的斜杠命令。
- `skills/`: 可复用的技能和指令流程。
- `agents/`: 专业的 Agent 角色定义。

## Commands & Data Flow

为了帮助你了解每个命令的作用范围，以下是详细的输入输出路径说明：

### 🧠 深度思考分析 (Brain Dump Analysis)
*   **Command**: `/brain-dump-analysis`
*   **输入**: 读取 `life/braindumps/` 目录下的所有文本文件 (`.txt`, `.md`)。
*   **输出**:
    *   洞察报告: `life/braindumps/analysis/insights-YYYY-MM-DD.md`
    *   完整分析: `life/braindumps/analysis/analysis-YYYY-MM-DD.md`

### 📰 每日简报 (Daily Brief)
*   **Command**: `/daily-brief`
*   **输入**: 分析用户工作区 (`CLAUDE.md`, `life/` 等) 以识别兴趣。
*   **输出**:
    *   每日简报: `life/daily-brief/YYYY-MM-DD-brief.md`

### 🌅 每日签到 (Daily Check-in)
*   **Command**: `/daily-checkin`
*   **输入**: 用户的交互式回复 + 历史日记 `life/journal/daily/`。
*   **输出**:
    *   日记条目: `life/journal/daily/YYYY-MM-DD.md`
    *   反思分析: `life/journal/daily/YYYY-MM-DD-reflection.md`

### 📧 Newsletter 研究 (Newsletter Research)
*   **Command**: `/newsletter-research`
*   **输入**: 简报来源 (来自 `life/newsletter/sources/` 或用户提供) + 互联网内容。
*   **输出**:
    *   研究分析: `life/newsletter/research/YYYY-MM-DD-analysis.md`
    *   内容草稿: `life/newsletter/drafts/YYYY-MM-DD-draft.md`
    *   指标数据: `life/metrics/newsletter-metrics.md`

### 📈 每周复盘 (Weekly Check-in)
*   **Command**: `/weekly-checkin`
*   **输入**: 用户交互式提供的指标数据 + 历史指标 `life/metrics/metrics-history.md`。
*   **输出**:
    *   详细报告: `life/metrics/weekly-report-YYYY-MM-DD.md`
    *   历史数据更新: `life/metrics/metrics-history.md`
