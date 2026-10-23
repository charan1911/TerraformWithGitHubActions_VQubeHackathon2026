
#!/bin/bash
set -e

echo "===== Installing Grafana ====="

# Configure Grafana repository
cat > /etc/yum.repos.d/grafana.repo <<'REPO'
[grafana]
name=Grafana OSS
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
REPO

# Refresh repository metadata
dnf clean all
dnf makecache --refresh

# Install Grafana
dnf install -y grafana

# Enable Grafana at boot and start it now
systemctl enable --now grafana-server

# Verify installation
echo "===== Grafana Version ====="
grafana-server -v

echo "===== Grafana Service Status ====="
systemctl is-active grafana-server

echo "===== Grafana Installation Completed ====="
