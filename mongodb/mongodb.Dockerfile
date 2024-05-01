# syntax=docker/dockerfile:1

# Service version to use.
ARG MONGODB_VERSION=latest

# Use the official MongoDB Community Server image as the base image.
# https://hub.docker.com/r/mongodb/mongodb-community-server/
FROM mongodb/mongodb-community-server:${MONGODB_VERSION}

# Set the MongoDB version as an environment variable.
ENV MONGODB_VERSION=${MONGODB_VERSION}

# Set the MongoDB configuration path as an environment variable.
ARG MONGODB_CONFIG_PATH=/usr/local/etc/mongodb/mongodb.conf
ENV MONGODB_CONFIG_PATH=${MONGODB_CONFIG_PATH}

# Copy the MongoDB configuration file to the container.
COPY mongodb.conf ${MONGODB_CONFIG_PATH}

# Set the MongoDB health check script path as an environment variable.
ARG MONGODB_HEALTHCHECK_PATH=/usr/local/bin/mongodb-healthcheck.bash
ENV MONGODB_HEALTHCHECK_PATH=${MONGODB_HEALTHCHECK_PATH}

# Copy the MongoDB health check script to the container.
COPY mongodb-healthcheck.bash ${MONGODB_HEALTHCHECK_PATH}

# Set the MongoDB health check script as executable.
RUN chmod +x ${MONGODB_HEALTHCHECK_PATH}

# Set the MongoDB health check command using the health check script.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ${MONGODB_HEALTHCHECK_PATH}

# Set the MongoDB command using the MongoDB configuration file.
# CMD redis-server ${MONGODB_CONFIG_PATH}
