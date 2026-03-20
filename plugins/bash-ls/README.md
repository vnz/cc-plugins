# bash-ls

Bash language server plugin for Claude Code, providing code intelligence features for shell scripts.

## Features

| Feature | Description |
|---------|-------------|
| **goToDefinition** | Navigate to function and variable definitions |
| **findReferences** | Find all usages of functions and variables |
| **hover** | Inline documentation for builtins and commands |
| **diagnostics** | Real-time linting via shellcheck integration |
| **formatting** | Document formatting via shfmt integration |
| **codeActions** | Quick fixes for shellcheck warnings |
| **completion** | Symbol and command completion |
| **rename** | Rename functions and variables across files |
| **workspaceSymbol** | Search symbols across the workspace |

## Supported Files

| Extension | Language ID | Description |
|-----------|-------------|-------------|
| `.sh` | `shellscript` | Shell scripts |
| `.bash` | `shellscript` | Bash scripts |

## Integrations

bash-language-server automatically detects and uses these tools if they are on your PATH:

| Tool | Purpose |
|------|---------|
| [shellcheck](https://github.com/koalaman/shellcheck) | Linting and static analysis (diagnostics + code actions) |
| [shfmt](https://github.com/mvdan/sh) | Code formatting (respects `.editorconfig`) |

No additional configuration is needed — if the tools are installed, they just work.

## Prerequisites

Requires [bash-language-server](https://github.com/bash-lsp/bash-language-server) in your PATH.

```bash
npm install -g bash-language-server
```

Optional but recommended:

```bash
# macOS
brew install shellcheck shfmt

# Ubuntu/Debian (22.04+)
sudo apt install shellcheck shfmt

# Other platforms
# See https://github.com/koalaman/shellcheck#installing
# See https://github.com/mvdan/sh/releases
```

## Installation

```bash
# Add marketplace from vnz/cc-plugins (aliased as cc-plugins-vnz)
/plugin marketplace add vnz/cc-plugins

# Install plugin from the new marketplace
/plugin install bash-ls@cc-plugins-vnz
```

Enable LSP in your Claude Code settings (`~/.claude/settings.json`):

```json
{
  "env": {
    "ENABLE_LSP_TOOL": "1"
  }
}
```

## Troubleshooting

### Plugin not visible
Run `/plugin list` and verify the plugin appears. Try reinstalling if needed.

### LSP not working
1. Verify bash-language-server is in your PATH: `which bash-language-server`
2. Check that `ENABLE_LSP_TOOL=1` is set in your settings and restart Claude Code.
3. Check Claude Code logs for any `bash-language-server` errors.

### No diagnostics
Verify shellcheck is installed: `which shellcheck`. bash-language-server uses shellcheck for all linting — without it, diagnostics are limited to parse errors.

### Formatting not working
Verify shfmt is installed: `which shfmt`. If using `.editorconfig`, ensure shfmt-specific properties are correctly set (shfmt reads `.editorconfig` natively).

## Links

- [bash-language-server GitHub](https://github.com/bash-lsp/bash-language-server)
- [shellcheck GitHub](https://github.com/koalaman/shellcheck)
- [shfmt GitHub](https://github.com/mvdan/sh)
