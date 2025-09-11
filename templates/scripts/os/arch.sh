#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  GEN_SCRIPT_REPLACE_VERSION
# @@Author           :  GEN_SCRIPT_REPLACE_AUTHOR
# @@Contact          :  GEN_SCRIPT_REPLACE_EMAIL
# @@License          :  GEN_SCRIPT_REPLACE_LICENSE
# @@ReadME           :  GEN_SCRIPT_REPLACE_FILENAME --help
# @@Copyright        :  GEN_SCRIPT_REPLACE_COPYRIGHT
# @@Created          :  GEN_SCRIPT_REPLACE_DATE
# @@File             :  GEN_SCRIPT_REPLACE_FILENAME
# @@Description      :  GEN_SCRIPT_REPLACE_DESC
# @@Changelog        :  GEN_SCRIPT_REPLACE_CHANGELOG
# @@TODO             :  GEN_SCRIPT_REPLACE_TODO
# @@Other            :  GEN_SCRIPT_REPLACE_OTHER
# @@Resource         :  GEN_SCRIPT_REPLACE_RES
# @@Terminal App     :  GEN_SCRIPT_REPLACE_TERMINAL
# @@sudo/root        :  GEN_SCRIPT_REPLACE_SUDO
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2120,SC2155,SC2199,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="GEN_SCRIPT_REPLACE_FILENAME"
VERSION="GEN_SCRIPT_REPLACE_VERSION"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [ "$1" = "--debug" ]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
SCRIPTSFUNCTURL="${SCRIPTSFUNCTURL:-https://github.com/casjay-dotfiles/scripts/raw/main/functions}"
SCRIPTSFUNCTDIR="${SCRIPTSFUNCTDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTFILE="${SCRIPTSFUNCTFILE:-system-installer.bash}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "./functions/$SCRIPTSFUNCTFILE" ]; then
  . "./functions/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE"
else
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SCRIPT_OS="arch"
SCRIPT_DESCRIBE="GEN_SCRIPT_REPLACE_FILENAME"
GITHUB_USER="${GITHUB_USER:-casjay}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SCRIPT_NAME="$(basename -- "$0" 2>/dev/null)"
SCRIPT_NAME="${SCRIPT_NAME%.*}"
RELEASE_VER="$(grep --no-filename -s 'VERSION_ID=' /etc/*-release | awk -F '=' '{print $2}' | sed 's#"##g' | awk -F '.' '{print $1}' | grep '^')"
RELEASE_NAME="$(grep --no-filename -s '^NAME=' /etc/*-release | awk -F'=' '{print $2}' | sed 's|"||g;s| .*||g' | tr '[:upper:]' '[:lower:]' | grep '^')"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grep --no-filename -sE '^ID=|^ID_LIKE=|^NAME=' /etc/*-release | grep -qiwE "$SCRIPT_OS" && true || printf_exit "This installer is meant to be run on a $SCRIPT_OS based system"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$1" == "--help" ] && printf_exit "${GREEN}${SCRIPT_DESCRIBE} installer for $SCRIPT_OS${NC}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
system_service_exists() { systemctl status "$1" 2>&1 | grep -iq "$1" && return 0 || return 1; }
system_service_enable() { systemctl status "$1" 2>&1 | grep -iq 'inactive' && execute "systemctl enable $1" "Enabling service: $1" || return 1; }
system_service_disable() { systemctl status "$1" 2>&1 | grep -iq 'active' && execute "systemctl disable --now $1" "Disabling service: $1" || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
get_user_ssh_key() {
  [ -n "$GITHUB_USER" ] && local ssh_key="" || return 0
  ssh_key="$(curl -q -LSsf "https://github.com/$GITHUB_USER.keys" 2>/dev/null | grep '^' || echo '')"
  if [ -n "$ssh_key" ]; then
    [ -d "/root/.ssh" ] || mkdir -p "/root/.ssh"
    [ -f "/root/.ssh/authorized_keys" ] || touch "/root/.ssh/authorized_keys"
    if grep -shq "$ssh_key" "/root/.ssh/authorized_keys"; then
      printf_cyan "key for $GITHUB_USER already exists in ~/.ssh/authorized_keys"
    else
      echo "$ssh_key" | tee -p -a "/root/.ssh/authorized_keys" &>/dev/null
      printf_green "Successfully added ssh key to ~/.ssh/authorized_keys"
    fi
    return 0
  else
    printf_return "Can not get key from https://github.com/$GITHUB_USER.keys"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_head_clear() { clear && printf_head "$*"; }
grab_remote_file() { urlverify "$1" && curl -q -SLs "$1" || exit 1; }
rm_repo_files() { [ "${1:-$YUM_DELETE}" = "yes" ] && rm -Rf "/etc/yum.repos" || true; }
run_external() { printf_green "Executing $*" && eval "$*" >/dev/null 2>&1 || return 1; }
save_remote_file() { urlverify "$1" && curl -q -SLs "$1" | tee -p "$2" &>/dev/null || exit 1; }
domain_name() { hostname -f | awk -F'.' '{$1="";OFS="." ; print $0}' | sed 's/^.//;s| |.|g' | grep '^'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
rm_if_exists() {
  local file_loc=("$@") && shift $#
  for file in "${file_loc[@]}"; do
    if [ -e "$file" ]; then
      execute "rm -Rf $file" "Removing $file"
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_grub() {
  local cfg="" efi="" grub_cfg="" grub_efi="" grub_bin="" grub_bin_name=""
  grub_cfg="$(find /boot/grub*/* -name 'grub*.cfg' | grep '^' || false)"
  grub_efi="$(find /boot/efi/EFI/* -name 'grub*.cfg' | grep '^' || false)"
  grub_bin="$(builtin type -P grub-mkconfig 2>/dev/null || builtin type -P grub2-mkconfig 2>/dev/null || false)"
  grub_bin_name="$(basename -- "$grub_bin" 2>/dev/null)"
  printf_green "Setting up ${grub_bin_name//-mkconfig/}"
  if [ -n "$grub_bin" ]; then
    rm_if_exists /boot/*rescue*
    if [ -n "$grub_cfg" ]; then
      for cfg in $grub_cfg; do
        if [ -e "$cfg" ]; then
          devnull $grub_bin -o "$cfg" && printf_green "Updated $cfg" || printf_return "Failed to update $cfg"
        fi
      done
    fi
    if [ -n "$grub_efi" ]; then
      for efi in $grub_efi; do
        if [ -e "$efi" ]; then
          devnull $grub_bin -o "$efi" && printf_green "Updated $efi" || printf_return "Failed to update $efi"
        fi
      done
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_post() {
  local e="$*"
  local m="${e//devnull /}"
  execute "$e" "executing: $m"
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
fix_network_device_name() {
  local device=""
  device="$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -n1 | grep '^' || echo 'eth0')"
  printf_green "Setting network device name to $device in $1"
  find "$1" -type f -exec sed -i 's|eth0|'$device'|g' {} +
}
##################################################################################################################
#### OS Specific
test_pkg() {
  devnull pacman -Qi "$1" && printf_success "$1 is installed" && return 1 || return 0
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
remove_pkg() {
  if ! test_pkg "$1"; then execute "pacman -R --noconfirm $1" "Removing: $1"; fi
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_pkg() {
  if test_pkg "$1"; then execute "pacman -S --noconfirm --needed $1" "Installing: $1"; fi
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_aur() {
  if test_pkg "$1"; then execute "sudo --user=$USER yay -S --noconfirm $1" "Installing: $1"; fi
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
retrieve_version_file() {
  grab_remote_file "https://github.com/casjay-base/arch/raw/main/version.txt" | head -n1 || echo "Unknown version"
}
##################################################################################################################
printf_head_clear "Initializing the installer for $SCRIPT_NAME"
##################################################################################################################
if [ -f "/etc/casjaysdev/updates/versions/$SCRIPT_NAME.txt" ]; then
  printf_red "$(<"/etc/casjaysdev/updates/versions/$SCRIPT_NAME.txt")"
  printf_red "To reinstall please remove the version file in"
  printf_red "/etc/casjaysdev/updates/versions/$SCRIPT_NAME.txt"
  exit 1
else
  install_pkg vnstat && system_service_enable vnstat && systemctl start vnstat &>/dev/null
  printf '%s\n' "Installed on $(date +'%Y-%m-%d at %H:%M %Z')" >"/etc/casjaysdev/updates/versions/$SCRIPT_NAME.txt"
fi
if ! builtin type -P systemmgr &>/dev/null; then
  if [ -d "/usr/local/share/CasjaysDev/scripts" ]; then
    run_external "git -C /usr/local/share/CasjaysDev/scripts pull"
  else
    run_external "git clone https://github.com/casjay-dotfiles/scripts /usr/local/share/CasjaysDev/scripts"
  fi
  run_external /usr/local/share/CasjaysDev/scripts/install.sh
  run_external /usr/local/share/CasjaysDev/scripts/bin/systemmgr --config
  run_external /usr/local/share/CasjaysDev/scripts/bin/systemmgr update scripts
fi
retrieve_repo_file
printf_green "Installer has been initialized"

##################################################################################################################
printf_head "Disabling selinux"
##################################################################################################################
disable_selinux

##################################################################################################################
printf_head "Configuring cores for compiling"
##################################################################################################################
numberofcores=$(grep -c ^processor /proc/cpuinfo)
printf_yellow "Total cores avaliable: $numberofcores"
if [ -f "/etc/makepkg.conf" ]; then
  if [ $numberofcores -gt 1 ]; then
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores + 1))'"/g' "/etc/makepkg.conf"
    sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' "/etc/makepkg.conf"
  fi
fi
##################################################################################################################
printf_head "Grabbing ssh key from github"
##################################################################################################################
get_user_ssh_key

##################################################################################################################
printf_head "Configuring the system"
##################################################################################################################
run_external timedatectl set-timezone America/New_York

##################################################################################################################
printf_head "Installing the packages for $SCRIPT_DESCRIBE"
##################################################################################################################
install_pkg listofpkgs

##################################################################################################################
printf_head "Fixing packages"
##################################################################################################################
run_grub

##################################################################################################################
printf_head "Installing packages: AUR"
##################################################################################################################
install_aur ttf-font-awesome
install_aur brackets-bin
install_aur cmatrix-git
install_aur font-manager-git
install_aur hardcode-fixer-git
install_aur pamac-aur
install_aur visual-studio-code
install_aur menulibre
install_aur mugshot
install_aur xfce4-panel-profiles

##################################################################################################################
printf_head "Fixing packages"
##################################################################################################################
run_post "sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf"
run_post "sed -i 's/files mymachines MY_SHORT_HOSTNAME/files mymachines/g' /etc/nsswitch.conf"
run_post "sed -i 's/\[\!UNAVAIL=return\] dns/\[\!UNAVAIL=return\] mdns dns wins MY_SHORT_HOSTNAME/g' /etc/nsswitch.conf"
run_post "usermod -a -G rfkill $USER"

##################################################################################################################
printf_head "setting up config files"
##################################################################################################################
run_post "cp -rT /etc/skel $HOME"
run_post "dotfilesreq bash"
run_post "dotfilesreq geany"
run_post "dotfilesreq misc"
run_post "dotfilesreq xfce4"
run_post "dotfilesreqadmin samba ssl"

##################################################################################################################
printf_head "Enabling services"
##################################################################################################################
system_service_enable lightdm.service
system_service_enable bluetooth.service
system_service_enable smb.service
system_service_enable nmb.service
system_service_enable avahi-daemon.service
system_service_enable tlp.service
system_service_enable org.cups.cupsd.service
system_service_disable mpd

##################################################################################################################
printf_head "Running post install"
##################################################################################################################
run_post "devnull systemctl set-default graphical.target"

##################################################################################################################
printf_head "Cleaning up"
##################################################################################################################
remove_pkg xfce4-artwork

##################################################################################################################

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-0}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ex: ts=2 sw=2 et filetype=sh
