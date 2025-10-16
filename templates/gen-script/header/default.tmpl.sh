cat <<EOF | tee
#!/usr/bin/env $shell
# shellcheck shell=$shell
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  $GEN_SCRIPT_VERSION
# @@Author           :  $GEN_SCRIPT_AUTHOR
# @@Contact          :  $GEN_SCRIPT_EMAIL
# @@License          :  $GEN_SCRIPT_DEFLICENSE
# @@ReadME           :  $GEN_SCRIPT_NEWFILE --help
# @@Copyright        :  $GEN_SCRIPT_COPYRIGHT
# @@Created          :  $GEN_SCRIPT_CREATED
# @@File             :  $GEN_SCRIPT_NEWFILE
# @@Description      :  ${desc:-$get_desc}
# @@Changelog        :  ${changelog:-$get_changelog}
# @@TODO             :  ${todo:-$get_todo}
# @@Other            :  ${other:-$get_other}
# @@Resource         :  ${res:-$get_res}
# @@Terminal App     :  ${terminal:-$get_terminal}
# @@sudo/root        :  ${sudo:-$get_sudo}
# @@Template         :  ${template:-$get_template}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shell check options
# shellcheck disable=SC2317
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
EOF
