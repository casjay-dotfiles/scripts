# AI TODO - Systematic Fix of All Tools

## Approach: Fix Everything, No Excuses

Testing all 95 tools, fixing each issue systematically.

## Tools Fixed:
- [x] zoxide - added do_not_strip_components flag
- [x] bob - fixed do_not_strip_components passing to __extract via env var
- [x] bottom/btm - added do_not_strip_components for flat archive, use musl
- [x] btop - custom function with explicit URL, added .tbz support to extraction
- [x] broot - custom function for multi-platform zip extraction
- [x] helm - custom function using get.helm.sh URLs (not GitHub assets)

## Core Fixes Made:
- Added `__dir_has_content()` helper function
- Fixed `_tar_extract()` to check for any content (files or dirs), not just files
- Updated extraction case statements to use `__dir_has_content` instead of `! __is_dir_empty`
- Added `.tbz` support to extraction (same as `.tbz2`)
- Fixed `--files` handler to `chmod +x` before checking, handles non-executable archives
- Fixed `__download_extract_move` to pass `extract_cmd` as environment variable to `__extract`

## Tools Tested & Working:
act, age, aichat, asdf, atuin, bat, bob, bottom, broot, btop, bun, caddy, coder, ctop,
delta, deno, devbox, direnv, dive, distrobox, dust, duf, exa, fastfetch, fabric, fd,
fnm, fzf, gh, glow, go, helm, helix, hyperfine, jless, k9s, kind, kubectl, lazydocker, lazygit

## Tools Needing Fix:
- [ ] just - pattern matching issue with `x86_64-unknown-linux-musl` format (in progress)

## Tools Skipped (expected):
- aider - requires pipx dependency (expected behavior)
- lapce - skipped on headless systems (expected behavior)

## Tools Not Yet Tested (alphabetically from 'l'):
lima, llama-cpp, llm, lua, mc, minikube, minio_server, mods, nix, nodejs, nvm, ollama,
opentofu, packer, pipx, podman, powershell, procs, rbenv, ripgrep, rvm, speedtest,
starship, tokei, traefik, uv, vagrant, vfox, webhookd, yq, zed, zellij, zig,
claude, copilot, codex, vercel, prettier, eslint, npm-check-updates

## Other Fixes:
- [x] pkmgr - Added automatic PGP keyring recovery for pacman signature errors on Arch/CachyOS

## Session Notes:
- Last tested up to: lazygit (working), just (failing - pattern issue)
- Pattern issue with just: The regex `(x86_64)[._-](unknown-)?(linux|gnu)` should match
  `x86_64-unknown-linux-musl` but grep -iE doesn't match the full URL for some reason
- Need to debug why pattern works on filename but not on full GitHub URL
- pkmgr now auto-detects PGP signature errors and attempts keyring recovery before retrying
