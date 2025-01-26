terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {
  #   bucket         = "<YOUR S3 BUCKET>"
  #   key            = "<SOME PATH>/terraform.tfstate"
  #   region         = "us-east-2"
  #   dynamodb_table = "<YOUR DYNAMODB TABLE>"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = "us-east-2"
}