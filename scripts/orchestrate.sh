#!/usr/bin/env bash
set -euo pipefail

# Minimal, background-friendly orchestration:
# - Detect theme vs plugin using offline heuristics
# - Persist a tiny state file for other agents/plugins to read
# - Never run heavy tools; do not block editor

ROOT_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
STATE_DIR="$ROOT_DIR/.claude-plugin"
STATE_FILE="$STATE_DIR/state.json"

mkdir -p "$STATE_DIR"

detect_type() {
  if [ -f "style.css" ] && grep -qi "Theme Name:" style.css 2>/dev/null; then
    echo theme
    return 0
  fi
  if [ -f "theme.json" ]; then
    echo theme
    return 0
  fi
  # plugin heuristics: top-level php with Plugin Name header, or readme.txt markers
  if ls ./*.php >/dev/null 2>&1; then
    if grep -Eqi "^\s*Plugin Name:\s*" ./*.php 2>/dev/null; then
      echo plugin
      return 0
    fi
  fi
  if [ -f "readme.txt" ] && grep -qi "== Changelog ==" readme.txt 2>/dev/null; then
    echo plugin
    return 0
  fi
  echo unknown
}

TYPE=$(detect_type)

# Check for existing reports to hint lightweight readiness
HAS_THEME_CHECK=false
HAS_PHPCS=false
if [ -f ".reports/theme-check.json" ]; then HAS_THEME_CHECK=true; fi
if [ -f ".reports/phpcs.json" ]; then HAS_PHPCS=true; fi

# Optionally detect presence of the slavet-claude-frontend plugin via marketplace or filesystem
FRONTEND_COLLAB="absent"
if [ -n "${CLAUDE_MARKETPLACE_PATH:-}" ] && [ -d "${CLAUDE_MARKETPLACE_PATH}/plugins/slavet-claude-frontend" ]; then
  FRONTEND_COLLAB="present"
fi
# Heuristic: sibling repo folder
if [ -d "$ROOT_DIR/../slavet-claude-frontend" ]; then FRONTEND_COLLAB="present"; fi

# Persist state (overwrite atomically)
TMP_FILE="${STATE_FILE}.tmp"
cat > "$TMP_FILE" <<EOF
{
  "detectedType": "${TYPE}",
  "reports": {
    "themeCheck": ${HAS_THEME_CHECK},
    "phpcs": ${HAS_PHPCS}
  },
  "collaboration": {
    "slavetClaudeFrontend": "${FRONTEND_COLLAB}"
  },
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
mv "$TMP_FILE" "$STATE_FILE"

# Non-intrusive notice
echo "[slavet-claude-wordpress] Orchestrate: type=${TYPE}, theme-check=${HAS_THEME_CHECK}, phpcs=${HAS_PHPCS}, frontend=${FRONTEND_COLLAB}" >&2

exit 0


