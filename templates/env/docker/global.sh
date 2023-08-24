# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# GLOBAL enviroment variables
USER="${USER:-root}"
LANG="${LANG:-C.UTF-8}"
TZ="${TZ:-America/New_York}"
ENV_PORTS="${ENV_PORTS//\/*/}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SERVICE_USER="${SERVICE_USER:-}"
SERVICE_GROUP="${SERVICE_GROUP:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# How to set permissions
CHANGE_USER="${SERVICE_USER:-}"
CHANGE_GROUP="${SERVICE_GROUP:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
