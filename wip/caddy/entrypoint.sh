#!/usr/bin/env bash
set -eu

# Substitute environment variables in Caddyfile.template
# shellcheck disable=SC2016
envsubst '$GEOIP_ACCOUNT_ID,$GEOIP_LICENSE_KEY' < "$CADDYFILE" > "$CADDYFILE.tmp" && mv "$CADDYFILE.tmp" "$CADDYFILE"

# Runs Caddy and blocks indefinitely; i.e. "daemon" mode.
# https://caddyserver.com/docs/command-line#caddy-run
"$CADDY" run --config "$CADDYFILE" --adapter caddyfile
