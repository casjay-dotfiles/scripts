# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# networing info
HOSTNAME="\${HOSTNAME:-casjaysdev-GEN_SCRIPT_REPLACE_APPNAME}"
DOMAINNAME="\${DOMAINNAME:-}"
FULL_DOMAIN_NAME="\${FULL_DOMAIN_NAME:-\${DOMAINNAME:-\$HOSTNAME}}"
SERVER_ADMIN="\${SERVER_ADMIN:-root@\${EMAIL_DOMAIN:-\$DOMAINNAME}}"
EMAIL_RELAY="\${EMAIL_RELAY:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get ip addresses
CONTAINER_IP4_ADDRESS="\${CONTAINER_IP4_ADDRESS:-\$(__get_ip4)}"
CONTAINER_IP6_ADDRESS="\${CONTAINER_IP6_ADDRESS:-\$(__get_ip6)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
