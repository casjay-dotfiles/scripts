# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ssl server settings
SSL_ENABLED="${SSL_ENABLED:-false}"
SSL_DIR="${SSL_DIR:-/config/ssl}"
SSL_CA="${SSL_CA:-$SSL_DIR/ca.crt}"
SSL_KEY="${SSL_KEY:-$SSL_DIR/server.key}"
SSL_CERT="${SSL_CERT:-$SSL_DIR/server.crt}"
SSL_CONTAINER_DIR="${SSL_CONTAINER_DIR:-/etc/ssl/CA}"
COUNTRY="${COUNTRY:-US}"
STATE="${STATE:-NY}"
CITY="${CITY:-Albany}"
UNIT="${UNIT:-CasjaysDev}"
ORG="${ORG:-"Casjays Developments"}"
DAYS_VALID="${DAYS_VALID:-3650}"
RSA="${RSA:-4096}"
CN="${CN:-$FULL_DOMAIN_NAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
