
resource "aws_s3_bucket" "cloudshield_storage" {
  bucket = "cloudshield-storage-15oct20261540"

  tags = {
    Name        = "CloudShield-Storage"
    Environment = "Hackathon"
  }
}
