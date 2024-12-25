terraform {
  cloud {

    organization = "Cyber5"

    workspaces {
      name = "Learning_CLI"
      # try prefix if needed
      # prefix = "pva-"
       # when you run this in a project with two workspaces named "pva-prod" and "pva-dev",
         # you will see two options while running: 
            # 1. prod 2. dev
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

resource "random_id" "random_id" {
  byte_length = 8
}

# create a storage bucket with a random suffix
resource "aws_s3_bucket" "tf_bucket" {
  bucket = "tf-bucket-${random_id.random_id.hex}"
  tags = {
    Environment = "Terraform-Prod"
  }
}