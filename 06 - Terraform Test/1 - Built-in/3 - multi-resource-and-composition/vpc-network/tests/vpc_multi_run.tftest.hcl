# Demonstrates multi-run tests with state sharing
# Uses run.<name> references to pass outputs between runs

mock_provider "aws" {}

variables {
  vpc_cidr           = "10.0.0.0/16"
  subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  environment        = "staging"
}

run "setup_vpc" {
  command = plan

  assert {
    condition     = aws_vpc.this.tags["Environment"] == "staging"
    error_message = "Expected staging environment tag"
  }
}

run "verify_three_subnets" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 3
    error_message = "Expected 3 subnets for 3 AZs"
  }
}

run "verify_route_table_associations" {
  command = plan

  assert {
    condition     = length(aws_route_table_association.public) == 3
    error_message = "Expected 3 route table associations matching subnet count"
  }
}
