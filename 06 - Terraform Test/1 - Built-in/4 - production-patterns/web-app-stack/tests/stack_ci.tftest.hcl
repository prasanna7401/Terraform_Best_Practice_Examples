# CI/CD integration patterns for terraform test
#
# This file demonstrates how to structure tests for CI pipelines.
# Run with different output formats:
#
#   terraform test                                    # Human-readable (default)
#   terraform test -json                              # JSON output for programmatic parsing
#   terraform test -junit-xml=results.xml             # JUnit XML for CI tools (Jenkins, GitHub Actions)
#   terraform test -filter=tests/stack_ci.tftest.hcl  # Run only this file
#   terraform test -verbose                           # Show all run blocks, not just failures
#
# GitHub Actions example:
#   - name: Run Terraform Tests
#     run: |
#       terraform init
#       terraform test -junit-xml=results.xml
#   - name: Upload Test Results
#     uses: actions/upload-artifact@v4
#     with:
#       name: terraform-test-results
#       path: results.xml

mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      names = ["us-east-1a", "us-east-1b"]
    }
  }

  mock_data "aws_ami" {
    defaults = {
      id = "ami-ci-mock"
    }
  }
}

variables {
  environment   = "dev"
  instance_type = "t3.micro"
  vpc_cidr      = "10.0.0.0/16"
  app_port      = 80
}

# Concern: Network layer
run "ci_network_layer" {
  command = plan

  assert {
    condition     = aws_vpc.this.cidr_block == "10.0.0.0/16"
    error_message = "Network: VPC CIDR mismatch"
  }

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Network: Expected 2 subnets"
  }
}

# Concern: Security
run "ci_security_layer" {
  command = plan

  assert {
    condition     = aws_vpc_security_group_ingress_rule.app.from_port == 80
    error_message = "Security: Expected port 80 ingress"
  }

  assert {
    condition     = aws_vpc_security_group_ingress_rule.app.ip_protocol == "tcp"
    error_message = "Security: Expected TCP protocol"
  }
}

# Concern: Compute
run "ci_compute_layer" {
  command = plan

  assert {
    condition     = aws_instance.web.instance_type == "t3.micro"
    error_message = "Compute: Expected t3.micro"
  }
}

# Concern: Load balancing
run "ci_load_balancer" {
  command = plan

  assert {
    condition     = aws_lb.this.internal == false
    error_message = "LB: Expected internet-facing ALB"
  }

  assert {
    condition     = aws_lb_listener.http.port == 80
    error_message = "LB: Expected listener on port 80"
  }
}

# Concern: Input validation
run "ci_rejects_invalid_environment" {
  command = plan

  variables {
    environment = "invalid"
  }

  expect_failures = [
    var.environment,
  ]
}

run "ci_rejects_invalid_instance_type" {
  command = plan

  variables {
    instance_type = "m5.large"
  }

  expect_failures = [
    var.instance_type,
  ]
}
