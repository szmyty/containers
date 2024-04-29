#!/usr/bin/env bash
# This script is used to check if the Redis service is up and running.

set -euo pipefail

# Check if the Redis service is up and running.
pong="$(redis-cli ping)"
if [[ "${pong}" != "PONG" ]]; then
    echo "The Redis service is not running."
    exit 1
else
    echo "The Redis service is up and running."
    exit 0
fi
