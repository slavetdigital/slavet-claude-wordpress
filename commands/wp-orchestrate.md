---
title: "/wp orchestrate"
description: Manually trigger a background-friendly detection/delegation pass and update state.
---

Runs `scripts/orchestrate.sh` to detect theme vs plugin, read optional reports, and persist a tiny state to `.claude-plugin/state.json` for other agents/plugins to use. Never runs heavy tools.

Outputs a short summary of detected type and available reports; suggests next light actions (e.g., run `/wp audit`).


