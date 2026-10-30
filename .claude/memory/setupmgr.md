# setupmgr rules

Applies to every change in `bin/setupmgr` (and its man page and completions).

## Install source priority

1. **Official binary release first, always.** A GitHub (or other forge) release asset, or the vendor's own download endpoint, installed through the existing helpers.
2. **npm / pip / pipx only when:**
   - no binary is published, or
   - the official docs state the tool is installed via npm / pip / pipx.
   That is why `__install_from_npm`, `__execute_npm`, `__install_from_pipx` exist. Keep them; do not remove them.
3. **Never install from source.** No `git clone` + build, `cargo install`, `go install`, `make install`, `pip install git+...`, and no source hints in error messages. If a tool has no binary for an architecture, print that plainly and return 1.
4. **Never `curl|sh` or `wget|sh`.** If the official docs use an install script, read it as research only (fetch to a temp dir) to learn the real mechanism: binary vs archive vs package, download URL, checksum, extraction, where the binary is placed. Then implement that mechanism natively in setupmgr. Never execute or copy the script wholesale.
5. Existing git-checkout installs (nvm, rvm, rbenv, asdf, gvm, luaver, distrobox, plandex) are tools whose official install is a checkout. Do not add new ones.

## Existing helpers (reuse, do not duplicate)

- `__install_from_binary name repo bin_dir [pattern] [platform] [custom_host]`: single-file release asset.
- `__install_from_archive name repo bin_dir [pattern] [platform] [extract_path] [custom_host] [strip_mode]`: tar/zip asset. Use `extract_path` when the archive binary has a different name, `do_not_strip_components` when the binary sits at the archive root.
- Default asset pattern matches `linux|gnu` + `x86_64|amd64|x64` / `aarch64|arm64` in either order; musl is preferred when both exist. Assets with a version between the arch and the extension need a custom pattern.
- Tools with their own URLs (claude, copilot, nix, ollama, garage, zig, go, ...) are dedicated `__setup_<tool>` functions. Prefer the vendor's real latest-version endpoint over a pinned default, and verify the published checksum when one exists.

## Adding, changing or removing a tool: all of these stay in sync

- `__setup_<tool>` function and its `case` branch in the install dispatch
- `__help` tool list, `SETUPMGR_ALL_TOOLS_DEFAULT`, and the `ARRAY` install-all lists (each line must end with a trailing space or comma so tokens never merge)
- uninstall / probe maps if the binary name differs from the tool name
- `completions/_setupmgr_completions.bash` and `man/setupmgr.1`
- version stamp in the header and `VERSION=`, plus the `@@Changelog` line
- `TODO.AI.md` for anything found but not fixed

## Verification procedure (before and after any change)

- Work only in the session scratchpad temp dir. **Never install anything** to verify.
- Check the latest release's real asset names for linux amd64 and arm64 against the pattern the helper would build.
- Download the asset, verify the upstream sha256 when one is published, extract, and run `--version` inside a throwaway `--network none` container with `--rm` and a `scripts-XXXXXXXX` name.
- Read the official docs for the current install method; tools change (opencode moved from npm to binaries, claude moved to downloads.claude.ai).
- Check for archived or renamed repos (`gh api repos/<repo> --jq '.archived, .full_name'`), and prefer the maintained successor or fork over an archived upstream.
- Clean up every download and any pulled image afterward.

## Known decisions

- `mc` installs the maintained `pgsty/mc` fork (release binary `mcli`, installed as `mc`); `rc` is `rustfs/cli`.
- `mods` installs the maintained `panjie/mods` fork.
- `nix` uses the official nixos.org release tarball (sha256 checked, `install --daemon --yes`), not the Determinate installer.
- `claude` uses `downloads.claude.ai/claude-code-releases`; `antigravity` uses Google's updater endpoint and the `Antigravity IDE.tar.gz` asset.
- `hermes` stays on PyPI via pipx: upstream refuses source and git builds, and its only other Linux method is `install.sh` (a source checkout).
- JS tools with no standalone binary (gemini, 9router, openclaw, continue, vercel, prettier, eslint, npm-check-updates, markdownlint) stay on npm.
- Removed because upstream is dead: charm, cortex, cody.
