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
