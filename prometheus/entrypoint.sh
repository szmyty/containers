#!/usr/bin/env bash
set -eu

# Substitute environment variables in prometheus.yaml configuration file.
# shellcheck disable=SC2016
envsubst '$CADDY_ADMIN_PORT' < "/etc/prometheus/prometheus.yml" > "/etc/prometheus/prometheus.yml.tmp" && \
  mv "/etc/prometheus/prometheus.yml.tmp" "/etc/prometheus/prometheus.yml"

/usr/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --web.listen-address=0.0.0.0:"$PROMETHEUS_PORT" \
  --storage.tsdb.path=/prometheus \
  --web.console.libraries=/usr/share/prometheus/console_libraries \
  --web.console.templates=/usr/share/prometheus/consoles
