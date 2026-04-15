# ALB composition tests
# Demonstrates testing a module that composes multiple resources

mock_provider "aws" {}

variables {
  alb_name   = "test-alb"
  subnet_ids = ["subnet-mock1", "subnet-mock2"]
  vpc_id     = "vpc-mock123"
}

run "creates_alb_with_correct_config" {
  command = plan

  assert {
    condition     = aws_lb.this.name == "test-alb"
    error_message = "Expected ALB name to be 'test-alb'"
  }

  assert {
    condition     = aws_lb.this.internal == false
    error_message = "Expected ALB to be external (internet-facing)"
  }

  assert {
    condition     = aws_lb.this.load_balancer_type == "application"
    error_message = "Expected application load balancer type"
  }
}

run "creates_security_group_for_alb" {
  command = plan

  assert {
    condition     = aws_security_group.alb.name == "test-alb-sg"
    error_message = "Expected SG name to be 'test-alb-sg'"
  }

  assert {
    condition     = aws_security_group.alb.vpc_id == "vpc-mock123"
    error_message = "Expected SG to be in the correct VPC"
  }
}

run "configures_http_listener" {
  command = plan

  assert {
    condition     = aws_lb_listener.http.port == 80
    error_message = "Expected listener port to be 80"
  }

  assert {
    condition     = aws_lb_listener.http.protocol == "HTTP"
    error_message = "Expected listener protocol to be HTTP"
  }
}

run "opens_port_80_ingress" {
  command = plan

  assert {
    condition     = aws_vpc_security_group_ingress_rule.http.from_port == 80
    error_message = "Expected ingress rule for port 80"
  }
}
