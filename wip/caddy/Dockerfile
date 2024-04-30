# syntax=docker/dockerfile:1
# escape=\
FROM caddy:2.7-builder AS configure

# Set maintainer label
LABEL maintainer="szmyty@gmail.com"

# Install dependencies.
RUN apk --no-cache add gettext nss wget

# Dynamically build Caddy for a specific DNS provider (Default: localhost).
ARG DNS_PROVIDER=localhost

# Set home directory for Caddy configuration.
ARG CADDY_HOME=/etc/caddy

# Output file for Caddy executable.
ARG CADDY=/usr/bin/caddy

# Add builder files to temp directory.
ARG PLUGINS_LIST=$CADDY_HOME/plugins.list
ARG INIT_SCRIPT=$CADDY_HOME/init.sh
ARG CADDY_TEMPLATE=$CADDY_HOME/Caddyfile.template
ARG XCADDY_COMMAND=$CADDY_HOME/xcaddy_command

# Copy over builder files.
COPY ./plugins.list $PLUGINS_LIST
COPY ./init.sh $INIT_SCRIPT
COPY ./Caddyfile.template $CADDY_TEMPLATE

# Run script to initialize Caddy configuration and build Caddy executable with plugins.
RUN chmod +x $INIT_SCRIPT && sh $INIT_SCRIPT

FROM configure AS builder

# Build the custom Caddy executable using the command that was built during the configure stage.
RUN eval "$(cat "$XCADDY_COMMAND")"

FROM caddy:2.7-alpine

# Install dependencies.
RUN apk --no-cache add wget gettext nss nss-tools bash openjdk11-jre ca-certificates

# Set the JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

# Set home directory for Caddy configuration.
ENV CADDY_HOME=/etc/caddy

# Set home directory for GeoIP2.
ENV GEOIP_HOME=/etc/geoip2

# Caddy executable.
ENV CADDY=/usr/bin/caddy

# Caddyfile (configuration).
ENV CADDYFILE=$CADDY_HOME/Caddyfile

# Copy Caddyfile configuration snippets.
COPY ./snippets $CADDY_HOME/snippets
COPY ./Caddyfile $CADDYFILE

# Increase the kernel limit socket buffer.
# https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
COPY ./sysctl.conf /etc/sysctl.d/sysctl.conf

# Avoid privilege escalation
# RUN addgroup -S caddy && adduser -S caddyuser -G caddy && adduser caddyuser wheel

# Create the output directory as root.
RUN mkdir -p /opt/caddy

# Set the caddyuser to be the owner of the output directory.
#RUN chown caddyuser /opt/caddy

# Formats the Caddyfile.
# https://caddyserver.com/docs/command-line#caddy-fmt
RUN "$CADDY" fmt --overwrite "$CADDYFILE"

#USER caddyuser

# Set a non-root working directory
#WORKDIR /home/caddyuser

# Copy custom Caddy executable from builder step.
COPY --from=builder $CADDY $CADDY

# Copy custom Caddy configuration files from builder step.
COPY --from=builder $CADDY_HOME $CADDY_HOME

# Ensure that health checks are in place for long-running containers
# HEALTHCHECK CMD curl --fail http://localhost:8080/healthz || exit 1

STOPSIGNAL SIGTERM

# Entrypoint script.
COPY ./entrypoint.sh .

# Copy the GeoLite2-City database to the database directory.
COPY ./geoip/GeoLite2-City*/GeoLite2-City.mmdb $GEOIP_HOME/GeoLite2-City.mmdb

#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["bash", "-c", "./entrypoint.sh"]
