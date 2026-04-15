# EC2 instance plan-mode tests with mock provider
# No AWS credentials needed

mock_provider "aws" {}

variables {
  instance_type = "t3.micro"
  environment   = "dev"
  instance_name = "test-server"
}

run "creates_instance_with_correct_type" {
  command = plan

  assert {
    condition     = aws_instance.this.instance_type == "t3.micro"
    error_message = "Expected instance type to be t3.micro"
  }
}

run "applies_correct_tags" {
  command = plan

  assert {
    condition     = aws_instance.this.tags["Name"] == "test-server"
    error_message = "Expected Name tag to be 'test-server'"
  }

  assert {
    condition     = aws_instance.this.tags["Environment"] == "dev"
    error_message = "Expected Environment tag to be 'dev'"
  }
}

run "output_reflects_instance_type" {
  command = plan

  assert {
    condition     = output.instance_type == "t3.micro"
    error_message = "Expected instance_type output to be t3.micro"
  }
}
