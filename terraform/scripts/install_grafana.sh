
echo "===== Installing Grafana ====="

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

dnf install -y grafana

systemctl enable --now grafana-server

grafana-server -v
systemctl is-active grafana-server

echo "===== Grafana installation completed ====="
