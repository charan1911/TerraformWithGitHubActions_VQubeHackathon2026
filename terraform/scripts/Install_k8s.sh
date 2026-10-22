
#!/bin/bash
set -euo pipefail

echo "Installing Kubernetes using K3s..."

# Check that the script is running on Linux
if [ "$(uname -s)" != "Linux" ]; then
  echo "Error: This script must run on Linux."
  exit 1
fi

# Install curl if it is missing
if ! command -v curl >/dev/null 2>&1; then
  sudo dnf install -y curl
fi

# Install K3s only if it is not already installed
if ! command -v k3s >/dev/null 2>&1; then
  curl -sfL https://get.k3s.io | sudo sh -
else
  echo "K3s is already installed."
fi

# Enable and start the Kubernetes service
sudo systemctl enable --now k3s

# Wait for the Kubernetes node to become ready
sudo k3s kubectl wait \
  --for=condition=Ready node \
  --all \
  --timeout=180s

# Display installation status
sudo k3s kubectl get nodes -o wide
sudo k3s kubectl get pods -A

echo "K3s Kubernetes installation completed successfully!"
