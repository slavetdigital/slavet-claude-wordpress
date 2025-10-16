# Plugin Improvement Plan

> **Objective:** Upgrade this WordPress plugin to an enterprise‑grade release that is **100% compliant** with the **WordPress.org Plugin Directory Guidelines**, passes **PHPCS/WPCS** with **0 errors/0 warnings** (or documented exceptions), meets **WCAG 2.2 AA** for any UI, and ships with robust **security**, **performance**, **privacy**, **i18n**, **docs**, and **CI/CD**.

---

## 0) Acceptance Criteria

- ✅ **WP.org Guidelines:** No obfuscated code, no remote code execution, no admin nags/upsells, no tracking by default, GPL‑compatible licensing.
- ✅ **Code Quality:** PHPCS with `WordPress`, `WordPress-Docs`, `WordPress-Extra`, and `Security` rulesets at **0 errors / 0 warnings**.
- ✅ **Security:** Nonces, capability checks, escaping/sanitization everywhere; no `eval`, no `base64_`, safe file ops, prepared SQL only.
- ✅ **Privacy:** Telemetry strictly **opt-in**, with clear notices, filters, and data minimization.
- ✅ **i18n:** Textdomain consistent; `load_plugin_textdomain();` all strings translatable; translator comments where placeholders appear.
- ✅ **Docs:** Valid **readme.txt** (headers: `Requires at least`, `Tested up to`, `Requires PHP`, `License`, `License URI`), changelog policy, support policy, `SECURITY.md`, `CONTRIBUTING.md`.
- ✅ **Packaging:** `.distignore` removes dev files; assets under `/assets/` for .org banners/icons.
- ✅ **CI/CD:** GitHub Actions → lint → test → package; artifact is install‑ready ZIP + `.reports/phpcs.json` for audits.

---

## 1) Repository Hygiene

- [ ] Standard structure:
  ```text
  plugin-slug/
  ├─ plugin-slug.php          # Main plugin file with headers
  ├─ includes/                # PHP classes / functions
  ├─ assets/                  # css, js, images; no large media
  ├─ languages/               # .pot / .po / .mo
  ├─ readme.txt               # WordPress.org readme
  ├─ LICENSE                  # GPL‑compatible
  ├─ .distignore              # prune dev files from release ZIP
  ├─ .editorconfig            # whitespace/newlines
  ├─ phpcs.xml                # WPCS ruleset
  ├─ .github/workflows/       # CI
  └─ docs/                    # optional docs
  ```
- [ ] Conventional commits; Keep a Changelog.
- [ ] Branch protection + status checks.

---

## 2) Headers & Bootstrap

- [ ] **Main file header:** `Plugin Name`, `Plugin URI`, `Description`, `Version`, `Author`, `License`, `Text Domain`, `Requires at least`, `Requires PHP`.
- [ ] **Textdomain:** consistent with slug; `load_plugin_textdomain()` on `plugins_loaded`.
- [ ] **Autoloading:** use simple `require`/PSR‑4 autoload via Composer (optional) with classmap optimize.

---

## 3) Security Checklist

- [ ] **Capabilities:** gate admin pages with `current_user_can()`; granular caps preferred.
- [ ] **Nonces:** for actions/forms; verify on submit; reject on failure.
- [ ] **Sanitization:** `sanitize_text_field`, `sanitize_email`, `sanitize_key`, custom callbacks for complex types.
- [ ] **Escaping:** `esc_html`, `esc_attr`, `esc_url`, `wp_kses_post` on output.
- [ ] **SQL:** only `$wpdb->prepare()` with correct placeholders; no concatenated queries.
- [ ] **Files/HTTP:** no `eval`; no `base64_`; no remote `file_get_contents('http');` use `wp_remote_get()` with validation if needed.
- [ ] **CSP‑ready:** avoid inline scripts/styles when possible.

---

## 4) Privacy & Telemetry

- [ ] Default = **no tracking**. If telemetry exists: explicit opt‑in checkbox; clear description of data; easy opt‑out; documented filters; no PII.
- [ ] Data minimization; retention policy documented in `PRIVACY.md` or README.

---

## 5) Internationalization (i18n) & Accessibility (a11y)

- [ ] Extract strings with `wp i18n make-pot`; translators comments near placeholders.
- [ ] Admin/UI screens meet **WCAG 2.2 AA** basics: labels, roles, focus order, contrast, keyboard navigation.
- [ ] Avoid color-only cues; announce dynamic changes with ARIA when needed.

---

## 6) Performance

- [ ] Autoload minimal code; lazy‑load heavy classes only in admin or when hooks fire.
- [ ] Scripts/styles enqueued conditionally; no hard blocking assets on all pages.
- [ ] Images compressed; no remote blocking calls on init.

---

## 7) Docs & Readme

- [ ] **readme.txt** passes validator; includes short/long description, screenshots (optional), FAQ, Installation, Changelog.
- [ ] `SECURITY.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `CHANGELOG.md` (Keep a Changelog).
- [ ] Clear support policy and tested versions.

---

## 8) CI/CD & Reports

- [ ] Add GitHub Actions at `.github/workflows/plugin-ci.yml`.
- [ ] Jobs produce `./.reports/phpcs.json` (and optional custom audits).
- [ ] Release packaging creates a clean ZIP using `.distignore`.

**Example .distignore (excerpt)**  
```
/.*
/node_modules
/vendor
/tests
/.github
/.vscode
*.map
composer.*
package-lock.json
pnpm-lock.yaml
```
---

## 9) Definition of Done

- [ ] PHPCS/WPCS: **0 errors / 0 warnings** (or documented exceptions).
- [ ] Security and privacy checklist pass; telemetry (if any) is opt‑in and documented.
- [ ] i18n coverage complete; POT generated.
- [ ] readme.txt validated; headers correct.
- [ ] CI green; ZIP install‑tested on a fresh site.
- [ ] Changelog updated; version bumped; tag pushed.

---

## 10) Concrete Task List

- [ ] Add `phpcs.xml` and Composer scripts for local linting.
- [ ] Implement capability + nonce checks for all actions.
- [ ] Escape all output; sanitize all inputs.
- [ ] Add `load_plugin_textdomain()`; generate POT.
- [ ] Validate `readme.txt` headers; add missing sections.
- [ ] Add `.distignore`; set up CI; publish release artifact.
