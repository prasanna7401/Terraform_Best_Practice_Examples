# Fetch the latest Amazon Linux 2 AMI (2023 version)
data "aws_ami" "linux_ami" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "^al2023-ami-.*-kernel-.*-x86_64"
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Import Key Pair
resource "aws_key_pair" "ec2-kp" {
  key_name   = "My_EC2_PUB"
  public_key = file("my-ec2-kp.pub") # This is created using ssh-keygen -f my-ec2-kp in your local machine
}