# syntax=docker/dockerfile:1

# Service version to use.
ARG PORTAINER_VERSION=latest

# Use the official Portainer Community Edition image as the base image.
# https://hub.docker.com/r/portainer/portainer-ce
FROM portainer/portainer-ce:${PORTAINER_VERSION}

# Set the Portainer version as an environment variable.
ENV PORTAINER_VERSION=${PORTAINER_VERSION}

# Set the Portainer configuration path as an environment variable.
ARG PORTAINER_CONFIG_PATH=/usr/local/etc/portainer/portainer.conf
ENV PORTAINER_CONFIG_PATH=${PORTAINER_CONFIG_PATH}

# Copy the Portainer configuration file to the container.
COPY portainer.conf ${PORTAINER_CONFIG_PATH}

# Install additional dependencies.
RUN apk add --no-cache bash

# Set the Portainer health check script path as an environment variable.
ARG PORTAINER_HEALTHCHECK_PATH=/usr/local/bin/portainer-healthcheck.bash
ENV PORTAINER_HEALTHCHECK_PATH=${PORTAINER_HEALTHCHECK_PATH}

# Copy the Portainer health check script to the container.
COPY portainer-healthcheck.bash ${PORTAINER_HEALTHCHECK_PATH}

# # Set the Portainer health check script as executable.
RUN chmod +x ${PORTAINER_HEALTHCHECK_PATH}

# # Set the Portainer health check command using the health check script.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ${PORTAINER_HEALTHCHECK_PATH}
