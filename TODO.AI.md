# TODO.AI.md

## Current Session Tasks

- [ ] Task 1: `__execute_buildx` — derive logfolder/logfile from push_tag (registry/org/repo/version); fix mkdir double-prefix; remove awk UUOC
- [ ] Task 2: `__set_variables` — fix UUOC in registry parser (`echo|grep`, `echo|cut` → `[[ ]]`, `${x%%/*}`); set init log to `$BUILDX_LOG_DIR/init.log`
- [ ] Task 3: Main body — fix `BUILDX_DEFAULT_LOG_ORG/REPO` UUOC (`basename/dirname` subshells)
- [ ] Task 4: `__reinit_buildx` / `__buildx_init` / `__buildx_run` — wire init logging to `$BUILDX_LOG_DIR/init.log`
- [ ] Task 5: Version bump + man/completions sync; write COMMIT_MESS; commit

## Completed

