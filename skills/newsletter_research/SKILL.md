---
name: Newsletter Research
description: Newsletter 创作助手：研究竞品 Newsletter 趋势，并为用户撰写自己的 Newsletter 内容草稿（用于发布给读者）。
allowed-tools: [bash, read_url_content, view_file, write_to_file]
---

# Newsletter 创作助手

## 工具权限与配置
**必须优先使用** `dev-browser` (位于 `skills/dev-browser/`) 来处理复杂的网页交互或获取动态内容。这可以复用用户本地浏览器（需安装扩展），从而访问需要登录的内容（如 Substack, Twitter）。
仅在非常简单或无需登录的情况下使用 `read_url_content`。

## 流程:

1. **来源发现**
   - 检查 `newsletter/sources/` 目录下的简报 URL
   - 如果未找到，询问用户竞争对手的简报 URL
   - 同时查找用户自己的简报 URL 以进行风格/声音分析

2. **内容获取**
   - **必须**使用 `dev-browser` 获取所有提供的简报 URL 的最新文章。
   - **启动服务**：如果尚未运行，先执行 `./skills/dev-browser/server.sh &`。
   - **读取内容**：使用 Dev Browser 脚本访问页面并提取关键内容、主题和写作风格。
   - **登录态**：如果连接了 Chrome 扩展，这将自动使用您的登录状态，确保能读取付费或订阅内容。
   - 提取关键内容、主题和写作风格

3. **研究阶段**
   - 调用 `content-researcher` Agent。
   - 对获取到的内容进行分析，寻找趋势和机会

4. **写作阶段**
   - 调用 `newsletter-writer` Agent。
   - 基于研究见解，撰写简报草稿

5. **输出组织**
   - 将研究报告保存至 `newsletter/research/YYYY-MM-DD-analysis.md`
   - 将草稿保存至 `newsletter/drafts/YYYY-MM-DD-draft.md`
   - 将指标保存至 `metrics/newsletter-metrics.md`

## 主要功能:

- 跨多来源的趋势分析
- 基于用户内容的风格匹配
- 完整的草稿，而不仅仅是大纲
- 价值优先，真实的内容
- 好奇心驱动的标题行
