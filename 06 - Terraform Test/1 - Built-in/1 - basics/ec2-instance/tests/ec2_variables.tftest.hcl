# Variable validation tests for EC2 module
# Demonstrates standalone vs per-run variable overrides

mock_provider "aws" {}

# Standalone variables apply to all runs unless overridden
variables {
  instance_type = "t3.micro"
  environment   = "dev"
  instance_name = "base-server"
}

run "default_variables_work" {
  command = plan

  assert {
    condition     = aws_instance.this.tags["Name"] == "base-server"
    error_message = "Expected standalone variable to apply"
  }
}

run "per_run_override_takes_precedence" {
  command = plan

  variables {
    instance_name = "override-server"
  }

  assert {
    condition     = aws_instance.this.tags["Name"] == "override-server"
    error_message = "Expected per-run variable to override standalone"
  }
}

run "rejects_invalid_instance_type" {
  command = plan

  variables {
    instance_type = "m5.large"
  }

  expect_failures = [
    var.instance_type,
  ]
}

run "rejects_invalid_environment" {
  command = plan

  variables {
    environment = "production"
  }

  expect_failures = [
    var.environment,
  ]
}
