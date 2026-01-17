#!/usr/bin/env bash
# Prettier PostToolUse hook - formats files after edits
# Uses: npx prettier (no global install needed)

set -euo pipefail

# Read file path from Claude Code hook JSON input (stdin)
FILE_PATH=$(jq -r '.tool_input.file_path // empty')

# Exit early if no file path
[[ -z "$FILE_PATH" ]] && exit 0

# Exit if file doesn't exist
[[ ! -f "$FILE_PATH" ]] && exit 0

# Get file extension
EXT="${FILE_PATH##*.}"

# Supported extensions (Prettier's default parsers)
case "$EXT" in
  js | jsx | ts | tsx | mjs | cjs | mts | cts | \
    json | json5 | jsonc | \
    css | scss | sass | less | \
    html | htm | vue | svelte | astro | \
    md | mdx | markdown | \
    yaml | yml | \
    graphql | gql | \
    xml)
    # Format the file in-place using prettier
    # --write modifies in place, --log-level=error reduces noise
    npx --yes prettier --write --log-level=error "$FILE_PATH" 2>/dev/null || true
    ;;
  *)
    # Unsupported extension, skip silently
    ;;
esac

exit 0
