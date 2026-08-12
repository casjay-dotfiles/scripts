[ ] bin/acme-cli: __run_post_commands (line ~944) has no explicit return; when
    /etc/cockpit/ws-certs.d does not exist, the function's return status is the
    exit status of the `[ -d ... ]` test itself (1), which the "fix" case then
    feeds into __reload_services as prevExit — a spurious failure signal on a
    normal no-op path, not a real error. Noted during the acme-cli exit-code
    bugfix; out of scope for that task, not fixed.
