# VPC network plan-mode tests
# Validates multi-resource module with count-based resources

mock_provider "aws" {}

variables {
  vpc_cidr           = "10.0.0.0/16"
  subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  environment        = "dev"
}

run "creates_vpc_with_correct_cidr" {
  command = plan

  assert {
    condition     = aws_vpc.this.cidr_block == "10.0.0.0/16"
    error_message = "Expected VPC CIDR to be 10.0.0.0/16"
  }

  assert {
    condition     = aws_vpc.this.enable_dns_support == true
    error_message = "Expected DNS support to be enabled"
  }
}

run "creates_correct_number_of_subnets" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected 2 subnets to be created"
  }
}

run "creates_internet_gateway" {
  command = plan

  assert {
    condition     = aws_internet_gateway.this.tags["Name"] == "dev-igw"
    error_message = "Expected IGW name tag to be 'dev-igw'"
  }
}

run "creates_route_table_with_default_route" {
  command = plan

  assert {
    condition     = aws_route_table.public.route[0].cidr_block == "0.0.0.0/0"
    error_message = "Expected default route in public route table"
  }
}

run "validates_minimum_subnets" {
  command = plan

  variables {
    subnet_cidrs       = ["10.0.1.0/24"]
    availability_zones = ["us-east-1a"]
  }

  expect_failures = [
    var.subnet_cidrs,
    var.availability_zones,
  ]
}
