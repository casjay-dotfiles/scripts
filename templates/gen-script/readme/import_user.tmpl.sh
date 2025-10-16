cat <<EOF | tee
$(. "$CASJAYSDEVDIR/templates/gen-script/header/default.tmpl.sh")
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set variables
__heading="- - - - - - - - - - - - - - - - - - - - - - - - -"
# - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME_README="\$GEN_SCRIPT_REPLACE_APPNAME"

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
__sed_head() { sed 's#..* :##g;s#^ ##g'; }
__grep_head() { grep -shE '[".#]?@[A-Z]' "$(type -P "\${2:-\$GEN_SCRIPT_REPLACE_FILENAME}")" | grep "\${1:-}"; }
__version() { __grep_head 'Version' "$(type -P "GEN_SCRIPT_REPLACE_FILENAME")" | __sed_head | head -n1 | grep '^'; }
__printf_head() { __printf_color "\\n\\t\\t\$__heading\\n\\t\\t\$2\\n\\t\\t\$__heading\\n" "\$1"; }
__printf_color() { printf "%b" "$(tput setaf "\$2" 2>/dev/null)" "\$1" "$(tput sgr0 2>/dev/null)"; }
__printf_help() {
  printf "%b" "$(tput setaf "\${2:-4}" 2>/dev/null)" "\\t\\t\$1" "$(tput sgr0 2>/dev/null)"
  printf '\\n'
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# begin
__printf_head "5" "GEN_SCRIPT_REPLACE_FILENAME: GEN_SCRIPT_REPLACE_DESC"
__printf_help " " "                                                  "
__printf_help "5" "Usage: GEN_SCRIPT_REPLACE_APPNAME []"

# Begin import
$PREV_README
# End Import

__printf_head "5" "Other GEN_SCRIPT_REPLACE_FILENAME Options"
__printf_help "4" "GEN_SCRIPT_REPLACE_FILENAME --config              - Generate user config file"
__printf_help "4" "GEN_SCRIPT_REPLACE_FILENAME --version             - Show script version"
__printf_help "4" "GEN_SCRIPT_REPLACE_FILENAME --help                - Shows this message"
__printf_help "4" "GEN_SCRIPT_REPLACE_FILENAME --options             - Shows all available options"
__printf_help " " "                                                  "
# - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
#exit \${exitCode:-\$?}
EOF
