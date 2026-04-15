output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "instance_id" {
  description = "ID of the web server instance"
  value       = aws_instance.web.id
}

output "sg_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}
