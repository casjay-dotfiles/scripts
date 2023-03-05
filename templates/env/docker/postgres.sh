# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# postgresql env
DATABASE_DIR_PGSQL="${DATABASE_DIR_PGSQL:-$PGDATA}"
PGDATA="${DATABASE_DIR_PGSQL:-$DATABASE_BASE_DIR/pgsql}"
POSTGRES_USER="${DATABASE_USER_ROOT:-$POSTGRES_USER}"
POSTGRES_PASSWORD="${DATABASE_PASS_ROOT:-$POSTGRES_PASSWORD}"
POSTGRES_CONFIG_FILE="${POSTGRES_CONFIG_FILE:-$(__find_pgsql_conf)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
