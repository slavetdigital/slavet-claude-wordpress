---
title: "/wp improvement-report"
description: Generate a delta report that maps repository state to the Theme Improvement Plan and lists exact fixes.
---
**Reports intake (if present):**
- Read `./.reports/theme-check.json` and `./.reports/phpcs.json`.
- Prefer citing **file:line** from these logs over fresh scans.
- If reports are missing, suggest running the CI workflow template (`templates/theme-ci.yml`).



Steps:
1) Locate **Theme Improvement Plan.md** in the workspace root or `/docs`. If missing, generate a minimal plan outline and continue.
2) Build a **Delta Matrix**: For each checklist item in the plan, mark **Done / Missing / Needs Fix** with evidence (file path or tool log).
3) Output:
   - **Current State vs Plan** table
   - **Blocking issues for WP.org submission**
   - **Exact PR checklist** with file names and code tasks
4) Keep the report concise but exhaustive. Never invent evidence.
