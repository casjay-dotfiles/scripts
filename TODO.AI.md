# TODO.AI.md

## Style cleanup: replace &&/|| logic-flow chains with if/elif/else

Per AI.md:303-304 ("Use if/elif/else — never &&/|| chains for logic
flow; &&/|| acceptable only for one-liner guards"), audit of
templates/scripts/** found ~30+ non-compliant chains. No live set -e
abort bugs among them (the only live bugs, in
templates/scripts/functions/docker-entrypoint's __symlink and
__initialize_ssl_certs, were already fixed in commits c3d330312b0d
and 5657d3e3b6ff) — this is style-only, mechanical cleanup.

- templates/scripts/bash/mgr-script.system.sh: `... && return 0 ||
  return 1` root-check/sudo-ask pattern, plus ~13 `X && VAR=0 ||
  VAR=1` ternary-assignment idioms
- templates/scripts/bash/mgr-script.user.sh: same root-check/sudo-ask
  pattern as mgr-script.system.sh
- templates/scripts/bash/simple: same root-check/sudo-ask pattern
- templates/scripts/bash/system: same root-check/sudo-ask pattern
- templates/scripts/bash/terminal: same root-check/sudo-ask pattern
- templates/scripts/bash/user: same root-check/sudo-ask pattern
  (missing the ask_for_password chain the other 5 files have)
- templates/scripts/os/arch.sh: is_installed-style helpers, grab_remote_file,
  system_service_exists/enable/disable, and other && chains (e.g. lines
  54, 58-60, 63, 82-85, 109, 116, 140, 175)
- templates/scripts/os/centos.sh: same helper patterns as arch.sh, plus
  longer top-level && chains at lines 688, 699, 718, 748
- templates/scripts/os/debian.sh: is_installed-style helper, grab_remote_file
- templates/scripts/os/fedora.sh: is_installed-style helper, grab_remote_file
- templates/scripts/os/void.sh: is_installed-style helper, grab_remote_file
- templates/scripts/os/macos.sh: is_installed-style helper, grab_remote_file
- templates/scripts/other/docker-entrypoint: safe top-level --debug-flag
  chains at lines 28-33 (same shape as the os/*.sh --debug lines)

Convert each to if/elif/else. One commit per file (or per logical
group of near-duplicate template files), per the findings-based
one-commit-per-finding convention.
