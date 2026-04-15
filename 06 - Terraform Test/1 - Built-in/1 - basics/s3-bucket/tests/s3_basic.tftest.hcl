# Basic S3 bucket tests using mock provider and plan mode
# No AWS credentials needed — runs entirely offline

mock_provider "aws" {}

variables {
  bucket_prefix = "test-bucket"
  environment   = "dev"
  tags = {
    Team = "platform"
  }
}

run "creates_bucket_with_correct_tags" {
  command = plan

  assert {
    condition     = aws_s3_bucket.this.tags["Environment"] == "dev"
    error_message = "Expected Environment tag to be 'dev'"
  }

  assert {
    condition     = aws_s3_bucket.this.tags["Team"] == "platform"
    error_message = "Expected Team tag to be 'platform'"
  }
}

run "enables_versioning" {
  command = plan

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "Expected versioning to be enabled"
  }
}

run "override_environment_per_run" {
  command = plan

  variables {
    environment = "prod"
  }

  assert {
    condition     = aws_s3_bucket.this.tags["Environment"] == "prod"
    error_message = "Expected Environment tag to be 'prod' when overridden"
  }
}

run "validates_environment_value" {
  command = plan

  variables {
    environment = "invalid"
  }

  expect_failures = [
    var.environment,
  ]
}
