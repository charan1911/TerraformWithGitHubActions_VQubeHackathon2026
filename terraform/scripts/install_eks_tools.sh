
#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/install-eks-tools.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting EKS tools installation..."

# Install prerequisites
dnf install -y unzip tar gzip

# Install AWS CLI v2 if missing
if ! command -v aws >/dev/null 2>&1; then
    cd /tmp
    curl -fsSLo awscliv2.zip \
      https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
    unzip -q -o awscliv2.zip
    ./aws/install
    rm -rf aws awscliv2.zip
fi

# Install kubectl if missing
if ! command -v kubectl >/dev/null 2>&1; then
    ARCH="$(uname -m)"
    case "$ARCH" in
      x86_64) K8S_ARCH="amd64" ;;
      aarch64) K8S_ARCH="arm64" ;;
      *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
    esac

    K8S_VERSION="$(curl -fsSL \
      https://dl.k8s.io/release/stable.txt)"

    curl -fsSLo /tmp/kubectl \
      "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/${K8S_ARCH}/kubectl"

    install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
    rm -f /tmp/kubectl
fi

echo "Installed tool versions:"
aws --version
kubectl version --client
terraform --version || true

echo "EKS tools installation completed."
