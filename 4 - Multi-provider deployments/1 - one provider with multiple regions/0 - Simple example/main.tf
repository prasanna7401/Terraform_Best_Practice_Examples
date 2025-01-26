resource "aws_instance" "server-main" {
  provider      = aws.primary
  ami           = data.aws_ami.ubuntu-main.id
  instance_type = "t2.micro"
  tags = {
    Name = "Main-Server"
  }
}

resource "aws_instance" "server-dr" {
  provider      = aws.secondary
  ami           = data.aws_ami.ubuntu-dr.id
  instance_type = "t2.micro"
  tags = {
    Name = "DR-Server"
  }
}