# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# couchdb env
COUCHDB_NODENAME="${ENV_COUCHDB_NODENAME:-${COUCHDB_NODENAME:-$NODENAME}}"
COUCHDB_USER="${ENV_COUCHDB_USER:-${COUCHDB_USER:-$DATABASE_USER_ROOT}}"
COUCHDB_PASSWORD="${ENV_COUCHDB_PASSWORD:-${COUCHDB_PASSWORD:-$DATABASE_PASS_ROOT}}"
DATABASE_DIR_COUCHDB="${ENV_DATABASE_DIR_COUCHDB:-${DATABASE_DIR_COUCHDB:-/data/db/couchdb}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
