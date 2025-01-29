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