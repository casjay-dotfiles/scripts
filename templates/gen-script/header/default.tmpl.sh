cat <<EOF | tee
#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  $GEN_SCRIPT_VERSION
# @Author            :  $GEN_SCRIPT_AUTHOR
# @Contact           :  $GEN_SCRIPT_EMAIL
# @License           :  $GEN_SCRIPT_DEFLICENSE
# @ReadME            :  $GEN_SCRIPT_NEWFILE --help
# @Copyright         :  $GEN_SCRIPT_COPYRIGHT
# @Created           :  $GEN_SCRIPT_CREATED
# @File              :  $GEN_SCRIPT_NEWFILE
# @Description       :  ${desc:-$get_desc}
# @TODO              :  ${todo:-$get_todo}
# @Other             :  ${other:-$get_other}
# @Resource          :  ${res:-$get_res}
# @sudo/root         :  no
EOF
