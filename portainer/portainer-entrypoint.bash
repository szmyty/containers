#!/usr/bin/env bash

# Custom initialization or setup commands can go here

# Execute Portainer with default or overridden flags
exec /portainer \
    --host unix:///var/run/docker.sock \
    --admin-password "$PORTAINER_ADMIN_PASSWORD" \
    --data "/data" \
    --base-url "/portainer" \
    "$@"
