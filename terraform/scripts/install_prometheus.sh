#!/bin/bash
set -euo pipefail

echo "===== Installing Prometheus ====="

PROMETHEUS_VERSION="3.8.0"
PROMETHEUS_USER="prometheus"
ARCHIVE="prometheus-${PROMETHEUS_VERSION}.linux-amd64"
URL="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${ARCHIVE}.tar.gz"

dnf install -y wget tar

if ! id "$PROMETHEUS_USER" >/dev/null 2>&1; then
  useradd --system --no-create-home --shell /sbin/nologin "$PROMETHEUS_USER"
fi

mkdir -p /etc/prometheus /var/lib/prometheus

# Download and extract Prometheus
cd /tmp
rm -rf prometheus-extract prometheus.tar.gz
mkdir -p /tmp/prometheus-extract

wget -q --show-progress "$URL" -O /tmp/prometheus.tar.gz
tar -xzf /tmp/prometheus.tar.gz -C /tmp/prometheus-extract

# Locate the extracted binaries instead of assuming the directory layout
PROM_DIR="$(find /tmp/prometheus-extract -type f -name prometheus -print -quit)"
if [ -z "$PROM_DIR" ] || [ ! -f "$(dirname "$PROM_DIR")/promtool" ]; then
  echo "ERROR: Prometheus binaries were not found in the archive."
  exit 1
fi

install -m 0755 "$PROM_DIR" /usr/local/bin/prometheus
install -m 0755 "$(dirname "$PROM_DIR")/promtool" /usr/local/bin/promtool

# Configure Prometheus
cat > /etc/prometheus/prometheus.yml <<'CONFIG'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ["localhost:9090"]
CONFIG

chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Create the systemd service
cat > /etc/systemd/system/prometheus.service <<'SERVICE'
[Unit]
Description=Prometheus Monitoring
After=network-online.target
Wants=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus --web.listen-address=0.0.0.0:9090
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable --now prometheus

/usr/local/bin/prometheus --version
systemctl is-active prometheus

echo "===== Prometheus installation completed successfully ====="