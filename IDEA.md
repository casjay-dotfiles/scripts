# IDEA.md — WHAT

This file answers **what** this project is and what it contains.
How things are done: see `AI.md`.

---

## Project description

A curated collection of bash scripts for system administration, development
tooling, and personal automation. Scripts are self-contained, portable across
Linux distributions, and installable as a dotfiles suite. Every script follows
a consistent header format, UX conventions (--help, --version, --debug,
--color auto|yes|no), and documentation triple (inline help, man page, bash completion).

---

## Project variables

```
project_name:   scripts
project_org:    casjay-dotfiles
internal_name:  scripts
internal_org:   casjaysdev
author:         Jason Hempstead
contact:        jason@casjaysdev.pro
license:        WTFPL
repo:           https://github.com/casjay-dotfiles/scripts
```

---

## Business logic

### Goals

- One script per concern — no monolithic tools
- Self-contained: no runtime deps beyond bash 4+ and standard POSIX utilities
- Consistent UX: every script supports `--help`, `--version`, `--debug`, and `--color auto|yes|no`
- `NO_COLOR` env var honored per no-color.org spec
- Portable across `linux/amd64`, `linux/arm64`, `linux/arm` (armv7l)
- Installable system-wide or per-user via `install.sh`

### Directory structure

```
bin/            executable scripts (one per tool)
functions/      shared function libraries (sourced during migration only)
completions/    bash completions: _{script}_completions.bash
man/            man pages: {script}.1
templates/      script generation templates (gen-script/gen-header output)
tests/          test scripts
containers/     Dockerfiles + docker-compose.yml for distro testing
```

### Script categories

**System administration**
- `pkmgr` — unified package manager wrapper (apt/dnf/pacman/apk/brew/etc.)
- `sysusage` — system resource usage summary
- `setupmgr` — install third-party tools not in distro repos (binary/archive/npm/pip)
- `detectostype` — OS/distro/arch detection (safe to source)
- `captive-auth` — captive portal detection and login automation
- `update-lecerts` — Let's Encrypt certificate renewal automation
- `proxmox-cli` — Proxmox VE management helpers

**Development tooling**
- `gitcommit` — sign + commit + push wrapper (the only commit path)
- `gitadmin` — git repository administration helpers
- `gen-changelog` — generate changelogs from git history
- `buildx` — multi-arch container image builder (Docker BuildKit wrapper)
- `dockermgr` — Docker image/container management
- `composemgr` — Docker Compose project management
- `apimgr` — multi-provider container registry + git forge API client (18 providers)
- `gen-script` — scaffold new scripts from templates
- `gen-header` — generate/update script headers and boilerplate

**Networking & security**
- `anonymize` — anonymity tooling (Tor, I2P, VPN, MAC randomization)
- `cloudflare` — Cloudflare DNS/tunnel management
- `pastebin` — upload snippets to pastebin services

**Environment & desktop**
- `dotfiles` — unified dotfiles manager (delegates to dfmgr, desktopmgr, etc.)
- `randomwallpaper` — rotating desktop wallpaper daemon
- `tmux-new` — tmux session/window launcher with config templates
- `zellij-new` — zellij session launcher
- `notifications` — desktop notification helper

**Utilities**
- `dictionary` — offline word lookup
- `reqpkgs` — check/install required packages for a script
- `gen-nginx` — generate nginx vhost configs
- `latest-iso` — fetch latest distro ISO URLs

### Script header format

Every script begins with:

```bash
#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  YYYYMMDDHHMM-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  LICENSE.md
# @@ReadME           :  {script} --help
# @@Copyright        :  Copyright: (c) {year} Jason Hempstead, Casjays Developments
# @@Created          :  {date}
# @@File             :  {script}
# @@Description      :  {one-line description}
# @@Changelog        :  {what changed}
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  bash/{type}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
```

### Configuration layout

```
~/.config/myscripts/{scriptname}/     per-user config
~/.local/log/{scriptname}/            per-user logs
/etc/casjaysdev/{scriptname}/         system-wide config (root installs)
```

### External dependency policy

Scripts detect and adapt to whatever is available:
- Package managers: apt, dnf, pacman, apk, brew, zypper, xbps
- Init systems: systemd, openrc, s6, runit
- Container runtimes: docker, podman, incus, lxc
- Display servers: X11, Wayland, headless

No hard runtime dependencies beyond bash 4+ and standard POSIX utilities.

### Installation

```bash
bash install.sh
```

Copies `bin/*` to `/usr/local/bin/`, man pages to `/usr/local/man/man1/`,
completions to `/etc/bash_completion.d/`.

### Supported architectures

- `linux/amd64` (x86_64)
- `linux/arm64` (aarch64)
- `linux/arm` (armv7l)
