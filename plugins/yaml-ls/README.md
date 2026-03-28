# yaml-ls

YAML language server plugin for Claude Code, providing code intelligence features for YAML files.

## Features

| Feature | Description |
|---------|-------------|
| **goToDefinition** | Navigate to anchor definitions |
| **findReferences** | Find all alias usages across your file |
| **hover** | Inline documentation from JSON Schema associations |
| **diagnostics** | Real-time validation and error checking |

## Supported Files

| Extension | Language ID | Description |
|-----------|-------------|-------------|
| `.yaml` | `yaml` | YAML configuration |
| `.yml` | `yaml` | YAML configuration (short extension) |

## Prerequisites

Requires [yaml-language-server](https://github.com/redhat-developer/yaml-language-server) in your PATH.

```bash
npm install -g yaml-language-server
```

## Installation

```bash
# Add marketplace from vnz/cc-plugins (aliased as cc-plugins-vnz)
/plugin marketplace add vnz/cc-plugins

# Install plugin from the new marketplace
/plugin install yaml-ls@cc-plugins-vnz
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
1. Verify yaml-language-server is in your PATH: `which yaml-language-server`
2. Check that `ENABLE_LSP_TOOL=1` is set in your settings and restart Claude Code.
3. Check Claude Code logs for any `yaml-language-server` errors.

## Links

- [yaml-language-server GitHub](https://github.com/redhat-developer/yaml-language-server)
- [YAML Specification](https://yaml.org/spec/)
- [JSON Schema Store](https://www.schemastore.org/json/) (for schema associations)
