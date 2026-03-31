# codex-review

AI-powered code review plugin for Claude Code using the [Codex CLI](https://github.com/openai/codex). Provides a `/codex-review:review` command, a code-review skill for autonomous workflows, and a specialized review agent.

## Features

| Feature | Description |
|---------|-------------|
| **Auto-detection** | Automatically selects `--uncommitted`, `--base`, or `--commit` mode |
| **Proactive review** | Skill triggers review after code changes without being asked |
| **Fix-and-review loop** | Fixes findings and re-reviews until clean (max 4 cycles) |
| **Anti-loop safety** | Three independent guards prevent runaway loops |
| **Review agent** | Specialized subagent for thorough, autonomous code analysis |
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

### Command

```bash
# Auto-detect mode (most common)
/codex-review:review

# Review uncommitted changes only
/codex-review:review uncommitted

# Review against a specific branch
/codex-review:review --base main

# Review a specific commit
/codex-review:review --commit abc1234
```

### Mode Detection

The command automatically determines the right review strategy:

1. If `--base <branch>` is passed, review the diff against that branch
2. If the current branch has an open PR, review the full PR diff against its base
3. Otherwise, review all uncommitted changes

### Skill (Autonomous)

The code-review skill triggers automatically when:

- You ask Claude to review code
- Claude finishes implementing a feature (proactive review)
- You ask about code quality, bugs, or security

### Agent

The code-reviewer agent can be used as a subagent for thorough, focused review:

```
Use the code-reviewer agent to review these changes
```

## How the Fix Loop Works

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

## Plugin Structure

```
plugins/codex-review/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── review.md              # /codex-review:review command
├── skills/
│   └── code-review/
│       └── SKILL.md           # When/how to review, autonomous workflow
├── agents/
│   └── code-reviewer.md       # Specialized review subagent
└── README.md
```

## Troubleshooting

### Command not visible
Run `/help` and look for `codex-review:review`. If missing, reinstall the plugin and restart Claude Code.

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
