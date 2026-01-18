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

1.  **理解内容上下文 (Context First)**
    - 读取 `CLAUDE.md` 以了解用户的内容风格。
    - 分析现有的内容链接和竞争对手链接。
    - 确定利基市场 (Niche) 和目标受众。

2.  **确定具体研究目标**
    - 询问用户要研究的具体目标：
        - 竞争对手的 Newsletter、YouTube 频道或 Twitter 账号。
        - 具体的话题或趋势。
        - 分析的时间段。
    - **等待用户回复**。

3.  **执行综合研究**
    - 使用 `dev-browser` 深度访问目标内容。
    - 分析竞争对手的内容主题和风格。
    - 识别热门话题和模式。
    - 提取关键见解和机会。

4.  **生成个性化见解**
    - 调用 `research-analyst` Agent。
    - 将发现结果与用户的风格和受众进行匹配。
    - 建议内容创意和切入点。
    - 提供可操作的建议。

5.  **输出组织**
    - 将研究报告保存至 `newsletter/research/YYYY-MM-DD-research.md`

## 主要功能:
- 跨多来源的趋势分析
- 竞争对手深度解构
- 个性化内容推荐
- 可操作的行动计划
