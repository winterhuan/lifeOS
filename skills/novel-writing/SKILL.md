---
name: novel-writing
version: "1.0.0"
description: 自动化小说写作系统。支持多项目管理、批量章节生成、热门趋势研究、参考库学习。采用"协同创作者"理念，AI辅助而非替代用户创作。
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - WebFetch
  - WebSearch
hooks:
  PreToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "cat novel_plan.md 2>/dev/null | head -50 || true"
  PostToolUse:
    - matcher: "Write"
      hooks:
        - type: command
          command: "echo '[novel-writing] 文件已保存。请更新 novel_plan.md 状态。'"
  Stop:
    - hooks:
        - type: command
          command: "echo '=== 会话结束 ===' >> session_log.md && date >> session_log.md"
---

# 小说写作系统 (Novel Writing System)

## 核心理念

> 基于 `planning-with-files` 方法论

```
上下文窗口 = RAM (易失)
文件系统 = Disk (持久)

→ 所有重要信息必须写入文件
```

### 核心规则

1. **先创建计划** — 永远不要在没有 `novel_plan.md` 的情况下开始写作
2. **行动后更新** — 每完成一章，立即更新 `novel_plan.md` 状态
3. **绝不重复失败** — 如果某方法失败，记录到 `findings.md`，换一种方法
4. **定期保存发现** — 重要洞察写入 `findings.md`
5. **会话可恢复** — 中断后可从文件状态恢复

### 状态检查
```bash
# 检查项目状态
bash skills/novel-writing/scripts/check-novel-status.sh
```

## 快速开始

### 初始化新项目
```bash
/write-novel init "我的小说" --type 玄幻
```

### 工作流
1. `/novel-research 玄幻` — 研究市场趋势
2. `/write-novel plan` — 生成大纲
3. `/write-novel draft --chapters 3` — 批量写作
4. `/write-novel review` — 质量审查
5. `/write-novel export --format epub` — 导出

---

## 核心文件

| 文件 | 用途 | 更新时机 |
|------|------|----------|
| `novel_plan.md` | 大纲、章节状态、进度 | 每章完成后 |
| `world_bible.md` | 世界观、角色、设定 | 设定变更后 |
| `session_log.md` | 写作日志、决策 | 每次会话 |
| `findings.md` | 发现、洞察、失败记录 | 有重要发现时 |

---

## 智能体 (Agents)

### 研究阶段
**TrendScout** — 市场趋势分析 (见 `agents/novel-trend-scout.md`)
- 抓取排行榜 (起点/番茄/七猫/百度/17K)
- 输出: `research/market_trends.md`

### 规划阶段
**Architect** — 大纲与结构设计 (见 `agents/novel-architect.md`)
- 读取: 趋势报告 + 用户需求 + 参考库
- 输出: `novel_plan.md`
- 要点:
  - 三幕式结构
  - 每章设置"承诺"(悬念/问题/发现)
  - 章末钩子

### 设定阶段
**CharacterDev** — 角色与世界观 (见 `agents/novel-character-dev.md`)
- 读取: `novel_plan.md`
- 输出: `world_bible.md`
- 要点:
  - 角色动机与成长弧
  - 世界规则一致性
  - 人物关系网

### 写作阶段
**Ghostwriter** — 章节起草 (见 `agents/novel-ghostwriter.md`)
- 读取: `novel_plan.md` + `world_bible.md` + `references/`
- 输出: `chapters/chapter_XX.md`
- 要点:
  - 感官描写 ≥ 3种/场景
  - 展示不讲述
  - 保持节奏张力

### 质量阶段
**HookMaster / TensionArc** — 见 `agents/novel-editor.md`
- 开篇优化：确保第一句/段创造不可抗拒的好奇心
- 节奏检查：章末悬念，张力起伏自然

**ClicheDetector** — 陈词滥调扫描 (见 `scripts/cliche_check.py`)
- 运行: `python3 scripts/cliche_check.py <文件>`
- 扫描: "一道寒光闪过"、"眼中精光一闪"等

### 审核阶段
**Editor** — 一致性与风格 (见 `agents/novel-editor.md`)
- 对比 `world_bible.md` 检查矛盾
- 风格统一性

### 反馈阶段
**BetaReader** — 模拟读者 (见 `agents/novel-beta-reader.md`)
- 输出: `feedback/chapter_XX_beta.md`
- 反馈: "这里困惑"、"节奏太慢"、"很精彩"

---

## 参考库 (Reference Library)

| 目录 | 内容 |
|------|------|
| `references/books/` | 参考书籍摘要 |
| `references/techniques/` | 写作技巧 |
| `references/exemplars/` | 优秀范文 |
| `references/trending/` | 自动生成的热门分析 |

### 使用
- `init --ref <路径>` — 预加载参考
- `--style-ref "金庸风格.md"` — 模仿风格

### 自动采集
`/novel-research --summarize`:
1. 抓取 Top 10 书籍前 3 章
2. 提取: 钩子、人设、节奏、爽点
3. 保存到 `references/trending/`

---

## 不过时指南

| ❌ 避免 | ✅ 优先 |
|---------|---------|
| 流行文化梗 | 普世人性主题 |
| 具体科技名称 | 通用术语 |
| 网络流行语 | 经典表达 |
| 时政直接评论 | 寓言/象征 |

---

## 质量检查清单

- [ ] 每章开头有"承诺"
- [ ] 安静场景也有内在冲突
- [ ] 感官描写 ≥ 3种/场景
- [ ] 章末留有"钩子"
- [ ] 无陈词滥调
- [ ] 与 world_bible 一致

---

## 批量生成规则

使用 `--all` 或 `--chapters N` 时:
1. 每章生成后立即保存
2. 更新 `novel_plan.md` 状态
3. 中断可恢复
4. 完成后运行全书扫描

---

## 多项目管理

```bash
/write-novel list          # 列出所有项目
/write-novel switch "书名"  # 切换项目
```

项目存储于 `~/novels/`，由 `.novel_registry.json` 管理。

---

## Skill 协作

本 Skill 与以下 Skill 协作：

| Skill | 用途 | 触发时机 |
|-------|------|---------|
| `dev-browser` | 抓取排行榜数据 | `/novel-research` |
| `content-research-writer` | 章节润色方法论 | `/write-novel review` `/write-novel feedback` |
| `planning-with-files` | 状态管理方法论 | 自动应用 |

> 详细的 Skill 使用方法请查阅各自的 `SKILL.md` 文件。

---

## 错误恢复

### 常见错误

| 错误 | 原因 | 解决方案 |
|------|------|---------|
| "找不到 novel_plan.md" | 未初始化项目 | `/write-novel init "书名"` |
| "项目不存在" | 切换到不存在的项目 | `/write-novel list` 查看 |
| "章节冲突" | 设定与 world_bible 矛盾 | `/write-novel review` 检查 |
| "批量生成中断" | 会话超时或手动中断 | 直接重新运行，自动跳过已完成章节 |

### 状态检查与恢复
```bash
# 检查项目状态
bash skills/novel-writing/scripts/check-novel-status.sh

# 查看当前进度
cat novel_plan.md | grep -E "^\s*-\s*\[.\]"
```

### 恢复写作
中断后重新开始时，系统会自动：
1. 读取 `novel_plan.md` 确定当前进度
2. 跳过已完成章节
3. 从上次中断处继续

---

## 环境要求

| 依赖 | 用途 | 安装 |
|------|------|------|
| Python 3.8+ | 项目管理脚本 | 系统自带 |
| Node.js 18+ | dev-browser（可选） | `brew install node` |
| pandoc | epub 导出（可选） | `brew install pandoc` |


