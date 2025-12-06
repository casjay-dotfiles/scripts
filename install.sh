#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207042244-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  LICENSE.md
# @ReadME            :  README.md
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created           :  Wednesday, Feb 10, 2021 02:00 EST
# @File              :  install.sh
# @Description       :  My custom scripts
# @TODO              :  MacOS fixes/Re-write function/*
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="scripts"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [ "$1" == "--debug" ]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi
export PATH="/usr/local/share/CasjaysDev/scripts/bin:$PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/main/functions}"
connect_test() { ping -c1 ${1:-1.1.1.1} &>/dev/null || curl --disable -LSIs --connect-timeout 3 --retry 0 --max-time 1 ${1:-1.1.1.1} 2>/dev/null | grep -e "HTTP/[0123456789]" | grep -q "200" -n1 &>/dev/null || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
elif connect_test; then
  curl -q -LSsf "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 90
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define pre-install scripts
run_pre_install() {
  if [ -f "/usr/local/bin/pkmgr" ]; then rm -Rf "/usr/local/bin/pkmgr"; fi
  return ${?:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define custom functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the main function
systemmgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make sure the scripts repo is installed
#scripts_check
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults
APPNAME="${APPNAME:-scripts}"
APPDIR="/usr/local/share/CasjaysDev/scripts"
INSTDIR="/usr/local/share/CasjaysDev/scripts"
REPO_BRANCH=${GIT_REPO_BRANCH:-main}
REPO="$SYSTEMMGRREPO/installer"
REPORAW="$REPO/raw/$REPO_BRANCH"
APPVERSION="$(__appversion "$REPORAW/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup plugins
PLUGNAMES=""
PLUGDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Require a version higher than
systemmgr_req_version "$APPVERSION"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the systemmgr function
systemmgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script options IE: --help
show_optvars "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Requires root - no point in continuing
sudoreq "sudo -HE $0 $*" # sudo required
#sudorun                  # sudo optional
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Do not update - add --force to overwrite
#installer_noupdate "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# initialize the installer
systemmgr_run_init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end with a space
if if_os mac; then
  APP="jq sudo curl wget cowsay fortune "
elif if_os linux; then
  APP="ruby expect byobu killall setcap nethogs iftop iotop iperf rsync locate pass python rsync "
  APP+="bash ifconfig jq sudo curl wget dialog html2text cowsay fortune hostname vnstat bc"
fi
PERL="CPAN "
PYTH="pip "
PIPS="speedtest-cli "
CPAN=""
GEMS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# install packages - useful for package that have the same name on all oses
install_packages "$APP"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# install required packages using file
install_required "$APP"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check for perl modules and install using system package manager
install_perl "$PERL"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check for python modules and install using system package manager
install_python "$PYTH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check for pip binaries and install using python package manager
install_pip "$PIPS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check for cpan binaries and install using perl package manager
install_cpan "$CPAN"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check for ruby binaries and install using ruby package manager
install_gem "$GEMS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Other dependencies
dotfilesreq
dotfilesreqadmin
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure directories exist
ensure_dirs
ensure_perms
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Backup if needed
if [ -d "$APPDIR" ]; then
  execute "backupapp $APPDIR $APPNAME" "Backing up $APPDIR"
fi
# Main progam
if __am_i_online; then
  if [ -d "$INSTDIR/.git" ]; then
    execute "git_update $INSTDIR" "Updating $APPNAME configurations"
  else
    execute "git_clone $REPO $INSTDIR" "Installing $APPNAME configurations"
  fi
  # exit on fail
  failexitcode $? "Git has failed"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
run_postinst() {
  systemmgr_run_post
  motdDir="/etc/casjaysdev/messages"
  bannerDir="/etc/casjaysdev/banners"
  verDir="/etc/casjaysdev/updates/versions"
  bashCompDir="${COMPDIR:-/etc/bash_completion.d}"
  fontdir="$(ls -A "$CASJAYSDEVSAPPDIR/fontmgr/" 2>/dev/null | wc -l)"
  get_pam_files_to_edit="$(grep -shRl 'dir=/var/spool/mail' /etc/pam.d/*)"
  [ -f "/etc/hostname" ] && export HOSTNAME="$(<"/etc/hostname")"
  [ -d "/etc/profile.d" ] && printf '%s\n' '[ -f "/etc/hostname" ] && export HOSTNAME="'$HOSTNAME'"' >"/etc/profile.d/00-hostname"
  [ -f "/etc/casjaysdev/.legal_updated" ] || [ "$RESET_LEGAL" != "yes" ] || { [ -f "$motdDir/legal/000.txt" ] && rm -Rf "$motdDir/legal/000.txt"; }
  ln_rm "$SHARE/applications/"
  git config --global pull.rebase 'true'
  systemctl enable --now vnstat &>/dev/null
  mkdir -p "$HOME/.local/backups/systemmgr/installer/pam"
  mkdir -p "/usr/local/share/CasjaysDev/apps/fontmgr"
  mkdir -p "$motdDir/motd" "$motdDir/issue" "$motdDir/legal" "$bannerDir" "$verDir"
  if [ -f "/usr/bin/mailx.s-nail" ] && [ ! -f "/usr/bin/mailx" ]; then
    ln -sf "/usr/bin/mailx.s-nail" "/usr/bin/mailx"
  fi
  if [ -x "$CASJAYSDEVDIR/bin/fontmgr" ]; then
    [ "$fontdir" = "0" ] && sudo "$CASJAYSDEVDIR/bin/fontmgr" install Hack all-the-icons fontawesome LigatureSymbols
  fi
  [ -d "/var/lib/srv/$USER/public" ] || { mkdir -p "/var/lib/srv/$USER/public" && chmod 777 "/var/lib/srv/$USER/public"; }
  [ -d "/var/lib/srv/$USER/docker" ] || { mkdir -p "/var/lib/srv/$USER/docker" && chmod 777 "/var/lib/srv/$USER/docker"; }
  for app in $(ls "$CASJAYSDEVDIR/applications"); do
    ln_sf "$CASJAYSDEVDIR/applications/$app" "$SYSSHARE/applications/$app"
  done
  if { [ ! -f "$motdDir/legal/000.txt" ] || [ ! -f "/etc/casjaysdev/.legal_updated" ]; }; then
    echo "$(date)" >"/etc/casjaysdev/.legal_updated"
    [ -f "$INSTDIR/templates/casjaysdev-legal.txt" ] && cp_rf "$INSTDIR/templates/casjaysdev-legal.txt" "$motdDir/legal/000.txt"
  fi
  [ -f "$bannerDir/ssh.txt" ] || touch "$bannerDir/ssh.txt"
  [ -f "$bannerDir/rsync.txt" ] || touch "$bannerDir/rsync.txt"
  date +"%b %d, %Y at %H:%M" | sudo tee -p "$verDir/date.scripts.txt" &>/dev/null
  [ -f "$INSTDIR/version.txt" ] && cp_rf "$INSTDIR/version.txt" "$verDir/scripts.txt"
  [ -f "$verDir/date.configs.txt" ] || date +"%b %d, %Y at %H:%M" | sudo tee -p "$verDir/date.configs.txt" &>/dev/null
  [ -f "$verDir/configs.txt" ] || date +"${VERSION_DATE_FORMAT:-%Y%m%d%H%M-git}" | sudo tee -p "$verDir/configs.txt" &>/dev/null
  [ -n "$(type -P hostname 2>/dev/null)" ] || { [ -x "/usr/local/bin/hostnamecli" ] && ln_sf "/usr/local/bin/hostnamecli" "/usr/local/bin/hostname"; }
  ln_sf "$APPDIR" "$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
  ln_sf "$APPDIR" "$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX/installer"
  for f in $get_pam_files_to_edit; do
    cp -Rf "$f" "/root/.local/backups/systemmgr/installer/pam/$(basename -- "$f").bak" && sed --follow-symlinks -i 's|dir=~/Maildir||g' "$f"
  done
  for user in root apache nginx www-user daemon nobody $USER; do
    if grep -qs "^$user:" /etc/passwd; then
      for d in composemgr docker public; do
        mkdir -p "/var/lib/srv/$USER/$d"
        chmod -f 777 "/var/lib/srv/$USER/$d"
        chown -f $user "/var/lib/srv/$USER/$d"
        grep -qs "^$user" /etc/group && chgrp -f $user "/var/lib/srv/$USER/$d"
      done
      if [ ! -d "/var/lib/srv/$USER" ]; then
        mkdir -p "/var/lib/srv/$USER"
        chmod -f 777 "/var/lib/srv/$USER"
        chown -f $user "/var/lib/srv/$USER"
        grep -qs "^$user" /etc/group && chgrp -f $user "/var/lib/srv/$USER"
      fi
    fi
  done
  for file in multi_clipboard se sentaku tdrop; do
    [ -f "/usr/local/bin/$file" ] || ln_sf "$APPDIR/sources/$file" "/usr/local/bin/$file"
  done
  for mgr in devenvmgr dfmgr dockermgr fontmgr iconmgr passmgr pkmgr systemmgr thememgr wallpapermgr; do
    eval "$mgr" --config &>/dev/null
  done
  replace "$motdDir/" "MYHOSTIP_4" "$CURRENT_IP_4"
  replace "$motdDir/" "MYHOSTIP_6" "${CURRENT_IP_6:-::1}"
  replace "$motdDir/" "MY_FULL_HOSTNAME" "$(hostname -f)"
  replace "$motdDir/" "MY_SHORT_HOSTNAME" "$(hostname -s)"
  cmd_exists update-ip && update-ip &>/dev/null
  cmd_exists update-motd && update-motd &>/dev/null
  cmd_exists dockermgr && dockermgr --cron &>/dev/null
  grep 'Defaults.*.env_reset' "/etc/sudoers" | grep -q '!' || sudo sed -i 's|env_reset|!env_reset|g' "/etc/sudoers"
  grep 'Defaults.*.secure_path' "/etc/sudoers" && sudo sed -i 's|secure_path =.*|secure_path = "/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin"|g' "/etc/sudoers"
  echo 'for f in '"$CASJAYSDEVDIR/completions"/*'; do source "$f" >/dev/null 2>&1; done' >"$bashCompDir/_my_scripts_completions"
  printf '%s: %s\n' "$(__os_name)" "$(__os_version)" | sed 's| [lL]inux:||g' | sudo tee -p "$verDir/osversion.txt" &>/dev/null
  printf '# update scripts\n5 4 * * * root %s update scripts cron ssl >/var/log/systemmgr\n' "$APPDIR/bin/systemmgr" | sudo tee -p "/etc/cron.d/systemmgr" &>/dev/null
  printf '# Fix resolver\n*/5 * * * * root [ -f "/etc/resolv.conf" ] || echo nameserver 1.1.1.1 >/etc/resolv.conf\n' | sudo tee -p "/etc/cron.d/update-resolver" &>/dev/null
  __os_fix_name "$verDir/osversion.txt"
}
#
execute "run_postinst" "Running post install scripts"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create version file
systemmgr_install_version
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# exit
run_exit
# end
