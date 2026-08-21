# TODO.AI.md

## bin/setupmgr / completions / man page

- `completions/_setupmgr_completions.bash`'s `ARRAY` and `man/setupmgr.1`'s
  package list only document a curated subset of tools — `SETUPMGR_ALL_TOOLS`
  in `bin/setupmgr` has 150+ entries (e.g. `age`, `ali`, `antigravity`,
  `bandwhich`, `bombardier`, `bottom`, `btop`, `buf`, `cody`, `continue`,
  `cosign`, `curlie`, `dasel`, `difftastic`, `dog`, `dua`, `duf`, `earthly`,
  `entr`, `evans`, `eza`, `fx`, `ghz`, `git-cliff`, `gitleaks`, `gitui`,
  `grex`, `gron`, `grype`, `grpcurl`, `hadolint`, `htmlq`, `httpie`, `jnv`,
  `jq`, `k6`, `kompose`, `kubectx`, `kubens`, `lf`, `llama_cpp`, `lsd`,
  `miller`, `mise`, `nushell`, `oha`, `sd`, `skaffold`, `sops`, `sq`, `stern`,
  `syft`, `tabby`, `trufflehog`, `trivy`, `vegeta`, `viddy`, `watchexec`,
  `wrk`, `xcaddy`, `xh`, `xsv`, and many more) that are missing from both
  files. Found while syncing docs for the `task`/`tig`/`tilt`/`tgpt`/`tldr`
  dispatch fix; out of scope for that fix since it's pre-existing drift far
  beyond the tools touched this session.
