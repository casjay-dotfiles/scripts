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
# Modify and set if using the auth token
AUTHTOKEN="${GITHUB_ACCESS_TOKEN:-$MYPERSONAL_GIT_TOKEN}"
# either http https or git
GIT_PROTO="https://"
# Your git repo
GIT_REPO="${MYPERSONAL_GIT_REPO:-github.com/dfmgr/personal}"
# scripts repo
SCRIPTSREPO="https://github.com/dfmgr/installer"
# Default NTP Server
NTPSERVER="ntp.casjay.net"
# Set primary dir
DOTFILES="$HOME/.local/dotfiles/personal"
# Set the temp directory
DOTTEMP="/tmp/dotfiles-personal-$USER"
# Set tmpfile
TMP_FILE="$(mktemp /tmp/dfm-XXXXXXXXX)"
# Git Command - Private Repo
FULL_GIT_URL="$GIT_PROTO$AUTHTOKEN:x-oauth-basic@$GIT_REPO"
#Public Repo
#FULL_GIT_URL="$GIT_PROTO$GIT_REPO"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/main/functions}"
SCRIPTSFUNCTDIR="${SCRIPTSAPPFUNCTDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE"
elif [ -f "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE"
else
  mkdir -p "$HOME/.local/share/CasjaysDev/functions"
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE" || exit 1
  . "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear
sleep 1
printf_green "Initializing the installer please wait"
sleep 2
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_all_dfmgr() { dfmgr install --all || return 1; }
install_basic_dfmgr() { dfmgr install misc bash git vim || return 1; }
install_server_dfmgr() { dfmgr install bash git tmux vifm vim || return 1; }
install_desktop_dfmr() { dfmgr install awesome bspwm i3 openbox qtile xfce4 xmonad || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_pre_inst() {
  if [ -z "$AUTHTOKEN" ] || [ "$AUTHTOKEN" == "YOUR_AUTH_TOKEN" ]; then
    printf_red "AUTH Token is not set"
    exit 1
  fi
  if [ ! -f "$(which sudo 2>/dev/null)" ] && [[ $EUID -ne 0 ]]; then
    printf_red "Sudo is needed, however its not installed installed"
    exit 1
  fi

  if [ ! -d "$DOTFILES"/.git ]; then rm -Rf "$DOTFILES"; fi
  rm -Rf "$DOTTEMP" &>/dev/null

  if [[ "$OSTYPE" =~ ^linux ]]; then
    if ! cmd_exists systemmgr; then
      if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
        sudo bash -c "$(curl -LSs https://github.com/systemmgr/installer/raw/main/install.sh)"
        sudo bash -c "$(curl -LSs https://github.com/systemmgr/installer/raw/main/install.sh)"
      else
        printf_red 'please run sudo bash -c "$(curl -LSs https://github.com/systemmgr/installer/raw/main/install.sh)"'
        exit 1
      fi
    fi
  fi
  if cmd_exists "sudoers"; then
    sudoers nopass
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_git_repo_init() {
  if [ -d "$DOTFILES"/.git ]; then
    git -C "$DOTFILES" pull -f
    getexitcode "repo update successfull" "Failed to pull $DOTFILES"
  else
    git clone "$FULL_GIT_URL" "$DOTFILES"
    getexitcode "git clone successfull" "Failed to clone $FULL_GIT_URL"
  fi
  if [ -d "$DOTFILES" ]; then cp -Rf "$DOTFILES" "$DOTTEMP" &>/dev/null; fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_scripts_init() {
  for sudoconf in installer ssl; do
    sudo systemmgr install $sudoconf
  done
  if [[ "$OSTYPE" =~ ^linux ]]; then
    if [ "$1" = "--all" ]; then
      install_all_dfmgr
    elif [ "$1" = "--server" ]; then
      install_server_dfmgr
    elif [ "$1" = "--desktop" ]; then
      install_desktop_dfmgr
    elif [ "$1" = "" ]; then
      install_basic_dfmgr
    fi
  else
    install_basic_dfmgr
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_files_init() {
  GPG_TTY="$(tty)"
  unalias cp &>/dev/null
  find "$HOME/" -xtype l -delete &>/dev/null
  mkdir -p "$HOME"/.ssh "$HOME"/.gnupg &>/dev/null
  chmod -Rf 755 "$DOTTEMP"/root/skel/.local/bin/* &>/dev/null
  find "$DOTTEMP"/root -type f -iname "*.bash" -exec chmod 755 -Rf {} \; &>/dev/null
  find "$DOTTEMP"/root -type f -iname "*.sh" -exec chmod 755 -Rf {} \; &>/dev/null
  find "$DOTTEMP"/root -type f -iname "*.pl" -exec chmod 755 -Rf {} \; &>/dev/null
  find "$DOTTEMP"/root -type f -iname "*.cgi" -exec chmod 755 -Rf {} \; &>/dev/null
  rsync -ahqk "$DOTTEMP"/root/skel/. "$HOME"/ &>/dev/null
  if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
    export GPG_TTY DOTTEMP
    sudo rsync -ahq "$DOTTEMP"/root/skel/* /root/ &>/dev/null
    sudo rsync -ahq "$DOTTEMP"/root/skel/* /etc/ &>/dev/null
    sudo gpg --import "$DOTTEMP"/tmp/*.gpg 2>/dev/null
    sudo gpg --import "$DOTTEMP"/tmp/*.sec 2>/dev/null
    sudo gpg --import-ownertrust "$DOTTEMP"/tmp/*.trust 2>/dev/null
  fi

  # Import GPG keys
  export GPG_TTY
  gpg --import "$DOTTEMP"/tmp/*.gpg 2>/dev/null
  gpg --import "$DOTTEMP"/tmp/*.sec 2>/dev/null
  gpg --import-ownertrust "$DOTTEMP"/tmp/*.trust 2>/dev/null

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

  # finallize
  find "$HOME"/.gnupg "$HOME"/.ssh -type f -exec chmod 600 {} \; &>/dev/null
  find "$HOME"/.gnupg "$HOME"/.ssh -type d -exec chmod 700 {} \; &>/dev/null
  chmod 755 -f "$HOME" &>/dev/null
  rm -Rf "$HOME/.local/share/mail/*/.keep" &>/dev/null
  rm -Rf "$TMP_FILE"
  mkdir -p "$HOME"/{Projects,Music,Videos,Downloads,Pictures,Documents} &>/dev/null
}

main() {
  if [ "$DOTTEMP" != "$DOTFILES" ]; then
    if [ -d "$DOTTEMP" ]; then rm -Rf "$DOTTEMP" &>/dev/null; fi
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "Setting up the git repo: $GIT_REPO"
  execute "_pre_inst" "Setting up"
  execute "_git_repo_init" "Initializing git repo"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "The installer is updating the scripts"
  execute "_scripts_init" "Installing scripts"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "Installing your personal files"
  execute "_files_init" "Installing files"
  unset __colors DOTTEMP MIN UPDATE DESKTOP
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_green "Installing your personal files completed"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# finally run main function
main "$@"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit "$?"
# end
