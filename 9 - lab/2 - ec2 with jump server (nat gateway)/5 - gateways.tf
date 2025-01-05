# Internet Gateway & NAT Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = var.tags
}

# Create a NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  subnet_id = aws_subnet.public.id
  allocation_id = aws_eip.elastic-ip.id
}


# Create an elastic IP for NAT Gateway
resource "aws_eip" "elastic-ip" {
  domain = "standard" # any public ip
}