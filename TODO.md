# TODO

Target Environment: **Legacy Magisk v20.4 – v23.x** (POSIX `/system/bin/sh`)

---

## v9.1 — user whitelist & blacklist configuration (`/sdcard/Documents/dss/`)
Allow users to customize excluded apps and extra blocked components from an easily accessible storage directory without modifying the module binary.

- [x] **Auto-initialize config directory & templates:**
  - Create `/sdcard/Documents/dss/` during first run (alongside `/data/.dss.init`) if it does not exist.
  - Generate `/sdcard/Documents/dss/exclude.list` with usage comments (package whitelist).
  - Generate `/sdcard/Documents/dss/custom.list` with usage comments (`package/component` blacklist).
- [x] **Implement `exclude.list` parsing (Package Whitelist):**
  - Strip Windows `
` line endings, blank lines, and `#` comments.
  - Filter matching package names out of `$PLIST` before execution.
  - Track excluded package count and display it in the 60-column summary box.
- [x] **Implement `custom.list` parsing (Custom Component Blacklist):**
  - Strip `
` line endings, blank lines, and `#` comments.
  - Run `dodis "$CMD"` on each valid `package/component` entry after the main package loop.
  - Respect `--dry-run` mode and scope rules for custom entries.
- [x] **Update `uninstall.sh` handling:**
  - Ensure `dss enable` runs before cleanup so custom components are also restored on module removal.
  - Preserve `/sdcard/Documents/dss/` user configs across module upgrades/uninstalls.

---

## v9.2 — Component Status Audit & Batch Targeting
Improve visibility into component states after app or Google Play System updates, and allow faster runs on curated app sets.

- [ ] **Add `status` action (`dss status {user|system} [package]`):**
  - Inspect current enabled vs. disabled state of targeted components using cached `dumpsys package` output.
  - Display a 60-column summary showing active vs. already-disabled component counts.
- [ ] **Add batch file targeting (`-f` / `--file <path>`):**
  - Allow passing a plain-text file of package names (`dss -f /sdcard/dss/targets.list disable`).
  - Validate file existence and filter against installed packages.

---

## v9.3 — Opt-In Boot Automation & Run Logging
Add optional background persistence across reboots and troubleshooting logs for debugging broken apps.

- [ ] **Add opt-in boot service (`service.sh`):**
  - Wait for `sys.boot_completed=1` before executing.
  - Run `dss disable user` silently in the background only if `/data/.dss.autoboot` exists.
- [ ] **Add CLI toggle (`dss autoboot {on|off}`):**
  - Create or remove `/data/.dss.autoboot` and display confirmation in the 60-column UI.
- [ ] **Add execution logging (`-l` / `--log`):**
  - Save timestamped component changes (`enabled` / `disabled` / `error`) to `/data/local/tmp/dss.log` (or `/sdcard/dss/last_run.log`) to help diagnose app crashes.

---

## Ongoing Maintenance & Compatibility
- [ ] Keep all scripts strictly POSIX `/system/bin/sh` compliant (no bashisms) for Magisk v20.4–v23.x compatibility.
- [ ] Maintain strict 60-column terminal formatting across all new banners, errors, and summaries.
- [ ] Ensure every newly added rule or config feature has corresponding cleanup logic in `uninstall.sh`.
