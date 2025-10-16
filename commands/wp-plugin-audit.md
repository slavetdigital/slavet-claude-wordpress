---
title: "/wp-plugin audit"
description: Fast, evidence-based audit for a WordPress plugin targeting WP.org standards.
---

**Reports intake (if present):**
- Read `./.reports/phpcs.json` and any custom plugin checks (`./.reports/plugin-lint.json` if provided).
- Prefer citing **file:line** from these logs over fresh scans.
- If reports are missing, suggest adding the CI workflow template (`templates/plugin-ci.yml`).


**Do not hallucinate.** Ground every claim in file paths, code snippets, or tool outputs.

1) **Detect repository type**
- Confirm it's a plugin root: a file with WP plugin header (e.g., `Plugin Name:` in top-level PHP) and/or `readme.txt` with `== Changelog ==`.

2) **Static checks (no network)**
- Disallowed/flag patterns: TGM, admin nags/screens, obfuscated code, `eval`, `base64_`, remote URL execution (`file_get_contents('http`), `curl_exec` without validation), direct DB writes w/o `$wpdb->prepare`.
- Check `readme.txt` headers: `Requires at least`, `Tested up to`, `Requires PHP`, `License`, `License URI`.
- i18n: textdomain consistency; `load_plugin_textdomain` present; translator comments around placeholders.
- Assets: `/assets/` banners/icons guidelines (just report presence, don't assume).
- Security: verify nonces + capability checks on actions; escaping on output.
- Privacy: any telemetry is **opt-in** and documented with filters.

3) **Tool runs (if locally available, else skip)**
```bash
phpcs -q --standard=WordPress,WordPress-Docs,WordPress-Extra --report=json . || true
```
If not installed, propose install commands.

4) **Summarize**
- **Evidence Table** with file:line and rule IDs when available.
- **Fix Plan** prioritized to pass WP.org review.
- If **Plugin Improvement Plan.md** exists, map findings to it.

Ask before applying code changes.
