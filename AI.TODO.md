# AI TODO List - setupmgr Enhancements

## Pending Additions to setupmgr

### Kubernetes/Container Tools
- [x] **k9s** - Kubernetes TUI (popular terminal UI for kubectl/helm) ✅ COMPLETED
  - Binary releases available for multiple architectures
  - GitHub: https://github.com/derailed/k9s
  - Added: bin/setupmgr:2915-2956

- [x] **dive** - Docker image layer explorer (complements dockermgr) ✅ COMPLETED
  - Binary releases available
  - GitHub: https://github.com/wagoodman/dive
  - Added: bin/setupmgr:3108-3148

- [x] **ctop** - Container monitoring tool ✅ COMPLETED
  - Binary releases available
  - GitHub: https://github.com/bcicen/ctop
  - Added: bin/setupmgr:3683-3724

### Terminal/Shell Tools
- [x] **zellij** - Modern terminal multiplexer (Rust-based, gaining popularity) ✅ COMPLETED
  - Binary releases available
  - GitHub: https://github.com/zellij-org/zellij
  - Added: bin/setupmgr:2017-2057

- [x] **atuin** - Shell history sync/search tool (very popular lately) ✅ COMPLETED
  - Binary releases available
  - GitHub: https://github.com/atuinsh/atuin
  - Added: bin/setupmgr:2159-2200

- [x] **broot** - Better directory navigation/tree viewer ✅ COMPLETED
  - Binary releases available
  - GitHub: https://github.com/Canop/broot
  - Added: bin/setupmgr:3426-3467

### Development Tools
- [x] **helix** - Modern modal editor (alternative to lapce) ✅ COMPLETED
  - Binary releases available
  - GitHub: https://github.com/helix-editor/helix
  - Added: bin/setupmgr:2878-2919

- [x] **hyperfine** - Command-line benchmarking tool ✅ COMPLETED
  - Binary releases available
  - GitHub: https://github.com/sharkdp/hyperfine
  - Added: bin/setupmgr:2921-2962

- [x] **ruff** - Fast Python linter/formatter (from Astral, creators of uv) ✅ COMPLETED
  - Binary releases available
  - GitHub: https://github.com/astral-sh/ruff
  - Added: bin/setupmgr:1555-1596

### Language/Platform
- [x] **zig** - Systems programming language (growing in popularity) ✅ COMPLETED
  - Binary releases available
  - Website: https://ziglang.org/
  - Added: bin/setupmgr:2059-2093

- [x] **rust/rustup** - Rust toolchain installer ✅ COMPLETED
  - Consider if not assuming system package manager installation
  - Website: https://rustup.rs/
  - Added: bin/setupmgr:2095-2115

## Systemd Service Files (from existing TODO)
- [ ] **localai.service** - Enable by default
- [ ] **ollama.service** - Enable by default
- [ ] **caddy.service** - Create but don't enable
- [ ] **minio.service** - Create but don't enable
- [ ] **garage.service** - Create but don't enable
- [ ] **traefik.service** - Create but don't enable
- [ ] **webhookd.service** - Create but don't enable
- [ ] **gohttpserver.service** - Create but don't enable

## Notes
- All tools should have binary releases (no building from source)
- Multi-architecture support preferred (amd64, arm64, arm)
- **Systemd services should be embedded in scripts** (not external template files)
- Services should be user-installable when possible (systemctl --user)
