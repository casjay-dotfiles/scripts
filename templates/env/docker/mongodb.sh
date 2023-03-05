# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# mongodb env
NITDB_ROOT_USERNAME="\${DATABASE_USER_ROOT:-\$NITDB_ROOT_USERNAME}"
DATABASE_DIR_MONGODB="\${DATABASE_DIR_MONGODB:-\$DATABASE_BASE_DIR/mongodb}"
MONGO_INITDB_ROOT_PASSWORD="\${DATABASE_PASS_ROOT:-\$MONGO_INITDB_ROOT_PASSWORD}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
