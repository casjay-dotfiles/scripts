#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME_README="cheat.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202108121904-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  cheat.sh --help
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Aug 12, 2021 19:04 EDT
# @File              :  cheat.sh
# @Description       :  Manual for cheat.sh
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set variables
__heading="- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
__sed_head() { sed 's#..* :##g;s#^ ##g'; }
__grep_head() { grep -shE '[".#]?@[A-Z]' "$(type -P "${2:-$cheat.sh}")" | grep "${1:-}"; }
__version() { __grep_head 'Version' "$(type -P "cheat.sh")" | __sed_head | head -n1 | grep '^'; }
__printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
__printf_head() { __printf_color "\n$__heading\n$2\n$__heading\n" "$1"; }
__printf_help() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
  local msg="$*"
  shift
  __printf_color "$msg\n" "$color"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf '\n'
__printf_head "5" "cheat.sh: Get help with commands"
__printf_help " " "                                                  "
__printf_help "5" "Usage: cheat.sh [searchTerm]"

__printf_help "4" "cheat.sh --shell [LANG]                           - Shell mode (open LANG if specified)"
__printf_help "4" "cheat.sh --standalone-install [DIR|help]          - Install cheat.sh in the standalone mode"
__printf_help "4" "cheat.sh --mode [auto|lite]                       - Set (or display) mode of operation"

__printf_head "5" "Other cheat.sh Options"
__printf_help "4" "cheat.sh --config                                 - Generate user config file"
__printf_help "4" "cheat.sh --version                                - Show script version"
__printf_help "4" "cheat.sh --help                                   - Shows this message"
__printf_help "4" "cheat.sh --options                                - Shows all available options"
__printf_help " " "                                                  "
#__printf_head "5" "This is a work in progress"
#__printf_help "4" "cheat.sh "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end help
printf '\n'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
#exit "${exitCode:-0}"
