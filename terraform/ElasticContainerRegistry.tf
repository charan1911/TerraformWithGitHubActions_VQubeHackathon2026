resource "aws_ecrpublic_repository" "main" {
  repository_name = "cloudshield-public-repo"
  provider        = aws.us_east_1

  tags = {
    Name = "${var.project_name}-PublicECR"
  }
}