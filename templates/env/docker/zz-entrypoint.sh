# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# File locations
ENTRYPOINT_PID_FILE="${ENTRYPOINT_PID_FILE:-/run/init.d/entrypoint.pid}"
ENTRYPOINT_INIT_FILE="${ENTRYPOINT_INIT_FILE:-/config/.entrypoint.done}"
ENTRYPOINT_DATA_INIT_FILE="${ENTRYPOINT_DATA_INIT_FILE:-/data/.docker_has_run}"
ENTRYPOINT_CONFIG_INIT_FILE="${ENTRYPOINT_CONFIG_INIT_FILE:-/config/.docker_has_run}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Startup variables
INIT_DATE="${INIT_DATE:-$(date)}"
START_SERVICES="${START_SERVICES:-yes}"
ENTRYPOINT_MESSAGE="${ENTRYPOINT_MESSAGE:-yes}"
ENTRYPOINT_FIRST_RUN="${ENTRYPOINT_FIRST_RUN:-yes}"
DATA_DIR_INITIALIZED="${DATA_DIR_INITIALIZED:-false}"
CONFIG_DIR_INITIALIZED="${CONFIG_DIR_INITIALIZED:-false}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if this is a new container
[ -f "$ENTRYPOINT_PID_FILE" ] && START_SERVICES="no"
[ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ] && ENTRYPOINT_FIRST_RUN="no"
[ -f "$ENTRYPOINT_DATA_INIT_FILE" ] && DATA_DIR_INITIALIZED="true"
[ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ] && CONFIG_DIR_INITIALIZED="true"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
