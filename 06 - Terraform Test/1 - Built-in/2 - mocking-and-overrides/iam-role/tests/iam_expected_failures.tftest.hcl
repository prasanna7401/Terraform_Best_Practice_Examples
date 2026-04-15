# Demonstrates expect_failures for input validation testing
# Each run block tests one validation rule by providing invalid input

mock_provider "aws" {}

variables {
  role_name            = "valid-role"
  policy_arn           = "arn:aws:iam::aws:policy/SomePolicy"
  max_session_duration = 3600
}

run "rejects_role_name_starting_with_number" {
  command = plan

  variables {
    role_name = "123-invalid-role"
  }

  expect_failures = [
    var.role_name,
  ]
}

run "rejects_invalid_policy_arn" {
  command = plan

  variables {
    policy_arn = "not-a-valid-arn"
  }

  expect_failures = [
    var.policy_arn,
  ]
}

run "rejects_session_duration_too_low" {
  command = plan

  variables {
    max_session_duration = 1800
  }

  expect_failures = [
    var.max_session_duration,
  ]
}

run "rejects_session_duration_too_high" {
  command = plan

  variables {
    max_session_duration = 50000
  }

  expect_failures = [
    var.max_session_duration,
  ]
}
