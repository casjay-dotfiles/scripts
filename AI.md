# AI.md — HOW

This file answers **how** things are done in this project. It is **read-only** — edit only for policy-level changes, not per-task edits.
Rules and communication behavior: see the global user rules file (`~/.claude/CLAUDE.md`).
What the project is: see `IDEA.md`.

---

## Project File Roles

| File | Role | Mutable during work? |
|------|------|----------------------|
| **AI.md** | THE HOW — implementation spec, source of truth | No (policy changes only) |
| **IDEA.md** | THE WHAT — project plan (description, variables, business logic) | Yes |
| **CLAUDE.md** | Short loader — points at AI.md and IDEA.md, no spec content | No |
| **TODO.AI.md** | AI-owned task list; completed items are REMOVED, not marked | Yes |
| **TODO.md** | Human-owned task list; AI marks done, never deletes entries | Limited |
| **PLAN.AI.md** | AI-owned implementation plan | Yes |
| **PLAN.md** | Human-owned plan; mark done when complete, never rewrite wholesale | Limited |

**If AI.md and IDEA.md conflict, AI.md wins. Fix IDEA.md.**

---

## Session Startup Checklist

Every session, in order:

1. Sync `{project_dir}` with the remote:
   - `git status --porcelain` — check for uncommitted changes
   - If dirty: `git stash push -m "session-start auto-stash"`
   - `git pull`
   - If stashed: `git stash pop`
   - If `stash pop` conflicts: report conflicting files and wait — never auto-resolve
   - If pull fails (no remote, offline, diverged): report it and wait
2. Read `IDEA.md` — understand what the project is
3. Read this file (`AI.md`) — understand how to work
4. Check `TODO.AI.md` if it exists — resume in-flight tasks
5. `git status` + `git log -5` — current working tree state

**Compliance schedule:** re-read relevant parts before each task; verify against spec every 3–5 changes; full compliance check before task completion.

---

## AI Behavior & Autonomy

- Read files, run `bash -n`, check `git status`, run `--help` — do these without asking
- `?` at end of a message = question; answer or clarify, do not execute
- A message ending in `?` that contains an action verb is still a question — answer it; only act if the user re-sends without `?` or says "yes" / "do it" / "go ahead"
- Action commands ("fix all issues", "run the tests") → execute fully without step-by-step confirmation
- "Run X" pre-authorizes X and its entire workflow (subcommands, loops, retries, pipes) for this session
- Do not expand scope beyond what was asked; note related issues, do not fix them
- When 2+ tasks are given, populate `TODO.AI.md` immediately
- **Plan mode for genuine ambiguity only** — not for file count; mechanical changes across many files do not need a plan

### Task Dependency Ordering

Dependency graph takes priority over label order. Numbered/lettered sequence is a tiebreaker only.
- Scan any task list for stated dependencies before starting; topological-sort the graph
- A task is only "ready" when all its prerequisites are complete
- For non-trivial graphs (3+ dependencies), document the resolved order at the top of `TODO.AI.md` or `PLAN.AI.md`

---

## Understanding User Intent

- `{name}` in a command or path = placeholder to substitute
- `name` without braces = literal text
- "We are working on X" = sets the active working set until user redirects
- "We are moving to Y" / "we need to fix Z" = redirect

---

## Verification & Safety

- Confirm before: `rm -rf`, force pushes, dropping branches, anything irreversible
- **Never run unrequested destructive ops, even to "fix"** — stop and ask
- **Never auto-bypass a hook block** — if a PreToolUse hook returns `BLOCKED:`, tell the user; only they decide
- Verify APIs/flags exist before using them; run code before calling it done; iterate until verification passes
- **kill scoping** — `kill $PID` only when `$PID` was captured at launch in the current task (`PID=$!`)
- **systemctl gate** — `status`/`is-active`/`is-enabled`/`cat`/`show` and `--user` variants are always OK; `restart`/`stop`/`start`/`reload`/`disable`/`enable`/`mask` on host services require user confirmation

---

## Self-Validation

- **Verify against ground truth** — logic: compare to expected output; data: spot-check a sample
- **Iterate until passing** — do not stop at "compiles"; keep going until success criteria are met
- **Define success up front** — before non-trivial work, state what "done" looks like
- **Add tests for new behavior** — add a test that fails before and passes after, then run it
- **One run, then fix** — do not loop on flaky failures without a hypothesis

---

## Output Rules

- No preamble, no reflexive agreement, no closing recap
- **Tight output budget** — status updates: 1–3 sentences max; no headers/bullets unless the task requires structured output
- Show diffs, not prose retellings of changes
- No emojis in code or inline tool output unless asked; emojis are appropriate in READMEs, docs, and commit messages
- **No AI attribution** — no `Co-Authored-By:`, AI-tool trailers, or "Generated with X" footers anywhere
- Next step is clear → do it; pause only for genuine blockers or destructive-op confirmation

---

## Agent Usage & Token Discipline

- **Explorer subagent for broad searches** — 3+ files, unknown locations, or multiple naming conventions
- **Read files narrowly** — files >500 lines: use `offset`/`limit` or grep first; never load 2000 lines for 50
- **No speculative reads** — only read files the current task directly requires
- **Don't re-read after editing** — exception: re-read `COMMIT_MESS` once before `gitcommit` to verify it matches the diff
- **Don't spawn agents for small tasks** — 2–3 direct tool calls: do it inline
- **Haiku for trivial tasks** — renames, single-line edits, simple lookups, mechanical refactors
- **Agents never commit** — agents edit and report back; main instance reviews the diff, writes `COMMIT_MESS`, runs `gitcommit`

---

## Git & Commit Workflow

### The only commit path

```bash
# 1. Check what changed
git status --porcelain
git diff --stat

# 2. Run syntax check + lint gate
bash -n bin/{script}
script-lint bin/{script}

# 3. Write the commit message
cat > .git/COMMIT_MESS << 'EOF'
{emoji} {subject} — ≤64 chars total {emoji}

{body: what and why, not how}

- {path}: {one-line description of change}
EOF

# 4. Commit + push (absolute path required for --dir)
gitcommit --dir /absolute/path/to/project all
```

`gitcommit` signs, commits, and pushes in one shot. The wrapper deletes `COMMIT_MESS` on success. Push is immediate and irreversible — use `touch .no_push` at repo root (confirm with user first) to skip.

**Key behavior:** when `.git/COMMIT_MESS` exists, `gitcommit` stages ALL changed files regardless of subcommand. Use `all` as the standard subcommand.

### Test & lint gates

- **Syntax gate:** `bash -n bin/{script}` — must pass before every commit
- **Lint gate:** `script-lint bin/{script}` — never commit with violations
- If `script-lint` is absent: run `bash -n` as minimum; shellcheck when available

### Subcommand reference

| Subcommand | Effect |
|---|---|
| `all` | stage everything + commit using COMMIT_MESS |
| `push` | push without committing (no COMMIT_MESS needed) |

### Forbidden

- `git commit` — skips signing
- `git push` — use `gitcommit push` instead
- `-m`/`--message` flag — always use COMMIT_MESS
- `gitcommit ai` / `gitcommit random` / `gitcommit custom` — bypass message file

### Commit message format

```
{emoji} {subject} — ≤64 chars total {emoji}

{body: what and why, not how}

- {path}: {one-line description of change}
```

Emoji map: ✨ feat · 🐛 fix · 📝 docs · 🎨 style · ♻️ refactor · ⚡ perf
           ✅ test · 🔧 chore · 🔒 security · 🗑️ remove · 🚀 deploy · 📦 deps

One logical change per commit. Unrelated changes → separate commits.
Never commit mid-task with files in an inconsistent state.

---

## Script Header Template

The separator line is exactly 24 dashes: `# - - - - - - - - - - - - - - - - - - - - - - - -`
Used between every logical block, including after the shellcheck disable line.

```bash
#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  YYYYMMDDHHMM-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  {scriptname} --help
# @@Copyright        :  Copyright: (c) {year} Jason Hempstead, Casjays Developments
# @@Created          :  {Weekday, Month DD, YYYY HH:MM TZ}
# @@File             :  {file_name}
# @@Description      :  {short one-sentence description}
# @@Changelog        :  {short one-sentence changelog message}
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  bash/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="${0##*/}"
VERSION="YYYYMMDDHHMM-git"
```

- `##@Version` uses **double `#`** — all other `@@` fields use single `#`
- `@@Created` — full weekday + date + time + timezone: `Wednesday, May 13, 2026 10:58 EDT`
- Separator line after shellcheck disable IS required
- `VERSION=` must stay in sync with `##@Version` header — bump both on every change

### Shell-specific differences

| Item | bash | sh | zsh | fish |
|------|------|----|-----|------|
| shellcheck shell | `# shellcheck shell=bash` | `# shellcheck shell=sh` | *(omit)* | *(omit)* |
| shellcheck disable | canonical SC set (see above) | same as bash | `# shellcheck disable=all` | *(omit entire line)* |
| `APPNAME` | `"${0##*/}"` | `"${0##*/}"` | `"${0:t}"` | `(path basename (status filename))` |
| `SCRIPT_SRC_DIR` | `"${BASH_SOURCE%/*}"` | `"$(dirname -- "$0")"` | `"${0:A:h}"` | `(path dirname (status filename))` |
| vim modeline filetype | `filetype=sh` | `filetype=sh` | `filetype=zsh` | `filetype=fish` |

**Vim modeline** — always the last line of the file:
```
# ex: ts=2 sw=2 et filetype=sh
```

---

## Shell Selection

| Target | Shell |
|--------|-------|
| macOS + Linux + BSD (cross-platform) | `#!/usr/bin/env sh` |
| Linux-only or bash required | `#!/usr/bin/env bash` |
| Zsh / oh-my-zsh context | `#!/usr/bin/env zsh` |
| Fish environment | `#!/usr/bin/env fish` |

Use the shell's native idioms fully. The shebang or extension determines which conventions apply — always check before editing.

---

## Code Standards

### File operations & paths

- **`cd` always uses absolute paths** in scripts, Makefiles, CI steps, and Claude's own Bash tool calls
- **External commands always use `\command`** — bypass aliases, call the real binary (`\grep`, `\curl`, `\rm`)
- **Read current file state before any edit** — never edit from memory
- **Working-set discipline** — scope is set when the user names files/dirs; never expand on your own initiative. Exception: spelling/grammar fixes in files already being edited
- **Fix completeness** — when a pattern changes, find and fix ALL instances across the working set with `grep -rn` before committing
- **Search before write** — search all candidate locations before adding a value; replace in place if found, only create/append if not
- **Create parent directories before writing** — `mkdir -p "$(dirname -- "$f")"` in shell

### Code quality

- **No partially implemented code** — every committed line must work as written; no stubs, no `TODO` placeholders inside logic
- **No TODO/FIXME/HACK in committed code**
- **No commented-out code** — delete it; git history preserves it if needed
- **Spelling & grammar** — always fix clear spelling and grammar errors in any file being edited; never alter technical terms or domain-specific names

### Comments

- Always **above** the code they describe — NEVER inline at end of line
- Single line, ≤180 characters
- Describe WHY not WHAT
- **Comments are never valid in:** JSON files · `.env`/`app.env`/`default.env` KEY=VALUE files · CSV/TSV · binary/compiled artifacts

### Naming

- Functions: `__` prefix — `__my_function` (no exceptions)
- Variables: `{SCRIPTNAME}_` prefix in uppercase — `MYAPP_TIMEOUT`
- Local variables: `local varname` inside functions
- Well-known globals exempt from prefix: `VERSION`, `APPNAME`, `RUN_USER`, `USER`, `HOME`, `PATH`, `PWD`
- Always use `_` — never `-` in variable or function names

### Versioning

- Format: `YYYYMMDDHHMM-git`
- Locations: `##@Version` header line AND `VERSION=` variable — bump both on every change
- Templates contain `GEN_SCRIPT_REPLACE_VERSION` — leave those alone

### Shellcheck disable

Single combined line, full canonical set — never split across multiple lines:

```bash
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
```

### Control flow

- Use `if/elif/else` — **never** `&&`/`||` chains for logic flow
- `&&`/`||` acceptable only for one-liner guards (`command || return 1`)
- Always add a newline at end of file

### Line length

- ≤180 characters: write on a single line, including pipelines
- >180 characters, or contains a multi-line embedded program (awk/sed script): split

---

## Exit Codes

Use standard POSIX and sysexits codes — never invent custom schemes.

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | General error |
| `2` | Misuse — bad arguments, unknown flag |
| `64` | EX_USAGE — wrong number of args or invalid flag |
| `65` | EX_DATAERR — input data malformed |
| `66` | EX_NOINPUT — input file not found |
| `69` | EX_UNAVAILABLE — required service unavailable |
| `70` | EX_SOFTWARE — internal software error |
| `77` | EX_NOPERM — insufficient permissions |
| `78` | EX_CONFIG — configuration error |
| `130` | 128+SIGINT — Ctrl-C |
| `137` | 128+SIGKILL — forced kill |
| `143` | 128+SIGTERM — graceful shutdown |

- `--help` and `--version` always exit `0`
- Never use exit codes outside `0–78` or `128–143` for script errors

---

## CLI Flags

### Standard flags (all interactive scripts)

| Flag | Short | Behavior |
|------|-------|----------|
| `--help` | `-h` | Print help and exit 0 |
| `--version` | `-v` | Print version and exit 0 |
| `--debug` | *(none)* | Enable debug output |
| `--no-color` | *(none)* | Disable color output |
| `--silent` | *(none)* | Suppress non-error output |
| `--config` | *(none)* | Generate user config file |
| `--options` | *(none)* | List all available options |
| `--completions` | *(none)* | Output completion data |

`--help` and `--version` must never require root/sudo.

### Argument parsing — bash getopt pattern

```bash
LONGOPTS="completions:,config,debug,dir:,help,options,no-color,version,silent"
setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "$APPNAME" -- "$@" 2>/dev/null)
eval set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in
  --help)     shift 1; __help; exit $? ;;
  --version)  shift 1; __version; exit $? ;;
  --debug)    shift 1; set -xo pipefail; export SCRIPT_OPTS="--debug" ;;
  --no-color) shift 1; export SHOW_RAW="true"; ... ;;
  --dir)      CWD_IS_SET="TRUE"; APPNAME_CWD="$2"; shift 2 ;;
  --)         shift 1; break ;;
  esac
done
```

`getopt` normalizes both `--flag value` and `--flag=value` automatically.

**Every flag handled in `case` must also appear in `LONGOPTS` (or `SHORTOPTS`).** A flag absent from `LONGOPTS` is silently dropped by `getopt` — a common source of broken flags.

---

## Bash Performance — No UUOC, Minimize Forks

Every `$(...)`, pipe, and external command spawns a subprocess. Prefer bash builtins.

### File reading

```bash
# BAD:  contents="$(cat file)"  /  cat file | grep pattern
# GOOD: contents="$(< file)"   /  grep -- pattern file
```

### Path manipulation

```bash
name="${path##*/}"      # basename — NOT $(basename "$path")
dir="${path%/*}"        # dirname  — NOT $(dirname "$path")
stem="${name%.ext}"     # strip extension
```

### String matching

```bash
# BAD:  if echo "$var" | grep -q "pattern"; then
# GOOD: if [[ "$var" == *"pattern"* ]]; then
```

### Regex

```bash
if [[ "$url" =~ ^(https?):// ]]; then
  protocol="${BASH_REMATCH[1]}"
fi
```

### Splitting and parsing

```bash
# BAD:  echo "$ver" | cut -d. -f1       /  cat /proc/loadavg | awk '{print $1}'
# GOOD: "${ver%%.*}"                     /  read -r load1 _ _ _ _ < /proc/loadavg
```

### Stdin passthrough

```bash
# BAD:  cat - | sed 's/x/y/'
# GOOD: sed 's/x/y/'
```

### grep — always use `--` separator

```bash
# BAD:  grep -r "pattern" file   /  grep "pattern" file
# GOOD: grep -r -- "pattern" file
```

`--` prevents a query starting with `-` from being misinterpreted as a flag. Apply to every `grep` call without exception. Never use `egrep`, `fgrep`, `rgrep` — use `grep -E`, `grep -F`, `grep -r`.

---

## ANSI Color and tput

**New code:** use ANSI escape sequences directly via `printf` — do not call `tput` ad-hoc outside the established `printf_color` block, because `tput` forks a subprocess per call.

| Prefer | Avoid |
|--------|-------|
| `printf '\e[0m'` | `tput sgr0` |
| `printf '\e[31m'` | `tput setaf 1` |
| `printf '\e[2J\e[H'` | `tput clear` |

**Established exception:** the `printf_color` function in existing scripts calls `tput setaf`/`tput sgr0` — this is accepted template boilerplate and is not changed in migration. Do not introduce new ad-hoc `tput` calls outside of `printf_color`.

Color/cursor sequences must be suppressed when `NO_COLOR` is set or `--no-color` is passed.

### TUI alt buffer

TUI scripts (interactive menus, full-screen output) must use the alternate screen buffer:

```bash
printf '\e[?1049h\e[5 q'               # enter alt buffer + blinking cursor
trap 'printf "\e[?1049l\e[0 q"' EXIT   # restore on exit (set BEFORE entering)
```

Non-TUI scripts (one-shot output, batch) must NOT enter the alt buffer.

---

## Self-Contained Scripts

Scripts in `bin/` are fully self-contained — no external functions file dependency.

- Must inline the full `printf_color` + `printf_*` block
- Must define all `__` helper functions they use
- Never `source` or `.` an external functions library

### Function inclusion rules

Only inline functions the script actually calls. Audit by grep — never rely on the `@@sudo/root` header (may be stale).

- **Sudo functions** (`requiresudo`, `__sudo`, `__sudorun`, `__sudoif`, `__can_i_sudo`, `__sudoask`, `__sudo_group`, `__user_is_root`, `__user_is_not_root`): include only if the script body actually calls them
- **Installer helpers** (`user_install`, `__options`): never include — they belong to the external functions library

### External → internal function migration

The project is moving away from the sourced external functions file.

- **Replace `cmd_exists`** with the inline `__cmd_exists` + `printf_exit`:
  ```bash
  # before
  cmd_exists --error tmux || exit 3
  # after
  __cmd_exists tmux || printf_exit "tmux is not installed" 3
  ```
- Apply this to every `cmd_exists` call in the file being edited — do not leave mixed usage.
- Other external-only helpers (`requiresudo`, `am_i_online`, etc.): find or add the inline equivalent, remove the external call.

### Colorization block — both branches required

The colorization `if/else` block must define `printf_column` in **both** branches:
- no-color branch: `printf_column() { tee | grep -- '^'; }`
- color branch: `printf_column() { column -t 2>/dev/null; }`

Corrected sed ANSI-stripping regex (no spurious space after `[`):
```bash
printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[[0-9;]*[a-zA-Z],,g'; }
```

### printf_* function suite (inline in every self-contained script)

```bash
printf_newline() { [ -n "$1" ] && printf '%b\n' "${*:-}" || printf '\n'; }
printf_green()  { printf_color "$1\n" 2; }
printf_red()    { printf_color "$1\n" 208; }
printf_purple() { printf_color "$1\n" 5; }
printf_yellow() { printf_color "$1\n" 3; }
printf_blue()   { printf_color "$1\n" 33; }
printf_cyan()   { printf_color "$1\n" 6; }
printf_exit() {    # prints to stderr, calls exit
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="208"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  printf_color "$*" "$color" 1>&2; printf '\n'; exit "$exitCode"
}
printf_return() {  # prints to stderr, calls return (non-fatal)
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="208"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  printf_color "$*" "$color" 1>&2; printf '\n'; return "$exitCode"
}
```

Additional as needed: `printf_custom` (urldecode/urlencode), `printf_read_question` + `printf_answer_yes` (check_app).

---

## Color & NO_COLOR

- `--no-color` flag sets `SHOW_RAW="true"` internally
- `NO_COLOR` env var: `[ -n "${NO_COLOR+x}" ]` — handles set-to-empty correctly
- Colorization block: `if [ -n "${NO_COLOR+x}" ] || [ "$SHOW_RAW" = "true" ]; then`
- Early argv check (before getopt): `[ "$1" = "--no-color" ] && export SHOW_RAW="true"`
- `--no-color` case in the getopt while loop also redefines `printf_column` and `printf_color`

---

## Documentation Triple Sync

Every script change requires updating all three in the same commit:

1. `__help()` inside the script
2. `man/{script}.1`
3. `completions/_{script}_completions.bash`

Exempt: hook scripts, sourced library files, non-interactive scripts with no `__help()`, man page, or completions.

---

## Temp Directories

```bash
# NEVER:  mktemp /tmp/XXXXXX        (no org prefix, hardcoded /tmp)
# NEVER:  mktemp -d                 (bare, no prefix)
# GOOD:
APPNAME_TEMP_DIR="${APPNAME_TEMP_DIR:-$HOME/.local/tmp/system_scripts/appname}"
[ -d "$APPNAME_TEMP_DIR" ] || mkdir -p "$APPNAME_TEMP_DIR"
APPNAME_TEMP_FILE="$(mktemp "$APPNAME_TEMP_DIR/XXXXXX" 2>/dev/null)"
trap '__trap_exit' EXIT    # __trap_exit removes the temp file
```

---

## Library Scripts — Sourced vs Direct Execution

```bash
# bash — detect whether sourced or run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  __main "$@"
fi
```

When sourced: define functions and set variables only — no side effects, no output, no `exit`.
When run directly: call `__main`, print help, or run self-tests.

---

## TODO.AI.md Workflow

Mandatory when 2+ tasks are given or the session is complex.

```markdown
## Current Session Tasks
- [ ] Task 1
- [ ] Task 2

## Completed
```

Lifecycle:
1. User gives 2+ tasks → create `TODO.AI.md` immediately
2. After each task → move to Completed
3. All done → empty the file (keep the file; blank = nothing outstanding)
4. Write `.git/COMMIT_MESS` and commit

---

## Testing

- Syntax check: `bash -n bin/{script}` (use correct interpreter per shebang)
- Run `bin/{script} --help` to confirm help renders without errors
- Run the specific subcommand being changed in a real shell
- Incus-first for full integration testing; Docker fallback when Incus unavailable; host only as last resort

| Shebang | Syntax check |
|---------|-------------|
| `#!/usr/bin/env bash` | `bash -n script` |
| `#!/usr/bin/env sh` | `sh -n script` |
| `#!/usr/bin/env zsh` | `zsh -n script` |
| `#!/usr/bin/env fish` | `fish -n script` |

---

## Security

- No `curl | sh` inside scripts — download, inspect, then run
- `curl | sh` is acceptable in README install docs (place description + raw URL link above the code block)
- The shell in the pipe must match the script's interpreter (bash script → `| bash`, not `| sh`)
- Use `sudo tee` instead of redirect for privileged writes
- Never hardcode secrets — all repos are public
- No `bash -x` on code paths that build auth headers (`set -x` exposes tokens in stderr)
- No `--token`/`--api-key`/`--password` values in test commands (GitGuardian flags the pattern)
- No unnamespaced destructive paths — always `[ -n "$VAR" ]` before `rm -rf "$VAR/"`

---

## Session History

Decisions and conventions established — not a work log.

- **2026-01**: Established AI workflow; `gitcommit` as sole commit path; comment-above-code standard
- **2026-01**: `__install_from_archive` / `__install_from_binary` unified helpers in setupmgr
- **2026-04**: UUOC elimination — `APPNAME="${0##*/}"`, bash builtins over forks, `[[ ]]` throughout
- **2026-04**: UUOC applied to templates/ (bash-only; sh/fish/zsh skipped)
- **2026-04**: All completions renamed to `.bash` extension
- **2026-05**: `__sleep` must use `sleep N` (read -t is a no-op on EOF)
- **2026-05**: `--raw` (color flag) renamed to `--no-color` everywhere; `NO_COLOR` env var support added
- **2026-05**: Shellcheck disable: single combined line, full canonical SC set
- **2026-05**: `gitcommit --dir {dir} all` — COMMIT_MESS presence triggers stage-all; `--dir` + absolute path required
- **2026-05**: gen-header structural update: 4 header fields restored (@@Other, @@Resource, @@Terminal App, @@sudo/root); boilerplate aligned to bash/system template
- **2026-05**: Self-contained migration rule: only inline functions the script calls; drop sudo functions when not used (verify by grep, not header); never include user_install, __options, or other external-lib entrypoints
- **2026-05**: Batch migration of 10 scripts to self-contained (urldecode, urlencode, command, decrypt, encrypt, expandurl, pslist, myps, covid19, check_app); printf_column required in both colorization branches; corrected sed ANSI regex
- **2026-06**: acme-cli overhaul — LONGOPTS fixes (--key, --server were silently dropped); heredoc `\$VAR` literal bug fixed via post-parse expansion; --folder renamed to --name; renew-all vs single-cert via ACME_CLI_CERT_DIR_EXPLICIT flag; grep -V → grep -v bug fixed (three sites)
- **2026-06**: cloudflare --zone bug — passing --zone now clears CLOUDFLARE_ZONE_ID to force re-lookup; previously a config-cached ID shadowed the flag silently
- **2026-06**: Vim modeline corrected project-wide to `# ex: ts=2 sw=2 et filetype=sh` (was incorrectly written as `vim: set ft=sh ts=4 sw=4 st=4 et :` in some edits)
- **2026-06**: AI.md synced to global CLAUDE.md — added session-start git sync, Verification & Safety, Self-Validation, Output Rules, Agent Usage & Token Discipline, Task Dependency Ordering; fixed commit subject line from 72 → 64 chars; fixed plan-mode rule; updated colorization color branch to `column -t 2>/dev/null`; added no-commented-code, comments-above-only, \command, cd-absolute-paths, working-set rules
