---
name: Newsletter Research
description: Newsletter 创作助手：研究竞品 Newsletter 趋势，并为用户撰写自己的 Newsletter 内容草稿（用于发布给读者）。
allowed-tools: [browser_subagent, read_url_content, view_file, write_to_file]
---

# Newsletter 创作助手

## 工具权限与配置
**允许并鼓励**使用 `browser_subagent` 及其所有能力（包括但不限于点击、输入、导航、滚动、截图等）来处理复杂的网页交互或获取动态内容。

## 流程:

1. **来源发现**
   - 检查 `life/newsletter/sources/` 目录下的简报 URL
   - 如果未找到，询问用户竞争对手的简报 URL
   - 同时查找用户自己的简报 URL 以进行风格/声音分析

2. **内容获取**
   - 优先使用 `browser_subagent` 或 `read_url_content` 获取所有提供的简报 URL 的最新文章
   - 对于需要登录、JavaScript 渲染或复杂交互的页面，**必须**使用 `browser_subagent`
   - 提取关键内容、主题和写作风格

3. **研究阶段**
   - 调用 `content-researcher` Agent。
   - 对获取到的内容进行分析，寻找趋势和机会

4. **写作阶段**
   - 调用 `newsletter-writer` Agent。
   - 基于研究见解，撰写简报草稿

5. **输出组织**
   - 将研究报告保存至 `life/newsletter/research/YYYY-MM-DD-analysis.md`
   - 将草稿保存至 `life/newsletter/drafts/YYYY-MM-DD-draft.md`
   - 将指标保存至 `life/metrics/newsletter-metrics.md`

## 主要功能:

- 跨多来源的趋势分析
- 基于用户内容的风格匹配
- 完整的草稿，而不仅仅是大纲
- 价值优先，真实的内容
- 好奇心驱动的标题行
