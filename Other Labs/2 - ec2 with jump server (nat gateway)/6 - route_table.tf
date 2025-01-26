# Route Table

# RT for Public subnet
resource "aws_route_table" "igw-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0" # connections to the internet
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name            = "IGW-RT"
    InstanceManager = "terraform-prasanna"
  }
}

# RT for Private subnet
resource "aws_route_table" "priv-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "Priv-RT"
    InstanceManager = "terraform-prasanna"
  }
}

# RT Associations


# Associate Public subnet with Public RT
resource "aws_route_table_association" "pub_snet_association" {
  route_table_id = aws_route_table.igw-rt.id
  subnet_id      = aws_subnet.public.id
}

# Associate Private subnet with Private RT
resource "aws_route_table_association" "priv_snet_assoc" {
  route_table_id = aws_route_table.priv-rt.id
  subnet_id = aws_subnet.private.id
}