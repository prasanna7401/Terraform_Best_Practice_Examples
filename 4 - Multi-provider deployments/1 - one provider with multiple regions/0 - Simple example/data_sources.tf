# data "aws_region" "region_1" {
#     provider = aws.MAIN
# }

# data "aws_region" "region_2" {
#     provider = aws.DR
# }

# data "aws_availability_zones" "region_1" {
#     provider = aws.MAIN
# }

# data "aws_availability_zones" "region_2" {
#     provider = aws.DR
# }

data "aws_ami" "ubuntu-main" {
  provider    = aws.primary
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_ami" "ubuntu-dr" {
  provider    = aws.secondary
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}