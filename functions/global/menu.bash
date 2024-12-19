#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071156-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  menu.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 11:56 EDT
# @File              :  menu.bash
# @Description       :  menu functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__zenity_custom_question() {
  zenity --question --text "$1" --no-wrap --ok-label "$2" --cancel-label "$3"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_menu_failed() {
  clear && echo -e "\n\n\n\n\n\n" && printf_red "${1:-An error has occured}" && sleep 3 && return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#attemp_install_menus "programname"
__attemp_install_menus() {
  local prog="$1"
  sudo -n true &>/dev/null && ask_for_password "sudo true"
  builtin type -P zenity &>/dev/null || { printf_blue "Installing required package: zenity" && sudo pkmgr silent install zenity &>/dev/null; }
  message() {
    zenity --width=400 --timeout=10 --title="install $prog" --question --text="$prog is not installed! \nshould I try to install it?" || return 1
  }
  if message; then
    sleep 2
    clear
    __pkmgr_gui "$prog"
    builtin type -P "$prog" &>/dev/null && pkmgr_exitCode=0 || pkmgr_exitCode=1
    if [ "$pkmgr_exitCode" = 0 ]; then
      zenity --timeout=10 --width=400 --text-info --title="Success" --text="Successfully installed $prog"
      return 0
    else
      zenity --timeout=10 --width=400 --error --title="failed" --text="$prog failed to install"
      return 1
    fi
  else
    zenity --timeout=10 --width=400 --error --title="cancelled" --text="Installation of $prog has been cancelled"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__custom_menus() {
  local custom="" opts=""
  printf_read_input "6" "Enter your custom program : " "120" "custom"
  printf_read_input "6" "Enter any additional options [type file to choose] : " "120" "opts"
  if [ "$opts" = "file" ]; then opts="$(__open_file_menus $custom)"; fi
  __start $custom "$opts" 2>/dev/null || __run_menu_failed "$custom is an invalid program"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#open_file_menus
__open_file_menus() {
  local prog="$1" && shift 1
  local args="$*" && shift $#
  if builtin type -P "$prog" &>/dev/null; then
    if __cmd_exists zenity && [ -n "$DISPLAY" ]; then
      __zenity_custom_question "Would you like to open files or folders" "Files" "Folders" &&
        local file="$(zenity --file-selection --multiple --title="File Chooser")" ||
        local file="$(zenity --file-selection --title="Choose a directory" --directory)"
    else
      local file="$(dialog --title "Play a file" --stdout --title "Please choose a file or url to play" --fselect "$HOME/" 14 48 || return 1)"
    fi
    if [ -f "$file" ] || [ -d "$file" ]; then
      __run_menu_start "$prog" "$file" || __run_menu_failed
    else
      __run_menu_start "$prog" || __run_menu_failed
    fi
  else
    __attemp_install_menus "$prog" && __run_menu_start "$prog" "$args" || __run_menu_failed
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#run_command "full command" - terminal apps
__run_command() {
  local cmd="$1" && shift 1
  local arg="$*" && shift $#
  clear
  if builtin type -P "$cmd" &>/dev/null; then
    eval $cmd ${arg:-} 2>/dev/null
  else
    printf_newline "\n\n\n"
    printf_pause 1 "Sorry but $cmd doesn't seem to exist [press any key to continue]"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#run_prog_menus - graphical apps
__run_prog_menus() {
  local prog="$1" && shift 1
  local args="$*" && shift $#
  clear
  printf_newline "\n\n\n"
  if builtin type -P "$prog" &>/dev/null; then
    __run_menu_start "$prog" "$args" && printf_counter "5" "3" "Launching $prog"
  else
    __attemp_install_menus "$prog" && __run_menu_start "$prog" "$args"
  fi
  clear
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__edit_menu() {
  local EDITOR="$EDITOR"
  [ -f "$1" ] && local file="$1" && shift 1 || local file="$file"
  [ -d "$1" ] && local dir="$1" && shift 1 || local dir="${WDIR:-$HOME}"
  if builtin type -P dialog &>/dev/null; then
    [ -n "$file" ] || file=$(dialog --title "Play a file" --stdout --title "Please choose a file to edit" --fselect "$dir/" 20 80 || __return 1)
    [ -f "$file" ] && __editor "$file" && __return 0 || __return 1 "Can not open file" "$file does not exists"
  else
    [ -f "$file" ] && __editor "$file" && __return 0 || __return 1 "Can not open file" "$file does not exists"
  fi
  __returnexitcode $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__editor() {
  local EDITOR="$EDITOR"
  if builtin type -P myeditor &>/dev/null; then
    myeditor "$@"
  elif [ -n "$EDITOR" ] && builtin type -t "$EDITOR" &>/dev/null; then
    $EDITOR "$@"
  elif builtin type -P vim &>/dev/null; then
    local vimoptions="$vimoptions"
    __vim ${vimoptions:-} "$@"
  elif builtin type -P nano &>/dev/null; then
    local nanooptions="$nanooptions"
    nano ${nanooptions:-} "$@"
  else
    printf_exit 1 1 "Can not open file: Please set the variable EDITOR=myeditor"
  fi
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_menu_start() {
  clear
  if __running "$1"; then
    __start "$@" && return 0 || return 1
  else
    echo -e "\n\n\n\n"
    printf_red "$1 is already running"
    sleep 5
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__ask_confirm() {
  local appname="${PROG:-$APPNAME}"
  local question="${1:-Would you like to proceed?}"
  local command="${2:-true}"
  local name="${3:-$appname}"
  ##
  __rofi() {
    [ "$(printf "No\\nYes" | rofi -theme ${ROFI_THEME:-purple} -dmenu -i -p "$1")" = "Yes" ] &&
      ${2:-true} || return 1
  }
  ##
  __dmenu() {
    [ "$(printf "No\\nYes" | dmenu -i -p "$1" -nb purple -sb white -sf black -nf gray)" = "Yes" ] &&
      ${2:-true} || return 1
  }
  ##
  __zenity() {
    zenity --question --width=400 --text="$1" --ellipsize --default-cancel &&
      ${2:-true} || return 1
  }
  ##
  __dialog() {
    gdialog --trim --cr-wrap --colors --title "question" --yesno "$1" 15 40 &&
      ${2:-true} || return 1
  }
  ##
  __term() {
    printf_question_term "$1" "$2" || return 1
  }
  ##
  notify_good() {
    local prog="$name"
    local name="${1:-$prog}"
    local message="${command:-Command} was successful"
    if [ -z "$SEND_NOTIFY" ]; then
      notifications "${prog:-$name}:" "$message" || printf_green "${prog:-$name}: $message"
      export YN_NOTIFY=yes
    fi
    return 0
  }
  ##
  notify_error() {
    local prog="$name"
    local name="${1:-$prog}"
    local message="${command:-Command} has failed"
    if [ -z "$SEND_NOTIFY" ]; then
      notifications "${prog:-$name}:" "$message" || printf_red "${prog:-$name}: $message"
      export YN_NOTIFY=yes
    fi
    return 1
  }
  if [ -n "$DISPLAY" ]; then
    if [ -n "$DESKTOP_SESSION" ] && [ -z "$SSH_SESSION" ]; then
      if builtin type -P zenity &>/dev/null; then
        __zenity "$question" "$command" && notify_good "${name:-$appname}" || notify_error "${name:-$appname}"
      elif builtin type -P rofi &>/dev/null; then
        __rofi "$question" "$command" && notify_good "${name:-$appname}" || notify_error "${name:-$appname}"
      elif builtin type -P dmenu &>/dev/null; then
        __dmenu "$question" "$command" && notify_good "${name:-$appname}" || notify_error "${name:-$appname}"
      elif builtin type -P gdialog &>/dev/null; then
        __dialog "$question" "$command" && notify_good "${name:-$appname}" || notify_error "${name:-$appname}"
      else
        __term "$question" "$command" && notify_good "${name:-$appname}" || notify_error "${name:-$appname}"
      fi
    elif [ -t 0 ]; then
      __term "$question" "$command" || notify_error
    fi
  else
    __term "$question" "$command" || notify_error
  fi
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
