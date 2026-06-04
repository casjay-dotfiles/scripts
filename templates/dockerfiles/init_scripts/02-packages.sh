cat <<EOF
#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  $(date +"${VERSION_DATE_FORMAT:-%Y%m%d%H%M-git}")
# @@Author           :  CasjaysDev
# @@Contact          :  CasjaysDev <docker-admin@casjaysdev.pro>
# @@License          :  WTFPL
# @@Copyright        :  Copyright $(date +'%Y') CasjaysDev
# @@Created          :  $(date)
# @@File             :  $custom_init_name
# @@Description      :  script to run $custom_init_command
# @@Changelog        :  newScript
# @@TODO             :  Refactor code
# @@Other            :  N/A
# @@Resource         :  N/A
# @@Terminal App     :  yes
# @@sudo/root        :  yes
# @@Template         :  templates/dockerfiles/init_scripts/02-packages.sh
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
set -eo pipefail
[ "\$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -x\$DEBUGGER_OPTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set env variables
exitCode=0

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Predefined actions

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Main script
if command -v update-ca-certificates >/dev/null 2>&1; then
  update-ca-certificates
elif command -v update-ca-trust >/dev/null 2>&1; then
  update-ca-trust extract
elif command -v trust >/dev/null 2>&1; then
  trust extract-compat
fi

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the exit code
exitCode=\$?
# - - - - - - - - - - - - - - - - - - - - - - - - -
exit \$exitCode
# - - - - - - - - - - - - - - - - - - - - - - - - -
# ex: ts=2 sw=2 et filetype=sh
# - - - - - - - - - - - - - - - - - - - - - - - - -

EOF
