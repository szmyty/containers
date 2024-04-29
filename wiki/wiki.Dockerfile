# syntax=docker/dockerfile:1

# Service version to use.
ARG WIKI_VERSION=latest

# Use the official Wiki image as the base image.
# https://github.com/Requarks/wiki/pkgs/container/wiki
FROM ghcr.io/requarks/wiki:${WIKI_VERSION}

# Set the Wiki version as an environment variable.
ENV WIKI_VERSION=${WIKI_VERSION}

# Switch to the root user to install the required packages and permissions.
USER root

# Set the Wiki configuration path as an environment variable.
ARG WIKI_CONFIG_PATH=/wiki/config.yml
ENV WIKI_CONFIG_PATH=${WIKI_CONFIG_PATH}

# Copy the Wiki configuration file to the container.
COPY --chown=node:node wiki.conf.yml ${WIKI_CONFIG_PATH}

# Set the Wiki health check script path as an environment variable.
ARG WIKI_HEALTHCHECK_PATH=/usr/local/bin/wiki-healthcheck.bash
ENV WIKI_HEALTHCHECK_PATH=${WIKI_HEALTHCHECK_PATH}

# Copy the Wiki health check script to the container.
COPY wiki-healthcheck.bash ${WIKI_HEALTHCHECK_PATH}

# Set the Wiki health check script as executable.
RUN chmod +x ${WIKI_HEALTHCHECK_PATH}

# Set the Wiki health check command using the health check script.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ${WIKI_HEALTHCHECK_PATH}

# Switch back to the node user.
USER node
