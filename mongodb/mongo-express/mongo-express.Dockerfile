# syntax=docker/dockerfile:1

# Service version to use.
ARG MONGO_EXPRESS_VERSION=latest

# Use the official Mongo Express image as the base image.
# https://hub.docker.com/_/mongo-express
FROM mongo-express:${MONGO_EXPRESS_VERSION}

RUN id

# Set the Mongo Express version as an environment variable.
ENV MONGO_EXPRESS_VERSION=${MONGO_EXPRESS_VERSION}

# Set the Mongo Express configuration path as an environment variable.
ARG MONGO_EXPRESS_CONFIG_PATH=/usr/local/etc/mongodb/mongodb.conf
ENV MONGO_EXPRESS_CONFIG_PATH=${MONGO_EXPRESS_CONFIG_PATH}

# Copy the Mongo Express configuration file to the container.
COPY mongo-express.conf ${MONGO_EXPRESS_CONFIG_PATH}

# Set the Mongo Express health check script path as an environment variable.
ARG MONGO_EXPRESS_HEALTHCHECK_DIR=/usr/local/bin
ARG MONGO_EXPRESS_HEALTHCHECK_SCRIPT=mongodb-healthcheck.bash
ENV MONGO_EXPRESS_HEALTHCHECK_PATH=${MONGO_EXPRESS_HEALTHCHECK_DIR}/${MONGO_EXPRESS_HEALTHCHECK_SCRIPT}

# Copy the Mongo Express health check script to the container.
COPY ${MONGO_EXPRESS_HEALTHCHECK_SCRIPT} ${MONGO_EXPRESS_HEALTHCHECK_PATH}

# Switch to root to change permissions.
# USER root

# Set the Mongo Express health check script as executable.
RUN chmod +x ${MONGO_EXPRESS_HEALTHCHECK_PATH}

# Switch back to 'mongod' user.
# USER mongod

# Set the Mongo Express health check command using the health check script.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ${MONGO_EXPRESS_HEALTHCHECK_PATH}

# Set the MongoDB command using the MongoDB configuration file.
# CMD redis-server ${MONGODB_CONFIG_PATH}
