#!/usr/bin/env bash

# Get current date/time info
HUMAN_DATE=$(date +"%A, %Y-%m-%d %H:%M:%S %Z")
ISO_DATE=$(date -Iseconds)
YEAR=$(date +%Y)

# Output JSON with additionalContext (same pattern as explanatory-output-style)
cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "[DATE CONTEXT] Current date: ${HUMAN_DATE} | ISO: ${ISO_DATE} | Year: ${YEAR} (NOT 2025 - model training cutoff). When searching the web or making date-sensitive decisions, always use ${YEAR} as the reference year."
  }
}
EOF

exit 0
