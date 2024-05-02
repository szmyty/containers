#!/usr/bin/env bash

# Script to increase the kernel limit socket buffer.
# https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes

# Check if the script is running as root
if [[ ${EUID} -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

{
    echo 'net.core.rmem_max=26214400'
    echo 'net.core.rmem_default=26214400'
    echo 'net.core.wmem_max=26214400'
    echo 'net.core.wmem_default=26214400'
    echo 'kern.ipc.maxsockbuf=3014656'
} >>/etc/sysctl.conf

# Reload sysctl to apply changes
echo "Applying changes..."
sysctl -p

echo "Configuration updated successfully."
