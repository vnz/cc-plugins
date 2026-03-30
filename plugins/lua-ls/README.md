# lua-ls

Lua language server plugin for Claude Code, providing code intelligence features for Lua files.

## Features

| Feature | Description |
|---------|-------------|
| **goToDefinition** | Navigate to function and variable definitions |
| **findReferences** | Find all usages of symbols across your workspace |
| **hover** | Inline documentation and type information |
| **diagnostics** | Real-time validation and error checking |

## Supported Files

| Extension | Language ID | Description |
|-----------|-------------|-------------|
| `.lua` | `lua` | Lua source files |

## Prerequisites

Requires [lua-language-server](https://github.com/LuaLS/lua-language-server) in your PATH.

```bash
# macOS / Linux (Homebrew)
brew install lua-language-server

# See https://github.com/LuaLS/lua-language-server/wiki/Getting-Started for other methods
```

## Installation

```bash
# Add marketplace from vnz/cc-plugins (aliased as cc-plugins-vnz)
/plugin marketplace add vnz/cc-plugins

# Install plugin from the new marketplace
/plugin install lua-ls@cc-plugins-vnz
```

Enable LSP in your Claude Code settings (`~/.claude/settings.json`):

```json
{
  "env": {
    "ENABLE_LSP_TOOL": "1"
  }
}
```

## Configuration

lua-language-server reads project settings from `.luarc.json` or `.luarc.jsonc` in your workspace root. Common options:

```json
{
  "runtime.version": "LuaJIT",
  "diagnostics.globals": ["vim"],
  "workspace.library": ["$VIMRUNTIME"],
  "workspace.checkThirdParty": false
}
```

See the [settings reference](https://github.com/LuaLS/lua-language-server/wiki/Settings) for all options.

## Troubleshooting

### Plugin not visible
Run `/plugin list` and verify the plugin appears. Try reinstalling if needed.

### LSP not working
1. Verify lua-language-server is in your PATH: `which lua-language-server`
2. Check that `ENABLE_LSP_TOOL=1` is set in your settings and restart Claude Code.
3. Check Claude Code logs for any `lua-language-server` errors.

## Links

- [lua-language-server GitHub](https://github.com/LuaLS/lua-language-server)
- [LuaLS Wiki](https://github.com/LuaLS/lua-language-server/wiki)
- [Lua Reference Manual](https://www.lua.org/manual/)
