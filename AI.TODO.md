# AI TODO List - setupmgr Enhancements

## Pending Additions to setupmgr

### Kubernetes/Container Tools
- [ ] **k9s** - Kubernetes TUI (popular terminal UI for kubectl/helm)
  - Binary releases available for multiple architectures
  - GitHub: https://github.com/derailed/k9s

- [ ] **dive** - Docker image layer explorer (complements dockermgr)
  - Binary releases available
  - GitHub: https://github.com/wagoodman/dive

- [ ] **ctop** - Container monitoring tool
  - Binary releases available
  - GitHub: https://github.com/bcicen/ctop

### Terminal/Shell Tools
- [ ] **zellij** - Modern terminal multiplexer (Rust-based, gaining popularity)
  - Binary releases available
  - GitHub: https://github.com/zellij-org/zellij

- [ ] **atuin** - Shell history sync/search tool (very popular lately)
  - Binary releases available
  - GitHub: https://github.com/atuinsh/atuin

- [ ] **broot** - Better directory navigation/tree viewer
  - Binary releases available
  - GitHub: https://github.com/Canop/broot

### Development Tools
- [ ] **helix** - Modern modal editor (alternative to lapce)
  - Binary releases available
  - GitHub: https://github.com/helix-editor/helix

- [ ] **hyperfine** - Command-line benchmarking tool
  - Binary releases available
  - GitHub: https://github.com/sharkdp/hyperfine

- [ ] **ruff** - Fast Python linter/formatter (from Astral, creators of uv)
  - Binary releases available
  - GitHub: https://github.com/astral-sh/ruff

### Language/Platform
- [ ] **zig** - Systems programming language (growing in popularity)
  - Binary releases available
  - Website: https://ziglang.org/

- [ ] **rust/rustup** - Rust toolchain installer
  - Consider if not assuming system package manager installation
  - Website: https://rustup.rs/

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
- Systemd services should use templates from `templates/systemd/`
- Services should be user-installable when possible
