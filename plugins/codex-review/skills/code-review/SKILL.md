---
name: code-review
description: Reviews code changes using Codex CLI. Use when user asks for code review, wants to check code quality, find bugs, or when you should proactively review code you just wrote. Activates on "review my code", "check for bugs", "code review", "run codex", or after implementing features.
---

# Codex Code Review

AI-powered code review using the Codex CLI. Enables autonomous development workflows where you implement features, review code, and fix issues without manual intervention.

## When to Use

When user asks to:

- Review code changes / Review my code / Review this
- Check code quality / Find bugs / Find issues
- Security review / Security check
- Get feedback on their code
- Run codex / Use codex review
- Implement a feature and review it
- Fix issues found in review

**Proactive review**: After implementing code changes, run `/codex-review:review` without waiting for the user to ask. Skip review only for trivial changes that don't touch code (docs-only, config-only, version bumps).

**Only review your own code**: Only use codex review for code you authored in the current session. When reviewing someone else's PR or code, review it directly — read the diff yourself and provide feedback without codex.

## How to Review

### 1. Check Prerequisites

```bash
command -v codex >/dev/null 2>&1 && echo "codex found" || echo "codex not found"
```

**If not found**, tell user:

```
Please install Codex CLI first:
npm install -g @openai/codex
```

### 2. Run Review

```bash
codex review
```

Mode options:

- `--uncommitted` — Uncommitted changes only
- `--base origin/<branch>` — Compare against specific branch (use for PRs)
- `--commit <SHA>` — Review a specific commit
- Default (no flag) — auto-detects based on git state

### 3. Present Results

Group findings by severity and create a task list for issues found.

| Severity | Action | Examples |
|----------|--------|----------|
| **P1 — Critical** | Must fix | Security vulnerabilities, data loss risks, broken logic |
| **P2 — Important** | Should fix | Error handling gaps, performance issues, missing validation |
| **P3 — Minor** | Nice to fix | Style inconsistencies, naming suggestions, minor simplifications |
| **False positive** | Skip | Findings that don't apply to the actual context |

Severity informs priority but doesn't mechanically determine the action — a P2 may be irrelevant in context, and a P3 may be worth fixing. Use judgment.

### 4. Fix Issues (Autonomous Workflow)

When user requests implementation + review, or when proactively reviewing your own code:

1. Implement the requested feature
2. Run `codex review` (auto-detect mode or `--uncommitted`)
3. Triage findings with judgment — fix actionable issues, dismiss false positives
4. Re-run review if fixes were applied
5. Repeat until clean or stop conditions are met

### Anti-Loop Safety

After each fix step, check these guards **before** re-running the review. **Stop immediately** if ANY is true:

| Guard | Condition |
|-------|-----------|
| No changes | `git diff --stat` is empty after the fix step |
| Max cycles | Cycle count reaches **4** |
| No progress | All remaining findings were dismissed or already fixed in a previous cycle |

## Documentation

For more details on the Codex CLI: <https://github.com/openai/codex>
