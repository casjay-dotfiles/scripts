# TODO.AI.md

## Current Session Tasks

- [ ] Task 4: Version bump + man page + completions sync; write COMMIT_MESS; commit

## Completed

- [x] Task 1: Add `__trap_int` function + global INT/TERM trap; replace `trap 'exit' SIGINT` in `__run_all` and `__buildx_run`
- [x] Task 2: Remove `&>/dev/null` from all 5 eval/push pipelines; change `--progress auto` → `--progress plain`
- [x] Task 3: Fix UUOC violations (`echo|cut`, `echo|grep`, `echo$(basename$(dirname))`) in `__complete_url`, `__parse_dockerfile_labels`, `__run_docker_build`
