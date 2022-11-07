#!/usr/bin/env bash
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
APPNAME="$(basename "$0")"
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
if [ -f "../functions/$SCRIPTSFUNCTFILE" ]; then
  . "../functions/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE"
else
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SCRIPT_OS="centos"
SCRIPT_DESCRIBE="GEN_SCRIPT_REPLACE_FILENAME"
GITHUB_USER="${GITHUB_USER:-casjay}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SCRIPT_NAME="${APPNAME%.*}"
RELEASE_VER="$(grep --no-filename -s 'VERSION_ID=' /etc/*-release | awk -F '=' '{print $2}' | sed 's#"##g' | awk -F '.' '{print $1}' | grep '^')"
RELEASE_NAME="$(grep --no-filename -s '^NAME=' /etc/*-release | awk -F'=' '{print $2}' | sed 's|"||g;s| .*||g' | tr '[:upper:]' '[:lower:]' | grep '^')"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$1" == "--help" ] && printf_exit "${GREEN}${SCRIPT_DESCRIBE} installer for $SCRIPT_OS${NC}"
grep --no-filename -sE '^ID=|^ID_LIKE=|^NAME=' /etc/*-release | grep -qiwE "$SCRIPT_OS" && true || printf_exit "This installer is meant to be run on a $SCRIPT_OS based system"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
system_service_exists() { systemctl status "$1" 2>&1 | grep -iq "$1" && return 0 || return 1; }
system_service_enable() { systemctl status "$1" 2>&1 | grep -iq 'inactive' && execute "systemctl enable $1" "Enabling service: $1" || return 1; }
system_service_disable() { systemctl status "$1" 2>&1 | grep -iq 'active' && execute "systemctl disable --now $1" "Disabling service: $1" || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__dnf_yum() {
  local rhel_pkgmgr=""
  rhel_pkgmgr="$(builtin type -P dnf || builtin type -P yum || false)"
  $rhel_pkgmgr "$@" || false
  return $?
}
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
  test_pkg "$*" &>/dev/null || execute "__dnf_yum remove -q -y $*" "Removing: $*"
  test_pkg "$*" &>/dev/null || return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_pkg() {
  local statusCode=0
  if test_pkg "$*"; then
    execute "__dnf_yum install -q -y --skip-broken $*" "Installing: $*"
    test_pkg "$*" &>/dev/null && statusCode=1 || statusCode=0
  else
    statusCode=0
  fi
  return $statusCode
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
  ssh_key="$(curl -q -LSsf "https://github.com/$GITHUB_USER.keys" 2>/dev/null | grep '^' || echo '')"
  if [ -n "$ssh_key" ]; then
    [ -d "/root/.ssh" ] || mkdir -p "/root/.ssh"
    [ -f "/root/.ssh/authorized_keys" ] || touch "/root/.ssh/authorized_keys"
    if grep -sq "$ssh_key" "/root/.ssh/authorized_keys"; then
      printf_cyan "key for $GITHUB_USER already exists in ~/.ssh/authorized_keys"
    else
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
printf_head_clear() { clear && printf_head "$*"; }
grab_remote_file() { urlverify "$1" && curl -q -SLs "$1" || exit 1; }
rm_repo_files() { [ "${1:-$YUM_DELETE}" = "yes" ] && rm -Rf "/etc/yum.repos" || true; }
run_external() { printf_green "Executing $*" && eval "$*" >/dev/null 2>&1 || return 1; }
save_remote_file() { urlverify "$1" && curl -q -SLs "$1" | tee "$2" &>/dev/null || exit 1; }
domain_name() { hostname -f | awk -F'.' '{$1="";OFS="." ; print $0}' | sed 's/^.//;s| |.|g' | grep '^'; }
retrieve_version_file() { grab_remote_file "https://github.com/casjay-base/centos/raw/main/version.txt" | head -n1 || echo "Unknown version"; }
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
retrieve_repo_file() {
  local RELEASE_FILE IFS
  if [ "$RELEASE_NAME" = "centos" ] && [ "$(hostname -s)" != "pbx" ]; then
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
  printf_green "Setting up ${grub_bin_name//-mkconfig/}"
  local cfg="" efi="" grub_cfg="" grub_efi="" grub_bin="" grub_bin_name=""
  grub_cfg="$(find /boot/grub*/* -name 'grub*.cfg' | grep '^' || false)"
  grub_efi="$(find /boot/efi/EFI/* -name 'grub*.cfg' | grep '^' || false)"
  grub_bin="$(builtin type -P grub-mkconfig 2>/dev/null || builtin type -P grub2-mkconfig 2>/dev/null || false)"
  grub_bin_name="$(basename "$grub_bin" 2>/dev/null)"
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
printf_head_clear "Initializing the installer for $SCRIPT_NAME"
##################################################################################################################
if [ -f "/etc/casjaysdev/updates/versions/$SCRIPT_NAME.txt" ]; then
  printf_red "This has already been installed"
  printf_red "To reinstall please remove the version file in"
  printf_exit "/etc/casjaysdev/updates/versions/$SCRIPT_NAME.txt"
else
  install_pkg vnstat && system_service_enable vnstat
  touch "/etc/casjaysdev/updates/versions/$SCRIPT_NAME.txt"
  run_external "yum clean all"
fi
if ! builtin type -P systemmgr &>/dev/null; then
  if [ -d "/usr/local/share/CasjaysDev/scripts" ]; then
    run_external "git -C /usr/local/share/CasjaysDev/scripts pull"
  else
    run_external "git clone https://github.com/casjay-dotfiles/scripts /usr/local/share/CasjaysDev/scripts"
  fi
  run_external /usr/local/share/CasjaysDev/scripts/install.sh
  run_external /usr/local/share/CasjaysDev/scripts/bin/systemmgr --config &>/dev/null
  run_external /usr/local/share/CasjaysDev/scripts/bin/systemmgr update scripts
  run_external "yum clean all"
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
ssh_key

##################################################################################################################
printf_head "Configuring the system"
##################################################################################################################
run_external timedatectl set-timezone America/New_York
for rpms in cronie-anacron sendmail sendmail-cf; do rpm -ev --nodeps $rpms &>/dev/null; done
run_external yum clean all
run_external yum update -q -y --skip-broken
install_pkg cronie-noanacron
install_pkg postfix
install_pkg net-tools
install_pkg wget
install_pkg curl
install_pkg git
install_pkg nail
install_pkg e2fsprogs
install_pkg redhat-lsb
install_pkg neovim
install_pkg unzip
rm_if_exists /tmp/dotfiles
rm_if_exists /root/anaconda-ks.cfg /var/log/anaconda
retrieve_repo_file
run_external yum clean all
run_external yum update -q -y --skip-broken

##################################################################################################################
printf_head "Installing the packages for $SCRIPT_DESCRIBE"
##################################################################################################################
install_pkg listofpkgs

##################################################################################################################
printf_head "Fixing packages"
##################################################################################################################
run_grub

##################################################################################################################
printf_head "setting up config files"
##################################################################################################################
rm_if_exists /etc/named*
rm_if_exists /var/named*
rm_if_exists /tmp/configs
rm_if_exists /etc/ntp.conf
rm_if_exists /etc/httpd/conf.d/ssl.conf
rm_if_exists /etc/cron*/0*
rm_if_exists /etc/cron*/dailyjobs
rm_if_exists /var/ftp/uploads
rm_if_exists /tmp/configs

##################################################################################################################
printf_head "Enabling services"
##################################################################################################################
system_service_enable "services_to_enable"

##################################################################################################################
printf_head "Disabling services"
##################################################################################################################
system_service_disable "firewalld"

##################################################################################################################
printf_head "Running post install"
##################################################################################################################
[ -f "/etc/yum/pluginconf.d/subscription-manager.conf" ] && run_post echo "" >"/etc/yum/pluginconf.d/subscription-manager.conf"

##################################################################################################################
printf_head "Cleaning up"
##################################################################################################################
remove_pkg "packages_to_remove"

##################################################################################################################
printf_head "Installer version: $(retrieve_version_file)"
##################################################################################################################
mkdir -p "/etc/casjaysdev/updates/versions"
echo "$VERSION" >"/etc/casjaysdev/updates/versions/configs.txt"
chmod -Rf 664 "/etc/casjaysdev/updates/versions/configs.txt"

##################################################################################################################
printf_head "Finished setting uo $(hostname -f)"
##################################################################################################################
printf '\n'

##################################################################################################################
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# ex: ts=2 sw=2 et filetype=sh
