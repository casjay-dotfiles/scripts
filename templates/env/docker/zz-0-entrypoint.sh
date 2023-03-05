# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if this is a new container
START_SERVICES="${START_SERVICES:-yes}"
DATA_DIR_INITIALIZED="${DATA_DIR_INITIALIZED:-false}"
CONFIG_DIR_INITIALIZED="${CONFIG_DIR_INITIALIZED:-false}"
export DATA_DIR_INITIALIZED CONFIG_DIR_INITIALIZED START_SERVICES ENTRYPOINT_FIRST_RUN
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
