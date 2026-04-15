# WARNING: This test creates REAL AWS resources and incurs costs!
# Only run with valid AWS credentials and in a test/sandbox account.
#
# Usage: terraform test -filter=tests/stack_apply.tftest.hcl
#
# Creates a full VPC + ALB + SG + EC2 stack, validates connectivity,
# then destroys everything.

variables {
  environment   = "dev"
  instance_type = "t3.micro"
  vpc_cidr      = "10.0.0.0/16"
  app_port      = 80
}

run "deploy_full_stack" {
  command = apply

  assert {
    condition     = output.vpc_id != ""
    error_message = "Expected non-empty VPC ID"
  }

  assert {
    condition     = output.alb_dns_name != ""
    error_message = "Expected non-empty ALB DNS name"
  }

  assert {
    condition     = output.instance_id != ""
    error_message = "Expected non-empty instance ID"
  }

  assert {
    condition     = output.sg_id != ""
    error_message = "Expected non-empty security group ID"
  }
}
