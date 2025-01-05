resource "aws_security_group" "pub_sg" {
  name        = "My-PUB-SG"
  description = "SG for Public Subnet"
  vpc_id      = aws_vpc.main.id

  # Ingress Rule-1: SSH Access to Public Subnet
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 0 # any source port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # any source

  }

  # Ingress Rule-2: Access to Public Subnet via port 8081
  ingress {
    description = "Allow 8081 from anywhere"
    from_port   = 0
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress Rule-1: Allow internet access
  egress {
    description = "Open outbound connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "priv_sg" {
  name        = "My-PRIV-SG"
  description = "SG for Private Subnet"
  vpc_id      = aws_vpc.main.id

  # Ingress Rule-1: SSH Access to Private Subnet
  ingress {
    description = "Allow SSH Access from same VPC"
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block] # connections from VPC
  }

  # Egress Rule-1: Allow internet access
  egress {
    description = "Open outbound connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}