# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# postgresql env
PGDATA="${DATABASE_DIR_PGSQL:-/dat/db/pgsql}"
DATABASE_DIR_PGSQL="${DATABASE_DIR_PGSQL:-$PGDATA}"
POSTGRES_USER="${DATABASE_USER_ROOT:-$POSTGRES_USER}"
POSTGRES_PASSWORD="${DATABASE_PASS_ROOT:-$POSTGRES_PASSWORD}"
POSTGRES_CONFIG_FILE="${POSTGRES_CONFIG_FILE:-$(__find_pgsql_conf)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
