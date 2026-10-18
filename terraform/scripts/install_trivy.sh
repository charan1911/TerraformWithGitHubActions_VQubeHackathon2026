exec > >(tee -a /var/log/user-data.log) 2>&1

echo "Starting Trivy installation..."

# Check curl availability
command -v curl

# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
  | sh -s -- -b /usr/local/bin

# Verify installation
/usr/local/bin/trivy --version

echo "Trivy installation completed successfully."
