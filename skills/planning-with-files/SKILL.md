---
name: planning-with-files
version: "2.3.0"
description: 实现 Manus 风格的文件规划，用于复杂任务。创建 task_plan.md, findings.md 和 progress.md。当开始复杂的多步骤任务、研究项目或任何需要超过 5 次工具调用的任务时使用。支持 /clear 后的自动会话恢复。
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
    - matcher: "Write|Edit|Bash|Read|Glob|Grep"
      hooks:
        - type: command
          command: "cat task_plan.md 2>/dev/null | head -30 || true"
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "echo '[planning-with-files] 文件已更新。如果这完成了某个阶段，请更新 task_plan.md 状态。'"
  Stop:
    - hooks:
        - type: command
          command: |
            bash "${CLAUDE_PLUGIN_ROOT}/skills/planning-with-files/scripts/check-complete.sh"
---

# 基于文件的规划 (Planning with Files)

像 Manus 一样工作：使用持久的 markdown 文件作为你的“磁盘上的工作记忆”。

## 第一步：检查之前的会话 (v2.2.0)

**在开始工作之前**，检查是否有来自之前会话的未同步上下文：

```bash
# 运行会话检查 (如果有相关脚本)
# 目前 lifeOS 版本简化了此步骤，直接初始化即可
```

## 重要：文件去向

**你的规划文件** 放在 **你的项目目录** 中。

| 位置 | 内容 |
|------|------|
| Skill 目录 (`.../skills/planning-with-files/`) | 模板、脚本、参考文档 |
| 你的项目目录 | `task_plan.md`, `findings.md`, `progress.md` |

## 快速开始

在任何复杂任务之前：

1.  **创建 `task_plan.md`** — 使用 [templates/task_plan.md](templates/task_plan.md) 作为参考
2.  **创建 `findings.md`** — 使用 [templates/findings.md](templates/findings.md) 作为参考
3.  **创建 `progress.md`** — 使用 [templates/progress.md](templates/progress.md) 作为参考
4.  **在做决定前重读计划** — 在注意力窗口中刷新目标
5.  **在每个阶段后更新** — 标记完成，记录错误

> **注意:** 规划文件放在你的项目根目录，而不是技能安装文件夹。

你可以使用 `scripts/init-session.sh` 来自动创建这些文件：

```bash
${CLAUDE_PLUGIN_ROOT}/skills/planning-with-files/scripts/init-session.sh [项目名称]
```

## 核心模式

```
上下文窗口 (Context Window) = RAM (易失，有限)
文件系统 (Filesystem) = Disk (持久，无限)

→ 任何重要的事情都要写入磁盘。
```

## 文件用途

| 文件 | 用途 | 何时更新 |
|------|------|----------|
| `task_plan.md` | 阶段、进度、决定 | 每个阶段后 |
| `findings.md` | 研究、发现 | 任何发现后 |
| `progress.md` | 会话日志、测试结果 | 整个会话期间 |

## 关键规则

### 1. 先创建计划
永远不要在没有 `task_plan.md` 的情况下开始复杂任务。没得商量。

### 2. 双动作规则 (The 2-Action Rule)
> “每做 2 次查看/浏览器/搜索操作后，立即将关键发现保存到文本文件中。”

这可以防止视觉/多模态信息丢失。

### 3. 先读后决 (Read Before Decide)
在做出重大决定之前，阅读计划文件。这可以让目标保持在你的注意力窗口中。

### 4. 行动后更新 (Update After Act)
完成任何阶段后：
- 标记阶段状态：`in_progress` → `complete`
- 记录遇到的任何错误
- 记录创建/修改的文件

### 5. 记录所有错误
每个错误都要进入计划文件。这建立了知识并防止重复。

```markdown
## 遇到的错误
| 错误 | 尝试次数 | 解决方案 |
|------|----------|----------|
| FileNotFoundError | 1 | 创建默认配置 |
| API timeout | 2 | 添加重试逻辑 |
```

### 6. 永不重复失败
```
if action_failed:
    next_action != same_action
```
追踪你尝试过的方法。改变方法。

## 何时使用此模式

**用于：**
- 多步骤任务（3步以上）
- 研究任务
- 构建/创建项目
- 跨越许多工具调用的任务
- 任何需要组织的事务

**跳过：**
- 简单问题
- 单文件编辑
- 快速查找
