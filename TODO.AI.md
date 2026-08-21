# TODO.AI.md

## bin/setupmgr / completions / man page

- DONE (this session): `completions/_setupmgr_completions.bash`'s `ARRAY` and
  `man/setupmgr.1`'s package list now document all 157 entries in
  `SETUPMGR_ALL_TOOLS`. Verified with `comm -23`/`comm -13` diffs — zero
  entries missing in either direction.

- **Critical, NOT fixed (out of scope for the doc-sync above): 58 of the 157
  tools in `SETUPMGR_ALL_TOOLS` have no dispatch `case` arm in the main CLI
  arg parser (`bin/setupmgr` lines ~7006-7614), so `setupmgr <tool>` silently
  falls through to the default/unknown-package branch instead of installing
  them. Of those 58, 23 also have no `__setup_*` function defined at all
  (calling them would be a no-op even if a case arm existed).**
  Verified via `grep -c "^__setup_<fn>()" bin/setupmgr` and a dispatch-block
  grep (`sed -n '7006,7614p' bin/setupmgr`, matched against plain and
  piped/grouped `case` arm syntax) for every `SETUPMGR_ALL_TOOLS` entry.

  Missing `__setup_*` function entirely (23): `ali`, `bombardier`, `buf`,
  `cody`, `continue`, `curlie`, `dog`, `dua`, `earthly`, `evans`, `eza`,
  `fx`, `ghz`, `grpcurl`, `jq`, `k6`, `lf`, `lsd`, `oha`, `sops`, `tabby`,
  `vegeta`, `wrk`.

  Has a `__setup_*` function but no dispatch case (35 more, on top of the
  23 above — 58 total): `antigravity`, `bandwhich`, `cosign`, `ctlptl`,
  `dasel`, `difftastic`, `entr`, `git-cliff`, `gitleaks`, `gitui`, `golang`,
  `grex`, `gron`, `grype`, `htmlq`, `httpie`, `jnv`, `kompose`, `kubectx`,
  `kubens`, `llama_cpp`, `miller`, `mise`, `nushell`, `sd`, `skaffold`, `sq`,
  `stern`, `syft`, `trivy`, `trufflehog`, `viddy`, `watchexec`, `xcaddy`,
  `xh`, `xsv`.

  Fixing this requires: (1) writing 23 new `__setup_*` functions, (2) adding
  58 dispatch case arms, (3) end-to-end verifying each install. This is a
  large, dedicated-session task — do not attempt to fold it into an
  unrelated commit.

- **`setupmgr all` (and `--all`) uses a separate, smaller internal `ARRAY`
  variable (`bin/setupmgr` lines ~6798-6801, consumed at line ~6997 via
  `for app in ${ARRAY//,/ }; do eval "$0" "$app"; done`) that is NOT the
  same list as `SETUPMGR_ALL_TOOLS` and currently has only ~85 entries — it
  is missing `task`, `tig`, `tilt`, `tgpt`, `tldr`, `dnsglobe`, and
  `terminal-browser` (the tools fixed/added in a prior session), meaning
  `setupmgr all` silently skips them. Found incidentally while auditing the
  dispatch-case gap above; not fixed since it's a separate mechanism from
  both `SETUPMGR_ALL_TOOLS` and the completions/man-page sync.
