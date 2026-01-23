---
name: skill-creator
description: 指导如何创建高效的 Skill。当用户想要创建一个新的 Skill（或更新现有 Skill）以扩展 Claude 的功能（包括专业知识、工作流或工具集成）时，应使用此 Skill。
license: Complete terms in LICENSE.txt
---

# 技能创建助手 (Skill Creator)

本 Skill 提供创建高效 Skill 的指导。

## 关于 Skills

Skills 是模块化的、独立的包，通过提供专业知识、工作流和工具来扩展 Claude 的能力。可以将它们视为特定领域或任务的“入职指南”——它们将 Claude 从一个通用 Agent 转变为一个拥有模型无法完全具备的过程性知识的专业 Agent。

### Skills 提供什么

1. **专业工作流** - 针对特定领域的多步骤程序
2. **工具集成** - 处理特定文件格式或 API 的指令
3. **领域专长** - 公司特定的知识、模式、业务逻辑
4. **捆绑资源** - 用于复杂和重复任务的脚本、参考资料和资产

## 核心原则 (Core Principles)

### 简洁是关键 (Concise is Key)

上下文窗口是一种公共资源。Skills 与 Claude 需要的其他所有内容共享上下文窗口：系统提示词、对话历史、其他 Skills 的元数据以及实际的用户请求。

**默认假设：Claude 已经非常聪明。** 只添加 Claude 尚未拥有的上下文。质疑每一条信息：“Claude 真的需要这个解释吗？”以及“这一段值得消耗这些 token 吗？”

倾向于使用简洁的例子，而不是冗长的解释。

### 设定适当的自由度 (Set Appropriate Degrees of Freedom)

将特指性水平与任务的脆弱性和可变性相匹配：

**高自由度 (基于文本的指令)**：当多种方法都有效、决策取决于上下文或由启发式方法指导时使用。

**中等自由度 (伪代码或带参数的脚本)**：当存在首选模式、允许一定变化或配置影响行为时使用。

**低自由度 (特定脚本，少量参数)**：当操作脆弱且容易出错、一致性至关重要或必须遵循特定顺序时使用。

把 Claude 想象成在探索一条路径：悬崖边的狭窄桥梁需要特定的护栏（低自由度），而开阔的田野允许许多路线（高自由度）。

### Skill 的结构 (Anatomy of a Skill)

每个 Skill 由一个必需的 `SKILL.md` 文件和可选的捆绑资源组成：

```
skill-name/
├── SKILL.md (必需)
│   ├── YAML frontmatter 元数据 (必需)
│   │   ├── name: (必需)
│   │   └── description: (必需)
│   └── Markdown 指令 (必需)
└── Bundled Resources (可选)
    ├── scripts/          - 可执行代码 (Python/Bash/etc.)
    ├── references/       - 旨在按需加载到上下文中的文档
    └── assets/           - 用于输出的文件 (模板、图标、字体等)
```

#### SKILL.md (必需)

每个 `SKILL.md` 包含：

- **Frontmatter** (YAML): 包含 `name` 和 `description` 字段。这是 Claude 读取以确定何时使用 Skill 的**唯一**字段，因此清晰全面地描述 Skill 是什么以及何时使用它非常重要。
- **Body** (Markdown): 使用 Skill 的指令和指南。仅在 Skill 触发**后**加载（如果有的话）。

#### 捆绑资源 (可选)

##### 脚本 (`scripts/`)

用于需要确定性可靠性或被重复重写的任务的可执行代码 (Python/Bash/etc.)。

- **何时包含**: 当相同的代码被重复重写或需要确定性可靠性时
- **示例**: 用于 PDF 旋转任务的 `scripts/rotate_pdf.py`
- **好处**: Token 高效、确定性、无需加载到上下文即可执行
- **注意**: 脚本可能仍需被 Claude 读取以进行修补或特定环境的调整

##### 参考资料 (`references/`)

旨在按需加载到上下文中以通知 Claude 的过程和思考的文档和参考材料。

- **何时包含**: Claude 在工作时应该参考的文档
- **示例**: 用于财务模式的 `references/finance.md`，用于公司 NDA 模板的 `references/mnda.md`，用于公司政策的 `references/policies.md`，用于 API 规范的 `references/api_docs.md`
- **用例**: 数据库模式、API 文档、领域知识、公司政策、详细工作流指南
- **好处**: 保持 `SKILL.md` 精简，仅在 Claude 确定需要时加载
- **最佳实践**: 如果文件很大 (>10k words)，在 `SKILL.md` 中包含 grep 搜索模式
- **避免重复**: 信息应存在于 `SKILL.md` 或参考文件中，而不是两者都在。除非信息真的是 Skill 的核心，否则倾向于将详细信息放在参考文件中——这保持了 `SKILL.md` 的精简，同时使信息可被发现而不占用上下文窗口。在 `SKILL.md` 中只保留基本的程序指令和工作流指导；将详细的参考材料、模式和示例移动到参考文件中。

##### 资产 (`assets/`)

不打算加载到上下文中，而是用于 Claude 生成的输出中的文件。

- **何时包含**: 当 Skill 需要在最终输出中使用的文件时
- **示例**: 用于品牌资产的 `assets/logo.png`，用于 PowerPoint 模板的 `assets/slides.pptx`，用于 HTML/React 样板的 `assets/frontend-template/`，用于排版的 `assets/font.ttf`
- **用例**: 模板、图像、图标、样板代码、字体、被复制或修改的示例文档
- **好处**: 将输出资源与文档分离，使 Claude 能够使用文件而无需将其加载到上下文中

#### 不要在 Skill 中包含什么

一个 Skill 应仅包含直接支持其功能的基本文件。**不要**创建无关的文档或辅助文件，包括：

- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- 等等。

Skill 应仅包含 AI Agent 完成手头工作所需的信息。它不应包含关于创建过程、设置和测试程序、面向用户的文档等的辅助上下文。创建额外的文档文件只会增加混乱和干扰。

### 渐进式披露设计原则 (Progressive Disclosure Design Principle)

Skills 使用三级加载系统来高效管理上下文：

1. **元数据 (name + description)** - 始终在上下文中 (~100 words)
2. **SKILL.md 正文** - 当 Skill 触发时 (<5k words)
3. **捆绑资源** - Claude 按需加载 (无限，因为脚本无需读入上下文窗口即可执行)

#### 渐进式披露模式

保持 `SKILL.md` 正文简练，控制在 500 行以内，以最小化上下文膨胀。当接近此限制时，将内容拆分到单独的文件中。当拆分内容到其他文件时，非常重要的是在 `SKILL.md` 中引用它们并清楚地描述何时读取它们，以确保 Skill 的阅读者（Claude）知道它们的存在以及何时使用它们。

**关键原则：** 当一个 Skill 支持多种变体、框架或选项时，在 `SKILL.md` 中只保留核心工作流和选择指南。将特定于变体的细节（模式、示例、配置）移动到单独的参考文件中。

**模式 1：带参考的高级指南**

```markdown
# PDF 处理

## 快速开始

使用 pdfplumber 提取文本：
[代码示例]

## 高级功能

- **表单填充**: 查看 [FORMS.md](FORMS.md) 获取完整指南
- **API 参考**: 查看 [REFERENCE.md](REFERENCE.md) 获取所有方法
- **示例**: 查看 [EXAMPLES.md](EXAMPLES.md) 获取常见模式
```

Claude 仅在需要时加载 `FORMS.md`, `REFERENCE.md`, 或 `EXAMPLES.md`。

**模式 2：特定领域的组织**

对于具有多个领域的 Skills，按领域组织内容以避免加载不相关的上下文：

```
bigquery-skill/
├── SKILL.md (概览和导航)
└── reference/
    ├── finance.md (收入, 账单指标)
    ├── sales.md (机会, 管道)
    ├── product.md (API 用法, 功能)
    └── marketing.md (活动, 归因)
```

当用户询问销售指标时，Claude 只读取 `sales.md`。

同样，对于支持多种框架或变体的 Skills，按变体组织：

```
cloud-deploy/
├── SKILL.md (工作流 + 提供商选择)
└── references/
    ├── aws.md (AWS 部署模式)
    ├── gcp.md (GCP 部署模式)
    └── azure.md (Azure 部署模式)
```

当用户选择 AWS 时，Claude 只读取 `aws.md`。

**模式 3：条件性细节**

显示基本内容，链接到高级内容：

```markdown
# DOCX 处理

## 创建文档

使用 docx-js 创建新文档。查看 [DOCX-JS.md](DOCX-JS.md)。

## 编辑文档

对于简单编辑，直接修改 XML。

**对于修订 (Tracked Changes)**: 查看 [REDLINING.md](REDLINING.md)
**对于 OOXML 细节**: 查看 [OOXML.md](OOXML.md)
```

Claude 仅在用户需要这些功能时读取 `REDLINING.md` 或 `OOXML.md`。

**重要准则：**

- **避免深层嵌套引用** - 保持引用距离 `SKILL.md` 只有一层深度。所有参考文件应直接从 `SKILL.md` 链接。
- **结构化较长的参考文件** - 对于超过 100 行的文件，在顶部包含目录，以便 Claude 在预览时能看到完整范围。

## Skill 创建流程

Skill 创建涉及以下步骤：

1. 通过具体示例理解 Skill
2. 规划可重用的 Skill 内容 (脚本, 参考资料, 资产)
3. 初始化 Skill (运行 `init_skill.py`)
4. 编辑 Skill (实现资源并编写 `SKILL.md`)
5. 打包 Skill (运行 `package_skill.py`)
6. 基于实际使用进行迭代

按顺序遵循这些步骤，仅在有明确理由不适用时跳过。

### 步骤 1：通过具体示例理解 Skill

仅当 Skill 的使用模式已经非常清楚时才跳过此步骤。即使是在处理现有 Skill 时，它仍然很有价值。

要创建一个有效的 Skill，需要清楚地理解 Skill 将被如何使用的具体示例。这种理解可以来自直接的用户示例，也可以来自经用户反馈验证的生成示例。

例如，在构建一个 `image-editor` Skill 时，相关问题包括：

- "这个 image-editor Skill 应该支持什么功能？编辑、旋转，还有别的吗？"
- "你能给出一些这个 Skill 会被如何使用的例子吗？"
- "我可以想象用户会要求像'去除这张图片中的红眼'或'旋转这张图片'之类的事情。你还能想象这个 Skill 还有其他使用方式吗？"
- "用户说什么应该触发这个 Skill？"

为避免让用户感到不知所措，避免在一条消息中问太多问题。从最重要的问题开始，并根据需要进行跟进以获得更好的效果。

当对 Skill 应该支持的功能有清晰的认识时，结束此步骤。

### 步骤 2：规划可重用的 Skill 内容

要将具体示例转化为有效的 Skill，通过以下方式分析每个示例：

1. 考虑如何从头开始执行该示例
2. 确定在重复执行这些工作流时，哪些脚本、参考资料和资产会有所帮助

示例：在构建 `pdf-editor` Skill 以处理像“帮我旋转这个 PDF”这样的查询时，分析显示：

1. 旋转 PDF 每次都需要重写相同的代码
2. 一个 `scripts/rotate_pdf.py` 脚本存储在 Skill 中会很有帮助

示例：在设计 `frontend-webapp-builder` Skill 以处理像“给我做一个待办事项应用”或“给我做一个仪表板来跟踪我的步数”这样的查询时，分析显示：

1. 编写前端 Web 应用每次都需要相同的样板 HTML/React
2. 一个包含样板 HTML/React 项目文件的 `assets/hello-world/` 模板存储在 Skill 中会很有帮助

示例：在构建 `big-query` Skill 以处理像“今天有多少用户登录？”这样的查询时，分析显示：

1. 查询 BigQuery 每次都需要重新发现表结构及关系
2. 一个记录表结构的 `references/schema.md` 文件存储在 Skill 中会很有帮助

要确立 Skill 的内容，分析每个具体示例以创建一个要包含的可重用资源的列表：脚本、参考资料和资产。

### 步骤 3：初始化 Skill

此时，是时候实际创建 Skill 了。

仅当正在开发的 Skill 已经存在，且需要迭代或打包时，跳过此步骤。在这种情况下，继续下一步。

当从头开始创建一个新 Skill 时，始终运行 `init_skill.py` 脚本。该脚本方便地生成一个新的模板 Skill 目录，自动包含 Skill 所需的一切，使 Skill 创建过程更加高效和可靠。

用法：

```bash
python3 skills/skill-creator/scripts/init_skill.py <skill-name> --path <output-directory>
```

该脚本会：

- 在指定路径创建 Skill 目录
- 生成带有正确 Frontmatter 和 TODO 占位符的 `SKILL.md` 模板
- 创建示例资源目录：`scripts/`，`references/`，和 `assets/`
- 在每个目录中添加可自定义或删除的示例文件

初始化后，根据需要自定义或删除生成的 `SKILL.md` 和示例文件。

### 步骤 4：编辑 Skill

当编辑（新生成的或现有的）Skill 时，请记住该 Skill 是为**另一个 Claude 实例**使用而创建的。包含对 Claude 有益且非显而易见的信息。考虑哪些过程性知识、领域特定细节或可重用资产将帮助另一个 Claude 实例更有效地执行这些任务。

#### 学习经过验证的设计模式

根据你的 Skill 需求参考这些有用的指南：

- **多步骤流程**: 查看 [references/workflows.md](references/workflows.md) 了解顺序工作流和条件逻辑
- **特定输出格式或质量标准**: 查看 [references/output-patterns.md](references/output-patterns.md) 了解模板和示例模式

这些文件包含了有效 Skill 设计的既定最佳实践。

#### 从可重用的 Skill 内容开始

开始实现时，从上面确定的可重用资源开始：`scripts/`，`references/`，和 `assets/` 文件。注意，此步骤可能需要用户输入。例如，当实现 `brand-guidelines` Skill 时，用户可能需要提供品牌资产或模板以存储在 `assets/` 中，或提供文档以存储在 `references/` 中。

添加的脚本必须通过实际运行它们来测试，以确保没有错误并且输出符合预期。如果有很多类似的脚本，只需要测试一个代表性的样本以确保信心，即它们都能工作，同时平衡完成时间。

任何 Skill 不需要个示例文件和目录都应被删除。初始化脚本在 `scripts/`，`references/`，和 `assets/` 中创建示例文件以演示结构，但大多数 Skills 不会需要所有这些。

#### 更新 SKILL.md

**写作指南：** 始终使用祈使句/不定式形式 (Imperative/Infinitive form)。

##### Frontmatter

编写带有 `name` 和 `description` 的 YAML frontmatter：

- `name`: Skill 名称
- `description`: 这是你的 Skill 的主要触发机制，帮助 Claude 理解何时使用该 Skill。
  - 包括 Skill 做什么以及何时使用它的具体触发器/上下文。
  - 在这里包含所有“何时使用”的信息 - **而不是在正文中**。正文仅在触发后加载，因此正文中的“何时使用此 Skill”部分对 Claude 没有帮助。
  - `docx` Skill 的示例描述：“全面的文档创建、编辑和分析，支持修订、评论、格式保留和文本提取。当 Claude 需要处理专业文档 (.docx 文件) 时使用，用于：(1) 创建新文档，(2) 修改或编辑内容，(3) 处理修订，(4) 添加评论，或任何其他文档任务”

不要在 YAML frontmatter 中包含任何其他字段。

##### Body

编写使用该 Skill 及其捆绑资源的指令。

### 步骤 5：打包 Skill

一旦 Skill 开发完成，必须将其打包成可分发的 `.skill` 文件（如果需要分享）。虽然在本地你可以直接使用文件夹，但打包过程会自动验证 Skill 以确保它符合所有要求：

```bash
python3 skills/skill-creator/scripts/package_skill.py <path/to/skill-folder>
```

可选的输出目录指定：

```bash
python3 skills/skill-creator/scripts/package_skill.py <path/to/skill-folder> ./dist
```

打包脚本将：

1. **自动验证** Skill，检查：

   - YAML frontmatter 格式和必需字段
   - Skill 命名约定和目录结构
   - 描述的完整性和质量
   - 文件组织和资源引用

2. **打包** Skill（如果验证通过），创建一个以 Skill 命名的 `.skill` 文件（例如 `my-skill.skill`），其中包含所有文件并保持正确的分发目录结构。`.skill` 文件是一个扩展名为 `.skill` 的 zip 文件。

如果验证失败，脚本将报告错误并退出，而不会创建包。修复任何验证错误并再次运行打包命令。

### 步骤 6：迭代

测试 Skill 后，用户可能会要求改进。这通常发生在刚使用完 Skill 后，拥有 Skill 表现如何的新鲜上下文。

**迭代工作流：**

1. 在实际任务上使用 Skill
2. 注意挣扎或低效之处
3. 确定 `SKILL.md` 或捆绑资源应如何更新
4. 实现更改并再次测试
