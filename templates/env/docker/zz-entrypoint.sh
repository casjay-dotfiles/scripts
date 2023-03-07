# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# File locations
ENTRYPOINT_PID_FILE="${ENTRYPOINT_PID_FILE:-/tmp/entrypoint.pid}"
ENTRYPOINT_INIT_FILE="${ENTRYPOINT_INIT_FILE:-/config/.entrypoint.done}"
ENTRYPOINT_DATA_INIT_FILE="${ENTRYPOINT_DATA_INIT_FILE:-/data/.docker_has_run}"
ENTRYPOINT_CONFIG_INIT_FILE="${ENTRYPOINT_CONFIG_INIT_FILE:-/config/.docker_has_run}"
export ENTRYPOINT_PID_FILE ENTRYPOINT_INIT_FILE ENTRYPOINT_DATA_INIT_FILE ENTRYPOINT_CONFIG_INIT_FILE
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
if [ ! -f "$ENTRYPOINT_CONFIG_INIT_FILE" ]; then
  "Initialized on: $INIT_DATE" >"$ENTRYPOINT_CONFIG_INIT_FILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_DATA_INIT_FILE" ]; then
  DATA_DIR_INITIALIZED="true"
  ENTRYPOINT_MESSAGE="no"
elif [ -d "/data" ]; then
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_DATA_INIT_FILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ]; then
  CONFIG_DIR_INITIALIZED="true"
  ENTRYPOINT_MESSAGE="no"
elif [ -d "/config" ]; then
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_CONFIG_INIT_FILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_PID_FILE" ]; then
  START_SERVICES="no"
  ENTRYPOINT_MESSAGE="no"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export DATA_DIR_INITIALIZED CONFIG_DIR_INITIALIZED START_SERVICES ENTRYPOINT_FIRST_RUN ENTRYPOINT_MESSAGE
