# Deploying a cluster of web servers using Auto Scaling Groups and Elastic Load Balancer

# Dependencies:

# a. Security Group

resource "aws_security_group" "web-server_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP inbound traffic" # will be created in default VPC
  ingress {
    from_port   = var.server_port #8080
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# b. Fetch subnets in the default VPC - refer to the data_sources.tf

#### Step - 1: Create a Launch Configuration for using in ASG

# 1.1 - Fetch the latest Amazon Linux 2 AMI ID - refer to the data_sources.tf

# 1.2 - Create a Launch Template

resource "aws_launch_template" "web-server-launch-template" {
  name                   = "web-server-launch-template"
  image_id               = data.aws_ami.linux_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-server_sg.id]
  user_data              = filebase64("userdata.sh")
  lifecycle {
    create_before_destroy = true # Direct deletion will fail due to dependencies in ASG
  }
}


#### Step - 2: Create an Auto Scaling Group

resource "aws_autoscaling_group" "web-server-asg" {
  name = "web-server-asg"
  launch_template {
    id      = aws_launch_template.web-server-launch-template.id
    version = "$Latest"
  }
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = data.aws_subnets.default.ids # Something like ["subnet-12345678", "subnet-87654321"]
  target_group_arns   = [aws_lb_target_group.web-server-tg.arn]
  health_check_type   = "ELB" # default is EC2 - not feasible for web servers, as we need to monitor site response codes
  tag {
    key                 = "deployment"
    value               = "terraform-managed"
    propagate_at_launch = true
  }
}

#### Step - 3: Setup load balancing

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

# outputs - public IP of the ELB

output "elb_dns_name" {
  value       = aws_lb.web-server-elb.dns_name
  description = "DNS name of the Load Balancer"
}