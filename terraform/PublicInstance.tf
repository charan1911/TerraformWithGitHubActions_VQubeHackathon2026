
resource "aws_instance" "public_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Install Trivy
    ${file("${path.module}/scripts/install_trivy.sh")}

    # Install Terraform
    ${file("${path.module}/scripts/install_terraform.sh")}

    # Install Docker
    ${file("${path.module}/scripts/install_docker.sh")}

    # Install Grafana
    ${file("${path.module}/scripts/install_grafana.sh")}

    # Install SonarQube
    ${file("${path.module}/scripts/install_sonarqube.sh")}

    # Install Prometheus
    ${file("${path.module}/scripts/install_prometheus.sh")}

    # Install EKS
    ${file("${path.module}/scripts/install_eks_tools.sh")}

    #Install K8S
    ${file("${path.module}/scripts/install_Kubernetes.sh")}
  EOF

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_name}-PublicInstance"
  }
}
