# slavet-claude-wordpress (Claude Code plugin)

A **lightweight**, **evidence-based** Claude Code plugin that audits and assists **WordPress FSE** theme development for **WordPress.org** compliance.

## Why this plugin
- Zero-bloat hooks; all heavy steps are **opt-in commands**
- **No hallucinations**: every claim must be **proven** from file paths or tool outputs
- Works offline with local tools (`theme-check`, `phpcs`) if available
- Minimizes context/credits usage by focusing on **files that changed** and **tool logs**

## Install (locally)
```bash
# In your theme project root
/plugin install /absolute/path/to/slavet-claude-wordpress
# or host it in a repo and install by repo URL once published
```

## Commands
- `/wp audit` — fast static+tooling audit; outputs evidence & fix plan
- `/wp improvement-report` — delta vs **Theme Improvement Plan.md** with exact tasks
- `/wp plan-status` — writes `docs/STATUS.md` summarizing Done / Partial / Missing
- `/wp orchestrate` — manual trigger for detection/state update (background-friendly)

## Sub-agents and orchestration

- **Orchestrator**: detects if the repo is a theme or plugin (offline heuristics) and delegates to the appropriate sub-agent without increasing credit usage.
- **Theme Developer sub-agent**: generates an enterprise-grade delta report for themes with precise fixes, mapped to your plan.
- **Plugin Developer sub-agent**: generates an enterprise-grade delta report for plugins with precise fixes, mapped to your plan.
- **Frontend Collaboration sub-agent**: coordinates with `slavet-claude-frontend` to enforce tokens/contrast and align component scaffolding.

Behavior:
- Prefers existing reports from `./.reports/` and avoids heavy tool runs unless asked.
- Works in background-friendly increments and returns concise, evidence-based artifacts (tables, diffs, checklists).

## Hooks
- `SessionStart` runs background orchestration to detect theme/plugin and persist lightweight state, then sets context-thrifty posture
- Debounced `PostToolUse` orchestration after writes/edits, plus a gentle reminder to re-run audit
- `PreCompact` stores a session note

## Optional MCP (disabled by default)
Enable in `.claude-plugin/plugin.json` (`enabled: true`) to wrap local tools via MCP:
- `wp` (WP-CLI), `theme-check`, `phpcs`

> Keep it disabled unless you need it.

## Resource & Context Hygiene
- Commands avoid long summaries; they reference **paths & logs**
- Prefer **file diffs** and **short tables** over verbose narratives
- Stop if evidence is missing; ask for permission before large scans
 
## Using sub-agents effectively
- The orchestrator runs minimal, offline detection and delegates; it does not perform heavy work itself.
- Sub-agents prefer existing reports and generate concise deltas and PR checklists.
- To keep credits low, request specific outputs (e.g., "delta for accessibility" or "PHPCS violations only").
- Frontend collaboration uses small structured exchanges; avoid repeated large requests by caching token maps locally.

## Using sub-agents effectively
- The orchestrator runs minimal, offline detection and delegates; it does not perform heavy work itself.
- Sub-agents prefer existing reports and generate concise deltas and PR checklists.
- To keep credits low, request specific outputs (e.g., "delta for accessibility" or "PHPCS violations only").

## Compliance references
- Claude Code plugin schema & directories (manifest, commands, agents, hooks)
- WP.org Theme Review, WPCS/PHPCS, WCAG 2.2, Interactivity API

License: MIT

---

## CI integration (drop JSON logs into `./.reports/`)
Use the template at `templates/theme-ci.yml` in your theme repo:

```yaml
# .github/workflows/theme-ci.yml
# (see templates/theme-ci.yml for full file)
```

The plugin will auto-read:
- `.reports/theme-check.json`
- `.reports/phpcs.json`

…and cite exact file/line findings without re-running heavy tools.

## Marketplace publish
Create a repo for this plugin and include `.claude-plugin/marketplace.json`. Then:

```
/plugin marketplace add https://github.com/slavetdigital/slavet-claude-wordpress
/plugin install slavet-claude-wordpress@latest
```

## Optional MCP (opt-in)
Enable in `.claude-plugin/plugin.json` and use the naive server at `servers/wp-mcp.js` to invoke:
- `wp theme validate`
- `theme-check --format json`
- `phpcs --report=json`
```

---

## Plugin development support

### Plugin commands
- `/wp-plugin audit` — strict audit for WP.org plugin standards (facts only).
- `/wp-plugin improvement-report` — delta vs **Plugin Improvement Plan.md**.
- `/wp-plugin plan-status` — writes `docs/PLUGIN_STATUS.md` with evidence.

### Plugin CI (`./.reports/` intake)
Use `templates/plugin-ci.yml` to emit `.reports/phpcs.json` for your plugin repo. The plugin will cite exact file:line from these logs without re-running heavy checks.

### What is checked
- WP.org guidelines (no obfuscated code, no nags/upsells, no remote code exec)
- PHPCS/WPCS compliance
- `readme.txt` headers and basics
- i18n (`load_plugin_textdomain`, textdomain consistency)
- Security (capabilities, nonces, sanitization/escaping)
- Privacy (opt-in telemetry only)

> Still lightweight and **opt-in**. If reports are available, they’re used; otherwise you’ll get instructions to run local tools or enable CI.

### Templates provided
- `templates/theme-ci.yml` — theme CI (Theme Check + PHPCS → `./.reports/`)
- `templates/plugin-ci.yml` — plugin CI (PHPCS → `./.reports/`)
- `templates/Plugin Improvement Plan.md` — drop into plugin repo as your authoritative checklist
