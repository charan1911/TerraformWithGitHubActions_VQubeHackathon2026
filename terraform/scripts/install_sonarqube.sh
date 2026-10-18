
echo "===== Installing SonarQube ====="

systemctl enable --now docker

sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072

cat > /etc/sysctl.d/99-sonarqube.conf <<'SYSCTL'
vm.max_map_count=524288
fs.file-max=131072
SYSCTL

docker volume create sonarqube_data
docker volume create sonarqube_logs
docker volume create sonarqube_extensions

docker pull sonarqube:community

docker rm -f sonarqube 2>/dev/null || true

docker run -d \
  --name sonarqube \
  --restart unless-stopped \
  -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_logs:/opt/sonarqube/logs \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  sonarqube:community

echo "===== SonarQube container created ====="
