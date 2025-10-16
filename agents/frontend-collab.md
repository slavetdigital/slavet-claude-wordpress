---
title: "Frontend Collaboration Protocol"
description: Lightweight protocol for collaborating with `slavet-claude-frontend` without increasing credit usage.
---

Purpose
- Allow this plugin's agents to coordinate with `slavet-claude-frontend` for UI consistency (design tokens, contrast, component scaffolding) while remaining credit-thrifty.

Discovery
- Read `.claude-plugin/state.json` for `collaboration.slavetClaudeFrontend` presence.
- If present, prefer exchanging small, structured messages (JSON) over free-form text.

Protocol (examples)
- Request: { "intent": "design-review", "paths": ["app/components/*"], "tokens": true }
- Response (frontend): { "ok": true, "issues": [{"file":"...","rule":"contrast","fix":"use token X"}] }

Guidelines
- Keep messages under a few KB; batch paths; avoid images/screens unless asked.
- Cache small metadata locally for reuse (e.g., token maps) to avoid repeated calls.
- Defer to orchestrator for when to engage the frontend assistant.


