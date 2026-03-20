---
name: Code Review Workflow
description: This skill should be used when deciding whether to run a code review, interpreting codex review findings, understanding review severity levels, or determining the appropriate review strategy for code changes. Activates on "should I review this", "what does this codex finding mean", "review workflow", or after making code changes.
---

# Code Review Workflow

## Review Mandate

Code review is **mandatory** for all code changes. Run `/codex-review` proactively without waiting for the user to ask.

**Skip review** for trivial changes that don't touch code: docs-only edits, config-only changes, version bumps with no logic changes.

## Only Review Your Own Code

Only use `/codex-review` (codex CLI) for code you authored in the current session. When reviewing someone else's PR or code, review it directly — read the diff yourself and provide feedback without codex.

## Interpreting Findings

Codex findings fall into severity categories:

| Severity | Action | Examples |
|----------|--------|----------|
| **P1 — Critical** | Must fix before commit/merge | Security vulnerabilities, data loss risks, broken logic |
| **P2 — Important** | Should fix, may proceed with justification | Error handling gaps, performance issues, missing validation |
| **P3 — Minor** | Nice to fix, safe to skip | Style inconsistencies, naming suggestions, minor simplifications |
| **False positive** | Note and skip | Findings that don't apply to the actual context |

Severity informs priority but doesn't mechanically determine the action — a P2 may be irrelevant in context, and a P3 may be worth fixing. Use judgment.
