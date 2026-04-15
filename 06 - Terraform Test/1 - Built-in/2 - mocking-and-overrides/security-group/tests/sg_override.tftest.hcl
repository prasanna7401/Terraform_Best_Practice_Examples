# Demonstrates override_data for targeted data source overrides
# Unlike mock_data (which replaces all instances), override_data
# targets a specific data source reference

mock_provider "aws" {}

override_data {
  target = data.aws_vpc.selected
  values = {
    id         = "vpc-override789"
    cidr_block = "172.16.0.0/16"
  }
}

variables {
  sg_name            = "override-test-sg"
  vpc_id             = "vpc-override789"
  allowed_cidr_block = "172.16.0.0/16"
  ingress_port       = 8080
}

run "override_targets_specific_data_source" {
  command = plan

  assert {
    condition     = aws_security_group.this.vpc_id == "vpc-override789"
    error_message = "Expected SG to use the overridden VPC ID"
  }
}

run "custom_ingress_port" {
  command = plan

  assert {
    condition     = aws_vpc_security_group_ingress_rule.allow_ingress.from_port == 8080
    error_message = "Expected custom ingress port of 8080"
  }
}
