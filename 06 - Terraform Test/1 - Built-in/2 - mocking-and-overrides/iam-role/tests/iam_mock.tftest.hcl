# IAM role tests with mock provider
# Plan-mode assertions for role configuration

mock_provider "aws" {}

variables {
  role_name            = "test-ec2-role"
  policy_arn           = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  max_session_duration = 3600
}

run "creates_role_with_correct_name" {
  command = plan

  assert {
    condition     = aws_iam_role.this.name == "test-ec2-role"
    error_message = "Expected role name to be 'test-ec2-role'"
  }
}

run "sets_max_session_duration" {
  command = plan

  assert {
    condition     = aws_iam_role.this.max_session_duration == 3600
    error_message = "Expected max session duration to be 3600"
  }
}

run "attaches_correct_policy" {
  command = plan

  assert {
    condition     = aws_iam_role_policy_attachment.this.policy_arn == "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    error_message = "Expected correct policy ARN attachment"
  }
}
