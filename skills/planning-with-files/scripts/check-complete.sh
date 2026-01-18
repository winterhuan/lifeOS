#!/bin/bash
# 检查 task_plan.md 中的所有阶段是否已完成
# 如果完成退出 0，未完成退出 1
# 被 Stop hook 用于验证任务完成情况

PLAN_FILE="${1:-task_plan.md}"

if [ ! -f "$PLAN_FILE" ]; then
    echo "错误: 未找到 $PLAN_FILE"
    echo "没有任务计划无法验证完成情况。"
    exit 1
fi

echo "=== 任务完成检查 ==="
echo ""

# 按状态统计阶段
TOTAL=$(grep -c "### Phase" "$PLAN_FILE" || true)
COMPLETE=$(grep -cF "**Status:** complete" "$PLAN_FILE" || true)
IN_PROGRESS=$(grep -cF "**Status:** in_progress" "$PLAN_FILE" || true)
PENDING=$(grep -cF "**Status:** pending" "$PLAN_FILE" || true)

# 默认值为 0
: "${TOTAL:=0}"
: "${COMPLETE:=0}"
: "${IN_PROGRESS:=0}"
: "${PENDING:=0}"

echo "总阶段数:   $TOTAL"
echo "已完成:     $COMPLETE"
echo "进行中:     $IN_PROGRESS"
echo "待处理:     $PENDING"
echo ""

# 检查完成情况
if [ "$COMPLETE" -eq "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
    echo "所有阶段已完成"
    exit 0
else
    echo "任务未完成"
    echo ""
    echo "在所有阶段完成之前请不要停止。"
    exit 1
fi
