# syntax=docker/dockerfile:1
# escape=\
FROM rust:1.71.0-bullseye as builder

# Set maintainer label
LABEL maintainer="szmyty@gmail.com"

# Avoid privilege escalation
RUN useradd -m whatbpm

# Set a non-root working directory
WORKDIR /home/whatbpm

# Copy app files to home directory.
COPY ./app .

# Install whatbpm application using cargo.
RUN cargo install --path .

FROM debian:bullseye-slim

# Ensure up-to-date system packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    apt-get install -y extra-runtime-dependencies && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/cargo/bin/whatbpm /usr/local/bin/whatbpm

CMD ["whatbpm"]
