#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="GEN_SCRIPTS_REPLACE_APPNAME"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : GEN_SCRIPTS_REPLACE_VERSION
# @Author        : GEN_SCRIPTS_REPLACE_AUTHOR
# @Contact       : GEN_SCRIPTS_REPLACE_EMAIL
# @License       : GEN_SCRIPTS_REPLACE_LICENSE
# @ReadME        : GEN_SCRIPTS_REPLACE_FILENAME --help
# @Copyright     : GEN_SCRIPTS_REPLACE_COPYRIGHT
# @Created       : GEN_SCRIPTS_REPLACE_DATE
# @File          : GEN_SCRIPTS_REPLACE_FILENAME
# @Description   : GEN_SCRIPTS_REPLACE_DESC
# @TODO          : GEN_SCRIPTS_REPLACE_TODO
# @Other         : GEN_SCRIPTS_REPLACE_OTHER
# @Resource      : GEN_SCRIPTS_REPLACE_RES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/$GIT_DEFAULT_BRANCH/functions}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_post() {
  local e="$1"
  local m="$(echo $1 | sed 's#devnull ##g')"
  execute "$e" "executing: $m"
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
system_service_exists() {
  if systemctl status "$1" >/dev/null 2>&1; then return 0; else return 1; fi
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
system_service_enable() {
  if system_service_exists "$1"; then execute "systemctl enable --now -f $1" "Enabling service: $1"; fi
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
system_service_disable() {
  if system_service_exists "$1"; then execute "systemctl disable --now $1" "Disabling service: $1"; fi
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
detect_selinux() {
  selinuxenabled
  if [ $? -ne 0 ]; then return 0; else return 1; fi
}
disable_selinux() {
  selinuxenabled
  setenforce 0 &>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grab_remote_file() { urlverify "$1" && curl -sSLq "$@" || exit 1; }
run_external() { printf_green "Executing $*" && "$@" >/dev/null 2>&1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
retrieve_version_file() {
  grab_remote_file https://github.com/casjay-base/centos/raw/$GIT_DEFAULT_BRANCH/version.txt | head -n1 || echo "GEN_SCRIPTS_REPLACE_VERSION"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_grub() {
  printf_green "Setting up grub"
  rm -Rf /boot/*rescue*
  devnull grub2-mkconfig -o /boot/grub2/grub.cfg
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### OS Specific
test_pkg() {
  devnull sudo pacman -Qi "$1" && printf_success "$1 is installed" && return 1 || return 0
  setexitstatus
  set --
}
remove_pkg() {
  if ! test_pkg "$1"; then execute "sudo pacman -R  --noconfirm $1" "Removing: $1"; fi
  setexitstatus
  set --
}
install_pkg() {
  if test_pkg "$1"; then execute "sudo pacman -S --noconfirm --needed $1" "Installing: $1"; fi
  setexitstatus
  set --
}
install_aur() {
  if test_pkg "$1"; then execute "sudo --user=$USER yay -S --noconfirm $1" "Installing: $1"; fi
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -n "$1" ] || printf_exit 'To many options provided'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##################################################################################################################
printf_head "Initializing the setup script"
##################################################################################################################
user_is_root && sudoexit "This scripts requires root/sudo"
##################################################################################################################
printf_head "Configuring cores for compiling"
##################################################################################################################
numberofcores=$(grep -c ^processor /proc/cpuinfo)
printf_info "Total cores avaliable: $numberofcores"
if [ $numberofcores -gt 1 ]; then
  sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores + 1))'"/g' /etc/makepkg.conf
  sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' /etc/makepkg.conf
fi
##################################################################################################################
printf_head "Installing the GEN_SCRIPTS_REPLACE_APPNAME packages"
##################################################################################################################
install_pkg qtile
##################################################################################################################
printf_head "Installing the packages from AUR"
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
run_post "sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf"
run_post "sudo sed -i 's/files mymachines myhostname/files mymachines/g' /etc/nsswitch.conf"
run_post "sudo sed -i 's/\[\!UNAVAIL=return\] dns/\[\!UNAVAIL=return\] mdns dns wins myhostname/g' /etc/nsswitch.conf"
run_post "sudo usermod  -a -G rfkill $USER"
##################################################################################################################
printf_head "setting up config files"
##################################################################################################################
run_post "cp -rT /etc/skel $HOME"
run_post "dotfilesreq APPWM"
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
run_post "devnull sudo systemctl set-default graphical.target"
run_post "devnull sudo grub-mkconfig -o /boot/grub/grub.cfg"
##################################################################################################################
printf_head "Cleaning up"
##################################################################################################################
remove_pkg xfce4-artwork
##################################################################################################################
printf_head "Finished "
printf_newline
##################################################################################################################
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
set --
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
