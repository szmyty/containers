# syntax=docker/dockerfile:1

# Service version to use.
ARG WIKIDB_VERSION=latest

# Use the official Postgres image as the base image.
# https://hub.docker.com/_/postgres/
FROM postgres:${WIKIDB_VERSION}

# Set the WikiDB version as an environment variable.
ENV WIKIDB_VERSION=${WIKIDB_VERSION}

# Switch to the root user to install the required packages and permissions.
USER root

# Set non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install additional dependencies.
RUN apt-get update --yes && \
    apt-get install --yes \
    bash \
    curl \
    jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the WikiDB health check script path as an environment variable.
ARG WIKIDB_HEALTHCHECK_PATH=/usr/local/bin/wikidb-healthcheck.bash
ENV WIKIDB_HEALTHCHECK_PATH=${WIKIDB_HEALTHCHECK_PATH}

# Copy the WikiDB health check script to the container.
COPY --chown=postgres:postgres wikidb-healthcheck.bash ${WIKIDB_HEALTHCHECK_PATH}

# Set the WikiDB health check script as executable.
RUN chmod +x ${WIKIDB_HEALTHCHECK_PATH}

# Set the WikiDB health check command using the health check script.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ${WIKIDB_HEALTHCHECK_PATH}

# Switch back to the postgres user.
USER postgres
