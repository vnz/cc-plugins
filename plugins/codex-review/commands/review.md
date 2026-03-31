---
description: Run codex code review on your changes
argument-hint: [type] [--base <branch>]
allowed-tools: Bash(codex:*, git:*, gh:*), Read, Grep, Glob
---

# Codex Code Review

Run an automated code review using the Codex CLI.

## Context

- Current directory: !`pwd`
- Git repo: !`git rev-parse --is-inside-work-tree 2>/dev/null && echo "Yes" || echo "No"`
- Branch: !`git branch --show-current 2>/dev/null || echo "detached HEAD"`
- Has changes: !`git status --porcelain 2>/dev/null | head -1 | grep -q . && echo "Yes" || echo "No"`

## Instructions

Review code based on: **$ARGUMENTS**

### Prerequisites Check

**Skip this check if you already verified codex earlier in this session.**

```bash
command -v codex >/dev/null 2>&1 && echo "codex found" || echo "codex not found"
```

**If not found**, tell user:
> Codex CLI is not installed. Install it:
>
> ```bash
> npm install -g @openai/codex
> ```
>
> Then restart your shell and try again.

### Detect Review Mode

Determine which mode to use from `$ARGUMENTS`:

1. If `--base <branch>` is specified, use: `codex review --base <branch>` (pass the ref as-is — the user may specify `origin/main`, `upstream/dev`, or a local branch)
2. If type is `committed`, use: `codex review` (no flags — reviews committed changes by default)
3. If type is `uncommitted`, use: `codex review --uncommitted`
4. If `--commit <SHA>` is specified, use: `codex review --commit <SHA>`
5. Default (no arguments): auto-detect:
   - Check for open PR → `codex review --base origin/<base>`
   - Otherwise → `codex review --uncommitted`

### Run Review

Run the detected command as a **background task** (`run_in_background: true`). Wait for it to complete.

### Present Results

Group findings by severity:

1. **P1 — Critical**: Security, bugs, data loss risks
2. **P2 — Important**: Error handling gaps, missing validation
3. **P3 — Minor**: Style, naming, minor simplifications

If no findings, report that the review is clean.

Offer to fix actionable findings if any are present.
