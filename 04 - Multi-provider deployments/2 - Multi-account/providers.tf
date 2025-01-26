terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # N. Virginia
  alias  = "prod_account"
}

provider "aws" {
  region = "us-west-2" # Oregon
  alias  = "dev_account"

  assume_role {
    role_arn = var.dev_role_arn # Role in the dev account

  }

}