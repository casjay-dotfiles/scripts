#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202111041659-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : apache.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created       : Thursday, Nov 04, 2021 16:59 EDT
# @File          : apache.sh
# @Description   : apache installer for centos/rhel
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202111041659-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
SCRIPT_DESCRIBE="default"
SCRIPT_OS="centos"
GITHUB_USER="${GITHUB_USER:-casjay}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [ "$1" == "--debug" ]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
SCRIPTSFUNCTURL="${SCRIPTSFUNCTURL:-https://github.com/casjay-dotfiles/scripts/raw/main/functions}"
SCRIPTSFUNCTDIR="${SCRIPTSFUNCTDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTFILE="${SCRIPTSFUNCTFILE:-system-installer.bash}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "../functions/$SCRIPTSFUNCTFILE" ]; then
  . "../functions/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE"
else
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$1" == "--help" ] && printf_exit "${GREEN}${SCRIPT_DESCRIBE} installer for $SCRIPT_OS"
grep --no-filename -sE '^ID=|^ID_LIKE=|^NAME=' /etc/*-release | grep -qiwE "$SCRIPT_OS" && true || printf_exit "This installer is meant to be run on a $SCRIPT_OS based system"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
system_service_exists() { systemctl status "$1" 2>&1 | grep -iq "$1" && return 0 || return 1; }
system_service_enable() { systemctl status "$1" 2>&1 | grep -iq 'inactive' && execute "systemctl enable $1" "Enabling service: $1" || return 1; }
system_service_disable() { systemctl status "$1" 2>&1 | grep -iq 'active' && execute "systemctl disable --now $1" "Disabling service: $1" || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_pkg() {
  for pkg in "$@"; do
    if rpm -q "$pkg" &>/dev/null; then
      printf_blue "[ ✔ ] $pkg is already installed"
      return 1
    else
      return 0
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
remove_pkg() {
  test_pkg "$*" &>/dev/null || execute "yum remove -q -y $*" "Removing: $*"
  test_pkg "$*" &>/dev/null || return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_pkg() {
  test_pkg "$*" && if execute "yum install -q -y --skip-broken $*" "Installing: $*"; then
    test_pkg "$*" &>/dev/null && return 0 || return 1
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
detect_selinux() {
  selinuxenabled
  if [ $? -ne 0 ]; then return 0; else return 1; fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
disable_selinux() {
  if selinuxenabled; then
    printf_blue "Disabling selinux"
    devnull setenforce 0
    sed -i 's|SELINUX=.*|SELINUX=disabled|g' "/etc/selinux/config"
  else
    printf_green "selinux is already disabled"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ssh_key() {
  [ -n "$GITHUB_USER" ] && local ssh_key="" || return 0
  printf_green "Grabbing ssh key for  $GITHUB_USER"
  ssh_key="$(curl -q -LSsf "https://github.com/$GITHUB_USER.keys" 2>/dev/null || echo '')"
  if [ -n "$ssh_key" ]; then
    [ -d "/root/.ssh" ] || mkdir -p "/root/.ssh"
    [ -f "/root/.ssh/authorized_keys" ] || touch "/root/.ssh/authorized_keys"
    if ! grep -sq "$ssh_key" "/root/.ssh/authorized_keys"; then
      echo "$ssh_key" | tee -a "/root/.ssh/authorized_keys" &>/dev/null
      printf_green "Successfully added github ssh key"
    fi
    return 0
  else
    printf_return "Can not get key from https://github.com/$GITHUB_USER.keys"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
rm_repo_files() { [ "${1:-$YUM_DELETE}" = "yes" ] && rm -Rf "/etc/yum.repos" || true; }
run_external() { printf_green "Executing $*" && eval "$*" >/dev/null 2>&1 || return 1; }
grab_remote_file() { urlverify "$1" && curl -q -SLs "$1" || exit 1; }
save_remote_file() { urlverify "$1" && curl -q -SLs "$1" | tee "$2" &>/dev/null || exit 1; }
retrieve_version_file() { grab_remote_file "https://github.com/casjay-base/centos/raw/main/version.txt" | head -n1 || echo "Unknown version"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
retrieve_repo_file() {
  local RELEASE_NAME RELEASE_VER RELEASE_FILE IFS
  RELEASE_VER="$(cat /etc/*-release | grep 'VERSION_ID=' | awk -F '=' '{print $2}' | sed 's#"##g' | awk -F '.' '{print $1}')"
  RELEASE_NAME="$(grep -i '^name=' /etc/os-release | awk -F'=' '{print $2}' | sed 's|"||g;s| .*||g' | tr '[:upper:]' '[:lower:]')"
  if [ "$RELEASE_NAME" = "centos" ]; then
    if [ "$RELEASE_VER" -ge "9" ]; then
      YUM_DELETE="no"
      RELEASE_FILE="https://github.com/rpm-devel/casjay-release/raw/main/casjay.rh9.repo"
    elif [ "$RELEASE_VER" -ge "8" ]; then
      YUM_DELETE="yes"
      RELEASE_FILE="https://github.com/rpm-devel/casjay-release/raw/main/casjay.rh8.repo"
    elif [ "$RELEASE_VER" -lt "8" ]; then
      YUM_DELETE="yes"
      RELEASE_FILE="https://github.com/rpm-devel/casjay-release/raw/main/casjay.rh.repo"
    else
      return
    fi
  else
    YUM_DELETE="no"
  fi
  if [ -n "$RELEASE_FILE" ]; then
    rm_repo_files "$YUM_DELETE"
    save_remote_file "$RELEASE_FILE" "/etc/yum.repos.d/casjay.repo"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_grub() {
  local grub_cnf grub2_cnf grub_bin grub2_bin
  printf_green "Setting up grub"
  grub_cnf="/boot/grub/grub.cfg"
  grub2_cnf="/boot/grub2/grub.cfg"
  grub_bin="$(builtin type -P grub-mkconfig 2>/dev/null || false)"
  grub2_bin="$(builtin type -P grub2-mkconfig 2>/dev/null || false)"
  rm -Rf /boot/*rescue*
  if [ -f "$grub2_bin" ] && [ -f "$grub2_cnf" ]; then
    devnull grub2-mkconfig -o "$grub2_cnf" &&
      printf_green "Updated $grub2_cnf" ||
      printf_return "Failed to update $grub2_cnf"
  elif type -P grub-mkconfig &>/dev/null && [ -f "$grub_cnf" ]; then
    devnull grub-mkconfig -o "$grub_cnf" &&
      printf_green "Updated $grub_cnf" ||
      printf_return "Failed to update $grub_cnf"
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
clear
ARGS="$*" && shift $#
##################################################################################################################
printf_head "Initializing the installer"
##################################################################################################################
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f /etc/casjaysdev/updates/versions/default.txt ]; then
  printf_red "This has already been installed"
  printf_red "To reinstall please remove the version file in"
  printf_exit "/etc/casjaysdev/updates/versions/default.txt"
fi
if ! builtin type -P systemmgr &>/dev/null; then
  if [ -d "/usr/local/share/CasjaysDev/scripts" ]; then
    run_external "git -C /usr/local/share/CasjaysDev/scripts pull"
  else
    run_external "git clone https://github.com/casjay-dotfiles/scripts /usr/local/share/CasjaysDev/scripts"
  fi
  run_external /usr/local/share/CasjaysDev/scripts/install.sh
  run_external systemmgr --config &>/dev/null
  run_external systemmgr install scripts
  run_external "yum clean all"
fi
if [ "$(hostname -s)" != "pbx" ]; then
  retrieve_repo_file
fi
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
if [ -f /etc/makepkg.conf ]; then
  if [ $numberofcores -gt 1 ]; then
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores + 1))'"/g' /etc/makepkg.conf
    sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' /etc/makepkg.conf
  fi
fi
##################################################################################################################
printf_head "Grabbing ssh key from github"
##################################################################################################################
ssh_key

##################################################################################################################
printf_head "Configuring the system"
##################################################################################################################
run_external yum clean all
run_external yum update -q -y --skip-broken
install_pkg vnstat
system_service_enable vnstat
install_pkg net-tools
install_pkg wget
install_pkg curl
install_pkg git
install_pkg nail
install_pkg e2fsprogs
install_pkg redhat-lsb
install_pkg neovim
install_pkg unzip
run_external rm -Rf /tmp/dotfiles
run_external timedatectl set-timezone America/New_York
install_pkg cronie-noanacron
for rpms in echo cronie-anacron sendmail sendmail-cf; do
  rpm -ev --nodeps $rpms &>/dev/null
done
run_external rm -Rf /root/anaconda-ks.cfg /var/log/anaconda
if [ "$(hostname -s)" != "pbx" ]; then
  retrieve_repo_file
fi
run_external yum clean all
run_external yum update -q -y --skip-broken
run_grub

##################################################################################################################
printf_head "Installing the packages for $SCRIPT_DESCRIBE"
##################################################################################################################
install_pkg listofpkgs

##################################################################################################################
printf_head "Fixing packages"
##################################################################################################################

##################################################################################################################
printf_head "setting up config files"
##################################################################################################################
run_post "config_file_actions"

##################################################################################################################
printf_head "Enabling services"
##################################################################################################################
system_service_enable "services_to_enable"

##################################################################################################################
printf_head "Disabling services"
##################################################################################################################
system_service_disable "services_to_disable"

##################################################################################################################
printf_head "Running post install"
##################################################################################################################
run_post "commands_to_run_after_package_install"

##################################################################################################################
printf_head "Cleaning up"
##################################################################################################################
remove_pkg "packages_to_remove"

##################################################################################################################
printf_head "Finished "
##################################################################################################################
printf_newline

##################################################################################################################
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
set --
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# ex: ts=2 sw=2 et filetype=sh
