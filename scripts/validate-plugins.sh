#!/usr/bin/env bash
set -euo pipefail

# validate-plugins.sh - Validate plugin structure and consistency
#
# Checks:
# 1. Version matches between plugin.json and marketplace.json
# 2. Required files exist (plugin.json, README.md)
# 3. Shell script syntax is valid

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

errors=0

log_error() {
  echo -e "${RED}ERROR:${NC} $1" >&2
  errors=$((errors + 1))
}

log_success() {
  echo -e "${GREEN}OK:${NC} $1"
}

# Check marketplace.json exists
MARKETPLACE_JSON="$ROOT_DIR/.claude-plugin/marketplace.json"
if [[ ! -f "$MARKETPLACE_JSON" ]]; then
  log_error "marketplace.json not found at $MARKETPLACE_JSON"
  exit 1
fi

# Get list of plugins from marketplace.json
plugins=$(jq -r '.plugins[].name' "$MARKETPLACE_JSON")

for plugin_name in $plugins; do
  echo "Validating plugin: $plugin_name"

  # Get plugin source directory from marketplace.json
  plugin_source=$(jq -r ".plugins[] | select(.name == \"$plugin_name\") | .source" "$MARKETPLACE_JSON")
  plugin_dir="$ROOT_DIR/${plugin_source#./}"

  # Check plugin directory exists
  if [[ ! -d "$plugin_dir" ]]; then
    log_error "Plugin directory not found: $plugin_dir"
    continue
  fi

  # Check required files
  plugin_json="$plugin_dir/.claude-plugin/plugin.json"
  readme="$plugin_dir/README.md"

  if [[ ! -f "$plugin_json" ]]; then
    log_error "plugin.json not found: $plugin_json"
  else
    log_success "plugin.json exists"
  fi

  if [[ ! -f "$readme" ]]; then
    log_error "README.md not found: $readme"
  else
    log_success "README.md exists"
  fi

  # Check version consistency
  if [[ -f "$plugin_json" ]]; then
    marketplace_version=$(jq -r ".plugins[] | select(.name == \"$plugin_name\") | .version" "$MARKETPLACE_JSON")
    plugin_version=$(jq -r '.version' "$plugin_json")

    if [[ "$marketplace_version" != "$plugin_version" ]]; then
      log_error "Version mismatch for $plugin_name: marketplace.json=$marketplace_version, plugin.json=$plugin_version"
    else
      log_success "Version consistent: $plugin_version"
    fi
  fi

  # Check shell script syntax
  for script in "$plugin_dir"/**/*.sh; do
    if [[ -f "$script" ]]; then
      if bash -n "$script" 2>/dev/null; then
        log_success "Bash syntax OK: $(basename "$script")"
      else
        log_error "Bash syntax error in: $script"
      fi
    fi
  done

  echo ""
done

if [[ $errors -gt 0 ]]; then
  echo -e "${RED}Validation failed with $errors error(s)${NC}"
  exit 1
else
  echo -e "${GREEN}All validations passed!${NC}"
  exit 0
fi
