#!/usr/bin/env bash
# eclint PostToolUse hook - fixes EditorConfig violations after file edits
# Requires: npm install -g eclint

set -euo pipefail

# Read file path from Claude Code hook JSON input (stdin)
FILE_PATH=$(jq -r '.tool_input.file_path // empty')

# Exit early if no file path
[[ -z "$FILE_PATH" ]] && exit 0

# Exit if file doesn't exist
[[ ! -f "$FILE_PATH" ]] && exit 0

# Check if eclint is available
if ! command -v eclint &>/dev/null; then
  echo "eclint not found. Install with: npm install -g eclint" >&2
  exit 0
fi

# Run eclint fix on the file
# eclint will automatically find and use .editorconfig
if ! eclint fix "$FILE_PATH"; then
  echo "eclint: failed to fix '$FILE_PATH'" >&2
fi

exit 0
