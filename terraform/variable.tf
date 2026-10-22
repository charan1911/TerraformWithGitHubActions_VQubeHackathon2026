variable "aws_region" {
  description = "AWS region for infrastructure"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "vpc_route_table" {
  description = "Route table for the VPC"
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = ""
}

variable "vpc_cidr1" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = ""
}

variable "vpc_cidr2" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = ""
}

variable "vpc_cidr3" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = ""
}


variable "private_cidr1" {
  description = "CIDR block for private subnet in AZ A"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_cidr2" {
  description = "CIDR block for private subnet in AZ B"
  type        = string
  default     = "10.0.12.0/24"
}

variable "private_cidr3" {
  description = "CIDR block for private subnet in AZ C"
  type        = string
  default     = "10.0.13.0/24"
}
