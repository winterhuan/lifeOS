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

## 流程:

1.  **准备与获取 (Preparation)**
    - **读取上下文**：读取 `CLAUDE.md` 或用户提供的文件链接，了解其写作声音 (My Voice) 和竞争对手列表。
    - **获取内容**：
        - 询问或读取 Newsletter URL / 竞争对手链接。
        - 使用 `dev-browser` 获取这些来源的最新帖子/文章。
        - *提示：优先关注最近 1-2 周的内容以寻找趋势。*

2.  **趋势研究 (Research)**
    - 调用 `content-researcher` Agent。
    - **任务**：
        - 分析竞争对手 Newsletter 的热门话题。
        - 识别内容缺口和机会。
        - 寻找具有时效性的切入点。
    - **输出**：生成趋势报告和见解，传递给下一步。

3.  **草稿撰写 (Writing)**
    - 调用 `newsletter-writer` Agent。
    - **输入**：来自 `content-researcher` 的见解 + 用户的声音样本 (`CLAUDE.md` 等)。
    - **任务**：
        - 撰写 3 个引起好奇心的标题行选项。
        - 创建 500-800 字的完整草稿。
        - **关键要求**：
            - 匹配用户的写作声音。
            - 包含从研究中获得的实际要点 (Practical Takeaways)。
            - 添加自然、温和的 CTA (Soft CTA)。
    - **风格**：价值优先，听起来真实，拒绝 AI生成感。

4.  **保存输出 (Saving)**
    - 将完整草稿保存至：`newsletter/drafts/YYYY-MM-DD-draft.md`
    - 将研究报告保存至：`newsletter/research/YYYY-MM-DD-research.md`

## 主要功能:
- **全自动流程**：从阅读竞品到生成草稿。
- **声音克隆**：学习用户过往内容，模仿其独特的写作风格。
- **好奇心标题**：生成高打开率的标题行。
- **价值导向**：确保内容提供实际价值，而非空泛的废话。
