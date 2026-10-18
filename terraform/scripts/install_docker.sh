
#!/bin/bash
set -e

echo "Starting Docker installation..."

dnf install -y docker

systemctl enable --now docker

usermod -aG docker ec2-user

docker --version
systemctl is-active docker

echo "Docker installation completed successfully."
