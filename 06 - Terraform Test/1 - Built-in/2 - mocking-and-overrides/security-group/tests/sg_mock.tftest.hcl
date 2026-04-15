# Security group tests with mock_provider and mock_data
# Demonstrates mocking data sources to avoid real AWS calls

mock_provider "aws" {
  mock_data "aws_vpc" {
    defaults = {
      id         = "vpc-mock12345"
      cidr_block = "10.0.0.0/16"
    }
  }
}

variables {
  sg_name            = "test-sg"
  vpc_id             = "vpc-mock12345"
  allowed_cidr_block = "10.0.0.0/16"
  ingress_port       = 443
}

run "creates_sg_in_correct_vpc" {
  command = plan

  assert {
    condition     = aws_security_group.this.vpc_id == "vpc-mock12345"
    error_message = "Expected SG to be created in the mocked VPC"
  }
}

run "applies_correct_name" {
  command = plan

  assert {
    condition     = aws_security_group.this.name == "test-sg"
    error_message = "Expected SG name to be 'test-sg'"
  }

  assert {
    condition     = aws_security_group.this.tags["Name"] == "test-sg"
    error_message = "Expected Name tag to match sg_name"
  }
}

run "configures_ingress_port" {
  command = plan

  assert {
    condition     = aws_vpc_security_group_ingress_rule.allow_ingress.from_port == 443
    error_message = "Expected ingress from_port to be 443"
  }

  assert {
    condition     = aws_vpc_security_group_ingress_rule.allow_ingress.to_port == 443
    error_message = "Expected ingress to_port to be 443"
  }
}
