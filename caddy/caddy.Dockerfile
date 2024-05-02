# syntax=docker/dockerfile:1
# escape=\

# Service version to use.
ARG CADDY_VERSION=latest

# Use the official Caddy image as the base image.
# https://hub.docker.com/_/caddy
FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

# Set the Caddy version as an environment variable.
ENV CADDY_VERSION=${CADDY_VERSION}

# Install dependencies.
RUN apk --no-cache add gettext nss wget

RUN xcaddy build \
    --with github.com/caddyserver/replace-response 

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Install additional dependencies.
RUN apk add --no-cache wget gettext nss nss-tools bash openjdk11-jre ca-certificates jq

# Set the JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

# Copy Caddyfile configuration snippets.
# COPY ./snippets /etc/caddy/snippets

# Copy Caddyfile.
COPY ./Caddyfile /etc/caddy/Caddyfile

# Create Caddy's fileserver directory root.
RUN mkdir -p /opt/caddy/fileserver

# Set the Caddy health check script path as an environment variable.
ARG CADDY_HEALTHCHECK_DIR=/usr/local/bin
ARG CADDY_HEALTHCHECK_SCRIPT=caddy-healthcheck.bash
ENV CADDY_HEALTHCHECK_PATH=${CADDY_HEALTHCHECK_DIR}/${CADDY_HEALTHCHECK_SCRIPT}

# Copy the Caddy health check script to the container.
COPY ${CADDY_HEALTHCHECK_SCRIPT} ${CADDY_HEALTHCHECK_PATH}

# Set the Caddy health check script as executable.
RUN chmod +x ${CADDY_HEALTHCHECK_PATH}

# Set the Caddy health check command using the health check script.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ${CADDY_HEALTHCHECK_PATH}

# Adding a custom entrypoint script.
COPY caddy-entrypoint.bash /opt/caddy/caddy-entrypoint.bash
RUN chmod +x /opt/caddy/caddy-entrypoint.bash

ENTRYPOINT ["/opt/caddy/caddy-entrypoint.bash"]

# Runs Caddy and blocks indefinitely; i.e. "daemon" mode.
# https://caddyserver.com/docs/command-line#caddy-run
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
