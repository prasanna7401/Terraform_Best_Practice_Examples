# Full stack plan validation
# Cross-resource assertions to verify the stack hangs together

mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      names = ["us-east-1a", "us-east-1b"]
    }
  }

  mock_data "aws_ami" {
    defaults = {
      id = "ami-mock12345"
    }
  }
}

variables {
  environment   = "dev"
  instance_type = "t3.micro"
  vpc_cidr      = "10.0.0.0/16"
  app_port      = 80
}

run "vpc_created_with_correct_cidr" {
  command = plan

  assert {
    condition     = aws_vpc.this.cidr_block == "10.0.0.0/16"
    error_message = "Expected VPC CIDR 10.0.0.0/16"
  }

  assert {
    condition     = aws_vpc.this.enable_dns_hostnames == true
    error_message = "Expected DNS hostnames enabled"
  }
}

run "two_public_subnets_created" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected 2 public subnets"
  }
}

run "alb_is_internet_facing" {
  command = plan

  assert {
    condition     = aws_lb.this.internal == false
    error_message = "Expected ALB to be internet-facing"
  }

  assert {
    condition     = aws_lb.this.load_balancer_type == "application"
    error_message = "Expected application load balancer"
  }
}

run "security_group_allows_app_port" {
  command = plan

  assert {
    condition     = aws_vpc_security_group_ingress_rule.app.from_port == 80
    error_message = "Expected ingress rule for port 80"
  }
}

run "ec2_uses_correct_instance_type" {
  command = plan

  assert {
    condition     = aws_instance.web.instance_type == "t3.micro"
    error_message = "Expected t3.micro instance type"
  }
}

run "all_resources_tagged_with_environment" {
  command = plan

  assert {
    condition     = aws_vpc.this.tags["Environment"] == "dev"
    error_message = "Expected VPC environment tag"
  }

  assert {
    condition     = aws_security_group.web.tags["Environment"] == "dev"
    error_message = "Expected SG environment tag"
  }

  assert {
    condition     = aws_instance.web.tags["Environment"] == "dev"
    error_message = "Expected EC2 environment tag"
  }
}
