#!/bin/bash
set -e
exec > >(tee -a /var/log/user-data.log) 2>&1

echo "Starting Trivy installation..."

# Use the existing curl command
command -v curl

# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
  | sh -s -- -b /usr/local/bin

# Verify installation
/usr/local/bin/trivy --version

echo "Trivy installation completed."
