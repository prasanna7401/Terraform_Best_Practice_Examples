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