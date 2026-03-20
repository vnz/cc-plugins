---
description: Run codex code review with auto-detection and iterative fix loop
argument-hint: [--commit <SHA>]
allowed-tools: Bash(codex:*, git:*, gh:*), Read, Edit, Write, Grep, Glob
---

Run an automated code review using the `codex` CLI. Follow each step in order.

## Step 1: Check Availability

Run `command -v codex` to verify codex is installed. If not found, stop silently — no error, no warning, no output.

## Step 2: Detect Review Mode

Determine which codex review mode to use:

1. If `$1` is `--commit` and `$2` is provided, use: `codex review --commit $2`
2. Otherwise, check for an open PR on the current branch:
   ```
   gh pr view --json baseRefName -q .baseRefName 2>/dev/null
   ```
   - If a base branch is found, use: `codex review --base origin/<base>`
   - If no PR exists, use: `codex review --uncommitted`

## Step 3: Execute Review

Run the detected codex review command as a **background task** (`run_in_background: true`). Wait for it to complete.

## Step 4: Parse Results

Read the review output. If there are no findings, report that the review is clean and stop.

## Step 5: Fix-and-Review Loop

If findings exist, enter a fix-and-review loop:

1. **Triage findings** by severity:
   - **P1 (critical)** and **P2 (important)**: Fix directly — edit the code.
   - **P3 (minor)** and **false positives**: Note them but do not fix.
2. **Check for changes** — run `git diff --stat` after fixing.

### Anti-Loop Safety

After each fix step, check these guards **before** re-running the review. **Stop immediately** if ANY is true:

| Guard | Condition |
|-------|-----------|
| No changes | `git diff --stat` is empty after the fix step (all findings were false positives or unfixable) |
| Max cycles | Cycle count reaches **3** |
| No progress | Finding count is same or higher than previous cycle |

If none of the stop conditions are met, go back to **Step 2** and re-run the review.

## Step 6: Final Report

Summarize the review outcome:

- **Fixed**: List what was fixed and in which cycle
- **Skipped**: List false positives or unfixable findings with brief reasoning
- **Status**: Whether the review is now clean or findings remain
