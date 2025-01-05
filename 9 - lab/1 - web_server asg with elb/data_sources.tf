# Fetch subnets in the default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Fetch the latest Amazon Linux 2 AMI
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