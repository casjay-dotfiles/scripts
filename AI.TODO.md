# AI TODO

## Current Session Tasks - setupmgr Refactoring (2026-02-06)

### Context
Refactoring setupmgr __setup_* install functions to use unified helpers.
76/134 functions already refactored (57%). Added messaging consolidation + claude native installer.

### Completed

- [x] Added __message_installed_ok() and __message_installed_failed() helpers
- [x] Consolidated messaging in __install_from_binary, __install_from_archive, __install_from_npm, __execute_npm
- [x] Removed redundant prints from __install_to_system_bin, __move_extracted_file
- [x] Added __setup_claude() native binary installer
- [x] Analyzed all 134 __setup_* functions and categorized into tiers
- [x] Tier 1: Cleaned up minikube (removed unused var), httpie already fine
- [x] Tier 2: Converted btop to __install_from_archive (43 lines → 3)
- [x] Tier 2: Applied messaging helpers to bottom, nushell, watchexec, miller
- [x] Applied __message_installed_ok/__message_installed_failed across ~50 functions
- [x] Fixed typo "hase been installed" in kubectl
- [x] Replaced pipx-specific failure messages with standard helper
- [x] Syntax check passed (bash -n bin/setupmgr)
- [x] Updated COMMIT_MESS with all changes

### Notes for Future Sessions

**Tier 2 functions NOT fully converted (have version comparison logic):**
- bottom, nushell, watchexec, miller, age, tig, entr, helix, helm, broot, packer, golang, zed, lapce
- These use __compare_versions/__save_version which __install_from_archive doesn't support
- Would need to add version-aware mode to helpers for full conversion

**Tier 3 functions left as-is (complex custom logic):**
- Systemd services: traefik, caddy, webhookd, localai
- Git clone: lua, asdf, gvm, nvm, rvm, rbenv
- Curl scripts: rustup, distrobox, dotnet, devbox, nix, nodejs, fnm
- Desktop apps: zed, lapce, antigravity
- Other: powershell, jekyll, pipx, minio, garage, plandex, ollama
