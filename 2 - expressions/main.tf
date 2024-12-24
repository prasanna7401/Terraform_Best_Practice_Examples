terraform {
  required_version = ">= 1.0.0" # version constraint - Good practice
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1" # N. Vigirnia
}


variable "vpc_id" {
  description = "The ID of the VPC"
  default     = "vpc-0bcf336f9d41db6ae" # default VPC
}

# declare existing VPC for reference - DATA
data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group" "to_be_imported" {
  # fill later after import
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.main.id # find other variables using terraform state show command

  tags = {
    Name       = "allow_tls"
    Deployment = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  description       = "Allow inbound traffic on port 443"
  cidr_ipv4         = data.aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  description       = "Allow all outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
