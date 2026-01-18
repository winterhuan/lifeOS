#!/usr/bin/env python3
import json
import argparse
import datetime
from pathlib import Path

REGISTRY_FILE = Path.home() / "novels" / ".novel_registry.json"
NOVELS_DIR = Path.home() / "novels"


def load_registry():
    if not REGISTRY_FILE.exists():
        return {}
    try:
        with open(REGISTRY_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, OSError):
        return {}


def save_registry(registry):
    REGISTRY_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(REGISTRY_FILE, "w", encoding="utf-8") as f:
        json.dump(registry, f, indent=2, ensure_ascii=False)


def list_novels(args):
    registry = load_registry()
    if not registry:
        print("📭 小说库为空。请使用 init 初始化第一个项目。")
        return

    print(f"📚 小说列表 ({len(registry)}):")
    for name, info in registry.items():
        active_mark = "*" if info.get("active") else " "
        print(f"{active_mark} [{info['type']}] {name} - 最后更新: {info['updated_at']}")
        print(f"    路径: {info['path']}")


def switch_novel(args):
    registry = load_registry()
    name = args.name
    if name not in registry:
        print(f"❌ 找不到小说: {name}")
        return

    # Deactivate all
    for n in registry:
        registry[n]["active"] = False

    # Activate target
    registry[name]["active"] = True
    save_registry(registry)
    print(f"✅ 已切换到小说: {name}")
    print(f"📂 工作目录: {registry[name]['path']}")


def init_novel(args):
    name = args.name
    novel_type = args.type

    # Target directory
    target_dir = NOVELS_DIR / name
    if target_dir.exists():
        print(f"⚠️ 目录已存在: {target_dir}")
        # Not exiting, might be re-registering

    # Call the existing shell script for scaffolding if it exists, or replicate logic
    # Replicating logic here for robustness and independence
    target_dir.mkdir(parents=True, exist_ok=True)
    (target_dir / "chapters").mkdir(exist_ok=True)
    (target_dir / "research").mkdir(exist_ok=True)
    (target_dir / "feedback").mkdir(exist_ok=True)
    (target_dir / "references/books").mkdir(parents=True, exist_ok=True)
    (target_dir / "references/techniques").mkdir(parents=True, exist_ok=True)
    (target_dir / "references/exemplars").mkdir(parents=True, exist_ok=True)
    (target_dir / "references/trending").mkdir(parents=True, exist_ok=True)

    # Note: We assume templates are in specific location, but simple content creation is safer
    date_str = datetime.date.today().isoformat()

    # novel_plan.md
    with open(target_dir / "novel_plan.md", "w") as f:
        f.write(f"# 小说计划: {name}\n\n")
        f.write(f"类型: {novel_type}\n")
        f.write(f"创建日期: {date_str}\n")
        f.write("状态: planning\n\n")
        f.write("## 核心设定\n> [用一句话描述整个故事]\n\n")
        f.write("## 大纲\n### 第一幕\n- [ ] 第1章: [标题] — 状态: pending\n")

    # session_log.md
    with open(target_dir / "session_log.md", "w") as f:
        f.write(f"# 写作日志\n\n## {date_str} - 项目初始化\n")

    # world_bible.md
    with open(target_dir / "world_bible.md", "w") as f:
        f.write(f"# 世界圣经: {name}\n类型: {novel_type}\n\n## 主要角色\n")

    # Update Registry
    registry = load_registry()
    # Deactivate others
    for n in registry:
        registry[n]["active"] = False

    registry[name] = {
        "path": str(target_dir),
        "type": novel_type,
        "created_at": date_str,
        "updated_at": date_str,
        "active": True,
    }
    save_registry(registry)

    print(f"✅ 小说 '{name}' 初始化完成！")
    print(f"📂 位置: {target_dir}")


def main():
    parser = argparse.ArgumentParser(description="小说项目管理器")
    subparsers = parser.add_subparsers(dest="command", required=True)

    # Init
    p_init = subparsers.add_parser("init", help="初始化新小说")
    p_init.add_argument("name", help="小说书名")
    p_init.add_argument("--type", default="玄幻", help="小说类型")
    p_init.set_defaults(func=init_novel)

    # List
    p_list = subparsers.add_parser("list", help="列出所有小说")
    p_list.set_defaults(func=list_novels)

    # Switch
    p_switch = subparsers.add_parser("switch", help="切换活跃小说")
    p_switch.add_argument("name", help="小说书名")
    p_switch.set_defaults(func=switch_novel)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
