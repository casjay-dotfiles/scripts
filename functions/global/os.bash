#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070949-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  os.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 09:49 EDT
# @File              :  os.bash
# @Description       :  OS functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_fix_name() {
  [[ -f "${1:-/etc/casjaysdev/updates/versions/osversion.txt}" ]] &&
    sudo sed -i 's|[",]||g;s| [lL]inux:||g' "${1:-/etc/casjaysdev/updates/versions/osversion.txt}" ||
    return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_name() {
  grep -sh '^NAME=' /etc/os-release | awk -F '=' '{print $2}' | sed 's|[0-9]||g;s|\.||g' | grep '^' ||
    grep -sh '^ID=' /etc/os-release | awk -F '=' '{print $2}' | sed 's|[0-9]||g;s|\.||g' | grep '^' ||
    echo "OS: Unknown"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_version() {
  os_v=""
  if [ -n "$DISTRO_VERSION" ] && [ "$DISTRO_VERSION" != "N/A" ] && printf '%s\n' "$DISTRO_VERSION" | grep -q '^[0-9]'; then
    printf '%s\n' "$DISTRO_VERSION"
    return
  fi
  if [ -z "$os_v" ]; then
    os_v="$([ -f "/etc/debian_version" ] && grep '[0-9]' "/etc/debian_version" | head -n1 | awk -F '.' '{print $1}')"
  fi
  if [ -z "$os_v" ]; then
    os_v="$(grep -sh '^VERSION=' /etc/os-release 2>/dev/null | sed 's|[a-zA-Z]||g;s/[^.0-9]*//g' | grep -v '/' | grep '[0-9]$')"
  fi
  if [ -z "$os_v" ]; then
    os_v="$(grep -sh 'BUILD_ID' /etc/os-release 2>/dev/null | awk -F '=' '{print $2}' | sed 's|[a-zA-Z]||g;s/[^.0-9]*//g' | grep '[0-9]$')"
  fi
  if [ -z "$os_v" ]; then
    os_v="$($LSB_RELEASE -a 2>/dev/null | grep -i '^Release' | grep -v '/' | awk '{print $2}' | grep '^' | grep '[0-9]')"
  fi
  [ -n "$os_v" ] && printf '%s\n' "$os_v" | sed 's|"||g' || echo "Version: Unknown"
  unset os_v
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__getpythonver() {
  if builtin type -P python3 &>/dev/null; then
    PYTHONVER="python3"
    PIP="pip3"
    PATH="${PATH}:$(python3 -c 'import site; print(site.USER_BASE)')/bin"
  elif builtin type -P python2 &>/dev/null; then
    PYTHONVER="python2"
    PIP="pip"
    PATH="${PATH}:$(python2 -c 'import site; print(site.USER_BASE)')/bin"
  elif builtin type -P python &>/dev/null; then
    PYTHONVER="python"
    PIP="pip"
    PATH="${PATH}:$(python -c 'import site; print(site.USER_BASE)')/bin"
  fi
  if builtin type -P yay &>/dev/null || builtin type -P pacman &>/dev/null; then
    PYTHONVER="python"
    PIP="pip3"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__getphpver() {
  if builtin type -P php &>/dev/null; then
    PHPVER="$(php -v | grep --only-matching --perl-regexp "(PHP )\d+\.\\d+\.\\d+" | cut -c 5-7)"
  else
    PHPVER=""
  fi
  echo "$PHPVER"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__setcursor() {
  echo -e -n "\x1b[\x35 q" "\e]12;cyan\a" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#basedir "file"
__basedir() {
  if [ "$(dirname "$1" 2>/dev/null)" = . ]; then
    echo "$PWD"
  else
    dirname "$1" | sed 's#\../##g' 2>/dev/null
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#basename -- "file"
__basename() {
  basename -- "${1:-.}" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#foldername "dir"
__foldername() {
  local file=""
  [ -n "$1" ] && file="$(readlink -f "$1" 2>/dev/null)" || return
  if [ -d "$file" ]; then
    local basename="$(basename -- "$file" 2>/dev/null)"
  elif [ -e "$1" ]; then
    local basename="$(basename $(dirname "$file" 2>/dev/null))"
  fi
  [ -n "$basename" ] && echo "$basename" || basename -- "$PWD"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# dirname dir
__dirname() { cd "$1" 2>/dev/null && echo "$PWD" || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#to_lowercase "args"
__to_lowercase() { echo "$@" | tr '[A-Z]' '[a-z]'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#to_uppercase "args"
__to_uppercase() { echo "$@" | tr '[a-z]' '[A-Z]'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#strip_ext "Filename"
__strip_ext() { echo "${@%.*}"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#get_full_file "file"
__get_full_file() { ls -A "$*" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#cat file | rmcomments
__rmcomments() { $sed 's/[[:space:]]*#.*//;/^[[:space:]]*$/d'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#countwd file
__countwd() { cat "$@" | wc -l | __rmcomments; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__column() { builtin type -P column &>/dev/null && column || tee; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#getuser "username" "grep options"
__getuser() {
  if [ -n "${1:-$USER}" ]; then
    cut -d: -f1 /etc/passwd |
      grep "${1:-$USER}" |
      cut -d: -f1 /etc/passwd |
      grep "${1:-$USER}" ${2:-}
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#getuser_shell "shellname"
__getuser_shell() {
  local PATH="/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games"
  local CURSHELL=${1:-$(grep "$USER" /etc/passwd | tr ':' '\n' | tail -n1)} && shift 1
  local USER=${1:-$USER} && shift 1
  grep "$USER" /etc/passwd |
    cut -d: -f7 |
    grep -q "${CURSHELL:-$SHELL}" &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__getuser_cur_shell() {
  local PATH="/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games"
  local CURSHELL="$(grep "$USER" /etc/passwd | tr ':' '\n' | tail -n1)"
  grep "$USER" /etc/passwd | tr ':' '\n' | grep "${CURSHELL:-$SHELL}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#mkd dir
__mkd() {
  for d in "$@"; do
    [ -e "$d" ] || mkdir -p "$d" &>/dev/null
  done
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__file_not_empty() {
  [ -s "$1" ] && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__file_is_empty() {
  [ ! -s "$1" ] && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#vim "file"
__vim() {
  local vim="${vim:-vim}"
  eval $vim "$@"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#keeps output color
if ! builtin type -P unbuffer &>/dev/null; then
  unbuffer() {
    exec "$@"
  }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#sed "commands"
__sed() {
  local sed="${sed:-sed}"
  ${sed:-sed} "$*" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# find replace
__find_replace() {
  find -L "$3" -type f -exec "$sed" -i 's#'$1'#'$2'#g' {} \; 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#replace file
__replace() {
  $sed -i 's|'"$1"'|'"$2"'|g' "$3" &>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#tar "filename dir"
__tar_create() {
  tar cfvz "$@"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#tar filename
__tar_extract() {
  tar xfvz "$@"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#while_true "command"
__while_loop() {
  while :; do
    "${@}" && sleep .3
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#for_each "option" "command"
__for_each() {
  for item in ${1}; do
    ${2} ${item} && sleep .1
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__readline() {
  while read -r line; do
    echo "$line"
  done <"$1"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#timeout "time" "command"
__timeout() {
  timeout ${1} bash -c "${2}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#start_count "proc" "search"
__start_count() {
  ps -ux |
    grep "$1" |
    grep -v 'grep ' |
    grep -c "${2:$1}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#count_words "file"
__count_lines() {
  wc -l "$1" |
    awk '${print $1}'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#count_files "dir"
__count_files() {
  find -L "${1:-./}" -maxdepth "${2:-1}" \
    -not -path "${1:-./}/.git/*" -type f 2>/dev/null |
    wc -l
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#count_dir "dir"
__count_dir() {
  find -L "${1:-./}" -maxdepth "${2:-1}" \
    -not -path "${1:-./}/.git/*" -type d 2>/dev/null |
    wc -l
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#touch file
__touch() {
  for f in "$@"; do
    local dir="$(dirname "$f" 2>/dev/null)"
    mkdir -p "$dir" &>/dev/null
    touch "$f" &>/dev/null
  done
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#symlink "file" "dest"
__symlink() {
  if [ -e "$1" ]; then
    __ln_sf "${1}" "${2}" &>/dev/null || return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#mv_f "file" "dest"
__mv_f() {
  if [ -e "$1" ]; then
    mv -f "$1" "$2" &>/dev/null || return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#cp_rf "file" "dest"
__cp_rf() {
  if [ -e "$1" ]; then
    cp -Rf "$1" "$2" &>/dev/null || return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#rm_rf "file"
__rm_rf() {
  if [ -e "$1" ]; then
    rm -Rf "$@" &>/dev/null || return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# unlink "location"
__unlink() {
  if [ -L "$1" ]; then
    unlink "$@" &>/dev/null || return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# broken_symlinks "file"
__broken_symlinks() {
  find -L "$@" -type l \
    -exec rm -f {} \; &>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#ln_rm "file"
__ln_rm() {
  if [ -e "$1" ]; then
    find -L $1 -mindepth 1 -maxdepth 1 \
      -type l -exec rm -f {} \; &>/dev/null
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#ln_sf "file"
__ln_sf() {
  [ -L "$2" ] && __rm_rf "$2" || true
  ln -sf "$1" "$2" &>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#find_mtime "file/dir" "time minutes"
__find_mtime() {
  if [ "$(find ${1:-.} -maxdepth 1 -type f -cmin ${2:-60} 2>/dev/null | wc -l)" -ne 0 ]; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#find "dir" "options"
__find() {
  local DEF_OPTS=""
  local opts="${FIND_OPTS:-$DEF_OPTS}"
  find "${*:-.}" -not -path "$dir/.git/*" $opts 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#find_old "dir" "minutes" "action"
__find_old() {
  [ -d "$1" ] && local dir="$1" && shift 1
  local time="$1" && shift 1
  local action="$1" && shift 1
  find "${dir:-$HOME/.local/tmp}" -type f -mmin +${time:-120} -${action:-delete} 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#find "dir" - return path relative to dir
__find_rel() {
  #f for file | d for dir
  local DIR="${*:-.}"
  local DEF_TYPE="${FIND_TYPE:-f,l}"
  local DEF_DEPTH="${FIND_DEPTH:-1}"
  local DEF_OPTS="${FIND_OPTS:-}"
  find $DIR/* -maxdepth $DEF_DEPTH -type $DEF_TYPE $DEF_OPTS -not \
    -path "$dir/.git/*" -print 2>/dev/null | $sed 's#'$DIR'/##g'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#cd "dir"
__cd() {
  cd "$1" || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# cd into directory with message
__cd_into() {
  if [ $PWD != "$1" ]; then
    cd "$1" && printf_green "Changing the directory to $1" &&
      printf_green "Type exit to return to your previous directory" &&
      exec bash || exit 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
path_info() {
  echo "$PATH" | tr ':' '\n' | sort -u
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
check_local() {
  local file="${1:-$PWD}"
  if [ -d "$file" ]; then
    type="dir"
    localfile="true"
    return 0
  elif [ -f "$file" ]; then
    type="file"
    localfile="true"
    return 0
  elif [ -L "$file" ]; then
    type="symlink"
    localfile="true"
    return 0
  elif [ -S "$file" ]; then
    type="socket"
    localfile="true"
    return 0
  elif [ -b "$file" ]; then
    type="block"
    localfile="true"
    return 0
  elif [ -p "$file" ]; then
    type="pipe"
    localfile="true"
    return 0
  elif [ -c "$file" ]; then
    type="character"
    localfile="true"
    return 0
  elif [ -e "$file" ]; then
    type="file"
    localfile="true"
    return 0
  else
    type= && localfile=
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#do_not_add_a_url "url"
__do_not_add_a_url() {
  regex="(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]"
  string="$1"
  if [[ "$string" =~ $regex ]]; then
    printf_exit "Do not provide the full url: only provide the username/repo"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__backupapp() {
  local filename count backupdir rmpre4vbackup
  [ -n "$1" ] && local myappdir="$1" || local myappdir="$APPDIR"
  [ -n "$2" ] && local myappname="$2" || local myappname="$APPNAME"
  local downloaddir="$INSTDIR"
  local logdir="${LOGDIR:-$HOME/.local/log}/backups/${SCRIPTS_PREFIX:-apps}"
  local curdate="$(date +%Y-%m-%d-%H-%M-%S)"
  local filename="$myappname-$curdate.tar.gz"
  local backupdir="${MY_BACKUP_DIR:-$HOME/.local}/backups/${SCRIPTS_PREFIX:-apps}/"
  local count="$(find "$backupdir/$myappname"*.tar.gz 2>/dev/null | wc -l 2>/dev/null)"
  local rmpre4vbackup="$(find "$backupdir/$myappname"*.tar.gz 2>/dev/null | head -n 1)"
  mkdir -p "$backupdir" "$logdir"
  if [ -d "$myappdir" ] && [ "$myappdir" != "$downloaddir" ] && [ ! -f "$APPDIR/.installed" ]; then
    __local_gen_header "#################################" "$logdir/$myappname.log"
    __local_gen_header "# Started on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    __local_gen_header "# Backing up $myappdir" >>"$logdir/$myappname.log"
    __local_gen_header "#################################" "$logdir/$myappname.log"
    tar cfzv "$backupdir/$filename" "$myappdir" >>"$logdir/$myappname.log" 2>>"$logdir/$myappname.log"
    __local_gen_header "#################################" "$logdir/$myappname.log"
    __local_gen_header "# Ended on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    __local_gen_header "#################################" "$logdir/$myappname.log"
    [ -f "$APPDIR/.installed" ] || rm_rf "$myappdir"
  fi
  if [ "$count" -gt "3" ]; then rm_rf $rmpre4vbackup; fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
