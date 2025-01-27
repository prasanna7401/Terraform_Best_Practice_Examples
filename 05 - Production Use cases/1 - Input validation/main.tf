resource "aws_instance" "server-main" {
  provider      = aws.primary
  ami           = data.aws_ami.ubuntu-main.id
  instance_type = var.instance_type
  tags = {
    Name = "Main-Server"
  }

  lifecycle {
    create_before_destroy = true
    precondition {
      condition = data.aws_ec2_instance_type.instance.free_tier_eligible
      error_message = "${var.instance_type} is not eligible for the free tier"
    }
    # post coondition to check if it has public ip
    postcondition {
      condition = self.public_ip != null # self is the instance
      error_message = "The instance does not have a public IP"
    }
  }
}

resource "aws_instance" "server-dr" {
  provider      = aws.secondary
  ami           = data.aws_ami.ubuntu-dr.id
  instance_type = var.instance_type
  tags = {
    Name = "DR-Server"
  }
}