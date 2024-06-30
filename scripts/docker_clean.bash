#!/usr/bin/env bash
# Script to clean Docker system while preserving base images and filtering by service.
#
# This script stops and removes containers, images, volumes, and networks associated with a specified label.
# It aims to provide a clean starting environment without removing untagged or unrelated Docker resources.

set -euo pipefail

# ANSI Color Codes
MAGENTA='\033[1;35m' # Magenta color for output
NC='\033[0m'         # No Color

# Stop containers with a specific label.
function stop_containers() {
    local label=$1
    echo "Stopping containers with label: ${label}"
    local containers
    containers=$(docker container ls --all --filter "label=${label}" --format "{{.Names}}")
    if [[ -n "${containers}" ]]; then
        echo "${containers}"
        # shellcheck disable=SC2086
        docker container stop ${containers} 2>/dev/null
    fi
}

# Remove containers with a specific label.
function remove_containers() {
    local label=$1
    echo "Removing containers with label: ${label}"
    local containers
    containers=$(docker container ls --all --filter "label=${label}" --format "{{.Names}}")
    if [[ -n "${containers}" ]]; then
        echo "${containers}"
        # shellcheck disable=SC2086
        docker container rm ${containers} 2>/dev/null
    fi
}

# Remove volumes with a specific label.
function remove_volumes() {
    local label=$1
    echo "Removing volumes with label: ${label}"
    local volumes
    volumes=$(docker volume ls --filter "label=${label}" --format "{{.Name}}")
    if [[ -n "${volumes}" ]]; then
        echo "${volumes}"
        # shellcheck disable=SC2086
        docker volume rm ${volumes} 2>/dev/null
    fi
}

# Remove images with a specific label.
function remove_images() {
    local label=$1
    echo "Removing images with label: ${label}"
    local images
    images=$(docker image ls --filter "label=${label}" --format "{{.Repository}}:{{.Tag}}")
    if [[ -n "${images}" ]]; then
        echo "${images}"
        # shellcheck disable=SC2086
        docker image rm ${images} 2>/dev/null
    fi
}

# Remove networks with a specific label.
function remove_networks() {
    local label=$1
    echo "Removing networks with label: ${label}"
    local networks
    networks=$(docker network ls --filter "label=${label}" --format "{{.Name}}")
    if [[ -n "${networks}" ]]; then
        echo "${networks}"
        # shellcheck disable=SC2086
        docker network rm ${networks} 2>/dev/null
    fi
}

# Clean up the Docker builder cache.
function clean_build_cache() {
    echo "Cleaning up Docker build cache"
    docker builder prune --all --force 2>/dev/null
}

# Main function to orchestrate cleanup based on label.
function main() {
    local label=$1
    echo "Starting Docker cleanup for label: ${label}"
    stop_containers "${label}"
    remove_containers "${label}"
    remove_images "${label}"
    remove_volumes "${label}"
    remove_networks "${label}"
    clean_build_cache
    echo "Docker clean-up complete."
}


function container_ips() {
    docker inspect --filter '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{.Name}}' $(docker ps --quiet)
}


# Entry point
main "$@"
