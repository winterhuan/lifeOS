#!/bin/bash
# check-novel-status.sh - 检查小说项目状态

set -e

NOVEL_DIR="${1:-.}"
PLAN_FILE="$NOVEL_DIR/novel_plan.md"

echo "📚 小说项目状态检查"
echo "===================="

# 检查核心文件
if [ -f "$PLAN_FILE" ]; then
    echo "✅ novel_plan.md 存在"
    
    # 提取状态
    STATUS=$(grep -E "^状态:" "$PLAN_FILE" 2>/dev/null | head -1 | cut -d':' -f2 | tr -d ' ' || echo "unknown")
    echo "📊 当前状态: $STATUS"
    
    # 统计章节
    if [ -d "$NOVEL_DIR/chapters" ]; then
        CHAPTER_COUNT=$(ls -1 "$NOVEL_DIR/chapters"/*.md 2>/dev/null | wc -l | tr -d ' ')
        echo "📖 已完成章节: $CHAPTER_COUNT"
    else
        echo "📖 已完成章节: 0"
    fi
    
    # 检查待完成章节
    PENDING=$(grep -E "^\s*-\s*\[\s*\]" "$PLAN_FILE" 2>/dev/null | wc -l | tr -d ' ')
    IN_PROGRESS=$(grep -E "^\s*-\s*\[/\]" "$PLAN_FILE" 2>/dev/null | wc -l | tr -d ' ')
    COMPLETED=$(grep -E "^\s*-\s*\[x\]" "$PLAN_FILE" 2>/dev/null | wc -l | tr -d ' ')
    
    echo ""
    echo "📋 任务统计:"
    echo "   待完成: $PENDING"
    echo "   进行中: $IN_PROGRESS"
    echo "   已完成: $COMPLETED"
    
else
    echo "❌ novel_plan.md 不存在"
    echo "💡 请运行: /write-novel init \"书名\" --type 类型"
    exit 1
fi

# 检查其他文件
echo ""
echo "📁 文件检查:"

if [ -f "$NOVEL_DIR/world_bible.md" ]; then
    echo "   ✅ world_bible.md"
else
    echo "   ⚠️ world_bible.md 缺失"
fi

if [ -f "$NOVEL_DIR/session_log.md" ]; then
    echo "   ✅ session_log.md"
else
    echo "   ⚠️ session_log.md 缺失"
fi

if [ -f "$NOVEL_DIR/findings.md" ]; then
    echo "   ✅ findings.md"
else
    echo "   ℹ️ findings.md 可选（未创建）"
fi

# 检查一致性问题
echo ""
echo "🔍 一致性检查:"

if [ -f "$NOVEL_DIR/world_bible.md" ]; then
    # 检查是否有死亡角色仍在活动
    DEAD_CHARS=$(grep -i "死亡\|已故\|牺牲" "$NOVEL_DIR/world_bible.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$DEAD_CHARS" -gt 0 ]; then
        echo "   ⚠️ 发现 $DEAD_CHARS 个已标记死亡的角色，请确保后续章节未使用"
    else
        echo "   ✅ 无死亡角色标记"
    fi
fi

echo ""
echo "===================="
echo "检查完成"
