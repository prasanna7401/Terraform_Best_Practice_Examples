terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1" # N. Virginia
}

variable "app_name" {
    type    = string
    default = "httpd"
}

data "aws_ami" "pvacorp_linux" {
    owners = ["self"]
    filter {
        name = "name" # one of the filters available for AMI in aws
        values = ["pva-corp_${var.app_name}"] 
    }
}

# UPDATE this based on the VPC you have in your account

resource "aws_vpc" "imported_vpc" {
    # values imported by terraform import - FILTERED to only what is needed
    cidr_block                           = "172.31.0.0/16"
    enable_dns_hostnames                 = true
    enable_dns_support                   = true
    lifecycle {
        ignore_changes = [cidr_block]
        prevent_destroy = true
    }
}

// create a security group to allow inbound HTTP traffic to the instance
resource "aws_security_group" "http_server" {
  name        = "allow_http"
  description = "Allow inbound HTTP traffic"
  vpc_id = aws_vpc.imported_vpc.id # default VPC value imported using terraform import aws_vpc.default vpc-0bcf336f9d41db6ae
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.http_server.id
  cidr_ipv4   = "0.0.0.0/0" # allow all traffic
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

// create an ec2 instance using the AMI created by packer
resource "aws_instance" "pva-example" {
    ami           = data.aws_ami.pvacorp_linux.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.http_server.id]
    tags = {
        Deployment = "terraform-cloud"
        Environment = "test"
    }
}

// output the public IP of the instance
output "public_ip" {
    value = aws_instance.pva-example.public_ip
}