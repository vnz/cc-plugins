# cc-plugins-vnz

Personal Claude Code plugin marketplace by vnz.

## Adding a New Plugin

1. Create plugin directory: `plugins/<plugin-name>/`
2. Add required files:
   - `.claude-plugin/plugin.json` - Plugin manifest
   - `README.md` - Documentation
   - Plus any: `commands/`, `agents/`, `skills/`, `hooks/`
3. Register in `.claude-plugin/marketplace.json`
4. Validate: `prek run --all-files`
5. Commit and test: `/plugin install <name>@cc-plugins-vnz`

## Skill Structure (Recommended)

Use the subdirectory format for skills with reference files:

```
skills/
└── <skill-name>/
    ├── SKILL.md              # Main skill (required)
    └── references/           # Optional reference data
        └── <topic>.md
```

This enables progressive disclosure — Claude loads SKILL.md first, then fetches reference files only when needed.

## Development

```bash
# Install pre-commit hooks
prek install

# Run validation manually
prek run --all-files
```

## Pre-commit Hooks

`prek run --all-files` (`just all`) is what CI runs:

- `shfmt`, `justfmt` - Format shell scripts and the justfile
- `shellcheck`, `json-validate`, `script-permissions` - Lint shell, JSON, and .sh executable bits
- `validate-plugins` - `scripts/validate-plugins.sh`: versions agree between `plugin.json` and `marketplace.json`, required files exist, and `claude plugin validate` passes for the marketplace and each plugin (fails in CI without the `claude` CLI, skipped locally)

## CI and Dependencies

- CI pins the Claude CLI with `CLAUDE_CLI_VERSION` in `.github/workflows/ci.yml`, because `claude plugin validate` rules change between releases. Bump it only after `just validate` passes locally on the new version.
- Actions are pinned to a commit SHA with a `# vX.Y.Z` comment. Dependabot (`.github/dependabot.yml`) bumps them and the `.pre-commit-config.yaml` hook revs weekly.
