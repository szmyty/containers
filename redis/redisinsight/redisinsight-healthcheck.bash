#!/usr/bin/env bash
# This script is used to check if the RedisInsight service is up and running.

set -euo pipefail

# URL to check the health of the RedisInsight service.
# shellcheck disable=SC2154
REDISINSIGHT_HEALTHCHECK_URL="http://${RI_APP_HOST}:${RI_APP_PORT}/api/health"

# Use 'curl' to fetch the health status and 'jq' to parse the JSON response.
status=$(curl --silent "${REDISINSIGHT_HEALTHCHECK_URL}" | jq -r '.status')

echo "RedisInsight service status: ${status}"

# Check if RedisInsight service is up and running.
if [[ "${status}" = "up" ]]; then
    echo "RedisInsight service is running."
    exit 0
else
    echo "RedisInsight service is not running."
    exit 1
fi
