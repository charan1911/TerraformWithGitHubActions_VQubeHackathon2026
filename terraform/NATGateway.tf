
# Allocate a static public IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-NAT-EIP"
  }
}

# Create the NAT Gateway in public subnet A
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "${var.project_name}-NAT-Gateway"
  }

  depends_on = [aws_internet_gateway.main]
}

# Allow private subnets to reach the internet through NAT
resource "aws_route" "private_internet_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}
