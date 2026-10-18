echo "Starting Terraform installation..."

# Install required tools
dnf install -y dnf-plugins-core

# Add the official HashiCorp repository
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Terraform
dnf install -y terraform

# Verify installation
terraform --version

echo "Terraform installation completed successfully."
