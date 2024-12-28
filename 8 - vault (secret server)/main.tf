terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 5.0.0"
        }
        vault = {
            source  = "hashicorp/vault"
            version = ">= 3.0.0"
        }
    }
}

provider "vault" {
    address = "http://127.0.0.1:8200" # replace with your Vault address
}

data "vault_generic_secret" "mycreds" {
    path = "secret/aws"
}

provider "aws" {
    region     = "us-east-1"
    access_key = data.vault_generic_secret.mycreds.data["aws_access_key"]
    secret_key = data.vault_generic_secret.mycreds.data["aws_secret_access_key"]
}

resource "random_id" "bucket_name" {
    byte_length = 8
}

# code to create a storage bucket
resource "aws_s3_bucket" "mybucket" {
    bucket = "pva-corp-${random_id.bucket_name.hex}"
}