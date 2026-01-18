#!/usr/bin/env python3
"""
Cliche Detector Script
Scans text files for overused phrases and potential quality issues.
"""

import sys
import re
from pathlib import Path

# Cliche patterns
PATTERNS = {
    "Action": [
        r"一道寒光闪过",
        r"身形一闪",
        r"化作一道残影",
        r"如同鬼魅一般",
        r"快若闪电",
        r"虎躯一震",
    ],
    "Expression": [
        r"眼中精光一闪",
        r"嘴角微微上扬",
        r"眉头微蹙",
        r"脸色大变",
        r"邪魅一笑",
        r"倒吸一口凉气",
    ],
    "Thought": [r"心中暗道", r"心中一凛", r"不仅仅是"],
    "Description": [r"金碧辉煌", r"一望无际", r"美轮美奂"],
}


def scan_file(file_path):
    print(f"🔍 正在扫描: {file_path}")
    path = Path(file_path)
    if not path.exists():
        print("❌ 文件不存在")
        return

    content = path.read_text(encoding="utf-8")
    found_issues = []

    lines = content.split("\n")
    for i, line in enumerate(lines):
        line_num = i + 1
        for category, regexes in PATTERNS.items():
            for pattern in regexes:
                matches = re.finditer(pattern, line)
                for match in matches:
                    found_issues.append(
                        {
                            "line": line_num,
                            "category": category,
                            "text": match.group(),
                            "context": line.strip()[:50] + "...",
                        }
                    )

    if found_issues:
        print(f"⚠️ 发现 {len(found_issues)} 个潜在陈词滥调:\n")
        print(f"{'行号':<6} | {'类型':<12} | {'原文':<15} | {'上下文'}")
        print("-" * 60)
        for issue in found_issues:
            print(
                f"{issue['line']:<6} | {issue['category']:<12} | {issue['text']:<15} | {issue['context']}"
            )
    else:
        print("✅ 未发现明显陈词滥调。")


def main():
    if len(sys.argv) < 2:
        print("Usage: cliche_check.py <file_path>")
        sys.exit(1)

    for file_path in sys.argv[1:]:
        scan_file(file_path)
        print("-" * 40)


if __name__ == "__main__":
    main()
