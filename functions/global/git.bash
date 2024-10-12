#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071116-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  git.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 11:16 EDT
# @File              :  git.bash
# @Description       :  git functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#git_globaluser
__git_globaluser() {
  local author="$(git config --get user.name | grep '^' || echo "$USER")"
  echo "$author"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#git_globalemail
__git_globalemail() {
  local email="$(git config --get user.email | grep '^' || echo "$USER"@"$(hostname -s)".local)"
  echo "$email"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git() {
  local exitCode=0
  local args="$*" && shift $#
  local tmpfile="${TMPDIR:-/tmp}/gitlog.$$.tmp"
  local PATH="/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin"
  git $args &>"$tmpfile"
  grep -Eqi "[rejectected]|error:|fatal:" "$tmpfile" && exitCode=1 || exitCode=0
  __rm_rf "$tmpfile"
  return ${exitCode:$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#git_clone "url" "dir"
__git_clone() {
  [ $# -ne 2 ] && printf_exit "Usage: git_clone remoteRepo localDir"
  local repo="$1"
  local dir="${2:-$dir}"
  __git_username_repo "$repo"
  [ -n "$2" ] && local dir="$2" && shift 1 || local dir="${INSTDIR:-.}"
  if [ -d "$dir/.git" ]; then
    __git_update "$dir" || false
  else
    [ -d "$dir" ] && __rm_rf "$dir"
    __git clone -q --recursive "$repo" "$dir" || false
  fi
  if [ "$?" != "0" ]; then
    printf_error "Failed to clone the repo"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#git_pull "dir"
__git_update() {
  [ -n "$1" ] && local dir="$1" && shift 1 || local dir="${INSTDIR:-.}"
  local repo="$(git -C "$dir" remote -v | grep fetch | head -n 1 | awk '{print $2}')"
  local gitrepo="$(dirname $dir/.git)"
  local reponame="${APPNAME:-$gitrepo}"
  git -C "$dir" reset --hard || return 1
  __git -C "$dir" pull --recurse-submodules -fq || return 1
  __git -C "$dir" submodule update --init --recursive -q || return 1
  git -C "$dir" reset --hard -q || return 1
  if [ "$?" != "0" ]; then
    printf_error "Failed to update the repo"
    #__backupapp "$dir" "$reponame" && __rm_rf "$dir" && git clone -q "$repo" "$dir"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#git_commit "dir"
__git_commit() {
  [ -n "$1" ] && local dir="$1" && shift 1 || local dir="${INSTDIR:-.}"
  if builtin type -P gitcommit &>/dev/null; then
    if [ -d "$2" ]; then shift 1; fi
    local mess="${*}"
    gitcommit "$dir" "$mess"
  else
    local mess="${1}"
    if [ ! -d "$dir" ]; then
      __mkd "$dir"
      git -C "$dir" init -q
    fi
    touch "$dir/README.md"
    git -C "$dir" add -A .
    if ! __git_porcelain "$dir"; then
      git -C "$dir" commit -q -m "${mess:-🏠🐜❗ Updated Files 🏠🐜❗}" | printf_readline "2"
    else
      return 0
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#git_init "dir"
__git_init() {
  [ -n "$1" ] && local dir="$1" && shift 1 || local dir="${APPDIR:-.}"
  if builtin type -P gitadmin &>/dev/null; then
    if [ -d "$2" ]; then shift 1; fi
    gitadmin --dir "$dir" setup
  else
    set --
    __mkd "$dir"
    __git -C "$dir" init -q &>/dev/null
    __git -C "$dir" add -A . &>/dev/null
    if ! __git_porcelain "$dir"; then
      git -C "$dir" commit -q -m " 🏠🐜❗ Initial Commit 🏠🐜❗ " | printf_readline "2"
    else
      return 0
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set folder name based on githost
__git_hostname() {
  echo "$@" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/" |
    awk -F. '{print $(NF-1) "." $NF}' | sed 's#\..*##g'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#setup directory structure
__git_username_repo() {
  unset protocol separator hostname username userrepo
  local url="$1"
  local re="^(https?|git|ssh)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+)$"
  local githostname="$(__git_hostname $url 2>/dev/null)"
  if [ -d "$url" ]; then
    protocol=
    separator=
    hostname=localhost
    userrepo="$(__basename "$url")"
    username="$(__basename "$(dirname "$url")")"
    folder="local"
    projectdir="${PROJECT_DIR:-$HOME/Projects}/$folder/$username-$userrepo"
  elif [[ $url =~ $re ]]; then
    protocol=${BASH_REMATCH[1]}
    separator=${BASH_REMATCH[2]}
    hostname=${BASH_REMATCH[3]}
    username=${BASH_REMATCH[4]}
    userrepo=${BASH_REMATCH[5]}
    folder=$githostname
    projectdir="${PROJECT_DIR:-$HOME/Projects}/$folder/$username/$userrepo"
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_status() {
  git -C "${1:-.}" status -b -s 2>/dev/null &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_log() {
  git -C "${1:-.}" log \
    --pretty='%C(magenta)%h%C(red)%d %C(yellow)%ar %C(green)%s %C(yellow)(%an)' 2>/dev/null &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_pull() {
  git -C "${1:-.}" pull -q 2>/dev/null &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_top_dir() {
  git -C "${1:-.}" rev-parse --show-toplevel 2>/dev/null |
    grep -v fatal && return 0 || echo "${1:-$PWD}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_top_rel() {
  local sed="${sed:-sed}"
  __git_top_dir "${1:-.}" 2>/dev/null &&
    git -C "${1:-.}" rev-parse --show-cdup 2>/dev/null |
    $sed 's#/$##g' | head -n1 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_remote_pull() {
  git -C "${1:-.}" remote -v 2>/dev/null |
    grep push | head -n 1 | awk '{print $2}' 2>/dev/null |
    grep '^'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_remote_fetch() {
  git -C "${1:-.}" remote -v 2>/dev/null |
    grep fetch | head -n 1 | awk '{print $2}' 2>/dev/null |
    grep '^' && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_remote_origin() {
  __git_remote_pull "${1:-.}" &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_porcelain() {
  __git_porcelain_count "${1:-.}" &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_porcelain_count() {
  [ -d "$(__git_top_dir ${1:-.})/.git" ] &&
    [ "$(git -C "${1:-.}" status --porcelain 2>/dev/null | wc -l 2>/dev/null)" -eq "0" ] &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_repobase() { __basename "$(__git_top_dir "${1:-$PWD}")" 2>/dev/null || echo "$(__basename "$PWD")"; }
#__reldir="$(__git_top_rel ${1:-$PWD} || echo $PWD)"
#__topdir="$(__git_top_dir "${1:-$PWD}" || echo $PWD)"
