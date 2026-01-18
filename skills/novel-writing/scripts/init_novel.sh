#!/bin/bash
# init_novel.sh - 初始化小说项目

set -e

NOVEL_TITLE="${1:-我的小说}"
NOVEL_TYPE="${2:-玄幻}"
TARGET_DIR="${3:-$(pwd)}"
DATE=$(date +%Y-%m-%d)

echo "📚 初始化小说项目: $NOVEL_TITLE"

# 创建目录结构
mkdir -p "$TARGET_DIR/chapters"
mkdir -p "$TARGET_DIR/research"
mkdir -p "$TARGET_DIR/feedback"
mkdir -p "$TARGET_DIR/references/books"
mkdir -p "$TARGET_DIR/references/techniques"
mkdir -p "$TARGET_DIR/references/exemplars"
mkdir -p "$TARGET_DIR/references/trending"

# 复制模板
SKILL_DIR="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}"
TEMPLATE_DIR="$SKILL_DIR/templates"

if [ -f "$TEMPLATE_DIR/novel_plan.md" ]; then
    sed -e "s/{{NOVEL_TITLE}}/$NOVEL_TITLE/g" \
        -e "s/{{NOVEL_TYPE}}/$NOVEL_TYPE/g" \
        -e "s/{{TARGET_WORDS}}/200000/g" \
        -e "s/{{DATE}}/$DATE/g" \
        "$TEMPLATE_DIR/novel_plan.md" > "$TARGET_DIR/novel_plan.md"
else
    echo "# 小说计划: $NOVEL_TITLE" > "$TARGET_DIR/novel_plan.md"
    echo "" >> "$TARGET_DIR/novel_plan.md"
    echo "类型: $NOVEL_TYPE" >> "$TARGET_DIR/novel_plan.md"
    echo "创建日期: $DATE" >> "$TARGET_DIR/novel_plan.md"
    echo "状态: planning" >> "$TARGET_DIR/novel_plan.md"
fi

if [ -f "$TEMPLATE_DIR/world_bible.md" ]; then
    sed -e "s/{{NOVEL_TITLE}}/$NOVEL_TITLE/g" \
        -e "s/{{WORLD_TYPE}}/$NOVEL_TYPE/g" \
        -e "s/{{ERA}}/待定/g" \
        -e "s/{{PROTAGONIST_NAME}}/主角/g" \
        "$TEMPLATE_DIR/world_bible.md" > "$TARGET_DIR/world_bible.md"
else
    echo "# 世界圣经: $NOVEL_TITLE" > "$TARGET_DIR/world_bible.md"
fi

if [ -f "$TEMPLATE_DIR/session_log.md" ]; then
    sed -e "s/{{DATE}}/$DATE/g" \
        "$TEMPLATE_DIR/session_log.md" > "$TARGET_DIR/session_log.md"
else
    echo "# 写作日志" > "$TARGET_DIR/session_log.md"
    echo "" >> "$TARGET_DIR/session_log.md"
    echo "## $DATE - 项目初始化" >> "$TARGET_DIR/session_log.md"
fi

# 创建 findings.md
if [ -f "$TEMPLATE_DIR/findings.md" ]; then
    cp "$TEMPLATE_DIR/findings.md" "$TARGET_DIR/findings.md"
else
    echo "# 创作发现" > "$TARGET_DIR/findings.md"
    echo "" >> "$TARGET_DIR/findings.md"
    echo "记录写作过程中的重要发现、决策和洞察。" >> "$TARGET_DIR/findings.md"
fi

echo "✅ 项目初始化完成!"
echo ""
echo "📁 目录结构:"
echo "  $TARGET_DIR/"
echo "  ├── novel_plan.md"
echo "  ├── world_bible.md"
echo "  ├── session_log.md"
echo "  ├── chapters/"
echo "  ├── research/"
echo "  ├── feedback/"
echo "  └── references/"
echo ""
echo "🚀 下一步: 运行 '/write-novel plan' 生成大纲"
