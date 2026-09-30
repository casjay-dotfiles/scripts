# TODO.AI.md

## bin/setupmgr / completions — 2 pre-existing lint findings, NOT fixed

Surfaced incidentally by `script-lint` while verifying this session's
setupmgr fixes; neither is on a changed line, out of scope for that work.

- `bin/setupmgr:7238`: `export FORCE_INSTALL="true"` — generic exported
  name crosses the process boundary; the script already carries
  `SETUPMGR_FORCE_INSTALL` alongside it, making `FORCE_INSTALL` a
  redundant unprefixed duplicate.
- `completions/_setupmgr_completions.bash`: header has
  `##@Version : 202609241759-git` but the file body has no `VERSION=`
  assignment at all — missing the required header/body pair.

## bin/setupmgr / completions / man page — CLEARED (202609301400-git)

Full backlog below resolved this session (user directive: fix in place,
no rewrite). Summary of what changed:

- `__setup_httpie` rewritten to install via `pipx install httpie`
  (matching the existing `__setup_llm`/`__setup_aider` pattern) instead of
  the broken `__install_from_archive` call — verified in a disposable
  Ubuntu container that `pipx install httpie` succeeds and provides
  `http`/`httpie`/`https`. IDEA.md's "binary/archive/npm/pip" install
  channel list sanctions this; no user decision needed.
- `__setup_ncdu` deleted entirely — verified via the GitHub releases API
  (in a container) that `rofl0r/ncdu` has zero releases, same defect
  class as the already-removed `tig`/`entr`/`wrk`.
- `__setup_antigravity`'s `apt install -y downloaded.deb` branch removed
  — same package-manager-delegation violation class as `podman`. The
  function's existing self-contained tarball install path is now the
  only Linux path (works on both x86_64/arm64; still `__require_desktop`
  gated).
- `remove` removed from `ARRAY` (was letting `setupmgr all` invoke
  `setupmgr remove` with no args mid-batch).
- All four tool-list sources (`SETUPMGR_ALL_TOOLS_DEFAULT`, `ARRAY`,
  `completions/_setupmgr_completions.bash`'s `ARRAY`, `man/setupmgr.1`'s
  package list) rebuilt from one canonical 166-tool list derived directly
  from the main dispatch `case` block (ground truth), then verified
  byte-for-word identical across all four with `diff`/`comm`. Man page's
  stale `dog`/`exa`/`htmlq`/`xsv` entries (already removed from the
  script in a prior session) dropped; `charm` added.
- `difftastic` probe fixed (`probe="difft"`, confirmed by downloading and
  running the real release asset in a container) in both
  `__is_package_installed`/`__remove_package`; `nvm`/`rvm`/`gvm`
  directory-based detection added to `__is_package_installed` (they
  install shell functions, not `PATH` binaries).
- `__help` rewritten: full 166-tool list, plus the 7 previously-missing
  flags (`--all`, `--system`, `--silent`, `--force`, `--dir`,
  `--reset-config`, `--completions`) and `--configure`.
- Short "intentional exception" comments added above `__setup_distrobox`,
  `__setup_jekyll`, `__setup_nix`, `__setup_terminal_browser` explaining
  why each is a defensible non-static-binary install.
- `printf_*`/`ask_for_password` unprefixed names: left as-is — confirmed
  still a deliberate, project-wide convention (see prior note), not a bug.
- `bash -n` passes; `awk 'length > 180'` returns zero across
  `bin/setupmgr`, `completions/_setupmgr_completions.bash`, and
  `man/setupmgr.1`.

Prior session history for this file (dispatch-case wiring, duplicate
function cleanup, `wrk`/`tig`/`entr` removal, the 13-defect functional
audit, the original line-length fix) is preserved in git log; superseded
by the cleared state above.

## templates/scripts/functions/docker-entrypoint lint findings — NOT fixed

Found while porting hardening fixes from the deployed
`/usr/local/share/CasjaysDev/scripts` copy: (1) line 942 (`useradd`
command in `__create_service_user`) is 200 chars, over the 180-char
limit — needs breaking into a multi-line command; (2) many function-local
variables are assigned without a `local` declaration (e.g. `result` in
`__find()`, `ip4` in `__get_ip4()`, `pid` in `__get_pid()`, `var` in
`__clean_variables()`, `no_exit_pid`, and others throughout the file) —
needs an audit pass adding `local` to every bare in-function assignment.
Both are pre-existing, unrelated to the hardening fixes just ported; too
broad to fold into that commit.

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

## bin/cloudflare script-lint findings (202608311331-git) — NOT fixed

script-lint review after fixing the confirmed `__devnull2` eval hang and
the ip.ifcfg.us HTML-response validation bug; out of scope for those
fixes:

- line 1293: bare `exit` with no code — use `exit 0`, `exit 1`, or
  `exit "$?"` to be explicit
- Interactive script (has `__help()` function) must support `-h` and
  `-v` short flags — add both to argument parser (currently only
  `--help`/`--version`; SHORTOPTS is empty on line 1024)

Not fixed this session — pre-existing, out of scope for the approved
hang-fix.

## bin/zellij-new — bring to tmux-new parity (migration project, in progress)

Goal: `bin/zellij-new` mirrors `bin/tmux-new`'s functionality and keybindings
(prefix `Ctrl Space`) as closely as zellij's architecture allows, so it can
become the daily-driver replacement for tmux-new. Full research/plan
produced and user-reviewed; decisions locked in below. Deferred plugin work
lives in `~/Projects/local/dfmgr/zellij/` (separate project, its own
TODO.AI.md/PLAN.AI.md), not in this repo.

Confirmed on this host: zellij 0.44.3, tmux 3.2a. Re-verify config/action
names against the installed version before writing KDL — some names below
are unconfirmed pending a follow-up `zellij action --help` full-output pass.

**User decisions locked in:**
- Status-bar git/weather/uptime live content: NOT built here — deferred to
  `~/Projects/local/dfmgr/zellij/` as a future WASM-plugin project.
- `--socket` flag: dropped entirely (no zellij equivalent to tmux `-L`).
- File-tree sidebar (tmux-sidebar equivalent): dropped here — deferred to
  the same `~/Projects/local/dfmgr/zellij/` plugin project.

### Standalone bugs in current zellij-new (fix first, independent of parity work)

- [ ] `zellij list-sessions -F '#{session_name}:#{session_path}'` (line
      438) — invalid flag; real flags are only `-n/--no-formatting
      -r/--reverse -s/--short`, no format-token syntax exists
- [ ] `__zellij_nested` (lines 778-858) — `set -g status off`,
      `send-keys -t`, `switch-client -t`, `new-session -d -s -c`, `-D -A`
      are all fabricated tmux-syntax, not real zellij CLI grammar; rewrite
      using verified real syntax (see CLI reference below)
- [ ] `templates/zellij/default.conf` referenced (script line 1130) does
      not exist on disk — silent `cp` failure every launch
- [ ] `__create_windows` always regenerates a bare
      `layout{ tab { pane command=X } }` with no `cwd`, no splits, no
      plugin/tab-bar panes, and never references the template file —
      zellij-new.kdl's keybinds/theme/options are never actually applied
- [ ] `$ARRAY` completions stale/wrong (`liskill` typo; missing
      ai/go/rust/python/devops/monitoring/database/switch/rename/status/
      clone/nested/update)
- [ ] `--exec weather`/`--exec uptime` cache keyed by `$$` (PID) — never
      actually cached across invocations
- [ ] `rename` subcommand is a stub (just prints instructions)
- [ ] `web` preset duplicates `server` with a copy-paste double-invoke bug

### Verified zellij 0.44.3 CLI reference (do not re-derive, use these)

```
zellij -s <name>                 # start new session named <name> (fails if exists)
zellij attach <name>             # attach to existing
zellij attach -c <name>          # attach, CREATE if it doesn't exist  <- create-or-attach
zellij attach -b <name>          # create detached in background if missing
zellij attach -f <name>          # if resurrecting, run captured commands immediately
zellij attach --forget <name>    # delete saved session state before connecting
zellij list-sessions -s -n       # parseable: short names, no color
zellij kill-session <name>
zellij kill-all-sessions
zellij delete-session -f <name>
zellij delete-all-sessions
zellij action <subcommand>       # send action to CURRENT session
zellij -n/--new-session-with-layout <layout>
zellij -l/--layout <layout>
```
No `-D`/`-A`/`-t`/`send-keys`/`switch-client`/`set -g` exist.

### Feature-parity implementation plan

- [ ] Named presets (ai/dev/go/rust/python/devops/monitoring/database/rpm/
      node/bun/deno/build/ssh/productivity/test/default/...): generate real
      per-preset KDL layouts under `templates/zellij/layouts/<preset>.kdl`
      with `cwd`, splits, `default_tab_template` for tab-bar/status-bar
      panes — replaces the current flat one-pane-per-tab generation
- [ ] Background autosave/state.txt mechanism: DROP entirely, do not port.
      Delegate to zellij's native continuous session-serialization instead
      — set `session_serialization true`, `pane_viewport_serialization`
      (or `scrollback_lines_to_serialize` for full scrollback), and
      `post_command_discovery_hook` (verify this key exists in 0.44.3
      before using it) in the config template
- [ ] `save`/`restore`/`boot`/`cleanup`/`apply-state-cmds` subcommands:
      rewrite as thin wrappers — `restore`/`boot` → `zellij attach -c
      <name>`, `save` → no-op (automatic), drop `apply-state-cmds`
      (no external plugin to hook into)
- [ ] tmux-resurrect/tmux-continuum/tpm: drop — native session
      serialization supersedes the plugins, and zellij has no plugin
      manager (plugins load directly as `.wasm` via `plugin location=`)
- [ ] Clipboard (tmux-yank/OSC-52 equivalent): zellij has native OSC-52 +
      `copy_command` fallback + `copy_on_select`. Set `copy_command` with
      the same runtime OS-detection (xclip/wl-copy/pbcopy) tmux-new's
      `new.conf` already does, OSC-52 as primary
- [ ] `list`/`attach`/`switch`/`rename`/`clone`/`status`/`kill [all]`/
      `clean` subcommands: rewrite against the verified CLI reference above
      (`zellij list-sessions -s -n`, `zellij attach -c`, `zellij
      kill-session`, `zellij kill-all-sessions`, `zellij delete-session -f`,
      `zellij delete-all-sessions`)
- [ ] `nested [name]`: needs its own small design pass — zellij's nested-
      session UX differs from tmux's (env var `ZELLIJ` detection); do not
      just port tmux syntax

### Keybinding layer (prefix Ctrl Space, mirror templates/tmux/new.conf)

Use zellij's built-in `tmux` keybind mode (default trigger `Ctrl b`) as the
base — rebind trigger to `Ctrl Space`, override individual bindings — rather
than hand-building a parallel prefix system from normal/pane/tab/resize
modes.

- [ ] Direct mappings confirmed, implement as-is: `d`→Detach,
      `n`/`p`→GoToNextTab/GoToPreviousTab, `1`-`9`→GoToTab N,
      `\`/`/`→NewPane Right/Down, arrows/`C-hjkl`→MoveFocus,
      `c`→NewTab, `+`→ToggleFocusFullscreen, `@`→CloseTab (no confirm
      prompt native — note as UX gap),
      `<`/`>`/`S-Left`/`S-Right`→MoveTab Left/Right (verify exact action
      spelling — was truncated in research capture)
- [ ] `Tab`→SwitchToMode "session" (session picker, closest to
      choose-tree -s)
- [ ] `?`→Run action opening `zellij-new --exec keybindings` (verify
      `Run`/`LaunchOrFocusPlugin` syntax during implementation)
- [ ] Resize mode: reuse existing resize mode from current
      zellij-new.kdl, entered via a bind inside tmux-mode (tmux-new has no
      resize-mode concept — document as closest-fit, not exact parity)
- [ ] **Needs a follow-up research pass before implementing** (run full
      untruncated `zellij action --help` first): `` ` `` last-window jump,
      `R` reload-config (live-reload may already exist, verify), `N`
      prompt-new-session-from-inside-session (likely needs a `Run`
      shell-out to `zellij-new`, not a pure keybind), `w` select-layout
      (zellij may have a native "swap layout" feature that replaces this
      concept rather than mapping 1:1), `s` sync-panes/toggle broadcast
      (no confirmed native action — likely a genuine gap), `C-p` broadcast
      to all panes (same gap as sync-panes), `J`/`B` join/break
      pane↔window (no confirmed native action — likely a genuine gap)

### Template files

- [ ] Rename `templates/zellij/zellij-new.kdl` → `templates/zellij/new.conf`
      (matches tmux-new's `default.conf`/`new.conf`/`simple.conf` naming),
      rewrite as config-only (options + keybinds + themes + ui)
- [ ] Create `templates/zellij/default.conf` (bootstrap variant, fixes the
      missing-file bug above)
- [ ] Create `templates/zellij/simple.conf` (minimal, no status/tab-bar
      plugin panes, parity with tmux-new's simple.conf)
- [ ] Create `templates/zellij/layouts/<preset>.kdl` per preset (or one
      parameterized template using `pane_template`) — this is what's
      currently missing entirely
- [ ] Carry over tmux-new's sed-based placeholder-substitution pattern into
      the zellij config template unchanged (script-level mechanism,
      independent of KDL vs tmux.conf syntax)

### Before implementation starts (do first)

- [ ] Run full untruncated `zellij action --help` and `zellij setup
      --dump-config` (or inspect `~/.config/zellij` if present) on this
      host to close the open keybinding research gaps above
- [ ] Verify `session_serialization`/`pane_viewport_serialization`/
      `post_command_discovery_hook` config keys actually exist in 0.44.3
      (web docs may lag/lead the installed version)

### Finish per project convention

- [ ] Update `--help`, `man/zellij-new.1`,
      `completions/_zellij-new_completions.bash` (Documentation Triple
      Sync) — already known out of sync even before this work
- [ ] Bump `##@Version`/`VERSION`, run `script-lint`, verify with `bash -n`
      before commit

## bin/screen-new — bring to tmux-new parity where genuinely possible (in progress)

Goal: mirror `bin/tmux-new`'s functionality/keybindings where GNU Screen
4.08.00 actually supports it. Unlike zellij-new, screen has **no plugin
system, no persistence API, no introspection API** — anything with no real
screen equivalent is DROPPED permanently and documented in `--help`, not
deferred to a future plugin project.

**Prerequisite fix (blocks everything else):** `bin/screen-new` currently
sources an external functions file
(`. "$SCRIPTSFUNCTDIR/testing.bash"`, ~line 49-62) and calls external-only
helpers (`user_install`, `__options`, `cmd_exists`, `ask_for_password`,
`run_server`, `run_options`, `notifications`) — violates AI.md
self-containment rule. Must inline the full printf_*/`__cmd_exists`/
`__gen_config`/getopt-loop suite (copy pattern from `bin/tmux-new` lines
50-353) before adding any new feature.

### Feature parity table — DROP entries are permanent, not deferred

| tmux-new feature | screen verdict |
|---|---|
| list/attach/kill/detach | KEEP (already implemented) |
| switch | ADD — detach current + attach target (no in-place switch, UX differs) |
| rename | ADD — `screen -X sessionname <new>`, direct port |
| clone | ADD DEGRADED — config-clone only, no live window/pane state clone |
| status/show | ADD DEGRADED — parse `screen -ls`, no multi-socket scoping |
| nested | DROP as separate subcommand — already covered by `escape ^N^N` passthrough |
| save/restore/apply-state-cmds/boot/cleanup | **DROP — permanent gap**, no persistence across reboot, no plugin host to build one on |
| 19 named presets (ai/dev/go/rust/python/...) | ADD — `screen -t <name> <idx> <cmd>` lines, direct port |
| create (custom config) | ADD — direct port, `screen -t` lines |
| update [template\|sessions\|all] | ADD — regenerate from templates/screen/new.conf |
| --exec git/weather/uptime | ADD — verbatim reuse of tmux-new's __exec_git/__exec_weather/__exec_uptime, wired via `backtick` |
| --exec keybindings | KEEP (already implemented) |
| tmux-resurrect/continuum + all TPM plugins (tilish/sidebar/prefix-highlight/online-status/pain-control/vim-navigator/simple-git-status/yank) | **DROP entirely — permanent gap**, no plugin loader exists |
| OSC-52 clipboard passthrough | ADD DEGRADED — not reliably supported in screen 4.08/4.09; explicit copy-out/paste-in binds via xclip/wl-copy/pbcopy pipe instead of transparent passthrough |
| mouse toggle | ADD DEGRADED — no toggle-query primitive; `m`=on / `M`=off pair instead of single toggle |
| pane sync (broadcast) | **DROP** — no broadcast-to-regions primitive |
| join/break pane↔window | **DROP** — no pane/window interconversion |
| send command to every pane | **DROP** — no `list-panes -a` equivalent |
| zoom pane | ADD DEGRADED — `only` (destructive, removes other regions, no toggle-back) |
| choose layout (tiled/even-h/...) | **DROP** — no named layout algorithms |
| sidebar file tree | **DROP** — plugin-only feature, no screen equivalent |
| mouse click/drag/dblclick/rightclick select/resize | **DROP** — not supported by screen at all; scroll-only mouse survives |

### Keybinding layer — prefix stays Ctrl+n, do NOT remap to Ctrl+Space

Ctrl+Space sends raw NUL in most terminals and screen's `escape xy` has no
named-key abstraction like tmux's `C-Space` — only literal control-char
notation. Keeping the existing, already-documented Ctrl+n prefix is a
deliberate, permanent deviation from tmux-new (flagged to user, not an
oversight).

- [ ] `d` detach, `t`/`c` new window, `n`/`p` next/prev, `,` rename,
      `@` kill window, digit keys select-window, Shift-Left/Right,
      `\`/`/` split, `x` kill pane/region — all already present, verify
      against tmux-new's binding set for exact parity
- [ ] Add `` ` `` → `other` (last window)
- [ ] Port arrow/vim pane-nav `bindkey` → `focus up/down/left/right`
      (recover from legacy templates/screen.conf lines 90-93)
- [ ] Add `+` → `only` (zoom, degraded)
- [ ] `[`/`]` copy/paste — already present, verify
- [ ] Add Ctrl+v → pipe wl-paste/xclip -o/pbpaste into buffer, `paste`
- [ ] Add `Y` → `writebuf` piped to wl-copy/xclip/pbcopy
- [ ] Add `m`/`M` mouse on/off pair (`mousetrack on`/`off`)
- [ ] Add `R` reload config — `eval "source ..." "echo reloaded"` using
      `$STY` for session name (screen sets this itself)
- [ ] `s`/`J`/`B`/`Ctrl-p`/`Ctrl-s`/`Ctrl-r`/`w` (layout) — **DROP, no
      binding**, do not attempt

### Template restructuring

- [ ] Create `templates/screen/new.conf` (master template, extracted from
      current `__screen-new_filerc` heredoc, ~lines 759-834 of
      bin/screen-new, plus updated keybinds/clipboard/status-bar
      backticks) with a local-override `source` line at the bottom
      (mirror templates/tmux/new.conf's local-override pattern)
- [ ] Create `templates/screen/simple.conf` (minimal: no backtick/
      hardstatus content, no clipboard binds)
- [x] ~~Delete `templates/screen.conf`~~ — CORRECTION: not dead code.
      `bin/scratchpad` (lines 394-401) still copies this exact file to
      `$SCRATCHPAD_HOME/screen.conf` and passes it to `screen -c`. The
      earlier "confirmed dead code" grep only checked bin/screen-new and
      bin/tmux-new, missing this cross-script reference. Left in place;
      not this migration's file to touch — bin/scratchpad is out of scope.
- [ ] Add `__create_screen_conf` mirroring tmux-new's
      `__create_tmux_conf` (copy templates/screen/new.conf to
      `$SCREEN_NEW_CONFIG_DIR/template` on first run if missing)

### Finish per project convention

- [ ] Add explicit "Known limitations vs tmux-new" block to `--help`
      (and/or README) itemizing every DROP row above as a permanent,
      documented gap — required since screen has no plugin escape hatch
- [ ] Update `--help`, `man/screen-new.1`,
      `completions/_screen-new_completions.bash` (Documentation Triple
      Sync) for every new subcommand/flag
- [ ] Bump `##@Version`/`VERSION`, run `script-lint`, verify with `bash -n`
      before commit

## Implementation order across both migration projects

1. bin/zellij-new: standalone bugs first, then feature-parity rewrite,
   then keybindings, then templates
2. bin/screen-new: self-containment fix first (blocks everything else),
   then feature-parity rewrite, then keybindings, then templates
3. Both: doc-sync (help/man/completions) run at the very end for both
   scripts before final commit, per explicit user instruction

## Pre-existing `script-lint` violations found 2026-09-13 (centos->rhel rename sweep)

Surfaced incidentally while updating hardcoded `casjay-base/centos`/
`pkmgr/centos` URLs to `casjay-base/rhel`/`pkmgr/rhel` — confirmed via
`git diff` that these predate this edit (only the URL lines changed).
Re-run `script-lint` for exact current line numbers before fixing.

- [ ] `bin/pkmgr`: ~47 pre-existing violations (grep missing `--`,
      inline comments, bare `exit`)
- [ ] `templates/scripts/os/centos.sh`: ~30 pre-existing violations
      (grep missing `--`, naming)
- [ ] `templates/scripts/os/{debian,fedora,macos,void}.sh`: ~13
      pre-existing violations each (grep missing `--`, template
      functions missing `__` prefix: `run_post`, `system_service_exists`,
      `system_service_enable`, `system_service_disable`,
      `detect_selinux`, `disable_selinux`, `grab_remote_file`,
      `run_external`, `retrieve_version_file`, `run_grub`, `test_pkg`,
      `remove_pkg`, `install_pkg`)

## Pre-existing `script-lint` violations found 2026-09-17 (ISO-URL accuracy fix)

Surfaced incidentally while fixing stale/broken ISO URLs in
`bin/latest-iso` (omnios, artix, endeavour, openbsd, openindiana,
slackware) — confirmed via `script-lint` that these predate the diff.

- [ ] `bin/latest-iso`: 9 pre-existing naming violations — the
      `printf_*` suite (`printf_newline`, `printf_blue`, `printf_red`,
      `printf_green`, `printf_cyan`, `printf_yellow`, `printf_purple`,
      `printf_error`, `printf_exit`, lines 120-128) is missing the `__`
      prefix. Matches the established repo-wide `printf_*` naming
      convention (AI.md's inline `printf_*` suite template), so any fix
      needs a coordinated rename across every script that defines/calls
      these, not a one-off change here.
