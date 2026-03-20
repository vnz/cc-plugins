---
name: Code Review Workflow
description: This skill should be used when deciding whether to run a code review, interpreting codex review findings, understanding review severity levels, or determining the appropriate review strategy for code changes. Activates on "should I review this", "what does this codex finding mean", "review workflow", or after making code changes.
---

# Code Review Workflow

Guidance for when, how, and why to run code reviews using the `/codex-review` command.

## Review Mandate

Code review is **mandatory** for all code changes. Run `/codex-review` proactively without waiting for the user to ask. Always run it as a background task.

**Skip review** for trivial changes that don't touch code: docs-only edits, config-only changes, version bumps with no logic changes.

## Only Review Your Own Code

Only use `/codex-review` (codex CLI) for code you authored in the current session. When reviewing someone else's PR or code, review it directly — read the diff yourself and provide feedback without codex.

## When to Review

| Situation | Action |
|-----------|--------|
| Before first commit on a feature branch | Run `/codex-review` |
| After pushing commits to a PR | Run `/codex-review` |
| Reviewing a specific commit | Run `/codex-review --commit <SHA>` |
| Docs-only or config-only change | Skip review |

The command auto-detects the correct mode (`--uncommitted`, `--base`, or `--commit`) — just run `/codex-review` without specifying a mode.

## Interpreting Findings

Codex findings fall into severity categories:

| Severity | Action | Examples |
|----------|--------|----------|
| **P1 — Critical** | Must fix before commit/merge | Security vulnerabilities, data loss risks, broken logic |
| **P2 — Important** | Should fix, may proceed with justification | Error handling gaps, performance issues, missing validation |
| **P3 — Minor** | Nice to fix, safe to skip | Style inconsistencies, naming suggestions, minor simplifications |
| **False positive** | Note and skip | Findings that don't apply to the actual context |

When the fix-and-review loop runs, use judgment to triage each finding: fix what's clearly correct and actionable, dismiss false positives. Severity informs priority but doesn't mechanically determine the action — a P2 may be irrelevant in context, and a P3 may be worth fixing.

## When Codex Is Unavailable

If the `codex` CLI is not installed, `/codex-review` silently does nothing — no error, no warning. This is intentional: the plugin should not block workflows in environments where codex is not available.
