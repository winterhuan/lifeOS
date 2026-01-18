# LifeOS Claude Code 插件

此仓库包含适用于 Claude Code 的 LifeOS Skills、Agents 和 Commands。

## 功能特性

- **每日简报 (Daily Brief)**：生成个性化的每日新闻简报。
- **每日签到 (Daily Check-in)**：跟踪每日进度和反思。
- **每周复盘 (Weekly Check-in)**：分析每周指标和趋势。
- **深度思考分析 (Brain Dump Analysis)**：从你的想法中提取见解。
- **Newsletter 研究 (Newsletter Research)**：研究并撰写 Newsletter。
- **内容研究写作 (Content Research Writer)**：通用型内容创作助手，协助大纲编写、研究和润色。
- **Dev Browser**：集成 SawyerHood 的浏览器自动化工具，支持 AI 友好的网页浏览和操作。

## 浏览器自动化 (Dev Browser)

本插件集成了 `SawyerHood/dev-browser`。为了获得最佳体验（如复用本地 Cookie 无需登录），建议安装配套的 Chrome 扩展。

**安装 Chrome 扩展 (可选，推荐)**:
1.  下载最新的扩展程序包 (`extension.zip`)：[dev-browser releases](https://github.com/SawyerHood/dev-browser/releases)
2.  解压到一个固定目录。
3.  在 Chrome 中打开 `chrome://extensions`。
4.  开启右上角 **"开发者模式" (Developer mode)**。
5.  点击 **"加载已解压的扩展程序" (Load unpacked)** 并选择解压后的目录。
6.  点击浏览器工具栏的 Dev Browser 图标，切换为 **Active** 即可连接。

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

## 更新

要更新插件到最新版本，请运行：

```bash
claude /plugin update lifeos@lifeos-marketplace
```
*(或者重新运行安装命令以获取最新版本)*

## 目录结构

- `commands/`: Claude 可调用的斜杠命令。
- `skills/`: 可复用的技能和指令流程。
- `agents/`: 专业的 Agent 角色定义。

## Commands & Data Flow

为了帮助你了解每个命令的作用范围，以下是详细的输入输出路径说明：

### 🧠 深度思考分析 (Brain Dump Analysis)
*   **Command**: `/brain-dump-analysis`
*   **输入**: 读取 `braindumps/` 目录下的所有文本文件 (`.txt`, `.md`)。
*   **输出**:
    *   洞察报告: `braindumps/analysis/insights-YYYY-MM-DD.md`
    *   完整分析: `braindumps/analysis/analysis-YYYY-MM-DD.md`

### 📰 每日简报 (Daily Brief)
*   **Command**: `/daily-brief`
*   **输入**: 分析用户工作区 (`CLAUDE.md`, `braindumps/` 等) 以识别兴趣。
*   **输出**:
    *   每日简报: `daily-brief/YYYY-MM-DD-brief.md`

### 🌅 每日签到 (Daily Check-in)
*   **Command**: `/daily-checkin`
*   **输入**: 用户的交互式回复 + 历史日记 `journal/daily/`。
*   **输出**:
    *   日记条目: `journal/daily/YYYY-MM-DD.md`
    *   反思分析: `journal/daily/YYYY-MM-DD-reflection.md`

### 📧 Newsletter 研究 (Newsletter Research)
*   **Command**: `/newsletter-research`
*   **输入**: 简报来源 (来自 `newsletter/sources/` 或用户提供) + 互联网内容。
*   **输出**:
    *   研究分析: `newsletter/research/YYYY-MM-DD-analysis.md`
    *   内容草稿: `newsletter/drafts/YYYY-MM-DD-draft.md`
    *   指标数据: `metrics/newsletter-metrics.md`

### 📈 每周复盘 (Weekly Check-in)
*   **Command**: `/weekly-checkin`
*   **输入**: 分析项目上下文 (`CLAUDE.md` 等) 以智能发现指标 + **针对具体指标的问答数据** + 历史指标 `metrics/metrics-history.md`。
*   **输出**:
    *   详细报告: `metrics/weekly-report-YYYY-MM-DD.md`
    *   历史数据更新: `metrics/metrics-history.md`

### ✍️ 内容研究写作 (Content Research Writer)
*   **Command**: `/content-research-writer`
*   **输入**: 用户提供的写作主题、大纲或草稿。
*   **输出**:
    *   协作生成的文稿、研究笔记（通常位于用户指定的写作目录或当前目录）。

## 致谢 (Credits)

- **Content Research Writer**: 本技能改编自 ComposioHQ 的 [Content Research Writer Skill](https://github.com/ComposioHQ/awesome-claude-skills/blob/master/content-research-writer/SKILL.md)。
- **Inspiration**: 项目灵感来源于 Alex Finn 的视频 [How I use Claude Code to automate my entire life (5 tricks)](https://www.youtube.com/watch?v=wfiv67NixCY) 以及 [Claude Code Life OS: 5 Automation Techniques](https://cc.deeptoai.com/docs/en/community-tips/claude-code-life-os)。
