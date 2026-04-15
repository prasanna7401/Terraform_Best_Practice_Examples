terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "this" {
  name        = var.sg_name
  description = "Security group managed by Terraform"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = var.sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ingress" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.allowed_cidr_block
  from_port         = var.ingress_port
  to_port           = var.ingress_port
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
