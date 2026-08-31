# TODO.AI.md

## bin/setupmgr / completions / man page

- **`script-lint` findings, NOT fixed (all pre-existing, out of scope for
  the small `wrk`-removal diff that triggered this lint pass — that diff
  only touched the `SETUPMGR_ALL_TOOLS` line, version headers, and
  changelog lines).** `bin/setupmgr`: 90 issues — 60 `grep` calls missing
  the `--` separator before the query (lines include 90, 342, 407, 423,
  569, 623, 625, 627, 633, 659-673, 732, 876-951, 1004, 1110, 1177,
  1191-1560, 5599-5615) and 21 inline comments that should be moved above
  the code they describe (lines 1212-1213, 1842, 1902-1904, 1954,
  1996-1998, 2071-2076, 2133-2140, 2205-2206, 5510-5512, 6904, 6915).
  `completions/_setupmgr_completions.bash`: 3 more `grep --` violations
  (lines 32, 34, 37). Needs its own dedicated cleanup pass (large,
  mechanical, file-wide — not folded into an unrelated commit).

- **`script-lint` finding, NOT fixed (pre-existing, out of scope for this
  session's edit):** `SETUPMGR_ALL_TOOLS="${SETUPMGR_ALL_TOOLS:-...}"`
  (currently line 6591) is a single line >180 chars (~1002 chars) — the
  AI.md line-length rule requires splitting. Predates this session; not
  touched by the `__setup_*`-functions diff, so left alone per
  working-set discipline. Needs its own mechanical fix (e.g. multi-line
  `+=` continuation) in a dedicated commit.

- **`__setup_httpie` is broken — wrong distribution channel, NOT fixed.**
  Verified via GitHub API: `httpie/cli`'s latest release (`3.2.4`) ships
  **zero release assets** — HTTPie is distributed via PyPI (`pip install
  httpie`), not GitHub binary releases, so `__install_from_archive` will
  always fail with "Could not find latest release asset for linux/amd64".
  Pre-existing bug (function predates this session); only just became
  reachable when its dispatch case was wired up (202608281340-git). No
  `__install_from_pip`/`__install_from_pipx` helper exists in this file, so
  fixing this needs either a new pip-based install helper (raises the
  static-binary-only design question the same way `antigravity`'s apt
  fallback did) or dropping `httpie` from `SETUPMGR_ALL_TOOLS` — a decision
  for the user, not a mechanical fix.

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

- DONE (this session): wrote 19 new `__setup_*` functions (`ali`,
  `bombardier`, `buf`, `curlie`, `dog`, `dua`, `earthly`, `evans`, `eza`,
  `fx`, `ghz`, `grpcurl`, `jq`, `k6`, `lsd`, `oha`, `vegeta`, `sops`,
  `tabby`) plus their main-dispatch-loop case arms, and added direct
  `__execute_npm`-based case arms (no wrapper function, matching the
  `cortex`/`gemini` precedent) for `cody` (`@sourcegraph/cody`) and
  `continue` (`@continuedev/cli`). Every GitHub repo/asset name/npm package
  was verified directly against the GitHub releases API / npm registry, not
  trusted from research-agent output. Six of the new functions needed a
  custom arch-aware asset pattern (following the `__setup_fnm` precedent)
  because the generic `__build_asset_pattern` os/arch matcher would have
  been ambiguous or wrong: `buf` (sibling `protoc-gen-buf-*` assets share
  the same `Linux-<arch>.tar.gz` substring), `eza`/`lsd` (musl-build
  siblings share the same arch substring as the gnu build), `oha` (a
  `-pgo` sibling build), `sops` (an `.spdx.sbom.json` sidecar), and
  `tabby` (`manylinux` naming breaks the generic linux/gnu substring
  match; only the verified x86_64 CPU build is supported, others error
  clearly). Also fixed a real bug surfaced along the way:
  `__configure_continue` checked `__cmd_exists continue`, but
  `@continuedev/cli`'s actual shipped binary (per its npm `bin` field) is
  `cn`, not `continue` — corrected to check `cn`.

  DONE (this session): `wrk` decided and resolved — user directive: never
  source build, matching the `tig`/`entr`/`podman` precedent (see Session
  History in AI.md). `wrk/wrk`'s releases have zero release assets on any
  release (source-build-only, no prebuilt binaries), so it could never get
  a real `__setup_wrk` via this codebase's download-and-install mechanism
  and a source-build helper is explicitly off the table. Removed `wrk`
  from `SETUPMGR_ALL_TOOLS` (`bin/setupmgr`),
  `completions/_setupmgr_completions.bash`'s `ARRAY`, and
  `man/setupmgr.1`'s HTTP/Load Testing Tools section.

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

## bin/setupmgr line-length lint finding — DONE

`script-lint` pass (202608272121-git session) flagged `SETUPMGR_ALL_TOOLS`
(`bin/setupmgr:6514`) at 1002 characters, exceeding the 180-char line limit.
Fixed by rebuilding it as `SETUPMGR_ALL_TOOLS_DEFAULT=""` plus chunked
`SETUPMGR_ALL_TOOLS_DEFAULT+="..."` continuation lines (each ≤180 chars),
matching the pattern already used by `completions/_setupmgr_completions.bash`'s
`ARRAY`/`LONGOPTS`. Verified byte-for-word identical to the original list:
153/153 tool names, same order. This same cleanup pass also fixed all other
real `script-lint` findings across `bin/setupmgr` and
`completions/_setupmgr_completions.bash`: missing `grep -- ` separators,
inline trailing comments moved above their code, bare `return` statements
in `__target_home()` given explicit `return 0` codes, remaining >180-char
lines split (archive-extraction `case` arms, `__get_version` probes,
GitHub-release URL pipelines), and `requiresudo` renamed to
`__requiresudo` for the missing `__` prefix.

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

## cp_rf / __cp_rf inconsistency audit (this session) — NOT fixed

User asked to check for cp/rsync usage inconsistencies after discussing
`cp -Rfa` vs `rsync` for `cp_rf`. Full survey via researcher agent found the
helper is defined **13 times across 12 files, in 2 name variants, with 4
divergent flag/behavior combinations** — no single canonical version:

- `cp -Rfa` + `[ -e "$1" ]` guard + `"$@"` + `return 1` on failure:
  `templates/scripts/installers/{desktopmgr,devenvmgr,dfmgr,hakmgr,systemmgr}.sh:110`
  (all identical — the "canonical" one).
- `cp -Rf` (no `-a`) + `"$@"`, no existence guard: `bin/latest-releases:327`,
  `bin/randomwallpaper:232-235`.
- `cp -Rf` (no `-a`) + guard, but hardcoded `"$1" "$2"` instead of `"$@"`
  (breaks on 3+ args): `functions/minimal.bash:916-920`,
  `functions/global/os.bash:293-297` — both also swallow cp failure as
  `return 0` instead of propagating it.
- `sudo cp -Rf "$@"`, no guard, no output redirect: `bin/pkmgr:576`.
- Unprefixed `cp_rf` (no `__`) using `cp -Rfa` + `devnull` wrapper:
  `functions/mgr-installers.bash:595`, `functions/app-installer.bash:614`
  (both `else return 0` on missing source), `functions/system-installer.bash:295`
  (same but missing the `else return 0` arm). Root `install.sh` calls bare
  `cp_rf` (lines 178, 183) and depends on one of these three unprefixed
  definitions being sourced in — it defines none of its own.

Also found:
- **Raw `cp` bypassing the helper convention:** `install.sh:190` —
  `cp -Rf "$f" "/root/.local/backups/systemmgr/installer/pam/...bak"` in
  the same file that otherwise routes through `cp_rf`.
- **No shared `rsync_*` wrapper exists anywhere.** Raw, ad hoc `rsync`
  calls with inconsistent flags (`-a`, `-avhP`, `-aq`,
  `-ah --delete-after`, `--partial --inplace`, `--list-only`, etc.) appear
  directly in `bin/composemgr`, `bin/dockermgr`, `bin/virtmgr`,
  `bin/acme-cli`, `bin/update-lecerts`, `bin/latest-iso`,
  `bin/latest-releases`, `bin/gen-script`, `bin/config`, `bin/setupmgr`,
  `templates/scripts/other/docker-entrypoint`,
  `templates/scripts/installers/{personal,dockermgr}.sh`.
  `bin/latest-iso`'s `__rsync_list`/`__rsync_find_latest_version`/
  `__rsync_get_filesize`/`__rsync_download` are ISO-mirror-specific
  listing/download utilities, not a generic copy helper — not reusable
  as-is for a general `rsync_update`.
- Sibling `~/Projects/github/*/*/install.sh` templates (`dockermgr`,
  `templatemgr`, `casjay-dotfiles/server`, `casjay-dotfiles/minimal`, etc.)
  don't use any `cp_rf` helper at all — raw, inconsistent `cp -Rf`/
  `cp -Rfa` calls inlined directly, mixed within the same file in two
  cases (`casjay-dotfiles/server/install.sh`, `casjay-dotfiles/minimal/install.sh`).

**Per-user instruction: do NOT rename any of these functions** (`cp_rf`,
`__cp_rf`, or any other) — renaming would break every script/project in
`~/Projects/github/**` that calls them by their current name. Any future
fix must converge behavior (flags, guard, `"$@"` support, failure
semantics) without changing any existing function name. Not fixed this
session — flagged only, per user's read-only request. Decision on adding
a shared `rsync_update` function is still open (see conversation).

## bin/buildx lint findings (202608301128-git) — NOT fixed

script-lint found 13 pre-existing convention violations in `bin/buildx`,
discovered while removing an unrelated credential-helper warning (none
of these were introduced by that removal):

- Naming: `printf_column` (line 131) and `printf_color` (lines 132, 134)
  missing required `__` prefix
- Missing `--` before the query on 4 `grep` calls: line 106
  (`grep -qi 'server:.*cloudflare'`), line 701 (`grep '^Error log: '`),
  line 810 (`grep -E 'latest|edge|rolling'`), line 811
  (`grep -Ev 'latest|edge|rolling|[0-9]'`)
- Bare `return` (no explicit code) at lines 476, 491, 502, 667 — should
  be `return 0` for clarity
- Triple-sync gap: `man/buildx.1` and
  `completions/_buildx_completions.bash` do not exist for this
  bin-installed script

Not fixed this session — out of scope for the credential-helper warning
removal the user actually asked for.

## bin/sshto + bin/myssh review findings (202608311102-git) — NOT fixed

code-reviewer review of both scripts, prompted by the user; the HIGH and
MEDIUM findings (eval injection, path traversal, config typo, unquoted
vars, retry-loop busy-wait, arg-parsing bug) plus the AI.md-documented
printf_color regex bug were fixed and committed (`5fe3c3f2a7ed`,
`901bf9e5122d`). These LOW/convention/dead-code findings were out of the
approved fix scope and remain outstanding in both files:

- Naming: several helper functions missing the required `__` prefix
- Missing `--` before the query on some `grep` calls
- `bin/sshto`: dead `__devnull2` function, never called
- `bin/sshto`: dead duplicated sudo subsystem block
- `bin/sshto`: dead commented-out "directory from args" block
- Trailing inline comments in both files (project convention requires
  comments above the line, never inline)
- One line exceeding the 180-char limit

Not fixed this session — out of scope for the approved HIGH/MEDIUM fix
list.
