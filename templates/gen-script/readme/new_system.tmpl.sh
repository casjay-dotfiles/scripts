cat <<EOF | tee
$(. "$CASJAYSDEVDIR/templates/gen-script/header/default.tmpl.sh")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set variables
__heading="- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME_README="\$GEN_SCRIPT_REPLACE_APPNAME"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
__sed_head() { sed 's#..* :##g;s#^ ##g'; }
__grep_head() { grep -shE '[".#]?@[A-Z]' "$(type -P "\${2:-\$GEN_SCRIPT_REPLACE_FILENAME}")" | grep "\${1:-}"; }
__version() { __grep_head 'Version' "$(type -P "\$GEN_SCRIPT_REPLACE_FILENAME")" | __sed_head | head -n1 | grep '^'; }
__printf_color() { printf "%b" "$(tput setaf "\$2" 2>/dev/null)" "\$1" "$(tput sgr0 2>/dev/null)"; }
__printf_head() { __printf_color "\\n\\t\\t\$__heading\\n\\t\\t\$2\\n\\t\\t\$__heading\\n" "\$1"; }
__printf_help() {
  test -n "\$1" && test -z "\${1//[0-9]/}" && local color="\$1" && shift 1 || local color="4"
  local msg="\$*"
  shift
  __printf_color "\\t\\t\$msgn" "\$color"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf '\\n'
__printf_head "5" "GEN_SCRIPT_REPLACE_FILENAME: GEN_SCRIPT_REPLACE_DESC"
__printf_help " " "                                                  "
__printf_help "5" "Usage: GEN_SCRIPT_REPLACE_APPNAME []"

$([[ -f "\$path_filename" ]] && for o in $(grep -sh 'ARRAY=' \$path_filename 2>/dev/null | grep -E ',| ' | head -n1 | sed 's|ARRAY=||g;s|,| |g;s|"||g' | tr ' ' 'n'); do echo '__printf_help "4" "'$(__filename \$GEN_SCRIPT_NEWFILE 2>/dev/null)' '\$o'  -  "'; done)

__printf_head "5" "Other GEN_SCRIPT_REPLACE_FILENAME Options"
__printf_help "4" "GEN_SCRIPT_REPLACE_FILENAME --config              - Generate user config file"
__printf_help "4" "GEN_SCRIPT_REPLACE_FILENAME --version             - Show script version"
__printf_help "4" "GEN_SCRIPT_REPLACE_FILENAME --help                - Shows this message"
__printf_help "4" "GEN_SCRIPT_REPLACE_FILENAME --options             - Shows all available options"
__printf_help " " "                                                  "
#__printf_head "5" "This is a work in progress"
#__printf_help "4" "GEN_SCRIPT_REPLACE_FILENAME "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end help
printf '\\n'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit "\${exitCode:-\$?}"
EOF
