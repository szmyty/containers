# syntax=docker/dockerfile:1
FROM node:18.17.0-bullseye

# Set maintainer label
LABEL maintainer="szmyty@gmail.com"

ENV NODE_ENV=production
ARG N64_PORT=3000

# Install serve package.
RUN npm install --global serve

# Avoid privilege escalation
RUN useradd -m n64
USER n64

# Set home directory for Caddy configuration.
ENV N64_HOME=/home/n64


RUN mkdir -p $N64_HOME
WORKDIR $N64_HOME

COPY ./app $N64_HOME/app

# Entrypoint script.
COPY ./entrypoint.sh .

ENTRYPOINT ["bash", "-c", "./entrypoint.sh"]
