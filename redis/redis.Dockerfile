# syntax=docker/dockerfile:1

# Service version to use.
ARG REDIS_VERSION=latest

# Use the official Redis image as the base image.
# https://hub.docker.com/_/redis
FROM redis:${REDIS_VERSION}

# Set the Redis version as an environment variable.
ENV REDIS_VERSION=${REDIS_VERSION}

# Set the Redis configuration path as an environment variable.
ARG REDIS_CONFIG_PATH=/usr/local/etc/redis/redis.conf
ENV REDIS_CONFIG_PATH=${REDIS_CONFIG_PATH}

# Copy the Redis configuration file to the container.
COPY redis.conf ${REDIS_CONFIG_PATH}

# Set the Redis health check script path as an environment variable.
ARG REDIS_HEALTHCHECK_PATH=/usr/local/bin/redis-healthcheck.bash
ENV REDIS_HEALTHCHECK_PATH=${REDIS_HEALTHCHECK_PATH}

# Copy the Redis health check script to the container.
COPY redis-healthcheck.bash ${REDIS_HEALTHCHECK_PATH}

# Set the Redis health check script as executable.
RUN chmod +x ${REDIS_HEALTHCHECK_PATH}

# Set the Redis health check command using the health check script.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ${REDIS_HEALTHCHECK_PATH}

# Set the Redis command using the Redis configuration file.
CMD redis-server ${REDIS_CONFIG_PATH}
