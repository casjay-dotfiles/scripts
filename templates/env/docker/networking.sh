# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# networing info
DOMAINNAME="${DOMAINNAME:-}"
EMAIL_RELAY="${EMAIL_RELAY:-}"
HOSTNAME="${HOSTNAME:-casjaysdev-GEN_SCRIPT_REPLACE_APPNAME}"
EMAIL_DOMAIN="${EMAIL_DOMAIN:-${DOMAINNAME:-$HOSTNAME}}"
FULL_DOMAIN_NAME="${FULL_DOMAIN_NAME:-${DOMAINNAME:-$HOSTNAME}}"
SERVER_ADMIN="${SERVER_ADMIN:-root@${EMAIL_DOMAIN:-$FULL_DOMAIN_NAME}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
