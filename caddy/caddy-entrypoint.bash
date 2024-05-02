#!/usr/bin/env bash

# Formats the Caddyfile.
# https://caddyserver.com/docs/command-line#caddy-fmt
/usr/bin/caddy fmt --overwrite /etc/caddy/Caddyfile

# Execute the main process using exec to ensure it receives SIGTERM
exec "$@"
