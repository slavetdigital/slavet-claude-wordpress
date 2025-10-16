---
title: "/wp plan-status"
description: Compare planned tasks vs. repo state and update a lightweight status file.
---
**Reports intake (if present):**
- Read `./.reports/theme-check.json` and `./.reports/phpcs.json`.
- Prefer citing **file:line** from these logs over fresh scans.
- If reports are missing, suggest running the CI workflow template (`templates/theme-ci.yml`).



1) Read **Theme Improvement Plan.md** and locate the **Concrete Task List** and **Definition of Done**.
2) Check repository for evidence of each task (files, configs, CI workflows).
3) Write/update `docs/STATUS.md` with:
   - ✅ Done (with links or paths)
   - 🟡 In Progress / Partial
   - ⛔ Missing
4) Keep it factual and link to code locations.
