#!/usr/bin/env bash
# Health check script for Portainer Community Edition

set -euo pipefail

# Default host and port for Portainer
DEFAULT_PORTAINER_HOSTNAME="localhost"
DEFAULT_PORTAINER_PORT="9000"

# Use environment variables if set, otherwise use defaults
PORTAINER_HOST="${PORTAINER_HOSTNAME:-$DEFAULT_PORTAINER_HOSTNAME}"
PORTAINER_PORT="${PORTAINER_PORT:-$DEFAULT_PORTAINER_PORT}"
API_ENDPOINT="http://${PORTAINER_HOST}:${PORTAINER_PORT}/api/status"

# Function to check Portainer's health
function check_portainer_health() {
    # Use curl to send a GET request to the Portainer API
    if curl -s --fail "$API_ENDPOINT" >/dev/null; then
        echo "Portainer is up and running."
        exit 0
    else
        echo "Failed to connect to Portainer."
        exit 1
    fi
}

# Call the health check function
check_portainer_health
