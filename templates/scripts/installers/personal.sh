#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : GEN_SCRIPT_REPLACE_VERSION
# @Author        : GEN_SCRIPT_REPLACE_AUTHOR
# @Contact       : GEN_SCRIPT_REPLACE_EMAIL
# @License       : GEN_SCRIPT_REPLACE_LICENSE
# @ReadME        : GEN_SCRIPT_REPLACE_FILENAME --help
# @Copyright     : GEN_SCRIPT_REPLACE_COPYRIGHT
# @Created       : GEN_SCRIPT_REPLACE_DATE
# @File          : GEN_SCRIPT_REPLACE_FILENAME
# @Description   : GEN_SCRIPT_REPLACE_DESC
# @TODO          : GEN_SCRIPT_REPLACE_TODO
# @Other         : GEN_SCRIPT_REPLACE_OTHER
# @Resource      : GEN_SCRIPT_REPLACE_RES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202111171035-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/main/functions}"
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
# user system devenv dfmgr dockermgr fontmgr iconmgr pkmgr systemmgr thememgr wallpapermgr
user_installdirs
show_optvars "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Options
PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl/cpan"
# Set primary dir
DOTFILES="${DOTFILES_PERSONAL:-$HOME/.local/dotfiles/personal}"
# Set the temp directory
DOTTEMP="${DOTTEMP:-/tmp/dotfiles-personal-$USER}"
#Modify and set if using the auth token
AUTHTOKEN="${GITHUB_ACCESS_TOKEN:-YOUR_AUTH_TOKEN}"
# either http https or git
GITPROTO="https://"
#Your git repo
GITREPO="${MYPERSONALGITREPO:-github.com/dfmgr/personal}"
#scripts repo
SCRIPTSREPO="https://github.com/dfmgr/installer"
# Git Command - Private Repo
GITURL="$GITPROTO$AUTHTOKEN:x-oauth-basic@$GITREPO"
#Public Repo
#GITURL="$GITPROTO$GITREPO"
# Default NTP Server
NTPSERVER="ntp.casjay.net"
# Set tmpfile
TMP_FILE="$(mktemp /tmp/dfmpersonal-XXXXXXXXX)"
# Set Options
OPTIONS="$*"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
rm -Rf "$TMP_FILE" /tmp/dfmpersonal-* &>/dev/null
if cmd_exists sudo; then sudo echo; fi
clear
printf "\n\n\n\n"
_pre_inst() {
  if [ -z "$AUTHTOKEN" ] || [ "$AUTHTOKEN" == "YOUR_AUTH_TOKEN" ]; then
    printf_red "AUTH Token is not set"
    exit 1
  fi
  if [ ! -f "$(which sudo 2>/dev/null)" ] && [[ $EUID -ne 0 ]]; then
    printf_red "Sudo is needed, however its not installed installed"
    exit 1
  fi
  if [ ! -d "$DOTFILES/.git" ]; then rm -Rf "$DOTFILES"; fi
  if [ -d "$DOTTEMP" ]; then rm -Rf "$DOTTEMP"; fi
  if [[ "$OSTYPE" =~ ^linux ]]; then
    if ! cmd_exists systemmgr; then
      if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
        sudo bash -c "$(curl -LSs https://github.com/systemmgr/installer/raw/main/install.sh)"
        sudo bash -c "$(curl -LSs https://github.com/systemmgr/installer/raw/main/install.sh)"
      else
        printf_red 'Please run sudo bash -c "$(curl -LSs https://github.com/systemmgr/installer/raw/main/install.sh)"'
        exit 1
      fi
    fi
  fi
  if cmd_exists sudoers; then
    sudoers nopass
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_git_repo_init() {
  if [ -d "$DOTFILES"/.git ]; then
    git -C "$DOTFILES" reset --hard &>/dev/null && git -C "$DOTFILES" pull -f
    getexitcode "repo update successfull" "git pull failed for $DOTFILES"
  else
    git clone "$GITURL" "$DOTFILES"
    getexitcode "git clone successfull" "git clone $GITURL has failed"
  fi
  if [ -d "$DOTFILES" ]; then cp -Rf "$DOTFILES" "$DOTTEMP" &>/dev/null; fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_scripts_init() {
  install_all_dfmgr() { dfmgr install --all || return 1; }
  install_basic_dfmgr() { dfmgr install misc bash git vim || return 1; }
  install_server_dfmgr() { dfmgr install bash git tmux vifm vim || return 1; }
  install_desktopmgr() { desktopmgr install awesome bspwm i3 openbox qtile xfce4 xmonad || return 1; }

  for sudoconf in installer ssh ssl; do
    sudo systemmgr --config &>/dev/null
    sudo systemmgr install $sudoconf
  done
  dfmgr --config &>/dev/null
  if [[ "$OSTYPE" =~ ^linux ]]; then
    if [ "$1" = "--all" ]; then
      install_all_dfmgr
    elif [ "$1" = "--server" ]; then
      install_server_dfmgr
    elif [ "$1" = "--desktop" ]; then
      install_basic_dfmgr
      install_desktopmgr
    elif [ "$1" = "" ]; then
      install_basic_dfmgr
    fi
  else
    install_basic_dfmgr
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_root_init() {
  # Copy gpg ssh to root
  if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
    sudo mkdir -p "/root/.ssh"
    sudo rsync -ahqk "$DOTTEMP/home/.ssh/." /root/.ssh/
    sudo chmod -Rf 600 /root/.ssh/
    sudo chmod -f 700 /root/.ssh
    sudo chown -Rf root:root /root
    [[ -d "/personal" ]] && sudo rm -R "/personal"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_files_init() {
  [ -d "$DOTTEMP" ] || DOTTEMP="$DOTFILES"
  GPG_TTY="$(tty)"
  unalias cp &>/dev/null
  find "$HOME/" -xtype l -delete &>/dev/null
  mkdir -p "$HOME"/.ssh "$HOME"/.gnupg &>/dev/null
  chmod -Rf 755 "$DOTTEMP"/system/usr/local/bin/* &>/dev/null
  chmod -Rf 755 "$DOTTEMP"/home/.local/bin/* &>/dev/null
  find "$DOTTEMP"/home -type f -iname "*.bash" -exec chmod 755 -Rf {} \; &>/dev/null
  find "$DOTTEMP"/home -type f -iname "*.sh" -exec chmod 755 -Rf {} \; &>/dev/null
  find "$DOTTEMP"/home -type f -iname "*.pl" -exec chmod 755 -Rf {} \; &>/dev/null
  find "$DOTTEMP"/home -type f -iname "*.cgi" -exec chmod 755 -Rf {} \; &>/dev/null
  find "$DOTTEMP"/system -type f -iname "*.bash" -exec chmod 755 -Rf {} \; &>/dev/null
  find "$DOTTEMP"/system -type f -iname "*.sh" -exec chmod 755 -Rf {} \; &>/dev/null
  find "$DOTTEMP"/system -type f -iname "*.pl" -exec chmod 755 -Rf {} \; &>/dev/null
  find "$DOTTEMP"/system -type f -iname "*.cgi" -exec chmod 755 -Rf {} \; &>/dev/null

  rsync -ahqk "$DOTTEMP"/home/. "$HOME/"

  # import podcast feeds
  if cmd_exists castero; then
    if [[ -f "$HOME"/.config/castero/podcasts.opml ]]; then
      castero --import "$HOME"/.config/castero/podcasts.opml &>/dev/null
    elif [[ -f "$DOTTEMP"/tmp/podcasts.opml ]]; then
      castero --import "$DOTTEMP"/tmp/podcasts.opml &>/dev/null
    fi
  fi

  # import rss feeds
  if cmd_exists newsboat; then
    if [[ -f "$HOME"/.config/newsboat/news.opml ]]; then
      newsboat -i "$HOME"/.config/newsboat/news.opml &>/dev/null
    elif [[ -f "$DOTTEMP"/tmp/news.opml ]]; then
      newsboat -i "$DOTTEMP"/tmp/news.opml &>/dev/null
    fi
  fi

  find "$HOME"/.gnupg "$HOME"/.ssh -type f -exec chmod 600 {} \; &>/dev/null
  find "$HOME"/.gnupg "$HOME"/.ssh -type d -exec chmod 700 {} \; &>/dev/null
  chmod 755 -f "$HOME" &>/dev/null
  mkdir -p "$HOME"/{Projects,Music,Videos,Downloads,Pictures,Documents}
  rm -Rf "$HOME/.local/share/mail/*/.keep" &>/dev/null
  rm -Rf "$TMP_FILE" /tmp/dfmpersonal-*
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_gpg_init() {
  GPG_TTY="$(tty)"
  # Import gpg keys - user
  gpg --import "$DOTTEMP"/tmp/*.gpg 2>/dev/null
  gpg --import "$DOTTEMP"/tmp/*.sec 2>/dev/null
  gpg --import "$DOTTEMP"/tmp/*.asc 2>/dev/null
  gpg --import-ownertrust "$DOTTEMP"/tmp/*.trust 2>/dev/null
  # Import gpg keys - root
  sudo GPG_TTY="$(tty)" gpg --import "$DOTTEMP"/tmp/*.gpg 2>/dev/null
  sudo GPG_TTY="$(tty)" gpg --import "$DOTTEMP"/tmp/*.sec 2>/dev/null
  sudo GPG_TTY="$(tty)" gpg --import "$DOTTEMP"/tmp/*.asc 2>/dev/null
  sudo GPG_TTY="$(tty)" gpg --import-ownertrust "$DOTTEMP"/tmp/*.trust 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main() {
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "Initializing the installer please wait"
  am_i_online && execute "_pre_inst $OPTIONS" "Loading......."
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "Setting up the git repo: $GITREPO"
  am_i_online && execute "_git_repo_init $OPTIONS" "Initializing git repo"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "The installer is updating the scripts"
  am_i_online && execute "_scripts_init $OPTIONS" "Installing scripts"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "Installing your personal files"
  execute "_files_init $OPTIONS" "Installing files"
  printf_blue "Installing your personal files completed"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "Installing your personal files for root"
  execute "_root_init $OPTIONS" "Installing files for root"
  printf_blue "Installing your personal files for root completed"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "Installing your gpg keys"
  if _gpg_init; then
    printf_blue "Installing your personal gpg keys completed"
  else
    printf_red "Installing your personal gpg keys has failed"
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf '\n'
  unset __colors DOTTEMP MIN UPDATE DESKTOP
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# finally run application
main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit "${exitCode:-$?}"
