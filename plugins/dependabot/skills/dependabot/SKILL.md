---
name: dependabot
description: This skill should be used when the user asks to "check dependencies", "find outdated packages", "scan for updates", "use dependabot", "run dependabot", "check for security updates", "upgrade dependencies", "version updates", "what needs updating", or requests dependency scanning for specific ecosystems like npm, terraform, or github-actions. Supports scanning all ecosystems or specific ones with "use dependabot for <ecosystem>".
---

# Dependabot Update Skill

Scan for dependency updates using the official Dependabot CLI.

**Reference files:**
- `references/ecosystems.md` - Complete list of supported ecosystems with aliases and detection methods

## 1. Prerequisites Check

Before running, verify the required tools are installed:

```bash
# Check if dependabot CLI is installed
command -v dependabot || echo "NOT_FOUND"

# Check if gh CLI is installed (needed for authentication)
command -v gh || echo "NOT_FOUND"

# Check if jq is installed (needed for JSON parsing)
command -v jq || echo "NOT_FOUND"
```

**If dependabot CLI is not found:**
- Inform the user: "The Dependabot CLI is not installed."
- Provide installation link: https://github.com/dependabot/cli
- Stop execution until the CLI is available.

**If gh CLI is not found:**
- Inform the user: "The GitHub CLI (gh) is needed for authentication."
- Suggest installation via their package manager.

**If jq is not found:**
- Inform the user: "jq is recommended for robust JSON parsing. The skill will fall back to a less reliable method if it's not available."
- Suggest installation via their package manager (e.g., `brew install jq`, `apt install jq`).

## 2. Parse User Intent

Analyze the user's trigger phrase:

- **"use dependabot"** → Scan ALL detected ecosystems
- **"use dependabot for \<name\>"** → Scan only the specified ecosystem

Consult `references/ecosystems.md` for the complete alias-to-ecosystem mapping (e.g., "npm" → `npm_and_yarn`, "actions" → `github_actions`).

## 3. Ecosystem Auto-Detection

If scanning all ecosystems, detect which are present using file existence checks. When ecosystems share a manifest (`package.json`, `pyproject.toml`, `*.tf`), follow the "Shared Manifests" rules in `references/ecosystems.md`.

Report detected ecosystems to the user before proceeding:
> "Detected ecosystems: npm_and_yarn, github_actions, terraform"

If a specific ecosystem was requested but not detected:
> "The 'terraform' ecosystem was requested but no Terraform files were found in this repository."

## 4. Run Dependabot Updates

Do not pass `--local .`: the CLI copies that directory's `.git` into the updater container and runs `git add . && git commit` there, so installed git hooks (pre-commit, prek, husky) run inside the container and the update fails with `failed to initialize clone dir`. Scan a fresh clone of the current commit instead:

```bash
SCAN_DIR=$(mktemp -d) && git clone --quiet --depth 1 "file://$(git rev-parse --show-toplevel)" "$SCAN_DIR" && echo "$SCAN_DIR"
```

Shell variables do not carry over between commands, so pass the printed path literally as `<scan-dir>`.

A fresh clone has no hooks installed, keeps tracked files tracked (Dependabot runs `git clean -fx` before fetching, which deletes untracked files), and gives the CLI nothing to commit, so the scan runs on the real commit. It scans that commit only: if `git status --porcelain` prints anything, tell the user that uncommitted changes are not scanned.

If the repository has a `.gitmodules` file, populate submodules at their recorded commits, as Dependabot does on GitHub. A plain clone leaves them empty, and a manifest that points into one (such as a Cargo `path` dependency) then fails:

```bash
git -C <scan-dir> remote set-url origin "$(git remote get-url origin)" && git -C <scan-dir> submodule update --quiet --init --recursive --depth 1
```

Setting the remote first makes relative submodule URLs (`../lib.git`) resolve against GitHub instead of the local clone source. If this fails, for example on a private submodule you cannot access, continue the scan and tell the user that files inside submodules are missing from it.

For each ecosystem to scan, run the Dependabot CLI:

```bash
# Get the repository name dynamically
REPO=$(gh repo view --json owner,name --jq '.owner.login + "/" + .name')
LOCAL_GITHUB_ACCESS_TOKEN=$(gh auth token) dependabot update <ecosystem> "$REPO" --local <scan-dir> 2>&1
```

Where `<ecosystem>` is the CLI ecosystem value (e.g., `npm_and_yarn`, `terraform`, `github_actions`).

**Exception — `submodules`:** omit `--local <scan-dir>`. The submodule fetcher looks up each submodule through the GitHub API at the scanned commit, so the commit must exist on GitHub. Without `--local`, the CLI clones the default branch from GitHub; say so when reporting its results.

**Run ecosystems serially** (one at a time) to avoid output confusion. When all are done, remove the copy with `rm -rf <scan-dir>`.

**Understanding the output:**
- The CLI outputs **JSON lines** (one JSON object per line), NOT human-readable tables
- The CLI **never modifies files directly** - it only outputs data describing what would change
- The `--local <scan-dir>` flag scans that clone instead of cloning from GitHub (NOT a "dry-run" flag)
- Output can be very large (40KB+) - it may be truncated
- **Important:** Use `2>&1` to capture both stdout and stderr, as the CLI mixes log messages (stderr) with JSON output (stdout)

## 5. Parse Results from JSON Output

Filter the output for `create_pull_request` events — these contain the updates:

```bash
# Primary method (jq) — robust JSON parsing
<output> | jq -c 'select(.type == "create_pull_request")'

# Fallback (grep) — if jq unavailable, less reliable
<output> | grep '"type":"create_pull_request"'
```

- ✅ **Updates found:** `create_pull_request` events in output
- ❌ **No updates:** Only `mark_as_processed` events (jq/grep returns nothing)

Each `create_pull_request` event contains:
- `data.dependencies[].name` - Package name
- `data.dependencies[]["previous-version"]` - Current version
- `data.dependencies[].version` - Available version
- `data["pr-title"]` - Suggested PR title
- `data["updated-dependency-files"][]` - The actual file changes to apply

**Extract dependency summary from an event:**
```bash
echo '<event>' | jq -r '.data.dependencies[] | "\(.name): \(.["previous-version"]) → \(.version)"'
```

## 6. Present Results

Summarize findings in a clear format:

```
## Dependabot Scan Results

### github_actions
| Dependency | Current | Available |
|------------|---------|-----------|
| actions/checkout | v4 | v6 |
| extractions/setup-just | v2 | v3 |

### npm_and_yarn
No updates available.
```

If no updates are found across all ecosystems:
> "All dependencies are up-to-date!"

## Important Notes

- Always use `gh auth token` for authentication — never ask for tokens directly
- Some ecosystems may require additional configuration (e.g., private registries)
- If dependabot fails for an ecosystem, report the error and continue with others
