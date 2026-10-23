#!/bin/bash
set -Eeuo pipefail

# Install Kubernetes node tools on Amazon Linux 2023:
#   kubelet, kubeadm, kubectl, and crictl
# This script installs tools only. It does not initialize a cluster,
# configure a container runtime, or join a node to a cluster.

K8S_MINOR_VERSION="v1.34"
CRICTL_VERSION="v1.34.0"
LOG_FILE="/var/log/install-kubernetes.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== Kubernetes tools installation started ====="
date

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: Run this script as root (Terraform user_data normally runs as root)." >&2
  exit 1
fi

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)
    CRICTL_ARCH="amd64"
    ;;
  aarch64)
    CRICTL_ARCH="arm64"
    ;;
  *)
    echo "ERROR: Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

echo "===== Installing prerequisites ====="
dnf install -y ca-certificates curl-minimal tar gzip

echo "===== Configuring Kubernetes ${K8S_MINOR_VERSION} repository ====="
cat > /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/${K8S_MINOR_VERSION}/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/${K8S_MINOR_VERSION}/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

dnf clean all
dnf makecache --refresh

echo "===== Installing kubelet, kubeadm, and kubectl ====="
dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Prefer the repository-installed kubectl so its version matches kubelet/kubeadm.
if [[ -x /usr/bin/kubectl ]]; then
  install -m 0755 /usr/bin/kubectl /usr/local/bin/kubectl
fi

echo "===== Installing crictl ${CRICTL_VERSION} ====="
CRICTL_URL="https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-${CRICTL_ARCH}.tar.gz"
TMP_ARCHIVE="$(mktemp /tmp/crictl.XXXXXX.tar.gz)"
trap 'rm -f "$TMP_ARCHIVE"' EXIT

curl -fL --retry 3 --retry-delay 2 "$CRICTL_URL" -o "$TMP_ARCHIVE"
tar -xzf "$TMP_ARCHIVE" -C /usr/local/bin crictl
chmod 0755 /usr/local/bin/crictl

echo "===== Enabling kubelet service ====="
systemctl enable kubelet

echo "===== Installed versions ====="
kubelet --version
kubeadm version -o short
kubectl version --client
/usr/local/bin/crictl --version

echo "===== Kubernetes tools installation completed ====="
echo "Log file: $LOG_FILE"
echo "Note: This script does not install/configure a container runtime, initialize a cluster, or run kubeadm join."
