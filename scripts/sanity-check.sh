#!/usr/bin/env bash
set -euo pipefail

# Basic environment and wiring checks for slavet-claude-wordpress

ROOT_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
STATUS=0

note() { echo "[slavet-claude-wordpress] $*" >&2; }

check_file() {
  local path="$1"; local label="$2"
  if [ -f "$path" ]; then note "OK: $label present ($path)"; else note "MISS: $label missing ($path)"; STATUS=1; fi
}

check_dir() {
  local path="$1"; local label="$2"
  if [ -d "$path" ]; then note "OK: $label present ($path)"; else note "MISS: $label missing ($path)"; STATUS=1; fi
}

check_bin() {
  local bin="$1"; local label="$2"
  if command -v "$bin" >/dev/null 2>&1; then note "OK: $label available ($bin)"; else note "INFO: $label not found ($bin) — optional"; fi
}

# Manifest & structure
check_file "$ROOT_DIR/.claude-plugin/plugin.json" "plugin manifest"
check_file "$ROOT_DIR/hooks/hooks.json" "hooks config"
check_dir  "$ROOT_DIR/commands" "commands dir"
check_dir  "$ROOT_DIR/agents"   "agents dir"
check_dir  "$ROOT_DIR/scripts"  "scripts dir"

# Scripts referenced by hooks
check_file "$ROOT_DIR/scripts/orchestrate.sh"   "orchestrate script"
check_file "$ROOT_DIR/scripts/on-change-audit.sh" "on-change-audit script"
check_file "$ROOT_DIR/scripts/session-start.sh" "session-start script"
check_file "$ROOT_DIR/scripts/save-state.sh"    "save-state script"

# Optional MCP
check_file "$ROOT_DIR/servers/wp-mcp.js" "optional MCP server"

# State coherence
STATE_FILE="$ROOT_DIR/.claude-plugin/state.json"
if [ -f "$STATE_FILE" ]; then
  if jq -e '.detectedType and .reports and .collaboration.slavetClaudeFrontend' "$STATE_FILE" >/dev/null 2>&1; then
    note "OK: state.json keys present"
  else
    note "MISS: state.json missing expected keys (detectedType, reports, collaboration.slavetClaudeFrontend)"; STATUS=1
  fi
else
  note "INFO: state.json not found — run '/wp orchestrate' once"
fi

# Optional tool presence (non-fatal)
check_bin "theme-check" "Theme Check"
check_bin "phpcs" "PHPCS"
check_bin "wp" "WP-CLI"

exit $STATUS


