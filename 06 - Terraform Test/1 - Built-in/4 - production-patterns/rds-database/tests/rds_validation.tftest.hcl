# RDS validation tests using mocks and expect_failures
# Tests every validation rule without creating real resources

mock_provider "aws" {}

variables {
  db_name            = "test-db"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  engine_version     = "8.0"
  db_password        = "securepassword123"
  subnet_ids         = ["subnet-mock1", "subnet-mock2"]
  security_group_ids = ["sg-mock1"]
  environment        = "dev"
}

run "valid_config_plans_successfully" {
  command = plan

  assert {
    condition     = aws_db_instance.this.identifier == "test-db"
    error_message = "Expected DB identifier to be 'test-db'"
  }

  assert {
    condition     = aws_db_instance.this.engine == "mysql"
    error_message = "Expected engine to be mysql"
  }
}

run "prod_enables_multi_az" {
  command = plan

  variables {
    environment = "prod"
  }

  assert {
    condition     = aws_db_instance.this.multi_az == true
    error_message = "Expected Multi-AZ to be enabled in prod"
  }
}

run "non_prod_disables_multi_az" {
  command = plan

  assert {
    condition     = aws_db_instance.this.multi_az == false
    error_message = "Expected Multi-AZ to be disabled in non-prod"
  }
}

run "rejects_invalid_db_name" {
  command = plan

  variables {
    db_name = "123-invalid"
  }

  expect_failures = [
    var.db_name,
  ]
}

run "rejects_invalid_instance_class" {
  command = plan

  variables {
    instance_class = "t3.micro"
  }

  expect_failures = [
    var.instance_class,
  ]
}

run "rejects_storage_too_low" {
  command = plan

  variables {
    allocated_storage = 5
  }

  expect_failures = [
    var.allocated_storage,
  ]
}

run "rejects_short_password" {
  command = plan

  variables {
    db_password = "short"
  }

  expect_failures = [
    var.db_password,
  ]
}
