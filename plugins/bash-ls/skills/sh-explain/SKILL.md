---
name: Shell Script Explanation
description: This skill should be used when the user asks to "explain this shell script", "what does this bash command do", "explain this shellcheck warning", "what does SC2086 mean", "help me understand this bash syntax", "explain set -euo pipefail", or needs help understanding shell scripts, bash patterns, or shellcheck diagnostics.
---

# Shell Script Explanation Skill

Explain shell scripts, bash syntax, shellcheck warnings, and common patterns with practical context. Leverage the LSP hover operation to retrieve documentation for builtins, commands, and variables when available.

## 1. Identify the Context

Before explaining, determine:

- **Shell dialect**: bash, sh (POSIX), dash, ksh — check the shebang line (`#!/bin/bash` vs `#!/bin/sh`)
- **Script type**: Standalone executable, sourced library, hook, CI/CD pipeline step, init script
- **Purpose**: Automation, build, deployment, system administration, data processing

The dialect matters because POSIX sh lacks bash-specific features (arrays, `[[ ]]`, process substitution). Shellcheck flags these as portability issues.

## 2. Explain with Structure

Cover these aspects as relevant:

1. **Purpose** — What the script accomplishes and its entry conditions
2. **Key Commands** — Important commands, their flags, and why those flags were chosen
3. **Control Flow** — Conditionals, loops, error handling patterns, and exit paths
4. **Variables & Parameters** — Environment variables, positional parameters, local variables, and their scope
5. **Exit Behavior** — Exit codes, error trapping, cleanup operations

Focus on the *why* behind non-obvious constructs, not just the *what*.

## 3. Shellcheck Warning Explanations

When explaining shellcheck warnings (SC codes), provide:

- **Rule**: The SC code and its severity (error, warning, info, style)
- **Why it matters**: The concrete bug or risk it prevents (word splitting, globbing, portability failure)
- **Fix**: Before/after code examples
- **Suppression**: When and how to use `# shellcheck disable=SCxxxx` directive comments

### Common Categories

**Quoting (SC2086, SC2046, SC2206)**
Word splitting and globbing risks from unquoted variables. Almost always a real bug in scripts handling filenames or user input. Fix: double-quote variables (`"$var"`, `"$@"`).

**Portability (SC2039, SC3045, SC3010)**
Bashisms used in scripts with a `#!/bin/sh` shebang. Either change the shebang to `#!/bin/bash` or replace with POSIX equivalents.

**Correctness (SC2155, SC2164, SC2103)**
Subtle bugs from common patterns:
- `local var=$(cmd)` masks the exit code of `cmd` — split into two lines
- `cd dir` without `|| exit` continues in the wrong directory on failure
- Missing `cd -` or subshell to restore working directory

**Style (SC2034, SC2148, SC2154)**
Unused variables, missing shebangs, referenced-but-unassigned variables. Often hints at typos or incomplete refactoring.

## 4. Common Bash Patterns

### Strict Mode
```bash
set -euo pipefail
```
- `-e`: Exit on first error (non-zero exit code)
- `-u`: Treat unset variables as errors
- `-o pipefail`: Pipe fails if any command in the pipeline fails, not just the last one

Explain the implications: `-e` interacts subtly with conditionals and command substitutions. A failing command in an `if` condition does not trigger `-e`.

### Cleanup Handlers
```bash
trap 'rm -f "$tmpfile"' EXIT
```
Runs cleanup on any exit (success, failure, signal). Multiple traps on the same signal override — use a cleanup function to combine.

### Parameter Expansion
- `${VAR:-default}` — Use default if unset or empty
- `${VAR:=default}` — Assign default if unset or empty
- `${VAR:+alternate}` — Use alternate if set and non-empty
- `${VAR%pattern}` — Remove shortest suffix match
- `${VAR##pattern}` — Remove longest prefix match

### Argument Handling
- `"$@"` preserves argument boundaries (use this, not `$*`)
- `"$*"` joins all arguments into a single string with `$IFS`
- `shift` removes the first positional parameter

### Process Substitution & Redirections
- `<(cmd)` — Feed command output as a file descriptor
- `>(cmd)` — Feed file writes to a command
- `2>&1` — Redirect stderr to stdout
- `&>file` — Redirect both stdout and stderr (bash-only)

## 5. Using LSP Context

When the bash-language-server LSP is available:

- Use **hover** to retrieve documentation for builtins (`read`, `declare`, `trap`) and commands
- Use **diagnostics** to identify shellcheck warnings already flagged on the file
- Use **go-to-definition** to trace function calls and sourced files

Combine LSP data with explanations to give precise, file-specific answers rather than generic guidance.
