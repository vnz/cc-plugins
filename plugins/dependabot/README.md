# Dependabot Plugin

Check for dependency updates across your project using the official [Dependabot CLI](https://github.com/dependabot/cli) with automatic ecosystem detection.

## Prerequisites

1. **Dependabot CLI** - Install from https://github.com/dependabot/cli
2. **GitHub CLI (gh)** - For authentication via `gh auth token`
3. **Docker** - The Dependabot CLI runs each update in a container
4. **jq** (recommended) - For parsing the CLI's JSON output

## Installation

```bash
/plugin install dependabot@cc-plugins-vnz
```

## Usage

### Scan All Ecosystems

```
use dependabot
```

Auto-detects all package managers in your repository and checks for updates.

### Scan Specific Ecosystem

```
use dependabot for terraform
use dependabot for npm
use dependabot for github-actions
```

## Supported Ecosystems

Every ecosystem the Dependabot CLI supports except the beta-only `apm`: GitHub Actions, pre-commit, Terraform, OpenTofu, npm/yarn/pnpm, Bun, Deno, Go, pip, uv, Conda, Bundler, Cargo, Rust toolchain, Docker, Docker Compose, Dev Containers, Maven, Gradle, sbt, Bazel, Composer, NuGet, .NET SDK, Helm, Pub, Swift, Hex, Elm, Julia, Nix, vcpkg, and git submodules.

Trigger aliases and detection files are in [`skills/dependabot/references/ecosystems.md`](skills/dependabot/references/ecosystems.md).

## Workflow

1. **Prerequisites check** - Verifies `dependabot`, `gh`, and `jq` are installed
2. **Ecosystem detection** - Finds package managers based on config files
3. **Update scan** - Runs `dependabot update` for each ecosystem on a copy of the working tree
4. **Results presentation** - Shows available updates in a table

The plugin only scans. It does not edit files or open PRs.

## Authentication

The plugin uses `gh auth token` to obtain a GitHub access token. Ensure you're authenticated with the GitHub CLI:

```bash
gh auth login
```

## How It Works

The Dependabot CLI outputs JSON describing available updates (it never modifies files directly):

```bash
LOCAL_GITHUB_ACCESS_TOKEN=$(gh auth token) dependabot update <ecosystem> <owner/repo> --local <scan-dir>
```

- `<scan-dir>` is a temporary copy of the working tree without `.git`. Pointing `--local` at the repository itself fails when git hooks are installed (pre-commit, prek, husky): the CLI commits inside its container, the hook runs there, and its tool is missing.
- The copy includes uncommitted changes and leaves out ignored files.
- Output is JSON lines; the updates are in `create_pull_request` events.
- Output can be large (40KB+).

## Links

- [Dependabot CLI Repository](https://github.com/dependabot/cli)
- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)
