---
title: "/wp-plugin improvement-report"
description: Generate a delta report mapping repo state to **Plugin Improvement Plan.md** and WP.org guidelines.
---

**Reports intake (if present):**
- Read `./.reports/phpcs.json` and any custom plugin checks (`./.reports/plugin-lint.json` if provided).
- Prefer citing **file:line** from these logs over fresh scans.
- If reports are missing, suggest adding the CI workflow template (`templates/plugin-ci.yml`).


Steps:
1) Locate **Plugin Improvement Plan.md** (root or `/docs`). If missing, generate a minimal outline and continue.
2) Build a **Delta Matrix** of checklist items → **Done / Missing / Needs Fix** with evidence (file paths or logs).
3) Output:
   - **Current State vs Plan** table
   - **Blocking issues for WP.org submission**
   - **PR-ready checklist** with exact files/tasks
4) Never invent evidence. If unknown, say: **“Not enough evidence.”**
