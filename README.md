# LifeOS Plugin for Claude Code

This repository contains skills, agents, and commands for LifeOS, designed to be used with Claude Code.

## Features

- **Daily Brief**: Generate personalized daily news briefs.
- **Daily Check-in**: Track your daily progress and reflections.
- **Weekly Check-in**: Analyze weekly metrics and trends.
- **Brain Dump Analysis**: Extract insights from your thoughts.
- **Newsletter Research**: Research and write newsletter sources.

## Installation

To use this plugin with Claude Code:

1. Clone this repository.
2. Run Claude Code with the `--plugin-dir` flag:
   ```bash
   claude --plugin-dir /path/to/lifeOS
   ```

## Directory Structure

- `commands/`: Slash commands invocable from Claude.
- `skills/`: Reusable skills and instructions.
- `agents/`: Specialized agent personas.
