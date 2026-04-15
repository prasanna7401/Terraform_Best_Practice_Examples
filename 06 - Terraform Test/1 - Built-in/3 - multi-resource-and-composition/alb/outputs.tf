output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.this.arn
}

output "listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}
