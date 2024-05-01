#!/usr/bin/env bash
# This script is used to check if the MongoDB service is up and running.

set -euo pipefail

# Check if the MongoDB service is up and running.
# Attempt to execute a simple command that returns the server status.
# Replace 'admin' with the appropriate database if needed.
status=$(mongo admin --eval "db.runCommand('ping').ok" --quiet)

if [[ "${status}" != "1" ]]; then
    echo "The MongoDB service is not running."
    exit 1
else
    echo "The MongoDB service is up and running."
    exit 0
fi
