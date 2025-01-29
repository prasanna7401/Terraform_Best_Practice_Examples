terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
    cloud {
      organization = "Cyber5"
      workspaces {
        name = "Learning_CLI"
      }
    }
}

provider "aws" {
    region = "us-east-1" # N. Virginia
}

# create an ec2 instance
resource "aws_instance" "example" {
    ami           = "ami-01816d07b1128cd2d" # Amazon Linux 2 AMI
    instance_type = "t2.micro" # should fail due to sentinel policy
    tags = {
        Deployment = "terraform-cloud"
        Environment = "test"
    }
}



