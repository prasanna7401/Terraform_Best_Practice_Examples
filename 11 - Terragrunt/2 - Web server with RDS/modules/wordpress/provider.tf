terraform {
  required_providers {
    aws = {
      version = "~>4.30.0"
    }
  }
  
  backend "s3" {} # Remaining configs to be added by terragrunt

  required_version = "> 1.1.3"
}

provider "aws" {
  region = var.region
}