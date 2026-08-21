# TODO.AI.md

## bin/setupmgr

- `task`, `tig`, `tilt`, `tgpt`, `tldr` are all listed in `SETUPMGR_ALL_TOOLS`
  and have working `__setup_*` functions, but have no dispatch `case`
  entries in the main CLI arg parser — `setupmgr task` (etc.) currently
  falls through to the default `*) break ;;` and does nothing. Found
  incidentally while adding the `terminal-browser` dispatch entry; not
  fixed since it's outside that task's scope.
