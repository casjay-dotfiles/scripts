# TODO.AI.md

## bin/setupmgr / completions / man page

- DONE (this session): `completions/_setupmgr_completions.bash`'s `ARRAY` and
  `man/setupmgr.1`'s package list now document all 157 entries in
  `SETUPMGR_ALL_TOOLS`. Verified with `comm -23`/`comm -13` diffs — zero
  entries missing in either direction.

- DONE (202608281300-git, user-reported bug: `setupmgr claude opencode gh lf
  shellcheck ...` silently stopped after `gh` with exit 0): root cause was
  `lf` having no `__setup_*` function and no dispatch case, so the arg
  parser's `*) break ;;` catch-all silently aborted the *entire* remaining
  batch instead of erroring on just the unknown tool. Fixed both halves:
  (1) added `__setup_lf()` (uses `__install_from_archive` against
  `gokcehan/lf`'s standard release assets) plus its dispatch case; (2) fixed
  the systemic `*) break ;;` catch-all to `printf_red "Unknown tool: $1"`,
  set `SETUPMGR_EXIT_STATUS=1`, `shift 1`, and continue the loop instead of
  aborting it — so any future dispatch gap degrades to a per-tool error
  instead of silently truncating the rest of the batch.

  Also wired up dispatch cases for 26 other tools that already had a
  `__setup_*` function but no case arm (same defect class as `lf`, found
  while auditing the bug): `bandwhich`, `cosign`, `ctlptl`, `dasel`,
  `difftastic`, `git-cliff`, `gitleaks`, `gitui`, `grex`, `gron`, `grype`,
  `htmlq`, `httpie`, `jnv`, `kompose`, `kubectx`, `kubens`, `sd`, `sq`,
  `stern`, `syft`, `trufflehog`, `trivy`, `viddy`, `watchexec`, `xcaddy`,
  `xh`, `xsv`. Verified none of these functions fall back to a system
  package manager (would be a package-manager-delegation violation) before
  wiring them up. `script-lint` run against the diff: clean, no new
  violations.

  `antigravity` was in the same "has function, no case" list but
  deliberately excluded — its `__setup_antigravity` uses
  `__sudo apt install -y` on Debian-family hosts, a package-manager
  delegation violation needing its own decision; left as-is below.

- **Still NOT fixed: 18 tools in `SETUPMGR_ALL_TOOLS` have no `__setup_*`
  function at all** (calling them is a no-op even with a case arm), so they
  still hit the (now non-fatal, error-and-continue) unknown-tool branch:
  `ali`, `bombardier`, `buf`, `curlie`, `dog`, `dua`, `earthly`, `evans`,
  `eza`, `fx`, `ghz`, `grpcurl`, `jq`, `k6`, `lsd`, `oha`, `vegeta`, `wrk`.
  Fixing this requires writing 18 new `__setup_*` functions plus their
  dispatch cases and end-to-end verifying each install — a large,
  dedicated-session task, do not fold into an unrelated commit.

  `antigravity` remains separately deferred (see above): has a function and
  could get a case arm mechanically, but the function itself needs a
  package-manager-delegation fix first — a decision for the user, not a
  mechanical wiring fix.

- **`setupmgr all` (and `--all`) uses a separate, smaller internal `ARRAY`
  variable (`bin/setupmgr` lines ~6798-6801, consumed at line ~6997 via
  `for app in ${ARRAY//,/ }; do eval "$0" "$app"; done`) that is NOT the
  same list as `SETUPMGR_ALL_TOOLS` and currently has only ~85 entries — it
  is missing `task`, `tig`, `tilt`, `tgpt`, `tldr`, `dnsglobe`, and
  `terminal-browser` (the tools fixed/added in a prior session), meaning
  `setupmgr all` silently skips them. Found incidentally while auditing the
  dispatch-case gap above; not fixed since it's a separate mechanism from
  both `SETUPMGR_ALL_TOOLS` and the completions/man-page sync.

- **`templates/scripts/functions/docker-entrypoint` lint findings** found
  while porting hardening fixes from the deployed
  `/usr/local/share/CasjaysDev/scripts` copy: (1) line 942 (`useradd`
  command in `__create_service_user`) is 200 chars, over the 180-char
  limit — needs breaking into a multi-line command; (2) many function-local
  variables are assigned without a `local` declaration (e.g. `result` in
  `__find()`, `ip4` in `__get_ip4()`, `pid` in `__get_pid()`, `var` in
  `__clean_variables()`, `no_exit_pid`, and others throughout the file) —
  needs an audit pass adding `local` to every bare in-function assignment.
  Both are pre-existing, unrelated to the hardening fixes just ported; too
  broad to fold into that commit.

## bin/setupmgr audit (202608272021-git) — package-manager violations, dead code, doc-sync drift

Follow-up audit after removing `podman` (same session, commit `82d1a719bda0` —
podman was misrepresented as a static-binary install but actually delegated
to `pkmgr install silent podman`). Scope: `bin/setupmgr`, `man/setupmgr.1`,
`completions/_setupmgr_completions.bash`. Read-only audit; nothing below is
fixed yet unless marked DONE.

- **Same violation as podman:**
  - `tig` — DONE (202608272117-git). Neither `tig` nor `entr` ships a
    prebuilt static binary upstream (verified against the GitHub releases
    API: tig's latest release is source-tarball-only, entr has no GitHub
    releases at all), so both were the same violation class as podman.
    Removed `__setup_tig`/`__setup_entr` entirely, removed the `tig)`
    dispatch case, and dropped both from `SETUPMGR_ALL_TOOLS`, the
    completions `ARRAY`, and the man page.
  - `entr` — DONE (202608272117-git), same commit as `tig` above.
  - `antigravity` (`__setup_antigravity`, `bin/setupmgr:6159-6248`) — GUI
    Electron IDE; on Debian-family hosts installs the `.deb` via
    `__sudo apt install -y`. Still latent (no dispatch case), NOT fixed —
    deferred, needs its own decision (unlike tig/entr it does at least
    download a real upstream artifact, just not a static binary).

- **Defensible exceptions, undocumented as such — NOT fixed:**
  `nix` (`bin/setupmgr:3804`, installs a real static installer binary but
  that binary sets up a system-wide multi-user daemon — inherent to what
  Nix is), `distrobox` (`bin/setupmgr:3238`, git-clones shell scripts, and
  is useless without podman/docker, which setupmgr no longer installs),
  `jekyll` (`bin/setupmgr:3665`, RubyGems + native `ffi` compile), `llm` /
  `aider` (`bin/setupmgr:5345`/`5366`, pipx/Python ecosystem),
  `terminal-browser` (`bin/setupmgr:5845`, bundled Electron app, but at
  least self-contained). Consider a short comment above each function
  noting why it's an intentional exception to the static-binary rule.

- **Two functions each defined twice — second silently wins — DONE
  (202608272117-git):**
  - `__setup_zed`: the dead first definition (Vulkan-gated, installed to
    `$ZED_INSTALL_DIR` as `zed-editor`) was deleted; kept the live,
    more-complete second definition (`__require_desktop`-gated, macOS +
    Linux, installs to `~/.local/share/zed`) and ported the missing Vulkan
    precondition check into it (Linux only, skipped on Darwin — Zed's GPU
    renderer needs Vulkan on Linux, Metal on macOS). Also fixed
    `__is_package_installed` and the `remove` case's zed probe path, both
    of which still pointed at the dead version's `$ZED_INSTALL_DIR`; both
    now check `$(__target_home)/.local/share/zed`, matching the live
    installer.
  - `__setup_lapce`: the dead first definition (plain archive
    download/`latest` redirect URL, no version pinning) was deleted; kept
    the live second definition (version-pinned via the GitHub releases
    API, `__require_desktop`-gated, macOS + Linux). No probe/remove case
    exists for lapce, so nothing else needed updating.

- **golang alias — DONE (202608272117-git), decided: prefer `go`, not
  `golang`, same treatment as `llama-cpp`/`llama_cpp`:** the install
  dispatch case (`bin/setupmgr:7069`, function `__setup_golang`) now
  accepts `go | golang)` so both spellings still install correctly, but
  `golang` was removed from every advertised surface — `SETUPMGR_ALL_TOOLS`,
  the man page's `golang` alias `.TP` entry, and the completions `ARRAY` —
  leaving `go` as the only publicly advertised name, matching how
  `llama-cpp`/`llama_cpp` was handled earlier this session.

- **`llama_cpp` (underscore) removed from `SETUPMGR_ALL_TOOLS` — DONE
  (202608272117-git):** replaced with `llama-cpp` in the same edit that
  added `go` to the list (it had been entirely missing from
  `SETUPMGR_ALL_TOOLS` before, a separate finding — see the four-way
  tool-list-drift item below, which still lists `go`/`llama-cpp` as gaps
  in that list; those two are now closed, the other 12 names in that gap
  list are still open).

- **`remove` listed as an installable tool, NOT fixed:** `bin/setupmgr:6768`
  and `completions/_setupmgr_completions.bash:62` include the subcommand
  name `remove` inside the install-list `ARRAY` that `setupmgr all` iterates
  (`bin/setupmgr:6963-6971`) — so `setupmgr all` runs `setupmgr remove` with
  no args mid-run. Harmless today only because `remove)`'s arg loop has
  nothing to consume.

- **Probe-name gaps, NOT fixed:** `difftastic` installs a binary named
  `difft`, but neither `__is_package_installed` nor `__remove_package`
  (`bin/setupmgr:2264-2275`, `2325-2336`) has a `difftastic) probe="difft"`
  entry — `setupmgr remove difftastic` / installed-check will report "not
  found" even after a real install. Currently masked since `difftastic` has
  no dispatch case (part of the 58-tool gap); becomes visible the moment
  that's fixed. Same class of gap likely applies to `nvm`/`rvm`/`gvm`,
  which install shell functions, not `PATH` binaries.

- **`ncdu` is fully orphaned, NOT fixed:** `__setup_ncdu`
  (`bin/setupmgr:5730`) has no dispatch case and appears in NO user-facing
  list (`--help`, `SETUPMGR_ALL_TOOLS`, `ARRAY`, man page, completions) —
  unreferenced dead code, not even part of the "advertised but missing"
  problem.

- **`configure` subcommand and `--configure` flag are both fully
  undocumented, NOT fixed:** `configure` (dispatch at `bin/setupmgr:7524`)
  is missing from `man/setupmgr.1` COMMANDS, from the completions `ARRAY`
  (never tab-completes), and from `__help`'s command list
  (`bin/setupmgr:317-320`). `--configure` (parsed at `bin/setupmgr:6852-6854`,
  in `LONGOPTS` at `6763`) is missing from `__help`'s options block
  (`381-390`), from the man page OPTIONS section, and from the completions
  `LONGOPTS` string.

- **`__help` missing 7 implemented flags, NOT fixed:** `--all`, `--system`,
  `--silent`, `--force`, `--dir`, `--reset-config`, `--completions` are all
  parsed (`bin/setupmgr:6857-6890`) and documented in the man page, but
  absent from `__help` (`bin/setupmgr:381-390`).

- **`--help` tool list missing 10 dispatchable tools, NOT fixed (was 11 —
  `tig` dropped from the count since it no longer exists as a tool):**
  `age`, `bottom`, `btop`, `dnsglobe`, `duf`, `task`, `terminal-browser`,
  `tgpt`, `tilt`, `tldr` install correctly but are absent from the
  `--help` listing (`bin/setupmgr:365-376`).

- **`ARRAY` (`setupmgr all`) missing ~32 dispatchable tools, updates/
  supersedes the older note above — NOT fixed (was ~33 — `tig` dropped
  from the count):** `bin/setupmgr:6766-6769` is what `setupmgr all`
  iterates (`6963-6971`); confirmed still missing `age`, `aider`, `atuin`,
  `bottom`, `broot`, `btop`, `cortex`, `ctop`, `dive`, `dnsglobe`,
  `droast`, `duf`, `gemini`, `hadolint`, `helix`, `hyperfine`, `k9s`,
  `localai`, `markdownlint`, `plandex`, `rustup`, `shellcheck`, `shfmt`,
  `task`, `terminal-browser`, `tgpt`, `tilt`, `tldr`, `vale`, `zellij`,
  `zig` (plus `dive`). `ARRAY` also feeds `__is_an_option`
  (`bin/setupmgr:396`), so this has knock-on effects beyond `setupmgr all`.

- **Four separate tool-list sources disagree with each other, NOT fixed
  (partially narrowed this session):** `SETUPMGR_ALL_TOOLS` (drives
  `setupmgr update`), the man page, completions `ARRAY`, and
  `bin/setupmgr`'s own `ARRAY` (~85 names, drives `setupmgr all`). No
  single list is authoritative. `go` and `llama-cpp` were added to
  `SETUPMGR_ALL_TOOLS` this session (202608272117-git, alongside removing
  `golang`/`llama_cpp`/`tig`/`entr`) closing 2 of the 14 names it was
  missing versus the man page; still missing: `claude`, `codex`, `copilot`,
  `cortex`, `distrobox`, `eslint`, `gemini`, `markdownlint`,
  `npm-check-updates`, `openclaw`, `prettier`, `vercel` — meaning
  `setupmgr update` never checks those for updates. Long-term fix is
  probably generating all four from one source list instead of four
  hand-maintained copies; too large to fold into this session.

## bin/setupmgr line-length lint finding — NOT fixed

`script-lint` pass (202608272121-git session) flagged `SETUPMGR_ALL_TOOLS`
(`bin/setupmgr:6514`) at 1002 characters, exceeding the 180-char line limit.
Pre-existing (the line was already this long before this session's edits
— only tool names within it changed). Fix is to break it into `ARRAY+=`
continuation lines the way `completions/_setupmgr_completions.bash`'s
`ARRAY` does; deferred because it's a single mechanical restructuring with
no behavior change, lower priority than the still-open dispatch-gap and
doc-drift items above, and would touch the same variable multiple other
open findings above also need to edit.

## bin/virt-check lint findings — DONE (202608230004-git)

All findings from the `script-lint` pass fixed: `requiresudo` renamed to
`__requiresudo`, `local exitCode` added to `__devnull()`/`__devnull2()`,
`local flags supports_v2 supports_v3 supports_v4` added to
`__cpu_version_check()`, the inline comment on `__help()`'s def line moved
above it, `--` added before every bare `grep`/`__grep` query across the
file, the stray-space ANSI-strip `sed` regex fixed in both `--no-color`
blocks, and the 3-line commented-out `requiresudo`/`cmd_exists`/
`am_i_online` dead-code block removed. One reported finding (`exit 3` in
`__cmd_exists`, line 92) was reviewed and found to be a false positive —
AI.md's exit-code rule only forbids codes outside `0–78`/`128–143`, and 3
is within that range, so no change was needed there.
