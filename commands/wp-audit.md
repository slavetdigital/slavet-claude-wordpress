---
title: "/wp audit"
description: Run a fast, zero-bloat audit of a WordPress FSE theme using local tools first, then summarize findings with strict evidence.
---
**Reports intake (if present):**
- Read `./.reports/theme-check.json` and `./.reports/phpcs.json`.
- Prefer citing **file:line** from these logs over fresh scans.
- If reports are missing, suggest running the CI workflow template (`templates/theme-ci.yml`).



**Do not hallucinate.** Ground every claim in file paths or tool outputs.

1) **Detect repository type**
- Confirm this is a WordPress theme root by locating: `style.css` header or `theme.json`.
- If not a theme, abort gracefully.

2) **Static checks (no network):**
- Search for disallowed patterns: TGM, admin nags, remote code fetch, `eval`, `base64`, `file_get_contents(http)`.
- Verify `theme.json` exists and has `"version": 3`; report schema issues if detected.
- Ensure **required templates/parts** present; note missing.
- Check `readme.txt`, `license.txt`, `screenshot.png (1200x900)`, `languages/` folder.
- Scan for missing escaping/sanitization in PHP output.

3) **Tool runs (use local tools if present, skip if missing):**
```bash
theme-check . --format json || true
phpcs -q --report=json || true
```
- If tools not installed, propose commands to install them (without running).

4) **Accessibility & Perf (lightweight heuristics only):**
- Verify skip links, nav landmarks, focus styles exist.
- Flag large CSS/JS bundles in `dist/` or `build/` (> suggested budgets).

5) **Summarize:**
- **Evidence Table** with exact file paths/lines or tool result keys.
- **Fix Plan**: ordered steps to reach WP.org compliance.
- If `Theme Improvement Plan.md` exists, **map each finding to relevant section**.

Finally, ask before making code changes.
