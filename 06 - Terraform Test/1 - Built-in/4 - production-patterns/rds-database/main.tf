terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier     = var.db_name
  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage * 2

  db_name  = replace(var.db_name, "-", "_")
  username = "admin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  skip_final_snapshot = true
  multi_az            = var.environment == "prod" ? true : false

  tags = {
    Name        = var.db_name
    Environment = var.environment
  }
}
