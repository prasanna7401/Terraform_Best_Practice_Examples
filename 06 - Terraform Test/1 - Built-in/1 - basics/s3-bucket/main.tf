terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = var.bucket_prefix
  force_destroy = true

  tags = merge(
    {
      Name        = "${var.bucket_prefix}-bucket"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}
