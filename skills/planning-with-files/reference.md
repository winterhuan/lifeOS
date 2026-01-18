# 参考资料: Manus 上下文工程原则 (Reference: Manus Context Engineering Principles)

此技能基于 Manus 的上下文工程原则，该 AI 代理公司于 2025 年 12 月被 Meta 以 20 亿美元收购。

## Manus 的 6 大原则

### 原则 1: 围绕 KV-Cache 设计 (Design Around KV-Cache)
> "KV-cache 命中率是生产级 AI 代理**最重要**的指标。"

**统计数据:**
- ~100:1 输入与输出 token 比率
- 缓存 token: $0.30/MTok vs 未缓存: $3/MTok
- 10倍的成本差异！

**实施:**
- 保持 prompt 前缀**稳定**（单个 token 变化会使缓存失效）
- 系统 prompt 中**不要**包含时间戳
- 使上下文**仅追加**且具有确定性的序列化

### 原则 2: 屏蔽，不要移除 (Mask, Don't Remove)
不要动态移除工具（会破坏 KV-cache）。使用 logit masking 代替。

**最佳实践:** 使用一致的动作前缀 (例如 `browser_`, `shell_`, `file_`) 以便更容易屏蔽。

### 原则 3: 文件系统作为外部存储器 (Filesystem as External Memory)
> "Markdown 是我在磁盘上的'工作记忆'。"

**公式:**
```
上下文窗口 (Context Window) = RAM (易失，有限)
文件系统 (Filesystem) = Disk (持久，无限)
```

**压缩必须是可恢复的:**
- 即使网页内容被丢弃，也要保留 URL
- 当丢弃文档内容时，保留文件路径
- 永远不要丢失指向完整数据的指针

### 原则 4: 通过背诵操纵注意力 (Manipulate Attention Through Recitation)
> "在整个任务过程中创建并更新 todo.md，将全局计划推入模型的近期注意力范围。"

**问题:** 在 ~50 次工具调用后，模型会忘记最初的目标（"迷失在中间"效应）。

**解决方案:** 在每次决定之前重读 `task_plan.md`。目标出现在注意力窗口中。

```
上下文开始: [最初的目标 - 遥远，被遗忘]
...许多工具调用...
上下文结束: [最近读取的 task_plan.md - 获得注意力！]
```

### 原则 5: 保留错误的东西 (Keep the Wrong Stuff In)
> "把错误的转折留在上下文中。"

**为什么:**
- 带有堆栈跟踪的失败操作让模型隐式更新信念
- 减少错误重复
- 错误恢复是“真正的代理行为的最清晰信号之一”

### 原则 6: 不要被 Few-Shot 固化 (Don't Get Few-Shotted)
> "一致性滋生脆弱性。"

**问题:** 重复的动作-观察对会导致漂移和幻觉。

**解决方案:** 引入受控的变化：
- 稍微改变措辞
- 不要盲目复制粘贴模式
- 在重复任务上重新校准

---

## 3 种上下文工程策略

基于 Lance Martin 对 Manus 架构的分析。

### 策略 1: 上下文缩减 (Context Reduction)
**压缩 (Compaction):**
```
工具调用有两种表示形式:
├── FULL: 原始工具内容 (存储在文件系统中)
└── COMPACT: 仅引用/文件路径

规则:
- 对旧的 (stale) 工具结果应用压缩
- 保持最近的 (RECENT) 结果完整 (以指导下一个决定)
```

**摘要 (Summarization):**
- 当压缩达到收益递减时应用
- 使用完整的工具结果生成
- 创建标准化的摘要对象

### 策略 2: 上下文隔离 (Context Isolation - Multi-Agent)
**架构:**
```
┌─────────────────────────────────┐
│         PLANNER AGENT           │
│  └─ 分配任务给子代理             │
├─────────────────────────────────┤
│       KNOWLEDGE MANAGER         │
│  └─ 审查对话                     │
│  └─ 确定文件系统存储             │
├─────────────────────────────────┤
│      EXECUTOR SUB-AGENTS        │
│  └─ 执行分配的任务               │
│  └─ 拥有自己的上下文窗口         │
└─────────────────────────────────┘
```

**关键洞察:** Manus 最初使用 `todo.md` 进行任务规划，但发现约 33% 的操作用于更新它。后来转向专用的规划代理调用执行子代理。

### 策略 3: 上下文卸载 (Context Offloading)
**工具设计:**
- 总共使用 <20 个原子函数
- 将完整结果存储在文件系统，而不是上下文
- 使用 `glob` 和 `grep` 进行搜索
- 渐进式披露: 仅在需要时加载信息

---

## 代理循环 (The Agent Loop)
Manus 在一个连续的 7 步循环中运行：

```
┌─────────────────────────────────────────┐
│  1. 分析上下文 (ANALYZE CONTEXT)         │
│     - 理解用户意图                       │
│     - 评估当前状态                       │
│     - 审查最近的观察结果                 │
├─────────────────────────────────────────┤
│  2. 思考 (THINK)                         │
│     - 我应该更新计划吗？                 │
│     - 下一个逻辑动作是什么？             │
│     - 有阻碍吗？                         │
├─────────────────────────────────────────┤
│  3. 选择工具 (SELECT TOOL)               │
│     - 选择一个工具                       │
│     - 确保参数可用                       │
├─────────────────────────────────────────┤
│  4. 执行动作 (EXECUTE ACTION)            │
│     - 工具在沙盒中运行                   │
├─────────────────────────────────────────┤
│  5. 接收观察 (RECEIVE OBSERVATION)       │
│     - 结果追加到上下文                   │
├─────────────────────────────────────────┤
│  6. 迭代 (ITERATE)                       │
│     - 返回步骤 1                         │
│     - 继续直到完成                       │
├─────────────────────────────────────────┤
│  7. 交付结果 (DELIVER OUTCOME)           │
│     - 发送结果给用户                     │
│     - 附上所有相关文件                   │
└─────────────────────────────────────────┘
```

---

## Manus 创建的文件类型
| 文件 | 用途 | 何时创建 | 何时更新 |
|------|------|----------|----------|
| `task_plan.md` | 阶段跟踪，进度 | 任务开始 | 完成阶段后 |
| `findings.md` | 发现，决定 | 任何发现后 | 查看图像/PDF后 |
| `progress.md` | 会话日志，已完成事项 | 在断点处 | 整个会话期间 |
| 代码文件 | 实施 | 执行前 | 错误后 |

---

## 关键约束 (Critical Constraints)
- **单动作执行:** 每轮一次工具调用。无并行执行。
- **必须有计划:** 代理必须始终知道：目标、当前阶段、剩余阶段。
- **文件即记忆:** 上下文 = 易失。文件系统 = 持久。
- **永不重复失败:** 如果动作失败，下一个动作必须不同。
- **沟通即工具:** 消息类型：`info` (进度), `ask` (阻塞), `result` (终结)。

---

## Manus 统计数据
| 指标 |以此为准 |
|------|-------|
| 每个任务的平均工具调用 | ~50 |
| 输入与输出 token 比率 | 100:1 |
| 收购价格 | 20 亿美元 |
| 达到 1 亿美元收入的时间 | 8 个月 |
| 发布以来的框架重构 | 5 次 |

---

## 关键引言 (Key Quotes)
> "Context window = RAM (volatile, limited). Filesystem = Disk (persistent, unlimited). Anything important gets written to disk."
> (上下文窗口 = RAM (易失，有限)。文件系统 = Disk (持久，无限)。任何重要的事情都要写入磁盘。)

> "if action_failed: next_action != same_action. Track what you tried. Mutate the approach."
> (如果动作失败：下一个动作 != 相同的动作。追踪你尝试过的方法。改变方法。)

> "Error recovery is one of the clearest signals of TRUE agentic behavior."
> (错误恢复是真正的代理行为的最清晰信号之一。)

> "KV-cache hit rate is the single most important metric for a production-stage AI agent."
> (KV-cache 命中率是生产级 AI 代理最重要的指标。)

> "Leave the wrong turns in the context."
> (把错误的转折留在上下文中。)

---

## 来源
基于 Manus 的官方上下文工程文档:
https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
