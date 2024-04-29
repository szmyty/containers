#!/usr/bin/env bash

# Script to set memory overcommit to a recommended setting for Redis
# Ensures that background saving and replication do not fail under low memory conditions.

# Check if the script is running as root
if [[ ${EUID} -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Set vm.overcommit_memory to 1
echo "Setting vm.overcommit_memory to 1..."
echo 'vm.overcommit_memory=1' >>/etc/sysctl.conf

# Reload sysctl to apply changes
echo "Applying changes..."
sysctl -p

echo "Configuration updated successfully."
