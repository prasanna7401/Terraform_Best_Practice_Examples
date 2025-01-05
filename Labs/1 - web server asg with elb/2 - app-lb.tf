# Dependencies:

# a. Security group for ELB:

resource "aws_security_group" "elb_sg" {
  name        = "elb-sg"
  description = "Allow HTTP inbound traffic" # will be created in default VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outbound traffic to allow ELB to perform health checks
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3.1. Create a Elastic Load Balancer (application type)

resource "aws_lb" "web-server-elb" {
  name                       = "web-server-elb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.elb_sg.id]
  subnets                    = data.aws_subnets.default.ids
  enable_deletion_protection = false
  tags                       = var.tags
}

# 3.2. Create a Target Group

resource "aws_lb_target_group" "web-server-tg" {
  name     = "web-server-tg"
  port     = var.server_port #8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/index.html"
    port                = var.server_port # listen for port 8080
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# 3.3. Create a Listener (HTTP)

resource "aws_lb_listener" "web-server-elb-listener" {
  load_balancer_arn = aws_lb.web-server-elb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a fixed response to requests not matching listener rules (to be created later)
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page not found"
      status_code  = 404
    }
  }
}

# 3.4. Create a Listener Rule

resource "aws_lb_listener_rule" "name" {
  listener_arn = aws_lb_listener.web-server-elb-listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"] # for any path
    }
  }

  action {
    type             = "forward" # forward to target group
    target_group_arn = aws_lb_target_group.web-server-tg.arn
  }
}