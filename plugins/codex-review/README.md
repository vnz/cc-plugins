# codex-review

Automated code review plugin for Claude Code using the OpenAI Codex CLI. Provides a `/codex-review` slash command with automatic mode detection and an iterative fix-and-review loop.

## Features

| Feature | Description |
|---------|-------------|
| **Auto-detection** | Automatically selects `--uncommitted`, `--base`, or `--commit` mode |
| **Fix-and-review loop** | Fixes findings and re-reviews until clean |
| **Anti-loop safety** | Three independent guards prevent runaway loops |
| **Background execution** | Reviews run as background tasks |
| **Silent fallback** | Does nothing if codex is not installed |

## Prerequisites

- [codex](https://github.com/openai/codex) CLI in your PATH
- [gh](https://cli.github.com/) CLI (for PR base branch detection)

## Installation

```bash
# Add marketplace
/plugin marketplace add vnz/cc-plugins

# Install plugin
/plugin install codex-review@cc-plugins-vnz
```

## Usage

```bash
# Auto-detect mode (most common)
/codex-review

# Review a specific commit
/codex-review --commit abc1234
```

### Mode Detection

The command automatically determines the right review strategy:

1. If `--commit <SHA>` is passed, review that commit
2. If the current branch has an open PR, review the full PR diff against its base
3. Otherwise, review all uncommitted changes

## How the Loop Works

```
┌─────────────────────┐
│   Run codex review   │
└──────────┬──────────┘
           │
     ┌─────▼─────┐
     │ Findings?  │──── No ──→ Report clean ✓
     └─────┬──────┘
           │ Yes
     ┌─────▼──────────┐
     │ Fix actionable  │
     │ Skip false pos.  │
     └─────┬──────────┘
           │
     ┌─────▼──────────┐
     │ Stop guards:    │
     │ • cycle >= 4    │──── Any met ──→ Report & stop
     │ • no progress   │
     │ • no changes    │
     └─────┬──────────┘
           │ None met
           └──→ Re-run review ↑
```

## Anti-Loop Safety

| Guard | Condition | Rationale |
|-------|-----------|-----------|
| **Max cycles** | Cycle count reaches 4 | Hard cap prevents runaway loops |
| **No progress** | All remaining findings were dismissed or already fixed | No new actionable findings to address |
| **No changes** | `git diff --stat` empty after fixes | All findings were dismissed or already fixed |

Any **one** of these triggers a stop.

## Troubleshooting

### Command not visible
Run `/help` and look for `codex-review`. If missing, reinstall the plugin and restart Claude Code.

### Codex not found
The command silently exits if `codex` is not in your PATH. Install it:
```bash
npm install -g @openai/codex
```

### No PR detected
If you expect `--base` mode but get `--uncommitted`, ensure:
1. You've pushed the branch to the remote
2. A PR is open (create one with `gh pr create`)
3. The `gh` CLI is authenticated

### Loop stops early
Check which guard triggered in the final report. Common causes:
- **No changes**: All findings were false positives — this is expected
- **No progress**: Fixes introduced new issues — review the changes manually
