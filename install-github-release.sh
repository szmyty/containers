#!/usr/bin/env bash
# Script to download and install the latest release of a GitHub package.

set -euo pipefail

if [[ "$#" -ne 2 ]]; then
  echo "Usage: $0 <github_repo> <package_name>"
  exit 1
fi

GITHUB_REPO=$1
PACKAGE_NAME=$2

# Fetch the latest release version from GitHub API
LATEST_RELEASE=$(curl --silent "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Latest release version is ${LATEST_RELEASE}"

# Download the latest release tarball
curl -L "https://github.com/${GITHUB_REPO}/archive/${LATEST_RELEASE}.tar.gz" -o "/tmp/${PACKAGE_NAME}-${LATEST_RELEASE}.tar.gz"

# Extract the tarball
tar -xzvf "/tmp/${PACKAGE_NAME}-${LATEST_RELEASE}.tar.gz" -C /tmp

# Change to the package directory
cd "/tmp/${PACKAGE_NAME}-${LATEST_RELEASE}"

# Install the package.
./configure && make && make install

# Clean up the temporary files
rm -rf "/tmp/${PACKAGE_NAME}-${LATEST_RELEASE}" "/tmp/${PACKAGE_NAME}-${LATEST_RELEASE}.tar.gz"

echo "${PACKAGE_NAME} installation completed."
