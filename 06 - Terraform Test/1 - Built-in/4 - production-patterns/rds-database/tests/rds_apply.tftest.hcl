# WARNING: This test creates REAL AWS resources and incurs costs!
# Only run with valid AWS credentials and in a test account.
#
# Usage: terraform test -filter=tests/rds_apply.tftest.hcl
#
# This file demonstrates apply-mode testing for production validation.
# For CI/CD pipelines, prefer the mock-based rds_validation.tftest.hcl.

variables {
  db_name            = "tftest-rds-apply"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  engine_version     = "8.0"
  db_password        = "testpassword123!"
  subnet_ids         = ["subnet-replace-me-1", "subnet-replace-me-2"]
  security_group_ids = []
  environment        = "dev"
}

run "apply_creates_rds_instance" {
  command = apply

  assert {
    condition     = output.endpoint != ""
    error_message = "Expected a non-empty endpoint after apply"
  }

  assert {
    condition     = output.port == 3306
    error_message = "Expected MySQL default port 3306"
  }

  assert {
    condition     = output.instance_class == "db.t3.micro"
    error_message = "Expected instance class db.t3.micro"
  }
}
