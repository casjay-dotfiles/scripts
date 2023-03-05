# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ssl server settings
SSL_ENABLED="${SSL_ENABLED:-false}"
SSL_DIR="${SSL_CONTAINER_DIR:-/config/ssl}"
SSL_DIR="${SSL_DIR:-$SSL_DIR}"
SSL_CA="${SSL_CA:-$SSL_DIR/ca.crt}"
SSL_KEY="${SSL_KEY:-$SSL_DIR/server.key}"
SSL_CERT="${SSL_CERT:-$SSL_DIR/server.crt}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# certificate settings
RSA="${RSA:-4096}"
STATE="${STATE:-NY}"
CITY="${CITY:-Albany}"
COUNTRY="${COUNTRY:-US}"
UNIT="${UNIT:-CasjaysDev}"
ORG="${ORG:-"Casjays Developments"}"
DAYS_VALID="${DAYS_VALID:-3650}"
CN="${CN:-${FULL_DOMAIN_NAME:-$HOSTNAME}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
