# 示例：基于文件的规划实战 (Planning with Files in Action)

## 示例 1: 研究任务 (Research Task)

**用户请求:** "研究晨练的好处并写一个总结"

### 循环 1: 创建计划 (Create Plan)
```bash
Write task_plan.md
```

```markdown
# 任务计划: 晨练益处研究

## 目标
创建一个关于晨练益处的研究总结。

## 阶段
- [ ] Phase 1: 创建此计划 ✓
- [ ] Phase 2: 搜索并收集来源
- [ ] Phase 3: 综合发现
- [ ] Phase 4: 交付总结

## 关键问题
1. 对身体健康有什么好处？
2. 对心理健康有什么好处？
3. 有哪些科学研究支持这一点？

## 状态
**当前处于 Phase 1** - 创建计划
```

### 循环 2: 研究 (Research)
```bash
Read task_plan.md           # 刷新目标
WebSearch "morning exercise benefits"
Write notes.md              # 存储发现
Edit task_plan.md           # 标记 Phase 2 完成
```

### 循环 3: 综合 (Synthesize)
```bash
Read task_plan.md           # 刷新目标
Read notes.md               # 获取发现
Write morning_exercise_summary.md
Edit task_plan.md           # 标记 Phase 3 完成
```

### 循环 4: 交付 (Deliver)
```bash
Read task_plan.md           # 验证完成
Deliver morning_exercise_summary.md
```

---

## 示例 2: 错误修复任务 (Bug Fix Task)

**用户请求:** "修复认证模块中的登录错误"

### task_plan.md
```markdown
# 任务计划: 修复登录 Bug

## 目标
识别并修复阻止成功登录的错误。

## 阶段
- [x] Phase 1: 理解错误报告 ✓
- [x] Phase 2: 定位相关代码 ✓
- [ ] Phase 3: 识别根本原因 (当前)
- [ ] Phase 4: 实施修复
- [ ] Phase 5: 测试并验证

## 关键问题
1. 出现了什么错误信息？
2. 哪个文件处理认证？
3. 最近改动了什么？

## 已做出的决定
- Auth 处理程序位于 src/auth/login.ts
- 错误发生在 validateToken() 函数中

## 遇到的错误
- [Initial] TypeError: Cannot read property 'token' of undefined
  → 根本原因: user 对象没有被正确 await

## 状态
**当前处于 Phase 3** - 找到根本原因，准备修复
```

---

## 示例 3: 功能开发 (Feature Development)

**用户请求:** "给设置页面添加暗黑模式切换"

### 3文件模式实战

**task_plan.md:**
```markdown
# 任务计划: 暗黑模式切换

## 目标
在设置中添加功能性的暗黑模式切换。

## 阶段
- [x] Phase 1: 研究现有的主题系统 ✓
- [x] Phase 2: 设计实施方案 ✓
- [ ] Phase 3: 实现切换组件 (当前)
- [ ] Phase 4: 添加主题切换逻辑
- [ ] Phase 5: 测试并完善

## 已做出的决定
- 使用 CSS 自定义属性作为主题
- 存储偏好在 localStorage
- 切换组件在 SettingsPage.tsx

## 状态
**当前处于 Phase 3** - 构建切换组件
```

**notes.md:**
```markdown
# 笔记: 暗黑模式实现

## 现有主题系统
- 位于: src/styles/theme.ts
- 使用: CSS 自定义属性
- 当前主题: 只有亮色

## 需要修改的文件
1. src/styles/theme.ts - 添加暗色主题颜色
2. src/components/SettingsPage.tsx - 添加切换
3. src/hooks/useTheme.ts - 创建新 hook
4. src/App.tsx - 用 ThemeProvider 包裹

## 颜色决定
- 暗色背景: #1a1a2e
- 暗色表面: #16213e
- 暗色文本: #eaeaea
```

**dark_mode_implementation.md:** (交付物)
```markdown
# 暗黑模式实现

## 变更内容

### 1. 添加了暗色主题颜色
File: src/styles/theme.ts
...

### 2. 创建了 useTheme hook
File: src/hooks/useTheme.ts
...
```

---

## 示例 4: 错误恢复模式 (Error Recovery Pattern)

当事情失败时，**不要**隐藏它：

### 之前 (错误做法)
```
Action: Read config.json
Error: File not found
Action: Read config.json  # 静默重试
Action: Read config.json  # 再次重试
```

### 之后 (正确做法)
```
Action: Read config.json
Error: File not found

# 更新 task_plan.md:
## 遇到的错误
- config.json 未找到 → 将创建默认配置

Action: Write config.json (默认配置)
Action: Read config.json
Success!
```

---

## 先读后决模式 (The Read-Before-Decide Pattern)

**在做出重大决定之前，始终阅读你的计划：**

```
[发生了许多工具调用...]
[上下文变得很长...]
[最初的目标可能被遗忘...]

→ Read task_plan.md          # 这将目标带回注意力中！
→ 现在做出决定                # 目标在上下文中是新鲜的
```

这就是为什么 Manus 可以处理 ~50 次工具调用而不迷失方向。计划文件充当了“目标刷新”机制。
