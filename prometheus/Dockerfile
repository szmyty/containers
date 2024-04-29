# syntax=docker/dockerfile:1
# escape=\
ARG PROMETHEUS_VERSION
FROM ubuntu/prometheus:$PROMETHEUS_VERSION

# Set maintainer label
LABEL maintainer="szmyty@gmail.com"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    apt-get install -y gettext-base && \
    rm -rf /var/lib/apt/lists/*

ARG CADDY_ADMIN_PORT=2019
ENV CADDY_ADMIN_PORT=$CADDY_ADMIN_PORT

ARG PROMETHEUS_PORT=9090
ENV PROMETHEUS_PORT=$PROMETHEUS_PORT

# Prometheus configuration.
COPY ./config.yml /etc/prometheus/prometheus.yml

# Entrypoint script.
COPY ./entrypoint.sh .

EXPOSE $PROMETHEUS_PORT

ENTRYPOINT ["bash", "-c", "./entrypoint.sh"]
