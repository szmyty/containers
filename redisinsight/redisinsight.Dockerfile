# syntax=docker/dockerfile:1

# Service version to use.
ARG REDISINSIGHT_VERSION=latest

# Use the official RedisInsight image as the base image.
# https://hub.docker.com/r/redis/redisinsight
FROM redis/redisinsight:${REDISINSIGHT_VERSION}

# Set the RedisInsight version as an environment variable.
ENV REDISINSIGHT_VERSION=${REDISINSIGHT_VERSION}

# Switch to the root user to install additional dependencies.
USER root

# Install additional dependencies.
RUN apk add --no-cache bash curl wget jq

# Set the RedisInsight health check script path as an environment variable.
ARG REDISINSIGHT_HEALTHCHECK_PATH=/usr/local/bin/redisinsight-healthcheck.bash
ENV REDISINSIGHT_HEALTHCHECK_PATH=${REDISINSIGHT_HEALTHCHECK_PATH}

# Copy the RedisInsight health check script to the container.
COPY redisinsight-healthcheck.bash ${REDISINSIGHT_HEALTHCHECK_PATH}

# Set the RedisInsight health check script as executable.
RUN chmod +x ${REDISINSIGHT_HEALTHCHECK_PATH}

# Set the RedisInsight health check command using the health check script.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ${REDISINSIGHT_HEALTHCHECK_PATH}

# Switch back to the default user.
USER node
