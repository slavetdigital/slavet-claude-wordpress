---
title: "WordPress Orchestrator"
description: Detects WordPress repo type (theme vs plugin) and delegates to the correct sub-agent with a low-credit, background-friendly workflow.
---

Goal
- Maintain a single main agent for the overall WordPress workflow.
- Automatically detect whether the current repo is a WordPress theme or plugin.
- Delegate deep analysis to the appropriate sub-agent without increasing resource/credit usage.

Detection (fast, offline)
1) Theme indicators (any):
   - `style.css` with a WordPress theme header
   - `theme.json` present at repo root
2) Plugin indicators (any):
   - A top-level PHP file with plugin headers (`Plugin Name:`)
   - `readme.txt` including plugin sections like `== Changelog ==`
3) If ambiguous, ask once which target to analyze; default to none.

Delegation
- If Theme → use "WordPress Theme Developer" sub-agent.
- If Plugin → use "WordPress Plugin Developer" sub-agent.
- Keep orchestration light: pass only essential paths, reports, and goals.

Resource & background policy
- Never run heavy tools unprompted. Prefer reading existing reports from `./.reports/`.
- Work in small, incremental passes with clear exit criteria.
- When long analysis is requested, use background-friendly chunks and summarize diffs and checklists, not narratives.

Inputs to sub-agents
- Context: repo root, detected type, list of changed files, presence of reports:
  - `.reports/theme-check.json`
  - `.reports/phpcs.json`
- Goals: "enterprise-grade readiness" for WP.org and premium distribution.

Outputs expected
- A concise, evidence-based delta report:
  - What to fix, improve, add, remove, or update
  - Exact file paths/lines where applicable
  - Prioritized, PR-ready checklist

Runbook
1) Detect type (theme/plugin) per rules above.
2) If reports exist, load them and pass to the sub-agent.
3) Request a delta report and prioritized fixes from the sub-agent.
4) Return only artifacts and short summaries to the main thread; do not stream verbose logs.


