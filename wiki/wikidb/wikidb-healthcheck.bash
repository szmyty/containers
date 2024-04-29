#!/usr/bin/env bash
# This script checks if the PostgreSQL service is up and running using pg_isready.

set -euo pipefail

# Define database connection parameters.
# shellcheck disable=SC2154
DB_HOST="${COMPOSE_PROJECT_NAME}.${WIKIDB_HOSTNAME}"

# shellcheck disable=SC2154
DB_PORT="${WIKIDB_PORT}"

# shellcheck disable=SC2154
DB_USER="${WIKIDB_DB_USER}"

# shellcheck disable=SC2154
DB_NAME="${WIKIDB_DB_NAME}"

# Execute pg_isready and capture the output
is_db_ready=$(pg_isready \
    --host="${DB_HOST}" \
    --port="${DB_PORT}" \
    --username="${DB_USER}" \
    --dbname="${DB_NAME}" \
    --timeout=1 \
    >/dev/null 2>&1 && echo "success" || echo "fail")

# Check if the database is ready
if [[ "${is_db_ready}" = "success" ]]; then
    echo "The PostgreSQL service is up and running."
    exit 0
else
    echo "The PostgreSQL service is not running."
    exit 1
fi
