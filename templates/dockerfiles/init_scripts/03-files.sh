cat <<EOF
#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  $(date +"${VERSION_DATE_FORMAT:-%Y%m%d%H%M-git}")
# @@Author           :  CasjaysDev
# @@Contact          :  CasjaysDev <docker-admin@casjaysdev.pro>
# @@License          :  MIT
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
# @@Template         :  templates/dockerfiles/init_scripts/03-files.sh
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
set -o pipefail
[ "\$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -x\$DEBUGGER_OPTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set env variables
exitCode=0

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Predefined actions
if [ -d "/tmp/bin" ]; then
  mkdir -p "/usr/local/bin"
  for bin in "/tmp/bin"/*; do
    name="\$(basename -- "\$bin")"
    echo "Installing \$name to /usr/local/bin/\$name"
    copy "\$bin" "/usr/local/bin/\$name"
    chmod -f +x "/usr/local/bin/\$name"
  done
fi
unset bin
if [ -d "/tmp/var" ]; then
  for var in "/tmp/var"/*; do
    name="\$(basename -- "\$var")"
    echo "Installing \$var to /var/\$name"
    if [ -d "\$var" ]; then
      mkdir -p "/var/\$name"
      copy "\$var/." "/var/\$name/"
    else
      copy "\$var" "/var/\$name"
    fi
  done
fi
unset var
if [ -d "/tmp/etc" ]; then
  for config in "/tmp/etc"/*; do
    name="\$(basename -- "\$config")"
    echo "Installing \$config to /etc/\$name"
    if [ -d "\$config" ]; then
      mkdir -p "/etc/\$name"
      copy "\$config/." "/etc/\$name/"
      mkdir -p "/usr/local/share/template-files/config/\$name"
      copy "\$config/." "/usr/local/share/template-files/config/\$name/"
    else
      copy "\$config" "/etc/\$name"
      copy "\$config" "/usr/local/share/template-files/config/\$name"
    fi
  done
fi
unset config
if [ -d "/tmp/data" ]; then
  for data in "/tmp/data"/*; do
    name="\$(basename -- "\$data")"
    echo "Installing \$data to /usr/local/share/template-files/data"
    if [ -d "\$data" ]; then
      mkdir -p "/usr/local/share/template-files/data/\$name"
      copy "\$data/." "/usr/local/share/template-files/data/\$name/"
    else
      copy "\$data" "/usr/local/share/template-files/data/\$name"
    fi
  done
fi
unset data
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Main script

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the exit code
#exitCode=\$?
# - - - - - - - - - - - - - - - - - - - - - - - - -
exit \$exitCode
# - - - - - - - - - - - - - - - - - - - - - - - - -
# ex: ts=2 sw=2 et filetype=sh
# - - - - - - - - - - - - - - - - - - - - - - - - -

EOF
