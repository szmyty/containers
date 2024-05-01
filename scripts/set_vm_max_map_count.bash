#!/usr/bin/env bash

# Script to set vm.max_map_count to a recommended setting for Elasticsearch
# Increases the limit on memory map areas a process may have. Required for Elasticsearch.

# Check if the script is running as root
if [[ ${EUID} -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Set vm.max_map_count to 262144
echo "Setting vm.max_map_count to 262144..."
echo 'vm.max_map_count=262144' >>/etc/sysctl.conf

# Reload sysctl to apply changes
echo "Applying changes..."
sysctl -p

echo "Configuration updated successfully."
