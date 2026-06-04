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
    [ -e "\$bin" ] || continue
    name="\${bin##*/}"
    echo "Installing \$name to /usr/local/bin/\$name"
    cp -Rf "\$bin" "/usr/local/bin/\$name"
    chmod -f +x "/usr/local/bin/\$name"
  done
fi
unset bin
if [ -d "/tmp/var" ]; then
  for var in "/tmp/var"/*; do
    [ -e "\$var" ] || continue
    name="\${var##*/}"
    echo "Installing \$var to /var/\$name"
    if [ -d "\$var" ]; then
      mkdir -p "/var/\$name"
      cp -Rf "\$var/." "/var/\$name/"
    else
      cp -Rf "\$var" "/var/\$name"
    fi
  done
fi
unset var
if [ -d "/tmp/etc" ]; then
  for config in "/tmp/etc"/*; do
    [ -e "\$config" ] || continue
    name="\${config##*/}"
    echo "Installing \$config to /etc/\$name"
    if [ -d "\$config" ]; then
      mkdir -p "/etc/\$name"
      cp -Rf "\$config/." "/etc/\$name/"
    else
      cp -Rf "\$config" "/etc/\$name"
    fi
  done
fi
unset config
if [ -d "/tmp/usr" ]; then
  for share in "/tmp/usr"/*; do
    [ -e "\$share" ] || continue
    name="\${share##*/}"
    dest="/usr/\$name"
    echo "Installing \$share to \$dest"
    mkdir -p "\$dest"
    cp -Rf "\$share/." "\$dest/"
  done
fi
unset share
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Main script

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the exit code
exitCode=\$?
# - - - - - - - - - - - - - - - - - - - - - - - - -
exit \$exitCode
# - - - - - - - - - - - - - - - - - - - - - - - - -
# ex: ts=2 sw=2 et filetype=sh
# - - - - - - - - - - - - - - - - - - - - - - - - -

EOF
