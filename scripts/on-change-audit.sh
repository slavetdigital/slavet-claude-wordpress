#!/usr/bin/env bash
set -euo pipefail
# Lightweight guard: only remind to re-run audit; don't run heavy tools automatically.
echo "[slavet-claude-wordpress] Files changed. Tip: run '/wp audit' for an updated report." >&2
