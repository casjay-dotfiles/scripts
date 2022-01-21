#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        : system-installer.sh
# @Created     : Wed, Aug 05, 2020, 02:00 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description : installer functions for apps
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[[ $(id -u) != 0 ]] || [[ "$EUID" != 0 ]] || [[ "$WHOAMI" != "root" ]] || { echo -e "\t\t\033[0;31mThis script requires sudo or root\033[0m" && exit 1; }
PATH="$(echo "$PATH" | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's#::#:.#g')"
USER="${USER:-}"
RUN_USER="$(logname 2>/dev/null)"
SUDO_USER="${RUN_USER:-$SUDO_USER}"
TMP="${TMP:-/tmp}"
TEMP="${TEMP:-/tmp}"
export RUN_USER SUDO_USER WHOAMI USER PATH
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# fail if git is not installed
if builtin command -v brew &>/dev/null; then
  __install() { eval brew install -f "$*" &>/dev/null; }
elif builtin command -v apt &>/dev/null; then
  __install() { eval apt install -yy -q "$*" &>/dev/null; }
elif builtin command -v pacman &>/dev/null; then
  __install() { eval pacman -S --noconfirm "$*" &>/dev/null; }
elif builtin command -v yum &>/dev/null; then
  __install() { eval yum install -yy -q "$*" &>/dev/null; }
elif builtin command -v choco &>/dev/null; then
  __install() { eval choco install "$*" -y &>/dev/null; }
else
  echo -e "\t\t\033[0;31mCan not determine you packager manager\033[0m"
  exit 1
fi

for check in git curl wget; do
  if builtin command -v "$check" &>/dev/null; then
    true
  else
    __install "$check" && true || false
    builtin command -v "$check" &>/dev/null || cmdMissing="$check "
  fi
done
if [[ -n "$cmdMissing" ]]; then
  echo -e "\n\n\t\t\033[0;31m$cmdMissing is not installed\033[0m\n"
  [ -f "/tmp/system-installer.bash" ] && rm -Rf /tmp/system-installer.bash
  exit 1
else
  unset cmdMissing
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_fix_name() { [[ -f "${1:-/etc/casjaysdev/updates/versions/osversion.txt}" ]] && sudo sed -i 's|[",]||g;s| [lL]inux:||g' "${1:-/etc/casjaysdev/updates/versions/osversion.txt}" || return 0; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_name() {
  grep -s '^NAME=' /etc/os-release | awk -F '=' '{print $2}' | grep '^' ||
    grep -s '^ID=' /etc/os-release | awk -F '=' '{print $2}' | grep '^' ||
    echo "OS: Unknown"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_version() {
  grep -s '^VERSION=' /etc/os-release 2>/dev/null | sed 's/[^.0-9]*//g' | grep '^' ||
    grep -s 'BUILD_ID' /etc/os-release 2>/dev/null | awk -F '=' '{print $2}' | grep '^' ||
    echo "Version: Unknown"
}
###################### builtins ######################
# Set Main Repo for dotfiles
export DOTFILESREPO="${DOTFILESREPO:-https://github.com/dfmgr}"
# Set other Repos
export PKMGRREPO="${PKMGRREPO:-https://github.com/pkmgr}"
export DEVENVMGR="${DEVENVMGR:-https://github.com/devenvmgr}"
export ICONMGRREPO="${ICONMGRREPO:-https://github.com/iconmgr}"
export FONTMGRREPO="${FONTMGRREPO:-https://github.com/fontmgr}"
export THEMEMGRREPO="${THEMEMGRREPO:-https://github.com/thememgr}"
export SYSTEMMGRREPO="${SYSTEMMGRREPO:-https://github.com/systemmgr}"
export WALLPAPERMGRREPO="${WALLPAPERMGRREPO:-https://github.com/wallpapermgr}"
export GIT_REPO_BRANCH="${GIT_DEFAULT_BRANCH:-main}"
##################################################################################################
NC="$(tput sgr0 2>/dev/null)"
RESET="$(tput sgr0 2>/dev/null)"
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
ORANGE="\033[0;33m"
LIGHTRED='\033[1;31m'
BG_GREEN="\[$(tput setab 2 2>/dev/null)\]"
BG_RED="\[$(tput setab 9 2>/dev/null)\]"
##################################################################################################
printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
printf_normal() { printf_color "\t\t$1\n" "$2"; }
printf_green() { printf_color "\t\t$1\n" 2; }
printf_red() { printf_color "\t\t$1\n" 1; }
printf_purple() { printf_color "\t\t$1\n" 5; }
printf_yellow() { printf_color "\t\t$1\n" 3; }
printf_blue() { printf_color "\t\t$1\n" 4; }
printf_cyan() { printf_color "\t\t$1\n" 6; }
printf_info() { printf_color "\t\t[ ℹ️ ] $1\n" 3; }
printf_exit() {
  printf_color "\t\t$1\n" 1 1>&2
  exit 1
}
printf_help() { printf_color "\t\t$1\n" 1; }
printf_read() { printf_color "\t\t$1" 5; }
printf_success() { printf_color "\t\t[ ✔ ] $1\n" 2; }
printf_error() { printf_color "\t\t[ ✖ ] $1 $2\n" 1 1>&2; }
printf_warning() { printf_color "\t\t[ ❗ ] $1\n" 3; }
printf_question() { printf_color "\t\t[ ❓ ] $1 [❓] " 6; }
printf_error_stream() { while read -r line; do printf_error "↳ ERROR: $line"; done; }
printf_execute_success() { printf_color "\t\t[ ✔ ] $1 \n" 2; }
printf_execute_error() { printf_color "\t\t[ ✖ ] $1 $2 \n" 1; }
printf_execute_result() {
  if [ "$1" -eq 0 ]; then printf_execute_success "$2"; else printf_execute_error "$2"; fi
  return "$1"
}
printf_execute_error_stream() { while read -r line; do printf_execute_error "↳ ERROR: $line"; done; }

##################################################################################################
printf_readline() {
  set -o pipefail
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  while read line; do
    printf_custom "$color" "$line"
  done
  set +o pipefail
}
##################################################################################################
printf_custom() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
  echo ""
}
##################################################################################################
printf_head() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="6"
  local msg="$*"
  shift
  printf_color "
\t\t##################################################
\t\t$msg
\t\t##################################################\n" "$color"
}
##################################################################################################
printf_result() {
  [ ! -z "$1" ] && EXIT="$1" || EXIT="$?"
  [ ! -z "$2" ] && local OK="$2" || local OK="Command executed successfully"
  [ ! -z "$2" ] && local FAIL="$2" || local FAIL="Command has failed"
  if [ "$EXIT" -eq 0 ]; then
    printf_success "$OK"
    exit 0
  else
    printf_error "$FAIL"
    exit 1
  fi
}
##################################################################################################
notifications() {
  local title="$1"
  shift 1
  local msg="$*"
  shift
  builtin command -v notify-send &>/dev/null && notify-send -u normal -i "notification-message-IM" "$title" "$msg" || return 0
}
##################################################################################################
devnull() { "$@" >/dev/null 2>&1; }
killpid() { devnull kill -9 "$(pidof "$1")"; }
hostname2ip() { getent hosts "$1" | cut -d' ' -f1 | head -n1; }
__command() {
  local cmd
  for cmd in "$@"; do
    type -P "$1" | grep -q "/" 2>/dev/null
  done
}
set_trap() { trap -p "$1" | grep "$2" &>/dev/null || trap '$2' "$1"; }
getuser() { [ -z "$1" ] && cut -d: -f1 /etc/passwd | grep "$USER" || cut -d: -f1 /etc/passwd | grep "$1"; }
log() {
  mkdir -p "$HOME/.local/log"
  "$@" >"$HOME/.local/log/$APPNAME.log" 2>"$HOME/.local/log/$APPNAME.err"
}
##################################################################################################
#alternative names
tf() { [ -f "$(builtin type -P tinyfigue 2>/dev/null)" ] || [ -f "$(builtin type -P tf 2>/dev/null)" ] || return 1; }
httpd() { [ -f "$(builtin type -P httpd 2>/dev/null)" ] || [ -f "$(builtin type -P apache2 2>/dev/null)" ] || [ -f "$(builtin type -P apache 2>/dev/null)" ] || return 1; }
cron() { [ -f "$(builtin type -P crond 2>/dev/null)" ] || [ -f "$(builtin type -P cron 2>/dev/null)" ] || return 1; }
grub() { [ -f "$(builtin type -P grub-install 2>/dev/null)" ] || [ -f "$(builtin type -P grub2-install 2>/dev/null)" ] || return 1; }
cowsay() { [ -f "$(builtin type -P cowsay 2>/dev/null)" ] || [ -f "$(builtin type -P cowpatty 2>/dev/null)" ] || return 1; }
fortune() { [ -f "$(builtin type -P fortune 2>/dev/null)" ] || [ -f "$(builtin type -P fortune-mod 2>/dev/null)" ] || return 1; }
mlocate() { [ -f "$(builtin type -P locate 2>/dev/null)" ] || [ -f "$(builtin type -P mlocate 2>/dev/null)" ] || return 1; }
xfce4() { [ -f "$(builtin type -P xfce4-about 2>/dev/null)" ] || return 1; }
xfce4-notifyd() { [ -f "$(builtin type -P xfce4-notifyd-config 2>/dev/null)" ] || find /usr/lib* -name "xfce4-notifyd" -type f 2>/dev/null | grep -q . || return 1; }
imagemagick() { [ -f "$(builtin type -P convert 2>/dev/null)" ] || return 1; }
fdfind() { [ -f "$(builtin type -P fdfind 2>/dev/null)" ] || [ -f "$(builtin type -P fd 2>/dev/null)" ] || return 1; }
speedtest() { [ -f "$(builtin type -P speedtest-cli 2>/dev/null)" ] || [ -f "$(builtin type -P speedtest 2>/dev/null)" ] || return 1; }
neovim() { [ -f "$(builtin type -P nvim 2>/dev/null)" ] || [ -f "$(builtin type -P neovim 2>/dev/null)" ] || return 1; }
chromium() { [ -f "$(builtin type -P chromium 2>/dev/null)" ] || [ -f "$(builtin type -P chromium-browser 2>/dev/null)" ] || return 1; }
firefox() { [ -f "$(builtin type -P firefox-esr 2>/dev/null)" ] || [ -f "$(builtin type -P firefox 2>/dev/null)" ] || return 1; }
powerline-status() { [ -f "$(builtin type -P powerline-config 2>/dev/null)" ] || [ -f "$(builtin type -P powerline-daemon 2>/dev/null)" ] || return 1; }
gtk-2.0() { find /lib* /usr* -iname "*libgtk*2*.so*" -type f 2>/dev/null | grep -q . || return 1; }
gtk-3.0() { find /lib* /usr* -iname "*libgtk*3*.so*" -type f 2>/dev/null | grep -q . || return 1; }
transmission-remote-cli() { [ -f "$(builtin type -P transmission-remote-cli 2>/dev/null)" ] || [ -f "$(builtin type -P transmission-remote 2>/dev/null)" ] || return 1; }
transmission() { [ -f "$(builtin type -P transmission-remote)" ] || [ -f "$(builtin type -P transmission-remote-cli)" ] || [ -f "$(builtin type -P transmission-remote-gtk)" ] || return 1; }
libvirt() { [ -f "$(builtin type -P libvirtd)" ] && return 0 || return 1; }
qemu() { [ -f "$(builtin type -P qemu-img)" ] && return 0 || return 1; }

##################################################################################################
rm_rf() { if [ -e "$1" ]; then devnull rm -Rf "$@"; fi; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; fi; }
ln_rm() { devnull find "$1" -xtype l -delete; }
ln_sf() {
  [ -L "$2" ] && rm_rf "$2"
  devnull ln -sf "$@"
}
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; fi; }
mkd() { devnull mkdir -p "$@"; }
replace() { find "$1" -not -path "$1/.git/*" -type f -exec sed -i "s#$2#$3#g" {} \; >/dev/null 2>&1; }
rmcomments() { sed 's/[[:space:]]*#.*//;/^[[:space:]]*$/d'; }
countwd() { cat "$@" | wc-l | rmcomments; }
urlcheck() { devnull curl --output /dev/null --silent --head --fail "$1"; }
urlinvalid() { if [ -z "$1" ]; then printf_red "\t\tInvalid URL\n"; else
  printf_red "\t\tCan't find $1\n"
  exit 1
fi; }
urlverify() { urlcheck $1 || urlinvalid $1; }
symlink() { ln_sf "$1" "$2"; }
##################################################################################################
system_service_enable() { execute "sudo systemctl enable -f $*" "Enabling services: $*"; }
system_service_disable() { execute "sudo systemctl disable --now $*" "Disabling services: $*"; }
##################################################################################################
generate_icon_index() { sudo fc-cache -f "${1:-$APPDIR/$APPNAME}"; }
##################################################################################################
generate_theme_index() {
  sudo find "${1:-$APPDIR/$APPNAME}" -mindepth 1 -maxdepth 2 -type d -not -path "${1:-$APPDIR/$APPNAME}/.git/*" | while read -r THEME; do
    if [ -f "$THEME/index.theme" ]; then
      gtk-update-icon-cache -f -q "$THEME"
    fi
  done
}
##################################################################################################
retry_cmd() {
  retries="${1:-}"
  shift
  count=0
  until "$@"; do
    exit=$?
    wait=$((2 ** count))
    count=$((count + 1))
    if [ "$count" -lt "$retries" ]; then
      echo "Retry $count/$retries exited $exit, retrying in $wait seconds ..."
      sleep $wait
    else
      echo "Retry $count/$retries exited $exit, no more retries left."
      exit $exit
    fi
  done
}
##################################################################################################
backupapp() {
  local filename count backupdir rmpre4vbackup
  [ ! -z "$1" ] && local myappdir="$1" || local myappdir="$APPDIR"
  [ ! -z "$2" ] && local myappname="$2" || local myappname="$APPNAME"
  local backupdir="${MY_BACKUP_DIR:-$HOME/.local/backups/dotfiles}"
  local filename="$myappname-$(date +%Y-%m-%d-%H-%M-%S).tar.gz"
  local count="$(ls $backupdir/$myappname*.tar.gz 2>/dev/null | wc -l 2>/dev/null)"
  local rmpre4vbackup="$(ls $backupdir/$myappname*.tar.gz 2>/dev/null | head -n 1)"
  mkdir -p "$backupdir"
  if [ -e "$myappdir" ] && [ ! -d $myappdir/.git ]; then
    echo "#################################" >>"$backupdir/$myappname.log"
    echo "# Started on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$backupdir/$myappname.log"
    echo "# Backing up $myappdir" >>"$backupdir/$myappname.log"
    echo "#################################" >>"$backupdir/$myappname.log"
    tar cfzv "$backupdir/$filename" "$myappdir" >>"$backupdir/$myappname.log" 2>&1 &&
      echo -e "Backup has completed successfully\n#################################\n\n" >>"$backupdir/$myappname.log"
    rm -Rf "$myappdir"
  fi
  if [ "$count" -gt "3" ]; then rm_rf $rmpre4vbackup; fi
}
##################################################################################################
returnexitcode() {
  local RETVAL="$?"
  EXIT="$RETVAL"
  if [ "$RETVAL" -ne 0 ]; then
    return "$EXIT"
  fi
}
##################################################################################################
getexitcode() {
  local RETVAL="$?"
  local ERROR="Setup failed"
  local SUCCES="$1"
  EXIT="$RETVAL"
  if [ "$RETVAL" -eq 0 ]; then
    printf_success "$SUCCES"
  else
    printf_error "$ERROR"
    exit "$EXIT"
  fi
}
##################################################################################################
failexitcode() {
  local RETVAL="$?"
  [ ! -z "$1" ] && local fail="$1" || local fail="Command has failed"
  [ ! -z "$2" ] && local success="$2" || local success=""
  if [ "$RETVAL" -ne 0 ]; then
    printf_error "$fail"
    exit 1
  else
    [ -z "$success" ] || printf_custom "42" "$success"
  fi
}
##################################################################################################
setexitstatus() {
  [ -z "$EXIT" ] && local EXIT="$?" || local EXIT="$EXIT"
  local EXITSTATUS+="$EXIT"
  if [ -z "$EXITSTATUS" ] || [ "$EXITSTATUS" -ne 0 ]; then
    BG_EXIT="${BG_RED}"
    return 1
  else
    BG_EXIT="${BG_GREEN}"
    return 0
  fi
}
##################################################################################################
get_answer() { printf "%s" "$REPLY"; }
ask() {
  printf_question "$1"
  read -r
}
answer_is_yes() { [[ "$REPLY" =~ ^[Yy]$ ]] && return 0 || return 1; }
ask_for_confirmation() {
  printf_question "$1 (y/n) "
  read -r -n 1
  printf "\n"
}
##################################################################################################
__getip() {
  NETDEV="$(ip route 2>/dev/null | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")"
  CURRIP4="$(/sbin/ifconfig $NETDEV 2>/dev/null | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed 's#addr:##g' | head -n1)"
}
__getip
##################################################################################################
__getpythonver() {
  if builtin type -P python3 &>/dev/null; then
    PYTHONBIN="python3"
  elif builtin type -P python2 &>/dev/null; then
    PYTHONBIN="python2"
  else
    PYTHONBIN="python"
  fi
  [[ -n "$PYTHONBIN" ]] || return 1
  if [[ "$($PYTHONBIN -V 2>/dev/null)" =~ "Python 3" ]]; then
    PYTHONVER="python3"
    PIP="pip3"
    PATH="${PATH}:$($PYTHONBIN -c 'import site; print(site.USER_BASE)')/bin"
  elif [[ "$($PYTHONBIN -V 2>/dev/null)" =~ "Python 2" ]]; then
    PYTHONVER="python"
    PIP="pip"
    PATH="${PATH}:$($PYTHONBIN -c 'import site; print(site.USER_BASE)')/bin"
  fi
  if [ -f "$(builtin type -P yay 2>/dev/null)" ] || [ -f "$(builtin type -P pacman 2>/dev/null)" ]; then
    PYTHONVER="python"
    PIP="pip3"
  fi
  [ -n "$PYTHONVER" ] || PYTHONVER=python3
  [ -n "$PIP" ] || PIP=pip3
}
__getpythonver
##################################################################################################
__getphpver() {
  if cmdif php; then
    PHPVER="$(php -v | grep --only-matching --perl-regexp "(PHP )\d+\.\\d+\.\\d+" | cut -c 5-7)"
  else
    PHPVER=""
  fi
  echo $PHPVER
}
##################################################################################################
sudoif() { (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; }
sudorun() { if sudoif; then sudo -HE "$@"; else "$@"; fi; }
sudorerun() {
  local ARGS="$ARGS"
  if [[ $UID != 0 ]]; then if sudoif; then sudo -HE "$APPNAME" "$ARGS" && exit $?; else sudoreq; fi; fi
}
sudoreq() {
  sudo_check=$(sudo -H -S -- echo SUDO_OK 2>&1 &)
  [[ $sudo_check == "SUDO_OK" ]] && return
  if [[ $UID != 0 ]]; then
    if builtin type -P ask_for_password &>/dev/null; then
      [[ "$SUDO_SUCCESS" = "TRUE" ]] || ask_for_password ${*:-true}
      export SUDO_SUCCESS="TRUE"
      return 0
    else
      printf_newline
      printf_error "Please run this script with sudo/root\n"
      exit 1
    fi
  fi
}
######################
sudoask() {
  if [ ! -f "$HOME/.sudo" ]; then
    sudo true &>/dev/null
    while true; do
      echo -e "$!" >"$HOME/.sudo"
      sudo -n true && echo -e "$$" >>"$HOME/.sudo"
      sleep 10
      rm -Rf "$HOME/.sudo"
      kill -0 "$$" || return
    done &>/dev/null &
  fi
}
######################
sudoexit() {
  if [ $? -eq 0 ]; then
    sudoask || printf_green "Getting privileges successfull continuing" &&
      sudo -n true
  else
    printf_red "Failed to get privileges"
  fi
}
######################
requiresudo() {
  if [ -f "$(command -v sudo 2>/dev/null)" ]; then
    if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
      sudoask
      sudoexit && sudo "$@"
    fi
  else
    printf_red "You dont have access to sudo\n\t\tPlease contact the syadmin for access"
    exit 1
  fi
}
##################################################################################################
versioncheck() {
  if [ -f $APPDIR/version.txt ]; then
    printf_green "\t\tChecking for updates\n"
    local NEWVERSION="$(echo $APPVERSION | grep -v "#" | tail -n 1)"
    local OLDVERSION="$(cat $APPDIR/version.txt | grep -v "#" | tail -n 1)"
    if [ "$NEWVERSION" == "$OLDVERSION" ]; then
      printf_green "No updates available current version is $OLDVERSION"
    else
      printf_blue "There is an update available"
      printf_blue "New version is $NEWVERSION and current version is $OLDVERSION"
      printf_question "Would you like to update" [y/N]
      read -n 1 -s choice
      echo ""
      if [[ $choice == "y" || $choice == "Y" ]]; then
        cd $APPDIR && git pull -q
        printf_green "Updated to latest version = $NEWVERSION"
      else
        printf_cyan "\t\tYou decided not to update\n"
      fi
    fi
  fi
  exit $?
}
##################################################################################################
scripts_check() {
  local REPO="${DOTFILESREPO:-https://github.com/dfmgr}"
  if ! builtin command -v "pkmgr" &>/dev/null && [ ! -f "$HOME/.noscripts" ]; then
    printf_red "\t\tPlease install my scripts repo - requires root/sudo\n"
    printf_question "Would you like to do that now" [y/N]
    read -n 1 -s choice
    echo ""
    if [[ $choice == "y" || $choice == "Y" ]]; then
      urlverify "$REPO/scripts/raw/$GIT_DEFAULT_BRANCH/install.sh"
      sudo bash -c "$(curl -LSs $REPO/scripts/raw/$GIT_DEFAULT_BRANCH/install.sh)"
    else
      touch "$HOME/.noscripts"
      exit 1
    fi
  fi
}
##################################################################################################
cmdif() {
  local package=$1
  builtin command -v "$package" &>/dev/null
  if builtin command -v "$package" &>/dev/null; then return 0; else return 1; fi
}
perlif() {
  local package=$1
  if devnull perl -M$package -le 'print $INC{"$package/Version.pm"}'; then return 0; else return 1; fi
}
pythonif() {
  local package=$1
  if devnull $PYTHONVER -c "import $package"; then return 0; else return 1; fi
}
##################################################################################################
cmd_missing() { cmdif "$1" || MISSING+="$1 "; }
perl_missing() { perlif $1 || MISSING+="perl-$1 "; }
python_missing() { pythonif "$1" || MISSING+="$PYTHONVER-$1 "; }
##################################################################################################
git_clone() {
  local repo="$1"
  [ ! -z "$2" ] && local myappdir="$2" || local myappdir="$APPDIR"
  [ ! -d "$myappdir" ] || rm_rf "$myappdir"
  devnull git clone --depth=1 -q --recursive "$@"
}
##################################################################################################
git_update() {
  cd "$APPDIR"
  local repo="$(git remote -v | grep fetch | head -n 1 | awk '{print $2}')"
  devnull git reset --hard &&
    devnull git pull --recurse-submodules -fq &&
    devnull git submodule update --init --recursive -q &&
    devnull git reset --hard -q
  if [ "$?" -ne "0" ]; then
    cd "$HOME"
    backupapp "$APPDIR" "$APPNAME" &&
      devnull rm_rf "$APPDIR" &&
      git_clone "$repo" "$APPDIR"
  fi
}
##################################################################################################
dotfilesreq() {
  local REPO="${DOTFILESREPO:-https://github.com/dfmgr}"
  local conf=""
  local confdir="$HOME/.local/share/CasjaysDev/apps"
  for conf in "$@"; do
    if [ ! -f "$confdir/$conf" ]; then
      urlverify "$REPO/$conf/raw/$GIT_DEFAULT_BRANCH/install.sh"
      bash -c "$(curl -LSs $REPO/$conf/raw/$GIT_DEFAULT_BRANCH/install.sh)"
    fi
  done
}
##################################################################################################
dotfilesreqadmin() {
  local REPO="${DOTFILESREPO:-https://github.com/dfmgr}"
  local conf=""
  local confdir="$HOME/.local/share/CasjaysDev/apps"
  for conf in "$@"; do
    if [ ! -f "$confdir/$conf" ]; then
      urlverify "$REPO/$conf/raw/$GIT_DEFAULT_BRANCH/install.sh"
      sudo bash -c "$(curl -LSs $REPO/$conf/raw/$GIT_DEFAULT_BRANCH/install.sh)"
    fi
  done
}
##################################################################################################
install_packages() {
  local MISSING=""
  local USER="$USER"
  for cmd in "$@"; do cmdif $cmd || MISSING+="$cmd "; done
  if [ ! -z "$MISSING" ]; then
    if builtin command -v "pkmgr" &>/dev/null; then
      printf_warning "Attempting to install missing packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        if builtin command -v yay &>/dev/null; then
          execute "pkmgr --enable-aur silent install $miss" "Installing $miss"
        else
          execute "pkmgr silent install $miss" "Installing $miss"
        fi
      done
    fi
  fi
}
##################################################################################################
install_required() {
  local MISSING=""
  for cmd in "$@"; do cmdif $cmd || MISSING+="$cmd "; done
  if [ ! -z "$MISSING" ]; then
    if builtin command -v "pkmgr" &>/dev/null; then
      printf_warning "Installing from package list"
      if builtin command -v yay &>/dev/null; then
        pkmgr --enable-aur dotfiles "$APPNAME"
      else
        pkmgr dotfiles "$APPNAME"
      fi
    fi
  fi
}
##################################################################################################
install_python() {
  local MISSING=""
  for cmd in "$@"; do python_missing "$cmd"; done
  if [ ! -z "$MISSING" ]; then
    if builtin command -v "pkmgr" &>/dev/null; then
      printf_warning "Attempting to install missing python packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        if builtin command -v yay &>/dev/null; then
          execute "pkmgr --enable-aur silent install $miss" "Installing $miss"
        else
          execute "pkmgr silent install $miss" "Installing $miss"
        fi
      done
    fi
  fi
}
##################################################################################################
install_perl() {
  local MISSING=""
  for cmd in "$@"; do perl_missing "$cmd"; done
  if [ ! -z "$MISSING" ]; then
    if builtin command -v "pkmgr" &>/dev/null; then
      printf_warning "Attempting to install missing perl packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        if builtin command -v yay &>/dev/null; then
          execute "pkmgr --enable-aur silent install $miss" "Installing $miss"
        else
          execute "pkmgr silent install $miss" "Installing $miss"
        fi
      done
    fi
  fi
}
##################################################################################################
install_pip() {
  local MISSING=""
  for cmd in "$@"; do cmdif $cmd || pip_missing $cmd; done
  if [ ! -z "$MISSING" ]; then
    if builtin command -v "pkmgr" &>/dev/null; then
      printf_warning "Attempting to install missing pip packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr pip $miss" "Installing $miss"
      done
    fi
  fi
}
##################################################################################################
install_cpan() {
  local MISSING=""
  for cmd in "$@"; do cmdif $cmd || cpan_missing "$cmd"; done
  if [ ! -z "$MISSING" ]; then
    if builtin command -v "pkmgr" &>/dev/null; then
      printf_warning "Attempting to install missing cpan packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr cpan $miss" "Installing $miss"
      done
    fi
  fi
}
##################################################################################################
install_gem() {
  local MISSING=""
  for cmd in "$@"; do cmdif $cmd || gem_missing $cmd; done
  if [ ! -z "$MISSING" ]; then
    if builtin command -v "pkmgr" &>/dev/null; then
      printf_warning "Attempting to install missing gem packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr gem $miss" "Installing $miss"
      done
    fi
  fi
}
##################################################################################################
trim() {
  local IFS=' '
  local trimmed="${@//[[:space:]]/}"
  echo "$trimmed"
}
##################################################################################################
execute() {
  kill_all_subprocesses() {
    local i=""
    for i in $(jobs -p); do
      kill "$i"
      wait "$i" &>/dev/null
    done
  }
  show_spinner() {
    local -r FRAMES='/-\|'
    local -r NUMBER_OR_FRAMES=${#FRAMES}
    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"
    local i=0
    local frameText=""
    if [ "$TRAVIS" != "true" ]; then
      printf "\n\n\n"
      tput cuu 3
      tput sc
    fi
    while kill -0 "$PID" &>/dev/null; do
      frameText="                [ ${FRAMES:i++%NUMBER_OR_FRAMES:1} ] $MSG"
      if [ "$TRAVIS" != "true" ]; then
        printf "%s\n" "$frameText"
      else
        printf "%s" "$frameText"
      fi
      sleep 0.2
      if [ "$TRAVIS" != "true" ]; then
        tput rc
      else
        printf "\r"
      fi
    done
  }
  local -r CMDS="$1"
  local -r MSG="${2:-$1}"
  local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
  local exitCode=0
  local cmdsPID=""
  set_trap "EXIT" "kill_all_subprocesses"
  eval "$CMDS" >/dev/null 2>"$TMP_FILE" &
  cmdsPID=$!
  show_spinner "$cmdsPID" "$CMDS" "$MSG"
  wait "$cmdsPID" &>/dev/null
  exitCode=$?
  printf_execute_result $exitCode "$MSG"
  if [ $exitCode -ne 0 ]; then
    printf_execute_error_stream <"$TMP_FILE"
  fi
  rm -rf "$TMP_FILE"
  return $exitCode
}
##################################################################################################
# end
