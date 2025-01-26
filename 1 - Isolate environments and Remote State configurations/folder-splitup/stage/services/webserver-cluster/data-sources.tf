
# IMPORTANT: This data source is used to fetch the remote state outputs from the DB module at `data-stores/my-sql/`
data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = "us-east-2"
  }
}

data "aws_vpc" "default" {
  default = true # Not recommended for production use
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