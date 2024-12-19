#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071004-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  system.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 10:04 EDT
# @File              :  system.bash
# @Description       :  system functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__which() { which "$1" 2>/dev/null; }
__type() { type -P "$1" 2>/dev/null; }
__command() { command -v "$1" 2>/dev/null; }
__is_wayland() { { [ "$XDG_SESSION_TYPE" = "wayland" ] || grep -shqiE 'chromeos|Chromium OS' "/proc/version"; } && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__paste_clip() {
  if [ "$(uname -s)" = 'Linux' ]; then
    if __cmd_exists wl-paste && __is_wayland; then
      wl-paste 2>/dev/null
    elif __cmd_exists xclip; then
      xclip -r -selection clipboard -o 2>/dev/null
    elif __cmd_exists xsel; then
      xsel -p -o 2>/dev/null
    fi
  elif [ "$(uname -s)" = 'Darwin' ]; then
    if __cmd_exists pbpaste; then
      pbpaste
    fi
  elif [[ "$(uname -s)" = 'Win'* ]]; then
    unclip.exe
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cmd_exists() {
  for cmd in "$@"; do
    builtin type -P "$cmd" &>/dev/null || return 1
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
user_is_root() {
  if [[ $(id -u) -eq 0 ]] || [[ "$EUID" = 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# runpost "program"
__run_post() {
  local e="$1"
  local m="${e//__devnull//}"
  __execute "$e" "executing: $m"
  __setexitstatus $?
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__newpasswd() {
  local oldpassword newpassword newpasswordc
  printf_read_password "3" "Enter old password for $1" "oldpassword"
  printf_read_password "3" "Enter new password for $1" "newpassword"
  printf_read_password "3" "Confirm new password for $1" "newpasswordc"
  [ "$oldpassword" = "$newpassword" ] && printf_exit "Password needs to be different"
  [ "$newpassword" = "$newpasswordc" ] || printf_exit "Passwords don't match"
  printf '%s\n%s\n%s' "$oldpassword" "$newpassword" "$newpasswordc" | __passwd "$1" &>/dev/null &&
    printf_green "Password has been updated" || printf_exit "Password change has failed"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__local_gen_header() {
  echo -e "$1" >>"$2"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__command() {
  [ "$1" = "-v" ] && shift 1
  if [ $# -ne 1 ]; then
    if builtin type "$@" 2>/dev/null | grep -v alias | head -n1 | awk '{print $1}' | grep '^'; then
      return 0
    else
      return 1
    fi
  elif builtin type "$@" 2>/dev/null | grep -v alias | head -n1 | awk '{print $1}' | grep -q '^'; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# exec command
__exec() {
  local cmd="$1" && shift 1
  local args="$*" && shift $#
  if [ "$cmd" = "$TERMINAL" ]; then
    eval $cmd "$args" 2>/dev/null && true || notifications "Failed to launch $cmd $args"
  else
    $cmd "$args" &>/dev/null && true || notifications "Failed to launch $cmd $args" &
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_support() {
  local OSTYPE=
  if [ -n "$1" ]; then
    OSTYPE="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  else
    OSTYPE="$(uname -s | tr '[:upper:]' '[:lower:]')"
  fi
  case "$OSTYPE" in
  linux*) echo "Linux" || return 1 ;;
  mac* | darwin*) echo "MacOS" || return 1 ;;
  win* | msys* | mingw* | cygwin*) echo "Windows" || return 1 ;;
  bsd*) echo "BSD" || return 1 ;;
  solaris*) echo "Solaris" || return 1 ;;
  *) return 0 ;;
  esac
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__supported_os() {
  [ $# -ne 0 ] || return 0
  for OSes in "$@"; do
    local app=${APPNAME:-$PROG}
    if_os "$OSes" && OS_IS_SUPPORTED="true"
  done
  [ "$OS_IS_SUPPORTED" = "true" ] && return || printf_exit 1 1 "$app does not support your OS"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__unsupported_oses() {
  [ $# -ne 0 ] || return 0
  local cur_os="" os_sup=""
  for OSes in "$@"; do
    os_sup="$(os_support | tr '[:upper:]' '[:lower:]')"
    cur_os="$(echo "$OSes" | tr '[:upper:]' '[:lower:]')"
    if [ "$cur_os" = "$os_sup" ]; then
      OS_IS_SUPPORTED="false"
    fi
  done
  [ "$OS_IS_SUPPORTED" != "false" ] && return || printf_exit 1 1 "$app does not support your OS"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__if_os() {
  [ $# -ne 0 ] || return 0
  local OS="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  local UNAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
  case "$OS" in
  linux*)
    if [ "$UNAME" = "linux" ]; then
      return 0
    else
      return 1
    fi
    ;;

  mac*)
    if [ "$UNAME" = "darwin" ]; then
      return 0
    else
      return 1
    fi
    ;;
  win*)
    if [ "$UNAME" = "ming" ] || [ "$UNAME" = "WindowsNT" ]; then
      return 0
    else
      return 1
    fi
    ;;
  *)
    return 1
    ;;
  esac
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__if_os_id() {
  local distroname="" distroversion="" distro_id="" distro_version="" in="" def="" args=""
  if [ "$(uname -s 2>/dev/null)" = "Darwin" ] && builtin type -P sw_vers &>/dev/null; then
    distroname="darwin"
    distroversion="$(sw_vers -productVersion)"
  elif [ -f "/etc/os-release" ]; then
    #local distroname=$(grep "ID_LIKE=" /etc/os-release | sed 's#ID_LIKE=##' | tr '[:upper:]' '[:lower:]' | sed 's#"##g' | awk '{print $1}')
    distroname=$(grep '^ID=' /etc/os-release | sed 's#ID=##g' | sed 's#"##g' | tr '[:upper:]' '[:lower:]')
    distroversion=$(grep '^VERSION="' /etc/os-release | sed 's#VERSION="##g;s#"##g')
    codename="$(grep 'VERSION_CODENAME' /etc/os-release && grep '^VERSION_CODENAME' /etc/os-release | sed 's#VERSION_CODENAME="##g;s#"##g' || true)"
  elif [ -f "/etc/redhat-release" ]; then
    distroname=$(awk '{print $1}' /etc/redhat-release | tr '[:upper:]' '[:lower:]' | sed 's#"##g')
    distroversion=$(awk '{print $4}' /etc/redhat-release | tr '[:upper:]' '[:lower:]' | sed 's#"##g')
  elif builtin type -P lsb_release &>/dev/null; then
    distroname="$(lsb_release -a 2>/dev/null | grep 'Distributor ID' | awk '{print $3}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')"
    distroversion="$(lsb_release -a 2>/dev/null | grep 'Release' | awk '{print $2}')"
  elif builtin type -P lsb-release &>/dev/null; then
    distroname="$(lsb-release -a 2>/dev/null | grep 'Distributor ID' | awk '{print $3}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')"
    distroversion="$(lsb-release -a 2>/dev/null | grep 'Release' | awk '{print $2}')"
  else
    return 1
  fi
  in="$*"
  def="${DISTRO}"
  args="$(echo "${*:-$def}" | tr '[:upper:]' '[:lower:]')"
  for id_like in $args; do
    case "$id_like" in
    alpine*)
      if [[ $distroname =~ ^alpine ]] || [[ "$distroname" = "Alpine Linux" ]]; then
        distro_id="alpine"
        distro_version="$(cat /etc/os-release | grep '^VERSION_ID=' | sed 's#VERSION_ID=##g')"
        return 0
      else
        return 1
      fi
      ;;
    arch* | arco*)
      if [[ $distroname =~ ^arco ]] || [[ "$distroname" =~ ^arch ]]; then
        distro_id="Arch"
        distro_version="$(cat /etc/os-release | grep '^BUILD_ID' | sed 's#BUILD_ID=##g')"
        return 0
      else
        return 1
      fi
      ;;
    rhel* | centos* | fedora* | rocky* | ol* | oracle* | redhat* | scientific* | alma*)
      if [[ "$distroname" =~ ^scientific ]] || [[ "$distroname" =~ ^redhat ]] || [[ "$distroname" =~ ^centos ]] || [[ "$distroname" =~ ^casjay ]] || [[ "$distroname" =~ ^rocky ]] || [[ "$distroname" =~ ^alma ]]; then
        distro_id="RHEL"
        distro_version="$distroversion"
        return 0
      else
        return 1
      fi
      ;;
    debian* | ubuntu*)
      if [[ "$distroname" =~ ^kali ]] || [[ "$distroname" =~ ^parrot ]] || [[ "$distroname" =~ ^debian ]] || [[ "$distroname" =~ ^raspbian ]] ||
        [[ "$distroname" =~ ^ubuntu ]] || [[ "$distroname" =~ ^linuxmint ]] || [[ "$distroname" =~ ^elementary ]] || [[ "$distroname" =~ ^kde ]]; then
        distro_id="Debian"
        distro_version="$distroversion"
        distro_codename="$codename"
        return 0
      else
        return 1
      fi
      ;;
    darwin* | mac*)
      if [[ "$distroname" =~ ^mac ]] || [[ "$distroname" =~ ^darwin ]]; then
        distro_id="MacOS"
        distro_version="$distroversion"
        return 0
      else
        return 1
      fi
      ;;
    *)
      return 1
      ;;
    esac
    # else
    #   return 1
    # fi
  done
  [ -n "$distro_id" ] || distro_id="Unknown"
  [ -n "$distro_version" ] || distro_version="Unknown"
  # [ -n "$codename" ] && distro_codename="$codename" || distro_codename="N/A"
  # echo $id_like $distroname $distroversion $distro_codename
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export -f __command
