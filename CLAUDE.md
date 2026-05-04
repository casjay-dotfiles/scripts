# Development Notes — Pointer to AI.md

**Source of truth: `<repo-root>/AI.md`.** All rules, workflows, project standards, the apimgr SPEC, and session history live there. This file is intentionally thin; everything below is a reminder of where to look, not a duplicate of the rules themselves.

## Read first, every session

1. `AI.md` — the full project SPEC + rules
2. `AI.TODO.md` (if it exists) — resume in-flight tasks
3. `git status` + `git log -5` — current state of the working tree

## Ten-second cheat sheet

These are reminders so the harness has *something* without expanding the full AI.md. The authoritative version of every line below lives in AI.md:

- **Don't ask permission for routine ops.** Read files, run tests, check git status, etc. — just do them. (AI.md → "AI Behavior & Autonomy")
- **Question marks are questions, not instructions.** Answer; don't act. (AI.md → "Understanding User Intent")
- **After changes:** write `.git/COMMIT_MESS`, then `gitcommit {command}` (e.g. `gitcommit all`). The message file is canonical — don't pass an inline `{message}`. A successful `gitcommit` also pushes. (AI.md → "Git & Commit Workflow")
- **Off-limits subcommands:** `gitcommit ai`, `gitcommit random`, `gitcommit custom` (all bypass the message file); raw `git commit` (skips signing). (AI.md → same section)
- **Code standards:** functions prefixed `__`, variables `SCRIPTNAME_`, comments above code never inline, no UUOC, prefer bash builtins over forks, single curl wrapper per script. (AI.md → "Code Standards" + "Bash Performance")
- **AI.TODO.md** when more than 2 tasks; delete when done. (AI.md → "AI.TODO.md Workflow")
- **Documentation triple sync:** when changing a script, update `__help`, `man/<script>.1`, and `completions/_<script>_completions.bash` together. (AI.md → "Documentation Synchronization")
- **For apimgr** specifically, the architectural rules are in AI.md → "apimgr — Multi-Provider API Client (SPEC)". Read it before adding providers, actions, or auth changes.

## Project at a glance

- **Type**: Bash script collection for system administration & development tooling
- **Layout**: `bin/<script>`, `man/<script>.1`, `completions/_<script>_completions.bash`, `functions/`, `templates/`, `tests/`
- **Versioning**: `YYYYMMDDHHMM-git` in script header `##@Version` and `VERSION=` (first occurrence only — templates may contain placeholder versions to leave alone). Bump on every change; sync across script, man, and completion.
- **Architectures supported**: amd64, arm64, arm

## Memory system

Persistent feedback / project / user / reference notes live in the per-project memory directory (the harness loads them automatically). Add a new entry whenever the user gives explicit guidance, corrects a mistake, or confirms a non-obvious decision. See AI.md for the conventions (file frontmatter, `MEMORY.md` index).

## When this file gets stale

If anything in this file conflicts with AI.md, **AI.md wins** — and that's a signal to update this pointer file (or trim it further). Do not duplicate AI.md content here; just point at it.
