#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070952-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  env.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 09:52 EDT
# @File              :  env.bash
# @Description       :  ENV functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
USER="${SUDO_USER:-$USER}"
RUN_USER="${RUN_USER:-$USER}"
USER_HOME="${USER_HOME:-$HOME}"
SRC_DIR="${BASH_SOURCE%/*}"
CASJAYSDEV_USERDIR="${CASJAYSDEV_USERDIR:-$HOME/.local/share/CasjaysDev}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
RUN_USER="$(logname 2>/dev/null)"
SUDO_USER="${RUN_USER:-$SUDO_USER}"
export RUN_USER SUDO_USER
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set Main Repo for dotfiles
GIT_REPO_BRANCH="${GIT_DEFAULT_BRANCH:-main}"
DOTFILESREPO="https://github.com/dfmgr"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set other Repos
DFMGRREPO="https://github.com/dfmgr"
DESKTOPGRREPO="https://github.com/desktopmgr"
PKMGRREPO="https://github.com/pkmgr"
DEVENVMGRREPO="https://github.com/devenvmgr"
DOCKERMGRREPO="https://github.com/dockermgr"
ICONMGRREPO="https://github.com/iconmgr"
FONTMGRREPO="https://github.com/fontmgr"
THEMEMGRREPO="https://github.com/thememgr"
SYSTEMMGRREPO="https://github.com/systemmgr"
WALLPAPERMGRREPO="https://github.com/wallpapermgr"
WHICH_LICENSE_URL="https://github.com/devenvmgr/licenses/raw/$GIT_REPO_BRANCH"
WHICH_LICENSE_DEF="$CASJAYSDEVDIR/templates/wtfpl.md"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup temp folders
TMP="${TMP:-$HOME/.local/tmp}"
TEMP="${TMP:-$HOME/.local/tmp}"
TMPDIR="${TMP:-$HOME/.local/tmp}"
mkdir -p "$TMPDIR" "$TEMP" "$TMP" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup path
[[ -d "/usr/local/opt/gnu-getopt/bin" ]] && TMPPATH="/usr/local/opt/gnu-getopt/bin:"
TMPPATH+="$HOME/.local/share/bash/basher/cellar/bin:$HOME/.local/share/bash/basher/bin:"
TMPPATH+="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/gem/bin:/usr/local/bin:"
TMPPATH+="/usr/local/share/CasjaysDev/scripts/bin:/usr/local/sbin:/usr/sbin:"
TMPPATH+="/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$PATH:."
PATH="$(echo "$TMPPATH" | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's#::#:.#g')"
unset TMPPATH
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# OS Settings
__detect_os() {
  if [ -f "$CASJAYSDEVDIR/bin/detectostype" ] && [ -z "$DISTRO_NAME" ]; then
    . "$CASJAYSDEVDIR/bin/detectostype"
  fi
} && __detect_os
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
