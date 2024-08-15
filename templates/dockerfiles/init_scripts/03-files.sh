cat <<EOF
#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  $(date +"${VERSION_DATE_FORMAT:-%Y%m%d%H%M-git}")
# @@Author           :  CasjaysDev
# @@Contact          :  CasjaysDev <docker-admin@casjaysdev.pro>
# @@License          :  MIT
# @@ReadME           :
# @@Copyright        :  Copyright 2023 CasjaysDev
# @@Created          :  Mon Aug 28 06:48:42 PM EDT 2023
# @@File             :  $custom_init_name
# @@Description      :  script to run $custom_init_command
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck shell=bash
# shellcheck disable=SC2016
# shellcheck disable=SC2031
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
# shellcheck disable=SC2317
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
set -o pipefail
[ "\$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -x\$DEBUGGER_OPTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set env variables
exitCode=0

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Predifined actions
if [ -d "/tmp/bin" ]; then
  echo "Installing /tmp/bin to /usr/local/bin"
  chmod -Rf +x "/tmp/bin"/*
  copy "/tmp/bin/." "/usr/local/bin/"
fi
if [ -d "/tmp/etc" ]; then
  echo "Installing /tmp/etc to /etc"
  copy "/tmp/etc"/* "/etc/"
  echo "Installing /tmp/etc to /usr/local/share/template-files/config"
  mkdir -p "/usr/local/share/template-files/config"
  copy "/tmp/etc"/* "/usr/local/share/template-files/config/"
fi
if [ -d "/tmp/data" ]; then
  echo "Installing /tmp/data to /usr/local/share/template-files/data"
  mkdir -p "/usr/local/share/template-files/data"
  copy "/tmp/data"/* "/usr/local/share/template-files/data/"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main script

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the exit code
exitCode=\$?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit \$exitCode

EOF
