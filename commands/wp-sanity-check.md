---
title: "/wp sanity-check"
description: Validate plugin wiring, hooks, optional MCP server, and persisted state keys.
---

Runs `scripts/sanity-check.sh` to confirm:
- Manifest and directory structure are present
- Hook-referenced scripts exist
- Optional MCP server file exists
- `.claude-plugin/state.json` has expected keys if present
- Optional local tools (`theme-check`, `phpcs`, `wp`) availability

Output is concise and exits non-zero if required pieces are missing.


