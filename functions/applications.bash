#!/usr/bin/env bash

export PATH="$(echo /usr/local/bin:$PATH:/usr/sbin:/sbin | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's#::#:.#g')"

#trap '' err exit SIGINT SIGTERM
if [ -n "$DISPLAY" ] && [ -f "$(command -v ask_for_password 2>/dev/null)" ]; then
  export SUDO_ASKPASS="/usr/local/bin/ask_for_password"
  export SUDO_PROMPT="/usr/local/bin/ask_for_password"
else
  export SUDO_ASKPASS="${SUDO_ASKPASS:-}"
  export SUDO_PROMPT="$(printf "\n\t\t\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m" && echo)"
fi
export WHOAMI="${USER}"
export RUN_USER="${RUN_USER:-$USER}"

TMP="${TMP:-/tmp}"
TEMP="${TEMP:-/tmp}"

APPNAME="${APPNAME:-app-installer}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        : install
# @Created     : Wed, Aug 05, 2020, 02:00 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description : functions for installed apps
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devnull() { "$@" >/dev/null 2>&1 || return $?; }

# fail if git is not installed

if ! command -v "git" >/dev/null 2>&1; then
  echo -e "\t\t\033[0;31mGit is not installed\033[0m"
  exit 1
fi

##################################################################################################

case "$(uname -s)" in
Darwin) alias dircolors=gdircolors ;;
esac

##################################################################################################

# Set Main Repo for dotfiles
export DFMGRREPO="${DFMGRREPO:-https://github.com/dfmgr}"
export PKMGRREPO="${PKMGRREPO:-https://github.com/pkmgr}"
export DEVENVMGR="${DEVENVMGR:-https://github.com/devenvmgr}"
export ICONMGRREPO="${ICONMGRREPO:-https://github.com/iconmgr}"
export FONTMGRREPO="${FONTMGRREPO:-https://github.com/fontmgr}"
export THEMEMGRREPO="${THEMEMGRREPO:-https://github.com/thememgr}"
export DOCKERMGRREPO="${DOCKERMGRREPO:-https://github.com/dockermgr}"
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
printf_read() { printf_color "\t\t$1" 5; }
printf_success() { printf_color "\t\t[ ✔ ] $1\n" 2; }
printf_error() { printf_color "\t\t[ ✖ ] $1 $2\n" 1; }
printf_warning() { printf_color "\t\t[ ❗ ] $1\n" 3; }
printf_question() { printf_color "\t\t[ ❓ ] $1 " 6; }
printf_error_stream() { while read -r line; do printf_error "↳ ERROR: $line"; done; }
printf_execute_success() { printf_color "\t\t[ ✔ ] $1\n" 2; }
printf_execute_error() { printf_color "\t\t[ ✖ ] $1 $2\n" 1; }
printf_execute_result() {
  if [ "$1" -eq 0 ]; then printf_execute_success "$2"; else printf_execute_error "$2"; fi
  return "$1"
}

printf_execute_error_stream() { while read -r line; do printf_execute_error "↳ ERROR: $line"; done; }
printf_not_found() { if ! cmd_exists "$1"; then printf_exit "The $1 command is not installed"; fi; }

##################################################################################################

printf_exit() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg " "$color"
  echo ""
  exit 1
}

##################################################################################################

printf_help() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="2"
  printf_color "\t\t$1" "$color"
  echo ""
  exit 0
}

##################################################################################################

printf_readline() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="3"
  while read line; do
    printf_custom "$color" "$line"
  done
  set +o pipefail
}

##################################################################################################

printf_newline() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="3"
  while read line; do
    printf_color "\t\t$line\n" "$color"
  done
  set +o pipefail
}

##################################################################################################

printf_custom() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="3"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
  echo ""
}

##################################################################################################

printf_custom_question() {
  local custom_question
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg " "$color"
}

##################################################################################################

printf_read_question() {
  printf_question "$1 is not installed Would you like install it"
}

##################################################################################################

printf_head() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  local msg="$*"
  shift
  printf_color "
\t\t##################################################
\t\t$msg
\t\t##################################################\n\n" "$color"
}

##################################################################################################

printf_result() {
  [ ! -z "$1" ] && EXIT="$1" || EXIT="$?"
  [ ! -z "$2" ] && local OK="$2" || local OK="Command executed successfully"
  [ ! -z "$3" ] && local FAIL="3" || local FAIL="Command has failed"
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
  cmd_exists notify-send && notify-send -u normal -i "notification-message-IM" "$title" "$msg" || return 0
}
##################################################################################################

mkd() { if [ ! -e "$1" ]; then devnull mkdir -p "$@"; else return 0; fi; }

ensure_dirs() {
  if [[ $EUID -ne 0 ]] || [[ "$WHOAMI" != "root" ]]; then
    mkd "$BIN"
    mkd "$SHARE"
    mkd "$LOGDIR"
    mkd "$LOGDIR/dfmgr"
    mkd "$LOGDIR/fontmg"
    mkd "$LOGDIR/iconmgr"
    mkd "$LOGDIR/systemmgr"
    mkd "$LOGDIR/thememgr"
    mkd "$LOGDIR/wallpapermgr"
    mkd "$COMPDIR"
    mkd "$STARTUP"
    mkd "$BACKUPDIR"
    mkd "$FONTDIR"
    mkd "$ICONDIR"
    mkd "$THEMEDIR"
    mkd "$FONTCONF"
    mkd "$CASJAYSDEVSHARE"
    mkd "$CASJAYSDEVSAPPDIR"
    mkd "$USRUPDATEDIR"
    mkd "$SYSUPDATEDIR"
    mkd "$SHARE/applications"
    mkd "$SHARE/CasjaysDev/functions"
    mkd "$SHARE/wallpapers/system"
  fi
  return 0
}

##################################################################################################

user_installdirs() {
  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    export INSTALL_TYPE=user
    if [[ "$OSTYPE" =~ ^darwin ]]; then
      export HOME="/usr/local/share/CasjaysDev/root"
    else
      export HOME="/root"
    fi
    export BIN="$HOME/.local/bin"
    export CONF="$HOME/.config"
    export SHARE="$HOME/.local/share"
    export LOGDIR="$HOME/.local/log"
    export STARTUP="$HOME/.config/autostart"
    export SYSBIN="/usr/local/bin"
    export SYSCONF="/usr/local/etc"
    export SYSSHARE="/usr/local/share"
    export SYSLOGDIR="/usr/local/log"
    export BACKUPDIR="$HOME/.local/backups/dotfiles"
    export COMPDIR="$HOME/.local/share/bash-completion/completions"
    export THEMEDIR="$SHARE/themes"
    export ICONDIR="$SHARE/icons"
    export FONTDIR="$SHARE/fonts"
    export FONTCONF="$SYSCONF/fontconfig/conf.d"
    export CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    export CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    export WALLPAPERS="${WALLPAPERS:-$SYSSHARE/wallpapers}"
    #USRUPDATEDIR="$SHARE/CasjaysDev/apps/dotfiles"
    #SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/dotfiles"
  else
    export INSTALL_TYPE=user
    export HOME="${HOME}"
    export BIN="$HOME/.local/bin"
    export CONF="$HOME/.config"
    export SHARE="$HOME/.local/share"
    export LOGDIR="$HOME/.local/log"
    export STARTUP="$HOME/.config/autostart"
    export SYSBIN="$HOME/.local/bin"
    export SYSCONF="$HOME/.config"
    export SYSSHARE="$HOME/.local/share"
    export SYSLOGDIR="$HOME/.local/log"
    export BACKUPDIR="$HOME/.local/backups/dotfiles"
    export COMPDIR="$HOME/.local/share/bash-completion/completions"
    export THEMEDIR="$SHARE/themes"
    export ICONDIR="$SHARE/icons"
    export FONTDIR="$SHARE/fonts"
    export FONTCONF="$SYSCONF/fontconfig/conf.d"
    export CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    export CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    export WALLPAPERS="$HOME/.local/share/wallpapers"
    #USRUPDATEDIR="$SHARE/CasjaysDev/apps/dotfiles"
    #SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/dotfiles"
  fi
}

user_installdirs

##################################################################################################

system_installdirs() {
  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    #printf_info "Install Type: system - ${WHOAMI}"
    #printf_red "\t\tInstalling as root ❓\n"
    export INSTALL_TYPE=system
    export BACKUPDIR="$HOME/.local/backups/dotfiles"
    if [[ "$OSTYPE" =~ ^darwin ]]; then
      export HOME="/usr/local/share/CasjaysDev/root"
    else
      export HOME="/root"
    fi
    export BIN="/usr/local/bin"
    export CONF="/usr/local/etc"
    export SHARE="/usr/local/share"
    export LOGDIR="/usr/local/log"
    export STARTUP="/dev/null"
    export SYSBIN="/usr/local/bin"
    export SYSCONF="/usr/local/etc"
    export SYSSHARE="/usr/local/share"
    export SYSLOGDIR="/usr/local/log"
    export COMPDIR="/etc/bash_completion.d"
    export THEMEDIR="/usr/local/share/themes"
    export ICONDIR="/usr/local/share/icons"
    export FONTDIR="/usr/local/share/fonts"
    export FONTCONF="/usr/local/share/fontconfig/conf.d"
    export CASJAYSDEVSHARE="/usr/local/share/CasjaysDev"
    export CASJAYSDEVSAPPDIR="/usr/local/share/CasjaysDev/apps"
    export WALLPAPERS="/usr/local/share/wallpapers"
    #USRUPDATEDIR="/usr/local/share/CasjaysDev/apps"
    #SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps"
  else
    export INSTALL_TYPE=system
    export BACKUPDIR="${BACKUPS:-$HOME/.local/backups/dotfiles}"
    export HOME="${HOME:-/home/$WHOAMI}"
    export BIN="$HOME/.local/bin"
    export CONF="$HOME/.config"
    export SHARE="$HOME/.local/share"
    export LOGDIR="$HOME/.local/log"
    export STARTUP="$HOME/.config/autostart"
    export SYSBIN="$HOME/.local/bin"
    export SYSCONF="$HOME/.local/etc"
    export SYSSHARE="$HOME/.local/share"
    export SYSLOGDIR="$HOME/.local/log"
    export COMPDIR="$HOME/.local/share/bash-completion/completions"
    export THEMEDIR="$HOME/.local/share/themes"
    export ICONDIR="$HOME/.local/share/icons"
    export FONTDIR="$HOME/.local/share/fonts"
    export FONTCONF="$HOME/.local/share/fontconfig/conf.d"
    export CASJAYSDEVSHARE="$HOME/.local/share/CasjaysDev"
    export CASJAYSDEVSAPPDIR="$HOME/.local/share/CasjaysDev/apps"
    export WALLPAPERS="$HOME/.local/share/wallpapers"
    #USRUPDATEDIR="$HOME/.local/share/CasjaysDev/apps"
    #SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps"
  fi
}

##################################################################################################

die() { echo -e "$1" exit ${2:9999}; }
devnull1() { "$@" 1>/dev/null || return $?; }
devnull2() { "$@" 2>/dev/null || return $?; }
killpid() { devnull kill -9 "$(pidof "$1")"; }
hostname2ip() { getent hosts "$1" | cut -d' ' -f1 | head -n1; }
cmd_exists() {
  local pkg LISTARRAY
  declare -a LISTARRAY="$*"
  for cmd in $LISTARRAY; do
    unalias $cmd >/devnull 2>&1
    type -P "$cmd" | grep -q "/" 2>/dev/null
  done
}
set_trap() { trap -p "$1" | grep "$2" &>/dev/null || trap '$2' "$1"; }
getuser() { [ -z "$1" ] && cut -d: -f1 /etc/passwd | grep "$USER" || cut -d: -f1 /etc/passwd | grep "$1"; }
log() {
  mkdir -p "$HOME/.local/log"
  "$@" >"$HOME/.local/log/$APPNAME.log" 2>"$HOME/.local/log/$APPNAME.err"
}
system_service_exists() {
  if sudo systemctl list-units --full -all | grep -Fq "$1"; then return 0; else return 1; fi
  setexitstatus
  set --
}
system_service_enable() {
  if system_service_exists; then execute "sudo systemctl enable -f $1" "Enabling service: $1"; fi
  setexitstatus
  set --
}
system_service_disable() {
  if system_service_exists; then execute "sudo systemctl disable --now $1" "Disabling service: $1"; fi
  setexitstatus
  set --
}
run_post() {
  local e="$1"
  local m="${e//devnull//}"
  #local m="$(echo $1 | sed 's#devnull ##g')"
  execute "$e" "executing: $m"
  setexitstatus
  set --
}

printclip() { cmd_exists xclip && xclip -o -s || return 1; }
putclip() { cmd_exists xclip && xclip -i -sel c || return 1; }

##################################################################################################

get_app_info() {
  local APPNAME="$1"
  local FILE="$SCRIPTSFUNCTDIR/bin/$APPNAME"
  if [ -f "$FILE" ]; then
    echo ""
    cat "$SCRIPTSFUNCTDIR/bin/$APPNAME" | grep "# @" | grep " : " >/dev/null 2>&1 &&
      cat "$SCRIPTSFUNCTDIR/bin/$APPNAME" | grep "# @" | grep " : " | printf_newline "3" &&
      printf_green "Scripts Version: $(cat $SCRIPTSFUNCTDIR/version.txt)" ||
      printf_red "File was found, however, No information was provided"
    echo ""
  else
    printf_red "File was not found"
  fi
  exit 0
}

##################################################################################################

#transmission-remote-cli() { cmd_exists transmission-remote-cli || cmd_exists transmission-remote; }

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

runapp() {
  local logdir="${LOGDIR:-$HOME/.local/log}"
  mkdir -p "$logdir"
  if [ "$1" = "--bg" ]; then
    local logname="$2"
    shift 2
    echo "#################################" >>"$logdir/$logname.log"
    echo "$(date +'%A, %B %d, %Y')" >>"$logdir/$logname.log"
    echo "#################################" >>"$logdir/$logname.err"
    "$@" >>"$logdir/$logname.log" 2>>"$logdir/$logname.err" &
  elif [ "$1" = "--log" ]; then
    local logname="$2"
    shift 2
    echo "#################################" >>"$logdir/$logname.log"
    echo "$(date +'%A, %B %d, %Y')" >>"$logdir/$logname.log"
    echo "#################################" >>"$logdir/$logname.err"
    "$@" >>"$logdir/$logname.log" 2>>"$logdir/$logname.err"
  else
    echo "#################################" >>"$logdir/${APPNAME:-$1}.log"
    echo "$(date +'%A, %B %d, %Y')" >>"$logdir/${APPNAME:-$1}.log"
    echo "#################################" >>"$logdir/${APPNAME:-$1}.err"
    "$@" >>"$logdir/${APPNAME:-$1}.log" 2>>"$logdir/${APPNAME:-$1}.err"
  fi
}

##################################################################################################

cmdif() {
  local package=$1
  devnull unalias "$package"
  if devnull command -v "$package"; then return 0; else return 1; fi
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
urlcheck() { devnull curl --config /dev/null --connect-timeout 3 --retry 3 --retry-delay 1 --output /dev/null --silent --head --fail "$1"; }
urlinvalid() { if [ -z "$1" ]; then
  printf_red "Invalid URL\n"
  exit 1
else
  printf_red "Can't find $1\n"
  exit 1
fi; }
urlverify() { urlcheck $1 || urlinvalid $1; }
symlink() { ln_sf "$1" "$2"; }

##################################################################################################

attemp_install_menus() {
  local prog="$1"
  if (dialog --timeout 10 --trim --cr-wrap --colors --title "install $1" --yesno "$prog in not installed! \nshould I try to install it?" 15 40); then
    sleep 2
    clear
    printf_custom "191" "\n\n\n\n\t\tattempting install of $prog\n\t\tThis could take a bit...\n\n\n"
    devnull pkmgr silent "$1"
    [ "$?" -ne 0 ] && dialog --timeout 10 --trim --cr-wrap --colors --title "failed" --msgbox "$1 failed to install" 10 41
    clear
  fi
}

##################################################################################################

custom_menus() {
  printf_custom_question "6" "Enter your custom program : "
  read custom
  printf_custom_question "6" "Enter any additional options [type file to choose] : "
  read opts
  if [ "$opts" = "file" ]; then opts="$(open_file_menus $custom)"; fi
  $custom $opts >/dev/null 2>&1 || clear
  printf_red "$custom is an invalid program"
}

##################################################################################################

run_prog_menus() {
  local prog="$1"
  shift 1
  local args="$*"
  if cmd_exists $prog; then
    devnull2 "$prog" "$@" || clear printf_red "An error has occured"
  else
    attemp_install_menus $prog &&
      devnull2 $prog $args || return 1
  fi
}

##################################################################################################

open_file_menus() {
  local prog="$1"
  shift 1
  local args="$*"
  if cmd_exists $prog; then
    local file=$(dialog --title "Play a file" --stdout --title "Please choose a file or url to play" --fselect "$HOME/" 14 48)
    [ -z "$FILE" ] && devnull2 "$prog" "$file" || clear
    printf_red "No file selected"
  else
    attemp_install_menus $prog &&
      devnull2 $prog $args || return 1
  fi
}

##################################################################################################

__getpythonver() {
  if [[ "$(python3 -V 2>/dev/null)" =~ "Python 3" ]]; then
    PYTHONVER="python3"
    PIP="pip3"
    PATH="${PATH}:$(python3 -c 'import site; print(site.USER_BASE)')/bin"
  elif [[ "$(python2 -V 2>/dev/null)" =~ "Python 2" ]]; then
    PYTHONVER="python"
    PIP="pip"
    PATH="${PATH}:$(python -c 'import site; print(site.USER_BASE)')/bin"
  fi
  if [ "$(cmdif yay)" ] || [ "$(cmdif pacman)" ]; then PYTHONVER="python" && PIP="pip3"; fi
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

setexitstatus() {
  [ ! -z "$EXIT" ] && local EXIT="$?"
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

returnexitcode() {
  if [ "$EXIT" -eq 0 ]; then
    BG_EXIT="${BG_GREEN}"
    return 0
  else
    BG_EXIT="${BG_RED}"
    return 1
  fi
}

##################################################################################################

getexitcode() {
  EXIT="$?"
  if [ ! -z "$1" ]; then
    local PSUCCES="$1"
  elif [ ! -z "$SUCCES" ]; then
    local PSUCCES="$SUCCES"
  else
    local PSUCCES="Command successful"
  fi
  if [ ! -z "$2" ]; then
    local PERROR="$2"
  elif [ ! -z "$ERROR" ]; then
    local PERROR="$ERROR"
  else
    local PERROR="Last command failed to complete"
  fi
  if [ "$EXIT" -eq 0 ]; then
    printf_cyan "$PSUCCES"
  else
    printf_red "$PERROR"
  fi
  unset ERROR SUCCES
  returnexitcode
}

##################################################################################################

getlipaddr() {
  if [[ "$OSTYPE" =~ ^darwin ]]; then
    NETDEV="$(route get default | grep interface | awk '{print $2}')"
  else
    NETDEV="$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")"
  fi
  CURRIP4="$(/sbin/ifconfig $NETDEV | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed s/addr://g | head -n1)"
}

##################################################################################################

git_clone() {
  local repo="$1"
  [ ! -z "$2" ] && local myappdir="$2" || local myappdir="$APPDIR"
  [ ! -d "$myappdir" ] || rm_rf "$myappdir"
  devnull git clone --depth=1 -q --recursive "$@"
}

##################################################################################################

git_update() {
  cd "$APPDIR" || exit 1
  local repo="$(git remote -v | grep fetch | head -n 1 | awk '{print $2}')"
  devnull git reset --hard &&
    devnull git pull --recurse-submodules -fq &&
    devnull git submodule update --init --recursive -q &&
    devnull git reset --hard -q
  if [ "$?" -ne "0" ]; then
    cd "$HOME" || exit 1
    backupapp "$APPDIR" "$APPNAME" &&
      devnull rm_rf "$APPDIR" &&
      git_clone "$repo" "$APPDIR"
  fi
}

##################################################################################################

check_app() {
  local MISSING=""
  for cmd in "$@"; do cmdif $cmd || MISSING+="$cmd "; done
  if [ ! -z "$MISSING" ]; then
    printf_question "$cmd is not installed Would you like install it" [y/N]
    read -n 1 -s choice && echo
    if [[ $choice == "y" || $choice == "Y" ]]; then
      for miss in $MISSING; do
        execute "pkmgr silent-install $miss" "Installing $miss" | printf_readline || return 1
      done
    else
      return 1
    fi
  fi
}

##################################################################################################

check_pip() {
  local MISSING=""
  for cmd in "$@"; do cmdif $cmd || MISSING+="$cmd "; done
  if [ ! -z "$MISSING" ]; then
    printf_question "$1 is not installed Would you like install it" [y/N]
    read -n 1 -s choice
    if [[ $choice == "y" || $choice == "Y" ]]; then
      for miss in $MISSING; do
        execute "pkmgr pip $miss" "Installing $miss"
      done
    fi
  else
    return 1
  fi
}

##################################################################################################

check_cpan() {
  local MISSING=""
  for cmd in "$@"; do cmdif $cmd || MISSING+="$cmd "; done
  if [ ! -z "$MISSING" ]; then
    printf_question "$1 is not installed Would you like install it" [y/N]
    read -n 1 -s choice
    if [[ $choice == "y" || $choice == "Y" ]]; then
      for miss in $MISSING; do
        execute "pkmgr cpan $miss" "Installing $miss"
      done
    fi
  else
    return 1
  fi

}

##################################################################################################

git_clone() {
  local repo="$1"
  rm_rf "$2"
  devnull git clone --depth=1 -q --recursive "$@"
}

##################################################################################################

git_update() {
  local repo="$(git remote -v | grep fetch | head -n 1 | awk '{print $2}')"
  devnull git reset --hard &&
    devnull git pull --recurse-submodules -fq &&
    devnull git submodule update --init --recursive -q &&
    devnull git reset --hard -q
  if [ "$?" -ne "0" ]; then
    cd "$HOME" || exit 1
    backupapp &&
      devnull git_clone "$repo" $APPDIR
  fi
}

##################################################################################################

can_i_sudo() {
  (
    ISINDSUDO=$(sudo grep -Re "$MYUSER" /etc/sudoers* | grep "ALL" >/dev/null)
    sudo -vn && sudo -ln
  ) 2>&1 | grep -v 'may not' >/dev/null
}

##################################################################################################

sudoask() {
  if [ ! -f "$HOME/.sudo" ]; then
    sudo true &>/dev/null
    while true; do
      echo "$$" >"$HOME/.sudo"
      sudo -n true
      sleep 10
      rm -Rf "$HOME/.sudo"
      kill -0 "$$" || return
    done &>/dev/null &
  fi
}

##################################################################################################

sudoexit() {
  if can_i_sudo; then
    sudoask || printf_green "Getting privileges successfull continuing"
  else
    printf_red "Failed to get privileges\n"
  fi
}

##################################################################################################

requiresudo() {
  if can_i_sudo; then
    sudoask && sudoexit && sudo "$@" 2>/dev/null
  else
    printf_red "You dont have access to sudo\n\t\tPlease contact the syadmin for access"
    return 1
  fi
}

##################################################################################################

kill_all_subprocesses() {
  local i=""
  for i in $(jobs -p); do
    kill "$i"
    wait "$i" &>/dev/null
  done
}

##################################################################################################

execute() {
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

##################################################################################################

dfmgr_install() {
  user_installdirs
  PREFIX="dfmgr"
  REPO="${DFMGRREPO}"
  REPORAW="$REPO/$APPNAME/raw"
  HOMEDIR="$CONF"
  APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$PREFIX"
  ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/array)"
  LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/list)"
  mkdir -p "$USRUPDATEDIR" "$SYSUPDATEDIR"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME" ]; then
    APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME)"
  else
    APPVERSION="N/A"
  fi
}

##################################################################################################

dockermgr_install() {
  user_installdirs
  PREFIX="dockermgr"
  REPO="${DOCKERMGRREPO}"
  REPORAW="$REPO/$APPNAME/raw"
  HOMEDIR="$SHARE/CasjaysDev/$PREFIX"
  APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$PREFIX"
  ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/array)"
  LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/list)"
  mkdir -p "$USRUPDATEDIR" "$SYSUPDATEDIR"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME" ]; then
    APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME)"
  else
    APPVERSION="N/A"
  fi
}

##################################################################################################

fontmgr_install() {
  system_installdirs
  PREFIX="fontmgr"
  REPO="${FONTMGRREPO}"
  REPORAW="$REPO/$APPNAME/raw"
  HOMEDIR="$SHARE/CasjaysDev/$PREFIX"
  APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$PREFIX"
  FONTDIR="${FONTDIR:-$SHARE/fonts}"
  ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/array)"
  LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/list)"
  mkdir -p "$USRUPDATEDIR" "$SYSUPDATEDIR" "$FONTDIR" "$HOMEDIR"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME" ]; then
    APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME)"
  else
    APPVERSION="N/A"
  fi
}

##################################################################################################

iconmgr_install() {
  system_installdirs
  PREFIX="iconmgr"
  REPO="${ICONMGRREPO}"
  REPORAW="$REPO/$APPNAME/raw"
  HOMEDIR="$SYSSHARE/CasjaysDev/$PREFIX"
  APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$PREFIX"
  ICONDIR="${ICONDIR:-$SHARE/icons}"
  ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/array)"
  LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/list)"
  mkdir -p "$USRUPDATEDIR" "$SYSUPDATEDIR" "$ICONDIR" "$HOMEDIR"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME" ]; then
    APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME)"
  else
    APPVERSION="N/A"
  fi
}

##################################################################################################

pkmgr_install() {
  PREFIX="pkmgr"
  REPO="${PKMGRREPO}"
  REPORAW="$REPO/$APPNAME/raw"
  HOMEDIR="$SYSSHARE/CasjaysDev/$PREFIX"
  APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$PREFIX"
  REPODF="https://raw.githubusercontent.com/pkmgr/dotfiles/$GIT_REPO_BRANCH"
  ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/array)"
  LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/list)"
  mkdir -p "$USRUPDATEDIR" "$SYSUPDATEDIR"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME" ]; then
    APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME)"
  else
    APPVERSION="N/A"
  fi
}

##################################################################################################

systemmgr_install() {
  system_installdirs
  PREFIX="systemmgr"
  REPO="${SYSTEMMGRREPO}"
  REPORAW="$REPO/$APPNAME/raw"
  CONF="/usr/local/etc"
  SHARE="/usr/local/share"
  HOMEDIR="/usr/local/etc"
  APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/$PREFIX"
  SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/$PREFIX"
  ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/array)"
  LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/list)"
  mkdir -p "$USRUPDATEDIR" "$SYSUPDATEDIR"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME" ]; then
    APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME)"
  else
    APPVERSION="N/A"
  fi
}

##################################################################################################

thememgr_install() {
  system_installdirs
  PREFIX="thememgr"
  REPO="${THEMEMGRREPO}"
  REPORAW="$REPO/$APPNAME/raw"
  HOMEDIR="$SYSSHARE/CasjaysDev/$PREFIX"
  APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$PREFIX"
  THEMEDIR="${THEMEDIR:-$SHARE/themes}"
  ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/array)"
  LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/list)"
  mkdir -p "$USRUPDATEDIR" "$SYSUPDATEDIR"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME" ]; then
    APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME)"
  else
    APPVERSION="N/A"
  fi
}

##################################################################################################

wallpapermgr_install() {
  system_installdirs
  PREFIX="wallpapermgr"
  REPO="${WALLPAPERMGRREPO}"
  REPORAW="$REPO/$APPNAME/raw"
  HOMEDIR="$SYSSHARE/CasjaysDev/wallpapers"
  APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/wallpapers"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/wallpapers"
  WALLPAPERS="${WALLPAPERS:-$SHARE/wallpapers}"
  ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/array)"
  LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$PREFIX/list)"
  mkdir -p "$USRUPDATEDIR" "$SYSUPDATEDIR" "$WALLPAPERS"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME" ]; then
    APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$PREFIX-$APPNAME)"
  else
    APPVERSION="N/A"
  fi
}

##################################################################################################

os_support() {
  if [ -n "$1" ]; then
    OSTYPE="$(echo $1 | tr '[:upper:]' '[:lower:]')"
  else
    OSTYPE="$(uname -s | tr '[:upper:]' '[:lower:]')"
  fi
  case "$OSTYPE" in
  linux*) echo "Linux" ;;
  mac* | darwin*) echo "MacOS" ;;
  win* | msys* | mingw* | cygwin*) echo "Windows" ;;
  bsd*) echo "BSD" ;;
  solaris*) echo "Solaris" ;;
  *) echo "Unknown OS" ;;
  esac
}

unsupported_oses() {
  for OSes in "$@"; do
    if [[ "$(echo $1 | tr '[:upper:]' '[:lower:]')" =~ $(os_support) ]]; then
      printf_red "\t\t$(os_support $OSes) is not supported\n"
      exit
    fi
  done
}

##################################################################################################

# end
