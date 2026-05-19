# AI Rules — casjay-dotfiles/scripts

**HOW things are done → `AI.md`**
**WHAT this project is → `IDEA.md`**

Read both files at session start before doing any work.

---

## Session Start (every time)

1. Read `IDEA.md`
2. Read `AI.md`
3. Check `TODO.AI.md` — resume in-flight tasks if present
4. `git status` + `git log -5`

---

## Quick Reference — Non-Obvious Rules

### Commit (memorize this)

```bash
gitcommit --dir /absolute/path/to/project all
```

Never `git commit`, never `git push`, never `-m`/`--message`. Always write `.git/COMMIT_MESS` first.
Subject line ≤72 chars. Body bullets: `- path: change`.

### Version stamps

Format: `YYYYMMDDHHMM-git` — bump **both** `##@Version` header AND `VERSION=` variable on every change.

### Documentation triple sync

Every script change → update all three in the same commit:
1. `__help()` in the script
2. `man/{script}.1`
3. `completions/_{script}_completions.bash`

### grep always uses `--`

```bash
grep -qi -- 'pattern' file    # never: grep -qi 'pattern' file
grep -- '^'                   # never: grep '^'
```

### Self-contained scripts

`bin/` scripts carry all functions inline — no `source`/`.` of external libs.
`printf_column` must be defined in **both** branches of the colorization block.
Only inline functions the script actually calls (audit by grep, not the `@@sudo/root` header).

### External → internal function migration

The project is moving away from the sourced external functions file. When editing any script:

- **Replace `cmd_exists`** with the inline `__cmd_exists` + `printf_exit`:
  ```bash
  # before
  cmd_exists --error tmux || exit 3
  # after
  __cmd_exists tmux || printf_exit "tmux is not installed" 3
  ```
- Apply this to every `cmd_exists` call in the file being edited — do not leave mixed usage.
- Other external-only helpers (`requiresudo`, `am_i_online`, etc.) get the same treatment as encountered: find or add the inline equivalent, remove the external call.

### No UUOC

```bash
"${0##*/}"          # not $(basename "$0")
"$(< file)"         # not $(cat file)
"${path##*/}"       # not $(basename "$path")
grep -- pat file    # not cat file | grep pat
```

### tput

`printf_color` block may use `tput` (established boilerplate — leave it). No new ad-hoc `tput` calls elsewhere; use ANSI escapes (`printf '\e[0m'`) instead.

### NO_COLOR

Check `[ -n "${NO_COLOR+x}" ]` (handles set-to-empty). Early argv: `[ "$1" = "--no-color" ] && export SHOW_RAW="true"`.

---

## Key AI.md Sections (quick index)

| Topic | Section in AI.md |
|-------|-----------------|
| Project file roles | Project File Roles |
| Commit workflow | Git & Commit Workflow |
| Script header template | Script Header Template |
| Exit codes (sysexits) | Exit Codes |
| CLI flags + getopt pattern | CLI Flags |
| No UUOC / minimize forks | Bash Performance |
| Self-contained + printf_* suite | Self-Contained Scripts |
| Color / NO_COLOR | Color & NO_COLOR |
| Temp directories | Temp Directories |
| Testing syntax check | Testing |
| Security rules | Security |
| Session history | Session History |
