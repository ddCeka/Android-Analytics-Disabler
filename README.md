# DSS — Analytics & Ads Disabler

A lightweight Magisk module that disables background analytics, ad SDKs, crash reporters, and tracking components across Android user and system apps.

## Overview

Many Android applications bundle background services, receivers, and content providers for behavioral tracking, telemetry, and advertising. DSS uses Android's native Package Manager binder interface (`cmd package`) paired with single-pass `dumpsys` component caching to persistently toggle these components off across reboots—reducing background wakeups, telemetry overhead, and data collection in seconds.

### Targeted SDKs & Services
* **Analytics & Attribution:** Google Analytics, Google App Measurement, Firebase Analytics/Performance, Adjust, AppsFlyer, Facebook Analytics.
* **Advertising Networks:** Google Mobile Ads (AdMob), Facebook Audience Network, Amazon Ads, AdMost, Nend, Insider.
* **Crash & Error Reporting:** Firebase Crashlytics, Sentry, ACRA.
* **App-Specific Rules:** Tailored component cleanup for select apps (such as Google Play Services, Google Messages, MyTelkomsel, OfficeSuite, MX Player, Iceraven, and others).

## Prerequisites

* A rooted Android device running **Magisk** (compatible with Magisk v20.4+ via POSIX `/system/bin/sh`).
* Terminal access via **ADB** or a local terminal app (e.g., [Termux](https://github.com/termux/termux-app/releases/latest)).

## Installation

1. Download the `dss.zip` module archive.
2. Push or copy the zip file to your device storage:
   ```bash
   adb push dss.zip /sdcard/
   ```
3. Open the **Magisk** app and go to the **Modules** tab.
4. Tap **Install from storage**, select `/sdcard/dss.zip`, and reboot your device once flashing completes.

## Usage

Open a root shell using ADB or a terminal emulator:

```bash
adb shell
su
```

> [!NOTE]
> If using Termux without direct `su`, install `sudo` (`pkg install sudo`) and prefix commands with `sudo`.

### First-Time Run
The very first time you execute `dss`, it creates `/data/.dss.init`, initializes configuration templates inside `/sdcard/Documents/dss/`, and displays a one-time safety reminder regarding Google Play system updates. Run your desired command a second time to begin execution.

### Syntax

```bash
dss [-n|--dry-run] {enable|disable} {user|system} [package]
```

* **`-n`, `--dry-run`** *(optional)*: Scans packages and reports matching components without modifying their state.
* **`enable` | `disable`**: Enables or disables the targeted tracking and ad components.
* **`user` | `system`**: Targets third-party user-installed apps (`-3`) or pre-installed system apps (`-s`).
* **`[package]`** *(optional)*: Limits execution to a single package name (e.g., `com.telkomsel.telkomselcm`).

### Examples

* **Preview changes on all user apps without applying them:**
  ```bash
  dss --dry-run disable user
  ```
* **Disable tracking and ads for all user apps:**
  ```bash
  dss disable user
  ```
* **Disable tracking and ads for a specific app:**
  ```bash
  dss disable user com.telkomsel.telkomselcm
  ```
* **Re-enable all targeted components on system apps:**
  ```bash
  dss enable system
  ```

### Sample Output

```text
+----------------------------------------------------------+
| DSS Execution Started                                    |
+----------------------------------------------------------+
| Action : disable                                         |
| Scope  : user (115 pkg(s), 2 excluded)                   |
+----------------------------------------------------------+
| Completed 115 package(s) in 11s.                         |
+----------------------------------------------------------+
| Disabled: 318      | Enabled: 0       | Skipped: 8842    |
+----------------------------------------------------------+
```

## Configuration (`/sdcard/Documents/dss/`)

On first run, DSS automatically creates `/sdcard/Documents/dss/` with two user-editable plain-text configuration files (blank lines and `#` comments are ignored):

* **`exclude.list` (Package Whitelist):** Add one package name per line (e.g., `com.example.bankingapp`) to skip it during bulk `user` or `system` scans.
* **`custom.list` (Custom Component Blacklist):** Add one `package/component` entry per line (e.g., `com.example.app/com.example.ads.BannerActivity`) to disable or re-enable additional components alongside built-in rules.

## Important Warnings & Troubleshooting

> [!WARNING]
> **Google Play System Updates:** Disabling components inside `system` packages can cause Google Play system updates to fail or bootloop. Always re-enable system components before installing a system or Play system update:
> ```bash
> dss enable system
> ```

### Fixing App Crashes
Some apps are poorly coded and may crash if a specific SDK component (such as `FacebookInitProvider`) is disabled. If an app misbehaves after running `dss`:

1. **Restore all components for that app:**
   ```bash
   dss enable user <package-name>
   ```
2. **Exclude the app permanently** by adding its package name to `/sdcard/Documents/dss/exclude.list`.
3. **Or re-enable a single component manually:**
   ```bash
   cmd package enable <package-name>/<component-name>
   ```
   *(For example: `cmd package enable com.telkomsel.telkomselcm/com.facebook.internal.FacebookInitProvider`)*

## Uninstalling

Removing the module from the **Magisk** app automatically runs `uninstall.sh` on the next reboot, which re-enables all built-in and `custom.list` components for both `user` and `system` apps while preserving your `/sdcard/Documents/dss/` configuration files.

## Inspecting the Source

All logic lives in a single POSIX shell script inside the module zip at `system/bin/dss`. Unzip `dss.zip` to review or customize the global and per-package component lists.
