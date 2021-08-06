#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="GEN_SCRIPT_REPLACE_APPNAME"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

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
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/GEN_SCRIPT_REPLACE_DEFAULT_BRANCH/functions}"
connect_test() { ping -c1 1.1.1.1 &>/dev/null || curl --disable -LSs --connect-timeout 3 --retry 0 --max-time 1 1.1.1.1 2>/dev/null | grep -e "HTTP/[0123456789]" | grep -q "200" -n1 &>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
elif connect_test; then
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# INIT
clear
sleep 1
# Options
PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl/cpan"
#Modify and set if using the auth token
AUTHTOKEN="${GITHUB_ACCESS_TOKEN}"
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
# Default dotfiles dir
# Set primary dir
DOTFILES="$HOME/.local/dotfiles/personal"
# Set the temp directory
DOTTEMP="/tmp/dotfiles-personal-$USER"
# Set tmpfile
TMP_FILE="$(mktemp /tmp/dfm-XXXXXXXXX)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_green "\t\tInitializing the installer please wait\n"
sleep 2

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
install_all_dfmgr() { dfmgr install --all || return 1; }
install_basic_dfmgr() { dfmgr install misc bash git vim || return 1; }
install_server_dfmgr() { dfmgr install bash git tmux vifm vim || return 1; }
install_desktop_dfmr() { dfmgr install awesome bspwm i3 openbox qtile xfce4 xmonad || return 1; }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

_pre_inst() {
  if [ -z "$AUTHTOKEN" ] || [ "$AUTHTOKEN" == "YOUR_AUTH_TOKEN" ]; then
    printf_red "\t\tAUTH Token is not set"
    exit 1
  fi
  if [ ! -f "$(type -P sudo 2>/dev/null)" ] && [[ $EUID -ne 0 ]]; then
    printf_red "\t\tSudo is needed, however its not installed installed\n"
    exit 1
  fi
  if [ ! -d "$DOTFILES"/.git ]; then rm -Rf "$DOTFILES"; fi
  rm -Rf "$DOTTEMP" >/dev/null 2>&1
  if [[ "$OSTYPE" =~ ^linux ]]; then
    if ! cmd_exists systemmgr; then
      if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
        sudo bash -c "$(curl -LSs https://github.com/systemmgr/installer/raw/GEN_SCRIPT_REPLACE_DEFAULT_BRANCH/install.sh)"
        sudo bash -c "$(curl -LSs https://github.com/systemmgr/installer/raw/GEN_SCRIPT_REPLACE_DEFAULT_BRANCH/install.sh)"
      else
        printf_red '\t\tplease run sudo bash -c "$(curl -LSs https://github.com/systemmgr/installer/raw/GEN_SCRIPT_REPLACE_DEFAULT_BRANCH/install.sh)\n"'
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
    getexitcode "repo update successfull"
  else
    git clone "$GITURL" "$DOTFILES"
    getexitcode "git clone successfull"
  fi

  if [ -d "$DOTFILES" ]; then cp -Rf "$DOTFILES" "$DOTTEMP" >/dev/null 2>&1; fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_scripts_init() {
  for sudoconf in installer ssh; do
    sudo systemmgr install "$sudoconf"
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
  find "$HOME/" -xtype l -delete >/dev/null 2>&1
  mkdir -p "$HOME"/.ssh "$HOME"/.gnupg >/dev/null 2>&1
  chmod -Rf 755 "$DOTTEMP"/usr/local/bin/* >/dev/null 2>&1
  chmod -Rf 755 "$DOTTEMP"/root/skel/.local/bin/* >/dev/null 2>&1
  find "$DOTTEMP"/root -type f -iname "*.bash" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
  find "$DOTTEMP"/root -type f -iname "*.sh" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
  find "$DOTTEMP"/root -type f -iname "*.pl" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
  find "$DOTTEMP"/root -type f -iname "*.cgi" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
  find "$DOTTEMP"/usr -type f -iname "*.bash" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
  find "$DOTTEMP"/usr -type f -iname "*.sh" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
  find "$DOTTEMP"/usr -type f -iname "*.pl" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
  find "$DOTTEMP"/usr -type f -iname "*.cgi" -exec chmod 755 -Rf {} \; >/dev/null 2>&1

  unalias cp 2>/dev/null
  rsync -ahqk "$DOTTEMP"/root/skel/. "$HOME"/

  export GPG_TTY="$(tty)"
  if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
    mv -f "$DOTTEMP"/root/skel "$DOTTEMP"/tmp/skel >/dev/null 2>&1
    sudo rsync -ahq "$DOTTEMP"/root/* root/ >/dev/null 2>&1
    mv -f "$DOTTEMP"/tmp/skel "$DOTTEMP"/root/skel >/dev/null 2>&1
  fi

  # Import gpg keys
  gpg --import "$DOTTEMP"/tmp/*.gpg 2>/dev/null
  gpg --import "$DOTTEMP"/tmp/*.sec 2>/dev/null
  gpg --import-ownertrust "$DOTTEMP"/tmp/*.trust 2>/dev/null

  # import podcast feeds
  if cmd_exists castero; then
    if [[ -f "$HOME"/.config/castero/podcasts.opml ]]; then
      castero --import "$HOME"/.config/castero/podcasts.opml >/dev/null 2>&1
    elif [[ -f "$DOTTEMP"/tmp/podcasts.opml ]]; then
      castero --import "$DOTTEMP"/tmp/podcasts.opml >/dev/null 2>&1
    fi
  fi

  # import rss feeds
  if cmd_exists newsboat; then
    if [[ -f "$HOME"/.config/newsboat/news.opml ]]; then
      newsboat -i "$HOME"/.config/newsboat/news.opml >/dev/null 2>&1
    elif [[ -f "$DOTTEMP"/tmp/news.opml ]]; then
      newsboat -i "$DOTTEMP"/tmp/news.opml >/dev/null 2>&1
    fi
  fi

  find "$HOME"/.gnupg "$HOME"/.ssh -type f -exec chmod 600 {} \; >/dev/null 2>&1
  find "$HOME"/.gnupg "$HOME"/.ssh -type d -exec chmod 700 {} \; >/dev/null 2>&1
  chmod 755 -f "$HOME" >/dev/null 2>&1
  rm -Rf "$HOME/.local/share/mail/*/.keep" >/dev/null 2>&1
  rm -Rf "$TMP_FILE"
  mkdir -p "$HOME"/{Projects,Music,Videos,Downloads,Pictures,Documents}

}

main() {
  if [ "$DOTTEMP" != "$DOTFILES" ]; then
    if [ -d "$DOTTEMP" ]; then rm -Rf "$DOTTEMP" >/dev/null 2>&1; fi
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "\t\tSetting up the git repo: $GITREPO\n"
  execute "_pre_inst" "Setting up"
  execute "_git_repo_init" "Initializing git repo"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "\t\tThe installer is updating the scripts\n"
  execute "_scripts_init" "Installing scripts"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_blue "\t\tInstalling your personal files\n"
  execute "_files_init" "Installing files"
  unset __colors DOTTEMP MIN UPDATE DESKTOP
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  printf_green "\t\tInstalling your personal files completed\n\n"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# finally run main function
main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
